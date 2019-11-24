program MegaDemo;

uses
  Vcl.Forms,
  Mainu in 'Mainu.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
