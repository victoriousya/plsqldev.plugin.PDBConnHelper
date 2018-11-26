unit uMainWindow;

interface

uses Classes, Dialogs, Contnrs, StrUtils, SysUtils, Windows, Forms;

type
    TConnectionObject = class(TObject)
    public
        ConnectionName, Username, Password, Database, ConnectAs: string;
        function getAsString: string;
    end;
    TConnectionList = class(TObjectList)
    public
         procedure ParseConnection(ConnectionDefinition: string; var ConnectionName, Username, Password,
            Database, ConnectAs: string);
         procedure AddConnection(ConnectionName, Username, Password,
            Database, ConnectAs: string); overload;
         procedure AddConnection(ConnectionDefinition: string); overload;
         function FindByName(ConnectionName: String): TConnectionObject;
         function IndexByName(ConnectionName: String): Integer;
         function FindByIndex(i: Integer): TConnectionObject;
         procedure AddDefault;
    end;

    TMainWindowMethods = class(TComponent)
    public
        procedure miTemplateClick(Sender: TObject);
    end;

procedure ParseHistoryEntry(HistoryEntry: string; var ConnectionName, Username, Password, ServiceName, ConnectAs: String);
procedure ParseLoginHistoryEntry(HistoryEntry: string; var Username, Password: String);
function replace_sid(serviceName, Database: String): String;
function get_sid(Database: String): String;


implementation

uses
  ufrmConnect, Menus, uPlugin, PlugInIntf;

procedure ParseHistoryEntry(HistoryEntry: string; var ConnectionName, Username, Password, ServiceName, ConnectAs: String);
var
    dotdotPos, slashPos, atPos, asPos: Integer;
    selText: string;
begin
//  ConnectionName:Username/Password@Database[ as ConnectAs]
    if Length(HistoryEntry) > 0 then begin
        selText:= StringReplace(HistoryEntry, '&', '', [rfReplaceAll] );
        dotdotPos:= PosEx(':', selText, 1);
        slashPos:= PosEx('/', selText, dotdotPos);
        atPos:= PosEx('@', selText, slashPos);
        asPos:= PosEx(' as ', selText, atPos);
        ConnectionName:=Copy(selText, 1, dotdotPos - 1);
        Username:= Copy(selText, dotdotPos + 1, slashPos - dotdotPos - 1);
        Password:= Copy(selText, slashPos + 1, atPos - slashPos - 1);
        if asPos > 0 then begin
          ServiceName:= Copy(selText, atPos + 1, asPos - atPos - 1);
          ConnectAs:= Copy(selText, asPos + 4, 255);
        end else begin
           ServiceName:= Copy(selText, atPos + 1, 255);
           ConnectAs:= '';
        end;
    end else begin
        ConnectionName:= '';
        Username:= '';
        Password:= '';
        ServiceName:= '';
        ConnectAs:= '';
    end;

end;

procedure ParseLoginHistoryEntry(HistoryEntry: string; var Username, Password: String);
var
    slashPos: Integer;
    selText: string;
begin
//  ConnectionName:Username/Password@Database[ as ConnectAs]
    if Length(HistoryEntry) > 0 then begin
        selText:= StringReplace(HistoryEntry, '&', '', [rfReplaceAll] );
        slashPos:= PosEx('/', selText, 1);
        Username:= Copy(selText, 1, slashPos - 1);
        Password:= Copy(selText, slashPos + 1, 100);
    end else begin
        Username:= '';
        Password:= '';
    end;

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

function get_sid(Database: String): String;
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
  Result:= Copy(Database, sidPos + Length('SID='), closePos - sidPos - Length('SID='));
end;

{ TMainWindowMetods }

procedure TMainWindowMethods.miTemplateClick(Sender: TObject);
var
    ConnectionName, Username, Password, ServiceName, ConnectAs: String;
    Database: string;
    conn: TConnectionObject;
    ConnResult: Boolean;
