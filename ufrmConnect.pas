unit ufrmConnect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus;

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
    procedure miTemplateClick(Sender: TObject);
    procedure btnRecentlyUsedClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowDialog(Username, Password, Database: string; var connUsername, connPassword, connServiceName: String; var connHistory: TStringList): Boolean;
procedure PreparePopup(Owner: TComponent; var pm: TPopupMenu; connHistory: TStringList; clickProc: TNotifyEvent );
procedure ParseMenuConnection(MenuCaption: string; var connUsername, connPassword, connServiceName: String);
function replace_sid(serviceName, Database: String): String;
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

procedure ParseMenuConnection(MenuCaption: string; var connUsername, connPassword, connServiceName: String);
var
    selText: String;
    firstPos, secondPos: Integer;
begin
    selText:= StringReplace(MenuCaption, '&', '', [rfReplaceAll] );
    firstPos:= PosEx('/', selText, 1);
    secondPos:= PosEx('@', selText, firstPos+1);
    connUsername:= Copy(selText, 1, firstPos-1);
    connPassword:= Copy(selText, firstPos + 1, secondPos - firstPos-1);
    connServiceName:= Copy(selText, secondPos+1, 255);
end;

function replace_sid(serviceName, Database: String): String;
var
  sidPos, closePos: Integer;
begin
  Result:= '';
  sidPos:= PosEx('SID=', Database, 1);
  if sidPos <= 0 then begin
      ShowMessage('"SID=" not found in Database connection string');
      Exit;
  end;
  closePos:= PosEx(')', Database, sidPos);
  if closePos <= 0 then
      ShowMessage('")" not found in Database connection string after "SID="');
  Result:= Copy(Database, 1, sidPos-1)+'SERVICE_NAME='+serviceName+Copy(Database, closePos, Length(Database));
end;

function ShowDialog(Username, Password, Database: string; var connUsername, connPassword, connServiceName: String; var connHistory: TStringList): Boolean;
var
    f : TfrmConnect;
    connDB: String;
    historyEntry: String;
    i: Integer;
    mi: TMenuItem;
begin
    f:= TfrmConnect.Create(Application);
    f.edtUsername.Text:= connUsername;
    f.edtPassword.Text:= connPassword;
    f.cbb_Connection.Items.Text:= dtmdl_ora.get_pdb_list(Username, Password, Database).Text;
    f.cbb_Connection.ItemIndex:= f.cbb_Connection.Items.IndexOf(connServiceName);

    PreparePopup(f, f.pm_History, connHistory, f.miTemplateClick );
    if f.ShowModal = mrOk then begin

        connDB:= replace_sid(f.cbb_Connection.Text, Database);
        if connDB <> '' then
            Result:= IDE_SetConnection(PChar(f.edtUsername.Text), PChar(f.edtPassword.Text), PChar(connDB));
            if Result then begin
              connUsername:= f.edtUsername.Text;
              connPassword:= f.edtPassword.Text;
              connServiceName:= f.cbb_Connection.Text;
              historyEntry:= connUsername+'/'+connPassword+'@'+connServiceName;
              if connHistory.IndexOf(historyEntry) < 0 then
                  connHistory.Add(historyEntry);
            end;
    end;
    f.Free;
end;

procedure TfrmConnect.miTemplateClick(Sender: TObject);
var
    connUsername, connPassword, connServiceName: String;
begin
    ParseMenuConnection(TMenuItem(Sender).Caption, connUsername, connPassword, connServiceName);
    edtUsername.Text:= connUsername;
    edtPassword.Text:= connPassword;
    cbb_Connection.ItemIndex:= cbb_Connection.Items.IndexOf(connServiceName);
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

end.
