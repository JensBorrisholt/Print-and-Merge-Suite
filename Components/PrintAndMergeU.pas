unit PrintAndMergeU;

interface

uses
  System.Classes, System.Sysutils,
  ppReport, ppFilDev;

type
  TppReportsArray = array of TppReport;

  TPrintAndMerge = class
  strict private
    FReports: TppReportsArray;
    FFileName: string;
    FFirstReport: TppReport;
    FOutputStream: TStream;
    FAsMemoryStream: Boolean;
    FOwnsStream: Boolean;
    procedure WalkChildren(Parent: TComponent; Visit: TProc<TComponent>);
    function GetpReportsArray(aOwner: TComponent): TppReportsArray;
    function PrintToFile(aFileDevice: TppFileDevice): string;
    procedure SetAsMemoryStream(const Value: Boolean);
    procedure SetOutputStream(const Value: TStream);
    procedure SetFileName(const Value: string);
  public
    constructor Create(const aOwner: TComponent); reintroduce; overload;
    constructor Create(const aOwner: TComponent; aFileName: string); reintroduce; overload;
    constructor Create(const aOwner: TComponent; aAsMemoryStream: Boolean); reintroduce; overload;
    constructor Create(const aReports: TppReportsArray); reintroduce; overload;
    constructor Create(const aReports: TppReportsArray; aFileName: string); overload;
    constructor Create(const aReports: TppReportsArray; aAsMemoryStream: Boolean); overload;
    destructor Destroy; override;
    function PrintToPDF: string;
    function PrintToRTF: string;
    function PrintToDOC: string;
    property FileName: string read FFileName write SetFileName;
    property OutputStream: TStream read FOutputStream write SetOutputStream;
    property AsMemoryStream: Boolean read FAsMemoryStream write SetAsMemoryStream;
  end;

implementation

uses
  System.IoUtils,
  ppPDFDevice, ppRTFDevice;
{ TPrintAndMerge }

constructor TPrintAndMerge.Create(const aReports: TppReportsArray; aFileName: string);
begin
  Create(aReports);

  if aFileName = '' then
    aFileName := TPath.GetTempFileName;

  FileName := aFileName;
end;

procedure TPrintAndMerge.SetAsMemoryStream(const Value: Boolean);
begin
  if (not Value) and (FOwnsStream) then
    FreeAndNil(FOutputStream)
  else if (Value) and (Assigned(FOutputStream)) then
    FreeAndNil(FOutputStream);

  if Value then
    FOutputStream := TMemoryStream.Create;

  FAsMemoryStream := Value;
end;

procedure TPrintAndMerge.SetFileName(const Value: string);
begin
  FFileName := Value;
  AsMemoryStream := False;
end;

procedure TPrintAndMerge.SetOutputStream(const Value: TStream);
begin
  AsMemoryStream := False;
  FOutputStream := Value;
end;

procedure TPrintAndMerge.WalkChildren(Parent: TComponent; Visit: TProc<TComponent>);
var
  i: Integer;
  Child: TComponent;
begin
  for i := 0 to Parent.ComponentCount - 1 do
  begin
    Child := Parent.Components[i];
    Visit(Child);
    if Child.ComponentCount > 0 then
      WalkChildren(Child, Visit);
  end;
end;

constructor TPrintAndMerge.Create(const aReports: TppReportsArray);
begin
  inherited Create;
  FReports := aReports;
  FFirstReport := FReports[0];
  AsMemoryStream := True;
  FOwnsStream := True;
end;

constructor TPrintAndMerge.Create(const aReports: TppReportsArray; aAsMemoryStream: Boolean);
begin
  Create(aReports);
  AsMemoryStream := aAsMemoryStream;
end;

constructor TPrintAndMerge.Create(const aOwner: TComponent; aAsMemoryStream: Boolean);
begin
  Create(aOwner);
  AsMemoryStream := aAsMemoryStream;
end;

