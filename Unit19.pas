unit Unit19;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, IniFiles, Buttons,Menus,ShellApi,Registry,
   Dateutils, StrUtils, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, VisualEffect;

const WM_REFRESHSMLAUNCHEXT = WM_USER+2001;
      WM_REFRESHSMLAUNCHINT = WM_USER+2002;

type TMyFont = record
     Color : String;
     Height : String;
     Name : String;
     Size : String;
     fsBold : String;
     fsItalic : String;
     fsUnderLine : String;
     fsStrikeOut : String;
     end;

type TLaunch =record
     ExecName : String[255];
     ActionBy : Byte;
     Day : TDate;
     Time: TTime;
     Frequence : Byte;
     NextExec : TDateTime;
     Link : TShortCut;
     end;

type TLaunchList = array of TLaunch;

type
  TForm19 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    TabSheet2: TTabSheet;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    TPGEdit: TEdit;
    Bevel1: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    CheckBox2: TCheckBox;
    TPFEdit: TEdit;
    Label6: TLabel;
    Bevel2: TBevel;
    Label7: TLabel;
    Bevel3: TBevel;
    Label8: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Bevel4: TBevel;
    CheckBox3: TCheckBox;
    TabSheet3: TTabSheet;
    Label9: TLabel;
    Button3: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    ListBox1: TListBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    TabSheet4: TTabSheet;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    Edit3: TEdit;
    SpeedButton3: TSpeedButton;
    Label12: TLabel;
    SaveDialog1: TSaveDialog;
    FontDialog1: TFontDialog;
    Bevel8: TBevel;
    Label19: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    FontDialog2: TFontDialog;
    TrackBar1: TTrackBar;
    Label24: TLabel;
    Button6: TButton;
    Label25: TLabel;
    Label26: TLabel;
    Edit1: TEdit;
    Label27: TLabel;
    TabSheet5: TTabSheet;
    CheckBox6: TCheckBox;
    ComboBox1: TComboBox;
    CheckBox7: TCheckBox;
    Bevel9: TBevel;
    Label28: TLabel;
    TabSheet6: TTabSheet;
    CheckBox8: TCheckBox;
    Label29: TLabel;
    ComboBox2: TComboBox;
    Label30: TLabel;
    Label31: TLabel;
    Bevel10: TBevel;
    Button7: TButton;
    Label33: TLabel;
    Memo1: TMemo;
    Label35: TLabel;
    Label36: TLabel;
    Button8: TButton;
    Edit2: TEdit;
    Button9: TButton;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    Label5: TLabel;
    Label37: TLabel;
    Edit4: TEdit;
    Label38: TLabel;
    ComboBox3: TComboBox;
    Label39: TLabel;
    PopupMenu1: TPopupMenu;
    Lancementdunemacrouneheureprcise1: TMenuItem;
    Lancementdunemacrolorsdunecombinaisondetouche1: TMenuItem;
    Lancementdunemacrolorsquunobjetesttrouv1: TMenuItem;
    TabSheet8: TTabSheet;
    ColorDialog1: TColorDialog;
    ListBox2: TListBox;
    Label40: TLabel;
    ComboBox4: TComboBox;
    Bevel6: TBevel;
    ModelFont: TButton;
    Label47: TLabel;
    Label48: TLabel;
    Bevel13: TBevel;
    TabSheet9: TTabSheet;
    Label10: TLabel;
    Image2: TImage;
    ListBox3: TListBox;
    ListBox4: TListBox;
    Button5: TButton;
    Bevel5: TBevel;
    Memo3: TMemo;
    Button10: TButton;
    Label11: TLabel;
    Label17: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    Image3: TImage;
    Image4: TImage;
    Label51: TLabel;
    Image5: TImage;
    Label52: TLabel;
    Label23: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label41: TLabel;
    ComboBox5: TComboBox;
    Button11: TButton;
    Image1: TImage;
    Label53: TLabel;
    Label54: TLabel;
    Label55: TLabel;
    Label34: TLabel;
    Label43: TLabel;
    HotKey1: THotKey;
    Image6: TImage;
    Label16: TLabel;
    HotKey2: THotKey;
    Label20: TLabel;
    TabSheet7: TTabSheet;
    DT1: TDateTimePicker;
    Label42: TLabel;
    Label56: TLabel;
    ComboBox6: TComboBox;
    Label57: TLabel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    HotKey3: THotKey;
    Panel1: TPanel;
    ListBox5: TListBox;
    Button12: TButton;
    Button14: TButton;
    Label58: TLabel;
    Image11: TImage;
    Label59: TLabel;
    CheckBox9: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    DT2: TEdit;
    UpDown3: TUpDown;
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure NewItemClick(Sender : TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Label13Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure TPGEditChange(Sender: TObject);
    procedure TPFEditChange(Sender: TObject);
    function ChangeResolEcran(Largeur,Hauteur, ColorResolution:integer; change : Boolean):Integer;
    function ChangeFreqEcran(Frequence : integer; Change : Boolean):Integer;
    procedure FtpClient1SessionConnected(Sender: TObject; Error: Word);
    procedure FtpClient1SessionClosed(Sender: TObject; Error: Word);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Button9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ListBox2DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ComboBox5Change(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure ComboBox4Click(Sender: TObject);
    procedure ChangeGeneralColorText();
    procedure Memo1Enter(Sender: TObject);
    procedure ListBox3Click(Sender: TObject);
    procedure ListBox4Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Memo3Enter(Sender: TObject);
    procedure Label50Click(Sender: TObject);
    procedure HotKey1Enter(Sender: TObject);
    procedure HotKey2Enter(Sender: TObject);
    procedure HotKey1Exit(Sender: TObject);
    procedure HotKey2Exit(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure ListBox5Click(Sender: TObject);
    procedure CheckBox9Click(Sender: TObject);
    procedure HotKey3Enter(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure Label22MouseEnter(Sender: TObject);
    procedure UpDown3Click(Sender: TObject; Button: TUDBtnType);
    procedure DT2Enter(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
    procedure updateParam(FileIniName : String = '');
    function FontToMyFont(Sender : TFont): TMyFont;
    function MyFontToFont(Sender : TMyFont): TFont;
    function WindowsVersion: string;
    procedure LoadLaunchToList(var List,ListAll : TLaunchList);
    procedure SaveLaunchToList(var List,ListAll : TLaunchList);
    procedure RefreshLaunchToList(List : TLaunchList;Component : TListBox);
    procedure DeleteListLaunchIndex(var List : TLaunchList; Index : integer);
    procedure GetNextExec(var Launch : Tlaunch);
    function LaunchToStartWindows(fileName : String; Start : Boolean):Boolean;
    function StartWindows(Name : String):Boolean;
    procedure downloadFile(URL,Fichier : String; TimeOut : integer = 10000);
    procedure WebUpdateStat(Id : dword);
    procedure SaveCommandeColor(filename : String);
  end;

var
  Form19: TForm19;
  MyFont1,MyFont2, MyFont3, MyFont4 : TMyFont;
  AncienneResolutionWidth:Integer;
  AncienneResolutionHeight:Integer;
  AncienneResolutionCouleur:Integer;
  connexion : Boolean = False;
  DateVerif : Boolean = False;
  RunTest : Boolean = False;
  // Lgn
  Lgn_LastExecution : String = 'Dernière exécution : Départ : %s Fin : %s Temps Total : %s';
  Lgn_No_Change : String = 'Pas de changement';
  LaunchList,LaunchListAll : TLaunchList;
  LaunchFileName : string;
implementation

uses Unit1,Unit2,Unit16,Unit23,mdlfnct,ModuleSup,GestionCommande,uBackground, ContextOfExecute;

{$R *.DFM}

procedure TForm19.MessageAide(var msg:TMessage);
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

procedure Tform19.SaveCommandeColor(filename : String);
var ConfigIniDest, ConfigIniScr : TIniFile;
    i,Color : Integer;
begin
if filename = Form1.GetFileIniName then Exit;

ConfigIniDest := TIniFile.Create(filename);
ConfigIniScr := TIniFile.Create(Form1.GetFileIniName);
try
for i := Low(CaseOfExecuteTab) to High(CaseOfExecuteTab)
do begin
   Color := ConfigIniScr.ReadInteger('ColorCommandes', CaseOfExecuteTab[i],clWhite);
   if Color <> clWhite
   then ConfigIniDest.WriteInteger('ColorCommandes', CaseOfExecuteTab[i], Color);
   end;
for i := 0 to Length(DynOrder)-1
do begin
   Color := ConfigIniScr.ReadInteger('ColorCommandes', DynOrder[i].Name,clWhite);
   ConfigIniDest.WriteInteger('ColorCommandes', DynOrder[i].Name, Color);
   end;


finally ConfigIniDest.free; ConfigIniScr.Free; end;

end;

procedure TForm19.WebUpdateStat(Id :Dword);
 var Ts : TStringList;
begin
  Ts := TStringList.Create;
  with TIdHTTP.Create(Application) do
  try
  try
     //Port := 80;
     TS.Add('Id='+IntToStr(Id));
     Request.ContentType := 'application/x-www-form-urlencoded';
     Post('http://adam.denadai.free.fr/StsUpdate.php',Ts);
  except end;
  finally Ts.free; free; end;
end;

procedure TForm19.LoadLaunchToList(var List,ListAll : TLaunchList);
var Fichier : file of TLaunch;
    i,j : integer;
    All : TLaunchList;
begin
LaunchFileName := ExtractFileDir(Application.ExeName)+ '\Launch.dat';
AssignFile(Fichier,LaunchFileName);
if not FileExists(LaunchFileName)
then Rewrite(Fichier)
else Reset(Fichier);
try
SetLength(List,0);
SetLength(ListALL,0);
SetLength(All,0);
i := -1;
while not eof(Fichier)
do begin
   Inc(i);
   SetLength(All,i+1);
   Read(Fichier,All[i]);
   if All[i].ExecName = Form1.StatusBar1.Panels[0].Text
   then begin
        j := length(List);
        SetLength(List,j+1);
        List[j] := All[i];
        end
   else  begin
        j := length(ListAll);
        SetLength(ListAll,j+1);
        ListAll[j] := All[i];
        end;
   end;
finally CloseFile(Fichier); end;
end;

procedure TForm19.SaveLaunchToList(var List,ListAll : TLaunchList);
var Fichier : file of TLaunch;
    i : integer;
begin
AssignFile(Fichier,LaunchFileName);
Rewrite(Fichier);
try
for i := 0 to length(ListAll)-1
do write(Fichier,ListAll[i]);
for i := 0 to length(List)-1
do write(Fichier,List[i]);
finally CloseFile(Fichier); end;
end;

procedure TForm19.RefreshLaunchToList(List : TLaunchList;Component : TListBox);
var i : integer;
    Text : String;
begin
DT1.Date := Int(Now);
DT2.Text := FormatDateTime('hh:mm',now);

Component.Items.Clear;
for i := 0 to length(List)-1
do if List[i].ExecName = Form1.StatusBar1.Panels[0].Text
   then begin
        if List[i].ActionBy = 1
        then begin
             Text := 'Tâche planifée prévu ';
             case List[i].Frequence of
             0 : Text := Text + 'le ';
             1 : Text := Text + 'tout les jours a partir du ';
             2 : Text := Text + 'toutes les semaines a partir du ';
             3 : Text := Text + 'tout les mois a partir du ';
             end;
             Text := Text + DateToStr(List[i].Day) + ' à '+ TimeToStr(List[i].Time)+'.';
             end;
        if List[i].ActionBy = 2
        then begin
             Text := 'Le raccourci clavier  ' +ShortCutToText(List[i].Link) + ' est associé a cette macro.' ;
             end;
        Component.Items.Add(Text);
        end;
end;

procedure TForm19.DeleteListLaunchIndex(var List : TLaunchList; Index : integer);
var count,i : integer;
begin
count := length(List);
if (index < 0) or (index > count-1) then exit;

for i := Index+1 to count-1
do List[i-1] := List[i];

SetLength(List, count-1);
end;

procedure TForm19.GetNextExec(var Launch : Tlaunch);
var DayTime : TDateTime;
    i : integer;
begin
if Launch.ActionBy <> 1 then begin Launch.NextExec :=0; Exit; end;
DayTime := Launch.Day + Launch.Time;
i := 0;
case Launch.Frequence of
     0 : Launch.NextExec := Launch.Day + Launch.Time;
     1 : if DayTime > Now
         then Launch.NextExec := Int(Now) + Launch.Time
         else while DayTime < Now
              do begin
                 Launch.NextExec := Int(IncDay(Now,1)) + Launch.Time;
                 DayTime := Launch.NextExec;
                 end;
     2 : if DayTime > Now
         then Launch.NextExec := Launch.Day + Launch.Time
         else while DayTime < Now
              do begin
                 Inc(i);
                 Launch.NextExec := IncWeek(Launch.Day,i) + Launch.Time;
                 DayTime := Launch.NextExec;
                 end;
     3 : if DayTime > Now
         then Launch.NextExec := Launch.Day + Launch.Time
         else while DayTime < Now
              do begin
              Inc(i);
              Launch.NextExec := IncMonth(Launch.Day,i) + Launch.Time;
              DayTime := Launch.NextExec;
              end;
     end;
end;

function TForm19.LaunchToStartWindows(FileName : String; Start : Boolean):Boolean;
const
  USERS: array[Boolean] of Cardinal = (HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE);
  KEY = 'Software\Microsoft\Windows\CurrentVersion\%s';
  KEY_ONCE: array[Boolean] of string = ('Run', 'RunOnce');
var Reg: TRegistry;
begin
  if not FileExists(FileName) then Begin Result := False; Exit; end;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := USERS[False];
    Result := Reg.OpenKey(Format(KEY, [KEY_ONCE[False]]), True);
    if Result
    then begin
         if Start
         then Reg.WriteString('SMLaunch', FileName) {TODO 1 -oAdam : a corriger plantage avec Start = True}
         else Reg.DeleteValue('SMLaunch');
         end;
  finally
    Reg.Free;
  end;
end;

function TForm19.StartWindows(Name : String):Boolean;
const USERS: array[Boolean] of Cardinal = (HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE);
      KEY = 'Software\Microsoft\Windows\CurrentVersion\%s';
      KEY_ONCE: array[Boolean] of string = ('Run', 'RunOnce');
var Reg: TRegistry;
    fileName : String;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := USERS[False];
    Result := Reg.OpenKey(Format(KEY, [KEY_ONCE[False]]), True);
    FileName := Reg.ReadString(Name);
    if FileExists(FileName) then result := True else result := False;
  finally
    Reg.Free;
  end;
end;

procedure TForm19.ChangeGeneralColorText();
var i,j : integer;
    ConfigIni : TIniFile;
    FileName : String;
    MyForm : TForm;
    TextColor,BackGroundColor : Tcolor;
begin

FileName := Form1.GetFileIniName();
ConfigIni := TIniFile.Create(filename);

try

ubackground.c1 := ConfigIni.ReadInteger('ColorBézier aléatoire', 'Dégradé début', RGB(209,219,221));
ubackground.c2 := ConfigIni.ReadInteger('ColorBézier aléatoire', 'Dégradé fin', RGB(128,155,162));
ubackground.c3 := ConfigIni.ReadInteger('ColorBézier aléatoire', 'Tracé', RGB(128,155,162));

TextColor := ConfigIni.ReadInteger('ColorAffichage', 'Texte', ClWindowText);
BackGroundColor := ConfigIni.ReadInteger('ColorAffichage', 'Fond', ClWindow);
// Changement de la couleur de font et du texte de la form1
Form1.RichEdit2.SelectAll;
Form1.RichEdit2.SelAttributes.Color := TextColor;
Form1.RichEdit2.SelLength := 0;
if XPMenu1.Active = True
then XPMenu1.Font.Color := TextColor;
for i := 1 to 32
do begin
   MyForm := TForm(Application.FindComponent('Form'+IntToStr(i)));
   if MyForm = nil then continue;
   if MyForm.Name = 'Form4' then continue;
   if MyForm.Name = 'Form19' then continue;
   if MyForm.Name = 'Form23' then continue;
   for j := 0 to MyForm.ComponentCount -1
   do begin
      if MyForm.Components[j] is TLabel       then TLabel(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TCheckBox    then TCheckBox(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TRadioButton then begin
                                                   TRadioButton(MyForm.Components[j]).Font.Color := TextColor;
                                                   TRadioButton(MyForm.Components[j]).Tag := 0;
                                                   end;
      if MyForm.Components[j] is TSpeedButton then TSpeedButton(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TEdit        then TEdit(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TPanel       then TPanel(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TPageControl then TPageControl(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TListBox     then TListBox(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TComboBox    then TComboBox(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TTreeView    then TTreeView(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TListView    then TListView(MyForm.Components[j]).Font.Color := TextColor;
      if MyForm.Components[j] is TTreeView    then TTreeView(MyForm.Components[j]).Color := backGroundColor;
      if MyForm.Components[j] is TListView    then TListView(MyForm.Components[j]).Color := backGroundColor;
      if MyForm.Components[j] is TRichEdit    then TRichEdit(MyForm.Components[j]).Color := backGroundColor;
      if MyForm.Components[j] is TButton      then TButton(MyForm.Components[j]).Font.Color := TextColor;
      end;
end;
finally ConfigIni.Free; end;
end;

function TForm19.WindowsVersion: string;
begin
    case Win32MajorVersion of
        3:  Result:='Windows NT 3.51';
        4:  case Win32MinorVersion of
                    0:  case Win32Platform of
                                1:  begin
                                            if length(Win32CSDVersion) =0
                                            then Result:='Windows 95 Emulation mode'
                                            else
                                            case Win32CSDVersion[1] of
                                                'A':    Result:='Windows 95 SP 1';
                                                'B':    Result:='Windows 95 SP 2';
                                            else
                                                Result:='Inconnue';
                                            end;
                                        end;
                                2:  Result:='Windows NT 4.0'
                            else
                                Result:='Inconnue';
                            end;
                    10: begin
                                if length(Win32CSDVersion) =0
                                then Result:='Windows 98 Emulation mode'
                                else
                                case Win32CSDVersion[1] of
                                    'A':    Result:='Windows 98 SP 1';
                                    'B':    Result:='Windows 98 SP 2';
                                else
                                    Result:='Inconnue';
                                end;
                            end;
                    90: Result:='Windows ME';
                else
                    Result:='Inconnue';
                end;
        5:  case Win32MinorVersion of
                    0:  Result:='Windows 2000';
                    1:  Result:='Windows XP';
                else
                    Result:='Inconnue';
                end;
        6: case Win32MinorVersion of
                    0: Result:='Windows Vista';
                    1: Result:='Windows 7';
                    2: Result:='Windows 8';
                else
                    Result:='Inconnue';
                end;
    else
        Result:='Inconnue';
    end;
end;

function DownloadHTTP(const AUrl : string; out DestStream: TStream; const APort : integer = 80): string;
begin
  with TIdHTTP.Create(Application) do
  try
      //Port := APort;
      try
        Get(AUrl,DestStream);
      except
        On e : Exception do
          result := Format('Erreur : %s',[e.Message]);
      end;
  finally
      Free;
  end;
end;

Procedure TForm19.downloadFile(URL, Fichier : String; TimeOut : integer = 10000);
var Data : TFileStream;
    Msg : String;
begin
connexion := False;
Button7.Enabled := False;
Label33.Caption := 'Status : Attendez SVP';

Data := TFileStream.Create(Fichier,fmCreate);
try
Msg := DownloadHTTP(URL, TStream(Data));
if Msg = ''
then Label33.Caption := 'Status : Recherche terminée avec succès.'
else Label33.Caption := Msg;
finally Data.Free; Button7.Enabled := True; end;
end;

function TForm19.ChangeResolEcran(Largeur,Hauteur, ColorResolution:integer; Change : Boolean):Integer;
var
  Retour:Longint;
  DevMode:TDeviceMode;
begin
  DevMode.dmSize:=SizeOf(DevMode);
  DevMode.dmPelsWidth:=Largeur;
  DevMode.dmPelsHeight:=Hauteur;
  DevMode.dmBitsPerPel:=ColorResolution;
  DevMode.dmFields:=DM_BITSPERPEL+DM_PELSWIDTH+DM_PELSHEIGHT; //indique ce que l'on veut modifier.
  Retour := ChangeDisplaySettings(DevMode, CDS_TEST); //CDS_TEST car ce que l'on veut en premier, c'est voir si c'est possible
  if (Retour=DISP_CHANGE_RESTART)    and (Change = True) then MessageDlg('Ne peut modifier la résolution car nécessiterait un redémarrage de Windows',mtInformation,[mbOk],0);
  if (Retour=DISP_CHANGE_FAILED)     and (Change = True) then MessageDlg('Erreur lors du changement de la résolution de l''ecran',mtInformation,[mbOk],0);
  if (Retour=DISP_CHANGE_BADMODE)    and (Change = True) then MessageDlg('Mode Graphique non supporté',mtInformation,[mbOk],0);
  if (Retour=DISP_CHANGE_SUCCESSFUL) and (Change = True) then ChangeDisplaySettings(DevMode, CDS_UPDATEREGISTRY);// là, c'est bon
  Result:=Retour;
end;

function TForm19.ChangeFreqEcran(Frequence : integer; Change : Boolean):Integer;
var
  Retour:Longint;
  DevMode:TDeviceMode;
begin
  DevMode.dmSize:=SizeOf(DevMode);
  DevMode.dmDisplayFrequency := Frequence;
  DevMode.dmFields:=DM_DISPLAYFREQUENCY; //indique ce que l'on veut modifier.
  Retour := ChangeDisplaySettings(DevMode, CDS_TEST); //CDS_TEST car ce que l'on veut en premier, c'est voir si c'est possible
  if (Retour=DISP_CHANGE_RESTART)    and (Change = True) then MessageDlg('Ne peut modifier la résolution car nécessiterait un redémarrage de Windows',mtInformation,[mbOk],0);
  if (Retour=DISP_CHANGE_FAILED)     and (Change = True) then MessageDlg('Erreur lors du changement de la résolution de l''ecran',mtInformation,[mbOk],0);
  if (Retour=DISP_CHANGE_BADMODE)    and (Change = True) then MessageDlg('Mode Graphique non supporté',mtInformation,[mbOk],0);
  if (Retour=DISP_CHANGE_SUCCESSFUL) and (Change = True) then ChangeDisplaySettings(DevMode, CDS_UPDATEREGISTRY);// là, c'est bon
  Result:=Retour;
end;

Function TForm19.FontToMyFont(Sender : TFont): TMyFont;
begin
Result.Color := IntToStr(Sender.Color);
Result.Height := IntToStr(Sender.Height);
Result.Name := Sender.Name;
Result.Size := IntToStr(Sender.Size);
if Sender.Style = [fsBold]  then Result.fsBold := '1' else Result.fsBold := '0';
if Sender.Style = [fsItalic]  then Result.fsItalic := '1' else Result.fsItalic := '0';
if Sender.Style = [fsUnderLine]  then Result.fsUnderLine := '1' else Result.fsUnderLine := '0';
if Sender.Style = [fsStrikeOut]  then Result.fsStrikeOut := '1' else Result.fsStrikeOut := '0';
end;

Function TForm19.MyFontToFont(Sender : TMyFont): TFont;
var MyFontStyles : set of TFontStyle;
begin
result := ModelFont.Font;
result.Color := StrToInt(Sender.Color);
result.Height := StrToInt(Sender.Height);
result.Name := Sender.Name;
if Sender.Size <> ''
then result.Size := StrToInt(Sender.Size)
else result.Size := 8;
MyFontStyles := [];
if Sender.fsBold = '1' then  MyFontStyles := MyFontStyles + [fsBold];
if Sender.fsItalic = '1' then  MyFontStyles:= MyFontStyles + [fsItalic];
if Sender.fsUnderLine = '1' then  MyFontStyles := MyFontStyles + [fsUnderLine];
if Sender.fsStrikeOut = '1' then  MyFontStyles := MyFontStyles + [fsStrikeOut];
result.Style := MyFontStyles;
end;

procedure TForm19.NewItemClick(Sender : TObject);
var outil : String;
begin
outil := TMenuItem(Sender).Hint;
ShellExecute(form1.handle,'Open',  PChar(Outil) ,'','',SW_SHOWNORMAL);
end;

Procedure TForm19.updateParam(FileIniName : String);
var ConfigIni: TIniFile;
    filename, outil : string;
    i : integer;
    NewItem: TMenuItem;
    icone : Ticon;
    lpiIcon : word;
    ListImage : TImageList;
    FileImage : string;
    Img : String;
    FicImg : Textfile;
    StringList : TStringList;
begin
if FileIniName = ''
then FileName := Form1.GetFileIniName()
else FileName := FileIniName;

Label22.Caption := filename;
ConfigIni := TIniFile.Create(filename);

TPGEdit.Text := ConfigIni.ReadString('Delais','General_time','10');
UpDown1.Position := StrToInt(ConfigIni.ReadString('Delais','General_time','10'));
TPFEdit.Text := ConfigIni.ReadString('Delais','Type_time','30');
UpDown2.Position := StrToInt(ConfigIni.ReadString('Delais','Type_time','30'));

TrackBar1.Position := StrToInt(ConfigIni.ReadString('Delais', 'SpeedMouse','10'));
Edit4.Text := ConfigIni.ReadString('Delais', 'PauseMouse','3000');

if ConfigIni.ReadString('Delais', 'General_Actif', 'True') = 'True'
then CheckBox1.checked := True
else CheckBox1.checked := False;

if ConfigIni.ReadString('Delais', 'Type_Actif', 'True') = 'True'
then CheckBox2.Checked := True
else CheckBox2.checked := False;

if ConfigIni.ReadString('General', 'VarHeader', 'True') = 'True'
then CheckBox12.Checked := True
else CheckBox12.checked := False;


if ConfigIni.ReadString('General', 'Mode', 'Insertion') = 'Edition'
then begin
     Radiobutton1.Checked := true;
     form1.edition2.click;
     end
else begin
     Radiobutton2.Checked := True;
     form1.insertion1.click;
     end;
if ConfigIni.ReadString('General', 'Grille', 'False') = 'False'
then begin
     form1.ListView1.GridLines := False;
     checkBox3.Checked := false;
     end
else begin
     form1.ListView1.GridLines := True;
     checkBox3.Checked := true;
     end;
ListBox1.Clear;

// nettoye la liste d'outil
Form1.mesoutils1.Clear;

StringList := TStringList.Create;
try
ConfigIni.ReadSectionValues('Outils', StringList);
for i := 0 to StringList.Count-1  do
begin
outil := Copy(StringList[i],Pos('=',StringList[i])+1,length(StringList[i]));
if ((outil <> '') and (fileexists(outil) = true))
then begin
     ListBox1.Items.Add(outil);
     NewItem := TMenuItem.Create(self);
     NewItem.Caption := IntToStr(i+1)+' - '+ ExtractFileName(outil);
     NewItem.Hint := Outil;
     // passage dans un TimageList pour avoir un format correct de l'icone
     icone := TIcon.create();
     ListImage := TImageList.Create(self);
     try
     Icone.Handle := ExtractAssociatedIcon(hInstance, PChar(outil), lpiIcon);
     ListImage.GetBitmap(ListImage.AddIcon(Icone),NewItem.Bitmap);
     finally ListImage.Free; Icone.Free; end;
     NewItem.OnClick := NewItemclick;
     form1.MesOutils1.Add(NewItem);
     if XPMenu1.Active = True
     then XPMenu1.ActivateMenuItem(NewItem,false);
     end;
end;
finally StringList.Free; end;

//Launch
if Form1.StatusBar1.Panels[0].Text = 'Nouvelle macro'
then Form19.TabSheet7.TabVisible := False
else Form19.TabSheet7.TabVisible := True;
Form19.LoadLaunchToList(LaunchList,LaunchListAll);
RefreshLaunchToList(LaunchList,ListBox5);


// Control
if ConfigIni.ReadString('Control', 'Erreur Execution', 'True') = 'True'
then checkBox4.Checked := True
else checkBox4.Checked := False;

if ConfigIni.ReadString('Control', 'Control Execution', 'True') = 'True'
then checkBox10.Checked := True
else checkBox10.Checked := False;

if ContextOfExecute.ExecutionType = NotRun // pour évité la désactivation
then if ConfigIni.ReadString('Control', 'Rapport', 'False') = 'True'
     then begin checkBox5.Checked := True;  form1.CheckBox3.Checked := True; end
     else begin checkBox5.Checked := False; form1.CheckBox3.Checked := False; end;

Edit1.Text := ConfigIni.ReadString('Control', 'CarSepParam', ';');
if length(Edit1.text) <= 0 then Edit1.text := ';';
unit1.SprPr := Edit1.text[1];
Edit3.Text := ConfigIni.ReadString('Control', 'RapportFile',ExtractFileDir(application.ExeName)+'\rapport.doc' );

if (DirectoryExists(ExtractFileDir(Edit3.Text)) = False)
then Unit1.RapportFileName := ExtractFileDir(application.ExeName) +'\'+ ExtractFileName(Edit3.Text);
if not FileNameValide(Unit1.RapportFileName)
then Unit1.RapportFileName := ExtractFileDir(application.ExeName) +'\rapport.doc';

if  not (ConfigIni.ReadString('Control', 'Anchor Activate', 'False') = 'False')
then checkBox11.Checked := False
else checkBox11.Checked := True;

VisualEffectObjX := StrToInt(ConfigIni.ReadString('VisualEffect', 'ObjectPosX',IntToStr(screen.Monitors[0].Width-80)));
VisualEffectObjY := StrToInt(ConfigIni.ReadString('VisualEffect', 'ObjectPosY',IntToStr(screen.Monitors[0].Height-100)));

MyFont1.Color := ConfigIni.ReadString('FontCommande', 'Color','-2147483640');
MyFont1.Height := ConfigIni.ReadString('FontCommande', 'Height','-11');
MyFont1.Name := ConfigIni.ReadString('FontCommande', 'Name','MS Sans Serif');
MyFont1.Size := ConfigIni.ReadString('FontCommande', 'Size','8');
MyFont1.fsBold := ConfigIni.ReadString('FontCommande', 'fsBold','1');
MyFont1.fsItalic := ConfigIni.ReadString('FontCommande', 'fsItalic','0');
MyFont1.fsUnderLine := ConfigIni.ReadString('FontCommande', 'fsUnderLine','0');
MyFont1.fsStrikeOut := ConfigIni.ReadString('FontCommande', 'fsStrikeOut','0');

MyFont2.Color := ConfigIni.ReadString('FontParam', 'Color','-2147483640');
MyFont2.Height := ConfigIni.ReadString('FontParam', 'Height','-11');
MyFont2.Name := ConfigIni.ReadString('FontParam', 'Name','MS Sans Serif');
MyFont2.Size := ConfigIni.ReadString('FontParam', 'Size','8');
MyFont2.fsBold := ConfigIni.ReadString('FontParam', 'fsBold','0');
MyFont2.fsItalic := ConfigIni.ReadString('FontParam', 'fsItalic','0');
MyFont2.fsUnderLine := ConfigIni.ReadString('FontParam', 'fsUnderLine','0');
MyFont2.fsStrikeOut := ConfigIni.ReadString('FontParam', 'fsStrikeOut','0');

MyFont3.Color := ConfigIni.ReadString('FontVariable', 'Color','128');
MyFont3.Height := ConfigIni.ReadString('FontVariable', 'Height','-11');
MyFont3.Name := ConfigIni.ReadString('FontVariable', 'Name','MS Sans Serif');
MyFont3.Size := ConfigIni.ReadString('FontVariable', 'Size','8');
MyFont3.fsBold := ConfigIni.ReadString('FontVariable', 'fsBold','0');
MyFont3.fsItalic := ConfigIni.ReadString('FontVariable', 'fsItalic','0');
MyFont3.fsUnderLine := ConfigIni.ReadString('FontVariable', 'fsUnderLine','0');
MyFont3.fsStrikeOut := ConfigIni.ReadString('FontVariable', 'fsStrikeOut','0');

MyFont4.Color := ConfigIni.ReadString('PrinterFont', 'Color','-2147483640');
MyFont4.Height := ConfigIni.ReadString('PrinterFont', 'Height','-11');
MyFont4.Name := ConfigIni.ReadString('PrinterFont', 'Name','MS Sans Serif');
MyFont4.Size := ConfigIni.ReadString('PrinterFont', 'Size','8');
MyFont4.fsBold := ConfigIni.ReadString('PrinterFont', 'fsBold','0');
MyFont4.fsItalic := ConfigIni.ReadString('PrinterFont', 'fsItalic','0');
MyFont4.fsUnderLine := ConfigIni.ReadString('PrinterFont', 'fsUnderLine','0');
MyFont4.fsStrikeOut := ConfigIni.ReadString('PrinterFont', 'fsStrikeOut','0');

Label13.Font := MyfontToFont(MyFont1);
Label14.Font := MyfontToFont(MyFont2);
Label15.Font := MyfontToFont(MyFont3);
Label23.Font := MyfontToFont(MyFont4);

// mise en place de la surveillance des combinaison de touche pour l'arret et la mise en pause de la macro
HotKeyManager1.RemoveHotKey(HotKey1.HotKey);
HotKeyManager1.RemoveHotKey(HotKey2.HotKey);
HotKey1.HotKey := TextToShortCut(ConfigIni.ReadString('Control', 'PauseExecute', 'Alt+F1'));
HotKey2.HotKey := TextToShortCut(ConfigIni.ReadString('Control', 'StopExecute', 'Alt+F2'));
HotKeyManager1.AddHotKey(HotKey1.HotKey);
HotKeyManager1.AddHotKey(HotKey2.HotKey);

Form1.SpeedButton29.Hint := 'Pause ('+ShortCutToText(HotKey1.HotKey)+')';
Form1.SpeedButton105.Hint := 'Stop ('+ShortCutToText(HotKey2.HotKey)+')';

if ConfigIni.ReadString('Divers', 'WaitSnd', 'True') = 'True'
then checkBox6.Checked := True
else checkBox6.Checked := False;


ComboBox1.Text := ConfigIni.ReadString('Resolution', 'Format',Lgn_No_Change);


if ConfigIni.ReadString('Resolution', 'ResFin', 'True') = 'True'
then begin CheckBox7.Checked := True; CheckBox7.Enabled := True end
else CheckBox7.Checked := False;

if ConfigIni.ReadString('MAJ', 'Run', 'False') = 'True'
then CheckBox8.Checked := True
else CheckBox8.Checked := False;
ComboBox2.Text := ConfigIni.ReadString('MAJ', 'Frequence', 'Une fois par semaine');
Label36.Caption := ConfigIni.ReadString('MAJ', 'DateVerif',DateCreation);
Label30.Caption := 'Version du logiciel actuelle : ' + Unit1.DateCreation;



// detail des commandes
if ConfigIni.ReadString('Detail', 'afficher','True') = 'True'
then begin Form1.Dtailcommandes1.Checked := False; Form1.Dtailcommandes1.Click; end
else begin Form1.Dtailcommandes1.Checked := True; Form1.Dtailcommandes1.Click; end;

// chargement background disponible
form19.ComboBox5.Clear;
form19.ComboBox5.Items.Add('Aucun');
form19.ComboBox5.Items.Add('Bézier aléatoire');
ScruteDossier(0,ExtractFileDir(application.ExeName),'*.bmp',0,False,ExtractFileDir(application.ExeName)+'\img');
if fileExists(ExtractFileDir(application.ExeName)+'\img')
then begin
     assignFile(FicImg,ExtractFileDir(application.ExeName)+'\img');
     reset(FicImg);
     while not eof(FicImg)
     do begin
        readln(FicImg,Img);
        form19.ComboBox5.Items.Add(ExtractFileName(Img));
        end;
        closeFile(FicImg);
        deletefile(ExtractFileDir(application.ExeName)+'\img');
     end;

form19.ComboBox5.Text := ConfigIni.ReadString('General', 'Background', 'Aucun');
if ExtractFileDir(ComboBox5.Text) =''
then FileImage := ExtractFileDir(Application.ExeName) +'\'+ComboBox5.Text
else FileImage := ComboBox5.Text;
if Fileexists(FileImage)
then try BackGround.LoadFromFile(FileImage) except ConfigIni.WriteString('General', 'Background', 'Aucun'); end
else BackGround.ReleaseHandle;
ComboBox5.OnChange(self);

ChangeGeneralColorText();

StringList := TStringList.Create;
try
ConfigIni.ReadSection('ColorCommandes',StringList);
Setlength(Unit1.ListColorOrder,StringList.Count);
for i := 0 to StringList.Count-1
do begin
   Unit1.ListColorOrder[i].Name := StringList[i];
   Unit1.ListColorOrder[i].Color := ConfigIni.ReadInteger('ColorCommandes',StringList[i], clWhite);
   end;
finally StringList.Free; end;

//CheckBox9.Checked := StartWindows('SMLaunch'); // désactivation provisoire 05/12/08

ConfigIni.UpdateFile;
ConfigIni.Free;
end;


procedure TForm19.UpDown3Click(Sender: TObject; Button: TUDBtnType);
var Strnbr : string;
    cpt : integer;
    chaine : array[1..5] of char;
    PosCur, nbr : integer;
function TimeValide(Text : String): Boolean;
begin
result := False;
if length(Text) <> 5 then Exit;
if not (Text[1] in ['0'..'9']) then exit;
if not (Text[2] in ['0'..'9']) then exit;
if not (Text[3] = ':') then exit;
if not (Text[4] in ['0'..'9']) then exit;
if not (Text[5] in ['0'..'9']) then exit;
result := True;
end;
begin
if DT2.Text = '' then begin DT2.Text := '00:00'; DT2.SelStart := 5; end;
if TimeValide(DT2.Text) then
begin
if length(DT2.Text) >= 5
then for cpt := 1 to 5 do chaine[cpt] := DT2.Text[cpt];
PosCur := DT2.SelStart;

if PosCur in [0..2] then Strnbr := DT2.Text[1] + DT2.Text[2];
if PosCur in [3..5] then Strnbr := DT2.Text[4] + DT2.Text[5];

nbr := StrToInt(Strnbr);
if Button = btNext then Inc(nbr);
if Button = btPrev then Dec(nbr);
// limite
if ((nbr < 0) and (PosCur in [3..5])) then nbr := 59;
if ((nbr < 0) and (PosCur in [0..2])) then nbr := 23;
if ((nbr > 59) and (PosCur in [3..5])) then nbr := 0;
if ((nbr > 23) and (PosCur in [0..2])) then nbr := 0;


if nbr >=10 then StrNbr := IntToStr(nbr) else StrNbr := '0' + IntToStr(nbr);

if PosCur in [0..2] then begin chaine[1] := strnbr[1]; chaine[2] := strnbr[2]; end;
if PosCur in [3..5] then begin chaine[4] := strnbr[1]; chaine[5] := strnbr[2]; end;

DT2.Text := chaine;
DT2.SelStart := PosCur;
//Edit5Change(self);
end;
end;

procedure TForm19.Button2Click(Sender: TObject);
begin
Form19.Close;
end;

procedure TForm19.FormShow(Sender: TObject);
var Dep, Fin, total : TTime;
   timeinSec : real;
   timeOrderBySec : real;
begin
PageControl1.ActivePage := TabSheet1;
Form19.HelpContext := 1174;
Label5.Caption := 'Nombre de commande : ' + IntToStr(Form1.ListView1.Items.Count);
Dep := StrToTime(unit1.TempDepart);
Fin := StrToTime(unit1.TempFin);
total := Fin - Dep;
timeinSec := Secondof(total)+MinuteOf(total)*60 +Hourof(total)*3600;
if unit1.NbrOrderExecute <> 0
then timeOrderBySec := timeinSec / unit1.NbrOrderExecute
else timeOrderBySec := 0;
Label48.Caption := 'Nombre de commande exécuté : ' + IntToStr(unit1.NbrOrderExecute)+ ' (soit ' + Format('%3.6g',[timeOrderBySec]) + ' Sec(s)/commande)';
Label37.Caption := Format(Lgn_LastExecution,[unit1.TempDepart,unit1.TempFin,FormatDateTime('hh:mm:ss',Total)]);
UpdateParam;
end;

procedure TForm19.Button1Click(Sender: TObject);
var ConfigIni: TIniFile;
    filename : string;
    i : integer;
    MyFont1,MyFont2, MyFont3, MyFont4 : TMyFont;
    CmObj : TCmObjet;
    LaunchHwnd : HWND;
begin
Form19.SaveLaunchToList(LaunchList,LaunchListAll);

FileName := Form1.GetFileIniName();

ConfigIni := TIniFile.Create(filename);

// pour l'onglet Delais

ConfigIni.WriteString('Delais', 'General_time', TPGEdit.Text);
ConfigIni.WriteString('Delais', 'Type_time', TPFEdit.text);

ConfigIni.WriteString('Delais', 'SpeedMouse',IntToStr(TrackBar1.position));
ConfigIni.WriteString('Delais', 'PauseMouse',Edit4.Text);

if CheckBox1.Checked = True
then ConfigIni.WriteString('Delais', 'General_Actif', 'True')
else ConfigIni.WriteString('Delais', 'General_Actif', 'False');

if CheckBox2.Checked = True
then ConfigIni.WriteString('Delais', 'Type_Actif', 'True')
else ConfigIni.WriteString('Delais', 'Type_Actif', 'False');

// pour l'onglet Generale
if radiobutton1.Checked = true
then ConfigIni.WriteString('General', 'Mode', 'Edition')
else ConfigIni.WriteString('General', 'Mode', 'Insertion');

if checkBox3.Checked = True
then ConfigIni.WriteString('General', 'Grille', 'True')
else ConfigIni.WriteString('General', 'Grille', 'False');

if checkBox12.Checked = True
then ConfigIni.WriteString('General', 'VarHeader', 'True')
else ConfigIni.WriteString('General', 'VarHeader', 'False');

// pour l'onglet outils
ConfigIni.EraseSection('Outils');
for i := 0 to ListBox1.Items.Count - 1 do
ConfigIni.WriteString('Outils', 'exe' + IntToStr(i), ListBox1.Items.Strings[i]);

// pour Control
if checkBox4.Checked = True
then ConfigIni.WriteString('Control', 'Erreur Execution', 'True')
else ConfigIni.WriteString('Control', 'Erreur Execution', 'False');

if checkBox10.Checked = True
then ConfigIni.WriteString('Control', 'Control Execution', 'True')
else ConfigIni.WriteString('Control', 'Control Execution', 'False');

if checkBox11.Checked = True
then ConfigIni.WriteString('Control', 'Anchor Activate', 'False')
else ConfigIni.WriteString('Control', 'Anchor Activate', 'True');


if checkBox5.Checked = True
then ConfigIni.WriteString('Control', 'Rapport', 'True')
else ConfigIni.WriteString('Control', 'Rapport', 'False');

ConfigIni.WriteString('Control', 'RapportFile', Edit3.Text);
ConfigIni.WriteString('Control', 'CarSepParam', Edit1.Text);

MyFont1 := FontToMyFont(Label13.Font);
MyFont2 := FontToMyFont(Label14.Font);
MyFont3 := FontToMyFont(Label15.Font);
MyFont4 := FontToMyFont(Label23.Font);

ConfigIni.WriteString('FontCommande', 'Color', MyFont1.Color);
ConfigIni.WriteString('FontCommande', 'Height', MyFont1.Height);
ConfigIni.WriteString('FontCommande', 'Name', MyFont1.Name);
ConfigIni.WriteString('FontCommande', 'Size', MyFont1.Size);
ConfigIni.WriteString('FontCommande', 'fsBold', MyFont1.fsBold);
ConfigIni.WriteString('FontCommande', 'fsItalic', MyFont1.fsItalic);
ConfigIni.WriteString('FontCommande', 'fsUnderLine', MyFont1.fsUnderLine);
ConfigIni.WriteString('FontCommande', 'fsStrikeOut', MyFont1.fsStrikeOut);

ConfigIni.WriteString('FontParam', 'Color', MyFont2.Color);
ConfigIni.WriteString('FontParam', 'Height', MyFont2.Height);
ConfigIni.WriteString('FontParam', 'Name', MyFont2.Name);
ConfigIni.WriteString('FontParam', 'Size', MyFont2.Size);
ConfigIni.WriteString('FontParam', 'fsBold', MyFont2.fsBold);
ConfigIni.WriteString('FontParam', 'fsItalic', MyFont2.fsItalic);
ConfigIni.WriteString('FontParam', 'fsUnderLine', MyFont2.fsUnderLine);
ConfigIni.WriteString('FontParam', 'fsStrikeOut', MyFont2.fsStrikeOut);

ConfigIni.WriteString('FontVariable', 'Color', MyFont3.Color);
ConfigIni.WriteString('FontVariable', 'Height', MyFont3.Height);
ConfigIni.WriteString('FontVariable', 'Name', MyFont3.Name);
ConfigIni.WriteString('FontVariable', 'Size', MyFont3.Size);
ConfigIni.WriteString('FontVariable', 'fsBold', MyFont3.fsBold);
ConfigIni.WriteString('FontVariable', 'fsItalic', MyFont3.fsItalic);
ConfigIni.WriteString('FontVariable', 'fsUnderLine', MyFont3.fsUnderLine);
ConfigIni.WriteString('FontVariable', 'fsStrikeOut', MyFont3.fsStrikeOut);

ConfigIni.WriteString('PrinterFont', 'Color', MyFont4.Color);
ConfigIni.WriteString('PrinterFont', 'Height', MyFont4.Height);
ConfigIni.WriteString('PrinterFont', 'Name', MyFont4.Name);
ConfigIni.WriteString('PrinterFont', 'Size', MyFont4.Size);
ConfigIni.WriteString('PrinterFont', 'fsBold', MyFont4.fsBold);
ConfigIni.WriteString('PrinterFont', 'fsItalic', MyFont4.fsItalic);
ConfigIni.WriteString('PrinterFont', 'fsUnderLine', MyFont4.fsUnderLine);
ConfigIni.WriteString('PrinterFont', 'fsStrikeOut', MyFont4.fsStrikeOut);

// pour l'onglet MAJ
if CheckBox8.Checked = true
then ConfigIni.WriteString('MAJ', 'Run', 'True')
else ConfigIni.WriteString('MAJ', 'Run', 'False');
ConfigIni.WriteString('MAJ', 'Frequence', ComboBox2.Text);
if DateVerif = True
then ConfigIni.WriteString('MAJ', 'DateVerif', DateToStr(Now));
DateVerif := False;

// pour l'onglet Generale
if CheckBox6.Checked = true
then ConfigIni.WriteString('Divers', 'WaitSnd', 'True')
else ConfigIni.WriteString('Divers', 'WaitSnd', 'False');

// pour l'onglet divers
ConfigIni.WriteString('Resolution', 'Format',ComboBox1.Text);

if CheckBox7.Checked = True
then ConfigIni.WriteString('Resolution', 'ResFin', 'True')
else ConfigIni.WriteString('Resolution', 'ResFin', 'False');

// arrêt de l'execution
ConfigIni.WriteString('Control', 'PauseExecute', ShortCutToText(HotKey1.HotKey));
ConfigIni.WriteString('Control', 'StopExecute', ShortCutToText(HotKey2.HotKey));

ConfigIni.WriteString('General', 'Background', ComboBox5.Text);

ConfigIni.UpdateFile;
ConfigIni.Free;
Updateparam;
if FileName <> Form1.GetFileIniName()
then MessageDlg('Les options ont été enregistrées pour la macro suivante : '+ FileName, mtInformation,[mbOk], 0);

// recherche de handle de l'application SMLaunch
Form16.ListComObjInit(CmObj);
CmObj.Classe := 'TLaunchForm'; CmObj.SelClasse := True;
CmObj.Texte := 'SMLaunch'; CmObj.SelTexte := True;
//CmObj.Module := 'smlaunch.exe'; CmObj.SelModule := True;
LaunchHwnd := form16.Fnct_FindObject(CmObj);

// demande de refresh des tâches
PostMessage(LaunchHwnd,WM_REFRESHSMLAUNCHEXT ,0,0);

Form19.close;
end;

procedure TForm19.Button3Click(Sender: TObject);
begin
Opendialog1.DefaultExt := '*.exe';
OpenDialog1.Filter := 'Fichiers exécutable (*.exe)|*.exe|Tous (*.*)|*.*';

If OpenDialog1.Execute
then ListBox1.Items.Add(Opendialog1.Filename);
end;

procedure TForm19.Button4Click(Sender: TObject);
var i : integer;
begin
for i := ListBox1.Items.Count - 1 downto 0 do
if ListBox1.Selected[i] = True then ListBox1.Items.Delete(i);
end;

procedure TForm19.SpeedButton1Click(Sender: TObject);
var i : integer;
    select : integer;
begin
select := -1;
for i := ListBox1.Items.Count - 1 downto 0 do
if ((ListBox1.Selected[i] = True) and (i <> 0))
then begin
     ListBox1.Items.Move(i ,i-1 );
     select := i-1;
     end;
if select <> -1 then ListBox1.ItemIndex := select;
end;

procedure TForm19.SpeedButton2Click(Sender: TObject);
var i : integer;
    select : integer;
begin
select := -1;
for i := ListBox1.Items.Count - 1 downto 0 do
if ((ListBox1.Selected[i] = True) and (i < ListBox1.Items.Count - 1))
then begin
     ListBox1.Items.Move(i ,i+1 );
     select := i+1;
     end;
if select <> -1 then ListBox1.ItemIndex := select;
end;

procedure TForm19.SpeedButton3Click(Sender: TObject);
begin
if Edit3.Text <> '' then Savedialog1.InitialDir := ExtractFileDir(Edit3.Text);
if SaveDialog1.Execute
then Edit3.Text := SaveDialog1.FileName;
end;

procedure TForm19.Label13Click(Sender: TObject);
begin
FontDialog1.Font := (Sender as TLabel).Font;
If FontDialog1.Execute then (Sender as TLabel).Font := FontDialog1.Font;
end;

procedure TForm19.Label22MouseEnter(Sender: TObject);
begin
Label22.Hint := Label22.Caption;
end;

procedure TForm19.FormCreate(Sender: TObject);
var CanUpdate : Boolean;
begin
CanUpdate := False;
DateSeparator := '/';
ShortDateFormat := 'dd/mm/yy';
LongDateFormat := 'dd/mm/yyyy';

AncienneResolutionWidth:=Screen.Width;
AncienneResolutionHeight:=Screen.Height;
AncienneResolutionCouleur:=GetDeviceCaps(Form1.Canvas.Handle, BITSPIXEL)*GetDeviceCaps(Form1.Canvas.Handle, PLANES);
form19.updateParam; // Chargement Generale des parametres de super macro
try
if Form19.checkBox8.Checked = True
then begin
     if Form19.ComboBox2.Text = 'A chaque démarrage de l''éditeur' then CanUpdate := True;
     if (Form19.ComboBox2.Text = 'Une fois par semaine') and (StrToDate(Label36.caption) +7 < Now) then CanUpdate := True;
     if (Form19.ComboBox2.Text = 'Une fois par mois') and (StrToDate(Label36.caption) +30 < Now) then CanUpdate := True;
     end;
except on EConvertError do CanUpdate := False end;

  // déclanchement de la recherche de MAJ
if (Application.ShowMainForm = True) and (CanUpdate = True)
  then begin
       Form19.Button7.Click; // Pour recherche de la mise à jour
       Form19.Button1.Click; // Pour mettre a jour les paramètre et en particulier la date de MAJ
       end;
end;

procedure TForm19.PageControl1Change(Sender: TObject);
var i : integer;
begin
if RunTest = True // assure de l'arrêt du teste Clavier/Souris
then begin Button8.Click; RunTest := True; Button9.Click; end;

if ((Sender as TPageControl).ActivePage = TabSheet1) then form19.HelpContext := 1174;
if ((Sender as TPageControl).ActivePage = TabSheet2) then form19.HelpContext := 1175;
if ((Sender as TPageControl).ActivePage = TabSheet3) then form19.HelpContext := 1176;
if ((Sender as TPageControl).ActivePage = TabSheet4) then form19.HelpContext := 1177;
if ((Sender as TPageControl).ActivePage = TabSheet5) then form19.HelpContext := 1178;
if ((Sender as TPageControl).ActivePage = TabSheet6) then form19.HelpContext := 1179;
if ((Sender as TPageControl).ActivePage = TabSheet7) then form19.HelpContext := 1192;
if ((Sender as TPageControl).ActivePage = TabSheet8) then form19.HelpContext := 1180;
if ((Sender as TPageControl).ActivePage = TabSheet9) then form19.HelpContext := 1181;

if ((Sender as TPageControl).ActivePage = TabSheet8) then ComboBox4.OnClick(self);
if ((Sender as TPageControl).ActivePage = TabSheet9)
then begin
     ListBox3.Clear; ListBox4.Clear;
     for i := 0 to Length(DynOrder)-1
     do if DynOrder[i].Name <> ''
        then ListBox3.items.add(DynOrder[i].Rubrique);
     form1.NoDoublonofListBox(ListBox3);
     if ListBox3.Items.Count > 0 then  ListBox3.Selected[0] := True;
     ListBox3.OnClick(self);
     end;
end;

procedure TForm19.TrackBar1Change(Sender: TObject);
begin
TrackBar1.Tag :=  (TrackBar1.Max - TrackBar1.position);
TrackBar1.SelEnd := TrackBar1.position;
TrackBar1.Hint := 'Valeur:' + IntToStr(TrackBar1.position);
end;

procedure TForm19.Button6Click(Sender: TObject);
var FileHandle: Integer;
    FileName : String;
begin
FileName := ChangeFileExt(Form1.statusBar1.Panels[0].Text,'.ini');
FileHandle := FileCreate(FileName);
if FileHandle <> -1
then begin
     FileClose(FileHandle);
     SaveCommandeColor(FileName);
     Button1.Click;
     end
else  MessageDlg('Impossible de créer le fichier de configuration.', mtInformation,[mbOk], 0);
end;

procedure TForm19.TPGEditChange(Sender: TObject);
begin
try
StrToInt(TPGEdit.Text);
except on EConvertError
do begin
   MessageDlg('Délais général dans les options invalide.',mtError,[mbOk],0);
   TPGEdit.Text := '10';
   if RunTest = True then Edit2.SetFocus;
   end;
   end;
end;

procedure TForm19.TPFEditChange(Sender: TObject);
begin
try
StrToInt(TPFEdit.Text);
except on EConvertError
do begin
   MessageDlg('Délais tape de texte dans les options invalide.',mtError,[mbOk],0);
   TPFEdit.Text := '30';
   if RunTest = True then Edit2.SetFocus;
   end;
   end;
end;

procedure TForm19.FtpClient1SessionConnected(Sender: TObject; Error: Word);
begin
connexion := True;
end;

procedure TForm19.FtpClient1SessionClosed(Sender: TObject; Error: Word);
begin
connexion := False;
end;

procedure TForm19.Button7Click(Sender: TObject);
var UpdateFileName : String;
    cpt, DelPos : integer;
    eff, MAJ : Boolean;
begin
Eff := False;
DelPos := 0;
DateVerif := True;
updatefilename := ExtractFileDir(Application.ExeName)+ '\update.ini';
Memo1.Clear;
DownLoadFile('http://adam.denadai.free.fr/Download/update.ini',updatefilename);

if (error = 0) and (FileExists(UpDateFileName))
then begin
     memo1.Visible := False;
     memo1.Lines.LoadFromFile(updatefilename);
     for cpt := 0 to memo1.Lines.Count -1 do
     begin
     if Eff = False
     then begin
          if FnctIsDate(memo1.Lines.Strings[cpt]) = True
          then if StrToDate(memo1.Lines.Strings[cpt]) <= StrToDate(DateCreation)
               then begin Eff := True; DelPos := cpt; end;
          end;
     if Eff = True then Memo1.Lines.Delete(DelPos);
     end;
     MAJ := False;
     for cpt := 0 to memo1.Lines.Count -1 do if memo1.Lines.Strings[cpt] <> '' then MAJ := True;
     memo1.Lines.Insert(0,'');
     if MAJ = False then memo1.Lines.Insert(0,'Aucune mise à jour n''a été trouvée sur le serveur.');
     deletefile(UpDateFileName);
     memo1.Visible := True;
     

     if (form19.Visible = True) and (PageControl1.ActivePage = TabSheet6)
     then  memo1.SetFocus;
     if MAJ = True then if MessageDlg('Une version plus recente de Super Macro existe. Voulez vous la télécharger ?',mtConfirmation, [mbYes, mbNo], 0) = mrYes
                        then ShellExecute(form1.handle,'Open',  PChar('http://adam.denadai.free.fr/Download/SuperMacro_install.exe') ,'','',SW_HIDE);
     Label36.Caption := DateToStr(Now);
     end
else Label33.Caption := 'Status : Echec lors de la connexion serveur.';
end;

procedure TForm19.Button8Click(Sender: TObject);
var x,y : String;
    ScrNr,maxX, index : integer;
begin
if RunTest = False
then begin
     //VisualEffectLoad(ExtractFileDir(Application.Exename)+'\Move mouse.gif',point(screen.Monitors[0].Width-120,screen.Monitors[0].Height-140),point(10,100),True);
     RunTest := True;
     Button8.Caption := 'Stop';
     label7.Caption := 'Vous êtes en train de tester la vitesse de la souris. Pour arrêter ce test appuiez sur Entrée, pour diminuer ou augmenter la vitesse de la souris utilisez les touche + ou - du pavé numérique.';
     label7.Font.Color := clRed;
     randomize;
     while RunTest = True
     do begin
        Application.ProcessMessages;
        if PageControl1.ActivePage = TabSheet2
        then Form19.Button8.SetFocus;

        maxX := 0;
        ScrNr := random(screen.MonitorCount);

        for index := 0 to ScrNr-1
        do Inc(maxX, Screen.Monitors[index].Width);

        x := IntToStr(random(Screen.Monitors[ScrNr].Width)+ maxX);
        y := IntToStr(random(Screen.Monitors[ScrNr].Height));
        Unit1.Run := True;
        FnctMoveMouse(x +SprPr+ y +SprPr +'Indirect' +SprPr);
        Unit1.Run := False;
        end;
     end
else begin
     RunTest := False;
     Unit1.Run := False;
     Button8.Caption := 'Tester la souris';
     Label7.Caption := 'Il est parfois nécessaire de mettre un temps de pause afin que les commandes de frappe de caractère se déroulent correctements.';
     Label7.Font.Color := ClBlack;
     //VisualEffectQuit();
     end;
end;

procedure TForm19.Button8KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if RunTest = True
then begin
     if Key = VK_Return then Button8.Click;
     if Key = VK_Subtract then TrackBar1.Position := TrackBar1.Position - 1;
     if Key = VK_Add then  TrackBar1.Position := TrackBar1.Position + 1;
     end;
end;

procedure TForm19.Button9Click(Sender: TObject);
begin
if RunTest = False
then begin
     RunTest := True;
     Edit2.Text := '';
     Edit2.Visible := True;
     Button9.Caption := 'Stop';
     Unit1.Run := True;
     while RunTest = True do
     begin
           Button9.Enabled := False;
           Edit2.Text := '';
           Edit2.SetFocus;
           Form19.Cursor := crHourGlass; TabSheet2.Cursor := crHourGlass;
           FnctType('Test la vitesse de frappe de Super Macro');
           Form19.Cursor := crDefault; TabSheet2.Cursor := crDefault;
           Button9.Enabled := True;
           Form1.FnctPause('1600'+SprPr+'MilliSec'+SprPr);
     end;
     end
else begin
     Unit1.Run := False;
     RunTest := False;
     Edit2.Visible := False;
     Button9.Caption := 'Tester le clavier';
     end;

end;

procedure TForm19.FormClose(Sender: TObject; var Action: TCloseAction);
begin
RunTest := False;
if Button8.Caption = 'Stop' then Button8.Click;
end;

procedure TForm19.ComboBox3Change(Sender: TObject);
var ConfigIni: TIniFile;
begin
ConfigIni := TIniFile.Create(form19.Label22.caption);
try
ConfigIni.WriteString('Langage', 'Lng',ComboBox3.Text);
ConfigIni.UpdateFile;
finally ConfigIni.Free; end;

LoadLanguage(Combobox3.Text);
end;

procedure TForm19.ComboBox1Change(Sender: TObject);
begin
if ComboBox1.Text = Lgn_No_Change
then CheckBox7.Enabled := False
else CheckBox7.Enabled := True;
end;

procedure TForm19.ListBox2DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var offset: Integer;      { largeur de décalage du texte }
    MyRect : TRect;
    MyColor : integer;
    ConfigIni: TIniFile;
    filename : string;
    sousRub : string;
begin
filename := Label22.Caption;
ConfigIni := TIniFile.Create(filename);
try
SousRub := (Control as TListBox).Items[Index];
if SousRub <> ''
then MyColor := ConfigIni.ReadInteger('Color'+ComboBox4.Text,SousRub, clWhite)
else MyColor := clWhite;
finally ConfigIni.free; end;

if ComboBox4.Text = 'Police de caractère'
then begin
     if index = 0 then (Control as TListBox).Canvas.Font := Label23.Font;
     if index = 1 then (Control as TListBox).Canvas.Font := Label13.Font;
     if index = 2 then (Control as TListBox).Canvas.Font := Label14.Font;
     if index = 3 then (Control as TListBox).Canvas.Font := Label15.Font;
     (Control as TListBox).Canvas.Font.Size := 8;
     end;


{
if ComboBox4.Text = 'Bézier aléatoire'
then begin
     if index = 0 then MyColor := UBackGround.C1;
     if index = 1 then MyColor := UBackGround.C2;
     if index = 2 then MyColor := UBackGround.C3;
     end; }

MyRect.Top := Rect.Top +2;
MyRect.Bottom := Rect.Bottom -2;
MyRect.Left := 2;
MyRect.Right := 36;
	with (Control as TListBox).Canvas do  { Le dessin se fait sur le canevas du contrôle, pas dans la fiche }
	begin
	FillRect(Rect);       { efface le rectangle }
	Offset := 40;          { fournit le décalage par défaut }
	TextOut(Rect.Left + Offset, Rect.Top, (Control as TListBox).Items[Index]);  { affiche le texte }
        Brush.Color := MyColor;
        Rectangle(MyRect);
        Brush.Color := clWhite;
	end;
end;

procedure TForm19.ComboBox5Change(Sender: TObject);
begin
if ExtractFileDir(ComboBox5.Text) = ''
then if not FileExists(ExtractFileDir(Application.ExeName)+'\'+ComboBox5.Text)
     then image1.Picture := nil
     else image1.Picture.LoadFromFile(ExtractFileDir(Application.ExeName)+'\'+ComboBox5.Text)
else if not FileExists(ComboBox5.Text)
     then image1.Picture := nil
     else image1.Picture.LoadFromFile(ComboBox5.Text);
if (ComboBox5.Text = 'Bézier aléatoire')
then begin
     Image1.Picture.Bitmap.Height := Image1.Height;
     Image1.Picture.Bitmap.Width := Image1.Width;
     ubackground.DrawBesiez(Image1.Picture.Bitmap);
     end;
end;

procedure TForm19.ListBox2DblClick(Sender: TObject);
var i, sel : integer;
    ConfigIni: TIniFile;
    filename : string;
begin
if ComboBox4.Text = 'Police de caractère'
then begin
     i := form1.GetListBoxSelected(ListBox2);
     if i = 0 then Label23.OnClick(Label23);
     if i = 1 then Label13.OnClick(Label13);
     if i = 2 then Label14.OnClick(Label14);
     if i = 3 then Label15.OnClick(Label15);
     Exit;
     end;

sel := -1;
for i := 0 to ListBox2.Items.Count -1
do if ListBox2.Selected[i] = True
   then begin
        sel := i;
        break;
        end;
filename := Label22.Caption;
ConfigIni := TIniFile.Create(filename);
ColorDialog1.Color := ConfigIni.ReadInteger('Color'+ComboBox4.Text, ListBox2.Items[sel], ClWhite);
ConfigIni.free;

if ComboBox4.Text = 'Bézier aléatoire'
then begin
     i := form1.GetListBoxSelected(ListBox2);
     if i = 0 then ColorDialog1.Color := UBackGround.C1;
     if i = 1 then ColorDialog1.Color := UBackGround.C2;
     if i = 2 then ColorDialog1.Color := UBackGround.C3;
     end;

if ColorDialog1.Execute
then begin
     if sel <> -1
     then begin
          filename := Label22.Caption;
          ConfigIni := TIniFile.Create(Form1.GetFileIniName);
          ConfigIni.WriteInteger('Color'+ComboBox4.Text, ListBox2.Items[sel], ColorDialog1.Color);
          ConfigIni.free;
          ListBox2.Repaint;
          end;
     end;
end;

procedure TForm19.ComboBox4Click(Sender: TObject);
var i : integer;
begin
if ComboBox4.Text = 'Commandes'
then begin
     with ListBox2
     do begin
        Clear;
        for i := Low(CaseOfExecuteTab) to High(CaseOfExecuteTab)
        do Items.Append(CaseOfExecuteTab[i]);
        for i := 0 to Length(DynOrder)-1
        do Items.Append(GestionCommande.DynOrder[i].Name);
        end;
     end;
if ComboBox4.Text = 'Affichage'
then begin
     with ListBox2
     do begin
        Clear;
        Items.Append('Texte');
        Items.Append('Fond');
        end;
     end;
if ComboBox4.Text = 'Police de caractère'
then begin
     with ListBox2
     do begin
        Clear;
        Items.Append('Impression');
        Items.Append('Commande');
        Items.Append('Paramètre');
        Items.Append('Variable');
        end;
     end;

if ComboBox4.Text = 'Bézier aléatoire'
then begin
     with ListBox2
     do begin
        Clear;
        Items.Append('Dégradé début');
        Items.Append('Dégradé fin');
        Items.Append('Tracé');
        end;
     end;
end;
procedure TForm19.Memo1Enter(Sender: TObject);
begin
TabSheet6.SetFocus;
end;

procedure TForm19.ListBox3Click(Sender: TObject);
var i : integer;
begin
ListBox4.Clear;
for i := 0 to Length(DynOrder)-1
do if (DynOrder[i].Name <> '') and (DynOrder[i].Rubrique = ListBox3.Items[Form1.GetListBoxSelected(ListBox3)])
   then ListBox4.items.add(DynOrder[i].Name);
        form1.NoDoublonofListBox(ListBox4);
        if ListBox4.Items.Count > 0 then  ListBox4.Selected[0] := True;
        ListBox4.OnClick(self);
end;

procedure TForm19.ListBox4Click(Sender: TObject);
var i : integer;
begin
memo3.Clear;
image3.Picture := nil;
if ListBox4.Items.Count = 0 then Exit;
for i := 0 to Length(DynOrder)-1
do begin
   if (DynOrder[i].Name = ListBox4.Items[Form1.GetListBoxSelected(ListBox4)])
   and (DynOrder[i].Rubrique = ListBox3.Items[Form1.GetListBoxSelected(ListBox3)])
   then begin
        memo3.Lines.Append(DynOrder[i].dllName);
        memo3.Lines.Append('Description: ' +DynOrder[i].Description);
        form1.ImageList1.GetIcon(DynOrder[i].IconIndex,image3.Picture.Icon);
        image3.Refresh;
        end;
   end;
end;

procedure TForm19.Button11Click(Sender: TObject);
begin
Opendialog1.DefaultExt := '*.bmp';
OpenDialog1.Filter := 'Fichiers image (*.bmp)|*.bmp';

if ExtractFileDir(Combobox5.Text) <> ''
then Opendialog1.InitialDir := ExtractFileDir(Combobox5.Text)
else Opendialog1.InitialDir := ExtractFileDir(Application.ExeName);

if Opendialog1.Execute
then begin
     Combobox5.Text := Opendialog1.FileName;
     Combobox5.OnChange(self);
     end;
end;

procedure TForm19.Button5Click(Sender: TObject);
var IndexNew : integer;
    i : integer;
    ConfigIni : TIniFile;
begin
form1.Opendialog2.Filter := 'Plugin|*.dll';
form1.Opendialog2.DefaultExt := '*.dll';

if form1.Opendialog2.Execute
then begin
     IndexNew := GestionCommande.AddOrder(Pchar(form1.Opendialog2.FileName));
     if IndexNew <> -1
     then begin
          ListBox3.Items.Append(DynOrder[IndexNew].Rubrique);
          form1.NoDoublonofListBox(ListBox3);
          for i := 0 to ListBox3.Items.Count -1
          do if ListBox3.Items[i] = DynOrder[IndexNew].Rubrique
             then ListBox3.Selected[i] := True;
          ListBox3.OnClick(self);
          for i := 0 to ListBox4.Items.Count -1
          do if ListBox4.Items[i] = DynOrder[IndexNew].Name
             then ListBox4.Selected[i] := True;
          ListBox4.OnClick(self);

          ConfigIni := TIniFile.Create(Form1.GetFileIniName);
          try
          ConfigIni.EraseSection('DynOrder');
          for i := 0 to Length(DynOrder)-1
          do if DynOrder[i].Name <> ''
          then ConfigIni.WriteString('DynOrder', InttoStr(i), DynOrder[i].dllName);
          finally ConfigIni.UpdateFile; ConfigIni.Free; end;
          end;
     end;
end;

procedure TForm19.Button10Click(Sender: TObject);
var i,j : integer;
    Find : Boolean;
    ConfigIni : TIniFile;
begin
if (Form1.GetListBoxSelected(ListBox4) < 0) or (Form1.GetListBoxSelected(ListBox3) < 0)
then Exit;

Find := False;

for i := 0 to Length(DynOrder)-1
do begin
   if (DynOrder[i].Name = ListBox4.Items[Form1.GetListBoxSelected(ListBox4)])
   and (DynOrder[i].Rubrique = ListBox3.Items[Form1.GetListBoxSelected(ListBox3)])
   then begin
        Find := True;
        FreeLibrary(DynOrder[i].Handle);
        DynOrder[i].Name := '';
        TSpeedButton(DynOrder[i].PointerSbtn).free;
        for j := form1.PageControl2.PageCount-1 downto 0
        do if form1.PageControl2.Pages[j].Caption = DynOrder[i].Rubrique
        then if form1.PageControl2.Pages[j].ComponentCount = 0
             then if (form1.PageControl2.Pages[j].Caption <> 'Standard') and
                     (form1.PageControl2.Pages[j].Caption <> 'Supplément')
                  then form1.PageControl2.Pages[j].Free;
        end;

   end;
if Find = False then ShowMessage('Le plugin nommé ' + ListBox4.Items[Form1.GetListBoxSelected(ListBox4)] + ' ne semble pas être chargé' );
ListBox4.DeleteSelected;
if ListBox4.Items.Count < 1 then ListBox3.DeleteSelected;

ConfigIni := TIniFile.Create(Form1.GetFileIniName);
try
ConfigIni.EraseSection('DynOrder');
for i := 0 to Length(DynOrder)-1
do if DynOrder[i].Name <> ''
   then ConfigIni.WriteString('DynOrder', InttoStr(i), DynOrder[i].dllName);
finally ConfigIni.UpdateFile; ConfigIni.Free; end;
end;

procedure TForm19.Edit1Change(Sender: TObject);
begin
if Edit1.Text = ''
then begin
     Edit1.Text := '|';
     Edit1.SelectAll;
     Exit;
     end;
if (Edit1.Text[1] in ['A'..'Z']) or
   (Edit1.Text[1] in ['a'..'z']) or
   (Edit1.Text[1] in ['0'..'9'])
then begin
     showmessage('Caractère de séparation impossible');
     Edit1.Text := '|';
     Edit1.SelectAll;
     end;
end;

procedure TForm19.DT2Enter(Sender: TObject);
begin
RadioButton4.Checked := True;
end;

procedure TForm19.Memo3Enter(Sender: TObject);
begin
TabSheet9.SetFocus;
end;

procedure TForm19.Label50Click(Sender: TObject);
begin
ShellExecute(handle,'Open', Pchar(unit23.MyUrlPlugins),'','',SW_SHOWNORMAL);
end;

procedure TForm19.HotKey1Enter(Sender: TObject);
begin
HotKeyManager1.RemoveHotKey(HotKey1.HotKey);
end;

procedure TForm19.HotKey2Enter(Sender: TObject);
begin
HotKeyManager1.RemoveHotKey(HotKey1.HotKey);
end;

procedure TForm19.HotKey1Exit(Sender: TObject);
begin
HotKeyManager1.AddHotKey(HotKey1.HotKey);
end;

procedure TForm19.HotKey2Exit(Sender: TObject);
begin
HotKeyManager1.AddHotKey(HotKey2.HotKey);
end;

procedure TForm19.Button12Click(Sender: TObject);
var i : integer;
begin
i := length(LaunchList);
SetLength(LaunchList,i+1);
LaunchList[i].ExecName := Form1.StatusBar1.Panels[0].Text;
if RadioButton3.Checked then LaunchList[i].ActionBy := 2;
if RadioButton4.Checked then LaunchList[i].ActionBy := 1;
LaunchList[i].Frequence := ComboBox6.ItemIndex;
LaunchList[i].Day := DT1.Date;
LaunchList[i].Time := EncodeTime(StrToInt(DT2.Text[1]+DT2.Text[2]),StrToInt(DT2.Text[4]+DT2.Text[5]),0,0);
LaunchList[i].Link := HotKey3.HotKey;
RefreshLaunchToList(LaunchList,ListBox5);
ListBox5.ItemIndex := ListBox5.Count-1;

end;

procedure TForm19.Button14Click(Sender: TObject);
begin
if ListBox5.SelCount <> 0 then DeleteListLaunchIndex(LaunchList, ListBox5.ItemIndex);
RefreshLaunchToList(LaunchList,ListBox5);
end;

procedure TForm19.ListBox5Click(Sender: TObject);
var i,j : integer;
begin
// initialisation
j := -1; ListBox5.Hint := '';
for i := 0 to ListBox5.Count-1 do if ListBox5.Selected[i] = True then j := i;
// si tache séléctionée
if j >= 0
then begin
     form19.GetNextExec(LaunchList[j]);
     if LaunchList[j].NextExec = 0
     then ListBox5.Hint := 'En attente d''événement non relatif au temps.'
     else begin
          if LaunchList[j].NextExec < Now
          then ListBox5.Hint := 'Cette tâche ne sera plus jamais exécutée, il est conseillé de la supprimer.'
          else ListBox5.Hint := 'Prochaine exécution le '+ DateTimetoStr(LaunchList[j].NextExec);
          end;
     end;
end;

procedure TForm19.CheckBox9Click(Sender: TObject);
var FileName : String;
begin
// désactivation provisoire 05/12/08
//FileName := ExtractFileDir(Application.ExeName)+'\SMLaunch.exe';
//if form19.LaunchToStartWindows(FileName,CheckBox9.Checked) = False
//then form1.ShowApplicationError('Ecriture dans la base de registre impossible.');
end;

procedure TForm19.HotKey3Enter(Sender: TObject);
begin
Radiobutton3.Checked := True;
end;

procedure TForm19.FormDeactivate(Sender: TObject);
begin
if RunTest = True // assure de l'arrêt du test Clavier/Souris
then begin Button8.Click; RunTest := True; Button9.Click; end;
end;

end.
