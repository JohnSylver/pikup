unit SnapScreens;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TSnapScreenFrm = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SnapScreenFrm: TSnapScreenFrm;

implementation

{$R *.dfm}

procedure TSnapScreenFrm.FormCreate(Sender: TObject);
var  FullscreenCanvas :TCanvas;
begin
  FullscreenCanvas := TCanvas.Create;
  FullscreenCanvas.Handle:= GetDC(0) ;
  Self.Canvas.CopyRect(
  Rect (0, 0, screen.Width,screen.Height),
  fullscreenCanvas,
  Rect (0, 0, Screen.Width, Screen.Height));
  ReleaseDC(0,FullscreenCanvas.Handle);
end;

end.
