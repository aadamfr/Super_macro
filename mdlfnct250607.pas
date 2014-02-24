unit mdlfnct;

interface

uses unit1, Math, Buttons, Consts, ComCtrls, Windows,Controls,ShellApi,SysUtils,IniFiles,classes,Messages, Jpeg,
 StdCtrls, ExtCtrls, TLHelp32, Clipbrd,forms,Dialogs, mmSystem, Graphics, StrUtils,CplBrd;

{$WARN SYMBOL_PLATFORM OFF}

type TkeyBoard = record
     VirtualKey : cardinal;
     KeyName : String[64];
     end;

TStrArray = array of string;

const
  {$EXTERNALSYM INPUT_MOUSE}
  INPUT_MOUSE = 0;
  {$EXTERNALSYM INPUT_KEYBOARD}
  INPUT_KEYBOARD = 1;
  {$EXTERNALSYM INPUT_HARDWARE}
  INPUT_HARDWARE = 2;

type
  PInput = ^TInput;
  {$EXTERNALSYM tagINPUT}
  tagINPUT = packed record
    Itype: DWORD;
    case Integer of
      0: (mi: TMouseInput);
      1: (ki: TKeybdInput);
      2: (hi: THardwareInput);
  end;
  TInput = tagINPUT;

  // DO NOT CREATE AN INSTANCE OF TInputArray - It is used for typecasting
  // PInputArray, which will be user allocated to desired size
  TInputArray =  Array [0..Pred(MaxInt div SizeOf(tagInput))] of TInput;
  PInputArray =  ^TInputArray;

// Valeur de retour de la fonction GetTypeOfTextfile
type TxFileType = (txAnsiOrByte,txUTF8,txUNI,txUNIBIG,txRTF,txWDOC);


procedure FnctType(Text : String);
procedure FnctTypePlus(Small : Smallint);
procedure FnctTypeSpl(Param : String);
procedure FnctExecute(command : String);
procedure FnctMoveMouse(Param : String);
procedure FnctClick(Param : String);
function FnctGoto(ListView : TListView; Param : String): integer ;
function Fnctprocedure(ListView : TListView; index :integer; Params : String; var ActiveOrd : TActiveOrder): integer;
Procedure FnctQuestion(Param : String);
Procedure FnctCalcul(Param : String);
Procedure FnctSysVar(Param : String);
Procedure FnctRead(Param : String);
Procedure FnctWrite(Param : String);
Procedure FnctManip(Param : String);
Procedure FnctShell(Param : String);
procedure FnctCapture(Param : String);
procedure FnctChangeRes(Param : String);
procedure FnctAlimentation(Param : String);
procedure FnctRepertoire(Param : String);
procedure FnctField(Param : String);
procedure FnctCalculEvol(Param : String);
procedure FnctMouvement(Param : String);
// Procedure FnctPause(Param : String); se trouve dans la form1

function FnctTypeVar(Param : String): String; // revoie le type de variable Numerique , Alpha , No_Type
function GetParam(strParam : String):TParam;
function GetValue(variable : String):String;
function FnctExamine(Param : String): Boolean;
function FnctIsInteger(Param : String): Boolean;
function FnctIsFloat(Param : String): Boolean;
function FnctIsdate (Param : String): Boolean;
function Decompose_Date(Date_Param : TDateTime; Mesure : String): String;
function ForceForegroundWindow(hWnd: LongWord): Boolean;
function NT9XSetPowerState(fSuspend, fForce: Boolean): Boolean;
function GetNumberOfMouseButtons: Integer;

function GetText(Hnd: LongWord): string;
function GetFirstParent(Hnd: LongWord): LongWord;
function Donne_Class(Hwnd: integer): string;
function GetWindowModuleFileName( const hSrcWnd: LongWord ): string;
function FnctStrToint(Str :String) : integer;
procedure Explode(Text, Car : String; var Tab : TStrArray);

procedure touche_altGr(touche_supp : integer);
procedure touche_Shift(touche_supp : integer);
Procedure ScruteDossier(Penetration:integer;Dossier:string;filtre:string;attributs:integer;recursif:boolean; ToFile : String);
Procedure ScruteFichier(Dossier:string;filtre:string;Attributs:integer; ToFile : String);
function filenamevalide(filename : string) : boolean;
function DirNameValide(filename : string) : boolean;
function findTextParam(Index : integer; Chaine : String) : Boolean;
function findTextPos(Index : integer; Chaine : String) : integer;
function countfindTextParam(Commande, Chaine : String) : Integer;
function GetTypeOfTextfile(filename : string) : TxFileType;

procedure LoadMyKeyboard();
function GetVKKeyToKeyName(VK_Key : cardinal) : String;
function GetVKKeyExtentedToKeyName(VK_Key : cardinal) : String;

var imgName : String = '';
    MyKeyBoard : Array[1..110]of  TKeyBoard;
    SousMacroIndent : integer = 0;
    ProcReg : array of LongWord;
implementation

uses Unit4, unit10, unit17, unit19,unit23,unit24, unit28, Debug;

procedure mouse_event(dwFlags, dx, dy, dwData: integer; dwExtraInfo: DWORD); stdcall; external User32 name 'mouse_event';
function SendInput(cInputs: UINT; lpInputs: PInputArray; cbSize: Integer): UINT; stdcall; external 'user32.dll';

function MouseMoveWithSendInput(X,Y : Integer): Boolean;
var lpi:   PInputArray;
    sysmetX,sysmetY : integer;
begin
result := True;
lpi:=AllocMem(1 * SizeOf(TInput));
sysmetX := GetSystemMetrics(SM_CXSCREEN);
sysmetY := GetSystemMetrics(SM_CYSCREEN);

lpi^[0].Itype := INPUT_MOUSE;
lpi^[0].mi.dx := X * 65535 div sysmetX;
lpi^[0].mi.dy := Y * 65535 div sysmetY;
lpi^[0].mi.mouseData := 0;
lpi^[0].mi.dwFlags := (MOUSEEVENTF_ABSOLUTE or MOUSEEVENTF_MOVE);
lpi^[0].mi.time := 0;
lpi^[0].mi.dwExtraInfo := 0;

if SendInput(1,lpi,SizeOf(TInput)) = 0
then result := False;

freeMem(lpi);
end;

procedure Explode(Text, Car : String; var Tab : TStrArray);
var i,j : integer;
begin
j := 1;
SetLength(Tab,j);
for i := 1 to length(Text)
do if Text[i] <> Car
   then Tab[j-1] := Tab[j-1]+Text[i]
   else begin
        Inc(J);
        SetLength(Tab,j);
        end;

if (length(Tab)=1) and (Tab[0] = '')
then SetLength(Tab,0);
end;

function GetTypeOfTextfile(filename : string) : TxFileType;
var F : file of byte;
    sign : array [0..2] of byte;
