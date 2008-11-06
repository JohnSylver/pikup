unit MapFileUnit;

interface
uses
  windows;
type
  pCommonData = ^TCommonData;
  TCommonData = record
    //KeyBrdHooked: boolean;
    CallBackHandle:HWnd;
    MousePos  : TPoint; (*当前鼠标屏幕坐标*)
    Key, ShiftState: WORD;
  end;

procedure MapCommonData(var CommonData:pCommonData;var HMapFile:THandle);
procedure UnMapCommonData(var CommonData:pCommonData;var HMapFile:THandle);

implementation

procedure MapCommonData(var CommonData:pCommonData;var HMapFile:THandle);
var FirstCall: Boolean;
begin
  HMapFile:=OpenFileMapping(FILE_MAP_WRITE, False, 'ZHUWEI_KEYBOARD');
  FirstCall:=(HMapFile = 0);
  if FirstCall then
    HMapFile:=CreateFileMapping($FFFFFFFF,nil,PAGE_READWRITE,
                                0,SizeOf(TCommonData),
                                'ZHUWEI_KEYBOARD');
  CommonData:= MapViewOfFile(HMapFile, FILE_MAP_WRITE, 0, 0, 0);
  if FirstCall then FillChar(CommonData^, SizeOf(TCommonData), 0);
end;

procedure UnMapCommonData(var CommonData:pCommonData;var HMapFile:THandle);
begin
  try
    UnMapViewOfFile(CommonData);
    CommonData := nil;
    CloseHandle(HMapFile);
    HMapFile := 0;
  except
      MessageBox(0,
                 'Error when free MapViewFile',
                 'ZW Hook Error',
                 MB_OK);
  end; //try
end;

end.
