unit Unit11;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons;

type
  TForm11 = class(TForm)
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    RadioButton4: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Image2: TImage;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form11: TForm11;

implementation

{$R *.DFM}

uses unit1, Unit21, mdlfnct;

procedure TForm11.MessageAide(var msg:TMessage);
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

procedure TForm11.Button2Click(Sender: TObject);
begin
Form11.Close;
unit1.sw_modif := false;
end;

procedure TForm11.FormShow(Sender: TObject);
var listParam : Tparam;
    Param : String;
begin
     ComboBox1.Items.Clear;
     ComboBox2.Items.Clear;
     ComboBox1.Text := '';
     ComboBox2.Text := '';
     RadioButton1.Checked := True;

form1.List_Var(ComboBox1.Items, True, True);
form1.List_Var(ComboBox2.Items, True, True);


if unit1.sw_modif = True
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.Text := listParam.param[1];
     ComboBox2.Text := listParam.param[3];
     if listParam.param[2] = '=' then radiobutton1.Checked := true;
     if listParam.param[2] = '<' then radiobutton2.Checked := true;
     if listParam.param[2] = '>' then radiobutton3.Checked := true;
     if listParam.param[2] = '<>' then radiobutton4.Checked := true;
     end;
end;

procedure TForm11.Button1Click(Sender: TObject);
var Param : String;
    type1 : String;
    ok : Boolean;
begin
ok := True;
type1 := mdlfnct.FnctTypeVar(ComboBox1.text);

if type1 = 'No_Type'
then begin
     ok := False;
     MessageDlg('Le premier paramètre doit être obligatoirement une variable.',mtWarning,[mbOk],0);
     end;

if ok = True
then begin
     if RadioButton1.Checked then Param := ComboBox1.text+ SprPr + '=' + SprPr + ComboBox2.Text + SprPr;
     if RadioButton2.Checked then Param := ComboBox1.text+ SprPr + '<' + SprPr + ComboBox2.Text + SprPr;
     if RadioButton3.Checked then Param := ComboBox1.text+ SprPr + '>' + SprPr + ComboBox2.Text + SprPr;
     if RadioButton4.Checked then Param := ComboBox1.text+ SprPr + '<>'+ SprPr + ComboBox2.Text + SprPr;

     if unit1.sw_modif = false
     then form1.add_insert('Examine',Param,11)
     else begin
          form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;
     
     Form11.Close;
     end;
end;

procedure TForm11.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm11.Label3Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm11.Label4Click(Sender: TObject);
begin
RadioButton4.Checked := True;
end;

procedure TForm11.Label5Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm11.Label6Click(Sender: TObject);
begin
RadioButton3.Checked := True;
end;

procedure TForm11.Image1Click(Sender: TObject);
begin
form21.label1.caption := 'Les deux prochaines commandes appartiennent à la commande examine,' +
                         ' si la condition est vraie, alors la première commande sera exécutée, '+
                         'sinon se sera la seconde.';
form21.Show;
end;

procedure TForm11.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm11.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox2.Text;
Form1.List_Var(ComboBox2.Items, True, True);
ComboBox2.Text := SaveText;
end;

end.
