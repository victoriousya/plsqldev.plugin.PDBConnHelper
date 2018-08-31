unit ufrmConnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, uMainWindow, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinBlack, dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinFoggy, dxSkinGlassOceans, dxSkiniMaginary,
  dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin,
  dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSharp, dxSkinSilver, dxSkinSpringTime,
  dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, ComCtrls;

type

  TfrmConnect = class(TForm)
    pnl1: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtUsername: TEdit;
    edtPassword: TEdit;
    btnRecentlyUsed: TButton;
    lbl3: TLabel;
    btn1: TButton;
    pm_History: TPopupMenu;
    lbl4: TLabel;
    cbb_BDB: TComboBox;
    cbb_Connection: TcxComboBox;
    btnOwnerConnect: TButton;
    lbl5: TLabel;
    cbbConnectAs: TComboBox;
    pgc1: TPageControl;
    tsConnection: TTabSheet;
    tsHistory: TTabSheet;
    mmoHistory: TMemo;
    btn2: TButton;
    procedure miTemplateClick(Sender: TObject);
    procedure btnRecentlyUsedClick(Sender: TObject);
    procedure cbb_BDBChange(Sender: TObject);
    procedure btn2Click(Sender: TObject);
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
    pm.Items.Clear;
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
    mr: TModalResult;
begin
    f:= TfrmConnect.Create(Application);
    f.cbb_BDB.Clear;
    f.cl:= cl;
    for i:= 0 to cl.Count - 1 do
    begin
        f.cbb_BDB.AddItem(cl.FindByIndex(i).ConnectionName, nil);
    end;

    f.ApplyHistoryEntry(lastConnection);
    PreparePopup(f, f.pm_History, connHistory, f.miTemplateClick );
    f.mmoHistory.Lines.Text:= connHistory.Text;

    mr:= f.ShowModal;

    connHistory.Text:= f.mmoHistory.Lines.Text;

    if mr = mrOk then begin
        conn:= cl.FindByIndex(f.cbb_BDB.ItemIndex);
        connDB:= replace_sid(Trim(f.cbb_Connection.Text), conn.Database);
        if connDB <> '' then
            Result:= IDE_SetConnectionAs(PChar(f.edtUsername.Text), PChar(f.edtPassword.Text), PChar(connDB), PChar(f.cbbConnectAs.Text));
            if Result then begin
                try
                    ConnectionName:= f.cbb_BDB.Text;
                    Username:= f.edtUsername.Text;
                    Password:= f.edtPassword.Text;
                    ServiceName:= Trim(f.cbb_Connection.Text);
                    ConnectAs:= f.cbbConnectAs.Text;
                    if ConnectAs <> '' then
                        lastConnection:= Format('%s:%s/%s@%s as %s', [ConnectionName, Username, Password, ServiceName, ConnectAs])
                    else
                        lastConnection:= Format('%s:%s/%s@%s', [ConnectionName, Username, Password, ServiceName]);
                    if connHistory.IndexOf(lastConnection) < 0 then
                        connHistory.Add(lastConnection);
                except
                    on e: Exception do
                        ShowMessage(E.Message);
                end;
            end else
                MessageBox(Application.Handle, 'Connection failed', 'Îøèáêà', MB_OK +
                  MB_ICONSTOP);

    end else if mr = mrYes then begin
        conn:= cl.FindByIndex(f.cbb_BDB.ItemIndex);
        Result:= IDE_SetConnectionAs(PChar(conn.Username), PChar(conn.Password), PChar(conn.Database), PChar(f.cbbConnectAs.Items[0]));
        if Result then begin
            try
                ConnectionName:= f.cbb_BDB.Text;
                Username:= conn.Username;
                Password:= conn.Password;
                ServiceName:= get_sid(conn.Database);
                ConnectAs:= f.cbbConnectAs.Items[0];
                if ConnectAs <> '' then
                    lastConnection:= Format('%s:%s/%s@%s as %s', [ConnectionName, Username, Password, ServiceName, ConnectAs])
                else
                    lastConnection:= Format('%s:%s/%s@%s', [ConnectionName, Username, Password, ServiceName]);
                if connHistory.IndexOf(lastConnection) < 0 then
                    connHistory.Add(lastConnection);
            except
                on e: Exception do
                    ShowMessage(E.Message);
            end;
        end else
            MessageBox(Application.Handle, 'Connection failed', 'Îøèáêà', MB_OK +
              MB_ICONSTOP);
    end;
    f.Free;
end;

procedure TfrmConnect.FillPDBList(lastServiceName: String);
var
    conn: TConnectionObject;
    i : Integer;
begin
    if cbb_BDB.ItemIndex >= 0 then
    begin
        conn:= cl.FindByIndex(cbb_BDB.ItemIndex);
        cbb_Connection.Properties.Items.Text:= dtmdl_ora.get_pdb_list(conn.Username, conn.Password, conn.Database).Text;
        for i:= 0 to cbb_Connection.Properties.Items.Count - 1 do
        begin
            if Trim(cbb_Connection.Properties.Items[i]) = Trim(lastServiceName) then begin
                cbb_Connection.ItemIndex:= i;
                Break;
            end;
        end;
//        cbb_Connection.ItemIndex:= cbb_Connection.Properties.Items.IndexOf(lastServiceName);
    end;
end;

procedure TfrmConnect.ApplyHistoryEntry(historyEntry: String);
var
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
begin
    ParseHistoryEntry(historyEntry, ConnectionName, Username, Password, ServiceName, ConnectAs);
    cbb_BDB.ItemIndex:= cl.IndexByName(ConnectionName);
    edtUsername.Text:= Username;
    edtPassword.Text:= Password;
    FillPDBList(ServiceName);
    cbbConnectAs.ItemIndex:= cbbConnectAs.Items.IndexOf(ConnectAs);
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

procedure TfrmConnect.cbb_BDBChange(Sender: TObject);
begin
    FillPDBList('');
end;

procedure TfrmConnect.btn2Click(Sender: TObject);
var
    sl: TStringList;
begin
    sl:= TStringList.Create;
    sl.Text:= mmoHistory.Text;
    PreparePopup(Self, Self.pm_History, sl, self.miTemplateClick );
    sl.Free;
    pgc1.ActivePage:= tsConnection;
end;

end.
