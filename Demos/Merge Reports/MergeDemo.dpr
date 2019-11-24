program MergeDemo;

uses
  Vcl.Forms,
  MainU in 'MainU.pas' {FormMain},
  PrintAndMergeU in '..\..\Components\PrintAndMergeU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
