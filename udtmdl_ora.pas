unit udtmdl_ora;

interface

uses
  SysUtils, Classes, DB, DBAccess, Ora, MemDS, Dialogs, ImgList, Controls,
  DAScript, OraScript, OraClasses;

type
  Tdtmdl_ora = class(TDataModule)
    orsn_cloner: TOraSession;
    orqry_srv_name: TOraQuery;
    il_common: TImageList;
    orqryPdbs: TOraQuery;
    orscrptDropPdb: TOraScript;
  private
    { Private declarations }
  public
    { Public declarations }
    function connect(Username, Password, Database: string; ConnectAs: string = 'NORMAL'): Boolean;
    procedure disconnect;
    function test_connection(Username, Password, Database: string; ConnectAs: string = 'NORMAL'; ShowMsg: Boolean = True): Boolean;
    function get_pdb_list(
        Username, Password, Database: string
    ): TStringList;
  end;

var
  dtmdl_ora: Tdtmdl_ora;

implementation

{$R *.dfm}

{ Tdtmdl_ora }

function Tdtmdl_ora.connect(Username, Password, Database: string; ConnectAs: string = 'NORMAL'): Boolean;
begin
    orsn_cloner.Username:= Username;
    orsn_cloner.Password:= Password;
    orsn_cloner.Server:= Database;
    orsn_cloner.ConnectPrompt:= False;
    if ConnectAs = 'NORMAL' then
        orsn_cloner.ConnectMode:= cmNormal
    else if ConnectAs = 'SYSDBA' then
        orsn_cloner.ConnectMode:= cmSYSDBA
    else if ConnectAs = 'SYSOPER' then
        orsn_cloner.ConnectMode:= cmSYSOPER;
    orsn_cloner.Connect;
    Result:= orsn_cloner.Connected;
end;

procedure Tdtmdl_ora.disconnect;
begin
    if orsn_cloner.Connected then
        orsn_cloner.Disconnect;
end;

function Tdtmdl_ora.get_pdb_list(Username, Password,
  Database: string): TStringList;
begin
    Result:= TStringList.Create;
    if connect(Username, Password, Database) then
    begin
      orqry_srv_name.Open;
      while not orqry_srv_name.Eof do begin
          Result.Add(orqry_srv_name.FieldByName('service_name').AsString);
          orqry_srv_name.Next;
      end;
      orqry_srv_name.Close;
      disconnect;
    end;
end;

function Tdtmdl_ora.test_connection(Username, Password,
  Database: string; ConnectAs: string = 'NORMAL'; ShowMsg: Boolean = True): Boolean;
var
    dummy: Integer;
begin
    try
        Result:= connect(Username, Password, Database, ConnectAs);
        if Result then disconnect;
    except
        on E: Exception do begin
            if ShowMsg then
                dummy:= MessageDlg(E.Message,  mtError, [mbOK], 0);
            Result:= False;
        end;
    end;
end;

end.
