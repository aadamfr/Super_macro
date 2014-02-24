unit Unit8;
interface

{$WARN SYMBOL_PLATFORM OFF}
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, Buttons, ComCtrls, Clipbrd,FileCtrl;

type TSysVar = record
     VName : string;
     VType : byte;
     VRW : byte;
     VValue : String;
     VDescr : String;
     end;

type TListOfSysVar = array of TSysVar;

type
  TForm8 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Bevel1: TBevel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label3: TLabel;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label5: TLabel;
    PopupMenu1: TPopupMenu;
    Copier1: TMenuItem;
    Coller1: TMenuItem;
    N1: TMenuItem;
    Cuper1: TMenuItem;
    Supprimer1: TMenuItem;
    N2: TMenuItem;
    Slctionnertout1: TMenuItem;
    Autre1: TMenuItem;
    Date1: TMenuItem;
    Heure1: TMenuItem;
    Fichier1: TMenuItem;
    Rpertoire1: TMenuItem;
    Annuler1: TMenuItem;
    N3: TMenuItem;
    OpenDialog1: TOpenDialog;
    SpeedButton1: TSpeedButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label4Click(Sender: TObject);
    procedure Label5Click(Sender: TObject);
    procedure Annuler1Click(Sender: TObject);
    procedure Cuper1Click(Sender: TObject);
    procedure Copier1Click(Sender: TObject);
    procedure Coller1Click(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure Slctionnertout1Click(Sender: TObject);
    procedure Date1Click(Sender: TObject);
    procedure Heure1Click(Sender: TObject);
    procedure Fichier1Click(Sender: TObject);
    procedure Rpertoire1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
    procedure InitListOfSysVar();
    function WriteSysVar(Ident, Value : string) : Boolean;
    function ReadSysVar(Ident: String) : String;
    function FindSysVar(Ident: String) : integer;
    function GetEnvironmentVariableToStr(Name : string): String;
  end;

var
  Form8: TForm8;
  OldVarName : String;
  ListOfSysVar : TListOfSysVar;
implementation

uses mdlFnct, Unit1, Unit2, Unit20, Unit19, Unit23, Unit28, Unit29;

{$R *.DFM}

procedure TForm8.MessageAide(var msg:TMessage);
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

function TForm8.GetEnvironmentVariableToStr(Name : string): String;
var nSize: DWord;
begin
  nSize:= 0;
  nSize:= GetEnvironmentVariable(PChar(Name), nil, nSize);
  if nSize = 0 then
    result:= ''
  else
  begin
    SetLength(result, nSize - 1);
    if GetEnvironmentVariable(PChar(Name), PChar(result), nSize) <> nSize - 1
    then Form1.ShowApplicationError(SysErrorMessage(GetlastError))
  end;
end;

function TForm8.FindSysVar(Ident: String) : integer;
var i : integer;
begin
result := -1;
for i := 0 to length(ListOfSysVar)-1
do if Ident = ListOfSysVar[i].VName
   then begin
        result := i;
        break;
        end;
end;

function TForm8.WriteSysVar(Ident, Value : string): Boolean;
var i : integer;
begin
result := False;
i := FindSysVar(Ident);
if i <> -1
then if ListOfSysVar[i].VRW = 1
     then result := True
     else Exit;

if Ident = '[PROGRESS]'
then begin
     if not FnctIsInteger(Value)
     then Exit;
     ListOfSysVar[i].VValue := Value;
     if StrToInt(ListOfSysVar[i].VValue) >= 0
     then begin if Form29.Visible = False then Form29.Show; end
     else begin if Form29.Visible = True then Form29.Close; end;
     if StrToInt(ListOfSysVar[i].VValue) > 100 then ListOfSysVar[i].VValue :='0';
     if StrToInt(ListOfSysVar[i].VValue) < 0 then ListOfSysVar[i].VValue := '0';
     Form29.Label1.Caption := 'Progression à ' + ListOfSysVar[i].VValue + '%';
     Form29.Label2.Caption := 'Appuiez sur la touche '+ ShortCutToText(Form19.HotKey1.HotKey) +' pour interrompre la progression.';
     Form29.ProgressBar1.Min := 0; Form29.ProgressBar1.Max := 100; Form29.ProgressBar1.Step := 1;
     Form29.ProgressBar1.Position := StrToInt(ListOfSysVar[i].VValue);
     application.ProcessMessages;
     end;
if Ident = '[CLIPBOARD]'
then begin
     ClipBoard.Open;
     try Clipboard.SetTextBuf(Pchar(Value));
     finally Clipboard.Close; application.ProcessMessages; end;
     end;

if Ident = '[SYSDIR.HOME]' then SetEnvironmentVariable('USERPROFILE',Pchar(Value));
if Ident = '[SYSDIR.PROGRAMFILES]' then SetEnvironmentVariable('ProgramFiles',Pchar(Value));
if Ident = '[SYSDIR.TEMP]' then SetEnvironmentVariable('TEMP',Pchar(Value));
if Ident = '[SYSDIR.WINDOWS]' then SetEnvironmentVariable('WINDIR',Pchar(Value));
if Ident = '[SYSDIR.CURRENT]' then SetCurrentDir(Value);
if Ident = '[DELAY]' then Form19.TPGEdit.Text := Value;

if Ident = '[EVENT.ACTIVATE]'
then begin
     if Value = '1'
     then begin
          if Application.FindComponent('Form28') = nil
          then Application.CreateForm(TForm28, Form28);
          Form28.EventHook(True)
          end
     else begin
          if Application.FindComponent('Form28') <> nil
          then Form28.EventHook(False);
          end;
     end;

end;

function TForm8.ReadSysVar(Ident: String) : String;
var i,j : integer;
    Exist : Boolean;
    SPS: TSystemPowerStatus;
    Pt : Tpoint;
begin
result := '';
Exist := False;

for i := 0 to length(ListOfSysVar)-1
do if Ident = ListOfSysVar[i].VName
   then begin
        result := ListOfSysVar[i].VValue;
        Exist := True;
        break;
        end;
if (Exist = False)
then Exit;

if Ident = '[POWER.PERCENT]'
then begin
     GetSystemPowerStatus(SPS);
     if SPS.BatteryLifePercent < 255
     then result := IntToStr(SPS.BatteryLifePercent)
     else result := '-1';
     end;

If Ident = '[PROCESSOR.PERCENT]'
then result := Format('%5.2f%',[(Form23.GetCPUPercent)]);

if Ident = '[CLIPBOARD]'then result := Form1.GetClipboardHasText;
if Ident = '[NUMLOCK]'  then if (GetKeyState(VK_NUMLOCK) and $01) <> 0 then result := '1' else result := '0';
if Ident = '[CAPITAL]'  then if (GetKeyState(VK_CAPITAL) and $01) <> 0 then result := '1' else result := '0';
if Ident = '[MOUSE.X]'  then begin GetCursorPos(Pt); result := IntToStr(Pt.X); end;
if Ident = '[MOUSE.Y]'  then begin GetCursorPos(Pt); result := IntToStr(Pt.Y); end;
if Ident = '[SCREEN.X]' then result := IntToStr(Screen.Width);
if Ident = '[SCREEN.Y]' then result := IntToStr(Screen.Height);

if Ident = '[HANDLE.FOREGROUNDWINDOW]' then result := IntToStr(GetForegroundWindow);
if Ident = '[HANDLE.ACTIVEWINDOW]' then result := IntToStr(GetActiveWindow);
if Ident = '[HANDLE.SUPERMACROWINDOW]' then result := IntToStr(Form1.Handle);

if Ident = '[SYSDIR.HOME]' then result := GetEnvironmentVariableToStr('USERPROFILE');
if Ident = '[SYSDIR.PROGRAMFILES]' then result := GetEnvironmentVariableToStr('ProgramFiles');
if Ident = '[SYSDIR.TEMP]' then result := GetEnvironmentVariableToStr('TEMP');
if Ident = '[SYSDIR.WINDOWS]' then result := GetEnvironmentVariableToStr('WINDIR');
if Ident = '[SYSDIR.CURRENTMACRO]'
then result := ExtractFileDir(Form1.StatusBar1.Panels[0].Text);

if Ident = '[SYSDIR.EXEMACRO]'
then if ALIAS_EXE = ''
     then result := ExtractFileDir(Form1.StatusBar1.Panels[0].Text)
     else result := ExtractFileDir(ALIAS_EXE);

if Ident = '[SYSDIR.CURRENT]' then result := GetCurrentDir;
if Ident = '[DELAY]' then result := Form19.TPGEdit.Text;

J := -1;
for i := Low(Variable) to High(Variable)
do if Variable[i].Name = Ident
   then begin
        j := i;
        break;
        end;
if j = -1
then begin
     SetLength(Variable, length(Variable)+1);
     Variable[Length(Variable)-1].Name := Ident;
     Variable[Length(Variable)-1].Value := result;
     end
else begin
     if Ident = '[ERROR.ADAPTATOR]' then Exit;
     if Ident = '[OBJECT.TIMEOUT]' then Exit;
     if Ident = '[ERROR]' then Exit;
     if Ident = '[PASSWORD]' then Exit;
     if Ident = '[EVENT.ACTIVATE]' then Exit;
     if Ident = '[EVENT.KEY]' then Exit;
     if Ident = '[EVENT.BUTTON]' then Exit;
     Variable[j].Value := result;
     end;
end;

procedure TForm8.InitListOfSysVar();
var i,index : integer;
    Pt : TPoint;
    p : Pchar;
    SPS: TSystemPowerStatus;
    function CreateSysVar(Name : String; PrmType, PrmRW : Byte) : integer;
    begin
    result := length(ListOfSysVar);
    SetLength(ListOfSysVar,result+1);
    ListOfSysVar[result].VName := Name;
    ListOfSysVar[result].VType := PrmType;
    ListOfSysVar[result].VRW := PrmRW;
    end;
begin
setlength(ListOfSysVar,0);

Index := CreateSysVar('[WINVER]',1,0);
ListOfSysVar[index].VValue := form19.WindowsVersion;
ListOfSysVar[index].VDescr := 'Valeur possible: Windows NT 3.51, Windows 95 SP 1, Windows 95 SP 2, Windows NT 4.0, '+
                                     'Windows 98 SP 1, Windows 98 SP 2, Windows ME, Windows 2000, Windows XP, Inconnue';

Index := CreateSysVar('[PROGRESS]',0,1);
ListOfSysVar[Index].VValue := '0';
ListOfSysVar[Index].VDescr := 'Valeur en pourcentage de la progression de l''exécution de la macro. Vous devez incrémenter la valeur vous-même.';

Index := CreateSysVar('[CLIPBOARD]',1,1);
ListOfSysVar[Index].VValue := Form1.GetClipboardHasText;
ListOfSysVar[Index].VDescr := 'Valeur du presse-papier.';

Index := CreateSysVar('[NUMLOCK]',0,0);
if (GetKeyState(VK_NUMLOCK) and $01) <> 0
then ListOfSysVar[Index].VValue := '1'
else ListOfSysVar[Index].VValue := '0';
ListOfSysVar[Index].VDescr := 'Permet de savoir si la touche de verrouillage du pavé numerique est activée. Valeur retournée 0 ou 1 si elle est activée.';

Index := CreateSysVar('[CAPITAL]',0,0);
if (GetKeyState(VK_CAPITAL) and $01) <> 0
then ListOfSysVar[Index].VValue := '1'
else ListOfSysVar[Index].VValue := '0';
ListOfSysVar[Index].VDescr := 'Permet de savoir si la touche de verrouillage des majuscules est activée. Valeur retournée 0 ou 1 si elle est activée.';

GetCursorPos(Pt);
Index := CreateSysVar('[MOUSE.X]',0,0);
ListOfSysVar[Index].VValue := IntToStr(Pt.X);
ListOfSysVar[Index].VDescr := 'Position courante de la souris abscisse (mesure en pixel).';

Index := CreateSysVar('[MOUSE.Y]',0,0);
ListOfSysVar[Index].VValue := IntToStr(Pt.Y);
ListOfSysVar[Index].VDescr := 'Position courante de la souris ordonnée (mesure en pixel).';

Index := CreateSysVar('[SCREEN.X]',0,0);
ListOfSysVar[Index].VValue := IntToStr(Screen.Width);
ListOfSysVar[Index].VDescr := 'Longueur de la resolution de l''écran (mesure en pixel).';

Index := CreateSysVar('[SCREEN.Y]',0,0);
ListOfSysVar[Index].VValue := IntToStr(Screen.Height);
ListOfSysVar[Index].VDescr := 'Largeur de la resolution de l''écran (mesure en pixel).';


i := GetEnvironmentVariable('USERPROFILE',P,0); ReAllocMem(P,i);
GetEnvironmentVariable('USERPROFILE',P,i);
Index := CreateSysVar('[SYSDIR.HOME]',1,1);
ListOfSysVar[Index].VValue := P;
ListOfSysVar[Index].VDescr := 'Répertoire personnel.';

i := GetEnvironmentVariable('ProgramFiles',P,0); ReAllocMem(P,i);
GetEnvironmentVariable('ProgramFiles',P,i);
Index := CreateSysVar('[SYSDIR.PROGRAMFILES]',1,1);
ListOfSysVar[Index].VValue := P;
ListOfSysVar[Index].VDescr := 'Répertoire Program Files.';

i := GetEnvironmentVariable('TEMP',P,0); ReAllocMem(P,i);
GetEnvironmentVariable('TEMP',P,i);
Index := CreateSysVar('[SYSDIR.TEMP]',1,1);
ListOfSysVar[Index].VValue := P;
ListOfSysVar[Index].VDescr := 'Répertoire temporaire.';

i := GetEnvironmentVariable('windir',P,0); ReAllocMem(P,i);
GetEnvironmentVariable('windir',P,i);
Index := CreateSysVar('[SYSDIR.WINDOWS]',1,1);
ListOfSysVar[Index].VValue := P;
ListOfSysVar[Index].VDescr := 'Répertoire windows.';

Index := CreateSysVar('[SYSDIR.CURRENTMACRO]',1,0);
ListOfSysVar[Index].VValue := ExtractFileDir(form1.StatusBar1.Panels[0].Text);
if ListOfSysVar[Index].VValue = '' then ListOfSysVar[Index].VValue := 'C:\';
ListOfSysVar[Index].VDescr := 'Répertoire de la macro courante.';

Index := CreateSysVar('[SYSDIR.EXEMACRO]',1,0);
if ALIAS_EXE = ''
then ListOfSysVar[Index].VValue := ExtractFileDir(form1.StatusBar1.Panels[0].Text)
else ListOfSysVar[Index].VValue := ExtractFileDir(ALIAS_EXE);
ListOfSysVar[Index].VDescr := 'Répertoire de la macro convertie en exécutable.';


Index := CreateSysVar('[SYSDIR.CURRENT]',1,1);
ListOfSysVar[Index].VValue := GetCurrentDir();
ListOfSysVar[Index].VDescr := 'Répertoire courant.';

Index := CreateSysVar('[DELAY]',0,1);
if (form19.CheckBox1.Checked = true)
then ListOfSysVar[Index].VValue := form19.TPGEdit.text
else ListOfSysVar[Index].VValue := '0';
ListOfSysVar[Index].VDescr := 'Permet de changer le temps de pause entre chaque commande en milli-seconde.';

Index := CreateSysVar('[VK_ENTER]',1,0);
ListOfSysVar[Index].VValue := #13;
ListOfSysVar[Index].VDescr := 'Puisque la touche Entrée n''est pas un caractère imprimable, cette variable posséde le code ASCII 13.';

Index := CreateSysVar('[HANDLE.FOREGROUNDWINDOW]',0,0);
ListOfSysVar[Index].VValue := IntToStr(GetForegroundWindow);
ListOfSysVar[Index].VDescr := 'Permet d''obtenir le handle de la fenêtre en avant plan placée sur le bureau.';

Index := CreateSysVar('[HANDLE.ACTIVEWINDOW]',0,0);
ListOfSysVar[Index].VValue := IntToStr(GetActiveWindow);
ListOfSysVar[Index].VDescr := 'Permet d''obtenir le handle de la fenêtre active.';

Index := CreateSysVar('[HANDLE.SUPERMACROWINDOW]',0,0);
ListOfSysVar[Index].VValue := IntToStr(Form1.Handle);
ListOfSysVar[Index].VDescr := 'Permet d''obtenir le handle de la fenêtre d''édition de Super macro.';

Index := CreateSysVar('[MACRO.MAIL]',1,1);
ListOfSysVar[Index].VValue := 'Inconnu';
ListOfSysVar[Index].VDescr := 'Email de l''auteur de la macro.';

Index := CreateSysVar('[MACRO.OPENMODE]',1,1);
ListOfSysVar[Index].VValue := 'EXEC';
ListOfSysVar[Index].VDescr := 'Choisir EXEC ou EDIT.';

Index := CreateSysVar('[PASSWORD]',1,1);
ListOfSysVar[Index].VValue := '';
ListOfSysVar[Index].VDescr := 'Variable permettant de cacher sa valeur.';


GetSystemPowerStatus(SPS);
Index := CreateSysVar('[POWER.SOURCE]',1,0);
case SPS.ACLineStatus of
      0:   ListOfSysVar[Index].VValue := 'Batterie';
      1:   ListOfSysVar[Index].VValue := 'Secteur';
      255: ListOfSysVar[Index].VValue := 'Unknow';
    end;
ListOfSysVar[Index].VDescr := 'Source d''alimentation de votre PC. Valeurs possibles:Batterie,Secteur,Unknow.';

Index := CreateSysVar('[POWER.PERCENT]',0,0);
if SPS.BatteryLifePercent < 255
then ListOfSysVar[Index].VValue := IntToStr(SPS.BatteryLifePercent)
else ListOfSysVar[Index].VValue := '-1';
ListOfSysVar[Index].VDescr := 'Pourcentage de charge restant de votre batterie, si votre PC ne posséde pas de batterie la valeur retournée est -1.';

Index := CreateSysVar('[PROCESSOR.PERCENT]',0,0);
ListOfSysVar[Index].VValue := Format('%5.2f%',[(Form23.GetCPUPercent)]);
ListOfSysVar[Index].VDescr := 'Taux d''occupation du processeur.';

Index := CreateSysVar('[ERROR]',1,1);
ListOfSysVar[Index].VValue := '';
ListOfSysVar[Index].VDescr := 'Récupère le dernier message d''erreur.(Si pas d''erreur cette valeur est vide)';

Index := CreateSysVar('[ERROR.ADAPTATOR]',0,1);
ListOfSysVar[Index].VValue := '1';
ListOfSysVar[Index].VDescr := 'Comportement à adopter lors d''une erreur. Valeurs possibles:  1 (Arrêt de la macro), '+
                                                                                               '2 (Reprise de la macro avec tentative de réexécution de la commande incriminée), '+
                                                                                               '3 (Reprise de la macro en ignorant la commande incriminée)'+
                                                                                               '4 (Reprise de la macro sans confirmation)';
Index := CreateSysVar('[OBJECT.TIMEOUT]',0,1);
ListOfSysVar[Index].VValue := '0';
ListOfSysVar[Index].VDescr := 'Temps d''attente de recherche d''un objet, pour une recherche infinie placez 0 dans la valeur d''initialisation.';

Index := CreateSysVar('[EVENT.ACTIVATE]',0,1);
ListOfSysVar[Index].VValue := '0';
ListOfSysVar[Index].VDescr := 'Status de l''activation de la surveillance d''événement.';

Index := CreateSysVar('[EVENT.BUTTON]',1,1);
ListOfSysVar[Index].VValue := '';
ListOfSysVar[Index].VDescr := 'Bouton de la souris concerné par l''événement.';

Index := CreateSysVar('[EVENT.KEY]',1,1);
ListOfSysVar[Index].VValue := '';
ListOfSysVar[Index].VDescr := 'Touche du clavier concernée par l''événement.';


end;

procedure TForm8.Button2Click(Sender: TObject);
begin
form8.Close;
end;

procedure TForm8.Button1Click(Sender: TObject);
var Param : String;
    pos : integer;
    ok : Boolean;
begin
ok := True;

if edit1.Text = ''
then begin
     MessageDlg('Vous devez donner un nom à votre variable.',mtWarning,[mbOk],0);
     ok := False;
     end;

if (RadioButton2.Checked = True) and ((not mdlFnct.FnctIsInteger(Edit2.Text)) and (Edit1.Text <> Edit2.Text))
then begin
     MessageDlg('Vous avez choisi une variable numérique, vous devez donc choisir un nombre entier pour initialiser cette variable.',mtWarning,[mbOk],0);
     ok := False;
     end;

if ok = True
then begin
          if RadioButton1.Checked then Param := edit1.text+ SprPr +edit2.Text+ SprPr + TAlpha + SprPr;
          if RadioButton2.Checked then Param := edit1.text+ SprPr +edit2.Text+ SprPr + TNum + SprPr;

          if unit1.sw_modif = false
          then begin
               if Form19.CheckBox12.Checked = True
               then begin
               for pos := 0 to form1.ListView1.Items.Count -1 do
               if form1.ListView1.Items[pos].Caption <> 'Variable'
               then break;
               if form1.ListView1.Items.Count <> 0
               then form1.ListView1.Items.Insert(pos)
               else begin
                    form1.ListView1.Items.Add();
                    pos := 0;
                    end;
               //Form1.InfoListViewInsert(Pos);
               Form1.ListView1.Items[pos].ImageIndex := 9;
               Form1.ListView1.Items[pos].Caption := 'Variable';
               Form1.listView1.items.Item[pos].SubItems.Add(Param);
               Form1.SaveBeforeChange(form1.ListView1.Items[pos]);
               end
               else begin
                    form1.add_insert('Variable',Param,9);
                    end;
               end
          else begin
               Form1.ListView1.Selected.SubItems.Strings[0] := Param;
               Form1.SaveBeforeChange(Form1.ListView1.Selected);
               if OldVarName <> Edit1.Text
               then if Form1.ChangeVarName(OldVarName,Edit1.Text,False) = True
                    then begin
                         if application.MessageBox('Vous avez changé le nom de la variable alors qu''elle est utilisée en paramètre. Voulez vous réctifier automatiquement le nom de cette variable dans les autres commandes.','Attention',MB_OKCANCEL)
                         = IDOK then begin
                                     Form1.AddHistory(0,'Début d''actions groupées','','');
                                     Form1.ChangeVarName(OldVarName,Edit1.Text,True);
                                     Form1.AddHistory(0,'Fin d''actions groupées','','');
                                     end;
                         end;
               end;
     Edit1.Text := '';
     Edit2.Text := '';
     Radiobutton1.Checked := true;
     Form8.close;
end;
end;

procedure TForm8.RadioButton2Click(Sender: TObject);
begin
if edit2.Text = '' then Edit2.Text := '0';
end;

procedure TForm8.FormShow(Sender: TObject);
var param : string;
    listParam : Tparam;
    index, count :integer;
begin
edit1.text := '';
edit2.Text := '';
RadioButton1.Checked := true;
Form1.New_Var_Name(Edit1);
if unit1.sw_modif = true
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     edit1.text := listParam.param[1];
     index := length(listParam.param[1])+2;
     count := length(param)-length(listParam.param[1])-length(listParam.param[listParam.nbr_param-1])-3;
     edit2.Text := Copy(param,index,count);
     if listParam.param[listParam.nbr_param-1] = TNum
     then RadioButton2.Checked := true
     else RadioButton1.Checked := true;
     end;
Form8.ActiveControl:= edit1;
OldVarName := Edit1.Text; // pour recuperer avant changement, servira a ChangeVar
end;

procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm8.Label4Click(Sender: TObject);
begin
RadioButton1.Checked := True;
end;

procedure TForm8.Label5Click(Sender: TObject);
begin
RadioButton2.Checked := True;
end;

procedure TForm8.Annuler1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).Undo;
end;

