unit Unit15;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TForm15 = class(TForm)
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    OpenDialog1: TOpenDialog;
    ComboBox3: TComboBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Bevel1: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Label6Click(Sender: TObject);
    procedure ComboBox3DropDown(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form15: TForm15;

implementation

uses Unit1, Unit13, mdlfnct;

{$R *.DFM}

procedure TForm15.MessageAide(var msg:TMessage);
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

procedure TForm15.FormShow(Sender: TObject);
var listParam : Tparam;
    param : string;
begin
Form1.List_Var(ComboBox1.Items, True, True);
Form1.List_Var(ComboBox2.Items, True, True);
Form1.List_Var(ComboBox3.Items, True, False);
if unit1.sw_modif
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     if form1.listview1.Selected.Caption = 'Lire'
     then begin RadioButton1.Checked := True; RadioButton1.OnClick(self); end
     else begin RadioButton2.Checked := True; RadioButton2.OnClick(self); end;
     comboBox3.Text := listParam.Param[1];
     comboBox1.Text := listParam.Param[2];
     comboBox2.Text := listParam.Param[3];
     end
else begin
     RadioButton1.Checked := True;
     RadioButton1.OnClick(self);
     comboBox3.Text := '';
     comboBox1.Text := '';
     comboBox2.Text := '';
     end;
end;

procedure TForm15.Button2Click(Sender: TObject);
begin
form15.Close;
end;

procedure TForm15.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm15.Button1Click(Sender: TObject);
var Param : String;
    ok : Boolean;
begin
Ok := True;
if ComboBox3.Text = ''
then begin
     MessageDlg('Vous devez obligatoirement spécifier un nom de fichier, ou une variable.',mtWarning,[mbok],0);
     Ok := False;
     end;

if (mdlfnct.FnctTypeVar(ComboBox1.Text) = TNo) and (RadioButton1.Checked = True)
then begin
     MessageDlg('Le paramètre Variable Lire doit être une variable déclarée.',mtWarning,[mbok],0);
     Ok := False;
     end;


if Ok = True
then begin
     Param := comboBox3.Text+ SprPr + ComboBox1.Text+ SprPr + ComboBox2.Text + SprPr ;

     if unit1.sw_modif = false
     then if RadioButton1.Checked
          then form1.add_insert('Lire',Param,16)
          else form1.add_insert('Ecrire',Param,16)
     else begin
          if RadioButton1.Checked = True
          then Form1.ListView1.Selected.Caption := 'Lire'
          else Form1.ListView1.Selected.Caption := 'Ecrire';
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;
     Form15.Close;
     end;
end;

procedure TForm15.SpeedButton1Click(Sender: TObject);
begin
if openDialog1.Execute
then comboBox3.Text := Opendialog1.FileName;

end;

procedure TForm15.RadioButton1Click(Sender: TObject);
begin
if RadioButton1.Checked = True
then begin ComboBox2.Enabled := True; if FnctIsInteger(ComboBox2.Text) =False then ComboBox2.Text := '1'; Form15.HelpContext := 1094; end
else begin ComboBox2.Enabled := False; ComboBox2.Text := ''; Form15.HelpContext := 1095; end;
end;

procedure TForm15.RadioButton2Click(Sender: TObject);
begin
if RadioButton1.Checked = True
then ComboBox2.Text := '1' else ComboBox2.Text := '';
Form15.HelpContext := 1095;
end;

procedure TForm15.Label5Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm15.Label6Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm15.ComboBox3DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox3.Text;
Form1.List_Var(ComboBox3.Items, True, False);
ComboBox3.Text := SaveText;
end;

procedure TForm15.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm15.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox2.Text;
Form1.List_Var(ComboBox2.Items, True, True);
ComboBox2.Text := SaveText;
end;

end.

