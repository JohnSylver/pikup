
//***********************************************************
//               Band Objects  (Oct 15, 2001)               *
//                                                          *
//                         ver. 1.2                         *
//                                                          *
//                       For Delphi 5 & 6                   *
//                                                          *
//                            by                            *
//                     Per Linds?Larsen                    *
//                   per.lindsoe@larsen.mail.dk             *
//                                                          *
//                                                          *
//                                                          *
//        Updated versions:                                 *
//                                                          *
//               http://www.euromind.com/iedelphi           *
//***********************************************************



unit _DelphiBand;

interface

uses
  Windows, Classes, ActiveX, ShlObj, ComServ, ComObj,
  controls, SysUtils, messages, Forms, Shdocvw_tlb, delphibandform;


const

  DeskBand = '{00021492-0000-0000-C000-000000000046}';
  VerticalBand = '{00021493-0000-0000-C000-000000000046}';
  HorizontalBand = '{00021494-0000-0000-C000-000000000046}';

(* Getting started:

1. Create the BandForm. Place your components on Coolbar if you
   plan to create a Toolband or a resizable band (see demo). Set form.height
   to the prefered band-height. In vertical bands set the form.width
   to the prefered band-width.

2. Choose Title and Bandtype. Use Horizontalband or Deskband if you
   plan to create a toolband.
   Set ToolBand=TRUE if you want to create a ToolBand.
   Create a unique identifier.

3. Set values in GetBandInfo for minimum size, maximum size etc. You
   can use Bandform.Width and Bandform.Height as variables. Remember that
   y represents the width of your form in Vertical bands.

   Typical values for Toolbands:
        set modeflags to DBIMF_NORMAL
        set minSize.y:=Bandform.height;
        set MixSize.x:=0;

4. Insert menu-items in QueryContextMenu and InvokeCommand.

5. Register your DLL. (Run -> Register ActiveX Server, or from commandline:
'regsvr32 delphiband.dll'):

*)


// ******************************************************************

  Caption = 'Pikup Band'; //Bands title
  BandType = HorizontalBand;
  ToolBand = true; // Create toolband

  CLSID_DelphiBand: TGUID = '{3F5A62E2-51F2-11D3-A075-CC7364CAE42B}';
// ******** Create your own unique identifier for each Band ********
// In Delphi-IDE : Ctrl-Shift-G

// ******************************************************************





type
  TDelphiBandFactory = class(TComObjectFactory)
  private
    procedure AddKeys;
    procedure RemoveKeys;
  public
    procedure UpdateRegistry(Register: Boolean); override;
  end;

  TDelphiBand = class(TComObject, IDeskBand, IPersist, IPersistStreamInit, IObjectWithSite, IContextMenu, IInputObject)
  private
    MenuItems : Integer;
    HasFocus: Boolean;
    BandID: DWORD;
    SavedWndProc: twndmethod;
    ParentWnd,selfhand: HWND;
    Site: IInputObjectSite;
    cmdTarget: IOleCommandTarget;
    BandForm: TBandform;
    IE : IWebbrowser2;
  public
   // IDeskBand methods
    function GetBandInfo(dwBandID, dwViewMode: DWORD; var pdbi: TDeskBandInfo):
      HResult; stdcall;
    function ShowDW(fShow: BOOL): HResult; stdcall;
    function CloseDW(dwReserved: DWORD): HResult; stdcall;
    function ResizeBorderDW(var prcBorder: TRect; punkToolbarSite: IUnknown;
      fReserved: BOOL): HResult; stdcall;
    function GetWindow(out wnd: HWnd): HResult; stdcall;
    function ContextSensitiveHelp(fEnterMode: BOOL): HResult; stdcall;
   // IPersistStreamInit methods
    function InitNew: HResult; stdcall;
    function GetClassID(out classID: TCLSID): HResult; stdcall;
    function IsDirty: HResult; stdcall;
    function Load(const stm: IStream): HResult; stdcall;
    function Save(const stm: IStream; fClearDirty: BOOL): HResult; stdcall;
    function GetSizeMax(out cbSize: Largeint): HResult; stdcall;
   // IObjectWithSite methods
    function SetSite(const pUnkSite: IUnknown): HResult; stdcall;
    function GetSite(const riid: TIID; out site: IUnknown): HResult; stdcall;
    // IContextMenu methods
    function QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult; stdcall;
    function InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult; stdcall;
    function GetCommandString(idCmd, uType: UINT; pwReserved: PUINT; pszName: LPSTR; cchMax: UINT): HResult; stdcall;
    /// IInputObject methods
    function UIActivateIO(fActivate: BOOL; var lpMsg: TMsg): HResult; stdcall;
    function HasFocusIO: HResult; stdcall;
    function TranslateAcceleratorIO(var lpMsg: TMsg): HResult; stdcall;

    procedure FocusChange(bHasFocus: Boolean);
    procedure UpdateBandInfo;
    procedure BandWndProc(var Message: TMessage);
  end;



