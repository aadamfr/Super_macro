unit Unit34;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, unit1;

type
  TForm34 = class(TForm)
    Image1: TImage;
    Shape1: TShape;
    Label1: TLabel;
    Memo1: TMemo;
    Button1: TButton;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form34: TForm34;
  TimeKill : integer = 30;
  TimeElapse : integer = 0;
implementation

{$R *.dfm}

procedure TForm34.Button1Click(Sender: TObject);
begin
Form34.Close;
end;

procedure TForm34.Timer1Timer(Sender: TObject);
begin
Inc(TimeElapse);
form34.Caption := 'Super macro va se terminer dans '+ InttoStr(TimeKill - TimeElapse)+' seconde(s).';
unit1.Run := False;
Form1.Stop1.OnClick(self);
if TimeKill = TimeElapse then Application.Terminate;
end;

procedure TForm34.FormShow(Sender: TObject);
begin
if Panel1.Caption = 'Internal error [code 2].'
then Form34.Caption := 'Erreur interne'
else begin
     form34.Caption := 'Super macro va se terminer dans '+ InttoStr(TimeKill - TimeElapse)+' seconde(s).';
     Timer1.Enabled := True;
     end;
end;

procedure TForm34.FormClose(Sender: TObject; var Action: TCloseAction);
begin
TimeElapse := 0;
Timer1.Enabled := False;
end;

end.
