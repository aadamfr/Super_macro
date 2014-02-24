unit Unit17;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, StrUtils;

type TNew_Objet = record
     Nhandle : integer;
     Nclass : string;
     Ntext : string;
     end;
type
  TForm17 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    Button3: TButton;
    Button4: TButton;
    Panel1: TPanel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    Label1: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Memo1: TMemo;
    Image1: TImage;
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure Button3Click(Sender: TObject);
    procedure InfoToHint();
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  procedure DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
  end;

var
  Form17: TForm17;
  Sel_objet_class : String = 'empty';
  HintText : String;
  posX,posY : integer;
  valider : boolean = false;
  Objet_select : TListitem;
  find_objet_text : string = '';
  find_objet_parent : string = '';
  SortIndex : integer = 0;
  SortAssending : Boolean = False;
  MainProcessId : DWord;
  Hwnd_MainForm_form_ProcessId : Hwnd;

function EnumWindowsCallback(hWnd: HWND; lParam: LPARAM): BOOL;stdcall;
function EnumChildCallback(hWnd: HWND; lParam: LPARAM): BOOL;stdcall;
function EnumThreadWindowsCallback(Wnd:HWnd;thePid:DWord):Boolean; stdcall;

implementation

uses Unit1, Unit16, mdlfnct, UBackGround;

{$R *.DFM}

procedure TForm17.MessageAide(var msg:TMessage);
var HelpDir : String;
begin
if ActiveControl = nil then Exit;
if ActiveControl.HelpContext <>0
then begin
     HelpDir := ExtractFileDir(Application.ExeName);
     if HtmlHelp(form1.Handle, PChar(HelpDir+'\aide.chm'), HH_HELP_CONTEXT,ActiveControl.HelpContext) = 0
     then ShowMessage('Erreur: Vérifiez la présence du fichier .chm dans le dossier de Super macro.');
     end;
end;

procedure TForm17.InfoToHint();
var Strhandle,texte,long,larg,classe,parentclasse, moduleName : String;
    Handle : longint;
    Dim : TRect;
begin
if ListView1.Selected <> nil
then begin
     handle := StrToInt(ListView1.Selected.Caption);
     Strhandle := Inttostr(handle);
     Texte := mdlfnct.gettext(handle);
     GetWindowRect(handle, Dim);
     Long := IntToStr(Dim.Right - Dim.Left);
     Larg := IntToStr(Dim.Bottom - Dim.Top);
     Classe := Donne_class(handle);
     ModuleName := GetWindowModuleFileName(handle);
     ParentClasse := Donne_class(GetParent(handle));
     Memo1.Clear;
     Memo1.Lines.Add('Module : ' + ModuleName);
     Memo1.Lines.Add('Handle : ' + StrHandle);
     Memo1.Lines.Add('Classe : ' + Classe);
     Memo1.Lines.Add('Classe parent : ' + ParentClasse);
     Memo1.Lines.Add('Longueur : ' + Long);
     Memo1.Lines.Add('Largeur : ' + Larg);
     Memo1.Lines.Add('Texte : ' + Texte);
     end;
end;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
begin
if SortAssending = False
then Begin
     if SortIndex = 0
     then Result := lstrcmp(PChar(TListItem(Item1).Caption), PChar(TListItem(Item2).Caption))
     else Result := lstrcmp(PChar(TListItem(Item1).SubItems.Strings[SortIndex-1]), PChar(TListItem(Item2).SubItems.Strings[SortIndex-1]));
     end
else begin
     if SortIndex = 0
     then Result := -lstrcmp(PChar(TListItem(Item1).Caption), PChar(TListItem(Item2).Caption))
     else Result := -lstrcmp(PChar(TListItem(Item1).SubItems.Strings[SortIndex-1]), PChar(TListItem(Item2).SubItems.Strings[SortIndex-1]));
     end;

end;

procedure TForm17.DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if HintInfo.HintControl = ListView1 then
  begin
    with HintInfo do
    begin
      CanShow := True;
      HintColor := clAqua;
      ReshowTimeout:= 1000;
      HideTimeout:= 1000;
    end;
  end;
end;

function EnumChildCallBack(hWnd: HWND; lParam: LPARAM): BOOL;
Var Texte : String;
    Classe : String;
    Parent : String;
    ProcessId : LongWord;
