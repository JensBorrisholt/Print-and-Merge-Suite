program DuplicatePrinterDemo;

uses
  Vcl.Forms,
  MainU in 'MainU.pas' {FormMain},
  DuplicatePrinterU in '..\..\Components\DuplicatePrinterU.pas',
  PrintAndMergeU in '..\..\Components\PrintAndMergeU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
