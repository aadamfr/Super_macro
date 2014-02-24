unit Unit25;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, MSScriptControl_TLB, StdCtrls, mdlfnct, ExtCtrls,
  Buttons, ShellAPI, StrUtils, ComObj, ComCtrls;

type
  TForm25 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    ComboBox2: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Bevel1: TBevel;
    SpeedButton1: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    function MSScriptEval(Expr : String) : Variant;
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
    function MSScriptIsBoolean(index : integer; ListView : TListView) : Boolean;
  end;

var
  Form25: TForm25;
  ScriptControl1 : Variant;
implementation

uses Unit1, Unit2;

{$R *.dfm}

procedure TForm25.MessageAide(var msg:TMessage);
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

procedure TForm25.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm25.Button2Click(Sender: TObject);
begin
form25.Close;
end;

procedure TForm25.Button1Click(Sender: TObject);
begin
if unit1.sw_modif = false
then begin
     form1.add_insert('ScriptEval',ComboBox1.text + SprPr + ComboBox2.text + SprPr + Edit1.Text,27);
    end
else begin
     form1.ListView1.Selected.SubItems.Strings[0] := ComboBox1.text + SprPr + ComboBox2.text + SprPr + Edit1.Text;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     unit1.sw_modif := false;
     end;

ComboBox1.text := '';
form25.close;
end;

procedure TForm25.FormShow(Sender: TObject);
var ListParam : TParam;
    AllParam : string;
    i : integer;
begin
Form1.List_Var(ComboBox2.Items, True, True);

if unit1.sw_modif
then begin
     AllParam := form1.ListView1.Selected.SubItems[0];
     ListParam := form1.GetParam(AllParam);
     if ListParam.Param[1] = 'VBScript'
     then Combobox1.ItemIndex := 1
     else Combobox1.ItemIndex := 0;
     ComboBox2.Text := ListParam.Param[2];
     i := length(AllParam) - (length(ListParam.Param[1]) + length(ListParam.Param[2])+2);
     Edit1.Text := RightStr(AllParam,i);
     Edit1.OnChange(self);
     end
else begin
     Combobox1.ItemIndex := 0;
     ComboBox2.Text := '';
     Edit1.Text := '';
     end;
end;

function TForm25.MSScriptIsBoolean(index : integer; ListView : TListView) : Boolean;
var i : integer;
    Expr : String;
    ListParam : Tparam;
    RVariant : Variant;
begin
ListParam := form1.GetParam(ListView.Items[index].SubItems[0]);
ScriptControl1.Language := ListParam.param[1];
Expr := ListParam.param[3];
for i := 0 to ListView.Items.Count-1
do if ListView.Items[i].Caption = 'Variable'
   then begin
        ListParam := form1.GetParam(ListView.Items[i].SubItems[0]);
        if ListParam.param[3] = TNum
        then Expr := StringReplace(Expr, ListParam.param[1], '1', [rfReplaceAll])
        else Expr := StringReplace(Expr, ListParam.param[1], '"1"', [rfReplaceAll]);
        end;
try
RVariant := ScriptControl1.Eval(Expr);
finally result := VarIsType(RVariant,varBoolean) end;

end;

function TForm25.MSScriptEval(Expr : String) : Variant;
var expression : string;
    i : integer;
    ListParam : TParam;
    ValueOfVar : string;
    ListVar : TStringList;
    ListView : TListView;
begin
result := '';
if not Form1.SpeedButton37.Enabled then Exit;

ListParam := form1.GetParam(Expr);
i := length(Expr) - (length(ListParam.Param[1]) + length(ListParam.Param[2])+2);
expression := RightStr(Expr,i);

ListVar := TStringList.Create;
try
// chargement des variables de la macro principale
Form1.List_Var(ListVar, True, True);
ListVar.Sort;
for i := ListVar.Count-1 downto 0
do begin
   ValueOfVar := mdlfnct.GetValue(ListVar[i]);
   //if mdlfnct.FnctTypeVar(ListVar[i]) = TAlpha
   //then ValueOfVar := '"'+ValueOfVar+'"';
   //if mdlfnct.FnctTypeVar(ListVar[i]) = TNum
   //then ValueOfVar := ' '+ValueOfVar+' ';
   if FnctIsFloat(ValueOfVar) = True
   then ValueOfVar := ' '+ValueOfVar+' '
   else ValueOfVar := '"'+ValueOfVar+'"';

   expression := StringReplace(expression, ListVar[i],ValueOfVar, [rfReplaceAll]);
   end;

// chargement des variables de la sous-macro
Form1.GetActiveMacro(ListView,i);
if ListView <> form1.ListView1
then begin
     Form1.List_Var(ListVar, True, True,ListView);
     ListVar.Sort;
     for i := ListVar.Count-1 downto 0
     do begin
        ValueOfVar := mdlfnct.GetValue(ListVar[i]);
        if FnctIsFloat(ValueOfVar) = True
        then ValueOfVar := ' '+ValueOfVar+' '
        else ValueOfVar := '"'+ValueOfVar+'"';
        expression := StringReplace(expression, ListVar[i],ValueOfVar, [rfReplaceAll]);
        end;
     end;

finally ListVar.Free; end;

ScriptControl1.Language := ListParam.param[1];
try
ScriptControl1.Eval('result=""');
result := ScriptControl1.Eval(expression);

except Form1.ErrorComportement(ScriptControl1.Error.Description + '. code ['+ IntToStr(ScriptControl1.Error.Number)+']');
end;
end;


procedure TForm25.Edit1Change(Sender: TObject);
var expression : string;
    resultat : Variant;
    i : integer;
begin
if not Form1.SpeedButton37.Enabled then Exit;

ScriptControl1.Language := Combobox1.Text;
expression := edit1.Text;
for i := 0 to ComboBox2.Items.Count-1
do expression := StringReplace(expression, ComboBox2.Items[i],form1.GetInitialValueofVar(ComboBox2.Items[i],'"'), [rfReplaceAll]);

try
Label2.Caption := 'Expression';
comboBox2.Enabled := True;
Label3.Enabled := True;

ScriptControl1.Eval('result=""');
resultat := ScriptControl1.Eval(expression);
label4.Caption := resultat;

if VarType(resultat) = varBoolean
then begin
     Label2.Caption := 'Expression Booléenne';
     comboBox2.Enabled := False;
     Label3.Enabled := False;
     end;
except label4.Caption := ScriptControl1.Error.Description + ' code ['+ IntToStr(ScriptControl1.Error.Number)+'].';
       Label2.Caption := 'Expression invalide';
end;
end;

procedure TForm25.SpeedButton1Click(Sender: TObject);
begin
if ComboBox1.Text = 'JScript'
then ShellExecute(handle,'Open',Pchar('http://www.host-web.com/iishelp/JScript/htm/JStoc.htm'),'','',SW_SHOWNORMAL)
else ShellExecute(handle,'Open',Pchar('http://www.host-web.com/iishelp/VBScript/htm/VBStoc.htm'),'','',SW_SHOWNORMAL);
end;

procedure TForm25.FormCreate(Sender: TObject);
begin
try
Form1.SpeedButton37.enabled := True;
ScriptControl1 := CreateOleObject('MSScriptControl.ScriptControl');
ScriptControl1.AllowUI := True;
except ScriptControl1 := Unassigned; Form1.SpeedButton37.enabled := False; end;
end;

end.
