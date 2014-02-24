unit Unit5;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, ImgList, IniFiles, Menus;

type TGraphicElement = record
     Ref : String;
     Image : TBitmap;
     end;

type TTabImgMoveMouse = Object
     Items : array of TGraphicElement;
     constructor create;
     procedure FreeAll;
     procedure Add(Name : String; Bmp : TBitmap);
     procedure Change(Name : String; Bmp : TBitmap);
     procedure Remove(Name : String);
     function GetAutoName :String;
     function GetImage(Name : String) : TBitmap;
     //procedure LoadTabImg(FileName : String);
     //procedure SaveTabImg(FileName : String);
     end;

type
  TForm5 = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label4: TLabel;
    Label5: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    HotKey1: THotKey;
    Label6: TLabel;
    Bevel2: TBevel;
    Image1: TImage;
    Label7: TLabel;
    Bevel3: TBevel;
    Button3: TButton;
    procedure PosCur();
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
    procedure ComboBox2DropDown(Sender: TObject);
    procedure HotKey1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
    procedure DrawCursor(ScreenShotBitmap : TBitmap);
  end;

var
  Form5: TForm5;
  Stop : boolean;
  Pt : Tpoint;
  MyKey : char = ' ';
  OldShortCut : TShortCut;
  ImgTab : TTabImgMoveMouse;
  ImgName : String;
implementation

uses Unit1, Unit19, MdlFnct;

{$R *.DFM}

procedure TForm5.MessageAide(var msg:TMessage);
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

procedure TForm5.DrawCursor(ScreenShotBitmap : TBitmap);
var r: TRect;
  CI: TCursorInfo;
  Icon: TIcon;
  II: TIconInfo;
begin
  r := ScreenShotBitmap.Canvas.ClipRect;
  Icon := TIcon.Create;
  try
    CI.cbSize := SizeOf(CI);
    if GetCursorInfo(CI) then
      if CI.Flags = CURSOR_SHOWING then
      begin
        Icon.Handle := CopyIcon(CI.hCursor);
        if GetIconInfo(Icon.Handle, II) then
        begin
          ScreenShotBitmap.Canvas.Draw(
                Image1.Width div 2 -Integer(II.xHotspot),
                Image1.Height div 2 -Integer(II.yHotspot),
                Icon
                );
        end;
      end;
  finally
    Icon.Free;
  end;
end;


Constructor TTabImgMoveMouse.create;
begin
SetLength(Items,0);
end;

procedure TTabImgMoveMouse.FreeAll;
var i : integer;
begin
for i := 0 to length(Items)-1
do Items[i].Image.Free;
SetLength(Items,0);
end;

procedure TTabImgMoveMouse.Add(Name : String; Bmp : TBitmap);
var i : integer;
begin
i := length(Items);
SetLength(Items, i+1);
Items[i].Ref := Name;
Items[i].Image := TBitmap.Create;
Items[i].Image.Height := 105;
Items[i].Image.Width := 105;
Items[i].Image.Canvas.CopyRect(Bmp.Canvas.ClipRect,Bmp.Canvas,Bmp.Canvas.ClipRect);
end;

procedure TTabImgMoveMouse.Change(Name : String; Bmp : TBitmap);
var i, index : integer;
begin
index := -1;
for i := Low(Items) to High(Items)
do if Items[i].ref = Name
   then begin
        index := i;
        break;
        end;

if Index <> -1
then begin
     if Items[Index].Image = nil
     then begin
          Items[Index].Image := TBitmap.Create;
          Items[i].Image.Height := 105;
          Items[i].Image.Width := 105;
          end;
     Items[Index].Image.Canvas.CopyRect(Bmp.Canvas.ClipRect,Bmp.Canvas,Bmp.Canvas.ClipRect);
     end;
end;


procedure TTabImgMoveMouse.Remove(Name : String);
var i, index : integer;
begin
index := -1;
for i := Low(Items) to High(Items)
do if Items[i].ref = Name
   then begin
        index := i;
        break;
        end;

if Index <> -1
then begin
     for i := High(Items) downto Index+1
     do Items[i-1] := Items[i];
     SetLength(Items,length(Items)-1);
     end;
end;

function TTabImgMoveMouse.GetAutoName():String;
begin
result := 'ImgRef' + IntToStr(High(Items)+1);
end;

function TTabImgMoveMouse.GetImage(Name : String) : TBitmap;
var i, index : integer;
begin
index := -1;
for i := Low(Items) to High(Items)
do if Items[i].ref = Name
   then begin
        index := i;
        break;
        end;

if Index <> -1
then result := Items[Index].Image
else result := nil;
end;

procedure TForm5.posCur;
begin
KeyPreview := True;
Stop := false;
repeat
GetCursorPos(Pt);
ComboBox1.Text := IntToStr(Pt.X);
ComboBox2.Text := IntToStr(Pt.Y);
Form5.Caption := 'X:'+IntToStr(Pt.X)+'-Y:'+IntToStr(Pt.Y);
Application.ProcessMessages;
until  Stop = True;
end;

