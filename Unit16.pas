unit Unit16;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ImgList, ComCtrls, Buttons, CheckLst, StrUtils,
  mdlfnct,IniFiles,ShellAPI,
  Unit1,unit19,VisualEffect;

type TCmObjet = record
     Handle : LongInt;
     ParentHandle : LongInt;
     Module : String;
     Classe : String;
     Texte : String;
     Long : integer;
     Larg : integer;
     SelHandle : Boolean;
     SelParentHandle : Boolean;
     SelModule : Boolean;
     SelClasse : Boolean;
     SelTexte : Boolean;
     SelLong : Boolean;
     SelLarg : Boolean;
     SelList : word;
     NoFound : integer;
     MoreFound : integer;
     Varobjcount : string;
     Varindex : string;
     end;

const ObjMax = 48;
type TListComObj = record
     Count : integer;
     Items : array[1..ObjMax] of TCmObjet;
     end;

type
  TForm16 = class(TForm)
    ImageList1: TImageList;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Bevel1: TBevel;
    Image1: TImage;
    Panel1: TPanel;
    Splitter2: TSplitter;
    TabSheet2: TTabSheet;
    CheckListBox1: TCheckListBox;
    TabSheet3: TTabSheet;
    Bevel2: TBevel;
    ComboBox1: TComboBox;
    Label3: TLabel;
    ComboBox2: TComboBox;
    Label4: TLabel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    ComboBox3: TComboBox;
    TabSheet4: TTabSheet;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit4: TEdit;
    Label8: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label12: TLabel;
    Panel2: TPanel;
    TreeView1: TTreeView;
    Label13: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    SpeedButton1: TSpeedButton;
    Button4: TButton;
    Button5: TButton;
    Label11: TLabel;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image2: TImage;
    procedure PrcRun(Sender: TObject);
    procedure PrcStop(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SpeedButton2Click(Sender: TObject);
    procedure TabSheet3Show(Sender: TObject);
    procedure CheckListBox1ClickCheck(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure Button3Click(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure RadioGroup2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);

  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  procedure ListComObjInit(var Obj : TCmObjet);
  procedure ListComObjInitAll();
  procedure DrawIntoTreeView();
  function AddObject(ObjHandle : Hwnd): Boolean;
  procedure SaveComportement();
  procedure LoadComportement();
  function Fnct_FindObject(CmObjet : TCmObjet):HWND; overload;
  procedure Fnct_FindObject(List : TListView; Index : Integer); overload;
  procedure SortObjectParent(Hwnd : HWND);
  procedure SortObjectModule(Str : String);
  procedure SortObjectClass(Str : String);
  procedure SortObjectText(Str : String);
  procedure SortObjectLong(Long : Integer);
  procedure SortObjectLarg(Larg : Integer);

  function FindModule(Str : string) : TTreeNode;
  function FindNode(Node : TTreeNode; Str :string): TTreeNode;
  function FindObjet(Str :string; Select : Boolean): TTreeNode;
  //procedure Timer1Proc (uHwnd : HWND; u,w : UINT; dwtime : DWORD);
  end;

var
  Form16: TForm16;
  SpyRunCapture : boolean = False;
  pt: Tpoint;
  Old_handle : hWNd;
  ListComObj : TListComObj;
  ObjIndex : integer = 0;
  NoChangeCmpt : Boolean = False;
  ListHwnd : TStringList;
  min, max : integer;
  SaveCursor : HIcon;
  CmObjet : TCmObjet;
  IDC_TIMER1 : HWND = 0;
  VisualEffectObjX : integer;
  VisualEffectObjY : integer;

function EnumWindowsCallback(hWnd: HWND; lParam: LPARAM): BOOL;stdcall;
function EnumChildCallback(hWnd: HWND; lParam: LPARAM): BOOL;stdcall;

implementation

uses Unit17,UBackGround,ContextOfExecute, Unit8;

{$R *.DFM}

procedure TForm16.MessageAide(var msg:TMessage);
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

function EnumChildCallBack(hWnd: HWND; lParam: LPARAM): BOOL;
begin
ListHwnd.Add(InttoStr(hWnd));
result:=True;
end;

function EnumWindowsCallback(hWnd: HWND; lParam: LPARAM): BOOL;
begin
if Cmobjet.SelModule = True
then if GetWindowModuleFileName(hwnd) <> CmObjet.Module
     then Exit;

ListHwnd.Add(InttoStr(hWnd));
EnumChildWindows(Hwnd,@EnumChildCallBack,0);
result:=true;
end;

procedure TForm16.SortObjectParent(Hwnd : Hwnd);
var i : integer;
begin
for i := ListHwnd.Count -1 downto 0
do if GetParent(StrToint(ListHwnd.Strings[i])) <> Hwnd
   then ListHwnd.Delete(i);
end;

procedure TForm16.SortObjectModule(Str : String);
var i : integer;
begin
for i := ListHwnd.Count -1 downto 0
do if GetWindowModuleFileName(StrToint(ListHwnd.Strings[i])) <> Str
   then ListHwnd.Delete(i);
end;

procedure TForm16.SortObjectClass(Str : String);
var i,j : integer;
    Text, ClassName : String;
begin
j := Pos(':',Str);
if j <> 0
then Text := Copy(Str,0,j-1)
else Text := Str;

for i := ListHwnd.Count -1 downto 0
do begin
   ClassName := Donne_class(StrToInt(ListHwnd.Strings[i]));
   j := Pos(':',ClassName);
   if j <> 0
   then ClassName := Copy(ClassName,0,j-1);
   if  ClassName <> Text
   then ListHwnd.Delete(i);
   end;

{for i := ListHwnd.Count -1 downto 0
do if Donne_class(StrToInt(ListHwnd.Strings[i])) <> Str
   then ListHwnd.Delete(i);
}
end;

procedure TForm16.SortObjectText(Str : String);
var i : integer;
begin
for i := ListHwnd.Count -1 downto 0
do if mdlfnct.gettext(StrToInt(ListHwnd.Strings[i])) <> Str
   then ListHwnd.Delete(i);
end;

procedure TForm16.SortObjectLong(Long : Integer);
var i : integer;
    Dim : Trect;
begin
for i := ListHwnd.Count -1 downto 0
do begin
   GetWindowRect(StrToInt(ListHwnd.Strings[i]),Dim);
   if Dim.Right - Dim.Left <> Long
   then ListHwnd.Delete(i);
   end;
end;

procedure TForm16.SortObjectLarg(Larg : Integer);
var i : integer;
    Dim : Trect;
begin
for i := ListHwnd.Count -1 downto 0
do begin
   GetWindowRect(StrToInt(ListHwnd.Strings[i]),Dim);
   if Dim.Bottom - Dim.Top <> Larg
   then ListHwnd.Delete(i);
   end;
end;

function TForm16.Fnct_FindObject(CmObjet : TCmObjet) : HWND;
begin
   ListHwnd.Clear;
   EnumWindows(@EnumWindowsCallback,0);
   if CmObjet.SelParentHandle then SortObjectParent(CmObjet.ParentHandle);
   if CmObjet.SelModule then SortObjectModule(CmObjet.Module);
   if CmObjet.SelClasse then SortObjectClass(CmObjet.Classe);
   if CmObjet.SelTexte then SortObjectText(CmObjet.Texte);
   if CmObjet.SelLong then SortObjectLong(CmObjet.Long);
   if CmObjet.SelLarg then SortObjectLarg(CmObjet.Larg);
   // avant ceci était une procedure, maintenant renvois le premier element dans la valeur return
   if ListHwnd.Count > 0 then result:= StrToInt(ListHwnd[0]) else result :=0;
end;


procedure TForm16.Fnct_FindObject(List : TListView; index : integer);
var ListParam : Tparam;
    item : TListItem;
    i : integer;
    Param : String;
    VisualEffectInfo : String;
    TimeElapse, TimeElapse2 : DWord;
    TimeOut : integer;
    VisualEffectVisible : Boolean;

begin
try
if List.Items[index] = nil
then Exit;
Param := List.Items[index].SubItems[0];
ListParam := form1.GetParam(Param);
CmObjet.Handle := MdlFnct.FnctStrToint(ListParam.param[1]);
CmObjet.ParentHandle := MdlFnct.FnctStrToint(ListParam.param[2]);
CmObjet.Module := ListParam.param[3];
CmObjet.Classe := ListParam.param[4];
CmObjet.Texte := ListParam.param[5];
CmObjet.Long := MdlFnct.FnctStrToint(ListParam.param[6]);
CmObjet.Larg := MdlFnct.FnctStrToint(ListParam.param[7]);
CmObjet.NoFound := MdlFnct.FnctStrToint(ListParam.param[8]);
CmObjet.moreFound := MdlFnct.FnctStrToint(ListParam.param[9]);
CmObjet.Varobjcount := ListParam.param[10];
CmObjet.Varindex := GetValue(ListParam.param[11]);
CmObjet.SelList := MdlFnct.FnctStrToint(ListParam.param[12]);
if ((CmObjet.SelList shr 6)and 1) = 1
then CmObjet.SelParentHandle := True else CmObjet.SelParentHandle := False;
if ((CmObjet.SelList shr 5)and 1) = 1
then CmObjet.SelModule := True else CmObjet.SelModule := False;
if ((CmObjet.SelList shr 4) and 1) = 1
then CmObjet.SelClasse := True else CmObjet.SelClasse := False;
if ((CmObjet.SelList shr 3)and 1) = 1
then CmObjet.SelTexte := True else CmObjet.SelTexte := False;
if ((CmObjet.SelList shr 2)and 1) = 1
then CmObjet.SelLong := True else CmObjet.SelLong := False;
if ((CmObjet.SelList shr 1)and 1) = 1
then CmObjet.SelLarg := True else CmObjet.SelLarg := False;

if (FnctIsInteger(GetValue('[OBJECT.TIMEOUT]')) = True)
then TimeOut := StrToInt(GetValue('[OBJECT.TIMEOUT]'))
else TimeOut := 0;

TimeElapse := GetTickCount + DWord(TimeOut*1000);
TimeElapse2 := GetTickCount + DWord(1*1000);

Fnct_FindObject(CmObjet);
if mdlfnct.FnctTypeVar(CmObjet.Varobjcount) <> TNo
then form1.WriteVariable('VAR',CmObjet.Varobjcount,IntToStr(ListHwnd.Count));

if ListHwnd.Count = 0
then begin
     if CmObjet.NoFound = 1 then begin
                                 VisualEffectInfo := 'Macro en attente de recherche d''objet :  ';
                                 if CmObjet.SelModule = True then VisualEffectInfo := VisualEffectInfo + chr(VK_RETURN) + 'Application :' + CmObjet.Module;
                                 if CmObjet.SelParentHandle = True then VisualEffectInfo := VisualEffectInfo + chr(VK_RETURN) + 'Handle Parent :' + IntToStr(CmObjet.ParentHandle);
                                 if CmObjet.SelClasse = True then VisualEffectInfo := VisualEffectInfo + chr(VK_RETURN)+ 'Classe :' + CmObjet.Classe;
                                 if CmObjet.SelTexte = True  then VisualEffectInfo := VisualEffectInfo + chr(VK_RETURN)+ 'Texte :' + CmObjet.Texte;
                                 if CmObjet.SelLong = True   then VisualEffectInfo := VisualEffectInfo + chr(VK_RETURN)+ 'Longueur :' + IntToStr(CmObjet.Long);
                                 if CmObjet.SelLarg = True   then VisualEffectInfo := VisualEffectInfo + chr(VK_RETURN)+ 'Largeur :' + IntToStr(CmObjet.Larg);
                                 VisualEffectVisible := False;
                                 try
                                 while (ListHwnd.Count = 0)
                                 do begin
                                    if (GetTickCount > TimeElapse2) and (VisualEffectVisible = False)
                                    then begin
                                         VisualEffectVisible := True;
                                         VisualEffectLoad(ExtractFileDir(Application.Exename)+'\searchObject.gif',point(VisualEffectObjX,VisualEffectObjY),point(10,100),True);
                                         VisualEffectHintInfo(VisualEffectInfo);
                                         end;

                                    if (ContextOfExecute.ExecutionType =  ContextOfExecute.NotRun)
                                    then break;
                                    Form1.Delay(800); // semble efficace
                                    Form16.Fnct_FindObject(CmObjet);

                                    if (GetTickCount > TimeElapse) and (TimeOut > 0)
                                    then begin
                                         Form1.ErrorComportement(VisualEffectInfo+chr(VK_RETURN)+ '[OBJECT.TIMEOUT] a expiré.'+chr(VK_RETURN),2);
                                         break;
                                         end;
                                    end;
                                 finally VisualEffectQuit(); end;
                                 end;
     if CmObjet.NoFound = 2 then Exit;
     end;

if ListHwnd.Count = 1
then begin
     Form1.ChangeParam(List, List.Items[Index].Index,1,ListHwnd[0],True);
     form1.Update_Objet(List, StrToInt(ListParam.param[1]),StrToInt(ListHwnd[0]));
     Form1.Delay(TimeOut * 100);
     end;

if ListHwnd.Count > 1
then begin

     if CmObjet.moreFound = 1
     then for i := 0 to ListHwnd.Count -1
          do if StrToInt(ListHwnd[i]) = CmObjet.Handle then Exit;

     if CmObjet.moreFound = 2 then Exit;

     if (mdlFnct.FnctIsInteger(GetValue(CmObjet.Varindex))) and (CmObjet.moreFound = 3)
     then begin
          i := StrToInt(GetValue(CmObjet.Varindex));
          if ( i <= ListHwnd.Count)
          then begin
               i := ListHwnd.Count-i;
               Form1.ChangeParam(List,List.Items[Index].Index,1,ListHwnd[i],True);
               Form1.Update_Objet(List,StrToint(ListParam.param[1]),StrToInt(ListHwnd[i]));
               end;
          end
     else begin
          List.Items[Index].SubItems[0] := ListHwnd[0] + RightStr(Param,length(Param)-length(ListParam.param[1]));
          Form1.Update_Objet(List, StrToint(ListParam.param[1]),StrToInt(ListHwnd[0]));
          for i := 0 to ListHwnd.Count -1
          do begin
             item := form17.ListView1.Items.Add;
             item.Caption := ListHwnd.Strings[i];
             item.SubItems.Add(mdlfnct.Donne_Class(StrToint(ListHwnd.Strings[i])));
             item.SubItems.Add(mdlfnct.GetText(StrToint(ListHwnd.Strings[i])))
             end;
          unit17.valider := False;
          form17.Show;
          form17.Button1.Enabled := True;
          Form17.Edit1.Visible := False;
          Form17.SpeedButton1.Visible := False;
          Form17.Label1.Caption := 'Sélectionnez un Objet parmis la liste ci-dessous, puis cliquez sur le bouton sélectionner.';
          while unit17.valider = False
          do begin
               SleepEx(200,False);
               application.ProcessMessages;
               end;
          end;
     end;
except on E: Exception do Form1.ShowApplicationError(nil,E); end;
end;


procedure TForm16.SaveComportement();
var index, i : integer;
begin
if NoChangeCmpt = True then Exit;
index := -1;
for i := 1 to ListComObj.Count
do if IntToStr(ListComObj.Items[i].Handle) = ComboBox1.Text
   then index := i;
if index > 0
then begin
     ListComObj.Items[index].NoFound := RadioGroup1.ItemIndex+1;
     ListComObj.Items[index].moreFound := RadioGroup2.ItemIndex+1;
     ListComObj.Items[index].Varobjcount := ComboBox2.Text;
     ListComObj.Items[index].Varindex := ComboBox3.Text;
     end;
end;

procedure TForm16.LoadComportement();
var index, i : integer;
begin
NoChangeCmpt := True;
index := -1;
for i := 1 to ListComObj.Count
do if IntToStr(ListComObj.Items[i].Handle) = ComboBox1.Text
   then begin index := i; break; end;

if index > 0
then begin
     RadioGroup1.ItemIndex := ListComObj.Items[index].NoFound -1;
     RadioGroup2.ItemIndex := ListComObj.Items[index].moreFound -1;
     ComboBox2.Text := ListComObj.Items[index].Varobjcount;
     ComboBox3.Text := ListComObj.Items[index].Varindex;
     ComboBox3.Enabled := RadioGroup2.ItemIndex = 2;
     end;
NoChangeCmpt := False;
end;

procedure TForm16.ListComObjInit(var Obj : TCmObjet);
begin
with Obj
do begin
   Handle :=0; ParentHandle :=0;
   Module :=''; Classe :=''; Texte :='';
   Long :=0; Larg :=0;
   SelHandle := True;
   SelParentHandle := False;
   SelModule := False;
   SelClasse := False;
   SelTexte := False;
   SelLong := False;
   SelLarg := False;
   SelList := 0;
   NoFound := 1; moreFound := 1;
   Varobjcount := '';
   Varindex := '';
   end;
end;

procedure TForm16.ListComObjInitAll();
var i : integer;
begin
for i := 1 to ObjMax
do ListComObjInit(ListComObj.Items[i]);
ListComObj.Count :=0;
end;

procedure TForm16.DrawIntoTreeView();
var i : integer;
    TN, CurItem : TTreeNode;
    first : Boolean;
begin
TN := nil;
TreeView1.Items.Clear;
for i := 1 to ListComObj.Count
do begin
   // ajout du module si un SelModule est a True
   if ListComObj.Items[i].SelModule = True
   then TN := FindModule(ListComObj.Items[i].Module);
   if (TN = nil) and (ListComObj.Items[i].SelModule = True)
   then begin
        TN := TreeView1.Items.AddFirst(nil,ListComObj.Items[i].Module);
        TN.ImageIndex := 5; TN.SelectedIndex := 5;
        end;

   // recherche si un parent existe
   CurItem := TreeView1.Items.GetFirstNode;
   while CurItem <> nil
   do begin
      if (CurItem.Text = IntToStr(ListComObj.Items[i].ParentHandle)) and (CurItem.ImageIndex = 0)
      then begin
           TN := CurItem;
           Break;
           end;
      CurItem := CurItem.GetNext;
      end;

   // Ajout des propriétés
   first := False;
   TN := TreeView1.Items.AddChild(TN,IntToStr(ListComObj.Items[i].Handle));
   TN.ImageIndex := 0; TN.SelectedIndex := 0;

   if ListComObj.Items[i].SelClasse = True then begin if first = false
                                                      then TN := TreeView1.Items.AddChild(TN,ListComObj.Items[i].Classe)
                                                      else TN := TreeView1.Items.Add(TN,ListComObj.Items[i].Classe);
                                                      TN.ImageIndex := 1; TN.SelectedIndex := 1; first := True;
                                                      end;
   if ListComObj.Items[i].SelTexte = True then begin  if first = false
                                                      then TN := TreeView1.Items.AddChild(TN,ListComObj.Items[i].Texte)
                                                      else TN := TreeView1.Items.Add(TN,ListComObj.Items[i].Texte);
                                                      TN.ImageIndex := 2; TN.SelectedIndex := 2; first := True;
                                                      end;
   if ListComObj.Items[i].SelLong = True then begin   if first = false
                                                      then TN := TreeView1.Items.AddChild(TN,IntToStr(ListComObj.Items[i].Long))
                                                      else TN := TreeView1.Items.Add(TN,IntToStr(ListComObj.Items[i].Long));
                                                      TN.ImageIndex := 3; TN.SelectedIndex := 3; first := True; end;
   if ListComObj.Items[i].SelLarg = True then begin   if first = false
                                                      then TN := TreeView1.Items.AddChild(TN,IntToStr(ListComObj.Items[i].Larg))
                                                      else TN := TreeView1.Items.Add(TN,IntToStr(ListComObj.Items[i].Larg));
                                                      TN.ImageIndex := 4; TN.SelectedIndex := 4; end;
   end;
TreeView1.FullExpand;
if TreeView1.Items.Count > 0 then Button5.Enabled := True else Button5.Enabled := False;
end;

function TForm16.AddObject(ObjHandle : HWND) : Boolean;
var Dim : TRect;
    i : integer;
begin
result := True;
if ListComObj.Count >= ObjMax // protection contre le surnombre d'objet
then begin
     MessageDlg('Le nombre limite d''objet listé est de '+InttoStr(ObjMax)+'.', mtWarning,[mbOk], 0);
     result := False;
     Exit;
     end;
Inc(ListComObj.Count);
i := ListComObj.Count;
ListComObj.Items[i].Handle := ObjHandle;
ListComObj.Items[i].ParentHandle := GetParent(ObjHandle);
ListComObj.Items[i].Module := GetWindowModuleFileName(ObjHandle);
ListComObj.Items[i].Classe := Donne_class(ObjHandle);
ListComObj.Items[i].Texte := mdlfnct.gettext(ObjHandle);
GetWindowRect(ObjHandle,Dim);
ListComObj.Items[i].Long := Dim.Right - Dim.Left;
ListComObj.Items[i].Larg := Dim.Bottom - Dim.Top;
ListComObj.Items[i].SelHandle := True;
ListComObj.Items[i].SelParentHandle := True;
ListComObj.Items[i].SelModule := True;
ListComObj.Items[i].SelClasse := True;
ListComObj.Items[i].SelTexte := True;
ListComObj.Items[i].SelLong := True;
ListComObj.Items[i].SelLarg := True;
// protection
//ListComObj.Items[i].NoFound := 1;
//ListComObj.Items[i].moreFound := 1;
// protection fin
end;

function TForm16.FindNode(Node : TTreeNode; Str :string): TTreeNode;
var CurItem: TTreeNode;
begin
  CurItem := Node;
  while CurItem <> nil do
  begin
    if CurItem.Text = Str then Break;
    CurItem := CurItem.GetNext;
  end;
result := CurItem;
end;

function TForm16.FindObjet(Str :string; Select : Boolean): TTreeNode;
var CurItem: TTreeNode;
begin
  CurItem := nil; result := nil;
  if select = True then CurItem := TreeView1.selected;
  if CurItem = nil then Exit;
  while CurItem <> nil do
  begin
    //if CurItem.Text = Str then Break;
    Str := CurItem.Text;
    if CurItem.ImageIndex = 0 then Break;
    CurItem := CurItem.GetPrev;
  end;
result := CurItem;
end;

function Tform16.FindModule(Str : string) : TTreeNode;
var CurItem: TTreeNode;
begin
  CurItem := TreeView1.Items.GetFirstNode;
  while CurItem <> nil do
  begin
    if (CurItem.Text = Str) and (CurItem.ImageIndex = 5) then Break;
    CurItem := CurItem.GetNext;
  end;
result := CurItem;
end;

procedure posCur();
begin
GetCursorPos(Pt);
Application.ProcessMessages;
end;

procedure TForm16.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SpyRunCapture := false;
unit1.sw_modif := False;
ListComObjInitAll;
PageControl1.ActivePage := TabSheet1;
Button4.Caption := '<< Precedent';
Button5.Caption := 'Suivant >>';
end;

procedure TForm16.PrcStop(Sender: TObject);
begin
SpyRunCapture := false;
end;

procedure TForm16.PrcRun(Sender: TObject);
var handle, OldHandle,ParentHandle : HWND;
    Wplacement : WindowPlacement;
    PPParent : HWND;
    TabPPParent : array of HWND;
    i : integer;
begin
SpyRunCapture := true;
poscur();
Oldhandle := 0;

while SpyRunCapture = true do
begin
// module
poscur();
handle := WindowFromPoint(pt);
form16.Caption := 'Spy - X : ' + Inttostr(pt.x) + ' Y : ' + Inttostr(pt.y);
application.ProcessMessages;

if handle = OldHandle then continue;

Form16.ListComObjInitAll;
if (checkBox3.Checked = True)
then begin
     ParentHandle := GetFirstParent(Handle);
     if (isWindowvisible(ParentHandle) = True)
     then begin
          GetWindowPlacement(ParentHandle,@Wplacement);
          case Uint(Wplacement.showCmd) of
               SW_NORMAL : begin ForceForegroundWindow(ParentHandle); ShowWindow(ParentHandle,SW_NORMAL) end;
               SW_SHOWMAXIMIZED : begin ForceForegroundWindow(ParentHandle); ShowWindow(ParentHandle,SW_SHOWMAXIMIZED) end;
          end;
          end;

{     if (isWindowvisible(GetParent(Handle)) = True)
     then begin
          GetWindowPlacement(Handle,@Wplacement);
          case Uint(Wplacement.showCmd) of
               SW_NORMAL : begin ForceForegroundWindow(Handle); ShowWindow(Handle,SW_NORMAL) end;
               SW_SHOWMAXIMIZED : begin ForceForegroundWindow(Handle); ShowWindow(Handle,SW_SHOWMAXIMIZED) end;
          end;
          end;}
     end;

PPParent := handle;
SetLength(TabPPParent,0);
while PPParent <> 0
do begin
   PPParent := GetParent(PPParent);
   if PPParent <> 0
   then begin
        SetLength(TabPPParent, length(TabPPParent)+1);
        TabPPParent[length(TabPPParent)-1] := PPParent;
        end;
   end;

for i := length(TabPPParent)-1 downto 0
do AddObject(TabPPParent[i]);
AddObject(handle);

DrawIntoTreeView;
OldHandle := handle;

end;
form16.Caption := 'Spy';
end;

procedure TForm16.FormShow(Sender: TObject);
var ListParam : Tparam;
    param : string;
    i : integer;
    ConfigIni : TiniFile;
begin
// bouton default
ConfigIni := TIniFile.Create(Form19.Label22.Caption);
try
CheckBox1.Checked := form1.StrToBool(ConfigIni.ReadString('Spy', 'ReduceForm','False'));
CheckBox2.Checked := form1.StrToBool(ConfigIni.ReadString('Spy', 'ReduceApp','False'));
CheckBox3.Checked := form1.StrToBool(ConfigIni.ReadString('Spy', 'ShowObjet','False'));
finally ConfigIni.free; end;

//ListComObjInitAll;
image1.Visible := True;
PageControl1.ActivePage := TabSheet1;
If unit1.sw_modif = True
then begin
     min := 0; max := 0;
     PageControl1.ActivePage := TabSheet4;
     for i := form1.listview1.Selected.Index to form1.listview1.Items.Count-1
     do if form1.listview1.Items[i].Caption = 'Objet' then max := i else break;

     for i := form1.listview1.Selected.Index downto 0
     do if form1.listview1.Items[i].Caption = 'Objet' then min := i else break;

     if max - min > ObjMax then max := max+ObjMax; // limite le nombre d'objet à ObjMax
     for i := min to max
     do begin
        param := form1.listview1.Items[i].SubItems.Strings[0];
        ListParam := form1.GetParam(param);
        ListComObj.Count := ListComObj.Count +1;
        ListComObj.Items[ListComObj.Count].Handle := StrToint(ListParam.param[1]);
        ListComObj.Items[ListComObj.Count].ParentHandle := StrToint(ListParam.param[2]);
        ListComObj.Items[ListComObj.Count].Module := ListParam.param[3];
        ListComObj.Items[ListComObj.Count].Classe := ListParam.param[4];
        ListComObj.Items[ListComObj.Count].Texte := ListParam.param[5];
        ListComObj.Items[ListComObj.Count].Long := StrToint(ListParam.param[6]);
        ListComObj.Items[ListComObj.Count].Larg := StrToint(ListParam.param[7]);
        ListComObj.Items[ListComObj.Count].NoFound := StrToint(ListParam.param[8]);
        ListComObj.Items[ListComObj.Count].moreFound := StrToint(ListParam.param[9]);
        ListComObj.Items[ListComObj.Count].Varobjcount := ListParam.param[10];
        ListComObj.Items[ListComObj.Count].Varindex := ListParam.param[11];
        ListComObj.Items[ListComObj.Count].SelList := StrToInt(ListParam.param[12]);

        if ((ListComObj.Items[ListComObj.Count].SelList shr 6)and 1) = 1
        then ListComObj.Items[ListComObj.Count].SelParentHandle := True else ListComObj.Items[ListComObj.Count].SelParentHandle := False;
        if ((ListComObj.Items[ListComObj.Count].SelList shr 5)and 1) = 1
        then ListComObj.Items[ListComObj.Count].SelModule := True else ListComObj.Items[ListComObj.Count].SelModule := False;
        if ((ListComObj.Items[ListComObj.Count].SelList shr 4) and 1) = 1
        then ListComObj.Items[ListComObj.Count].SelClasse := True else ListComObj.Items[ListComObj.Count].SelClasse := False;
        if ((ListComObj.Items[ListComObj.Count].SelList shr 3)and 1) = 1
        then ListComObj.Items[ListComObj.Count].SelTexte := True else ListComObj.Items[ListComObj.Count].SelTexte := False;
        if ((ListComObj.Items[ListComObj.Count].SelList shr 2)and 1) = 1
        then ListComObj.Items[ListComObj.Count].SelLong := True else ListComObj.Items[ListComObj.Count].SelLong := False;
        if ((ListComObj.Items[ListComObj.Count].SelList shr 1)and 1) = 1
        then ListComObj.Items[ListComObj.Count].SelLarg := True else ListComObj.Items[ListComObj.Count].SelLarg := False;
        end;
     DrawIntoTreeView;
     end;

if TreeView1.Items.Count = 0
then Button5.Enabled := False
else Button5.Enabled := True;

end;

procedure TForm16.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Button = mbLeft
then begin
     if (Shift <> [ssLeft]) then Exit;
     SaveCursor := Screen.Cursors[1];
     Screen.Cursors[1] := SetCursor(image1.Picture.Icon.Handle);
     image1.Visible := False;
     unit1.MainFormStatus := Form1.WindowState;
     if checkBox1.Checked = True then form16.WindowState := wsMinimized;
     if checkBox2.Checked = True then form1.WindowState := wsMinimized;
     PrcRun(self);
     end;

end;

procedure TForm16.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if Button = mbLeft
then begin
     image1.Visible := True;
     PrcStop(self);
     Screen.Cursors[1] := SaveCursor;
     //if checkBox1.Checked = True then
     form16.WindowState := wsNormal;
     //if checkBox2.Checked = True then
     mdlfnct.ForceForegroundWindow(Form1.Handle);
     form1.WindowState := unit1.MainFormStatus;
     end;
end;

procedure TForm16.SpeedButton2Click(Sender: TObject);
begin
CheckListBox1.DeleteSelected;
end;

procedure TForm16.TabSheet3Show(Sender: TObject);
var i : integer;
begin
form1.List_Var(ComboBox2.Items,True,True);
form1.List_Var(ComboBox3.Items,True,True);
Combobox1.Clear;
for i := 1 to ListComObj.Count
do ComboBox1.Items.Add(InttoStr(ListComObj.items[i].Handle));
ComboBox1.Text := InttoStr(ListComObj.items[1].Handle)
end;

procedure TForm16.CheckListBox1ClickCheck(Sender: TObject);
var i,pos : integer;
    Checked : Boolean;
    Lparam : TParam;
    index : integer;
begin
if CheckListBox1.SelCount = 0 then Exit;
pos := -1;
for i := 0 to CheckListBox1.Count -1
do begin
   if CheckListBox1.Selected[i] = True
   then begin pos := i; break; end;
   end;
if pos = -1 then Exit;
Checked := CheckListBox1.Checked[pos];
Lparam := form1.GetParam(CheckListBox1.Items[pos]);
index := -1;
for i := 1 to ListComObj.Count
do if IntToStr(ListComObj.Items[i].Handle) = Lparam.param[1]
   then index := i;
   
if index > 0
then begin
     if Lparam.param[2] = 'Module'
     then ListComObj.Items[index].SelModule := Checked;
     if Lparam.param[2] = 'Parent'
     then ListComObj.Items[index].SelParentHandle := Checked;
     if Lparam.param[2] = 'Classe'
     then ListComObj.Items[index].SelClasse := Checked;
     if Lparam.param[2] = 'Texte'
     then ListComObj.Items[index].SelTexte  := Checked;
     if Lparam.param[2] = 'Longueur'
     then ListComObj.Items[index].SelLong := Checked;
     if Lparam.param[2] = 'Largeur'
     then ListComObj.Items[index].SelLarg := Checked;
     DrawIntoTreeView;
     end;
end;

procedure TForm16.TreeView1Click(Sender: TObject);
var TN : TTreeNode;
    i,index : integer;
begin
if TreeView1.Selected = nil then Exit;
TN := findObjet('',True);
if TN = nil then Exit;
ObjIndex := Tn.Index;
index := 0;
for i := 1 to ListComObj.Count
do if TN.Text = IntToStr(ListComObj.Items[i].Handle) then index := i;
if index = 0 then Exit;

if PageControl1.ActivePage = TabSheet4
then begin
     Edit1.Text := ''; Edit2.Text := ''; Edit3.Text := '';
     Edit4.Text := ''; Edit5.Text := ''; Edit6.Text := '';
     Edit1.Text := IntToStr(ListComObj.Items[Index].Handle);
     Edit2.Text := IntToStr(ListComObj.Items[Index].ParentHandle);
     Edit3.Text := ListComObj.Items[Index].Classe;
     Edit4.Text := ListComObj.Items[Index].Texte;
     Edit5.Text := IntToStr(ListComObj.Items[Index].Long);
     Edit6.Text := IntToStr(ListComObj.Items[Index].Larg);
     end;
if PageControl1.ActivePage = TabSheet3
then begin
     ComboBox1.Text := Tn.Text;
     ComboBox1.OnChange(self);
     end;
end;

procedure TForm16.Button1Click(Sender: TObject);
var i, Index : integer;
begin
index := 1;
for i := 1 to ListComObj.Count
do if ListComObj.Items[i].Handle = StrToint(Edit1.Text)
   then Index := i;

   ListComObj.Items[Index].Handle := StrToint(Edit1.Text);
   ListComObj.Items[Index].ParentHandle := StrToint(Edit2.Text);
   ListComObj.Items[Index].Classe := Edit3.Text;
   ListComObj.Items[Index].Texte := Edit4.Text;
   ListComObj.Items[Index].Long := StrToint(Edit5.Text);
   ListComObj.Items[Index].Larg := StrToint(Edit6.Text);
   DrawIntoTreeView;
end;

procedure TForm16.TabSheet2Show(Sender: TObject);
var i,j : integer;
    StrHnd : string;
begin
CheckListBox1.Clear;
for i := 1 to ListComObj.Count
do begin
   StrHnd := InttoStr(ListComObj.items[i].Handle);
   j :=CheckListBox1.Items.Add('+ Propriétés');
       CheckListBox1.Header[j] := True;
   j :=CheckListBox1.Items.Add(StrHnd+SprPr+'Module'+SprPr+ListComObj.items[i].Module);
   CheckListBox1.Checked[j] := ListComObj.items[i].SelModule;
   j :=CheckListBox1.Items.Add(StrHnd+SprPr+'Parent'+SprPr+IntToStr(ListComObj.items[i].ParentHandle));
   CheckListBox1.Checked[j] := ListComObj.items[i].SelParentHandle;
   j :=CheckListBox1.Items.Add(StrHnd+SprPr+'Classe'+SprPr+ListComObj.items[i].Classe);
   CheckListBox1.Checked[j] := ListComObj.items[i].SelClasse;
   j :=CheckListBox1.Items.Add(StrHnd+SprPr+'Texte'+SprPr+ListComObj.items[i].Texte);
   CheckListBox1.Checked[j] := ListComObj.items[i].SelTexte;
   j :=CheckListBox1.Items.Add(StrHnd+SprPr+'Longueur'+SprPr+IntToStr(ListComObj.items[i].Long));
   CheckListBox1.Checked[j] := ListComObj.items[i].SelLong;
   j :=CheckListBox1.Items.Add(StrHnd+SprPr+'Largeur'+SprPr+IntToStr(ListComObj.items[i].Larg));
   CheckListBox1.Checked[j] := ListComObj.items[i].SelLarg;
   end;
end;

procedure TForm16.ComboBox1Change(Sender: TObject);
begin
LoadComportement;
end;

procedure TForm16.RadioGroup1Click(Sender: TObject);
begin
SaveComportement;
end;

procedure TForm16.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
AllowChange := False;
end;

procedure TForm16.Button3Click(Sender: TObject);
begin
Form16.Close;
end;

procedure TForm16.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
if TreeView1.Items.Count = 0
then Button5.Enabled := False
else Button5.Enabled := True;
end;

procedure TForm16.RadioGroup2Click(Sender: TObject);
begin
SaveComportement;
ComboBox3.Enabled := RadioGroup2.ItemIndex = 2;
end;

procedure TForm16.FormCreate(Sender: TObject);
begin
ListHwnd := TStringList.Create;
TransformTimageToWizard(Image2);
TransformTimageToWizard(Image3);
TransformTimageToWizard(Image4);
TransformTimageToWizard(Image5);
TransformTimageToWizard(Image6);
end;

procedure TForm16.FormDestroy(Sender: TObject);
begin
ListHwnd.Free;
end;

procedure TForm16.ComboBox1Select(Sender: TObject);
var MyNode : TTreeNode;
begin
MyNode := FindObjet(ComboBox1.Text,True);
if MyNode <> nil then MyNode.Selected := True;
ComboBox1.OnChange(self);
end;

procedure TForm16.Button2Click(Sender: TObject);
var ConfigIni: TIniFile;
begin
ConfigIni := TIniFile.Create(Form19.Label22.Caption);
try
ConfigIni.WriteString('Spy', 'ReduceForm', form1.BoolToStr(CheckBox1.Checked));
ConfigIni.WriteString('Spy', 'ReduceApp', form1.BoolToStr(CheckBox2.Checked));
ConfigIni.WriteString('Spy', 'ShowObjet', form1.BoolToStr(CheckBox3.Checked));
finally ConfigIni.free; end;

end;

procedure TForm16.SpeedButton1Click(Sender: TObject);
var URL : String;
    MyClass : string;
begin
if Edit3.Text <> ''
then Begin
     MyClass := Edit3.Text;
     if (Edit3.Text[1] = 't') or (Edit3.Text[1] = 'T')
     then MyClass := MyClass + '+' +  RightStr(Edit3.Text, length(Edit3.Text)-1);
     URL := 'http://search.microsoft.com/search/results.aspx?na=81&st=a&View=msdn&qu=&qp=&qa='+MyClass+'&qn=&c=4&s=2';
     ShellExecute(handle,'Open',Pchar(URL),'','',SW_SHOWNORMAL);
     end;
end;

procedure TForm16.Button4Click(Sender: TObject);
begin
Button4.Caption := '<< Précedent';
Button5.Caption :='Suivant >>';
if PageControl1.ActivePageIndex > 0 then PageControl1.ActivePageIndex := PageControl1.ActivePageIndex -1;
if PageControl1.ActivePage = TabSheet1 then Button4.enabled := False else Button4.Enabled := True;
end;

procedure TForm16.Button5Click(Sender: TObject);
var Param : String;
    SelCode,i,itemparent : integer;
    item : TlistItem;
begin

if Button5.Caption = 'Terminer'
then begin
     Form1.AddHistory(0,'Début d''actions groupées','','');
     if unit1.sw_modif = True
     then for i := max downto min do Form1.ListView1.Items.Delete(i);
     // determine si les objets parents sont séléctionnés
     itemParent := 1;
     for i := ListComObj.Count downto 1
     do if ListComObj.Items[i].SelParentHandle = False
        then begin itemParent := i; break; end;

     for i := itemParent to ListComObj.Count
     do begin
     Param := '';
     SelCode := 0;
     Param := Param + IntToStr(ListComObj.Items[i].Handle)+ SprPr;
     Param := Param + IntToStr(ListComObj.Items[i].ParentHandle)+ SprPr;
     Param := Param + ListComObj.Items[i].Module+ SprPr;
     Param := Param + ListComObj.Items[i].Classe+ SprPr;
     Param := Param + ListComObj.Items[i].Texte+ SprPr;
     Param := Param + IntToStr(ListComObj.Items[i].Long)+ SprPr;
     Param := Param + IntToStr(ListComObj.Items[i].Larg)+ SprPr;
     Param := Param + IntToStr(ListComObj.Items[i].NoFound)+ SprPr;
     Param := Param + IntToStr(ListComObj.Items[i].moreFound)+ SprPr;
     Param := Param + ListComObj.Items[i].Varobjcount+ SprPr;
     Param := Param + ListComObj.Items[i].VarIndex+ SprPr;
     if ListComObj.Items[i].SelHandle = True then SelCode := SelCode + 128;
     if ListComObj.Items[i].SelParentHandle = True then SelCode := SelCode + 64;
     if ListComObj.Items[i].SelModule = True then SelCode := SelCode + 32;
     if ListComObj.Items[i].SelClasse = True then SelCode := SelCode + 16;
     if ListComObj.Items[i].SelTexte = True then SelCode := SelCode + 8;
     if ListComObj.Items[i].SelLong = True then SelCode := SelCode + 4;
     if ListComObj.Items[i].SelLarg = True then SelCode := SelCode + 2;
     Param := Param + IntToStr(SelCode)+ SprPr;
     if unit1.sw_modif = False
     then form1.add_insert('Objet',Param,17)
     else begin
          Item := form1.ListView1.Items.Insert(min-1+i);
          Item.Caption := 'Objet';
          Item.ImageIndex := 17;
          Item.SubItems.Add(param);
          end;
     end;
     Form16.Close;
     Form1.AddHistory(0,'Fin d''actions groupées','','');
     end;

Button4.Caption := '<< Précedent';
Button5.Caption :='Suivant >>';

if PageControl1.ActivePageIndex < PageControl1.PageCount-1
then PageControl1.ActivePageIndex := PageControl1.ActivePageIndex +1;
if PageControl1.ActivePage = TabSheet3 then Button5.Caption := 'Terminer';
if PageControl1.ActivePage = TabSheet1 then Button4.Enabled := False else Button4.Enabled :=True;
if TreeView1.Selected = nil then  findNode(TreeView1.Items.GetFirstNode,IntToStr(ListComObj.Items[ListComObj.Count].Handle)).Selected := True;
TreeView1.OnClick(self);
end;

end.
