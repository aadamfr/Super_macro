unit Unit27;
{$WARN SYMBOL_PLATFORM OFF}

interface
uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, ShellAPI, FileCtrl,
  ImgList, Registry,Menus;

type
  TForm27 = class(TForm)
    TreeView1: TTreeView;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label5: TLabel;
    OpenDialog1: TOpenDialog;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ImageList1: TImageList;
    Label6: TLabel;
    procedure FnctCopier(Handle:HWND;Source,Cible:String);
    procedure FnctEffacer(Handle:HWND;Source:String);
    procedure FnctDeplacer(Handle:HWND;Source,Cible:String);
    procedure FnctRenommer(Handle:HWND;Source,Cible:String);
    Function TestFonction(): Boolean;
    procedure TreeView1Click(Sender: TObject);
    procedure ActiveParam(number : integer; Active : Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Form27Show(Rubrique : String);
    procedure RebootXP(Activate : Boolean);
    function  RebootXPExists() : Boolean;
    procedure FormCreate(Sender: TObject);
    function  FindNode(TView : TTreeView; Rubrique : String) : TTreeNode;
  private
    { Private declarations }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Public declarations }
  procedure OnClickMenu_RestartXP(sender : Tobject);
  end;

var
  Form27: TForm27;
  LastSelect : String ='';
  Menu_RestartXP : TMenuItem;

const ResX : array [1..15]of cardinal = (320,400,480,512,640,720,800,848,960,1024,1152,1280,1360,1600,1920);
const ResY : array [1..18]of cardinal = (200,240,300,360,384,400,480,576,600,768,720,768,864,900,960,1024,1080,1200);
implementation

{$R *.dfm}

uses Unit1, Unit19, mdlfnct, ModuleSup;

procedure TForm27.MessageAide(var msg:TMessage);
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

procedure TForm27.OnClickMenu_RestartXP(sender : Tobject);
begin
RebootXP(not RebootXPExists);
end;

function TForm27.RebootXPExists() : Boolean;
var Reg: TRegistry;
begin
result := True;
  if Form19.WindowsVersion <> 'Windows XP' then Exit;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', True)
    then begin
              if not Reg.ValueExists('DefaultDomainName') then result := False;
              if not Reg.ValueExists('DefaultUserName')  then result := False;
              if not Reg.ValueExists('DefaultPassword')  then result := False;
              if Reg.ReadString('AutoAdminLogon') <> '1' then result := False;
         end;
  finally
    Reg.Free;
    inherited;
  end;

end;


procedure TForm27.RebootXP(Activate : Boolean);
var Reg: TRegistry;
    domaine, user, password : string;
begin
  if Form19.WindowsVersion <> 'Windows XP' then Exit;
  domaine := GetEnvironmentVariable('USERDOMAIN');
  user := GetEnvironmentVariable('USERNAME');

  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon', True)
    then begin
         if Activate = True
         then begin
              domaine := form1.Saisie('Windows XP session auto','Veuillez saisir votre nom de domaine',domaine, False);
              user := form1.Saisie('Windows XP session auto','Veuillez saisir votre nom d''utilisateur',user, False);
              password := form1.Saisie('Windows XP session auto','Veuillez saisir votre mot de passe','', True);

              Reg.WriteString('DefaultDomainName',domaine);
              Reg.WriteString('DefaultUserName',User);
              Reg.WriteString('DefaultPassword',password);
              Reg.WriteString('AutoAdminLogon','1');
              Reg.CloseKey;
              Menu_RestartXP.Caption := 'Ne pas ouvrir la session au démarrage';
              end
         else begin
              Reg.DeleteValue('DefaultPassword');
              Reg.DeleteValue('AutoAdminLogon');
              Menu_RestartXP.Caption  := 'Ouvrir une session au démarrage';
              end;
         end;
  finally
    Reg.Free;
    inherited;
  end;

end;

Function TForm27.TestFonction(): Boolean;
var SValeur : String;
    IValeur : integer;
    i : integer;
    ResOk : Boolean;
