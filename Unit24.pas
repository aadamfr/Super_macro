unit Unit24;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls, printers, Buttons, SysConst, Consts,
  StrUtils, Math;

type
  TForm24 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    ListBox1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //procedure List_Var(Sender: TObject; Alpha, Num : Boolean);
    procedure ListBox1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function  TestCalculEvol(Param : String; ToVar : Boolean) : String;
    function  GetValueVar(Arg : String): String;
    procedure Edit1Change(Sender: TObject);
    procedure SpeedButton18Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    procedure SpeedButton17Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  procedure EmptyTabVal(var tab : array of string);
  end;

var
  Form24: TForm24;
  resultat : String;
  FirstType : string;
  RsltText : string;



implementation

uses Unit1, Unit19, mdlfnct;

{$R *.DFM}

procedure TForm24.MessageAide(var msg:TMessage);
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

procedure TForm24.EmptyTabVal(var tab : array of string);
var i,j : integer;
begin
for i := Low(tab) to High(tab)
do begin
   if tab[i] = ''
   then for j := i to High(tab)-1
        do begin
           tab[j] := tab[j+1];
           end;
   end;
end;

function TForm24.GetValueVar(Arg : String): String;
var i : integer;
    ListParam : Tparam;
begin
//result := mdlfnct.GetValue(Arg);
result := Arg;
for i := 0 to Form1.ListView1.Items.Count -1 do
if Form1.ListView1.Items.Item[i].Caption = 'Variable'
then begin
     ListParam := mdlfnct.GetParam(Form1.ListView1.Items.Item[i].SubItems[0]);
     if ListParam.param[1] = Arg
     then begin
          if (ListParam.param[1] = ListParam.param[2]) and (ListParam.param[3] = 'Numerique')
          then result := '0'
          else result := ListParam.param[2];
          end;
     end;
end;

function TForm24.TestCalculEvol(Param : String; ToVar : Boolean) : String;
var valnr,i,j : integer;
    Inttmp : real;
    strtmp : String;
    car : char;
    change  : boolean;
    tabVal : array[1..31] of string;
    tabVar : array[1..31] of string;
begin
try
result := '';
resultat := '';
for i := 1 to 31 do tabval[i] := '';
j := 1;

for i := 1 to length(Param)
do begin
   car := param[i];
   if (car = '+') or (car = '-') or (car = '/') or (car = '*') or (car = '=') or (car = '^')
   then begin
        if tabval[j] <> '' then inc(j);
        if j > 30
        then begin
             if ToVar = False then result := 'Expression ne peut pas contenir plus de 30 éléments (opérateurs et opérandes).';
             Exit;
             end;
        tabval[j] := car;
        inc(j);
        continue;
        end;
   // else
   tabval[j] := tabval[j] + car;
   end;

valnr := j;

FirstType := FnctTypeVar(Trim(tabval[1]));
if FirstType = TNo
then begin
     if ToVar = False then result := 'Le premier élément de l''expression doit obligatoirement être une variable.';
     Exit;
     end;

for j := 1 to valnr
do begin
   Strtmp := Trim(tabval[j]);
   if (FnctTypeVar(StrTmp) <> TNo)
   then tabval[j] := StrTmp;
   end;

for i := low(TabVal) to High(TabVal)
do TabVar[i] := TabVal[i];

// remplace les variables par leur valeur
// si ToVar = False -> Valeur d'initialisation des variables
// sinon valeur réél
for i := 2 to valnr
do if ToVar = False
   then tabval[i] := GetValueVar(tabval[i])
   else tabval[i] := GetValue(tabval[i]);

if FirstType = TAlpha
then begin
     if tabval[2] = '=' then Strtmp := '' else Strtmp := GetValueVar(tabval[1]);
     for i := 3 to valnr
     do begin
        if tabval[i] <> '+' then Strtmp := Strtmp + tabval[i];
        if (tabval[i-1] = '+') and (tabval[i] = '+') and (tabval[i+1] = '+')
        then Strtmp := Strtmp + '+';
        end;
     resultat := Strtmp;
     if ToVar = True
     then form1.WriteVariable('VAR',tabval[1],Strtmp);
     end;

