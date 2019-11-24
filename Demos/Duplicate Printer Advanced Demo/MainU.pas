unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ppParameter, ppDesignLayer, ppBands,
  ppStrtch, ppPageBreak, ppPrnabl, ppClass, ppCtrls, ppCache, ppComm, ppRelatv,
  ppProd, ppReport, Vcl.StdCtrls,

  DuplicatePrinterU;

type
  TFormMain = class(TForm)
    Button2: TButton;
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
    Edit3: TEdit;
    Edit2: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FDuplicatePrinters: TDuplicatePrinters;
    procedure DuplicatePrintersOnGetWatermarkText(Sender: TppReport; Copy: integer; var Text: string);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  PrintAndMergeU;

{$R *.dfm}

procedure TFormMain.Button2Click(Sender: TObject);
begin
  ppReport1.PrinterSetup.Copies := StrToIntDef(Edit1.Text, 2);
  ppReport2.PrinterSetup.Copies := StrToIntDef(Edit2.Text, 2);
  ppReport3.PrinterSetup.Copies := StrToIntDef(Edit3.Text, 2);

  (*
    Technically the PrintAndMerge component has nothing to do with theis demo
    It's just used as an easy way to get at PDF print
  *)
  with TPrintAndMerge.Create(Self, ChangeFileExt(Application.ExeName, '.pdf')) do
    try
      PrintToPDF;
    finally
      Free;
    end;

end;

procedure TFormMain.DuplicatePrintersOnGetWatermarkText(Sender: TppReport; Copy: integer; var Text: string);
begin
  Text := 'Copy ' + Copy.ToString;
  //If you want to use your own control for printing eg.  Duplicate in
  //Use this event. Set Text to string.empty and assign a text to your own component

end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  (*
    Here we constructed a new component TDuplicatePrinters. Notice Pluralis TDuplicatePrinterS
    It's uses for controlling ALL ppReports on your form (The Owner).
  *)

  FDuplicatePrinters := TDuplicatePrinters.Create(Self);

  // You can change the Watermark text on all registered ppReports:
  FDuplicatePrinters.CopyText := 'Copy';

  // Or you can use the OnGetWatermarkText event in order to generate your own text:
  FDuplicatePrinters.OnGetWatermarkText := DuplicatePrintersOnGetWatermarkText;
end;

end.
