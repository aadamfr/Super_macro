unit Unit29;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Consts,
  Debug;

type
  TForm29 = class(TForm)
    Label1: TLabel;
    ProgressBar1: TProgressBar;
    Label2: TLabel;
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form29: TForm29;
  EchapProgress : Boolean = False;
implementation

uses Unit1;

{$R *.dfm}

procedure TForm29.FormKeyPress(Sender: TObject; var Key: Char);
begin
if Key = Chr(VK_ESCAPE) then EchapProgress := True;
   Debug.WriteMessage(Form1.ListView1,0,SMsgDlgWarning,'Progression "'+ Label1.Caption + '" stoppé par l''utilisateur.');
   form1.Select_unique(Form1.ListView2,Form1.ListView2.Items.Count-1);
end;

procedure TForm29.FormShow(Sender: TObject);
begin
EchapProgress := False;
end;

end.
