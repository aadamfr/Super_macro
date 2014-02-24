unit Unit37;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm37 = class(TForm)
    ListBox1: TListBox;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form37: TForm37;
  LangSelect : String ='';
implementation

uses UBackGround, Unit1;

{$R *.dfm}

procedure TForm37.MessageAide(var msg:TMessage);
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

procedure TForm37.Button1Click(Sender: TObject);
begin
if ListBox1.ItemIndex < 0
then ShowMessage('Veuillez sélectionner un langage.')
else begin
     LangSelect := ListBox1.Items[ListBox1.ItemIndex];
     Form37.Close;
     end;
end;

procedure TForm37.Button2Click(Sender: TObject);
begin
LangSelect := '';
Form37.Close;
end;

procedure TForm37.FormCreate(Sender: TObject);
begin
TransformTimageToWizard(Image1);
Form37.Close;
end;

end.
