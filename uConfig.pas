unit uConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlugInIntf, StdCtrls, ExtCtrls, uMainWindow, DB, dxmdaset,
  Grids, DBGrids, CRGrid, DBCtrls, Mask;

type
  TfConfig = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl_connected: TLabel;
    lbl_not_connected: TLabel;
    btn1: TButton;
    pnl2: TPanel;
    lbl4: TLabel;
    pnl3: TPanel;
    btn2: TButton;
    btn3: TButton;
    dxmdt: TdxMemData;
    strngflddxmdt1ConnectionName: TStringField;
    strngflddxmdt1Username: TStringField;
    strngflddxmdt1Password: TStringField;
    strngflddxmdt1Database: TStringField;
    ds1: TDataSource;
    CRDBGrid1: TCRDBGrid;
    dbnvgr1: TDBNavigator;
    dbedtUsername: TDBEdit;
    dbedtPassword: TDBEdit;
    dbedtConnectionName: TDBEdit;
    dbmmoDatabase: TDBMemo;
    procedure btn1Click(Sender: TObject);
    procedure dxmdtAfterScroll(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function DoConfig( var cl: TConnectionList ): TModalResult;


var
  fConfig: TfConfig;

implementation

uses
  udtmdl_ora;

{$R *.dfm}

function DoConfig(var cl: TConnectionList): TModalResult;
var
  f: TfConfig;
  i: Integer;
begin
    Application.Handle:= IDE_GetAppHandle;
    f:= TfConfig.Create(Application);
    f.dxmdt.Open;
    for i:= 0 to cl.Count - 1 do
    begin
        f.dxmdt.Append;
        f.dxmdt.FieldByName('ConnectionName').asString:= (cl.Items[i] as TConnectionObject).ConnectionName;
        f.dxmdt.FieldByName('Username').asString:= (cl.Items[i] as TConnectionObject).Username;
        f.dxmdt.FieldByName('Password').asString:= (cl.Items[i] as TConnectionObject).Password;
        f.dxmdt.FieldByName('Database').asString:= (cl.Items[i] as TConnectionObject).Database;
        f.dxmdt.Post;
    end;
    f.dxmdt.First;

    f.lbl_connected.Visible:= False;
    f.lbl_not_connected.Visible:= False;
    Result:= f.ShowModal;
    if (Result = mrOk) then
    begin
        cl.Clear;
        f.dxmdt.First;

        while not f.dxmdt.Eof do begin
            cl.AddConnection(
                f.dxmdt.FieldByName('ConnectionName').asString
              , f.dxmdt.FieldByName('Username').asString
              , f.dxmdt.FieldByName('Password').asString
              , f.dxmdt.FieldByName('Database').asString
              , ''
            );
            f.dxmdt.Next;
        end;
    end else Result:= mrCancel;
    f.Free;
end;

procedure TfConfig.btn1Click(Sender: TObject);
begin
    if dtmdl_ora.test_connection(
          dxmdt.FieldByName('Username').asString
        , dxmdt.FieldByName('Password').asString
        , dxmdt.FieldByName('Database').asString) then begin
        lbl_connected.Visible:= True;
        lbl_not_connected.Visible:= False;
    end else begin
        lbl_connected.Visible:= False;
        lbl_not_connected.Visible:= True;
    end;
end;

procedure TfConfig.dxmdtAfterScroll(DataSet: TDataSet);
begin
    lbl_connected.Visible:= False;
    lbl_not_connected.Visible:= False;
end;

end.
