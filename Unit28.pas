unit Unit28;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ComCtrls, Unit1;

const
  MSG_Clavier = WM_USER + 3;
  MSG_Souris = WM_USER + 4;
  MSG_MoveMouse = WM_User + 13;

type TParcours = record
     X : array of cardinal;
     Y : array of cardinal;
     end;

type
TMSetHook = function : Boolean; stdcall;
TMUnSetHook = procedure ; stdcall;
TMSetMainHandle = procedure (Handle: HWND); stdcall;
TSetHook = function : Boolean; stdcall;
TUnSetHook = procedure; stdcall;
TSetMainHandle = procedure (Handle: HWND); stdcall;

THook = record
        MSetHook : TMSetHook;
        MUnSetHook : TMUnSetHook;
        MSetMainHandle : TMSetMainHandle;
        SetHook : TSetHook;
        UnSetHook : TUnSetHook;
        SetMainHandle : TSetMainHandle;
        end;
type
  TForm28 = class(TForm)
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    Timer1: TTimer;
    Bevel2: TBevel;
    Label2: TLabel;
    SaveDialog1: TSaveDialog;
    CheckBox1: TCheckBox;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    Bevel1: TBevel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    CheckBox2: TCheckBox;
    Label9: TLabel;
    Edit1: TEdit;
    CheckBox3: TCheckBox;
    Label10: TLabel;
    Image2: TImage;
    procedure Timer1Timer(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label9Click(Sender: TObject);
    procedure Label10Click(Sender: TObject);
  private
    { Private declarations }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Public declarations }
  procedure MWMGM(var Msg: TMessage); message MSG_Souris;
  procedure WMGM(var Msg: TMessage); message MSG_Clavier;
  procedure TraitementSouris( button : String);

  function MsgSourisToStr(messag: Cardinal): string;
  function SecToTime(Sec : real) : String;
  function TimeToSec(Temp : String): LongInt;

  procedure AddParcours();
  procedure AddTime();
  procedure ForeGroundWin();
  procedure Optimisation(Macro : TListView);
  function GetLastCoor(Param : string) : Tpoint;
  procedure ListAllObj(ObjHandle : HWND);
  Procedure EventHook(Activate : Boolean);
  Procedure EventProcExecute(Name : String);
  function MsgMouseEvent(messag: Cardinal; var Button : string; Var Action : cardinal) : Boolean;
  end;

var
  Form28: TForm28;
  PosK7 : integer = 176;
  StateForm1 : TWindowState;
  clignote : Boolean = False;
  FileMacro : File of TOrdre;
  Ordre : TOrdre;
  OldPos,LastPos : Tpoint;
  LastKey : string = '';
  CodeMouvement : string = '';
  Temp : cardinal;
  Parcours : TParcours;
  ProcessId, MainProcessId : DWORD;
  Hook : THook;
  OldForeGroundWin : Thandle = 0;
  AllIsOk : Boolean = True;
  //ProcEvent : TListView;

implementation

uses Unit4, MdlFnct, UBackGround, Unit23;

{$R *.dfm}

Procedure TForm28.EventProcExecute(Name : String);
var ProcActiveOrder :TActiveOrder;
    ProcIndex, ProcEnd : integer;
    i : integer;
begin
ProcIndex := Form1.procedure_exists(Form1.ListView1,Name);
if ProcIndex <> -1
then begin
     ProcEnd := Form1.FindEndOfProcedure(Form1.ListView1,ProcIndex);
     Setlength(ProcActiveOrder,Form1.ListView1.items.count);
     for i := Low(ProcActiveOrder) to High(ProcActiveOrder)
     do ProcActiveOrder[i] := True;
     Inc(ProcIndex);

     while ((ProcIndex < ProcEnd ) and (Run = True))
     do begin
        Form1.Execute_commande(Form1.ListView1,ProcIndex,ProcActiveOrder);
        end;
     end;
end;

Procedure TForm28.EventHook(Activate : Boolean);
var FileName : String;
begin
if Activate = True
then begin
     FileName := ExtractFileDir(Application.ExeName) + '\temp.sqc';
     AssignFile(FileMacro,FileName);
     Hook.MSetMainHandle(Handle);
     if not Hook.MSetHook then showmessage('Capture des événements souris impossible.');
     Hook.SetMainHandle(Handle);
     if not Hook.SetHook then showmessage('Capture des événements clavier impossible.');
     end
else begin
     Hook.MUnsetHook;
     Hook.UnsetHook;
     end;

end;

procedure TForm28.MessageAide(var msg:TMessage);
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


procedure TForm28.ListAllObj(ObjHandle: HWND);
var TabPPParent : array of HWND;
    i : integer;
    Handle : HWND;
    PrmIgnored : String;
begin
SetLength(TabPPParent,0);
Handle := ObjHandle;
while Handle <> 0
do begin
   Handle := GetParent(Handle);
   if Handle <> 0
   then begin
        SetLength(TabPPParent, length(TabPPParent)+1);
        TabPPParent[length(TabPPParent)-1] := Handle;
        end;
   end;