begin
result := True;
if TreeView1.Selected.Text = 'Résolution'
then begin
     ResOk := False;
     for i := 1 to length(ResX)
     do if IntToStr(ResX[i]) = ComboBox1.Text then ResOk := True;
     if ResOk = False
     then begin
          MessageDlg('Le paramètre 1 n''est pas valide. Veuillez séléctionner une valeur dans le menu déroulant.',mtError,[mbOk],0);
          result := False;
          end;

     ResOk := False;
     for i := 1 to length(ResY)
     do if IntToStr(ResY[i]) = ComboBox2.Text then ResOk := True;
     if ResOk = False
     then begin
          MessageDlg('Le paramètre 2 n''est pas valide. Veuillez séléctionner une valeur dans le menu déroulant.',mtError,[mbOk],0);
          result := False;
          end;
     if (ComboBox3.Text <> '8 bits') and (ComboBox3.Text <> '16 bits') and (ComboBox3.Text <> '24 bits') and (ComboBox3.Text <> '32 bits')
     then begin
          MessageDlg('Le paramètre 3 n''est pas valide. Veuillez séléctionner une valeur dans le menu déroulant.',mtError,[mbOk],0);
          result := False;
          end;
     if result = True
     then begin
          if ComboBox3.Text = '8 bits' then Svaleur := '8' else Svaleur := ComboBox3.Text[1] + ComboBox3.Text[2];
          IValeur := Form19.ChangeResolEcran(StrToInt(ComboBox1.Text),StrToInt(ComboBox2.Text),StrToInt(SValeur),False);
          if IValeur = DISP_CHANGE_BADMODE then MessageDlg('Le mode Graphique n''est pas supporté. Un nouveau test sera effectué avant l''exécution de votre macro.',mtInformation,[mbOk],0);
          if IValeur = DISP_CHANGE_FAILED  then MessageDlg('Le test de changement de résolution a echoué. Un nouveau test sera effectué avant l''exécution de votre macro.',mtInformation,[mbOk],0);
          if IValeur = DISP_CHANGE_RESTART then MessageDlg('Attention, votre configuration demande un redémarrage du PC. Un nouveau test sera effectué avant l''exécution de votre macro.',mtInformation,[mbOk],0);
          end;
     end;
if TreeView1.Selected.Text = 'Copier vers bmp'
then begin
     SValeur := FnctTypeVar(ComboBox1.Text);
     if (SValeur = TNo) and (FileNameValide(ComboBox1.Text) = False)
     then begin
          MessageDlg('Le paramètre 1 n''est pas un nom de fichier valide.',mtError,[mbOk],0);
          result := False;
          end;
     if (SValeur = TNo) and (FileNameValide(ComboBox1.Text) = True) and (ExtractFileExt(ComboBox1.Text) <> '.bmp')
     then begin
          MessageDlg('Le paramètre 1 n''est pas un fichier avec l''extension .bmp.',mtError,[mbOk],0);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          MessageDlg('Le paramètre 1 ne peut pas être une variable numèrique.',mtError,[mbOk],0);
          result := False;
          end;
     end;
if TreeView1.Selected.Text = 'Copier vers Jpg'
then begin
     SValeur := FnctTypeVar(ComboBox1.Text);
     if (SValeur = TNo) and (FileNameValide(ComboBox1.Text) = False)
     then begin
          MessageDlg('Le paramètre 1 n''est pas un nom de fichier valide.',mtError,[mbOk],0);
          result := False;
          end;
     if (SValeur = TNo) and (FileNameValide(ComboBox1.Text) = True) and (ExtractFileExt(ComboBox1.Text) <> '.jpg')
     then begin
          MessageDlg('Le paramètre 1 n''est pas un fichier avec l''extension .jpg.',mtError,[mbOk],0);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          MessageDlg('Le paramètre 1 ne peut pas être une variable numèrique.',mtError,[mbOk],0);
          result := False;
          end;
     end;
