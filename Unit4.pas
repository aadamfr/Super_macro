unit Unit4;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, StdCtrls, ExtCtrls,StrUtils, Menus, AppEvnts;

type
  TForm4 = class(TForm)
    SpeedButton70: TSpeedButton;
    SpeedButton68: TSpeedButton;
    SpeedButton69: TSpeedButton;
    SpeedButton76: TSpeedButton;
    SpeedButton77: TSpeedButton;
    SpeedButton78: TSpeedButton;
    SpeedButton79: TSpeedButton;
    SpeedButton73: TSpeedButton;
    SpeedButton67: TSpeedButton;
    SpeedButton10: TSpeedButton;
    SpeedButton11: TSpeedButton;
    SpeedButton12: TSpeedButton;
    SpeedButton13: TSpeedButton;
    SpeedButton14: TSpeedButton;
    SpeedButton15: TSpeedButton;
    SpeedButton16: TSpeedButton;
    SpeedButton17: TSpeedButton;
    SpeedButton18: TSpeedButton;
    SpeedButton19: TSpeedButton;
    SpeedButton20: TSpeedButton;
    SpeedButton21: TSpeedButton;
    SpeedButton22: TSpeedButton;
    SpeedButton23: TSpeedButton;
    SpeedButton24: TSpeedButton;
    SpeedButton25: TSpeedButton;
    SpeedButton26: TSpeedButton;
    SpeedButton27: TSpeedButton;
    SpeedButton28: TSpeedButton;
    SpeedButton29: TSpeedButton;
    SpeedButton30: TSpeedButton;
    SpeedButton31: TSpeedButton;
    SpeedButton32: TSpeedButton;
    SpeedButton33: TSpeedButton;
    SpeedButton34: TSpeedButton;
    SpeedButton35: TSpeedButton;
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    SpeedButton38: TSpeedButton;
    SpeedButton39: TSpeedButton;
    SpeedButton40: TSpeedButton;
    SpeedButton41: TSpeedButton;
    SpeedButton42: TSpeedButton;
    SpeedButton43: TSpeedButton;
    SpeedButton46: TSpeedButton;
    SpeedButton47: TSpeedButton;
    SpeedButton48: TSpeedButton;
    SpeedButton49: TSpeedButton;
    SpeedButton50: TSpeedButton;
    SpeedButton51: TSpeedButton;
    SpeedButton52: TSpeedButton;
    SpeedButton53: TSpeedButton;
    SpeedButton54: TSpeedButton;
    SpeedButton55: TSpeedButton;
    SpeedButton58: TSpeedButton;
    SpeedButton59: TSpeedButton;
    SpeedButton60: TSpeedButton;
    SpeedButton61: TSpeedButton;
    SpeedButton62: TSpeedButton;
    SpeedButton63: TSpeedButton;
    SpeedButton64: TSpeedButton;
    SpeedButton65: TSpeedButton;
    SpeedButton66: TSpeedButton;
    SpeedButton9: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton71: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton80: TSpeedButton;
    SpeedButton81: TSpeedButton;
    SpeedButton82: TSpeedButton;
    SpeedButton83: TSpeedButton;
    SpeedButton84: TSpeedButton;
    SpeedButton85: TSpeedButton;
    SpeedButton86: TSpeedButton;
    SpeedButton88: TSpeedButton;
    SpeedButton89: TSpeedButton;
    SpeedButton90: TSpeedButton;
    SpeedButton92: TSpeedButton;
    SpeedButton94: TSpeedButton;
    SpeedButton96: TSpeedButton;
    SpeedButton97: TSpeedButton;
    SpeedButton98: TSpeedButton;
    SpeedButton100: TSpeedButton;
    SpeedButton101: TSpeedButton;
    SpeedButton102: TSpeedButton;
    SpeedButton103: TSpeedButton;
    SpeedButton104: TSpeedButton;
    SpeedButton105: TSpeedButton;
    SpeedButton106: TSpeedButton;
    SpeedButton107: TSpeedButton;
    SpeedButton108: TSpeedButton;
    SpeedButton109: TSpeedButton;
    SpeedButton110: TSpeedButton;
    SpeedButton87: TSpeedButton;
    SpeedButton91: TSpeedButton;
    SpeedButton72: TSpeedButton;
    SpeedButton45: TSpeedButton;
    SpeedButton44: TSpeedButton;
    SpeedButton56: TSpeedButton;
    SpeedButton57: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton8: TSpeedButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Shape1: TShape;
    Shape2: TShape;
    Label1: TLabel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Shape7: TShape;
    Shape8: TShape;
    Shape9: TShape;
    Shape10: TShape;
    Shape11: TShape;
    Shape12: TShape;

    procedure Button1Click(Sender: TObject);
    procedure select_touche(sender : Tobject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton1Click(Sender: TObject);
    procedure UpdateKeyBoard();
    procedure LoadLangToTString(ProgressView : Boolean);
    procedure LangDialogShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    function  ExtractLang(List : TStrings) : TStrings;
    function  ExtractSubLang(List : TStrings; LangText : String) : TStrings;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    function StrLen(Text : array of char; startPos : integer) : integer;
    procedure OnClickLg(Sender: TObject);
    procedure OnClickOkButton(Sender: TObject);
    procedure OnClickCancelButton(Sender: TObject);
    procedure PaintSpeedButton(Sender : TControl; var MouseInControl: boolean);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form4: TForm4;
  NbrTouche : integer;
  MyTouche : Array[1..3] of string;
  ListLangId, ListLang : TStrings;
  LangDialog : Tform;
  MyLangID : String;
function EnumLocalesProc(AnotherLocale: PChar): Integer; stdcall;

implementation

uses Unit1, Unit29;

{$R *.DFM}

procedure TForm4.MessageAide(var msg:TMessage);
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

Procedure TForm4.PaintSpeedButton(Sender : TControl; var MouseInControl: boolean);
var Obj : TSpeedButton;
    C: TControlCanvas;
    pt : TPoint;
    Text : String;
    R : TRect;
begin
  R := Sender.ClientRect;
  Obj :=  TSpeedButton(Sender);
  C := TControlCanvas.Create;
  try
    C.Control := Sender;
    C.Brush.Style := bsSolid;
    if Win32MajorVersion < 5
    then C.Brush.Color := clWhite
    else C.Brush.Color := clBlack;
    C.Rectangle(R);
    if MouseInControl
    then C.Draw(-2,-2,Obj.Glyph)
    else C.Draw(0,0,Obj.Glyph);

    C.Brush.Style := bsClear;
    C.Font.Assign(Obj.Font);
    pt.Y := C.TextHeight(Obj.Caption);
    pt.X := C.TextWidth(Obj.Caption);
    pt.Y := (Obj.Height - pt.Y) div 2;
    pt.X := (Obj.Width - pt.X) div 2;
    if MouseInControl then begin Dec(pt.X,2); Dec(pt.Y,2); end;
    if Obj.Caption = '&&' then text := '&' else text := obj.Caption;
    C.TextRect(Obj.ClientRect,pt.X,pt.Y,text);
 finally C.Free; end;
application.ProcessMessages;
end;

function Tform4.StrLen(Text : array of char; startPos : integer) : integer;
var i : integer;
begin
result :=1;
for i := startPos to length(Text)
do if Text[i] <> #0 then result := i+1 else break;

end;


procedure TForm4.OnClickLg(Sender: TObject);
var i : integer;
    Lg, SubLg : TListBox;
begin
Lg := TListBox(LangDialog.FindComponent('Lg'));
if Lg = nil then Exit;
SubLg := TListBox(LangDialog.FindComponent('SubLg'));
if SubLg = nil then Exit;

for i := 0 to Lg.Items.Count -1
do if Lg.Selected[i]
   then SubLg.Items := ExtractSubLang(ListLang, Lg.Items[i]);

end;

procedure TForm4.OnClickOkButton(Sender: TObject);
var i, pos : integer;
    Lg, SubLg : TListBox;
    LgText, SubLgText : String;
    KeyHwnd : Hwnd;
    LanguageID : array [0..64]of Char;
begin
Lg := TListBox(LangDialog.FindComponent('Lg'));
if Lg = nil then Exit;
SubLg := TListBox(LangDialog.FindComponent('SubLg'));
if SubLg = nil then Exit;
try

LgText := '';
for i := 0 to Lg.Items.Count -1
do if Lg.Selected[i]
   then LgText := Lg.Items[i];

SubLgText := '';
for i := 0 to SubLg.Items.Count -1
do if SubLg.Selected[i]
   then SubLgText := SubLg.Items[i];

pos := ListLang.IndexOf(LgText + SubLgText);
if pos = -1 then begin ShowMessage('Erreur de sélection.'); exit; end;
KeyHwnd := LoadKeyboardLayout(PCHar(ListLangId[pos]),KLF_ACTIVATE);
ActivateKeyboardLayout(KeyHwnd,KLF_REORDER);
UpdateKeyBoard();
VerLanguageName(KeyHwnd,LanguageID,63);
Form4.Caption := 'Saisie de touche - '+LanguageId;
MyLangId := LanguageId;
finally LangDialog.Close; LangDialog.Release; end;
end;

procedure TForm4.OnClickCancelButton(Sender: TObject);
var form : TForm;
    Panel : Tpanel;
begin
if TWinControl(Sender).Parent is Tpanel
then begin
     Panel := (TWinControl(Sender).Parent as TPanel);
     form := Tform(Panel.Parent);
     end
else form := (TWinControl(Sender).Parent as TForm);
if form is TForm
then begin
     Form.close;
     Form.Release;
     end;
end;

function TForm4.ExtractLang(List : Tstrings) : TStrings;
var i,j,k, pos : integer;
   Lang : String;
   Exist : Boolean;
   MyList : TStrings;
begin
MyList := TStringList.create;
//try
MyList.Clear;
for i := 0 to List.Count -1
do begin
   Lang := List[i];
   pos := length(Lang)+1;
   for j := 1 to length(Lang)
   do if Lang[j] = '(' then  pos := j;
   Exist := False;

   Lang := LeftStr(Lang,pos-1);
   for k := 0 to MyList.Count -1
   do if MyList[k] = Lang then Exist := True;
   if Exist = False then  MyList.Add(Lang);
   end;
result := MyList;
//MyList.Free
end;

function TForm4.ExtractSubLang(List : Tstrings; LangText : String) : TStrings;
var i,j,k, pos : integer;
   CompareLang, Lang : String;
   Exist : Boolean;
   MyList : TStrings;
begin
MyList := TStringList.create;
//try
MyList.Clear;
pos := 0;
for i := 0 to List.Count -1
do begin
   Lang := List[i];
   for j := 1 to length(Lang)
   do if Lang[j] = '(' then  pos := j;
   Exist := False;
   CompareLang := LeftStr(Lang,pos-1);
   Lang := RightStr(Lang,length(lang)-length(LangText));
   if CompareLang = LangText
   then begin
        for k := 0 to MyList.Count -1
        do if MyList[k] = Lang then Exist := True;
        if Exist = False then  MyList.Add(Lang);
        end;
   end;
result := MyList;
//finally MyList.free; end;
end;

procedure TForm4.LoadLangToTString(ProgressView : Boolean);
var i : integer;
    LanguageID   : Array [0..64] of Char;
    KeyHwnd : Hwnd;
begin
 Form29.ProgressBar1.Position := 0;
 Application.ProcessMessages;
 Form29.Label1.Caption := 'Chargement des langues disponibles, attendez svp.';
 Application.ProcessMessages;
 if ProgressView = True then Form29.Show;
 Application.ProcessMessages;
 ListLangId.Clear;
 ListLang.Clear;
 EnumSystemLocales(@EnumLocalesProc,LCID_INSTALLED);
 for i := 0 to ListLangId.Count -1
 do begin
    if unit29.EchapProgress = True then break;
    KeyHwnd := LoadKeyboardLayout(PChar(ListLangId[i]),KLF_ACTIVATE);
    ActivateKeyboardLayout(KeyHwnd,KLF_REORDER);
    VerLanguageName(KeyHwnd,LanguageID,63);
    ListLang.Add(LanguageID);
    Form29.ProgressBar1.Position := Form29.ProgressBar1.Position +1
    end;
 if ProgressView = True then form29.Close;
end;

procedure TForm4.LangDialogShow(Sender: TObject);
var Lg, SubLg : TListBox;
    LgText, SubLgText : TLabel;
    TopPanel,BottomPanel : TPanel;
    OkButton, CancelButton : TButton;
    i, index : integer;
begin
LangDialog := TForm.Create(Self);
LangDialog.Caption := 'Liste des Langues disponibles';
LangDialog.Position := poMainFormCenter;
LangDialog.FormStyle := fsStayOnTop;
LangDialog.Height := 300;
LangDialog.Width := 400;
LangDialog.Name := 'LangDialog';

TopPanel := Tpanel.Create(LangDialog);
TopPanel.Parent := LangDialog;
TopPanel.Height := 22;
TopPanel.Align := alTop;

LgText := Tlabel.Create(LangDialog);
LgText.Parent := TopPanel;
LgText.Caption := 'Langue';
LgText.Top := 8; LgText.Left := 5;

SubLgText := Tlabel.Create(LangDialog);
SubLgText.Parent := TopPanel;
SubLgText.Caption := 'Sous-Langue';
SubLgText.Top := 8; SubLgText.Left := 125;

Lg := TListBox.Create(LangDialog);
Lg.Parent := LangDialog;
Lg.Align := alLeft;
Lg.Name := 'Lg';
Lg.OnClick := OnClickLg;

SubLg := TListBox.Create(LangDialog);
SubLg.Parent := LangDialog;
SubLg.Align := alClient;
SubLg.Name := 'SubLg';

BottomPanel := Tpanel.Create(LangDialog);
BottomPanel.Parent := LangDialog;
BottomPanel.Height := 42;
BottomPanel.Align := alBottom;

OkButton := TButton.Create(LangDialog);
OkButton.Parent := BottomPanel;
OkButton.Caption := 'Valider';
OkButton.Left := 210; OkButton.Top := 10;
OkButton.OnClick := OnClickOkButton;
//OkButton.Anchors := [akRight,akBottom];
CancelButton := TButton.Create(LangDialog);
CancelButton.Parent := BottomPanel;
CancelButton.Caption := 'Annuler';
CancelButton.Left := 300; CancelButton.Top := 10;
CancelButton.OnClick := OnClickCancelButton;
//CancelButton.Anchors := [akRight,akBottom];

LoadLangToTString(True);
Lg.Items := ExtractLang(ListLang);
if Lg.Items.Count > 0
then begin
     Lg.Selected[0] := True;
     SubLg.Items := ExtractSubLang(ListLang,Lg.Items[0]);
     end;

index := 0;
for i := 1 to length(MyLangId)
do if MyLangId[i] = '('
then begin index := i; break; end;

for i := 0 to Lg.Items.Count -1
do if Lg.Items[i] = LeftStr(MyLangId,index-1)
   then begin Lg.Selected[i] := True; Lg.OnClick(self); break; end;

index := Length(MyLangId)-index+1;
for i := 0 to SubLg.Items.Count -1
do if SubLg.Items[i] = RightStr(MyLangId,index)
   then begin SubLg.Selected[i] := True; break; end;
if XPMenu1.Active = True
then XPMenu1.InitComponent(LangDialog);
LangDialog.show;
end;

function EnumLocalesProc(AnotherLocale: PChar): Integer;
begin
 ListLangId.Add(AnotherLocale);
 {continue enumeration}
 EnumLocalesProc := 1;
end;

procedure TForm4.select_touche(sender : Tobject);
var touche : string;
begin

Touche :=(Sender as TSpeedButton).Hint;

if (Sender as TSpeedButton).Font.Color = clWindowText
then begin
     if NbrTouche > 2 then begin MessageDlg('Le nombre de touche appuyé simultanément ne peut excéder 3.',mtWarning,[mbOk],0); Exit; end;
     (Sender as TSpeedButton).Font.Color := clred;
     if MyTouche[1] = '' then MyTouche[1] := Touche
     else if MyTouche[2] = '' then MyTouche[2] := Touche
     else if MyTouche[3] = '' then MyTouche[3] := Touche;
     Inc(NbrTouche);
     end
else begin
     (Sender as TSpeedButton).Font.Color := clWindowText;
     if MyTouche[1] = Touche then MyTouche[1] := ''
     else if MyTouche[2] = Touche then MyTouche[2] := ''
     else if MyTouche[3] = Touche then MyTouche[3] := '';
     Dec(NbrTouche);
     end;
end;

procedure TForm4.Button1Click(Sender: TObject);
var list_touche : string;
    resultat : string;
begin
if NbrTouche > 0
then begin
     resultat := '';
     if Mytouche[1] <> '' then resultat := resultat + Mytouche[1] + SprPr;
     if Mytouche[2] <> '' then resultat := resultat + Mytouche[2] + SprPr;
     if Mytouche[3] <> '' then resultat := resultat + Mytouche[3] + SprPr;
     if Combobox1.Text = ComboBox1.Items[1] then resultat := resultat + '[KeyDown]' + SprPr;
     if Combobox1.Text = ComboBox1.Items[2] then resultat := resultat + '[KeyUp]' + SprPr;
     List_touche := resultat;

     if unit1.sw_modif = false
     then form1.add_insert('Type Special',list_touche,4)
     else begin
          form1.ListView1.Selected.SubItems.Strings[0] := list_touche;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;

form4.close;
end
else
MessageDlg('Vous devez sélectionner au moins 1 touche clavier.',mtWarning,[mbOk],0);
end;

procedure TForm4.FormShow(Sender: TObject);
var i,j : integer;
    object_touche : TObject;
    ListParam : TParam;
begin
// initialisation
HotKeyManager1.AddHotKey(ShortCut(VK_Capital,[]));

Mytouche[1] := ''; Mytouche[2] := ''; Mytouche[3] := '';
ComboBox1.ItemIndex := 0;
NbrTouche := 0;
// recherche d'une langue pour le clavier
if (SpeedButton1.Caption = '?') and (SpeedButton2.Caption = '?') and
   (SpeedButton3.Caption = '?') and (SpeedButton5.Caption = '?')
then Button3.Click;

if unit1.sw_modif = true
then begin
          ListParam := form1.GetParam(form1.ListView1.Selected.SubItems[0]);
          // vérification que le caractère de séparation des paramètres soit reperé
          for i := 1 to ListParam.nbr_param-1
          do if ListParam.param[i] = '' then begin ListParam.param[i] := SprPr; break; end;; ;

          if ListParam.param[ListParam.nbr_param -1] = '[KeyDown]'
          then ComboBox1.ItemIndex := 1;
          if ListParam.param[ListParam.nbr_param -1] = '[KeyUp]'
          then ComboBox1.ItemIndex := 2;


           for i := 1 to ListParam.nbr_param-1
           do begin
              for j := form4.ComponentCount-1 downto 0
              do begin
                 if form4.Components[j] is TSpeedButton
                 then begin
                      object_touche := form4.Components[j];
                      if (object_touche as TSpeedButton).Hint = ListParam.param[i]
                      then (object_touche as TSpeedButton).click;
                      end;
                 end;
              end;
end;

if (GetKeyState(VK_NUMLOCK) and $01) <> 0
then Shape1.Brush.Color := clLime else Shape1.Brush.Color := clWhite;
if (GetKeyState(VK_CAPITAL) and $01) <> 0
then Shape2.Brush.Color := clLime else Shape2.Brush.Color := clWhite;
end;

procedure TForm4.Button2Click(Sender: TObject);
begin
form4.Close;
end;

procedure TForm4.FormClose(Sender: TObject; var Action: TCloseAction);
var touche : TSpeedButton;
    i : integer;
begin
HotKeyManager1.RemoveHotKey(ShortCut(VK_Capital,[]));

unit1.sw_modif := false;
// reinitialise tous les boutons a la couleur TextWindow
for i := 0to 110
do begin
   touche := TSpeedButton(form4.FindComponent('SpeedButton'+IntToStr(i)));
   if touche = nil then continue;
   if touche.Font.Color = clRed then touche.Font.Color := clWindowText;
   end;
end;

procedure TForm4.SpeedButton1Click(Sender: TObject);
begin
select_touche(Sender);
end;

procedure TForm4.UpdateKeyBoard();
var i : integer;
   SBtn : TSpeedButton;
   KeyName : array[1..100]of char;
   SKeyName : String;
begin
for i := 1 to 110
do begin
   SBtn := (Form4.findComponent('SpeedButton'+ Inttostr(i)) as TSpeedButton);
   if SBtn = nil then continue;
   if Sbtn.Tag < 100
   then GetKeyNameText(Sbtn.Tag*65536,@KeyName,length(KeyName))
   else GetKeyNameText((Sbtn.Tag -100)*65536 + 16777217,@KeyName,length(KeyName));
   SKeyName := LeftStr(KeyName,StrLen(KeyName,1));
   if SKeyName = '' then continue;
   Sbtn.Hint := SKeyName;
   if SKeyName = '&' then SKeyName := '&&';
   if length(SKeyName) > Sbtn.Width  div 7
   then Sbtn.Caption := LeftStr(SKeyName, Sbtn.Width  div 7)
   else Sbtn.Caption := SKeyName;
   end;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
Form4.LangDialogShow(self);
end;

procedure TForm4.FormCreate(Sender: TObject);
var LanguageID : array [0..64]of Char;
begin
VerLanguageName(GetSystemDefaultLangId(),LanguageID,63);
Form4.Caption := 'Saisie de touche - '+LanguageId;
MyLangID := LanguageId;
ListLang := TStringList.Create;
ListLangId := TStringList.Create;
UpdateKeyBoard();
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
ListLang.free;
ListLangId.free;
end;

end.
