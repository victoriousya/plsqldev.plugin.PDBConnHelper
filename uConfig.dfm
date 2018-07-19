object fConfig: TfConfig
  Left = 534
  Top = 390
  BorderStyle = bsDialog
  Caption = 'Config'
  ClientHeight = 187
  ClientWidth = 448
  Color = clBtnFace
  DefaultMonitor = dmMainForm
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 0
    Top = 8
    Width = 48
    Height = 13
    Caption = 'Username'
  end
  object lbl2: TLabel
    Left = 0
    Top = 32
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object lbl3: TLabel
    Left = 0
    Top = 56
    Width = 46
    Height = 13
    Caption = 'Database'
  end
  object lbl_connected: TLabel
    Left = 224
    Top = 16
    Width = 84
    Height = 19
    Caption = 'Connected'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clGreen
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_not_connected: TLabel
    Left = 224
    Top = 16
    Width = 134
    Height = 19
    Caption = 'Connection failed'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object edtUsername: TEdit
    Left = 88
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edtUsername'
  end
  object edtPassword: TEdit
    Left = 88
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'edtPassword'
  end
  object mmoDatabase: TMemo
    Left = 88
    Top = 56
    Width = 353
    Height = 81
    Lines.Strings = (
      'mmoDatabase')
    TabOrder = 2
    WantReturns = False
  end
  object btn1: TButton
    Left = 0
    Top = 160
    Width = 97
    Height = 25
    Caption = 'Test connection'
    TabOrder = 3
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 288
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Accept'
    ModalResult = 1
    TabOrder = 4
  end
  object btn3: TButton
    Left = 368
    Top = 160
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
end
