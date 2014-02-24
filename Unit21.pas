unit Unit21;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Consts;

type
  TForm21 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form21: TForm21;

implementation

{$R *.DFM}

procedure TForm21.FormClose(Sender: TObject; var Action: TCloseAction);
begin
label1.caption := SrNone; // (vide)
end;

procedure TForm21.Button1Click(Sender: TObject);
begin
form21.Close;
end;

procedure TForm21.FormShow(Sender: TObject);
begin
Form21.Caption := SMsgDlgInformation;
end;

end.
