unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ppParameter, ppDesignLayer, ppBands,
  ppStrtch, ppPageBreak, ppPrnabl, ppClass, ppCtrls, ppCache, ppComm, ppRelatv,
  ppProd, ppReport, Vcl.StdCtrls;

type
  TFormMain = class(TForm)
    Label1: TLabel;
    Button2: TButton;
    Edit1: TEdit;
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
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  PrintAndMergeU,
  DuplicatePrinterU;

{$R *.dfm}

procedure TFormMain.Button2Click(Sender: TObject);
begin
  ppReport1.PrinterSetup.Copies := StrToIntDef(Edit1.Text, 2);

  (*
    Technically the PrintAndMerge component had nothing to do with theis demo
    It's just used as an easy way to get at PDF print
  *)
  with TPrintAndMerge.Create(Self, ChangeFileExt(Application.ExeName, '.pdf')) do
    try
      PrintToPDF;
    finally
      Free;
    end;

end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  TDuplicatePrinter.Create(ppReport1);

  (*
    On copy 2 and following TDuplicatePrinter will add a Watermark to your reports, saying "Duplicate"

    If you want some thing else written construct DuplicatePrinter like this:

    with TDuplicatePrinter.Create(ppReport1) do
    CopyText := 'Copy';

    TDuplicatePrinter is a component so no need to destroy it
  *)

end;

end.