begin
  try
    AssignFile(F,FileName);
    filemode := 0;
    Reset(F);
    Read(F,sign[0],sign[1],sign[2]);
  finally closeFile(F); end;
  if (sign[0] = $ef) and (sign[1] = $bb) and (sign[2] = $bf) then
     { xEFBBBF correspond a un fichier UTF8 }
     result := txUTF8
  else
  if (sign[0] = $ff) and (sign[1] = $fe) then
     { xFFFE correspond a un fichier Unicode }
     result := txUNI
  else
  if (sign[0] = $fe) and (sign[1] = $ff) then
     { xFEFF correspond a un fichier Unicode big endian }
     result := txUNIBIG
  else
  if (sign[0] = $7B) and (sign[1] = $5C) and (sign[2] = $72) then
     { x7B5C72 correspond a un fichier au format RTF }
     result := txRTF
  else
  if (sign[0] = $D0) and (sign[1] = $CF) and (sign[2] = $11) then
     { xD0CF11 correspond en general a un fichier au format DOC (word) }
     result := txWDOC
  else
     { si rien de tout ça c'est que ça doit etre un fichier texte ascii ou binaire }
     result := txAnsiOrByte;
end;


function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
{=================================================================}
{ fonction permettant de convertir des date de type FileTime      }
{ en Date de type DateTime                                        }
{=================================================================}
var
  LocalFileTime: TFileTime;
  SystemTime: TSystemTime;
begin
  FileTimeToLocalFileTime(FileTime, LocalFileTime);
  FileTimeToSystemTime(LocalFileTime, SystemTime);
  Result := SystemTimeToDateTime(SystemTime);
end;


function DateHeureCreationFichier1(fichier: string): TDateTime;
{=================================================================}
{ fonction renvoyant la date et heure de la création du fichier   }
{=================================================================}
var SearchRec:TSearchRec;
    Resultat:longint;
begin
  Result:=0;
  Resultat:=FindFirst(fichier, FaAnyFile, SearchRec);
  if Resultat=0 then Result:=FileDateToDateTime(SearchRec.Time); // FileDateToDateTime transforme une date de type dos en format TDateTime
  FindClose(SearchRec);
end;


function TimeAccesFichier(fichier: string): TDateTime;
{=================================================================}
{ fonction renvoyant la date et heure du dernier accés au fichier }
{ l'heure ne semble pas marcher au moins en Win 98                }
{=================================================================}
var SearchRec:TSearchRec;
    Resultat:LongInt;
begin
  Result:=0;
  Resultat:=FindFirst(fichier, FaAnyFile, SearchRec);
  if Resultat=0 then Result:=FileTimeToDateTime(SearchRec.FindData.ftLastAccessTime) ; // FileDateToDateTime transforme une date de type dos en format TDateTime
  FindClose(SearchRec);
end;



function TimeModificationFichier(fichier: string): TDateTime;
{===========================================================================}
{ fonction renvoyant la date et heure de la dernière modification du fichier}
{===========================================================================}
var SearchRec:TSearchRec;
    Resultat:longint;
begin
  Result:=0;
  Resultat:=FindFirst(fichier, FaAnyFile, SearchRec);
  if Resultat=0 then Result:=FileDateToDateTime(SearchRec.Time); // FileDateToDateTime transforme une date de type dos en format TDateTime
  FindClose(SearchRec);
end;

function TimeCreationFichier(fichier: string): TDateTime;
{=================================================================}
{ fonction renvoyant la date et heure de la création du fichier   }
{=================================================================}
var SearchRec:TSearchRec;
    Resultat:LongInt;
begin
  Result:=0;
  Resultat:=FindFirst(fichier, FaAnyFile, SearchRec);
  if Resultat=0 then Result:=FileTimeToDateTime(SearchRec.FindData.ftCreationTime) ; // FileDateToDateTime transforme une date de type dos en format TDateTime
  FindClose(SearchRec);
end;

function DateHeureModificationFichier2(fichier: string): TDateTime;
{seconde solution pour trouver la date et l'heure de dernière modification d'un fichier}
{fonction renvoyant la date et l'heure de création du fichier sous la forme d'un TDateTime}
begin
  Result:=FileDateToDateTime(FileAge(fichier)); // FileDateToDateTime transforme une date de type dos en format TDateTime
end;



function GetFirstParent(Hnd: LongWord): LongWord;
var tmphnd : LongWord;
begin
tmphnd := Hnd;
while GetParent(tmphnd) <> 0
do tmphnd := GetParent(tmphnd);
result := tmphnd;
end;


function GetNumberOfMouseButtons: Integer;
begin
  Result := GetSysTemMetrics(SM_CMOUSEBUTTONS);
end;

function NT9XSetPowerState(fSuspend, fForce: Boolean): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(),
      TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
      TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd,
          False,
          TTokenPvg,
          cbtpPrevious,
          rTTokenPvg,
          pcbtpPreviousRequired);
    end;
  end;
  result := SetSystemPowerState(fSuspend, fForce);
end;

function FnctStrToInt(Str :String) : integer;
begin
if FnctIsInteger(Str) = True
then Result := StrToint(Str)
else result := 0;
end;

function GetWindowModuleFileName( const hSrcWnd: LongWord ): string;
var
 Data :TProcessEntry32;
 hID  :DWord;
 Snap : Integer;
 Done : boolean;
 ExeName : string;
begin
 Result := '';
 try
   GetWindowThreadProcessId(hSrcWnd,@hID);
   Snap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
   Done:=false;
   ExeName := '';
   try
     Data.dwSize:=SizeOf(Data);
     if(Process32First(Snap,Data))then
     begin
       repeat
         if Data.th32ProcessID=hID then
         begin
           ExeName:= StrPas(Data.szExeFile);
           Done:=true;
         end;
       until Done or not(Process32Next(Snap,Data));
     end;
   finally
     Windows.CloseHandle(Snap);
   end;
   result := LowerCase(ExtractFileName(ExpandUNCFileName(ExeName)));
 except
//    Result := '';
 end;
end;

function GetVKKeyToKeyName(VK_Key : cardinal) : String;
var i : integer;
begin
LoadMyKeyboard;
for i := 1 to 110
do if MyKeyBoard[i].VirtualKey = VK_Key
   then begin result := MyKeyBoard[i].KeyName; break; end;
end;

function GetVKKeyExtentedToKeyName(VK_Key : cardinal) : String;
var i : integer;
begin
LoadMyKeyboard;
for i := 1 to 110
do if MyKeyBoard[i].VirtualKey = VK_Key
   then begin result := MyKeyBoard[i].KeyName; end;
end;

procedure LoadMyKeyboard();
var i : integer;
    MySpButton : TSpeedButton;
begin
for i := 1 to 110
do begin
   MySpButton := (form4.FindComponent('SpeedButton' + inttostr(i)) as TSpeedButton);
   if MySpButton = nil
   then begin
        MyKeyBoard[i].VirtualKey := 0;
        MyKeyBoard[i].KeyName := '';
        continue;
        end;
   if MySpButton.Tag < 100
   then MyKeyBoard[i].VirtualKey := MySpButton.Tag
   else MyKeyBoard[i].VirtualKey := MySpButton.Tag -100;
   MyKeyBoard[i].KeyName := MySpButton.Hint;
   MyKeyBoard[i].VirtualKey := MapVirtualKey(MyKeyBoard[i].VirtualKey,1); // le code 3 est reservé a 98 XP
   if MyKeyBoard[i].VirtualKey = 0 then Debug.WriteMessage(Form1.ListView2,0,'Warning','Error to MapVirtualKey');


   if MySpButton.Name = 'SpeedButton106' then MyKeyBoard[i].VirtualKey := VK_LEFT;
   if MySpButton.Name = 'SpeedButton107' then MyKeyBoard[i].VirtualKey := VK_DOWN;
   if MySpButton.Name = 'SpeedButton108' then MyKeyBoard[i].VirtualKey := VK_RIGHT;
   if MySpButton.Name = 'SpeedButton109' then MyKeyBoard[i].VirtualKey := VK_UP;

   if MySpButton.Name = 'SpeedButton100' then MyKeyBoard[i].VirtualKey := VK_INSERT;
   if MySpButton.Name = 'SpeedButton101' then MyKeyBoard[i].VirtualKey := VK_HOME;
   if MySpButton.Name = 'SpeedButton102' then MyKeyBoard[i].VirtualKey := VK_PRIOR;
   if MySpButton.Name = 'SpeedButton103' then MyKeyBoard[i].VirtualKey := VK_DELETE;
   if MySpButton.Name = 'SpeedButton104' then MyKeyBoard[i].VirtualKey := VK_END;
   if MySpButton.Name = 'SpeedButton105' then MyKeyBoard[i].VirtualKey := VK_NEXT;

   if MySpButton.Name = 'SpeedButton16' then MyKeyBoard[i].VirtualKey := VK_SNAPSHOT;
   if MySpButton.Name = 'SpeedButton17' then MyKeyBoard[i].VirtualKey := VK_SCROLL;
   if MySpButton.Name = 'SpeedButton18' then MyKeyBoard[i].VirtualKey := VK_PAUSE;

   if MySpButton.Name = 'SpeedButton92' then MyKeyBoard[i].VirtualKey := VK_NUMPAD0;
   if MySpButton.Name = 'SpeedButton96' then MyKeyBoard[i].VirtualKey := VK_NUMPAD1;
   if MySpButton.Name = 'SpeedButton97' then MyKeyBoard[i].VirtualKey := VK_NUMPAD2;
   if MySpButton.Name = 'SpeedButton98' then MyKeyBoard[i].VirtualKey := VK_NUMPAD3;
   if MySpButton.Name = 'SpeedButton84' then MyKeyBoard[i].VirtualKey := VK_NUMPAD4;
   if MySpButton.Name = 'SpeedButton85' then MyKeyBoard[i].VirtualKey := VK_NUMPAD5;
   if MySpButton.Name = 'SpeedButton86' then MyKeyBoard[i].VirtualKey := VK_NUMPAD6;
   if MySpButton.Name = 'SpeedButton88' then MyKeyBoard[i].VirtualKey := VK_NUMPAD7;
   if MySpButton.Name = 'SpeedButton89' then MyKeyBoard[i].VirtualKey := VK_NUMPAD8;
   if MySpButton.Name = 'SpeedButton90' then MyKeyBoard[i].VirtualKey := VK_NUMPAD9;
   if MySpButton.Name = 'SpeedButton94' then MyKeyBoard[i].VirtualKey := VK_SEPARATOR;
                                                                          
   if MySpButton.Name = 'SpeedButton80' then MyKeyBoard[i].VirtualKey := VK_NUMLOCK;
   if MySpButton.Name = 'SpeedButton81' then MyKeyBoard[i].VirtualKey := VK_DIVIDE;
   if MySpButton.Name = 'SpeedButton82' then MyKeyBoard[i].VirtualKey := VK_MULTIPLY;
   if MySpButton.Name = 'SpeedButton83' then MyKeyBoard[i].VirtualKey := VK_SUBTRACT;
   if MySpButton.Name = 'SpeedButton91' then MyKeyBoard[i].VirtualKey := VK_ADD;
   if MySpButton.Name = 'SpeedButton87' then MyKeyBoard[i].VirtualKey := VK_RETURN;

   if MySpButton.Name = 'SpeedButton1' then MyKeyBoard[i].VirtualKey := VK_MENU;
   if MySpButton.Name = 'SpeedButton3' then MyKeyBoard[i].VirtualKey := VK_LWIN;
   if MySpButton.Name = 'SpeedButton5' then MyKeyBoard[i].VirtualKey := VK_RWIN;
   if MySpButton.Name = 'SpeedButton6' then MyKeyBoard[i].VirtualKey := VK_APPS;
   end;
end;

Procedure ScruteFichier(Dossier:string;filtre:string;Attributs:integer; ToFile : String);
var FichierTrouve:string;
    Resultat:Integer;
    SearchRec:TSearchRec;
    MaskPtr,Ptr:Pchar;
    Fic : TextFile;
begin
  If (Dossier<>'')
    then if  (Dossier[length(Dossier)]='\')
      then Dossier:=copy(Dossier,1,length(Dossier)-1);
  MaskPtr := PChar(Filtre);
  while MaskPtr <> nil do // boucle pour chaque filtre contenu dans Filtre
  begin
       Ptr := StrScan (MaskPtr, ';');// adresse de la première occurence de ';'
       if Ptr <> nil then Ptr^ := #0; // on remplace le ; par un caractère de fin de chaine #0
       // ainsi, MaskPtr ne sera interprété que comme ayant un seul filtre
       Resultat:=FindFirst(Dossier+'\'+MaskPtr,Attributs,SearchRec);
       while (Resultat=0) do
       begin
            Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main
            if ((SearchRec.Attr and faDirectory)<=0) then // On a trouvé un Fichier (et non un dossier)
            begin
                  FichierTrouve:=Dossier+'\'+SearchRec.Name;
                  assignfile(fic,ToFile);
                  if not fileExists(ToFile)
                  then begin
                       rewrite(fic);
                       closefile(fic);
                       end;
                  Append(fic);
                  Writeln(fic,FichierTrouve);
                  Flush(fic);
                  CloseFile(fic);
            end;
            Resultat:=FindNext(SearchRec);
       end;
       FindClose(SearchRec);// libération de la mémoire
       if Ptr <> nil then
       begin
            Ptr^ := ';';// on remet le ; à la place du #0
            Inc (Ptr); // on se décale dans la chaine de caractère pour se placer derrière le #0
       end;
       MaskPtr := Ptr;//on retire ainsi les filtres déjà vus
  end;
end;

Procedure ScruteDossier(Penetration:integer;Dossier:string;filtre:string;attributs:integer;recursif:boolean; ToFile : String);
var DossierTrouve:string;
    Resultat:Integer;
    SearchRec:TSearchRec;
begin
  if Dossier<>'' then
     If Dossier[length(Dossier)]='\' then Dossier:=copy(Dossier,1,length(Dossier)-1); // s'il y a un '\' à la fin, je le retire
  ScruteFichier(Dossier,filtre,attributs, ToFile); //pour trouver les fichiers du dossier
  Resultat:=FindFirst(Dossier+'\'+'*.*',FaDirectory +faHidden + faSysFile ,SearchRec); //permet de trouver le premier sous dossier de Dossier
  while (Resultat=0)do                                           // SearchRec contient tous les renseignements concernant le dossier trouvé
  begin
    if (SearchRec.Name<>'.') and (SearchRec.Name<>'..')
         and ((SearchRec.Attr and faDirectory)>0) then // C'est comme cela que je teste si on a trouvé un Dossier et non un fichier
    begin
      DossierTrouve:=Dossier+'\'+SearchRec.Name; // pour avoir le nom du dossier avec le chemin complet
      //if stop then exit;
      if recursif then
      begin
        ScruteDossier(Penetration+1,DossierTrouve,filtre,attributs,recursif, ToFile);// je relance la recherche mais cette fois à partir du dossier trouvé
      end;
      Application.ProcessMessages; // rend la main à windows pour qu'il traite les autres applications (évite que l'application garde trop longtemps la main
    end;
    Resultat:=FindNext(SearchRec); // permet de trouver les sous dosssiers suivants
  end;
  FindClose(SearchRec);//libère la mémoire
end;

function findTextParam(Index : integer; Chaine : String) : Boolean;
var ListParam : Tparam;
    StrParam : String;
    i : integer;
begin
result := false;
StrParam := Form1.ListView1.Items.Item[Index].SubItems.Strings[0];
ListParam := GetParam(StrParam);
for i := 1 to ListParam.nbr_param-1 do
if ListParam.param[i] = Chaine then result := True;
end;

function findTextPos(Index : integer; Chaine : String) : integer;
var ListParam : Tparam;
    StrParam : String;
    i : integer;
begin
result := 0;
StrParam := Form1.ListView1.Items.Item[Index].SubItems.Strings[0];
ListParam := GetParam(StrParam);
for i := 1 to ListParam.nbr_param-1 do
if ListParam.param[i] = Chaine then result := i;
end;

function countfindTextParam(Commande, Chaine : String) : Integer;
var i : integer;
begin
result := 0;
for i := 0 to Form1.ListView1.Items.Count - 1 do
begin
if Form1.ListView1.Items.Item[i].Caption = Commande
then begin
     if findTextParam(i,Chaine) = True then result := result + 1;
     end;
end;
end;

function FileNameValide(filename : string) : boolean;
begin
if ((ExtractFileDir(filename) = '') or
    (ExtractFileName(filename) = '') or
    (ExtractFileDrive(filename) = '') or
    (ExtractFileExt(filename) = ''))
then result := False
else result := True;
end;

function DirNameValide(filename : string) : boolean;
var DirExplode : TStrArray;
    i : integer;
begin
result := True;
// vérifie les caractères interdits
for i := 3 to length(FileName)
do if FileName[i] in ['/',':','*','?','"','<','<','|','.']
     then begin result := False; Exit; end;
Explode(FileName,'\',DirExplode);
if length(DirExplode) = 0
then begin result := False; Exit; end;
// vérifie le Nom du lecteur
if length(DirExplode[0]) <> 2
then begin result := False; Exit; end;
if not(DirExplode[0][1] in ['a'..'z','A'..'Z'])
then begin result := False; Exit; end;
if DirExplode[0][2] <> ':'
then begin result := False; Exit; end;
end;
procedure touche_Alt(touche_supp : integer);
begin
KeyBD_event(vk_menu, $45, KeyEventf_ExtendedKey, 0);
KeyBD_event(touche_supp, $45, 0, 0);
KeyBD_event(vk_menu, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
end;

procedure touche_altGr(touche_supp : integer);
begin
KeyBD_event(VK_CONTROL, $45, 0, 0);
touche_Alt(touche_supp);
KeyBD_event(VK_CONTROL, $45, KeyEventf_KeyUp,0);
end;

procedure touche_Shift(touche_supp : integer);
var CapLock : Boolean;
begin
CapLock :=(GetKeyState(VK_CAPITAL) and $01) <> 0;
if CapLock = false
then KeyBD_event(vk_Lshift, $45, KeyEventf_ExtendedKey, 0);
KeyBD_event(touche_supp, $45, 0, 0);
if CapLock = false
then KeyBD_event(vk_Lshift, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
end;

procedure touche_Ctrl(touche_supp : integer);
begin
KeyBD_event(VK_CONTROL, $45, KeyEventf_ExtendedKey, 0);
KeyBD_event(touche_supp, $45, 0, 0);
KeyBD_event(VK_CONTROL, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
end;



Function GetValue(variable : String):String;
var valeur : String;
    Type_var : string;
begin
Type_var := FnctTypeVar(variable);
if Type_var = TNo then valeur := variable
else if Type_var = TNum then valeur := Form1.ReadVariable('VAR',variable,'0')
     else if Type_var = TAlpha then valeur := Form1.ReadVariable('VAR',variable,'');

result:= valeur;
end;


function Donne_Class(Hwnd: integer): string;
var
  ClassName : Array[0..255] Of Char;
begin
  Result := '';
  try
  GetClassName(Hwnd, ClassName, SizeOf(ClassName));
  except end;
  Result := String(ClassName);
end;

function GetText(Hnd: LongWord): string;
var Texte:array[0..255]of Char;
begin
  try
  SendMessage(Hnd,WM_GETTEXT,255,Integer(@Texte));
  except end;
  result := String(Texte);
end;

Function ForceForegroundWindow(hWnd: LongWord): Boolean;
var ThreadID1 : Dword;
    ThreadID2 : Dword;
    nRet : boolean;
begin
ThreadID1 := 0;
   // Nothing to do if already in foreground.
   If hWnd <> GetForegroundWindow()
   Then
      ThreadID1 := GetWindowThreadProcessId(GetForegroundWindow, nil);
      ThreadID2 := GetWindowThreadProcessId(hWnd, nil);
      // By sharing input state, threads share their concept of
      // the active window.
      If ThreadID1 <> ThreadID2
      Then begin
           AttachThreadInput(ThreadID1, ThreadID2, True);
           nRet := SetForegroundWindow(hWnd);
           AttachThreadInput(ThreadID1, ThreadID2, False);
           end
      Else nRet := SetForegroundWindow(hWnd);
      // Restore and repaint
      If IsIconic(hWnd)
      Then ShowWindow(hWnd, SW_RESTORE)
      Else ShowWindow(hWnd, SW_SHOW);
      // SetForegroundWindow return accurately reflects success.
      ForceForegroundWindow := nRet;
End;

Function Decompose_Date(Date_Param : TdateTime; Mesure : String): String;
var return_val : String;
    param : String;
begin
if ((Mesure ='Jour') or (Mesure = 'Mois') or (Mesure ='Année'))
then Param := FormatDateTime( 'dd/mm/yyyy',Date_Param);
if Mesure = 'Jour' then return_val := Param[1] + Param[2];
if Mesure = 'Mois' then return_val := Param[4] + Param[5];
if Mesure = 'Année' then return_val := Param[7] + Param[8]+Param[9]+Param[10];

if ((Mesure ='Heure') or (Mesure = 'Minute') or (Mesure ='Seconde'))
then Param := FormatDateTime( 'hh:mm:ss',Date_Param);
if Mesure = 'Heure' then return_val := Param[1] + Param[2];
if Mesure = 'Minute' then return_val := Param[4] + Param[5];
if Mesure = 'Seconde' then return_val := Param[7] + Param[8];

result := return_val;
end;

Function FnctIsInteger(Param : String): Boolean;
var V,code : integer;
begin
result := False;
if Param ='' then Exit;
if (Param[1] ='x') or (Param[1] ='X') then exit; // a conserver sinon x1 serait un nombre valide
Val(Param,V,code);
if Code = 0 then result := True
            else result := False;
end;

function FnctIsFloat(Param : String) : Boolean;
var V : real;
    code : integer;
begin
result := False;
if Param ='' then Exit;
if (Param[1] ='x') or (Param[1] ='X') then exit; // a conserver sinon x1 serait un nombre valide
Val(Param,V,code);
if Code = 0 then result := True
            else result := False;
end;

function FnctIsdate (Param : String): Boolean;
var jour,mois,annee : string;
begin
result := True;
if length(Param) <> 8
then result := False
else begin
     jour  := Param[1] + Param[2];
     mois  := Param[4] + Param[5];
     annee := Param[7] + Param[8];
     if FnctIsInteger(jour) = False then result := False;
     if FnctIsInteger(mois) = False then result := False;
     if FnctIsInteger(annee) = False then result := False;
     end;
if result = True
then begin
     if (StrToInt(jour) < 0) or (StrToInt(jour) > 31) then result := False;
     if (StrToInt(mois) < 0) or (StrToInt(mois) > 12) then result := False;
     end;
end;

function GetParam(strParam : String):TParam;
var i,j : integer;
    resultparam :Tparam;
begin
// initialistation
for i := 1 to 20 do
resultparam.param[i] := '';

i :=1;
// traitement
for j := 1 to length(StrParam) do
    begin
    if  StrParam[j] <> SprPr
    then resultparam.param[i] := resultparam.param[i] + Strparam[j]
    else if j < length(StrParam) then Inc(i);
    end;
resultparam.nbr_param := i+1; // avant -1
result := resultparam;
end;

// --------------------------------- procedure des commandes ------------------------------------------------


procedure FnctType(Text : String);
var i : integer;
    Type_var1 : String;
    Param_Pause : string;
    Char1: Char;
    Small1, Small2: Smallint;
begin
// verification de valeur ou de variable
Type_var1 := FnctTypeVar(Text);

Text := GetValue(Text);

param_pause := '0;MilliSec;';

if form19.CheckBox2.Checked = True
then param_Pause := form19.TPFEdit.text +';MilliSec;';

//SendKeys(Pchar(Text),False);
{
if (GetKeyState(VK_CAPITAL) and $01) <> 0
then capitalState := True else CapitalState := False;
if CapitalState = True
then begin
//     KeyBD_event(VK_capital, $45, 0, 0);
//     KeyBD_event(VK_capital, $45, KeyEventf_KeyUp, 0);
     KeyBD_event(VK_Lshift, $45,KEYEVENTF_EXTENDEDKEY,0);
     end;
}//

// test si Alt est activé et que la frappe de texte est un nombre pour les caractères spéciaux
if ((GetKeyState(VK_MENU) and $01) <> 0) and (FnctIsInteger(Text)= True)
then begin
     KeyBD_event(VK_MENU, $45 , KEYEVENTF_KEYUP, 0);
     KeyBD_event(VK_MENU, $45 , 0, 0);
     application.ProcessMessages;
     for i := 1 to length(Text)
     do begin
        KeyBD_event(VK_NUMPAD0+StrToInt(Text[i]), MapvirtualKey(VK_NUMPAD0+StrToInt(Text[i]), 0) , 0, 0);
        KeyBD_event(VK_NUMPAD0+StrToInt(Text[i]), MapvirtualKey(VK_NUMPAD0+StrToInt(Text[i]), 0), KEYEVENTF_KEYUP, 0);
        end;
      exit;
   end;

for i := 1 to length(Text) do
begin
if form19.CheckBox2.Checked = True
then Form1.FnctPause(form19.TPFEdit.text +';MilliSec;');
Char1 := Text[i];
Small1 := VkKeyScan(Char1);


if Small1 >= 0
then FnctTypePlus(Small1)
else begin
     case Text[i] of
     'Ä' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('A');
           FnctTypePlus(small2);
           end;
     'Ë' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('E');
           FnctTypePlus(small2);
           end;
     'Ï' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('I');
           FnctTypePlus(small2);
           end;
     'Ö' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('O');
           FnctTypePlus(small2);
           end;
     'ä' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('a');
           FnctTypePlus(small2);
           end;
     'ë' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('e');
           FnctTypePlus(small2);
           end;
     'ï' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('i');
           FnctTypePlus(small2);
           end;
     'ö' : begin
           Small2 := VkKeyScan('¨');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('o');
           FnctTypePlus(small2);
           end;
     'Â' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('A');
           FnctTypePlus(small2);
           end;
     'Ê' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('E');
           FnctTypePlus(small2);
           end;
     'Î' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('I');
           FnctTypePlus(small2);
           end;
     'Ô' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('O');
           FnctTypePlus(small2);
           end;
     'Û' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('U');
           FnctTypePlus(small2);
           end;
     'â' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('a');
           FnctTypePlus(small2);
           end;
     'ê' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('e');
           FnctTypePlus(small2);
           end;
     'î' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('i');
           FnctTypePlus(small2);
           end;
     'ô' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('o');
           FnctTypePlus(small2);
           end;
     'û' : begin
           Small2 := VkKeyScan('^');
           FnctTypePlus(small2);
           Small2 := VkKeyScan('u');
           FnctTypePlus(small2);
           end;
     end;
end;
end;
{if CapitalState = True
then begin
     //KeyBD_event(VK_capital, $45, 0, 0);
     //KeyBD_event(VK_capital, $45, KeyEventf_KeyUp, 0);
     KeyBD_event(VK_Lshift, $45,KEYEVENTF_EXTENDEDKEY or KeyEventf_KeyUp,0);
     end;
}
end;

procedure FnctTypePlus(small : Smallint);
var CapLock : Boolean;
begin
CapLock :=(GetKeyState(VK_CAPITAL) and $01) <> 0;
if HiByte(Small) = 0
then begin
     if CapLock = true
     then KeyBD_event(vk_Lshift, $45, KeyEventf_ExtendedKey, 0);
     KeyBD_event(LoByte(Small), $45, 0, 0);
     if CapLock = true
     then KeyBD_event(vk_Lshift, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
     end;
if HiByte(Small) = 1 then Touche_shift(LoByte(Small));
if HiByte(Small) = 2 then Touche_ctrl(LoByte(Small));
if HiByte(Small) = 4 then Touche_Alt(LoByte(Small));
if HiByte(Small) = 6 then Touche_AltGr(LoByte(Small));
end;

function tableaurtf(nbcol,nbligne,largeur:integer):string;
var i,j : integer;
begin
 result:='{\rtf1\trowd';
 for i:=1 to nbcol do result:=result+format('\cellx%d',[i*(2000+largeur)]);
 for j:=1 to nbligne do
 begin
  result:=result+'\intbl';
  for i:=1 to nbcol do result:=result+'\cell';
  result:=result+'\row';
 end;
 result:=result+'}';
end; 

function black(text : string):string;
begin
result := '{\rtf1\ansi\ansicpg1252\deff0\deflang1036{\fonttbl{\f0\froman\fprq2\fcharset0 Times New Roman;}{\f1\fnil MS Sans Serif;}}'+
'{\colortbl ;\red255\green255\blue255;\red0\green0\blue0;}'+
'\viewkind4\uc1\pard\cf1\highlight2\f0\fs24 '+Text+'\highlight0'+
'\par \pard\cf0\f1\fs16'+
'\par }';
end;

procedure FnctExecute(command : String);
var  ExtSpl : boolean;
     param : TParam;
     exeparam : String;
     tmp,fichier : string;
     i : integer;
     SousMacro : TListView;
     NewColumn: TListColumn;
     ParentPos : integer;
     FileExt : String;
     SousActiveOrder :TActiveOrder;
     UpdateIniFile : String;
begin
ExtSpl := False;
Param := GetParam(command);
Fichier := GetValue(Param.Param[1]);
Exeparam := GetValue(Param.Param[2]);

if not FileExists(Fichier)
then begin
     tmp := '';
     for i := 1 to length(Fichier)
     do begin
        if Fichier[i] <> '"' then tmp := tmp + Fichier[i];
        if FileExists(tmp) then begin  ExeParam := Copy(Fichier,i+2,length(Fichier)); Fichier := '"'+tmp+'"'; break; end;
        end;
     end;

FileExt := ExtractFileExt(Fichier);
if Pos('"',FileExt) <> 0
then Delete(FileExt, Pos('"',FileExt),1);


if (AnsiStrLIComp(Pchar(fichier),'http://',length('http://')) = 0) or
   (AnsiStrLIComp(Pchar(fichier),'mailto:',length('mailto:')) = 0)
then begin
     ShellExecute(0,'Open',  PChar(Fichier) ,'','',SW_SHOWNORMAL);
     Exit;
     end;

if (FileExt = '.wav') and (Exeparam = '')
then begin
     ExtSpl := True;
     if Form19.CheckBox6.Checked = True
     then PlaySound(PChar(fichier),0,SND_SYNC)
     else PlaySound(PChar(fichier),0,SND_ASYNC)
     end;

if FnctIsInteger(Fichier)
then begin
     i := StrToInt(Fichier)-1;
     if (i >= 0) and (i <= form1.MesOutils1.Count-1)
     then form1.MesOutils1.Items[i].Click
     else Form1.ErrorComportement('N° de raccourci introuvable ['+IntToStr(i+1)+'] dans le menu "Mes Outils".');
     Exit;
     end;

if (FileExt = '.mcr') //and (ExeParam ='')
then begin
     ExtSpl := True;
     if ExeParam <> ''
     then begin
          ShellExecute(0,nil,Pchar(Application.ExeName),Pchar(Fichier+' '+ExeParam),nil,SW_SHOWNORMAL);
          Exit;
          end;

     if SousMacroIndent > 12-1 // en réalité 12 mais l'incrémentation se fait après le test
     then Form1.ShowApplicationError('Niveau d''indentation de sous macro trop grand (Max12).');

     if not FileExists(Fichier)
     then begin Form1.ErrorComportement('Fichier introuvable ('+ Fichier +').'); Exit; end;
     SousMacro := TListView.Create(form23);
     SousMacroExecute := SousMacro;
     Inc(SousMacroIndent);
     TabSousMacroExecute[SousMacroIndent] := SousMacro;
     try
     SousMacro.Parent := form23;
     SousMacro.Align := alClient;
     SousMacro.ViewStyle := vsReport;
     NewColumn := SousMacro.Columns.Add;
     NewColumn.Caption := 'Commande';
     NewColumn := SousMacro.Columns.Add;
     NewColumn.Caption := 'Paramètres';
     SousMacro.LargeImages := Form1.ImageList1;
     SousMacro.SmallImages := Form1.ImageList1;
     SousMacro.StateImages := Form1.ImageList1;

     // suppression des Quotes et espace
     Fichier := Trim(Fichier);
     if Fichier[1] = '"'
     then Fichier := Copy(Fichier,2,length(Fichier));
     if Fichier[length(Fichier)] = '"'
     then Fichier := Copy(Fichier,1,length(Fichier)-1);
     Form1.OpenFileMacro(Fichier,SousMacro, 0,'Chargement de '+ Fichier +', veuillez patient SVP.');

     // chargement du Fichier des paramètres de la sous macro
     UpdateIniFile := ChangeFileExt(Fichier,'.ini');
     if FileExists(UpdateIniFile)
     then begin Form19.UpdateParam(UpdateIniFile); Form1.ChangeResolution(False); end;

     ParentPos := unit1.pos_command +1;
     for i := 0 to SousMacro.Items.Count -1
     do begin
        if Debug.Control(SousMacro, SousMacro.Items[i].Caption,SousMacro.Items[i].SubItems[0],i,ParentPos) = False
        then begin
             if Form1.ListView2.Items[0].SubItems[1] = Dbg_NoError
             then Form1.ListView2.Items[0].Delete;
             Form1.Stop1.Click;
             Form1.PageControl1.ActivePage := Form1.TabSheet1;
          end;
        end;

     if Form1.CheckBox3.Checked = True
     then begin
          Form1.RichEdit1.Lines.Add('');
          Form1.RichEdit1.SelText :=black('Entre dans une sous-macro ('+ExtractFileName(Fichier)+').');
          end;

     Setlength(SousActiveOrder,SousMacro.items.count);
     for i := 0 to SousMacro.Items.Count-1
     do SousActiveOrder[i] := True;
     i := 0;
     while ((i < SousMacro.Items.Count) and (Run = True))
     do begin
        SousMacroExecuteIndex := i;
        Form1.Execute_commande(SousMacro,i,SousActiveOrder);
        if DLL_POS_ORDER_CHANGE = True
        then begin i := SousMacroExecuteIndex; DLL_POS_ORDER_CHANGE := False; end;
        if i < SousMacro.Items.Count
        then if SousMacro.Items[i].Caption = 'Quitter' then break;
        end;

     finally
            Dec(SousMacroIndent);
            if SousMacroIndent > 0
            then SousMacroExecute := TabSousMacroExecute[SousMacroIndent]
            else SousMacroExecute := nil;
            TabSousMacroExecute[SousMacroIndent+1] := nil;
            SousMacro.Free;
            if Form1.CheckBox3.Checked = True
            then begin
                 Form1.RichEdit1.Lines.Add('');
                 Form1.RichEdit1.SelText :=black('Quitte sous-macro ('+ExtractFileName(Fichier)+').');
                 end;
            if FileExists(UpdateIniFile)
            then begin Form19.UpdateParam(UpdateIniFile); Form1.ChangeResolution(True); end;
            end;
     end;



if ExtSpl = False
then begin
     if (ExtractFileExt(Fichier)=  '.exe') and (ExeParam = '')
     then WinExec(Pchar(fichier),SW_SHOWNORMAL)
     else if ExeParam = ''
          then begin
               if ShellExecute(form1.handle,'Open',  PChar(Fichier) ,'','',SW_SHOWNORMAL) <= 32
               then Form1.ErrorComportement(SysErrorMessage(GetLastError),1);
               end
          else begin
               if ShellExecute(form1.handle,'',  PChar(Fichier) ,PChar(ExeParam),'',SW_SHOWNORMAL) <= 32
               then Form1.ErrorComportement(SysErrorMessage(GetLastError),1);
               end;
     end;

end;

procedure FnctMoveMouse(Param : String);
var Coor : Tpoint;
    ListParam : Tparam;
    curPt, LastCurPt : Tpoint;
    vitesse : integer;
    b,pente : real;
    diagx,diagy : integer;
    pause : String;
begin
ListParam := GetParam(Param);
if FnctIsInteger(GetValue(ListParam.Param[1])) = true
then Coor.X := StrToInt(GetValue(ListParam.Param[1]))
else begin Form1.ErrorComportement('La valeur de X n''est pas un numérique.['+ListParam.Param[1]+']'); Exit; end;

if FnctIsInteger(GetValue(ListParam.Param[2])) = true
then Coor.Y := StrToInt(GetValue(ListParam.Param[2]))
else begin Form1.ErrorComportement('La valeur de Y n''est pas un numérique.['+ListParam.Param[2]+']'); Exit; end;

if ListParam.param[3] = 'Direct'
then begin
     if Win32MajorVersion = 4
     then SetCursorPos(Coor.x,Coor.y)
     else MouseMoveWithSendInput(Coor.X,Coor.Y);
     Exit;
     end;

if ListParam.param[3] = 'Indirect'
then begin
     // initialisation
     if FnctIsInteger(Form19.Edit4.text) = true
     then pause := Form19.Edit4.text+ SprPr+'MilliSec'+SprPr
     else pause := '3000'+SprPr+'MilliSec'+SprPr;
     pente := 0;
     GetCursorPos(CurPt);
     vitesse := -1;
     diagx := CurPt.x - Coor.x;
     diagy := CurPt.y - Coor.y;
     if diagx <> 0 then pente := diagy / diagx;
     b := Coor.y - (pente * Coor.x) ;
     // deplacement de la souris
     if abs(diagx) > abs(diagy)
     then begin
               while coor.x < CurPt.x do
               begin
               if unit1.Run = False then Exit;
               SetCursorPos(CurPt.x,CurPt.y);
               LastCurPt := CurPt;
               Dec(CurPt.x);
               CurPt.y := trunc(pente * CurPt.x + b);
               Inc(Vitesse);
               if Form19.TrackBar1.Position = Vitesse
               then begin
                    SleepEX(10,False);
                    Application.ProcessMessages;
                    Vitesse := -1;
                    GetCursorPos(CurPt);
                    if (CurPt.x <> LastCurPt.x) or (CurPt.y <> LastCurPt.y)
               then begin form1.FnctPause(pause); GetCursorPos(CurPt); end;
                    end;
               end;
               while coor.x > CurPt.x  do
               begin
               if unit1.Run = False then Exit;
               SetCursorPos(CurPt.x,CurPt.y);
               LastCurPt := CurPt;
               Inc(CurPt.x);
               CurPt.y := Trunc(pente * CurPt.x + b);
               Inc(Vitesse);
               if Form19.TrackBar1.Position = Vitesse
               then begin
                    SleepEX(10,False);
                    Application.ProcessMessages;
                    Vitesse := -1;
                    GetCursorPos(CurPt);
                    if (CurPt.x <> LastCurPt.x) or (CurPt.y <> LastCurPt.y)
                    then begin form1.FnctPause(pause); GetCursorPos(CurPt); end;
                    end;
               end;
          end
          else begin
               while coor.y < CurPt.y do
               begin
               if unit1.Run = False then Exit;
               SetCursorPos(CurPt.x,CurPt.y);
               LastCurPt := CurPt;
               Dec(CurPt.y);
               if pente <> 0
               then CurPt.x := trunc((CurPt.y - b) / pente)
               else CurPt.x := trunc(Coor.x);
               Inc(Vitesse);
               if Form19.TrackBar1.Position = Vitesse
               then begin
                    SleepEX(10,False);
                    Application.ProcessMessages;
                    Vitesse := -1;
                    GetCursorPos(CurPt);
                    if (CurPt.x <> LastCurPt.x) or (CurPt.y <> LastCurPt.y)
               then begin form1.FnctPause(pause); GetCursorPos(CurPt); end;
                    end;
               end;
               while coor.y > CurPt.y  do
               begin
               if unit1.Run = False then Exit;
               SetCursorPos(CurPt.x,CurPt.y);
               LastCurPt := CurPt;
               Inc(CurPt.y);
               if pente <> 0
               then CurPt.x := trunc((CurPt.y - b) / pente)
               else CurPt.x := trunc(Coor.x);
               Inc(Vitesse);
               if Form19.TrackBar1.Position = Vitesse
               then begin
                    SleepEX(10,False);
                    Application.ProcessMessages;
                    Vitesse := -1;
                    GetCursorPos(CurPt);
                    if (CurPt.x <> LastCurPt.x) or (CurPt.y <> LastCurPt.y)
                    then begin form1.FnctPause(pause); GetCursorPos(CurPt); end;
                    end;
               end;
          end;
     SetCursorPos(Coor.x,Coor.y);
     end;
end;
procedure FnctClick(Param : String);
var ListParam : Tparam;
    ExtraInfo : DWORD;
    i,j : integer;
    DoubleClickTime : Longint;
begin
ExtraInfo := 0;
DoubleClickTime := GetDoubleClickTime;
DoubleClickTime := DoubleClickTime - 300;
if DoubleClickTime < 1 then DoubleClickTime := 300;
if DoubleClickTime > 1000 then DoubleClickTime := 300;

ListParam := GetParam(Param);
for i := 1 to 6 do
     begin
     if listParam.param[i] = 'Left Down' then mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,ExtraInfo);
     if listParam.param[i] = 'Middle Down' then mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,ExtraInfo);
     if listParam.param[i] = 'Right Down' then mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,ExtraInfo);
     if listParam.param[i] = 'Left Up' then mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,ExtraInfo);
     if listParam.param[i] = 'Middle Up' then mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,ExtraInfo);
     if listParam.param[i] = 'Right Up' then mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,ExtraInfo);

     if listParam.param[i] = 'Left click'
     then begin
          mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,ExtraInfo);
          mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,ExtraInfo);
          end;
     if listParam.param[i] = 'Middle click'
     then begin
          mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,ExtraInfo);
          mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,ExtraInfo);
          end;
     if listParam.param[i] = 'Right click'
     then begin
          mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,ExtraInfo);
          mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,ExtraInfo);
          end;
     if listParam.param[i] = 'Left double-click'
     then begin
          mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,ExtraInfo); mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,ExtraInfo);
          Application.ProcessMessages;
          SleepEx(DoubleClickTime,False);
          mouse_event(MOUSEEVENTF_LEFTDOWN,0,0,0,ExtraInfo); mouse_event(MOUSEEVENTF_LEFTUP,0,0,0,ExtraInfo);
          end;
     if listParam.param[i] = 'Middle double-click'
     then begin
          mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,ExtraInfo); mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,ExtraInfo);
          Application.ProcessMessages;
          SleepEx(DoubleClickTime,False);
          mouse_event(MOUSEEVENTF_MIDDLEDOWN,0,0,0,ExtraInfo); mouse_event(MOUSEEVENTF_MIDDLEUP,0,0,0,ExtraInfo);
          end;
     if listParam.param[i] = 'Right double-click'
     then begin
          mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,ExtraInfo); mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,ExtraInfo);
          Application.ProcessMessages;
          SleepEx(DoubleClickTime,False);
          mouse_event(MOUSEEVENTF_RIGHTDOWN,0,0,0,ExtraInfo); mouse_event(MOUSEEVENTF_RIGHTUP,0,0,0,ExtraInfo);
          end;
     if listParam.param[i] = 'Whell Down'
     then for j := 1 to StrToInt(listParam.param[i+1])
          do begin
             mouse_event(MOUSEEVENTF_WHEEL,0,0,-120,ExtraInfo);
             application.ProcessMessages;
             SleepEx(DoubleClickTime,False);
             end;
     if listParam.param[i] = 'Whell Up'
     then for j := 1 to StrToInt(listParam.param[i+1])
          do begin
             mouse_event(MOUSEEVENTF_WHEEL,0,0,120,ExtraInfo);
             application.ProcessMessages;
             SleepEx(DoubleClickTime,False);
             end;
     end;