SetLength(TabPPParent, length(TabPPParent)+1);
TabPPParent[length(TabPPParent)-1] := ObjHandle;

PrmIgnored := '0'+SprPr+'0'+SprPr+'1'+SprPr+'1'+SprPr+SprPr+SprPr+'248'+SprPr;

Ordre.commande := 'Objet';

for i := 0 to length(TabPPParent)-1
do begin
   Ordre.textparam := '';
   Ordre.textparam := IntToStr(TabPPParent[i])+SprPr+ IntToStr(GetParent(TabPPParent[i])) + SprPr +
                      GetWindowModuleFileName(TabPPParent[i])+ SprPr+ Donne_class(TabPPParent[i])+ SprPr +
                      mdlfnct.gettext(TabPPParent[i]) + SprPr + PrmIgnored ;
                      Write(FileMacro,Ordre);

   end;
end;

procedure TForm28.AddTime;
var Tmp : Cardinal;
begin
Tmp := (GetTickCount-Temp) div 1000;
if ((GetTickCount-Temp) - Tmp *1000) > 600
then Inc(Tmp);
if Tmp > 0
then begin
     Ordre.commande := 'Pause';
     Ordre.textparam := SecToTime(Tmp);
     Write(FileMacro,Ordre);
     end;
Temp := GetTickCount;
ForeGroundWin;
end;

function TForm28.GetLastCoor(param : string): Tpoint;
var i,j : integer;
    x, y : string;
begin
x := ''; y := '';
j := 0;
for i := length(param)-1 downto 1
do if param[i] <> unit1.SprPr then y := param[i] + y
   else begin j := i; break; end;

for i := j-1 downto  1
do if param[i] <> unit1.SprPr then x := param[i] + x
   else break;
result := point(StrToInt(x),StrToInt(y));

end;

procedure ProcessMessagesEX();
var msg : TMSG;
begin
while (PeekMessage(msg,0,0,0,PM_REMOVE))
do begin
   TranslateMessage(msg);
   DispatchMessage(msg);
   end;
end;

procedure TForm28.ForeGroundWin;
var Hwin : HWND;
    Wplacement : WindowPlacement;
    ProcessId : LongWord;
    MainProcessId : cardinal;
begin
if checkBox3.Checked then Exit;
if GetForegroundWindow() <=0 then Exit;
Hwin := GetForegroundWindow();
MainProcessId := GetWindowThreadProcessId(Form1.Handle,@ProcessId);
if MainProcessId = GetWindowThreadProcessId(Hwin,@ProcessId) then Exit;

if not isWindow(HWin) then Exit;
if  Hwin <> OldForeGroundWin
then begin
     GetWindowPlacement(Hwin,@Wplacement);
     case Uint(Wplacement.showCmd) of
     SW_NORMAL,
     SW_SHOW,
     SW_RESTORE : begin
                  if (Wplacement.rcNormalPosition.Left = 0) and (Wplacement.rcNormalPosition.Top = 0) and (Wplacement.rcNormalPosition.Right = 0) and (Wplacement.rcNormalPosition.Bottom = 0) then exit;

                  ListAllObj(Hwin);

                  Ordre.commande := 'Manipulation';
                  Ordre.textparam :=IntToStr(Hwin)+SprPR+'Déplacer'+SprPr+IntToStr(Wplacement.rcNormalPosition.Left)+SprPr+IntToStr(Wplacement.rcNormalPosition.Top)+SprPR;
                  Write(FileMacro,Ordre);

                  Ordre.textparam :=IntToStr(Hwin)+SprPr+'Taille'+SprPr+IntToStr(Wplacement.rcNormalPosition.Right-Wplacement.rcNormalPosition.Left)+SprPr+IntToStr(Wplacement.rcNormalPosition.Bottom-Wplacement.rcNormalPosition.Top)+SprPr;
                  Write(FileMacro,Ordre);

                  Ordre.commande := 'Pause';
                  Ordre.textparam :='00:00:01';
                  Write(FileMacro,Ordre);

                  label2.Caption := 'Resize "'+ mdlfnct.Donne_Class(Hwin)+ ' - ' + mdlfnct.GetText(Hwin)+'"';
                  end;
     SW_SHOWMINIMIZED : begin
                        if (Wplacement.rcNormalPosition.Right = screen.Width) and (Wplacement.rcNormalPosition.Bottom = screen.Height)
                        then begin
                             ListAllObj(Hwin);
                             Ordre.commande := 'Manipulation';
                             Ordre.textparam :=IntToStr(Hwin)+SprPr+'Réduire'+SprPr;
                             Write(FileMacro,Ordre);

                             Ordre.commande := 'Pause';
                             Ordre.textparam :='00:00:01';
                             Write(FileMacro,Ordre);
                             end;
                        end;
     SW_SHOWMAXIMIZED,
     SW_MAX           : begin
                        if (Wplacement.rcNormalPosition.Right = screen.Width) and (Wplacement.rcNormalPosition.Bottom = screen.Height)
                        then begin
                             ListAllObj(Hwin);
                             Ordre.commande := 'Manipulation';
                             Ordre.textparam :=IntToStr(Hwin)+SprPr+'Agrandir'+SprPr;
                             Write(FileMacro,Ordre);

                             Ordre.commande := 'Pause';
                             Ordre.textparam :='00:00:01';
                             Write(FileMacro,Ordre);
                             end;
                        end;
     else begin
          Ordre.commande := 'Commentaire';
          Ordre.textparam := 'Evénement non traité code ['+ IntToStr(Uint(Wplacement.showCmd)) +']';
          Write(FileMacro,Ordre);
          end;
  // SW_SHOWMINIMIZED : chaine := 'Réduit';
    end;
    OldForeGroundWin := Hwin;
    end;
