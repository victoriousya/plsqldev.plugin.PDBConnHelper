unit uPlugin;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ShellAPI, PlugInIntf, uMainWindow;

const // Description of this Plug-In (as displayed in Plug-In configuration dialog)
  Plugin_Desc = 'PDB(Ora12c) Connection Helper';
  TB_BTN_NEW_CONN = 1;
  TB_BTN_RECONNECT = 2;
  TB_BTN_RECYCLE = 3;

procedure SetRoamingFolderPath;

var
  gRoamingFolderPath: string;
  cl: TConnectionList;


implementation

uses IniFiles, uConfig, udtmdl_ora, ufrmConnect, StrUtils, Menus, 
  ufrmPdbManager;

var
//    Username, Password, ConnectAs, connUsername, connPassword, connServiceName: String;
    connHistory, LoginHistory: TStringList;
    ini_file_name: string;
    tb_bmp, tb_dd_bmp, tb_recyle_bmp: TBitmap;
    mwm: TMainWindowMethods;
    pm_dd: TPopupMenu;
    lastConnection: String;


procedure OutDebug(Str: string);
begin
{$IFDEF DEBUG}
  SendDebug(Str);
//  OutputDebugString(Str);
{$ENDIF}
end;

procedure OutDebugFmt(const Msg: string; const Args: array of const);
begin
{$IFDEF DEBUG}
  SendDebugFmt(Msg, Args);
//  OutputDebugString(Str);
{$ENDIF}
end;

function add_trailing_slash( i_dir  : string): string;
begin
    if copy(i_dir, Length(i_dir), 1) = PathDelim then begin
      result:= i_dir;
    end else begin
      result:= i_dir + PathDelim;
    end;
end;

procedure SetRoamingFolderPath;
var
  buf  : PAnsiChar;
begin
  GetMem(buf,MAX_PATH);
  ZeroMemory(buf,MAX_PATH);
  Windows.GetEnvironmentVariable('APPDATA', buf,MAX_PATH);
  gRoamingFolderPath:= buf;
  FreeMem(Buf);

  gRoamingFolderPath:= add_trailing_slash(gRoamingFolderPath)+'PLSQL Developer'+ PathDelim;
  if not DirectoryExists(gRoamingFolderPath) then
      CreateDir(gRoamingFolderPath);
  gRoamingFolderPath:= gRoamingFolderPath + 'Plugins'+ PathDelim;
  if not DirectoryExists(gRoamingFolderPath) then
      CreateDir(gRoamingFolderPath);
  gRoamingFolderPath:= gRoamingFolderPath + 'pdb_conn'+ PathDelim;
  if not DirectoryExists(gRoamingFolderPath) then
      CreateDir(gRoamingFolderPath);
  gRoamingFolderPath:= gRoamingFolderPath;
end;


procedure write_ini_settings;
var
    ini          : TIniFile;
    RoamingFolder: string;
    i            : Integer;
begin
    RoamingFolder:= uPlugin.gRoamingFolderPath;
    ini_file_name:= RoamingFolder+'pdb_conn.ini';
    ini:= TIniFile.Create(ini_file_name);

    ini.WriteString('LastConnection', 'Value', lastConnection);
    ini.EraseSection('ConnectionsList');
    for i:= 0 to cl.Count - 1 do begin
        ini.WriteString('ConnectionsList', 'Item'+IntToStr(i), (cl[i] as TConnectionObject).getAsString);
    end;
    ini.EraseSection('ConnectionHistory');
    for i:= 0 to connHistory.Count - 1 do begin
        ini.WriteString('ConnectionHistory', 'Item'+IntToStr(i), connHistory[i]);
    end;
    ini.EraseSection('LoginHistory');
    for i:= 0 to LoginHistory.Count - 1 do begin
        ini.WriteString('LoginHistory', 'Item'+IntToStr(i), LoginHistory[i]);
    end;

    ini.UpdateFile;
    ini.Free;
end;

procedure read_ini_settings;
var
    ini          : TIniFile;
    RoamingFolder: string;
    i : Integer;
    lConnections: TStringList;
    lHistory: TStringList;
    replStr: string;
