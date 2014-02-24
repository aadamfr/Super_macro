unit Erreurcompil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPi, ExtCtrls;

type
  TForm35 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    Memo1: TMemo;
    Image1: TImage;
    Label3: TLabel;
    SaveDialog1: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form35: TForm35;

implementation

{$R *.dfm}
uses unit1, mdlfnct, Unit32;

procedure TForm35.FormShow(Sender: TObject);
var i : integer;
begin
Form35.Height := 120;
Memo1.Visible := False;
Label1.Caption := Unit1.Lng_Error_without_edit;
if FnctTypeVar('[MACRO.MAIL]') = TAlpha
then Label2.Caption := form1.GetInitialValueofVar('[MACRO.MAIL]');
Memo1.Clear;
for i := 0 to form1.ListView2.Items.Count -1
do if form1.ListView2.Items[i].SubItems[0] = 'Erreur' // pour ne séléctionner que les erreurs et pas les warning
   then memo1.Lines.Add(form1.ListView2.Items[i].Caption + chr(VK_TAB) + form1.ListView2.Items[i].SubItems[0] + chr(VK_TAB) + form1.ListView2.Items[i].SubItems[1]);

end;

procedure TForm35.Button2Click(Sender: TObject);
begin

if TButton(Sender).Tag = 0
then begin
     Memo1.Visible := True;
     Form35.Height := 375;
     TButton(Sender).Tag := 1;
     TButton(Sender).Caption := 'Cacher';
     end
else begin
     Memo1.Visible := False;
     Form35.Height := 120;
     TButton(Sender).Tag :=0;
     TButton(Sender).Caption := 'Consulter';
end;
end;

procedure TForm35.Label2Click(Sender: TObject);
begin
ShellExecute(handle,'Open', Pchar('mailto:'+Label2.Caption+'?subject=Macro error&body= '),'','',SW_SHOWNORMAL);
end;

procedure TForm35.Button3Click(Sender: TObject);
begin
Form35.Close;
end;

procedure TForm35.Button1Click(Sender: TObject);
begin
SaveDialog1.Filter := 'Fichiers texte (*.txt)|*.txt';
//OpenDialog1.FileName := 'Error-'+Form1.StatusBar1.Panels[0].Text +'-'+ DateTimeToStr(Now)+'.txt';

if SaveDialog1.Execute
then begin
     memo1.Lines.SaveToFile(SaveDialog1.FileName);
     end;

end;

end.
