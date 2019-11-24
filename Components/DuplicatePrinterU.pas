unit DuplicatePrinterU;

interface

uses
  System.Classes, VCL.Forms, System.Generics.Collections,
  ppReport, ppTypes, ppCtrls, ppComm, ppRTTI;

{$M+}

type
  TGetWatermarkText = reference to procedure(Sender: TppReport; Copy: Integer; var Text: string);

  TDuplicatePrinter = class(TComponent)
  strict private
    FCopy: Integer;
    FReport: TppReport;
    FLabel: TppLabel;
    FCommunicator: TppCommunicator;
    FCopyText: string;
    FOnGetWatermarkText: TGetWatermarkText;
    function GetLabel(aCaption: string): TppLabel;
    procedure StartPage(Sender: TObject);
    procedure EndPage(Sender: TObject);
    procedure SetOnGetWatermarkText(const Value: TGetWatermarkText);
  strict protected
    procedure EventNotifyEvent(Sender: TObject; aCommunicator: TppCommunicator; aEventID: Integer; aParams: TraParamList); virtual;
  published
    property CopyText: string read FCopyText write FCopyText;
    property OnGetWatermarkText: TGetWatermarkText read FOnGetWatermarkText write SetOnGetWatermarkText;
  public
    constructor Create(aOwner: TppReport); reintroduce;
  end;

  TDuplicatePrinters = class(TComponent)
  strict private
    FCopyText: string;
    FOwner: TForm;
    FOnGetWatermarkText: TGetWatermarkText;
    FDuplicatePrinterList: TList<TDuplicatePrinter>;
    procedure SetCopyText(const Value: string);
    procedure SetOnGetWatermarkText(const Value: TGetWatermarkText);
  published
    property CopyText: string read FCopyText write SetCopyText;
    property OnGetWatermarkText: TGetWatermarkText read FOnGetWatermarkText write SetOnGetWatermarkText;
  public
    constructor Create(aOwner: TForm); reintroduce;
    destructor Destroy; override;
  end;

implementation

uses
  ppDrwCmd, ppDevice, ppUtils;

const
  DefaultCopyText = 'Duplicate';

  { TDuplicatePrinter }

constructor TDuplicatePrinter.Create(aOwner: TppReport);
begin
  inherited Create(aOwner);
  FCommunicator := TppCommunicator.Create(Self);
  FCommunicator.OnEventNotify := EventNotifyEvent;
  FCommunicator.EventNotifies := [ciEngineEndPage, ciEngineStartPage];

  FReport := aOwner;
  FReport.AddEventNotify(FCommunicator);
  FCopyText := DefaultCopyText;
end;

procedure TDuplicatePrinter.EndPage(Sender: TObject);
var
  WatermarkText: string;
  lDrawText: TppDrawText;
  lPage: TppPage;
  Top, Left: Single;
begin
  if (not Assigned(FOnGetWatermarkText)) and (FCopy = 1) then
    exit;

  WatermarkText := FCopyText;

  if Assigned(FOnGetWatermarkText) then
  begin
    if FCopy = 1 then
      WatermarkText := ''
    else
      WatermarkText := FCopyText;

    FOnGetWatermarkText(FReport, FCopy, WatermarkText);
  end;

  GetLabel(WatermarkText);

  Top := (FReport.PrinterSetup.PaperHeight - FLabel.Height) / 2;
  Left := (FReport.PrinterSetup.PaperWidth - FLabel.Width) / 2;

  lPage := FReport.Engine.Page;

  lDrawText := TppDrawText.Create(nil);
  lDrawText.Text := WatermarkText;
  lDrawText.Left := ppToMMThousandths(Left, utScreenPixels, pprtHorizontal, nil);
  lDrawText.Top := ppToMMThousandths(Top, utScreenPixels, pprtVertical, nil);
  lDrawText.Angle := FLabel.Angle;
  lDrawText.Width := ppToMMThousandths(FLabel.Width, utScreenPixels, pprtHorizontal, nil);
  lDrawText.Height := Trunc(ppToMMThousandths(FLabel.Height, utScreenPixels, pprtVertical, nil) * 1.05);
  lDrawText.Transparent := True;
  lDrawText.Font.Assign(FLabel.Font);

  lDrawText.Width := lPage.PageDef.mmPrintableWidth;
  lDrawText.Height := lPage.PageDef.mmPrintableWidth;

  FReport.Engine.Page.InsertChild(0, lDrawText);

  if (FCopy = FReport.PrinterSetup.Copies) and (FReport.AbsolutePageNo = FReport.PageCount) then
    FCopy := -1;