implementation

uses dialogs, Registry;

procedure TDelphiBand.UpdateBandInfo;
(*
Band objects can send commands to their container.
Two commands are supported:
DBID_BANDINFOCHANGED
   The band's information has changed. The container will call the band
   object's GetBandInfo method to request the updated information.
DBID_MAXIMIZEBAND
The container will maximize the band.
*)
var
  vain, vaOut: OleVariant;
  PtrGuid: PGUID;
begin
  vaIn := Variant(BandID);
  New(PtrGUID);
  PtrGUID^ := IDESKBAND;
  cmdTarget.Exec(PtrGUID, DBID_BANDINFOCHANGED, OLECMDEXECOPT_DODEFAULT, vaIn, vaOut);
  Dispose(PtrGUID);
end;


function TDelphiBand.GetBandInfo(dwBandID, dwViewMode: DWORD; var pdbi: TDeskBandInfo):
  HResult;
// Retrieves the information for the band object.
begin
  BandId := dwBandID;
  (*
DBIM_MINSIZE:
The minimum size of the band object.
The minimum width is placed in the x member
and the minimum height is placed in the y member.

NB: In vertical bands is y=width e.g.:
    pdbi.ptMinSize.y:=Bandform.Width;
*)

  if (pdbi.dwMask or DBIM_MINSIZE) <> 0
    then begin
    pdbi.ptMinSize.x := 250;
    pdbi.ptMinSize.y := 24;
  end;

(*
DBIM_MAXSIZE:
The maximum size of the band object.
The maximum height is placed in the y member
and the x member is ignored. If there is no
limit for the maximum height, -1 should be used.
*)
  if (pdbi.dwMask or DBIM_MAXSIZE) <> 0
    then begin
    pdbi.ptMaxSize.x := 0;
    pdbi.ptMaxSize.y := -1;
  end;

(*
DBIM_INTEGRAL:
the sizing step value of the band object.
The vertical step value is placed in the y member,
and the x member is ignored. The step value determines
in what increments the band will be resized.
This member is ignored if dwModeFlags does not
contain DBIMF_VARIABLEHEIGHT.
*)
  if (pdbi.dwMask or DBIM_INTEGRAL) <> 0
    then begin
    pdbi.ptIntegral.x := 0;
    pdbi.ptIntegral.y := 0;
  end;


(*
DBIM_ACTUAL:
The ideal size of the band object. The ideal width
is placed in the x member and the ideal height is placed
in the y member. The band container will attempt to use
these values, but the band is not guaranteed to be this size.
*)
  if (pdbi.dwMask or DBIM_ACTUAL) <> 0
    then begin
    pdbi.ptActual.x := 250;
    pdbi.ptActual.y := 32;
  end;

(*
DBIM_MODEFLAGS:
A value that receives a set of flags that define the mode of
operation for the band object. This must be one or a combination
of the following values:

DBIMF_NORMAL:  The band is normal in all respects. The other mode flags modify this flag.
DBIMF_VARIABLEHEIGHT:  The height of the band object can be changed.
        The ptIntegral member defines the step value by which the band object can be resized.
DBIMF_DEBOSSED:  The band object is displayed with a sunken appearance.
DBIMF_BKCOLOR:  The band will be displayed with the background color specified in crBkgnd
*)
  if (pdbi.dwMask or DBIM_MODEFLAGS) <> 0 then
  begin
    pdbi.dwModeFlags := DBIMF_VARIABLEHEIGHT;
  end;

(*
DBIM_BKCOLOR:
A value that eceives the background color of the band.
This member is ignored if dwModeFlags does not contain the DBIMF_BKCOLOR flag.
*)
  if (pdbi.dwMask or DBIM_BKCOLOR) <> 0 then
  begin
    pdbi.dwMask := pdbi.dwMask and (not DBIM_BKCOLOR);;
  end;


(*
DBIM_TITLE:
the title of the band.
*)
  if (Pdbi.dwMask and DBIM_TITLE) = DBIM_TITLE
    then begin
    FillChar(pdbi.wszTitle, SizeOf(Caption) + 1, ' ');
    StringToWideChar(Caption, @pdbi.wszTitle, Length(Caption) + 1);
  end;
  Result := NOERROR;