procedure TForm5.Button1Click(Sender: TObject);
var ImgRef : string;
begin
Stop := true;
if (ComboBox1.text <> '') and (ComboBox2.Text <> '')
then begin
     if Image1.Picture.Bitmap.Empty = False
     then ImgRef := ImgName+SprPr else ImgRef := ''; // Extension des paramètres
     if unit1.sw_modif = false
     then begin
          if radioButton1.Checked = true then form1.add_insert('Move Mouse',ComboBox1.Text+ SprPr + ComboBox2.Text+ SprPr +'Direct'+ SprPr+ImgRef,3);
          if radioButton2.Checked = true then form1.add_insert('Move Mouse',ComboBox1.Text+ SprPr + ComboBox2.Text+ SprPr +'Indirect'+ SprPr+ImgRef,3);
          if Image1.Picture.Bitmap.Empty = False
          then ImgTab.Add(ImgName,Image1.Picture.Bitmap);
          end
     else begin
          if radioButton1.Checked = true then form1.ListView1.Selected.SubItems.Strings[0] := ComboBox1.Text+ SprPr + ComboBox2.Text+ SprPr +'Direct' + SprPr+ImgRef;
          if radioButton2.Checked = true then form1.ListView1.Selected.SubItems.Strings[0] := ComboBox1.Text+ SprPr + ComboBox2.Text+ SprPr +'Indirect' + SprPr+ImgRef;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          if Image1.Picture.Bitmap.Empty = False
          then ImgTab.Change(ImgName,Image1.Picture.Bitmap);
          end;
     form5.close;
     end
else MessageDlg('Les paramètres X et Y ne peuvent pas être vides.',mtWarning,[mbOk],0);
end;

procedure TForm5.FormShow(Sender: TObject);
var param : string;
    listParam : Tparam;
    ConfigIni : TIniFile;
begin
ConfigIni := TIniFile.Create(Form19.Label22.Caption);
HotKeyManager1.AddHotKey(TextToShortCut(ConfigIni.ReadString('Capture mouse','HotKey','Alt+C')));
HotKey1.HotKey := TextToShortCut(ConfigIni.ReadString('Capture mouse','HotKey','Alt+C'));
OldShortCut := HotKey1.HotKey;
ConfigIni.Free;
Form1.List_Var(ComboBox1.Items, True, True);
Form1.List_Var(ComboBox2.Items, True, True);
Image1.Picture := nil;
Form5.Caption := 'Déplacement Curseur';

if unit1.sw_modif =false
then begin
     pt.x := 0;
     pt.y := 0;
     ComboBox1.Enabled := True;
     ComboBox2.Enabled := True;
     ComboBox1.Text := '0';
     ComboBox2.Text := '0';
     ImgName := ImgTab.GetAutoName;
     end
else begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.Text := ListParam.param[1];
     ComboBox2.Text := ListParam.param[2];
     ComboBox1.Enabled := True;
     ComboBox2.Enabled := True;
     if listParam.param[3] = 'Direct'   then radiobutton1.Checked := true;
     if listParam.param[3] = 'Indirect' then radiobutton2.Checked := true;
     ImgName := ListParam.param[4];
     Image1.Picture.Bitmap := ImgTab.GetImage(ImgName);
     end;
KeyPreview := True;
Stop := true;
end;

procedure TForm5.FormClose(Sender: TObject; var Action: TCloseAction);
var ConfigIni : TIniFile;
begin
ConfigIni := TIniFile.Create(Form19.Label22.Caption);
try
ConfigIni.WriteString('Capture mouse','HotKey',ShortCutToText(HotKey1.HotKey));
HotKeyManager1.RemoveHotKey(HotKey1.HotKey);
finally ConfigIni.Free; end;


KeyPreview := False;
Stop := true;
radiobutton1.Checked := true;
unit1.sw_modif := false;
end;

procedure TForm5.Button2Click(Sender: TObject);
begin
form5.Close;
end;

procedure TForm5.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if (Mykey = 'c') or (Mykey = 'C')
then begin
     if Stop = false
     then begin
          Stop := True;
          ComboBox1.Enabled := True;
          ComboBox2.Enabled := True;
          end
     else begin
          comboBox1.Enabled := False;
          ComboBox2.Enabled := False;
          PosCur();
          end;
     end;
end;

procedure TForm5.FormKeyPress(Sender: TObject; var Key: Char);
begin
MyKey := Key;
end;

procedure TForm5.Label2Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm5.Label3Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm5.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

procedure TForm5.ComboBox2DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox2.Text;
Form1.List_Var(ComboBox2.Items, True, True);
ComboBox2.Text := SaveText;
end;

procedure TForm5.HotKey1Change(Sender: TObject);
begin
HotKeyManager1.RemoveHotKey(OldShortCut);
HotKeyManager1.AddHotKey(HotKey1.HotKey);
end;

procedure TForm5.Button3Click(Sender: TObject);
begin
FnctMoveMouse(ComboBox1.Text+SprPr+ComboBox2.Text+SprPr+'Direct'+SprPr);
end;

end.