end;

procedure FnctTypeSpl(Param : String);
var ListParam : Tparam;
    i,j : integer;
    sp_key : array [1..3] of integer;
    //Key: PInputArray;
begin

ListParam := GetParam(Param);
// vérification que le caractère de séparation des paramètres soit reperé
for i := 1 to ListParam.nbr_param-1
do if ListParam.param[i] = '' then begin ListParam.param[i] := SprPr; break; end;; ;

Sp_Key[1] := 0; Sp_Key[2] := 0; Sp_Key[3] := 0;

// retrouve le code virtuel des touches
for j := 1 to 3
do for i := 1 to 110
   do if listParam.param[j] = MyKeyBoard[i].KeyName
      then begin
           Sp_key[j] := MyKeyBoard[i].VirtualKey;
           break;
           end;


// Action Appuyé
if listParam.param[ListParam.nbr_param-1] = '[KeyDown]'
then begin
     // pour corriger les problème particulier de la touche ALT

     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], $45 , 0, 0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2], MapvirtualKey( Sp_key[2], 0) , KEYEVENTF_EXTENDEDKEY or 0, 0);
     if Sp_Key[3] <> 0 then KeyBD_event(Sp_key[3], MapvirtualKey( Sp_key[3], 0) , KEYEVENTF_EXTENDEDKEY or 0, 0);
     Exit;
     end;
