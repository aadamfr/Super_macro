unit Unit7;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls;

type
  TForm7 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    UpDown1: TUpDown;
    Image1: TImage;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure DrawAiguille(Pos : integer;Long : Integer);
    procedure InitCadran();
    procedure ComboBox1Change(Sender: TObject);
    function TimeValide(Str : String): Boolean;
    procedure ComboBox1DropDown(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form7: TForm7;
  centre : Tpoint;
implementation

uses Unit1,mdlfnct;

{$R *.DFM}

procedure TForm7.MessageAide(var msg:TMessage);
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

function TForm7.TimeValide(Str : String) : Boolean;
var chaine : array[1..8] of char;
    cpt : integer;
    heure,min,sec : string;
    Bheure,Bmin,Bsec : Boolean;
begin
result := False;
if length(Str) = 8
then begin
     for cpt := 1 to 8 do chaine[cpt] := Str[cpt];
     heure := chaine[1] + chaine[2];
     min := chaine[4] + chaine[5];
     sec := chaine[7] + chaine[8];
     Bheure := mdlfnct.FnctIsInteger(heure);
     Bmin := mdlfnct.FnctIsInteger(min);
     Bsec := mdlfnct.FnctIsInteger(sec);
     if ((Bheure = True) and (Bmin = True) and (Bsec = True) and
         (chaine[3] = ':') and (chaine[6] = ':'))
     then result := True;
     end;
end;

procedure TForm7.DrawAiguille(Pos : integer;Long : Integer);
var X,Y : integer;
begin
image1.Canvas.MoveTo(centre.x,centre.y);
X:=Round(sin(2*pi*Pos /60)*Long);
Y:=Round(cos(2*pi*Pos /60)*-Long);
image1.Canvas.LineTo(centre.x+X,centre.y+Y);
end;

procedure TForm7.InitCadran;
begin

image1.Canvas.CopyRect(Rect(0,0,image2.Width,image2.Height),image2.Canvas,Rect(0,0,image2.Width,image2.Height));
end;

procedure TForm7.Button1Click(Sender: TObject);
var param : String;
begin

if ComboBox1.Text <> ''
then begin
     Param := ComboBox1.Text;
     if unit1.sw_modif = false
     then form1.add_insert('Pause',Param,6)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;
     form7.close;
     unit1.sw_modif := false;
     end
else MessageDlg('Le paramètre de temps ne peut pas être vide.',mtWarning,[mbOk],0);
end;

procedure TForm7.FormShow(Sender: TObject);
var param : string;
    listParam : Tparam;
begin
image2.Left := image1.Left;
image2.Top := image1.Top;
image2.Height := image1.Height;
image2.Width := image1.Width;

// centre.x := 97;
// centre.y := 123;
centre.x := 74; //image2.Width div 2;
centre.y := 70; //image2.Height div 2;
Form1.List_Var(ComboBox1.Items,True, False);
if unit1.sw_modif = False
then ComboBox1.text := '00:00:01'
else begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.text := listParam.param[1];
     end;
ComboBox1.OnChange(self); // pour positionner les aiguilles
ComboBox1.SelStart := length(ComboBox1.Text);

end;

procedure TForm7.Button2Click(Sender: TObject);
begin
form7.close;
end;

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm7.UpDown1Click(Sender: TObject; Button: TUDBtnType);
var Strnbr : string;
    cpt : integer;
    chaine : array[1..8] of char;
    PosCur, nbr : integer;
begin
if ComboBox1.Text = '' then begin ComboBox1.Text := '00:00:00'; ComboBox1.SelStart := 8; end;
if TimeValide(ComboBox1.Text) then
begin
if length(comboBox1.Text) >= 8
then for cpt := 1 to 8 do chaine[cpt] := comboBox1.Text[cpt];
PosCur := comboBox1.SelStart;

if PosCur in [0..2] then Strnbr := comboBox1.Text[1] + comboBox1.Text[2];
if PosCur in [3..5] then Strnbr := comboBox1.Text[4] + comboBox1.Text[5];
if PosCur in [6..8] then Strnbr := comboBox1.Text[7] + comboBox1.Text[8];

nbr := StrToInt(Strnbr);
if Button = btNext then Inc(nbr);
if Button = btPrev then Dec(nbr);
// limite
if ((nbr < 0) and (PosCur in [3..8])) then nbr := 59;
if ((nbr < 0) and (PosCur in [0..2])) then nbr := 23;
if ((nbr > 59) and (PosCur in [3..8])) then nbr := 0;
if ((nbr > 23) and (PosCur in [0..2])) then nbr := 0;


if nbr >=10 then StrNbr := IntToStr(nbr) else StrNbr := '0' + IntToStr(nbr);

if PosCur in [0..2] then begin chaine[1] := strnbr[1]; chaine[2] := strnbr[2]; end;
if PosCur in [3..5] then begin chaine[4] := strnbr[1]; chaine[5] := strnbr[2]; end;
if PosCur in [6..8] then begin chaine[7] := strnbr[1]; chaine[8] := strnbr[2]; end;
ComboBox1.Text := chaine;
ComboBox1.SelStart := PosCur;
ComboBox1Change(self);
end;
end;

procedure TForm7.ComboBox1Change(Sender: TObject);
var heure, min, sec : integer;
    chaine : array[1..8] of char;
    cpt : integer;
begin
if TimeValide(ComboBox1.Text) then
begin
if length(comboBox1.Text) >= 8
then for cpt := 1 to 8 do chaine[cpt] := comboBox1.Text[cpt];
heure := Strtoint(chaine[1] + chaine[2]);
if heure > 12 then heure := heure - 12;
heure := heure *5;
min := Strtoint(chaine[4] + chaine[5]);
sec := Strtoint(chaine[7] + chaine[8]);

Initcadran;

image1.Canvas.Pen.width := 3;
Drawaiguille(heure,20);
image1.Canvas.Pen.width := 2;
Drawaiguille(min,35);
image1.Canvas.Pen.Color := clRed;
image1.Canvas.Pen.width := 1;
Drawaiguille(sec,45);
image1.Canvas.Pen.Color := clBlack
//image1.Refresh;
end;
end;

procedure TForm7.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm7.FormCreate(Sender: TObject);
begin

form7.DoubleBuffered := True;
end;

end.
