unit Unit33;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm33 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ListView1: TListView;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    Image1: TImage;
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
    function FileChecked(Name : String) : Boolean;
  end;

var
  Form33: TForm33;
  CloseBy : TMsgDlgBtn;
implementation
uses UBackGround, Unit1;
{$R *.dfm}

procedure TForm33.MessageAide(var msg:TMessage);
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

function TForm33.FileChecked(Name : String) : Boolean;
var i : integer;
begin
result := False;
for i := 0 to Form33.ListView1.Items.Count-1
do if (Form33.ListView1.Items[i].Caption = Name) and (Form33.ListView1.Items[i].Checked)
   then result := True;
end;

procedure TForm33.Button3Click(Sender: TObject);
begin
CloseBy := mbok;
Form33.close;
end;

procedure TForm33.Button4Click(Sender: TObject);
begin
CloseBy := mbcancel;
Form33.close;
end;

procedure TForm33.Button1Click(Sender: TObject);
var i : integer;
begin
for i := 0 to ListView1.Items.Count -1
do ListView1.Items[0].Checked := True;
end;

procedure TForm33.Button2Click(Sender: TObject);
var List : TListItem;
begin
If openDialog1.Execute
then begin
     List := ListView1.Items.Add;
     List.Caption := OpenDialog1.FileName;
     List.Checked := True;
     List.Indent := 1;
     end;
end;

procedure TForm33.FormCreate(Sender: TObject);
begin
TransformTimageToWizard(Image1);    
end;

end.