// Action relâché
if listParam.param[ListParam.nbr_param-1] = '[KeyUp]'
then begin
     if Sp_Key[3] <> 0 then KeyBD_event(Sp_key[3], MapvirtualKey( Sp_key[3], 0) , KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2], MapvirtualKey( Sp_key[2], 0) , KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], $45 , KEYEVENTF_KEYUP, 0);
     Exit;
     end;
// simulation frappe 3 touches simultanément
if Sp_Key[3] <> 0
then begin
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], MapvirtualKey( Sp_key[1], 0) , KEYEVENTF_EXTENDEDKEY or 0, 0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2], MapvirtualKey( Sp_key[2], 0) , KEYEVENTF_EXTENDEDKEY or 0, 0);
     if Sp_Key[3] <> 0 then KeyBD_event(Sp_key[3], MapvirtualKey( Sp_key[3], 0) , 0, 0);
     if Sp_Key[3] <> 0 then KeyBD_event(Sp_key[3], MapvirtualKey( Sp_key[3], 0) , KEYEVENTF_KEYUP, 0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2], MapvirtualKey( Sp_key[2], 0) , KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], MapvirtualKey( Sp_key[1], 0) , KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
     end
else // ou 2
if Sp_Key[2] <> 0
then begin
{
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], MapvirtualKey(Sp_key[1], 0) , KEYEVENTF_EXTENDEDKEY, 0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2], MapvirtualKey(Sp_key[2], 0) , 0, 0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2], MapvirtualKey(Sp_key[2], 0) , KEYEVENTF_KEYUP, 0);
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], MapvirtualKey(Sp_key[1], 0) , KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
}

     if (Sp_Key[1] = VK_SHIFT) and (Sp_Key[2] <> VK_CONTROL) and (Sp_Key[2] <> VK_MENU)
     then begin touche_Shift(Sp_Key[2]); Exit; end;
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1],0,0,0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2],0,0,0);
     if Sp_Key[2] <> 0 then KeyBD_event(Sp_key[2],0,KEYEVENTF_KEYUP,0);
     if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1],0,KEYEVENTF_KEYUP,0);

     end
