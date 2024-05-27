object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Teste Thread'
  ClientHeight = 442
  ClientWidth = 750
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 750
    Height = 73
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 137
      Height = 13
      Caption = 'Adicionar                  Threads'
    end
    object btnCriarThreads: TButton
      Left = 16
      Top = 35
      Width = 137
      Height = 32
      Caption = 'Criar Threads'
      TabOrder = 0
      OnClick = btnCriarThreadsClick
    end
    object btnMenssagem: TButton
      Left = 176
      Top = 2
      Width = 129
      Height = 32
      Caption = 'Mensagem'
      TabOrder = 1
      OnClick = btnMenssagemClick
    end
    object Edit1: TEdit
      Left = 313
      Top = 7
      Width = 137
      Height = 21
      TabOrder = 2
    end
    object Edit2: TEdit
      Left = 69
      Top = 10
      Width = 36
      Height = 21
      NumbersOnly = True
      TabOrder = 3
      Text = '10'
    end
    object Button3: TButton
      Left = 176
      Top = 35
      Width = 161
      Height = 32
      Caption = 'Terminar todas as Threads'
      TabOrder = 4
      OnClick = Button3Click
    end
    object GroupBox2: TGroupBox
      Left = 568
      Top = 1
      Width = 181
      Height = 71
      Align = alRight
      Caption = 'Qtd de Thread Ativas'
      TabOrder = 5
      object lblQtdThreads: TLabel
        Left = 2
        Top = 15
        Width = 177
        Height = 54
        Align = alClient
        Alignment = taCenter
        Caption = '0'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitWidth = 10
        ExplicitHeight = 19
      end
    end
    object cbAtualizarTela: TCheckBox
      Left = 360
      Top = 34
      Width = 137
      Height = 17
      Caption = 'Atualizar na tela'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = cbAtualizarTelaClick
    end
    object cbSuspender: TCheckBox
      Left = 360
      Top = 50
      Width = 137
      Height = 17
      Caption = 'Pausar Threads'
      TabOrder = 7
      OnClick = cbSuspenderClick
    end
  end
  object memLog: TMemo
    Left = 0
    Top = 280
    Width = 750
    Height = 162
    Align = alBottom
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 73
    Width = 750
    Height = 207
    Align = alClient
    Caption = 'Pista de Corrida'
    TabOrder = 2
    object ScrollBox1: TScrollBox
      Left = 2
      Top = 15
      Width = 746
      Height = 190
      Align = alClient
      TabOrder = 0
    end
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 384
    Top = 136
  end
end
