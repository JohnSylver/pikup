unit DelphiBandForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls,  Buttons, Menus, ToolWin, shdocvw_tlb,
  ImgList, IniFiles, MSHTML_TLB, MapFileUnit,Variants, loginfrm,DLLXPTheming,
  snapscreens,IEhelper,activex,Registry,MyPopupMenu,jpeg;

type
  TOperateMode =(SelectSnap,FullSnap,FNone);
  TBandForm = class(TForm,IDispatch)

    ToolBar1: TToolBar;
    tbSearchType: TToolButton;
    ToolButton5: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton1: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure tbHighLightClick(Sender: TObject);
    procedure Pikup1Click(Sender: TObject);
    procedure tbSearchTypeClick(Sender: TObject);
    procedure ToolButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ToolButton3Click(Sender: TObject);
  private
    { Private declarations }
    //创建一个BHO对象操作WebBroser
    iehelper:TIeHelper;
    //继承WebBrowser的编辑接口
    IEService: IHTMLEditServices;
    //记录当前的操作
    _Operation:TOperateMode;

    procedure GetCategory(s: string);
    procedure IniMenu;
    procedure AddOtherMenu;
    procedure CloseMenu;
    procedure AddToUrlHistory(s: string);

  public
    { Public declarations }
    //bExistHook: boolean;
    bFirstClick: boolean;

    IE: IWebbrowser2;
    FCPC: IConnectionPointContainer;
    FCP: IConnectionPoint;
    FCookie: Integer;
    procedure CloseBand;
    procedure NavigateFromBand(const URL: string);
    procedure WndProc(var Mess: TMessage); override;
   // procedure CreateParams(var Params : TCreateParams);Override;

    function GetTypeInfoCount(out Count: Integer): HResult; stdcall;
    function GetTypeInfo(Index, LocaleID: Integer; out TypeInfo): HResult; stdcall;
    function GetIDsOfNames(const IID: TGUID; Names: Pointer;
      NameCount, LocaleID: Integer; DispIDs: Pointer): HResult; stdcall;
    function Invoke(DispID: Integer; const IID: TGUID; LocaleID: Integer;
      Flags: Word; var Params; VarResult, ExcepInfo, ArgErr: Pointer): HResult; stdcall;
  end;


type
  TConfig = record
    WebSite: integer;
    EngineCount: integer;
    WriteLog: integer;
    AutoSearch: integer;
  end;

  TpMenuData = ^TMenuData;
  TMenuData = record
    Name: string;
    Category: string;
    HomePage: string;
    URL: string;
  end;

  TpListItem = ^TListItem;
  TListItem = record
    Category: string;
    menu: TMenuItem;
  end;

const
  KeyName = 'SOFTWARE\Kinpro\Pikup';

var
  ZW_CLICK_MSG: UINT;
  AppDir, AppName: string;
  isLogined:boolean;

  {ZwKeyMsg: UINT;
  HMapFile:THandle;
  CommonData:pCommonData;}

implementation

{$R *.DFM}
uses _DelphiBand, ComObj, ShellApi;

function  GetAppName: string;
var
  Myreg: TReginifile;
  SubKey: string;
begin
  SubKey := 'SOFTWARE\Classes\CLSID\'+ GuidToString(CLSID_DelphiBand) + '\InprocServer32';
  MyReg := TReginifile.Create;
  MyReg.rootkey := HKEY_LOCAL_MACHINE;
  Result := MyReg.ReadString(SubKey ,'','');
  MyReg.Free;
end;

function TBandForm.GetIDsOfNames(const IID: TGUID; Names: Pointer;
  NameCount, LocaleID: Integer; DispIDs: Pointer): HResult;
begin
  Result := E_NOTIMPL;
end;
 
function TBandForm.GetTypeInfo(Index, LocaleID: Integer;
  out TypeInfo): HResult;
begin
  Result := E_NOTIMPL;
  pointer(TypeInfo) := nil;
end;
 
function TBandForm.GetTypeInfoCount(out Count: Integer): HResult;
begin
  Result := E_NOTIMPL;
  Count := 0;
end;

procedure TBandForm.WndProc(var Mess: TMessage);
var s: string;
begin
 
  if mess.Msg = wm_close then Windows.Beep(2000,10);
  inherited;
end;

{procedure TBandForm.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(params);
  Params.WinClassName := 'ZW_IE_BAR';//任意给个名字
end; }


procedure TBandForm.GetCategory(s: string);
var
  i, j, len, index: integer;
  ts: string;
  pListItem: TpListItem;
  bExist: boolean;