else // ou 1
if Sp_Key[1] <> 0
then begin
     if Sp_Key[1] = VK_SEPARATOR then begin FnctType(DecimalSeparator); exit; end;
     if ((GetKeyState(VK_LSHIFT) and $01) <> 0 = True) or
        ((GetKeyState(VK_RSHIFT) and $01) <> 0 = True) or
        ((GetKeyState(VK_MENU) and $01) <> 0 = True) or
        ((GetKeyState(VK_CONTROL) and $01) <> 0 = True)
     then begin // Touche deja appuier utiliser  KEYEVENTF_EXTENDEDKEY
          if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], $45 , KEYEVENTF_EXTENDEDKEY or 0, 0);
          if Sp_Key[1] <> 0 then KeyBD_event(Sp_key[1], $45 , KEYEVENTF_EXTENDEDKEY or KEYEVENTF_KEYUP, 0);
          end
     else KeyBD_event(Sp_key[1], $45 ,0, 0);
     end;
application.ProcessMessages;
end;

function FnctGoto(ListView : TListView; Param : String): integer;
var ListParam : Tparam;
    i : integer;
begin
ListParam := GetParam(Param);
result := 0;
for i := 0 to ListView.Items.Count - 1 do
if ((ListView.items.Item[i].SubItems.Strings[0] = ListParam.param[1]) and
    (ListView.Items[i].Caption = 'Label'))
then result := i;
Application.ProcessMessages;
end;

function Fnctprocedure(ListView : TListView; Index :integer; Params : String; var ActiveOrd : TActiveOrder): integer;
var ActionType : cardinal;
    i : integer;
    ProcName : String;
    MsgError : String;
begin
result := -1;
MsgError := '';
ProcName := '';
ActionType := 1;
if copy(params,0,3) = 'END' then ActionType := 2;
if copy(params,0,5) = 'CALL ' then begin ActionType := 3; ProcName := copy(params,6,length(params)); end;

try
if ActionType = 1
then begin
     ProcName := Params;
     i := form1.FindEndOfProcedure(ListView,Index);
     if i < 0 then MsgError := 'La procédure nommée '+ProcName+ ' n''est pas fermée.'
     else result := i+1;
     end;
if ActionType = 2
then begin
     if length(ProcReg) <= 0
     then  MsgError := 'Une erreur a été généré lors du retour de fin de procédure.'
     else result := ProcReg[length(ProcReg)-1]+1;
     Setlength(ProcReg,length(ProcReg)-1);
     end;
if ActionType = 3
then begin
     if Form1.procedure_exists(ListView,ProcName) < 0
     then MsgError := 'La procédure nommée '+ProcName+' n''existe pas.'
     else begin
          i := Form1.procedure_exists(ListView,ProcName);
          SetLength(ProcReg, length(ProcReg)+1);
//          if unit1.command_disable = -1
          if ActiveOrd[index] = True
          then ProcReg[length(ProcReg)-1] := Index
          else ProcReg[length(ProcReg)-1] := Index+1;
          result := i+1;
          end;
     end;
finally if MsgError <> '' then Form1.ErrorComportement(MsgError); end;
end;

function FnctTypeVar(Param : String): String;
var i : integer;
    listParam : Tparam;
    Find : Boolean;
    List : TListView;
    Index : integer;
begin
Form1.GetActiveMacro(List,Index);

result := TNo;
Find := False;

for i := 0 to List.Items.Count -1 do
if List.Items[i].Caption = 'Variable'
then begin
     ListParam := GetParam(List.items.Item[i].SubItems.Strings[0]);
     if ListParam.param[1] = Param
     then begin Find := True; break; end;
     end;
if Find = True then result := ListParam.Param[ListParam.nbr_param-1];

end;

Procedure FnctQuestion(Param : String);
var ListParam : Tparam;
    LastActiveApp : HWND;
begin
LastActiveApp := GetForegroundWindow;
ListParam := GetParam(Param);
Form10.caption := GetValue(ListParam.Param[1]);
Form10.Label1.Caption := GetValue(ListParam.param[2]);

if ListParam.param[3] = ''
then begin
     MessageBox(Form1.Handle,Pchar(GetValue(ListParam.param[2])),Pchar(GetValue(ListParam.param[1])),MB_OK or MB_TOPMOST);
     exit;
     end
else begin Form10.Edit1.Visible := True; Form10.Button1.Caption := 'Valider'; Form10.Button2.Visible := True; end;

if ListParam.param[3] = '[PASSWORD]'
then Form10.Edit1.PasswordChar := '*'
else Form10.Edit1.PasswordChar :=#0;

Form10.Edit1.Text := GetValue(ListParam.param[3]);
Form10.Show;

Unit10.valider := False;
while (Unit10.valider = False)
do Form1.Delay(300);

if ListParam.param[3] <> ''
then Form1.WriteVariable('VAR',ListParam.param[3],Form10.Edit1.Text);
form10.close;
ForceForegroundWindow(LastActiveApp);
end;

Function FnctExamine(Param : String): Boolean;
var ListParam : Tparam;
    Type_var1 : string;
    Type_var2 : string;
    i_var1, i_var2 : integer;
    Str_var1, Str_var2 : String;
    Exist_var1, Exist_var2 : boolean;
begin
i_var1 := 0; i_var2 := 0;

// test l'existance et le type de la variable
exist_var1 := True;
exist_var2 := True;
ListParam := GetParam(Param);
Type_var1 := FnctTypeVar(ListParam.param[1]);
Type_var2 := FnctTypeVar(ListParam.param[3]);

if Type_var1 = TNum
then if FnctIsInteger(GetValue(ListParam.Param[1])) = True
then i_var1 := StrToInt(GetValue(ListParam.Param[1]))
else form1.ErrorComportement('La valeur contenu dans '+ListParam.Param[1]+'n''est pas un numerique valide ['+GetValue(ListParam.Param[1])+']');
if Type_var2 = TNum
then if FnctIsInteger(GetValue(ListParam.Param[3])) = True
then i_var2 := StrToInt(GetValue(ListParam.Param[3]))
else form1.ErrorComportement('La valeur contenu dans '+ListParam.Param[3]+'n''est pas un numerique valide ['+GetValue(ListParam.Param[3])+']');

if Type_var1 = TAlpha then Str_var1 := GetValue(ListParam.Param[1]);
if Type_var2 = TAlpha then Str_var2 := GetValue(ListParam.Param[3]);

if Type_var1 = TNo then exist_var1 := False;
if Type_var2 = TNo then exist_var2 := False;


if exist_var1 = False
then begin
     if Type_var1 = TNo
     then begin
          If FnctIsInteger(ListParam.param[1])
          then begin i_var1 := StrToInt(ListParam.param[1]);
                     Type_var1 := TNum;
               end
          else begin Str_var1 := ListParam.Param[1];
                     Type_var1 := TAlpha;
               end;
          end;
     end;

if exist_var2 = False
then begin
     if Type_var2 = TNo
     then begin
          If FnctIsInteger(ListParam.param[3])
          then begin i_var2 := StrToInt(ListParam.param[3]);
                     Type_var2 := TNum;
               end
          else begin Str_var2 := ListParam.Param[3];
                     Type_var2 := TAlpha;
               end;
          end;
     end;

// traitement de la condition
result := false;
if ((Type_var1 = TNum) and (Type_var2 = TNum))
then begin
     if  ListParam.param[2] = '=' then if i_var1 = i_var2 then result := true;
     if  ListParam.param[2] = '<' then if i_var1 < i_var2 then result := true;
     if  ListParam.param[2] = '>' then if i_var1 > i_var2 then result := true;
     if  ListParam.param[2] = '<>' then if i_var1 <> i_var2 then result := true;
     exit;
     end;

if ((Type_var1 = TAlpha) and (Type_var2 = TAlpha))
then begin
     if  ListParam.param[2] = '=' then if Str_var1 = Str_var2 then result := true;
     if  ListParam.param[2] = '<' then if Str_var1 < Str_var2 then result := true;
     if  ListParam.param[2] = '>' then if Str_var1 > Str_var2 then result := true;
     if  ListParam.param[2] = '<>' then if Str_var1 <> Str_var2 then result := true;
     exit;
     end;

if (Type_var1 = TNum) and (Type_var2 = TAlpha)
then begin
     if FnctIsInteger(Str_var2) = False
     then result := False
     else begin
          if  ListParam.param[2] = '=' then if i_var1 = StrToInt(Str_var2) then result := true;
          if  ListParam.param[2] = '<' then if i_var1 < StrToInt(Str_var2) then result := true;
          if  ListParam.param[2] = '>' then if i_var1 > StrToInt(Str_var2) then result := true;
          if  ListParam.param[2] = '<>' then if i_var1 <> StrToInt(Str_var2) then result := true;
          exit;
          end;
     end;

if ((Type_var1 = TAlpha) and (Type_var2 = TNum))
then begin
     if FnctIsInteger(Str_var1) = False
     then result := False
     else begin
          if  ListParam.param[2] = '=' then if StrToInt(Str_var1) = i_var2 then result := true;
          if  ListParam.param[2] = '<' then if StrToInt(Str_var1) < i_var2 then result := true;
          if  ListParam.param[2] = '>' then if StrToInt(Str_var1) > i_var2 then result := true;
          if  ListParam.param[2] = '<>' then if StrToInt(Str_var1) <> i_var2 then result := true;
          exit;
          end;
     end;

end;