end;

procedure TForm28.AddParcours;
var i, j, k : integer;
const limite = 30;
begin
   if length(Parcours.x) = 0 then Exit;
   Ordre.commande := 'Parcours souris';
   j := (length(Parcours.x)-1) div limite;
   if (length(Parcours.x)-1) mod limite <> 0 then Inc(j);

   for i := 0 to j-1
   do begin
      Ordre.textparam := '';
      for k := i*limite+1 to i*limite+limite
      do if k < length(Parcours.x)
         then Ordre.textparam := Ordre.textparam + IntToStr(Parcours.x[k]) + SprPr + IntToStr(Parcours.y[k]) + SprPr;
      Write(FileMacro,Ordre);
      end;
   SetLength(Parcours.x,0);
   SetLength(Parcours.y,0);
end;

procedure TForm28.MWMGM(var Msg: TMessage);
var Pt : Tpoint;
    handle : HWND;
    Action : String;
    TabLength : Integer;
    EventType : cardinal;
    button : String;
    Ok : Boolean;
begin

if GetValue('[EVENT.ACTIVATE]') = '1'
then begin
     if (Msg.wParam = WM_MOUSEMOVE) then Exit;
     if Msg.wParam = WM_MOUSEWHEEL then Exit;

     ok := MsgMouseEvent(Msg.wParam,button,EventType);
     if ok=True
     then begin
          Form1.WriteVariable('VAR','[EVENT.BUTTON]',Button);
          if EventType = 0
          then EventProcExecute('[EVENT.MOUSEDOWN]');
          if EventType = 1
          then EventProcExecute('[EVENT.MOUSEUP]');
          end;
     Exit;
     end;
if Timer1.Enabled = False then exit;


AddTime;
if Msg.wParam = WM_NCMOUSEMOVE then Exit;

GetCursorPos(Pt);
handle := WindowFromPoint(Pt);

if windows.GetWindowThreadProcessId(handle,@ProcessId) <> MainProcessId
then begin
     if (Msg.wParam = WM_MOUSEMOVE)
     then begin
          if (Pt.X = LastPos.X) and (Pt.Y = LastPos.Y) then Exit;
          TabLength := length(Parcours.x);
          SetLength(Parcours.x,TabLength+1);
          SetLength(Parcours.y,TabLength+1);
          Parcours.x[TabLength] := Pt.x;
          Parcours.y[TabLength] := Pt.y;
          LastPos := Pt;
          ProcessMessagesEx;
          end
     else  begin
           AddParcours();
           if Msg.wParam <> WM_MOUSEWHEEL
           then begin
                //Ordre.commande := 'Move Mouse';
                //Ordre.textparam := IntToStr(Pt.x) + SprPr + IntToStr(Pt.y) + SprPr + 'Direct' +SprPr;
                //Write(FileMacro,Ordre);
                Action := MsgSourisToStr(Msg.wParam);
                TraitementSouris(Action);
                LastPos := Pt;
                end
           else begin
                Ordre.commande := 'Click';
                if  Msg.lparam < 0
                then Ordre.textparam := 'Whell Down'+SprPr+'1'+SprPr
                else Ordre.textparam := 'Whell Up'+SprPr+'1'+SprPr;
                Write(FileMacro,Ordre);
                end;
          end;
     end;
end;


procedure TForm28.WMGM(var Msg: TMessage);
var Action: cardinal;
    StrKey : String;
    Key : array[1..100] of char;
    ProcActiveOrder :TActiveOrder;
    ProcIndex, ProcEnd : integer;
    i : integer;
begin

GetKeyNameText(Msg.LParam, @Key, 100);
StrKey := StrPas(@Key);

if ((Msg.lParam shr 31) and 1) = 1
then Action := 2
else if ((Msg.lParam shr 30) and 1) = 1
     then Action := 3
     else Action := 1;

if GetValue('[EVENT.ACTIVATE]') = '1'
then begin
     if Action <> 2 then Exit;
     if (GetKeyState(VK_CAPITAL) and $01) <> 0
     then Form1.WriteVariable('VAR','[EVENT.KEY]',UpperCase(StrKey))
     else Form1.WriteVariable('VAR','[EVENT.KEY]',LowerCase(StrKey));
     EventProcExecute('[EVENT.KEYPRESS]');
     Exit;
     end;
if Timer1.Enabled = False then exit;

