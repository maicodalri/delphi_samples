program ThreadAndFileTextLog;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  MyUtils.FileTextLog in 'MyUtils.FileTextLog.pas',
  MyUtils.ThreadSample in 'MyUtils.ThreadSample.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