Procedure FnctCalcul(Param : String);
var ListParam : Tparam;
    Int1 : integer;
    Str1 : String;
    Ivar1 : Integer;
begin
int1 := 0;
ListParam := GetParam(Param);
if FnctTypeVar(ListParam.param[1]) = TNum
then begin
     Ivar1 := StrToInt(GetValue(ListParam.param[1]));
     if ListParam.Param[2] = '+' then Int1 := Ivar1 + StrToInt(GetValue(ListParam.param[3]));
     if ListParam.Param[2] = '-' then Int1 := Ivar1 - StrToInt(GetValue(ListParam.param[3]));
     if ListParam.Param[2] = '*' then Int1 := Ivar1 * StrToInt(GetValue(ListParam.param[3]));
     if ListParam.Param[2] = '/'
     then if StrToInt(GetValue(ListParam.param[3])) = 0
          then begin
               Int1 := 0;
               Form1.ErrorComportement('Division par 0 impossible.');
               end
          else Int1 := Ivar1 div StrToInt(GetValue(ListParam.param[3]));

     form1.WriteVariable('VAR',ListParam.Param[1],IntToStr(Int1));
     end;

if FnctTypeVar(ListParam.param[1]) = TAlpha
then begin
     Str1 := '';
     if ListParam.Param[2] = '+'
     then Str1 := GetValue(ListParam.param[1]) + GetValue(ListParam.param[3]);
     Form1.WriteVariable('VAR',ListParam.Param[1],Str1);
     end;
end;

Procedure FnctSysVar(Param : String);
var ListParam : Tparam;
    Val : String;
    chaine : string;
    Pt : Tpoint;
    i : integer;
    fic : TextFile;
    Dim :TRect;
    Wplacement : WindowPlacement;
    p : PChar;
    nbr1, nbr2 : integer;
    param4 : String;
    SearchRec:TSearchRec;
    MyVariant : Variant;
    MyExtended : Extended;
label Affectation;

begin
ListParam := GetParam(Param);
param4 := GetValue(ListParam.param[4]);
chaine := GetValue(ListParam.param[4]);

if (ListParam.Param[2] = 'Texte')
then begin
     if (ListParam.Param[3] = 'Longueur')
     then begin Val := IntToStr(Length(chaine)); goto Affectation; end;

     if (ListParam.Param[3] = 'Caractère(s)/Position(s)')
     then begin
          if FnctIsInteger(GetValue(ListParam.param[5]))
          then nbr1 := StrToInt(GetValue(ListParam.param[5]))
          else begin Form1.ErrorComportement('Le paramètre 5 de la commande Caractère(s)/Position(s) est invalide ['+ListParam.param[5]+'].');Exit;end;
          if FnctIsInteger(GetValue(ListParam.param[6]))
          then nbr2 := StrToInt(GetValue(ListParam.param[6]))-nbr1+1
          else begin Form1.ErrorComportement('Le paramètre 6 de la commande Caractère(s)/Position(s) est invalide ['+ListParam.param[6]+'].');Exit;end;
          Val := Copy(GetValue(ListParam.param[4]),nbr1,nbr2);
          goto Affectation;
          end;

     if (ListParam.Param[3] = 'Majuscule')
     then begin Val := UpperCase(GetValue(Param4)); goto Affectation; end;
     if (ListParam.Param[3] = 'Minuscule')
     then begin Val := LowerCase(GetValue(Param4)); goto Affectation; end;
     if (ListParam.Param[3] = 'Remplace')
     then begin Val := StringReplace(GetValue(ListParam.param[1]),GetValue(Param4),GetValue(ListParam.param[5]),[rfReplaceAll, rfIgnoreCase]); goto Affectation; end;
     if (ListParam.Param[3] = 'Trouver')
     then begin Val := IntToStr(Pos(GetValue(ListParam.param[5]),GetValue(Param4))); goto Affectation; end;
     end;

if ((ListParam.Param[2] = 'Clipboard') and (ListParam.Param[3] = 'Texte'))
then val := ClipBoard.AsText;

if (ListParam.Param[2] = 'Date')
then begin
     nbr1 := 0;
     if param4 <> ''
     then begin
          if FnctIsInteger(param4)
          then nbr1 := StrToInt(param4)
          else begin
               Form1.ErrorComportement('Le paramètre de décalage de jour ne pas une valeur numérique. ['+param4+']');
               Exit;
               end;
          end;

     if ListParam.Param[3] = 'JJ/MM/AAAA'
     then begin val := FormatDateTime( 'dd/mm/yyyy',Now + nbr1); goto Affectation; end;
     if ListParam.Param[3] = 'JJMMAAAA'
     then begin val := FormatDateTime( 'ddmmyyyy',Now + nbr1); goto Affectation; end;
     if ListParam.Param[3] = 'AAAAMMJJ'
     then begin val := FormatDateTime( 'yyyymmdd',Now + nbr1); goto Affectation; end;

     if (ListParam.Param[3] = 'Jour') or (ListParam.Param[3] = 'Mois') or (ListParam.Param[3] = 'Année')
     then begin Val := Decompose_Date(Now + nbr1,ListParam.Param[3]); goto Affectation; end;
     end;

if (ListParam.Param[2] = 'Heure')
then begin
     if (ListParam.Param[3] = 'Heure') or (ListParam.Param[3] = 'Minute') or (ListParam.Param[3] = 'Seconde')
     then begin Val := Decompose_Date(Now,ListParam.Param[3]); goto Affectation; end;

     if ListParam.Param[3] = 'HH:MM:SS'
     then begin Val := FormatDateTime( 'hh:mm:ss',Now); goto Affectation; end;

     if ListParam.Param[3] = 'HHMMSS'
     then begin
          DateSeparator := '/';
          Val := Decompose_Date(Now,'Heure')+
                 Decompose_Date(Now,'Minute') +
                 Decompose_Date(Now,'Seconde');
          goto Affectation;
          end;
     end;

if ListParam.Param[3] = 'Position X'
then begin
     GetCursorPos(Pt);
     Val := IntToStr(Pt.x);
     goto Affectation;
     end;
if ListParam.Param[3] = 'Position Y'
then begin
     GetCursorPos(Pt);
     Val := IntToStr(Pt.y);
     goto Affectation;
     end;

if (ListParam.Param[2] = 'Handle')
then begin
     if FnctIsInteger(Param4) =False
     then begin Form1.ErrorComportement('Numéro de handle invalide.'); Exit; end;
     if (ListParam.Param[3] = 'Texte')
     then begin Val := GetText(StrToint(Param4)); goto Affectation; end;
     if (ListParam.Param[3] = 'Longueur')
     then begin
          GetWindowRect(StrToint(Param4),Dim);
          pt.x := Dim.Right - Dim.Left;
          Val := IntToStr(Pt.x);
          goto Affectation;
          end;
     if(ListParam.Param[3] = 'Largeur')
     then begin
          GetWindowRect(StrToint(Param4),Dim);
          pt.y := Dim.Bottom - Dim.Top;
          Val := IntToStr(Pt.y);
          goto Affectation;
          end;
     if(ListParam.Param[3] = 'Position X')
     then begin
          GetWindowRect(StrToint(Param4),Dim);
          Val := IntToStr(Dim.Left);
          goto Affectation;
          end;
     if(ListParam.Param[3] = 'Position Y')
     then begin
          GetWindowRect(StrToint(Param4),Dim);
          Val := IntToStr(Dim.Top);
          goto Affectation;
          end;
     if (ListParam.Param[3] = 'Etat')
     then begin
          GetWindowPlacement(StrToint(Param4),@Wplacement);
          case Uint(Wplacement.showCmd) of
               SW_Hide : chaine := '';
               SW_NORMAL : chaine := 'Normal';
               SW_SHOWMINIMIZED : chaine := 'Réduit';
               SW_SHOWMAXIMIZED : chaine := 'Agrandi';
               SW_SHOWNOACTIVATE : chaine := '';
               SW_SHOW : chaine := '';
               SW_MINIMIZE : chaine := '';
               SW_SHOWMINNOACTIVE : chaine := '';
               SW_SHOWNA : chaine := '';
               SW_RESTORE : chaine := '';
               SW_SHOWDEFAULT : chaine := '';
          end;
          if isWindowVisible(StrToInt(Param4)) = False
          then chaine := 'Indéterminé';
          Val := chaine;
          goto Affectation;
          end;
     end;

if (ListParam.Param[2] = 'Hasard')
then begin
     if (ListParam.Param[3] = 'Nombre')
     then begin
          if FnctIsInteger(Param4) = True
          then Val := IntToStr(random(StrToInt(Param4)))
          else Val := '0';
          goto Affectation;
          end;

     if (ListParam.Param[3] = 'Lettre')
     then begin Val := chr(random(25)+65); goto Affectation; end;
     end;

if (ListParam.Param[2] = 'Fichier')
then begin
     if (ListParam.Param[3] = 'Nombre d''enregistrement')
     then begin
          i := 0;
          chaine := GetValue(ListParam.Param[4]);
          assignfile(fic,chaine);
          if FileExists(chaine)
          then begin
                {$I-} reset(fic); {$I+} if IOResult <> 0 then begin Form1.ErrorComportement('Impossible d''accéder au fichier nommé '+ chaine+'.');Exit;end;
                while not eof(fic)
                do begin
                   Inc(i);
                   readln(fic);
                   end;
                closefile(fic);
               end
          else i := 0;
          Val := IntToStr(i);
          goto Affectation;
          end;

        if (ListParam.Param[3] = 'Existe')
        then begin
             if FileExists(GetValue(ListParam.Param[4]))
             then Val := 'oui' else Val := 'non';
             goto Affectation;
             end;

        if (ListParam.Param[3] = 'Taille octets')
        then begin
             {val := '0';
             val :=IntToStr(FindFirst(GetValue(ListParam.Param[4]), FaAnyFile, SearchRec));
             if val= '0' then Val := IntToStr(SearchRec.Size);
             FindClose(SearchRec);}
               if FindFirst(GetValue(ListParam.Param[4]),faAnyFile,SearchRec)=0
               then try
                    Val := IntToStr(Int64(SearchRec.FindData.nFileSizeHigh) shl 32 + SearchRec.FindData.nFileSizeLow);
                    finally FindClose(SearchRec); end
               else Val := '0';
             goto Affectation;
             end;

        if (ListParam.Param[3] = 'Extrait nom de fichier')
        then begin Val := ExtractFileName(GetValue(ListParam.Param[4])); goto Affectation; end;
        if (ListParam.Param[3] = 'Extrait répertoire')
        then begin val := ExtractFileDir(GetValue(ListParam.Param[4])); goto Affectation; end;
        if (ListParam.Param[3] = 'Extrait extention')
        then begin val := ExtractFileExt(GetValue(ListParam.Param[4])); goto Affectation; end;

        if (ListParam.Param[3] = 'Date Création Fichier')
        then if  FnctTypeVar(ListParam.Param[1]) = TAlpha
             then Val := DateTimeToStr(TimeCreationFichier(GetValue(ListParam.Param[4])))
             else Val := FloatToStr(TimeCreationFichier(GetValue(ListParam.Param[4])));

        if (ListParam.Param[3] = 'Date Modification Fichier')
        then if  FnctTypeVar(ListParam.Param[1]) = TAlpha
             then Val := DateTimeToStr(TimeModificationFichier(GetValue(ListParam.Param[4])))
             else Val := FloatToStr(TimeModificationFichier(GetValue(ListParam.Param[4])));

        if (ListParam.Param[3] = 'Date Accès Fichier')
        then if  FnctTypeVar(ListParam.Param[1]) = TAlpha
             then Val := DateTimeToStr(TimeAccesFichier(GetValue(ListParam.Param[4])))
             else Val := FloatToStr(TimeAccesFichier(GetValue(ListParam.Param[4])));

        i := FileGetAttr(GetValue(ListParam.Param[4]));

        if (ListParam.Param[3] = 'en lecture seule?')
        then begin if (i and faReadOnly) = faReadOnly then Val := 'oui' else Val := 'non'; end;

        if (ListParam.Param[3] = 'caché?')
        then begin if (i and faHidden) = faHidden then Val := 'oui' else Val := 'non'; end;

        if (ListParam.Param[3] = 'système?')
        then begin if (i and faSysFile) = faSysFile then Val := 'oui' else Val := 'non'; end;

        if (ListParam.Param[3] = 'd''identification de volume?')
        then begin if (i and faVolumeID) = faVolumeID then Val := 'oui' else Val := 'non'; end;

        if (ListParam.Param[3] = 'répertoire?')
        then begin if (i and faDirectory) = faDirectory then Val := 'oui' else Val := 'non'; end;

        if (ListParam.Param[3] = 'archive?')
        then begin if (i and faArchive) = faArchive then Val := 'oui' else Val := 'non'; end;

        goto Affectation;
    end;

