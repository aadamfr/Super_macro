unit BackGround;

interface

uses windows, ExtCtrls;

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


procedure Degrade(Image : TImage; cdep, cfin : integer);
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

procedure DrawBesiez(Image : TImage);
var StartCbez, EndCBez, InterCBez, LatCBez : array of TPoint;
    i : integer;
    Lt1, Lt2 : TPoint;
    Ind : real;
begin
with Image
do begin
   SetLength(StartCbez,4);
   SetLength(EndCbez,4);
   SetLength(InterCBez,4);
   SetLength(LatCBez,4);
   Degrade(Image,RGB(209,219,221),RGB(128,155,162));
   Canvas.Pen.Color := RGB(154,167,171);
   Randomize;

   for i := 0 to 3
   do begin
      StartCbez[i].X := Random(Width);  StartCbez[i].Y := Random(Height);
        EndCbez[i].X := Random(Width);    EndCbez[i].Y := Random(Height);
      end;

   StartCbez[0].X := Random(Width div 10); StartCbez[0].Y := Random(Height div 10);
   StartCbez[3].X := Width - Random(Width div 10); StartCbez[3].Y := Random(Height div 10);

   EndCbez[0].X := Random(Width div 10); EndCbez[0].Y := Height - Random(Height div 10);
   EndCbez[3].X := Width - Random(Width div 10); EndCbez[3].Y := Height - Random(Height div 10);

   Canvas.Pen.Width := 1;
   Ind := 0;

   for i := 0 to 20
   do begin
      Binterpol(StartCBez,EndCbez,4,Ind,InterCBez);
      Canvas.PolyBezier(InterCBez);

      Lt1 := Bcalcul(StartCbez[0],StartCbez[1],StartCbez[2],StartCbez[3],Ind);
      Lt2 := Bcalcul(EndCbez[0],EndCbez[1],EndCbez[2],EndCbez[3],Ind);
      Canvas.PenPos := Lt1;
      Canvas.LineTo(Lt2.X,Lt2.Y);
      Ind := Ind + 0.05;
      end;
   end;
end;


end.
 