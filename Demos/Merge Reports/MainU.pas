unit MainU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ppParameter,
  ppDesignLayer, ppBands, ppStrtch, ppPageBreak, ppPrnabl, ppClass, ppCtrls,
  ppCache, ppComm, ppRelatv, ppProd, ppReport;

type
  TFormMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button2: TButton;
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
    Button1: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure SetupCopies;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

uses
  PrintAndMergeU;
{$R *.dfm}

procedure TFormMain.Button1Click(Sender: TObject);
begin
  SetupCopies;
  (*
    Note
    TPrintAndMerge was created with an array of ppReports, inorder for only using those
  *)
  with TPrintAndMerge.Create([ppReport1, ppReport2], ChangeFileExt(Application.ExeName, '.pdf')) do
    try
      PrintToPDF;
    finally
      Free;
    end;
end;

procedure TFormMain.Button2Click(Sender: TObject);
begin
  SetupCopies;
  (*
    Note
    TPrintAndMerge was created with self (the form) inorder for using all ppReports on the form
  *)
  with TPrintAndMerge.Create(Self, ChangeFileExt(Application.ExeName, '.pdf')) do
    try
      PrintToPDF;
    finally
      Free;
    end;
end;

procedure TFormMain.SetupCopies;
begin
  ppReport1.PrinterSetup.Copies := StrToIntDef(Edit1.Text, 2);
  ppReport2.PrinterSetup.Copies := StrToIntDef(Edit2.Text, 2);
  ppReport3.PrinterSetup.Copies := StrToIntDef(Edit3.Text, 2);
end;

end.
