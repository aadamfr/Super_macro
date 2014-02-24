unit Unit31;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls;

const
  PixelCountMax = 32768;

type
  pRGBQuadArray = ^TRGBQuadArray;
  TRGBQuadArray = ARRAY[0..PixelCountMax-1] OF TRGBQuad;


type TMemImage = record
     Filename : string;
     Image : TImage;
     end;

type
  TForm31 = class(TForm)
    Button1: TButton;
    Button2: TButton;
  procedure FnctFindGraphic(Param : String);
  //function IsMyImage(x,y, index : integer): Boolean;
  private
    { Private declarations }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Public declarations }
  end;

var
  Form31: TForm31;
  Bureau : TImage;
  MemImage : array of TMemImage;
implementation

uses unit1, mdlfnct;

{$R *.dfm}

procedure TForm31.MessageAide(var msg:TMessage);
var HelpDir : String;
begin
if ActiveControl = nil then Exit;
if ActiveControl.HelpContext <>0
then begin
     HelpDir := ExtractFileDir(Application.ExeName);
     if HtmlHelp(form1.Handle, PChar(HelpDir+'\aide.chm'), HH_HELP_CONTEXT,ActiveControl.HelpContext) = 0
     then ShowMessage('Erreur: Vérifiez la présence du fichier .chm dans le dossier de Super macro.');
     end;
end;

procedure TForm31.FnctFindGraphic(Param : String);
var ListParam : Tparam;
    Bounds : Trect;
    index,i,j : integer;
    HandleDCBureau : HDC;
    LastPixel : TColor;
    LimX, LimY : word;
    p1, p2 :  pRGBQuadArray;
    c1 : Tcolor;
    count, item : integer;
    ImageFileName : String;
    function IsMyImage(x,y,index : integer): Boolean;
    var i,j : integer;
    begin
    result := True;
    Application.ProcessMessages;
    if not Run then begin result := False; Exit; end;
    for i := 1 to MemImage[index].Image.Picture.Bitmap.Height-1
    do for j := 1 to MemImage[index].Image.Picture.Bitmap.Width-1
       do if MemImage[index].Image.Picture.Bitmap.Canvas.Pixels[j,i] <> bureau.Picture.Bitmap.Canvas.Pixels[j+x,i+y]
          then begin
               result := False;
               Exit;
               end;
    end;
begin
ListParam := GetParam(Param);
ImageFileName := GetValue(ListParam.param[1]);

Bounds.Left   := StrToInt(ListParam.param[2]);
Bounds.Top    := StrToInt(ListParam.param[3]);
Bounds.Right  := StrToInt(ListParam.param[4]);
Bounds.Bottom := StrToInt(ListParam.param[5]);
Item := StrToInt(GetValue(ListParam.param[12]));// Nièmme de l'image a trouver
index := -1;
// recherche si l'image est chargé en mémoire
for i := 0 to length(MemImage)-1
do if MemImage[i].Filename = ImageFileName
   then begin index := i; break; end;

// si l'image n'est pas chargé en mémoire on l'ajoute
if index = -1
then begin
     if not FileExists(ImageFileName) then Exit;
     index := length(MemImage);
     SetLength(MemImage, index+1);
     MemImage[index].Filename := ImageFileName;
     MemImage[index].Image := Timage.Create(self);
     MemImage[index].Image.Picture.Bitmap.PixelFormat := pf32bit;
     MemImage[index].Image.Picture.Bitmap.LoadFromFile(ImageFileName);
     end;
if index = -1 then Exit;
// capture de l'image du bureau
bureau := Timage.Create(self);
HandleDCBureau:=GetDC(GetDesktopWindow);
try
Bureau.Picture.Bitmap.PixelFormat := pf32bit;
bureau.Picture.Bitmap.Width := Bounds.Right - Bounds.Left;
bureau.Picture.Bitmap.Height :=Bounds.Bottom - Bounds.Top;

LastPixel :=  MemImage[index].Image.Picture.Bitmap.Canvas.Pixels[MemImage[index].Image.Picture.Bitmap.Width-1,MemImage[index].Image.Picture.Bitmap.Height-1];
LimX := bureau.Picture.Bitmap.Width - MemImage[index].Image.Picture.Bitmap.Width +1;
LimY := bureau.Picture.Bitmap.Height - MemImage[index].Image.Picture.Bitmap.Height +1;


BitBlt(bureau.Picture.Bitmap.Canvas.Handle,0,0,bureau.Picture.Bitmap.Width,bureau.Picture.Bitmap.Height,HandleDCBureau,Bounds.Left,Bounds.Top,SrcCopy);

p1 := MemImage[index].Image.Picture.Bitmap.scanline[0];
c1 :=  (p1[0].rgbRed * 100000) + (p1[0].rgbGreen * 100) + (p1[0].rgbBlue);
count := 0;

for i := 0 to LimY
do begin
   p2 := bureau.Picture.Bitmap.scanline[i];
   for j := 0 to LimX
do begin
   if  c1 =  (p2[j].rgbRed * 100000) + (p2[j].rgbGreen * 100) + (p2[j].rgbBlue)   //FirstPixel = bureau.Picture.Bitmap.Canvas.Pixels[j,i]
   then begin
        if Not Run then Exit;
        if LastPixel = bureau.Picture.Bitmap.Canvas.Pixels[j+MemImage[index].Image.Picture.Bitmap.Width-1,i+MemImage[index].Image.Picture.Bitmap.Height-1]
        then
        if IsMyImage(j,i, index) = True
        then begin
             Inc(count);
             if count = Item //Nièmme de l'image a trouver
             then begin
                  Form1.WriteVariable('VAR',ListParam.param[10],IntToStr(j+Bounds.Left+1));
                  Form1.WriteVariable('VAR',ListParam.param[11],IntToStr(i+Bounds.Top+1));
                  Exit;
                  end;
             end;
        end;
   end;
   end;
   Form1.WriteVariable('VAR',ListParam.param[10],'-1');
   Form1.WriteVariable('VAR',ListParam.param[11],'-1');
finally Bureau.Free; ReleaseDC(GetDesktopWindow,HandleDCBureau); end;

end;

end.