if (TreeView1.Selected.Text = 'Copier') or (TreeView1.Selected.Text = 'Déplacer') or (TreeView1.Selected.Text = 'Renommer')
then begin
     SValeur := FnctTypeVar(ComboBox1.Text);
     if (SValeur = TNo) and (FileNameValide(ComboBox1.Text) = False)
     then begin
          MessageDlg('Le paramètre 1 n''est pas un nom de fichier valide.',mtError,[mbOk],0);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          MessageDlg('Le paramètre 1 ne peut pas être une variable numèrique.',mtError,[mbOk],0);
          result := False;
          end;
     SValeur := FnctTypeVar(ComboBox2.Text);
     if (SValeur = TNo)
     then begin
          if ((TreeView1.Selected.Text = 'Copier') or (TreeView1.Selected.Text = 'Déplacer')) and (DirNameValide(ComboBox2.Text) = False)
          then begin
               MessageDlg('Le paramètre 2 n''est pas un répertoire valide.',mtError,[mbOk],0);
               result := False;
               end;
          if  (TreeView1.Selected.Text = 'Renommer') and (FileNameValide(ComboBox2.Text) = False)
          then begin
               MessageDlg('Le paramètre 2 n''est pas un nom de fichier valide.',mtError,[mbOk],0);
               result := False;
               end;

          end;
     if (SValeur = TNum)
     then begin
          MessageDlg('Le paramètre 2 ne peut pas être une variable numèrique.',mtError,[mbOk],0);
          result := False;
          end;
     end;
if (TreeView1.Selected.Text = 'Effacer')
then begin
     SValeur := FnctTypeVar(ComboBox1.Text);
     if (SValeur = TNo) and (FileNameValide(ComboBox1.Text) = False)
     then begin
          MessageDlg('Le paramètre 1 n''est pas un nom de fichier valide.',mtError,[mbOk],0);
          result := False;
          end;
     if (SValeur = TNum)
     then begin
          MessageDlg('Le paramètre 1 ne peut pas être une variable numèrique.',mtError,[mbOk],0);
          result := False;
          end;
     end;
if Label5.Caption = 'Séléctionnez une action dans les sous menus.' then result := False;
end;

procedure TForm27.FnctCopier(Handle:HWND;Source,Cible:String);
var
  lpFileOp:TSHFileOpStructA;
  TabFrom:array[0..255] of char;
  i:integer;

begin
     For i:=0 to length(Source)-1 do TabFrom[i]:=Source[i+1];
     TabFrom[length(Source)]:=#0;// pFrom peut contenir plusieurs noms de fichier. Les noms doivent être séparés par le caractère #0.
     TabFrom[length(Source)+1]:=#0;// d'après mes essais, le dernier nom de fichier doit être suivi de deux caractères #0.

    {-----préparation du paramètre lpFileOp qui sera passé en paramètre à SHFileOperation -----}
     lpFileOp.Wnd:=handle;
     lpFileOp.wFunc:=FO_COPY; // l'action sera une copie
     lpFileOp.pFrom:=TabFrom; // contient le ou les fichiers /dossiers à recopier
     lpFileOp.pTo:=PAnsiChar(Cible);   // ce vers quoi on recopie
     lpFileOp.fFlags:=FOF_ALLOWUNDO;   // préserve la possibilité d'annuler la copie
                              // + FOF_RENAMEONCOLLISION; //si le fichier cible existe déjà, il le copie sous un nom du style copie (1) de..
     { fin de la préparation du paramètre lpFileOp}

     SHFileOperation(lpFileOp); // procède à la copie
end;


procedure TForm27.FnctEffacer(Handle:HWND;Source:String);
var
  lpFileOp:TSHFILEOPSTRUCTA;
  TabFrom:array[0..255] of char;
  i:integer;

begin
     For i:=0 to length(Source)-1 do TabFrom[i]:=Source[i+1];
     TabFrom[length(Source)]:=#0;
     TabFrom[length(Source)+1]:=#0;

     lpFileOp.Wnd:=handle;
     lpFileOp.wFunc:=FO_DELETE; // l'action sera un effacement
     lpFileOp.pFrom:=TabFrom; // contient le ou les fichiers /dossiers à recopier
     lpFileOp.pTo:='';
     lpFileOp.fFlags:=FOF_ALLOWUNDO;   // préserve la possibilité d'annuler l'effacement

     SHFileOperation(lpFileOp); // procède à l'effacement
