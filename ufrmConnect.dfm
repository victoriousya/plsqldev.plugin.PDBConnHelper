object frmConnect: TfrmConnect
  Left = 488
  Top = 331
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'PDB Connect'
  ClientHeight = 161
  ClientWidth = 329
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnl1: TPanel
    Left = 0
    Top = 0
    Width = 329
    Height = 161
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    PopupMenu = pm_History
    TabOrder = 0
    object lbl1: TLabel
      Left = 8
      Top = 32
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object lbl2: TLabel
      Left = 8
      Top = 56
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object lbl3: TLabel
      Left = 8
      Top = 80
      Width = 54
      Height = 13
      Caption = 'Connection'
    end
    object lbl4: TLabel
      Left = 8
      Top = 8
      Width = 43
      Height = 13
      Caption = 'PDB alias'
    end
    object edtUsername: TEdit
      Left = 96
      Top = 32
      Width = 193
      Height = 21
      TabOrder = 1
      Text = 'edtUsername'
    end
    object edtPassword: TEdit
      Left = 96
      Top = 56
      Width = 193
      Height = 21
      TabOrder = 2
      Text = 'edtPassword'
    end
    object btnRecentlyUsed: TButton
      Left = 296
      Top = 8
      Width = 25
      Height = 25
      Caption = '...'
      TabOrder = 4
      TabStop = False
      OnClick = btnRecentlyUsedClick
    end
    object cbb_Connection: TComboBox
      Left = 96
      Top = 80
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
    object btn1: TButton
      Left = 127
      Top = 112
      Width = 75
      Height = 25
      Caption = 'Connect'
      ModalResult = 1
      TabOrder = 5
    end
    object cbb_Connections: TComboBox
      Left = 96
      Top = 8
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 3
      OnChange = cbb_ConnectionsChange
    end
  end
  object pm_History: TPopupMenu
    Left = 296
    Top = 40
  end
end
