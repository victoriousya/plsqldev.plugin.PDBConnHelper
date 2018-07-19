unit uMainWindow;

interface

uses Classes, Dialogs;

type
    TMainWindowMethods = class(TComponent)
    public
        procedure miTemplateClick(Sender: TObject);
    end;

implementation

uses
  ufrmConnect, Menus, uPlugin, PlugInIntf;

{ TMainWindowMetods }

procedure TMainWindowMethods.miTemplateClick(Sender: TObject);
var
    connDB, connUsername, connPassword, connServiceName: String;
begin
    ufrmConnect.ParseMenuConnection(TMenuItem(Sender).Caption, connUsername, connPassword, connServiceName);
    connDB:= ufrmConnect.replace_sid(connServiceName, uPlugin.Database);
    if connDB <> '' then
        IDE_SetConnection(PChar(connUsername), PChar(connPassword), PChar(connDB));
end;

end.