end;

procedure TForm27.FnctDeplacer(Handle:HWND;Source,Cible:String);
var
  lpFileOp:TSHFILEOPSTRUCTA;
  TabFrom:array[0..255] of char;
  i:integer;

begin
     For i:=0 to length(Source)-1 do TabFrom[i]:=Source[i+1];
     TabFrom[length(Source)]:=#0;
     TabFrom[length(Source)+1]:=#0;


     lpFileOp.Wnd:=handle;
     lpFileOp.wFunc:=FO_MOVE; // l'action sera un déplacement
     lpFileOp.pFrom:=TabFrom; // contient le ou les fichiers /dossiers à déplacer
     lpFileOp.pTo:=PAnsiChar(Cible);     // ce vers quoi on déplace
     lpFileOp.fFlags:=FOF_ALLOWUNDO;   // préserve la possibilité d'annuler le déplacement
                              // + FOF_RENAMEONCOLLISION; //si le fichier cible existe déjà, il le copie sous un nom du style copie (1) de..

     SHFileOperation(lpFileOp); // procède au déplacement
end;


procedure TForm27.FnctRenommer(Handle:HWND;Source,Cible:String);
var
  lpFileOp:TSHFILEOPSTRUCTA;
  TabFrom:array[0..255] of char;
  i:integer;

begin
     For i:=0 to length(Source)-1 do TabFrom[i]:=Source[i+1];
     TabFrom[length(Source)]:=#0;
     TabFrom[length(Source)+1]:=#0;

     lpFileOp.Wnd:=handle;
     lpFileOp.wFunc:=FO_RENAME; // l'action sera un "renommage"
     lpFileOp.pFrom:=TabFrom; // contient le ou les fichiers /dossiers à déplacer
     lpFileOp.pTo:=PAnsiChar(Cible);     // ce vers quoi on déplace
     lpFileOp.fFlags:=FOF_ALLOWUNDO;   // préserve la possibilité d'annuler le déplacement
                              // + FOF_RENAMEONCOLLISION; //si le fichier cible existe déjà, il le copie sous un nom du style copie (1) de..

     SHFileOperation(lpFileOp); // procède au déplacement
end;

procedure TForm27.ActiveParam(number : integer; Active : Boolean);
begin
if number = 1 then
begin
     if Active = false
     then ComboBox1.Text := '';
     ComboBox1.Enabled := Active;
     ComboBox1.Items.Clear;
     Label1.Enabled := Active;
     SpeedButton1.Enabled := Active;
end;
if number = 2 then
begin
     if Active = false
     then ComboBox2.Text := '';
     ComboBox2.Enabled := Active;
     ComboBox2.Items.Clear;
     Label2.Enabled := Active;
     SpeedButton2.Enabled := Active;
end;
if number = 3 then
begin
     if Active = false
     then ComboBox3.Text := '';
     ComboBox3.Enabled := Active;
     ComboBox3.Items.Clear;
     Label3.Enabled := Active;
     SpeedButton3.Enabled := Active;
end;

end;

