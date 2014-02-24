unit Debug;
interface

uses Consts, SysConst, Forms, Controls,windows,ShellApi,SysUtils,IniFiles,classes,
     Messages, StdCtrls, ComCtrls, ExtCtrls, TLHelp32, mdlfnct,GestionCommande,
     Buttons, StrUtils,
     unit1, unit4, unit7, unit8, unit10, unit17, unit19, unit20, unit25;

     type TstructParam = record
     value : String;
     BStr : boolean;
     BNum : boolean;
     BVarStr : boolean;
     BVarNum : boolean;
     BObject : boolean;
     BEnum : boolean;
     BLimite : boolean;
     Enum : array of string;
     Limite : array[1..2] of Int64;
     CanEmpty : Boolean;
     end;

type TstructOrdre = class
     Name : String;
     NbrParam: integer;
     Pos : integer;
     items : array of TstructParam;
     count : integer;
     constructor Create;
     function Add() : integer;
     function CheckAll(List : TListView; ParentPos : integer = 0) : Boolean;
     procedure IntoEnum(A :array of string; index : integer);
     end;

var StopAllDebug : Boolean = False;
    ErrorCount : word = 0;

Function Control(List : TListView; Commande, Parametre : String ;Pos : Integer;  ParentPos : integer = 0): Boolean;
Procedure WriteMessage(List : TListView; Pos : integer; MsgType, Msg : String; ParentPos : integer = 0);

