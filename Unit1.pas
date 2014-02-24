unit Unit1;
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Registry,
  Menus, ImgList, ComCtrls, Buttons, ExtCtrls, Grids, IniFiles, stdctrls, Printers, ClipBrd,
  ShellAPi, ValEdit, StrUtils, XPMenu, HotKeymanager,Consts,
  SysConst, uDebugEx, ResourcesMaker,  ShlObj, DateUtils, Variants,
  OleCtrls, CommCtrl, SHDocVw;

const
  WM_NEWTASK = WM_USER + 1233;

  WM_MYMESSAGE= WM_USER+100;
  WM_PLUGIN_MSG = WM_USER + 1234;
  WM_STOP_UNDER_MACRO = WM_USER + 1235;
  WM_LIST_ORDER = WM_USER + 1236;
  WM_POS_ORDER = WM_USER + 1237;
  GET_VAR_VALUE = WM_USER + 1238;
  SET_VAR_VALUE = WM_USER + 1239;
  PLUGIN_ERROR_OF_EXECUTE =  WM_USER +1240;
  WM_ADD_ORDER = WM_USER + 1241;

  const CaseOfExecuteTab: array [0..31]of string =
  ('Goto','Procedure','Label','Examine','Variable',
  'ScriptEval','Move Mouse','Click','Trouve image',
  'Lire','Ecrire','Calcul','Calcul évolué','Fonction',
  'Commentaire','Champs','Type','Execute','Parcours souris',
  'Type Special','Objet','Question','Manipulation','Pause',
  'Outil Fichier','Outil Ecran','Outil Affichage','Outil Alimentation'
  ,'Outil Répertoire','Quitter','Inclusion','Message');

  TNum = 'Numerique'; TAlpha = 'Alpha'; TNo = 'No_Type';

  DateCreation = '28/01/10';
  VersionType = 1; // 1 Stable, 2 Beta, 3 Test

  HelpGeneral = 1;
  HelpControl = 12;
  HelpRapport = 13;
  HelpVarSysDate = 32;
  HelpVarSysHeure = 33;
  HelpVarSysClipBoard = 34;
  HelpVarSysTexte = 35;
  HelpVarSysEcran = 36;
  HelpVarSysCurseur = 37;
  HelpVarSysHandle = 38;
  HelpVarSysHazard = 39;
  HelpVarSysFichier = 40;
  HelpVarSysRepertoire = 41;
  HelpOutilAffichage = 42;
  HelpOutilAlimentation = 43;
  HelpOutilEcran = 44;
  HelpOutilFichier = 45;
  HelpOutilRepertoire = 46;

type TOrdre = record
     commande : String[20];
     textparam : String[255];
     end;

type Tparam = packed record
     param : array [1..20] of String[255];
     nbr_param : integer;
     end;

type TActiveOrder = array of Boolean;

type TListFile = record
     Name : array of string;
     MemFile : array of TextFile;
     Index : array of integer;
     end;

type TOrderColor = packed record
     Name : String;
     Color : TColor;
     end;

type
  TTimeoutOrVersion = record
    case Integer of          // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT);
      1: (uVersion: UINT);   // Only used when sending a NIM_SETVERSION message
  end;

type TIgnoreMsg = record
     Pos : string;
     Msg : String;
     Exists : boolean;
     end;
type TTabIgnoreMsg = array of TIgnoreMsg;

type
  TNotifyIconDataEx = record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;  // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    TimeoutOrVersion: TTimeoutOrVersion;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
{$IFDEF _WIN32_IE_600}
    guidItem: TGUID;  // Reserved for WinXP; define _WIN32_IE_600 if needed
{$ENDIF}
  end;

type
TVar = record
     Name : String;
     Value : String;
     TypeVar : String;
     end;
TListVar = array of TVar;

TArrayString = array of String;

TInclude = record
         FileName : String;
         Index : integer;
         count : integer;
         end;

TTabOfInclude =array of TInclude;

TInfoListview = record
    index : integer;
    Bullet : Boolean;
    BulletColor : TColor;
    SignetNr : integer;
    end;

type
  TForm1 = class(TForm)
    PaintPanel1 : TPanel;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    Macro1: TMenuItem;
    Nouveau1: TMenuItem;
    Ouvrir1: TMenuItem;
    Enregistrer1: TMenuItem;
    Enregistersous1: TMenuItem;
    Quitter1: TMenuItem;
    Edition1: TMenuItem;
    Editer1: TMenuItem;
    Supprimer1: TMenuItem;
    Mode1: TMenuItem;
    Edition2: TMenuItem;
    Insertion1: TMenuItem;
    Executer1: TMenuItem;
    Execute1: TMenuItem;
    Paspas1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Couper1: TMenuItem;
    Copier1: TMenuItem;
    Coller1: TMenuItem;
    Supprimer2: TMenuItem;
    Couper2: TMenuItem;
    Copier2: TMenuItem;
    Coller2: TMenuItem;
    Insereruncommentaire1: TMenuItem;
    Stop1: TMenuItem;
    Imprimer1: TMenuItem;
    Dfaire1: TMenuItem;
    Outils1: TMenuItem;
    RechercherObjet1: TMenuItem;

    ImageList1: TImageList;
    ImageList2: TImageList;
    ImageList3: TImageList;

    PrintDialog1: TPrintDialog;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    OpenDialog1: TOpenDialog;
    OpenDialog2: TOpenDialog;
    FindDialog1: TFindDialog;
    FindDialog2: TFindDialog;

    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    Monterdunniveau1: TMenuItem;
    Descendredunniveau1: TMenuItem;
    Options1: TMenuItem;
    Recents1: TMenuItem;
    mesoutils1: TMenuItem;

    Pointdarrt1: TMenuItem;
    Reprendrelexcution1: TMenuItem;
    Aide1: TMenuItem;
    Consulter1: TMenuItem;
    Apropos1: TMenuItem;
    Dtailcommandes1: TMenuItem;
    Spy1: TMenuItem;
    Enregistrerunesequence1: TMenuItem;
    PageControl1: TPageControl;
    PageControl2: TPageControl;

    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;

    ListView2: TListView;

    RichEdit1: TRichEdit;
    PopupMenu2: TPopupMenu;
    Rafr1: TMenuItem;
    Enregister1: TMenuItem;
    Imprimer2: TMenuItem;
    Rechercher1: TMenuItem;
    PopupMenu3: TPopupMenu;
    Quitter2: TMenuItem;
    Rechercher2: TMenuItem;
    Danslescommandes1: TMenuItem;
    Danslesparamtres1: TMenuItem;
    Danslescommandesetparamtres1: TMenuItem;
    Crypter1: TMenuItem;

    RichEdit2: TRichEdit;
    Splitter2: TSplitter;

    PopupMenu4: TPopupMenu;
    Annuler1: TMenuItem;

    Couper3: TMenuItem;
    Copier3: TMenuItem;
    Coller3: TMenuItem;
    Supprimer3: TMenuItem;


    SlctionnerTout1: TMenuItem;

    Enregistrer2: TMenuItem;
    Envoyeralauteur1: TMenuItem;
    PopupMenu5: TPopupMenu;
    Dvelopper1: TMenuItem;
    Rduire1: TMenuItem;

    valuer1: TMenuItem;
    CheckBox1: TCheckBox;

    valuer2: TMenuItem;

    ListView3: TListView;
    ListView4: TListView;



    Modificattion1: TMenuItem;
    Refaire1: TMenuItem;
    Panel1: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    CheckBox3: TCheckBox;
    ReplaceDialog1: TReplaceDialog;
    Remplacer1: TMenuItem;
    Splitter3: TSplitter;

    PopupMenu6: TPopupMenu;
    Ajouter1: TMenuItem;
    Modifier1: TMenuItem;
    Supprimer4: TMenuItem;
    Reinitialiertouteslesvariable1: TMenuItem;
    Supprimertouteslesvariables1: TMenuItem;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    SpeedButton7: TSpeedButton;
    SpeedButton8: TSpeedButton;
    SpeedButton9: TSpeedButton;
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
    SpeedButton36: TSpeedButton;
    SpeedButton37: TSpeedButton;
    SpeedButton38: TSpeedButton;
    SpeedButton100: TSpeedButton;
    SpeedButton101: TSpeedButton;
    SpeedButton102: TSpeedButton;
    SpeedButton106: TSpeedButton;
    SpeedButton107: TSpeedButton;
    SpeedButton108: TSpeedButton;
    SpeedButton103: TSpeedButton;
    SpeedButton104: TSpeedButton;
    SpeedButton105: TSpeedButton;
    SpeedButton109: TSpeedButton;
    SpeedButton110: TSpeedButton;
    SpeedButton111: TSpeedButton;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Splitter1: TSplitter;



    Gestiondesnouvellecommandes1: TMenuItem;
    Aperuavantimpression1: TMenuItem;

    MiseenForme1: TMenuItem;
    Exporterversexecutable1: TMenuItem;
    ComboBox1: TComboBox;
    Label1: TLabel;


    Sauvegardeducontextedexcution1: TMenuItem;



    Collerapartirduntextesimple1: TMenuItem;

    Copier4: TMenuItem;
    Slctionnertout2: TMenuItem;
    ExporterversOtherLangage1: TMenuItem;
    Gestionnairedetche1: TMenuItem;
    ActiveCom: TMenuItem;
    Activer1: TMenuItem;
    Dsactiver1: TMenuItem;

    TreeView1: TTreeView;
    Occurencesuivante1: TMenuItem;
    Rechercherladclaration1: TMenuItem;
    ListView1: TListView;
    Ignorercetteavertissement1: TMenuItem;
    Restituerlesavertissementsignors1: TMenuItem;
    N25: TMenuItem;
    Copierlavaleur1: TMenuItem;
    CopierauformatphpBB1: TMenuItem;
    HTML1: TMenuItem;
    phpBB1: TMenuItem;
    SpeedButton30: TSpeedButton;
    OtherLangEditor1: TMenuItem;
    Apropos2: TMenuItem;
    SpeedButton31: TSpeedButton;
    PopupMenu7: TPopupMenu;
    Rechercher3: TMenuItem;
    Label2: TLabel;
    Image1: TImage;
    N26: TMenuItem;
    Inclusion1: TMenuItem;
    Charger1: TMenuItem;
    Dcharger1: TMenuItem;
    ColorDialog1: TColorDialog;
    PaintBox1: TPaintBox;
    PopupMenu8: TPopupMenu;
    Changercouleurbullet1: TMenuItem;
    Couleurbulletslectionn1: TMenuItem;
    Installerunsignets1: TMenuItem;
    N01: TMenuItem;
    N110: TMenuItem;
    N28: TMenuItem;
    N31: TMenuItem;
    N41: TMenuItem;
    N51: TMenuItem;
    N61: TMenuItem;
    N71: TMenuItem;
    N81: TMenuItem;
    N91: TMenuItem;
    Allerausignet1: TMenuItem;
    N02: TMenuItem;
    N111: TMenuItem;
    N29: TMenuItem;
    N32: TMenuItem;
    N42: TMenuItem;
    N52: TMenuItem;
    N62: TMenuItem;
    N72: TMenuItem;
    N82: TMenuItem;
    N92: TMenuItem;
    N30: TMenuItem;
    N33: TMenuItem;
    oussupprimer1: TMenuItem;
    Ajoutertouslesbullets1: TMenuItem;
    Placerdanslevisualisateurdevariable1: TMenuItem;

    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton8Click(Sender: TObject);

    function GetParam(strParam : String):TParam;
    function GetParamToStr(Params : TParam) : String;
    procedure Enregistrer1Click(Sender: TObject);
    procedure Enregistersous1Click(Sender: TObject);
    procedure SaveMacro(List : TListView= nil);
    procedure Ouvrir1Click(Sender: TObject);
    procedure Nouveau1Click(Sender: TObject);
    procedure Editer1Click(Sender: TObject);
    procedure Supprimer1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Quitter1Click(Sender: TObject);
    procedure Execute(Sender: TObject; WithContext : Boolean = False; StartAt : integer =0);
    procedure Execute1Click(Sender: TObject);
    procedure Insertion1Click(Sender: TObject);
    procedure Edition2Click(Sender: TObject);
    procedure Add_commande(ListView : TListView; Ordre : TOrdre);
    procedure Insert_commande(ListView : TListView; Ordre : TOrdre; index : integer);
    procedure add_insert(Str1, Str2 : String; image_nr : integer);
    procedure SpeedButton6Click(Sender: TObject);
    procedure SpeedButton7Click(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure SpeedButton9Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpeedButton10Click(Sender: TObject);
    procedure SpeedButton11Click(Sender: TObject);
    procedure List_Var(Sender: TStrings; Alpha, Num : Boolean; List : TListView = nil);
    function GetInitialValueofVar(Name :String; Quote : char = #0) : string;
    procedure List_Label(Sender: TObject);
    procedure List_Objet(Sender: TObject);
    procedure List_var_and_objet(Sender : TObject);
    procedure List_procedure(Sender: TObject);
    function procedure_exists(List : TListView; Name : string) : integer;
    function FindEndOfProcedure(List : TListView; Pos : integer) : integer;
    function CanGetEndofProcedure(List : TListView; Pos : integer; Add : Boolean): Boolean;
    procedure ListView1DblClick(Sender: TObject);
    procedure Execute_commande(List : TListView; var Index: integer; var ActiveOrd : TActiveOrder);
    procedure Paspas1Click(Sender: TObject);
    procedure Couper2Click(Sender: TObject);
    procedure Copier2Click(Sender: TObject);
    Function  GetImageIndex(Ordre: Tordre): integer; overload;
    procedure Coller2Click(Sender: TObject);
    procedure Couper1Click(Sender: TObject);
    procedure Copier1Click(Sender: TObject);
    procedure Coller1Click(Sender: TObject);
    procedure Supprimer2Click(Sender: TObject);
    procedure SpeedButton12Click(Sender: TObject);
    procedure SpeedButton13Click(Sender: TObject);
    procedure ListView1MouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
    Procedure New_Var_Name(Sender: TObject);
    Procedure New_Label_Name(Sender: TObject);
    procedure NoDoublonofListBox(Sender : TListBox);
    procedure SpeedButton14Click(Sender: TObject);
    procedure Insereruncommentaire1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Select_unique(Sender: Tobject; Index : integer);
    procedure SpeedButton15Click(Sender: TObject);
    procedure WriteRegistry(Chemin : String; Entete : String; Valeur : String);
    procedure Spy1Click(Sender: TObject);
    function  Fonction_existe(List : TListView; Commande : String ; Parametre : String): boolean;
    function  Fonction_existe_with_param(List : TListView; Commande : String ; Parametre : String; indexofParam : integer): boolean;
    function  Fonction_Pos(Commande : String ; Parametre : String; List : TListView = nil): integer;
    function  VarUse(List : TListView; Variable : String): boolean;
    function  GetTreeViewFullText(Sender: TObject;Fr : Boolean) : String;
    function  FindModif(Index, limit : integer; default : string): String; // pour la fonction historique
    procedure RechercherObjet1Click(Sender: TObject);
    procedure SpeedButton16Click(Sender: TObject);
    // Mise a jour de l'ensemble des commandes utilisant un Handle
    procedure Update_Objet(List : TListView; Old_handle : integer; New_handle : integer);
    Procedure FnctPause(Param : String);
    procedure Monterdunniveau1Click(Sender: TObject);
    procedure MoveCommande(Sender :TListView; Old : integer; New : integer);
    procedure Descendredunniveau1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure AddRecents(File_recents : String);
    procedure ReadRecents;
    procedure ClickRecents(Sender : TObject);
    function OpenFileMacro(file_name : string; ListView : TListView; index : integer; MsgDownload : string): integer;
    function ControlAll(List : TListView): boolean;
    procedure AddToRapport(Order, params : String); // permet de naviguer dans les fichiers du rapport
    procedure FormDestroy(Sender: TObject);
    Function  GetExecParam(index : integer) : string;
    procedure Pointdarrt1Click(Sender: TObject);
    procedure Executer1Click(Sender: TObject);
    procedure Reprendrelexcution1Click(Sender: TObject);
    procedure Consulter1Click(Sender: TObject);
    procedure Edition1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Apropos1Click(Sender: TObject);
    procedure Dtailcommandes1Click(Sender: TObject);
    function SaveBeforeExit(): Boolean; // sauvegarde avant de quitter l'application
    function  MacroChange(): Boolean; //  test si la macro a changé depuis le dernier enregistrement;
    function ChangeVarName(VarIni, VarAfter : String; Change : Boolean) : Boolean; // se produit quand on change le nom d'une variable et que l'on veut rectifier dans toutes les autres commande.
    function ChangeVarNameIntoSimpleText(Text, VarIni, VarAfter : String): String;
    procedure ChangeParam(List : TListView; index,pos : integer; newValue : string; history : boolean);
    procedure OneVarOnly(VarName : String; List : TListView = nil);
    function ReadVariable(const Section, Ident, Default: String): String;
    procedure WriteVariable(const Section, Ident, Value: String);
    procedure SpeedButton17Click(Sender: TObject);
    procedure Enregistrerunesequence1Click(Sender: TObject);
    procedure InitForm1();
    procedure ListView2DblClick(Sender: TObject);
    procedure ListView2ColumnClick(Sender: TObject; Column: TListColumn);
    procedure FormShow(Sender: TObject);
    procedure Rafr1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Enregister1Click(Sender: TObject);
    procedure Rechercher1Click(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure Imprimer2Click(Sender: TObject);
    procedure ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure SpeedButton18Click(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure Outils1Click(Sender: TObject);
    function StrExist(Ch1, Ch2 : String) : Boolean;
    procedure Danslescommandes1Click(Sender: TObject);
    procedure Danslesparamtres1Click(Sender: TObject);
    procedure Danslescommandesetparamtres1Click(Sender: TObject);
    procedure FindDialog2Find(Sender: TObject);
    procedure SpeedButton19Click(Sender: TObject);
    procedure Crypter1Click(Sender: TObject);
    procedure Macro1Click(Sender: TObject);
    procedure SpeedButton20Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure Annuler1Click(Sender: TObject);
    procedure Couper3Click(Sender: TObject);
    procedure Copier3Click(Sender: TObject);
    procedure Coller3Click(Sender: TObject);
    procedure Supprimer3Click(Sender: TObject);
    procedure SlctionnerTout1Click(Sender: TObject);
    procedure Envoyeralauteur1Click(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure ChangeDescription(Theme : String);
    procedure Enregistrer2Click(Sender: TObject);
    procedure Dvelopper1Click(Sender: TObject);
    procedure Rduire1Click(Sender: TObject);
    procedure Openform13withparam(rubrique, format : String);
    procedure PopupMenu4Popup(Sender: TObject);
    procedure ListView1Change(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure FormResize(Sender: TObject);
    procedure valuer1Click(Sender: TObject);
    procedure SpeedButton21Click(Sender: TObject);
    procedure ListView3KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure valuer2Click(Sender: TObject);
    procedure ListView3Click(Sender: TObject);
    procedure SpeedButton22Click(Sender: TObject);
    procedure ListView1Deletion(Sender: TObject; Item: TListItem);
    procedure SaveBeforeChange(Item: TListItem);
    procedure ListView4Click(Sender: TObject);
    procedure SpeedButton25Click(Sender: TObject);
    procedure SpeedButton24Click(Sender: TObject);
    procedure ListView3AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
    procedure SpeedButton23Click(Sender: TObject);
    procedure ListView4Changing(Sender: TObject; Item: TListItem; Change: TItemChange; var AllowChange: Boolean);
    procedure Modificattion1Click(Sender: TObject);
    procedure Dfaire1Click(Sender: TObject);
    procedure Refaire1Click(Sender: TObject);
    procedure AddHistory(Pos : integer; Action, commande, param : String);
    procedure CheckBox3Click(Sender: TObject);
    procedure ReplaceDialog1Replace(Sender: TObject);
    procedure Remplacer1Click(Sender: TObject);
    procedure ListView3DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ListView3EndDrag(Sender, Target: TObject; X, Y: Integer);
    function Saisie(Titre, question,default : String; Pass : Boolean): String; // variable Saisie Boolean pour arret de l'attente
    procedure OnSaisieClose(Sender: TObject; var Action: TCloseAction);
    procedure OnSaisieClickOk(Sender: TObject);
    procedure MenuPanel(Sender: TMenuItem);
    procedure OnCloseMenuPanel(Sender: TObject);
    procedure OnDrawItemMenuPanel(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
    procedure PopupMenu6Popup(Sender: TObject);
    procedure SpeedButton28MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Supprimer4Click(Sender: TObject);
    procedure Modifier1Click(Sender: TObject);
    procedure Ajouter1Click(Sender: TObject);
    procedure Supprimertouteslesvariables1Click(Sender: TObject);
    procedure Reinitialiertouteslesvariable1Click(Sender: TObject);
    procedure PrintComponentList(Form : TForm; TextFileName, SortFileName : String);
    procedure PrintMapArea(Form : TForm; TextFileName, SortFileName : String); // création des coordonnée map pour fichier d'aide
    procedure ListView1Exit(Sender: TObject); // Gestion commande click button
    function  GetNewOrderIndex(Commande : String): integer; overload;
    procedure OnClickNewOrder(Sender : TObject);
    procedure StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure MiseenForme1Click(Sender: TObject);
    function GetListBoxSelected(LBox : TListBox) : integer;
    procedure ListView1Enter(Sender: TObject);
    procedure Gestiondesnouvellecommandes1Click(Sender: TObject);
    procedure HotKeyManager1HotKeyPressed(HotKey: Cardinal; Index: Word);
    procedure N2Click(Sender: TObject);
    procedure Exporterversexecutable1Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure GetDescURLStyle(Desc : String);
    procedure DescURLStyleOnMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DescURLStyleOnclick(sender : TObject);
    procedure SpeedButton27Click(Sender: TObject);
    procedure SpeedButton26Click(Sender: TObject);
    procedure Sauvegardeducontextedexcution1Click(Sender: TObject);
    procedure SpeedButton29Click(Sender: TObject);
    procedure SpeedButton36Click(Sender: TObject);
    procedure SpeedButton37Click(Sender: TObject);
    procedure Collerapartirduntextesimple1Click(Sender: TObject);
    procedure Copier4Click(Sender: TObject);
    procedure Slctionnertout2Click(Sender: TObject);
    procedure Aperuavantimpression1Click(Sender: TObject);
    procedure Imprimer1Click(Sender: TObject);
    procedure Activer1Click(Sender: TObject);
    procedure Dsactiver1Click(Sender: TObject);
    procedure SpeedButton38Click(Sender: TObject);
    procedure ExporterversOtherLangage1Click(Sender: TObject);
    procedure StatusBar1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Gestionnairedetche1Click(Sender: TObject);
    procedure StatusBar1DblClick(Sender: TObject);
    procedure Occurencesuivante1Click(Sender: TObject);
    procedure Rechercherladclaration1Click(Sender: TObject);
    procedure Ignorercetteavertissement1Click(Sender: TObject);
    procedure Restituerlesavertissementsignors1Click(Sender: TObject);
    procedure Copierlavaleur1Click(Sender: TObject);
    procedure phpBB1Click(Sender: TObject);
    procedure HTML1Click(Sender: TObject);
    procedure SpeedButton30Click(Sender: TObject);
    procedure OtherLangEditor1Click(Sender: TObject);
    procedure Apropos2Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure Rechercher3Click(Sender: TObject);
    procedure Charger1Click(Sender: TObject);
    procedure Dcharger1Click(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Couleurbulletslectionn1Click(Sender: TObject);
    procedure Changercouleurbullet1Click(Sender: TObject);
    procedure Quitter2Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure N01Click(Sender: TObject);
    procedure N02Click(Sender: TObject);
    procedure Ajoutertouslesbullets1Click(Sender: TObject);
    procedure oussupprimer1Click(Sender: TObject);
    procedure ListView1Insert(Sender: TObject; Item: TListItem);
  private
    { Déclarations privées }
    procedure TrayMessage(var Msg: TMessage); message WM_MYMESSAGE;
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
    function Authen(App : string):cardinal;
    procedure ShowApplicationError(Sender : TObject; E : Exception); overload;
    procedure ShowApplicationError(Msg : String); overload;
    procedure DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
    procedure ReceiveMsgfromNewOrder(var Message: TMessage); message WM_PLUGIN_MSG;
    procedure StopUnderMacro(var Message: TMessage); message WM_STOP_UNDER_MACRO;
    procedure GiveListOrder(var message: Tmessage); message WM_LIST_ORDER;
    // Form dll plugin
    procedure DLL_POS_ORDER(var message: Tmessage); message WM_POS_ORDER;
    procedure DLL_GET_VAR_VALUE(var message: Tmessage); message GET_VAR_VALUE;
    procedure DLL_SET_VAR_VALUE(var message: Tmessage); message SET_VAR_VALUE;
    procedure DLL_ERROR_TO_EXECUTE(var message : Tmessage); message PLUGIN_ERROR_OF_EXECUTE;
    procedure DLL_ADD_ORDER(var message : Tmessage); message WM_ADD_ORDER;

    function BoolToStr(Value : Boolean) : String; overload;
    function StrToBool(Value : String) : Boolean; overload;
    function  GetImageIndex(Ordre: String): integer; overload;
    function  GetNewOrderIndex(Handle : Hwnd): integer; overload;
    procedure ContextMenuOnClick(Sender : TObject);
    procedure MParcours();
    procedure GetBitmapFromResAll;
    procedure LoadPrintMacro(fileName : String);
    procedure DropMsg(var msg: TWMDropFiles); message WM_DROPFILES;
    procedure CodeToStd(FileName : String; ListView : TListView = nil);
    function ExporterversexecutableAddFile(List: TListView) : Boolean;
    procedure AssignFileDirToVar(fic :String);
    function GetFileIniName():String;
    function ColorForProcedure(List: TListView; index : integer; var Color : TColor): Boolean;
    function StrToFloat(const S: string): Extended; overload;
    function ListVarUseForThisCommand(Index :Integer; List: TListView = nil):TListVar;
    Procedure ErrorComportement(Msg : String; Comportement : cardinal=0);
    procedure RefreshEvaluateVar(Ident,Value : String);
    procedure Delay(Milliseconds: Dword);
    function ShowBalloonTip(Sender: TWinControl; Icon: integer; Title, Text: PChar; Align : cardinal = 0): HWND; //0 TopLeft - 1 TopRight - 2 BottomLeft - 3 BottomRight
    function Form1CaptionUpdate : String;
    procedure SetClipboardHasText(Text : String);
    function  GetClipboardHasText():String;
    function GetClipboardFormat() : cardinal;
    procedure ChangeResolution(Restore : Boolean);
    procedure GetActiveMacro(var List : TListView; var Index : integer);
    procedure LoadTabInclude(var TabOfInclude :TTabOfInclude;  ListView : TListView);
    procedure RestoreTabInclude(var TabOfInclude :TTabOfInclude;  ListView : TListView);
    procedure OtherLangageToClipBoard(FileName : String ='');
    function OtherLangageSelect() : String;
    procedure AnchorForm(FormObj : TForm); // pour palier au problème de changement de taille de police 120ppp
    function ObjectPopMenu(): TWinControl;
    procedure InfoListViewDraw();
    procedure InfoListViewDelete(index : integer);
    procedure InfoListViewInsert(index : integer);
    procedure InfoListViewClear(index : integer = 0);
    function InfoListViewEmpty():boolean;
    function Explode(Chaine :string; car : string) : TArrayString;
  end;

var
  Form1: TForm1;
  XPMenu1: TXPMenu;
  HotKeyManager1: THotKeyManager;
  NotifyStruc : TNotifyIconDataEX;
  pos_command : integer = 0;
  ActiveOrder : TActiveOrder;
  sw_modif : Boolean = False;
  Run : Boolean = False;
  change_liste : Boolean = False;
  application_close : Boolean = false;
  Can_Save : Boolean = True;
  Nbr_Can_Save : integer = 0;
  Index_Can_save : integer = 0;
  CanAddHistory : Boolean = True;
  Oldfenetre : HWND;
  MainFormStatus : TWindowState;
  RapportFile : TextFile;
  RapportFileName : String;
  WaitRedFlag : boolean = false;
  OpenEdt : Boolean = False;
  SprPr : char = ';'; // caractère séparteur de paramètre
  TempDepart : String = '00:00:00';
  TempFin : String = '00:00:00';
  NbrOrderExecute : integer = 0;
  BackGround : TBitmap;
  SortIndex : integer = 0;
  SortAssending : Boolean = False;
  Form32Text : integer = 0;
  Description : TStringList;
  OldSelectTreeView : String = '';
  Save_caption : String = ''; // permet de connaitre le paramètre de n'importe qu'elle commande avant la modification
  BSaisie : Boolean = False; // Uniquement pour la Procedure Saisie
  Variable : TListVar;
  ListFile : TListFile;
  SousMacroExecute : TListView = nil;
  TabSousMacroExecute : array [1..14] of TListView;
  SousMacroExecuteIndex : integer = 0;
  DLL_POS_ORDER_CHANGE : Boolean = False;
  ListColorOrder : array of TOrderColor;
  ALIAS_EXE : string = '';
  EXTAPPHwnd : Hwnd = 0;
  TabIgnoreMsg : TTabIgnoreMsg; // Liste des messages d'avertissement ignoré
  DirectRun : Boolean = False;
  DirectFromExport : Boolean= False;
  TabOfIncludeGen : TTabOfInclude;
  TabInfoListview : array of TInfoListView;
  BulletColor : TColor = clBlue;
  ICONRUN : TIcon;
  HICONSTD : HIcon;
  PaintBox1MouseX :integer;
  PaintBox1MouseY : integer;
  MiniFrame : Boolean = False;
  ShowInfoBulle : Boolean = True;
  // Lng
  Dbg_NoError : String = 'Aucune erreur, ni suggestion n''a été detectée';
  IdentOfOrder : array of Shortint;
  Lng_Point_darret : String = 'Point d''arrêt';
  Lng_Delete_Point_darret : String = 'Supprimer point d''arrêt';
  Lng_Error_with_edit : String = 'Cette macro comportent des erreurs, veuillez consulter le contrôle des commandes.';
  Lng_Error_without_edit : String = 'Cette macro comportent des erreurs, prennez contact avec le concepteur de la macro.';
  Lng_NewMacro : String = 'Nouvelle macro';
  Lng_MenuContextExeSave : String = 'Contexte d''exécution (Sauvegarde)';
  Lng_MenuContextExeDownload : String = 'Contexte d''exécution (Chargement)';

implementation

uses mdlfnct, Unit2, Unit4, Unit5, Unit6, Unit7, Unit3, Unit8, Unit9,Unit10,
  Unit11, Unit12, Unit13, Unit14, Unit15, Unit16, Unit17, Unit18, Unit19,
  Unit20, Debug, Unit23,ModuleSup, Unit24, Unit26, Unit27,
  Unit28,Unit29, Unit30, Unit22, Unit31, Unit32, GestionCommande,
  Unit34, ContextOfExecute, Unit25, Erreurcompil, Unit33,
  Unit36, Unit37, UBackGround;

{$R *.DFM}

const
  HH_HELP_CONTEXT         = $000F;
  HH_DISPLAY_TOPIC        = $0000;
  HH_DISPLAY_SEARCH       = $0003;

function HtmlHelp(hwndCaller: HWND;
  pszFile: PChar; uCommand: UINT;
  dwData: DWORD): HWND; stdcall;
  external 'HHCTRL.OCX' name 'HtmlHelpA';


function TForm1.Explode(Chaine :string; car : string) : TArrayString;
var i : integer;
    Str : String;
begin
SetLength(result,0);
i := Pos(car,chaine);
while i > 0
do begin
   Str := Copy(chaine,0,i);
   setlength(result,length(result)+1);
   result[length(result)-1] := Copy(Str,0,length(Str)-1);
   chaine := Copy(chaine,i+1,length(chaine)-i);
   i := Pos(car,chaine);
   end;
if length(Chaine) > 0
then begin
     setlength(result,length(result)+1);
     result[length(result)-1] := chaine;
     end;
end;

function Tform1.InfoListViewEmpty():boolean;
var i : integer;
begin
result := True;
for i := Low(TabInfoListView) to High(TabInfoListView)
do if (TabInfoListView[i].Bullet = True) or (TabInfoListView[i].SignetNr <> -1)
   then begin
        result := False;
        break;
        end;
end;

procedure TForm1.InfoListViewDraw;
var i,j : integer;
    SelectItem : integer;
    Rct : TRect;
begin
PaintBox1.Canvas.Brush.Color := PaintBox1.Color;
PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);
PaintBox1.Canvas.Pen.Color := $00CC9999;
PaintBox1.Canvas.Font.Color := $00CC9999;
PaintBox1.Canvas.PenPos := point(PaintBox1.Width-1,0);
PaintBox1.canvas.lineTo(PaintBox1.width-1,PaintBox1.height);
PaintBox1.Canvas.TextOut(2,2,'Repère');
i := 0;

if ListView1.Selected = nil then SelectItem := -1 else SelectItem := ListView1.Selected.Index;
if  ListView1.TopItem = nil then Exit;
while i < ListView1.Height
do begin
   j := ListView1.TopItem.Index+1 +(i div 17);

   if j < length(TabInfoListView)+1
   then begin
        if TabInfoListView[j-1].Bullet = True
        then begin
             PaintBox1.Canvas.Pen.Color := TabInfoListView[j-1].BulletColor;
             PaintBox1.Canvas.Brush.Color := TabInfoListView[j-1].BulletColor;
             PaintBox1.Canvas.Ellipse(1,i+27-5,11,i+27+5);
             end;
        if TabInfoListView[j-1].SignetNr <> -1
        then begin
             PaintBox1.Canvas.Pen.Color := clBlack;
             PaintBox1.Canvas.Brush.Color := Clsilver;
             Rct := Rect(14,i+27-10,24,i+27+5);
             PaintBox1.Canvas.Rectangle(rct);

             PaintBox1.Canvas.Brush.Color := Clgreen;
             Rct.Left := Rct.Left-2;
             Rct.Top := Rct.Top+2;
             Rct.Right := Rct.Right-2;
             Rct.Bottom := Rct.Bottom+2;
             PaintBox1.Canvas.Rectangle(Rct);
             PaintBox1.Canvas.Font.Color := clBlack;
             PaintBox1.Canvas.TextOut(rct.Left+2,rct.Top+1,IntToStr(TabInfoListView[j-1].SignetNr));
             PaintBox1.Canvas.Pen.Color := clSilver;
             PaintBox1.Canvas.PenPos :=Point(rct.Left+1,rct.Top+1);
             PaintBox1.Canvas.LineTo(rct.Left+1,rct.Bottom-1);
             end;
        end;

   PaintBox1.Canvas.Pen.Color := $00CC9999;
   PaintBox1.Canvas.Font.Color := $00CC9999;
   PaintBox1.Canvas.Brush.Color := PaintBox1.Color;
   if (j mod 10 = 0) or (j-1 = SelectItem)
   then PaintBox1.Canvas.TextOut(PaintBox1.Width-22,i+22,IntToStr(j))
   else begin
        PaintBox1.Canvas.PenPos := point(PaintBox1.width-5,i+28);
        if j mod 5 = 0
        then PaintBox1.Canvas.LineTo(PaintBox1.Width-10,i+28)
        else PaintBox1.Canvas.LineTo(PaintBox1.Width-6,i+28)
        end;
   Inc(i,17);
   end;
end;

procedure TForm1.InfoListViewDelete(index : integer);
var i : integer;
begin
for i :=  index to High(TabInfoListView)-1
do begin
   TabInfoListView[i].Bullet :=  TabInfoListView[i+1].Bullet;
   TabInfoListView[i].BulletColor :=  TabInfoListView[i+1].BulletColor;
   TabInfoListView[i].SignetNr :=  TabInfoListView[i+1].SignetNr;
   end;
if length(TabInfoListView) > 0
then SetLength(TabInfoListView,length(TabInfoListView)-1);
end;

procedure TForm1.InfoListViewInsert(index : integer);
var i : integer;
begin
SetLength(TabInfoListView,length(TabInfoListView)+1);
for i :=  High(TabInfoListView)-1 downto index
do begin
   TabInfoListView[i+1].Bullet :=  TabInfoListView[i].Bullet;
   TabInfoListView[i+1].BulletColor :=  TabInfoListView[i].BulletColor;
   TabInfoListView[i+1].SignetNr :=  TabInfoListView[i].SignetNr;
   end;
TabInfoListView[index].index := index;
TabInfoListView[index].Bullet :=  False;
TabInfoListView[index].SignetNr := -1;
end;

procedure TForm1.InfoListViewClear(index : integer = 0);
var i: integer;
begin
SetLength(TabInfoListView,index);
PaintBox1.Canvas.Brush.Color := PaintBox1.Color;
PaintBox1.Canvas.FillRect(PaintBox1.ClientRect);
PaintBox1.Canvas.Pen.Color := $00CC9999;
PaintBox1.Canvas.Font.Color := $00CC9999;
PaintBox1.Canvas.PenPos := point(PaintBox1.Width-1,0);
PaintBox1.canvas.lineTo(PaintBox1.width-1,PaintBox1.height);
PaintBox1.Canvas.TextOut(2,2,'Repère');
for i := Low(TabInfoListView) to High(TabInfoListView)
do begin
   TabInfoListView[i].Bullet := False;
   TabInfoListView[i].SignetNr := -1;
   end;
end;

procedure TForm1.MessageAide(var msg:TMessage);
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

function TForm1.ObjectPopMenu(): TWinControl;
var i : integer;
    Frm : TForm;
    Obj : TWinControl;
begin
result := nil;
Frm := nil;
for i := 1 to 37
do begin
   if (Application.FindComponent('Form'+ InttoStr(i)) as TForm) = nil then continue;
   if (Application.FindComponent('Form'+ InttoStr(i)) as TForm).Active
   then Frm := (Application.FindComponent('Form'+ InttoStr(i)) as TForm);
   end;
if Frm = nil then Exit;
Obj := Frm.ActiveControl;
//if Obj is TCustomEdit then result := Obj;
if Obj is TEdit then result := Obj;
if Obj is TComboBox then result := Obj;
if Obj is TMemo then result := Obj;

end;

procedure TForm1.ChangeResolution(Restore : Boolean);
begin
if Restore = False
then begin
     if Form19.ComboBox1.Text <> Unit19.Lgn_No_Change
     then begin
          if Form19.ComboBox1.Text = '800 * 600 8 bits' then Form19.ChangeResolEcran(800,600,8,True);
          if Form19.ComboBox1.Text = '800 * 600 16 bits' then Form19.ChangeResolEcran(800,600,16,True);
          if Form19.ComboBox1.Text = '800 * 600 32 bits' then Form19.ChangeResolEcran(800,600,32,True);
          if Form19.ComboBox1.Text = '1024 * 768 8 bits' then Form19.ChangeResolEcran(1024,768,8,True);
          if Form19.ComboBox1.Text = '1024 * 768 16 bits' then Form19.ChangeResolEcran(1024,768,16,True);
          if Form19.ComboBox1.Text = '1024 * 768 32 bits' then Form19.ChangeResolEcran(1024,768,32,True);
          if Form19.ComboBox1.Text = '1152 * 864 8 bits' then Form19.ChangeResolEcran(1152,864,8,True);
          if Form19.ComboBox1.Text = '1152 * 864 16 bits' then Form19.ChangeResolEcran(1152,864,16,True);
          if Form19.ComboBox1.Text = '1152 * 864 32 bits' then Form19.ChangeResolEcran(1152,864,32,True);
          if Form19.ComboBox1.Text = '1280 * 768 8 bits' then Form19.ChangeResolEcran(1280,768,8,True);
          if Form19.ComboBox1.Text = '1280 * 768 16 bits' then Form19.ChangeResolEcran(1280,768,16,True);
          if Form19.ComboBox1.Text = '1280 * 768 32 bits' then Form19.ChangeResolEcran(1280,768,32,True);
          end;
     end
else begin
     if (Form19.CheckBox7.Checked = True) and (Form19.CheckBox7.Enabled = True)and (Form19.ComboBox1.Text <> Unit19.Lgn_No_Change)
     then Form19.ChangeResolEcran(unit19.AncienneResolutionWidth,unit19.AncienneResolutionHeight,unit19.AncienneResolutionCouleur,True);
     end;
end;

function TForm1.GetClipboardFormat() : cardinal;
begin
// evite les bloquages du presse-papiers
Application.ProcessMessages;
SleepEx(10,True);
result := 0;

try
if ClipBoard.HasFormat(CF_Text) then result := 1;
if ClipBoard.HasFormat(CF_Bitmap) then result := 2;
if ClipBoard.HasFormat(CF_MetaFilePict) then result := 3;
if ClipBoard.HasFormat(CF_Picture) then result := 4;
if ClipBoard.HasFormat(CF_Component) then result := 5;
except SleepEX(100,True) end;

end;

procedure TForm1.SetClipboardHasText(Text : String);
begin
// evite les bloquages du presse-papiers
Application.ProcessMessages;
SleepEx(10,True);
try
ClipBoard.AsText := Text;
except ErrorComportement('L''application nommée "'+GetWindowModuleFileName(GetOpenClipboardWindow)+'" bloque l''accès en écriture du presse-papiers.',4);end;
end;

function  TForm1.GetClipboardHasText():String;
begin
// evite les bloquages du presse-papiers
Application.ProcessMessages;
SleepEx(10,True);
try
if Clipboard.HasFormat(CF_TEXT)
then result := ClipBoard.AsText
else result := '';
except ErrorComportement('L''application nommée "'+GetWindowModuleFileName(GetOpenClipboardWindow)+'" bloque l''accès en lecture du presse-papiers.',4); end;
end;

function TForm1.Form1CaptionUpdate : String;
begin
case ExecutionType of
     1 : begin
         result := ExtractFileName(StatusBar1.Panels[0].Text) + ' - Super macro [En exécution]';
         Application.Icon.Assign(ICONRUN);
         end;
     2 : begin
         result := ExtractFileName(StatusBar1.Panels[0].Text) + ' - Super macro [Pas à pas]';
         Application.Icon.Handle := HICONSTD;
         end;
     3 : begin
         result := ExtractFileName(StatusBar1.Panels[0].Text) + ' - Super macro [Mise en pause]';
         Application.Icon.Handle := HICONSTD;
         end;
     4 : begin
         result := ExtractFileName(StatusBar1.Panels[0].Text) + ' - Super macro [Stoppé par Point d''arrêt]';
         Application.Icon.Handle := HICONSTD;
         end;
     5 : begin
         result := ExtractFileName(StatusBar1.Panels[0].Text) + ' - Super macro [Pas à pas, Commande en exécution]';
         Application.Icon.Assign(ICONRUN);
         end
     else begin
          result := ExtractFileName(StatusBar1.Panels[0].Text) + ' - Super macro';
          Application.Icon.Handle := HICONSTD;
          end;
     end;
end;

function TForm1.ShowBalloonTip(Sender: TWinControl; Icon: integer; Title,Text: PChar; Align : Cardinal): HWND;
var hToolTip : HWND;
    Ti       : TTOOLINFO;
    R        : TRect;
    ltext    : PChar;
    ltitle   : PChar;
    APoint   : Tpoint;
    TIMER : cardinal;
    PosForm : Tpoint;
const TTS_BALLOON = $040;
      TTM_SETTITLE = 1056;
begin
  //Align -> 0 TopLeft - 1 TopRight - 2 BottomLeft - 3 BottomRight
  hToolTip  := CreateWindowEx(0, 'Tooltips_Class32', Nil, WS_POPUP or TTS_BALLOON, 0, 0, 0, 0,Sender.ParentWindow, 0, Application.Handle, nil);
  SetWindowPos(hToolTip, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_IDISHWND + TTF_TRACK + TTF_ABSOLUTE + TTF_TRANSPARENT;
  ti.hInst  := Application.Handle;
  SendMessage(hToolTip, TTM_ACTIVATE, 1, 0);
  Windows.GetClientRect(Sender.Handle, R);
  ltext   := Text;
  ltitle  := title;
  ti.hwnd := Sender.Handle;
  ti.Rect := R;
  ti.lpszText := ltext;
  SendMessage(hToolTip, TTM_ADDTOOL, 0, Longint(@ti));
  SendMessage(hToolTip, TTM_SETTITLE, 1, Longint(ltitle));
  SendMessage(hToolTip, TTM_ACTIVATE, 1, 0);

  APoint.X := Sender.Left; APoint.Y := Sender.Top;
  case Align of
    1 : Inc(Apoint.X,Sender.Width);
    2 : Inc(Apoint.Y,Sender.Height);
    3 : begin Inc(Apoint.X,Sender.Width); Inc(Apoint.Y,Sender.Height); end;
  end;
  
  //sender.ClientToParent()
  APoint := Sender.Parent.ClientToScreen(APoint);
  SendMessage(hToolTip,TTM_TRACKPOSITION,0,MAKELPARAM(APoint.X, APoint.Y));
  SendMessage(hToolTip,TTM_TRACKACTIVATE,Integer(LongBool(True)), Integer(@ti));
  PosForm := Sender.Parent.ClientOrigin;
  timer := 0;
  while (timer < 20) and (Sender.Parent.Visible) and (PosForm.X = Sender.Parent.ClientOrigin.X) and (PosForm.Y = Sender.Parent.ClientOrigin.Y)
  do begin
     Inc(timer);
     SleepEx(100,False);
     application.ProcessMessages;
     end;
  SendMessage(hToolTip,TTM_TRACKACTIVATE,Integer(LongBool(False)), Integer(@ti));
  result := hToolTip;
end;


procedure TForm1.Delay(Milliseconds: Dword);
var Tick: DWord;
    Event: THandle;
begin
Event := CreateEvent(nil, False, False, nil);
try
  Tick := GetTickCount + DWord(Milliseconds);
  while (Milliseconds > 0) and (MsgWaitForMultipleObjects(1, Event, False, Milliseconds, QS_ALLINPUT) <> WAIT_TIMEOUT)
   do begin
      Application.ProcessMessages;
      if Run = False then Exit;
      if Application.Terminated then Exit;
      if GetTickCount > Tick then Exit;
      try Milliseconds := Tick - GetTickcount; except end;
    end;
finally CloseHandle(Event); end;
end;


procedure TForm1.ErrorComportement(Msg : String; Comportement : cardinal= 0);
var PosStr, Text, Force : String;
    List : TListView;
    cmpt, Index :Integer;
    TextLen,TextSel : integer;
begin

if Comportement = 0
then begin
     if FnctIsInteger(GetValue('[ERROR.ADAPTATOR]'))
     then cmpt := StrToInt(GetValue('[ERROR.ADAPTATOR]'))
     else cmpt := 1;
     end
else cmpt := Comportement;

TextLen := RichEdit1.GetTextLen;

RichEdit1.Lines.Add(Msg);
TextSel := TextLen + length(Msg);
RichEdit1.SelStart := TextLen;
RichEdit1.SelLength := TextSel;
RichEdit1.SelAttributes.Color := clRed;
RichEdit1.SelStart := TextLen + TextSel;


WriteVariable('VAR','[ERROR]',Msg);
if PageControl1.ActivePage <> TabSheet2
then PageControl1.ActivePage := TabSheet2;

GetActiveMacro(List,Index);
if List = Form1.ListView1
then PosStr := IntToStr(Index+1)
else PosStr := IntToStr(pos_command+1)+'.'+IntToStr(Index+1);

case Cmpt of
     1 : begin
         if Comportement = 1 then Force  := ' inévitable' else Force := '';
         Text := Format('%s Arrêt de la macro%s. [Position %s]',[Msg,Force,PosStr]);
         MessageDlg(Text,mtError,[mbok],0);
         Stop1.Click;
         end;
     2 : begin
         Text := Format('%s Confirmez la tentative de reprise. [Position %s]',[Msg,PosStr]);
         if MessageDlg(Text,mtError,[mbYes,mbNo],0) = mrYes
         then Execute_commande(List,Index, ActiveOrder);
         end;
     3 : begin
         Text := Format('%s Confirmez la poursuite de l''exécution. [Position %s]',[Msg,PosStr]);
         if MessageDlg(Text,mtError,[mbYes,mbNo],0) = mrNo
         then Stop1.Click;
         end;
     4 : begin
         // simple message dans le rapport sans consequence pour la macro
         end;
 end;
end;

function TForm1.ListVarUseForThisCommand(Index : integer; List : TListView =nil ): TListVar;
var ListParam, VarParam : TParam;
    i,k, iprm, cpt : integer;
    Command : String;
    ListVarUse : TListVar;
begin
SetLength(ListVarUse,0);
result := ListVarUse;

try
if List.Items[Index] = nil
then Exit;
except on EInvalidOperation do Exit; end;

Command := List.Items[Index].SubItems[0];
ListParam := GetParam(Command);


if (List.Items[Index].Caption = 'Calcul évolué') or (List.Items[Index].Caption = 'ScriptEval')
then begin
     for i := 0 to List.Items.Count -1 do
     if List.Items[i].Caption = 'Variable'
     then begin
          VarParam := GetParam(List.items.Item[i].SubItems.Strings[0]);
          if (List.Items[Index].Caption = 'ScriptEval')
          then iprm := 2
          else iprm := 1;

          if AnsiPos(VarParam.param[iprm],Command) <> 0
          then begin
               cpt := length(ListVarUse);
               SetLength(ListVarUse,cpt+1);
               ListVarUse[cpt].Name := VarParam.Param[1];
               ListVarUse[cpt].TypeVar := VarParam.Param[3];
               if VarParam.Param[1] <> '[PASSWORD]'
               then begin
                    if ListVarUse[cpt].TypeVar = TAlpha
                    then ListVarUse[cpt].Value := '''' + GetValue(VarParam.param[1]) +''''
                    else ListVarUse[cpt].Value := GetValue(VarParam.param[1]);
                    end
               else ListVarUse[cpt].Value := '********';
               end;
          end;
     end
else begin
     for i := 1 to ListParam.nbr_param -1
     do begin
        if mdlfnct.FnctTypeVar(ListParam.param[i]) <> TNo
        then begin
             cpt := length(ListVarUse);
             SetLength(ListVarUse,cpt+1);
             ListVarUse[cpt].Name := ListParam.param[i];
             ListVarUse[cpt].TypeVar := FnctTypeVar(ListParam.param[i]);
             if ListParam.param[i] <> '[PASSWORD]'
             then begin
                  if ListVarUse[cpt].TypeVar = TAlpha
                  then ListVarUse[cpt].Value := '''' + GetValue(ListParam.param[i]) +''''
                  else ListVarUse[cpt].Value := GetValue(ListParam.param[i]);
                  end
             else ListVarUse[cpt].Value := '********';
             if (List.Items[Index].Caption = 'Variable') and (cpt = 0)
             then begin
                  k := Form8.FindSysVar(ListParam.param[1]);
                  if k <> -1
                  then if ListOfSysVar[k].VRW = 1
                       then begin
                            if ListOfSysVar[k].VType = 1
                            then ListVarUse[cpt].Value := ''''''
                            else ListVarUse[cpt].Value := '0';
                            end;
                  end;
             end;
        end;
     end;
result := ListVarUse;
end;

function TForm1.StrToFloat(const S: string): Extended;
var Str : String;
begin
Str := S;
result := 0;
if (FnctIsFloat(Str) = False) and (FnctIsInteger(Str) = False)
then begin
     If DecimalSeparator = '.' then Str := StringReplace(Str,',',DecimalSeparator,[rfReplaceAll, rfIgnoreCase]);
     If DecimalSeparator = ',' then Str := StringReplace(Str,'.',DecimalSeparator,[rfReplaceAll, rfIgnoreCase]);
     end;
if (FnctIsFloat(Str) = False) and (FnctIsInteger(Str) = False)
then ErrorComportement(S +' n''est pas une valeur numérique valide.')
else result := SysUtils.StrToFloat(Str);
end;


function TForm1.ColorForProcedure(List: TListView; index : integer; var Color : TColor): Boolean;
var i : integer;
function Lum(Mycolor,intens : integer):TColor;
var R,G,B : integer;
begin
R := GetRValue( ColorToRGB(MyColor));
G := GetGValue( ColorToRGB(MyColor));
B := GetBValue( ColorToRGB(MyColor));
R := round(R * ( 1 + intens / 100));
G := round(G * ( 1 + intens / 100));
B := round(B * ( 1 + intens / 100));
result := RGB(R,G,B);
end;
begin
result := False;
for i := index downto 0
do if List.Items[i].Caption = 'Procedure'
   then begin
        if List.Selected = List.Items[i] then begin result := False; exit; end;
        if (List.Items[i].SubItems[0] = 'END') and (i<Index) then begin result := False; exit; end;
        if Copy(List.Items[i].SubItems[0],0,4) <> 'CALL'
        then begin
             if i = index then Color := Lum(Color,-4);
             if List.Items[i].SubItems[0] = 'END' then Color := Lum(Color,6);
             result := True;
             exit;
             end;
        end;

end;


procedure TForm1.GetActiveMacro(var List : TListView; var Index : integer);
begin
if SousMacroExecute = nil
then begin
     List := Form1.ListView1;
     Index := unit1.pos_command;
     end
else begin
     List := SousMacroExecute;
     Index := unit1.SousMacroExecuteIndex;
     end;
end;

function TForm1.GetFileIniName():String;
var ConfigOther : String;
begin
ConfigOther := ChangeFileExt(StatusBar1.Panels[0].Text,'.ini');
if FileExists(ConfigOther) and (StatusBar1.Panels[0].Text <> Lng_NewMacro)
then result := ConfigOther
else result := ExtractFileDir(Application.ExeName) + '\config.ini';
end;

function GetLongFilename(const ShortFilename: string): string;  // renvoie le chemin complet du fichier
var
  desktop: IShellFolder;
  filename: Widestring;
  pchEaten: Cardinal;
  ppIdl: PItemIDList;
  pdwAttributes: Cardinal;
  buffer: array [0..MAX_PATH] of char;
begin
  result:= ShortFilename;
  if SHGetDesktopFolder(desktop) = NOERROR then
  begin
    filename:= ShortFilename; { Conversion en WideString }
    if Desktop.ParseDisplayName(0, nil, PWideChar(filename),
                   pchEaten, ppidl, pdwAttributes) = NOERROR then
    begin
      if SHGetPathFromIDList(ppidl, buffer) then
        result:= buffer;
    end;
  end;
end;

procedure TForm1.DescURLStyleOnMouseMove;
begin
TLabel(Sender).Cursor := crHandPoint;
end;

procedure TForm1.DescURLStyleOnclick;
var i,j : integer;
begin
for i := 0 to TreeView1.Items.Count-1
do if TreeView1.Items[i].AbsoluteIndex = TLabel(Sender).Tag
   then TreeView1.Items[i].Selected := True;
// recherche dans la rubrique des composants
if Tag = 0
then for i := 0 to Length(DynOrder)-1
     do if DynOrder[i].Name = TLabel(Sender).Caption
        then for j := 0 to PageControl2.PageCount -1
             do if PageControl2.Pages[j].Caption = DynOrder[i].Rubrique
                then PageControl2.ActivePageIndex := j;
// recherche par rapport au nom du label
for j := 0 to PageControl2.PageCount -1
do if PageControl2.Pages[j].Caption = TLabel(Sender).Caption
   then PageControl2.ActivePageIndex := j;

end;

procedure TForm1.GetDescURLStyle(Desc : String);
var ListParam : TParam;
    i,j,LeftPos : integer;
    SousDesc : TLabel;
    Node : TTreeNode;
begin
for i := Panel9.ComponentCount -1 downto 0
do begin
   SousDesc := TLabel(Panel9.Components[i]);
   if SousDesc <> nil
   then Panel9.Components[i].Free;
   end;

ListParam := GetParam(Desc);
LeftPos := 6;

SousDesc := TLabel.Create(Panel9);
SousDesc.Parent := Panel9;
SousDesc.Top := 4;
SousDesc.Font.Size := 8;
SousDesc.Font.Style := [];
SousDesc.Font.Color := clBlack;
SousDesc.Left := LeftPos;
SousDesc.Caption := 'Description de : ';
LeftPos := LeftPos + SousDesc.Width;
if TreeView1.Selected <>  nil
then begin
     for i := 1 to ListParam.nbr_param-1
     do begin
        Node := TreeView1.Selected;
        for j :=  ListParam.nbr_param - i-1 downto 1
        do Node := Node.Parent;
           SousDesc := TLabel.Create(Panel9);
           SousDesc.Parent := Panel9;
           SousDesc.Top := 4;
           SousDesc.Font.Size := 8;
           SousDesc.Font.Style := [fsUnderLine];
           SousDesc.Font.Color := clBlue;
           SousDesc.Caption := ListParam.Param[i];
           if Node <> nil
           then SousDesc.Tag := Node.AbsoluteIndex else SousDesc.Tag := 0;
           SousDesc.OnMouseMove := DescURLStyleOnMouseMove;
           SousDesc.OnClick := DescURLStyleOnclick;
           SousDesc.Left := LeftPos;
           LeftPos := LeftPos + SousDesc.Width;

           if i <= ListParam.nbr_param -2
           then begin
                SousDesc := TLabel.Create(Panel9);
                SousDesc.Parent := Panel9;
                SousDesc.Top := 4;
                SousDesc.Font.Size := 8;
                SousDesc.Font.Style := [];
                SousDesc.Font.Color := clBlack;
                SousDesc.Left := LeftPos;
                SousDesc.Caption := ' > ';
                LeftPos := LeftPos + SousDesc.Width;
                end;
        end;
     end
else begin
     for i := 1 to ListParam.nbr_param-1
     do begin
           SousDesc := TLabel.Create(Panel9);
           SousDesc.Parent := Panel9;
           SousDesc.Top := 4;
           SousDesc.Font.Size := 8;
           SousDesc.Font.Style := [fsUnderLine];
           SousDesc.Font.Color := clBlue;
           SousDesc.Caption := ListParam.Param[i];
           SousDesc.Tag := 0;
           SousDesc.OnMouseMove := DescURLStyleOnMouseMove;
           SousDesc.OnClick := DescURLStyleOnclick;
           SousDesc.Left := LeftPos;
           LeftPos := LeftPos + SousDesc.Width;

           if i <= ListParam.nbr_param -2
           then begin
                SousDesc := TLabel.Create(Panel9);
                SousDesc.Parent := Panel9;
                SousDesc.Top := 4;
                SousDesc.Font.Size := 8;
                SousDesc.Font.Style := [];
                SousDesc.Font.Color := clBlack;
                SousDesc.Left := LeftPos;
                SousDesc.Caption := ' > ';
                LeftPos := LeftPos + SousDesc.Width;
                end;
     end;
     end;
end;

procedure TForm1.ChangeParam(List : TListView; index,pos : integer; newValue : string; history : boolean);
var ListParam : TParam;
    Returnvalue, RestoreSaveCaption : string;
    i : integer;
begin
if List.items[index] = nil then Exit;
ListParam := GetParam(List.Items[index].SubItems[0]);
if ListParam.param[pos] = newValue then Exit;
ReturnValue := '';
for i := 1 to ListParam.nbr_param -1
do begin
   if i = pos then ReturnValue := ReturnValue + newvalue + SprPr
              else ReturnValue := ReturnValue +ListParam.Param[i] + SprPr;
   end;

RestoreSaveCaption := Save_Caption;
Save_caption := List.Items[index].SubItems[0];
unit1.sw_modif := True;

List.Items[index].SubItems[0] := ReturnValue;

if (history = True) and (List = Form1.ListView1)
then Form1.SaveBeforeChange(list.Items.item[index]);
unit1.sw_modif := False;
Save_Caption := RestoreSavecaption;
end;

procedure TForm1.Changercouleurbullet1Click(Sender: TObject);
begin
if ColorDialog1.Execute
then BulletColor := ColorDialog1.Color;
end;

procedure TForm1.NoDoublonofListBox(Sender : TListBox);
var i,j : integer;
begin
for i := Sender.Count-1 downto 0
do for j := i-1 downto 0
   do if Sender.Items[i] = Sender.Items[j]
      then begin Sender.Items.Delete(i); break; end;
end;

function TForm1.GetListBoxSelected(LBox : TListBox) : integer;
var i : integer;
begin
result := -1;
if Lbox = nil then Exit;
for i := LBox.Count -1 downto 0
do if LBox.Selected[i] = True
   then result := i;
end;

function Tform1.BoolToStr(Value : Boolean) : String;
begin
result := '';
if Value = True then result := 'True';
if Value = False then result := 'False';
end;

function Tform1.StrToBool(Value : String) : Boolean;
begin
result := False;
if Value = 'True' then result := True;
end;

Procedure TForm1.ShowApplicationError(Sender: TObject; E: Exception);
var ErrorMode:word;
    MapFileAddress: DWORD;
    UnitName,
    ProcedureName,
    Module, LineNumber: string;
    i, OrderIndex : integer;
    List : TListView;
    Index, SousIndex : Integer;
    RunPos : string;
    ListVarUse : TListVar;
begin
SetLength(ListVarUse,0);
if Application.FindComponent('Form34') = nil then Exit;

if Application.Terminated = True then Exit;
ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
try
MapFileAddress := uDebugEx.GetMapAddressFromAddress(DWORD(ExceptAddr));
UnitName := GetModuleNameFromAddress(MapFileAddress);
ProcedureName := GetProcNameFromAddress(MapFileAddress);
LineNumber := GetLineNumberFromAddress(MapFileAddress);

form34.Memo1.Clear;

Module := Application.ExeName;
GetActiveMacro(List,Index);

if List <> Form1.ListView1
then begin SousIndex := Index; Index := Pos_command; RunPos := IntToStr(Index+1)+'.'+ IntToStr(sousIndex+1); end;

if List.Items.Item[Index] <> nil
then begin
     OrderIndex := form1.GetNewOrderIndex(List.Items.Item[Index].caption);
     if OrderIndex <> -1
     then Module := DynOrder[OrderIndex].dllName
     end;

Form34.Panel1.Caption := 'Class :'+ E.ClassName;

form34.Memo1.Lines.Add('['+DateToStr(now)+ ' - '+ TimeToStr(now)+']');
form34.Memo1.Lines.Add('Version :'+ unit23.ver);
form34.Memo1.Lines.Add('Module :'+ Module);
form34.Memo1.Lines.Add('Message :'+ E.Message);
form34.Memo1.Lines.Add('Addr exception : 0x' + IntToHex(cardinal(ExceptAddr), 8));
form34.Memo1.Lines.Add('Class :' + E.ClassName);
form34.Memo1.Lines.Add('File :'+UnitName);
form34.Memo1.Lines.Add('Procedure :' + ProcedureName);
form34.Memo1.Lines.Add('Line Nr :' + LineNumber);

if Run = True
then form34.Memo1.Lines.Add('Run :' + BoolToStr(Run) + ' ('+RunPos+')')
else form34.Memo1.Lines.Add('Run :' + BoolToStr(Run));
if sw_modif = True
then form34.Memo1.Lines.Add('Edited :' + BoolToStr(sw_modif)+ ' ('+IntToStr(ListView1.Selected.Index+1)+')')
else form34.Memo1.Lines.Add('Edited :' + BoolToStr(sw_modif));

GetActiveMacro(List,Index);
form34.Memo1.Lines.Add('Commande:' + List.Items[Index].Caption);
form34.Memo1.Lines.Add('Params:' + List.Items[Index].SubItems[0]);
ListVarUse := ListVarUseForThisCommand(Index,List);
form34.Memo1.Lines.Add('');
form34.Memo1.Lines.Add('***** VarUse *****');
for i := 0 to length(ListVarUse)-1
do form34.Memo1.Lines.Add(ListVarUse[i].Name+':'''+ListVarUse[i].Value+'''['+ ListVarUse[i].TypeVar+']');

Form34.Show;
finally seterrormode(ErrorMode); end;
end;

procedure TForm1.ShowApplicationError(Msg : String);
var i : integer;
    List : TListView;
    Index, SousIndex : Integer;
    RunPos : string;
    ListVarUse : TListVar;
begin
SetLength(ListVarUse,0);
if Application.FindComponent('Form34') = nil then Exit;

GetActiveMacro(List,Index);

if List <> Form1.ListView1
then begin SousIndex := Index; Index := Pos_command; RunPos := IntToStr(Index+1)+'.'+ IntToStr(sousIndex+1); end
else RunPos := IntToStr(Index+1);

form34.Memo1.Clear;
Form34.Panel1.Caption := 'Internal error [code 2].';

form34.Memo1.Lines.Add('['+DateToStr(now)+ ' - '+ TimeToStr(now)+']');
form34.Memo1.Lines.Add('Message :'+ Msg);
form34.Memo1.Lines.Add('Addr exception : 0x00000000');

if Run = True
then form34.Memo1.Lines.Add('Run :' + BoolToStr(Run) + ' ('+RunPos+')')
else form34.Memo1.Lines.Add('Run :' + BoolToStr(Run));
if sw_modif = True
then form34.Memo1.Lines.Add('Edited :' + BoolToStr(sw_modif)+ ' ('+IntToStr(ListView1.Selected.Index+1)+')')
else form34.Memo1.Lines.Add('Edited :' + BoolToStr(sw_modif));

GetActiveMacro(List,Index);
form34.Memo1.Lines.Add('Commande:' + List.Items[Index].Caption);
form34.Memo1.Lines.Add('Params:' + List.Items[Index].SubItems[0]);
ListVarUse := ListVarUseForThisCommand(Index,List);
form34.Memo1.Lines.Add('');
form34.Memo1.Lines.Add('***** VarUse *****');
for i := 0 to length(ListVarUse)-1
do form34.Memo1.Lines.Add(ListVarUse[i].Name+':'''+ListVarUse[i].Value+'''['+ ListVarUse[i].TypeVar+']');


Stop1.Click;
Form34.ShowModal;

end;
procedure TForm1.PrintComponentList(Form : TForm; TextFileName, SortFileName : String);
var fic, ficSort : TextFile;
    i : integer;
    Text, TextSort, ObjText : String;
    MyObject : TObject;
begin
try
assignFile(fic,TextFileName);
if not FileExists(TextFileName) then rewrite(fic) else append(fic);

assignFile(ficSort,SortFileName);
if not FileExists(SortFileName) then rewrite(ficSort) else append(ficSort);

writeln(fic,'');
writeln(fic, '*** Print Component List of ' + TForm(form).Name + ' ***');
writeln(fic,'['+ TForm(form).Name + ']');
writeln(fic,'');

ObjText := 'Label';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TLabel);
   if MyObject = nil then continue;
   TextSort := Concat(TForm(Form).Name,'.',(MyObject as TLabel).Name,'.caption := FileLng.ReadString(''',TForm(Form).Name,''',','''',(MyObject as TLabel).Name,''',',TForm(Form).Name,'.',(MyObject as TLabel).Name,'.caption);');
   writeln(FicSort,TextSort);
//   Form1.Macro1.caption := FileLng.ReadString('Menu1','Macro1',Form1.Macro1.caption);
   Text := Concat((MyObject as TLabel).Name,' =', (MyObject as TLabel).Caption);
   writeln(Fic,Text);
   end;

ObjText := 'Edit';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TEdit);
   if MyObject = nil then continue;
   TextSort := Concat(TForm(Form).Name,'.',(MyObject as TEdit).Name,'.Text := FileLng.ReadString(''',TForm(Form).Name,''',','''',(MyObject as TEdit).Name,''',',TForm(Form).Name,'.',(MyObject as TEdit).Name,'.Text);');
   writeln(FicSort,TextSort);
   Text := Concat((MyObject as TEdit).Name,' =', (MyObject as TEdit).Text);
   writeln(Fic,Text);
   end;

ObjText := 'Button';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TButton);
   if MyObject = nil then continue;
   TextSort := Concat(TForm(Form).Name,'.',(MyObject as TButton).Name,'.caption := FileLng.ReadString(''',TForm(Form).Name,''',','''',(MyObject as TButton).Name,''',',TForm(Form).Name,'.',(MyObject as TButton).Name,'.caption);');
   writeln(FicSort,TextSort);
   Text := Concat((MyObject as TButton).Name,' =', (MyObject as TButton).Caption);
   writeln(Fic,Text);
   end;

ObjText := 'SpeedButton';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TSpeedButton);
   if MyObject = nil then continue;
   TextSort := Concat(TForm(Form).Name,'.',(MyObject as TSpeedButton).Name,'.caption := FileLng.ReadString(''',TForm(Form).Name,''',','''',(MyObject as TSpeedButton).Name,''',',TForm(Form).Name,'.',(MyObject as TSpeedButton).Name,'.caption);');
   writeln(FicSort,TextSort);
   Text := Concat((MyObject as TSpeedButton).Name,' =', (MyObject as TSpeedButton).Caption);
   writeln(Fic,Text);
   end;

ObjText := 'CheckBox';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TCheckBox);
   if MyObject = nil then continue;
   if (MyObject as TCheckBox).caption = '' then continue;
   TextSort := Concat(TForm(Form).Name,'.',(MyObject as TCheckBox).Name,'.caption := FileLng.ReadString(''',TForm(Form).Name,''',','''',(MyObject as TCheckBox).Name,''',',TForm(Form).Name,'.',(MyObject as TCheckBox).Name,'.caption);');
   writeln(FicSort,TextSort);
   Text := Concat((MyObject as TCheckBox).Name,' =', (MyObject as TCheckBox).Caption);
   writeln(Fic,Text);
   end;
ObjText := 'RadioButton';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TRadioButton);
   if MyObject = nil then continue;
   if (MyObject as TRadioButton).caption = '' then continue;
   TextSort := Concat(TForm(Form).Name,'.',(MyObject as TRadioButton).Name,'.caption := FileLng.ReadString(''',TForm(Form).Name,''',','''',(MyObject as TRadioButton).Name,''',',TForm(Form).Name,'.',(MyObject as TRadioButton).Name,'.caption);');
   writeln(FicSort,TextSort);
   Text := Concat((MyObject as TRadioButton).Name,' =', (MyObject as TRadioButton).Caption);
   writeln(Fic,Text);
   end;

writeln(fic,'');
writeln(fic, '*** End of ' + TForm(form).Name + ' ***');
writeln(fic,'');
finally
CloseFile(fic);
CloseFile(ficSort);

end;
end;

procedure TForm1.PrintMapArea(Form : TForm; TextFileName, SortFileName : String);
var fic, ficSort : TextFile;
    i : integer;
    Text, ObjText : String;
    MyObject : TObject;
    Str : String;
const    OffsetX = 8;
         OffsetY = 28;
begin
try
assignFile(fic,TextFileName);
if not FileExists(TextFileName) then rewrite(fic) else append(fic);

assignFile(ficSort,SortFileName);
if not FileExists(SortFileName) then rewrite(ficSort) else append(ficSort);

writeln(fic, '*** Print Component List of ' + TForm(form).Name +' ['+TForm(form).Caption +  '] ***');
writeln(fic,'<map name="graphique">');
writeln(fic,'');

{
ObjText := 'Label';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TLabel);
   if MyObject = nil then continue;
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left)+','+InttoStr(TControl(MyObject).Top)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height)+'" alt="'+TLabel(MyObject).Caption+'">';
   writeln(Fic,Text);
   end;
}

ObjText := 'Edit';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TEdit);
   if MyObject = nil then continue;
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left+OffsetX)+','+InttoStr(TControl(MyObject).Top+OffsetY)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width+OffsetX)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height+OffsetY)+'" alt="Paramètre">';
   writeln(Fic,Text);
   end;

ObjText := 'ComboBox';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TComboBox);
   if MyObject = nil then continue;
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left+OffsetX)+','+InttoStr(TControl(MyObject).Top+OffsetY)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width+OffsetX)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height+OffsetY)+'" alt="Paramètre">';
   writeln(Fic,Text);
   end;


ObjText := 'Button';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TButton);
   if MyObject = nil then continue;
   Str := TButton(MyObject).Caption;
   if Str = 'Valider'
   then Str := 'Cliquez sur ce bouton pour valider la commande.';
   if Str = 'Annuler'
   then Str := 'Cliquez sur ce bouton pour annuler la commande.';
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left+OffsetX)+','+InttoStr(TControl(MyObject).Top+OffsetY)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width+OffsetX)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height+OffsetY)+'" alt="'+Str+'">';
   writeln(Fic,Text);
   end;

ObjText := 'SpeedButton';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TSpeedButton);
   if MyObject = nil then continue;
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left+OffsetX)+','+InttoStr(TControl(MyObject).Top+OffsetY)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width+OffsetX)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height+OffsetY)+'" alt="'+TSpeedButton(MyObject).Caption+'">';
   writeln(Fic,Text);
   end;

ObjText := 'CheckBox';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TCheckBox);
   if MyObject = nil then continue;
   if (MyObject as TCheckBox).caption = '' then continue;
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left+OffsetX)+','+InttoStr(TControl(MyObject).Top+OffsetY)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width+OffsetX)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height+OffsetY)+'" alt="'+TCheckBox(MyObject).Caption+'">';
   writeln(Fic,Text);
   end;

   ObjText := 'RadioButton';
for i := 0 to Form.ComponentCount-1
do begin
   MyObject := (Form.FindComponent(ObjText+ InttoStr(i)) as TRadioButton);
   if MyObject = nil then continue;
   if (MyObject as TRadioButton).caption = '' then continue;
   Text := '<area shape="rect" coords="'+InttoStr(TControl(MyObject).left+OffsetX)+','+InttoStr(TControl(MyObject).Top+OffsetY)+','+InttoStr(TControl(MyObject).left+TControl(MyObject).Width+OffsetX)+','+InttoStr(TControl(MyObject).Top+TControl(MyObject).Height+OffsetY)+'" alt="'+TRadioButton(MyObject).Caption+'">';
   writeln(Fic,Text);
   end;

writeln(fic,'</map>');
writeln(fic, '*** End of ' + TForm(form).Name + ' ***');
writeln(fic,'');
finally
CloseFile(fic);
CloseFile(ficSort);
end;
end;


function TForm1.Saisie(Titre, question, default : String; Pass : Boolean): String;
var MyForm : TForm;
    MyLabel : TLabel;
    MyEdit : TEdit;
    Btok : Tbutton;
begin
result := '';
MyForm := TForm.Create(self);
try
MyForm.Height := 120;
MyForm.Width := 290;
MyForm.Position := poDesktopCenter;
MyForm.Caption := Titre;
MyForm.OnClose := OnSaisieClose;

MyLabel := TLabel.Create(MyForm);
MyLabel.Parent := MyForm;
MyLabel.Top := 8; MyLabel.Left := 8;
MyLabel.Caption := Question;

MyEdit := TEdit.Create(MyForm);
MyEdit.Parent := MyForm;
MyEdit.Top := 22; MyEdit.Left := 8;
MyEdit.Width := 250;
MyEdit.ReadOnly := False;
if Pass = True then MyEdit.PasswordChar := #215;


BtOk := TButton.Create(MyForm);
btOk.Parent := MyForm;
BtOk.Caption := 'Valider';
BtOk.Top := 55;
BtOk.Left := 182;
BtOk.OnClick := OnSaisieClickOk;

MyForm.Show;
MyEdit.Text := default; // placé ici sinon il ne s'affiche pas
MyEdit.AutoSelect := True;
MyForm.FormStyle := fsStayOnTop;
BSaisie := False;
While BSaisie = False
do Delay(200);

result := MyEdit.Text;
finally
BSaisie := True;
MyForm.Close;
MyForm.Free;
end;
end;

procedure TForm1.OnSaisieClose(Sender: TObject; var Action: TCloseAction);
begin
BSaisie := True;
end;

procedure TForm1.OnSaisieClickOk(Sender: TObject);
begin
BSaisie := True;
end;


procedure TForm1.AddHistory(Pos : integer; Action, commande, param : String);
var index,i : integer;
begin
if Can_Save = True
then begin
Can_Save := False;
index := ListView4.Tag+1;
if index < 0 then index := ListView4.Items.Count;

// suppression des evenements a partir du curseur jusqu'a la fin de la liste
for i := ListView4.Items.Count -1 downto index
do ListView4.Items.Delete(i);
// determine si il faut ajouter ou inserer l'evenement
if index = ListView4.Items.Count -1
then ListView4.Items.Add
else ListView4.Items.Insert(index);

ListView4.Items.Item[Index].Caption := InttoStr(Pos);
ListView4.Items.Item[Index].SubItems.Add(Action);
ListView4.Items.Item[Index].SubItems.Add(Commande);
ListView4.Items.Item[Index].SubItems.Add(Param);

ListView4.Items.Item[ListView4.Tag].StateIndex := -1;
ListView4.Tag := index;
ListView4.Items.Item[ListView4.Tag].StateIndex := 14;

Select_Unique(ListView4,index);
Can_Save := True;
end;

end;

procedure TForm1.SaveBeforeChange(Item: TListItem);
var index,i : integer;
begin
if Item = nil then exit;
Can_Save := False;
index := ListView4.Tag+1;
if index < 0 then index := ListView4.Items.Count;

// suppression des evenements a partir du curseur jusqu'a la fin de la liste
for i := ListView4.Items.Count -1 downto index
do ListView4.Items.Delete(i);
// determine si il faut ajouter ou inserer l'evenement
if index = ListView4.Items.Count -1
then ListView4.Items.Add
else ListView4.Items.Insert(index);


if sw_modif = True
then begin
     ListView4.Items.Item[Index].Caption := IntToStr(Item.index+1);
     ListView4.Items.Item[Index].SubItems.Add('Modification');
     ListView4.Items.Item[Index].SubItems.Add(Item.Caption);
     ListView4.Items.Item[Index].SubItems.Add(Item.SubItems[0]);
     if findmodif(Item.Index+1,index-1,'¶') = '¶'
     then begin
          ListView4.Items.Insert(index);
          ListView4.Items.Item[Index].Caption := IntToStr(Item.index+1);
          ListView4.Items.Item[Index].SubItems.Add('Valeur Initiale');
          ListView4.Items.Item[Index].SubItems.Add(Item.Caption);
          ListView4.Items.Item[Index].SubItems.Add(save_caption);
          Inc(Index);
          end;
     end
else begin
     ListView4.Items.Item[Index].Caption := IntToStr(Item.index+1);
     ListView4.Items.Item[Index].SubItems.Add('Ajout');
     ListView4.Items.Item[Index].SubItems.Add(Item.Caption);
     ListView4.Items.Item[Index].SubItems.Add(Item.SubItems[0]);
     end;
Can_Save := True;
ListView4.Tag := index;
for i := 0 to ListView4.Items.Count -1
do if ListView4.Tag = i
   then ListView4.Items.Item[i].StateIndex := 14
   else ListView4.Items.Item[i].StateIndex := -1;

Select_Unique(ListView4,index);
end;

procedure TForm1.ChangeDescription(Theme : String);
var chaine : string;
    dep, fin, i : integer;
    Trouver : Boolean;
begin
Trouver := False;
dep := -1; fin := -1;
for i := 0 to Description.Count -1
do begin
   chaine := Description[i];
   if length(chaine) < 4 then continue;
   if (chaine[1] = ';') and (chaine[2] = ';') and (chaine[length(chaine)] = ';') and (chaine[length(chaine)] = ';')
   then if chaine = ';;'+ Theme +';;'
        then begin Dep := i; Trouver := True; end
        else if trouver = True then begin Fin := i-1; break; end;
   if Trouver = True then Fin := Description.Count -1;
   end;
if (Dep > -1) and (Fin > -1 )
then for i := Fin downto Dep
     do Description.Delete(i);

Description.Add(';;'+Theme+';;');
for i := 0 to RichEdit2.Lines.Count -1 do
Description.Add(RichEdit2.Lines[i]);
end;

function TForm1.StrExist(Ch1, Ch2 : String) : Boolean;
var i,j : integer;
    part : string;
begin
result := False;
for i := 1 to length(Ch1)
do begin
   part := ''; for j := i to length(Ch1) do part := part + ch1[j];
   if AnsiStrLiComp(PChar(part),PChar(ch2),length(Ch2)) = 0 then begin result := True; break; end;
   end;
end;

procedure TForm1.TrayMessage(var Msg: TMessage);
var coordonnes_souris :TPoint;
begin
  //('Bouton droit pressé on affiche le menu pop');
  if (Msg.LParam=WM_RBUTTONDOWN) then
  begin
    GetCursorPos(coordonnes_souris);//récupération de la position de la souris
    SetForegroundWindow(Handle); // mise en avant plan de l'application
    PopupMenu3.Popup(coordonnes_souris.x,coordonnes_souris.y); //affichage du menu
  end;
  if (Msg.LParam=WM_LBUTTONDBLCLK) then { Dbl Bouton gauche }
  begin
//    ActDesact
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

procedure TForm1.RefreshEvaluateVar(Ident,Value : String);
var i : integer;
begin
if CheckBox1.Checked = True
then begin
     for i := ListView3.Items.Count-1 downto 0
     do if ListView3.Items.Item[i].Caption = Ident
        then begin
             if ListView3.Items.Item[i].SubItems[0] = Value then continue;
             if Ident <> '[PASSWORD]'
             then ListView3.Items.Item[i].SubItems[0] := Value
             else ListView3.Items.Item[i].SubItems[0] := '********';
             break;
             end;
     end;
FnctExecuteOrder('Dialogue','[CHANGEVALUE]'+SprPr+Ident+SprPr+Value+SprPr);
end;

function TForm1.ReadVariable(const Section, Ident, Default: String): String;
var i : integer;
begin
result := Default;
Form8.ReadSysVar(Ident);
for i := 0 to length(variable)-1
do if variable[i].Name = Ident then begin result := variable[i].Value; break; end;
RefreshEvaluateVar(Ident,result);
end;

procedure TForm1.WriteVariable(const Section, Ident, Value: String);
var i, indexVar : integer;
    ValueMod : String;
begin
ValueMod := Value;
// recherche si la variable est système, si oui donne l'indice dans iSysVar

for i := 0 to length(ListOfSysVar)-1
do if Ident = ListOfSysVar[i].VName // variable trouvé
   then begin
        if ListOfSysVar[i].VRW = 1 // écriture possible
        then begin
             if (Section = 'INITVAR') and (Ident = Value)
             then ValueMod := Form8.ReadSysVar(Ident)
             else Form8.WriteSysVar(Ident, Value);
             end
        else ValueMod := Form8.ReadSysVar(Ident); // lecture seule
        break;
        end;

// ajout ou modification de la variable
indexVar := -1;
if FnctTypeVar(Ident) = TNum
then begin
     ValueMod := StringReplace(ValueMod,' ','',[rfReplaceAll]);
     end;

for i := 0 to length(variable)-1
do if variable[i].Name = Ident then indexVar := i;
if indexVar <> -1
then begin
     // empeche l'initialisation d'une variable lorsque Nom = valeur
     if (Section = 'INITVAR') and (Ident = Value)
     then exit
     else variable[IndexVar].Value := ValueMod;
     end
else begin
     Setlength(Variable,length(Variable)+1);
     Variable[length(Variable)-1].Name := Ident;
     Variable[length(Variable)-1].Value := ValueMod;
     end;

RefreshEvaluateVar(Ident,ValueMod);
end;

function  TForm1.VarUse(List : TListView; Variable : String): boolean;
var ListParam : TParam;
    i,j : integer;
begin
result := False;
for i := 0 to List.Items.Count -1
do begin
   ListParam := GetParam(List.Items.Item[i].SubItems[0]);
   if (List.Items.Item[i].Caption <> 'Variable') or (ListParam.param[1] <> Variable)
   then begin
        for j := 1 to ListParam.nbr_param -1
        do if ListParam.param[j] = Variable
           then result := True;
        end;
   if (List.Items.Item[i].Caption = 'Calcul évolué')
   then begin
        if AnsiPos(variable,ListParam.param[1]) <> 0 then result := True;
        end;
   end;
end;

function TForm1.ChangeVarNameIntoSimpleText(Text, VarIni, VarAfter : String): String;
var i : integer;
    TabWord : array of string;
begin
Setlength(TabWord,1);
for i := 1 to length(Text)
do if Text[i] in ['+','-','*','/','=',' ']
   then begin
        SetLength(TabWord,length(TabWord)+1);
        TabWord[length(TabWord)-1] := TabWord[length(TabWord)-1] + Text[i];
        SetLength(TabWord,length(TabWord)+1);
        end
   else TabWord[length(TabWord)-1] := TabWord[length(TabWord)-1] + Text[i];

result := '';
for i := 0 to length(TabWord)-1
do if TabWord[i] = VarIni
   then result := result + VarAfter
   else result := result + TabWord[i];

end;



function TForm1.ChangeVarName(VarIni, VarAfter : String; Change : Boolean) : Boolean;
var i,j : integer;
    ListParam : TParam;
    Modif : Boolean;
    txt : string;
begin
result := False;
for i := 0 to ListView1.items.count - 1
do begin
   ListParam := GetParam(ListView1.Items.Item[i].SubItems[0]);
   modif := False;
   for j := 1 to ListParam.nbr_param-1
   do begin
      if ListView1.Items.Item[i].Caption = 'Calcul évolué'
      then begin
           if Change = False
           then begin
                if ChangeVarNameIntoSimpleText(ListView1.Items.Item[i].SubItems[0],VarIni,VarAfter) <> ListView1.Items.Item[i].SubItems[0]
                then begin
                     result := True;
                     Exit;
                     end;
                end
           else begin
                Save_caption := Form1.ListView1.Items[i].SubItems[0];
                sw_modif := True;
                ListView1.Items.Item[i].SubItems[0] := ChangeVarNameIntoSimpleText(ListView1.Items.Item[i].SubItems[0],VarIni,VarAfter);
                Form1.SaveBeforeChange(Form1.ListView1.Items[i]);
                continue;
                end;
           end;

      if (j = 3) and (ListView1.Items.Item[i].Caption = 'ScriptEval')
      then begin
           if Change = False
           then begin
                if ListParam.param[j] <> ChangeVarNameIntoSimpleText(ListParam.param[j],VarIni,VarAfter)
                then begin
                     result := True;
                     Exit;
                     end;
                end
           else begin
                txt := ChangeVarNameIntoSimpleText(ListParam.param[j],VarIni,VarAfter);
                if txt <> ListParam.param[j]
                then begin
                     ListParam.param[j] := txt;
                     Modif := True;
                     end;
                end;
           end;

      if ListParam.param[j] = VarIni
      then begin
           Result := True;
           if Change = False then Exit;
           ListParam.param[j] := VarAfter;
           Modif := True;
           end;
      end;
   if Modif = True
   then begin
        Save_caption := Form1.ListView1.Items[i].SubItems[0];
        sw_modif := True;
        ListView1.Items.Item[i].SubItems[0] := GetParamToStr(ListParam);
        Form1.SaveBeforeChange(Form1.ListView1.Items[i]);
        end;
   end;
end;

Function TForm1.MacroChange() : Boolean;
var cpt : integer;
    file_macro : File of TOrdre;
    Ordre,ListOrdre : TOrdre;
    Params :Tparam;
    i : integer;
begin
result := False;
if (StatusBar1.Panels[0].Text <> Lng_NewMacro) and (StatusBar1.Panels[0].Text <> '')
then begin
     // test l'existance du fichier au cas où il aurait été effacé durant l'édition
     if not FileExists(StatusBar1.Panels[0].Text)
     then begin
          SaveDialog1.FileName := StatusBar1.Panels[0].Text;
          application.Title := ExtractFileName(StatusBar1.Panels[0].Text);
          form1.Enregistrer1.OnClick(self);
          end;

     assignfile(file_macro,StatusBar1.Panels[0].Text);
     FileMode := 0;
     reset(file_macro);
     try
     for cpt := 0 to ListView1.Items.Count - 1 do
     begin
           if eof(file_macro) then begin result := True; break; end;
           read(file_macro,Ordre);
           while form32.decrypte(Ordre.commande) = 'Info' do read(file_macro,Ordre);
           while form32.decrypte(Ordre.commande) = 'Infos' do read(file_macro,Ordre);
           while form32.decrypte(Ordre.commande) = 'InfosExit' do read(file_macro,Ordre);
           if Key <>''
           then begin
                Ordre.commande := Form32.decrypte(Ordre.commande);
                Ordre.textparam:= Form32.decrypte(Ordre.textparam);
                end;
           ListOrdre.commande := ListView1.Items[cpt].Caption;
           ListOrdre.textparam:= ListView1.Items.Item[cpt].SubItems.Strings[0];
           // ignore les comparaisons des n° handle
           if (Ordre.commande = 'Objet') and (ListOrdre.commande = 'Objet')
           then begin
                Params := GetParam(Ordre.textparam);
                Ordre.textparam := '';
                for i := 3 to Params.nbr_param-1
                do Ordre.textparam := Ordre.textparam + Params.param[i] + SprPr;
                Params := GetParam(ListOrdre.textparam);
                ListOrdre.textparam := '';
                for i := 3 to Params.nbr_param-1
                do ListOrdre.textparam := ListOrdre.textparam + Params.param[i] + SprPr;
                end;
           if (Ordre.commande = 'Manipulation') and (ListOrdre.commande = 'Manipulation')
           then begin
                Params := GetParam(Ordre.textparam);
                Ordre.textparam := '';
                for i := 2 to Params.nbr_param-1
                do Ordre.textparam := Ordre.textparam + Params.param[i] + SprPr;
                Params := GetParam(ListOrdre.textparam);
                ListOrdre.textparam := '';
                for i := 2 to Params.nbr_param-1
                do ListOrdre.textparam := ListOrdre.textparam + Params.param[i] + SprPr;
                end;

           if (Ordre.commande <> ListOrdre.commande) or (Ordre.textparam <> ListOrdre.textparam)
           then begin result := True; break; end;
     end;
     while not eof(file_macro)
     do begin
        read(file_macro,Ordre);
        if Key <>''
        then begin
             Ordre.commande := Form32.decrypte(Ordre.commande);
             Ordre.textparam:= Form32.decrypte(Ordre.textparam);
             end;
        if (Ordre.commande = 'Évaluer') or (Ordre.commande ='IgnoreMsg') or (Ordre.commande = '[InfoListView]') or
           (Ordre.commande = '[VISUALVAR]') or (Ordre.commande = '[VISUALVAR_PROP]')
        then continue else result := True;
        end;

     if not eof(file_macro) then result := True;
     finally closeFile(file_macro); FileMode := 2; end;
     end;
end;

function TForm1.SaveBeforeExit : Boolean;
var ResultMsg : integer;
begin
result := True;
if Application_close = True then Exit;

change_liste := MacroChange;
if (change_liste = True) and (ListView1.Items.Count <> 0)
then begin
     ResultMsg :=  MessageDlg('Voulez-vous sauvegarder avant de quitter?',mtConfirmation, [mbYes, mbNo, mbCancel], 0);
     if ResultMsg = mrYes then Enregistrer1.Click;
     if ResultMsg = mrCancel then result := False;
     end;

if (ListView1.Items.Count <> 0) and (StatusBar1.Panels[0].Text = Lng_NewMacro)
then begin
     ResultMsg :=  MessageDlg('Voulez-vous sauvegarder avant de quitter?',mtConfirmation, [mbYes, mbNo, mbCancel], 0);
     if ResultMsg = mrYes then Enregistrer1.Click;
     if ResultMsg = mrCancel then result := False;
     end;
end;

Function TForm1.GetExecParam(index : integer) : string;
var i,iparam : integer;
    chaine : string;
begin
iparam := 1;
chaine := '';
result := '';
for i := 1 to ParamCount do
begin chaine := chaine + ParamStr(i) + ' ';
      if ExtractFileExt(chaine) <> ''
      then begin
           if index = iparam
           then begin
                result := chaine;
                Inc(iparam);
                end
           else begin
                chaine := '';
                Inc(iparam);
                end;
           end;
end;
end;

function TForm1.ControlAll(List : TListView): boolean;
var i : integer;
    Commande : string;
    Parametre : String;
    Affichage : Boolean;
    progress : integer;
begin
result := true;
ListView2.Items.Clear;
// ignore le controle des commandes si l'option Ne pas exécuter si erreur est décochée
// et que la macro n'est pas en édition
if (Form19.CheckBox4.Checked = False) and (DirectRun = True)
then Exit;
// Form19.CheckBox10 décoché ignore le debuggage
if Form19.CheckBox10.Checked = False
then begin
     WriteMessage(ListView1,0,SMsgDlgWarning,'Le contrôle des commandes est désactivé, pour le réactiver rendez vous dans les options, onglet contrôle, puis coché la case "Contrôle des commandes avant chaque exécution".', 0);
     Exit;
     end;

//for i := 0 to length(TabIgnoreMsg)-1
//do TabIgnoreMsg[i].Exists := False;


StopAllDebug := False;
ErrorCount := 0;
//if Form29.Visible = True then Exit;
progress := 0;
Affichage := False;

     if List.Items.Count > 300
     then begin
          Affichage  := True;
          Form29.ProgressBar1.Position := 0;
          Application.ProcessMessages;
          Progress := List.Items.Count div 100;
          Form29.Show;
          Form29.Label1.Caption := 'Vérification des commandes en cours. Veuillez patienter SVP.';
          end;

     if List = ListView1 then ListView2.Items.Clear;
     for i := 0 to List.Items.Count - 1 do
     begin
          if Affichage = True
          then begin
               if i mod progress  = 0 then Form29.ProgressBar1.Position := Form29.ProgressBar1.Position +1;
               application.ProcessMessages;
               if unit29.EchapProgress = True then break;
               end;
          Commande := List.Items[i].Caption;
          Parametre:= List.Items.Item[i].SubItems.Strings[0];
          //Pos"_"Command := i;
          if Debug.Control(List, Commande, Parametre, i) = false then result := false;
          if StopAllDebug = True then begin WriteMessage(ListView1,0,SMsgDlgError,'Commande destructurée.(Arrêt du contrôle des commandes)'); break; end;
          if ErrorCount > 8 then begin WriteMessage(ListView1,0,SMsgDlgError,'Nombre d''erreur trop important.(Arrêt du contrôle des commandes)'); break; end;
     end;

     if Affichage = True then form29.Close;
     // pour réaffichage de la form1
     application.ProcessMessages;

if ListView2.Items.Count = 0
then begin
     ListView2.Items.Add();
     ListView2.Items[0].Caption := '0';
     ListView2.Items[0].ImageIndex := 2;
     listView2.items.Item[0].SubItems.Add('Valide');
     listView2.items.Item[0].SubItems.Add(Dbg_NoError);
     select_unique(ListView2,0);
     end;
end;

procedure TForm1.AddToRapport(Order, params : String);
var Etape1,Etape2,Etape3,i,GetTextLen : integer;
    filename,fileExt : String;
    SAll, SOrder, SParam, SVar : String;
    ListVarUse : TListVar;
    List : TListView;
    Index : Integer;
begin
SetLength(ListVarUse,0);
if Order = 'Procedure'
then begin
     if (Copy(params,0,5) <> 'CALL ') then  Exit;
     end;

GetActiveMacro(List,Index);
GetTextLen := RichEdit1.GetTextLen;

if  GetTextLen > 80000
then begin
     if Form19.CheckBox5.Checked = True
     then begin
          FileExt := ExtractFileExt(RapportFileName);
          FileName := ChangeFileExt(RapportFileName,'');
          FileName := FileName + ComboBox1.Text + FileExt;
          RichEdit1.Lines.SaveToFile(FileName);
          end;
     FileName := Format('%6d',[ComboBox1.items.count +1]);
     FileName := AnsiReplaceText(FileName,' ', '0');
     ComboBox1.Items.Add(FileName);
     ComboBox1.ItemIndex := ComboBox1.items.count-1;

     FileExt := ExtractFileExt(RapportFileName);
     FileName := ChangeFileExt(RapportFileName,'');
     FileName := FileName + ComboBox1.Text + FileExt;

     RichEdit1.Clear;
     RichEdit1.SelAttributes.Color := clGray;
     RichEdit1.SelAttributes.Style := Form19.Label14.Font.Style;
     RichEdit1.SelAttributes.Size := 8;
     RichEdit1.Lines.Add('Fichier ' + FileName);
     end;

     SOrder := Order + ' ';
     SParam := Params + ' ';
     SVar := '';
     if Order <> 'Parcours souris'
     then begin
          ListVarUse := ListVarUseForThisCommand(Index,List);
          for i := 0 to length(ListVarUse)-1
          do SVar := SVar + ' '+ ListVarUse[i].Name +'='+ ListVarUse[i].Value;
          end;

     SAll := SOrder + SParam + SVar;

     RichEdit1.Lines.Add(SAll);

     Etape1 := GetTextLen + length(SOrder);
     Etape2 := Etape1 + length(SParam);
     Etape3 := Etape2 + length(SVar);

     if Order = 'Commentaire'
     then RichEdit1.SelAttributes.Style := RichEdit1.SelAttributes.Style + [fsBold];
     RichEdit1.SelStart := GetTextLen;
     RichEdit1.SelLength := Etape1;
     RichEdit1.SelAttributes.Assign(Form19.Label13.Font);

     if Order = 'Commentaire'
     then RichEdit1.SelAttributes.Style := RichEdit1.SelAttributes.Style + [fsBold];
     RichEdit1.SelStart := Etape1;
     RichEdit1.SelLength := Etape2;
     RichEdit1.SelAttributes.Assign(Form19.Label14.Font);
     
     if Order = 'Commentaire'
     then RichEdit1.SelAttributes.Style := RichEdit1.SelAttributes.Style + [fsBold];
     RichEdit1.SelStart := Etape2;
     RichEdit1.SelLength := Etape3;
     RichEdit1.SelAttributes.Assign(Form19.Label15.Font);

     RichEdit1.SelLength := 0;

     if Order = 'Goto'
     then RichEdit1.Lines.Add('');
end;

procedure TForm1.AddRecents(File_recents : String);
var ConfigIni: TIniFile;
    Filename : String;
    Recents_Nr : String;
    valeur,fichier_ecrase : String;
    i : integer;
begin
File_recents := GetLongFilename(File_recents);
if Recents1.Count > 0
then if Recents1.Items[0].Caption = File_recents then exit;

Filename := ExtractFileDir(Application.ExeName) + '\config.ini'; // recent uniquement dans Config.ini
ConfigIni := TIniFile.Create(filename);
try
Recents_nr := ConfigIni.ReadString('Recents', 'Recents_Nr','0');
fichier_ecrase := ConfigIni.ReadString('Recents', 'Recents' + Recents_nr, '');

for i := StrToInt(recents_nr) -1 downto 0 do
begin
valeur := ConfigIni.ReadString('Recents', 'Recents' + inttostr(i), '');
if Valeur =File_recents
then ConfigIni.WriteString('Recents', 'Recents' + IntToStr(i), fichier_ecrase);
end;

for i := 9 downto StrToInt(recents_nr) do
begin
valeur := ConfigIni.ReadString('Recents', 'Recents' + inttostr(i), '');
if Valeur =File_recents
then ConfigIni.WriteString('Recents', 'Recents' + IntToStr(i), fichier_ecrase);
end;

ConfigIni.WriteString('Recents', 'Recents' + Recents_Nr, file_recents);

if StrToInt(recents_nr) > 9 then recents_nr := '0';
recents_nr := IntToStr(StrToInt(recents_nr) + 1);
ConfigIni.WriteString('Recents', 'Recents_Nr',Recents_Nr);
finally ConfigIni.Free; ReadRecents; end;
end;

procedure TForm1.ReadRecents;
var ConfigIni: TIniFile;
    Filename : String;
    Recents_Nr : String;
    valeur : string;
    i : integer;
    NewItem: TMenuItem;
begin
Recents1.Clear;
filename := ExtractFileDir(Application.ExeName) + '\config.ini'; // recent uniquement dans Config.ini
ConfigIni := TIniFile.Create(filename);
try
Recents_nr := ConfigIni.ReadString('Recents', 'Recents_Nr','0');

for i := StrToInt(recents_nr) -1 downto 0 do
begin
valeur := ConfigIni.ReadString('Recents', 'Recents' + inttostr(i), '');
if valeur <> ''
then begin
     NewItem := TMenuItem.Create(Self);
     NewItem.Caption := valeur;
     NewItem.Tag := i;
     NewItem.OnClick := ClickRecents;
     Recents1.Add(NewItem);
     end;
end;
for i := 9 downto StrToInt(recents_nr) do
begin
valeur := ConfigIni.ReadString('Recents', 'Recents' + inttostr(i), '');
if valeur <> ''
then begin
     NewItem := TMenuItem.Create(Self);
     NewItem.Caption := valeur;
     NewItem.Tag := i;
     NewItem.OnClick := ClickRecents;
     Recents1.Add(NewItem);
     end;
end;
if XPMenu1.Active = True
then XPMenu1.ActivateMenuItem(Recents1,True);
finally ConfigIni.Free; end;
end;

procedure TForm1.ClickRecents(Sender : TObject);
var ConfigIni: TIniFile;
    filename : string;
    valeur : string;
begin
filename := GetFileIniName();
ConfigIni := TIniFile.Create(filename);
try
valeur := TMenuItem(Sender).Caption
finally ConfigIni.free; end;
openfilemacro(valeur,ListView1, -1,'Chargement des commandes en cours, veuillez patienter SVP.');
end;


procedure TForm1.MoveCommande(Sender :TListView; Old : integer; New : integer);
var Old_commande, New_commande : string;
    Old_param, New_param : string;
    Old_index, New_Index : integer;
begin
if ((Old >= 0) and (Old < Sender.Items.Count) and
    (New >= 0) and (New < Sender.Items.Count))
then begin
     // sauvegarde des valeurs actuelles
     Old_commande := Sender.Items.Item[Old].Caption;
     Old_param := Sender.Items.item[Old].SubItems.Strings[0];
     Old_index := Sender.Items.Item[Old].ImageIndex;

     New_commande := Sender.Items.Item[New].Caption;
     New_param := Sender.Items.item[New].SubItems.Strings[0];
     New_index := Sender.Items.Item[New].ImageIndex;
     // inversion des valeurs
     Sender.Items.Item[Old].Caption := New_commande;
     Sender.Items.item[Old].SubItems.Strings[0]:= New_param;
     Sender.Items.Item[Old].ImageIndex:= New_index;

     Sender.Items.Item[New].Caption := Old_commande;
     Sender.Items.item[New].SubItems.Strings[0] := Old_param;
     Sender.Items.Item[New].ImageIndex := Old_index;
     end;
end;

procedure TForm1.Update_Objet(List : TListView; Old_handle : Integer; New_handle : Integer);
var i : integer;
    ListParam : Tparam;
begin
for i := 0 to List.Items.Count -1
do begin
   // pour toutes les commandes avec le 1er parametre
   ListParam := GetParam(List.Items[i].SubItems.Strings[0]);
   if ListParam.param[1] = IntToStr(Old_Handle)
   then ChangeParam(List,i,1,IntToStr(new_Handle),False);

// plus necessaire puisque param = 1
{   if List.items[i].caption = 'Manipulation'
   then begin
        ListParam := GetParam(List.Items[i].SubItems.Strings[0]);
        if ListParam.param[1] = IntToStr(Old_Handle)
        then ChangeParam(List,i,1,IntToStr(new_Handle),True);
        end; }

   if List.items[i].caption = 'Fonction'
   then begin
        ListParam := GetParam(List.Items[i].SubItems.Strings[0]);
        if ListParam.param[4] = IntToStr(Old_Handle)
        then ChangeParam(List,i,4,IntToStr(new_Handle),False);
        end;

   if List.items[i].caption = 'Objet'
   then begin
        ListParam := GetParam(List.Items[i].SubItems.Strings[0]);
        if ListParam.param[2] = IntToStr(Old_Handle)
        then ChangeParam(List,i,2,IntToStr(new_Handle),False);
        end;
end;
end;

procedure TForm1.List_var_and_objet(Sender : TObject);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
    existe : boolean;
begin
if Sender is TComboBox
then begin
     (Sender as TComboBox).Items.Clear;
     (Sender as TComboBox).Text := '';
     for i := 0 to form1.ListView1.Items.Count -1 do
     if ((form1.ListView1.Items[i].Caption = 'Variable') or (form1.ListView1.Items[i].Caption = 'Objet'))
     then begin
          existe := False;
          var_list := form1.listView1.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);

          for j := 0 to (Sender as TComboBox).Items.Count -1 do
          if (Sender as TComboBox).Items.Strings[j] = ListParam.param[1]
          then existe := True;

          if existe = False then (Sender as TComboBox).Items.Add(ListParam.param[1]);

          if (Sender as TComboBox).Items.count = 0
          then (Sender as TComboBox).Items.Add(ListParam.param[1]);
          end;
end;
end;

procedure TForm1.WriteRegistry(Chemin : String; Entete : String; Valeur : String);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CLASSES_ROOT;
    Reg.OpenKey(Chemin,True);
    Reg.WriteString(Entete,Valeur);
  finally
    Reg.CloseKey;
    Reg.Free;
    inherited;
  end;
end;

procedure TForm1.Select_unique(Sender : TObject; Index : Integer);
var i :  integer;
begin
if sender is TListView
then begin
     if (index < 0) and ((Sender as TListView).Items.Count > 0)
     then index := 0;
     if ((Sender as TListView).Items.Count < index)
     then index := (Sender as TListView).Items.Count-1;

     for i := 0 to (Sender as TListview).items.count -1 do
     if i = index
     then (Sender as TListview).Items[i].Selected := True
     else (Sender as TListview).Items[i].Selected := False;
     end;
     if (Sender as TListview).SelCount = 1
     then (Sender as TListview).Selected.MakeVisible(True);
     end;


Procedure TForm1.New_Var_Name(Sender : TObject);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
begin
if Sender is TEdit
then begin
     j := 1;
     for i := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[i].Caption = 'Variable'
     then begin
          var_list := form1.listView1.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);
          if ListParam.param[1] = '<Var'+IntToStr(j)+'>'
          then Inc(J);
          end;
     (Sender as TEdit).Text := '<Var'+IntToStr(j)+'>';
     (Sender as TEdit).SelStart := 1;
     (Sender as TEdit).SelLength := length(IntToStr(j))+3;
      end;
end;

function TForm1.Fonction_existe(List : TListView; Commande : String ; Parametre : String): boolean;
var i : integer;
    var_list : String;
    resultat : boolean;
begin
     resultat := false;
     for i := 0 to List.Items.Count -1 do
     if List.Items[i].Caption = Commande
     then begin
          var_list := List.items.Item[i].SubItems.Strings[0];
          if var_list = Parametre then resultat := true;
          end;
     Result := resultat;
end;

function TForm1.Fonction_existe_with_param(List : TListView; Commande : String ; Parametre : String; indexofParam : integer): boolean;
var i : integer;
    var_list : String;
    resultat : boolean;
//  ListParam : TParam;
begin
     resultat := false;
     for i := 0 to List.Items.Count -1 do
     if List.Items[i].Caption = Commande
     then begin
          var_list := List.items.Item[i].SubItems.Strings[0];
          if GetParam(var_list).param[indexofParam] = Parametre then resultat := true;
          end;
     Result := resultat;
end;

function TForm1.FindModif(Index,Limit : integer; default : String): String;
var i, pos : integer;
    Ind : integer;
begin
result := default;
if index < 0 then Exit;
if Limit < 0 then Exit;
if Limit > ListView4.Items.Count-1 then Exit;

Ind := Index;
i := Limit;
while i > 0
do begin
   if (ListView4.Items.Item[i].SubItems[0] = 'Monter d''un niveau')
   then if  ListView4.Items.Item[i].caption= IntToStr(Ind)
        then begin Inc(ind); Dec(i); continue; end;

   if (ListView4.Items.Item[i].SubItems[0] = 'Descendre d''un niveau')
   then if ListView4.Items.Item[i].caption = IntToStr(Ind-1)
        then begin Dec(ind); Dec(i); continue;  end;

   pos := StrToInt(ListView4.Items.Item[i].caption);
   if pos = ind
   then begin
        result := ListView4.Items.Item[i].SubItems[2];
        break;
        end;
   Dec(i);
   end;

end;

function TForm1.Fonction_Pos(Commande : String ; Parametre : String; List : TListView = nil): integer;
var i : integer;
    var_list : String;
    resultat : integer;
    VList : TListView;
begin
if List = nil then VList := form1.listView1 else VList := List;
     resultat := -1;
     for i := 0 to VList.Items.Count -1 do
     if VList.Items[i].Caption = Commande
     then begin
          var_list := VList.items.Item[i].SubItems.Strings[0];
          if var_list = Parametre then resultat := i;
          end;
     Result := resultat;
end;

Procedure TForm1.New_Label_Name(Sender: TObject);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
begin
if Sender is TComboBox
then begin
     j := 1;
     for i := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[i].Caption = 'Label'
     then begin
          var_list := form1.listView1.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);
          if ListParam.param[1] = '<Label'+IntToStr(j)+'>'
          then Inc(J);
          end;
     (Sender as TComboBox).Text := '<Label'+IntToStr(j)+'>';
end;
end;

procedure TForm1.List_Objet(Sender: TObject);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
    Existe : Boolean;
begin

if Sender is TComboBox
then begin
     (Sender as TComboBox).Items.Clear;
     for i := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[i].Caption = 'Objet'
     then begin
          Existe := False;
          var_list := form1.listView1.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);

          for j := 0 to (Sender as TComboBox).Items.Count -1 do
          if (Sender as TComboBox).Items.Strings[j] = ListParam.param[1]
          then existe := True;

          If existe = False then (Sender as TComboBox).Items.Add(ListParam.param[1]);

          if (Sender as TComboBox).Items.count = 0
          then (Sender as TComboBox).Items.Add(ListParam.param[1]);
          end;
end;
end;

procedure TForm1.DoShowHint(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo);
begin
  if HintInfo.HintControl = ListView1 then
  begin
    with HintInfo do
    begin
      CanShow := True;
      ReshowTimeout:= 500;
      HideTimeout:= 500;
    end;
  end;
end;

procedure TForm1.List_Var(Sender: TStrings; Alpha, Num : Boolean; List : TListView = nil);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
    existe : Boolean;
begin
if List = nil then List := Form1.ListView1;

     Sender.Clear;
     Sender.Text := '';
     for i := 0 to List.Items.Count -1 do
     if List.Items[i].Caption = 'Variable'
     then begin
          existe := false;
          var_list := List.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);

          for j := 0 to Sender.Count -1 do
          if Sender.Strings[j] = ListParam.param[1]
          then existe := true;

          if (ListParam.param[3] = TAlpha) and ( Alpha = False) then existe := True;
          if (ListParam.param[3] = TNum) and ( Num = False) then existe := True;

          if existe = False then Sender.Add(ListParam.param[1]);
          end;
end;

function TForm1.GetInitialValueofVar(Name :String; Quote : char = #0) : string;
var i : integer;
    ListParam : TParam;
begin
result := '';

for i := 0 to ListView1.Items.Count -1
do if ListView1.Items[i].Caption = 'Variable'
   then begin
        ListParam := form1.GetParam(ListView1.items.Item[i].SubItems.Strings[0]);
        if ListParam.param[1] = Name
        then begin
             if  (ListParam.param[3] = TAlpha) and (Quote <> #0)
             then result := Quote + ListParam.param[2] + Quote
             else result := ListParam.param[2];
             break;
             end;
        end;
end;

procedure TForm1.List_Label(Sender: TObject);
var i,j : integer;
    var_list : String;
    ListParam : TParam;
    existe : Boolean;
begin
existe := False;
if (Sender is TComboBox) or (Sender is TListBox)
then begin
     (Sender as TComboBox).Items.Clear;
     for i := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[i].Caption = 'Label'
     then begin
          var_list := form1.listView1.items.Item[i].SubItems.Strings[0];
          ListParam := form1.GetParam(var_list);

          for j := 0 to (Sender as TComboBox).Items.Count -1 do
          if (Sender as TComboBox).Items.Strings[j] = ListParam.param[1]
          then Existe := True;
          if Existe = False then (Sender as TComboBox).Items.Add(ListParam.param[1]);

          if (Sender as TComboBox).Items.count = 0
          then (Sender as TComboBox).Items.Add(ListParam.param[1]);
          end;
end;
end;

procedure TForm1.List_procedure(Sender: TObject);
var i,j : integer;
    ProcName : String;
    ListParam : TParam;
    existe : Boolean;
begin
existe := False;
if (Sender is TComboBox) or (Sender is TListBox)
then begin
     (Sender as TComboBox).Items.Clear;
     for i := 0 to form1.ListView1.Items.Count -1 do
     if form1.ListView1.Items[i].Caption = 'Procedure'
     then begin
          ProcName := form1.listView1.items.Item[i].SubItems.Strings[0];
          if (copy(ProcName,0,3) = 'END') or (copy(ProcName,0,4) = 'CALL')
          then continue;

          for j := 0 to (Sender as TComboBox).Items.Count -1 do
          if (Sender as TComboBox).Items.Strings[j] = ListParam.param[1]
          then Existe := True;
          if Existe = False then (Sender as TComboBox).Items.Add(ProcName);

          if (Sender as TComboBox).Items.count = 0
          then (Sender as TComboBox).Items.Add(ProcName);
          end;
     end;
end;

function Tform1.FindEndOfProcedure(List : TListView; Pos : integer): integer;
var i,j : integer;
    ActionType : cardinal;
    param : String;
begin
result := -1;
j := 0;
if (Pos > List.Items.Count-1) then exit;
for i := Pos to List.Items.Count-1
do begin
   if (List.Items[i].Caption = 'Procedure')
   then begin
        param := List.items[i].SubItems[0];
        ActionType := 1;
        if copy(param,0,3) = 'END' then ActionType := 2;
        if copy(param,0,5) = 'CALL ' then ActionType := 3;
        if ActionType = 1 then Inc(j);
        if ActionType = 2 then Dec(j);
        if j = 0 then begin result := i; Exit; end;
        end;
   end;
end;

function TForm1.CanGetEndofProcedure(List : TListView; Pos : integer; Add : Boolean): Boolean;
var i,EndNbr,DeclNbr : integer;
begin
EndNbr := 0; DeclNbr := 0;
for i := Pos downto 0
do if List.Items[i].Caption = 'Procedure'
   then if (copy(List.Items[i].SubItems[0],0,3) = 'END')
        then Inc(EndNbr)
        else if (copy(List.Items[i].SubItems[0],0,5) <> 'CALL ')
             then begin Inc(DeclNbr); break; end;
if Add = True
then begin
     if EndNbr <> DeclNbr -1
     then result := False
     else result := True;
     end
else begin
     if EndNbr <> DeclNbr
     then result := False
     else result := True;
     end;

end;

function TForm1.procedure_exists(List : TListView; Name : string) : integer;
var i : integer;
begin
result := -1;

for i := 0 to List.Items.Count -1
do if (List.Items[i].Caption = 'Procedure') and (List.Items[i].SubItems[0] = GetValue(Name))
   then begin result := i; exit; end;

if (FnctTypeVar(Name) <> TNo) and (result = -1) and (ExecutionType = NotRun)
then result := 0;
end;

procedure TForm1.add_insert(Str1, Str2 : String; image_nr : integer);
var pos : integer;
begin
    if form1.Edition2.Checked = true
    then begin form1.ListView1.Items.Add();
               pos := form1.ListView1.Items.Count-1;
         end
    else begin
               if Form1.ListView1.Selected <> nil
               then begin
                    pos := Form1.ListView1.Selected.Index + 1;
                    form1.ListView1.Items.Insert(pos);
                    end
               else begin
                    form1.ListView1.Items.Add();
                    pos := form1.ListView1.Items.Count-1;
                    end;
         end;
    form1.ListView1.Items[pos].ImageIndex := image_nr;
    form1.ListView1.Items[pos].Caption := Str1;
    form1.listView1.items.Item[pos].SubItems.Add(Str2);
    Select_Unique(ListView1,pos);
    //InfoListViewInsert(pos);
    if sw_modif = False
    then form1.SaveBeforeChange(ListView1.Items[pos]);
end;

Procedure TForm1.FnctPause(Param : String);
var Debut: LongWord;
  ListParam : Tparam;
  millisec  : LongWord;
  oldname : string;
  Ssec,Smin,Sheure : String;
  Sec,Min,Heure : integer;
  chaine : array[1..8] of char;
  cpt : integer;
  aff : boolean;
begin
  MilliSec := 0;
  oldname := '';
  Param := GetValue(Param);
  ListParam := Form1.GetParam(Param);
  if ListParam.param[2] = 'Min' then Millisec := StrToInt(GetValue(ListParam.Param[1])) * 60000;
  if ListParam.param[2] = 'Sec' then Millisec := StrToInt(GetValue(ListParam.Param[1])) * 1000;
  if ListParam.param[2] = 'MilliSec' then Millisec := StrToInt(GetValue(ListParam.Param[1]));
  // pour le nouveau format 00:00:00
  if ListParam.param[2] = ''
  then begin
       ListParam.Param[1] := GetValue(ListParam.Param[1]);
       if Form7.TimeValide(ListParam.Param[1]) then
       begin
       if length(ListParam.Param[1]) >= 8 then for cpt := 1 to 8 do chaine[cpt] := ListParam.Param[1][cpt];
       Ssec := chaine[7] + chaine[8];
       Smin := chaine[4] + chaine[5];
       Sheure := chaine[1] + chaine[2];
       Millisec := StrToInt(Ssec) + StrToInt(Smin)*60 + StrToInt(Sheure)*3600;
       Millisec := Millisec *1000;
       end;
       end;

  if Millisec >= 3000 then Aff := True else Aff := False;
  Oldname := application.Title;

  Debut := GetTickCount;
  if Millisec > 0
  then begin
  repeat
  SleepEx(20,False);
  Application.ProcessMessages;
  if Run = False then break;
  if ((GetTickCount - debut) mod 1000 = 0) and (Aff = True)
  then begin
       cpt := (Millisec-(GetTickCount - debut)) div 1000;
       Heure := cpt div 3600; cpt := cpt mod 3600;
       Min := cpt div 60; cpt := cpt mod 60;
       Sec := cpt;
       SHeure := IntToStr(Heure);
       Smin := IntToStr(min);
       SSec := IntToStr(sec);
       if Heure < 10
       then begin chaine[1] := '0'; chaine[2] := SHeure[1]; end
       else begin chaine[1] := Sheure[1]; chaine[2] := Sheure[2]; end;
       chaine[3] := ':';
       if min < 10
       then begin chaine[4] := '0'; chaine[5] := Smin[1]; end
       else begin chaine[4] := Smin[1]; chaine[5] := Smin[2]; end;
       chaine[6] := ':';
       if sec < 10
       then begin chaine[7] := '0'; chaine[8] := Ssec[1]; end
       else begin chaine[7] := Ssec[1]; chaine[8] := Ssec[2]; end;
       Application.Title := 'Pause ' + chaine + ' - ' +StatusBar1.Panels[0].Text;
       Application.ProcessMessages;
       end;
  until ((GetTickCount - debut) >= LongWord(Millisec));
  end;
  Application.Title := oldname;
  Application.ProcessMessages;
end;

function TForm1.GetParamToStr(Params : TParam) : String;
var i : integer;
begin
case Params.nbr_param-1 of
     0: result := '';
     1: result := Params.param[1];
     else for i := 1 to Params.nbr_param-1
          do result := result+Params.param[i]+SprPr;
     end;
end;

function TForm1.GetParam(strParam : String):TParam;
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
    else Inc(i);
    if i >= 20 then break;
    end;
if length(StrParam) > 0
then if StrParam[length(StrParam)] <> SprPr then Inc(i);

resultparam.nbr_param := i ; //avant -1
result := resultparam;
end;

Function TForm1.GetImageIndex(Ordre: Tordre): integer;
begin
result := -1;
case AnsiIndexStr(Ordre.commande,CaseOfExecuteTab) of
     0 : result := 8;
     1 : result := 28;
     2 : result := 7;
     3 : result := 11;
     4 : result := 9;
     5 : result := 27;
  6,18 : result := 3;
     7 : result := 2;
     8 : result := 22;
  9,10 : result := 16;
    11 : result := 12;
    12 : result := 26;
    13 : result := 13;
    14 : result := 15;
    15 : result := 21;
    16 : result := 0;
    17 : result := 5;
    19 : result := 4;
    20 : result := 17;
    21 : result := 10;
    22 : result := 18;
    23 : result := 6;
24..28 : result := 20;
    29 : result := 14;
    30 : result := 29;
    31 : result := 30;
    -1 : if GetNewOrderIndex(Ordre.commande) <> -1
         then result := DynOrder[GetNewOrderIndex(Ordre.commande)].IconIndex
         else result := -1;
    end;
end;

Function TForm1.GetImageIndex(Ordre: String): integer;
var MyOrdre : TOrdre;
begin
MyOrdre.commande := Ordre;
result := GetImageIndex(MyOrdre);
end;


procedure TForm1.Add_commande(ListView : TListView; Ordre : TOrdre);
var Item : TListItem;
begin
Item := ListView.Items.Add();
Item.ImageIndex := GetImageIndex(Ordre);
Item.Caption := Ordre.commande;
Item.SubItems.Add(Ordre.textparam);
end;

procedure TForm1.Insert_commande(ListView : TListView; Ordre : TOrdre; index : integer);
var Item : TListItem;
begin
Item := ListView.Items.Insert(index);
Item.ImageIndex := GetImageIndex(Ordre);
Item.Caption := Ordre.commande;
Item.SubItems.Add(Ordre.textparam);
end;


procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
form2.show;
form2.ComboBox1.SetFocus;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
form4.show;
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin
form5.show;
end;

procedure TForm1.SaveMacro(List : TListView = nil);
var file_macro : File of TOrdre;
    Ordre : TOrdre;
    z,i : integer;
begin
if length(TabOfIncludeGen) > 0
then begin
     RestoreTabInclude(TabOfIncludeGen,ListView1);
     Exit;
     end;

if List = nil then List := ListView1;
if SaveDialog1.FileName <> ''
then begin
     z := random(List.Items.Count -1); //key
     if ExtractFileExt(SaveDialog1.FileName) = '.mcr'
     then AddRecents(SaveDialog1.filename);
     assignfile(file_macro,SaveDialog1.FileName);
     i := FileGetAttr(SaveDialog1.filename);
     if ((i and faReadOnly) = faReadOnly) and (FileExists(SaveDialog1.FileName) = True)
     then begin ShowMessage('Ce fichier est en lecture seule, veuillez enregister le fichier sous un autre nom, ou supprimer cette propriété.'); Exit; end;
     try
     rewrite(file_macro);
     // Sauvegarde macro Principale
     for i := 0 to List.Items.Count -1
     do begin
        if (z = i) and (Key <> '')
        then begin
             Ordre.commande := form32.Crypte('Info');
             Ordre.textparam := form32.Crypte(Key);
             write(file_macro,Ordre);
             Ordre.commande := form32.Crypte('Infos');
             if SourceOnly = True then Ordre.textparam := form32.Crypte('True') else Ordre.textparam := form32.Crypte('False');
             write(file_macro,Ordre);
             end;
        if Key = ''
        then begin
             Ordre.commande := List.Items[i].Caption;
             Ordre.textparam:= List.Items.Item[i].SubItems.Strings[0];
             end
        else begin
             Ordre.commande := Form32.crypte(List.Items[i].Caption);
             Ordre.textparam:= Form32.crypte(List.Items.Item[i].SubItems.Strings[0]);
             end;
        write(file_macro,Ordre);
        end;

     for i := 0 to ListView3.Items.Count -1
     do begin
        if Key = ''
        then begin
             Ordre.commande := 'Évaluer';
             Ordre.textparam:= ListView3.Items[i].Caption;
             end
        else begin
             Ordre.commande := Form32.crypte('Évaluer');
             Ordre.textparam:= Form32.crypte(ListView3.Items[i].Caption);
             end;
        write(file_macro,Ordre);
        end;

     for i := 0 to length(TabIgnoreMsg)-1
     do begin
        if TabIgnoreMsg[i].Exists = False then continue;
        if Key = ''
        then begin
             Ordre.commande :='IgnoreMsg';
             Ordre.textparam := TabIgnoreMsg[i].Pos +'~'+ TabIgnoreMsg[i].Msg;
             end
        else begin
             Ordre.commande :=Form32.crypte('IgnoreMsg');
             Ordre.textparam := Form32.crypte(TabIgnoreMsg[i].Pos +'~'+ TabIgnoreMsg[i].Msg);
             end;
        write(file_macro,Ordre);
        end;

     if (InfoListViewEmpty = False) and (List = ListView1)
     then begin
          for i := Low(TabInfoListView) to High(TabInfoListView)
          do begin
             if Key = ''
             then begin
                  Ordre.commande := '[InfoListView]';
                  Ordre.textparam := IntToStr(i)+'~'+BoolToStr(TabInfoListView[i].Bullet)+'~'+IntToStr(TabInfoListView[i].BulletColor)+'~'+IntToStr(TabInfoListView[i].SignetNr);
                  end
             else begin
                  Ordre.commande := Form32.crypte('InfoListView');
                  Ordre.textparam := Form32.crypte(IntToStr(i)+'~'+BoolToStr(TabInfoListView[i].Bullet)+'~'+IntToStr(TabInfoListView[i].BulletColor)+'~'+IntToStr(TabInfoListView[i].SignetNr));
                  end;
             write(file_macro,Ordre)
             end;
          end;

     if Form23.ComboBox1.Text <> Form23.ComboBox1.Items[3]
     then begin
          if MessageDlg('Votre macro n''est pas en priorité normal, voulez vous sauvegarder ce paramètre ?',
                         mtConfirmation, [mbYes, mbNo], 0) = mrYes
          then begin
               for i := 0 to 4 do if Form23.ComboBox1.Text = Form23.ComboBox1.Items[i] then break;

               Ordre.commande := '[Process Priority]';
               Ordre.textparam:= InttoStr(i);
               write(file_macro,Ordre);
               end;
          end;
     Form19.TabSheet7.TabVisible := True;
     finally CloseFile(file_macro); end;
     if List = ListView1
     then begin
          StatusBar1.Panels[0].Text := ExpandFileName(SaveDialog1.FileName);
          application.Title := ExtractFileName(StatusBar1.Panels[0].Text);
          Form1.Caption := Form1CaptionUpdate;
          change_liste := false;
          end;
     end
else begin
     Enregistersous1.Click;
     end;
end;

procedure TForm1.Enregistrer1Click(Sender: TObject);
begin
SaveMacro;
statusBar1.Repaint;
end;

procedure TForm1.Enregistersous1Click(Sender: TObject);
begin
if SaveDialog1.Execute then Enregistrer1.Click;
end;

procedure TForm1.Ouvrir1Click(Sender: TObject);
var file_macro : File of TOrdre;
    Ordre : TOrdre;
    count : integer;
    Affichage : Boolean;
    i,j,progress : integer;
    pass : integer;
    ListItem : TListItem;
    ArrayStr : TArrayString;
    Bln : Boolean;
begin
count := 0; progress :=0;
Affichage := False;

Form23.ComboBox1.Text := Form23.ComboBox1.Items[3];
Form23.ComboBox1.ItemIndex := 3;
Form23.ComboBox1.OnChange(self);

if SaveBeforeExit() = False then Exit;
ListView1.Visible := False;
ListView1.Items.BeginUpdate;
OpenDialog1.FilterIndex := 1;
If Opendialog1.Execute
then begin
     SetLength(TabIgnoreMsg,0);
     SetLength(TabInfoListView,0);
     if lowerCase(ExtractFileExt(OpenDialog1.FileName)) <> '.mcr'
     then begin
          Nouveau1.Click;
          CodeToStd(OpenDialog1.FileName);
          ListView1.Items.EndUpdate;
          ListView1.Visible := True;
          exit;
          end;

     unit32.Key := '';
     pass := form32.validation(Opendialog1.filename);
     if pass <> 1
     then begin
          if pass = 0 then MessageDlg('Mot de passe incorect.',mtWarning, [mbOk], 0);
          Exit;
          end;

     AddRecents(Opendialog1.filename);
     ListView1.Items.Clear;
     ListView3.Items.Clear;

     Can_Save := False;
     ListView4.Items.Clear;
     ListView4.Items.Add;
     ListView4.Items.Item[0].Caption := IntToStr(0);
     ListView4.Items.Item[0].SubItems.Add('Ouvrir');
     ListView4.Items.Item[0].SubItems.Add('');
     ListView4.Items.Item[0].SubItems.Add(Opendialog1.filename);
     // ajout du nouveau et unique evenement
     ListView4.Tag := 0;
     for i := 0 to ListView4.Items.Count -1
     do if ListView4.Tag = i
        then ListView4.Items.Item[i].StateIndex := 14
        else ListView4.Items.Item[i].StateIndex := -1;
     Select_Unique(ListView4,0);
     Can_Save := True;

     RichEdit1.Lines.Clear;

     StatusBar1.Panels[0].Text := ExpandFileName(OpenDialog1.FileName);
     application.Title := ExtractFileName(StatusBar1.Panels[0].Text);
     Form1.Caption := Form1CaptionUpdate;
     SaveDialog1.FileName := ExpandFileName(OpenDialog1.FileName);
     assignfile(file_macro,OpenDialog1.FileName);
     FileMode := 0;
     reset(file_macro);
     try
     while not eof(file_macro) do
           begin
                read(file_macro,Ordre);
                Inc(Count);
                //if Count > 301 then break;
           end;
     if Count > 300
     then begin
          Affichage  := True;
          Form29.ProgressBar1.Position := 0;
          Application.ProcessMessages;
          Progress := Count div 100;
          Form29.Show;
          Form29.Label1.Caption := 'Chargement des commandes en cours. Veuillez patienter SVP.';
          end;
     finally closeFile(File_macro); FileMode := 2; end;

     FileMode := 0;
     reset(File_Macro);
     try
     i :=0;
     while not eof(file_macro) do
           begin
                read(file_macro,Ordre);
                if Affichage = True
                then begin
                     Inc(i);
                     if i mod progress  = 0
                     then begin
                          Form29.ProgressBar1.Position := Form29.ProgressBar1.Position +1;
                          application.ProcessMessages;
                          end;
                     //if unit29.EchapProgress = True then break;
                     end;

                if Form32.decrypte(Ordre.commande) ='Info' then continue;
                if Form32.decrypte(Ordre.commande) ='Infos' then begin unit32.SourceOnly  := (Form32.decrypte(Ordre.textparam) = 'True'); continue; end;
                //if Form32.decrypte(Ordre.commande) ='InfosExit' then begin unit32.CanExit  := (Form32.decrypte(Ordre.textparam) = 'True'); continue; end;
                if key <> '' then begin
                                  Ordre.commande := Form32.decrypte(Ordre.commande);
                                  Ordre.textparam := Form32.decrypte(Ordre.textparam);
                                  end;

                if Ordre.commande = 'Évaluer'
                then begin

                     ListItem := ListView3.Items.Add;
                     ListItem.Caption := Ordre.textparam;
                     ListItem.SubItems.Add('');
                     ListItem.ImageIndex := 34;
                     continue;
                     end;

                if Ordre.commande = '[Process Priority]'
                then begin
                     if FnctIsInteger(Ordre.textparam) = True
                     then begin
                          Form23.ComboBox1.Text := Form23.ComboBox1.Items[StrToInt(Ordre.textparam)];
                          Form23.ComboBox1.ItemIndex := StrToInt(Ordre.textparam);
                          Form23.ComboBox1.OnChange(self);
                          end;
                     continue;
                     end;
                if Ordre.commande = '[ALIAS_EXE]'
                then begin
                     ALIAS_EXE := Ordre.textparam;
                     continue;
                     end;
                if Ordre.commande = 'IgnoreMsg'
                then begin
                     SetLength(TabIgnoreMsg,length(TabIgnoreMsg)+1);
                     j := Pos('~',Ordre.textparam);
                     TabIgnoreMsg[length(TabIgnoreMsg)-1].Pos := Copy(Ordre.textparam,0,j-1);
                     TabIgnoreMsg[length(TabIgnoreMsg)-1].Msg := Copy(Ordre.textparam,j+1,length(Ordre.textParam)-j);
                     TabIgnoreMsg[length(TabIgnoreMsg)-1].Exists := True;
                     continue;
                     end;
                if Ordre.commande = '[InfoListView]'
                then begin
                     ArrayStr := Explode(Ordre.textparam,'~');
                     if Length(ArrayStr) = 4
                     then begin
                          TabInfoListView[StrToInt(ArrayStr[0])].index := StrToInt(ArrayStr[0]);
                          TabInfoListView[StrToInt(ArrayStr[0])].Bullet := StrToBool(ArrayStr[1]);
                          TabInfoListView[StrToInt(ArrayStr[0])].BulletColor := StrToInt(ArrayStr[2]);
                          TabInfoListView[StrToInt(ArrayStr[0])].SignetNr := StrToInt(ArrayStr[3]);
                          end;
                     continue;
                     end;
                add_commande(ListView1, Ordre);
           end;
     finally closeFile(file_macro); FileMode := 2; end;
     Select_unique(ListView1, -1);
     change_liste := false;
     ControlAll(ListView1);
     end;

if Affichage = True then form29.Close;
StatusBar1.Repaint;
ListView1.Items.EndUpdate;
ListView1.Visible := True;
// Mise a jout de la liste des tâches planifiées
Form19.updateParam;
if (length(TabInfoListView) <> ListView1.Items.Count)
then InfoListViewClear(ListView1.Items.Count);
ImgTab.FreeAll;
end;

function TForm1.OpenFileMacro(file_name : string; ListView : TListView; index : integer; MsgDownload : string): integer;
var file_macro : File of TOrdre;
    Ordre : TOrdre;
    count : integer;
    Affichage : Boolean;
    i,j,cptindex, progress : integer;
    pass : integer;
    ListItem : TListItem;
    BigMacro : integer;
    ArrayStr : TArrayString;
    VisualVar_PropName : String;
begin
result := 0;
if ListView = ListView1
then SetLength(TabInfoListView,0);
cptIndex := 0; count := 0; progress := 0;
Affichage := False;

Form23.ComboBox1.Text := Form23.ComboBox1.Items[3];
Form23.ComboBox1.ItemIndex := 3;
Form23.ComboBox1.OnChange(self);
ListView.Items.BeginUpdate;
try

if fileexists(file_name) = True
then begin
     unit32.Key := '';

     if (lowerCase(ExtractFileExt(file_name)) <> '.mcr') and (ExtractFileExt(file_name) <> '.sqc')
     then begin
          if ListView = Form1.ListView1 then Nouveau1.Click;
          CodeToStd(file_name,ListView);
          ListView1.Items.EndUpdate;
          exit;
          end;

     if (OpenEdt = False) and (form32.IsCryptedSourceOnly(file_name) = True)
     then begin pass := 1; unit32.key := form32.GetPass(file_name); end
     else pass := Form32.validation(file_name);

     if pass <> 1
     then begin
          if pass = 0 then MessageDlg('Mot de passe incorrect.',mtWarning, [mbOk], 0);
          unit32.Key := '';
          result := 0;
          Exit;
          end;
     if index < 0 then if SaveBeforeExit = False then Exit;
     Opendialog1.FileName := file_name;
     Application.ProcessMessages;

     Can_Save := False;

     if index < 0
     then begin
          AddRecents(Opendialog1.filename);
          ListView1.Items.Clear;
          ListView3.Items.Clear;
          ListView4.Items.Clear;
          ListView4.Items.Add;
          ListView4.Items.Item[0].Caption := IntToStr(0);
          ListView4.Items.Item[0].SubItems.Add('Ouvrir');
          ListView4.Items.Item[0].SubItems.Add('');
          ListView4.Items.Item[0].SubItems.Add(Opendialog1.filename);
          // ajout du nouveau et unique evenement
          ListView4.Tag := 0;
          for i := 0 to ListView4.Items.Count -1
          do if ListView4.Tag = i
             then ListView4.Items.Item[i].StateIndex := 14
             else ListView4.Items.Item[i].StateIndex := -1;
          Select_Unique(ListView4,0);
          end;

     assignfile(file_macro,file_name);
     FileMode := 0;
     reset(file_macro);
     try
     while not eof(file_macro) do  // pour déterminer le nombre d'enregistrement
     begin
          read(file_macro,Ordre);
          Inc(Count);
     end;
     finally closeFile(File_macro); FileMode := 2; end;
     if DirectRun = True then BigMacro := 1000 else BigMacro := 300;

     if (Count > BigMacro) and (MsgDownload <> '')
     then begin
          Affichage  := True;
          Form29.ProgressBar1.Position := 0;
          Application.ProcessMessages;
          Progress := Count div 100;
          Form29.Show;
          Form29.Label1.Caption := MsgDownload;
          end;

     FileMode := 0;
     reset(File_Macro);
     try
     i := 0;

     while not eof(file_macro) do
           begin
                read(file_macro,Ordre);
                if Form32.decrypte(Ordre.commande) ='Info' then continue;
                if Form32.decrypte(Ordre.commande) ='Infos' then begin continue; unit32.SourceOnly  := (Form32.decrypte(Ordre.textparam) = 'True'); end;
                //if Form32.decrypte(Ordre.commande) ='InfosExit' then begin continue; unit32.CanExit  := (Form32.decrypte(Ordre.textparam) = 'True'); end;
                if key <> '' then begin
                                  if Ordre.commande <> '[ALIAS_EXE]'
                                  then begin
                                       Ordre.commande := Form32.decrypte(Ordre.commande);
                                       Ordre.textparam := Form32.decrypte(Ordre.textparam);
                                       end;
                                  end;

                if Ordre.commande = 'Évaluer'
                then begin
                     if ListView <> ListView1 then continue;
                     ListItem := ListView3.Items.Add;
                     ListItem.Caption := Ordre.textparam;
                     ListItem.SubItems.Add('');
                     ListItem.ImageIndex := 34;
                     continue;
                     end;

                if Ordre.commande = '[Process Priority]'
                then begin
                     if FnctIsInteger(Ordre.textparam) = True
                     then begin
                          Form23.ComboBox1.Text := Form23.ComboBox1.Items[StrToInt(Ordre.textparam)];
                          Form23.ComboBox1.ItemIndex := StrToInt(Ordre.textparam);
                          Form23.ComboBox1.OnChange(self);
                          end;
                     continue;
                     end;
                if Ordre.commande = '[ALIAS_EXE]'
                then begin
                     ALIAS_EXE := Ordre.textparam;
                     continue;
                     end;
                if Ordre.commande ='IgnoreMsg'
                then begin
                     SetLength(TabIgnoreMsg,length(TabIgnoreMsg)+1);
                     j := Pos('~',Ordre.textparam);
                     TabIgnoreMsg[length(TabIgnoreMsg)-1].Pos := Copy(Ordre.textparam,0,j-1);
                     TabIgnoreMsg[length(TabIgnoreMsg)-1].Msg := Copy(Ordre.textparam,j+1,length(Ordre.textParam)-j);
                     TabIgnoreMsg[length(TabIgnoreMsg)-1].Exists := True;
                     continue;
                     end;
                if Ordre.commande = '[InfoListView]'
                then begin
                     if ListView <> ListView1 then continue;
                     ArrayStr := Explode(Ordre.textparam,'~');
                     if Length(ArrayStr) = 4
                     then begin
                          TabInfoListView[StrToInt(ArrayStr[0])].index := StrToInt(ArrayStr[0]);
                          TabInfoListView[StrToInt(ArrayStr[0])].Bullet := StrToBool(ArrayStr[1]);
                          TabInfoListView[StrToInt(ArrayStr[0])].BulletColor := StrToInt(ArrayStr[2]);
                          TabInfoListView[StrToInt(ArrayStr[0])].SignetNr := StrToInt(ArrayStr[3]);
                          end;
                     continue;
                     end;

                if index < 0
                then add_commande(ListView, Ordre)
                else Insert_commande(ListView, Ordre,index+CptIndex);
                Inc(CptIndex);

                if Affichage = True
                then begin
                     Inc(i);
                     if i mod progress  = 0 then Form29.ProgressBar1.Position := Form29.ProgressBar1.Position +1;
                     application.ProcessMessages;
                     if unit29.EchapProgress = True then break;
                     end;
           end;
     finally closeFile(File_macro); FileMode := 2; end;
     
     if Index < 0
     then begin
          StatusBar1.Panels[0].Text := ExpandFileName(OpenDialog1.FileName);
          application.Title := ExtractFileName(StatusBar1.Panels[0].Text);
          Form1.Caption := Form1CaptionUpdate;
          SaveDialog1.FileName := OpenDialog1.FileName;

          if (ListView.name <> 'ListView1') or (DirectRun = False)
          then ControlAll(ListView);
          end;
     end
else begin
     MessageDlg(SFileNotFound +' ('+ file_name + ')',mtError,[mbok],0);
     end;

if Affichage = True then form29.Close;
finally
statusBar1.Repaint;
ListView.Items.EndUpdate;
Can_Save := True;
result := CptIndex;
if (ListView = ListView1) and(length(TabInfoListView) <> ListView1.Items.Count)
then InfoListViewClear(ListView1.Items.Count);
end;
// Mise a jout de la liste des tâches planifiées
Form19.updateParam;
ImgTab.FreeAll;
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin
form6.show;
end;

procedure TForm1.SpeedButton5Click(Sender: TObject);
var FileName : String;
begin
OpenDialog2.Filter := 'Exécutable et macro|*.exe;*.mcr|Exécutable|*.exe|Macro|*.mcr|Tous|*.*';
OpenDialog2.FilterIndex := 1;
FileName := '';
if unit1.sw_modif = true
then begin
     FileName := form1.ListView1.Selected.SubItems.Strings[0];
     if fileExists(FileName) then OpenDialog2.FileName := FileName;

     if ExtractfileExt(FileName) = '.exe' then Opendialog2.FilterIndex := 1;
     if ExtractfileExt(FileName) = '.mcr' then Opendialog2.FilterIndex := 2;
     if ((ExtractfileExt(FileName) <> '.mcr') and (ExtractfileExt(FileName) <> '.exe'))
     then OpenDialog2.filterIndex := 3;
     end
else OpenDialog2.FileName := '';
form26.show;
end;

procedure TForm1.SpeedButton8Click(Sender: TObject);
begin
form7.show;
end;

procedure TForm1.Nouveau1Click(Sender: TObject);
var i : integer;
begin
if ContextofExecute.ExecutionType <> ContextOfExecute.NotRun
then Stop1.OnClick(self);
if SaveBeforeExit = False then Exit;
Can_Save := False;
InfoListViewClear;

ListView1.Items.BeginUpdate;
ListView1.Items.Clear;
ListView1.Items.EndUpdate;

ListView3.Items.BeginUpdate;
ListView3.Items.Clear;
ListView3.Items.EndUpdate;

ListView4.Items.BeginUpdate;
ListView4.Items.Clear;
ListView4.Items.EndUpdate;

ListView4.Items.Add;
ListView4.Items.Item[0].Caption := IntToStr(0);
ListView4.Items.Item[0].SubItems.Add(Lng_NewMacro);
ListView4.Items.Item[0].SubItems.Add('');
ListView4.Items.Item[0].SubItems.Add('');
// ajout du nouveau et unique evenement
ListView4.Tag := 0;
for i := 0 to ListView4.Items.Count -1
do if ListView4.Tag = i
   then ListView4.Items.Item[i].StateIndex := 14
   else ListView4.Items.Item[i].StateIndex := -1;
Select_Unique(ListView4,0);
Can_Save := True;

RichEdit1.Lines.Clear;

StatusBar1.Panels[0].Text := Lng_NewMacro;
application.Title := Lng_NewMacro;
Form1.Caption := Form1CaptionUpdate;
SaveDialog1.FileName := '';
unit32.key := '';
ControlAll(ListView1);
StatusBar1.Panels[3].Text := 'Ligne 0/0';
StatusBar1.Repaint;
Form19.updateparam;
SetLength(TabIgnoreMsg,0);
unit5.ImgTab.FreeAll;

end;

procedure TForm1.Editer1Click(Sender: TObject);
var Text : String;
    Item : TListItem;
begin
if listview1.Selected = nil then Exit;
if listview1.Selected.SubItems = nil then Exit;
if listview1.Selected <> nil
then begin
Item :=  listview1.Selected;
sw_modif := true;
     Save_Caption := listview1.Selected.SubItems[0];
     if listview1.Selected.Caption = 'Type'
     then form2.show;
     if listview1.Selected.Caption = 'Type Special'
     then form4.show;
     if listview1.Selected.Caption = 'Move Mouse'
     then form5.show;
     if listview1.Selected.Caption = 'Click'
     then form6.show;
     if listview1.Selected.Caption = 'Execute'
     then Speedbutton5.Click;
     if listview1.Selected.Caption = 'Pause'
     then form7.show;
     if listview1.Selected.Caption = 'Variable'
     then form8.show;

     if listview1.Selected.Caption = 'Question'
     then begin form9.Caption := 'Question';  Form9.Label3.Visible := True; Form9.ComboBox1.Visible := True; form9.show; end;
     if listview1.Selected.Caption = 'Message'
     then begin form9.Caption := 'Message'; Form9.Label3.Visible := False; Form9.ComboBox1.Visible := False; form9.show; end;

     if listview1.Selected.Caption = 'Examine'
     then form11.show;
     if listview1.Selected.Caption = 'Label'
     then begin form3.Caption := 'Label'; form3.show; end;
     if listview1.Selected.Caption = 'Goto'
     then begin form3.Caption := 'Goto'; form3.show; end;
     if listview1.Selected.Caption = 'Calcul'
     then form12.show;
     if listview1.Selected.Caption = 'Calcul évolué'
     then form24.show;
     if listview1.Selected.Caption = 'Fonction'
     then form13.show;
     if listview1.Selected.Caption = 'Commentaire'
     then form14.show;
     if listview1.Selected.Caption = 'Lire'
     then form15.show;
     if listview1.Selected.Caption = 'Ecrire'
     then form15.show;
     if listview1.Selected.Caption = 'Objet'
     then form16.show;
     if listview1.Selected.Caption = 'Manipulation'
     then form18.show;
     if listview1.Selected.Caption = 'ScriptEval'
     then form25.show;
     if listview1.Selected.Caption = 'Procedure'
     then form36.show;
     if ListView1.Selected.Caption = 'Inclusion'
     then begin
          OpenDialog2.Filter := 'Macro|*.mcr|Tous les fichiers|*.*';
          if ExtractFileExt(ListView1.Selected.SubItems.Strings[0]) = '.mcr'
          then OpenDialog2.FilterIndex := 1
          else  OpenDialog2.FilterIndex := 2;
          Opendialog2.FileName := ListView1.Selected.SubItems.Strings[0];
          if OpenDialog2.Execute
          then begin
               ListView1.Selected.SubItems.Strings[0] := Opendialog2.FileName;
               SaveBeforeChange(Form1.ListView1.Selected);
               end;
          sw_modif := False;
          end;
     //if listview1.Selected.Caption = 'Parcours souris'
     //then MParcours;
     if listview1.Selected.Caption = 'Outil Affichage' then form27.show;
     if listview1.Selected.Caption = 'Outil Alimentation' then form27.show;
     if listview1.Selected.Caption = 'Outil Ecran' then form27.show;
     if listview1.Selected.Caption = 'Outil Fichier' then form27.show;
     if listview1.Selected.Caption = 'Outil Son' then form27.show;
     if listview1.Selected.Caption = 'Outil Répertoire' then form27.show;
     if listview1.Selected.Caption = 'Champs' then form30.show;
     if listview1.Selected.Caption = 'Trouve image' then form22.show;
     if (sw_modif = True) and (GetNewOrderIndex(Item.Caption)<> -1)
     then begin
          TSpeedButton(DynOrder[GetNewOrderIndex(Item.Caption)].PointerSbtn).Enabled := False;
          PLUGIN_CANCEL_NEW_OR_CHANGE_ORDER := False;
          Text := StrPas(DynOrder[GetNewOrderIndex(Item.Caption)].ChangeOrdre(Pchar(Item.SubItems[0])));
          if PLUGIN_CANCEL_NEW_OR_CHANGE_ORDER = False
          then begin
               Item.SubItems[0] := Text;
               if Save_Caption <> Text then Form1.SaveBeforeChange(Item);
               end;
          sw_modif := False;
          TSpeedButton(DynOrder[GetNewOrderIndex(Item.Caption)].PointerSbtn).Enabled := True;
          end;
end;

end;

procedure TForm1.Supprimer1Click(Sender: TObject);
var i, ISelect : integer;
    ok : Boolean;
    ListParam : Tparam;
    CustomEdit : TCustomEdit;
begin
if ((Listview1.Selected <> nil) and (ListView1.Focused = True))
then begin
     ISelect := listview1.Selected.Index;
     for i := ListView1.Items.Count -1 downto 0
     do begin
        if (ListView1.Items.Item[i].Selected = True) then ok := True else ok := False;

        if (ListView1.Items.Item[i].Selected = True) and (ListView1.Items.Item[i].caption = 'Variable')
        then begin
             ListParam := GetParam(ListView1.Items.Item[i].SubItems[0]);
             if VarUse(Listview1, ListParam.param[1]) = True
             then begin
                  if CountFindTextParam('Variable',ListParam.param[1]) <= 1
                  then begin
                       ok := False;
                       MessageDlg('La variable nommée '+ ListParam.param[1] +' ne peut pas être supprimer car elle est utilisée dans les paramètres d''une autre commande.',mtWarning,[mbok],0);
                       end;
                  end;
             end;

        if (ListView1.Items.Item[i].Selected = True) and (ListView1.Items.Item[i].caption = 'Label')
        then begin
             ListParam := GetParam(ListView1.Items.Item[i].SubItems[0]);
             if Fonction_Pos('Goto',ListParam.param[1]) >= 0
             then begin
                  if CountFindTextParam('Label',ListParam.param[1]) <= 1
                  then begin
                       ok := False;
                       MessageDlg('Le label nommée '+ ListParam.param[1] +' ne peut pas être supprimer car il est utilisé dans une commande Goto.',mtWarning,[mbok],0);
                       end;
                  end;
             end;

        if ok = True then ListView1.Items.Item[i].Delete;
        end;
        Select_Unique(ListView1,ISelect-1);
end
else begin
     CustomEdit :=  TCustomEdit(ObjectPopMenu);
     if CustomEdit <> nil
     then SendMessage(CustomEdit.Handle,WM_KEYDOWN,VK_DELETE,0);
     end;
end;

procedure TForm1.InitForm1();
var i,j : integer;
    ARect : TRect;
    ConfigIni: TIniFile;
    Str,MyHint : String;
    HelpFile : String;
    SpBtn : TSpeedButton;
    FileNameExpand : string;
    ChildNode, RubNode, MyTreeNode : TTreeNode;
    List : TStringList;
    IEVersion : String;
    IEVersionMin : integer;
    FormNoName : TForm;
begin
// ppp120 au lieu du standard 96
PageControl2.width := PaintPanel1.Width - SpeedButton14.Left + SpeedButton14.Width+10;

Randomize;
IEVersionMin := 4;
IEVersion :=form23.GetInternetExplorerVersion;
IEVersion := Copy(IEVersion,0,Pos('.',IEVersion)-1);
if FnctIsInteger(IEVersion)
then if StrToInt(IEVersion) < IEVersionMin
     then begin
          ShowApplicationError('La configuration requise pour l''exécution de cette application n''est pas correcte [Internet Explorer '+ IEVersion +'('+Form23.GetInternetExplorerVersion+')<'+IntToStr(IEVersionMin)+'].');
          Application.Terminate;
          end;

// initialisation des Variables système
DecimalSeparator := '.';
Form8.InitListOfSysVar();

GetBitmapFromResAll;

Form23.ComboBox1.Text := Form23.ComboBox1.Items[3];
Form23.ComboBox1.ItemIndex := 3;
Form23.ComboBox1.OnChange(self);

ConfigIni := TIniFile.Create(GetFileIniName);
try
// chargement de la langue
Form19.Combobox3.Text := ConfigIni.ReadString('Langage', 'Lng',Form19.Combobox3.Text);
// Description détaillé


// les nouvelles commandes doivent etre chargées avant la macro

List := TStringList.Create;
try
ConfigIni.ReadSection('DynOrder',List);
for i := 0 to List.Count-1
do if ConfigIni.ReadString('DynOrder', IntToStr(i) ,'nil') <> 'nil'
   then AddOrder(Pchar(ConfigIni.ReadString('DynOrder', IntToStr(i) ,'nil')));
finally List.Free; end;

MyTreeNode := TreeView1.Items.Add(nil,'Plugins');
MyTreeNode.ImageIndex := 23;
MyTreeNode.StateIndex := 23;
MyTreeNode.SelectedIndex := 23;
for i := 0 to Length(DynOrder)-1
do begin

   if DynOrder[i].Name <> ''
   then begin
        RubNode := nil;
        for j := 0 to MyTreeNode.Count-1
        do begin
           if MyTreeNode[j].Text = DynOrder[i].Rubrique
           then Rubnode := MyTreeNode[j];
           end;

        if RubNode = nil
        then begin
             RubNode := TreeView1.Items.AddChild(MyTreeNode,DynOrder[i].Rubrique);
             RubNode.ImageIndex :=  24;
             RubNode.StateIndex := 24;
             RubNode.SelectedIndex := 24;
             end;

        ChildNode := TreeView1.Items.AddChild(RubNode,DynOrder[i].Name);
        ChildNode.ImageIndex :=  DynOrder[i].IconIndex;
        ChildNode.StateIndex := DynOrder[i].IconIndex;
        ChildNode.SelectedIndex := DynOrder[i].IconIndex;
        end;
   end;

ModuleSup.Form1_LoadTreeView1;

if Form19.Combobox3.Text <> 'Français'
then LoadLanguage(Form19.Combobox3.Text);

Str := UpperCase(ConfigIni.ReadString('InfoBulle', 'Show','True'));
if Str = 'TRUE' then ShowInfoBulle := True else ShowInfoBulle := False;


// chargement de la taille et de la position de toutes les fenêtres
for i := 1 to 37 do
begin
     if (Application.FindComponent('Form'+ InttoStr(i)) as TForm) = nil then continue;
     // Exclus la fenêtre de bug Message
     FormNoName := (Application.FindComponent('Form'+ InttoStr(i)) as TForm);
     if FormNoName.Name = 'Form34' then continue;

     Arect.Top    := FormNoName.Top;
     Arect.Left   := FormNoName.Left;
     Arect.Right  := FormNoName.Width;
     Arect.Bottom := FormNoName.Height;

     Arect.Top    := StrToInt(ConfigIni.ReadString('Form', 'Top'+IntToStr(i) , IntToStr(ARect.Top)));
     Arect.Left   := StrToInt(ConfigIni.ReadString('Form', 'Left'+IntToStr(i) , IntToStr(ARect.Left)));
     Arect.Right  := StrToInt(ConfigIni.ReadString('Form', 'Width'+IntToStr(i) , IntToStr(ARect.Right)));
     Arect.Bottom := StrToInt(ConfigIni.ReadString('Form', 'Height'+IntToStr(i) , IntToStr(ARect.Bottom)));

     FormNoName.Top     := ARect.Top;
     FormNoName.Left    := ARect.Left;
     FormNoName.Width   := ARect.Right;
     FormNoName.Height  := ARect.Bottom;

     // pas de dessin de fond pour la fenetre principale
     if (FormNoName.Name <> 'Form1') and (FormNoName.Name <> 'Form36')
     then (Application.FindComponent('Form'+ InttoStr(i)) as TForm).OnPaint := Form2.OnPaint;

     FormNoName.HelpFile := HelpFile;
     if XPMenu1.Active = True
     then XPMenu1.InitComponent(FormNoName);
     if (Form19.CheckBox11.Checked) and (i <> 1)
     then AnchorForm(FormNoName); // shuntage des Anchors

     //PrintComponentList(FormNoName,'c:\component.txt','c:\componentSort.txt');
     //PrintMapArea(FormNoName,'c:\Jacques\component.txt','c:\Jacques\componentSort.txt');
end;
finally ConfigIni.Free; end;

// ajout dans le menu les fichiers recents
ReadRecents;
// Recuperation du fichier d'aide
HelpFile := ExtractFileDir(application.ExeName) + '\AIDE SUPER MACRO.HLP';
if not Fileexists(HelpFile) then helpFile := 'AIDE SUPER MACRO.HLP';

if ParamStr(ParamCount) = '/edt'
then OpenEdt := True
else OpenEdt := False;
if ParamStr(ParamCount) = '/fromExport'
then DirectFromExport := True
else DirectFromExport := False;

// l'execution se fait dans le fichier super_macro.pas
OpenDialog1.FileName := ParamStr(1); //GetExecParam(1);
OpenDialog1.FileName := StringReplace(OpenDialog1.FileName,'~',' ',[rfReplaceAll]);
Opendialog1.FileName := GetLongFilename(Opendialog1.FileName);
if OpenDialog1.FileName = ''
then Nouveau1.click
else if not FileExists(OpenDialog1.FileName)
     then Exit
     else begin
          if ParamStr(ParamCount) <> '/edt' then DirectRun := True;
          OpenFileMacro(OpenDialog1.FileName, ListView1, -1,'Chargement des commandes en cours, veuillez patienter SVP.');
          end;

if UpperCase(ParamStr(ParamCount)) = '/HIDE'
then begin
     MiniFrame := True;
     OpenEdt := True;
     end;

if (form1.GetInitialValueofVar('[MACRO.OPENMODE]') = 'EDIT')
then unit1.OpenEdt := True;

// référe toutes les evénements click des composants SpeedButton imitant les touches
// clavier a SpeedButton1.onclick de la form4 (commande touche spécial)
for i := 2 to 110
do begin
   SpBtn := (Form4.FindComponent('SpeedButton'+ InttoStr(i)) as TSpeedButton);
   if  SpBtn = nil then continue;
   SpBtn.OnClick  := Form4.SpeedButton1.onClick;
   end;

form23.label5.Caption := 'Windows version : '+ Form19.WindowsVersion();

HotKeyManager1.AddHotKey(ShortCut(VK_NumLock,[]));
HotKeyManager1.AddHotKey(ShortCut(VK_SNAPSHOT,[]));
Form19.ChangeGeneralColorText();

//ajoute la petite icône dans la barre des tâches
if (Form1.OpenDialog1.FileName <> '') and (OpenEdt = False) and (ShowInfoBulle = True)
then begin
     FileNameExpand := GetLongFilename(Form1.OpenDialog1.FileName);
     notifyStruc.cbSize:=SizeOf(notifyStruc);
     notifyStruc.hWnd:=Handle;
     notifyStruc.uID:=1;
     NotifyStruc.uFlags := NIF_ICON or NIF_TIP or NIF_MESSAGE;
     NotifyStruc.uCallbackMessage := WM_MYMESSAGE;
     NotifyStruc.hIcon :=  application.Icon.Handle;
     if ALIAS_EXE = ''
     then MyHint:= 'Exécution de ' + FileNameExpand
     else MyHint:= 'Exécution de ' + ALIAS_EXE;
     if length(MyHint) > 127 // Pour éviter le depassement du tableau de szTip limité à 128bits
     then MyHint := Copy(MyHint,0,16)+'...'+ Copy(MyHint,length(MyHint)-106,length(MyHint));

     for i:=0 to length(MyHint)-1 do NotifyStruc.szTip[i] := MyHint[i+1];
     NotifyStruc.szTip[length(MyHint)]:=#0;
     // info bulle
     NotifyStruc.uFlags := NotifyStruc.uFlags or $00000010;;
     NotifyStruc.dwInfoFlags := $00000001;
     if ALIAS_EXE = ''
     then Str := 'Exécution de :' +#13#10+ WrapText(FileNameExpand, 38)
     else Str := 'Exécution de :' +#13#10+ WrapText(ALIAS_EXE, 38);
     if length(Str) > 255 then Str := Copy(Str,0,16)+'...'+ Copy(Str,length(Str)-206,length(Str));
//     if ALIAS_EXE = ''
//     then StrLCopy(NotifyStruc.szInfo, PChar('Exécution de :'+ Chr(VK_RETURN) + FileNameExpand), SizeOf(NotifyStruc.szInfo)-1)
//     else StrLCopy(NotifyStruc.szInfo, PChar('Exécution de :'+ Chr(VK_RETURN) + ALIAS_EXE), SizeOf(NotifyStruc.szInfo)-1);
     StrLCopy(NotifyStruc.szInfo, PChar(Str), SizeOf(NotifyStruc.szInfo)-1);
     StrLCopy(NotifyStruc.szInfoTitle, PChar('Super Macro'), SizeOf(NotifyStruc.szInfoTitle)-1);
     NotifyStruc.TimeoutOrVersion.uTimeout := 5 * 1000;
     //
     Shell_NotifyIcon(NIM_ADD,@NotifyStruc);
     end;

Description := TStringList.Create();
if FileExists(ExtractFileDir(Application.ExeName) + '\'+ form19.ComboBox3.Text + '.lng')
then Description.LoadFromFile(ExtractFileDir(Application.ExeName) + '\'+ form19.ComboBox3.Text + '.lng');

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
XPMenu1:= TXPMenu.Create(Form1);
XPMenu1.Active := True;
UbackGround.TransformTimageToWizard(Image1);
HotKeyManager1 := THotKeyManager.Create(Form1);
HotKeyManager1.OnHotKeyPressed := HotKeyManager1HotKeyPressed;

// recuperation des erreurs
if LoadAndParseMapFile then application.OnException := ShowApplicationError;

// InitForm1(); la fonction est applée par la dernière form (fichier de chargement)

BackGround := TBitmap.Create; // création d'un BitMap

ImageList1.GetBitmap(0,SpeedButton1.Glyph);
ImageList1.GetBitmap(4,SpeedButton2.Glyph);
ImageList1.GetBitmap(2,SpeedButton3.Glyph);
ImageList1.GetBitmap(3,SpeedButton4.Glyph);
ImageList1.GetBitmap(5,SpeedButton5.Glyph);
ImageList1.GetBitmap(7,SpeedButton6.Glyph);
ImageList1.GetBitmap(8,SpeedButton7.Glyph);
ImageList1.GetBitmap(6,SpeedButton8.Glyph);
ImageList1.GetBitmap(9,SpeedButton9.Glyph);
ImageList1.GetBitmap(10,SpeedButton10.Glyph);
ImageList1.GetBitmap(11,SpeedButton11.Glyph);
ImageList1.GetBitmap(12,SpeedButton12.Glyph);
ImageList1.GetBitmap(13,SpeedButton13.Glyph);
ImageList1.GetBitmap(14,SpeedButton14.Glyph);
ImageList1.GetBitmap(16,SpeedButton15.Glyph);
ImageList1.GetBitmap(18,SpeedButton16.Glyph);
ImageList1.GetBitmap(20,SpeedButton17.Glyph);
ImageList1.GetBitmap(21,SpeedButton18.Glyph);
ImageList1.GetBitmap(22,SpeedButton19.Glyph);
ImageList1.GetBitmap(26,SpeedButton22.Glyph);
ImageList1.GetBitmap(27,SpeedButton37.Glyph);
ImageList1.GetBitmap(28,SpeedButton38.Glyph);
ImageList1.GetBitmap(29,SpeedButton30.Glyph);
ImageList1.GetBitmap(30,SpeedButton31.Glyph);

PageControl1.ActivePage := TabSheet1;
PageControl2.ActivePage := TabSheet6;
DragAcceptFiles(self.Handle,True);

end;

procedure TForm1.Quitter1Click(Sender: TObject);
begin
Form1.Close;
end;

procedure TForm1.Quitter2Click(Sender: TObject);
begin
Stop1.Click;
end;

procedure TForm1.Execute_commande(List : TListView; var Index : integer; var ActiveOrd : TActiveOrder);
var parametre,tmp : string;
    VarParam : Tparam;
    posNewOrder : integer;
    ListParam : TParam;
    Variant1 : Variant;
    i : integer;
begin
// desactive une commande
if (Index < Low(ActiveOrd)) or (Index > High(ActiveOrd))
then begin
     form1.ShowApplicationError('Indice ActiveOrder hors limite, veuillez contacter l''auteur de l''application.');
     Exit;
     end;
if ActiveOrd[Index] = False
then begin  ActiveOrd[Index]:= True; Inc(Index); Exit; end;

if Index >= List.Items.Count then Exit;
if CheckBox3.Checked = True
then AddToRapport(List.Items[Index].Caption,List.Items[Index].SubItems[0]);
Inc(NbrOrderExecute);
parametre := List.Items.item[Index].SubItems.Strings[0];

case AnsiIndexStr(List.Items.Item[Index].caption,CaseOfExecuteTab) of
   0 : begin //'Goto'
     if FnctIsInteger(parametre)
     then begin
          if Index = StrToInt(parametre)-1
          then ShowApplicationError('Arrêt de l''application - Vous avez généré une boucle illimité.');
          if (StrToInt(parametre) > 0) and (StrToInt(parametre) <= List.Items.Count+1)
          then Index := StrToInt(parametre)-1
          end
     else begin
          Index := FnctGoto(List, parametre);
          Inc(Index);
          end;
     for i := 0 to List.Items.Count-1
     do ActiveOrd[i] := True;
     Exit;
     end;

   1 : begin //'Procedure'
       Index := FnctProcedure(List, Index, parametre, ActiveOrd);
       Exit;
       end;

   2 : begin //'Label'
       Inc(Index);
       Exit;
       end;

   3 : begin //'Examine'
       while (FnctExamine(parametre) = False) and (List.Items.Item[Index+2].caption = 'Examine')
       do begin
          Inc(Index,2);
          parametre := List.Items.item[Index].SubItems.Strings[0];
          end;

       if FnctExamine(parametre) = True  // if
       then begin
            i := Index+2;
            while List.Items[i] <> nil
            do begin
               ActiveOrd[i] := False;
               if List.items[i].caption = 'Examine'
               then begin
                    ActiveOrd[i+1] := False;
                    ActiveOrd[i+2] := False;
                    i := i+2;
                    end
               else break;
               end
            end
       else Inc(Index);
       Inc(Index);
       Exit;    // else
       end;

   4 : begin //'Variable'
       VarParam := MdlFnct.GetParam(parametre);
       // pour permettre de détecter s'il n'y aurait pas un caractère de séparation des paramètres dans la valeur d'initialisation
       tmp := Copy(parametre,length(VarParam.param[1])+2,length(parametre)-length(VarParam.param[1])-length(VarParam.param[VarParam.nbr_param-1])-3);
       WriteVariable('INITVAR',VarParam.param[1],tmp);
       Inc(Index);
       Exit;
       end;

   5 : begin //'ScriptEval'
       ListParam := form1.GetParam(parametre);
       Variant1 := Form25.MSScriptEval(parametre);
       if VarType(Variant1) = varBoolean
       then begin
            if form25.MSScriptEval(parametre) = True  // if
            then begin
                 i := Index+2;
                 while List.Items[i] <> nil
                 do begin
                    ActiveOrd[i] := False;
                    if List.items[i].caption = 'ScriptEval'
                    then begin
                         ActiveOrd[i+1] := False;
                         ActiveOrd[i+2] := False;
                         i := i+2;
                         end
                    else break;
                   end
                 end
       else Inc(Index);
       Inc(Index);
       Exit;
       end
       else Form1.WriteVariable('VAR',ListParam.param[2],Variant1);
       end;

   6 : FnctMoveMouse(parametre);               //'Move Mouse'
   7 : FnctClick(parametre);                   //'Click'
   8 : Form31.FnctFindGraphic(parametre);      //'Trouve image'
   9 : FnctRead(parametre);                    //'Lire'
  10 : FnctWrite(parametre);                   //'Ecrire'
  11 : FnctCalcul(parametre);                  //'Calcul'
  12 : FnctCalculEvol(parametre);              //'Calcul évolué'
  13 : FnctSysVar(parametre);                  //'Fonction'
  14 : ;                                       //'Commentaire'
  15 : FnctField(parametre);                   //'Champs'
  16 : mdlfnct.FnctType(parametre);            //'Type'
  17 : mdlfnct.FnctExecute(parametre);         //'Execute'
  18 : FnctMouvement(parametre);               //'Parcours souris'
  19 : FnctTypeSpl(parametre);                 //'Type Special'
  20 : form16.Fnct_FindObject(List,Index);     //'Objet'
  21 : FnctQuestion(parametre);                //'Question'
  22 : FnctManip(parametre);                   //'Manipulation'
  23 : FnctPause(parametre);                   //'Pause'
  24 : FnctShell(parametre);                   //'Outil Fichier'
  25 : FnctCapture(parametre);                 //'Outil Ecran'
  26 : FnctChangeRes(parametre);               //'Outil Affichage'
  27 : FnctAlimentation(parametre);            //'Outil Alimentation
  28 : FnctRepertoire(parametre);              //'Outil Répertoire'
  31 : FnctQuestion(parametre);                //'Message'
  29 : begin //'Quitter'
       if List = ListView1
       then begin
            change_liste := false;
            ContextOfExecute.ExecutionType := ContextOfExecute.NotRun;
            Form1.Caption := Form1CaptionUpdate;
            Run := False;
            if application_close = False
            then application.MainForm.WindowState := MainFormStatus
            else Exit;
            end;
       end;

  -1 : begin //'Nouvelle commande'
       PosNewOrder := form1.GetNewOrderIndex(List.Items.Item[Index].caption);
       if PosNewOrder <> -1
       then begin FnctExecuteOrder(List.Items.Item[Index].caption, parametre); Inc(Index); Exit; end;
       end;
end;
Inc(Index);
end;

procedure TForm1.Execute1Click(Sender: TObject);
begin
if WaitRedFlag = True
then begin
     WaitRedFlag := False;
     ContextOfExecute.ExecutionType := ContextOfExecute.Run;
     Form1.Caption := Form1CaptionUpdate;
     end
else begin SetLength(mdlfnct.ProcReg,0);  Execute(Sender); end;
end;

procedure TForm1.Execute(Sender: TObject; WithContext : Boolean = False; StartAt : integer =0);
var i : integer;
    FileName, FileExt : String;
begin
if StartAt = 0
then begin
     SetLength(variable, 0);
     SetLength(ListFile.Name, 0);
     SetLength(ListFile.MemFile, 0);
     SetLength(ListFile.Index, 0);
     end;
LoadTabInclude(TabOfIncludeGen,ListView1);
// option control ne pas executer si erreur
if (form19.CheckBox4.Checked = True) and (WithContext = False)
then begin
     if ControlAll(ListView1) = false
     then begin
          if unit1.application_close = False
          then Application.MessageBox(Pchar(Lng_Error_with_edit),'Erreur',MB_OK)
          else begin
               //Application.MessageBox(Pchar(Lng_Error_without_edit),'Erreur',MB_OK);
               Form35.showmodal;
               Form1.Close;
               end;
          PageControl1.ActivePage := TabSheet1;
          Stop1.OnClick(self);
          Exit;
          end;
     end;

Enregistrerunesequence1.Enabled := False;
mdlfnct.LoadMyKeyboard;

TempDepart := FormatDateTime( 'hh:mm:ss',Now);
NbrOrderExecute := 0;
RichEdit1.Clear; // vide le rapport precedent
FileExt := ExtractFileExt(RapportFileName);
for i := 0 to ComboBox1.Items.Count -1
do begin
   FileName := ChangeFileExt(RapportFileName,'') + ComboBox1.Items[i]+ FileExt;
   if FileExists(FileName) = True then DeleteFile(FileName);
   end;
ComboBox1.Clear;
ComboBox1.Items.Add('000001');
ComboBox1.ItemIndex := 0;
RichEdit1.Clear;
RichEdit1.SelAttributes.Color := clGray;
RichEdit1.SelAttributes.Style := Form19.Label14.Font.Style;
RichEdit1.SelAttributes.Size := 8;
if CheckBox3.Checked = True then RichEdit1.Lines.Add('Fichier '+ ChangeFileExt(RapportFileName,'') + '000001'+ FileExt);
ComboBox1.Enabled := False; Label1.Enabled := False;

// changement Resolution suivant les options
ChangeResolution(False);

     Pos_command := StartAt;
     SetLength(ActiveOrder,ListView1.Items.Count);
     for i := 0 to ListView1.Items.Count-1
     do ActiveOrder[i] := True;
     Run := True;
     
     ContextOfExecute.ExecutionType :=  ContextOfExecute.Run;
     form1.Caption := Form1CaptionUpdate;
     // pour reprise exécution
     Execute1.Enabled := false;
     Speedbutton103.Enabled := False;
     Speedbutton105.Enabled := True;
     SpeedButton29.Enabled := True;
     execute1.ShortCut := TextToShortCut('none');
     Reprendrelexcution1.ShortCut := TextToShortCut('F9');

     MainFormStatus := Form1.WindowState;

     if WithContext = True then ContextOfExecute.LoadContext(ContextOfExecute.FileName);
     while ((Pos_command < ListView1.Items.Count) and (Run = True)) do
     begin
     if ListView1.Items[Pos_command] = nil
     then begin
          Form1.ErrorComportement('Processus d''exécution dérouté.',1);
          break;
          end;

     if ListView1.Items.Item[Pos_command].ImageIndex = 19 // redflag
     then Begin
          Oldfenetre := GetForegroundWindow;
          WaitRedFlag := True;
          Select_Unique(ListView1,Pos_Command);
          FnctPause('500;MilliSec;');
          Speedbutton103.Enabled := True;
          ForceForegroundWindow(Application.MainForm.Handle);

          if WaitRedFlag = True then ContextOfExecute.ExecutionType :=  ContextOfExecute.BreakPoint;
          Form1.Caption := Form1CaptionUpdate;
          
          While WaitRedFlag = True do begin  SleepEx(10,False); Application.ProcessMessages; end; // pause 0% cpu
          ContextOfExecute.ExecutionType :=  ContextOfExecute.Run;
          Form1.Caption := Form1CaptionUpdate;

          ForceForegroundWindow(oldfenetre);
          FnctPause('500;MilliSec;');
          end;
     if SpeedButton103.Enabled = True
     then Speedbutton103.Enabled := False;



     Execute_Commande(form1.ListView1, Pos_Command, ActiveOrder);
     if (form19.CheckBox1.Checked = true) then FnctPause(form19.TPGEdit.text +';MilliSec;');
     end;

// sauvegarde du rapport
if Form19.CheckBox5.Checked = True
then begin
     if ComboBox1.Items.Count > 1
     then begin
          RichEdit1.Lines.SaveToFile(ChangeFileExt(RapportFileName,'') + ComboBox1.Items[ComboBox1.Items.Count -1] + FileExt);
          RichEdit1.Clear;
          RichEdit1.SelAttributes.Color := clGray;
          RichEdit1.SelAttributes.Style := Form19.Label14.Font.Style;
          RichEdit1.SelAttributes.Size := 8;
          RichEdit1.Lines.Add('Retrouvez l''ensemble des fichiers rapports dans les fichiers suivants :');
          for i := 0 to ComboBox1.Items.Count -1
          do RichEdit1.Lines.Add(ChangeFileExt(RapportFileName,'') + ComboBox1.Items[i] + FileExt);
          end;
     RichEdit1.Lines.SaveToFile(RapportFileName);
     end;

Stop1.Click;

// pour quitter l'application
if application_close = True then form1.Close;
end;

procedure TForm1.Insertion1Click(Sender: TObject);
begin
Insertion1.Checked := true;
Edition2.Checked := false;
end;

procedure TForm1.Edition2Click(Sender: TObject);
begin
Insertion1.Checked := false;
Edition2.Checked := true;
end;

procedure TForm1.SpeedButton6Click(Sender: TObject);
begin
form3.Caption := 'Label';
if Form3.visible then Form3.Close;
form3.show;
end;

procedure TForm1.SpeedButton7Click(Sender: TObject);
begin
List_Label(Form3.ComboBox1);
Form3.Caption := 'Goto';
if Form3.visible then Form3.Close; // Pour éviter que la fenêtre Label soit dejà ouverte.
Form3.show;
end;

procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
if Key = VK_ESCAPE then Run := false;
end;

procedure TForm1.SpeedButton9Click(Sender: TObject);
begin
Form8.show;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
var i : integer;
    ARect : TRect;
    var ConfigIni: TIniFile;
begin
Can_Save := False;

ConfigIni := TIniFile.Create(GetFileIniName);
try

// Sauvegarde de la position de toutes les fenêtres
if (Application.ShowMainForm = True)
then begin
          for i := 1 to 38 do
          begin
          if (Application.FindComponent('Form'+ InttoStr(i)) as TForm) = nil then continue;
          if (Application.FindComponent('Form'+ InttoStr(i)) as TForm).WindowState = wsNormal
          then begin
               Arect.Top    := (Application.FindComponent('Form'+ InttoStr(i)) as TForm).Top;
               Arect.Left   := (Application.FindComponent('Form'+ InttoStr(i)) as TForm).Left;
               Arect.Right  := (Application.FindComponent('Form'+ InttoStr(i)) as TForm).Width;
               Arect.Bottom := (Application.FindComponent('Form'+ InttoStr(i)) as TForm).Height;
               ConfigIni.WriteString('Form', 'Top'+IntToStr(i) , IntToStr(ARect.Top));
               ConfigIni.WriteString('Form', 'Left'+IntToStr(i) , IntToStr(ARect.Left));
               ConfigIni.WriteString('Form', 'Width'+IntToStr(i) , IntToStr(ARect.Right));
               ConfigIni.WriteString('Form', 'Height'+IntToStr(i) , IntToStr(ARect.Bottom));
               end;
          end;
      end;

// detail des commandes
if Form1.Dtailcommandes1.Checked = True
then ConfigIni.WriteString('Detail', 'afficher','True')
else ConfigIni.WriteString('Detail', 'afficher','False');

finally ConfigIni.UpdateFile; ConfigIni.Free; DragAcceptFiles(self.Handle,False); end;
end;

procedure TForm1.SpeedButton10Click(Sender: TObject);
begin
Form9.Caption := 'Question';
Form9.Label3.Visible := True;
Form9.ComboBox1.Visible := True;
Form9.show;
Form9.ComboBox2.Text := 'Question';
Form9.ComboBox3.SetFocus;
end;


procedure TForm1.SpeedButton11Click(Sender: TObject);
begin
form11.show;
end;

procedure TForm1.ListView1DblClick(Sender: TObject);
begin
if ListView1.Selected <> nil then Editer1.Enabled := True;
Editer1.Click();
end;

procedure TForm1.Paspas1Click(Sender: TObject);
var i : integer;
begin
if ContextOfExecute.ExecutionType = ContextOfExecute.StepByStepAndRun then Exit;
if ListView1.Items.Count <> 0
then begin
     if Run = false
     then begin
          Pos_command := 0;
          Run := True;
          KeyPreview := true;
          ContextOfExecute.ExecutionType :=  ContextOfExecute.StepByStep;
          form1.Caption := Form1CaptionUpdate;
          SetLength(ActiveOrder,ListView1.Items.Count);
          for i := 0 to ListView1.Items.Count-1
          do ActiveOrder[i] := True;
          SpeedButton105.Enabled := True;
          end;

          Select_unique(ListView1, Pos_command);
          if ListView1.Items.Item[Pos_command].caption <> 'Pause'
          then begin
               ContextOfExecute.ExecutionType :=  ContextOfExecute.StepByStepAndRun;
               form1.Caption := Form1CaptionUpdate;
               ForceForegroundWindow(OldFenetre);
               Execute_Commande(ListView1, Pos_Command, ActiveOrder);
               FnctPause('500;MilliSec;');
               if GetForegroundWindow <> form1.handle then Oldfenetre := GetForegroundWindow;
               ForceForegroundWindow(form1.handle);
               ContextOfExecute.ExecutionType :=  ContextOfExecute.StepByStep;
               form1.Caption := Form1CaptionUpdate;
               end
          else begin
               Inc(Pos_command);
               end;

          if Pos_command >= ListView1.Items.Count
          then Stop1.Click;
     end;
end;

procedure TForm1.Couper2Click(Sender: TObject);
var tampon_macro : File of TOrdre;
    Ordre : TOrdre;
    i : integer;
    tmp : String;
    Multi : Boolean;
begin
if ListView1.Focused = True
then begin
     if ListView1.Selected = nil then Exit;
     // place dans le clipboard les commandes couper
     SetClipboardHasText(''); tmp := '';
     for i := 0 to ListView1.Items.Count -1
     do begin
        if ListView1.Items.Item[i].Selected = True
        then begin
             tmp := ListView1.Items[i].Caption + Chr(VK_Tab) + ListView1.Items[i].SubItems.Text;
             if i < ListView1.Items.Count -1 then tmp := tmp + #0;
             ClipBoard.AsText := ClipBoard.AsText +tmp;
             end;
        end;

     assignfile(tampon_macro,ExtractFileDir(Application.ExeName)+'\clipboard.tmp');
     rewrite(tampon_macro);
     if ListView1.SelCount > 1 then Multi := True else Multi := False;
     if Multi = True then AddHistory(0,'Début d''actions groupées','','');
     for i := 0 to ListView1.Items.Count -1
     do begin
        if ListView1.Items.Item[i].Selected = True
        then begin
             Ordre.commande := ListView1.Items[i].Caption;
             Ordre.textparam:= ListView1.Items.Item[i].SubItems.Strings[0];
             write(tampon_macro,Ordre);
             end;
        end;
     closefile(tampon_macro);
     Supprimer1.click;
     if Multi = True then AddHistory(0,'Fin d''actions groupées','','');
     end
else if ObjectPopMenu <> nil then SendMessage(ObjectPopMenu.handle,WM_CUT,0,0);
end;

procedure TForm1.Copier2Click(Sender: TObject);
var tampon_macro : File of TOrdre;
    Ordre : TOrdre;
    i : integer;
    tmp : string;
begin
if ListView1.Focused = True
then begin
     if ListView1.Selected = nil then Exit;
     ClipBoard.Open;
     try
     ClipBoard.Clear; tmp := '';
     for i := 0 to ListView1.Items.Count -1
     do begin
        if ListView1.Items.Item[i].Selected = True
        then begin
             tmp := ListView1.Items[i].Caption + Chr(VK_Tab) + ListView1.Items[i].SubItems.Text;
             if i < ListView1.Items.Count -1 then tmp := tmp + #0;
             ClipBoard.AsText := ClipBoard.AsText +tmp;
             end;
        end;
        finally ClipBoard.Close; end;

     assignfile(tampon_macro,ExtractFileDir(Application.ExeName)+'\clipboard.tmp');
     rewrite(tampon_macro);
     for i := 0 to ListView1.Items.Count -1
     do begin
        if ListView1.Items.Item[i].Selected = True
        then begin
             Ordre.commande := ListView1.Items[i].Caption;
             Ordre.textparam:= ListView1.Items.Item[i].SubItems.Strings[0];
             write(tampon_macro,Ordre);
             end;
        end;
     CloseFile(tampon_macro);
     end
else if ObjectPopMenu <> nil then SendMessage(ObjectPopMenu.handle,WM_COPY,0,0);
end;

procedure TForm1.Coller2Click(Sender: TObject);
var tampon_macro : File of TOrdre;
    Ordre : TOrdre;
    Multi : Boolean;
begin
if ListView1.Focused = True
then begin
assignfile(tampon_macro,ExtractFileDir(Application.ExeName)+'\clipboard.tmp');
if fileexists(ExtractFileDir(Application.ExeName)+'\clipboard.tmp')
then begin
     ListView1.Items.BeginUpdate;
     ListView4.Items.BeginUpdate;

     reset(tampon_macro);
     read(tampon_macro,Ordre);
     if eof(tampon_macro) = True then Multi := False else Multi := True;
     closefile(tampon_macro);
     if Multi = True then AddHistory(0,'Début d''actions groupées','','');
     reset(tampon_macro);
     while not eof(tampon_macro)
     do begin
        Read(tampon_macro,Ordre);
        Add_Insert(Ordre.commande,Ordre.textparam,GetImageindex(Ordre));
        end;
     CloseFile(tampon_macro);
     if Multi = True then AddHistory(0,'Fin d''actions groupées','','');
     ListView1.Items.EndUpdate;
     ListView4.Items.EndUpdate;
     end;
end
else if ObjectPopMenu <> nil then SendMessage(ObjectPopMenu.handle,WM_PASTE,0,0);
end;

procedure TForm1.Couleurbulletslectionn1Click(Sender: TObject);
var i : integer;
begin
i := ((PaintBox1MouseY) div 17) + ListView1.TopItem.Index-1;
if (i < Low(TabInfoListView)) or (i > High(TabInfoListView))
then Exit;
if ColorDialog1.Execute
then begin
     TabInfoListView[i].BulletColor := ColorDialog1.Color;
     ListView1.Repaint;
     end;
end;

procedure TForm1.Couper1Click(Sender: TObject);
begin
Couper2.OnClick(Self);
end;

procedure TForm1.Copier1Click(Sender: TObject);
begin
Copier2.OnClick(Self);
end;

procedure TForm1.Coller1Click(Sender: TObject);
begin
Coller2.OnClick(Self);
end;

procedure TForm1.Supprimer2Click(Sender: TObject);
begin
if ListView1.Focused = True
then Supprimer1.OnClick(Self)
else if ObjectPopMenu <> nil then SendMessage(ObjectPopMenu.handle,WM_PASTE,0,0);
end;

procedure TForm1.SpeedButton12Click(Sender: TObject);
begin
form12.show;
end;

procedure TForm1.SpeedButton13Click(Sender: TObject);
begin
form13.show;
end;

procedure TForm1.ListView1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var ListParam : Tparam;
    HintSelected : TListItem;
    file_macro : File of TOrdre;
    Ordre : TOrdre;
    cpt : integer;
begin
ListView1.Hint := '';
ListView1.ShowHint := False;
HintSelected := ListView1.GetItemAt(X,Y);
if HintSelected = nil then Exit;

if ((ExecutionType = StepByStep) or (ExecutionType = BreakPoint))
then begin
     ListParam := GetParam(HintSelected.SubItems.Strings[0]);

     if HintSelected.Caption = 'Variable'
     then begin
          ListView1.Hint := ListParam.Param[1] + ' = ' + GetValue(ListParam.param[1]);
          if ListParam.Param[1] = '[PASSWORD]' then ListView1.Hint := 'Valeur inaccessible';
          ListView1.ShowHint := True;
          Application.OnShowHint := DoShowHint;
          end;

     if HintSelected.Caption = 'Examine'
     then begin
           if FnctExamine(HintSelected.SubItems.Strings[0]) = True
           then ListView1.Hint := 'Vrai'
           else ListView1.Hint := 'Faux';

           ListView1.ShowHint := True;
           Application.OnShowHint := DoShowHint;
           end;
      end;

if (ExecutionType = ContextOfExecute.NotRun) and (HintSelected.Caption = 'Execute') and
   (ExtractFileExt(HintSelected.SubItems[0]) = '.mcr')
then begin
     if not fileExists(HintSelected.SubItems[0]) then exit;
     if Form32.IsCrypted(HintSelected.SubItems[0]) = True
     then begin
          ListView1.Hint := 'Attention : Cette macro est protégée par un mot de passe.';
          ListView1.ShowHint := True;
          Exit;
          end
     else begin
          cpt := 0;
          assignfile(file_macro,HintSelected.SubItems[0]);
          FileMode := 0;
          reset(file_macro);
          try
          while not eof(file_macro)
          do begin
             read(file_macro,Ordre);
             if Ordre.commande = 'Évaluer' then continue;
             if Ordre.commande = 'Info' then continue;
             if Ordre.commande = '[VISUALVAR]' then continue;
             if Ordre.commande = '[VISUALVAR_PROP]' then continue;
             if form32.decrypte(Ordre.commande) = 'Info' then continue;
             Inc(cpt);
             ListView1.Hint := ListView1.Hint + Ordre.commande + ' ' + Ordre.textparam + #13#10;
             if cpt > 30 then begin ListView1.Hint := ListView1.Hint + '...'; break; end;
             end;
          ListView1.ShowHint := True;
          Application.OnShowHint := DoShowHint;
          finally CloseFile(file_macro); FileMode := 2; end;
          end;
     end;
end;

procedure TForm1.SpeedButton14Click(Sender: TObject);
begin
form1.add_insert('Quitter','',14);
end;

procedure TForm1.Insereruncommentaire1Click(Sender: TObject);
begin
form14.Show;
end;

procedure TForm1.Stop1Click(Sender: TObject);
var i : integer;
begin
Run := False;
Unit10.valider := True;

ContextOfExecute.ExecutionType :=  ContextOfExecute.NotRun;
form1.Caption := Form1CaptionUpdate;

// Test le maintien de pression de touche Shift, Crt, Alt
if (GetKeyState(VK_LSHIFT) and $01) <> 0
then KeyBD_event(VK_LSHIFT, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
if (GetKeyState(VK_RSHIFT) and $01) <> 0
then KeyBD_event(VK_RSHIFT, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
if (GetKeyState(VK_CONTROL) and $01) <> 0
then KeyBD_event(VK_CONTROL, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
if (GetKeyState(VK_MENU) and $01) <> 0
then KeyBD_event(VK_MENU, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);


WaitRedFlag := False;
TempFin := FormatDateTime('hh:mm:ss',Now);
Pos_command := 0;
KeyPreview := False;
ComboBox1.Enabled := True; Label1.Enabled := True;
if Form29.Visible = True then Form29.Close;

// Arret des Hook;
WriteVariable('VAR','[EVENT.ACTIVATE]','0');

// Dechargement des images stockées pour la commande findImage
for i := 10 to length(unit31.MemImage)-1
do begin
   unit31.MemImage[i].Filename := '';
   unit31.MemImage[i].Image.Free;
   end;
SetLength(unit31.MemImage,0);

// Envois la commande Stop a toutes les nouvelles commandes
for i := 0 to Length(DynOrder)-1
do if DynOrder[i].Name <> '' then DynOrder[i].StopOrder;

// fermeture de fichier unit1.FichierOuvert[index]
try
for i := 0 to length(ListFile.memFile)-1
do if ListFile.Index[i] > 0 then try CloseFile(ListFile.memFile[i]); except end;
SetLength(ListFile.Name,0);
SetLength(ListFile.MemFile,0);
SetLength(ListFile.Index,0);
except on EInOutError do end;

// réactive les boutons
execute1.Enabled := True;
Speedbutton103.Enabled := True;
Speedbutton105.Enabled := False;
SpeedButton29.Enabled := False;
Enregistrerunesequence1.Enabled := True;

// réactive les touches de raccourcie
execute1.ShortCut := TextToShortCut('F9');
Reprendrelexcution1.ShortCut := TextToShortCut('none');

// restauration de la résolution
ChangeResolution(True);
// restauration des inclusions
RestoreTabInclude(TabOfIncludeGen,ListView1);
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
{
Supprimer1.ShortCut := TextToShortCut('Suppr');
Copier2.ShortCut := TextToShortCut('Ctrl+C');
Couper2.ShortCut := TextToShortCut('Ctrl+X');
Coller2.ShortCut := TextToShortCut('Ctrl+V');
Dfaire1.ShortCut := TextToShortCut('Ctrl+Z');
Refaire1.ShortCut := TextToShortCut('Maj+Ctrl+Z');
N2.ShortCut := TextToShortCut('Ctrl+A');
}
//Form1.Menu := MainMenu1;
StatusBar1.Repaint;
end;

procedure TForm1.FormDeactivate(Sender: TObject);
begin
//Form1.Menu := nil;
{
Supprimer1.ShortCut := TextToShortCut('none');
Copier2.ShortCut := TextToShortCut('none');
Couper2.ShortCut := TextToShortCut('none');
Coller2.ShortCut := TextToShortCut('none');
Dfaire1.ShortCut := TextToShortCut('none');
Refaire1.ShortCut := TextToShortCut('none');
N2.ShortCut := TextToShortCut('none');
}
end;

procedure TForm1.SpeedButton15Click(Sender: TObject);
begin
form15.show;
end;

procedure TForm1.Spy1Click(Sender: TObject);
begin
Form16.CheckListBox1.Clear;
Form16.TreeView1.Items.Clear;
Form16.show;
Form16.PageControl1.ActivePage := Form16.TabSheet1;
end;

procedure TForm1.RechercherObjet1Click(Sender: TObject);
begin
Form17.StatusBar1.SimpleText := '';
unit17.find_objet_text := '';
find_objet_parent := '';
Form17.Edit1.Visible := True;
Form17.SpeedButton1.Visible := True;
Form17.Label1.Caption := 'Classe recherchée';
Form17.Memo1.Clear;
Form17.show;
//application_close := False;
end;

procedure TForm1.SpeedButton16Click(Sender: TObject);
begin
Form18.show;
end;

procedure TForm1.Monterdunniveau1Click(Sender: TObject);
var pos : integer;
begin
if ((ListView1.Selected <> nil) and (ListView1.SelCount = 1) and
    (ListView1.Selected.Index <> 0))
then begin
     pos :=  ListView1.Selected.Index -1;
     if pos < 0 then pos := 0;

     AddHistory(ListView1.Selected.index+1,'Monter d''un niveau',ListView1.Selected.Caption,IntToStr(pos+1));
     Movecommande(ListView1,ListView1.Selected.Index,pos);
     Select_Unique(ListView1, pos);
     end;
end;

procedure TForm1.Descendredunniveau1Click(Sender: TObject);
var pos : integer;
begin
if ((ListView1.Selected <> nil) and (ListView1.SelCount = 1) and
    (ListView1.Selected.Index <> ListView1.items.Count - 1 ))
then begin
     pos := ListView1.Selected.Index +1;
     if pos > ListView1.Items.Count -1 then pos := ListView1.Items.Count - 1;
     AddHistory(ListView1.Selected.index+1,'Descendre d''un niveau',ListView1.Selected.Caption,IntToStr(pos+1));
     Movecommande(ListView1,ListView1.Selected.Index,pos);
     select_Unique(ListView1, pos);
     end;
end;

procedure TForm1.Options1Click(Sender: TObject);
begin
Form19.show;
// pour le bouton d'enregistrement des options pour une macro
if StatusBar1.Panels[0].Text <> Lng_NewMacro
then form19.button6.Enabled := True
else form19.button6.Enabled := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var i : integer;
   FileName : string;
begin
// supression du fichier temporaire d'enregistrement de sequence
FileName := ExtractFileDir(Application.ExeName) + '\temp.sqc';
if FileExists(FileName) then deleteFile(FileName);

// suppression de l'icone dans le systray si elle existe
if (@NotifyStruc <> NIL)
then Shell_NotifyIcon(NIM_DELETE,@NotifyStruc);

Run := false;
BackGround.Free;
Description.Free;

// liberation des dlls
for i := 0 to Length(DynOrder)-1
do if DynOrder[i].Name <> ''
   then FreeLibrary(DynOrder[i].Handle);

// décharge l'icone mis en exécution
ICONRUN.Free;

// déchargement de la surveillance du debugage
// a appelé en dernier
CleanUpMapFile;

end;

procedure TForm1.Pointdarrt1Click(Sender: TObject);
var MyOrdre : TOrdre;
    i : integer;
begin
If ListView1.Selected = nil then Exit;
for i := 0 to ListView1.Items.Count-1
do if ListView1.Items[i].Selected = True
   then if ListView1.Items[i].Imageindex <> 19
        then ListView1.Items[i].ImageIndex := 19
        else Begin
             MyOrdre.commande := ListView1.Items[i].Caption;
             ListView1.Items[i].ImageIndex := GetImageIndex(MyOrdre);
             end;
end;

procedure TForm1.Executer1Click(Sender: TObject);
begin

if ListView1.Selected <> nil then Pointdarrt1.Enabled := True else Pointdarrt1.Enabled := False;
Pointdarrt1.Caption := Lng_Point_darret;

If ListView1.Selected = nil then Exit;

if ListView1.Selected.ImageIndex = 19
then Pointdarrt1.Caption := Lng_Delete_Point_darret
else Pointdarrt1.Caption := Lng_Point_darret;

if WaitRedFlag = True then Reprendrelexcution1.Enabled := True else Reprendrelexcution1.Enabled := False;
if ContextOfExecute.ExecutionType <>  ContextOfExecute.NotRun
then begin
     Sauvegardeducontextedexcution1.Caption := Lng_MenuContextExeSave;
     Sauvegardeducontextedexcution1.ImageIndex := 37;
     if StatusBar1.Panels[0].Text = Lng_NewMacro
     then Sauvegardeducontextedexcution1.Enabled := False
     else Sauvegardeducontextedexcution1.Enabled := True;
     end
else begin
     Sauvegardeducontextedexcution1.Enabled := True;
     Sauvegardeducontextedexcution1.Caption := Lng_MenuContextExeDownload;
     Sauvegardeducontextedexcution1.ImageIndex := 39;
     end;
end;

procedure TForm1.Reprendrelexcution1Click(Sender: TObject);
begin
if WaitRedFlag = True
then begin
     WaitRedFlag := False;
     ContextOfExecute.ExecutionType := ContextOfExecute.Run;
     Form1.Caption := Form1CaptionUpdate;
     end
else MessageDlg('Aucune macro n''est en attente de reprise d''exécution.',mtWarning,[mbok],0);
end;

procedure TForm1.Consulter1Click(Sender: TObject);
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
     if HtmlHelp(0, PChar(HelpDir+'\aide.chm'), HH_DISPLAY_TOPIC,0) = 0
     then ShowMessage('Erreur: Vérifiez la présence du fichier .chm dans le dossier de Super macro.');
     end;
end;

procedure TForm1.Edition1Click(Sender: TObject);
begin
{if ListView1.Selected <> nil
then begin Supprimer1.Enabled := True;  couper2.Enabled := True; Copier2.Enabled := True; Editer1.Enabled := True; end
else begin Supprimer1.Enabled := False; couper2.Enabled := False; Copier2.Enabled := False; Editer1.Enabled := False end;
}

if (Clipboard.HasFormat(CF_TEXT)) and (Clipboard.asText <> '')
then Collerapartirduntextesimple1.Enabled := True
else Collerapartirduntextesimple1.Enabled := False;

Dfaire1.Enabled := SpeedButton25.Enabled;
Refaire1.Enabled := SpeedButton23.Enabled;
Modificattion1.enabled := not TabSheet5.TabVisible;

if FileExists(ExtractFileDir(Application.ExeName)+'\clipboard.tmp')
then Coller2.Enabled := True
else Coller2.Enabled := False;

end;

procedure TForm1.PopupMenu1Popup(Sender: TObject);
var i : integer;
begin
if ListView1.Selected <> nil
then begin
     Supprimer2.Enabled := True;
     couper1.Enabled := True;
     Copier1.Enabled := True;
     Monterdunniveau1.Enabled := True;
     Descendredunniveau1.Enabled := True;
     if ListView1.Selected.Caption = 'Commentaire'
     then MiseenForme1.Visible := True else MiseenForme1.Visible := False;
     if (ListView1.Selected.Caption = 'Procedure') and (Copy(ListView1.Selected.SubItems[0],0,4) = 'CALL')
     then Rechercherladclaration1.Visible := True else Rechercherladclaration1.Visible := False;
     end
else begin
     Supprimer2.Enabled := False;
     couper1.Enabled := False;
     Copier1.Enabled := False;
     Monterdunniveau1.Enabled := False;
     Descendredunniveau1.Enabled := False;
     MiseenForme1.Visible := False;
     Rechercherladclaration1.Visible := False;
     end;

if FileExists(ExtractFileDir(Application.ExeName)+'\clipboard.tmp')
then Coller1.Enabled := True
else Coller1.Enabled := False;

valuer1.Visible := False;
for i := 0 to ListView1.Items.Count -1
do if (ListView1.Items.Item[i].Selected = True) and (ListView1.Items.Item[i].Caption = 'Variable')
   then begin valuer1.Visible := True; break; end;

end;

procedure TForm1.Apropos1Click(Sender: TObject);
begin
form23.show;
end;

procedure TForm1.Dtailcommandes1Click(Sender: TObject);
begin
//Form24.show;
if Dtailcommandes1.Checked = False
then begin
     Panel3.Visible := True;
     Splitter2.Visible := True;
     Dtailcommandes1.Checked := True;
     TabSheet3.TabVisible := True;
     end
else begin
     Splitter2.Visible := False;
     Panel3.Visible := False;
     Dtailcommandes1.Checked := False;
     TabSheet3.TabVisible := False;
end;
end;

procedure TForm1.SpeedButton17Click(Sender: TObject);
begin
form27.show;
end;

procedure TForm1.Enregistrerunesequence1Click(Sender: TObject);
begin
if Application.FindComponent('Form28') = nil
then Application.CreateForm(TForm28, Form28);
if unit28.AllIsOk = True
then Form28.show;
end;

procedure TForm1.ListView2DblClick(Sender: TObject);
var Pos_Commande : integer;
begin
if listView2.Selected <> nil
then begin
     Pos_commande := Trunc(form1.StrToFloat(ListView2.Selected.caption)) -1 ;
     form1.Select_unique(ListView1,Pos_Commande);
     if ListView1.Visible then ListView1.SetFocus;
     end;
end;

procedure TForm1.ListView2ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
SortIndex := Column.Index;
ListView2.CustomSort(@CustomSortProc, 0);
if SortAssending = True
then SortAssending := False
else SortAssending := True;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
PageControl1.ActivePage := TabSheet1;
end;

procedure TForm1.Rafr1Click(Sender: TObject);
begin
If PageControl1.ActivePage = TabSheet1 then ControlAll(ListView1);
end;

procedure TForm1.PageControl1Change(Sender: TObject);
const Msg1 = 'Vous n''avez pas exécuté de macro.';
      Msg2 = 'Pour obtenir un rapport d''exécution vous devez activer l''option dans les options de contrôle avant l''exécution, ou cocher la case "Activer le rapport" ci-dessus.';
begin
Form1.ActiveControl := nil;
RichEdit1.HideSelection := True;
If (PageControl1.ActivePage = TabSheet1) and (ExecutionType = 0)
then begin
     Rafr1.Enabled := True;
     Slctionnertout2.Enabled := False;
     Copier4.Enabled := False;

     Form1.HelpContext := HelpControl;
     ControlAll(ListView1);
     ListView2.ClearSelection;
     end;

if PageControl1.ActivePage = TabSheet2
then begin
     RichEdit1.HideSelection := False;
     Form1.HelpContext := HelpRapport;
     Rafr1.Enabled := False;
     Slctionnertout2.Enabled := True;
     Copier4.Enabled := True;
     if Form19.CheckBox5.checked = True
     then begin
          if (RichEdit1.Text = '') or (RichEdit1.Text =  Msg2) then RichEdit1.Text := Msg1 ;
          end
     else begin
          if (RichEdit1.Text = '') or (RichEdit1.Text =  Msg1) then RichEdit1.Text := Msg2;
          end;
     end;


end;

procedure TForm1.PaintBox1DblClick(Sender: TObject);
var i : integer;
begin
if ListView1.TopItem = nil then Exit;
i := ((PaintBox1MouseY) div 17) + ListView1.TopItem.Index-1;
if i > length(TabInfoListView)-1 then exit;

if (TabInfoListView[i].SignetNr > -1) and (PaintBox1MouseX >= 14) and (PaintBox1MouseX <= 24)
then begin
     TabInfoListView[i].SignetNr := -1;
     end
else begin
     if TabInfoListView[i].Bullet = False
     then begin
          TabInfoListView[i].Bullet := True;
          TabInfoListView[i].BulletColor := BulletColor;
          end
     else TabInfoListView[i].Bullet := False;
end;

InfoListViewDraw;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

PaintBox1MouseX := X;
PaintBox1MouseY := Y;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
InfoListViewDraw;
end;

procedure TForm1.Enregister1Click(Sender: TObject);
var i : integer;
    fichier : Textfile;
    chaine : string;
    Fic : TextFile;
begin
if PageControl1.ActivePage = TabSheet1
then begin
     if SaveDialog2.Execute
     then begin
          assignfile(fichier,SaveDialog2.FileName);
          rewrite(fichier);
          for i := 0 to ListView2.Items.Count -1 do
          begin
               chaine := ListView2.Items[i].caption + ' ' +
                         ListView2.Items.Item[i].SubItems.Strings[0] + ' ' +
                         ListView2.Items.Item[i].SubItems.Strings[1];
               writeln(fichier,chaine);
               end;
     closefile(fichier);
     end;
     end;

if PageControl1.ActivePage = TabSheet2
then begin
     if Savedialog2.Execute
     then begin
          RichEdit1.Lines.SaveToFile(SaveDialog2.FileName);
          end;
     end;

if PageControl1.ActivePage = TabSheet3
then begin
     if TreeView1.Selected = nil then Exit;
     AssignFile(Fic,ExtractFileDir(Application.ExeName) + '\'+ form19.ComboBox3.Text + '.lng');
     Append(Fic);
     writeln(fic,';;'+ TreeView1.selected.text + ';;');
     for i := 0 to RichEdit2.Lines.Count - 1
     do writeln(fic,RichEdit2.Lines[i]);
     closeFile(fic);
     end;
end;

procedure TForm1.Rechercher1Click(Sender: TObject);
begin
  FindDialog1.Position := Point(Form1.Left + (form1.Width div 2), Form1.Top + (Form1.Height div 2));
  FindDialog1.Execute;
end;

procedure TForm1.Rechercher3Click(Sender: TObject);
type THHFtsQuery = packed record          //tagHH_FTS_QUERY, HH_FTS_QUERY
    cbStruct:          integer;      // Sizeof structure in bytes.
    fUniCodeStrings:   BOOL;         // TRUE if all strings are unicode.
    pszSearchQuery:    PChar;        // String containing the search query.
    iProximity:        LongInt;      // Word proximity.
    fStemmedSearch:    Bool;         // TRUE for StemmedSearch only.
    fTitleOnly:        Bool;         // TRUE for Title search only.
    fExecute:          Bool;         // TRUE to initiate the search.
    pszWindow:         PChar;
     end;

var HelpDir : String;
    WinCtrl : TWinControl;
    q: THHFtsQuery;
begin
if ActiveControl = nil then Exit;
if ActiveControl.HelpContext = 0
then WinCtrl := ActiveControl.Parent
else WinCtrl := ActiveControl;

with q do
  begin
    cbStruct := sizeof(q); //Taille de la requête
    fUniCodeStrings := false; //mettre à true si toute la chaîne recherchée est de type Unicode
    pszSearchQuery := nil; //chaîne recherchée
    iProximity := -1; //HH_FTS_DEFAULT_PROXIMITY; //Recherche en respectant les mots similaires
    fStemmedSearch := false; //mettre à true pour rechercher dans les résultats précédents
    fTitleOnly := false; //mettre à true si la recherche se fait uniquement sur les titres de rubriques
    fExecute := true; //mettre à true pour exécuter la requête
    pszWindow := nil; //type de fenêtre à afficher, ici c'est celle par défaut
  end;

if WinCtrl.HelpContext <>0
then begin
     HelpDir := ExtractFileDir(Application.ExeName);
     if HtmlHelp(0, PChar(HelpDir+'\aide.chm'), HH_DISPLAY_SEARCH,DWORD(@q)) = 0
     then ShowMessage('Erreur: Vérifiez la présence du fichier .chm dans le dossier de Super macro.');
     end;
end;

procedure TForm1.FindDialog1Find(Sender: TObject);
var
  FoundAt: LongInt;
  StartPos, ToEnd: integer;
  Option : TSearchTypes;
begin
  with RichEdit1 do
  begin
    { commence la recherche après la sélection en cours s'il y en a une }
    { sinon, commence au début du texte }

    if SelLength <> 0 then
      StartPos := SelStart + SelLength
    else
      StartPos := 0;

    { ToEnd indique la longueur entre StartPos et la fin du texte du contrôle }

    ToEnd := Length(Text) - StartPos;
    Option := [];
    if frMatchCase in FindDialog1.Options then Option := Option + [stMatchCase];
    if frWholeWord in FindDialog1.Options then Option := Option + [stWholeWord];

    FoundAt := FindText(FindDialog1.FindText, StartPos, ToEnd, Option);
    if FoundAt <> -1 then
    begin
      SetFocus;
      SelStart := FoundAt;
      SelLength := Length(FindDialog1.FindText);
    end;
  end;
end;

procedure TForm1.PopupMenu2Popup(Sender: TObject);
begin
if PageControl1.ActivePage = TabSheet1
then begin
     Enregister1.Caption := 'Enregistrer la liste des contrôles';
     Restituerlesavertissementsignors1.Visible := True;
     if length(TabIgnoreMsg) = 0
     then Restituerlesavertissementsignors1.Enabled := False
     else Restituerlesavertissementsignors1.Enabled := True;
     end
else Restituerlesavertissementsignors1.Visible := False;

if PageControl1.ActivePage = TabSheet2
then begin
     Rechercher1.Enabled := True;
     Enregister1.Caption := 'Enregistrer la page de rapport d''exécution';
     end
else Rechercher1.Enabled := False;


if ListView2.Selected <> nil
then begin
     if ListView2.Selected.ImageIndex = 1
     then Ignorercetteavertissement1.Visible := True
     else Ignorercetteavertissement1.Visible := False;
     end
else Ignorercetteavertissement1.Visible := False;

end;

procedure TForm1.Imprimer2Click(Sender: TObject);
var i, x , y : integer;
    write_commande : String;
    page_number, old_page_number : integer;
begin
if PageControl1.ActivePage = TabSheet1
then begin
     x := 50 ; y := 0;
     Printer.Title := 'Super Macro Control';
     old_page_number := 0;
     with Printer
     do begin
        BeginDoc;
        for i:= 0 to ListView2.Items.Count-1
        do begin
           page_number := printer.PageNumber;
           if page_number <> old_page_number
           then begin
                old_page_number := page_number;
                Canvas.TextOut(x,y,'Macro : ' + Statusbar1.Panels[0].Text + ' Page : ' + IntToStr(printer.PageNumber) + ' Date : ' + DateToStr(now) + ' Heure : ' + TimeToStr(now) );
                Inc(y, 50);
                end;
           write_commande := ListView2.Items[i].caption + ' ' +
           ListView2.Items.Item[i].SubItems.Strings[0] + ' ' +
           ListView2.Items.Item[i].SubItems.Strings[1];
           Canvas.TextOut(x,y,write_commande);
           Inc(y, 50);
           if y > 3250
           then begin
                y := 0;
                printer.NewPage;
                end;
           end;
      EndDoc;
      end;
end;
if PageControl1.ActivePage = TabSheet2
then RichEdit1.Print('Super macro rapport d''exécution');

end;

procedure TForm1.ListView1AdvancedCustomDrawItem(Sender: TCustomListView; Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage; var DefaultDraw: Boolean);
var i,ColorExamine : TColor;
//    ColorProcedure : TColor;
r : Trect;
begin
if item = nil then exit;

InfoListViewDraw;

if (Stage = cdPrePaint)
then begin
     for i := 0 to length(ListColorOrder)-1
     do if ListColorOrder[i].Name = Item.Caption then begin ListView1.Canvas.Brush.Color := ListColorOrder[i].Color; break; end;

     //ColorProcedure := $00DBB7B7;
     //if ColorForProcedure(ListView1,Item.Index,ColorProcedure) = True
     //then begin ListView1.Canvas.Brush.Color := ColorProcedure; ListView1.Canvas.Font.Style := [];  end;

     if Item.Caption = 'Commentaire'
     then begin
               r:= item.DisplayRect(drbounds);
               Sender.canvas.FillRect(r);
               Sender.Canvas.Font.Style := [fsBold];
               Sender.Canvas.textout(r.Left +Sender.Column[0].Width, r.top,item.SubItems[0]);
               if not(cdsSelected in State)
               then DefaultDraw := False;
          end;

     ColorExamine := ClWhite;
     for i := 0 to length(ListColorOrder)-1
     do if ListColorOrder[i].Name = 'Examine' then begin colorExamine := ListColorOrder[i].Color; break; end;

     if ListView1.Items.Item[Item.index-1] <> nil
     then if ListView1.Items[Item.index-1].Caption = 'Examine'
          then ListView1.Canvas.Brush.Color := ColorExamine;

     if ListView1.Items[Item.Index-2] <> nil
     then if ListView1.Items[Item.index-2].Caption = 'Examine'
          then ListView1.Canvas.Brush.Color := ColorExamine;
     end;

ListView1.Canvas.Font.Style := [];
end;

procedure TForm1.SpeedButton18Click(Sender: TObject);
begin
Form30.show;
end;

procedure TForm1.ListView1Click(Sender: TObject);
var i : integer;
begin
Form1.HelpContext := HelpGeneral;
if ListView1.Selected <> nil
then begin
     SpeedButton106.Enabled := True;
     SpeedButton107.Enabled := True;
     SpeedButton109.Enabled := True;
     SpeedButton111.Enabled := True;
     end
else begin
     SpeedButton106.Enabled := False;
     SpeedButton107.Enabled := False;
     SpeedButton109.Enabled := False;
     SpeedButton111.Enabled := False;
     end;
// active ou pas le SpeedButton d'evaluation des variable
SpeedButton110.Enabled := False;
for i := 0 to ListView1.Items.Count -1
do if (ListView1.Items.Item[i].Selected = True) and (ListView1.Items.Item[i].Caption = 'Variable')
   then begin SpeedButton110.Enabled := True; break; end;

end;

procedure TForm1.Outils1Click(Sender: TObject);
begin
valuer2.Checked := TabSheet4.TabVisible;
if FileExists(StatusBar1.Panels[0].Text)
then Gestionnairedetche1.Enabled := True
else Gestionnairedetche1.Enabled := False;
if FileExists(ExtractFileDir(Application.ExeName)+ '\SMLaunch.exe')
then Gestionnairedetche1.Visible := True
else Gestionnairedetche1.Visible := False;

end;

procedure TForm1.Danslescommandes1Click(Sender: TObject);
begin
Danslescommandes1.Checked := True;
Danslescommandes1.ShortCut := ShortCut(Ord('F'),[ssCtrl]);
Danslesparamtres1.Checked := False;
Danslesparamtres1.ShortCut := 0;
Danslescommandesetparamtres1.Checked := False;
Danslescommandesetparamtres1.ShortCut := 0;
FindDialog2.Execute;
if frDown in FindDialog2.Options
then Select_unique(ListView1,0)
else Select_unique(ListView1,ListView1.Items.Count-1);
end;

procedure TForm1.Danslesparamtres1Click(Sender: TObject);
begin
Danslescommandes1.Checked := False;
Danslescommandes1.ShortCut := 0;
Danslesparamtres1.Checked := True;
Danslesparamtres1.ShortCut := ShortCut(Ord('F'),[ssCtrl]);
Danslescommandesetparamtres1.Checked := False;
Danslescommandesetparamtres1.ShortCut := 0;
FindDialog2.Execute;
if frDown in FindDialog2.Options
then Select_unique(ListView1,0)
else Select_unique(ListView1,ListView1.Items.Count-1);
end;

procedure TForm1.Charger1Click(Sender: TObject);
begin
LoadTabInclude(TabOfIncludeGen,ListView1);
end;

procedure TForm1.Dcharger1Click(Sender: TObject);
begin
RestoreTabInclude(TabOfIncludeGen,ListView1);
end;

procedure TForm1.Danslescommandesetparamtres1Click(Sender: TObject);
begin
Danslescommandes1.Checked := False;
Danslescommandes1.ShortCut := 0;
Danslesparamtres1.Checked := False;
Danslesparamtres1.ShortCut := 0;
Danslescommandesetparamtres1.Checked := True;
Danslescommandesetparamtres1.ShortCut := ShortCut(Ord('F'),[ssCtrl]);
FindDialog2.Execute;
if frDown in FindDialog2.Options
then Select_unique(ListView1,0)
else Select_unique(ListView1,ListView1.Items.Count-1);
end;

procedure TForm1.FindDialog2Find(Sender: TObject);
var index : Integer;
    Trouver : Boolean;
begin
if ListView1.Items.Count = 0 then Exit;
FindDialog2.CloseDialog;
Trouver  := False;

if frDown in FindDialog2.Options
then begin
     // recherche vers le bas
     if ListView1.Selected = nil then Select_unique(ListView1,0);
     for index := ListView1.Selected.Index+1 to ListView1.Items.Count -1
     do begin
        if (Danslescommandes1.Checked = True) or (Danslescommandesetparamtres1.Checked = True)
        then if StrExist(ListView1.Items[index].Caption, FindDialog2.FindText) then Trouver := True;
        if (Danslesparamtres1.Checked = True) or (Danslescommandesetparamtres1.Checked = True)
        then if StrExist(ListView1.Items[index].SubItems[0], FindDialog2.FindText) then Trouver := True;
        if Trouver = True then break;
     end;
end
else begin
     // recherche vers le haut
     if ListView1.Selected = nil then Select_unique(ListView1,ListView1.Items.Count-1);
     for index := ListView1.Selected.Index -1 downto 0
     do begin
        if (Danslescommandes1.Checked = True) or (Danslescommandesetparamtres1.Checked = True)
        then if StrExist(ListView1.Items[index].Caption, FindDialog2.FindText) then Trouver := True;
        if (Danslesparamtres1.Checked = True) or (Danslescommandesetparamtres1.Checked = True)
        then if StrExist(ListView1.Items[index].SubItems[0], FindDialog2.FindText) then Trouver := True;
        if Trouver = True then break;
        end;
     end;

if Trouver = True
then begin
     Select_Unique(ListView1, index);
     ListView1.SetFocus;
     end
else begin
     MessageDlg('La chaine '''+FindDialog2.FindText+''' n''a pas été trouvée.',mtInformation,[mbOk],0);
     FindDialog2.Execute;
     if frDown in FindDialog2.Options
     then Select_unique(ListView1,0)
     else Select_unique(ListView1,ListView1.Items.Count-1);
     end;
end;

procedure TForm1.SpeedButton19Click(Sender: TObject);
begin
form22.Show;
end;

procedure TForm1.Crypter1Click(Sender: TObject);
begin
Form32Text := 0;
Form32.ShowModal;
end;

procedure TForm1.Macro1Click(Sender: TObject);
begin
if FileExists(StatusBar1.Panels[0].Text)
then begin Crypter1.Enabled := True; Exporterversexecutable1.Enabled := True; end
else begin Crypter1.Enabled := False; Exporterversexecutable1.Enabled := False; end;

if not FileExists(ExtractFileDir(Application.ExeName)+'\MdlAE.exe')
then Exporterversexecutable1.Enabled := False;

end;

procedure TForm1.SpeedButton20Click(Sender: TObject);
begin
Dtailcommandes1.Click;
end;

function  TForm1.GetTreeViewFullText(Sender: TObject; Fr : Boolean) : String;
var Text : String;
    ident1,ident2, ident3 : integer;
    DescUrl : String;
begin
result := '';
if not (Sender is TTreeView) then Exit;
if (Sender as TTreeView).Selected = nil then Exit;
Text := ''; DescUrl := '';
ident3 := -1;

if (Sender as TTreeView).Selected.Parent <> nil
then if (Sender as TTreeView).Selected.Parent.Parent <> nil
     then ident3 := (Sender as TTreeView).Selected.Parent.Parent.AbsoluteIndex else ident3 := -1;

if (Sender as TTreeView).Selected.Parent <> nil
     then ident2 := (Sender as TTreeView).Selected.Parent.AbsoluteIndex else ident2 := -1;

ident1 := TreeView1.Selected.AbsoluteIndex;

if Fr = False
then begin
     if (ident3 >= 0) and (AllDetailOrder.Count > ident3) then begin Text := Text + AllDetailOrder.Items[ident3].LngText_Order + ' > '; DescUrl := DescUrl + AllDetailOrder.Items[ident3].LngText_Order + SprPr; end;
     if (ident2 >= 0) and (AllDetailOrder.Count > ident2) then begin Text := Text + AllDetailOrder.Items[ident2].LngText_Order + ' > '; DescUrl := DescUrl + AllDetailOrder.Items[ident2].LngText_Order + SprPr; end;
     if (ident1 >= 0) and (AllDetailOrder.Count > ident1) then begin Text := Text + AllDetailOrder.Items[ident1].LngText_Order; DescUrl := DescUrl + AllDetailOrder.Items[ident1].LngText_Order + SprPr; end;
     end
else begin
     if (ident3 >= 0) and (AllDetailOrder.Count > ident3) then begin Text := Text + AllDetailOrder.Items[ident3].FrText_Order + ' > '; DescUrl := DescUrl + AllDetailOrder.Items[ident3].FrText_Order + SprPr; end;
     if (ident2 >= 0) and (AllDetailOrder.Count > ident2) then begin Text := Text + AllDetailOrder.Items[ident2].FrText_Order + ' > '; DescUrl := DescUrl + AllDetailOrder.Items[ident2].FrText_Order + SprPr; end;
     if (ident1 >= 0) and (AllDetailOrder.Count > ident1) then begin Text := Text + AllDetailOrder.Items[ident1].FrText_Order; DescUrl := DescUrl + AllDetailOrder.Items[ident1].FrText_Order + SprPr; end;
     end;

GetDescURLStyle(DescUrl);
result := Text;
end;

procedure TForm1.TreeView1Click(Sender: TObject);
var i,j : integer;
    Chaine : String;
    Trouver : Boolean;
    TreeViewText : String;
    HelpFileDynOrder : String;
    HelpContext, fileDefineName, FileDefineLine : string;
    WordFind : integer;
    ExplodeHelpContext : array of string;
    fileDefine : textfile;

begin
TreeViewText := GetTreeViewFullText(TreeView1,False);

// retrouve le n° de Context dans Define.h
FileDefineName := extractFileDir(application.ExeName)+'\define.h';
if FileExists(FileDEfineName) = True
then begin
     HelpContext := TreeViewText;
     HelpContext := UpperCase(HelpContext);
     HelpContext := StringReplace(HelpContext,' > ','-',[rfReplaceAll]);
     HelpContext := StringReplace(HelpContext,' ','-',[rfReplaceAll]);
     HelpContext := StringReplace(HelpContext,'é','E',[rfReplaceAll]);
     HelpContext := StringReplace(HelpContext,'è','E',[rfReplaceAll]);
     HelpContext := StringReplace(HelpContext,'É','E',[rfReplaceAll]);
     HelpContext := 'COMMANDE-'+HelpContext;

     Setlength(ExplodeHelpContext,1);
     for i := 1 to length(HelpContext)
     do if HelpContext[i] = '-'
        then Setlength(ExplodeHelpContext,length(ExplodeHelpContext)+1)
        else ExplodeHelpContext[length(ExplodeHelpContext)-1] := ExplodeHelpContext[length(ExplodeHelpContext)-1] + HelpContext[i];

     assignFile(fileDefine,FileDefineName);
     WordFind := 0;
     reset(fileDefine);
     try
     while not eof(FileDefine)
     do begin
        j := 0;
        Readln(FileDefine,FileDefineLine);
        for i := High(ExplodeHelpContext) downto low(ExplodeHelpContext)
        do begin
           if length(ExplodeHelpContext[i]) <= 2 then continue; // exclus la recherche de mot inferieur à 3 caractères.
           if Pos(ExplodeHelpContext[i],FileDefineLine) <> 0
           then begin
                Inc(j,1);
                FileDefineLine := StringReplace(FileDefineLine,ExplodeHelpContext[i],'',[]);
                end;
           end;
        if j > WordFind
        then begin
             WordFind := j;
             HelpContext := FileDefineLine;
             end;
        end;
     if length(FileDefineLine) >= 4
     then HelpContext := Copy(HelpContext,length(HelpContext)-3,4);
     if FnctIsInteger(HelpContext) then TreeView1.HelpContext := StrToInt(HelpContext);
     finally CloseFile(FileDefine); end;
     end;

ChangeDescription(OldSelectTreeView);
RichEdit2.Clear;
Trouver := False;
for i := 0 to Description.Count -1
do begin
   chaine := Description[i];
   if length(chaine) < 4 then continue;
   if (chaine[1] = ';') and (chaine[2] = ';') and (chaine[length(chaine)] = ';') and (chaine[length(chaine)] = ';')
   then if chaine = ';;'+ TreeViewText +';;'
        then begin trouver := True; continue; end
        else trouver := False;
   if trouver = True then RichEdit2.Lines.Add(chaine);
   end;

if leftstr(TreeViewText, length('Plugin')) = 'Plugin'
then begin
     for i := 0 to Length(DynOrder)-1
     do if (TreeView1.Selected.Text = DynOrder[i].Name) and (TreeView1.Selected.Parent.Text = DynOrder[i].Rubrique)
        then begin
             HelpFileDynOrder := ExtractFileDir(DynOrder[i].dllName)+'\'+ DynOrder[i].GetInfoDescription;
             if FileExists(HelpFileDynOrder)
             then RichEdit2.Lines.LoadFromFile(HelpFileDynOrder)
             else RichEdit2.Text := DynOrder[i].Description;
             break;
             end;
     end;

if RichEdit2.Text <> '' then PageControl1.ActivePage :=  TabSheet3;
OldSelectTreeView := TreeViewText;
if PageControl1.ActivePage =  TabSheet3
then RichEdit2.SelStart := 0;



end;


procedure TForm1.Annuler1Click(Sender: TObject);
begin
RichEdit2.Undo;
end;

procedure TForm1.Couper3Click(Sender: TObject);
begin
RichEdit2.CutToClipboard
end;

procedure TForm1.Copier3Click(Sender: TObject);
begin
RichEdit2.CopyToClipboard;
end;

procedure TForm1.Coller3Click(Sender: TObject);
begin
RichEdit2.PasteFromClipboard
end;

procedure TForm1.Supprimer3Click(Sender: TObject);
begin
if RichEdit2.SelLength > 0
then RichEdit2.ClearSelection;
end;

procedure TForm1.SlctionnerTout1Click(Sender: TObject);
begin
RichEdit2.SelectAll;
end;

procedure TForm1.Envoyeralauteur1Click(Sender: TObject);
var
 mail: TStringList;
begin
 mail := TStringList.Create;
 try
   Enregistrer2.Click;
   mail.values['to'] := Unit23.MyAddr;
   mail.values['subject'] := 'Super macro';
   mail.values['body'] := '';
   mail.values['attachment0'] := ExtractFileDir(Application.ExeName) +'\'+ form19.ComboBox3.Text +'.lng';
   ModuleSup.SendEMail(Application.Handle, mail);
 finally mail.Free; end;
end;

procedure Tform1.Openform13withparam(rubrique, format : String);
begin
SpeedButton13.Click;
Form13.ListBoxSetText(Form13.ListBox1,rubrique);
Form13.ListBox1click(Form13.ListBox1);
Form13.ListBoxSetText(Form13.ListBox2,Format);
Form13.ListBox2click(Form13.ListBox2);
end;

procedure TForm1.TreeView1DblClick(Sender: TObject);
var Text : String;
    i : integer;
begin
if TreeView1.Selected = nil then Exit;

Text := GetTreeViewFullText(TreeView1, True);

if Text = 'Clavier > Tape de Texte' then SpeedButton1.Click;
if Text = 'Clavier > Combinaison de touche' then SpeedButton2.Click;
if Text = 'Souris > Clique' then SpeedButton3.Click;
if Text = 'Souris > Déplacement' then SpeedButton4.Click;
if Text = 'Exécute > Programme' then begin SpeedButton5.Click; Form26.ComboBox1.Text := ''; end;
if Text = 'Exécute > Email' then begin SpeedButton5.Click; Form26.ComboBox1.Text := 'mailto:'; end;
if Text = 'Exécute > Page internet' then begin SpeedButton5.Click; Form26.ComboBox1.Text := 'http://www.'; end;
if Text = 'Label & Goto > Label' then SpeedButton6.Click;
if Text = 'Label & Goto > Goto' then SpeedButton7.Click;
if Text = 'Variable > Alphanumérique' then begin SpeedButton9.Click; Form8.RadioButton1.Checked := True; end;
if Text = 'Variable > Numérique' then begin SpeedButton9.Click; Form8.RadioButton2.Checked := True; end;
if Text = 'Fenêtre > Message' then SpeedButton31.Click;
if Text = 'Fenêtre > Question' then SpeedButton10.Click;
if Text = 'Pause > Pause' then SpeedButton8.Click;
if Text = 'Examine > Égale' then begin SpeedButton11.Click; Form11.RadioButton1.Checked := True end;
if Text = 'Examine > Différent' then begin SpeedButton11.Click; Form11.RadioButton4.Checked := True end;
if Text = 'Examine > Inférieur' then begin SpeedButton11.Click; Form11.RadioButton2.Checked := True end;
if Text = 'Examine > Supérieur' then begin SpeedButton11.Click; Form11.RadioButton3.Checked := True end;
if Text = 'Calcul > Évolué' then begin SpeedButton22.Click; end;
if Text = 'Calcul > Addition' then begin SpeedButton12.Click; Form12.RadioButton1.Checked := True; end;
if Text = 'Calcul > Soustraction' then begin SpeedButton12.Click; Form12.RadioButton2.Checked := True; end;
if Text = 'Calcul > Division' then begin SpeedButton12.Click; Form12.RadioButton4.Checked := True; end;
if Text = 'Calcul > Multiplication' then begin SpeedButton12.Click; Form12.RadioButton3.Checked := True; end;
if Text = 'Procédure > Déclaration' then begin SpeedButton38.Click; form36.Form36Show('Déclaration'); end;
if Text = 'Procédure > Fin' then begin SpeedButton38.Click; form36.Form36Show('Fin'); end;
if Text = 'Procédure > Appel' then begin SpeedButton38.Click; form36.Form36Show('Appel'); end;
If Text = 'Script > JScript' then begin Form25.Show; Form25.ComboBox1.ItemIndex := 0; end;
If Text = 'Script > VBScript' then begin Form25.Show; Form25.ComboBox1.ItemIndex := 1; end;

if Text = 'Fonction > Date > JJ/MM/AAAA' then Openform13withparam('Date','JJ/MM/AAAA');
if Text = 'Fonction > Date > JJMMAAAA' then Openform13withparam('Date','JJMMAAAA');
if Text = 'Fonction > Date > AAAAMMJJ' then Openform13withparam('Date','AAAAMMJJ');
if Text = 'Fonction > Date > Jour' then Openform13withparam('Date','Jour');
if Text = 'Fonction > Date > Mois' then Openform13withparam('Date','Mois');
if Text = 'Fonction > Date > Année' then Openform13withparam('Date','Année');
if Text = 'Fonction > Heure > HH:MM:SS' then Openform13withparam('Heure','HH:MM:SS');
if Text = 'Fonction > Heure > HHMMSS' then Openform13withparam('Heure','HHMMSS');
if Text = 'Fonction > Heure > Heure' then Openform13withparam('Heure','Heure');
if Text = 'Fonction > Heure > Heure' then Openform13withparam('Heure','Heure');
if Text = 'Fonction > Heure > Minute' then Openform13withparam('Heure','Minute');
if Text = 'Fonction > Heure > Seconde' then Openform13withparam('Heure','Seconde');
if Text = 'Fonction > Clipboard > Texte' then Openform13withparam('Clipboard','Texte');
if Text = 'Fonction > Texte > Longueur' then Openform13withparam('Texte','Longeur');
if Text = 'Fonction > Texte > Caractère/position' then Openform13withparam('Texte','Caractère(s)/Position(s)');
if Text = 'Fonction > Texte > Caractère/Longueur' then Openform13withparam('Texte','Caractère(s)/Longueur');
if Text = 'Fonction > Texte > Majuscule' then Openform13withparam('Texte','Majuscule');
if Text = 'Fonction > Texte > Minuscule' then Openform13withparam('Texte','Minuscule');
if Text = 'Fonction > Ecran > Longueur' then Openform13withparam('Ecran','Longueur');
if Text = 'Fonction > Ecran > Largeur' then Openform13withparam('Ecran','Largeur');
if Text = 'Fonction > Curseur > Position X' then Openform13withparam('Curseur','Position X');
if Text = 'Fonction > Curseur > Position Y' then Openform13withparam('Curseur','Position Y');
if Text = 'Fonction > Handle > Texte' then Openform13withparam('Handle','Texte');
if Text = 'Fonction > Handle > Longueur' then Openform13withparam('Handle','Longueur');
if Text = 'Fonction > Handle > Largeur' then Openform13withparam('Handle','Largeur');
if Text = 'Fonction > Handle > Etat' then Openform13withparam('Handle','Etat');
if Text = 'Fonction > Hasard > Lettre' then Openform13withparam('Hasard','Lettre');
if Text = 'Fonction > Hasard > Nombre' then Openform13withparam('Hasard','Nombre');
if Text = 'Fonction > Fichier > Nombre d''enregistrement' then Openform13withparam('Fichier','Nombre d''enregistrement');
if Text = 'Fonction > Fichier > Existe' then Openform13withparam('Fichier','Existe');
if Text = 'Fonction > Fichier > Taille en octets' then Openform13withparam('Fichier','Taille octets');
if Text = 'Fonction > Fichier > Extrait nom de fichier' then Openform13withparam('Fichier','Extrait nom de fichier');
if Text = 'Fonction > Fichier > Extrait répertoire' then Openform13withparam('Fichier','Extrait répertoire');
if Text = 'Fonction > Fichier > Extrait extension' then Openform13withparam('Fichier','Extrait extension');
if Text = 'Fonction > Répertoire système > Répertoire Maison' then Openform13withparam('Répertoire système','Rep Maison');
if Text = 'Fonction > Répertoire système > Répertoire Program File' then Openform13withparam('Répertoire système','Rep Fichier prog');
if Text = 'Fonction > Répertoire système > Répertoire Temporaire' then Openform13withparam('Répertoire système','Rep Temporaire');
if Text = 'Fonction > Répertoire système > Répertoire Windows' then Openform13withparam('Répertoire système','Rep Windows');
if Text = 'Fonction > Répertoire système > Répertoire Super macro' then Openform13withparam('Répertoire système','Rep Super Macro');
if Text = 'Fonction > Répertoire système > Répertoire macro' then Openform13withparam('Répertoire système','Rep Fichier Macro');
if Text = 'Fonction > Paramètre d''exécution > Paramètre n°' then Openform13withparam('Paramètre d''exécution','Paramètre n°');
if Text = 'Fonction > Paramètre d''exécution > Nombre de paramètre' then Openform13withparam('Paramètre d''exécution','Nombre de paramètre');


if Text = 'Fonction > Nombre > Abs' then Openform13withparam('Nombre','Abs');
if Text = 'Fonction > Nombre > Cos' then Openform13withparam('Nombre','Cos');
if Text = 'Fonction > Nombre > Cotang' then Openform13withparam('Nombre','Cotang');
if Text = 'Fonction > Nombre > Décimales' then Openform13withparam('Nombre','Décimales');
if Text = 'Fonction > Nombre > Monétaire' then Openform13withparam('Nombre','Monétaire');
if Text = 'Fonction > Nombre > Tang' then Openform13withparam('Nombre','Tang');
if Text = 'Fonction > Nombre > Tronc' then Openform13withparam('Nombre','Tronc');
if Text = 'Fonction > Nombre > Sin' then Openform13withparam('Nombre','Sin');

if Text = 'Fonction > Disque > Type de disque' then Openform13withparam('Disque','Type de disque');
if Text = 'Fonction > Disque > Taille Totale' then Openform13withparam('Disque','Taille Totale');
if Text = 'Fonction > Disque > Taille Disponible' then Openform13withparam('Disque','Taille Disponible');

if Text = 'Quitter > Quitter' then SpeedButton14.Click;
if Text = 'Commentaire > Commentaire' then Insereruncommentaire1.Click;
if Text = 'Lire et Ecrire > Lire' then begin SpeedButton15.Click; form15.RadioButton1.Checked := True; end;
if Text = 'Lire et Ecrire > Ecrire' then begin SpeedButton15.Click; form15.RadioButton2.Checked := True; end;
if Text = 'Objet > Objet' then Spy1.Click;

if Text = 'Manipulation sur objet > Restaurer' then begin SpeedButton16.Click; form18.Form18Show('Restaurer'); end;
if Text = 'Manipulation sur objet > Déplacer' then begin SpeedButton16.Click; form18.Form18Show('Déplacer'); end;
if Text = 'Manipulation sur objet > Taille' then begin SpeedButton16.Click; form18.Form18Show('Taille'); end;
if Text = 'Manipulation sur objet > Réduire' then begin SpeedButton16.Click; form18.Form18Show('Réduire'); end;
if Text = 'Manipulation sur objet > Agrandir' then begin SpeedButton16.Click; form18.Form18Show('Agrandir'); end;
if Text = 'Manipulation sur objet > Fermer' then begin SpeedButton16.Click; form18.Form18Show('Fermer'); end;
if Text = 'Manipulation sur objet > Déplacement souris' then begin SpeedButton16.Click; form18.Form18Show('Déplacement souris'); end;
if Text = 'Manipulation sur objet > Changement texte' then begin SpeedButton16.Click; form18.Form18Show('Changement texte'); end;
if Text = 'Manipulation sur objet > Fermeture forcée' then begin SpeedButton16.Click; form18.Form18Show('Fermeture forcée'); end;

if Text = 'Outils divers > Affichage > Résolution' then begin SpeedButton17.Click; Form27.Form27Show('Résolution'); end;
if Text = 'Outils divers > Affichage > Fréquence' then begin SpeedButton17.Click; Form27.Form27Show('Fréquence'); end;
if Text = 'Outils divers > Alimentation > Fermer session' then begin SpeedButton17.Click; Form27.Form27Show('Fermer la session'); end;
if Text = 'Outils divers > Alimentation > Eteindre' then begin SpeedButton17.Click; Form27.Form27Show('Eteindre'); end;
if Text = 'Outils divers > Alimentation > Redémarrer' then begin SpeedButton17.Click; Form27.Form27Show('Redémarrer'); end;
if Text = 'Outils divers > Alimentation > Mise en veille' then begin SpeedButton17.Click; Form27.Form27Show('Mise en veille'); end;
if Text = 'Outils divers > Ecran > Copier vers bmp' then begin SpeedButton17.Click; Form27.Form27Show('Copier vers bmp'); end;
if Text = 'Outils divers > Ecran > Copier vers jpg' then begin SpeedButton17.Click; Form27.Form27Show('Copier vers jpg'); end;
if Text = 'Outils divers > Fichier > Copier' then begin SpeedButton17.Click; Form27.Form27Show('Copier'); end;
if Text = 'Outils divers > Fichier > Déplacer' then begin SpeedButton17.Click; Form27.Form27Show('Déplacer'); end;
if Text = 'Outils divers > Fichier > Effacer' then begin SpeedButton17.Click; Form27.Form27Show('Effacer'); end;
if Text = 'Outils divers > Fichier > Renommer' then begin SpeedButton17.Click; Form27.Form27Show('Renommer'); end;
if Text = 'Outils divers > Fichier > Rechercher' then begin SpeedButton17.Click; Form27.Form27Show('Rechercher'); end;
if Text = 'Outils divers > Répertoire > Créer' then begin SpeedButton17.Click; Form27.Form27Show('Créer'); end;
if Text = 'Outils divers > Répertoire > Supprimer' then begin SpeedButton17.Click; Form27.Form27Show('Supprimer'); end;
if Text = 'Champs > Champs' then SpeedButton18.Click;
if Text = 'Trouve Image > Trouve Image' then SpeedButton19.Click;
if Text = 'Ouvrir une session au démarrage' then Form27.RebootXP(True);
if Text = 'Ne pas ouvrir la session au démarrage' then Form27.RebootXP(False);

if leftstr(Text, length('Plugin')) = 'Plugin'
then begin
     for i := 0 to Length(DynOrder)-1
     do if (TreeView1.Selected.Text = DynOrder[i].Name) and (TreeView1.Selected.Parent.Text = DynOrder[i].Rubrique)
        then begin TSpeedButton(DynOrder[i].PointerSbtn).Click; break; end;
     end;
end;

procedure TForm1.Enregistrer2Click(Sender: TObject);
begin
ChangeDescription(OldSelectTreeView);
Description.SaveToFile(ExtractFileDir(Application.ExeName) +'\'+ form19.ComboBox3.Text +'.lng');
end;

procedure TForm1.Dvelopper1Click(Sender: TObject);
begin
TreeView1.Items.BeginUpdate;
TreeView1.FullExpand;
TreeView1.Items.EndUpdate;
end;

procedure TForm1.Rduire1Click(Sender: TObject);
begin
TreeView1.Items.BeginUpdate;
TreeView1.FullCollapse;
TreeView1.Items.EndUpdate;
end;

procedure TForm1.PopupMenu4Popup(Sender: TObject);
begin
Annuler1.Enabled := RichEdit2.CanUndo;
Coller3.Enabled := Clipboard.HasFormat(CF_TEXT);
If RichEdit2.SelLength > 0
then begin Copier3.Enabled := True; Couper3.Enabled := True; Supprimer3.Enabled := True; end
else begin Copier3.Enabled := False; Couper3.Enabled := False; Supprimer3.Enabled := False; end;
end;

procedure TForm1.ListView1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var index : integer;
begin
if DirectRun = True then Exit;
if ListView1.Selected <> nil
then StatusBar1.Panels[3].Text := 'Ligne ' + IntToStr(ListView1.Selected.Index +1)+'/'+inttoStr(ListView1.Items.Count)
else StatusBar1.Panels[3].Text := 'Ligne 0/'+inttoStr(ListView1.Items.Count);
if Change = ctState then Exit;

for index := Item.Index-2 to Item.Index
do begin
   if ListView1.Items.Item[index] = nil then continue;
   ListView1.Items[index].Indent := 0;
   if ListView1.Items.Item[index-1] <> nil
   then begin
        if ListView1.Items[index-1].Caption = 'Examine'
        then begin
             ListView1.Items[index].Indent := ListView1.Items[index-1].Indent + 2;
             continue;
             end
        else ListView1.Items[index].Indent := 0;
        end;
   if ListView1.Items[index-2] <> nil
   then begin
        if ListView1.Items[index-2].Caption = 'Examine'
        then begin
             ListView1.Items[index].Indent := ListView1.Items[index-2].Indent + 2;
             continue;
             end
        else ListView1.Items[index].Indent := 0;
        end;

   if (ListView1.Items[index].Caption = 'Label') and (ListView1.Items[index].Indent = 0)
   then ListView1.Items[index].Indent := -1;
   if (ListView1.Items[index].Caption = 'Goto')  and (ListView1.Items[index].Indent = 0)
   then ListView1.Items[index].Indent := -1;
end;
end;

procedure TForm1.FormResize(Sender: TObject);
var i, OffSet : integer;
    WidthSecur : integer;
begin
OffSet := 0;
for i := 1 to StatusBar1.Panels.Count-1
do OffSet := OffSet + StatusBar1.Panels[i].Width;
// empêche d'avoir une longeur de composant < 10
WidthSecur :=  Form1.Width - OffSet-40;
if WidthSecur < 10 then WidthSecur := 10;
StatusBar1.Panels[0].Width := WidthSecur;
// empêche d'avoir une longeur de composant < 10
WidthSecur :=  ListView3.Width - ListView3.Columns[0].Width-4;
if WidthSecur < 10 then WidthSecur := 10;
ListView3.Columns[1].Width := WidthSecur;
end;

procedure TForm1.valuer1Click(Sender: TObject);
var i,j : integer;
    find : Boolean;
    ListParam : TParam;
    ListItem: TListItem;
begin
for i := 0 to ListView1.Items.Count -1
do if (ListView1.Items[i].Selected = True) and (ListView1.Items[i].Caption = 'Variable')
   then begin
        find := False;
        ListParam := GetParam(ListView1.Items[i].SubItems[0]);
        // Recherche de l'existance d'une évaluation de variable
        for j := 0 to ListView3.Items.Count - 1
        do if ListView3.Items.Item[j].Caption = ListParam.param[1]
           then find := True;
        // si pas trouvé Ajout
        if find = False
        then begin
             ListItem := ListView3.Items.Add;
             ListItem.Caption := ListParam.param[1];
             ListItem.SubItems.Add(ListParam.param[2]);
             ListItem.ImageIndex := 34;
             end;
        end;

TabSheet4.TabVisible := True;
PageControl1.ActivePage := TabSheet4;
end;

procedure TForm1.SpeedButton21Click(Sender: TObject);
begin
TabSheet4.TabVisible := False;
checkBox1.Checked := False;
end;

procedure TForm1.ListView3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var pos : integer;
begin
if ListView3.Selected = nil then Exit;
if Key = VK_delete
then begin
     pos := ListView3.Selected.Index -1;
     if (pos < 0) and (ListView3.Items.Count > 0)
     then pos := 0;
     ListView3.Selected.Delete;
     Select_Unique(ListView3,pos);
     end;
end;

procedure TForm1.valuer2Click(Sender: TObject);
begin
Valuer2.Checked := not Valuer2.Checked;
TabSheet4.TabVisible := Valuer2.Checked;
CheckBox1.Checked := Valuer2.Checked;
if TabSheet4.TabVisible = True then PageControl1.ActivePage := TabSheet4;
end;

procedure TForm1.ListView3Click(Sender: TObject);
begin
Select_unique(listView1,-1);
end;

procedure TForm1.SpeedButton22Click(Sender: TObject);
begin
form24.Show;
end;

procedure TForm1.ListView1Deletion(Sender: TObject; Item: TListItem);
begin
if ListView1.Visible = False then Exit;
CanAddHistory := False;
AddHistory(Item.index+1,'Suppression',Item.Caption,Item.SubItems[0]);
CanAddHistory := True;
if ListView1.Selected <> nil
then StatusBar1.Panels[3].Text := 'Ligne ' + IntToStr(ListView1.Selected.Index +1)+'/'+inttoStr(ListView1.Items.Count)
else StatusBar1.Panels[3].Text := 'Ligne 0/'+inttoStr(ListView1.Items.Count);
InfoListViewDelete(Item.Index);
end;

procedure TForm1.ListView4Click(Sender: TObject);
var i, pos : integer;
    Action, Commande, param : String;
begin
if ListView4.Selected = nil then Exit;

ListView4.Items.BeginUpdate;
Can_Save := False;

for i := 0 to ListView4.Items.Count -1
do if ListView4.Items.Item[i].Selected = True
   then ListView4.Items.Item[i].StateIndex := 14
   else ListView4.Items.Item[i].StateIndex := -1;

if ListView4.Tag = -1 then ListView4.Tag := ListView4.Items.Count -1;

if ListView4.Tag > ListView4.Selected.Index
then begin
     for i := ListView4.Tag downto ListView4.Selected.Index+1
     do begin
        pos := StrToInt(ListView4.Items.Item[i].caption)-1;
        Action := ListView4.Items.Item[i].SubItems[0];
        Commande := ListView4.Items.Item[i].SubItems[1];
        Param := ListView4.Items.Item[i].SubItems[2];
        if Action = 'Suppression'
        then begin
             ListView1.Items.Insert(pos);
             ListView1.Items.Item[pos].caption := Commande;
             ListView1.Items.Item[pos].ImageIndex := form1.GetImageIndex(Commande);
             ListView1.Items.Item[pos].SubItems.Add(Param);
             end;
        if Action = 'Ajout'
        then begin
             if ListView1.Items.Item[pos] <> nil
             then ListView1.Items.Item[pos].Delete;
             end;
        if Action = 'Modification'
        then begin
             if ListView1.Items.Item[pos] <> nil
             then ListView1.Items.Item[pos].SubItems[0] := Form1.FindModif(pos+1,ListView4.Selected.Index,ListView1.Items.Item[pos].SubItems[0]);
             end;
        if Action = 'Monter d''un niveau'
        then Movecommande(ListView1,pos-1,pos);
        if Action = 'Descendre d''un niveau'
        then Movecommande(ListView1,pos+1,pos);
        if Action = 'Valeur Initiale'
        then begin
             if ListView1.Items.Item[pos] <> nil
             then ListView1.Items.Item[pos].SubItems[0] := Param;
             end;
        end;
     end;

if ListView4.Tag < ListView4.Selected.Index
then begin
     for i := ListView4.Tag+1 to ListView4.Selected.Index
     do begin
        pos := StrToInt(ListView4.Items.Item[i].caption)-1;
        Action := ListView4.Items.Item[i].SubItems[0];
        Commande := ListView4.Items.Item[i].SubItems[1];
        Param := ListView4.Items.Item[i].SubItems[2];
        if Action = 'Ajout'
        then begin
             ListView1.Items.Insert(pos);
             ListView1.Items.Item[pos].caption := Commande;
             ListView1.Items.Item[pos].ImageIndex := form1.GetImageIndex(Commande);
             ListView1.Items.Item[pos].SubItems.Add(Param);
             end;
        if Action = 'Suppression'
        then begin
             if ListView1.Items.Item[pos] <> nil
             then ListView1.Items.Item[pos].Delete;
             end;
        if Action = 'Modification'
        then begin
             if ListView1.Items.Item[pos] <> nil
             then ListView1.Items.Item[pos].SubItems[0] := Param;
             end;

        if Action = 'Monter d''un niveau'
        then Movecommande(ListView1,pos,pos-1);
        if Action = 'Descendre d''un niveau'
        then Movecommande(ListView1,pos,pos+1);
     end;
     end;

ListView4.Tag := ListView4.Selected.Index;
ListView4.OnChanging(ListView4,nil,ctState,Can_save);
Can_Save := True;
ListView4.Items.EndUpdate;
end;

procedure TForm1.SpeedButton25Click(Sender: TObject);
begin
if ListView4.Tag >= 0
then if ListView4.Selected = nil
     then ListView4.Items[ListView4.Tag].Selected := True;
if ListView4.Selected = nil then Exit;

Select_Unique(ListView4,ListView4.Selected.Index-1);
ListView4.OnClick(self);
end;

procedure TForm1.SpeedButton24Click(Sender: TObject);
begin
TabSheet5.TabVisible := False;
end;

procedure TForm1.ListView3AdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
begin
if item.index mod 2 <> 0
then ListView3.Canvas.Brush.Color := $00EEEEEE
else ListView3.Canvas.Brush.Color := ListView2.Color;

ListView3.Canvas.Font.Style := [];
ListView3.Canvas.Font.Color := GetSysColor(COLOR_WINDOWTEXT);

end;

procedure TForm1.SpeedButton23Click(Sender: TObject);
begin
if ListView4.Tag >= 0
then if ListView4.Selected = nil
     then ListView4.Items[ListView4.Tag].Selected := True;
if ListView4.Selected = nil then Exit;

Select_Unique(ListView4,ListView4.Selected.Index+1);
ListView4.OnClick(self);
end;

procedure TForm1.ListView4Changing(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
begin

if (ListView4.Tag > 0) and (ListView4.Items.Count > 1)
then begin SpeedButton25.Enabled := True; SpeedButton26.Enabled := True; end
else begin SpeedButton25.Enabled := False; SpeedButton26.Enabled := False; end;

if (ListView4.Tag < ListView4.Items.Count-1)
then begin SpeedButton23.Enabled := True; SpeedButton27.Enabled := True; end
else begin SpeedButton23.Enabled := False; SpeedButton27.Enabled := False; end;
end;

procedure TForm1.Modificattion1Click(Sender: TObject);
begin
TabSheet5.TabVisible := True;
PageControl1.ActivePage := TabSheet5;
end;

procedure TForm1.Dfaire1Click(Sender: TObject);
begin
SpeedButton25.Click;
end;

procedure TForm1.Refaire1Click(Sender: TObject);
begin
SpeedButton23.Click;
end;

procedure TForm1.CheckBox3Click(Sender: TObject);
begin
Form19.CheckBox5.Checked := CheckBox3.Checked;
end;

procedure TForm1.ReplaceDialog1Replace(Sender: TObject);
var index : Integer;
    Trouver, GTrouver : Boolean;
begin
if ListView1.Items.Count = 0 then Exit;
GTrouver := False;

if FnctTypeVar(ReplaceDialog1.FindText) <> TNo
then begin
     Form1.AddHistory(0,'Début d''actions groupées','','');
     Form1.ChangeVarName(ReplaceDialog1.FindText,ReplaceDialog1.ReplaceText,True);
     Form1.AddHistory(0,'Fin d''actions groupées','','');
     MessageDlg('Remplacement terminé.',mtInformation,[mbOk],0);
     ReplaceDialog1.CloseDialog;
     Exit;
     end;

if frReplace in ReplaceDialog1.Options
then begin
     if frDown in ReplaceDialog1.Options // recherche vers le bas
     then begin
          if ListView1.Selected = nil then Select_unique(ListView1,0);
          for index := ListView1.Selected.Index to ListView1.Items.Count -1
          do begin
             if StrExist(ListView1.Items[index].SubItems[0], ReplaceDialog1.FindText) then Trouver := True else Trouver := False;
             if Trouver = True
             then begin
                  Select_Unique(ListView1, index);
                  Save_caption := ListView1.Items[index].SubItems[0];
                  sw_modif := True;
                  ListView1.Items[index].SubItems[0] := AnsiReplaceText(ListView1.Items[index].SubItems[0],ReplaceDialog1.FindText,ReplaceDialog1.ReplaceText);
                  SaveBeforeChange(ListView1.Items[index]);
                  sw_modif := False;
                  Exit;
                  end;
             end;
          end
          else begin // recherche vers le haut
               if ListView1.Selected = nil then Select_unique(ListView1,ListView1.Items.Count-1);
               for index := ListView1.Selected.Index -1 downto 0
               do begin
                  if StrExist(ListView1.Items[index].SubItems[0], ReplaceDialog1.FindText) then Trouver := True else Trouver := False;
                  if Trouver = True
                  then begin
                       Select_Unique(ListView1, index);
                       Save_caption := ListView1.Items[index].SubItems[0];
                       sw_modif := True;
                       ListView1.Items[index].SubItems[0] := AnsiReplaceText(ListView1.Items[index].SubItems[0],ReplaceDialog1.FindText,ReplaceDialog1.ReplaceText);
                       SaveBeforeChange(ListView1.Items[index]);
                       sw_modif := False;
                       Exit;
                       end;
                  end;
               end;
end;

if frReplaceAll in ReplaceDialog1.Options
then begin
     if frDown in ReplaceDialog1.Options // recherche vers le bas
     then begin
          if ListView1.Selected = nil then Select_unique(ListView1,0);
          for index := ListView1.Selected.Index to ListView1.Items.Count -1
          do begin
             if StrExist(ListView1.Items[index].SubItems[0], ReplaceDialog1.FindText) then Trouver := True else Trouver := False;
             if Trouver = True
             then begin
                  GTrouver := True;
                  Save_caption := ListView1.Items[index].SubItems[0];
                  sw_modif := True;
                  ListView1.Items[index].SubItems[0] := AnsiReplaceText(ListView1.Items[index].SubItems[0],ReplaceDialog1.FindText,ReplaceDialog1.ReplaceText);
                  SaveBeforeChange(ListView1.Items[index]);
                  sw_modif := False;
                  end;
             end;
          end
          else begin // recherche vers le haut
               if ListView1.Selected = nil then Select_unique(ListView1,ListView1.Items.Count-1);
               for index := ListView1.Selected.Index -1 downto 0
               do begin
                  if StrExist(ListView1.Items[index].SubItems[0], ReplaceDialog1.FindText) then Trouver := True else Trouver := False;
                  if Trouver = True
                  then begin
                       GTrouver := True;
                       Save_caption := ListView1.Items[index].SubItems[0];
                       sw_modif := True;
                       ListView1.Items[index].SubItems[0] := AnsiReplaceText(ListView1.Items[index].SubItems[0],ReplaceDialog1.FindText,ReplaceDialog1.ReplaceText);
                       SaveBeforeChange(ListView1.Items[index]);
                       sw_modif := False;
                       end;
                  end;
               end;
end;

if Gtrouver = True
then MessageDlg('Remplacement terminé.',mtInformation,[mbOk],0)
else MessageDlg('La chaine "'+ReplaceDialog1.FindText+'" n''a pas été trouvée.',mtInformation,[mbOk],0);

ReplaceDialog1.CloseDialog;
end;

procedure TForm1.Remplacer1Click(Sender: TObject);
begin
ReplaceDialog1.Execute;
end;

procedure TForm1.ListView3DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
Accept := Sender = ListView3;
end;

procedure TForm1.ListView3EndDrag(Sender, Target: TObject; X, Y: Integer);
Var InsertItem : TListItem;
        iIcone, i1, i2 : integer;
    vr,vl : String;
begin
if Target = nil then Exit;
i1 := ListView3.Selected.index;
if ListView3.GetItemAt(X,Y) <> nil
then i2 := ListView3.GetItemAt(X,Y).Index
else i2 := ListView3.Items.Count;
if i2 < 0 then i2 := 0;
if i2 > ListView3.Items.Count then i2 := ListView3.Items.Count;
vr := ListView3.Items[i1].Caption;
vl := ListView3.Items[i1].SubItems[0];
iIcone := ListView3.Items[i1].ImageIndex;
ListView3.Items.Delete(i1);
InsertItem := ListView3.Items.Insert(i2);
InsertItem.Caption := vr;
InsertItem.SubItems.Add(vl);
InsertItem.ImageIndex := iIcone;
select_Unique(ListView3,i2);
end;

procedure TForm1.MenuPanel(Sender: TMenuItem);
var i : integer;
   Panel : TPanel;
   SpeedButton : TSpeedButton;
   Left : integer;
begin
// creation du panel & ses params
Panel := TPanel.Create(Form1);
Panel.Parent := Form1;
Panel.Height := 28;
Panel.Align := alTop;
Panel.Top :=0;
Left := 8;

// creation du bouton fermer & ses params
   SpeedButton := TSpeedButton.Create(Panel);
   SpeedButton.Parent := Panel;
   SpeedButton.Top := 3;
   SpeedButton.Height := 12;
   SpeedButton.Width := 12;
   SpeedButton.Flat := True;
   SpeedButton.Left := Panel.Width - 15;
   ImageList3.GetBitmap(22,SpeedButton.Glyph);
   SpeedButton.Hint := 'Fermer'; SpeedButton.ShowHint := True;
   SpeedButton.Anchors := [akTop,akRight,akBottom];
   SpeedButton.OnClick := OnCloseMenuPanel;
// creation des boutons & de ses params
for i := 0 to Sender.Count -1
do begin
   if Sender.Items[i].IsLine then continue;
   if Sender.Items[i].Count > 0 then continue;
   SpeedButton := TSpeedButton.Create(Panel);
   SpeedButton.Parent := Panel;
   SpeedButton.Top := 3;
   SpeedButton.Height := 22;
   SpeedButton.Left := Left;
   SpeedButton.Flat := True;
   SpeedButton.Name := 'Menu'+ Sender.Items[i].Name;
   SpeedButton.Enabled := Sender.Items[i].Enabled;
   //Sender.Items[i].OnDrawItem := OnDrawItemMenuPanel;
   ImageList3.GetBitmap(Sender.Items[i].ImageIndex,SpeedButton.Glyph);
   SpeedButton.Caption := Sender.Items[i].Caption;
   SpeedButton.Width := length(SpeedButton.Caption)*8 - length(SpeedButton.Caption);
   if Sender.Items[i].ImageIndex <> -1 then SpeedButton.Width := SpeedButton.Width +16;
   SpeedButton.OnClick := Sender.Items[i].OnClick;
   Left := Left + SpeedButton.Width; // + 8;
   end;
end;

procedure TForm1.OnCloseMenuPanel(Sender: TObject);
begin
TComponent(Sender).GetParentComponent.Free;
end;

procedure TForm1.OnDrawItemMenuPanel(Sender: TObject; ACanvas: TCanvas; ARect: TRect; Selected: Boolean);
var Bt : TspeedButton;
begin
Bt :=(Form1.FindComponent('Menu'+ TControl(sender).Name) as TSpeedButton);
if Bt = nil then Exit;
Bt.Enabled := TControl(Sender).enabled;

end;

procedure TForm1.PopupMenu6Popup(Sender: TObject);
var i : integer;
begin
if ListView3.Selected = nil
then begin
     Modifier1.Enabled := False;
     Supprimer4.Enabled := False;
     end
else begin
     Modifier1.Enabled := True;
     Supprimer4.Enabled := True;
     for i := Low(ListOfSysVar) to High(ListOfSysVar)
     do if ListOfSysVar[i].VName = ListView3.Selected.Caption
        then if ListOfSysVar[i].VRW = 0
             then Modifier1.Enabled := False;
     end;
if ListView3.Items.Count = 0
then Reinitialiertouteslesvariable1.Enabled := False else Reinitialiertouteslesvariable1.Enabled := True;
if ListView3.Items.Count = 0
then Supprimertouteslesvariables1.Enabled := False else Supprimertouteslesvariables1.Enabled := True;

Ajouter1.Enabled := False;
if ListView1.Selected <> nil
then if ListView1.Selected.Caption = 'Variable' then Ajouter1.enabled := True;
end;

procedure TForm1.SpeedButton28MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
if button = mbLeft then popupMenu6.Popup(SpeedButton28.ClientOrigin.x + SpeedButton28.Width ,SpeedButton28.ClientOrigin.y + SpeedButton28.Height div 2);
end;

procedure TForm1.Supprimer4Click(Sender: TObject);
var pos : integer;
begin
if ListView3.Selected = nil then Exit;

pos := ListView3.Selected.Index -1;
if (pos < 0) and (ListView3.Items.Count > 0)
then pos := 0;
ListView3.Selected.Delete;
Select_Unique(ListView3,pos);
end;

procedure TForm1.Modifier1Click(Sender: TObject);
var TVar,change :String;
    VarName : String;
begin
if ListView3.Selected = nil then Exit;
VarName := ListView3.Selected.Caption;
TVar := mdlfnct.FnctTypeVar(VarName);
if TVar = TNo
then begin
     ShowMessage('La variable nommée '+ VarName +' n''est pas déclarée.');
     Supprimer4.Click;
     Exit;
     end;
if Run = True
then Change := Saisie('Modification de variable','Valeur',GetValue(VarName),False)
else Change := Saisie('Modification de variable','Valeur','',False);
if (TVar = TNum) and (mdlfnct.FnctIsInteger(Change) = False)
then begin ShowMessage('Valeur incorrecte'); Exit; end;

form1.WriteVariable('VAR',ListView3.Selected.Caption,Change)
end;

procedure TForm1.Ajouter1Click(Sender: TObject);
begin
valuer1.Click;
end;

procedure TForm1.Ajoutertouslesbullets1Click(Sender: TObject);
var i : integer;
begin
for i := Low(TabInfoListView) to High(TabInfoListView)
do begin
   if TabInfoListView[i].Bullet = False
   then begin
        TabInfoListView[i].Bullet := True;
        TabInfoListView[i].BulletColor := BulletColor;
        end;
   end;
InfoListViewDraw;
end;

procedure TForm1.Supprimertouteslesvariables1Click(Sender: TObject);
begin
ListView3.Clear;
end;

procedure TForm1.Reinitialiertouteslesvariable1Click(Sender: TObject);
var i,j : integer;
    FType : String;
begin
for i := ListView3.Items.Count-1 downto 0
do begin
   if ListView3.Items[i] = nil then continue;
   FType := mdlfnct.FnctTypeVar(ListView3.Items[i].Caption);
   if FType = TAlpha then WriteVariable('VAR',ListView3.Items[i].Caption,'');
   if FType = TNum then WriteVariable('VAR',ListView3.Items[i].Caption,'0');
   if FType = TNo
   then begin
        j := Form8.FindSysVar(ListView3.Items[i].Caption);
        if j = -1 then begin ListView3.Items[i].Delete; continue; end;
        if ListOfSysVar[j].VRW = 1 then ListView3.Items[i].Delete;
        end;
   end;
end;

procedure TForm1.ListView1Exit(Sender: TObject);
begin
SpeedButton106.Enabled := False;
SpeedButton107.Enabled := False;
SpeedButton108.Enabled := False;
SpeedButton109.Enabled := False;
SpeedButton110.Enabled := False;
SpeedButton111.Enabled := False;
end;

procedure TForm1.ListView1Insert(Sender: TObject; Item: TListItem);
begin
InfoListViewInsert(Item.Index);
end;

function TForm1.GetNewOrderIndex(Commande : String): integer;
var i : integer;
begin
   result := -1;
   if Commande = '' then Exit;
   for i := 0 to Length(DynOrder)-1
   do if GestionCommande.DynOrder[i].Name = Commande
      then begin result := i; break; end;
end;

function TForm1.GetNewOrderIndex(Handle : Hwnd): integer;
var i : integer;
begin
result := 0;
for i := 0 to Length(DynOrder)-1
do if GestionCommande.DynOrder[i].Handle = Handle
   then begin result := i; break; end;
if result = 0 then DynOrder[0].Handle := Handle;
end;

procedure TForm1.OnClickNewOrder(Sender : TObject);
var pos : integer;
    Text : String;
    HelpFileDynOrder : String;
begin
pos := TSpeedButton(Sender).tag;
HelpFileDynOrder := ExtractFileDir(DynOrder[pos].dllName)+'\'+ DynOrder[pos].GetInfoDescription;
if FileExists(HelpFileDynOrder)
then Form1.RichEdit2.Lines.LoadFromFile(HelpFileDynOrder)
else Form1.RichEdit2.Text := DynOrder[pos].GetInfoDescription;

TreeView1.ClearSelection();
if Form1.RichEdit2.Text <> '' then Form1.PageControl1.ActivePage :=  Form1.TabSheet3;

Form1.GetDescURLStyle(DynOrder[pos].Rubrique + SprPr +DynOrder[pos].Name+SprPr);
try
TSpeedButton(DynOrder[pos].PointerSbtn).Enabled := False;
PLUGIN_CANCEL_NEW_OR_CHANGE_ORDER := False;
Text := StrPas(DynOrder[pos].NewOrdre);
if PLUGIN_CANCEL_NEW_OR_CHANGE_ORDER = False
then Add_Insert(DynOrder[pos].Name,Text,DynOrder[pos].IconIndex);
TSpeedButton(DynOrder[pos].PointerSbtn).Enabled := True;
except on E: Exception do ShowApplicationError(Sender,E); end;
end;

procedure TForm1.DLL_GET_VAR_VALUE(var message: Tmessage);
var MyPChar : PChar;
    value : String;
    index : integer;
begin
index := GetNewOrderIndex(message.wParam);
MyPchar := Pchar(message.LParam);
value := GetValue(MyPchar);
DynOrder[index].GetInfoFromSMacro(Pchar('GET_VAR_VALUE'),Pchar(value),0,True);
end;

procedure TForm1.DLL_SET_VAR_VALUE(var message: Tmessage);
var PCharVarName, PCharValue : PChar;
begin
PCharVarName := Pchar(message.WParam);
PCharValue := Pchar(message.LParam);
Form1.WriteVariable('VAR',PCharVarName,PCharValue);
end;

procedure TForm1.DLL_ERROR_TO_EXECUTE(var message : Tmessage);
var PcharwParam : Pchar;
    TextLen, TextSel : integer;
begin
PcharwParam := Pchar(message.lParam);
if PcharwParam = nil then Exit;
if message.WParam < 5 // mode erreur
then ErrorComportement(PcharwParam,message.WParam)
else begin // mode message
     TextLen := RichEdit1.GetTextLen;
     RichEdit1.Lines.Add(PcharwParam);
     TextSel := TextLen + length(PcharwParam);
     RichEdit1.SelStart := TextLen;
     RichEdit1.SelLength := TextSel;
     RichEdit1.SelAttributes.Color := clGreen;
     RichEdit1.SelStart := TextLen + TextSel;
     WriteVariable('VAR','[ERROR]',PcharwParam);
     end;
end;

procedure TForm1.DLL_ADD_ORDER(var message : Tmessage);
var PcharwParam : Pchar;
    index : integer;
begin
index := GetNewOrderIndex(message.wParam);
PcharwParam := Pchar(message.lParam);
form1.add_insert(DynOrder[index].Name,PcharwParam,DynOrder[index].IconIndex);
end;

function TForm1.Authen(App : String):cardinal;
type Tarray128 = array[1..128]of char;
const   AES = 'PLJUK5RGN9QHDJSW8MVKFOIECPOEOLDFE8ED5HSEHALSMAWGT68NOG7E5QBH8KUDEWABGHUERKGICS6JKI9KKRTJHI9VCWQ776GS5TISEIFKH5KCU5EVHHLI8WADFAIK';
   AESMouse = 'EVISDD2YE3PWACBONYKMOPDL3M6DCA1YE5VDJ56MROV57JYT8QS5OHH945W44IBPI6QHXZI68JNGZPX1W3PCW2LMTHEOMVMHHSVCGNTNJO5KPFVOABLTLFKQDUKKCN9F';
AESKeyboard = 'M7C5HNUMYBW439ZRRTNBHAOQFCPNN4BL4YP5NJQUYFCFT1LW5BJS85L3Y7D2KM59OETK58P9IL6QFIGV9I8QLLAQV8SKD9J7VP8ANQ7IFKH9JR7BHAEGAOI56CRCHNKG';
  AESLaunch = 'PSCM56MDIEJLEAS5GIKCLH6ONP764MBWU8ULS98D9UY9EBQLE9IALPN9EPVLPQ5CDBGBTPI9JFBTFAF7HMPOS8CQMPBFGFKRTJ7UG8NMGO6DOELH7UJ7CJI96EC5QVVU';
function AddToKey(Key,Add : Tarray128): Tarray128;
var i,j: integer;
str : string;
begin
str := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
for i := 1 to 128
do begin
   j := (Ord(Key[i]) + Ord(Add[i]))mod 35;
   result[i] := Str[j+1];
   end;
end;
var
  FromF : file;
  NumRead : Integer;
  Buf: Tarray128;
  Key: Tarray128;
  //KStr : String;
  i : integer;
begin
    result := 0;
    if not FileExists(App)
    then begin MessageDlg(SFileNotFound+' ('+App+').', mtWarning,[mbOk], 0); exit; end;
    AssignFile(FromF, App);
    for i := 1 to 128 do Key[i] := ' ';
    try
    FileMode := 0;
    Reset(FromF, 1);
     repeat
     BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
     Key := AddToKey(Key, Buf);
     until (NumRead = 0);
     //KStr := Key;  // Pour examiner la valeur de Key
     if (SameFileName(ExtractFileName(App),'mdlae.exe') = True)and(Key = AES) then result := 1;
     if (SameFileName(ExtractFileName(App),'Souris_Hook.dll') = True)and(Key = AESMouse) then result := 1;
     if (SameFileName(ExtractFileName(App),'Clavier_Hook.dll') = True)and(Key = AESKeyboard) then result := 1;
     if (SameFileName(ExtractFileName(App),'SMLaunch.exe') = True)and(Key = AESLaunch) then result := 1;
     Finally CloseFile(FromF); FileMode := 2;
     if result = 0
     then begin
          if DeleteFile(App)= True
          then MessageDlg('Le test d''authentification à échoué. Afin de prévenir tous risques d''intrusions de logiciel malveillant, le module ['+ExtractFileName(App)+'] a été supprimé définitivement de votre disque.', mtWarning,[mbOk], 0)
          else MessageDlg('Le test d''authentification à échoué. Le fichier est occupé par une autre ressource('+ App +').Suppression automatique impossible', mtWarning,[mbOk], 0);
          end;
     end;

end;

procedure TForm1.ReceiveMsgfromNewOrder(var Message: TMessage);
var index,i,j : integer;
    Text : String;
    nAtom : Word;
    PCharBuffer:array[0..254]of Char;
    PCharText : Pchar;
    ListVar : TStringList;
    ListParam : TParam;
    List : TListView;
    Pos : Integer;
begin
form1.GetActiveMacro(List,Pos);

index := GetNewOrderIndex(message.wParam);
case message.LParam of
         0 : GestionCommande.PLUGIN_CANCEL_NEW_OR_CHANGE_ORDER := True;
         1 : begin
             Text := StatusBar1.Panels[0].Text;
             if ALIAS_EXE <> '' then Text := ALIAS_EXE;
             if Text = Lng_NewMacro then  Text := '';
             DynOrder[index].GetInfoFromSMacro(Pchar('Macro filename'),Pchar(Text),0,True);
             end;
         2 : begin
             Text := DynOrder[index].Name;
             DynOrder[index].GetInfoFromSMacro('Filename plugin',Pchar(Text),0,True);
             end;
         3 : begin
             Text := Form19.Label22.Caption;
             DynOrder[index].GetInfoFromSMacro(Pchar('Filename config'),Pchar(Text),0,True);
             end;
         4 : begin
             Text := SprPr;
             DynOrder[index].GetInfoFromSMacro(Pchar('Char of separation'),Pchar(Text),0,True);
             end;
         5 : begin
             DynOrder[index].GetInfoFromSMacro(Pchar('Count Order'),'',List.Items.Count,True);
             end;
         6 : begin
             if BackGround <> nil
             then DynOrder[index].GetInfoFromSMacro(Pchar('Handle BackGround'),'',Integer(BackGround.Handle),True)
             else DynOrder[index].GetInfoFromSMacro(Pchar('Handle BackGround'),'',0,False);
             end;
         7 : DynOrder[index].GetInfoFromSMacro(Pchar('GetFont'),'',Integer(Application.MainForm.Font.Handle),True);
         8 : DynOrder[index].GetInfoFromSMacro(Pchar('GetFont'),'',Panel4.Font.Color,True);
         9 : DynOrder[index].GetInfoFromSMacro(Pchar('SMacroHandle'),'',Integer(application.Handle),True);
        10 : DynOrder[index].GetInfoFromSMacro(Pchar('LibraryHandle'),'',Integer(DynOrder[index].Handle),True);
    11..30 : begin
             i := 0;
             if List = Form1.ListView1
             then begin if List.Items[Pos_Command] <> nil then i := Pos_Command; end
             else begin if List.Items[SousMacroExecuteIndex] <> nil then i := SousMacroExecuteIndex; end;

             if (List.Selected <> nil) and (ContextOfExecute.ExecutionType = ContextOfExecute.NotRun) and (sw_modif = True)
             then i := List.Selected.Index;

             if List.Items[i] <> nil
             then begin
                  ListParam := GetParam(List.Items[i].SubItems[0]);
                  Text := ListParam.Param[message.lParam - 10];
                  DynOrder[index].GetInfoFromSMacro(Pchar('Array param'),Pchar(Text),0,True);
             end else DynOrder[index].GetInfoFromSMacro(Pchar('Array param'),Pchar(''),0,False);
             end;
    31 : DynOrder[index].GetInfoFromSMacro(Pchar('ContextOfExecute'),'',ContextOfExecute.ExecutionType,True);
    32 : Form1.SpeedButton103.Click; // Run
    33 : Form1.SpeedButton29.Click; // Pause
    34 : Form1.SpeedButton105.Click; // Stop
    35 : begin  // Start At ... for Label Name
         nAtom:=TMessage(Message).WParam;
         GlobalGetAtomName(nAtom, PCharBuffer, SizeOf(PCharBuffer));
         PcharText := PCharBuffer;
         j := 0;
         for i := 0 to List.Items.Count - 1
             do if (List.Items[i].Caption = 'Label') and (List.Items[i].SubItems[0] = PcharText)
                then begin
                     if ContextOfExecute.ExecutionType = ContextOfExecute.Run
                     then SendMessage(Form1.Handle,WM_POS_ORDER,message.wParam,i)
                     else Execute(nil,False,i);
                     j := 1;
                     break;
                     end;
         if j = 0 then ErrorComportement('Label '+ PcharText +' introuvable');
         end;
    36 : Form1.SpeedButton100.Click; // NEW
1000, 2000,
3000       : begin
             j := 0;
             if message.LParam = 3000 then Text := 'Objet' else Text := 'Variable';
             for i := 0 to List.Items.Count - 1
             do if List.Items[i].Caption = Text
                then Inc(j);
             DynOrder[index].GetInfoFromSMacro(Pchar(Text + ' count'),'',j,True);
             end;
1001..1999 : begin
             Text := '';
             ListVar := TStringList.Create();
             try
             form1.List_Var(ListVar,true,true, List);
             if ((message.lParam - 1000) <= (ListVar.Count))
             then Text := ListVar[message.lParam - 1001];
             if Text <> ''
             then DynOrder[index].GetInfoFromSMacro(Pchar('Variable name'),Pchar(Text),0,True)
             else  DynOrder[index].GetInfoFromSMacro(Pchar('Variable name'),'',0,False);
             finally ListVar.Free; end;
             end;
2001..2999 : begin
             Text := '';
             ListVar := TStringList.Create();
             try
             form1.List_Var(ListVar,true,true,List);
             if ((message.lParam - 2000) <= (ListVar.Count))
             then Text := ListVar[message.lParam - 2001];
             if Text <> ''
             then begin
                  Text := mdlFnct.FnctTypeVar(Text);
                  DynOrder[index].GetInfoFromSMacro(Pchar('Variable type'),Pchar(Text),0,True);
                  end
             else  DynOrder[index].GetInfoFromSMacro(Pchar('Variable type'),'Unknow',0,False);
             finally ListVar.Free; end;
             end;
3001..3999 : begin
             j := 0; Text := '';
             for i := 0 to List.Items.Count - 1
             do if List.Items[i].Caption = 'Objet'
                then begin
                     Inc(j);
                     if j = (message.lParam - 3000)
                     then begin
                          text := List.Items[i].SubItems[0];
                          ListParam := GetParam(text);
                          Text := ListParam.param[1];
                          end;
                     end;
             if Text <> ''
             then DynOrder[index].GetInfoFromSMacro(Pchar('Objet name'),Pchar(Text),0,True)
             else  DynOrder[index].GetInfoFromSMacro(Pchar('Objet name'),'',0,False);
             end;
     else DynOrder[index].GetInfoFromSMacro('','',0,False);
end;

end;

procedure TForm1.GiveListOrder(var message: Tmessage);
var index : integer;
List : TListView;
begin
if SousMacroExecute = nil
then List := ListView1 else List := SousMacroExecute;
if not (List is TListView)
then begin form1.ShowApplicationError('Perte de référence de la sous macro.'); Exit; end;

index := GetNewOrderIndex(message.wParam);
if List.Items[message.LParam-1] = nil
then DynOrder[index].GetListOrder('','',False)
else DynOrder[index].GetListOrder(Pchar(List.Items[message.LParam-1].Caption),Pchar(List.Items[message.LParam-1].SubItems[0]),True);
end;

procedure TForm1.DLL_POS_ORDER(var message: Tmessage);
var index : integer;
List : TListView;
Pos : integer;
begin
GetActiveMacro(List,Pos);
index := GetNewOrderIndex(message.wParam);
if message.LParam = 0
then begin // demande la position Courante de la macro
     if (List.Name = 'ListView1')
     then DynOrder[index].GetInfoFromSMacro('Pos Order','',Pos_command+1,True)
     else DynOrder[index].GetInfoFromSMacro('Pos Order','',SousMacroExecuteIndex+1,True);
     end
else // Détourne la position courante de la macro
     if (message.LParam > 0) and (message.LParam <= List.Items.Count)
     then begin
          if (List.Name = 'ListView1')
          then Pos_command := message.LParam-1
          else begin SousMacroExecuteIndex := message.LParam; DLL_POS_ORDER_CHANGE := True; end;
          end;
end;

procedure TForm1.StopUnderMacro(var Message: TMessage);
begin
Stop1.Click;
end;

procedure TForm1.StatusBar1DrawPanel(StatusBar: TStatusBar; Panel: TStatusPanel; const Rect: TRect);
var MyBmp : TIcon;
    IconLng : TPicture;
    Lng : String;
begin
if Panel = StatusBar1.Panels[0]
then StatusBar1.Panels[0].text := GetLongFilename(StatusBar1.Panels[0].text);
  if Key <> ''
  then begin
       MyBmp := TIcon.Create;
       try
       Imagelist3.GetIcon(32,MyBmp);
       Statusbar1.Canvas.Draw(StatusBar1.Panels[0].Width +8,2,MyBmp);
       finally MyBmp.Free; end;
       end;

     Lng := '??';
     if form19.ComboBox3.Text = 'Français' then Lng := 'FR';
     if form19.ComboBox3.Text = 'English' then Lng := 'EN';

       IconLng := TPicture.Create;
       try
       IconLng.Bitmap.Height := 14;
       IconLng.Bitmap.Width := 22;
       IconLng.Bitmap.Canvas.Brush.Style := bsSolid;
       IconLng.Bitmap.Canvas.Brush.Color := clNavy;
       IconLng.Bitmap.Canvas.Rectangle(0,0,IconLng.Bitmap.Width,IconLng.Bitmap.Height);
       IconLng.Bitmap.Canvas.Font.Color := clWhite;
       IconLng.Bitmap.Canvas.TextOut(2,1,Lng);
       Statusbar1.Canvas.Draw(StatusBar1.Panels[0].Width+ StatusBar1.Panels[1].Width +6,4,IconLng.Graphic);
       finally IconLng.Free; end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
CanClose := SaveBeforeExit;
end;

procedure TForm1.MiseenForme1Click(Sender: TObject);
var Texte, start : string;
    countstart,i,j  : integer;
begin
if ListView1.Selected = nil then Exit;
unit1.sw_modif := True;
try
if ListView1.SelCount > 1 then AddHistory(0,'Début d''actions groupées','','');
for j := 0 to ListView1.Items.Count-1
do begin
   // Exclus les éléments non seléctionnés
   if ListView1.Items[j].Selected = False
   then continue;
   // Mise en form sous format ***** Texte *****
   texte := ListView1.Items[j].SubItems[0];
   unit1.Save_caption := texte;
   countstart := (ListView1.Columns[1].Width - listview1.Canvas.TextWidth(texte)) div listview1.Canvas.TextWidth('*');
   countstart := (countstart-4) div 2;
   start := '';
   for i := 1 to countstart do start := start +'*';
   texte := start +' ' +texte+ ' '+ start;
   ListView1.Items[j].SubItems[0] := texte;
   Form1.SaveBeforeChange(Form1.ListView1.Items[j]);
   end;

if ListView1.SelCount > 1 then AddHistory(0,'Fin d''actions groupées','','');
finally unit1.sw_modif := False; end;
end;

procedure TForm1.ListView1Enter(Sender: TObject);
begin
SpeedButton108.Enabled := fileexists(ExtractFileDir(Application.ExeName)+'\clipboard.tmp');
end;

procedure TForm1.Gestiondesnouvellecommandes1Click(Sender: TObject);
begin
Options1.Click;
Form19.PageControl1.ActivePage := Form19.TabSheet9;
Form19.PageControl1.OnChange(Form19.PageControl1);
end;

procedure TForm1.HotKeyManager1HotKeyPressed(HotKey: Cardinal;
  Index: Word);
var ImageBureau:TPicture;
    Pt : Tpoint;
    Rect : TRect;
    HwndDc : HDC;
    ResultMsg : integer;
begin
// pause
if HotKey = Form19.HotKey1.HotKey
then begin
     ContextOfExecute.ExecutionType :=  ContextOfExecute.Pause;
     Form1.Caption := Form1CaptionUpdate;
     ResultMsg :=  MessageDlg('Voulez-vous reprendre l''exécution?',mtConfirmation, [mbYes, mbAbort], 0);
     ContextOfExecute.ExecutionType :=  ContextOfExecute.Run;
     Form1.Caption := Form1CaptionUpdate;
     if ResultMsg = mrAbort
     then SpeedButton105.Click;//SpeedButton29.Click;
     end;
// arret
if HotKey = Form19.HotKey2.HotKey
then begin
     ResultMsg :=  MessageDlg('Souhaitez-vous réellement stopper l''exécution?',mtConfirmation, [mbYes, mbNo], 0);
     if ResultMsg = mrYes then SpeedButton105.Click;
     end;

if HotKey = ShortCut(VK_numLock,[])
then begin
     HotKeyManager1.RemoveHotKey(ShortCut(VK_NumLock,[]));
     KeyBD_event(VK_numLock, $45, 0, 0);
     Application.processMessages;
     HotKeyManager1.AddHotKey(ShortCut(VK_NumLock,[]));
     if ((GetKeyState(VK_NUMLOCK) and $01) <> 0) then form4.Shape1.Brush.Color := ClLime else form4.Shape1.Brush.Color := clWhite;
     end;
if HotKey = ShortCut(VK_Capital,[])
then begin
     HotKeyManager1.RemoveHotKey(ShortCut(VK_Capital,[]));
     KeyBD_event(VK_capital, $45, 0, 0);
     Application.processMessages;
     HotKeyManager1.AddHotKey(ShortCut(VK_Capital,[]));
     if ((GetKeyState(VK_Capital) and $01) <> 0) then form4.Shape2.Brush.Color := ClLime else form4.Shape2.Brush.Color := clWhite;
     end;

if Form5.Visible = True
then if HotKey = Form5.HotKey1.HotKey
     then if Unit5.Stop = True
     then begin
          form5.PosCur;
          ImageBureau := TPicture.Create;
          HwndDc := GetDC(GetDesktopWindow);
          try
          ImageBureau.Bitmap.Width := Screen.Width;
          ImageBureau.Bitmap.Height := Screen.Height;
          GetCursorPos(Pt);
          Rect.Left := Pt.X -(Form5.Image1.Width div 2); Rect.Top := Pt.Y-(Form5.Image1.Height div 2);
          Rect.Right := Pt.X+(Form5.Image1.Width);       Rect.Bottom := Pt.Y+(Form5.Image1.Height);
          BitBlt(ImageBureau.Bitmap.Canvas.Handle,0,0,Rect.Right,Rect.Bottom,HwndDc,Rect.Left,Rect.Top,SrcCopy);
          Form5.DrawCursor(ImageBureau.Bitmap);
          Form5.Image1.Picture.Bitmap := ImageBureau.Bitmap;

          finally ImageBureau.Free; ReleaseDC(GetDesktopWindow, HwndDc);end;
          end
     else Unit5.Stop := True;

if HotKey = ShortCut(VK_SNAPSHOT,[])
then begin
     form22.image2.Visible := False;
     form22.image3.Visible := False;
     form22.image4.Visible := False;
     form22.image5.Visible := False;
     application.ProcessMessages;

     ImageBureau := TPicture.Create;
     try
     ImageBureau.Bitmap.Width := Screen.Width;
     ImageBureau.Bitmap.Height := Screen.Height;
     BitBlt(ImageBureau.Bitmap.Canvas.Handle,0,0,Screen.Width,Screen.Height,GetDC(GetDesktopWindow),0,0,SrcCopy);
     Clipboard.Assign(ImageBureau);
     finally ImageBureau.Free; end;

     Form22.Button1.Enabled := Clipboard.HasFormat(CF_BITMAP);

     form22.image2.Visible := True;
     form22.image3.Visible := True;
     form22.image4.Visible := True;
     form22.image5.Visible := True;

     end;

end;

procedure TForm1.N01Click(Sender: TObject);
var i,j : integer;
begin
i := ((PaintBox1MouseY) div 17) + ListView1.TopItem.Index-1;
if (i < Low(TabInfoListView)) or (i > High(TabInfoListView))
then Exit;
for j := Low(TabInfoListView) to High(TabInfoListView)
do if TabInfoListView[j].SignetNr = TMenuItem(Sender).Tag
   then TabInfoListView[j].SignetNr := -1;
TabInfoListView[i].SignetNr := TMenuItem(Sender).Tag;
InfoListViewDraw;
end;

procedure TForm1.N02Click(Sender: TObject);
var i : integer;
begin
for i := Low(TabInfoListView) to High(TabInfoListView)
do if TabInfoListView[i].SignetNr = TMenuItem(Sender).Tag
   then  Select_Unique(ListView1,i);
end;

procedure TForm1.N2Click(Sender: TObject);
var WinCtrl : TWinControl;
begin
WinCtrl := ObjectPopMenu;
if WinCtrl <> nil
then begin
     if WinCtrl is TComboBox 
     then TComboBox(WinCtrl).SelectAll;
     if WinCtrl is TEdit
     then TEdit(WinCtrl).SelectAll;
     end
else begin
     if ListView1.Visible = True
     then begin
          ListView1.SetFocus;
          ListView1.SelectAll;
          end;
     end;
end;


function TForm1.ExporterversexecutableAddFile(List: TListView) : boolean;
var i,j,k : integer;
   params : Tparam;
   item : TListItem;
   Order : TOrdre;
   Exists : Boolean;
const exclude : array[1..3] of string = ('Label','Goto','Type');
begin
Form33.ListView1.Clear;
if List = nil then List := Form1.ListView1;
for i := 0 to List.Items.Count -1
do begin
   Order.commande := List.Items[i].Caption;
   for j := 1 to length(exclude)
   do if Order.commande = exclude[j] then continue;
   Order.textparam := List.Items[i].SubItems[0];
   Params := GetParam(Order.textparam);
   for j := 1 to params.nbr_param-1
   do if FileExists(params.param[j])
      then begin
           // control si le fichier n'est pas deja listé
           if ExtractFileExt(params.param[j]) = '.exe'
           then continue;
           Exists := False;
           for k := 0 to Form33.ListView1.Items.Count-1
           do if Form33.ListView1.Items[k].Caption = params.param[j]
              then Exists := True;
           //Ajout
           if Exists = False
           then begin
                Item := Form33.ListView1.Items.Add;
                Item.Caption := params.param[j];
                Item.Checked := True;
                end;
           end;
   end;
//if form33.ListView1.Items.Count = 0 then exit;
form33.ShowModal;
if unit33.CloseBy =mbcancel
then result := False else result := True;
end;

procedure TForm1.AssignFileDirToVar(fic :String);
const exclude : array[1..3] of string = ('Label','Goto','Type');
var Order,Order2 : TOrdre;
    i,j : integer;
    params : Tparam;
    TmpLView : TListView;
function VirtualDirectoryName(Name:String) : String;
var repertoire,Lecteur : String;
begin
repertoire := ExtractFileDir(Name);
lecteur := ExtractFileDrive(Name);
repertoire := copy(repertoire,length(lecteur)+1,length(repertoire));
lecteur := copy(lecteur,0,length(lecteur)-1);
result := lecteur+repertoire;
end;
begin
TmpLView := TListView.Create(form23);
try
TmpLView.Parent := form23;
TmpLView.Align := alClient;
TmpLView.ViewStyle := vsReport;
TmpLView.Columns.Add;
TmpLView.Columns.Add;
TmpLView.LargeImages := Form1.ImageList1;
TmpLView.SmallImages := Form1.ImageList1;
TmpLView.StateImages := Form1.ImageList1;
TmpLView.Items.Assign(ListView1.Items);

Order.commande := 'Variable';
Order.textparam := '[SYSDIR.CURRENTMACRO]'+SprPR+SprPr+TAlpha+SprPr;
Form1.Insert_commande(TmpLView,Order,0);

for i := 1 to 20 // ajout des variables FileDirToVar.1 à FileDirToVar.20
do begin
   Order.textparam := '[VIRTUALFILEDIR'+IntToStr(i)+']'+SprPR+SprPr+TAlpha+SprPr;
   Insert_commande(TmpLView,Order,i);
   end;

for j := TmpLView.Items.Count-1 downto 0
do begin
   Order.commande := TmpLView.items[j].Caption;
   Order.textparam := TmpLView.Items[j].SubItems[0];
   for i := 1 to length(exclude)
   do if Order.commande = exclude[i] then continue;
   Params := GetParam(Order.textparam);
   for i := 1 to params.nbr_param-1
   do if Form33.FileChecked(params.param[i])
      then begin
           TmpLView.Items[j].SubItems[0] := StringReplace(Order.textparam,params.param[i],'[VIRTUALFILEDIR'+IntToStr(i)+']',[rfReplaceAll, rfIgnoreCase]);
           Order2.commande := 'Calcul évolué';
           Order2.textparam:= '[VIRTUALFILEDIR'+IntToStr(i)+']'+'=[SYSDIR.CURRENTMACRO]+\'+VirtualDirectoryName(params.param[i])+'\'+ ExtractFileName(params.param[i]);
           Insert_commande(TmpLView,Order2,j);
           end;
   end;
SaveDialog1.FileName := ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.AssignFileDirToVar');
SaveMacro(TmpLView);
SaveDialog1.FileName := Form1.StatusBar1.Panels[0].Text;

finally TmpLView.Free; end;

end;



procedure TForm1.Exporterversexecutable1Click(Sender: TObject);
var Archive : TResourcesMaker;
    FExport, FSource, FFrom : String;
    ListFile : TStringList;
    i,j,k : integer;
    ConfigIni: TIniFile;
    VirtualDir : string;
    Param : TParam;
function VirtualDirectoryName(Name:String) : String;
var repertoire,Lecteur : String;
begin
repertoire := ExtractFileDir(Name);
lecteur := ExtractFileDrive(Name);
repertoire := copy(repertoire,length(lecteur)+1,length(repertoire));
lecteur := copy(lecteur,0,length(lecteur)-1);
result := lecteur+repertoire;
end;
begin

if Authen(ExtractFileDir(Application.ExeName)+'\MdlAE.exe') <> 1
then Exit;

if not ExporterversexecutableAddFile(ListView1)
then Exit;

// modification de la macro pour fichiers virtuel
j := 0;
for i := 0 to Form33.ListView1.Items.Count -1
do if Form33.ListView1.Items[i].Checked = True then Inc(j);
if j > 0
then AssignFileDirToVar(Form1.StatusBar1.Panels[0].Text)
else CopyFile(Pchar(Form1.StatusBar1.Panels[0].Text),Pchar(ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.AssignFileDirToVar')),False);
//ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.AssignFileDirToVar');

Archive := TResourcesMaker.Create(ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.~exe'), '');
ListFile := TStringList.Create;
FExport := ExtractFileDir(Application.ExeName)+'\Export';
CreateDir(FExport);
try
//Archive.GeneralProgressBar := Form29.ProgressBar1;
Archive.FileProgressBar := Form29.ProgressBar1;
Archive.CompressionLevel := 0;
Archive.TempPath := FExport;
Form29.Label1.Caption := 'Exportation de la macro vers exécutable, patientez SVP...';
Form29.Show;
Form29.Repaint;
Application.ProcessMessages;

//Ajout des fichiers Supplementaires
for i := 0 to Form33.ListView1.Items.Count-1
do if Form33.ListView1.Items[i].Checked = True
   then begin
        FSource := form33.ListView1.Items[i].Caption;
        if form33.ListView1.Items[i].Indent = 0 // determine si c'est un fichier ajouté par l'utilisateur
        then begin
             VirtualDir := FExport + '\'+ VirtualDirectoryName(form33.ListView1.Items[i].Caption);
             ForceDirectories(VirtualDir);
             FFrom := VirtualDir+'\'+ExtractFileName(form33.ListView1.Items[i].Caption);
             end
        else FFrom := FExport +'\'+ExtractFileName(form33.ListView1.Items[i].Caption);
        CopyFile(PChar(FSource),PChar(FFrom),False); ListFile.Add(FFrom);
        end;


// Ajout du programme Super macro
FSource := Application.ExeName; FFrom := FExport +'\super_macro.exe';
if not CopyFile(PChar(FSource),PChar(FFrom),False)
then begin form1.ShowApplicationError('Fichier '+FSource +' introuvable.'); Exit; end;
ListFile.Add(FFrom);

// Ajout de la macro
FSource := ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.AssignFileDirToVar'); FFrom := FExport +'\'+ExtractFileName(Form1.StatusBar1.Panels[0].Text);
if not CopyFile(PChar(FSource),PChar(FFrom),False)
then begin form1.ShowApplicationError('Fichier '+FSource +' introuvable.'); Exit; end;
ListFile.Add(FFrom);
// Ajout fichier lng
if form19.Combobox3.Text <> 'Français'
then begin
     FSource := form19.Combobox3.Text+'.lng'; FFrom := FExport + '\'+ form19.Combobox3.Text+'.lng';
     CopyFile(PChar(FSource),PChar(FFrom),False); ListFile.Add(FFrom);
     end;
// Ajout fichier configuration
// Attention fichier ajouté en dernier pour modification
FSource := Form19.Label22.Caption; FFrom := FExport + '\config.ini';
CopyFile(PChar(FSource),PChar(FFrom),False);
ListFile.Add(FFrom);


ConfigIni := TIniFile.Create(FFrom);
try
ConfigIni.EraseSection('DynOrder');
ConfigIni.EraseSection('Recents');
ConfigIni.EraseSection('Outils');
ConfigIni.WriteString('MAJ','Run','False');
ConfigIni.WriteString('Control','Rapport','False');
// Ajout de Clavier_Hook.dll et Souris_Hook.dll si necessaire
k := 0;
for i := 0 to ListView1.Items.Count-1
do begin
   if (ListView1.Items[i].Caption = 'Variable')
   then begin
        Param := GetParam(ListView1.Items[i].SubItems[0]);
        if Param.param[1] = '[EVENT.ACTIVATE]' then begin k := 1; break; end;
        end;
   end;

if k = 1
then begin
     FSource := ExtractFileDir(Application.ExeName)+'\Souris_Hook.dll';
     FFrom := FExport + '\' + ExtractFileName(FSource);
     CopyFile(PChar(FSource),PChar(FFrom),False);
     ListFile.Add(FFrom);
     FSource := ExtractFileDir(Application.ExeName)+'\Clavier_Hook.dll';
     FFrom := FExport + '\' + ExtractFileName(FSource);
     CopyFile(PChar(FSource),PChar(FFrom),False);
     ListFile.Add(FFrom);
     end;
// recherche des plugins utilisé dans la macro courante
k := 0;
for i := 0 to length(DynOrder)-1
do begin
   for j := 0 to ListView1.Items.Count-1
   do if ListView1.Items[j].Caption = DynOrder[i].Name
      then begin
           FSource := DynOrder[i].dllName;
           FFrom := FExport + '\' + ExtractFileName(DynOrder[i].dllName);
           CopyFile(PChar(FSource),PChar(FFrom),False);
           ListFile.Add(FFrom);
           ConfigIni.WriteString('DynOrder', IntToStr(k) ,ExtractFileName(DynOrder[i].dllName));
           Inc(k);
           break;
           end;
   end;
finally ConfigIni.Free; end;
for i := 0 to ListFile.Count-1
do ListFile[i] := Copy(ListFile[i],length(Archive.TempPath)+1,length(ListFile[i]));
for i := 0 to ListFile.Count-1
do begin
   Archive.AddFile(Archive.TempPath+ListFile[i],ListFile[i],True);
   end;
//Archive.AddFiles(ListFile, True);
Archive.MakeAutoExtract(ExtractFileDir(Application.ExeName)+'\MdlAE.exe');
finally
   Form29.Close;
   Archive.Free;
   ListFile.Free;
   if FileExists(ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.~exe'))
   then DeleteFile(ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.~exe'));
   if FileEXists(ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.AssignFileDirToVar'))
   then DeleteFile(ChangeFileExt(Form1.StatusBar1.Panels[0].Text,'.AssignFileDirToVar'));
end;

end;

procedure TForm1.ComboBox1Change(Sender: TObject);
var FileExt, FileName : String;
begin
FileExt := ExtractFileExt(RapportFileName);
FileName := ChangeFileExt(RapportFileName,'') + ComboBox1.Text+ FileExt;
if FileExists(FileName) = True
then RichEdit1.Lines.LoadFromFile(FileName)
else if FileExists(RapportFileName) then RichEdit1.Lines.LoadFromFile(RapportFileName)
                                      else begin
                                           RichEdit1.Clear;
                                           RichEdit1.Lines.Add('Report file is not found !');
                                           end;
end;


procedure TForm1.SpeedButton27Click(Sender: TObject);
var i,index : integer;
begin
if ListView4.Tag >= 0
then if ListView4.Selected = nil
     then ListView4.Items[ListView4.Tag].Selected := True;
if ListView4.Selected = nil then Exit;

index := -1;
for i := ListView4.Selected.Index+1 to ListView4.Items.Count -1
do if (ListView4.Items[i].SubItems[0] = 'Début d''actions groupées')
   or (ListView4.Items[i].SubItems[0] = 'Fin d''actions groupées')
   then begin index := i; break; end;

if index < 0 then Index := ListView4.Items.Count -1
else begin
     if ListView4.Items[index+1] <> nil
     then begin
          if (ListView4.Items[index+1].SubItems[0] = 'Début d''actions groupées')
          or (ListView4.Items[index+1].SubItems[0] = 'Fin d''actions groupées')
          then Inc(Index);
          end;
     end;
Select_Unique(ListView4,Index);
ListView4.OnClick(self);
end;

procedure TForm1.SpeedButton26Click(Sender: TObject);
var i,index : integer;
begin
if ListView4.Tag >= 0
then if ListView4.Selected = nil
     then ListView4.Items[ListView4.Tag].Selected := True;
if ListView4.Selected = nil then Exit;

index := -1;
for i := ListView4.Selected.Index-1 downto 0
do if (ListView4.Items[i].SubItems[0] = 'Début d''actions groupées')
   or (ListView4.Items[i].SubItems[0] = 'Fin d''actions groupées')
   then begin index := i; break; end;

if index < 0
then index := 0
else begin
     if ListView4.Items[index-1] <> nil
     then begin
          if (ListView4.Items[index-1].SubItems[0] = 'Début d''actions groupées')
          or (ListView4.Items[index-1].SubItems[0] = 'Fin d''actions groupées')
          then Dec(Index);
          end;
     end;

Select_Unique(ListView4,Index);
ListView4.OnClick(self);
end;

procedure TForm1.Sauvegardeducontextedexcution1Click(Sender: TObject);
var AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
    ContextDir : String;
begin
ContextDir := ExtractFileDir(application.ExeName)+'\Sauvegarde context d''exécution';

if not DirectoryExists(ContextDir) then
if not CreateDir(ContextDir)
then ShowApplicationError(ContextDir + ' can''t be create.');
OpenDialog2.InitialDir := ContextDir;
if ContextOfExecute.ExecutionType <>  ContextOfExecute.NotRun
then begin
     OpenDialog2.Filter := 'Executable & macro|*.exe;*.mcr|Executable|*.exe|Macro|*.mcr|Tous|*.*';
     OpenDialog2.Filter := 'Fichier contextuel d''execution (*.ctx)|*.ctx|Tous|*.*';
     OpenDialog2.FilterIndex := 1;
     DecodeDateTime(now, AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond);
     OpenDialog2.FileName := ExtractFileName(StatusBar1.Panels[0].Text)+ ' ' + IntToStr(ADay) +'_'+ IntToStr(AMonth) +
                 '_' + IntToStr(AYear) +' '+ IntToStr(AHour) +
                 '_' + IntToStr(AMinute) +'_'+ IntToStr(ASecond);
     if OpenDialog2.Execute
     then ContextOfExecute.SaveContext(OpenDialog2.FileName);
     end
else begin
     OpenDialog2.Filter := 'Executable & macro|*.exe;*.mcr|Executable|*.exe|Macro|*.mcr|Tous|*.*';
     OpenDialog2.Filter := 'Fichier contextuel d''execution (*.ctx)|*.ctx|Tous|*.*';
     OpenDialog2.FilterIndex := 1;
     if OpenDialog2.Execute
     then begin
          ContextOfExecute.FileName := OpenDialog2.FileName;
          form1.Execute(nil,True);
          end;
     end;
end;

procedure TForm1.SpeedButton29Click(Sender: TObject);
begin
// Test le maintien de pression de touche Shift, Crt, Alt
if (GetKeyState(VK_SHIFT) and $01) <> 0
then KeyBD_event(VK_SHIFT, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
if (GetKeyState(VK_CONTROL) and $01) <> 0
then KeyBD_event(VK_CONTROL, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);
if (GetKeyState(VK_MENU) and $01) <> 0
then KeyBD_event(VK_MENU, $45, KeyEventf_ExtendedKey Or KeyEventf_KeyUp,0);

          if WaitRedFlag = False
          then Oldfenetre := GetForegroundWindow;
          WaitRedFlag := not WaitRedFlag;
          Select_Unique(ListView1,Pos_Command);
          FnctPause('500;MilliSec;');
          if application_close = False
          then ForceForegroundWindow(Application.MainForm.Handle);

          ContextOfExecute.ExecutionType :=  ContextOfExecute.Pause;
          Form1.Caption := Form1CaptionUpdate;

          SpeedButton103.Enabled := True;
          SpeedButton29.Enabled := False;
          While WaitRedFlag = True
          do begin
             SleepEX(200,False);
             Application.ProcessMessages;
             end; // pause 0% cpu

          SpeedButton103.Enabled := False;
          SpeedButton29.Enabled := True;

          ContextOfExecute.ExecutionType :=  ContextOfExecute.Run;
          Form1.Caption := Form1CaptionUpdate;

          ForceForegroundWindow(oldfenetre);
          FnctPause('500;MilliSec;');
end;

Procedure TForm1.ContextMenuOnClick(Sender : TObject);
var ContextDir : String;
    ContextFile : String;
    ContextFilename : String;
begin
if not (Sender is TMenuItem) then Exit;
ContextFile := (Sender as TMenuItem).Caption;
ContextDir := ExtractFileDir(application.ExeName)+'\Sauvegarde context d''exécution\';
ContextFilename := ContextDir + ContextFile;
ContextOfExecute.FileName := ContextFilename;
form1.Execute(nil,True);
end;

procedure TForm1.SpeedButton36Click(Sender: TObject);
var pnt : Tpoint;
    FicContextList : Textfile;
    Context : String;
    ContextMenu : TMenuItem;
begin
PopUpMenu7.Items.Clear;
ScruteDossier(0,ExtractFileDir(application.ExeName)+'\Sauvegarde context d''exécution','*.ctx',0,False,ExtractFileDir(application.ExeName)+'\ctxList.lst');
if fileExists(ExtractFileDir(application.ExeName)+'\ctxList.lst')
then begin
     assignFile(FicContextList,ExtractFileDir(application.ExeName)+'\ctxList.lst');
     reset(FicContextList);
     while not eof(FicContextList)
     do begin
        readln(FicContextList,Context);
        ContextMenu := TMenuItem.Create(self);
        ContextMenu.AutoHotkeys := maManual;
        ContextMenu.Caption := ExtractFileName(Context);
        ContextMenu.onClick := ContextMenuOnClick;
        if LoadContextSimpleInfo(Context).MacroName = StatusBar1.Panels[0].Text
        then PopUpMenu7.Items.Add(ContextMenu);
        end;
        closeFile(FicContextList);
        deletefile(ExtractFileDir(application.ExeName)+'\ctxList.lst');
     end;

pnt := point(SpeedButton103.left,SpeedButton103.Top+SpeedButton103.Height+2);
pnt := Form1.ClientToScreen(pnt);
PopUpMenu7.Popup(pnt.x,pnt.y);
end;

procedure TForm1.SpeedButton37Click(Sender: TObject);
begin
Form25.Show;
end;


procedure TForm1.Collerapartirduntextesimple1Click(Sender: TObject);
var List : TStringList;
    Ordre : TOrdre;
    i,j : integer;
    com, correct : string;
begin
if clipboard.HasFormat(CF_TEXT)
then begin
     List := TStringList.Create;
     try
     List.SetText(Pchar(clipboard.AsText));
     if List.Count > 1 then AddHistory(0,'Début d''actions groupées','','');

     For i := 0 to List.Count-1
     do begin
        if List[i] = '' then continue;
        Ordre.commande := '';
        Ordre.textparam := '';
        com := '';
        correct := '';

        for j := 1 to length(List[i])
        do begin
           if (List[i][j] = chr(VK_SPACE)) or (List[i][j] = chr(VK_TAB)) or (j = length(List[i]))
           then begin
                if j = length(List[i]) then com := com + List[i][j];
                Ordre.commande := com;
                if GetImageindex(Ordre) >= 0
                then correct := com;
                Ordre.commande := Trim(com);
                if GetImageindex(Ordre) >= 0
                then correct := Trim(com);

                end;
           com := com + List[i][j];

           end;
           if correct <> ''
           then begin
                Ordre.commande := correct;
                Ordre.textparam :=  RightStr(List[i], length(List[i])-length(correct)-1);
                Ordre.textparam := Trim(Ordre.textparam);
                Add_Insert(Ordre.commande,Ordre.textparam,GetImageindex(Ordre));
                end
           else begin
                if ListView1.Items.Count > 0
                then ListView1.Items[ListView1.Items.Count-1].SubItems[0] := ListView1.Items[ListView1.Items.Count-1].SubItems[0] + TrimRight(List[i])
                else begin
                     Ordre.commande := '';
                     Ordre.textparam := List[i];
                     Ordre.textparam := Trim(Ordre.textparam);
                     Add_Insert(Ordre.commande,Ordre.textparam,31);
                     end;
                end;
        end;
     if List.Count > 1 then AddHistory(0,'Fin d''actions groupées','','');
     ListView1.Items.EndUpdate;
     ListView4.Items.EndUpdate;
     finally List.Free; end;
     end;
end;

procedure TForm1.Copier4Click(Sender: TObject);
begin
RichEdit1.CopyToClipboard;
end;

procedure TForm1.Slctionnertout2Click(Sender: TObject);
begin
RichEdit1.SelectAll;
end;

procedure TForm1.MParcours();
var i : integer;
    DC:HDC;
    Icon : TIcon;
    x,y : string;
    First, Second : Boolean;
    Param : String;
begin
if ListView1.Selected = nil then Exit;
x := ''; y := '';
First := True;
Second := True;
Param := ListView1.Selected.SubItems[0];
Icon := TIcon.Create;
Icon.SetSize(8,8);
ImageList1.GetIcon(GetImageIndex('Parcours souris'), Icon);
DC:=GetDc(0);
try
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
        windows.DrawIcon(Dc,StrToInt(x),StrToInt(y),Icon.Handle);
        x := ''; y := '';
        First := True;
        Second := True;
        end;
   end;

finally ReleaseDc(0,DC); Icon.Free; end;
end;

procedure TForm1.GetBitmapFromResAll;
type TGetBitmap = function (name : Pchar) : hBitmap ; StdCall;
var i : integer;
    SBtn : TSpeedButton;
    Bitmap : TBitmap;
    GetBitmapFromRes : TGetBitmap;
    Handle : THandle;
    fileRes : String;
    ICONRUNLARG,ICONRUNSMALL : hicon;
begin

HICONSTD := Application.Icon.Handle;
ICONRUN := TIcon.Create;
ICONRUN.Handle := HICONSTD;

FileRes := ExtractFileDir(Application.ExeName)+'\ressources.dll';
if not FileExists(FileRes) then Exit;
Handle := LoadLibrary(Pchar(FileRes));
if Handle = 0 then Exit;
@GetBitmapFromRes := GetProcAddress(Handle, 'GetBitmap');
if @GetBitmapFromRes = nil then Exit;

Form19.Image6.Picture.Bitmap.Handle := GetBitmapFromRes('ECRAN');

if Xpmenu1.Active = True
then begin
//Format standard de la touche de clavier
Form4.SpeedButton1.Glyph.Handle := GetBitmapFromRes('KEY');
// Pour les autres touches
Form4.SpeedButton70.Glyph.Handle := GetBitmapFromRes('KEY22PAR38');
Form4.SpeedButton31.Glyph.Handle := GetBitmapFromRes('KEY22PAR38');
Form4.SpeedButton110.Glyph.Handle := GetBitmapFromRes('KEY22PAR38');
Form4.SpeedButton8.Glyph.Handle := GetBitmapFromRes('KEY22PAR38');
Form4.SpeedButton2.Glyph.Handle := GetBitmapFromRes('KEY22PAR38');
Form4.SpeedButton71.Glyph.Handle := GetBitmapFromRes('KEY22PAR198');
Form4.SpeedButton30.Glyph.Handle := GetBitmapFromRes('KEY22PAR49');
Form4.SpeedButton72.Glyph.Handle := GetBitmapFromRes('KEY46PAR33');
Form4.SpeedButton9.Glyph.Handle := GetBitmapFromRes('KEY22PAR57');
Form4.SpeedButton91.Glyph.Handle := GetBitmapFromRes('KEY46PAR23');
Form4.SpeedButton87.Glyph.Handle := GetBitmapFromRes('KEY46PAR23');
Form4.SpeedButton92.Glyph.Handle := GetBitmapFromRes('KEY22PAR49');
end;
for i := 1 to 110
do begin
   SBtn := (Form4.findComponent('SpeedButton'+ Inttostr(i)) as TSpeedButton);
   if SBtn = nil then continue;
   if SBtn.Glyph.Empty = True
   then begin
        SBtn.Glyph := form4.SpeedButton1.Glyph;
        end;
   end;

Bitmap := TBitmap.Create;
try
Bitmap.Handle := GetBitmapFromRes('SOURIS');
Form6.ImageList1.Add(Bitmap,nil);
finally Bitmap.Free; end;

Form7.Image1.Picture.Bitmap.Handle := GetBitmapFromRes('HORLOGE');
Form7.image2.Picture.Bitmap := Form7.image1.Picture.Bitmap;

if ExtractIconEx(PChar(FileRes),0,ICONRUNLARG,ICONRUNSMALL,1) <> 1
then ICONRUN.Handle := ICONRUNSMALL;
end;

procedure TForm1.OneVarOnly(VarName : String; List : TListView = nil);
var find : Boolean;
    VList : TListView;
    i : integer;
    Param : TParam;
begin
if List <> nil
then VList := List
else VList := ListView1;

find := False;
for i := 0 to VList.Items.Count -1
do begin
   if VList.Items[i] = nil then continue;
   if VList.Items[i].Caption = 'Variable'
   then begin
       Param := GetParam(VList.Items[i].SubItems[0]);
       if (Param.param[1] = VarName) and (find = True)
       then VList.Items[i].Delete;
       if (Param.param[1] = VarName) and (find = False)
       then Find := True;
       end;
   end;
end;

procedure TForm1.LoadPrintMacro(fileName : String);
var first, i : integer;
   RichEditPrint : TRichEdit;
begin
RichEditPrint := TRichEdit.Create(self);
RichEditPrint.Parent := Form19;
RichEditPrint.Clear;

try
for i := 0 to ListView1.Items.Count-1
do begin
    First := RichEditPrint.GetTextLen;
    RichEditPrint.Lines.Append(ListView1.Items[i].Caption +chr(VK_TAB)+ ListView1.Items[i].SubItems[0]);
    RichEditPrint.SelStart := First;
    RichEditPrint.SelLength := length(ListView1.Items[i].Caption);

    RichEditPrint.SelAttributes.Style := Form19.Label13.Font.Style;
    RichEditPrint.SelAttributes.Color := Form19.Label13.Font.Color;
    RichEditPrint.SelAttributes.Size := Form19.Label13.Font.Size;
    RichEditPrint.SelAttributes.Name := Form19.Label13.Font.Name;
    RichEditPrint.SelAttributes.Height := Form19.Label13.Font.Height;

    RichEditPrint.SelStart := First+length(ListView1.Items[i].Caption)+1 ;
    RichEditPrint.SelLength := length(ListView1.Items[i].SubItems[0]);

    RichEditPrint.SelAttributes.Style := Form19.Label14.Font.Style;
    RichEditPrint.SelAttributes.Color := Form19.Label14.Font.Color;
    RichEditPrint.SelAttributes.Size := Form19.Label14.Font.Size;
    RichEditPrint.SelAttributes.Name := Form19.Label14.Font.Name;
    RichEditPrint.SelAttributes.Height := Form19.Label14.Font.Height;
    end;
RichEditPrint.Lines.SaveToFile(FileName);
finally RichEditPrint.Free; end;
end;


procedure TForm1.Aperuavantimpression1Click(Sender: TObject);
var Fichier : string;
begin
Fichier := ExtractFileDir(Application.ExeName)+ '\pr~tmp.doc';
LoadPrintMacro(Fichier);
ShellExecute(0,'Open',  PChar(Fichier) ,PChar(''),'',SW_SHOWNORMAL)
end;

procedure TForm1.Imprimer1Click(Sender: TObject);
var Fichier :String;
begin
Fichier := ExtractFileDir(Application.ExeName)+ '\pr~tmp.doc';
LoadPrintMacro(Fichier);
ShellExecute(0,'Print',  PChar(Fichier) ,PChar(''),'',SW_SHOWNORMAL)
end;

procedure TForm1.DropMsg(var msg: TWMDropFiles);
var FileName: String;
    Files: Array[0..255] of Char;
begin
  DragQueryFile(Msg.Drop, $FFFFFFFF, Files, SizeOf(FileName));
  FileName:=copy(Files, 0, DragQueryFile(Msg.Drop, 0, Files, 255));
  //if extractFileExt(FileName) <> '.mcr' then ShowMessage('Vous ne pouvez ouvrir que des fichiers ayant l''extension .mcr');
  form1.OpenFileMacro(FileName,ListView1, -1,'Chargement des commandes en cours, veuillez patienter SVP.');
  Msg.Result:=0;
  DragFinish(msg.Drop);
end;

procedure TForm1.CodeToStd(FileName : String; ListView : TListView = nil);
var OtherLangEditor: TIniFile;
    OtherLangEditorFileName : String;
    fichier : textfile;
    Text, SousTextStr : String;
    i,j,k : integer;
    Ordre : TOrdre;
    Deb,Fin : integer;
    Str,Str2,Str3,SeparatorPrm,Prm,DebPrm,FinPrm, EndCommand, AffectationOperator: string;
    ListParam : TParam;
    Alias, AliasValue, SousText : TStringList;
    Bln : Boolean;
    Tmp : String;
begin
if ListView = nil then ListView := ListView1;
if not FileExists(FileName) then Exit;
assignFile(Fichier,FileName);
reset(Fichier);
Text := '';
while Text = ''
do begin
    readln(Fichier,Text);
    Text := Trim(Text);
    end;

Text := LowerCase(Text);
if Copy(Text,0,length('LangEditor='))= 'langeditor='
then Text := Copy(Text,length('LangEditor=')+1,length(Text))
else begin
     WriteMessage(ListView,0,SMsgDlgError,'Le paramètre LangEditor doit être spécifier en tête de fichier.',0);
     Exit;
     end;

if not FileExists(ExtractFileDir(Application.ExeName)+'\'+ Text)
then begin
     WriteMessage(ListView,0,SMsgDlgError,'Le fichier de linkage nommé "'+ Text +'" est introuvable.',0);
     Exit;
     end;

Alias := TStringList.create;
AliasValue := TStringList.create;
SousText := TStringList.create;

OtherLangEditorFileName := Text;
OtherLangEditor := TIniFile.Create(ExtractFileDir(Application.ExeName)+'\'+OtherLangEditorFileName);
try
SeparatorPrm := OtherLangEditor.ReadString('General','SeparatorPrm',SprPr);
EndCommand := OtherLangEditor.ReadString('General','EndCommand','');
if EndCommand = '' then EndCommand := #$D#$A;
Str := OtherLangEditor.ReadString('General','StringCar','''');
Prm := OtherLangEditor.ReadString('General','Parametre','');
if Prm = '' then Prm := chr(VK_Tab) + ' ';
AffectationOperator := OtherLangEditor.ReadString('General','AffectationOperator','=');
DebPrm := Prm[1]; FinPrm := Prm[2];

// récuperation des alias
OtherLangEditor.ReadSection('Alias',Alias);
OtherLangEditor.ReadSectionValues('Alias',AliasValue);
for i := 0 to Alias.Count-1
do AliasValue[i] := Copy(AliasValue[i],length(Alias[i])+2,length(AliasValue[i])-length(Alias[i])-1);


while not eof(Fichier)
do begin
   readln(Fichier,Text);
   Text := Trim(Text);
   if Text = '' then continue;
  // Sous Text
  SousText.Clear;
  SousTextStr := '';
  for i := 1 to length(Text)
  do begin
      SousTextStr := SousTextStr + Text[i];
      if Text[i] = EndCommand[1]
      then begin
           SousText.Add(Trim(SousTextStr));
           SousTextStr := '';
           end;
      end;
     if Text[length(Text)] <> EndCommand[1]
     then SousText.Add(Trim(SousTextStr));
// ANALYSE DU SOUS-TEXTE
  for j := 0 to SousText.Count -1
  do begin
     Text := SousText[j];
  // analyse dans le sous text

  // Recuper la partie commande pour renommage des alias
  k := Pos(DebPrm,Text);                     
  if k = 0 then k := length(Text);
  if k > 20 then k := 20;
  Str2 := Copy(Text,0,k-1);
  Str3 := Str2;
  Bln := False;
  for i := 0 to Alias.Count-1 do if Pos(Alias[i],Str2) <> 0 then Bln := True; // attention au Alias diminutif
  if Bln = False
  then begin
       for i := 0 to Alias.Count-1
       do begin
          if Str2 = Str3 then Str2 := StringReplace(Str2,AliasValue[i],Alias[i],[rfIgnoreCase]);
          end;
       end;

  Text := Str2 + Copy(Text,k,length(Text));

  if copy(Text,0,length('Commentaire')) = 'Commentaire'
  then begin
       Ordre.commande := 'Commentaire';
       Ordre.textparam := Text;
       for i := j+1 to SousText.Count-1
       do Ordre.textparam := Ordre.textparam + SousText[i];
       Ordre.textparam := Trim(Copy(Ordre.textparam,length('Commentaire')+1,length(Ordre.textparam)-length('Commentaire')));
       add_commande(ListView, Ordre);
       break;
       end;

  Deb := -1; Fin := -1;
  for i := 1 to length(Text)
  do begin
     if (Text[i] = DebPrm) and (Deb = -1) then Deb := i;
     if Text[i] = FinPrm then begin Fin := i+1; Text[i] := SprPr; end;
     if Text[i] = SeparatorPrm then Text[i] := SprPr;
     end;
  Ordre.commande := ''; Ordre.textparam := '';

  if Deb <> -1 then Ordre.commande := Trim(copy(Text,0,Deb-1)) else Ordre.commande := '';

  // commande pour les calculs évolués
  if AnsiPos(AffectationOperator,Text) <> 0
  then begin
       Tmp :=Trim(Copy(Text,0,AnsiPos(AffectationOperator,Text)-1));
       if FnctTypeVar(Tmp) <>TNo
       then begin
            Ordre.commande := 'Calcul évolué';
            Text := StringReplace(Text,AffectationOperator,'=',[rfIgnoreCase]);
            Ordre.textparam := Copy(Text,0,length(Text)-(length(AffectationOperator)-1));
            add_commande(ListView, Ordre);
            continue;
            end;
       end;

  if AnsiPos('+',Text) <> 0
  then begin
       Tmp :=Trim(Copy(Text,0,AnsiPos('+',Text)-1));
       if FnctTypeVar(Tmp) <> TNo
       then begin
            Ordre.commande := 'Calcul évolué';
            Ordre.textparam := Text;
            add_commande(ListView, Ordre);
            continue;
            end;
       end;
  if AnsiPos('-',Text) <> 0
  then begin
       Tmp :=Trim(Copy(Text,0,AnsiPos('-',Text)-1));
       if FnctTypeVar(Tmp) <> TNo
       then begin
            Ordre.commande := 'Calcul évolué';
            Ordre.textparam := Text;
            add_commande(ListView, Ordre);
            continue;
            end;
       end;

  if (Ordre.commande = 'Label') or (Ordre.commande = 'Goto') or (Ordre.commande = 'Type')
  or (Ordre.commande = 'Calcul évolué')
  then begin
       Dec(Fin); // Supprime le caractère de fin des paramètre
       if Fin <> -1 then Ordre.textparam := Copy(Text,Deb+1,Fin-Deb-1);
       Ordre.textparam := AnsiDequotedStr(Ordre.textparam,Str[1]);
       add_commande(ListView, Ordre);
       continue;
       end;

  if (Ordre.commande = 'Calcul')
  then begin
       Text :=Copy(Text,Deb+1,Fin-Deb-1);
       ListParam := GetParam(Text);
       if ListParam.nbr_param =2
       then begin
            Ordre.textparam := '';
            i := 0;
            if ((AnsiPos('+',Text) <> 0) and (i=0)) then i := AnsiPos('+',Text);
            if ((AnsiPos('-',Text) <> 0) and (i=0)) then i := AnsiPos('-',Text);
            if ((AnsiPos('*',Text) <> 0) and (i=0)) then i := AnsiPos('*',Text);
            if ((AnsiPos('/',Text) <> 0) and (i=0)) then i := AnsiPos('/',Text);
            if i <> 0 then Ordre.textparam := Copy(Text,0,i-1)+SprPr+Copy(Text,i,1)+SprPR+Copy(Text,i+1,length(Text)-i);
            /// suppression des guillemets
            ListParam := GetParam(Ordre.textparam);
            ListParam.param[3] := AnsiDequotedStr(ListParam.param[3],Str[1]);
            Ordre.textparam := ListParam.param[1] + SprPR + ListParam.param[2] + SprPR +ListParam.param[3] + SprPR;
            end
       else Ordre.textparam := Text;
       add_commande(ListView, Ordre);
       continue;
       end;

  if (Ordre.commande = 'Examine')
  then begin
       Text :=Copy(Text,Deb+1,Fin-Deb-1);
       ListParam := GetParam(Text);
       if ListParam.nbr_param =2
       then begin
            Ordre.textparam := '';
            i := 0;
            if ((AnsiPos('=',Text) <> 0) and (i=0)) then i := AnsiPos('=',Text);
            if ((AnsiPos('<>',Text) <> 0) and (i=0)) then i := AnsiPos('<>',Text);
            if ((AnsiPos('<',Text) <> 0) and (i=0)) then i := AnsiPos('<',Text);
            if ((AnsiPos('>',Text) <> 0) and (i=0)) then i := AnsiPos('>',Text);
            if i <> 0 then Ordre.textparam := Copy(Text,0,i-1)+SprPr+Copy(Text,i,1)+SprPR+Copy(Text,i+1,length(Text)-i);
            /// suppression des guillemets
            ListParam := GetParam(Ordre.textparam);
            ListParam.param[3] := AnsiDequotedStr(ListParam.param[3],Str[1]);
            Ordre.textparam := ListParam.param[1] + SprPR + ListParam.param[2] + SprPR +ListParam.param[3] + SprPR;
            end
       else Ordre.textparam := Text;
       add_commande(ListView, Ordre);
       continue;
       end;

  Text :=Copy(Text,Deb+1,Fin-Deb-1);
  ListParam := GetParam(Text);
  Text := '';
  for i := 1 to ListParam.nbr_param-1
  do begin
     if ListParam.Param[i] = Str[1]+Str[1] then ListParam.Param[i] := '';
     Text := Text + AnsiDequotedStr(ListParam.Param[i],Str[1])+SprPR;
     end;

  if Fin <> -1 then Ordre.textparam := Text;
  if Ordre.commande = ''
  then begin
       Ordre.commande := 'Unknow';
       Ordre.textparam := SousText[j];
       end;
  add_commande(ListView, Ordre);
  end;
  end;
Select_unique(ListView, -1);
change_liste := false;
ControlAll(ListView);
finally OtherLangEditor.Free; closeFile(Fichier); Alias.Free; AliasValue.Free; SousText.Free; end;
end;

procedure TForm1.Activer1Click(Sender: TObject);
var i : integer;
    tmp : String;
begin
for i := 0 to ListView1.Items.Count -1
do begin
   if ListView1.Items.Item[i].Selected = True
   then begin
        tmp := '// '+ ListView1.Items[i].Caption + ' {' + ListView1.Items[i].SubItems[0] + '}';
        ListView1.Items.Item[i].Caption := 'Commentaire';
        ListView1.Items.Item[i].SubItems[0] := tmp;
        ListView1.Items.Item[i].ImageIndex := 15;
        end;
   end;
end;

procedure TForm1.Dsactiver1Click(Sender: TObject);
var i,j : integer;
    tmp : String;
    Order : TOrdre;
begin
for i := 0 to ListView1.Items.Count -1
do begin
   if ListView1.Items.Item[i].Selected = True
   then begin
        if ListView1.Items[i].Caption = 'Commentaire'
        then if (ListView1.Items[i].SubItems[0][1] = '/') and
                (ListView1.Items[i].SubItems[0][2] = '/')
                then begin
                     tmp := copy(ListView1.Items[i].SubItems[0],4,length(ListView1.Items[i].SubItems[0]));
                     j := Pos('{',tmp);
                     if j = 0 then Continue;
                     Order.commande := Copy(tmp,0,j-2);
                     Order.textparam := Copy(tmp,j+1,length(tmp)-j-1);
                     ListView1.Items.Item[i].Caption := Order.commande;
                     ListView1.Items.Item[i].SubItems[0] := Order.textparam;
                     ListView1.Items.Item[i].ImageIndex := form1.GetImageIndex(Order);
                     end;
       end;
   end;
end;

procedure TForm1.SpeedButton38Click(Sender: TObject);
begin
Form36.show;
end;

procedure TForm1.ExporterversOtherLangage1Click(Sender: TObject);
var i,j : integer;
fichier : TextFile;
Params : TParam;
StrParams : String;
OtherLangEditor: TIniFile;
OtherLangEditorFileName : String;
Str,SeparatorPrm,Prm,DebPrm,FinPrm, EndCommand, AffectationOperator: string;
Alias, AliasValue : TStringList;
Order : TOrdre;
TypeFileName, TypeFileExt : String;
begin

Alias := TStringList.create;
AliasValue := TStringList.create;

OtherLangEditorFileName := OtherLangageSelect;

if OtherLangEditorFileName = ''
then Exit;


OtherLangEditor := TIniFile.Create(OtherLangEditorFileName);
try
TypeFileName := OtherLangEditor.ReadString('General','TypeFileName','Pascal');
TypeFileExt := OtherLangEditor.ReadString('General','TypeFileExt','*.pas');


SeparatorPrm := OtherLangEditor.ReadString('General','SeparatorPrm',SprPr);
EndCommand := OtherLangEditor.ReadString('General','EndCommand','');
if EndCommand = '' then EndCommand := #$D#$A;
Str := OtherLangEditor.ReadString('General','StringCar','''');
Prm := OtherLangEditor.ReadString('General','Parametre','');
if Prm = '' then Prm := chr(VK_Tab) + ' ';
AffectationOperator := OtherLangEditor.ReadString('General','AffectationOperator','=');
DebPrm := Prm[1]; FinPrm := Prm[2];

// récuperation des alias
OtherLangEditor.ReadSection('Alias',Alias);
OtherLangEditor.ReadSectionValues('Alias',AliasValue);
for i := 0 to Alias.Count-1
do AliasValue[i] := Copy(AliasValue[i],length(Alias[i])+2,length(AliasValue[i])-length(Alias[i])-1);
finally OtherLangEditor.Free; end;

OpenDialog2.Filter := TypeFileName+'|'+TypeFileExt+';|Tous|*.*';
OpenDialog2.FilterIndex := 0;

If OpenDialog2.Execute
then assignFile(Fichier,OpenDialog2.FileName)
else Exit;

rewrite(Fichier);
try
Writeln(Fichier,'LangEditor='+ExtractFileName(OtherLangEditorFileName));
Writeln (Fichier);
for i := 0 to ListView1.Items.Count-1
do begin
   Order.commande := ListView1.items[i].caption;
   if Order.commande = 'Commentaire'
   then begin
        writeln(Fichier,'//'+ListView1.items[i].SubItems[0]);
        continue;
        end;
   Params := GetParam(ListView1.items[i].SubItems[0]);
   StrParams := '';
   for j := 1 to Params.nbr_param-1
   do StrParams := StrParams + Params.param[j]+SeparatorPrm;

   for j := 0 to Alias.Count-1
   do if Alias[j] = Order.commande
      then Order.commande := AliasValue[j];

   if length(StrParams) > 0 then StrParams := Copy(StrParams,0,length(StrParams)-1);
   if Order.commande <> ''
   then writeln(Fichier,Order.commande+DebPrm+StrParams+FinPrm+EndCommand)
   else begin // si calcul évolué
        StrParams := StringReplace(StrParams,'=',AffectationOperator,[]);
        writeln(Fichier,StrParams+EndCommand);
        end;
   end;
finally CloseFile(Fichier); Alias.Free; AliasValue.Free; end;
end;

procedure TForm1.OtherLangageToClipBoard(FileName : String);
var i,j : integer;
Params : TParam;
StrParams : String;
OtherLangEditor: TIniFile;
OtherLangEditorFileName : String;
Str,SeparatorPrm,Prm,DebPrm,FinPrm, EndCommand, AffectationOperator: string;
Alias, AliasValue : TStringList;
Order : TOrdre;
TypeFileName, TypeFileExt : String;
begin
Alias := TStringList.create;
AliasValue := TStringList.create;
if FileName <> ''
then OtherLangEditorFileName := FileName
else OtherLangEditorFileName := 'c:\Pascal.OtherLangEditor';
OtherLangEditor := TIniFile.Create(OtherLangEditorFileName);
try
TypeFileName := OtherLangEditor.ReadString('General','TypeFileName','Pascal');
TypeFileExt := OtherLangEditor.ReadString('General','TypeFileExt','*.pas');


SeparatorPrm := OtherLangEditor.ReadString('General','SeparatorPrm',SprPr);
EndCommand := OtherLangEditor.ReadString('General','EndCommand','');
Str := OtherLangEditor.ReadString('General','StringCar','''');
Prm := OtherLangEditor.ReadString('General','Parametre','()');
AffectationOperator := OtherLangEditor.ReadString('General','AffectationOperator','=');

if (length(Prm) <> 2) or (Prm = '')
then Prm := '()';
DebPrm := Prm[1]; FinPrm := Prm[2];

// récuperation des alias
OtherLangEditor.ReadSection('Alias',Alias);
OtherLangEditor.ReadSectionValues('Alias',AliasValue);
for i := 0 to Alias.Count-1
do AliasValue[i] := Copy(AliasValue[i],length(Alias[i])+2,length(AliasValue[i])-length(Alias[i])-1);
finally OtherLangEditor.Free; end;

OpenDialog2.Filter := TypeFileName+'|'+TypeFileExt+';|Tous|*.*';
OpenDialog2.FilterIndex := 0;

if ListView1.Visible = False then Exit;
ClipBoard.Open;
try
ClipBoard.Clear;
for i := 0 to ListView1.Items.Count-1
do begin
   if (ListView1.Items[i].Selected = False) and (ListView1.SelCount <> 0)
   then continue;

   Order.commande := ListView1.items[i].caption;
   if Order.commande = 'Commentaire'
   then begin
        ClipBoard.AsText := ClipBoard.AsText +'//'+ListView1.items[i].SubItems[0] + #$D#$A;
        continue;
        end;
   Params := GetParam(ListView1.items[i].SubItems[0]);
   StrParams := '';
   for j := 1 to Params.nbr_param-1
   do StrParams := StrParams + Params.param[j]+SeparatorPrm;

   for j := 0 to Alias.Count-1
   do if Alias[j] = Order.commande
      then Order.commande := AliasValue[j];

   if length(StrParams) > 0 then StrParams := Copy(StrParams,0,length(StrParams)-1);
   if Order.commande <> ''
   then ClipBoard.AsText := ClipBoard.AsText + Order.commande+DebPrm+StrParams+FinPrm+EndCommand + #$D#$A
   else begin // si calcul évolué
        StrParams := StringReplace(StrParams,'=',AffectationOperator,[]);
        ClipBoard.AsText := ClipBoard.AsText + StrParams+EndCommand + #$D#$A;
        end;
   end;
finally ClipBoard.Close; Alias.Free; AliasValue.Free; end;
end;


function GetStatusBarHint(Sender: TStatusBar; x: Integer): integer;
var i,width : integer;
begin
i := 0;
width := Sender.Panels[0].Width;
while (x > width) and (i < Sender.Panels.Count-1)
do begin
   Inc(i);
   width := width + Sender.Panels[i].Width;
   end;
if x < width
then result := i else result := -1;
end;

procedure TForm1.StatusBar1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
case GetStatusBarHint(StatusBar1,X) of
     0 : StatusBar1.Hint:='';
     1 : if Key <> '' then StatusBar1.Hint := 'Macro protégée par mot de passe.' else StatusBar1.Hint := 'Macro non protégée.';
     2 : StatusBar1.Hint := 'Language '+form19.ComboBox3.Text;
     3 : StatusBar1.Hint:='Double-cliquez ici pour changer la commande sélectionnée.';
     end;
end;

procedure TForm1.Gestionnairedetche1Click(Sender: TObject);
begin
Options1.Click;
Form19.PageControl1.ActivePage := Form19.TabSheet7;
Form19.PageControl1.OnChange(Form19.PageControl1);
//Form1.Authen(ExtractFileDir(Application.ExeName)+ '\SMLaunch.exe');

end;

procedure TForm1.StatusBar1DblClick(Sender: TObject);
var i : integer;
begin
if ContextOfExecute.ExecutionType <> ContextOfExecute.NotRun then Exit;
if StatusBar1.Hint ='Double-cliquez ici pour changer la commande sélectionnée.'
then begin
     Form10.Caption := 'Aller à la ligne';
     Form10.Label1.Caption := 'Numéro de ligne';
     Form10.Edit1.Text := '';
     Form10.ShowModal;
     Form10.Edit1.Text :=  Trim(Form10.Edit1.Text);
     If FnctIsInteger(Form10.Edit1.Text) = True
     then Begin
          i := StrToInt(Form10.Edit1.Text);
          if (i > 0) and (i <= ListView1.Items.Count)
          then begin
               form1.Select_unique(ListView1,i-1);
               ListView1.SetFocus;
               end
          else ShowMessage('Numéro de ligne hors limite.');
          end
     else if Form10.Edit1.Text <> '' then ShowMessage('Numéro de ligne invalide.');
     end;
if StatusBar1.Hint =  'Language '+form19.ComboBox3.Text
then begin Form19.Show; Form19.PageControl1.ActivePage := Form19.TabSheet5; ShowBalloonTip(Form19.ComboBox3,1,'Information','Sélectionnez un autre langage.',2); end;
end;


procedure TForm1.Occurencesuivante1Click(Sender: TObject);
begin
FindDialog2.OnFind(self);
end;

procedure TForm1.Rechercherladclaration1Click(Sender: TObject);
var ProcName : String;
    Index : integer;
begin
if ListView1.Selected = nil
then Exit;
ProcName := Copy(ListView1.Selected.SubItems[0],6,length(ListView1.Selected.SubItems[0])-5);
Index := procedure_exists(ListView1,ProcName);
if Index = -1
then ShowMessage('Définition de procédure introuvable. ['+ProcName+']')
else Select_unique(ListView1,Index);
end;

procedure TForm1.Ignorercetteavertissement1Click(Sender: TObject);
var index : integer;
begin
index := length(TabIgnoreMsg);
SetLength(TabIgnoreMsg, index+1);
TabIgnoreMsg[index].Pos := ListView2.Selected.Caption;
TabIgnoreMsg[index].Msg := ListView2.Selected.SubItems[1];
TabIgnoreMsg[index].Exists := True;
Form1.ControlAll(ListView1);
end;

procedure TForm1.Restituerlesavertissementsignors1Click(Sender: TObject);
begin
SetLength(TabIgnoreMsg, 0);
Form1.ControlAll(ListView1);
end;

procedure TForm1.Copierlavaleur1Click(Sender: TObject);
begin
if (ListView3.Selected <> nil) and (ListView3.Focused = True)
then ClipBoard.AsText := ListView3.Selected.SubItems[0];
end;

procedure TForm1.phpBB1Click(Sender: TObject);
var i : integer;
    tmp : string;
    FileName : String;
begin
if ListView1.Visible = False then Exit;
ClipBoard.Open;
try
ClipBoard.Clear; tmp := '';
for i := 0 to ListView1.Items.Count -1
do begin
   if ListView1.Items.Item[i].Selected = True
   then begin
        FileName := StringReplace(ListView1.Items[i].Caption,' ','~',[rfReplaceAll]);
        if GetImageIndex(ListView1.Items[i].Caption) < length(CaseOfExecuteTab)+1
        then tmp := '[img]http://adam.denadai.free.fr/ImgOrder/'+IntToStr(GetImageIndex(ListView1.Items[i].Caption))+'.GIF[/img]'+Chr(VK_Tab)+'[B]'+ListView1.Items[i].Caption +'[/B]' + Chr(VK_Tab) + Chr(VK_Tab) +ListView1.Items[i].SubItems.Text
        else tmp := '[img]http://adam.denadai.free.fr/ImgOrder/'+ FileName+'.GIF[/img]'+Chr(VK_Tab)+'[B]'+ListView1.Items[i].Caption +'[/B]' + Chr(VK_Tab) + Chr(VK_Tab) +ListView1.Items[i].SubItems.Text;
        if i < ListView1.Items.Count -1 then tmp := tmp + #0;
        ClipBoard.AsText := ClipBoard.AsText+tmp;
        end;
   end;
tmp := #0 +':idea: [b]Info utile:[/b] Pour transférer le code ci-dessus dans Super macro,';
tmp := tmp + ' sélectionnez l''ensemble des commandes contenues dans ce message,copiez la sélection (Ctrl+C), puis dans ';
tmp := tmp + 'Super macro allez dans le menu Edition, cliquez sur Coller a partir d''un texte simple.';
ClipBoard.AsText := ClipBoard.AsText+tmp;

finally ClipBoard.Close; end;
end;

procedure TForm1.HTML1Click(Sender: TObject);
var i : integer;
    FileName, text, tmp : string;
    URL : String;
begin
//URL := '<IMG src="';
URL := '<IMG src="http://adam.denadai.free.fr/ImgOrder/';
if ListView1.Visible = False then Exit;
ClipBoard.Open;
try
ClipBoard.Clear; tmp := '';
for i := 0 to ListView1.Items.Count -1
do begin
   if ListView1.Items.Item[i].Selected = True
   then begin
        FileName := StringReplace(ListView1.Items[i].Caption,' ','~',[rfReplaceAll]);
        Text := StringReplace(ListView1.Items[i].SubItems.Text,'<','&lt;',[rfReplaceAll, rfIgnoreCase]);
        Text := StringReplace(Text,'>','&gt;',[rfReplaceAll, rfIgnoreCase]);
        if GetImageIndex(ListView1.Items[i].Caption) < length(CaseOfExecuteTab)+1
        then tmp := URL +IntToStr(GetImageIndex(ListView1.Items[i].Caption))+'.GIF">&nbsp<B>'+ListView1.Items[i].Caption +'</B>&nbsp&nbsp;' + Text+'<BR>'
        else tmp := URL+ FileName+'.GIF">&nbsp<B>'+ListView1.Items[i].Caption +'</B>&nbsp&nbsp;' +Text+'<BR>';
        if i < ListView1.Items.Count -1 then tmp := tmp + #0;
        ClipBoard.AsText := ClipBoard.AsText +tmp;
        end;
   end;
finally ClipBoard.Close; end;

end;

procedure TForm1.SpeedButton30Click(Sender: TObject);
var FileList : TStringList;
    OtherLangEditor: TIniFile;
    i : integer;
    TitleFilter, ExtFilter, FilterName : String;
begin
FilterName := 'Macro|*.mcr';
TitleFilter := 'Extensions reconnues (*.mcr';
ExtFilter := '*.mcr';
FileList := TStringList.Create;
try
mdlfnct.ScruteFichier(ExtractFileDir(Application.ExeName),'*.OtherLangEditor',faAnyFile,FileList);

for i := 0 to FileList.Count-1
do begin
   OtherLangEditor := TIniFile.Create(FileList[i]);
   try
   TitleFilter := TitleFilter + ';'+ OtherLangEditor.ReadString('General','TypeFileExt','*.Unknow');
   ExtFilter := ExtFilter + ';'+ OtherLangEditor.ReadString('General','TypeFileExt','*.Unknow');
   finally OtherLangEditor.free; end;
   end;

FilterName := FilterName +'|'+ TitleFilter +')|'+ ExtFilter +'|Tous les fichiers|*.*';

OpenDialog2.Filter := FilterName;
OpenDialog2.FilterIndex := 2;
Opendialog2.FileName := '';
if OpenDialog2.Execute
then form1.add_insert('Inclusion',Opendialog2.FileName,29)

finally FileList.Free; end;
end;

procedure TForm1.LoadTabInclude(var TabOfInclude :TTabOfInclude; ListView : TListView);
var TabCount, i,j : integer;
     SousMacro : TListView;
     ListItem : TListItem;
begin
SetLength(TabOfInclude,0);
i := 0;
ListView.Items.BeginUpdate;
try
while i < ListView.Items.Count
do begin
   if (ListView.Items[i].Caption = 'Inclusion') and (FileExists(ListView.Items[i].SubItems[0]))
   then begin
        TabCount := Length(TabOfInclude);
        SetLength(TabOfInclude,TabCount+1);
        TabOfInclude[TabCount].FileName := ListView.Items[i].SubItems[0];
        TabOfInclude[TabCount].Index := i;
        SousMacro := TListView.Create(form23);
        try
        SousMacro.Parent := Form23;
        SousMacro.Align := alClient;
        SousMacro.ViewStyle := vsReport;
        SousMacro.Visible := False;
        SousMacro.Columns.Add; //NewColumn.Caption := 'Commande';
        SousMacro.Columns.Add; //NewColumn.Caption := 'Paramètres';
        OpenFileMacro(TabOfInclude[TabCount].FileName,SousMacro, 0,'Chargement de '+ TabOfInclude[TabCount].FileName +' a inclure, veuillez patient SVP.');
        TabOfInclude[TabCount].count := SousMacro.Items.Count;
        Can_Save := False;
        ListView.Items.Delete(i);
        Can_Save := True;
        for j := 0 to SousMacro.Items.Count-1
        do begin
           ListItem := ListView.Items.Insert(i+j);
           //Form1.InfoListViewInsert(ListItem.Index);
           ListItem.Caption := SousMacro.Items[j].Caption;
           ListItem.SubItems.Add(SousMacro.Items[j].SubItems[0]);
           ListItem.ImageIndex := SousMacro.Items[j].ImageIndex;
           end;
        finally SousMacro.Free; end;
        end;
   Inc(i);
   end;
finally ListView.Items.EndUpdate; end;
end;

procedure TForm1.RestoreTabInclude(var TabOfInclude :TTabOfInclude;  ListView : TListView);
var i,j : integer;
    ListItem : TListItem;
begin
ListView.Items.BeginUpdate;
try
for i := length(TabOfInclude)-1 downto 0
do begin
   Can_Save := False;
   for j := 1 to TabOfInclude[i].count
   do ListView.Items.Delete(TabOfInclude[i].Index);
   Can_Save := True;
   ListItem := ListView.Items.Insert(TabOfInclude[i].Index);
   //form1.InfoListViewInsert(TabOfInclude[i].Index);
   ListItem.Caption := 'Inclusion';
   ListItem.SubItems.Add(TabOfInclude[i].FileName);
   ListItem.ImageIndex := 29;
   end;
SetLength(TabOfInclude,0);
finally ListView.Items.EndUpdate; end;
end;

procedure TForm1.OtherLangEditor1Click(Sender: TObject);
begin
OtherLangageToClipBoard(OtherLangageSelect);
end;

procedure TForm1.oussupprimer1Click(Sender: TObject);
var i : integer;
begin
for i := Low(TabInfoListView) to High(TabInfoListView)
do begin
   TabInfoListView[i].Bullet := False;
   TabInfoListView[i].SignetNr := -1;
   end;
InfoListViewDraw;
end;

function TForm1.OtherLangageSelect() : String;
begin
mdlfnct.ScruteFichier(ExtractFileDir(Application.ExeName),'*.OtherLangEditor',faAnyFile,Form37.ListBox1.Items);
Form37.ShowModal;
result := Unit37.LangSelect;
end;

procedure TForm1.AnchorForm(FormObj : TForm);
var MyObject : TObject;
    i : integer;
begin
for i := 0 to TForm(FormObj).ComponentCount-1
do begin
   MyObject := TForm(FormObj).Components[i];
   if not (MyObject is TControl) then continue;
   if MyObject = nil then continue;
   TControl(MyObject).Anchors := [akTop, akLeft];
   end;
end;
procedure TForm1.Apropos2Click(Sender: TObject);
begin
form23.show;
end;

procedure TForm1.SpeedButton31Click(Sender: TObject);
begin
Form9.Caption := 'Message';

Form9.Label3.Visible := False;
Form9.ComboBox1.Visible := False;
Form9.Show;
Form9.ComboBox2.Text := 'Message';
Form9.ComboBox3.SetFocus;
end;

end.

