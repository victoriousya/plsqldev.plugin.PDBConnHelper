unit uConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PlugInIntf, StdCtrls;

type
  TfConfig = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    mmoDatabase: TMemo;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    lbl_connected: TLabel;
    lbl_not_connected: TLabel;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function DoConfig(var Username, Password, Database: string ): TModalResult;


var
  fConfig: TfConfig;

implementation

uses
  udtmdl_ora;

{$R *.dfm}

function DoConfig(var Username, Password, Database: string): TModalResult;
var
  f: TfConfig;
begin
    Application.Handle:= IDE_GetAppHandle;
    f:= TfConfig.Create(Application);
    f.edtUsername.Text:= Username;
    f.edtPassword.Text:= Password;
    f.mmoDatabase.Lines.Text:= Database;
    f.lbl_connected.Visible:= False;
    f.lbl_not_connected.Visible:= False;
    Result:= f.ShowModal;
    if (Result = mrOk) and f.lbl_connected.Visible then
    begin
        Username:= f.edtUsername.Text;
        Password:= f.edtPassword.Text;
        Database:= f.mmoDatabase.Lines.Text;
    end else Result:= mrCancel;
    f.Free;
end;

procedure TfConfig.btn1Click(Sender: TObject);
begin
    if dtmdl_ora.test_connection(edtUsername.Text, edtPassword.Text, mmoDatabase.Lines.Text) then begin
        lbl_connected.Visible:= True;
        lbl_not_connected.Visible:= False;
    end else begin
        lbl_connected.Visible:= False;
        lbl_not_connected.Visible:= True;
    end;
end;

end.
