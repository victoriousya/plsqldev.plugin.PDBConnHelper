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
    btn_Connect: TButton;
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
    btn_ApplyHistory: TButton;
    ts1: TTabSheet;
    mmo_LoginHistory: TMemo;
    btn_ApplyLoginHistory: TButton;
    btn_LoginHistory: TButton;
    pm_LoginHistory: TPopupMenu;
    btn_ClearInvalid: TButton;
    mmoLogInvalid: TMemo;
    pnl2: TPanel;
    splLogInvalid: TSplitter;
    procedure miTemplateClick(Sender: TObject);
    procedure btnRecentlyUsedClick(Sender: TObject);
    procedure cbb_BDBChange(Sender: TObject);
    procedure btn_ApplyHistoryClick(Sender: TObject);
    procedure btn_ApplyLoginHistoryClick(Sender: TObject);
    procedure btn_LoginHistoryClick(Sender: TObject);
    procedure btn_ClearInvalidClick(Sender: TObject);
    procedure tsHistoryEnter(Sender: TObject);
  private
    { Private declarations }
    cl: TConnectionList;
    procedure ApplyHistoryEntry(historyEntry: String);
    procedure FillPDBList(lastServiceName: String);
    procedure ApplyLoginHistoryEntry(historyEntry: String);
    procedure miLoginTemplateClick(Sender: TObject);
  public
    { Public declarations }
  end;

function ShowDialog(var lastConnection: String; var connHistory, loginHistory: TStringList; cl: TConnectionList): Boolean;
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
    miGrp: TMenuItem;
    sidMenuList: TStringList;
    sidMenuListIdx: Integer;
    sid: string;

    function getSid(i_str: String): string;
    var
        atPos, spacePos: Integer;
    begin
        atPos:= PosEx('@', i_str, 1);
        spacePos:= PosEx(' ', i_str, atPos);
        result:= Copy(i_str, atPos+1, spacePos - atPos - 1);
    end;
begin
    sidMenuList:= TStringList.Create;
    pm.Items.Clear;
    for i:= 0 to connHistory.Count-1 do begin
        if Trim(connHistory[i]) <> '' then begin
            sid:= getSid(connHistory[i]);
            sidMenuListIdx:= sidMenuList.IndexOf(sid);
            if sidMenuListIdx < 0 then begin
                miGrp:= TMenuItem.Create(Owner);
                miGrp.Caption:= sid;
                miGrp.ImageIndex:= 3;
                pm.Items.Add(miGrp);
                sidMenuList.AddObject(sid, miGrp);
            end else begin
                miGrp:= sidMenuList.Objects[sidMenuListIdx] as TMenuItem;
            end;
            mi:= TMenuItem.Create(Owner);
            mi.Caption:= connHistory[i];
            mi.OnClick:= clickProc;
            miGrp.Add(mi);
        end;
    end;
    sidMenuList.Free;
end;

procedure PrepareLoginPopup(Owner: TComponent; var pm: TPopupMenu; connHistory: TStringList; clickProc: TNotifyEvent );
var
    i: Integer;
    mi: TMenuItem;
    miGrp: TMenuItem;
    sidMenuList: TStringList;
    sidMenuListIdx: Integer;
begin
    sidMenuList:= TStringList.Create;
    pm.Items.Clear;
    for i:= 0 to connHistory.Count-1 do begin
        if Trim(connHistory[i]) <> '' then begin
            mi:= TMenuItem.Create(Owner);
            mi.Caption:= connHistory[i];
            mi.OnClick:= clickProc;
            pm.Items.Add(mi);
        end;
    end;
    sidMenuList.Free;
end;

