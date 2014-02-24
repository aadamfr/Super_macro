unit Unit32;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

//const Key1 = 12; key2 = 6; key3 = 7; key4 = 27;
const Key1 = 13; key2 = 17; key3 = 11; key4 = 27;

type
  TForm32 = class(TForm)
    Edit1: TEdit;
    Image1: TImage;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Label2: TLabel;
    function Crypte(text:string):string;
    function Decrypte(text:string):string;
    function GetPass(filename : String) : string;
    function Validation(filename : String) : integer;
    function IsCrypted(filename : String) : Boolean;
    function IsCryptedSourceOnly(filename : String) : Boolean;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Label2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form32: TForm32;
  key : String = '';
  oldKey : String = '';
  SourceOnly : Boolean = False;
  attendre : boolean = False;
  annuler : boolean = False;
implementation

uses Unit1;

{$R *.dfm}

procedure TForm32.MessageAide(var msg:TMessage);
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

function Tform32.Validation(filename : String) : integer;
begin
result := 1;
if GetPass(filename) <> ''
then begin
     unit1.Form32Text := 1;
     attendre := True;
     form32.ShowModal;
     while attendre = True
     do begin
        SleepEx(500,false);
        Application.ProcessMessages
        end;
     If Edit1.Text = Key then Validation := 1 else Validation := 0;
     if Annuler = True then begin validation := 2; annuler := False; end;
     Edit1.Text := '';
     end;
end;

function TForm32.Crypte(text:string):string;
var
pos:integer;
text1:string;
a:integer;
begin
        if Key = '' then Exit;
        text1 := text;
        for pos := 1 to length(text1)
        do begin
           a := 0;
           if pos mod 2 = 0 then a := key1;
           if pos mod 3 = 0 then a := key2;
           if pos mod 5 = 0 then a := key3;
           if a = 0 then a := key4;
           text1[pos] := chr(ord(text1[pos]) + a);
           end;
        crypte := text1;
end;

function TForm32.decrypte(text:string):string;
var pos:integer;
    text1:string;
    a:integer;
begin
        text1 := text;
        for pos := 1 to length(text1)
        do begin
           a := 0;
           if pos mod 2 = 0 then a := key1;
           if pos mod 3 = 0 then a := key2;
           if pos mod 5 = 0 then a := key3;
           if a = 0 then a := key4;
           text1[pos] := chr(ord(text1[pos]) - a);
           end;
        result := text1;
end;

procedure TForm32.FormShow(Sender: TObject);
begin
OldKey := '';
checkBox1.Visible := False;
Label2.Visible := False;
if unit1.Form32Text = 0
then begin
     form32.Text := 'Cryptage d''une macro';
     CheckBox1.Visible := True;
     Label2.Visible := True;
     SourceOnly := IsCryptedSourceOnly(Form1.StatusBar1.Panels[0].text);
     CheckBox1.Checked := SourceOnly;
     end;

if unit1.Form32Text = 1 then form32.Text := 'Decryptage d''une macro';
Annuler := False;
Form32.ActiveControl :=  Edit1;
end;

function TForm32.Getpass(filename : String) : string;
var file_macro : File of TOrdre;
    Ordre : TOrdre;
begin
assignfile(file_macro,filename);
FileMode := 0;
reset(file_macro);
try
result := '';
while not eof(file_macro)
do begin
   read(file_macro,Ordre);
   if decrypte(Ordre.commande) = 'Info'
   then begin
        result := decrypte(Ordre.textparam);
        key := decrypte(Ordre.textparam);
        exit;
        end;
   end;
finally closeFile(File_macro); FileMode := 2; end;
end;

function TForm32.IsCrypted(filename : String) : Boolean;
var file_macro : File of TOrdre;
    Ordre : TOrdre;
begin
result := False;
if not fileExists(filename) then exit;
assignfile(file_macro,filename);
FileMode := 0;
reset(file_macro);
try
while not eof(file_macro)
do begin
   read(file_macro,Ordre);
   if decrypte(Ordre.commande) = 'Info'
   then begin
        if decrypte(Ordre.textparam) <> ''
        then begin result := True; break; end;
        end;
   end;
form1.StatusBar1.Repaint;
finally CloseFile(File_macro); FileMode := 2; end;
end;

function TForm32.IsCryptedSourceOnly(filename : String) : Boolean;
var file_macro : File of TOrdre;
    Ordre : TOrdre;
begin
result := False;
if not fileExists(filename) then exit;
assignfile(file_macro,filename);
FileMode := 0;
reset(file_macro);
try
while not eof(file_macro)
do begin
   read(file_macro,Ordre);
   if decrypte(Ordre.commande) = 'Infos'
   then begin
        if decrypte(Ordre.textparam) = 'True'
        then begin result := True; break; end;
        end;
   end;
form1.StatusBar1.Repaint;
finally CloseFile(File_macro);  FileMode := 2; end;
end;

procedure TForm32.Button2Click(Sender: TObject);
begin
annuler := True;
form32.Close;
end;

procedure TForm32.Button1Click(Sender: TObject);
begin
OldKey  := Key;
if (unit1.Form32Text = 0) and (label1.Caption = 'Mot de passe')
then begin
     key := Edit1.Text;
     Edit1.Text := '';
     label1.Caption := 'Confirmation du mot de passe';
     Edit1.SetFocus;
     Exit;
     end;
if (unit1.Form32Text = 0) and (label1.Caption = 'Confirmation du mot de passe')
then if Key = Edit1.Text
     then begin
          MessageDlg('Le cryptage de votre macro prendra effet lors de votre prochain enregistrement.',mtInformation, [mbOk], 0);
          form32.Close;
          end
     else begin
          MessageDlg('La confirmation du mot de passe n''est pas correcte, veuillez  renouveller l''opération.',mtwarning, [mbOk], 0);
          Key := OldKey;
          form32.Close;
          end;
if (unit1.Form32Text = 1)
then begin
     form32.Close;
     Exit;
     end;
Edit1.Text := '';
label1.Caption := 'Mot de passe';
end;

procedure TForm32.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Attendre := False;
end;

procedure TForm32.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if key = vk_return then button1.Click;
end;

procedure TForm32.Label2Click(Sender: TObject);
begin
CheckBox1.Checked := not CheckBox1.Checked;
end;

procedure TForm32.CheckBox1Click(Sender: TObject);
begin
SourceOnly := CheckBox1.Checked;
end;

end.

