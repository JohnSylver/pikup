unit MyPopupMenu;
interface
uses Windows, Forms, Messages, Classes, Controls, Menus,ExtCtrls;

type
  TMyPopupList = class(TList)
  private
    procedure WndProc(var Message: TMessage);
  public
    Window: HWND;
    procedure Add(Popup: TPopupMenu);
    procedure Remove(Popup: TPopupMenu);
  end;
  TMyPopupMenu = class(TPopupMenu)
  private
    FPopupList: TMyPopupList;
    function IsOwnerDrawMenu: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Popup(X, Y: Integer); override;
    procedure WndMessage(Sender: TObject; var AMsg: TMessage;
      var Handled: Boolean);
  end;
implementation
procedure TMyPopupList.WndProc(var Message: TMessage);
var
  I: Integer;
  MenuItem: TMenuItem;
  FindKind: TFindItemKind;
  ContextID: Integer;
  Handled: Boolean;
begin
  try
    case Message.Msg of
      WM_MEASUREITEM, WM_DRAWITEM:
        for I := 0 to Count - 1 do
        begin
          Handled := False;
          TMyPopupMenu(Items[I]).WndMessage(nil, Message, Handled);
          if Handled then
            Exit;
        end;
      WM_COMMAND:
        for I := 0 to Count - 1 do
          if TMyPopupMenu(Items[I]).DispatchCommand(Message.WParam) then
            Exit;
      WM_INITMENUPOPUP:
        for I := 0 to Count - 1 do
          with TWMInitMenuPopup(Message) do
            if TMyPopupMenu(Items[I]).DispatchPopup(MenuPopup) then
              Exit;
      WM_MENUSELECT:
        with TWMMenuSelect(Message) do
        begin
          FindKind := fkCommand;
          if MenuFlag and MF_POPUP <> 0 then
          begin
            FindKind := fkHandle;
            ContextID := GetSubMenu(Menu, IDItem);
          end
          else
            ContextID := IDItem;
          for I := 0 to Count - 1 do
          begin
            MenuItem := TMyPopupMenu(Items[I]).FindItem(ContextID, FindKind);
            if MenuItem <> nil then
            begin
              Application.Hint := MenuItem.Hint;
              {with TMyPopupMenu(Items[I]) do
                if Cursor <> crDefault then
                  if (MenuFlag and MF_HILITE <> 0) then
                    SetCursor(Screen.Cursors[Cursor])
                  else
                    SetCursor(Screen.Cursors[crDefault]);     }
              Exit;
            end;
          end;
          Application.Hint := '';
        end;
      WM_MENUCHAR:
        for I := 0 to Count - 1 do
          with TMyPopupMenu(Items[I]) do
            if (Handle = HMenu(Message.LParam)) or
              (FindItem(Message.LParam, fkHandle) <> nil) then
            begin
              ProcessMenuChar(TWMMenuChar(Message));
              Exit;
            end;
      WM_HELP:
        with PHelpInfo(Message.LParam)^ do
        begin
          for I := 0 to Count - 1 do
            if TMyPopupMenu(Items[I]).Handle = hItemHandle then
            begin
              ContextID := TMenu(Items[I]).GetHelpContext(iCtrlID, True);
              if ContextID = 0 then
                ContextID := TMenu(Items[I]).GetHelpContext(hItemHandle, False);
              if Screen.ActiveForm = nil then
                Exit;
              if (biHelp in Screen.ActiveForm.BorderIcons) then
                Application.HelpCommand(HELP_CONTEXTPOPUP, ContextID)
              else
                Application.HelpContext(ContextID);
              Exit;
            end;
        end;
    end;
    with Message do
      Result := DefWindowProc(Window, Msg, WParam, LParam);
  except
    Application.HandleException(Self);
  end;
end;
procedure TMyPopupList.Add(Popup: TPopupMenu);
begin
  if Count = 0 then
    Window := AllocateHWnd(WndProc);
  inherited Add(Popup);
end;
procedure TMyPopupList.Remove(Popup: TPopupMenu);
begin
  inherited Remove(Popup);
  if Count = 0 then
    DeallocateHWnd(Window);
end;
{ TMyPopupMenu }
constructor TMyPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPopupList := TMyPopupList.Create;
  FPopupList.Add(Self);
end;
destructor TMyPopupMenu.Destroy;
begin
  if Assigned(FPopupList) then begin
    FPopupList.Remove(Self);
  end;
  inherited Destroy;
end;

procedure TMyPopupMenu.WndMessage(Sender: TObject; var AMsg: TMessage;
  var Handled: Boolean);
begin
  //if IsOwnerDrawMenu then MenuWndMessage(Self, AMsg, Handled);
end;

function TMyPopupMenu.IsOwnerDrawMenu: Boolean;
begin
 // Result := (FStyle <> msStandard)
  //  or (Assigned(FImages) and (FImages.Count > 0));
end;

procedure TMyPopupMenu.Popup(X, Y: Integer);
var
  _FParentBiDiMode: Boolean;
const
  Flags: array[Boolean, TPopupAlignment] of Word =
  ((TPM_LEFTALIGN, TPM_RIGHTALIGN, TPM_CENTERALIGN),
    (TPM_RIGHTALIGN, TPM_LEFTALIGN, TPM_CENTERALIGN));
  Buttons: array[TTrackButton] of Word =
  (TPM_RIGHTBUTTON, TPM_LEFTBUTTON);
begin
  SetPopupPoint(Point(X, Y));
  _FParentBiDiMode := ParentBiDiMode;
  try
    //SetBiDiModeFromPopupControl;
    DoPopup(Self);
   { if IsOwnerDrawMenu then
      RefreshMenu(True);  }
    Items.RethinkHotkeys;
    Items.RethinkLines;
    Items.Handle;

    AdjustBiDiBehavior;
    TrackPopupMenu(Items.Handle,
      Flags[UseRightToLeftAlignment, Alignment] or Buttons[TrackButton], X, Y,
      0 { reserved }, FPopupList.Window, nil);
  finally
    ParentBiDiMode := _FParentBiDiMode;
  end;
end;
end.

