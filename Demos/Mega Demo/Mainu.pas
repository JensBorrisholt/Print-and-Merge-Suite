unit Mainu;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ppParameter, ppDesignLayer, ppBands,
  ppStrtch, ppPageBreak, ppPrnabl, ppClass, ppCtrls, ppCache, ppComm, ppRelatv,
  ppProd, ppReport, Vcl.StdCtrls;

type
  TFormMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    ppReport1: TppReport;
    ppHeaderBand1: TppHeaderBand;
    ppLabel1: TppLabel;
    ppDetailBand1: TppDetailBand;
    ppLabel3: TppLabel;
    ppPageBreak1: TppPageBreak;
    ppLabel4: TppLabel;
    ppFooterBand1: TppFooterBand;
    ppDesignLayers1: TppDesignLayers;
    ppDesignLayer1: TppDesignLayer;
    ppParameterList1: TppParameterList;
    ppReport2: TppReport;
    ppHeaderBand2: TppHeaderBand;
    ppLabel2: TppLabel;
    ppDetailBand2: TppDetailBand;
    ppFooterBand2: TppFooterBand;
    ppDesignLayers2: TppDesignLayers;
    ppDesignLayer2: TppDesignLayer;
    ppParameterList2: TppParameterList;
    ppReport3: TppReport;
    ppHeaderBand3: TppHeaderBand;
    ppLabel5: TppLabel;
    ppDetailBand3: TppDetailBand;
    ppFooterBand3: TppFooterBand;
    ppDesignLayers3: TppDesignLayers;
    ppDesignLayer3: TppDesignLayer;
    ppParameterList3: TppParameterList;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DuplicatePrintersOnGetWatermarkText(Sender: TppReport; Copy: integer; var Text: string);
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

uses
  DuplicatePrinterU, PrintAndMergeU, PDFViewerU;

procedure TFormMain.Button1Click(Sender: TObject);
begin
  ppReport1.PrinterSetup.Copies := StrToIntDef(Edit1.Text, 2);
  ppReport2.PrinterSetup.Copies := StrToIntDef(Edit2.Text, 2);
  ppReport3.PrinterSetup.Copies := StrToIntDef(Edit3.Text, 2);

  with TPrintAndMerge.Create(Self) do
    try
      PrintToPDF;
      TPDFViewer.LoadFromStream(OutputStream);
    finally
      Free;
    end;
end;

procedure TFormMain.DuplicatePrintersOnGetWatermarkText(Sender: TppReport; Copy: integer; var Text: string);
begin
  if Copy = 1 then
    Text := ''
  else
    Text := 'Copy ' + (Copy - 1).ToString;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  with TDuplicatePrinters.Create(Self) do
    OnGetWatermarkText := DuplicatePrintersOnGetWatermarkText;
end;

end.