AddTime;
AddParcours();

case Action of
     1 : begin
         if (StrKey[1] in [chr(21)..chr(175)]) and (length(StrKey) = 1)
         then begin
              LastKey := StrKey;
              Ordre.commande := 'Type';
              if (GetKeyState(VK_CAPITAL) and $01) <> 0
              then Ordre.textparam :=  UpperCase(StrKey)
              else Ordre.textparam :=  LowerCase(StrKey);
              Write(FileMacro,Ordre);
              end
         else begin
              Ordre.commande := 'Type Special';
              Ordre.textparam :=  StrKey + SprPr + '[KeyDown]' + SprPr;
              Write(FileMacro,Ordre);
              end;
         end;
     2 : begin
              if StrKey = LastKey
              then LastKey := ''
              else begin
                   Ordre.commande := 'Type Special';
                   Ordre.textparam :=  StrKey + SprPr + '[KeyUp]' + SprPr;
                   Write(FileMacro,Ordre);
                   end;
              end;
     3 : begin
         if (StrKey[1] in [chr(21)..chr(175)]) and (length(StrKey) = 1)
         then begin
              LastKey := StrKey;
              Ordre.commande := 'Type';
              if (GetKeyState(VK_CAPITAL) and $01) <> 0
              then Ordre.textparam :=  UpperCase(StrKey)
              else Ordre.textparam :=  LowerCase(StrKey);
              Write(FileMacro,Ordre);
              end
         else begin
              Ordre.commande := 'Type Special';
              Ordre.textparam :=  StrKey + SprPr;
              Write(FileMacro,Ordre);
              end;
         end;
     end;
ProcessMessagesEX;
end;


function TForm28.SecToTime(Sec : real): String;
var h,m : integer;
    intSec : integer;
begin
result := '';
IntSec := Trunc(Sec);
h := IntSec div 3600;
Sec := Sec - (h * 3600);
m := IntSec div 60;
IntSec := IntSec - (m * 60);

if h < 10 then begin result := '0' + IntToStr(h) + ':'; end
          else result := IntToStr(h) + ':';

if m < 10 then begin result := result + '0' + IntToStr(m) + ':'; end
          else result := result + IntToStr(m)+ ':';

if Sec < 10 then begin result := result + '0' + IntToStr(IntSec); end
          else result := result + IntToStr(IntSec);

end;

function TForm28.TimeToSec(Temp : String): LongInt;
var h,m,s : integer;
begin
result := 0;
if length(Temp) <> 8 then Exit;
h := StrToInt(Temp[1])*10 + StrToInt(Temp[2]);
m := StrToInt(Temp[4])*10 + StrToInt(Temp[5]);
s := StrToInt(Temp[7])*10 + StrToInt(Temp[8]);
result := (h * 3600) + (m * 60) + s;
end;

procedure TForm28.Optimisation(Macro : TListView);
var Last2Commande, LastCommande, Commande : TOrdre;
    i : integer;
    LastParam, Param : TParam;
    RightMAJDown, LeftMaJDown : String;
    RightMAJUp, LeftMaJUp : String;
    Espace : String;
    key0, key1, key2, key3, key4, key5, key6, key7, key8, key9 : String;
begin
LeftMAjDown := MdlFnct.GetVKKeyToKeyName(VK_SHIFT)+SprPr+'[KeyDown]'+SprPr;
RightMAjDown := MdlFnct.GetVKKeyExtentedToKeyName(VK_SHIFT)+SprPr+'[KeyDown]'+SprPr;
LeftMAjUp := MdlFnct.GetVKKeyToKeyName(VK_SHIFT)+SprPr+'[KeyUp]'+SprPr;
RightMAjUp := MdlFnct.GetVKKeyExtentedToKeyName(VK_SHIFT)+SprPr+'[KeyUp]'+SprPr;
Espace := MdlFnct.GetVKKeyToKeyName(VK_SPACE)+SPrPr;
key0 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD0)+SPrPr;
key1 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD1)+SPrPr;
key2 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD2)+SPrPr;
key3 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD3)+SPrPr;
key4 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD4)+SPrPr;
key5 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD5)+SPrPr;
key6 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD6)+SPrPr;
key7 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD7)+SPrPr;
key8 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD8)+SPrPr;
key9 := MdlFnct.GetVKKeyToKeyName(VK_NUMPAD9)+SPrPr;

