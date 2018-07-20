unit ufrmConnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, uMainWindow;

type

  TfrmConnect = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnRecentlyUsed: TButton;
    cbb_Connection: TComboBox;
    lbl3: TLabel;
    btn1: TButton;
    pm_History: TPopupMenu;
    lbl4: TLabel;
    cbb_Connections: TComboBox;
    procedure miTemplateClick(Sender: TObject);
    procedure btnRecentlyUsedClick(Sender: TObject);
    procedure cbb_ConnectionsChange(Sender: TObject);
  private
    { Private declarations }
    cl: TConnectionList;
    procedure ApplyHistoryEntry(historyEntry: String);
    procedure FillPDBList(lastServiceName: String);
  public
    { Public declarations }
  end;

function ShowDialog(var lastConnection: String; var connHistory: TStringList; cl: TConnectionList): Boolean;
procedure PreparePopup(Owner: TComponent; var pm: TPopupMenu; connHistory: TStringList; clickProc: TNotifyEvent );

var
  frmConnect: TfrmConnect;

implementation

uses
  PlugInIntf, StrUtils, udtmdl_ora;

{$R *.dfm}

procedure PreparePopup(Owner: TComponent; var pm: TPopupMenu; connHistory: TStringList; clickProc: TNotifyEvent );
var
    i: Integer;
    mi: TMenuItem;
begin
    for i:= 0 to connHistory.Count-1 do begin
        mi:= TMenuItem.Create(Owner);
        mi.Caption:= connHistory[i];
        mi.OnClick:= clickProc;
        pm.Items.Add(mi);
    end;
end;

function ShowDialog(var lastConnection: String; var connHistory: TStringList; cl: TConnectionList): Boolean;
var
    f : TfrmConnect;
    connDB: String;
    i: Integer;
    conn: TConnectionObject;
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
begin
    f:= TfrmConnect.Create(Application);
    f.cbb_Connections.Clear;
    f.cl:= cl;
    for i:= 0 to cl.Count - 1 do
    begin
        f.cbb_Connections.AddItem(cl.FindByIndex(i).ConnectionName, nil);
    end;

    f.ApplyHistoryEntry(lastConnection);
    PreparePopup(f, f.pm_History, connHistory, f.miTemplateClick );

    if f.ShowModal = mrOk then begin
        conn:= cl.FindByIndex(f.cbb_Connections.ItemIndex);
        connDB:= replace_sid(f.cbb_Connection.Text, conn.Database);
        if connDB <> '' then
            Result:= IDE_SetConnection(PChar(f.edtUsername.Text), PChar(f.edtPassword.Text), PChar(connDB));
            if Result then begin
                ConnectionName:= f.cbb_Connections.Text;
                Username:= f.edtUsername.Text;
                Password:= f.edtPassword.Text;
                ServiceName:= f.cbb_Connection.Text;
                if ConnectAs <> '' then
                    lastConnection:= Format('%s:%s/%s@%s as %s', [ConnectionName, Username, Password, ServiceName, ConnectAs])
                else
                    lastConnection:= Format('%s:%s/%s@%s', [ConnectionName, Username, Password, ServiceName]);
                if connHistory.IndexOf(lastConnection) < 0 then
                    connHistory.Add(lastConnection);
            end else
                MessageBox(Application.Handle, 'Connection failed', 'Îøèáêà', MB_OK +
                  MB_ICONSTOP);

    end;
    f.Free;
end;

procedure TfrmConnect.FillPDBList(lastServiceName: String);
var
    conn: TConnectionObject;
begin
    if cbb_Connections.ItemIndex >= 0 then
    begin
        conn:= cl.FindByIndex(cbb_Connections.ItemIndex);
        cbb_Connection.Items.Text:= dtmdl_ora.get_pdb_list(conn.Username, conn.Password, conn.Database).Text;
        cbb_Connection.ItemIndex:= cbb_Connection.Items.IndexOf(lastServiceName);
    end;
end;

procedure TfrmConnect.ApplyHistoryEntry(historyEntry: String);
var
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
begin
    ParseHistoryEntry(historyEntry, ConnectionName, Username, Password, ServiceName, ConnectAs);
    cbb_Connections.ItemIndex:= cl.IndexByName(ConnectionName);
    edtUsername.Text:= Username;
    edtPassword.Text:= Password;
    FillPDBList(ServiceName);
end;

procedure TfrmConnect.miTemplateClick(Sender: TObject);
begin
    ApplyHistoryEntry(TMenuItem(Sender).Caption);
end;

procedure TfrmConnect.btnRecentlyUsedClick(Sender: TObject);
var
   r: TRect;
   p: TPoint;
begin
    r:= TButton(Sender).ClientRect;
    p:= TButton(Sender).ClientToScreen(Point(r.Left, r.Bottom));
    pm_History.Popup(p.X, p.Y);
end;

procedure TfrmConnect.cbb_ConnectionsChange(Sender: TObject);
begin
    FillPDBList('');
end;

end.