function ShowDialog(var lastConnection: String; var connHistory, loginHistory: TStringList; cl: TConnectionList): Boolean;
var
    f : TfrmConnect;
    connDB: String;
    i: Integer;
    conn: TConnectionObject;
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
    mr: TModalResult;
    loginStr: String;
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
    PrepareLoginPopup(f, f.pm_LoginHistory, loginHistory, f.miLoginTemplateClick );
    f.mmoHistory.Lines.Text:= connHistory.Text;
    f.mmo_LoginHistory.Lines.Text:= LoginHistory.Text;

    mr:= f.ShowModal;

    connHistory.Text:= f.mmoHistory.Lines.Text;
    LoginHistory.Text:= f.mmo_LoginHistory.Lines.Text;

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
                    loginStr:= Format('%s/%s', [Username, Password]);
                    if LoginHistory.IndexOf(loginStr) < 0 then
                        LoginHistory.Add(loginStr);
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
                if ConnectAs <> '' then begin
                    lastConnection:= Format('%s:%s/%s@%s as %s', [ConnectionName, Username, Password, ServiceName, ConnectAs])
                end else begin
                    lastConnection:= Format('%s:%s/%s@%s', [ConnectionName, Username, Password, ServiceName]);
                end;
                if (ConnectAs <> f.cbbConnectAs.Items[0]) and (ConnectAs <> '') then begin
                    loginStr:= Format('%s/%s as %s', [Username, Password, ConnectAs]);
                end else begin
                    loginStr:= Format('%s/%s', [Username, Password]);
                end;
                if connHistory.IndexOf(lastConnection) < 0 then
                    connHistory.Add(lastConnection);
                if LoginHistory.IndexOf(loginStr) < 0 then
                    LoginHistory.Add(loginStr);
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

procedure TfrmConnect.ApplyLoginHistoryEntry(historyEntry: String);
var
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
begin
    ParseLoginHistoryEntry(historyEntry, Username, Password, ConnectAs);
    edtUsername.Text:= Username;
    edtPassword.Text:= Password;
    cbbConnectAs.ItemIndex:= cbbConnectAs.Items.IndexOf(ConnectAs);
end;

procedure TfrmConnect.miLoginTemplateClick(Sender: TObject);
begin
    ApplyLoginHistoryEntry(TMenuItem(Sender).Caption);
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

procedure TfrmConnect.btn_ApplyHistoryClick(Sender: TObject);
var
    sl: TStringList;
begin
    sl:= TStringList.Create;
    sl.Text:= mmoHistory.Text;
    PreparePopup(Self, Self.pm_History, sl, self.miTemplateClick );
    sl.Free;
    mmoLogInvalid.Visible:= False;
    pgc1.ActivePage:= tsConnection;
end;

procedure TfrmConnect.btn_ApplyLoginHistoryClick(Sender: TObject);
var
    sl: TStringList;
begin
    sl:= TStringList.Create;
    sl.Text:= mmo_LoginHistory.Text;
    PrepareLoginPopup(Self, Self.pm_LoginHistory, sl, self.miLoginTemplateClick );
    sl.Free;
    pgc1.ActivePage:= tsConnection;
end;

procedure TfrmConnect.btn_LoginHistoryClick(Sender: TObject);
var
   r: TRect;
   p: TPoint;
begin
    r:= TButton(Sender).ClientRect;
    p:= TButton(Sender).ClientToScreen(Point(r.Left, r.Bottom));
    pm_LoginHistory.Popup(p.X, p.Y);
end;

procedure TfrmConnect.btn_ClearInvalidClick(Sender: TObject);
var
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
    cUsername, cPassword, cDatabase, cConnectAs: PANSIChar;
    sl: TStringList;
    i: Integer;
    ConnRes: String;
    conn: TConnectionObject;
    connDB: string;
begin
    sl:= TStringList.Create;
    sl.Text:= mmoHistory.Text;
    mmoHistory.Lines.Clear;
    mmoLogInvalid.Lines.Clear;
    mmoLogInvalid.Visible:= True;
    splLogInvalid.Visible:= True;
    splLogInvalid.Left:= 1;
    for i:= 0 to sl.Count-1 do begin
        Application.ProcessMessages;
        ParseHistoryEntry(sl[i], ConnectionName, Username, Password, ServiceName, ConnectAs);
        conn:= cl.FindByName(ConnectionName);
        connDB:= replace_sid(Trim(ServiceName), conn.Database);
        if connDB <> '' then
            ConnRes:= dtmdl_ora.test_connection_err(Username, Password, connDB, ConnectAs)
        else
            ConnRes:= '';
        if ConnRes = '' then
            mmoHistory.Lines.Add(sl[i])
        else
            mmoLogInvalid.Lines.Add(ConnRes);
    end;
    sl.Free;

end;

procedure TfrmConnect.tsHistoryEnter(Sender: TObject);
begin
    mmoLogInvalid.Visible:= False;
    splLogInvalid.Visible:= False;
end;

end.
