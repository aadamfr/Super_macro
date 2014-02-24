unit Unit22;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons,clipbrd, ComCtrls, jpeg,
  HotKeyManager, Menus, ExtDlgs, AppEvnts, IniFiles;


type
  TForm22 = class(TForm)
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Button1: TButton;
    ScrollBox1: TScrollBox;
    Image1: TImage;
    Image3: TImage;
    Image2: TImage;
    Image4: TImage;
    Image5: TImage;
    ScrollBox2: TScrollBox;
    Image6: TImage;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Image7: TImage;
    Bevel1: TBevel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Bevel2: TBevel;
    Label10: TLabel;
    Label11: TLabel;
    Button2: TButton;
    Button3: TButton;
    Label12: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label13: TLabel;
    Label14: TLabel;
    PopupMenu1: TPopupMenu;
    Placerlecureuralextremitdelimage1: TMenuItem;
    placerlescureursauxextremitsdelimage1: TMenuItem;
    PopupMenu2: TPopupMenu;
    Placerlecureurenbasdroitedelimage1: TMenuItem;
    Placerlescureursauxextremitsdelimage2: TMenuItem;
    SpeedButton1: TSpeedButton;
    OpenPictureDialog1: TOpenPictureDialog;
    PopupMenu3: TPopupMenu;
    Positiondescurseurs1: TMenuItem;
    Restaurer1: TMenuItem;
    Sauvegarder1: TMenuItem;
    Shape1: TShape;
    Edit2: TEdit;
    Label15: TLabel;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    procedure Button1Click(Sender: TObject);
    procedure Image1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure Image4EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure Image5EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure UpDown1Click(Sender: TObject; Button: TUDBtnType);
    procedure UpDown2Click(Sender: TObject; Button: TUDBtnType);
    procedure Image1StartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure FormActivate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Image1DragDrop(Sender, Source: TObject; X, Y: Integer);
    Procedure New_Image_Name(Sender : TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Placerlecureuralextremitdelimage1Click(Sender: TObject);
    procedure Placerlecureurenbasdroitedelimage1Click(Sender: TObject);
    procedure placerlescureursauxextremitsdelimage1Click(Sender: TObject);
    procedure Placerlescureursauxextremitsdelimage2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
    Procedure DrawImg6();
    Procedure CenterImg6();
    procedure Sauvegarder1Click(Sender: TObject);
    procedure Restaurer1Click(Sender: TObject);
    procedure Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
//  PROCEDURE WMEraseBkgnd( VAR Message : TMessage ); MESSAGE WM_ERASEBKGND;
  public
    { Public declarations }
  end;

var
  Form22: TForm22;
  RZone,OZone : Trect;
  InitialPos : TPoint;
  MoveImage : boolean = False;
  LastDark : TImage;
implementation

uses Unit1, mdlfnct, Unit19;

{$R *.dfm}

{PROCEDURE TForm22.WMEraseBkgnd( VAR Message : TMessage );
BEGIN
  Message.Result:=1;  // indique à Windows de ne pas effacer.
END;}

procedure TForm22.MessageAide(var msg:TMessage);
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

Procedure TForm22.DrawImg6();
var ImageBureau : TPicture;
begin
if (OZone.Right - ozone.Left < 1) or (OZone.Bottom - Ozone.Top <1)
then begin
     Label11.Visible := True;
     Label11.Caption := 'Le cadre de l''image est hors zone.';
     Image6.Picture.Bitmap := nil;
     Exit;
     end;

ImageBureau := Tpicture.Create;
  try
  ImageBureau.Bitmap.Width := OZone.Right - ozone.Left;
  ImageBureau.Bitmap.Height := OZone.Bottom - Ozone.Top;
  BitBlt(ImageBureau.Bitmap.Canvas.Handle,0,0,Ozone.Right,Ozone.Bottom,Image1.Picture.Bitmap.Canvas.Handle,Ozone.Left,OZone.Top,SrcCopy);
  Label11.Visible := False;
  Image6.Picture.Bitmap := ImageBureau.Bitmap;
  finally ImageBureau.Free; end;
end;

Procedure TForm22.CenterImg6();
begin
ScrollBox2.HorzScrollBar.Position := 0;
ScrollBox2.VertScrollBar.Position := 0;
ScrollBox2.HorzScrollBar.Range := ScrollBox2.Width-20;
ScrollBox2.VertScrollBar.Range := ScrollBox2.Height-20;

if (ScrollBox2.Width > image6.Width )
then image6.Left := (ScrollBox2.Width - image6.Width) div 2
else begin
     ScrollBox2.HorzScrollBar.Range := image6.Width +40;
     image6.Left := 20;
     end;
if (ScrollBox2.Height > image6.Height )
then image6.Top := (ScrollBox2.Height - image6.Height) div 2
else begin
     ScrollBox2.VertScrollBar.Range := image6.Height +40;
     image6.Top := 20;
     end;
end;

Procedure TForm22.New_Image_Name(Sender : TObject);
var i : integer;
    path : string;
begin
if Sender is TComboBox
then begin
     if Form1.StatusBar1.Panels[0].Text = Lng_NewMacro
     then path := ExtractFileDir(Application.ExeName)
     else path := ExtractFileDir(Form1.StatusBar1.Panels[0].Text);
     
     for i := 1 to 99999 do
     if not FileExists(path + '\image' + IntToStr(i) + '.bmp')
     then begin
          (Sender as TComboBox).Text := path + '\image' + IntToStr(i) + '.bmp';
          Break;
          end;
     end;
end;

procedure TForm22.Button1Click(Sender: TObject);
begin
if Clipboard.HasFormat(CF_BITMAP)
then begin
     Image1.Picture.Assign(Clipboard);
     Label10.Visible := False;
     DrawImg6(); CenterImg6();
     end;
end;

procedure TForm22.Image1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var  ScreenPt: TPoint;
     ClientPt: TPoint;
begin

if Source is TImage
then LastDark := Source as TImage
else Exit;

Accept := Source is TImage;

windows.GetCursorPos(ScreenPt);
ClientPt := ScreenToClient(screenpt);
ClientPt.x := ClientPt.x -19;
ClientPt.y := ClientPt.y -55;

if (source as TImage).Name = 'Image2'
then begin
     if ClientPt.y > image3.Top then Accept := False;
     if ClientPt.y > image4.Top then Accept := False;
     if ClientPt.y > image5.Top then Accept := False;
     if ClientPt.x > image3.Left then Accept := False;
     if ClientPt.x > image4.Left then Accept := False;
     if ClientPt.x > image5.Left then Accept := False;
     end;
if (source as TImage).Name = 'Image4'
then begin
     if ClientPt.y < image2.Top then Accept := False;
     if ClientPt.y > image3.Top then Accept := False;
     if ClientPt.y > image5.Top then Accept := False;
     if ClientPt.x < image2.Left then Accept := False;
     if ClientPt.x > image3.Left then Accept := False;
     if ClientPt.x > image5.Left then Accept := False;
     end;
if (source as TImage).Name = 'Image5'
then begin
     if ClientPt.y < image2.Top then Accept := False;
     if ClientPt.y > image3.Top then Accept := False;
     if ClientPt.y < image4.Top then Accept := False;
     if ClientPt.x < image2.Left then Accept := False;
     if ClientPt.x > image3.Left then Accept := False;
     if ClientPt.x < image4.Left then Accept := False;
     end;
if (source as TImage).Name = 'Image3'
then begin
     if ClientPt.y < image2.Top then Accept := False;
     if ClientPt.y < image4.Top then Accept := False;
     if ClientPt.y < image5.Top then Accept := False;
     if ClientPt.x < image2.Left then Accept := False;
     if ClientPt.x < image4.Left then Accept := False;
     if ClientPt.x < image5.Left then Accept := False;
     end;

end;

procedure TForm22.Image4EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
if Image1.Picture.Bitmap.Empty = True then Exit;
DrawImg6(); CenterImg6();
end;

procedure TForm22.Image5EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
if Image1.Picture.Bitmap.Empty = True then Exit;
DrawImg6(); CenterImg6();
end;

procedure TForm22.FormCreate(Sender: TObject);
begin
Rzone.Top := Image2.top;
Rzone.Left := Image2.Left;
Rzone.Bottom := Image3.Top + Image3.Height;
Rzone.Right := Image3.Left + Image3.Width;
Ozone.Top := Image4.top;
Ozone.Left := Image4.Left;
Ozone.Bottom := Image5.Top + Image5.Height;
Ozone.Right := Image5.Left + Image5.Width;
Label1.Caption := 'Position : ' + IntToStr(Ozone.Left) + ',' + IntToStr(Ozone.Top);
Label2.Caption := 'Position : ' + IntToStr(Ozone.Right) + ',' + IntToStr(Ozone.Bottom);
Label3.Caption := 'Position : ' + IntToStr(Rzone.Left) + ',' + IntToStr(Rzone.Top);
Label4.Caption := 'Position : ' + IntToStr(Rzone.Right) + ',' + IntToStr(Rzone.Bottom);
end;

procedure TForm22.UpDown1Click(Sender: TObject; Button: TUDBtnType);
begin
if not (LastDark is TImage) then Exit;
if Button = btNext
then begin
     LastDark.Left := LastDark.Left +1;
     if LastDark.Name = 'Image2' then Rzone.Left := Rzone.Left +1;
     if LastDark.Name = 'Image3' then Rzone.Right := Rzone.Right +1;
     if LastDark.Name = 'Image4' then Ozone.Left := Ozone.Left +1;
     if LastDark.Name = 'Image5' then Ozone.Right := Ozone.Right +1;
     end;
if Button = btPrev
then begin
     LastDark.Left := LastDark.Left -1;
     if LastDark.Name = 'Image2' then Rzone.Left := Rzone.Left -1;
     if LastDark.Name = 'Image3' then Rzone.Right := Rzone.Right -1;
     if LastDark.Name = 'Image4' then Ozone.Left := Ozone.Left -1;
     if LastDark.Name = 'Image5' then Ozone.Right := Ozone.Right -1;
     end;


DrawImg6();CenterImg6();

if LastDark.Name = 'Image4' then Label1.Caption := 'Position : ' + IntToStr(Ozone.Left) + ',' + IntToStr(Ozone.Top);
if LastDark.Name = 'Image5' then Label2.Caption := 'Position : ' + IntToStr(Ozone.Right) + ',' + IntToStr(Ozone.Bottom);
if LastDark.Name = 'Image2' then Label3.Caption := 'Position : ' + IntToStr(Rzone.Left) + ',' + IntToStr(Rzone.Top);
if LastDark.Name = 'Image3' then Label4.Caption := 'Position : ' + IntToStr(Rzone.Right) + ',' + IntToStr(Rzone.Bottom);

end;

procedure TForm22.UpDown2Click(Sender: TObject; Button: TUDBtnType);
begin
if not (LastDark is TImage) then Exit;
if Button = btNext
then begin
     LastDark.Top := LastDark.Top -1;
     if LastDark.Name = 'Image2' then Rzone.Top := Rzone.Top -1;
     if LastDark.Name = 'Image3' then Rzone.Bottom := Rzone.Bottom -1;
     if LastDark.Name = 'Image4' then Ozone.Top := Ozone.Top -1;
     if LastDark.Name = 'Image5' then Ozone.Bottom := Ozone.Bottom -1;
     end;
if Button = btPrev
then begin
     LastDark.Top := LastDark.Top +1;
     if LastDark.Name = 'Image2' then Rzone.Top := Rzone.Top +1;
     if LastDark.Name = 'Image3' then Rzone.Bottom := Rzone.Bottom +1;
     if LastDark.Name = 'Image4' then Ozone.Top := Ozone.Top +1;
     if LastDark.Name = 'Image5' then Ozone.Bottom := Ozone.Bottom +1;
     end;

DrawImg6();CenterImg6();

if LastDark.Name = 'Image4' then Label1.Caption := 'Position : ' + IntToStr(Ozone.Left) + ',' + IntToStr(Ozone.Top);
if LastDark.Name = 'Image5' then Label2.Caption := 'Position : ' + IntToStr(Ozone.Right) + ',' + IntToStr(Ozone.Bottom);
if LastDark.Name = 'Image2' then Label3.Caption := 'Position : ' + IntToStr(Rzone.Left) + ',' + IntToStr(Rzone.Top);
if LastDark.Name = 'Image3' then Label4.Caption := 'Position : ' + IntToStr(Rzone.Right) + ',' + IntToStr(Rzone.Bottom);

end;

procedure TForm22.Image1StartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
LAstDark := Sender as TImage;
Image7.Picture.Bitmap := LastDark.Picture.Bitmap;
end;

procedure TForm22.Image3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
scrollBox1.VertScrollBar.Position  := scrollBox1.VertScrollBar.Position + 5;
scrollBox1.HorzScrollBar.Position  := scrollBox1.HorzScrollBar.Position + 5;
end;

procedure TForm22.FormActivate(Sender: TObject);
begin
if Clipboard.HasFormat(CF_BITMAP)
then Button1.Enabled := True else Button1.Enabled := False;
end;

procedure TForm22.Button2Click(Sender: TObject);
var param : String;
    ImageName : String;
    RZonePlusX, RZonePlusY : string;
begin

if Image6.Picture.Bitmap.Empty = True
then begin
     MessageDlg('Le graphique rechercher n''est pas valide.',mtError, [mbOk], 0);
     Exit;
     end;

if FnctTypeVar(ComboBox1.Text) = TNo
then begin
     MessageDlg('Saisissez une variable où la position de X doit être stockée.',mtError, [mbOk], 0);
     Exit;
     end;
if FnctTypeVar(ComboBox1.Text) = TAlpha
then begin
     MessageDlg('Saisissez une variable de type numèrique pour la position de X.',mtError, [mbOk], 0);
     Exit;
     end;
if FnctTypeVar(ComboBox2.Text) = TNo
then begin
     MessageDlg('Saisissez la variable où la position de Y doit être stockée.',mtError, [mbOk], 0);
     Exit;
     end;
if FnctTypeVar(ComboBox2.Text) = TAlpha
then begin
     MessageDlg('Saisissez une variable de type numèrique pour la position de Y.',mtError, [mbOk], 0);
     Exit;
     end;


ImageName := ComboBox4.Text;
Image6.Picture.Bitmap.PixelFormat := pf32bit;

if FileExists(ImageName)
then begin
     if MessageDlg(ImageName +' existe déja voulez vous le remplacer?', mtwarning, [mbOk, mbCancel], 0) = mrok
     then Image6.Picture.Bitmap.SaveToFile(ImageName);
     end
else Image6.Picture.Bitmap.SaveToFile(ImageName);

RZonePlusX :=  IntToStr(RZone.Left);
RZonePlusY :=  IntToStr(RZone.Top);

if (FnctTypeVar(Combobox3.Text) <> TNum) and ( not fnctIsInteger(ComboBox3.Text))
then ComboBox3.Text := '1';

param := ImageName + Sprpr + RZonePlusX + Sprpr + RZonePlusY + Sprpr
                   + IntToStr(RZone.Right) + Sprpr + IntToStr(RZone.Bottom) + SprPr
                   + IntToStr(OZone.Left) + Sprpr + IntToStr(OZone.Top) + SprPr
                   + IntToStr(OZone.Right) + Sprpr + IntToStr(OZone.Bottom) + SprPr
                   + ComboBox1.Text + SprPr + ComboBox2.Text + SprPr + ComboBox3.Text;

if unit1.sw_modif = false
then begin
     form1.add_insert('Trouve image',param,22);
    end
else begin
     Form1.ListView1.Selected.SubItems.Strings[0] := param;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     end;
form22.Close;
end;

procedure TForm22.FormShow(Sender: TObject);
var param : string;
    listParam : Tparam;
begin
form1.List_Var(ComboBox1.Items,False,True);
form1.List_Var(ComboBox2.Items,False,True);
form1.List_Var(ComboBox3.Items,False,True);
form1.List_Var(ComboBox4.Items,True,False);
Label11.Visible := True;

if unit1.sw_modif = false
then begin
     New_image_name(ComboBox4);
     ComboBox1.Text := '';
     ComboBox2.Text := '';
     ComboBox3.Text := '1';
     if Clipboard.HasFormat(CF_BITMAP) = True
     then begin
          image4.Top := 150; Image3.Top := 410;
          image4.Left := 180; Image3.Left := 520;
          Ozone.Top := 150; Ozone.Left := 180;
          Ozone.Bottom := 300; Ozone.Right := 360;
          Button1.Click;
          end
     else begin
          image1.Picture := nil;
          image6.Picture := nil;
          end
     end
else begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox4.Text := Listparam.param[1];
     if FileExists(ComboBox4.Text)
     then begin
          image6.Picture.Bitmap.LoadFromFile(ComboBox4.Text);
          CenterImg6();
          Label11.Visible := False;
          end;
          
     Label3.Caption := 'Position : ' + Listparam.param[2] + ','+ Listparam.param[3];
     Label4.Caption := 'Position : ' + Listparam.param[4] + ','+ Listparam.param[5];




     if fnctisInteger(Listparam.param[2]) = True
     then image2.Left := StrToInt(Listparam.param[2]) - ScrollBox1.HorzScrollBar.Position
     else image2.Left := 0;
     if fnctisInteger(Listparam.param[3]) = True
     then image2.Top := StrToInt(Listparam.param[3]) - ScrollBox1.VertScrollBar.Position
     else image2.Top := 0;

     image3.Left := StrToInt(Listparam.param[4]) - image3.Width - ScrollBox1.HorzScrollBar.Position;
     image3.Top := StrToInt(Listparam.param[5]) - image3.Height - ScrollBox1.VertScrollBar.Position;

     image4.Left := StrToInt(Listparam.param[6]) - ScrollBox1.HorzScrollBar.Position;
     image4.Top := StrToInt(Listparam.param[7]) - ScrollBox1.VertScrollBar.Position;
     image5.Left := StrToInt(Listparam.param[8]) - image5.Width - ScrollBox1.HorzScrollBar.Position;
     image5.Top := StrToInt(Listparam.param[9]) - image5.Height - ScrollBox1.VertScrollBar.Position;

     if fnctisInteger(Listparam.param[2]) = True
     then Rzone.Left := StrToInt(Listparam.param[2]) else Rzone.Left := 0;

     if fnctisInteger(Listparam.param[3]) = True
     then RZone.Top := StrToInt(Listparam.param[3]) else  RZone.Top := 0;

     RZone.Right := StrToInt(Listparam.param[4]); RZone.Bottom := StrToInt(Listparam.param[5]);
     Ozone.Left := StrToInt(Listparam.param[6]); OZone.Top := StrToInt(Listparam.param[7]);
     OZone.Right := StrToInt(Listparam.param[8]); OZone.Bottom := StrToInt(Listparam.param[9]);

     ComboBox1.Text := Listparam.param[10];
     ComboBox2.Text := Listparam.param[11];
     ComboBox3.Text := Listparam.param[12];
     end;
end;

procedure TForm22.Button3Click(Sender: TObject);
begin
Form22.close;
end;

procedure TForm22.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif :=False;
end;

procedure TForm22.Image1DragDrop(Sender, Source: TObject; X, Y: Integer);
var  ScreenPt: TPoint;
     ClientPt: TPoint;
begin

windows.GetCursorPos(ScreenPt);
ClientPt := ScreenToClient(screenpt);
ClientPt.x := ClientPt.x -19;
ClientPt.y := ClientPt.y -55;
(Source as TImage).Left := ClientPt.x;
(Source as TImage).Top := ClientPt.y;

if (Source as TImage).Name = 'Image2'
then begin
     Label3.Caption := 'Position : ' + IntToStr(x) + ',' + IntToStr(y);
     Rzone.Left := x; Rzone.Top := y;
     end;

if (Source as TImage).Name = 'Image3'
then begin
     Label4.Caption := 'Position : ' + IntToStr(x) + ',' + IntToStr(y);
     Rzone.Right := x + image3.Width;
     Rzone.Bottom := y + image3.Height;
     end;

if (Source as TImage).Name = 'Image4'
then begin
     Label1.Caption := 'Position : ' + IntToStr(x) + ',' + IntToStr(y);
     Ozone.Left := x; Ozone.Top := y;
     end;

if (Source as TImage).Name = 'Image5'
then begin
     Label2.Caption := 'Position : ' + IntToStr(x) + ',' + IntToStr(y);
     Ozone.Right := x + image5.Width;
     Ozone.Bottom := y + image5.Height;
     end;

end;

procedure TForm22.FormDeactivate(Sender: TObject);
begin
if Clipboard.HasFormat(CF_BITMAP)
then Button1.Enabled := True else Button1.Enabled := False;
end;

procedure TForm22.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
Edit2.Text := 'Position souris :' + IntToStr(x) +','+IntToStr(y);
Application.ProcessMessages;
end;

procedure TForm22.Placerlecureuralextremitdelimage1Click(Sender: TObject);
begin
image2.Top := 0 - ScrollBox1.VertScrollBar.Position;
image2.Left := 0 - ScrollBox1.HorzScrollBar.Position;
Label3.Caption := 'Position : 0,0';
Rzone.Left := 0; Rzone.Top := 0;
end;

procedure TForm22.Placerlecureurenbasdroitedelimage1Click(Sender: TObject);
begin
image3.Top := image1.Picture.Bitmap.Height - ScrollBox1.VertScrollBar.Position;
image3.Left := image1.Picture.Bitmap.Width - ScrollBox1.HorzScrollBar.Position;
Label4.Caption := 'Position : '+ IntToStr(image1.Picture.Bitmap.Width) +','+ IntToStr(image1.Picture.Bitmap.Height);
Rzone.Right := image1.Picture.Bitmap.Width; Rzone.Bottom := image1.Picture.Bitmap.Height;

end;

procedure TForm22.placerlescureursauxextremitsdelimage1Click(Sender: TObject);
begin
image2.Top := 0 - ScrollBox1.VertScrollBar.Position;
image2.Left := 0 - ScrollBox1.HorzScrollBar.Position;
image3.Top := image1.Picture.Bitmap.Height - image3.Picture.Bitmap.Height - ScrollBox1.VertScrollBar.Position;
image3.Left := image1.Picture.Bitmap.Width - image3.Picture.Bitmap.Width - ScrollBox1.HorzScrollBar.Position;
Label3.Caption := 'Position : 0,0';
Label4.Caption := 'Position : '+ IntToStr(image1.Picture.Bitmap.Width) +','+ IntToStr(image1.Picture.Bitmap.Height);
Rzone.Left := 0; Rzone.Top := 0;
Rzone.Right := image1.Picture.Bitmap.Width; Rzone.Bottom := image1.Picture.Bitmap.Height;

end;

procedure TForm22.Placerlescureursauxextremitsdelimage2Click(Sender: TObject);
begin
image2.Top := 0 - ScrollBox1.VertScrollBar.Position;
image2.Left := 0 - ScrollBox1.HorzScrollBar.Position;
image3.Top := image1.Picture.Bitmap.Height - image3.Picture.Bitmap.Height - ScrollBox1.VertScrollBar.Position;
image3.Left := image1.Picture.Bitmap.Width - image3.Picture.Bitmap.Width - ScrollBox1.HorzScrollBar.Position;
Label3.Caption := 'Position : 0,0';
Label4.Caption := 'Position : '+ IntToStr(image1.Picture.Bitmap.Width) +','+ IntToStr(image1.Picture.Bitmap.Height);
Rzone.Left := 0; Rzone.Top := 0;
Rzone.Right := image1.Picture.Bitmap.Width; Rzone.Bottom := image1.Picture.Bitmap.Height;

end;

procedure TForm22.SpeedButton1Click(Sender: TObject);
begin
OpenPictureDialog1.FileName := ComboBox4.Text;
If OpenPictureDialog1.Execute
then ComboBox4.Text := OpenPictureDialog1.FileName;
end;

procedure TForm22.Edit1Change(Sender: TObject);
begin
if FileExists(ComboBox4.Text)
then begin
     Image6.Picture.Bitmap.LoadFromFile(ComboBox4.Text);
     CenterImg6();
     end;
end;

procedure TForm22.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm22.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox2.Text;
Form1.List_Var(ComboBox2.Items, True, True);
ComboBox2.Text := SaveText;
end;

procedure TForm22.Sauvegarder1Click(Sender: TObject);
var ConfigIni : TIniFile;
begin
ConfigIni := TIniFile.Create(Form19.Label22.Caption);
try
ConfigIni.WriteString('Dark1','Top',IntToStr(Rzone.Top));
ConfigIni.WriteString('Dark1','Left',IntToStr(Rzone.Left));
ConfigIni.WriteString('Dark2','Top',IntToStr(Rzone.Bottom));
ConfigIni.WriteString('Dark2','Left',IntToStr(Rzone.Right));
ConfigIni.WriteString('Dark3','Top',IntToStr(Ozone.Top));
ConfigIni.WriteString('Dark3','Left',IntToStr(Ozone.Left));
ConfigIni.WriteString('Dark4','Top',IntToStr(Ozone.Bottom));
ConfigIni.WriteString('Dark4','Left',IntToStr(Ozone.Right));

finally ConfigIni.UpdateFile; ConfigIni.Free; end;
end;

procedure TForm22.Restaurer1Click(Sender: TObject);
var ConfigIni: TIniFile;
begin
ConfigIni := TIniFile.Create(Form19.Label22.Caption);
try

Rzone.Top := StrToInt(ConfigIni.ReadString('Dark1','Top',IntToStr(Rzone.Top)));
Rzone.Left := StrToInt(ConfigIni.ReadString('Dark1','Left',IntToStr(Rzone.Left)));

Rzone.Bottom := StrToInt(ConfigIni.ReadString('Dark2','Top',IntToStr(Rzone.Bottom)));
Rzone.Right := StrToInt(ConfigIni.ReadString('Dark2','Left',IntToStr(Rzone.Right)));

Ozone.Top := StrToInt(ConfigIni.ReadString('Dark3','Top',IntToStr(Ozone.Top)));
Ozone.Left := StrToInt(ConfigIni.ReadString('Dark3','Left',IntToStr(Ozone.Left)));

Ozone.Bottom := StrToInt(ConfigIni.ReadString('Dark4','Top',IntToStr(Ozone.Bottom)));
Ozone.Right := StrToInt(ConfigIni.ReadString('Dark4','Left',IntToStr(Ozone.Right)));

image2.Left := RZone.Left - ScrollBox1.HorzScrollBar.Position;
image2.Top := RZone.Top - ScrollBox1.VertScrollBar.Position;
image3.Left := RZone.Right - image3.Width - ScrollBox1.HorzScrollBar.Position;
image3.Top := RZone.Bottom - image3.Height - ScrollBox1.VertScrollBar.Position;

image4.Left := OZone.Left - ScrollBox1.HorzScrollBar.Position;
image4.Top := OZone.Top - ScrollBox1.VertScrollBar.Position;
image5.Left := OZone.Right - image5.Width - ScrollBox1.HorzScrollBar.Position;
image5.Top := OZone.Bottom - image5.Height - ScrollBox1.VertScrollBar.Position;

if Image1.Picture.Bitmap.Empty = True then Exit;
DrawImg6();CenterImg6();

finally ConfigIni.Free; end;
end;

end.

