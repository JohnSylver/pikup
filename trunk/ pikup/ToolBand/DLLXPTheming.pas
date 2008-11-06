Unit DLLXPTheming;

Interface

// *********************************
// Author: Hibiki, kirikawa
// Date:   Sep 5th, 2006, 17:40 
// *********************************

 Uses
  Windows, Classes, SysUtils;

 Const
  ACTCTX_FLAG_PROCESSOR_ARCHITECTURE_VALID = ($00000001);
  ACTCTX_FLAG_LANGID_VALID = ($00000002);
  ACTCTX_FLAG_ASSEMBLY_DIRECTORY_VALID = ($00000004);
  ACTCTX_FLAG_RESOURCE_NAME_VALID = ($00000008);
  ACTCTX_FLAG_SET_PROCESS_DEFAULT = ($00000010);
  ACTCTX_FLAG_APPLICATION_NAME_VALID = ($00000020);
  ACTCTX_FLAG_SOURCE_IS_ASSEMBLYREF = ($00000040);
  ACTCTX_FLAG_HMODULE_VALID = ($00000080);
  ISOLATIONAWARE_MANIFEST_RESOURCE_ID = 2;

 Type
  USHORT = Word;
  ULONG_PTR = LongWord;
  PULONG_PTR = ^ULONG_PTR;
  HANDLE = THandle;
  PVOID = Pointer;
  tagACTCTXA = Record
                cbSize: ULONG;
                dwFlags: DWORD;
                lpSource: LPCSTR;
                wProcessorArchitecture: USHORT;
                wLangId: LANGID;
                lpAssemblyDirectory: LPCSTR;
                lpResourceName: LPCSTR;
                lpApplicationName: LPCSTR;
                hModule: hModule;
               End;

  ACTCTXA = tagACTCTXA;
  PACTCTXA = ^ACTCTXA;
  TActCtxA = ACTCTXA;

  ACTCTX = ACTCTXA;
  PACTCTX = PACTCTXA;
  TActCtx = TActCtxA;

 Procedure ActivateTheming;

 Var
  CreateActCtx: function(pActCtx: pointer): THandle; stdcall;
  ActivateActCtx: function(hActCtx: THandle; lpCookie: pointer): Boolean; stdcall;
  DeactivateActCtx:function(dwFlags:DWORD;lpcookie:pointer):BOOL;stdcall;
  ReleaseActCtx:procedure(hActCtx: THandle);stdcall;
  Function GetDLLName: String;
Implementation
  {$R windowsxp.res}
 Var
  ctxHandle: THandle;
  krnl: HMODULE;
  HandleActCtx: THandle = 0;

Function GetDLLName: String;
 Var
  charPath: Array [0..2047] Of Char;
  sFile: String;
 Begin
  ZeroMemory(Addr(charPath[0]), 2048);
  GetModuleFileName(HInstance, charPath, 2048);
  sFile := charPath;
  Result := sFile;
 End;

Function BuildManifest: TStringList;
 Begin
  Result := TStringList.Create;
  Result.Add('<?xml version="1.0" encoding="utf-8" standalone="yes"?>');
  Result.Add('<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">');
  Result.Add('    <assemblyIdentity');
  Result.Add('    version="1.0.0.0"');
  Result.Add('    processorArchitecture="X86"');
  Result.Add('    name="DelphiBand"');
  Result.Add('    type="win32"');
  Result.Add('/>');
  Result.Add('    <description>Animation Search Kit for Internet Explorer.</description>');
  Result.Add('    <dependency>');
  Result.Add('        <dependentAssembly>');
  Result.Add('            <assemblyIdentity');
  Result.Add('            type="win32"');
  Result.Add('            name="Microsoft.Windows.Common-Controls"');
  Result.Add('            version="6.0.0.0"');
  Result.Add('            processorArchitecture="X86"');
  Result.Add('            publicKeyToken="6595b64144ccf1df"');
  Result.Add('            language="*"');
  Result.Add('        />');
  Result.Add('        </dependentAssembly>');
  Result.Add('    </dependency>');
  Result.Add('</assembly>');
 End; 

Procedure ActivateTheming;
 Var
  ctx: ACTCTX;
  path, manifest, s: ansistring;
  d: TStringList;
  Cookie: Pointer;
  Buffer: array[0..MAX_PATH] of Char;
 Begin
  if HandleActCtx <> 0 then Exit;
  krnl := GetModuleHandle('KERNEL32.DLL');
  CreateActCtx := GetProcAddress(krnl, 'CreateActCtxA');
  ActivateActCtx := GetProcAddress(krnl, 'ActivateActCtx');
  DeactivateActCtx := GetProcAddress(krnl, 'DeactivateActCtx');
  ReleaseActCtx := GetProcAddress(krnl, 'ReleaseActCtx');
  if (not Assigned(CreateActCtx)) or (not Assigned(ActivateActCtx)) then Exit;
  FillChar(ctx, SizeOf(ctx), 0);
  ctx.cbSize := SizeOf(ctx);
  ctx.dwFlags :=ACTCTX_FLAG_SET_PROCESS_DEFAULT ;
  s := GetDLLName;
   path := ExtractFilePath(s);
  manifest := ExtractFileName(s) + '.manifest';
  s := path + '\' + manifest;
 d := BuildManifest;
  Try
   If Not FileExists(s) Then d.SaveToFile(s);
  Except
  End;
  d.Free;               
 ctx.lpSource := pansichar(s);
 GetModuleFileName(hInstance, Buffer, SizeOf(Buffer));
// ctx.lpSource := Buffer;
 //Resource ID in the Resoure File
 //ctx.lpResourceName := MAKEINTRESOURCE(1);
  ctx.lpAssemblyDirectory := pansiChar(path);
  ctxhandle := CreateActCtx(addr(ctx));
  if(ctxHandle <> INVALID_HANDLE_VALUE) then begin
    ActivateActCtx(ctxHandle,Cookie);
    DeactivateActCtx(0,Cookie);
    ReleaseActCtx(ctxHandle);
  end;
 End;

Initialization
try
     ActivateTheming;
except

end;



End.

