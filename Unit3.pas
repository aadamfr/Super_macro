unit Unit3;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, mdlfnct;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;

implementation

{$R *.DFM}

uses unit1;

procedure TForm3.MessageAide(var msg:TMessage);
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

procedure TForm3.Button1Click(Sender: TObject);
var label_existe : boolean;
    i : integer;
    OldLabel : String;
begin
label_existe := false;

if unit1.sw_modif = false
then begin
     if form3.Caption = 'Label'
     then begin
          if combobox1.text <> ''
          then form1.add_insert('Label',combobox1.text,7);
          end
     else begin
          for i := 0 to Combobox1.Items.Count do
          if combobox1.Text = combobox1.Items.Strings[i]
          then label_existe := true;
          if ((label_existe = true) and (ComboBox1.Text <> '')) or (FnctIsInteger(combobox1.text))
          then form1.add_insert('Goto',combobox1.text,8);
          end;
     end
else begin
     OldLabel := Form1.ListView1.Selected.SubItems.Strings[0];
     Form1.ListView1.Selected.SubItems.Strings[0] := ComboBox1.text;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     end;

combobox1.Text := '';
form3.Close;

end;

procedure TForm3.Button2Click(Sender: TObject);
begin
ComboBox1.Text := '';
ComboBox1.Items.Clear;
form3.Close;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
ComboBox1.items.clear;
ComboBox1.Text := '';
if form3.Caption = 'Label' then form1.New_Label_Name(ComboBox1);
if unit1.sw_modif = true
then begin
     if form3.Caption = 'Goto'
     then begin
          Form1.List_Label(ComboBox1);
          ComboBox1.Text := form1.listview1.Selected.SubItems.Strings[0];
          end;
     if form3.Caption = 'Label'
     then begin
          ComboBox1.Text := form1.listview1.Selected.SubItems.Strings[0];
          end;
     end
else if form3.Caption = 'Goto' then begin
                                    Form1.List_Label(ComboBox1);
                                    end;
ComboBox1.SetFocus;
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

end.