procedure TForm27.TreeView1Click(Sender: TObject);
var i : integer;
begin
if TreeView1.Selected <> nil
then begin
     if TreeView1.Selected.Parent <> nil
     then if TreeView1.Selected.Parent.Text = 'Affichage' then Form27.HelpContext := HelpOutilAffichage;
     if TreeView1.Selected.Text = 'Affichage' then Form27.HelpContext := HelpOutilAffichage;

     if TreeView1.Selected.Parent <> nil
     then if TreeView1.Selected.Parent.Text = 'Alimentation' then Form27.HelpContext := HelpOutilAlimentation;
     if TreeView1.Selected.Text = 'Alimentation' then Form27.HelpContext := HelpOutilAlimentation;

     if TreeView1.Selected.Parent <> nil
     then if TreeView1.Selected.Parent.Text = 'Ecran' then Form27.HelpContext := HelpOutilEcran;
     if TreeView1.Selected.Text = 'Ecran' then Form27.HelpContext := HelpOutilEcran;

     if TreeView1.Selected.Parent <> nil
     then if TreeView1.Selected.Parent.Text = 'Fichier' then Form27.HelpContext := HelpOutilFichier;
     if TreeView1.Selected.Text = 'Fichier' then Form27.HelpContext := HelpOutilFichier;

     if TreeView1.Selected.Parent <> nil
     then if TreeView1.Selected.Parent.Text = 'Répertoire' then Form27.HelpContext := HelpOutilRepertoire;
     if TreeView1.Selected.Text = 'Répertoire' then Form27.HelpContext := HelpOutilRepertoire;

     end;



if LastSelect <> TreeView1.Selected.Text
then begin
ActiveParam(1,False); ActiveParam(2,False); ActiveParam(3,False);
Label5.Caption := 'Séléctionnez une action dans les sous menus.';
if TreeView1.Selected.Text = 'Résolution'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 la longueur et dans le paramètre 2 la largeur de l''ecran (en pixels). Séléctionnez la qualité des couleurs dans le paramètre 3.';
     ActiveParam(1,True); ActiveParam(2,True); ActiveParam(3,True);
     SpeedButton1.Enabled := False;
     SpeedButton2.Enabled := False;
     SpeedButton3.Enabled := False;

     for i := 1 to length(ResX)
     do ComboBox1.Items.Add(IntToStr(ResX[i]));
     for i := 1 to length(ResY)
     do ComboBox2.Items.Add(IntToStr(ResY[i]));

     ComboBox3.Items.Add('8 bits');
     ComboBox3.Items.Add('16 bits');
     ComboBox3.Items.Add('24 bits');
     ComboBox3.Items.Add('32 bits');

     ComboBox1.Text := '800';
     ComboBox2.Text := '600';
     ComboBox3.Text := '16 bits';
     end;

if TreeView1.Selected.Text = 'Fréquence'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 la fréquence désirée (exprimée en HZ).';
     ActiveParam(1,True); ActiveParam(2,False); ActiveParam(3,False);
     SpeedButton1.Enabled := False;
     SpeedButton2.Enabled := False;
     SpeedButton3.Enabled := False;
     ComboBox1.Items.Add('60');
     ComboBox1.Items.Add('70');
     ComboBox1.Items.Add('72');
     ComboBox1.Items.Add('75');
     ComboBox1.Items.Add('85');
     ComboBox1.Items.Add('100');
     ComboBox1.Items.Add('120');
     ComboBox1.Items.Add('140');
     ComboBox1.Items.Add('144');
     ComboBox1.Items.Add('150');
     ComboBox1.Items.Add('170');
     ComboBox1.Items.Add('200');
     ComboBox1.Text := '60';
     end;


if TreeView1.Selected.Text = 'Eteindre'
then label5.Caption := 'Pas de paramètre.';

if TreeView1.Selected.Text = 'Redémarrer'
then label5.Caption := 'Pas de paramètre.';

if TreeView1.Selected.Text = 'Fermer la session'
then label5.Caption := 'Pas de paramètre. Attention vous devez disposer d''une version de Windows multi-session ( Nt, 2000, Xp).';

if TreeView1.Selected.Text = 'Mise en veille'
then begin
     label5.Caption := 'Indiquez dans le paramètre 1 si vous desirez une veille prolongée ou pas.';
     ActiveParam(1,True);
     SpeedButton1.Enabled := False;
     ComboBox1.Items.Add('Oui');
     ComboBox1.Items.Add('Non');
     ComboBox1.Text := 'Non';
     end;

if TreeView1.Selected.Text = 'Copier vers bmp'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le nom du fichier voulu (*.bmp).';
     ActiveParam(1,True);
     form1.List_Var(ComboBox1.Items, True, False);
     end;