for i := Macro.Items.Count - 1 downto 1 do
begin
     if Macro.Items[i] = nil then continue;

     Commande.commande := Macro.items.Item[i].Caption;
     Commande.textparam := Macro.items.Item[i].SubItems.Strings[0];
     LastCommande.commande := Macro.items.Item[i-1].Caption;
     LastCommande.textparam := Macro.items.Item[i-1].SubItems.Strings[0];

     if Macro.Items[i-2] <> nil
     then begin
          Last2Commande.commande := Macro.items.Item[i-2].Caption;
          Last2Commande.textparam := Macro.items.Item[i-2].SubItems.Strings[0];
          end
     else begin
          Last2Commande.commande := '';
          Last2Commande.textparam := '';
          end;

     if (Commande.commande = 'Click') and (Commande.textparam = 'Left Up'+SprPr) and
        (LastCommande.commande = 'Click') and (LastCommande.textparam = 'Left Down'+SprPr)
     then  begin
           Macro.items.Item[i].SubItems.Strings[0] := 'Left click'+SprPr;
           Macro.items.Item[i-1].Delete;
           continue;
           end;
     if (Commande.commande = 'Click') and (Commande.textparam = 'Right Up'+SprPr) and
        (LastCommande.commande = 'Click') and (LastCommande.textparam = 'Right Down'+SprPr)
     then  begin
           Macro.items.Item[i].SubItems.Strings[0] := 'Right click'+SprPr;
           Macro.items.Item[i-1].Delete;
           continue;
           end;
     if (Commande.commande = 'Click') and (Commande.textparam = 'Middle Up'+SprPr) and
        (LastCommande.commande = 'Click') and (LastCommande.textparam = 'Middle Down'+SprPr)
     then  begin
           Macro.items.Item[i].SubItems.Strings[0] := 'Middle click'+SprPr;
           Macro.items.Item[i-1].Delete;
           continue;
           end;

     if (Commande.commande = 'Pause') and (LastCommande.commande = 'Pause')
     then  begin
           Macro.items.Item[i].SubItems.Strings[0] := SecToTime(TimeToSec(Commande.textparam) + TimeToSec(LastCommande.textparam)) ;
           Macro.items.Item[i-1].Delete;
           continue;
           end;

     if (LastCommande.commande = 'Pause') and (Lastcommande.textparam = '00:00:00')
           then begin
                Macro.items.Item[i-1].Delete;
                continue;
                end;
     if (Commande.commande = 'Move Mouse') and (LastCommande.commande = 'Parcours souris')
     then begin
          if length(Macro.items.Item[i-1].SubItems.Strings[0]) < 240
          then begin
               Param := form1.GetParam(Commande.textparam);
               Macro.items.Item[i-1].SubItems.Strings[0] := Macro.items.Item[i-1].SubItems.Strings[0] +
               Param.param[1] + SprPr + Param.param[2] + SprPr;
               Macro.items.Item[i].Delete;
               continue;
               end;
          end;
     // Test sur un paramètre particulier
     LastParam := form1.GetParam(LastCommande.textparam);
     Param := form1.GetParam(Commande.textparam);
     // ************************************************** //
     if (Commande.commande = 'Click') and (Param.param[1] = 'Whell Up') and
        (LastCommande.commande = 'Click') and (LastParam.param[1] = 'Whell Up')
     then  begin
           Macro.items.Item[i].SubItems.Strings[0] := 'Whell Up'+SprPr+ IntToStr(StrToInt(Param.param[2]) + StrToInt(LastParam.param[2]))+SprPr;
           Macro.items.Item[i-1].Delete;
           continue;
           end;

     if (Commande.commande = 'Click') and (Param.param[1] = 'Whell Down') and
        (LastCommande.commande = 'Click') and (LastParam.param[1] = 'Whell Down')
     then  begin
           Macro.items.Item[i].SubItems.Strings[0] := 'Whell Down'+SprPr+ IntToStr(StrToInt(Param.param[2]) + StrToInt(LastParam.param[2]))+SprPr;
           Macro.items.Item[i-1].Delete;
           continue;
           end;

     if (Commande.commande = 'Type Special') and (LastCommande.commande = 'Type Special')
     then begin
          if (LastParam.nbr_param = 3) and (Param.nbr_param = 3)
          then if LastParam.param[1] = Param.param[1]
               then if (LastParam.param[2] = '[KeyDown]') and (Param.param[2] = '[KeyUp]')
                    then begin
                         Macro.items.Item[i-1].SubItems.Strings[0] := Param.param[1] + SprPr;
                         Macro.items.Item[i].Delete;
                         end;
          end;

      if (Commande.commande = 'Type Special') and (LastCommande.commande = 'Type') and (Last2Commande.commande = 'Type Special')
      then begin
           if ((Commande.textparam = LeftMajUp) and  (Last2Commande.textparam = LeftMajDown)) or
              ((Commande.textparam = RightMajUp) and  (Last2Commande.textparam = RightMajDown))
           then if length(LastCommande.textparam) = 1
                then if UpperCase(LastCommande.textparam) = LastCommande.textparam
                     then begin
                          Macro.items.Item[i-1].SubItems.Strings[0] := LowerCase(LastCommande.textparam);
                          Macro.items.Item[i].Delete;
                          Macro.items.Item[i-2].Delete;
                          end
                     else begin
                          Macro.items.Item[i-1].SubItems.Strings[0] := UpperCase(LastCommande.textparam);
                          Macro.items.Item[i].Delete;
                          Macro.items.Item[i-2].Delete;
                          end;
           end;

     if (Commande.commande = 'Type Special')
     then begin
          if Commande.textparam = Espace then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := ' '; end;
          if Commande.textparam = key0 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '0'; end;
          if Commande.textparam = key1 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '1'; end;
          if Commande.textparam = key2 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '2'; end;
          if Commande.textparam = key3 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '3'; end;
          if Commande.textparam = key4 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '4'; end;
          if Commande.textparam = key5 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '5'; end;
          if Commande.textparam = key6 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '6'; end;
          if Commande.textparam = key7 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '7'; end;
          if Commande.textparam = key8 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '8'; end;
          if Commande.textparam = key9 then begin Macro.items.Item[i].Caption := 'Type'; Macro.items.Item[i].SubItems.Strings[0] := '9'; end;
          end;

