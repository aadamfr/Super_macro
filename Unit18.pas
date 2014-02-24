unit Unit18;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ImgList;

type
  TForm18 = class(TForm)
    Label1: TLabel;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    ComboBox2: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    ComboBox3: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Bevel2: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    image1: TPaintBox;
    Bevel3: TBevel;
    RadioButton3: TRadioButton;
    Label9: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Image1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Label7Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure Form18Show(rubrique : String);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
    procedure ComboBox3DropDown(Sender: TObject);
    procedure DrawImageMenu(index : integer);
    procedure image1Paint(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
     lng_msgInit : String = 'Sélectionnez le n° du Handle puis une action dans la rubrique manipulation. Si l''action a besoin un ou des paramètres, un message vous le dira.';
     lng_msgNotParam : String  = 'Cette action demande aucun paramètre.';
     lng_msgDeplace : String  = 'Sélectionnez dans Paramètre 1 l''abscisse, puis dans Paramètre 2 l''ordonnée, la mesure est en pixel.';
     lng_msgTaille : String = 'Sélectionnez dans Paramètre 1 la Longueur, puis dans Paramètre 2 la largueur, la mesure est en pixel.';
     lng_msgChgText : String = 'Sélectionnez dans Paramètre 1 le Texte de remplacement.';
     lng_msgNoAction : String = 'Sélectionnez une action dans la rubrique Manipulation.';

var
  Form18: TForm18;
  sy: integer;
  choix : integer = 0;

 lng_restaurer : string = 'Restaurer';
 lng_Deplacer  : string = 'Déplacer';
 lng_Taille    : string = 'Taille';
 lng_Reduire   : string = 'Réduire';
 lng_Agrandir  : string = 'Agrandir';
 lng_Fermer    : string = 'Fermer';

implementation

uses Unit1, mdlfnct;

{$R *.DFM}

procedure TForm18.MessageAide(var msg:TMessage);
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

procedure TForm18.DrawImageMenu(index : integer);
var zone1 : TpaintBox;
begin
zone1 := image1;
zone1.Canvas.Brush.Style := bsClear;

zone1.Canvas.Font.Color := Label1.Font.Color;
zone1.Canvas.Pen.Color := Label1.Font.Color;

if index = 1
then begin
     zone1.Canvas.Font.Color := clRed;
     zone1.Canvas.Pen.Color := clRed;
     Form18.HelpContext := 1097;
     end;

zone1.Canvas.TextOut(24,4,lng_Restaurer);
zone1.Canvas.Rectangle(6,6,13,12);
zone1.Canvas.Rectangle(4,9,11,14);
zone1.Canvas.PenPos := point(6,7);
zone1.Canvas.LineTo(13,7);
zone1.Canvas.PenPos := point(4,10);
zone1.Canvas.LineTo(11,10);

zone1.Canvas.Font.Color := Label1.Font.Color;
zone1.Canvas.Pen.Color := Label1.Font.Color;

if index = 2
then begin
     zone1.Canvas.Font.Color := clRed;
     zone1.Canvas.Pen.Color := clRed;
     Form18.HelpContext := 1098;
     end;

zone1.Canvas.TextOut(24,24,Lng_Deplacer);

zone1.Canvas.Font.Color := Label1.Font.Color;
zone1.Canvas.Pen.Color := Label1.Font.Color;

if index = 3
then begin
     zone1.Canvas.Font.Color := clRed;
     zone1.Canvas.Pen.Color := clRed;
     Form18.HelpContext := 1099;
     end;

zone1.Canvas.TextOut(24,44,Lng_Taille);

zone1.Canvas.Font.Color := Label1.Font.Color;
zone1.Canvas.Pen.Color := Label1.Font.Color;

if index = 4
then begin
     zone1.Canvas.Font.Color := clRed;
     zone1.Canvas.Pen.Color := clRed;
     Form18.HelpContext := 1100;
     end;

zone1.Canvas.TextOut(24,64,Lng_Reduire);
zone1.Canvas.Rectangle(5,73,11,75);

zone1.Canvas.Font.Color := Label1.Font.Color;
zone1.Canvas.Pen.Color := Label1.Font.Color;

if index = 5
then begin
     zone1.Canvas.Font.Color := clRed;
     zone1.Canvas.Pen.Color := clRed;
     Form18.HelpContext := 1101;
     end;

zone1.Canvas.TextOut(24,84,Lng_Agrandir);
zone1.Canvas.Rectangle(4,85,13,94);
zone1.Canvas.Rectangle(4,85,13,87);

zone1.Canvas.Font.Color := Label1.Font.Color;
zone1.Canvas.Pen.Color := Label1.Font.Color;

zone1.Canvas.Pen.Color := clGray;
zone1.Canvas.PenPos := point(3,100);
zone1.Canvas.LineTo(zone1.Width-3,100);
zone1.Canvas.Pen.Color := clWhite;
zone1.Canvas.PenPos := Point(3,101);
zone1.Canvas.LineTo(zone1.Width-3,101);
zone1.Canvas.Pen.Color := Label1.Font.Color;

if index = 6
then begin
     zone1.Canvas.Font.Color := clRed;
     zone1.Canvas.Pen.Color := clRed;
     Form18.HelpContext := 1102;
     end;
zone1.Canvas.Font.Style := [fsBold];
zone1.Canvas.TextOut(24,110,Lng_Fermer);
zone1.Canvas.TextOut(95,110,'Alt+F4');
zone1.Canvas.Font.Style := [];
zone1.Canvas.Pen.Width := 2;
zone1.Canvas.PenPos := Point(4,113);
zone1.Canvas.LineTo(12,121);
zone1.Canvas.PenPos := Point(4,121);
zone1.Canvas.LineTo(12,113);
zone1.Canvas.Pen.Width :=1;
end;

procedure TForm18.FormShow(Sender: TObject);
var listParam : unit1.Tparam;
    param : string;
begin
choix := 0;
Form1.List_var_and_objet(ComboBox1);
if ComboBox1.Items.Count > 0
then ComboBox1.Text := ComboBox1.Items[0]
else ComboBox1.Text := '0';

Form1.List_Var(ComboBox2.Items, True, True);
Form1.List_Var(ComboBox3.Items, True, True);

DrawImageMenu(0);

Label6.Caption := lng_MsgInit;
If unit1.sw_modif = True
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.text := ListParam.param[1];
     if ListParam.param[2] = 'Restaurer' then choix := 1;
     if ListParam.param[2] = 'Déplacer' then choix := 2;
     if ListParam.param[2] = 'Taille' then choix := 3;
     if ListParam.param[2] = 'Réduire' then choix := 4;
     if ListParam.param[2] = 'Agrandir' then choix := 5;
     if ListParam.param[2] = 'Fermer' then choix := 6;
     if ListParam.param[2] = 'Déplacement souris' then begin RadioButton1.Checked := True; choix := 7; end;
     if ListParam.param[2] = 'Changement texte' then begin RadioButton2.Checked := True; choix := 8; end;
     if ListParam.param[2] = 'Fermeture forcée' then begin RadioButton3.Checked := True; choix := 9; end;
     //ImageList1.GetBitmap(choix,image1.Picture.Bitmap);
     DrawImageMenu(choix);
     image1.Refresh;
     ComboBox2.Text := ListParam.param[3];
     ComboBox3.Text := ListParam.param[4];
     case choix of
     1,4,5,6,7,9 : Label6.Caption := lng_MsgNotParam;
               2 : Label6.Caption := lng_MsgDeplace;
               3 : Label6.Caption := lng_MsgTaille;
               8 : Label6.Caption := lng_MsgChgText;
     end;
     end;
end;

procedure TForm18.Form18Show(rubrique : String);
begin
choix := 0;
ComboBox2.Enabled := False;
ComboBox3.Enabled := False;
Label3.Enabled := False;
Label4.Enabled := False;
Form1.List_Objet(ComboBox1);
Form1.List_Var(ComboBox1.Items, True, True);
Form1.List_Var(ComboBox2.Items, True, True);
Form1.List_Var(ComboBox3.Items, True, True);
//ImageList1.GetBitmap(0,image1.Picture.Bitmap);
image1.Refresh;
DrawImageMenu(0);
Label6.Caption := lng_MsgInit;
if Rubrique = 'Restaurer' then choix := 1;
if Rubrique = 'Déplacer' then choix := 2;
if Rubrique = 'Taille' then choix := 3;
if Rubrique = 'Réduire' then choix := 4;
if Rubrique = 'Agrandir' then choix := 5;
if Rubrique = 'Fermer' then choix := 6;
if Rubrique = 'Déplacement souris' then begin RadioButton1.Checked := True; choix := 7; end;
if Rubrique = 'Changement texte' then begin RadioButton2.Checked := True; choix := 8; end;
if Rubrique = 'Fermeture forcée' then begin RadioButton3.Checked := True; choix := 9; end;

//ImageList1.GetBitmap(choix,image1.Picture.Bitmap);
DrawImageMenu(choix);
case choix of
     1,4,5,6,7 : Label6.Caption := lng_MsgNotParam;
     2         : begin Label6.Caption := lng_MsgDeplace; ComboBox2.Enabled := True; ComboBox3.Enabled := True; Label3.Enabled := True; Label4.Enabled := True;end;
     3         : begin Label6.Caption := lng_MsgTaille; ComboBox2.Enabled := True; ComboBox3.Enabled := True; Label3.Enabled := True; Label4.Enabled := True;end;
     8         : begin Label6.Caption := lng_MsgChgText; ComboBox2.Enabled := True; Label3.Enabled := True; end;
     9         : begin Label6.Caption := lng_MsgNotParam; ComboBox3.Enabled := True; Label9.Enabled := True; end;
     end;
image1.Refresh;
end;

procedure TForm18.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ComboBox1.text := '';
unit1.sw_modif := False;
end;

procedure TForm18.Button1Click(Sender: TObject);
var Param : String;
    Ok : Boolean;
begin
Ok := True;
if (FnctIsInteger(ComboBox1.Text) = false) and (FnctTypeVar(ComboBox1.Text) = TNo)
then begin
     Ok := False;
     MessageDlg('Le handle doit être un nombre entier ou une variable.', mtWarning,[mbOk], 0)
     end;
if (FnctIsInteger(ComboBox2.Text) = false) and (FnctTypeVar(ComboBox2.Text) = TNo) and (choix in [2..3])
then begin
     Ok := False;
     MessageDlg('Le paramètre 1 doit être un nombre entier ou une variable.', mtWarning,[mbOk], 0)
     end;
if (FnctIsInteger(ComboBox3.Text) = false) and (FnctTypeVar(ComboBox3.Text) = TNo) and (choix in [2..3])
then begin
     Ok := False;
     MessageDlg('Le paramètre 2 doit être un nombre entier ou une variable.', mtWarning,[mbOk], 0)
     end;
if choix = 0
then begin
     Ok := False;
     MessageDlg(lng_MsgNoAction, mtWarning,[mbOk], 0)
     end;

     if Ok = True
     then begin
     Param := ComboBox1.text+ SprPr;
     case choix of
          1 : Param := Param + 'Restaurer' + SprPr;
          2 : Param := Param + 'Déplacer' + SprPr;
          3 : Param := Param + 'Taille' + SprPr;
          4 : Param := Param + 'Réduire' + SprPr;
          5 : Param := Param + 'Agrandir' + SprPr;
          6 : Param := Param + 'Fermer' + SprPr;
          7 : Param := Param + 'Déplacement souris'+ SprPr;
          8 : Param := Param + 'Changement texte' + SprPr;
          9 : Param := Param + 'Fermeture forcée' + SprPr;
      end;
      
     Param := Param + ComboBox2.text + SprPr + ComboBox3.text + SprPr;

     if unit1.sw_modif = false
     then Form1.add_insert('Manipulation',Param,18)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;

     unit1.sw_modif := false;
     Form18.Close;
     end;
end;

procedure TForm18.Button2Click(Sender: TObject);
begin
form18.close;
end;

procedure TForm18.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//sx := x;
sy := y;
end;

procedure TForm18.Image1Click(Sender: TObject);
var handle : HWND;
    X, Y : String;
    Dim : TRect;
begin
if ((sy > 0)    and (sy < 20)) then choix := 1;
if ((sy > 21)   and (sy < 40)) then choix := 2;
if ((sy > 41)   and (sy < 60)) then choix := 3;
if ((sy > 61)   and (sy < 80)) then choix := 4;
if ((sy > 81)  and (sy < 100)) then choix := 5;
if ((sy > 101) and (sy < 130)) then choix := 6;
RadioButton1.Checked := False;
RadioButton2.Checked := False;
RadioButton3.Checked := False;
//ImageList1.GetBitmap(choix,image1.Picture.Bitmap);
//image1.Refresh;
DrawImageMenu(choix);

X := '0'; Y := '0';
if FnctIsInteger(ComboBox1.Text)
then begin
     handle := StrToInt(ComboBox1.Text);
     if handle > 0
     then begin
          GetWindowRect(handle, Dim);
          if choix = 2
          then begin
               X := IntToStr(Dim.Left);
               Y := IntToStr(Dim.Top);
               end;
          if choix = 3
          then begin
               X := IntToStr(Dim.Right - Dim.Left);
               Y := IntToStr(Dim.Bottom - Dim.Top);
               end;
          end;
     end;

case choix of
1,4,5,6 : begin Label6.Caption := lng_MsgNotParam; ComboBox2.Text := ''; ComboBox3.Text := ''; ComboBox2.Enabled := False; ComboBox3.Enabled := False; end;
      2 : begin Label6.Caption := lng_MsgDeplace; ComboBox2.Enabled := True; ComboBox3.Enabled := True; ComboBox2.Text := X; ComboBox3.Text := Y; end;
      3 : begin Label6.Caption := lng_MsgTaille;  ComboBox2.Enabled := True; ComboBox3.Enabled := True; ComboBox2.Text := X; ComboBox3.Text := Y; end;
end;

label3.Enabled := ComboBox2.Enabled; // paramètre 1
label4.Enabled := ComboBox3.Enabled; // paramètre 2
Form18.refresh;
end;

procedure TForm18.RadioButton1Click(Sender: TObject);
begin
if radiobutton1.Checked then
begin
DrawImageMenu(0);
choix := 7;
Label6.Caption := lng_MsgNotParam;
ComboBox2.Enabled := False;
ComboBox3.Enabled := False;
ComboBox2.Text := '';
ComboBox3.Text := '';
label3.Enabled := ComboBox2.Enabled; // paramètre 1
label4.Enabled := ComboBox3.Enabled; // paramètre 2
Form18.Refresh;
Form18.HelpContext := 1104;
end;
end;

procedure TForm18.RadioButton2Click(Sender: TObject);
begin
if radiobutton2.Checked then
begin
DrawImageMenu(0);
choix :=  8;
Label6.Caption := lng_MsgChgText;
ComboBox2.Enabled := True;
ComboBox3.Enabled := False;
ComboBox3.Text := '';
label3.Enabled := ComboBox2.Enabled; // paramètre 1
label4.Enabled := ComboBox3.Enabled; //paramètre 2
Form18.Refresh;
Form18.HelpContext := 1105;
end;
end;

procedure TForm18.RadioButton3Click(Sender: TObject);
begin
if radiobutton3.Checked then
begin
DrawImageMenu(0);
choix :=  9;
Label6.Caption := lng_MsgNotParam;
ComboBox2.Enabled := False;
ComboBox3.Enabled := False;
ComboBox3.Text := '';
label3.Enabled := ComboBox2.Enabled; // paramètre 1
label4.Enabled := ComboBox3.Enabled; //paramètre 2
Form18.Refresh;
Form18.HelpContext := 1103;
end;
end;

procedure TForm18.Label7Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm18.Label8Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm18.Label9Click(Sender: TObject);
begin
RadioButton3.Checked := True;
end;

procedure TForm18.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_var_and_objet(ComboBox1);
ComboBox1.Text := SaveText;
end;

procedure TForm18.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox2.Text;
Form1.List_Var(ComboBox2.Items, True, True);
ComboBox2.Text := SaveText;
end;

procedure TForm18.ComboBox3DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox3.Text;
Form1.List_Var(ComboBox3.Items, True, True);
ComboBox3.Text := SaveText;
end;

procedure TForm18.image1Paint(Sender: TObject);
begin
DrawImageMenu(choix);
end;

end.