constructor TPrintAndMerge.Create(const aOwner: TComponent; aFileName: string);
begin
  Create(aOwner);

  if aFileName = '' then
    aFileName := TPath.GetTempFileName;

  FileName := aFileName;
end;

constructor TPrintAndMerge.Create(const aOwner: TComponent);
begin
  Create(GetpReportsArray(aOwner));
end;

destructor TPrintAndMerge.Destroy;
begin
  if FOwnsStream then
    FreeAndNil(FOutputStream);

  inherited;
end;

function TPrintAndMerge.GetpReportsArray(aOwner: TComponent): TppReportsArray;
var
  ResultArray: TppReportsArray;
begin
  ResultArray := nil;

  WalkChildren(aOwner,
    procedure(Child: TComponent)
    begin
      if not(Child is TppReport) then
        exit;

      SetLength(ResultArray, Length(ResultArray) + 1);
      ResultArray[Length(ResultArray) - 1] := TppReport(Child);
    end);

  Result := ResultArray;
end;

function TPrintAndMerge.PrintToDOC: string;
var
  lDOCDevice: TppDOCDevice;
begin
  lDOCDevice := TppDOCDevice.Create(nil);
  lDOCDevice.RTFSettings.Assign(FFirstReport.RTFSettings);
  lDOCDevice.OpenFile := FFileName <> '';
  Result := PrintToFile(lDOCDevice);
end;

function TPrintAndMerge.PrintToFile(aFileDevice: TppFileDevice): string;
var
  FirstReport: TppReport;
  LastReport: TppReport;
  Report: TppReport;
  NumberOfReports: Integer;
  liIndex: Integer;
begin
  Result := '';
  NumberOfReports := Length(FReports);
  try
    if NumberOfReports = 0 then
      exit;

    FFileName := TPath.ChangeExtension(FFileName, aFileDevice.DefaultExt);

    Result := FFileName;

    FirstReport := FReports[0];
    LastReport := FReports[NumberOfReports - 1];

    aFileDevice.FileName := FFileName;

    aFileDevice.EndPrintJob := False;
    aFileDevice.Publisher := FirstReport.Publisher;
    aFileDevice.OutputStream := FOutputStream;

    for liIndex := 0 to FirstReport.PrinterSetup.Copies - 1 do
    begin
      aFileDevice.Reset;
      aFileDevice.StartPrintJob := liIndex = 0;
      if NumberOfReports = 1 then
        aFileDevice.EndPrintJob := liIndex = FirstReport.PrinterSetup.Copies - 1;

      FirstReport.PrintToDevices;
    end;

    if NumberOfReports = 1 then
      exit;

    for Report in FReports do
    begin
      if Report = FirstReport then
        continue;

      aFileDevice.StartPrintJob := False;
      aFileDevice.Publisher := Report.Publisher;

      for liIndex := 0 to Report.PrinterSetup.Copies - 1 do
      begin
        aFileDevice.Reset;
        aFileDevice.EndPrintJob := (Report = LastReport) and (liIndex = Report.PrinterSetup.Copies - 1);
        Report.PrintToDevices;
      end;
    end;

  finally
    aFileDevice.Free;
  end;

  if Assigned(FOutputStream) then
    Result := '<Exported to ' + FOutputStream.ClassName + '>';
end;

function TPrintAndMerge.PrintToPDF: string;
var
  lPDFDevice: TppPDFDevice;
begin
  lPDFDevice := TppPDFDevice.Create(nil);
  lPDFDevice.PDFSettings.Assign(FFirstReport.PDFSettings);
  lPDFDevice.PDFSettings.OpenPDFFile := FFileName <> '';
  Result := PrintToFile(lPDFDevice);
end;

function TPrintAndMerge.PrintToRTF: string;
var
  lRTFDevice: TppRTFDevice;
begin
  lRTFDevice := TppRTFDevice.Create(nil);
  lRTFDevice.RTFSettings.Assign(FFirstReport.RTFSettings);
  lRTFDevice.OpenFile := FFileName <> '';
  Result := PrintToFile(lRTFDevice);
end;

end.
