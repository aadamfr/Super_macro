unit Unit14;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, IniFiles;

type
  TForm14 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form14: TForm14;

implementation

uses Unit1, Unit19;

{$R *.DFM}

procedure TForm14.MessageAide(var msg:TMessage);
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

procedure TForm14.Button1Click(Sender: TObject);
var i, PosStart,PosEnd : integer;
    ImgCom : integer;
begin
if memo1.Lines.Count > 1
then Form1.AddHistory(0,'Début d''actions groupées','','');

ImgCom := Form1.GetImageIndex('Commentaire');

Form1.ListView1.Items.BeginUpdate;
Form1.ListView4.Items.BeginUpdate;
try
if Memo1.Text = '' then
Memo1.Text := chr(VK_Return);
if unit1.sw_modif = False
then begin
     for i := 0 to memo1.Lines.Count -1
     do begin
         if Form1.ListView1.Selected <> nil
         then form1.add_insert('Commentaire',Memo1.Lines.Strings[i],ImgCom)
         else begin
              form1.Select_unique(Form1.ListView1,form1.ListView1.Items.count - 1);
              form1.add_insert('Commentaire',Memo1.Lines.Strings[i],ImgCom);
              end;
         end;
     end
else begin
     PosStart := 0; PosEnd := 0;
     for i := Form1.ListView1.selected.index downto 0
     do if Form1.ListView1.Items.Item[i].Caption = 'Commentaire'
        then PosStart := i else break;
     for i := Form1.ListView1.selected.index to Form1.ListView1.Items.Count -1
     do if Form1.ListView1.Items.Item[i].Caption = 'Commentaire'
        then PosEnd := i else break;
     for i := PosEnd downto PosStart
     do Form1.ListView1.Items[i].Delete;
     
     for i := 0 to Memo1.Lines.Count-1
     do begin

        form1.Select_unique(Form1.ListView1,PosStart+i-1);
        unit1.sw_modif := False;
        form1.add_insert('Commentaire',Memo1.Lines.Strings[i],ImgCom);
        unit1.sw_modif := True;
        end;
     end;
if memo1.Lines.Count > 1
then Form1.AddHistory(0,'Fin d''actions groupées','','');
finally Form1.ListView1.Items.EndUpdate; Form1.ListView4.Items.EndUpdate; end;
form14.close;
end;

procedure TForm14.Button2Click(Sender: TObject);
begin
form14.close;
end;

procedure TForm14.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Memo1.clear;
unit1.sw_modif := false;
end;

procedure TForm14.FormShow(Sender: TObject);
var i,k,PosStart,PosEnd : integer;
    ConfigIni: TIniFile;
    filename : string;
begin

filename := Form19.Label22.Caption;
ConfigIni := TIniFile.Create(filename);
try
Memo1.Color := ConfigIni.ReadInteger('ColorCommandes', 'Commentaire',ClWhite);
Memo1.Font.Color := ConfigIni.ReadInteger('ColorAffichage', 'Texte',ClBlack);
finally ConfigIni.free; end;

Form14.Width := Form1.ListView1.Column[1].Width+10;
if unit1.sw_modif = True
then begin
     PosStart := 0; PosEnd := 0;
     for i := Form1.ListView1.selected.index downto 0
     do if Form1.ListView1.Items.Item[i].Caption = 'Commentaire'
        then PosStart := i else break;

     for i := Form1.ListView1.selected.index to Form1.ListView1.Items.Count -1
     do if Form1.ListView1.Items.Item[i].Caption = 'Commentaire'
        then PosEnd := i else break;

     for i := PosStart to PosEnd
     do begin
        memo1.Lines.Add(Form1.ListView1.Items.Item[i].SubItems.Strings[0]);
        if i = Form1.ListView1.selected.index
        then k := length(Memo1.Text);
        end;
     Memo1.SelStart := k-1;
     Memo1.SetFocus;
     end;
end;

procedure TForm14.Button3Click(Sender: TObject);
begin
OpenDialog1.InitialDir := ExtractFileDir(Application.ExeName);

if OpenDialog1.Execute
then begin
     Memo1.Lines.LoadFromFile(OpenDialog1.FileName);
     end;
end;

end.