end;

for i := Macro.Items.Count - 1 downto 1 do
begin
     if Macro.Items[i] = nil then continue;
     Commande.commande := Macro.items.Item[i].Caption;
     Commande.textparam := Macro.items.Item[i].SubItems.Strings[0];
     LastCommande.commande := Macro.items.Item[i-1].Caption;
     LastCommande.textparam := Macro.items.Item[i-1].SubItems.Strings[0];
     if (Commande.commande = 'Type') and (LastCommande.commande = 'Type')
     then begin
          Macro.items.Item[i-1].SubItems.Strings[0] := Macro.items.Item[i-1].SubItems.Strings[0] + Macro.items.Item[i].SubItems.Strings[0];
          Macro.items.Item[i].Delete;
          end;
end;

end;

procedure TForm28.Timer1Timer(Sender: TObject);
begin
if Clignote = False
then begin
//     ForeGroundWin;
     Timer1.Interval := 200;
     if Image1.Visible = False then Image1.Visible := True;
     PosK7 := PosK7 + 10;
     if PosK7 > 290 then PosK7 := 176;
     Image1.Left := PosK7;
     //if Temp < 2
     //then Temp := Temp + 0.5
     //else Temp := Temp +0.2;
     end
else begin
     Timer1.Interval := 500;
     Image1.Visible := not Image1.Visible;
     end;
ProcessMessagesEx;
end;

procedure TForm28.SpeedButton3Click(Sender: TObject);
begin
try
SpeedButton1.Enabled := True;
SpeedButton2.Enabled := False;
SpeedButton3.Enabled := False;
Button1.Enabled := True;
Button2.Enabled := True;
timer1.Enabled := False;
Form1.WindowState := StateForm1;
AddParcours;
SetLength(Parcours.X,0);
SetLength(Parcours.Y,0);

finally Hook.MUnsetHook;
        Hook.UnsetHook;
        if clignote = False then CloseFile(FileMacro);
        Clignote := False;
        end;

end;

procedure TForm28.SpeedButton1Click(Sender: TObject);
var FileName : String;
    Ok : Boolean;
    TailleFichier : integer;
begin

Ok := True;
FileName := ExtractFileDir(Application.ExeName) + '\temp.sqc';
MainProcessId := GetWindowThreadProcessId(Application.Handle,@ProcessId);

TailleFichier := 0;
if FileExists(FileName)
then begin
     AssignFile(FileMacro,FileName);
     reset(FileMacro);
     try
     TailleFichier := FileSize(FileMacro);
     finally closeFile(FileMacro); end;
     end;

if (FileExists(FileName) = True) and (Clignote = False) and ( TailleFichier <> 0)
then if MessageDlg('Voulez vous réellement ignorer l''ancienne séquence ?',mtConfirmation, [mbYes, mbNo], 0) = mrNo
     then Ok := False;

if Ok = True
then begin
     Clignote := False;
     Temp := GetTickCount;
     timer1.Enabled := True;
     SpeedButton1.Enabled := False;
     SpeedButton2.Enabled := True;
     SpeedButton3.Enabled := True;
     Button1.Enabled := False;
     Button2.Enabled := False;
     StateForm1 := Form1.WindowState;
     Form1.WindowState := wsMinimized;
     //
     AssignFile(FileMacro,FileName);
     if Clignote = False
     then rewrite(FileMacro)
     else reset(FileMacro);

     if checkBox3.Checked = false
     then begin
          Ordre.commande := 'Variable';
          Ordre.textparam := '[HANDLE.FOREGROUNDWINDOW];0;Numerique;';
          Write(FileMacro,Ordre);
          end;
     Timer1.Enabled := True;
     Hook.MSetMainHandle(Handle);
     if not Hook.MSetHook then showmessage('Capture des événements souris impossible.');
     Hook.SetMainHandle(Handle);
     if not Hook.SetHook then showmessage('Capture des événement clavier impossible.');
     end;
end;

procedure TForm28.SpeedButton2Click(Sender: TObject);
begin
clignote := True;
SpeedButton1.Enabled := True;
SpeedButton2.Enabled := False;
SpeedButton3.Enabled := True;

CloseFile(FileMacro);
Hook.MUnsetHook;
Hook.UnsetHook;
end;

procedure TForm28.FormClose(Sender: TObject; var Action: TCloseAction);
var FileName : String;
begin
FileName := ExtractFileDir(Application.ExeName) + '\temp.sqc';
if FileExists(FileName) then DeleteFile(FileName);
Timer1.Enabled := False;
Clignote := False;
end;

