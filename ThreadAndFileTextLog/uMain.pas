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
    //My control to see if the thread should be terminated
    property MyTerminate: Boolean read FMyTerminate write FMyTerminate;
    //Property to store some information that must be informed to the user
    property Information: string read FInformation write FInformation;
    //Thread-controlled progressbar position
    property Position: integer read FPosition write FPosition;
    //Method that should be called to inform the main loop that the thread must be terminated
    procedure DoButtonCancel(Sender: TObject);
    constructor Create;
    destructor Destroy; override;
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
begin
  //Create the thread
  TSampleThread.Create.Start;

  //Calls the log method
  TFileTextLog.WriteLog('Thread created and started');
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
  inherited Create(True); //Class constructor inheritance
  CreateInnerComp;    //Creates auxiliary components in the VCL

  //Variables initialization
  Self.MyTerminate     := False;
  Self.FreeOnTerminate := True;
  Self.Position        := 0;

  //Diversifying the thread length
  Randomize;
  Self.FInterval:= Random(500);

  //Calls the log method
  TFileTextLog.WriteLog('Thread id ' + IntToStr(Self.ThreadID) + ' - Created');
end;

destructor TSampleThread.Destroy;
begin
  //Destroy the components in the VCL
  Synchronize(
    procedure
    begin
      //As the other components are children of the panel,
      //then just destroy it
      Self.FPanel.Free;
    end);

  //Calls the log method
  TFileTextLog.WriteLog('Thread id ' + IntToStr(Self.ThreadID) + ' - Destroyed');
  inherited;
end;

procedure TSampleThread.DoButtonCancel(Sender: TObject);
begin
  //Only inform a finalization os thread
  Self.MyTerminate:= True;
end;

procedure TSampleThread.Execute;
begin
  inherited;

  //Main loop os thread
  while (not Self.MyTerminate) or (Self.Terminated) do
  begin
    //Not to use all the processor processing
    Sleep(Self.FInterval);

    //Increase que possiotion os progressbar (not in VCL)
    Self.Position:= Self.Position + 1;
    if Self.Position >= 100 then
      Self.Position:= 0;

    //The information do show to user (not in VCL)
    case Self.Position of
      01: Self.Information:= 'Initializing...';
      20: Self.Information:= 'Some information...';
      40: Self.Information:= 'Baking bread...';
      60: Self.Information:= 'Freezing ice cream...';
      90: Self.Information:= 'Finalizing...';
    end;

    //Update the VCL
    Synchronize(
      procedure
      begin
        Self.FLabel.Caption:= Self.Information;
        Self.FProgressBar.Position := Self.Position;
        TFileTextLog.WriteLog('Thread id ' + IntToStr(Self.ThreadID) + ' - Update screen (VCL)');
      end);

    TFileTextLog.WriteLog('Thread id ' + IntToStr(Self.ThreadID) + ' - End Loop');
  end;
  Self.Terminate;
end;

procedure TfrmMain.btnSaveLogClick(Sender: TObject);
begin
  //Calls the log method
  TFileTextLog.WriteLog('Generate now...');
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
