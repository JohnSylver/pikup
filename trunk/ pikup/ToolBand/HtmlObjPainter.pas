unit HtmlObjPainter;


interface
uses windows,MSHTML_TLB,Graphics,classes;
 type THtmlObjPainter=class(TInterfacedObject,IElementBehaviorFactory,IElementBehavior,IHTMLPainter)
 private
   ihtmlObj:IHTMLElement;
   FBehaviorSite: IElementBehaviorSite;
   Body:ihtmlelement;
   frect:tagRECT;
   procedure DrawButton(Bounds:TRect;Canvas:TCanvas);
   function FindBehavior(const bstrBehavior: WideString; const bstrBehaviorUrl: WideString;
                          const pSite: IElementBehaviorSite; out ppBehavior: IElementBehavior): HResult; stdcall;
   function Init(const pBehaviorSite: IElementBehaviorSite): HResult; stdcall;
   function Notify(lEvent: Integer; var pVar: OleVariant): HResult; stdcall;
   function Detach: HResult; stdcall;
   function Draw(rcBounds: tagRECT; rcUpdate: tagRECT; lDrawFlags: Integer;
                  var hdc: _RemotableHandle; var pvDrawObject: Pointer): HResult; stdcall;
    function onresize(size: tagSIZE): HResult; stdcall;
    function GetPainterInfo(out pInfo: _HTML_PAINTER_INFO): HResult; stdcall;
    function HitTestPoint(pt: tagPOINT; out pbHit: Integer; out plPartID: Integer): HResult; stdcall;
    function SnapRect(const pIElement: IHTMLElement; var prcNew: tagRECT; eHandle: _ELEMENT_CORNER): HResult; stdcall;
  public

 end ;
implementation

function THtmlObjPainter.Init(const pBehaviorSite: IElementBehaviorSite): HResult;
begin
  pBehaviorSite.GetElement(ihtmlObj);
  FBehaviorSite :=pBehaviorSite;
  Result:=S_OK;
end;


function THtmlObjPainter.FindBehavior(const bstrBehavior: WideString; const bstrBehaviorUrl: WideString;
                          const pSite: IElementBehaviorSite; out ppBehavior: IElementBehavior): HResult;
begin
  ppBehavior:=Self;
  Result:=S_OK;
end;

function THtmlObjPainter.Notify(lEvent: Integer; var pVar: OleVariant): HResult;
begin
  Result:=S_OK;
end;

function THtmlObjPainter.Detach:HRESULT;
begin
  Result:=S_OK;
end;

function THtmlObjPainter.Draw(rcBounds: tagRECT; rcUpdate: tagRECT; lDrawFlags: Integer;
                  var hdc: _RemotableHandle; var pvDrawObject: Pointer): HResult;
var ps:PAINTSTRUCT;
    canvas:tcanvas;
    DrawBox: tagRECT;
begin
  //BeginPaint(longword(@hdc),@ps);
  {MoveToEx(longword(@hdc),rcBounds.right,rcBounds.top,nil);
  LineTo(longword(@hdc),rcBounds.left,rcBounds.top);
  LineTo(longword(@hdc),rcBounds.left,rcBounds.bottom);
  LineTo(longword(@hdc),rcBounds.right,rcBounds.bottom);
  LineTo(longword(@hdc),rcBounds.right,rcBounds.top); }
  canvas:=TCanvas.Create;
  canvas.Handle:=longword(@hdc);
  canvas.Brush.Style:= bsClear;
  canvas.Pen.Color:=$00ee5555;
  DrawBox.left:=rcBounds.left;
  DrawBox.top:=rcBounds.top;
  DrawBox.right:=rcBounds.right;
  DrawBox.bottom:=rcBounds.bottom;
  canvas.Rectangle(DrawBox.right,DrawBox.top,DrawBox.left,DrawBox.bottom);
  DrawButton(Rect(rcBounds.left,rcBounds.top,rcBounds.right,rcBounds.bottom),Canvas);
   (FBehaviorSite as IHTMLPaintSite).InvalidateRect(rcBounds);
  canvas.Free;
 // EndPaint(longword(@hdc),@ps);
  Result:=S_OK;
end;

procedure THtmlObjPainter.DrawButton(Bounds:TRect;Canvas:TCanvas);
begin
  Canvas.Pen.Style := psSolid;
  Canvas.Brush.Style := bsClear;
  Canvas.Pen.Color := clBtnFace;
  Canvas.Rectangle(Bounds.Left+0,Bounds.Top,Bounds.Right,Bounds.Bottom-0);
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBtnFace;
  Canvas.Pen.Color := clBtnFace;
  Canvas.Rectangle(Bounds.Left,Bounds.Top,Bounds.Left + 0,Bounds.Top + 0);
  //if FButtonPushed then
//    DrawFrameControl(Canvas.Handle, Rect(Bounds.Left,Bounds.Top,Bounds.Left + 20,Bounds.Top + 20), DFC_BUTTON, DFCS_PUSHED or DFCS_BUTTONPUSH or DFCS_ADJUSTRECT)
  //else
  DrawFrameControl(Canvas.Handle, Rect(Bounds.Left,Bounds.Top+0,Bounds.Left + 20,Bounds.Top + 20), DFC_POPUPMENU, DFCS_BUTTONPUSH or DFCS_ADJUSTRECT);
  //Canvas.Pen.Style := psClear;
  //Canvas.Brush.Style := bsSolid;
  //Canvas.Brush.Color := clBtnText;
 // Canvas.Ellipse(Bounds.Left+5,Bounds.Top+5,Bounds.Left + 15,Bounds.Top + 15);
end;

function THtmlObjPainter.onresize(size: tagSIZE): HResult;
begin
 (FBehaviorSite as IHTMLPaintSite).InvalidateRect(frect);
  result:=S_OK;
end;

function THtmlObjPainter.GetPainterInfo(out pInfo: _HTML_PAINTER_INFO): HResult;
begin
  pInfo.lFlags := HTMLPAINTER_OPAQUE + HTMLPAINTER_HITTEST;
  pInfo.lZOrder:=HTMLPAINT_ZORDER_WINDOW_TOP;
  pInfo.rcExpand.left:=0;
  pInfo.rcExpand.top:=0;
  Result:=S_OK;
end;

function THtmlObjPainter.HitTestPoint(pt: tagPOINT; out pbHit: Integer; out plPartID: Integer): HResult;
begin
  Result:=S_OK;
end;

function THtmlObjPainter.SnapRect(const pIElement: IHTMLElement; var prcNew: tagRECT; eHandle: _ELEMENT_CORNER): HResult;
begin
 Result:=S_OK; 
end;
end.
