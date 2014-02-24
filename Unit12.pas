unit Unit12;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TForm12 = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Label2: TLabel;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    Bevel2: TBevel;
    ComboBox2: TComboBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image2: TImage;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form12: TForm12;

implementation

{$R *.DFM}

uses unit1, unit24, unit21, mdlfnct;

procedure TForm12.MessageAide(var msg:TMessage);
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

procedure TForm12.FormShow(Sender: TObject);
var listParam : Tparam;
    Param : String;
begin
RadioButton1.Checked := True;
Form1.List_Var(combobox1.Items, True, True);
Form1.List_Var(combobox2.Items, True, True);


if unit1.sw_modif = True
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.Text := listParam.param[1];
     ComboBox2.Text := listParam.param[3];
     if listParam.param[2] = '+' then radiobutton1.Checked := true;
     if listParam.param[2] = '-' then radiobutton2.Checked := true;
     if listParam.param[2] = '*' then radiobutton3.Checked := true;
     if listParam.param[2] = '/' then radiobutton4.Checked := true;
     end;
end;

procedure TForm12.Button1Click(Sender: TObject);
var param : string;
    type1, type2 : String;
    ok : Boolean;
begin
ok := True;
type1 := mdlfnct.FnctTypeVar(ComboBox1.text);
type2 := mdlfnct.FnctTypeVar(ComboBox2.text);

if type1 = 'No_Type'
then begin
     ok := False;
     MessageDlg('Le premier paramètre doit être obligatoirement une variable.',mtWarning,[mbOk],0);
     end;
if (type1 = TAlpha) and (RadioButton1.Checked = False)
then begin
     ok := False;
     MessageDlg('Le seul opérateur possible avec une variable Alphanumérique est celui d''addition.',mtWarning,[mbOk],0);
     end;

if (type1 = TNum) and ((type2 <> TNum) and (mdlfnct.FnctIsInteger(mdlfnct.GetValue(comboBox2.Text))= False))
then begin
     ok := False;
     MessageDlg('Vous avez séléctionné une variable numérique dans le premier paramètre, vous devez donc utiliser une valeur numérique dans le deuxième paramètre (constante ou  variable).',mtWarning,[mbOk],0);
     end;

if ok = True
then begin
     if RadioButton1.Checked then Param := ComboBox1.text+ SprPr + '+' + SprPr + ComboBox2.Text + SprPr;
     if RadioButton2.Checked then Param := ComboBox1.text+ SprPr + '-' + SprPr + ComboBox2.Text + SprPr;
     if RadioButton3.Checked then Param := ComboBox1.text+ SprPr + '*' + SprPr + ComboBox2.Text + SprPr;
     if RadioButton4.Checked then Param := ComboBox1.text+ SprPr + '/' + SprPr + ComboBox2.Text + SprPr;

     if unit1.sw_modif = false
     then form1.add_insert('Calcul',Param,12)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;

     Form12.Close;
     end;
end;

procedure TForm12.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
form12.Close;
end;

procedure TForm12.Label3Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm12.Label4Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm12.Label5Click(Sender: TObject);
begin
RadioButton3.Checked := True;
end;

procedure TForm12.Label6Click(Sender: TObject);
begin
RadioButton4.Checked := True;
end;

procedure TForm12.Image2Click(Sender: TObject);
begin
form21.Label1.Caption := 'Vous avez la possiblité de concaténer deux' +
                         ' valeurs alphanumériques avec l''opérateur d''addition.';
form21.show;
end;

procedure TForm12.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm12.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox2.Text;
Form1.List_Var(ComboBox2.Items, True, True);
ComboBox2.Text := SaveText;
end;

end.