Function DebugType(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugTypeSpl(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugMoveMouse(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugExecute(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugPause(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugGoto(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugLabel(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugLire(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugEcrire(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugQuestion(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugClick(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugExamine(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugCalcul(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugOutilAffichage(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugOutilAlimentation(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugOutilFichier(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugOutilRepertoire(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugOutilEcran(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugFields(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugVariable(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugVariableSystem(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugNewOrder(List : TListView; Commande, parametre : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugCalculEvol(List : TListView; parametre : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugObjet(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugProcedure(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugScriptEval(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
Function DebugInclusion(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;

Function VarReadOnly(Name : String): Boolean;
implementation

constructor TstructOrdre.Create;
begin
  Name := '';
  count := 0;
  NbrParam := 0;
end;

function TstructOrdre.Add() : integer;
begin
Inc(count);
result :=  count;
Setlength(Items,count);
Items[count-1].value := '';
Items[count-1].BNum := False;
Items[count-1].BVarStr := False;
Items[count-1].BVarNum := False;
Items[count-1].BObject := False;
Items[count-1].BEnum := False;
Items[count-1].BLimite := False;
Items[count-1].CanEmpty := False;
SetLength(Items[count-1].Enum,0);
end;

function TstructOrdre.CheckAll(List : TListView; ParentPos : integer = 0) : Boolean;
var msg : string;
    i,j : integer;
    Ok : boolean;
    ListParam : TParam;
    TempList: TStrings;
begin
result := True;
for i := 0 to count -1
do begin
   Ok := False;
   if items[i].BStr or items[i].BNum or items[i].BVarStr or items[i].BVarNum or items[i].BObject or
   items[i].BLimite or items[i].BEnum = False
   then continue;
   if (items[i].CanEmpty = True) and (items[i].value = '') then Ok := True;
   if (items[i].BStr = True) and (mdlfnct.FnctIsInteger(items[i].value) = False) then Ok := True;
   if (items[i].BNum = True) and (mdlfnct.FnctIsInteger(items[i].value) = True) then Ok := True;
   if (items[i].BVarNum = True) and (FnctTypeVar(items[i].Value) = TNum) then Ok := True;
   if (items[i].BVarStr = True) and (FnctTypeVar(items[i].Value) = TAlpha) then Ok := True;
   // Enum
   if (items[i].BEnum = True)
   then begin
        for j := 0 to length(Items[i].Enum)-1
        do if Items[i].value = Items[i].Enum[j] then Ok := True;
        end;
   // Object
   if (items[i].BObject = True)
   then begin
        for j := 0 to List.Items.Count -1
        do if List.Items[j].Caption = 'Objet'
           then begin
                ListParam := form1.GetParam(List.items.Item[j].SubItems.Strings[0]);
                if items[i].value = ListParam.param[1] then Ok := True;
                end;
        end;
   // Limite
   if (items[i].BLimite = True)
   then if FnctIsInteger(Items[i].value) = True
        then if (StrToInt(Items[i].value) >= Items[i].Limite[1]) and (StrToInt(Items[i].value) <= Items[i].Limite[2])
             then Ok := True;

   if Ok = False then result := Ok;
   if Ok = False
   then begin
        TempList := TStringList.Create;
        try
        if items[i].BStr = True then TempList.Add('valeur alphanumérique');
        if items[i].BNum = True then TempList.Add('valeur numérique');
        if items[i].BVarStr = True then TempList.Add('variable alphanumérique');
        if items[i].BVarNum = True then TempList.Add('variable numérique');
        if items[i].BObject = True then TempList.Add('object');
        if items[i].BEnum = True then for j := 0 to length(items[i].Enum)-1 do TempList.Add(items[i].Enum[j]);
        if items[i].BLimite = True then TempList.Add('valeur comprise entre '+ IntToStr(items[i].Limite[1])+ ' et '+ IntToStr(items[i].Limite[2]));
        msg := 'Le paramètre ' + IntToStr(i+1) + ' de la commande "' + Name +'" doit être de type suivant [';
        for j := 0 to TempList.Count -1
        do begin
           msg := msg + TempList[j];
           if j < TempList.Count-1 then msg := msg + ', ';
           end;
        msg := msg + '].';
        finally TempList.Free; end;
        WriteMessage(List,Pos + 1,SMsgDlgError,msg, ParentPos);
        end;
   end;
end;

procedure TstructOrdre.IntoEnum(A :array of string; index : integer);
var i : integer;
begin
//if @Items[index] = nil then Exit;
SetLength(Items[index].Enum,length(A));
if length(A) > 0
then items[index].BEnum := True
else items[index].BEnum := False;

for i := 0 to length(A)-1
do Items[index].Enum[i] := A[i];
end;

Procedure WriteMessage(List : TListView; Pos : integer; MsgType, Msg : String; ParentPos : integer = 0);
var i : integer;
begin
for i := 0 to length(TabIgnoreMsg)-1
do if Msg = TabIgnoreMsg[i].Msg
        then begin
             TabIgnoreMsg[i].Exists := True;
             Exit;
             end;

if Form1.ListView2.Items.Count > 0
then if Form1.ListView2.Items[0].SubItems[0] = 'Valide'
     then Form1.ListView2.Items[0].Delete;

Form1.ListView2.Items.Add();
i := Form1.ListView2.Items.Count-1;
if List <> form1.ListView1
then Form1.ListView2.Items[i].Caption := IntToStr(ParentPos)+ DecimalSeparator +IntToStr(Pos)
else Form1.ListView2.Items[i].Caption := IntToStr(Pos);

if MsgType = SMsgDlgError
then begin Form1.ListView2.Items[i].ImageIndex := 0; Inc(ErrorCount); end
else Form1.ListView2.Items[i].ImageIndex := 1;

Form1.ListView2.items.Item[i].SubItems.Add(MsgType);
Form1.ListView2.items.Item[i].SubItems.Add(Msg);

end;

Function VarReadOnly(Name : String): Boolean;
var i : integer;
    Found : integer;
begin
Result := False;
Found := -1;
for i := 0 to length(ListOfSysVar)-1
do if (ListOfSysVar[i].VName = Name)
   then Begin Found := i; break; end;

if Found <> -1
   then if ListOfSysVar[Found].VRW = 0
        then Result := True;
end;

Function Control(List : TListView; Commande, Parametre : String ;Pos : Integer; ParentPos : integer = 0): Boolean;
var find : Boolean;
    correct : Boolean;
begin
find := True;
correct := True;
case AnsiIndexStr(Commande,CaseOfExecuteTab) of
     0 : correct := DebugGoto(List,Parametre,Pos ,ParentPos);
     1 : correct := DebugProcedure(List,Parametre,Pos ,ParentPos);
     2 : correct := DebugLabel(List,Parametre,Pos ,ParentPos);
     3 : correct := DebugExamine(List,Parametre,Pos ,ParentPos);
     4 : correct := DebugVariable(List,Parametre,Pos ,ParentPos);
     5 : correct := DebugScriptEval(List,Parametre,Pos ,ParentPos);
     6 : correct := DebugMoveMouse(List,Parametre,Pos ,ParentPos);
     7 : correct := DebugClick(List,Parametre,Pos ,ParentPos);
     8 : ; //'Trouve image'
     9 : correct := DebugLire(List,Parametre,Pos ,ParentPos);
    10 : correct := DebugEcrire(List,Parametre,Pos ,ParentPos);
    11 : correct := DebugCalcul(List,Parametre,Pos ,ParentPos);
    12 : correct := DebugCalculEvol(List,Parametre,Pos ,ParentPos);
    13 : correct := DebugVariableSystem(List,Parametre,Pos ,ParentPos);
    14 : ; //'Commentaire'
    15 : correct := DebugFields(List,Parametre,Pos ,ParentPos);
    16 : correct := DebugType(List,Parametre,Pos ,ParentPos);
    17 : correct := DebugExecute(List,Parametre,Pos ,ParentPos);
    18 : ; //'Parcours souris'
    19 : correct := DebugTypeSpl(List,Parametre,Pos ,ParentPos);
    20 : correct := DebugObjet(List,Parametre,Pos ,ParentPos);
    21 : correct := DebugQuestion(List,Parametre,Pos ,ParentPos);
    22 : ;//'Manipulation'
    23 : correct := DebugPause(List,Parametre,Pos ,ParentPos);
    24 : correct := DebugOutilFichier(List,Parametre,Pos ,ParentPos);
    25 : correct := DebugOutilEcran(List,Parametre,Pos ,ParentPos);
    26 : correct := DebugOutilAffichage(List,Parametre,Pos ,ParentPos);
    27 : correct := DebugOutilAlimentation(List,Parametre,Pos ,ParentPos);
    28 : correct := DebugOutilRepertoire(List,Parametre,Pos ,ParentPos);
    29 : ; //'Quitter'
    30 : correct := DebugInclusion(List,Parametre,Pos ,ParentPos);
    -1 : if (form1.GetNewOrderIndex(Commande)<> -1)
         then begin
              Find := True;
              correct := DebugNewOrder(List,Commande, Parametre,Pos, ParentPos);
              end
         else Find := False;
    end;

if find = false
then WriteMessage(List,Pos + 1,SMsgDlgError,SUnknown, ParentPos);
if (find = false) or (correct = false)
then result := False
else result := True;
end;

Function DebugCalculEvol(List : TListView; parametre : String; Pos : integer; ParentPos : integer = 0): Boolean;
var i : integer;
    firstVar : String;
begin
result := True;
FirstVar := '';
for i := 1 to length(parametre)
do if parametre[i] = '=' then break else FirstVar := firstVar + parametre[i];
FirstVar := Trim(FirstVar);

if VarReadOnly(FirstVar) = True
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable '+FirstVar+' est en lecture seule.', ParentPos);
     result := False;
     end;
end;

Function DebugType(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
begin
result := True;
if Commande = ''
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Commande inutile puisque aucun paramètre', ParentPos);
end;

Function DebugTypeSpl(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    structOrdre : TstructOrdre;
    i,index : integer;
    MyKeyBoard : array[1..110]of string;
    MyKeyBoardplus : array[1..112]of string;
    KeyButton : TSpeedButton;
begin
for i := 1 to 110
do begin
   KeyButton := (Form4.FindComponent('SpeedButton' + inttostr(i)) as TSpeedButton);
   if KeyButton = nil then MyKeyBoard[i] := '' else MyKeyBoard[i] := KeyButton.Hint;
   if KeyButton = nil then MyKeyBoardplus[i] := '' else MyKeyBoardplus[i] := KeyButton.Hint;
   end;
MyKeyBoardPlus[111] := '[KeyDown]';
MyKeyBoardPlus[112] := '[KeyUp]';

ListParam := GetParam(Commande);

structOrdre := TstructOrdre.Create;
try
structOrdre.Name := 'Type special';
structOrdre.Pos := Pos;

for index := 1 to ListParam.nbr_param -1
do begin
   structOrdre.Add;
   structOrdre.items[index-1].value := ListParam.Param[index];
   if index <> ListParam.nbr_param -1
   then structOrdre.IntoEnum(MyKeyBoard,index-1)
   else structOrdre.IntoEnum(MyKeyBoardPlus,index-1);
   end;

result := structOrdre.CheckAll(List, ParentPos);
finally structOrdre.Free; end;

if ((listParam.param[4] <> '[KeyDown]') and (listParam.param[4] <> '[KeyUp]')) and (listParam.param[4] <> '')
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Le nombre maximal est 3 touches simultanées.', ParentPos);
end;

Function DebugMoveMouse(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    //Dim : Trect;
    x,y : integer;
    structOrdre : TstructOrdre;
    index : integer;
begin
x := 0; y := 0;
for index := 0 to screen.MonitorCount-1
do begin
   Inc(x, Screen.Monitors[index].Width);
   if y < Screen.Monitors[index].Height
   then y := Screen.Monitors[index].Height;
   end;

ListParam := GetParam(Commande);

if not ListParam.nbr_param-1 in [3..4]
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;

structOrdre := TstructOrdre.Create;
try
structOrdre.Name := 'Déplacement souris';
structOrdre.Pos := Pos;
for index := 1 to ListParam.nbr_param -1
do begin
   structOrdre.Add;
   structOrdre.items[index-1].value := ListParam.Param[index];
   end;

structOrdre.items[0].BVarNum := True;
structOrdre.items[0].BLimite := True;
structOrdre.items[0].Limite[1] := 0;
structOrdre.items[0].Limite[2] := x;

structOrdre.items[1].BVarNum := True;
structOrdre.items[1].BLimite := True;
structOrdre.items[1].Limite[1] := 0;
structOrdre.items[1].Limite[2] := y;

structOrdre.IntoEnum(['Direct','Indirect'],2);

result := structOrdre.CheckAll(List, ParentPos);
finally structOrdre.Free; end;
end;

Function DebugExecute(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    resultat : Boolean;
begin
resultat := True;
ListParam := GetParam(Commande);
if mdlfnct.FnctTypeVar(listParam.param[1]) = TNum
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable '+ listParam.param[1] +' est numèrique.', ParentPos);
     resultat := False;
     end;
result := resultat;
end;

Function DebugPause(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    resultat : Boolean;
begin
resultat := True;
ListParam := GetParam(Commande);
if Form7.TimeValide(listParam.param[1])
then begin

     end
else begin
     if mdlfnct.FnctTypeVar(listParam.param[1]) = TAlpha
     then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Assurez-vous que la variable placée dans le temps de pause contient une valeur 00:00:00.', ParentPos);
     if mdlfnct.FnctTypeVar(listParam.param[1]) = TNo
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le temps de pause est invalide, (00:00:01) ou variable.', ParentPos);
          resultat := False;
          end;
     end;
result := resultat;
end;

Function DebugGoto(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
begin
result := True;
ListParam := GetParam(Commande);

if FnctIsInteger(ListParam.param[1])
then begin
     if (StrToInt(ListParam.param[1])<1) or (StrToInt(ListParam.param[1])> List.Items.Count+1)
     then begin
          result := False;
          WriteMessage(List,Pos + 1,SMsgDlgError,'La commande n° ' + ListParam.param[1] + ' n''existe pas.', ParentPos);
          end;
     if (StrToInt(ListParam.param[1])=Pos+1)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'La commande Goto ne peut pas Boucler sur soi-même.', ParentPos);
          result := False;
          end;
     end
else begin
     result := form1.Fonction_existe(List,'Label',ListParam.param[1]);
     if result = False
     then WriteMessage(List,Pos + 1,SMsgDlgError,'Le Label nommé ' + ListParam.param[1] + ' n''existe pas.', ParentPos);
     end;
end;

Function DebugLabel(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    Int : integer;
begin
result := True;
ListParam := GetParam(Commande);
if not form1.Fonction_existe(List,'Goto',ListParam.param[1])
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Aucun Goto ' + ListParam.param[1] + ' n''a été appelé.', ParentPos);

Int := CountFindTextParam('Label',ListParam.param[1]);
if Int > 1 then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le label nommé ' + ListParam.param[1] + ' est défini '+ IntToStr(Int) + ' fois.', ParentPos); result := False; end;

Int := form1.Fonction_Pos('Goto',ListParam.param[1],List);
if (Int = Pos - 1) or (Int = Pos + 1)
then begin WriteMessage(List,Pos + 1,SMsgDlgError,'La boucle Label-Goto ne peut pas être vide.', ParentPos); result := False; end;
end;

Function DebugLire(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
begin
result := True;
ListParam := GetParam(Commande);
if ListParam.nbr_param-1 <> 3
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;

if  mdlfnct.FnctTypeVar(listParam.param[1]) = TNo
then if not fileexists(ListParam.param[1])
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgWarning,'Le fichier ' + ListParam.param[1] + ' appelé dans la commande lire n''existe pas.', ParentPos);
          end;

if  mdlfnct.FnctTypeVar(listParam.param[2]) = TNo
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable ' + ListParam.param[2] + ' appelée dans la commande lire n''existe pas.', ParentPos);
     result := False;
     end;
if not FnctIsInteger(listParam.param[3])
then begin
     if mdlfnct.FnctTypeVar(listParam.param[3]) = TAlpha
     then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Assurez-vous que la variable placée dans la position de lecture contient une valeur numerique.', ParentPos);
     if mdlfnct.FnctTypeVar(listParam.param[3]) = TNo
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'La position de lecture est invalide.', ParentPos);
          result := False;
          end;
     end;

if VarReadOnly(listParam.param[2]) = True
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable '+listParam.param[2]+' est en lecture seule.', ParentPos);
     result := False;
     end;
end;

Function DebugEcrire(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    resultat : Boolean;
begin
ListParam := GetParam(Commande);
if ListParam.nbr_param-1 <> 3
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;
resultat := True;
if mdlfnct.filenamevalide(ListParam.param[1]) = false
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Nom de fichier ' + ListParam.param[1] + ' est peut être incorrect dans la commande ecrire.', ParentPos);
result := resultat;
end;

Function DebugQuestion(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
begin
Result := True;
ListParam := GetParam(Commande);
if (ListParam.nbr_param-1 <> 3)
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;
if listParam.param[1] = '' then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Aucun titre n''est spécifié dans la fenêtre de la commande question.', ParentPos);
if listParam.param[2] = '' then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Aucun message n''est spécifié dans la fenêtre de la commande question.', ParentPos);

if  ((mdlfnct.FnctTypeVar(listParam.param[3]) = TNo) and (listParam.param[3] <> ''))
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable ' + ListParam.param[3] + ' appelée dans la commande question n''existe pas.', ParentPos);
     result := False;
     end;

if VarReadOnly(listParam.param[3]) = True
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable '+listParam.param[3]+' est en lecture seule.', ParentPos);
     result := False;
     end;

end;

Function DebugClick(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    IntDown, IntUp : integer;
    ButtonUp, ButtonDown : string;
begin
ListParam := GetParam(Commande);
result := True;
if listParam.param[1] = '' then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Aucun paramètre n''est spécifié dans la commande Click.', ParentPos);

if ((listParam.param[1] = 'Left Up') or (listParam.param[1] = 'Left Down'))
then begin
     buttonUp := 'Left Up';
     ButtonDown := 'Left Down';
     end;
if ((listParam.param[1] = 'Middle Up') or (listParam.param[1] = 'Middle Down'))
then begin
     buttonUp := 'Middle Up';
     ButtonDown := 'Middle Down';
     end;
if ((listParam.param[1] = 'Right Up') or (listParam.param[1] = 'Right Down'))
then begin
     buttonUp := 'Right Up';
     ButtonDown := 'Right Down';
     end;

IntUp := CountFindTextParam('Click',ButtonUp);
IntDown := CountFindTextParam('Click',ButtonDown);

if IntUp > IntDown
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Le nombre de relâchement du bouton '+ ButtonUp +' de la souris est supérieur à l''appui.', ParentPos);
if IntUp < IntDown
then begin
     WriteMessage(List,Pos + 1,SMsgDlgWarning,'Le nombre d''appui du bouton '+ ButtonDown +' de la souris est supérieur au relâchement.', ParentPos);
     result := False;
     end;
end;

Function DebugCalcul(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    TypeParam1, TypeParam2 : string;
begin
result := True;
ListParam := GetParam(Commande);
if ListParam.nbr_param-1 <> 3
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;

TypeParam1 := mdlfnct.FnctTypeVar(ListParam.param[1]);
TypeParam2 := mdlfnct.FnctTypeVar(ListParam.param[3]);

if ((commande[1] = SprPr) or (Listparam.nbr_param < 3))
then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Vous devez spécifez tous les paramètres.', ParentPos); result := False; end;

if TypeParam1 = TNo
then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le premier paramètre de calcul doit être une variable.', ParentPos);  result := False; end;

if ((TypeParam1 = TNum) and (TypeParam2 = TAlpha))
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Assurez vous que la variable du deuxième paramètre de la commande calcul contient une valeur numerique.', ParentPos);

if ((TypeParam1 = TAlpha) and (Listparam.param[2] <> '+'))
then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Operation impossible sur une variable de type alphanumérique.', ParentPos);  result := False; end;

if ((TypeParam1 = TNum) and (TypeParam2 = TNo))
then begin
     if not FnctIsInteger(ListParam.param[3])
     then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le deuxième operande doit être un nombre entier.', ParentPos);  result := False; end;
     end;
if (Listparam.param[2] = '/') and (Listparam.param[3] = '0')
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Division par 0 impossible.', ParentPos);
     result := False;
     end;

if VarReadOnly(listParam.param[1]) = True
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable '+listParam.param[1]+' est en lecture seule.', ParentPos);
     result := False;
     end;

end;

Function DebugExamine(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    TypeParam1, TypeParam2 : string;
begin
result := True;
ListParam := GetParam(Commande);
if ListParam.nbr_param-1 <> 3
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;
TypeParam1 := mdlfnct.FnctTypeVar(ListParam.param[1]);
TypeParam2 := mdlfnct.FnctTypeVar(ListParam.param[3]);

if ((commande[1] = SprPr) or (Listparam.nbr_param < 3))
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Vous devez spécifez tous les paramètres.', ParentPos);
     result := False;
     end;

if TypeParam1 = TNo
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Le premier paramètre d''examine doit être une variable.', ParentPos);
     result := False;
     end;

if ((TypeParam1 = TNum) and (TypeParam2 = TAlpha))
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Assurez vous que la variable du deuxième paramètre de la commande d''examine contient une valeur numerique.', ParentPos);

if ((TypeParam1 = TNum) and (TypeParam2 = TNo))
then begin
     if not FnctIsInteger(ListParam.param[3])
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le deuxième operande doit être un nombre entier.', ParentPos);
          result := False;
          end;
     end;

if List.Items[pos+2] = nil
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La commande examine a besoin de deux commandes placées en dessous d''elle pour agir correctement.', ParentPos);
     result := False;
     Exit;
     end;

if List.Items[pos+1].Caption = 'Label'
then begin
     WriteMessage(List,Pos + 2,SMsgDlgError,'Un label ne peut pas être défini à cette endroit, car la position de cette commande appartient à la commande Examine ci-dessus.', ParentPos);
     result := False;
     Exit;
     end;

if List.Items[pos+1].Caption = 'Procedure'
then if copy(List.Items[pos+1].SubItems[0],0,5) <> 'CALL '
     then begin
          WriteMessage(List,Pos + 2,SMsgDlgError,'Une procédure ne peut pas être définie à cette endroit, car la position de cette commande appartient à la commande Examine ci-dessus.', ParentPos);
          result := False;
          Exit;
          end;

if List.Items[pos+2].Caption = 'Label'
then begin
     WriteMessage(List,Pos + 3,SMsgDlgError,'Un label ne peut pas être défini à cette endroit, car la position de cette commande appartient à la commande Examine ci-dessus.', ParentPos);
     result := False;
     Exit;
     end;

if List.Items[pos+2].Caption = 'Procedure'
then if copy(List.Items[pos+2].SubItems[0],0,5) <> 'CALL '
     then begin
          WriteMessage(List,Pos + 3,SMsgDlgError,'Une procédure ne peut pas être définie à cette endroit, car la position de cette commande appartient à la commande Examine ci-dessus.', ParentPos);
          result := False;
          Exit;
          end;

end;

Function DebugOutilAffichage(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    IValeur : integer;
    SValeur : String;
    structOrdre : TstructOrdre;
    index : integer;
begin
ListParam := GetParam(Commande);
result := false;
if ListParam.param[1] = 'Résolution'
then begin
     structOrdre := TstructOrdre.Create;
     try
     structOrdre.Name := 'Résolution';
     structOrdre.Pos := Pos;
     for index := 1 to ListParam.nbr_param -1
     do begin
        structOrdre.Add;
        structOrdre.items[index-1].value := ListParam.Param[index];
        end;

     structOrdre.IntoEnum(['320','400','480','512','640','720','800','848','960','1024','1152','1280','1360','1600','1920'],1);
     structOrdre.IntoEnum(['200','240','300','360','384','400','480','576','600','720','768','864','900','960','1024','1080','1200'],2);
     structOrdre.IntoEnum(['8 bits','16 bits','24 bits','32 bits'],3);

     result := structOrdre.CheckAll(List, ParentPos);
     finally structOrdre.Free; end;

     if result = True
     then begin
          SValeur := '';
          if ListParam.param[4] = '8 bits' then Svaleur := '8' else Svaleur := ListParam.param[4][1] + ListParam.param[4][2];
          IValeur := Form19.ChangeResolEcran(StrToInt(ListParam.param[2]),StrToInt(ListParam.param[3]),StrToInt(SValeur),False);
          if IValeur = DISP_CHANGE_BADMODE then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le mode Graphique n''est pas supporté.', ParentPos); result := False; end;
          if IValeur = DISP_CHANGE_FAILED  then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le test de changement de résolution a echoué.', ParentPos); result := False; end;
          if IValeur = DISP_CHANGE_RESTART then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Votre configuration demande un redémarrage du PC, il n''est donc pas possible d''exécuter cette commande.', ParentPos); result := False; end;
          end;
     end;

if ListParam.param[1] = 'Fréquence'
then begin
     structOrdre := TstructOrdre.Create;
     try
     structOrdre.Name := 'Fréquence';
     structOrdre.Pos := Pos;
     for index := 1 to ListParam.nbr_param -1
     do begin
        structOrdre.Add;
        structOrdre.items[index-1].value := ListParam.Param[index];
        end;

     structOrdre.IntoEnum(['60','70','72','75','85','100','120','140','144','150','170','200'],1);
     result := structOrdre.CheckAll(List, ParentPos);
     finally structOrdre.Free; end;

     if result = True
     then begin
          SValeur := '';
          IValeur := Form19.ChangeFreqEcran(StrToInt(ListParam.param[2]),False);
          if IValeur = DISP_CHANGE_BADMODE then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le mode Graphique n''est pas supporté.', ParentPos); result := False; end;
          if IValeur = DISP_CHANGE_FAILED  then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Le test de changement de Fréquence a echoué.', ParentPos); result := False; end;
          if IValeur = DISP_CHANGE_RESTART then begin WriteMessage(List,Pos + 1,SMsgDlgError,'Votre configuration demande un redémarrage du PC, il n''est donc pas possible d''exécuter cette commande.', ParentPos); result := False; end;
          end;
     end;
end;

Function DebugOutilAlimentation(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var structOrdre : TstructOrdre;
    index : integer;
    ListParam : Tparam;
begin
ListParam := GetParam(Commande);

structOrdre := TstructOrdre.Create;
try
structOrdre.Name := 'Outil alimentation';
structOrdre.Pos := Pos;
for index := 1 to ListParam.nbr_param -1
do begin
   structOrdre.Add;
   structOrdre.items[index-1].value := ListParam.Param[index];
   end;

structOrdre.items[0].BEnum := True;
structOrdre.IntoEnum(['Fermer la session','Eteindre','Redémarrer','Mise en veille'],0);

result := structOrdre.CheckAll(List, ParentPos);
finally structOrdre.Free; end;

end;

Function DebugOutilEcran(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    SValeur : String;
begin
result := True;
ListParam := GetParam(Commande);
if ListParam.param[1] = 'Copier vers bmp'
then begin
     SValeur := FnctTypeVar(ListParam.param[2]);
     if (SValeur = TNo) and (FileNameValide(ListParam.param[2]) = False)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 n''est pas un nom de fichier valide.', ParentPos);
          result := False;
          end;
     if (SValeur = TNo) and (FileNameValide(ListParam.param[2]) = True) and (ExtractFileExt(ListParam.param[2]) <> '.bmp')
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 n''est pas un fichier avec l''extension .bmp.', ParentPos);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 ne peut pas être une variable numèrique.', ParentPos);
          result := False;
          end;
     end;
if ListParam.param[1] = 'Copier vers jpg'
then begin
     SValeur := FnctTypeVar(ListParam.param[2]);
     if (SValeur = TNo) and (FileNameValide(ListParam.param[2]) = False)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 n''est pas un nom de fichier valide.', ParentPos);
          result := False;
          end;
     if (SValeur = TNo) and (FileNameValide(ListParam.param[2]) = True) and (ExtractFileExt(ListParam.param[2]) <> '.jpg')
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 n''est pas un fichier avec l''extension .jpg.', ParentPos);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 ne peut pas être une variable numèrique.', ParentPos);
          result := False;
          end;
     end;
if FileExists(GetValue(ListParam.param[2])) then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Vous allez écraser un fichier existant.', ParentPos);
end;

Function DebugOutilFichier(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    SValeur : String;
begin
result := True;
ListParam := GetParam(Commande);
if (ListParam.param[1] = 'Copier') or (ListParam.param[1] = 'Déplacer') or (ListParam.param[1] = 'Renommer')
then begin
     SValeur := FnctTypeVar(ListParam.param[2]);
     if (SValeur = TNo) and (FileNameValide(ListParam.param[2]) = False)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 n''est pas un nom de fichier valide.', ParentPos);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 ne peut pas être une variable numèrique.', ParentPos);
          result := False;
          end;
     SValeur := FnctTypeVar(ListParam.param[3]);
     if (SValeur = TNo)
     then begin
          if ((ListParam.param[1] = 'Copier') or (ListParam.param[1] = 'Déplacer')) and (DirNameValide(ListParam.param[3]) = False)
          then begin
               WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 2 n''est pas un répertoire valide.', ParentPos);
               result := False;
               end;
          if (ListParam.param[1] = 'Renommer') and (FileNameValide(ListParam.param[3]) = False)
          then begin
               WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 2 n''est pas un nom de fichier valide.', ParentPos);
               result := False;
               end;
          end;
     if (SValeur = TNum)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 2 ne peut pas être une variable numèrique.', ParentPos);
          result := False;
          end;
     end;
if (ListParam.param[1] = 'Effacer')
then begin
     SValeur := FnctTypeVar(ListParam.param[2]);
     if (SValeur = TNo) and (FileNameValide(ListParam.param[2]) = False)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 n''est pas un nom de fichier valide.', ParentPos);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre 1 ne peut pas être une variable numèrique.', ParentPos);
          result := False;
          end;
          if (SValeur = TNo) and (FileExists(ListParam.param[2]) = False)
     then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Le fichier que vous voulez effacer n''existe pas (A moins qu''il soit créé durant l''exécution de la macro).', ParentPos);
     end;

end;

Function DebugOutilRepertoire(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
begin
result := True;
ListParam := GetParam(Commande);

end;

Function DebugFields(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    i : integer;
begin
result := True;
ListParam := GetParam(Commande);

if mdlfnct.FnctTypeVar(ListParam.param[1]) <> TAlpha
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable a traiter dans la commande déclaration de champs n''est pas valide.', ParentPos);
     result:= False;
     end;

if ListParam.param[2] = 'D'
then begin
     if (ListParam.param[3] = '') and (ListParam.param[4] = '') and (ListParam.param[5] = '') and (ListParam.param[6] = '') and (ListParam.param[7] = '')
     then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Si vous ne séléctionnez pas de séparateur cette commande devient obsolette.', ParentPos);
     if ListParam.param[8] = '' then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Si vous n''utilisez pas de champ cette commande devient obsolette.', ParentPos);
     for i := 8 to 19 do
     begin
     if i mod 2 = 0
     then begin
          if ListParam.param[i] <> ''
          then if form1.Fonction_existe_with_param(List,'Variable',ListParam.param[i],1) = False
               then begin
                    WriteMessage(List,Pos + 1,SMsgDlgError,'Le champ '+ ListParam.param[i]+ 'n''a pas de variable correpondant, veuillez déclarer la variable.', ParentPos);
                    result:= False;
                    end;
          end
     else begin
          if ListParam.param[i] <> ''
          then if FnctIsInteger(ListParam.param[i]) = False
               then begin
                    WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre du champ '+ ListParam.param[i-1]+ 'n''est pas un nombre entier.', ParentPos);
                    result:= False;
                    end;
          end;
     end;
     end;

if ListParam.param[2] = 'F'
then begin

if ListParam.param[3] = '' then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Si vous n''utilisez pas de champ cette commande devient obsolette.', ParentPos);
for i := 3 to 18 do if i mod 3 = 0 // pour prendre que les multiples de 3
then begin
     if ListParam.param[i] <> ''
     then begin
          if form1.Fonction_existe_with_param(List,'Variable',ListParam.param[i],1) = False
          then begin
               WriteMessage(List,Pos + 1,SMsgDlgError,'Le champ '+ ListParam.param[i]+ 'n''a pas de variable correpondant, veuillez déclarer la variable.', ParentPos);
               result:= False;
               end;
          if (FnctIsInteger(ListParam.param[i+1]) = False) or (FnctIsInteger(ListParam.param[i+2]) = False)
          then begin
               WriteMessage(List,Pos + 1,SMsgDlgError,'L''un des paramètres du champ '+ ListParam.param[i]+ 'n''est pas un nombre entier.', ParentPos);
               result:= False;
               end;
          end;
     end;
     end;
end;

Function DebugVariable(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    i : integer;
const InvalideChar :array[1..5] of String = ('+','-','/','*','=');
begin
result := True;
ListParam := GetParam(Commande);

for i := Low(InvalideChar) to High(InvalideChar)
do if System.Pos(InvalideChar[i],ListParam.Param[1]) <> 0
   then begin
        WriteMessage(List,Pos + 1,SMsgDlgError,'Le nom de la variable ne peut posséder le caractère "'+InvalideChar[i]+'".', ParentPos);
        result := False;
        Exit;
        end;

if ListParam.param[1] = '[MACRO.MAIL]'
then begin
     if system.Pos('@',ListParam.param[2]) = 0
     then WriteMessage(List,Pos + 1,SMsgDlgWarning,'Adresse mail invalide.', ParentPos);
     exit;
     end;

if ListParam.nbr_param-1 <> 3
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     StopAllDebug := True;
     result := False;
     Exit;
     end;
     
if Form1.VarUse(List, ListParam.param[1]) = False
then WriteMessage(List,Pos + 1,SMsgDlgWarning,'La variable nommée '+ ListParam.param[1] +' n''est pas utilisée.', ParentPos);
end;

function DebugNewOrder(List : TListView; Commande, parametre : String; Pos : integer; ParentPos : integer = 0): Boolean;
var Handle: THandle;
    newpos : integer;
    MyMsg : String;
begin
result := True;
newpos := form1.GetNewOrderIndex(Commande);
Handle := DynOrder[newpos].Handle;
if Handle <> 0
then begin
     result := GestionCommande.DynOrder[Newpos].Debug(PChar(parametre));
     MyMsg := GestionCommande.DynOrder[Newpos].MsgDebug(Pchar(parametre));
     if MyMsg <> ''
     then if result = True
     then WriteMessage(List,Pos + 1,SMsgDlgWarning,MyMsg, ParentPos)
     else WriteMessage(List,Pos + 1,SMsgDlgError,MyMsg, ParentPos);
     end;
end;

Function DebugVariableSystem(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var structOrdre : TstructOrdre;
    index : integer;
    ListParam : Tparam;
begin
ListParam := GetParam(Commande);

structOrdre := TstructOrdre.Create;
try
structOrdre.Name := 'Fonction';
structOrdre.Pos := Pos;
for index := 1 to ListParam.nbr_param -1
do begin
   structOrdre.Add;
   structOrdre.items[index-1].value := ListParam.Param[index];
   end;

structOrdre.items[0].BVarStr := True;
structOrdre.items[0].BVarNum := True;

if (ListParam.Param[2] = 'Texte')
then begin
     if (structOrdre.count <> 6) and (Listparam.Param[3] = 'Caractère(s)/Position(s)')
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre '+IntToStr(structOrdre.count+1)+' de la commande Caractère(s)/Position(s) est introuvable.', ParentPos);
          result := False;
          Exit;
          end;
     if (structOrdre.count <> 6) and (Listparam.Param[3] = 'Caractère(s)/Longueur')
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Le paramètre '+IntToStr(structOrdre.count+1)+' de la commande Caractère(s)/Longueur est introuvable.', ParentPos);
          result := False;
          Exit;
          end;
     if (structOrdre.count <> 4) and (Listparam.Param[3] = 'Longueur')
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Veuillez sélectionner dans les paramètres uniquement le texte a traiter.', ParentPos);
          result := False;
          Exit;
          end;

     structOrdre.items[3].BVarStr := True;
     structOrdre.items[3].BStr := True;
     if (Listparam.Param[3] = 'Caractère(s)/Position(s)')
     then begin
          structOrdre.items[4].BNum := True;
          structOrdre.items[4].BVarNum := True;
          structOrdre.items[5].BNum := True;
          structOrdre.items[5].BVarNum := True;
          end;
     end;

result := structOrdre.CheckAll(List, ParentPos);
finally structOrdre.Free; end;

if VarReadOnly(listParam.param[1]) = True
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'La variable '+listParam.param[1]+' est en lecture seule.', ParentPos);
     result := False;
     end;

end;

Function DebugObjet(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var ListParam : Tparam;
    structOrdre : TstructOrdre;
    index : integer;
begin

ListParam := GetParam(Commande);

if ListParam.nbr_param-1 <> 12
then begin
     WriteMessage(List,Pos + 1,SMsgDlgError,'Nombre de paramètre invalide.', ParentPos);
     result := False;
     Exit;
     end;

structOrdre := TstructOrdre.Create;
try
structOrdre.Name := 'Objet';
structOrdre.Pos := Pos;
for index := 1 to ListParam.nbr_param -1
do begin
   structOrdre.Add;
   structOrdre.items[index-1].value := ListParam.Param[index];
   end;

structOrdre.items[0].BLimite := True; // Handle
structOrdre.items[0].Limite[1] := 0;
structOrdre.items[0].Limite[2] := 4294967295;


structOrdre.items[1].BLimite := True; // Handle
structOrdre.items[1].Limite[1] := 0;
structOrdre.items[1].Limite[2] := 4294967295;

structOrdre.items[2].BStr := True; // Nom du module
structOrdre.items[3].BStr := True; // Class
structOrdre.items[4].BStr := True; // Text
structOrdre.items[4].BNum := True; // Text

structOrdre.items[5].BLimite := True; // Longueur
structOrdre.items[5].Limite[1] := -2560;
structOrdre.items[5].Limite[2] := 2560;

structOrdre.items[6].BLimite := True; // Largeur
structOrdre.items[6].Limite[1] := -2560;
structOrdre.items[6].Limite[2] := 2560;

structOrdre.items[7].BLimite := True; // Si objet pas trouvé choix 1 ou 2
structOrdre.items[7].Limite[1] := 1;
structOrdre.items[7].Limite[2] := 2;

structOrdre.items[8].BLimite := True; // Si plusieurs objets trouvés choix 1 à 3
structOrdre.items[8].Limite[1] := 1;
structOrdre.items[8].Limite[2] := 3;

 // Variable du nombre d'objet trouvé
structOrdre.items[9].BVarStr := True;
structOrdre.items[9].BVarNum := True;
structOrdre.items[9].CanEmpty := True;

structOrdre.items[10].BLimite := True; // Séléctionner l'objet n° (pas + de 999)
structOrdre.items[10].Limite[1] := 1;
structOrdre.items[10].Limite[2] := 999;
structOrdre.items[10].BVarNum := True;
if ListParam.param[9] = '3'
then structOrdre.items[10].CanEmpty := False
else structOrdre.items[10].CanEmpty := True;

structOrdre.items[11].BLimite := True; // Critere de selection 0 à 256
structOrdre.items[11].Limite[1] := 0;
structOrdre.items[11].Limite[2] := 256;

result := structOrdre.CheckAll(List, ParentPos);
finally structOrdre.Free; end;
end;

Function DebugProcedure(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var actionType : cardinal;
    procName : String;
begin
result := True;
ProcName := '';
ActionType := 1;
if copy(Commande,0,3) = 'END' then ActionType := 2;
if copy(Commande,0,5) = 'CALL ' then begin ActionType := 3; ProcName := copy(Commande,6,length(Commande)); end;
if ActionType = 1
then if Form1.FindEndOfProcedure(List,Pos) < 0
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Fin de procédure introuvable.', ParentPos);
          result := False;
          Exit;
          end;
if ActionType = 2
then if Form1.CanGetEndOfProcedure(List,Pos,False) = False
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Aucune procédure à fermer.', ParentPos);
          result := False;
          Exit;
          end;

if ActionType = 3
then if Form1.procedure_exists(List,ProcName) < 0
     then begin
          WriteMessage(List,Pos + 1,SMsgDlgError,'Définition de procédure introuvable.', ParentPos);
          result := False;
          Exit;
          end;
end;

Function DebugScriptEval(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
var structOrdre : TstructOrdre;
    index : integer;
    ListParam : Tparam;
begin
ListParam := GetParam(Commande);

structOrdre := TstructOrdre.Create;
try
structOrdre.Name := 'ScriptEval';
structOrdre.Pos := Pos;
for index := 1 to 3
do begin
   structOrdre.Add;
   structOrdre.items[index-1].value := ListParam.Param[index];
   end;

StructOrdre.IntoEnum(['JScript','VBScript'],0);
StructOrdre.items[1].BStr := True;
if Form25.MSScriptIsBoolean(Pos,List)
then StructOrdre.items[1].CanEmpty := True
else StructOrdre.items[1].CanEmpty := False;
//StructOrdre.items[2].BVarStr := True;
//StructOrdre.items[2].BVarNum := True;
//StructOrdre.items[2].CanEmpty := True;
result := structOrdre.CheckAll(List, ParentPos);
finally structOrdre.Free; end;
end;

Function DebugInclusion(List : TListView; Commande : String; Pos : integer; ParentPos : integer = 0): Boolean;
begin
result := True;
if not FileExists(Commande)
then WriteMessage(List,Pos + 1,SMsgDlgError,'Fichier inclusion introuvable ['+Commande+'].', ParentPos);
end;

end.
