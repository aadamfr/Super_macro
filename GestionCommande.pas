unit GestionCommande;

interface
uses unit1, unit4, unit19, Dialogs, windows, ComCtrls, Buttons, Controls, Graphics, Forms, sysutils,
     StdCtrls, ExtCtrls, IniFiles;

function AddOrder(DllOrdre : Pchar) : integer;
procedure FnctExecuteOrder(Commande, Params : String);

type
TReceiveHandleApp = procedure (Handle : Hwnd); StdCall;
TReceiveHandleLibrary = procedure(Handle : Hwnd); StdCall;
TGetInfoFromSMacro = procedure (Info, PcharValue : PChar; IntegerValue : integer ;correct : boolean); StdCall;
TGetInfoName = function() : PChar; StdCall;
TGetInfoRubrique = function () : PChar ; StdCall;
TGetInfoHint = function () : PChar ; StdCall;
TGetInfoDescription = function () : PChar ; StdCall;
TGetInfoIcon = function () : hIcon ; StdCall;
TDebug = function (Params : Pchar) : Boolean; StdCall;
TMsgDebug = function (Params : Pchar) : PChar; StdCall;
TNewOrdre = function () : Pchar; StdCall;
TChangeOrdre = function (Params : Pchar) : Pchar; StdCall;
TExecuteOrder = procedure (Params : Pchar); StdCall;
TStopOrder = procedure (); StdCall;
TGetListOrder = procedure (Order, params : PChar; correct : boolean); StdCall;

TDynamiqueOrder = record
  Name : String;
  Rubrique : String;
  Hint : String;
  Description : String;
  Icon : hicon;
  IconIndex : integer;
  index : integer;
  dllName : String;
  Handle : hwnd;
  PointerSbtn : Pointer;
  ReceiveHandleApp : TReceiveHandleApp;
  ReceiveHandleLibrary : TReceiveHandleLibrary;
  GetInfoFromSMacro : TGetInfoFromSMacro;
  GetListOrder : TGetListOrder;
  GetInfoName : TGetInfoName;
  GetInfoRubrique : TGetInfoRubrique;
  GetInfoHint : TGetInfoHint;
  GetInfoDescription : TGetInfoDescription;
  GetInfoIcon : TGetInfoIcon;
  Debug : TDebug;
  MsgDebug : TMsgDebug;
  NewOrdre : TNewOrdre;
  ExecuteOrder : TExecuteOrder;
  StopOrder : TStopOrder;
  ChangeOrdre : TChangeOrdre;
  end;

//const  Max_newOrder = 30;

var DynOrder : array of TDynamiqueOrder;
    ImageList : TImageList;
    Icon : TIcon;
    Bitmap : TBitMap;
    PLUGIN_CANCEL_NEW_OR_CHANGE_ORDER : Boolean;

implementation

procedure GetInfoFromSMacroVirtual(Info, PcharValue : PChar; IntegerValue : integer ;correct : boolean); StdCall;
begin
ShowMessage('Envois à :' + InttoStr(DynOrder[0].Handle) + ', info : ' + PcharValue +' et '+ InttoStr(IntegerValue));
SendMessage(DynOrder[0].Handle,WM_PLUGIN_MSG,integer(PcharValue),IntegerValue);
end;

procedure GetListOrderVirtual(Order, params : PChar; correct : boolean); StdCall;
begin
SendMessage(DynOrder[0].Handle,WM_PLUGIN_MSG,integer(Order),Integer(params));
end;

function AddOrder(DllOrdre : Pchar): integer;
var
  Handle: THandle;
  newpos,i : integer;
  Ok : Boolean;
  TabSheet : TTabSheet;
  SpeedButton : TSpeedButton;
  dllok : Boolean;
  ComponentPlus : integer;
  RepOrg,RepPlug : string;
begin
result := -1;

dllok := True;
SetLength(DynOrder,length(DynOrder)+1);
newpos := length(DynOrder)-1;

// test si le fichier plugin existe, si pas le cas test Origine, puis Origine/Plugins
RepOrg := ExtractFileDir(application.ExeName)+'\'+ExtractFileName(DllOrdre);
RepPlug := ExtractFileDir(application.ExeName)+'\Plugins\'+ExtractFileName(DllOrdre);
if not FileExists(DllOrdre) then DllOrdre := Pchar(RepOrg);
if not FileExists(DllOrdre) then DllOrdre := Pchar(RepPlug);
if not FileExists(DllOrdre)
then begin ShowMessage(DllOrdre + ' not found.'); Exit; end;

