unit Unit9;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TForm9 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox1DropDown(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form9: TForm9;

implementation

uses Unit1, Unit21;

{$R *.DFM}

procedure TForm9.MessageAide(var msg:TMessage);
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

procedure TForm9.FormShow(Sender: TObject);
var listParam : Tparam;
begin
activeControl := ComboBox2;
ComboBox1.Items.Clear;
ComboBox1.Text := '';
ComboBox2.Text := '';
ComboBox3.Text := '';
form1.List_Var(ComboBox1.Items, True, True);
form1.List_Var(ComboBox2.Items, True, True);
form1.List_Var(ComboBox3.Items, True, True);
if unit1.sw_modif = true
then begin
     if Form1.ListView1.Selected <> nil
     then listParam := form1.GetParam(form1.listview1.Selected.SubItems.Strings[0]);
     ComboBox2.Text := ListParam.param[1];
     ComboBox3.Text := ListParam.param[2];
     ComboBox1.Text := ListParam.param[3];
     end;
end;

procedure TForm9.Button2Click(Sender: TObject);
begin
unit1.sw_modif := false;
Form9.Close;
end;

procedure TForm9.Button1Click(Sender: TObject);
var Param : String;
begin
if form9.Caption = 'Message'
then begin
     param := ComboBox2.text + SprPr + ComboBox3.text + SprPr;
     if Unit1.sw_modif = false
     then form1.add_insert('Message',Param,30)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;
     end
else begin
     param := ComboBox2.text + SprPr + ComboBox3.text + SprPr + ComboBox1.Text+ SprPr;
     if Unit1.sw_modif = false
     then form1.add_insert('Question',Param,10)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;
     end;

Form9.ComboBox2.Text := '';
Form9.ComboBox3.Text := '';
Form9.ComboBox1.Text := '';
form9.close;
end;

procedure TForm9.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm9.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
if not (sender is TComboBox) then Exit;
SaveText := TComboBox(Sender).Text;
Form1.List_Var(TComboBox(Sender).Items, True, True);
TComboBox(Sender).Text := SaveText;
end;

end.
