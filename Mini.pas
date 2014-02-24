unit Mini;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls;

type
  TForm38 = class(TForm)
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form38: TForm38;

implementation

uses Unit1, MdlFnct;

{$R *.dfm}

procedure TForm38.FormCreate(Sender: TObject);
begin
SetWindowLong(Application.Handle, GWL_EXSTYLE, GetWindowLong(Application.Handle, GWL_EXSTYLE) or WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

Form1.ImageList3.GetBitmap(19,SpeedButton1.Glyph);
Form1.ImageList3.GetBitmap(21,SpeedButton2.Glyph);
Form1.ImageList3.GetBitmap(22,SpeedButton3.Glyph);
end;

procedure TForm38.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
ReleaseCapture;
Self.Perform(WM_SYSCOMMAND,$f012,0);
end;

procedure TForm38.FormShow(Sender: TObject);
begin
Label1.Caption := ExtractFileName(Form1.OpenDialog1.FileName);
Label1.Hint := Form1.OpenDialog1.FileName;
ForceForegroundWindow(Form38.Handle);
SetWindowPos(Form38.Handle, HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TForm38.SpeedButton1Click(Sender: TObject);
begin
Form1.Execute1Click(self);
end;

procedure TForm38.SpeedButton2Click(Sender: TObject);
begin
Form1.Stop1Click(self);
end;

procedure TForm38.SpeedButton3Click(Sender: TObject);
begin
Form1.Close;
end;

end.