if ListParam.Param[2] = 'Répertoire système'
then begin
     p := AllocMem(0); // Allocation mémoire
     if ListParam.Param[3] ='Rep Maison'
     then begin
          i := GetEnvironmentVariable('USERPROFILE',p,0);
          ReAllocMem(P,i);
          GetEnvironmentVariable('USERPROFILE',P,i);
          goto Affectation;
          end;
     if ListParam.Param[3] ='Rep Fichier prog'
     then begin
          i := GetEnvironmentVariable('ProgramFiles',P,0);
          ReAllocMem(P,i);
          GetEnvironmentVariable('ProgramFiles',P,i);
          goto Affectation;
          end;
     if ListParam.Param[3] ='Rep Temporaire'
     then begin
          i := GetEnvironmentVariable('TEMP',P,0);
          ReAllocMem(P,i);
          GetEnvironmentVariable('TEMP',P,i);
          goto Affectation;
          end;
     if ListParam.Param[3] ='Rep Windows'
     then begin
          i := GetEnvironmentVariable('windir',P,0);
          ReAllocMem(P,i);
          GetEnvironmentVariable('windir',P,i);
          goto Affectation;
          end;
     if ListParam.Param[3] ='Rep Super Macro'
     then begin P := PChar(ExtractFilePath(application.ExeName)); goto Affectation; end;

     if ListParam.Param[3] ='Rep Fichier Macro'
     then begin
          if unit1.ALIAS_EXE = ''
          then P := PChar(ExtractFilePath(Form1.StatusBar1.Panels[0].Text))
          else P := PChar(ExtractFilePath(unit1.ALIAS_EXE));
          goto Affectation;
          end;

     Val := String(P);
     end;

if (ListParam.Param[2] = 'Ecran')
then begin
     if (ListParam.Param[3] = 'Longueur')
     then Val := IntToStr(screen.Width);
     if (ListParam.Param[3] = 'Largeur')
     then Val := IntToStr(screen.Height);
     goto Affectation;
     end;

if (ListParam.Param[2] = 'Nombre')
then begin
     if FnctIsInteger(GetValue(ListParam.Param[1])) or FnctIsFloat(GetValue(ListParam.Param[1]))
     then begin
          MyVariant := GetValue(ListParam.Param[1]);
          MyExtended := MyVariant;
          if (ListParam.Param[3] = 'Abs')
          then begin val := FloatToStr(abs(MyExtended)); goto Affectation; end;
          if (ListParam.Param[3] = 'Cos')
          then begin val := FloatToStr(cos(MyExtended)); goto Affectation; end;
          if (ListParam.Param[3] = 'Cotang')
          then begin val := FloatToStr(cotan(MyExtended));goto Affectation; end;
          if (ListParam.Param[3] = 'Tang')
          then begin val := FloatToStr(Tan(MyExtended)); goto Affectation; end;
          if (ListParam.Param[3] = 'Tronc')
          then begin val := FloatToStr(Trunc(MyExtended)); goto Affectation; end;
          if (ListParam.Param[3] = 'Sin')
          then begin val := FloatToStr(sin(MyExtended)); goto Affectation; end;
          if (ListParam.Param[3] = 'Décimales')
          then begin
               chaine := '0'+ DecimalSeparator;
               if FnctIsInteger(GetValue(ListParam.Param[4]))
               then begin
                    for i := 1 to StrToInt(GetValue(ListParam.Param[4]))
                    do chaine := chaine + '0';
                    end
               else chaine := '0'+ DecimalSeparator + '00';
               val := FormatFloat(chaine,MyExtended);
               goto Affectation;
               end;
          if (ListParam.Param[3] = 'Monétaire')
          then begin
               chaine := '0'+ DecimalSeparator + '00';
               val := FormatFloat(chaine,MyExtended);
               goto Affectation;
               end;
     end
     else begin
          form1.ErrorComportement('[Ligne :'+InttoStr(Pos_command+1)+']- Fonction Nombre impossible à exécuter,car la valeur n''est pas numérique.');
          Exit;
          end;
     end;

if (ListParam.Param[2] = 'Paramètre d''exécution')
then begin
     if (ListParam.Param[3] = 'Paramètre n°')
     then begin
          if FnctIsInteger(Param4) = True
          then Val := ParamStr(StrToInt(Param4))
          else begin Val := ''; Form1.ErrorComportement('Numéro du paramètre d''exécution invalide.'); Exit; end;
          goto Affectation;
          end;

     if (ListParam.Param[3] = 'Nombre de paramètre')
     then begin Val := IntToStr(ParamCount); goto Affectation; end;
     end;
Exit;

Affectation: Form1.WriteVariable('VAR',ListParam.param[1],Val);

end;

Procedure FnctRead(Param : String);
var ListParam : Tparam;
    fic : TextFile;
    valeur,FileName : String;
    i,index, position : integer;
    ouvert : boolean;
begin
i := 0;
index := 0;
valeur := '';

ListParam := GetParam(Param);
FileName := GetValue(ListParam.Param[1]);

if not FileExists(FileName)
then begin Form1.ErrorComportement('Nom de Fichier invalide ('+FileName+').'); Exit; end;

if ListParam.param[2] = '[CLIPBOARD]'
then if CplBrd.OpenToCplFile(FileName) = True then Exit;

if FnctIsInteger(ListParam.Param[3])
then position := Strtoint(ListParam.Param[3])
else begin
     if FnctIsInteger(GetValue(ListParam.Param[3]))
     then position := Strtoint(GetValue(ListParam.Param[3]))
     else begin
          Form1.ErrorComportement('La variable '+ListParam.Param[3]+' ne contient pas une valeur numérique entière('+GetValue(ListParam.Param[3])+').');
          Exit;
          end;
     end;

if position > 0
then begin
     assignfile(fic,FileName);
     {$I-} reset(fic);{$I+} if IOResult<>0 then begin Form1.ErrorComportement('Impossible d''accéder au fichier nommé '+ FileName+'.');Exit;end;
     while ((not eof(fic)) and (i < position)) do
     begin
          Inc(i);
          readln(fic,valeur);
     end;
     closefile(fic);
     end
else begin
     Ouvert := False;
     for i := 0 to length(ListFile.Name)-1
     do if ListFile.Name[i] = FileName
        then begin
             Ouvert := True;
             index := i;
             break;
             end;

     if Ouvert = False
     then begin
          index := Length(ListFile.Name);
          SetLength(ListFile.Name, index+1);
          SetLength(ListFile.memFile, index+1);
          SetLength(ListFile.Index, index+1);
          ListFile.Name[index] := FileName;
          if GetTypeOfTextfile(FileName) <> txAnsiOrByte
          then begin Form1.ErrorComportement('Fichier ASCII non reconnu.'); Exit; end;
          assignfile(ListFile.memFile[index],FileName);
          reset(ListFile.memFile[index]);
          ListFile.Index[index] := 0;
          end;
     if not eof(ListFile.memFile[index])
     then begin readln(ListFile.memFile[index],valeur); Inc(ListFile.Index[index]) end
     else valeur := '';
     end;

Form1.WriteVariable('VAR',ListParam.param[2],valeur);

end;

Procedure FnctWrite(Param : String);
var ListParam : Tparam;
    fic :TextFile;
    DirOk : Boolean;
    FileName : String;
    MemFileText : TStringList;
    Pos,i : integer;
begin
ListParam := GetParam(Param);
FileName := GetValue(ListParam.Param[1]);

if not FileNameValide(FileName)
then begin Form1.ErrorComportement('Nom de Fichier invalide ('+FileName+').'); Exit; end;


DirOk := True;
if not DirectoryExists(ExtractFileDir(FileName))
then DirOk := ForceDirectories(ExtractFileDir(FileName));

if not DirOk
then begin Form1.ErrorComportement('Impossible de créer le répertoire ('+FileName+').'); Exit; end;

if ListParam.param[2] = '[CLIPBOARD]'
then if CplBrd.SaveToCplFile(FileName) = True then Exit;


if ListParam.Param[3] = ''
then begin
     assignfile(fic,FileName);
     try
     if not fileExists(FileName)
     then begin
          rewrite(fic);
          closefile(fic);
          end;
     Append(fic);
     Writeln(fic,GetValue(ListParam.Param[2]));
     Flush(fic);
     finally CloseFile(fic); end;
     end
else begin
     MemFileText := TStringList.Create;
     try
     if not FileExists(FileName)
     then begin
          assignfile(fic,FileName);
          rewrite(fic);
          closefile(fic);
          end;
     MemFileText.LoadFromFile(FileName);
     Pos := 0;
     if FnctIsInteger(GetValue(ListParam.Param[3]))
     then Pos := StrToInt(GetValue(ListParam.Param[3]))
     else Form1.ErrorComportement('Position d''écriture invalide.');
     if Pos > MemFileText.Count-1
     then for i := MemFileText.Count+1 to Pos
     do MemFileText.Add('');
     MemFileText.Strings[Pos-1] := GetValue(ListParam.Param[2]);
     MemFileText.SaveToFile(FileName);
     finally MemFileText.Free; end;
     end;

end;

Procedure FnctManip(Param : String);
var ListParam : Tparam;
    Handle : Hwnd;
    Dim : Trect;
    pt : Tpoint;
    Texte : String;
    Wplacement : WindowPlacement;
begin
ListParam := GetParam(Param);
if not FnctIsInteger(GetValue(ListParam.Param[1])) then begin Form1.ErrorComportement('Numéro de handle invalide.'); Exit; end;
Handle := StrToInt(GetValue(ListParam.Param[1]));
if isWindowvisible(Handle) = False then Exit;

if ListParam.Param[2] = 'Déplacement souris'
then begin
     GetWindowRect(handle, Dim);
     Pt.x := Dim.Left + 5;
     Pt.y := Dim.Top + 5;
     SetCursorPos(Pt.x,Pt.y);
     end;
if ListParam.Param[2] = 'Changement texte'
then begin
     Texte := GetValue(ListParam.Param[3]);
     SendMessage(handle, WM_SetText, 0, Integer(Pchar(Texte)));
     end;
if ListParam.Param[2] = 'Réduire'
then begin
     repeat
     enablewindow(handle, false);
     ShowWindow(handle, SW_SHOWMINIMIZED);
     enablewindow(handle, True);
     application.ProcessMessages;
     GetWindowPlacement(handle,@Wplacement);
     until Uint(Wplacement.showCmd) = SW_SHOWMINIMIZED;
     end;
if ListParam.Param[2] = 'Restaurer'
then begin
     repeat
     enablewindow(handle, false);
     ShowWindow(handle, SW_SHOWNORMAL);
     enablewindow(handle, True);
     ForceForegroundWindow(handle);
     until SetForegroundWindow(handle) = True;
     end;
if ListParam.Param[2] = 'Agrandir'
then begin
     repeat
     enablewindow(handle, false);
     ShowWindow(handle, SW_SHOWMAXIMIZED);
     enablewindow(handle, True);
     ForceForegroundWindow(handle);
     until SetForegroundWindow(handle) = True;
     end;
if ListParam.Param[2] = 'Fermer'
then begin
     PostMessage(Handle, WM_CLOSE, 0, 0);
     end;
if ListParam.Param[2] = 'Taille'
then begin
     GetWindowRect(handle, Dim);
     moveWindow(handle,Dim.Left,
                       Dim.Top,
                       StrToInt(GetValue(ListParam.Param[3])),
                       StrToInt(GetValue(ListParam.Param[4])),
                       True);
    end;
if ListParam.Param[2] = 'Déplacer'
then begin
     GetWindowRect(handle, Dim);
     moveWindow(handle,StrToInt(GetValue(ListParam.Param[3])),
                       StrToInt(GetValue(ListParam.Param[4])),
                       Dim.Right-Dim.Left,
                       Dim.Bottom-Dim.Top,
                       True);
    end;
end;


procedure FnctShell(Param : String);
var ListParam : Tparam;
    EditSource,EditCible : String;
    FileOpStruct: TSHFileOpStruct;
    RetourVal : boolean;
    i : integer;
begin
RetourVal := True;
ListParam := GetParam(Param);
EditSource := GetValue(ListParam.param[2]);
EditCible := GetValue(ListParam.param[3]);

