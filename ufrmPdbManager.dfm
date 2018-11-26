object frmPdbManager: TfrmPdbManager
  Left = 468
  Top = 239
  Width = 566
  Height = 418
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
    Width = 558
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
  object dbgrd1: TDBGrid
    Left = 0
    Top = 41
    Width = 558
    Height = 261
    Align = alClient
    DataSource = ds1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'name'
        Width = 162
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'creation_time'
        Width = 143
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'open_mode'
        Width = 107
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'conn_count'
        Width = 80
        Visible = True
      end>
  end
  object mmoLog: TMemo
    Left = 0
    Top = 302
    Width = 558
    Height = 89
    Align = alBottom
    ReadOnly = True
    TabOrder = 2
  end
  object ds1: TDataSource
    DataSet = dtmdl_ora.orqryPdbs
    Left = 136
    Top = 56
  end
end
