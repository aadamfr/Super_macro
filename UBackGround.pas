unit UBackGround;

interface

uses windows, ExtCtrls, Graphics;

var c1,c2,c3 : Tcolor;

//procedure Degrade(Image : TBitmap; cdep, cfin : integer);
procedure DrawBesiez(Image : TBitmap);
procedure TransformTimageToWizard(Image : Timage);

implementation

Function interpol(p1, p2 : Tpoint; p : single): Tpoint;
var
  x1, x2, y1, y2 : single;
begin
  x1 := p1.x;
  y1 := p1.y;
  x2 := p2.x;
  y2 := p2.y;
  result.x := round(x1*p+x2*(1-p));
  result.y := round(y1*p+y2*(1-p));
end;

Procedure Binterpol(Z1, Z2: array of Tpoint; NB: integer; k: single;
                    var Z3: array of Tpoint);
var
  i : integer;
begin
  dec(NB);
  for i := 0 to NB do Z3[i] := interpol(Z2[i], Z1[i], k);
end;



Function Bcalcul(P1,C1,C2,P2: Tpoint; t: single): Tpoint;
var
  t2,  //   t^2
  t3,  //   t^3
  r1, r2, r3, r4 : single;   // working storage
begin
  t2 := t * t;
  t3 := t * t2;
 // formula  (1-t)^3  = 1 - 3*t + 3*t^2 - t^3
  r1 := (1 - 3*t + 3*t2 -   t3)*P1.x;
  r2 := (    3*t - 6*t2 + 3*t3)*C1.x;
  r3 := (          3*t2 - 3*t3)*C2.x;
  r4 := (                   t3)*P2.x;
  Result.x := round(r1 + r2 + r3 + r4);
  r1 := (1 - 3*t + 3*t2 -   t3)*P1.y;
  r2 := (    3*t - 6*t2 + 3*t3)*C1.y;
  r3 := (          3*t2 - 3*t3)*C2.y;
  r4 := (                   t3)*P2.y;
  Result.y := round(r1 + r2 + r3 + r4);
end;


procedure Degrade(Image : TBitmap; cdep, cfin : integer);
var pr, pg, pb : real;
    Rdep, Gdep, Bdep : byte;
    Rfin, Gfin, Bfin : byte;
    i : integer;
begin
  Rdep := getRvalue (cdep);
  Gdep := getGvalue (cdep);
  Bdep := getBvalue (cdep);
  Rfin := getRvalue (cfin);
  Gfin := getGvalue (cfin);
  Bfin := getBvalue (cfin);
  pr := (Rfin - Rdep) / Image.Width;
  pg := (Gfin - Gdep) / Image.Width;
  pb := (Bfin - Bdep) / Image.Width;
  for i := 0 to Image.Width do begin
    Image.Canvas.pen.color := rgb (Rdep +round(i*pr), Gdep+round(i*pg), Bdep+round (i*pb));
    Image.canvas.moveto (i,0);
    Image.canvas.LineTo (i, Image.Height);
  end;
end;

procedure DrawBesiez(Image : TBitmap);
var StartCbez, EndCBez, InterCBez, LatCBez : array of TPoint;
    Coeffor, i : integer;
    Lt1, Lt2 : TPoint;
    Coef, Ind : real;
begin

with Image
do begin
   if (Height < 1 ) or (Width < 1) then Exit;
   SetLength(StartCbez,4);
   SetLength(EndCbez,4);
   SetLength(InterCBez,4);
   SetLength(LatCBez,4);
   Degrade(Image,c1,c2);
   Canvas.Pen.Color := c3;
   Randomize;

   for i := 0 to 3
   do begin
      StartCbez[i].X := - Width + Random(Width)*-5;  StartCbez[i].Y := - Height + Random(Height)*-5;
      EndCbez[i].X := Width + Random(Width)*5;    EndCbez[i].Y := Height + Random(Height)*5;
      end;

   Canvas.Pen.Width := 1;
   Ind := 0;

   coeffor := (width * height) div 6000;
   if coeffor <= 0 then coeffor := 1;
   coef := 1 / coeffor;

   for i := 0 to coeffor
   do begin
      Binterpol(StartCBez,EndCbez,4,Ind,InterCBez);
      Canvas.PolyBezier(InterCBez);

      Lt1 := Bcalcul(StartCbez[0],StartCbez[1],StartCbez[2],StartCbez[3],Ind);
      Lt2 := Bcalcul(EndCbez[0],EndCbez[1],EndCbez[2],EndCbez[3],Ind);
      Canvas.PenPos := Lt1;
      Canvas.LineTo(Lt2.X,Lt2.Y);
      Ind := Ind + coef;
      end;
   end;
end;

procedure TransformTimageToWizard(Image : Timage);
var rect : TRect;
begin
Image.Picture.Bitmap.Width := Image.Width;
Image.Picture.Bitmap.Height := Image.Height;
Degrade(Image.Picture.Bitmap,$00CC6633,clwhite);
rect := Image.ClientRect;
rect.Bottom := rect.Bottom -5;
Image.Picture.Bitmap.Canvas.Brush.Color := ClWhite;
Image.Picture.Bitmap.Canvas.Rectangle(rect);
end;



end.