begin
 { ts := '';
  len := length(s);
  index := 0;
  for i := 1 to len do
  begin
    if s[i]<>';' then ts:=ts+s[i];// else inc(index);
    if (s[i]=';')or(i=len) then
    if trim(ts)<>'' then
    begin
      bExist := false;
      for j:= 0 to CategoryList.Count-1 do
      begin
        pListItem := TpListItem(CategoryList.Items[j]);
        if ts = pListItem.Category then
        begin
          bExist := true;
          break;
        end;
      end;
      if not bExist then
      begin
        new(pListItem);
        pListItem.Category := ts;
        pListItem.menu := TMenuItem.Create(self);
        //pListItem.menu.AutoHotkeys := maManual;
        pListItem.menu.Caption := ts;
        //pListItem.menu.ShortCut := ;
        //pListItem.menu.OnClick := MyMenuHandler;

        CategoryList.Add(pListItem);
      end;
      inc(index);
      ts:='';
    end;
  end;}
end;

procedure TBandForm.IniMenu;
var PopMenu:TMyPopupMenu;
    Nmemu:TMenuItem;
begin
  PopMenu :=TMyPopupMenu.Create(self);
  Nmemu := TMenuItem.Create(self);
  Nmemu.Caption := '登录Pikup';
  Nmemu.OnClick := Pikup1Click;
  PopMenu.Items.Add(Nmemu);

  Nmemu := TMenuItem.Create(self);
  Nmemu.Caption := '注册Pikup';
  PopMenu.Items.Add(Nmemu);

  Nmemu := TMenuItem.Create(self);
  Nmemu.Caption := '-';
  PopMenu.Items.Add(Nmemu);

  Nmemu := TMenuItem.Create(self);
  Nmemu.Caption := '管理';
  PopMenu.Items.Add(Nmemu);
  tbSearchType.DropdownMenu := PopMenu;
end;

procedure TBandForm.AddOtherMenu;
var
  miSep, miAbout: TMenuItem;
begin

end;


procedure TBandForm.CloseMenu;
var
  i: integer;
  pListItem: TpListItem;

begin

end;

procedure TBandForm.AddToUrlHistory(s: string);
var
  i: integer;
  bAdd: boolean;
begin
  bAdd := true;
end;

procedure TBandForm.CloseBand;
var
  x, y, z: Olevariant;
begin
  x := GuidToString(CLSID_DelphiBand);
  Y := FALSE;
  Z := 0;
  IE.ShowBrowserBar(X, Y, Z);

end;

procedure TBandForm.NavigateFromBand(const URL: string);
var
  _url: OleVariant;
  X: OleVariant;
begin
  _Url := Url;
  X := 0;
  IE.Navigate(Url, X, X, X, X);
end;

procedure TBandForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if Assigned(iehelper) then

iehelper.Free;
end;

procedure TBandForm.FormCreate(Sender: TObject);
var RegObejct:TRegistry;
begin
  bFirstClick := true;
  Height := 21;
  ZW_CLICK_MSG := RegisterWindowMessage('WM_ZWCLICK');
   AppName := GetAppName;
  AppDir := ExtractFilePath(AppName);
  IniMenu;
  iehelper:=TIeHelper.Create;
  _Operation:=FNone;
end;

procedure TBandForm.tbHighLightClick(Sender: TObject);
var
  sString,bgColor:string;
  doc:IHTMLdocument2;
  R:IHTMLTxtRange;
begin
  //=Edit1.text; 要查找的字符串,空格都能找
  //还可以跨边界 比如<u>docum<b>entdo</b>cument</u>
 { sString :=cbAddr.Text;
  try
    doc :=IHTMLdocument2(IE.Document) ;
    R :=IHTMLTxtRange(doc.selection.createRange);

    if tbHighLight.Down then bgColor :='magenta';  //color 也可以是 '#FF00FF'这种形式

    while R.findText(sString,1,0) do
    begin
      R.select;
      R.execCommand('Backcolor',false,bgColor);
      R.setEndPoint('StartToEnd',R);
    end;
    R.execCommand('UnSelect',true,EmptyParam);
  except beep;
    
  end;    }
end;


procedure TBandForm.tbSearchTypeClick(Sender: TObject);
begin
  if(Assigned(IE)) then begin
    
  end;
end;

procedure TBandForm.Pikup1Click(Sender: TObject);
var LoginFrm:TLoginForm;
begin
  LoginFrm:=TLoginForm.Create(self);
  LoginFrm.ShowModal;
  LoginFrm.Free;
