unit LoginFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,Registry,activex,commucator, jpeg,ShellAPI
  ,md5 ,IdHashMessageDigest;

type
  TLoginForm = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Password: TEdit;
    Button1: TButton;
    UserName: TComboBoxEx;
    LinkLabel1: TLabel;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button1Click(Sender: TObject);
    procedure LinkLabel1Click(Sender: TObject);
  private
    _ComID : string;//当前组件安装的GUID
    _userName : string;//登录用户名
    _password : string;//登录用户密码
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

uses delphibandform;

{$R *.dfm}

procedure TLoginForm.Button1Click(Sender: TObject);
 var
    i:integer;
    MD5:TMessageDigest;
begin

  if(UserName.Text='') or (Password.Text='') then begin
    MessageBox(self.Handle,'请输入用户登录信息','Pikup登录',0+48);
    abort;
  end;
  _password:='';
  MD5 := TMessageDigest5.Create;
  _password:=TMessageDigest.AsHex( MD5.HashValue(password.Text));

  ShowMessage(_password);
//  CheckUserLogin(UserName.Text,,_ComID);
end;

procedure TLoginForm.FormCreate(Sender: TObject);
var
  RegObject:TRegistry;
  TmpGUID: TGUID;
begin
  RegObject := TRegistry.Create;
  RegObject.RootKey := HKEY_LOCAL_MACHINE;
  if RegObject.KeyExists(KeyName)  then begin
    RegObject.OpenKey(KeyName,false);
    _ComID := RegObject.ReadString('ComID');
    _userName := RegObject.ReadString('UserName');
    _password := RegObject.ReadString('Password');
    if(_userName <>'') then begin
      UserName.Items.Add(_userName);
    end;
  end;
  if _ComID ='' then begin
    CoCreateGuid(TmpGUID);
    _ComID := GUIDToString(TmpGUID);
    RegObject.OpenKey(KeyName,true);
    RegObject.WriteString('ComID',_ComID);
  end;
  LinkLabel1.Caption := '注册用户';
  RegObject.Free;
end;

procedure TLoginForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if   Key   =   27   then begin
    Close;
  end;
end;

procedure TLoginForm.LinkLabel1Click(Sender: TObject);
begin
 ShellExecute(0, nil, PChar('http://localhost:8080/PikupProject/RegistUser.jsp'), nil, nil, 1);
 close();
end;

end.
