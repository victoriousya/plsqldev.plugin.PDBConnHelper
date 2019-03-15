unit ufrmPdbManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, uMainWindow, StdCtrls, ExtCtrls, Grids, DBGrids, CRGrid, Buttons;

type
  TfrmPdbManager = class(TForm)
    ds1: TDataSource;
    pnl1: TPanel;
    lbl4: TLabel;
    cbb_BDB: TComboBox;
    lblConnectioError: TLabel;
    btnDrop: TSpeedButton;
    btnShow: TSpeedButton;
    crdbgrd1: TCRDBGrid;
    procedure btnShowClick(Sender: TObject);
    procedure btnDropClick(Sender: TObject);
  private
    { Private declarations }
    cl: TConnectionList;
    procedure Init(cl: TConnectionList);
    procedure Finalize;
  public
    { Public declarations }
  end;

procedure ShowDialog(cl: TConnectionList);

var
  frmPdbManager: TfrmPdbManager;

implementation

uses
  udtmdl_ora, OraScript;

{$R *.dfm}

procedure ShowDialog(cl: TConnectionList);
var
    f: TfrmPdbManager;
begin
    f:= TfrmPdbManager.Create(Application);
    f.Init(cl);
    f.ShowModal;
    f.Finalize;
    f.Free;
end;

{ TfrmPdbManager }

procedure TfrmPdbManager.Init(cl: TConnectionList);
var
    i: Integer;
begin
    cbb_BDB.Clear;
    Self.cl:= cl;
    for i:= 0 to cl.Count - 1 do
    begin
        cbb_BDB.AddItem(cl.FindByIndex(i).ConnectionName, nil);
    end;

end;

procedure TfrmPdbManager.btnShowClick(Sender: TObject);
var
    conn: TConnectionObject;
begin
    conn:= cl.FindByIndex(cbb_BDB.ItemIndex);
    dtmdl_ora.disconnect;
    if dtmdl_ora.connect(conn.Username, conn.Password, conn.Database) then begin
        lblConnectioError.Visible:= False;
        ds1.DataSet.Open;
        btnDrop.Visible:= True;
    end else begin
        lblConnectioError.Visible:= True;
        btnDrop.Visible:= False;
    end;
end;

procedure TfrmPdbManager.btnDropClick(Sender: TObject);
var
    pdb_name: String;
begin
    pdb_name:= ds1.DataSet.FieldByName('name').AsString;
    case MessageBox(Handle, PChar('Drop database "'+pdb_name+'". Please confirm'),
      PChar(Application.Title), MB_YESNO + MB_ICONWARNING + MB_DEFBUTTON2) of
      IDYES:
        begin
            dtmdl_ora.orscrptDropPdb.MacroByName('SID').Value:= pdb_name;
            dtmdl_ora.orscrptDropPdb.Execute;
            ds1.Enabled:= False;
            ds1.DataSet.Close;
            ds1.DataSet.Open;
            ds1.Enabled:= True;
        end;
    end;

end;

procedure TfrmPdbManager.Finalize;
begin
    dtmdl_ora.disconnect;
end;

end.