end;

procedure TBandForm.ToolButton2Click(Sender: TObject);
var SnapScreen:TSnapScreenFrm;
begin
  ToolButton2.Down :=true;
  if Assigned(IE) then begin
    if _Operation <>FNone then begin     
      exit;
    end;
    ((IE.Document as IHTMLDocument2)  as IServiceProvider).QueryService(SID_IHTMLEDITSERVICE,IID_IHTMLEditServices,IEService);
    if(Assigned(IEService)) then begin
        if(Assigned(iehelper)) then begin
          iehelper:=TIeHelper.create;
        end;
          _Operation:=SelectSnap;
          IEService.AddDesigner(iehelper);
    end;
  end;
end;

procedure TBandForm.ToolButton3Click(Sender: TObject);
var
  Doc: IHTMLDocument2;
  ViewObject: IViewObject;
  sourceDrawRect: TRect;
  a, getjpg: TBitMap;
  i, m: integer;
  pdest, psour: hbitmap;
  jpg: tjpegimage;
begin
  Doc := ie.Document as IHTMLDocument2;
  if ie.Document <> nil then
  try
    ie.Document.QueryInterface(IViewObject, ViewObject);
    if ViewObject <> nil then
    try
      doc.body.style.overflow := 'hidden';
      Doc.Get_ParentWindow.Scroll(0, 0); //跳到网页头
      getjpg := TBitMap.Create();
      getjpg.PixelFormat := pf24bit;

      getjpg.Height := doc.Body.getAttribute('ScrollHeight', 0);
      getjpg.Width := doc.Body.getAttribute('Scrollwidth', 0);
      pdest := getjpg.Canvas.Handle;
     MoveWindow(ie.HWND,0,0,2000,2000,true);

     // m := Trunc(doc.Body.getAttribute('ScrollHeight', 0) / (doc.Body.getAttribute('offsetHeight', 0) - 20));
      //i := Trunc(doc.Body.getAttribute('Scrollwidth', 0) / (doc.Body.getAttribute('offsetwidth', 0) - 20));
     // for i := 0 to i do
      begin
       // for m := 0 to m + 1 do
        begin
          a := TBitMap.Create();
          a.Height := doc.Body.getAttribute('offsetHeight', 0);
          a.Width := doc.Body.getAttribute('offsetWidth', 0);
          psour := a.Canvas.handle;
          sourceDrawRect := Rect(0, 0, a.Width, a.Height);

          ViewObject.Draw(DVASPECT_CONTENT, 0, nil, nil, 0, a.Canvas.Handle, @sourceDrawRect, nil, nil, 0);
          bitblt(pdest, doc.Body.getAttribute('scrollLeft', 0), doc.Body.getAttribute('Scrolltop', 0), a.Width, a.Height, psour, 2, 2, srccopy);
        //  Doc.Get_ParentWindow.Scroll(doc.Body.getAttribute('scrollLeft', 0), doc.Body.getAttribute('offsetHeight', 0) + doc.Body.getAttribute('Scrolltop', 0) - GetSystemMetrics(SM_CXVSCROLL) - 24);
          a.Free;
        end;
       // Doc.Get_ParentWindow.Scroll(doc.Body.getAttribute('offsetwidth', 0) + doc.Body.getAttribute('scrollLeft', 0) - GetSystemMetrics(SM_CXVSCROLL) - 24, 0);
      end;
      jpg := tjpegimage.Create;
      jpg.Assign(getjpg);
      getjpg.Free;
      jpg.SaveToFile('c:\test.jpg');
      jpg.Free;
    finally
      ViewObject._Release;
    end;
  except
  end;
end;

function TBandForm.Invoke(DispID: Integer; const IID: TGUID;
  LocaleID: Integer; Flags: Word; var Params; VarResult, ExcepInfo,
  ArgErr: Pointer): HResult;
  var
 	pdpParams: PDispParams;
  bHasParams: boolean;
  pDispIds: PDispIdList;
  iDispIdsSize: integer;
begin
  pdpParams:=@params;
  ShowMessage(inttostr(DispID));
  case DispID of
  //--------------------退出浏览器----------------------
   253:begin
    ShowMessage('Quite');
   end;
  //-------------------载入页面成功---------------------
   259:begin
      ShowMessage('Load Page ok');
      if _Operation<>FNone then begin
        _Operation:=FNone;
        IEService:=nil;
      end;
   end;
  end;
  Result:=S_OK;
end;


end.