begin
    Texte := mdlfnct.GetText(hWnd);
    Parent := MdlFnct.Donne_Class(GetParent(hWnd));
    Classe := MdlFnct.Donne_Class(hWnd);
    //HintText := HintText + 'Handle : ' +IntToStr(hWnd) + ' Classe : ' + Classe + ' Texte : ' + Texte +#13#10;
    // en plus
  if (AnsiStrLiComp(Pchar(Classe), Pchar(Sel_Objet_class),length(Sel_Objet_class)) = 0) or (Sel_Objet_class = '')
   then if ((find_objet_text = Texte) or (find_objet_text = '')) and ((find_objet_parent = Parent) or (find_objet_parent = ''))
   then begin
        if MainProcessId <> GetWindowThreadProcessId(hWnd,@ProcessId) // Pour exclure les handles de Super Macro
        then begin
             form17.ListView1.Items.Add();
             form17.ListView1.Items[form17.ListView1.Items.Count - 1].Caption := IntToStr(hWnd);
             form17.listView1.items.Item[form17.ListView1.Items.Count-1].SubItems.Add(Classe);
             form17.listView1.items.Item[form17.ListView1.Items.Count-1].SubItems.Add(Texte);
             end;
        end;
   // fin plus
    result:=True;
end;

function EnumWindowsCallback(hWnd: HWND; lParam: LPARAM): BOOL;
Var Texte : String;
    Classe : String;
    Parent : String;
    ProcessId : LongWord;
begin
  Texte := MdlFnct.GetText(hWnd);
  Parent := MdlFnct.Donne_Class(GetParent(hWnd));
  Classe := MdlFnct.Donne_Class(hWnd);
  if (AnsiStrLiComp(Pchar(Classe), Pchar(Sel_Objet_class),length(Sel_Objet_class)) = 0) or (Sel_Objet_class = '')
  then if ((find_objet_text = texte) or (find_objet_text ='')) and ((find_objet_parent = Parent) or (find_objet_parent =''))
  then begin
       if MainProcessId <> GetWindowThreadProcessId(hWnd,@ProcessId) // Pour exclure les handles de Super Macro
       then begin
            form17.ListView1.Items.Add();
            form17.ListView1.Items[form17.ListView1.Items.Count - 1].Caption := IntToStr(hWnd);
            form17.listView1.items.Item[form17.ListView1.Items.Count-1].SubItems.Add(Classe);
            form17.listView1.items.Item[form17.ListView1.Items.Count-1].SubItems.Add(Texte);
            end;
       end;
   EnumChildWindows(Hwnd,@EnumChildCallBack,0);
   result:=true;
end;

function EnumThreadWindowsCallback(Wnd:HWnd;thePid:DWord):Boolean;
var
   pc:array[0..255] of char;
begin
 if (GetClassName(Wnd,pc,SizeOf(pc))<>0) and (pc='TForm1') {to get the specific window by class}
   then begin
     Hwnd_MainForm_form_ProcessId :=Wnd;
     Result:=false;
     end
   else Result:=true;

end;

procedure TForm17.SpeedButton1Click(Sender: TObject);
var ProcessId : LongWord;
   i : integer;
begin
for i := 0 to Form17.ComponentCount - 1 
do if (Form17.Components[i] as Tcontrol) <> nil
   then begin 
        (Form17.Components[i] as Tcontrol).Cursor := crHourGlass;
        end;
Application.ProcessMessages; 
        
try
MainProcessId := GetWindowThreadProcessId(Form1.Handle,@ProcessId);
Sel_objet_class := edit1.text;

ListView1.Items.BeginUpdate;
ListView1.Items.Clear;
EnumWindows(@EnumWindowsCallback,0);
Button3.Click; // Supprime les objet déja listés dans la macro
ListView1.Items.EndUpdate;

if Button1.Enabled = false
then StatusBar1.SimpleText := 'Nombre d''objet listé : ' + IntToStr(ListView1.Items.Count);
finally
for i := 0 to Form17.ComponentCount - 1 
do if (Form17.Components[i] as Tcontrol) <> nil
   then begin 
        (Form17.Components[i] as Tcontrol).Cursor := crDefault;
        end;
Application.ProcessMessages; 
end;
end;

procedure TForm17.Button2Click(Sender: TObject);
begin
Unit17.valider := True;
form1.Stop1.click;
Sel_objet_class := '';
ListView1.Items.BeginUpdate;
ListView1.Items.Clear;
ListView1.Items.EndUpdate;
Memo1.Clear;
form17.close;
// il n'est pas nécessaire de fermer l'application sinon erreur
end;

