unit Charts;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Printers, ComCtrls, StdCtrls;

type
  TForm37 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    ScrollBox1: TScrollBox;
    Prv: TPaintBox;
    function NewPage : Integer;
    function DrawPage(ListView : TListView; Index : integer) : integer;
    procedure MacroToCharts(ListView : TListView);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PrvPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    { Déclarations privées }
    LPages: TList;
  public
    { Déclarations publiques }
  procedure MetaDefault(Meta : TMetafileCanvas);
  function DrawTypeSpl(Meta : TMetafileCanvas; Prm : String; Pos : integer) : integer;
  end;

var
  Form37: TForm37;

implementation

uses Unit1, MdlFnct;

{$R *.dfm}

procedure TForm37.MetaDefault(Meta : TMetafileCanvas);
begin
Meta.Font.Size := 8;
Meta.Font.Style := [];
Meta.Pen.Color := clBlack;
Meta.Brush.Style := bsSolid;
end;

function TForm37.DrawTypeSpl(Meta : TMetafileCanvas; Prm : String; Pos : integer) : integer;
var ListParam : Tparam;
begin

Meta.RoundRect(10,Pos, 32,Pos+32,5,5);
ListParam := GetParam(Prm);
result := Pos + 32;
end;

function TForm37.NewPage: Integer;
var I : integer;
begin
I := Lpages.Count;
LPages.add(TMetafile.Create);
TMetafile(LPages[I]).Width  := Printer.PageWidth;
TMetafile(LPages[I]).Height := Printer.PageHeight;
result := I;
end;

function TForm37.DrawPage(ListView : TListView; Index : integer) : integer;
var i,PageNr,Pos : integer;
    S : String;
    Obj : TMetafileCanvas;
begin
PageNr := NewPage;
Obj := TMetafileCanvas.Create(TMetafile(LPages[PageNr]), 0);
with Obj
do begin
   Font.Size := 12;
   Font.PixelsPerInch := GetDeviceCaps(Printer.handle, LOGPIXELSX);
   Pos := TextHeight('Lq')*2;
   for i := Index to ListView.Items.Count-1
   do begin
      S := ListView.Items[i].Caption + ListView.Items[i].SubItems[0];
      Inc(Pos,TextHeight(S)*2);
      if ListView.Items[i].Caption = 'Type Special'
      then begin Pos := DrawTypeSpl(Obj,ListView.Items[i].SubItems[0],pos); continue; end;
      TextOut(10, Pos, S);
      if Pos > Printer.PageHeight - TextHeight('Lq')*2 then break;
      end;
   free;
   result := i;
   end;
end;

procedure TForm37.MacroToCharts(ListView : TListView);
var i : integer;
begin
i := 0;
while i < ListView.Items.Count-1
do i := DrawPage(ListView,i+1);
end;

procedure TForm37.FormCreate(Sender: TObject);
begin
LPages := TList.Create;
end;

procedure TForm37.FormDestroy(Sender: TObject);
begin
LPages.Free;
end;

procedure TForm37.FormShow(Sender: TObject);
begin
MacroToCharts(Form1.ListView1);
Prv.Refresh;
end;

procedure TForm37.FormClose(Sender: TObject; var Action: TCloseAction);
begin
while LPages.Count > 0 do
  begin
   Dispose(LPages[0]);
   LPages.Delete(0);
  end;
end;

procedure TForm37.PrvPaint(Sender: TObject);
var
 M: TMetafile;
begin
if LPages.Count > 0 then
 begin
  Prv.Canvas.Brush.Color := clWhite;
  M := TMetafile(LPages[Prv.tag]);
  Prv.Canvas.FillRect(Rect(0,0, M.width, M.height)); {Pour "peindre" le fond en blanc.}
  Prv.canvas.StretchDraw(Rect(0, 0, Prv.width, Prv.Height), M);
 end;

end;

procedure TForm37.Button1Click(Sender: TObject);
begin
if Prv.Tag <= 1
then Button1.Enabled := False
else Button1.Enabled := True;
Prv.Tag := Prv.Tag-1;
Prv.Refresh;
end;

procedure TForm37.Button2Click(Sender: TObject);
begin
if Prv.Tag >= Lpages.Count-1
then Button2.Enabled := False
else Button2.Enabled := True;
Prv.Tag := Prv.Tag +1;
Prv.Refresh;
end;

procedure TForm37.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
Prv.Height := Prv.Height + (Prv.Height div 10);
Prv.Width := Prv.Width + (Prv.Width div 10);
end;

procedure TForm37.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
Prv.Height := Prv.Height - (Prv.Height div 10);
Prv.Width := Prv.Width - (Prv.Width div 10);
end;

end.