procedure TForm8.Cuper1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).CutToClipboard;
end;

procedure TForm8.Copier1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).CopyToClipboard;
end;

procedure TForm8.Coller1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).PasteFromClipboard;
end;

procedure TForm8.Supprimer1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).Text := '';
end;

procedure TForm8.Slctionnertout1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).SelectAll;
end;

procedure TForm8.Date1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).Text := DateToStr(now);
end;

procedure TForm8.Heure1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then TEdit(PopupMenu1.PopupComponent).Text := TimeToStr(now);
end;

procedure TForm8.Fichier1Click(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then if OpenDialog1.Execute
     then TEdit(PopupMenu1.PopupComponent).Text := Opendialog1.FileName;
end;

procedure TForm8.Rpertoire1Click(Sender: TObject);
var Dir : String;
begin
if PopupMenu1.PopupComponent is TEdit
then if SelectDirectory('Entrez le nom du répertoire','',Dir)
     then TEdit(PopupMenu1.PopupComponent).Text := Dir;
end;

procedure TForm8.PopupMenu1Popup(Sender: TObject);
begin
if PopupMenu1.PopupComponent is TEdit
then begin
     if TEdit(PopupMenu1.PopupComponent).CanUndo = True
     then Annuler1.Enabled := True else Annuler1.Enabled := False;
     if TEdit(PopupMenu1.PopupComponent).SelLength = length(TEdit(PopupMenu1.PopupComponent).Text)
     then Slctionnertout1.Enabled := False else Slctionnertout1.Enabled := True;
     end;
end;

procedure TForm8.SpeedButton1Click(Sender: TObject);
var NewColumn: TListColumn;
    NewListItem : TListItem;
    i : integer;
begin
InitListOfSysVar;
with Form20
do begin
   Memo1.Lines.Clear;
   Memo1.Lines.Add('Faites un simple clic pour avoir une description de la variable séléctionnée.');
   Memo1.Lines.Add('Faites un double clic pour placer la variable système dans la nouvelle variable.');
   Memo1.Lines.Add('Appuyez sur F5 pour actualiser les valeurs.');

   Label1.Caption := 'Liste des variables systèmes';
   ListView1.Items.Clear;
   ListView1.Columns.Clear;
   NewColumn := listView1.Columns.Add;
   NewColumn.Caption := 'Nom';
   NewColumn.Width := 110;
   NewColumn := listView1.Columns.Add;
   NewColumn.Caption := 'Type';
   NewColumn.Width := 60;
   NewColumn := listView1.Columns.Add;
   NewColumn.Caption := 'R/W';
   NewColumn.Width := 40;
   NewColumn := listView1.Columns.Add;
   NewColumn.Caption := 'Valeur';
   NewColumn.Width := form20.Width - 222;
   for i := 0 to length(ListOfSysVar)-1
   do begin
      NewListItem := listView1.Items.Add;
      NewListItem.Caption := ListOfSysVar[i].VName;
      if ListOfSysVar[i].VType = 0
      then NewListItem.SubItems.Add('Num')
      else NewListItem.SubItems.Add(TAlpha);
      NewListItem.SubItems.Add(Inttostr(ListOfSysVar[i].VRW));
      NewListItem.SubItems.Add(ListOfSysVar[i].VValue);
      if ListOfSysVar[i].VName = Edit1.Text
      then begin
           NewListItem.Selected := True;
           NewListItem.MakeVisible(True);
           ListView1.OnClick(self);
           end;
      end;

   NewColumn.AutoSize := True;
   Show;
   end;

end;

procedure TForm8.Edit1Change(Sender: TObject);
var i : integer;
begin
Edit2.Enabled := True;
Label2.Enabled := True;
RadioButton1.Enabled := True;
RadioButton2.Enabled := True;
Label4.Enabled := True;
Label5.Enabled := True;

for i := 0 to length(ListOfSysVar)-1
do if Edit1.Text = ListOfSysVar[i].VName
   then Begin
        if ListOfSysVar[i].VRW = 0
        then begin
             Edit2.Enabled := False;
             Label2.Enabled := False;
             end;
        if ListOfSysVar[i].VType = 1
        then begin
             Edit2.Text := '';
             RadioButton1.Checked := True;
             RadioButton2.Enabled := False;
             Label5.Enabled := False
             end
        else begin
             Edit2.Text := '0';
             RadioButton2.Checked := True;
             RadioButton1.Enabled := False;
             Label4.Enabled := False
             end;
        end;
end;

procedure TForm8.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
if Key in ['+','-','/','*','=']
then begin
     Key := #0;
     Form1.ShowBalloonTip(Edit1,1,'Information','Caractères impossibles dans le nom de variable + - / * =');
     end;
end;

end.