procedure TForm17.FormClose(Sender: TObject; var Action: TCloseAction);
var Region : Trect;
begin
// si j'attend une séléction d'objet et que je ferme la fenetre
if (Button1.Enabled = True) and (valider = False)
then begin
     Unit17.valider := True;
     Sel_objet_class := '';
     form1.Stop1.click;
     end;

Region := Classes.Rect(0, 0, screen.Width, screen.Height);
InvalidateRect(ClientHandle, @Region, true);
unit1.sw_modif := False;
ListView1.Hint := '';
edit1.text := '';
ListView1.Visible := False;
ListView1.Items.Clear;
ListView1.Visible := True;
button1.Enabled := false;
end;

procedure TForm17.Button1Click(Sender: TObject);
var new_param : string;
    ListParam : Tparam;
    Old_handle, New_handle : integer;
begin
if ((listview1.Selected = nil) and (listview1.items.count > 0))
then listview1.Selected := listview1.Items[0];
if listview1.Selected <> nil
then begin
     Objet_select := form1.ListView1.Items[unit1.Pos_command];
     ListParam := GetParam(Objet_select.SubItems[0]);
     Old_handle := strtoint(ListParam.param[1]);
     New_handle := Strtoint(listview1.Selected.Caption);
     form1.Update_Objet(Form1.Listview1, Old_handle,New_handle);
     new_param := listview1.Selected.caption + RightStr(Objet_select.SubItems[0],length(Objet_select.SubItems[0])-length(ListParam.param[1]));
     Objet_select.SubItems[0] := new_param;
     valider := true;
     form17.close;
     end;
end;

procedure TForm17.ListView1Click(Sender: TObject);
var i, handle : HWND;
begin
if listView1.Selected <> nil
then begin
     InfoToHint;
     handle := StrToInt(ListView1.Selected.Caption);
     {i := handle;
     while GetParent(i) <> 0
     do begin handle := GetParent(i); i := handle; end;
     if IsWindow(handle)
     then ForceForegroundWindow(handle); }
     end;

end;

procedure TForm17.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if (key = Vk_return)  then ListView1.OnClick(ListView1);
end;

procedure TForm17.FormShow(Sender: TObject);
begin
Button1.Enabled := false;
Button1.caption := 'Sélectionner';
end;

procedure TForm17.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
SortIndex := Column.Index;
ListView1.CustomSort(@CustomSortProc, 0);
if SortAssending = True
then SortAssending := False
else SortAssending := True;
end;

procedure TForm17.Button3Click(Sender: TObject);
var cpt, cpt2 : integer;
begin
for cpt :=  ListView1.Items.Count -1  downto 0 do
begin
     for cpt2 := 0 to Form1.ListView1.Items.Count - 1 do
         if Form1.ListView1.Items.Item[cpt2].caption = 'Objet'
         then if findTextParam(cpt2,ListView1.Items.Item[cpt].Caption) = True
     then begin ListView1.Items.Item[cpt].Delete; break; end;
end;
end;

procedure TForm17.FormCreate(Sender: TObject);
begin
TransformTimageToWizard(Image1);
form1.ImageList3.GetBitmap(9,SpeedButton1.Glyph);

end;

procedure TForm17.Button4Click(Sender: TObject);
var PPParent : HWND;
    TabPPParent : array of HWND;
    i : integer;
begin
if ListView1.Selected = nil then Exit;
try
PPParent := StrToInt(ListView1.Selected.Caption);
except Form1.ErrorComportement('La valeur sélectionnée n''est pas un handle valide.'); Exit; end;
Form16.Show;
SetLength(TabPPParent,0);
while PPParent <> 0
do begin
   PPParent := GetParent(PPParent);
   if PPParent <> 0
   then begin
        if length(TabPPParent) > unit16.ObjMax-1 then break;
        SetLength(TabPPParent, length(TabPPParent)+1);
        TabPPParent[length(TabPPParent)-1] := PPParent;
        end;
   end;

for i := length(TabPPParent)-1 downto 0
do if Form16.AddObject(TabPPParent[i])= False then break;

Form16.AddObject(StrToInt(ListView1.Selected.Caption));
Form16.DrawIntoTreeView;
end;

end.
