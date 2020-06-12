unit uMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  System.Generics.Collections, MyUtils.FileTextLog;

type

  TSampleThread = class(TThread)
  strict private
    FMyTerminate: Boolean;
    FInformation: string;
    FPanel: TPanel;
    FLabel: TLabel;
    FProgressBar: TProgressBar;
    FButton: TButton;
    FPosition: Integer;
    FInterval: Integer;
  protected
    procedure Execute; override;
  public
    property MyTerminate: Boolean read FMyTerminate write FMyTerminate;
    property Information: string read FInformation write FInformation;
    property Position: integer read FPosition write FPosition;
    constructor Create;
    destructor Destroy; override;
    procedure DoButtonCancel(Sender: TObject);
  end;

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
var
  lThread: TSampleThread;
begin
  lThread:= TSampleThread.Create;
  lThread.Start;
  TFileTextLog.SaveLog('Thread created and started');
end;

{ TSampleThread }

constructor TSampleThread.Create;

  procedure CreateInnerComp;
  begin
    FPanel       := TPanel.Create(frmMain.ScrollBox);
    FPanel.Parent:= frmMain.ScrollBox;
    FPanel.Width := 670;
    FPanel.Height:= 57;
    FPanel.Align := alTop;

    FLabel         := TLabel.Create(FPanel);
    FLabel.Parent  := FPanel;
    FLabel.Left    := 8;
    FLabel.Top     := 39;
    FLabel.Width   := 68;
    FLabel.Height  := 13;
    FLabel.Caption := 'Information...';

    FProgressBar         := TProgressBar.Create(FPanel);
    FProgressBar.Parent  := FPanel;
    FProgressBar.Left    := 8;
    FProgressBar.Top     := 16;
    FProgressBar.Width   := 541;
    FProgressBar.Height  := 17;
    FProgressBar.Anchors := [akLeft, akTop, akRight];

    FButton         := TButton.Create(FPanel);
    FButton.Parent  := FPanel;
    FButton.Left    := 555;
    FButton.Top     := 4;
    FButton.Width   := 111;
    FButton.Height  := 49;
    FButton.Align   := alRight;
    FButton.Caption := 'Cancel';
    FButton.OnClick := Self.DoButtonCancel;

  end;

begin
  inherited Create(True);
  CreateInnerComp;
  Self.MyTerminate     := False;
  Self.FreeOnTerminate := True;
  Self.Position        := 0;
  Randomize;
  Self.FInterval:= Random(500);
  TFileTextLog.SaveLog('Thread id ' + IntToStr(Self.ThreadID) + ' - Created');
end;

destructor TSampleThread.Destroy;
begin
  Synchronize(
    procedure
    begin
      Self.FPanel.Free;
    end);
  TFileTextLog.SaveLog('Thread id ' + IntToStr(Self.ThreadID) + ' - Destroyed');
  inherited;
end;

procedure TSampleThread.DoButtonCancel(Sender: TObject);
begin
  Self.MyTerminate:= True;
end;

procedure TSampleThread.Execute;
begin
  inherited;

  while (not Self.MyTerminate) or (Self.Terminated) do
  begin
    Sleep(Self.FInterval);

    Self.Position:= Self.Position + 1;
    case Self.Position of
      01: Self.Information:= 'Initializing...';
      20: Self.Information:= 'Some information...';
      40: Self.Information:= 'Baking bread...';
      60: Self.Information:= 'Freezing ice cream...';
      90: Self.Information:= 'Finalizing...';
    end;

    if Self.Position >= 100 then
      Self.Position:= 0;

    Synchronize(
      procedure
      begin
        Self.FLabel.Caption:= Self.Information;
        Self.FProgressBar.Position := Self.Position;
        TFileTextLog.SaveLog('Thread id ' + IntToStr(Self.ThreadID) + ' - Update screen');
      end);

  end;
  Self.Terminate;
end;

procedure TfrmMain.btnSaveLogClick(Sender: TObject);
begin
  TFileTextLog.SaveLog('Generate now...');
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ScrollBox.ControlCount > 0 then
  begin
    ShowMessage('Complete the processes before closing!');
    Action:= caNone;
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown:= True;
end;

end.