if FirstType = TNum
then begin
     // test si le - suivant appartient a la valeur numérique suivante
     repeat
     for i := 1 to 28
     do begin
        change := False;
        if ((tabval[i] = '^') and (tabval[i+1] = '-')) then begin tabval[i+2] := '-' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '*') and (tabval[i+1] = '-')) then begin tabval[i+2] := '-' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '/') and (tabval[i+1] = '-')) then begin tabval[i+2] := '-' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '^') and (tabval[i+1] = '+')) then begin tabval[i+2] := '+' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '*') and (tabval[i+1] = '+')) then begin tabval[i+2] := '+' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '/') and (tabval[i+1] = '+')) then begin tabval[i+2] := '+' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '=') and (tabval[i+1] = '-')) then begin tabval[i+2] := '-' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '=') and (tabval[i+1] = '+')) then begin tabval[i+2] := '+' + tabval[i+2]; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '-') and (tabval[i+1] = '-')) then begin tabval[i] := '+'; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '+') and (tabval[i+1] = '-')) then begin tabval[i] := '-'; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '-') and (tabval[i+1] = '+')) then begin tabval[i] := '-'; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        if ((tabval[i] = '+') and (tabval[i+1] = '+')) then begin tabval[i] := '+'; tabval[i+1] := ''; EmptyTabVal(tabval); change := True end;
        end;
     until change = False;

     // initialisation de la valeur de départ
     if ToVar = True
     then begin
          if tabval[2] = '=' then Inttmp := 0 else Inttmp := Form1.StrToFloat(GetValue(tabval[1]));
          end
     else begin
          if tabval[2] = '=' then Inttmp := 0 else Inttmp := Form1.StrToFloat(GetValueVar(tabval[1]));
          end;
     // traitement des opérateurs *, /, ^
     for i := 3 to valnr do
     begin
     if tabval[i] = '*'
     then begin
          if (tabval[i-1] = '') or (tabval[i+1] = '') then  continue;
          if FnctIsFloat(tabval[i-1]) = False then begin result := 'La valeur ' + tabval[i-1] + ' n''est pas un nombre entier.'; Exit; end;
          if FnctIsFloat(tabval[i+1]) = False then begin result := 'La valeur ' + tabval[i+1] + ' n''est pas un nombre entier.'; Exit; end;
          tabval[i+1] := FloatToStr(Form1.StrToFloat(tabval[i-1]) * Form1.StrToFloat(tabval[i+1]));
          tabval[i-1] := ''; tabval[i] := '';
          end;

     if tabval[i] = '^'
     then begin
          if (tabval[i-1] = '') or (tabval[i+1] = '') then  continue;
          if FnctIsFloat(tabval[i-1]) = False then begin result := 'La valeur ' + tabval[i-1] + ' n''est pas un nombre entier.'; Exit; end;
          if FnctIsFloat(tabval[i+1]) = False then begin result := 'La valeur ' + tabval[i+1] + ' n''est pas un nombre entier.'; Exit; end;
          tabval[i+1] := FloatToStr(Trunc(Power(Form1.StrToFloat(tabval[i-1]), Form1.StrToFloat(tabval[i+1]))));
          tabval[i-1] := ''; tabval[i] := '';
          end;

     if tabval[i] = '/'
     then begin
          if (tabval[i-1] = '') or (tabval[i+1] = '') then  continue;
          if FnctIsFloat(tabval[i-1]) = False then begin result := 'La valeur ' + tabval[i-1] + ' n''est pas un nombre entier.'; Exit; end;
          if FnctIsFloat(tabval[i+1]) = False then begin result := 'La valeur ' + tabval[i+1] + ' n''est pas un nombre entier.'; Exit; end;
          if Form1.StrToFloat(tabval[i+1]) = 0
          then begin
               if (TabVar[i+1] <>'0') and (ToVar = False)
               then begin resultat := 'Attention au risque de division par zéro lié à la variable '+ TabVar[i+1]; Exit; end;
               if ToVar = False then result := SDivByZero
               else Form1.ErrorComportement(SDivByZero);
               Exit;
               end;
          tabval[i+1] := SysUtils.FloatToStr(Form1.StrToFloat(tabval[i-1]) / Form1.StrToFloat(tabval[i+1]));
          tabval[i-1] := ''; tabval[i] := '';
          end;
     end;

     for i := 3 to valnr
     do if tabval[i] = ''
        then for j := i to valnr
             do if tabval[j] <> ''
                then begin
                     tabval[i] := tabval[j];
                     tabval[j] := '';
                     break;
                     end;

// calcul le nombre d'operateur et operande dans la liste
     for i := 1 to 31
     do if tabval[i] <> '' then valnr := i else break;


     for i := 3 to valnr
     do begin
        if tabval[i] = ''  then begin if ToVar = False then result := 'Expression à compléter.'; Exit; end;
        if tabval[i] = '/' then begin if ToVar = False then result := 'Expression à compléter.'; Exit; end;
        if tabval[i] = '*' then begin if ToVar = False then result := 'Expression à compléter.'; Exit; end;
        if tabval[i] = '^' then begin if ToVar = False then result := 'Expression à compléter.'; Exit; end;

        if (FnctIsFloat(tabval[i]) = false) and not((tabval[i] = '+') or (tabval[i] = '-') or (tabval[i] = '='))
        then begin if ToVar = False then result := (tabval[i] + ' n''est pas une valeur numérique correct.'); Exit; end;
        if tabval[i-1] = '+' then Inttmp := Inttmp + Form1.StrToFloat(tabval[i]);
        if tabval[i-1] = '-' then Inttmp := Inttmp - Form1.StrToFloat(tabval[i]);
        if tabval[i-1] = '=' then Inttmp := Inttmp + Form1.StrToFloat(tabval[i]);
        end;

     resultat := FloatToStr(IntTmp);
     if ToVar = True then form1.WriteVariable('VAR',tabval[1],FloatToStr(Inttmp));

     end;
