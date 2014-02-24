unit Unit30;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AppEvnts, StdCtrls, ExtCtrls, Grids, Buttons, ComCtrls, StrUtils;

type
  TForm30 = class(TForm)
    BitBtn1: TBitBtn;
    StringGrid1: TStringGrid;
    OpenDialog1: TOpenDialog;
    Bevel1: TBevel;
    Label1: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit1: TEdit;
    Bevel2: TBevel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Bevel3: TBevel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ListBox3: TListBox;
    ComboBox1: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    ComboBox2: TComboBox;
    StatusBar1: TStatusBar;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Bevel4: TBevel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    function GetItemSelected(ListBox : TListBox) : integer;
    procedure ChangeDelimited(car : char; IndexRow : Integer);
    procedure RepaintGrid(IndexRow : Integer);
    procedure DelimitedAll();
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ListBox2Click(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure ListBox1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox2KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListBox3KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Label20Click(Sender: TObject);
    procedure Label21Click(Sender: TObject);
    procedure Label22Click(Sender: TObject);
    procedure Label23Click(Sender: TObject);
    procedure Label24Click(Sender: TObject);
    procedure Label18Click(Sender: TObject);
    procedure Label19Click(Sender: TObject);
    procedure InitStringGrid();
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
    procedure ListBox1Enter(Sender: TObject);
    procedure ListBox1Exit(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
  private
    { Private declarations }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Public declarations }
  end;

var
  Form30: TForm30;
  tableau : array[0..1000] of boolean;
  MyTopRow : integer;
  DrawCell : Boolean = True;
implementation

uses Unit1;

{$R *.dfm}

procedure TForm30.MessageAide(var msg:TMessage);
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

procedure TForm30.InitStringGrid();
var x, y : integer;
begin
for y := 0 to StringGrid1.RowCount -1
do for x := 0 to StringGrid1.ColCount -1
   do begin
      StringGrid1.Cells[x,y] := '';
      StringGrid1.Objects[x,y].Free;
      end; 

end;

function TForm30.GetItemSelected(ListBox : TListBox) : integer;
var i : integer;
begin
result := -1;
for i := 0 to listbox.Count -1 do
if listbox.Selected[i] = True then begin result := i; break; end;
end;

procedure TForm30.DelimitedAll();
var i,y : integer;
begin
for y := StringGrid1.TopRow to StringGrid1.TopRow + StringGrid1.VisibleRowCount
do begin
   For i := 0 to 1000 do Tableau[i] := False;

   if CheckBox1.Checked then ChangeDelimited(chr(Vk_Tab),y);
   if CheckBox2.Checked then ChangeDelimited(chr(Vk_Space),y);
   if CheckBox3.Checked then ChangeDelimited(';',y);
   if CheckBox4.Checked then ChangeDelimited(',',y);
   if (CheckBox5.Checked) and (Edit1.Text <> '') then ChangeDelimited(Edit1.Text[1],y);
   repaintGrid(y);
   end;
end;

procedure Tform30.ChangeDelimited(car : char; IndexRow : Integer);
var i : integer;
begin
for i := 0 to StringGrid1.ColCount - 1 do
begin
     if StringGrid1.Cells[i,IndexRow] = car
     then begin
          Tableau[i] := not Tableau[i];
          if i-1 >= 0 then if StringGrid1.Cells[i-1,IndexRow] = car then Tableau[i] := not Tableau[i];
          if i+1 <= StringGrid1.ColCount - 1 then if StringGrid1.Cells[i+1,IndexRow] <> car then Tableau[i+1] := not Tableau[i+1];
          end
end;
end;

procedure TForm30.RepaintGrid(IndexRow : Integer);
var rect : Trect;
    cpt : integer;
begin
if IndexRow < 0
then begin
     for cpt := 0 to StringGrid1.ColCount -1
     do begin
        if tableau[cpt] = True
        then StringGrid1.Canvas.Pen.Color := clTeal
        else StringGrid1.Canvas.Pen.Color := clwindow;
        rect := StringGrid1.CellRect(cpt,StringGrid1.TopRow);
        StringGrid1.Canvas.PenPos := Point(rect.Left,0);
        StringGrid1.Canvas.LineTo(rect.Left,StringGrid1.Height);
        end;
     end
else begin
     for cpt := 0 to StringGrid1.ColCount -1
     do begin
        if tableau[cpt] = True
        then StringGrid1.Canvas.Pen.Color := clTeal
        else StringGrid1.Canvas.Pen.Color := clwindow;
        rect := StringGrid1.CellRect(cpt,IndexRow);
        StringGrid1.Canvas.PenPos := Point(rect.Left,rect.Top);
        StringGrid1.Canvas.LineTo(rect.Left,rect.Bottom);
        end;
     end;

end;

procedure TForm30.BitBtn1Click(Sender: TObject);
var fichier : TextFile;
    ligne : string;
    y,x : integer;
begin
if OpenDialog1.Execute
then begin
     for x := 0 to 1000 do Tableau[x] := False;
     y := 0;
     InitStringGrid;
     StringGrid1.ColCount := 1;
     StringGrid1.RowCount := 1;
     assignfile(Fichier,OpenDialog1.FileName);
     StatusBar1.SimpleText := OpenDialog1.FileName;
     reset(Fichier);
     DrawCell := False;
     try
     while not eof(fichier) do
     begin
          readln(fichier,ligne);
          StringGrid1.RowCount := StringGrid1.RowCount + 1;
          if length(ligne) > StringGrid1.ColCount then StringGrid1.ColCount := length(ligne);
          for x := 1 to length(ligne) do
          StringGrid1.Cells[x-1,y] := ligne[x];
          Inc(y);
     end;
     finally closeFile(Fichier); DrawCell := True; RepaintGrid(-1); end;
     end;
end;

procedure TForm30.FormShow(Sender: TObject);
var i : integer;
    param : string;
    listParam : Tparam;
begin
// pour que l'on voit tous les composants de la fenêtre
while StringGrid1.Height < 20
do form30.Height := Form30.Height+20;

for i := 0 to 1000 do tableau[i] := False;
StatusBar1.SimpleText := '';
ComboBox1.Clear;
ComboBox2.Clear;
Form1.List_Var(Form30.ComboBox1.Items, True, False);
Form1.List_Var(Form30.ComboBox2.Items, True, False);
if unit1.sw_modif = True
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.Text := ListParam.param[1];
     if ListParam.param[2] = 'D'
     then begin
          RadioButton1.Checked := True;
          if ListParam.param[3] <> '' then CheckBox1.Checked := True;
          if ListParam.param[4] <> '' then CheckBox2.Checked := True;
          if ListParam.param[5] <> '' then CheckBox3.Checked := True;
          if ListParam.param[6] <> '' then CheckBox4.Checked := True;
          if ListParam.param[7] <> '' then begin CheckBox5.Checked := True; Edit1.Text := ListParam.param[7][1]; end;

          if ListParam.param[8] <> '' then ListBox1.Items.Add(ListParam.param[8]);
          if ListParam.param[9] <> '' then ListBox2.Items.Add(ListParam.param[9]);
          if ListParam.param[10] <> '' then ListBox1.Items.Add(ListParam.param[10]);
          if ListParam.param[11] <> '' then ListBox2.Items.Add(ListParam.param[11]);
          if ListParam.param[12] <> '' then ListBox1.Items.Add(ListParam.param[12]);
          if ListParam.param[13] <> '' then ListBox2.Items.Add(ListParam.param[13]);
          if ListParam.param[14] <> '' then ListBox1.Items.Add(ListParam.param[14]);
          if ListParam.param[15] <> '' then ListBox2.Items.Add(ListParam.param[15]);
          if ListParam.param[16] <> '' then ListBox1.Items.Add(ListParam.param[16]);
          if ListParam.param[17] <> '' then ListBox2.Items.Add(ListParam.param[17]);
          if ListParam.param[18] <> '' then ListBox1.Items.Add(ListParam.param[18]);
          if ListParam.param[19] <> '' then ListBox2.Items.Add(ListParam.param[19]);
          end
     else begin
          RadioButton2.Checked := True;
          if ListParam.param[3] <> '' then ListBox1.Items.Add(ListParam.param[3]);
          if ListParam.param[4] <> '' then ListBox2.Items.Add(ListParam.param[4]);
          if ListParam.param[5] <> '' then ListBox3.Items.Add(ListParam.param[5]);

          if ListParam.param[6] <> '' then ListBox1.Items.Add(ListParam.param[6]);
          if ListParam.param[7] <> '' then ListBox2.Items.Add(ListParam.param[7]);
          if ListParam.param[8] <> '' then ListBox3.Items.Add(ListParam.param[8]);

          if ListParam.param[9] <> '' then ListBox1.Items.Add(ListParam.param[9]);
          if ListParam.param[10] <> '' then ListBox2.Items.Add(ListParam.param[10]);
          if ListParam.param[11] <> '' then ListBox3.Items.Add(ListParam.param[11]);

          if ListParam.param[12] <> '' then ListBox1.Items.Add(ListParam.param[12]);
          if ListParam.param[13] <> '' then ListBox2.Items.Add(ListParam.param[13]);
          if ListParam.param[14] <> '' then ListBox3.Items.Add(ListParam.param[14]);

          if ListParam.param[15] <> '' then ListBox1.Items.Add(ListParam.param[15]);
          if ListParam.param[16] <> '' then ListBox2.Items.Add(ListParam.param[16]);
          if ListParam.param[17] <> '' then ListBox3.Items.Add(ListParam.param[17]);

          if ListParam.param[18] <> '' then ListBox1.Items.Add(ListParam.param[18]);
          if ListParam.param[19] <> '' then ListBox2.Items.Add(ListParam.param[19]);
          if ListParam.param[20] <> '' then ListBox3.Items.Add(ListParam.param[20]);
          end;
     end;
end; 

procedure TForm30.StringGrid1Click(Sender: TObject);
var cpt : integer;
    i,Dep, Fin : integer;
    ok : Boolean;
    block : integer;
begin
if RadioButton1.Checked = True
then begin
     For i := 0 to 1000 do Tableau[i] := False;
     if CheckBox1.Checked then ChangeDelimited(chr(Vk_Tab),StringGrid1.Selection.Top);
     if CheckBox2.Checked then ChangeDelimited(chr(Vk_Space),StringGrid1.Selection.Top);
     if CheckBox3.Checked then ChangeDelimited(';',StringGrid1.Selection.Top);
     if CheckBox4.Checked then ChangeDelimited(',',StringGrid1.Selection.Top);
     if (CheckBox5.Checked) and (Edit1.Text <> '') then ChangeDelimited(Edit1.Text[1],StringGrid1.Selection.Top);
     end;
Dep := StringGrid1.Selection.Left;
Fin := StringGrid1.Selection.Left;

Block := 0;
for i := 0 to StringGrid1.Selection.Left do
if Tableau[i] = True then Inc(Block);
Inc(Block);

if Tableau[StringGrid1.Selection.Left+1] = False
then begin
     for cpt := StringGrid1.Selection.Left +1 to StringGrid1.ColCount -1 do
     if Tableau[cpt] = False then Fin := cpt else break;
     end;

if Tableau[StringGrid1.Selection.Left] = False
then begin
     for cpt := StringGrid1.Selection.Left  downto 0 do
     if Tableau[cpt] = False then Dep := cpt else begin Dep := cpt; break; end;
     end;

Inc(dep);
Inc(Fin);
label10.Caption := IntToStr(Dep);
label11.Caption := IntToStr(Fin);
label12.Caption := IntTostr(StringGrid1.Selection.Left+1);
label17.Caption := IntTostr(Block);
ok := False;
if RadioButton1.Checked = True
then begin
     for cpt := 0 to ListBox2.Count -1
     do if ListBox2.Items.Strings[cpt] = label17.Caption
        then begin
             ListBox1.Selected[cpt] := True;
             ListBox2.Selected[cpt] := True;
             ComboBox2.Text :=  ListBox1.Items.Strings[cpt];
             Ok := True;
             end;
     end;
if RadioButton2.Checked = True
then begin
     for cpt := 0 to ListBox2.Count -1
     do if (Dep >= StrToint(ListBox2.Items.Strings[cpt])) and (Fin <= StrToint(ListBox3.Items.Strings[cpt]))
        then begin
             ListBox1.Selected[cpt] := True;
             ListBox2.Selected[cpt] := True;
             ListBox3.Selected[cpt] := True;
             ComboBox2.Text :=  ListBox1.Items.Strings[cpt];
             Ok := True;
             end;
     end;
if Ok = False
then Begin
     ListBox1.ClearSelection;
     ListBox2.ClearSelection;
     ListBox3.ClearSelection;
     ComboBox2.Text := '';
     end;
end;

procedure TForm30.StringGrid1DblClick(Sender: TObject);
begin
if RadioButton1.Checked = True then Exit;
if tableau[StringGrid1.Selection.Left] = False
then tableau[StringGrid1.Selection.Left] := True
else tableau[StringGrid1.Selection.Left] := False;
repaintGrid(-1);
end;

procedure TForm30.Button3Click(Sender: TObject);
var i : integer;
   FieldName : String;
   VarName : String;
begin

if ComboBox2.Text = '' then Exit;

FieldName := ComboBox2.Text;
VarName := ComboBox1.Text;

if length(FieldName)>1
then begin
     if Fieldname[1] = '<' then FieldName := RightStr(FieldName,length(FieldName)-1);
     if Fieldname[length(FieldName)] = '>' then FieldName :=LeftStr(FieldName,length(FieldName)-1);
     end;
if length(VarName) >1
then begin
     if VarName[1] = '<' then VarName := RightStr(VarName,length(VarName)-1);
     if VarName[length(VarName)] = '>' then VarName :=LeftStr(VarName,length(VarName)-1);
     end;

FieldName := '<'+ VarName +'.'+FieldName+'>';

if form1.Fonction_existe_with_param(Form1.ListView1,'Variable',ComboBox2.Text,1)= True
then FieldName := ComboBox2.text
else ComboBox2.Text := FieldName;

if ListBox1.Items.Count > 5
then if MessageDlg('Le nombre de champs est limité à 6, pour obtenir plus de champs veuillez valider cette commande, puis créer en une nouvelle.',mtWarning, [mbOk], 0) = mrOk
     then Exit;
if FieldName = ComboBox1.Text
then if MessageDlg('La variable que vous voulez traiter ne peut pas être en même tant un champ.',mtError, [mbOk], 0) = mrOk
     then Exit;
for i := 0 to ListBox1.Items.Count-1 do
if FieldName = ListBox1.Items.Strings[i]
then if MessageDlg('Le champ ne peut pas se trouver plus d''une fois dans la liste.',mtError, [mbOk], 0) = mrOk
     then Exit;

ListBox1.Items.Add(FieldName);
if RadioButton1.Checked = True
then begin
     ListBox2.Items.Add(label17.Caption);
     end
else begin
     ListBox2.Items.Add(label10.Caption);
     ListBox3.Items.Add(label11.caption);
     end;
end;

procedure TForm30.ListBox1Click(Sender: TObject);
var x1,x2,i,index : integer;
    ARect : TGridRect;
    block : integer;
begin
index := GetItemSelected(listBox1);

if RadioButton1.Checked = True
then begin
     x1 := 0; x2 := 0;
     ComboBox2.Text := listBox1.Items.Strings[index];
     listbox2.Selected[index] := True;
     Block := 1;
     for i := 0 to StringGrid1.ColCount -1
     do begin
        if Tableau[i] = True then Inc(Block);
        if (x1 = 0) and (block = StrToInt(ListBox2.items.Strings[index])) then x1 := i+1;
        if (x2 = 0) and (block > StrToInt(ListBox2.items.Strings[index])) then x2 := i;
        end;
     if x2 = 0 then x2 := StringGrid1.ColCount;
     ARect.Left := x1-1;
     Arect.Right := x2-1;
     Arect.Top := 0;
     Arect.Bottom := StringGrid1.DefaultRowHeight * StringGrid1.RowCount;
     StringGrid1.Selection := Arect;
     end;

if RadioButton2.Checked = True
then begin
     ComboBox2.Text := listBox1.Items.Strings[index];
     listbox2.Selected[index] := True;
     listbox3.Selected[index] := True;
     ARect.Left := StrToInt(ListBox2.Items.Strings[index])-1;
     Arect.Right := StrToInt(ListBox3.Items.Strings[index])-1;
     Arect.Top := 0;
     Arect.Bottom := StringGrid1.DefaultRowHeight * StringGrid1.RowCount;
     StringGrid1.Selection := Arect;
     end;

if Form1.GetListBoxSelected(ListBox1)> -1
then begin
     Button4.Enabled := True;
     Button5.Enabled := True;
     end
else begin
     Button4.Enabled := False;
     Button5.Enabled := False;
     end;

end;

procedure TForm30.Button5Click(Sender: TObject);
var index : integer;
begin
index := GetItemSelected(listBox1);
if index <> -1
then begin
     ListBox1.Items.Delete(index);
     ListBox2.Items.Delete(index);
     if RadioButton1.Checked = False then ListBox3.Items.Delete(index);
     end;
end;

procedure TForm30.Button4Click(Sender: TObject);
var index : integer;
begin
index := GetItemSelected(listBox1);
if index <> -1
then begin
     ListBox1.Items.Strings[index] := ComboBox2.Text;
     if RadioButton1.Checked = True
     then begin
          ListBox2.Items.Strings[index] := label17.Caption;
          end
     else begin
          ListBox2.Items.Strings[index] := label10.Caption;
          ListBox3.Items.Strings[index] := label11.caption;
          end;
     ComboBox2.Text := '';
     end;
end;

procedure TForm30.ListBox2Click(Sender: TObject);
var index : integer;
begin
index := GetItemSelected(listBox2);
ComboBox2.Text := listBox1.Items.Strings[index];
listbox1.Selected[index] := True;
if RadioButton2.Checked = True then listbox3.Selected[index] := True;
ListBox1.OnClick(self);
end;

procedure TForm30.ListBox3Click(Sender: TObject);
var index : integer;
begin
index := GetItemSelected(listBox3);
ComboBox2.Text := listBox1.Items.Strings[index];
listbox1.Selected[index] := True;
listbox2.Selected[index] := True;
ListBox1.OnClick(self);
end;

procedure TForm30.Button1Click(Sender: TObject);
begin
Form30.Close;
end;

procedure TForm30.CheckBox1Click(Sender: TObject);
begin
if RadioButton1.Checked = True
then DelimitedAll()
else begin
     ChangeDelimited(chr(Vk_Tab),StringGrid1.TopRow);
     RepaintGrid(-1);
     end;
end;

procedure TForm30.CheckBox2Click(Sender: TObject);
begin
if RadioButton1.Checked = True
then DelimitedAll()
else begin
     ChangeDelimited(chr(Vk_Space),StringGrid1.TopRow);
     RepaintGrid(-1);
     end;
end;

procedure TForm30.CheckBox3Click(Sender: TObject);
begin
if RadioButton1.Checked = True
then DelimitedAll()
else begin
     ChangeDelimited(';',StringGrid1.TopRow);
     RepaintGrid(-1);
     end;
end;

procedure TForm30.CheckBox4Click(Sender: TObject);
begin
if RadioButton1.Checked = True
then DelimitedAll()
else begin
     ChangeDelimited(',',StringGrid1.TopRow);
     RepaintGrid(-1);
     end;
end;

procedure TForm30.CheckBox5Click(Sender: TObject);
begin
if Edit1.text <> ''
then begin
     if RadioButton1.Checked = True
     then DelimitedAll()
     else begin
          ChangeDelimited(chr(Vk_Space),StringGrid1.TopRow);
          RepaintGrid(-1);
          end;
     end;
end;

procedure TForm30.ListBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var index : integer;
begin
index := GetItemSelected(ListBox1);
if index <> -1
then begin
     ListBox1.Items.Delete(index);
     ListBox2.Items.Delete(index);
     ListBox3.Items.Delete(index);
     ComboBox2.Text := '';
     end;

end;

procedure TForm30.ListBox2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var index : integer;
begin
index := GetItemSelected(ListBox2);
if index <> -1
then begin
     ListBox1.Items.Delete(index);
     ListBox2.Items.Delete(index);
     ListBox3.Items.Delete(index);
     ComboBox2.Text := '';
     end;
end;

procedure TForm30.ListBox3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var index : integer;
begin
index := GetItemSelected(ListBox3);
if index <> -1
then begin
     ListBox1.Items.Delete(index);
     ListBox2.Items.Delete(index);
     ListBox3.Items.Delete(index);
     ComboBox2.Text := '';
     end;
end;

procedure TForm30.RadioButton2Click(Sender: TObject);
var i : Integer;
    myRect: TGridRect;
begin
if RadioButton2.Checked = True
then begin
     label1.Enabled := False;
     bevel1.Enabled := False;
     CheckBox1.Enabled := False;
     CheckBox2.Enabled := False;
     CheckBox2.Enabled := False;
     CheckBox3.Enabled := False;
     CheckBox4.Enabled := False;
     CheckBox5.Enabled := False;
     if CheckBox1.Checked = True then CheckBox1.Checked := false;
     if CheckBox2.Checked = True then CheckBox2.Checked := false;
     if CheckBox3.Checked = True then CheckBox3.Checked := false;
     if CheckBox4.Checked = True then CheckBox4.Checked := false;
     if CheckBox5.Checked = True then CheckBox5.Checked := false;
     Edit1.Enabled := False;
     for i := 0 to 1000 do tableau[i] := False;
     StringGrid1.Repaint;
     Label4.Caption := 'Position Depart';
     ListBox3.Visible := True;
     Label14.Visible := True;
     ListBox1.Clear;
     ListBox2.Clear;
     ListBox3.Clear;
     ComboBox2.Text := '';
     myrect.Left := 0;
     myrect.Right := 0;
     myrect.Top := 0;
     myrect.Bottom := 0;
     StringGrid1.Selection := myRect;
     end;
end;

procedure TForm30.RadioButton1Click(Sender: TObject);
var i : integer;
    myRect: TGridRect;
begin
if RadioButton1.Checked = True
then begin
     label1.Enabled := True;
     bevel1.Enabled := True;
     CheckBox1.Enabled := True;
     CheckBox2.Enabled := True;
     CheckBox3.Enabled := True;
     CheckBox4.Enabled := True;
     CheckBox5.Enabled := True;
     Edit1.Enabled := True;
     for i := 0 to 1000 do tableau[i] := False;
     StringGrid1.Repaint;
     Label4.Caption := 'Bloc';
     ListBox3.Visible := False;
     Label14.Visible := False;
     ListBox1.Clear;
     ListBox2.Clear;
     ListBox3.Clear;
     ComboBox2.Text := '';
     myrect.Left := 0;
     myrect.Right := 0;
     myrect.Top := 0;
     myrect.Bottom := 0;
     StringGrid1.Selection := myRect;
     end;
end;

procedure TForm30.FormClose(Sender: TObject; var Action: TCloseAction);
var myRect: TGridRect;
begin
unit1.sw_modif := False;
myrect.Left := 0;
myrect.Right := 0;
myrect.Top := 0;
myrect.Bottom := 0;
StringGrid1.Selection := myRect;
StringGrid1.ColCount := 1;
StringGrid1.RowCount := 1;
StringGrid1.Cells[0,0] := '';
ListBox1.Clear; ListBox2.Clear; ListBox3.Clear;
checkBox1.Checked := False;
checkBox2.Checked := False;
checkBox3.Checked := False;
checkBox4.Checked := False;
checkBox5.Checked := False;
Edit1.Text := '';

end;

procedure TForm30.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if Edit1.Text <> ''
then begin
     ChangeDelimited(Edit1.Text[1],StringGrid1.TopRow);
     RepaintGrid(-1);
     end;
end;

procedure TForm30.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Edit1.Text <> ''
then begin
     ChangeDelimited(Edit1.Text[1],StringGrid1.TopRow);
     RepaintGrid(-1);
     end;
end;

procedure TForm30.Button2Click(Sender: TObject);
var Param, ParamForVar : String;
    pos,i : integer;
    verif : boolean;
begin
if form1.Fonction_existe_with_param(Form1.ListView1,'Variable',ComboBox1.Text,1)= False
then begin
     MessageDlg('Vous devez obligatoirement specifier une variable à traiter.',mtError, [mbOk], 0);
     Exit;
     end;

verif := False;
Param := ComboBox1.Text + SprPr;
if RadioButton1.Checked = True
then Param := Param + 'D' + SprPr
else Param := Param + 'F' + SprPr;
if RadioButton1.Checked = True
then begin
     if CheckBox1.Checked = True then Param := Param + 'Tab' + SprPr else Param := Param + SprPr;
     if CheckBox2.Checked = True then Param := Param + 'Space' + SprPr else Param := Param + SprPr;
     if CheckBox3.Checked = True then Param := Param + 'Point virgule' + SprPr else Param := Param + SprPr;
     if CheckBox4.Checked = True then Param := Param + 'Virgule' + SprPr else Param := Param + SprPr;
     if Edit1.Text <> '' then begin
                              if CheckBox5.Checked = True
                              then Param := Param + Edit1.Text + SprPr
                              else Param := Param + SprPr;
                              end
                         else Param := Param + SprPr;

     end;
for i := 0 to ListBox1.Count -1 do
begin
Param := Param + ListBox1.Items.Strings[i] + SprPr;
Param := Param + ListBox2.Items.Strings[i] + SprPr;
if RadioButton2.Checked = True
then Param := Param + ListBox3.Items.Strings[i] + SprPr;
end;

if unit1.Sw_modif = False
then Form1.add_insert('Champs',Param,21)
else begin
     Form1.ListView1.Selected.SubItems.Strings[0] := Param;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     end;
// test si les variables listées existent sinon elles sont créées
for i := 0 to ListBox1.Items.Count -1 do
begin
if form1.Fonction_existe_with_param(Form1.ListView1,'Variable',ListBox1.items.Strings[i],1)= False
then begin
     if Verif = False then MessageDlg('Certains champs ne sont pas déclarer comme variable, ils seront créés automatiquement.',mtWarning, [mbOk], 0);
     verif := True;
     ParamForVar := ListBox1.Items.Strings[i] + SprPr + SprPr + TAlpha + SprPr;
     for pos := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[pos].Caption <> 'Variable'
     then break;
     if form1.ListView1.Items.Count <> 0
     then form1.ListView1.Items.Insert(pos)
     else begin
          form1.ListView1.Items.Add();
          pos := 0;
          end;
     form1.ListView1.Items[pos].ImageIndex := 9;
     form1.ListView1.Items[pos].Caption := 'Variable';
     form1.listView1.items.Item[pos].SubItems.Add(ParamForVar);
     unit1.sw_modif := False;
     Form1.SaveBeforeChange(form1.listView1.items.Item[pos]);
     end;
end;

Form30.Close;
end;

procedure TForm30.StringGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var i : integer;
begin
if DrawCell = False then Exit;
if CheckBox1.Checked = True
then begin
     For i := 0 to 1000 do Tableau[i] := False;

     if CheckBox1.Checked then ChangeDelimited(chr(Vk_Tab),ARow);
     if CheckBox2.Checked then ChangeDelimited(chr(Vk_Space),ARow);
     if CheckBox3.Checked then ChangeDelimited(';',ARow);
     if CheckBox4.Checked then ChangeDelimited(',',ARow);
     if (CheckBox5.Checked) and (Edit1.Text <> '') then ChangeDelimited(Edit1.Text[1],ARow);
     repaintGrid(ARow);
     end
else RepaintGrid(-1);

// if CheckBox1.Checked = True then DelimitedAll() else RepaintGrid(-1);
end;

procedure TForm30.Label20Click(Sender: TObject);
begin
if CheckBox1.Checked = True
then CheckBox1.Checked := False
else CheckBox1.Checked := True;
end;

procedure TForm30.Label21Click(Sender: TObject);
begin
if CheckBox2.Checked = True
then CheckBox2.Checked := False
else CheckBox2.Checked := True;
end;

procedure TForm30.Label22Click(Sender: TObject);
begin
if CheckBox3.Checked = True
then CheckBox3.Checked := False
else CheckBox3.Checked := True;
end;

procedure TForm30.Label23Click(Sender: TObject);
begin
if CheckBox5.Checked = True
then CheckBox5.Checked := False
else CheckBox5.Checked := True;
end;

procedure TForm30.Label24Click(Sender: TObject);
begin
if CheckBox4.Checked = True
then CheckBox4.Checked := False
else CheckBox4.Checked := True;
end;

procedure TForm30.Label18Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm30.Label19Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm30.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, False);
ComboBox1.Text := SaveText;
end;

procedure TForm30.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm30.ListBox1Enter(Sender: TObject);
begin
if Form1.GetListBoxSelected(ListBox1)> -1
then begin
     Button4.Enabled := True;
     Button5.Enabled := True;
     end
else begin
     Button4.Enabled := False;
     Button5.Enabled := False;
     end;
end;

procedure TForm30.ListBox1Exit(Sender: TObject);
begin
if Form1.GetListBoxSelected(ListBox1)> -1
then begin
     Button4.Enabled := True;
     Button5.Enabled := True;
     end
else begin
     Button4.Enabled := False;
     Button5.Enabled := False;
     end;
end;

procedure TForm30.ComboBox2Change(Sender: TObject);
var i : integer;
begin
if ComboBox2.Text <> ''
then Button3.Enabled := True
else Button3.Enabled := False;

for i := 0 to ListBox1.Items.Count-1
do if ComboBox2.Text = ListBox1.Items[i]
   then Button3.Enabled := False;
end;

end.
