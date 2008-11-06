unit IEHelper;

interface
uses MSHTML_TLB,Types,windows,SysUtils,HtmlObjPainter;

type
  TIeHelper = class(TInterfacedObject,IHTMLEditDesigner)
  private
    _DrawHtmlObj:IHTMLElement2;
    _PainterID:integer;
    painter:THtmlObjPainter;
    procedure SetPainter(ihtmlobj :IHTMLElement2);
  public
    constructor create();overload;
    destructor Destroy;override;
    function PreHandleEvent(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult; stdcall;
    function PostHandleEvent(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult; stdcall;
    function TranslateAccelerator(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult; stdcall;
    function PostEditorEventNotify(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult; stdcall;
  end;
  const
      SID_IHTMLEDITSERVICE:TGUID='{3050f7f9-98b5-11cf-bb82-00aa00bdce0b}';
  const
    DISPID_HTMLELEMENTEVENTS_ONDBLCLICK =$FFFFFDA7;
		DISPID_HTMLELEMENTEVENTS_ONDRAGSTART = $8001000B;
		DISPID_HTMLELEMENTEVENTS_ONDRAG = $80010014;
		DISPID_HTMLELEMENTEVENTS_ONMOUSEDOWN = $FFFFFDA3;
		DISPID_HTMLELEMENTEVENTS_ONMOUSEUP = $FFFFFDA1;
		DISPID_HTMLELEMENTEVENTS_ONMOUSEMOVE = -606;
		DISPID_HTMLELEMENTEVENTS_ONMOVE = $40B;
		DISPID_HTMLELEMENTEVENTS_ONMOVESTART =$40E;
		DISPID_HTMLELEMENTEVENTS_ONMOVEEND = $40F;
		DISPID_HTMLELEMENTEVENTS_ONRESIZESTART = $410;
		DISPID_HTMLELEMENTEVENTS_ONRESIZEEND = $411;
		DISPID_READYSTATE = $FFFFFDF3;
		DISPID_XOBJ_MIN = $80010000;
		DISPID_XOBJ_MAX = $8001FFFF;
		DISPID_XOBJ_BASE = DISPID_XOBJ_MIN;
implementation


constructor TIeHelper.create;
begin
  inherited create;
end;

destructor TIeHelper.Destroy;
begin
  if Assigned(_DrawHtmlObj) then begin
  _DrawHtmlObj.removeBehavior(_PainterID);
  _DrawHtmlObj:=nil;
  end;
  inherited Destroy;
end;

function  TIeHelper.PreHandleEvent(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult;
var point:TPoint;
    P1,P2:Pointer;
    tmpobj:IHTMLElement;
    ss:string;
begin
  point.X:=pIEventObj.x;
  point.Y:=pIEventObj.y;
//  MessageBox(0,'Get message','',0+32);
  case inEvtDispId of
   DISPID_HTMLELEMENTEVENTS_ONMOUSEMOVE :begin
    //MessageBox(0,pchar(pIEventObj.srcElement.tagName),'',0+32);
    //SetSystemCursor(GetCursor,OCR_NORMAL);

   //  OutputDebugString(pchar(inttostr(pIEventObj.srcElement.sourceIndex)+'---'+inttostr((_DrawHtmlObj as ihtmlelement).sourceIndex)));
     if Assigned(_DrawHtmlObj) then begin
     // OutputDebugString(pchar(inttostr(pIEventObj.srcElement.sourceIndex)+'---'+inttostr((_DrawHtmlObj as ihtmlelement).sourceIndex)));
        if pIEventObj.srcElement.sourceIndex=(_DrawHtmlObj as ihtmlelement).sourceIndex then begin
          Result:=S_false;
        //OutputDebugString('相同对象');
          exit;
        end;
        //OutputDebugString('不同对象');
        _DrawHtmlObj.removeBehavior(_PainterID);
        _DrawHtmlObj:=nil;
     end;
      ss:=pIEventObj.srcElement.tagName;
      OutputDebugString(pchar(ss));
   // if (pIEventObj.srcElement.tagName='TABLE') then begin
      _DrawHtmlObj:=pIEventObj.srcElement as IHTMLElement2;
//      OutputDebugString(pchar((_DrawHtmlObj as ihtmlelement).innerHTML));
      SetPainter(_DrawHtmlObj);
   // end;
    {if (pIEventObj.srcElement.tagName='IMG') then begin
      _DrawHtmlObj:=pIEventObj.srcElement as IHTMLElement2;
      SetPainter(_DrawHtmlObj);
    end;}
   end;
   DISPID_HTMLELEMENTEVENTS_ONMOUSEDOWN :begin
   //   OutputDebugString(pchar( 'X坐标:'+inttostr(point.X)+' Y坐标:'+inttostr(point.y)+' ['+pIEventObj.srcElement.tagName+']'));
   end;
  end;
  Result:=S_FALSE;
end;

procedure TIeHelper.SetPainter(ihtmlobj :IHTMLElement2);
var
  vfactory:OleVariant;
begin
 // MessageBox(0,'setpainter','',0+32);
  painter:=THtmlObjPainter.Create;
  vfactory:=IElementBehaviorFactory(painter);
  _PainterID:=ihtmlobj.addBehavior('',vfactory);
end;

function TIeHelper.PostHandleEvent(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult;
begin
   Result:=S_FALSE;
end;

function TIeHelper.TranslateAccelerator(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult;
begin
   Result:=S_FALSE;
end;

function TIeHelper.PostEditorEventNotify(inEvtDispId: Integer; const pIEventObj: IHTMLEventObj): HResult;
begin
   Result:=S_FALSE;
end;
end.
 