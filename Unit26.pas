unit Unit26;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComObj, ExtCtrls;

type
  TForm26 = class(TForm)
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Image1: TImage;
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Public declarations }
  end;

var
  Form26: TForm26;

implementation

uses Unit1,ModuleSup;

{$R *.dfm}

procedure TForm26.MessageAide(var msg:TMessage);
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

procedure TForm26.Button2Click(Sender: TObject);
begin
form26.Close;
end;

procedure TForm26.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm26.FormShow(Sender: TObject);
begin
Form1.List_Var(ComboBox1.Items, True, False);
ComboBox1.Items.Add('http://www.');
ComboBox1.Items.Add('mailto:nom@domain.fr');
AddAdrExeList(Form26.ComboBox1);
if unit1.sw_modif = true
then ComboBox1.Text := form1.ListView1.Selected.SubItems.Strings[0]
else ComboBox1.Text := '';
ComboBox1.SetFocus;
end;

procedure TForm26.Button1Click(Sender: TObject);
var ok : Boolean;
begin
ok := True;
if ComboBox1.Text = ''
then begin
     MessageDlg('Le paramètre de la commande exécute ne peut pas être vide.',mtWarning,[mbOk],0);
     Ok := False;
     end;
if ComboBox1.Text = 'http://www.'
then begin
     MessageDlg('Le paramètre "http://www." n''est pas complet, veuillez completer l''adresse.',mtWarning,[mbOk],0);
     Ok := False;
     end;
if Ok = True
then begin
     if unit1.sw_modif = False
     then Form1.add_insert('Execute',ComboBox1.Text,5)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := ComboBox1.text;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;
     form26.Close;
     end;
end;

procedure TForm26.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, False);
ComboBox1.Items.Add('http://www.');
ComboBox1.Items.Add('mailto:nom@domain.fr');
AddAdrExeList(Form26.ComboBox1);
ComboBox1.Text := SaveText;
end;

procedure TForm26.Button3Click(Sender: TObject);
begin
if Form1.Opendialog2.Execute then
ComboBox1.text := Form1.OpenDialog2.FileName;
end;

end.