end;

procedure TDuplicatePrinter.EventNotifyEvent(Sender: TObject; aCommunicator: TppCommunicator; aEventID: Integer; aParams: TraParamList);
begin
  case aEventID of
    ciEngineStartPage:
      StartPage(FReport);
    ciEngineEndPage:
      EndPage(FReport);
  end;
end;

function TDuplicatePrinter.GetLabel(aCaption: string): TppLabel;
begin
  if FLabel = nil then
    FLabel := TppLabel.Create(FReport);

  FLabel.Text := aCaption;
  if aCaption = '' then
    Exit(Flabel);


  FLabel.AutoSize := True;
  FLabel.Angle := 315;
  FLabel.Transparent := True;
  FLabel.Font.Size := 20;
  FLabel.Font.Color := clBtnFace;

  while FLabel.Width < FReport.PrinterSetup.PaperWidth do
    FLabel.Font.Size := FLabel.Font.Size + 50;

  while FLabel.Width > FReport.PrinterSetup.PaperWidth do
    FLabel.Font.Size := FLabel.Font.Size - 10;

  while FLabel.Width < FReport.PrinterSetup.PaperWidth do
    FLabel.Font.Size := FLabel.Font.Size + 5;

  while FLabel.Height > FReport.PrinterSetup.PaperHeight do
    FLabel.Font.Size := FLabel.Font.Size - 1;

  Result := FLabel;
end;

procedure TDuplicatePrinter.SetOnGetWatermarkText(const Value: TGetWatermarkText);
begin
  FOnGetWatermarkText := Value;
end;

procedure TDuplicatePrinter.StartPage(Sender: TObject);
begin
  if FReport.PassSetting = psTwoPass then
    if not FReport.SecondPass then
      exit;

  if FCopy < 0 then
    FCopy := 0;

  if FReport.AbsolutePageNo = 1 then
    FCopy := FCopy + 1;
end;

{ TDuplicatePrinters }

constructor TDuplicatePrinters.Create(aOwner: TForm);
var
  i: Integer;
  DuplicatePrinter: TDuplicatePrinter;
begin
  inherited Create(aOwner);
  FOwner := aOwner;
  FCopyText := DefaultCopyText;
  FDuplicatePrinterList := TList<TDuplicatePrinter>.Create;
  for i := 0 to aOwner.ComponentCount - 1 do
    if aOwner.Components[i] is TppReport then
    begin
      DuplicatePrinter := TDuplicatePrinter.Create(aOwner.Components[i] as TppReport);
      FDuplicatePrinterList.Add(DuplicatePrinter);
    end;
end;

destructor TDuplicatePrinters.Destroy;
begin
  FDuplicatePrinterList.Free;
  inherited;
end;

procedure TDuplicatePrinters.SetCopyText(const Value: string);
var
  DuplicatePrinter: TDuplicatePrinter;
begin
  FCopyText := Value;

  for DuplicatePrinter in FDuplicatePrinterList do
    DuplicatePrinter.CopyText := FCopyText;
end;

procedure TDuplicatePrinters.SetOnGetWatermarkText(const Value: TGetWatermarkText);
var
  DuplicatePrinter: TDuplicatePrinter;
begin
  FOnGetWatermarkText := Value;

  for DuplicatePrinter in FDuplicatePrinterList do
    DuplicatePrinter.OnGetWatermarkText := Value;
end;

end.
