unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, Commctrl;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormPaint(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;
  GRect : TRect;
  LastBezierForm : string = '';
implementation

uses Unit1, Unit4, Unit19, mdlfnct,UBackGround, Unit22;

{$R *.DFM}

procedure TForm2.MessageAide(var msg:TMessage);
var HelpDir : String;
    WinCtrl : TWinControl;
begin
if ActiveControl = nil then Exit;
if ActiveControl.HelpContext = 0
then WinCtrl := ActiveControl.Parent
else WinCtrl := ActiveControl;

if WinCtrl.HelpContext <>0
then begin
     HelpDir := ExtractFileDir(Application.ExeName);
     if HtmlHelp(0, PChar(HelpDir+'\aide.chm'), HH_HELP_CONTEXT,WinCtrl.HelpContext) = 0
     then ShowMessage('Erreur: Vérifiez la présence du fichier .chm dans le dossier de Super macro.');
     end;
end;


procedure TForm2.Button1Click(Sender: TObject);
begin
if unit1.sw_modif = false
then begin
     form1.add_insert('Type',ComboBox1.text,0);
    end
else begin
     form1.ListView1.Selected.SubItems.Strings[0] := ComboBox1.text;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     unit1.sw_modif := false;
     end;

ComboBox1.text := '';
form2.close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
form2.close;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
Form1.List_Var(ComboBox1.Items, True, True);
if unit1.sw_modif
then ComboBox1.Text := Form1.listview1.Selected.SubItems.Strings[0];
ComboBox1.SetFocus;
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := False;
end;



procedure TForm2.FormPaint(Sender: TObject);
var ARect : TRect;
    i,x,y : integer;
    MyRadioButton : TRadioButton;
    Mosaique : Boolean;
begin
Mosaique := False;
ARect := (Sender as TForm).ClientRect;
Arect := Rect(0,0,Screen.Width,Screen.Height);
if form19.ComboBox5.Text = 'Bézier aléatoire'
then begin
     BackGround.Height := Arect.Bottom;
     BackGround.Width := Arect.Right;
     {if (GRect.Left <> ARect.Left) or (GRect.Top <> ARect.Top) or
        (GRect.Right <> ARect.Right) or (GRect.Bottom <> ARect.Bottom)
     then}
     if LastBezierForm <> (Sender as TForm).Name
     then UbackGround.DrawBesiez(BackGround);
     LastBezierForm := (Sender as TForm).Name;
     GRect := Arect;
     end;

if BackGround.Empty = True then Exit;

if (BackGround.Height < ARect.Bottom -Arect.Top) or (BackGround.Width < ARect.Right -Arect.Left)
then if Mosaique = False
     then (Sender as TForm).Canvas.StretchDraw(ARect,BackGround)
     else begin
      y:= 0;
      while y < ARect.Bottom
      do begin
         x := 0;
         while x < ARect.Right
         do begin
            (Sender as TForm).Canvas.Draw(x,y,BackGround);
            Inc(x,BackGround.Width);
            end;
         Inc(y,BackGround.Height);
         end;
      end
else (Sender as TForm).Canvas.Draw(0,0,BackGround);

for i := 1 to 6
   do begin
   if TForm(Sender).FindComponent('RadioButton'+IntToStr(i)) <> nil
   then begin
        MyRadioButton := TRadioButton(TForm(Sender).FindComponent('RadioButton'+IntToStr(i)));
        if MyRadioButton.Tag = 0
        then begin
             if form19.Image1.Picture.Graphic = nil
             then MyRadioButton.Color := clBtnFace
             else MyRadioButton.Color := TForm(Sender).Canvas.Pixels[MyRadioButton.Left-1,MyRadioButton.Top+7];
             MyRadioButton.Tag := 1;
             if not (MyRadioButton.Parent is TForm) then MyRadioButton.Color := clBtnFace;
             end;
        end;
      end;

end;

procedure TForm2.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm2.ComboBox1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_Return then Button1.Click;
end;

end.