if (FileNameValide(EditSource) = True) and ((ListParam.param[1] = 'Copier') or (ListParam.param[1] = 'Déplacer') or (ListParam.param[1] = 'Renommer'))
then begin
     if not DirectoryExists(ExtractFileDir(EditCible)) then ForceDirectories(ExtractFileDir(EditCible));
     if FileExists(EditSource)
     then begin

          if ListParam.param[1] = 'Copier' then RetourVal := CopyFile(PChar(EditSource),PChar(EditCible),False);
          if ListParam.param[1] = 'Renommer' then RetourVal := RenameFile(PChar(EditSource),PChar(EditCible));
          if ListParam.param[1] = 'Déplacer'
          then begin
               if EditCible[length(EditCible)] <> '\'
               then EditCible := EditCible + '\';
               EditCible := EditCible +ExtractFileName(EditSource);
               if FileExists(EditCible) then DeleteFile(PChar(EditCible));
               RetourVal := MoveFile(PChar(EditSource),PChar(EditCible));
               end;

          if RetourVal = False then Form1.ErrorComportement(SysErrorMessage(GetLastError));
          end;
     end;

EditSource := GetValue(ListParam.param[2]);
EditCible := GetValue(ListParam.param[3]);

if ListParam.param[1] = 'Effacer'
then begin
          for i := 0 to length(ListFile.memFile)-1
          do
          if ListFile.Name[i] = EditSource // ferme le fichier ouvert avant de le supprimer
          then begin
               ListFile.Name[i] := '';
               ListFile.Index[i] := 0;
               CloseFile(ListFile.memFile[i]);
               end;

          ZeroMemory(@FileOpStruct, SizeOf(FileOpStruct));
          if ListParam.param[3] = 'Non'
          then FileOpStruct.fFlags:= FOF_NOCONFIRMATION or FOF_NOERRORUI
          else FileOpStruct.fFlags:= FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_NOERRORUI;

          FileOpStruct.Wnd := 0;
          FileOpStruct.wFunc:=FO_DELETE;
          FileOpStruct.pFrom:=PChar(EditSource+ #0);
          FileOpStruct.pTo := nil;
          FileOpStruct.hNameMappings := nil;
          FileOpStruct.lpszProgressTitle := nil;
          FileOpStruct.fAnyOperationsAborted := True;
          if (0 <> SHFileOperation(FileOpStruct)) and (FileExists(EditSource)= True) then Form1.ErrorComportement('Fichier ou répertoire impossible à effacer');
     end;

if ListParam.param[1] = 'Rechercher'
then begin
     if FileNameValide(GetValue(ListParam.Param[4]))
     then ScruteDossier(0,GetValue(ListParam.Param[2]),GetValue(ListParam.Param[3]),faAnyFile,True,GetValue(ListParam.Param[4]));
     end;
end;

procedure FnctCapture(Param : String);
var  ImageJPEG : TJPEGImage;
     ImageBureau:TPicture;
     ListParam : Tparam;
     HandleDCBureau : HDC;
begin
Application.ProcessMessages;
ListParam := GetParam(Param);
if not DirectoryExists(ExtractFileDir(GetValue(ListParam.param[2]))) then ForceDirectories(ExtractFileDir(GetValue(ListParam.param[2])));
if FileNameValide(GetValue(ListParam.param[2])) = True
then begin
     ImageBureau := TPicture.Create;
     ImageBureau.Bitmap.Width := Screen.Width;
     ImageBureau.Bitmap.Height := Screen.Height;
     HandleDCBureau:=GetDC(GetDesktopWindow);
     BitBlt(ImageBureau.Bitmap.Canvas.Handle,0,0,Screen.Width,Screen.Height,HandleDCBureau,0,0,SrcCopy);
     if ListParam.param[1] = 'Copier vers jpg'
     then begin
          ImageJPEG := TJPEGImage.Create;
          try
             //ImageJPEG.CompressionQuality:= TrackBar1.Position;
             ImageJPEG.Assign(ImageBureau.Bitmap);
             ImageJPEG.SaveToFile(GetValue(ListParam.param[2]));
          finally
          ImageJPEG.Free;
          end;
     end
     else ImageBureau.Bitmap.SaveToFile(GetValue(ListParam.param[2]));
     ImageBureau.Free;
     ReleaseDC(GetDesktopWindow,HandleDCBureau);
     end;
end;

procedure FnctChangeRes(Param : String);
var ListParam : Tparam;
    i : integer;
    bits : string;
begin
  ListParam := GetParam(Param);
  if ListParam.param[1] = 'Résolution'
  then begin
       bits := '';
       for i := 1 to length(ListParam.param[4]) do
       if ListParam.param[4][i] in ['0'..'9'] then bits := bits + ListParam.param[4][i] else break;
       if FnctIsInteger(bits)
       then Form19.ChangeResolEcran(StrToInt(ListParam.param[2]),StrToInt(ListParam.param[3]),StrToInt(bits),True);
       end;
  if ListParam.param[1] = 'Fréquence'
  then begin
       Form19.ChangeFreqEcran(StrToInt(ListParam.param[2]),True);
       end;
end;

procedure FnctAlimentation(Param : String);
var sTokenIn,sTokenOut : TTOKENPRIVILEGES ;
    dwLen : DWORD ;
    hCurrentProcess,hToken : THANDLE ;
    Luid1 : TLargeInteger ;  // LUID ;
    ListParam : Tparam;
begin
  ListParam := GetParam(Param);
  // Handle du process en cours
  hCurrentProcess := GetCurrentProcess ;
  OpenProcessToken (hCurrentProcess,TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, hToken);
  // valeur du privilege SHUTDOWN
  LookupPrivilegeValue(nil,'SeShutdownPrivilege',Luid1) ;
  sTokenIn.PrivilegeCount := 1;
  sTokenIn.Privileges[0].Luid := Luid1;
  sTokenIn.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
  // Ajustement du privilege avec les nouvelles valeurs
  AdjustTokenPrivileges ( hToken, FALSE, sTokenIn,sizeof(TTOKENPRIVILEGES),sTokenOut, dwLen);
  CloseHandle (hToken);

  if ListParam.param[1] = 'Eteindre'          then begin form1.Enregistrer1.Click; ExitWindowsEx(EWX_SHUTDOWN {or EWX_FORCE}, 0); end;
  if ListParam.param[1] = 'Redémarrer'        then begin form1.Enregistrer1.Click; ExitWindowsEx(EWX_REBOOT {or EWX_FORCE}, 0);  end;
  if ListParam.param[1] = 'Fermer la session' then begin form1.Enregistrer1.Click; ExitWindowsEx(EWX_LOGOFF {or EWX_FORCE}, 0); end;

  if ListParam.param[1] = 'Mise en veille'    then if ListParam.param[2] = 'Oui' then NT9XSetPowerState(False,True) else NT9XSetPowerState(True,True);
end;

procedure FnctRepertoire(Param : String);
var ListParam : Tparam;
    PathName : String;
begin
ListParam := GetParam(Param);
PathName := GetValue(ListParam.Param[2]);

if ListParam.Param[1] = 'Créer'
then begin
     if not DirectoryExists(PathName)
     then ForceDirectories(PathName);
     end;

if ListParam.Param[1] = 'Supprimer'
then begin
     if DirectoryExists(PathName)
     then FnctShell('Effacer'+ SprPr +  PathName + SprPr +'Oui'+SprPr); // effacer et placer dans la poubelle
     end;

end;

procedure FnctField(Param : String);
var ListParam : Tparam;
    mode : String;
    i,j : integer;
    bloc, x1, x2 : array[1..6] of integer;
    field, resultat : array[1..6] of string;
    Enr : String;
    car : array[1..5] of char;
    block : integer;
    NewBlock, splCar : boolean;
    Booleanblocx1 : array[1..6]of Boolean;
begin
ListParam := GetParam(Param);
Enr := GetValue(ListParam.Param[1]);
if Enr = '' then begin
                 if  field[1] <> '' then Form1.WriteVariable('VAR',field[1],'');
                 if  field[2] <> '' then Form1.WriteVariable('VAR',field[2],'');
                 if  field[3] <> '' then Form1.WriteVariable('VAR',field[3],'');
                 if  field[4] <> '' then Form1.WriteVariable('VAR',field[4],'');
                 if  field[5] <> '' then Form1.WriteVariable('VAR',field[5],'');
                 if  field[6] <> '' then Form1.WriteVariable('VAR',field[6],'');
                 Exit;
                 end;
Mode := ListParam.Param[2];

if mode = 'F'
then begin
     for i := 3 to 20 do
     case i of
     3,6,9 ,12,15,18 : field[i div 3] := ListParam.Param[i];
     4,7,10,13,16,19 : if FnctIsInteger(ListParam.Param[i]) then x1[(i-1) div 3] := StrToInt(ListParam.Param[i]);
     5,8,11,14,17,20 : if FnctIsInteger(ListParam.Param[i]) then x2[(i-2) div 3] := StrToInt(ListParam.Param[i]);
     end;
     end
else begin
     if ListParam.param[3] <> '' then Car[1] := chr(vk_tab) else Car[1] := chr(0);
     if ListParam.param[4] <> '' then Car[2] := chr(vk_space) else Car[2] := chr(0);
     if ListParam.param[5] <> '' then Car[3] := ';' else Car[3] := chr(0);
     if ListParam.param[6] <> '' then Car[4] := ',' else Car[4] := chr(0);
     if ListParam.param[7] <> '' then Car[5] := ListParam.param[7][1] else Car[5] := chr(0);
     for i := 8 to 19 do
     case i of
     8,10,12,14,16,18 : field[(i-6) div 2] := ListParam.Param[i];
     9,11,13,15,17,19 : if FnctIsInteger(ListParam.Param[i]) then bloc[(i-7) div 2] := StrToInt(ListParam.Param[i]);
     end;
     block := 1;
     NewBlock := False;
     for i := 1 to 6 do Booleanblocx1[i] := False;
     if (Enr[1] <> car[1]) and (Enr[1] <> car[2]) and  (Enr[1] <> car[3]) and (Enr[1] <> car[4]) and (Enr[1] <> car[5])
     then SplCar := False else SplCar := True;

     for i := 1 to length(Enr)
     do begin

        if (SplCar = True) and (Enr[i] <> car[1]) and (Enr[i] <> car[2]) and  (Enr[i] <> car[3]) and (Enr[i] <> car[4]) and (Enr[i] <> car[5])
        then begin SplCar := False; NewBlock := True; end;
        if (SplCar = False) and ((Enr[i] = car[1]) or (Enr[i] = car[2]) or  (Enr[i] = car[3]) or (Enr[i] = car[4]) or (Enr[i] = car[5]))
        then begin SplCar := True; NewBlock := True; end;

        if NewBlock = True then begin NewBlock := False; Inc(Block); end;

        for j := 1 to 6
        do begin
           if (Booleanblocx1[j] = False) and (bloc[j] = block) then begin Booleanblocx1[j] := True; x1[j] := i; end;
           if bloc[j] = block then  x2[j] := i;
           end;
        end;
     end;
// traitement commun
for i := 1 to length(Enr)
     do begin
        if (x1[1] <= i) and (x2[1] >= i) then resultat[1] := resultat[1] + Enr[i];
        if (x1[2] <= i) and (x2[2] >= i) then resultat[2] := resultat[2] + Enr[i];
        if (x1[3] <= i) and (x2[3] >= i) then resultat[3] := resultat[3] + Enr[i];
        if (x1[4] <= i) and (x2[4] >= i) then resultat[4] := resultat[4] + Enr[i];
        if (x1[5] <= i) and (x2[5] >= i) then resultat[5] := resultat[5] + Enr[i];
        if (x1[6] <= i) and (x2[6] >= i) then resultat[6] := resultat[6] + Enr[i];
        end;

if  field[1] <> '' then Form1.WriteVariable('VAR',field[1],resultat[1]);
if  field[2] <> '' then Form1.WriteVariable('VAR',field[2],resultat[2]);
if  field[3] <> '' then Form1.WriteVariable('VAR',field[3],resultat[3]);
if  field[4] <> '' then Form1.WriteVariable('VAR',field[4],resultat[4]);
if  field[5] <> '' then Form1.WriteVariable('VAR',field[5],resultat[5]);
if  field[6] <> '' then Form1.WriteVariable('VAR',field[6],resultat[6]);
end;

procedure FnctCalculEvol(Param : String);
begin
form24.TestCalculEvol(Param, True);
end;

procedure FnctMouvement(Param : String);
var i : integer;
    x,y : string;
    First, Second : Boolean;
begin
x := ''; y := '';
First := True;
Second := True;

for i :=1 to length(Param)
do begin
   if (Param[i] <> SprPr)
   then begin
        if First = True then x := x + Param[i]
        else y := y + Param[i];
        end
   else begin
        if First = True
        then First := False
        else Second := False;
        end;
   if not(First) and not(Second)
   then begin
        FnctMoveMouse(x+SprPr+y+SprPr+'Indirect'+SprPr);
        SleepEX(10,False);
        Application.ProcessMessages;
        x := ''; y := '';
        First := True;
        Second := True;
        end;
   end;

end;

end.