end;


function TDelphiBand.QueryContextMenu(Menu: HMENU; indexMenu, idCmdFirst, idCmdLast, uFlags: UINT): HResult;
begin
//Add Menuitems here in reverse order:
  InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst + 2, 'About...');
  InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdFirst + 1, 'IE and Delphi');
  InsertMenu(Menu, indexMenu, MF_STRING or MF_BYPOSITION, idCmdfirst, 'Update Bandinfo');
// Return number of items added:
  MenuItems := 3;
  Result := MenuItems;
end;


function TDelphiBand.InvokeCommand(var lpici: TCMInvokeCommandInfo): HResult;
begin
  if (HiWord(Integer(lpici.lpVerb)) <> 0) or (LoWord(lpici.lpVerb) > MenuItems-1) then
  begin
    Result := E_FAIL;
    Exit;
  end;
  case LoWord(lpici.lpVerb) of
// Add menu commands:
    0: UpdateBandInfo;
    1: Bandform.NavigateFromBand('http:/b');
    2: Showmessage('Band Objects ver. 1.1');
  end;
  Result := NO_ERROR;
end;



procedure TDelphiBand.BandWndProc(var Message: TMessage);
begin
// Notify the browser when the band has focus so Accelerator
// keys are translated.
  if (Message.Msg = WM_PARENTNOTIFY)  then
  begin
    Hasfocus:=True;
    FocusChange(True);
  end;
  SavedWndProc(Message);
end;

function TDelphiBand.GetWindow(out wnd: HWnd): HResult;
begin
  if not Assigned(BandForm) then
  begin
    BandForm := TBandForm.CreateParented(ParentWnd);
    BandForm.IE:=IE;
  end;
  Wnd := Bandform.Handle;
  SavedWndProc := Bandform.WindowProc;
  Bandform.WindowProc := BandWndProc;
  Result := S_OK;
end;

procedure TDelphiBand.FocusChange(bHasFocus: Boolean);
begin
  // Informs the browser that the focus has changed.
  {
   如无下面一句，则BackSapce键不起作用。参见
   "WebBrowser Keystroke Problems"
   http://www.microsoft.com/mind/0499/faq/faq0499.asp
   但有此句就无法输入中文。
   谁找到了解决方法，请告诉我，不胜感激。< zw84611@sina.com >
  }
  if (Site <> nil) then Site.OnFocusChangeIS(Self, bHasFocus);

end;

function TDelphiBand.TranslateAcceleratorIO(var lpMsg: TMsg): HResult;
// Passes keyboard accelerators to the object.
begin
  if (lpMsg.WParam <> VK_TAB) then begin
    TranslateMessage(lpMSg);
    DispatchMessage(lpMsg);
    Result := S_OK;
  end
  else Result := S_FALSE;
end;


function TDelphiBand.HasFocusIO: HResult;
{var Wnd, TemWnd: HWND;}
// Determines if one of the object's windows has the keyboard focus.
begin
  //=====================================
  {Wnd := GetFocus();
  TemWnd := Bandform.Handle;//ParentWnd;
  while (Wnd<>0) and (TemWnd<>0) do
  begin
    if Wnd=TemWnd then
    begin
      Result := S_OK;
      Windows.Beep(1000,200);
      exit;
    end;
    TemWnd := Windows.GetWindow(TemWnd,GW_CHILD);
  end;
  Result := S_FALSE;
  exit; }
  //if BandForm.cbAddr.Focused then Windows.Beep(1000,20);
  //=====================================
  Result:=Integer(not HasFocus);

end;


function TDelphiBand.UIActivateIO(fActivate: BOOL;
  var lpMsg: TMsg): HResult;
// Activates or deactivates the object.
begin
  Hasfocus:=fActivate;
  if HasFocus then Bandform.SetFocus;
  Result := S_OK;
end;


function TDelphiBand.GetCommandString(idCmd, uType: UINT; pwReserved: PUINT;
  pszName: LPSTR; cchMax: UINT): HResult;
begin
  Result := NOERROR;
end;


function TDelphiBand.SetSite(const pUnkSite: IUnknown): HResult;
// When the user selects an Explorer Bar, the container calls
// the corresponding band object's SetSite method. The punkSite
// parameter will be set to the site's IUnknown pointer.
begin
//If the pointer passed to SetSite is set to Nil, the band is being removed.
//SetSite can return S_OK. ->
  if Assigned(pUnkSite) then begin
// Store the pointer to this interface for use later. ->
    Site := pUnkSite as IInputObjectSite;