Handle := LoadLibrary(DllOrdre);
DynOrder[newpos].dllName := DllOrdre;

if Handle <> 0
then begin
     DynOrder[newpos].Handle := Handle;
     @DynOrder[newpos].ReceiveHandleApp := GetProcAddress(Handle, 'ReceiveHandleApp');
     if @DynOrder[newpos].ReceiveHandleApp <> nil
     then DynOrder[newpos].ReceiveHandleApp(Form1.Handle)
     else begin ShowMessage('ReceiveHandleApp no found.'); dllok := False; end;

     @DynOrder[newpos].ReceiveHandleLibrary := GetProcAddress(Handle, 'ReceiveHandleLibrary');
     if @DynOrder[newpos].ReceiveHandleLibrary <> nil
     then DynOrder[newpos].ReceiveHandleLibrary(Handle)
     else begin ShowMessage('ReceiveHandleLibrary no found.'); dllok := False; end;

     @DynOrder[newpos].GetInfoName := GetProcAddress(Handle, 'GetInfoName');
     if @DynOrder[newpos].GetInfoName <> nil
     then DynOrder[newpos].name := DynOrder[newpos].GetInfoName
     else begin ShowMessage('GetInfoName no found.'); dllok := False; end;

     @DynOrder[newpos].GetInfoRubrique := GetProcAddress(Handle, 'GetInfoRubrique');
     if @DynOrder[newpos].GetInfoRubrique <> nil
     then DynOrder[newpos].Rubrique := DynOrder[newpos].GetInfoRubrique
     else begin ShowMessage('GetInfoRubrique no found.'); dllok := False; end;

     @DynOrder[newpos].GetInfoHint := GetProcAddress(Handle, 'GetInfoHint');
     if @DynOrder[newpos].GetInfoHint <> nil
     then DynOrder[newpos].Hint := DynOrder[newpos].GetInfoHint
     else begin ShowMessage('GetInfoHint no found.'); dllok := False; end;

     @DynOrder[newpos].GetInfoDescription := GetProcAddress(Handle, 'GetInfoDescription');
     if @DynOrder[newpos].GetInfoDescription <> nil
     then DynOrder[newpos].Description := DynOrder[newpos].GetInfoDescription
     else begin ShowMessage('GetInfoDescription no found.'); dllok := False; end;

     @DynOrder[newpos].GetInfoIcon := GetProcAddress(Handle, 'GetInfoIcon');
     if @DynOrder[newpos].GetInfoIcon <> nil
     then DynOrder[newpos].Icon := DynOrder[newpos].GetInfoIcon
     else begin ShowMessage('GetInfoIcon no found.'); dllok := False; end;

     @DynOrder[newpos].GetInfoFromSMacro := GetProcAddress(Handle, 'GetInfoFromSMacro');
     if @DynOrder[newpos].GetInfoFromSMacro = nil then begin ShowMessage('GetInfoFromSMacro no found.'); dllok := False; end;
     @DynOrder[newpos].GetListOrder := GetProcAddress(Handle, 'GetListOrder');
     if @DynOrder[newpos].GetListOrder = nil then begin ShowMessage('GetListOrder no found.'); dllok := False; end;
     @DynOrder[newpos].Debug := GetProcAddress(Handle, 'Debug');
     if @DynOrder[newpos].Debug = nil then begin ShowMessage('Debug no found.'); dllok := False; end;
     @DynOrder[newpos].MsgDebug := GetProcAddress(Handle, 'MsgDebug');
     if @DynOrder[newpos].MsgDebug = nil then begin ShowMessage('MsgDebug no found.'); dllok := False; end;
     @DynOrder[newpos].NewOrdre := GetProcAddress(Handle, 'NewOrdre');
     if @DynOrder[newpos].NewOrdre = nil then begin ShowMessage('NewOrdre no found.'); dllok := False; end;
     @DynOrder[newpos].ExecuteOrder := GetProcAddress(Handle, 'ExecuteOrder');
     if @DynOrder[newpos].ExecuteOrder = nil then begin ShowMessage('ExecuteOrder no found.'); dllok := False; end;
     @DynOrder[newpos].StopOrder := GetProcAddress(Handle, 'StopOrder');
     if @DynOrder[newpos].StopOrder = nil then begin ShowMessage('StopOrder no found.'); dllok := False; end;
     @DynOrder[newpos].ChangeOrdre := GetProcAddress(Handle, 'ChangeOrdre');
     if @DynOrder[newpos].ChangeOrdre = nil then begin ShowMessage('ChangeOrdre no found.'); dllok := False; end;

     // Avant de créer le bouton test si le fichier dll est valide
     if dllok = False then begin DynOrder[newpos].name := ''; Exit; end;

     // vérification si la rubriques existe
     Ok := False;
     for i := 0 to form1.PageControl2.PageCount-1
     do if form1.PageControl2.Pages[i].Caption = DynOrder[newpos].Rubrique
        then begin Ok := True; break; end;
     // création de la rubrique si n'existe pas
     if Ok = False
     then begin
          TabSheet := TTabSheet.create(Form1.PageControl2);
          TabSheet.Parent := Form1.PageControl2;
          TabSheet.PageControl := Form1.PageControl2;
          TabSheet.TabVisible := True;
          TabSheet.caption := DynOrder[newpos].Rubrique;
          end
     else TabSheet := form1.PageControl2.Pages[i];

     // Création du Bouton de commande
     SpeedButton := TSpeedButton.Create(TabSheet);
     SpeedButton.Parent := TabSheet;
     SpeedButton.Height := Form1.SpeedButton1.Height ; SpeedButton.Width := Form1.SpeedButton1.Width;
     ComponentPlus := 0;
     if TabSheet.Caption = 'Standard' then ComponentPlus := 10;
     if TabSheet.Caption = 'Supplément' then ComponentPlus := 14;
     SpeedButton.Top := Form1.SpeedButton1.Top ; SpeedButton.Left := (Form1.SpeedButton2.Left - Form1.SpeedButton1.Left- Form1.SpeedButton1.Width) + ((TabSheet.ComponentCount-1 + ComponentPlus) * (Form1.SpeedButton2.Left - Form1.SpeedButton1.Left));
     SpeedButton.Hint := DynOrder[newpos].Hint;
     SpeedButton.ShowHint := True;
     SpeedButton.Tag := newpos;
     SpeedButton.Transparent := False;
     DynOrder[newpos].PointerSbtn := SpeedButton;
     if XPMenu1.Active = True
     then XPMenu1.InitComponent(SpeedButton);

     Icon := TIcon.Create;
     Bitmap := TBitmap.Create;
     try
     if DynOrder[newpos].Icon <> 0
     then begin
          Icon.Handle := DynOrder[newpos].Icon;
          Bitmap.Handle := DynOrder[newpos].Icon;
          if CopyImage(DynOrder[newpos].Icon,IMAGE_ICON,0,0,LR_COPYRETURNORG) <> 0
          then DynOrder[newpos].IconIndex := Form1.ImageList1.AddIcon(Icon)
          else DynOrder[newpos].IconIndex := Form1.ImageList1.Add(Bitmap,nil);

          //SpeedButton.Glyph.Width := icon.Width;
          //SpeedButton.Glyph.Height := icon.Height;
          form1.ImageList1.GetBitmap(DynOrder[newpos].IconIndex,SpeedButton.Glyph);
          end
     else begin
          form1.ImageList3.GetBitmap(31,SpeedButton.Glyph);
          DynOrder[newpos].IconIndex := Form1.ImageList1.Add(SpeedButton.Glyph,nil);
          end;
     finally icon.Free; Bitmap.Free; end;

     SpeedButton.OnClick := Form1.OnclickNewOrder;
     end
     else ShowMessage('Le dll séléctionné n''est pas une nouvelle commande valide. ('+DllOrdre+')');
result := newpos;
end;

procedure FnctExecuteOrder(Commande, Params : String);
var pos : integer;
begin
try
  pos := Form1.GetNewOrderIndex(Commande);
  if pos = -1 then Exit;
  DynOrder[pos].ExecuteOrder(Pchar(Params));
except on E: Exception do Form1.ErrorComportement(E.Message); end;
end;

begin
Setlength(DynOrder,0);
end.