procedure TForm28.FormShow(Sender: TObject);
begin
SpeedButton1.Enabled := True;
SpeedButton2.Enabled := False;
SpeedButton3.Enabled := False;
end;

procedure TForm28.FormCreate(Sender: TObject);
var MyHandle : cardinal;
    Dir : String;
    DllOk : Boolean;
begin
AllIsOk := True;
TransformTimageToWizard(Image2);
Dir := ExtractFileDir(Application.ExeName);
Dir := Dir + '\';
DllOk := True;

if Form1.Authen(ExtractFileDir(Application.ExeName)+'\Souris_Hook.dll') <> 1 then begin AllIsOk := False; form1.Enregistrerunesequence1.Enabled := False; Exit; end;
if Form1.Authen(ExtractFileDir(Application.ExeName)+'\Clavier_Hook.dll') <> 1 then begin AllIsOk := False;form1.Enregistrerunesequence1.Enabled := False; Exit; end;

MyHandle := loadlibrary(Pchar(Dir+'Souris_Hook.dll'));
if MyHandle <> 0
then begin
     Hook.MSetHook := GetProcAddress(MyHandle, 'MSetHook');
     if @Hook.MSetHook = nil
     then begin ShowMessage('MSetHook no found.'); DllOk := False; end;
     Hook.MUnSetHook := GetProcAddress(MyHandle, 'MUnSetHook');
     if @Hook.MUnSetHook = nil
     then begin ShowMessage('MUnSetHook no found.'); DllOk := False; end;
     Hook.MSetMainHandle := GetProcAddress(MyHandle, 'MSetMainHandle');
     if @Hook.MSetMainHandle = nil
     then begin ShowMessage('MSetMainHandle no found.'); DllOk := False; end;
     end
else DllOk := False;

MyHandle := loadlibrary(Pchar(Dir+'Clavier_Hook.dll'));
if MyHandle <> 0
then begin
     Hook.SetHook := GetProcAddress(MyHandle, 'SetHook');
     if @Hook.SetHook = nil
     then begin ShowMessage('SetHook no found.'); DllOk := False; end;
     Hook.UnSetHook := GetProcAddress(MyHandle, 'UnSetHook');
     if @Hook.UnSetHook = nil
     then begin ShowMessage('UnSetHook no found.'); DllOk := False; end;
     Hook.SetMainHandle := GetProcAddress(MyHandle, 'SetMainHandle');
     if @Hook.SetMainHandle = nil
     then begin ShowMessage('SetMainHandle no found.'); DllOk := False; end;
     end
else DllOk := False;

AllIsOk := DllOk;
form1.Enregistrerunesequence1.Enabled := AllIsOk;

Form28.Top := Screen.Height - Form28.Height - 30;
Form28.Left := Screen.Width - Form28.Width - 5;
end;

procedure TForm28.Button3Click(Sender: TObject);
begin
Optimisation(Form1.ListView1);
end;

function TForm28.MsgSourisToStr(messag: Cardinal): string;
begin
  case Messag of

    WM_lButtonDown      : result := 'Left Down'+SprPr;
    WM_LBUTTONDBLCLK    : result := 'Left Down'+SprPr;
    WM_LBUTTONUP        : result := 'Left Up'+SprPr;
    WM_NCLBUTTONDBLCLK  : result := 'Left Down'+SprPr;
    WM_NCLBUTTONDOWN    : result := 'Left Down'+SprPr;    WM_NCLBUTTONUP      : result := 'Left Up'+SprPr;

    WM_RButtonDown      : result := 'Right Down'+SprPr;
    WM_RBUTTONDBLCLK    : result := 'Right Down'+SprPr;
    WM_RBUTTONUP        : result := 'Right Up'+SprPr;
    WM_NCMBUTTONDBLCLK  : result := 'Right Down'+SprPr;
    WM_NCMBUTTONDOWN    : result := 'Right Down'+SprPr;    WM_NCMBUTTONUP      : result := 'Right Up'+SprPr;
    WM_MButtonDown      : result := 'Middle Down'+SprPr;
    WM_MBUTTONDBLCLK    : result := 'Middle Down'+SprPr;
    WM_MBUTTONUP        : result := 'Middle Up'+SprPr;
    WM_NCRBUTTONDBLCLK  : result := 'Middle Down'+SprPr;    WM_NCRBUTTONDOWN    : result := 'Middle Down'+SprPr;    WM_NCRBUTTONUP      : result := 'Middle Up'+SprPr;  else
    result := 'Other';
  end
end;

function TForm28.MsgMouseEvent(messag: Cardinal; var Button : string; var Action : cardinal) : Boolean;
begin
result := True;
  case Messag of

    WM_lButtonDown      : begin button := 'Left'; Action := 0; end;
//    WM_LBUTTONDBLCLK    : begin button := 'Left'; Action := 0; end;
    WM_LBUTTONUP        : begin button := 'Left'; Action := 1; end;

    WM_RButtonDown      : begin button := 'Right'; Action := 0; end;