begin
    ParseHistoryEntry(TMenuItem(Sender).Caption, ConnectionName, Username, Password, ServiceName, ConnectAs);
    conn:= cl.FindByName(ConnectionName);
    Database:= replace_sid(ServiceName, conn.Database);
    if Database <> '' then
        ConnResult:= IDE_SetConnectionAs(PChar(Username), PChar(Password), PChar(Database), PChar(ConnectAs));
        if not ConnResult then
            MessageBox(Application.Handle, 'Connection failed', 'Îøèáêà', MB_OK +
              MB_ICONSTOP);
end;

{ TConnectionList }

procedure TConnectionList.AddConnection(ConnectionName, Username, Password,
  Database, ConnectAs: string);
var
    co: TConnectionObject;
begin
    co:= TConnectionObject.Create;
    co.ConnectionName:= ConnectionName;
    co.Username      := Username;
    co.Password      := Password;
    co.Database      := Database;
    co.ConnectAs     := ConnectAs;
    Self.Add(co);
end;

procedure TConnectionList.AddConnection(ConnectionDefinition: string);
var
    ConnectionName, Username, Password, Database, ConnectAs: string;
begin
//  ConnectionName:Username/Password@Database[ as ConnectAs]
    ParseConnection(ConnectionDefinition, ConnectionName, Username, Password, Database, ConnectAs);
    Self.AddConnection(ConnectionName, Username, Password, Database, ConnectAs);

end;

procedure TConnectionList.AddDefault;
begin
     Self.AddConnection(
         'SVBO'
       , 'C##SBCLONER'
       , 'SBCLONER1'
       , '(DESCRIPTION=(ADDRESS_LIST=(ADDRESS=(PROTOCOL=TCP)(HOST=t7-12ac.bt.bpc.in)(PORT=1521)))(CONNECT_DATA=(SID=svbo)))'
       , ''
     );
end;

function TConnectionList.FindByIndex(i: Integer): TConnectionObject;
begin
    Result:= Self.Items[i] as TConnectionObject;
end;

function TConnectionList.IndexByName(ConnectionName: String): Integer;
var
    i: Integer;
begin
    Result:= -1;
    for i:= 0 to Self.Count - 1 do begin
       if (Self.Items[i] as TConnectionObject).ConnectionName = ConnectionName then begin
           Result:= i;
           Break;
       end;

    end;
end;

function TConnectionList.FindByName(
  ConnectionName: String): TConnectionObject;
var
    i: Integer;
begin
    Result:= nil;
    i:= IndexByName(ConnectionName);
    if i >= 0 then Result:= (Self.Items[i] as TConnectionObject);
end;

procedure TConnectionList.ParseConnection(ConnectionDefinition: string;
  var ConnectionName, Username, Password, Database, ConnectAs: string);
var
    dotdotPos, slashPos, atPos, asPos: Integer;
begin
//  ConnectionName:Username/Password@Database[ as ConnectAs]
    dotdotPos:= PosEx(':', ConnectionDefinition, 1);
    slashPos:= PosEx('/', ConnectionDefinition, dotdotPos);
    atPos:= PosEx('@', ConnectionDefinition, slashPos);
    asPos:= PosEx(' as ', ConnectionDefinition, atPos);
    ConnectionName:=Copy(ConnectionDefinition, 1, dotdotPos - 1);
    Username:= Copy(ConnectionDefinition, dotdotPos + 1, slashPos - dotdotPos - 1);
    Password:= Copy(ConnectionDefinition, slashPos + 1, atPos - slashPos - 1);
    if asPos > 0 then begin
      Database:= Copy(ConnectionDefinition, atPos + 1, asPos - atPos - 1);
      ConnectAs:= Copy(ConnectionDefinition, asPos + 4, 255);
    end else begin
       Database:= Copy(ConnectionDefinition, atPos + 1, 255);
       ConnectAs:= '';
    end;
end;

{ TConnectionObject }

function TConnectionObject.getAsString: string;
begin
    if Self.ConnectAs <> '' then
        Result:= Format('%s:%s/%s@%s as %s', [Self.ConnectionName, Self.Username, Self.Password, Self.Database, Self.ConnectAs])
    else
        Result:= Format('%s:%s/%s@%s', [Self.ConnectionName, Self.Username, Self.Password, Self.Database]);
end;

end.
