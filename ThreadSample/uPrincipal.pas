unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.Generics.Collections;

type

  TMinhaThread = class(TThread)
    protected
      procedure Execute; override;
    private
      FProgress: TProgressBar;
      FPanel: TPanel;
      FLabel: TLabel;
      FSleepTime: integer;
      class var FThreadList: TObjectList<TMinhaThread>;
      class var FTerminateAll: Boolean;
    class var FAtualizarNaTela: Boolean;
    public
      procedure AtualizaTela;
      procedure Msg(const AMsg: string);
      destructor Destroy; override;
      constructor Create(const AOwner: TWinControl);
      class constructor ClassCreate;
      class destructor ClassDestroy;
      class function GetThreadList: TObjectList<TMinhaThread>;
      class property TerminateAll: Boolean read FTerminateAll write FTerminateAll;
      class property AtualizarNaTela: Boolean read FAtualizarNaTela write FAtualizarNaTela;
  end;

  TfrmPrincipal = class(TForm)
    Panel1: TPanel;
    btnCriarThreads: TButton;
    memLog: TMemo;
    btnMenssagem: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Edit2: TEdit;
    GroupBox1: TGroupBox;
    ScrollBox1: TScrollBox;
    Button3: TButton;
    Timer: TTimer;
    GroupBox2: TGroupBox;
    lblQtdThreads: TLabel;
    cbAtualizarTela: TCheckBox;
    cbSuspender: TCheckBox;
    procedure btnCriarThreadsClick(Sender: TObject);
    procedure btnMenssagemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure cbAtualizarTelaClick(Sender: TObject);
    procedure cbSuspenderClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

{ TMinhaThread }

procedure TMinhaThread.AtualizaTela;
begin
  if TMinhaThread.FAtualizarNaTela then
    Application.ProcessMessages;
end;

class constructor TMinhaThread.ClassCreate;
begin
  TMinhaThread.FTerminateAll:= False;
  TMinhaThread.FAtualizarNaTela:= True;
  TMinhaThread.FThreadList:= TObjectList<TMinhaThread>.Create(False);
end;

class destructor TMinhaThread.ClassDestroy;
begin
  TMinhaThread.FThreadList.Free;
end;

constructor TMinhaThread.Create(const AOwner: TWinControl);
begin
  inherited Create(False);
  FreeOnTerminate:= True;

  FPanel:= TPanel.Create(AOwner);
  FPanel.Parent:= AOwner;
  FPanel.Align:= alTop;
  FPanel.Height:= 20;

  FLabel:= TLabel.Create(FPanel);
  FLabel.Parent:= FPanel;
  FLabel.Align:= alLeft;
  FLabel.Layout:= tlCenter;
  FLabel.AutoSize:= False;
  FLabel.Width:= 120;
  FLabel.Caption:= 'Thread ID: ' + FormatFloat('0000000000', Self.ThreadID) + ' ';

  FProgress:= TProgressBar.Create(FPanel);
  FProgress.Parent:= FPanel;
  FProgress.Align:= alClient;
  FProgress.Position:= 0;
  FProgress.Max:= 100;
  FProgress.Top:= 1000;

  Randomize;
  FSleepTime:= Random(100);
  TMinhaThread.FThreadList.Add(Self); //Insere a Thread na lista de threads ativas
end;

destructor TMinhaThread.Destroy;
begin
  Self.Synchronize(
    procedure
    begin
      FPanel.Free;
    end);
  TMinhaThread.FThreadList.Remove(Self); //Remove a Thread da lista de
                                         // threads ativas, pois ela esta sendo concluída
  inherited;
end;

procedure TMinhaThread.Execute;
var
  l: Integer;
begin
  inherited;
  Self.Msg('Iniciada...');

  for l:= 0 to Pred(FProgress.Max) do
  begin
    if TMinhaThread.FTerminateAll then
    begin
      if not Self.Terminated then
        Self.Msg('Encerrando a Thread prematuramente...');
      Self.Terminate;
      Continue;
    end;

    if TMinhaThread.FAtualizarNaTela then
      FProgress.Position:= l;
    Sleep(Self.FSleepTime);
    Randomize;
    Self.FSleepTime:= Random(2000);
    Self.Synchronize(Self.AtualizaTela);

    if FProgress.Position = 50 then
       Self.Msg('Thread em 50%...');

    if FProgress.Position = 75 then
       Self.Msg('Thread em 75%...');

  end;

  Self.Msg('Thread em 100%...');
  Self.Msg('Concluída...');
  Sleep(1000);
end;

class function TMinhaThread.GetThreadList: TObjectList<TMinhaThread>;
begin
  Result:= TMinhaThread.FThreadList;
end;

procedure TMinhaThread.Msg(const AMsg: string);
begin
  if TMinhaThread.FAtualizarNaTela then
  begin
    Self.Synchronize(
      procedure
      begin
        frmPrincipal.memLog.Lines.Add(FormatDateTime('hh:mm:ss:zzz', Now) + ' - Thread ' + IntToStr(Self.ThreadID) + ' > ' + AMsg)
      end);
  end;
end;

procedure TfrmPrincipal.btnCriarThreadsClick(Sender: TObject);
var
  l: integer;
begin
  TMinhaThread.TerminateAll:= False;
  l:= StrToIntDef(Edit2.Text, 0);
  TThread.CreateAnonymousThread( //Thread par aa criação das outras Threads
    procedure
    var
      k: integer;
    begin
      Sleep(1000);
      for k:= 0 to Pred(l) do
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            TMinhaThread.Create(Self.ScrollBox1);
          end);
      end;
    end).Start;
end;

procedure TfrmPrincipal.btnMenssagemClick(Sender: TObject);
begin
  ShowMessage('Xuxu beleza...');
end;

procedure TfrmPrincipal.Button3Click(Sender: TObject);
begin
  TMinhaThread.TerminateAll:= True;
end;

procedure TfrmPrincipal.cbAtualizarTelaClick(Sender: TObject);
begin
  TMinhaThread.AtualizarNaTela:= cbAtualizarTela.Checked;
end;

procedure TfrmPrincipal.cbSuspenderClick(Sender: TObject);
var
  lItem: TMinhaThread;
begin
  for lItem in TMinhaThread.GetThreadList do
    lItem.Suspended := cbSuspender.Checked;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
var
  lItem: TMinhaThread;
begin
  TMinhaThread.TerminateAll:= True;

  for lItem in TMinhaThread.GetThreadList do
    lItem.Suspended := False;

  //Aguara as Threads terminarem, para poder sair do programa
  while TMinhaThread.GetThreadList.Count > 0 do
  begin
    Application.ProcessMessages;
    Sleep(100);
  end;

end;

procedure TfrmPrincipal.TimerTimer(Sender: TObject);
begin
  lblQtdThreads.Caption:= IntToStr(TMinhaThread.GetThreadList.Count);
end;

end.