//Call GetWindow to obtain the parent window's handle,
//and save it for future use. ->
    (pUnkSite as IOleWindow).GetWindow(ParentWnd);
// Need IOleCommandTarget if you want to send commands to the container
// (see UpdateBandInfo) ->
    cmdTarget := pUnkSite as IOleCommandTarget;
//  Get a connection to IE's browser-window ->
    (CmdTarget as IServiceProvider).QueryService(IWebbrowserApp, IWebbrowser2, IE);
  end;
  Result := S_OK;
end;

function TDelphiBand.GetSite(const riid: TIID; out site: IUnknown): HResult;
// Retrieves the last site set with SetSite.
begin
  if Assigned(Site) then Result := Site.QueryInterface(riid, site)
  else Result := E_FAIL;
end;

function TDelphiBand.GetClassID(out classID: TCLSID): HResult;
begin
  classID := CLSID_DelphiBand;
  Result := S_OK;
end;


function TDelphiBand.CloseDW(dwReserved: DWORD): HResult;
begin
  if BandForm <> nil then BandForm.Destroy;
  Result := S_OK;
end;


function TDelphiBand.ContextSensitiveHelp(fEnterMode: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDelphiBand.ShowDW(fShow: BOOL): HResult;
begin
  Hasfocus:=fShow;
  FocusChange(fShow);
  Result := S_OK;
end;


function TDelphiBand.ResizeBorderDW(var prcBorder: TRect; punkToolbarSite: IUnknown;
  fReserved: BOOL): HResult;
begin
  Result := E_NOTIMPL;
end;


function TDelphiBand.IsDirty: HResult;
begin
  Result := S_FALSE;
end;

function TDelphiBand.Load(const stm: IStream): HResult;
begin
  Result := S_OK;
end;

function TDelphiBand.Save(const stm: IStream; fClearDirty: BOOL): HResult;
begin
  Result := S_OK;
end;

function TDelphiBand.GetSizeMax(out cbSize: Largeint): HResult;
begin
  Result := E_NOTIMPL;
end;

function TDelphiBand.InitNew: HResult;
begin
  Result := E_NOTIMPL;
end;


procedure TDelphiBandFactory.UpdateRegistry(Register: Boolean);
begin
  inherited UpdateRegistry(Register);
  if Register then AddKeys else RemoveKeys;
end;

procedure TDelphiBandFactory.AddKeys;
var S: string;
begin
  S := GUIDToString(CLSID_DelphiBand);
  with TRegistry.Create do
  try

// http://support.microsoft.com/support/kb/articles/Q247/7/05.ASP   ->
    if BandType <> DeskBand then
    begin
      DeleteKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Discardable\PostSetup\Component Categories\' + VerticalBand + '\Enum');
      DeleteKey('Software\Microsoft\Windows\CurrentVersion\Explorer\Discardable\PostSetup\Component Categories\' + HorizontalBand + '\Enum');
    end;

    RootKey := HKEY_CLASSES_ROOT;
    if OpenKey('CLSID\' + S, True) then
    begin
      WriteString('', '');
      CloseKey;
    end;
    if OpenKey('CLSID\' + S + '\InProcServer32', True) then
    begin
      WriteString('ThreadingModel', 'Apartment');
      CloseKey;
    end;
    if OpenKey('CLSID\' + S + '\Implemented Categories\' + BandType, True)
      then CloseKey;
    if Toolband then begin
      RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\Microsoft\Internet Explorer\Toolbar', True) then
      begin
        WriteString(S, '');
        CloseKey;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TDelphiBandFactory.RemoveKeys;
var S: string;
begin
  S := GUIDToString(CLSID_DelphiBand);
  with TRegistry.Create do
  try
    RootKey := HKEY_CLASSES_ROOT;

    // http://support.microsoft.com/support/kb/articles/Q214/8/42.ASP ->
    if BandType = DeskBand then
      DeleteKey('Component Categories\' + DeskBand + '\Enum');

    DeleteKey('CLSID\' + S + '\Implemented Categories\' + BandType);
    DeleteKey('CLSID\' + S + '\InProcServer32');
    DeleteKey('CLSID\' + S);
    Closekey;
    if ToolBand then begin
      RootKey := HKEY_LOCAL_MACHINE;
      OpenKey('Software\Microsoft\Internet Explorer\Toolbar', FALSE);
      DeleteValue(s);
      CloseKey;
    end;
  finally
    Free;
  end;
end;

initialization
  TDelphiBandFactory.Create(ComServer, TDelphiBand, CLSID_DelphiBand, '', Caption, ciMultiInstance);
end.