begin
    RoamingFolder:= gRoamingFolderPath;
    ini_file_name:= RoamingFolder+'pdb_conn.ini';
    ini:= TIniFile.Create(ini_file_name);

    lastConnection:= ini.ReadString('LastConnection', 'value', '');

    lConnections:= TStringList.Create;
    ini.ReadSectionValues('ConnectionsList', lConnections);
    cl.Clear;
    for i:= 0 to lConnections.Count - 1 do begin
        replStr:= Copy( lConnections[i], Pos('=', lConnections[i])+1, 255);
        if Trim(replStr) <> '' then
            cl.AddConnection(replStr);
    end;
    lConnections.Clear;
    if cl.Count = 0 then cl.AddDefault;

    lHistory:= TStringList.Create;
    ini.ReadSectionValues('ConnectionHistory', lHistory);
    connHistory.Clear;
    for i:= 0 to lHistory.Count - 1 do begin
        replStr:= Copy( lHistory[i], Pos('=', lHistory[i])+1, 255);
        if Trim(replStr) <> '' then
            connHistory.Add(replStr);
    end;
    lHistory.Free;

    lHistory:= TStringList.Create;
    ini.ReadSectionValues('LoginHistory', lHistory);
    LoginHistory.Clear;
    for i:= 0 to lHistory.Count - 1 do begin
        replStr:= Copy( lHistory[i], Pos('=', lHistory[i])+1, 255);
        if Trim(replStr) <> '' then
            LoginHistory.Add(replStr);
    end;
    lHistory.Free;

    ini.UpdateFile;
    ini.Free;
    write_ini_settings;
end;


// Plug-In identification, a unique identifier is received and
// the description is returned
function IdentifyPlugIn(ID: Integer): PChar;  cdecl;
begin
    PlugInID := ID;
    Result := Plugin_Desc;
end;

procedure OnCreate; cdecl;
begin
    SetRoamingFolderPath;
    dtmdl_ora:= Tdtmdl_ora.Create(Application);
    tb_bmp:= TBitmap.Create;
    tb_dd_bmp:= TBitmap.Create;
    tb_recyle_bmp:= TBitmap.Create;
    connHistory:= TStringList.Create;
    LoginHistory:= TStringList.Create;
    pm_dd:= TPopupMenu.Create(Application);
    mwm:= TMainWindowMethods.Create(Application);
    cl:= TConnectionList.Create;
end;

procedure OnActivate; cdecl;
begin
    Application.Handle := IDE_GetAppHandle;
    OutDebug('Activated');
    lastConnection:= 'SVBO:SVBO_REF/SVBO_REF1@SVBO';

    read_ini_settings;

    dtmdl_ora.il_common.GetBitmap(0, tb_bmp);
    dtmdl_ora.il_common.GetBitmap(1, tb_dd_bmp);
    dtmdl_ora.il_common.GetBitmap(2, tb_recyle_bmp);
    IDE_CreateToolButton(PlugInID, TB_BTN_NEW_CONN, 'PDB New Connection', '', tb_bmp.Handle);
    IDE_CreateToolButton(PlugInID, TB_BTN_RECONNECT, 'PDB Reconnect', '', tb_dd_bmp.Handle);
    IDE_CreateToolButton(PlugInID, TB_BTN_RECYCLE, 'PDB Recycle', '', tb_recyle_bmp.Handle);
end;

procedure OnDeactivate; cdecl;
begin
    write_ini_settings;
end;

// Called when the Plug-In is destroyed
procedure OnDestroy; cdecl;
begin
    FreeAndNil(tb_bmp);
    FreeAndNil(tb_dd_bmp);
    FreeAndNil(tb_recyle_bmp);
    FreeAndNil(connHistory);
    FreeAndNil(LoginHistory);
    FreeAndNil(pm_dd);
    FreeAndNil(mwm);
    FreeAndNil(cl);
    FreeAndNil(dtmdl_ora);
end;

procedure Configure; cdecl;
begin
    if uConfig.DoConfig(cl) = mrOk then
    begin
        write_ini_settings;
    end;
end;

procedure OnMenuClick(Index: Integer); cdecl;
var
   p: TPoint;
begin
    case Index of
    TB_BTN_NEW_CONN: begin
            if ufrmConnect.ShowDialog(lastConnection, connHistory, LoginHistory, cl) then
                write_ini_settings;
        end;
    TB_BTN_RECONNECT: begin
          pm_dd.Items.Clear;
          ufrmConnect.PreparePopup(Application, pm_dd, connHistory, mwm.miTemplateClick);
          p:= Point(10, 10);
          p:= Mouse.CursorPos;
          pm_dd.Popup(p.X, p.Y);
        end;
    TB_BTN_RECYCLE: begin
            ufrmPdbManager.ShowDialog(cl);
        end;
    end;
end;

function About: PChar;
begin
    Result:= Plugin_Desc+
             #13'©2018 VictoriousSoft Team'
           + #13#13'Help generate connection string to various service_name within Container DB'
           + #13'eMail to author: victorious.soft@gmail.ru'
           + #13'or visit my GitHub page: github.com/victoriousya'
             ;
end;

exports
  IdentifyPlugIn,
  RegisterCallback,
  OnCreate,
  OnActivate,
  OnDeactivate,
  OnDestroy,
  OnMenuClick,
  Configure,
  About;

end.
