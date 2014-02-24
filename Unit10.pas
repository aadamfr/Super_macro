unit Unit10;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm10 = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form10: TForm10;
  valider : boolean = False;
implementation

{$R *.DFM}

uses unit1, unit8, mdlFnct, ContextOfExecute;

Function TextSize(Phrase : string; Police : TFont = nil) : TPoint;
var DC: HDC;
    Rectangle: TRect;
    C : TBitmap;
begin
  C := TBitmap.create;
  if police <> nil then  C.canvas.Font := police;
    Rectangle := Rect(0,0,0,0);
    DC := GetDC(0);
    C.Canvas.Handle := DC;
    DrawText(C.Canvas.Handle, PChar(Phrase), Length(Phrase), Rectangle, (DT_EXPANDTABS or DT_CALCRECT));
    C.Canvas.Handle := 0;
    ReleaseDC(0, DC);
    result.X:=Rectangle.Right-Rectangle.Left;
    result.Y:=Rectangle.Bottom-Rectangle.Top;
    C.Free;
end;



procedure TForm10.Button1Click(Sender: TObject);
begin
form10.Close;
Application.ProcessMessages;
Valider := True;
end;

procedure TForm10.Button2Click(Sender: TObject);
begin
form10.Close;
Valider := True;
// pour finir l'execution sans problème.
unit1.pos_command := Form1.ListView1.Items.Count -1;

ContextOfExecute.ExecutionType := ContextOfExecute.NotRun;
Form1.Caption := Form1.Form1CaptionUpdate;
end;

procedure TForm10.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
If Key = VK_RETURN then Button1.Click;
end;

procedure TForm10.FormShow(Sender: TObject);
var i : integer;
    Text : String;
    Dim : TPoint;
begin
if (length(Label1.Caption) > 90) and (Pos(chr(VK_RETURN),label1.Caption) = 0)
then begin
     Text := Label1.Caption;
     i := 80;
     while i < length(Text)
     do begin
        Inc(i);
        if Text[i] = ' '
        then begin
             Text := Copy(Text,0,i-1)+ Chr(VK_RETURN) + Copy(Text,i,length(Text));
             Inc(i,80);
             end;
        end;
     Label1.Caption := Text;
     end;
//Label1.Top := 8;
//Label1.Left := 16;
Dim := TextSize(label1.Caption,Label1.Font);
Label1.Width := Dim.X; Label1.Height := Dim.Y;

Form10.Width := Label1.Width+40;
Form10.Height := Label1.Height + 140;
if (Form10.Width < 260) or (Form10.Height < 140)
then begin
     Form10.Width := 260;
     Form10.Height := 140;
     end;

ForceForegroundWindow(Form10.Handle);
//SetWindowPos(Form10.Handle, HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);

end;

procedure TForm10.FormActivate(Sender: TObject);
begin
Edit1.SetFocus;
end;

end.