if TreeView1.Selected.Text = 'Copier vers jpg'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le nom du fichier voulu (*.jpg).';
     ActiveParam(1,True);
     form1.List_Var(ComboBox1.Items, True, False);
     end;

if TreeView1.Selected.Text = 'Copier'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le nom du fichier à copier, puis dans le paramètre 2 le dossier de destination.';
     ActiveParam(1,True); ActiveParam(2,True);
     form1.List_Var(ComboBox1.Items, True, False);
     form1.List_Var(ComboBox2.Items, True, False);
     end;

if TreeView1.Selected.Text = 'Déplacer'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le nom du fichier à déplacer, puis dans le paramètre 2 le dossier de destination.';
     ActiveParam(1,True); ActiveParam(2,True);
     form1.List_Var(ComboBox1.Items, True, False);
     form1.List_Var(ComboBox2.Items, True, False);
     end;

if TreeView1.Selected.Text = 'Effacer'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le nom du fichier à effacer, puis dans le paramètre 2 si le fichier a effacer doit se trouver dans la corbeille.';
     ActiveParam(1,True); ActiveParam(2,True);
     SpeedButton2.Enabled := False;
     ComboBox2.Items.Add('Oui');
     ComboBox2.Items.Add('Non');
     ComboBox2.Text := 'Oui';
     form1.List_Var(ComboBox1.Items, True, False);
     end;

if TreeView1.Selected.Text = 'Renommer'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le nom du fichier( ou dossier) à renommer, puis dans le paramètre 2 le nouveau nom du fichier (ou dossier).';
     ActiveParam(1,True); ActiveParam(2,True);
     form1.List_Var(ComboBox1.Items, True, False);
     form1.List_Var(ComboBox2.Items, True, False);
     end;
end;

if TreeView1.Selected.Text = 'Rechercher'
then begin
     label5.Caption := 'Inserez dans le paramètre 1 le repertoire de recherche, puis dans le paramètre 2 votre recherche,puis dans le paramètre 3 le nom du fichier texte où le resulta sera stocké.';
     ActiveParam(1,True); ActiveParam(2,True);  ActiveParam(3,True);
     form1.List_Var(ComboBox1.Items, True, False);
     form1.List_Var(ComboBox2.Items, True, False);
     form1.List_Var(ComboBox3.Items, True, False);
     SpeedButton2.Enabled := False;
     ComboBox2.Text := '*.*';
     end;

if TreeView1.Selected.Parent <> nil
then begin
     if TreeView1.Selected.Parent.Text = 'Répertoire'
     then begin
          label5.Caption := 'Inserez dans le paramètre 1 le nom du répertoire a créer ou a supprimer.';
          ActiveParam(1,True);
          form1.List_Var(ComboBox1.Items, True, False);
          end;
     end;

LastSelect := TreeView1.Selected.Text;
end;

procedure TForm27.Button2Click(Sender: TObject);
begin
form27.Close;
end;

procedure TForm27.Button1Click(Sender: TObject);
var param : String;
begin
if TestFonction = True
then begin
param := TreeView1.Selected.Text + SprPr;
if ComboBox1.Enabled = True then param := param + ComboBox1.Text + SprPr;
if ComboBox2.Enabled = True then param := param + ComboBox2.Text + SprPr;
if ComboBox3.Enabled = True then param := param + ComboBox3.Text + SprPr;

if unit1.sw_modif = False
then begin
     form1.add_insert('Outil ' + TreeView1.Selected.Parent.Text,param,20);
    end
else begin
     Form1.ListView1.Selected.SubItems.Strings[0] := param;
     Form1.SaveBeforeChange(Form1.ListView1.Selected);
     end;
Form27.close;
end;
end;

procedure TForm27.SpeedButton1Click(Sender: TObject);
var Dir : String;
    ShowDirectory : Boolean;
begin
ShowDirectory := False;
OpenDialog1.Filter := 'Tous les Fichiers (*.*)|*.*';
OpenDialog1.DefaultExt := '';