//    WM_RBUTTONDBLCLK    : begin button := 'Right'; Action := 0; end;
    WM_RBUTTONUP        : begin button := 'Right'; Action := 1; end;

    WM_MButtonDown      : begin button := 'Middle'; Action := 0; end;
//    WM_MBUTTONDBLCLK    : begin button := 'Middle'; Action := 0; end;
    WM_MBUTTONUP        : begin button := 'Middle'; Action := 1; end;
  else    begin result := False; Button := ''; Action := 2; end;
  end
end;

procedure TForm28.TraitementSouris(Button : String);
var pt : Tpoint;
begin
GetCursorPos(Pt);
if (Pt.x <> LastPos.x) or (Pt.y <> LastPos.y)
then begin
     Ordre.commande := 'Move Mouse';
     Ordre.textparam := IntToStr(Pt.x) +';'+ IntToStr(Pt.Y) +';Indirect;';
     Write(FileMacro,Ordre);
     end;

if button <> 'Other'
then begin
     ForegroundWin;
     Ordre.commande := 'Click';
     Ordre.textparam := Button;
     Write(FileMacro,Ordre);
     ForegroundWin;
     end;
end;

procedure TForm28.Button1Click(Sender: TObject);
var FileName : String;
    Macro : TListView;
    NewColumn: TListColumn;
    i,j : integer;
    LastCoor : Tpoint;
begin
FileName := ExtractFileDir(Application.ExeName) + '\temp.sqc';

if FileExists(FileName)
then begin
     assignfile(FileMacro,FileName);
     reset(FileMacro);
     Form1.ListView4.items.add();

     Macro := TListView.Create(form28);
     try
     form28.Visible := False;
     Macro.Parent := form28;
     Macro.Align := alClient;
     Macro.ViewStyle := vsReport;
     NewColumn := Macro.Columns.Add;
     NewColumn.Caption := 'Commande';
     NewColumn := Macro.Columns.Add;
     NewColumn.Caption := 'Paramètres';
     Macro.LargeImages := Form1.ImageList1;
     Macro.SmallImages := Form1.ImageList1;
     Macro.StateImages := Form1.ImageList1;

     Form1.OpenFileMacro(FileName,Macro, 0,'Préparation de la séquence d''enregistrement, veuillez patienter SVP.');
     if form28.CheckBox1.Checked then  Optimisation(Macro);
     if Macro.items.Count > 1 then Form1.AddHistory(0,'Début d''actions groupées','','');
     for i := 0 to Macro.items.Count-1
     do begin
        if (form28.Edit1.Text <> '0') and (Macro.items[i].Caption = 'Pause')
        then begin
             j := TimeTosec(Macro.items[i].SubItems[0]) + strtoint(form28.Edit1.Text);
             if j <= 0 then continue else Macro.items[i].SubItems[0] := sectotime(j);
             end;
        if (Form28.CheckBox2.checked = True) and (Macro.items[i].Caption = 'Parcours souris')
        then begin
             if i < Macro.items.Count-2
             then begin
                  if Macro.items[i+1].Caption = 'Parcours souris'
                  then continue
                  else begin
                       LastCoor := GetLastCoor(Macro.items[i].SubItems[0]);
                       Macro.items[i].Caption := 'Move Mouse';
                       Macro.items[i].SubItems[0] := IntToStr(LastCoor.x) + SprPr + IntToStr(LastCoor.y) + SprPr + 'Indirect'+ SprPr;
                       end;
                  end
             else begin
                  LastCoor := GetLastCoor(Macro.items[i].SubItems[0]);
                  Macro.items[i].Caption := 'Move Mouse';
                  Macro.items[i].SubItems[0] := IntToStr(LastCoor.x) + SprPr + IntToStr(LastCoor.y) + SprPr + 'Indirect'+ SprPr;
                  end;
             end;
        Ordre.commande := Macro.items[i].Caption;
        Ordre.textParam := Macro.items[i].SubItems[0];
        Form1.add_insert(Ordre.commande,Ordre.textParam,form1.getimageindex(Ordre));
        end;
     if Macro.items.Count > 1 then Form1.AddHistory(0,'Fin d''actions groupées','','');
     Form1.OneVarOnly('[HANDLE.FOREGROUNDWINDOW]');
     finally Macro.free; form28.Visible := True; end;
     end;
end;

procedure TForm28.Button2Click(Sender: TObject);
var FileName : String;
begin
FileName := ExtractFileDir(Application.ExeName) + '\temp.sqc';
if FileExists(FileName)
then begin
     If SaveDialog1.Execute
     then CopyFile(PChar(FileName),PChar(SaveDialog1.FileName),false)
     end;
end;

procedure TForm28.Label3Click(Sender: TObject);
begin
CheckBox1.checked := not CheckBox1.checked;
end;

procedure TForm28.Label9Click(Sender: TObject);
begin
CheckBox2.checked := not CheckBox2.checked;
end;

procedure TForm28.Label10Click(Sender: TObject);
begin
CheckBox3.checked := not CheckBox3.checked;
end;

end.


