object frmPdbManager: TfrmPdbManager
  Left = 658
  Top = 308
  Width = 870
  Height = 630
  Caption = 'PDB Manager'
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
    Width = 862
    Height = 41
    Align = alTop
    Caption = ' '
    TabOrder = 0
    object lbl4: TLabel
      Left = 8
      Top = 8
      Width = 43
      Height = 13
      Caption = 'PDB alias'
    end
    object lblConnectioError: TLabel
      Left = 384
      Top = 8
      Width = 130
      Height = 19
      Caption = 'Connection error'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      Visible = False
    end
    object btnDrop: TSpeedButton
      Left = 376
      Top = 8
      Width = 145
      Height = 25
      Caption = 'Drop selected'
      Visible = False
      OnClick = btnDropClick
    end
    object btnShow: TSpeedButton
      Left = 296
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Show'
      OnClick = btnShowClick
    end
    object cbb_BDB: TComboBox
      Left = 96
      Top = 8
      Width = 193
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object crdbgrd1: TCRDBGrid
    Left = 0
    Top = 41
    Width = 862
    Height = 562
    OptionsEx = [dgeEnableSort, dgeFilterBar, dgeLocalFilter, dgeLocalSorting, dgeRecordCount, dgeStretch]
    Align = alClient
    BorderStyle = bsNone
    Ctl3D = True
    DataSource = ds1
    Options = [dgTitles, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'BASE_NAME'
        Title.Caption = 'Base name'
        Width = 249
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Cloned DB'
        Width = 227
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CREATION_TIME'
        Title.Caption = 'Created'
        Width = 112
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'OPEN_MODE'
        Title.Caption = 'Open mode'
        Width = 89
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CONN_COUNT'
        Title.Caption = 'Connections'
        Width = 162
        Visible = True
      end>
  end
  object ds1: TDataSource
    DataSet = dtmdl_ora.orqryPdbs
    Left = 136
    Top = 56
  end
end
