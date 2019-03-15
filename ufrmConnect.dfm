object frmConnect: TfrmConnect
  Left = 488
  Top = 331
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'PDB Connect'
  ClientHeight = 200
  ClientWidth = 378
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
  object pgc1: TPageControl
    Left = 0
    Top = 0
    Width = 378
    Height = 200
    ActivePage = tsConnection
    Align = alClient
    TabOrder = 0
    object tsConnection: TTabSheet
      Caption = 'Connection'
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 370
        Height = 172
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
        object lbl5: TLabel
          Left = 8
          Top = 104
          Width = 55
          Height = 13
          Caption = 'Connect As'
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
          TabOrder = 5
          TabStop = False
          OnClick = btnRecentlyUsedClick
        end
        object btn_Connect: TButton
          Left = 96
          Top = 128
          Width = 193
          Height = 25
          Caption = 'Connect'
          ModalResult = 1
          TabOrder = 6
        end
        object cbb_BDB: TComboBox
          Left = 96
          Top = 8
          Width = 193
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          TabOrder = 0
          OnChange = cbb_BDBChange
        end
        object cbb_Connection: TcxComboBox
          Left = 96
          Top = 80
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 16
          Properties.DropDownSizeable = True
          Style.BorderStyle = ebs3D
          Style.Shadow = False
          TabOrder = 3
          Width = 193
        end
        object btnOwnerConnect: TButton
          Left = 320
          Top = 8
          Width = 41
          Height = 25
          Caption = 'root'
          ModalResult = 6
          TabOrder = 7
          TabStop = False
        end
        object cbbConnectAs: TComboBox
          Left = 96
          Top = 104
          Width = 193
          Height = 21
          Style = csDropDownList
          ItemHeight = 13
          ItemIndex = 0
          TabOrder = 4
          Text = 'NORMAL'
          Items.Strings = (
            'NORMAL'
            'SYSDBA'
            'SYSOPER')
        end
        object btn_LoginHistory: TButton
          Left = 296
          Top = 32
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 8
          TabStop = False
          OnClick = btn_LoginHistoryClick
        end
      end
    end
    object tsHistory: TTabSheet
      Caption = 'History'
      ImageIndex = 1
      DesignSize = (
        370
        172)
      object mmoHistory: TMemo
        Left = 0
        Top = 0
        Width = 370
        Height = 131
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          'mmoHistory')
        TabOrder = 0
        WordWrap = False
      end
      object btn_ApplyHistory: TButton
        Left = 91
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Apply'
        TabOrder = 1
        OnClick = btn_ApplyHistoryClick
      end
      object btn_ClearInvalid: TButton
        Left = 208
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Clear_Invalid'
        TabOrder = 2
        OnClick = btn_ClearInvalidClick
      end
    end
    object ts1: TTabSheet
      Caption = 'Login history'
      ImageIndex = 2
      DesignSize = (
        370
        172)
      object mmo_LoginHistory: TMemo
        Left = 0
        Top = 0
        Width = 370
        Height = 131
        Anchors = [akLeft, akTop, akRight, akBottom]
        Lines.Strings = (
          'mmoHistory')
        TabOrder = 0
        WordWrap = False
      end
      object btn_ApplyLoginHistory: TButton
        Left = 147
        Top = 136
        Width = 75
        Height = 25
        Caption = 'Apply'
        TabOrder = 1
        OnClick = btn_ApplyLoginHistoryClick
      end
    end
  end
  object pm_History: TPopupMenu
    AutoPopup = False
    Images = dtmdl_ora.il_common
    Left = 48
    Top = 56
  end
  object pm_LoginHistory: TPopupMenu
    AutoPopup = False
    Left = 64
    Top = 56
  end
end