if TreeView1.Selected.Parent.Text = 'Répertoire' then ShowDirectory := True;
if (TreeView1.Selected.Parent.Text = 'Fichier') and (TreeView1.Selected.Text = 'Rechercher')
then ShowDirectory := True;

if TreeView1.Selected.Text = 'Copier vers bmp'
then begin
    OpenDialog1.DefaultExt := 'bmp';
    OpenDialog1.Filter := 'Fichiers Bitmap (*.bmp)|*.bmp';
    end;

    if TreeView1.Selected.Text = 'Copier vers jpg'
then begin
     OpenDialog1.DefaultExt := 'jpg';
     OpenDialog1.Filter := 'Fichiers jpg (*.jpg)|*.jpg';
     end;

if ShowDirectory = True
then begin
     if SelectDirectory('Entrez le nom du répertoire','',Dir) then ComboBox1.Text := Dir;
     end
else begin
     if Opendialog1.Execute then ComboBox1.Text := OpenDialog1.FileName;
     end;
end;

procedure TForm27.SpeedButton2Click(Sender: TObject);
var Dir : String;
begin
if TreeView1.Selected.Parent <> nil
then if TreeView1.Selected.Parent.Text = 'Fichier'
     then begin
          if (TreeView1.Selected.Text = 'Déplacer') or (TreeView1.Selected.Text = 'Copier')
          then begin if SelectDirectory('Entrez le nom du répertoire','',Dir) then ComboBox2.Text := Dir; end
          else begin if Opendialog1.Execute then ComboBox2.Text := OpenDialog1.FileName; end;
          end;
end;

procedure TForm27.SpeedButton3Click(Sender: TObject);
begin
if Opendialog1.Execute then ComboBox3.Text := OpenDialog1.FileName;
end;

Function TForm27.FindNode(TView : TTreeView; Rubrique : String) : TTreeNode;
var i : integer;
begin
result := nil;
for i := 0 to TView.Items.Count -1 do
if Tview.Items.Item[i].Text = Rubrique
then result := Tview.Items.Item[i];
end;

procedure TForm27.Form27Show(Rubrique : String);
var i : integer;
begin
Treeview1.FullCollapse;

for i := 0 to TreeView1.Items.Count -1 do
if Treeview1.Items.Item[i].Text = Rubrique
then Treeview1.Items.Item[i].Selected := True;

Treeview1.Selected.Expanded;
Treeview1.OnClick(self);
end;

procedure TForm27.FormShow(Sender: TObject);
var param : string;
    listParam : Tparam;
    i : integer;
    Categorie : string;
begin
Treeview1.FullCollapse;

if unit1.sw_modif = true
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     Categorie := Copy(form1.listview1.Selected.Caption,length('Outil ')+1,length(form1.listview1.Selected.Caption)-length('Outil '));
     listParam := form1.GetParam(param);
     for i := 0 to TreeView1.Items.Count -1 do
     if Treeview1.Items.Item[i].Text = ListParam.param[1]
     then if Treeview1.Items.Item[i].Parent.Text = Categorie
          then Treeview1.Items.Item[i].Selected := True;
     Treeview1.Selected.Expanded;
     Treeview1.OnClick(self);
     comboBox1.Text := ListParam.param[2];
     comboBox2.Text := ListParam.param[3];
     comboBox3.Text := ListParam.param[4];
     end
else begin
     Treeview1.Items.Item[0].Selected := True;
     Treeview1.OnClick(self);
     end;
end;

procedure TForm27.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := False;
end;

procedure TForm27.FormCreate(Sender: TObject);
begin
if Form19.WindowsVersion <> 'Windows XP' then Exit;

Menu_RestartXP := TMenuItem.Create(Form1.Outils1);
Menu_RestartXP.OnClick := OnClickMenu_RestartXP;
if not RebootXPExists
then Menu_RestartXP.Caption := 'Ouvrir une session au démarrage'
else Menu_RestartXP.Caption := 'Ne pas ouvrir la session au démarrage';

Form1.Outils1.Add(Menu_RestartXP);
end;

end.
