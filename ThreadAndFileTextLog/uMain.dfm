object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Main Form'
  ClientHeight = 427
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBotton: TPanel
    Left = 0
    Top = 386
    Width = 674
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnCreate: TButton
      AlignWithMargins = True
      Left = 508
      Top = 4
      Width = 162
      Height = 33
      Align = alRight
      Caption = 'Create Thread'
      TabOrder = 0
      OnClick = btnCreateClick
    end
    object btnSaveLog: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 197
      Height = 33
      Align = alLeft
      Caption = 'Save Log Now'
      TabOrder = 1
      OnClick = btnSaveLogClick
      ExplicitLeft = 0
      ExplicitTop = 6
    end
  end
  object ScrollBox: TScrollBox
    Left = 0
    Top = 0
    Width = 674
    Height = 386
    Align = alClient
    TabOrder = 1
  end
end
