library DelphiBand;


uses
  ComServ,
  _DelphiBand in '_DelphiBand.pas',
  DelphiBand_TLB in 'DelphiBand_TLB.pas',
  MSHTML_TLB in 'MSHTML_TLB.pas',
  LoginFrm in 'LoginFrm.pas' {LoginForm},
  DLLXPTheming in 'DLLXPTheming.pas',
  SnapScreens in 'SnapScreens.pas' {SnapScreenFrm},
  IEHelper in 'IEHelper.pas',
  HtmlObjPainter in 'HtmlObjPainter.pas',
  Commucator in 'Commucator.pas',
  MyPopupMenu in 'MyPopupMenu.pas',
  md5 in 'md5.pas',
  delphibandform in 'delphibandform.pas' {BandForm};

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;

{$R *.TLB}
{$R *.RES}
{$R windowsxp.res}

begin
end.


