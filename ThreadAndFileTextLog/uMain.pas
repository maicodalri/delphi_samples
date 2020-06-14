unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Generics.Collections, MyUtils.FileTextLog, Vcl.Forms,
  MyUtils.ThreadSample;

type

  TfrmMain = class(TForm)
    pnlBotton: TPanel;
    ScrollBox: TScrollBox;
    btnCreate: TButton;
    btnSaveLog: TButton;
    procedure btnCreateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveLogClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.btnCreateClick(Sender: TObject);
begin
  //Create the thread
  TSampleThread.Create(Self.ScrollBox).Start;

  //Calls the log method
  TFileTextLog.WriteLog('Thread created and started');
end;

procedure TfrmMain.btnSaveLogClick(Sender: TObject);
begin
  //Calls the log method
  TFileTextLog.WriteLog('Generate now... (Thread safe)');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //checks if there are components within the scrool,
  // this indicates that there are still active threads
  if ScrollBox.ControlCount > 0 then
  begin
    ShowMessage('Complete the processes before closing!');
    Action:= caNone;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  //Activate this feature to monitorate the memory leaks
  ReportMemoryLeaksOnShutdown:= True;
end;

end.
