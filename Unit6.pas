unit Unit6;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList, ComCtrls;

type
  TForm6 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    ImageList1: TImageList;
    Edit1: TEdit;
    Edit2: TEdit;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrawImageMouse(point : Tpoint; FloodColor : Tcolor);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox14MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form6: TForm6;
  Image_Select : TBitmap;
  TabColorOfMouse : array[1..4]of Tpoint;
  ActionColor : array[0..6] of TColor = (clWhite,$0080FFFF,clSkyBlue,$0080FF80,$0055AAFF,$00FFB9FF,$00FFFF80);


implementation

uses Unit1, Unit2, mdlfnct;

{$R *.DFM}

procedure TForm6.MessageAide(var msg:TMessage);
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

procedure TForm6.DrawImageMouse(point : Tpoint; FloodColor : Tcolor);
begin
ImageList1.GetBitmap(0,Image1.Picture.Bitmap);
Image1.Canvas.brush.Color := clfuchsia;
Image1.Canvas.FloodFill(0,0,clwhite,fsSurface);
Image1.Canvas.brush.Color := FloodColor;
Image1.Canvas.FloodFill(point.x,point.y,clwhite,fsSurface);
end;

procedure TForm6.Button1Click(Sender: TObject);
var clique : string;
begin
if (checkBox1.Checked = False) and (checkBox2.Checked = False) and (checkBox3.Checked = False) and
   (checkBox4.Checked = False) and (checkBox5.Checked = False) and (checkBox6.Checked = False) and
   (checkBox7.Checked = False) and (checkBox8.Checked = False) and (checkBox9.Checked = False) and
   (checkBox10.Checked = False) and (checkBox11.Checked = False) and (checkBox12.Checked = False) and
   (checkBox13.Checked = False) and (checkBox14.Checked = False)
then begin
     MessageDlg('Vous devez sélectionner au moins une action.',mtWarning,[mbOk],0);
     exit;
     end;
clique := '';
if checkBox1.Checked = true then clique := clique + 'Left Down'+ SprPr;
if checkBox2.Checked = true then clique := clique + 'Middle Down'+ SprPr;
if checkBox3.Checked = true then clique := clique + 'Right Down'+ SprPr;
if checkBox4.Checked = true then clique := clique + 'Left Up'+ SprPr;
if checkBox5.Checked = true then clique := clique + 'Middle Up'+ SprPr;
if checkBox6.Checked = true then clique := clique + 'Right Up'+ SprPr;

if checkBox7.Checked = true then clique := clique + 'Left click'+ SprPr;
if checkBox8.Checked = true then clique := clique + 'Middle click'+ SprPr;
if checkBox9.Checked = true then clique := clique + 'Right click'+ SprPr;
if checkBox10.Checked = true then clique := clique + 'Left double-click'+ SprPr;
if checkBox11.Checked = true then clique := clique + 'Middle double-click'+ SprPr;
if checkBox12.Checked = true then clique := clique + 'Right double-click'+ SprPr;

if checkBox13.Checked = true then clique := clique + 'Whell Up'+ SprPr+ Edit1.Text+ SprPr;
if checkBox14.Checked = true then clique := clique + 'Whell Down'+ SprPr+ Edit2.Text+ SprPr;

if unit1.sw_modif = false
    then form1.add_insert('Click',clique,2)
    else begin
         Form1.ListView1.Selected.SubItems.Strings[0] := clique;
         Form1.SaveBeforeChange(Form1.ListView1.Selected);
         end;
form6.close;
end;

procedure TForm6.FormShow(Sender: TObject);
var listParam : Tparam;
    param : string;
    i : integer;
begin
DrawImageMouse(TabColorOfMouse[1],ActionColor[0]);

for i := Form6.ComponentCount-1 downto 0
do if (Form6.Components[i] is TCheckBox) then TCheckBox(Components[i]).Checked := False;

Shape1.Brush.Color := ActionColor[1];
Shape2.Brush.Color := ActionColor[2];
Shape3.Brush.Color := ActionColor[3];
Shape4.Brush.Color := ActionColor[4];
Shape5.Brush.Color := ActionColor[5];
Shape6.Brush.Color := ActionColor[6];

Edit1.Visible := False; UpDown1.Visible := False;
Edit2.Visible := False; UpDown2.Visible := False;
edit1.Text := '1';
edit2.Text := '1';