except on E: EConvertError do Form1.ErrorComportement(E.Message); end;

end;

{procedure TForm24.List_Var(Sender: TObject; Alpha, Num : Boolean);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
    existe : Boolean;
begin
if Sender is TListBox
then begin
     (Sender as TListBox).Items.Clear;
     for i := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[i].Caption = 'Variable'
     then begin
          existe := false;
          var_list := form1.listView1.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);

          for j := 0 to (Sender as TListBox).Items.Count -1 do
          if (Sender as TListBox).Items.Strings[j] = ListParam.param[1]
          then existe := true;

          if (ListParam.param[3] = TAlpha) and ( Alpha = False) then existe := True;
          if (ListParam.param[3] = TNum) and ( Num = False) then existe := True;

          if existe = False then (Sender as TListBox).Items.Add(ListParam.param[1]);
          end;
     end;

end;}

procedure TForm24.Button1Click(Sender: TObject);
begin

if unit1.sw_modif = False
then begin
     form1.add_insert('Calcul évolué',Edit1.text,26);
    end
else begin
     Form1.ListView1.Selected.SubItems.Strings[0] := Edit1.text;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     end;
form24.Close;
end;

procedure TForm24.Button2Click(Sender: TObject);
begin
form24.Close;
end;

procedure TForm24.FormShow(Sender: TObject);
begin
Form1.List_Var(ListBox1.Items, true,true);

//ListBox1.Items.Add('Sin');
//ListBox1.Items.Add('Cos');
//ListBox1.Items.Add('Tag');
//ListBox1.Items.Add('Pi');
Edit1.Text := '';
if unit1.sw_modif
then Edit1.Text := Form1.listview1.Selected.SubItems.Strings[0];

Edit1.SetFocus;
if Edit1.Text = ''
then begin
     Label3.caption := 'Expression';
     Label3.Font.Color := clBlack;
     end;
if ListBox1.Items.Count = 0
then begin
     Button1.Enabled := False;
     RsltText := 'Pour utiliser cette commande vous devez avoir au moins une variable.';
     Memo1.Clear;
     Memo1.Lines.Add(RsltText);
     end
else begin
     Button1.Enabled := True;
     RsltText := 'Vide';
     Memo1.Clear;
     Memo1.Lines.Add(RsltText);
     end;

if (unit1.sw_modif) and (ListBox1.Items.Count <> 0)
then begin
     TestCalculEvol(Edit1.Text,False);
     RsltText := resultat;
     Memo1.Clear;
     Memo1.Lines.Add(RsltText);
     end; 
end;

procedure TForm24.ListBox1DblClick(Sender: TObject);
var i : integer;
begin
for i := 0 to ListBox1.Count -1 do
if ListBox1.Selected[i] = true then break;
edit1.SelText := ListBox1.Items[i];

end;

procedure TForm24.SpeedButton1Click(Sender: TObject);
begin
edit1.SelText := (sender as TSpeedButton).Caption;
end;

procedure TForm24.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm24.Edit1Change(Sender: TObject);
begin
RsltText := TestCalculevol(Edit1.Text, False);
Memo1.Clear;
Memo1.Lines.Add(RsltText);

if RsltText = ''
then begin
     Label3.Caption := 'Expression valide';
     Label3.Font.Color := clGreen;
     RsltText := resultat;
     Memo1.Clear;
     Memo1.Lines.Add(RsltText);
     Button1.Enabled := True;
     end
else begin
     Label3.Caption := 'Expression invalide';
     Label3.Font.Color := clRed;
     Button1.Enabled := False;
     end;
if FirstType = TAlpha
then begin
     SpeedButton3.Enabled := False;
     SpeedButton4.Enabled := False;
     SpeedButton5.Enabled := False;
     end;
if FirstType = TNum
then begin
     SpeedButton3.Enabled := True;
     SpeedButton4.Enabled := True;
     SpeedButton5.Enabled := True;
     end;
end;

procedure TForm24.SpeedButton18Click(Sender: TObject);
begin
edit1.SelStart := edit1.SelStart +1;
end;

procedure TForm24.SpeedButton16Click(Sender: TObject);
begin
edit1.SelText := '^';
end;

procedure TForm24.SpeedButton17Click(Sender: TObject);
begin
edit1.SelStart := edit1.SelStart -1;
end;

end.
