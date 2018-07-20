object fConfig: TfConfig
  Left = 494
  Top = 339
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'Config'
  ClientHeight = 283
  ClientWidth = 619
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
  object pnl1: TPanel
    Left = 162
    Top = 0
    Width = 457
    Height = 227
    Align = alRight
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 0
    object lbl1: TLabel
      Left = 8
      Top = 40
      Width = 48
      Height = 13
      Caption = 'Username'
    end
    object lbl2: TLabel
      Left = 8
      Top = 64
      Width = 46
      Height = 13
      Caption = 'Password'
    end
    object lbl3: TLabel
      Left = 8
      Top = 88
      Width = 46
      Height = 13
      Caption = 'Database'
    end
    object lbl_connected: TLabel
      Left = 232
      Top = 48
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
      Left = 232
      Top = 48
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
    object lbl4: TLabel
      Left = 8
      Top = 16
      Width = 83
      Height = 13
      Caption = 'Connection name'
    end
    object btn1: TButton
      Left = 8
      Top = 192
      Width = 97
      Height = 25
      Caption = 'Test connection'
      TabOrder = 3
      OnClick = btn1Click
    end
    object dbedtUsername: TDBEdit
      Left = 96
      Top = 40
      Width = 121
      Height = 21
      DataField = 'Username'
      DataSource = ds1
      TabOrder = 0
    end
    object dbedtPassword: TDBEdit
      Left = 96
      Top = 64
      Width = 121
      Height = 21
      DataField = 'Password'
      DataSource = ds1
      TabOrder = 1
    end
    object dbedtConnectionName: TDBEdit
      Left = 96
      Top = 16
      Width = 121
      Height = 21
      DataField = 'ConnectionName'
      DataSource = ds1
      TabOrder = 4
    end
    object dbmmoDatabase: TDBMemo
      Left = 96
      Top = 88
      Width = 353
      Height = 81
      DataField = 'Database'
      DataSource = ds1
      TabOrder = 2
      WantReturns = False
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 162
    Height = 227
    Align = alClient
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object CRDBGrid1: TCRDBGrid
      Left = 2
      Top = 20
      Width = 158
      Height = 205
      OptionsEx = [dgeLocalSorting, dgeRecordCount, dgeStretch]
      Align = alClient
      DataSource = ds1
      Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'ConnectionName'
          Width = 138
          Visible = True
        end>
    end
    object dbnvgr1: TDBNavigator
      Left = 2
      Top = 2
      Width = 158
      Height = 18
      DataSource = ds1
      VisibleButtons = [nbLast, nbInsert, nbDelete, nbEdit, nbPost, nbCancel]
      Align = alTop
      Flat = True
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
    end
  end
  object pnl3: TPanel
    Left = 0
    Top = 227
    Width = 619
    Height = 56
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    Caption = ' '
    TabOrder = 2
    object btn2: TButton
      Left = 224
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Accept'
      ModalResult = 1
      TabOrder = 0
    end
    object btn3: TButton
      Left = 304
      Top = 15
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object dxmdt: TdxMemData
    Active = True
    Indexes = <>
    Persistent.Option = poNone
    Persistent.Data = {
      5665728FC2F5285C8FFE3F040000001E00000001000F00436F6E6E656374696F
      6E4E616D65001E00000001000900557365726E616D65001E0000000100090050
      617373776F726400FF0000000100090044617461626173650001040000005356
      424F010400000075736572010800000070617373776F72640108000000646174
      6162617365010400000053564645010600000073767573657201060000007376
      70617373010400000073766462}
    SortOptions = []
    AfterScroll = dxmdtAfterScroll
    Left = 48
    Top = 16
    object strngflddxmdt1ConnectionName: TStringField
      FieldName = 'ConnectionName'
      Size = 30
    end
    object strngflddxmdt1Username: TStringField
      FieldName = 'Username'
      Size = 30
    end
    object strngflddxmdt1Password: TStringField
      FieldName = 'Password'
      Size = 30
    end
    object strngflddxmdt1Database: TStringField
      FieldName = 'Database'
      Size = 255
    end
  end
  object ds1: TDataSource
    DataSet = dxmdt
    Left = 16
    Top = 16
  end
end