if unit1.sw_modif = true
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);

     for i := 1 to 6
     do begin
        if listParam.param[i] = 'Left Down' then begin checkbox1.Checked := true; DrawImageMouse(TabColorOfMouse[1],ActionColor[1]); end;
        if listParam.param[i] = 'Middle Down' then begin checkbox2.Checked := true; DrawImageMouse(TabColorOfMouse[2],ActionColor[1]); end;
        if listParam.param[i] = 'Right Down' then begin checkbox3.Checked := true; DrawImageMouse(TabColorOfMouse[3],ActionColor[1]); end;

        if listParam.param[i] = 'Left Up' then begin checkbox4.Checked := true; DrawImageMouse(TabColorOfMouse[1],ActionColor[2]); end;
        if listParam.param[i] = 'Middle Up' then begin checkbox5.Checked := true; DrawImageMouse(TabColorOfMouse[2],ActionColor[2]); end;
        if listParam.param[i] = 'Right Up' then begin checkbox6.Checked := true; DrawImageMouse(TabColorOfMouse[3],ActionColor[2]); end;

        if listParam.param[i] = 'Left click' then begin checkbox7.Checked := true; DrawImageMouse(TabColorOfMouse[1],ActionColor[3]); end;
        if listParam.param[i] = 'Middle click' then begin checkbox8.Checked := true; DrawImageMouse(TabColorOfMouse[2],ActionColor[3]); end;
        if listParam.param[i] = 'Right click' then begin checkbox9.Checked := true; DrawImageMouse(TabColorOfMouse[3],ActionColor[3]); end;

        if listParam.param[i] = 'Left double-click' then begin checkbox10.Checked := true; DrawImageMouse(TabColorOfMouse[1],ActionColor[4]); end;
        if listParam.param[i] = 'Middle double-click' then begin checkbox11.Checked := true; DrawImageMouse(TabColorOfMouse[2],ActionColor[4]); end;
        if listParam.param[i] = 'Right double-click' then begin checkbox12.Checked := true; DrawImageMouse(TabColorOfMouse[3],ActionColor[4]); end;

        if listParam.param[i] = 'Whell Up' then begin checkbox13.Checked := true; Edit1.Visible := True; UpDown1.Visible := True; Edit1.Text :=  listParam.param[i+1];  DrawImageMouse(TabColorOfMouse[4],ActionColor[5]); end;
        if listParam.param[i] = 'Whell Down' then begin checkbox14.Checked := true; Edit2.Visible := True; UpDown2.Visible := True; Edit2.Text :=  listParam.param[i+1];  DrawImageMouse(TabColorOfMouse[4],ActionColor[6]); end;
        end;
     end;
end;

procedure TForm6.Button2Click(Sender: TObject);
begin
form6.close;
end;

procedure TForm6.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm6.FormCreate(Sender: TObject);
begin
Form6.DoubleBuffered := True;
TabColorOfMouse[1] := point(20,30);
TabColorOfMouse[2] := point(18,18);
TabColorOfMouse[3] := point(35,5);
TabColorOfMouse[4] := point(35,18);

end;

procedure TForm6.CheckBox14MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i : integer;
begin

for i := Form6.ComponentCount-1 downto 0
do if (Form6.Components[i] is TCheckBox)  and (Form6.Components[i].Tag <> TCheckBox(Sender).Tag) then TCheckBox(Components[i]).Checked := False;
Edit1.visible := False; UpDown1.visible := False;
Edit2.visible := False; UpDown2.visible := False;
DrawImageMouse(TabColorOfMouse[1],ActionColor[0]);

case TCheckBox(Sender).Tag of
     11 : if TCheckBox(Sender).Checked then  DrawImageMouse(TabColorOfMouse[1],ActionColor[1]);
     12 : if TCheckBox(Sender).Checked then  DrawImageMouse(TabColorOfMouse[1],ActionColor[2]);
     13 : if TCheckBox(Sender).Checked then  DrawImageMouse(TabColorOfMouse[1],ActionColor[3]);
     14 : if TCheckBox(Sender).Checked then  DrawImageMouse(TabColorOfMouse[1],ActionColor[4]);

     21 : if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[2],ActionColor[1]);
     22 : if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[2],ActionColor[2]);
     23 : if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[2],ActionColor[3]);
     24 : if TCheckBox(Sender).Checked then  DrawImageMouse(TabColorOfMouse[2],ActionColor[4]);

     31 : if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[3],ActionColor[1]);
     32 : if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[3],ActionColor[2]);
     33 : if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[3],ActionColor[3]);
     34 : if TCheckBox(Sender).Checked then  DrawImageMouse(TabColorOfMouse[3],ActionColor[4]);

     41 : begin if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[4],ActionColor[5]);
                Edit1.visible := TCheckBox(Sender).checked; UpDown1.visible  := TCheckBox(Sender).checked;
                end;
     42 : begin if TCheckBox(Sender).Checked then DrawImageMouse(TabColorOfMouse[4],ActionColor[6]);
                Edit2.visible := TCheckBox(Sender).checked; UpDown2.visible  := TCheckBox(Sender).checked;
                end;
     end;
end;

procedure TForm6.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
if not FnctIsInteger(Edit1.Text) then Edit1.Text := '1';
if Button = btNext
then Edit1.Text := IntToStr(StrToInt(Edit1.Text) + 1);
if Button = btPrev
then Edit1.Text := IntToStr(StrToInt(Edit1.Text) - 1);
if StrToInt(Edit1.Text) > 100 then Edit1.Text := '100';
if StrToInt(Edit1.Text) < 1 then Edit1.Text := '1';
end;

procedure TForm6.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
if not FnctIsInteger(Edit2.Text) then Edit2.Text := '1';
if Button = btNext
then Edit2.Text := IntToStr(StrToInt(Edit2.Text) + 1);
if Button = btPrev
then Edit2.Text := IntToStr(StrToInt(Edit2.Text) - 1);
if StrToInt(Edit2.Text) > 100 then Edit2.Text := '100';
if StrToInt(Edit2.Text) < 1 then Edit2.Text := '1';
end;

procedure TForm6.Edit1Change(Sender: TObject);
begin
if not FnctIsInteger(Edit1.Text) then Edit1.Text := '1';
Edit1.Text := IntToStr(StrToInt(Edit1.Text));
if StrToInt(Edit1.Text) > 100 then Edit1.Text := '100';
if StrToInt(Edit1.Text) < 1 then Edit1.Text := '1';
end;

procedure TForm6.Edit2Change(Sender: TObject);
begin
if not FnctIsInteger(Edit2.Text) then Edit2.Text := '1';
Edit2.Text := IntToStr(StrToInt(Edit2.Text));
if StrToInt(Edit2.Text) > 100 then Edit2.Text := '100';
if StrToInt(Edit2.Text) < 1 then Edit2.Text := '1';
end;

end.
