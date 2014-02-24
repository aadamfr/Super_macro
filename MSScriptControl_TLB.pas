unit MSScriptControl_TLB;

// ************************************************************************ //
// AVERTISSEMENT                                                                 
// -------                                                                    
// Les types d�clar�s dans ce fichier ont �t� g�n�r�s � partir de donn�es lues 
// depuis la biblioth�que de types. Si cette derni�re (via une autre biblioth�que de types 
// s'y r�f�rant) est explicitement ou indirectement r�-import�e, ou la commande "Rafra�chir"  
// de l'�diteur de biblioth�que de types est activ�e lors de la modification de la biblioth�que 
// de types, le contenu de ce fichier sera r�g�n�r� et toutes les modifications      
// manuellement apport�es seront perdues.                                     
// ************************************************************************ //

// PASTLWTR : 1.2
// Fichier g�n�r� le 05/09/2006 17:01:05 depuis la biblioth�que de types ci-dessous.

// ************************************************************************  //
// Bibl. types : C:\WINDOWS\System32\msscript.ocx (1)
// LIBID: {0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}
// LCID: 0
// Fichier d'aide : C:\WINDOWS\System32\MSSCRIPT.HLP
// Cha�ne d'aide : Microsoft Script Control 1.0
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// Erreurs :
//   Remarque : le typeinfo Procedure a �t� chang� en Procedure_
//   Remarque : param�tre 'Object' dans IScriptModuleCollection.Add chang� en 'Object_'
//   Remarque : param�tre 'Object' dans IScriptControl.AddObject chang� en 'Object_'
// ************************************************************************ //
{$TYPEDADDRESS OFF} // L'unit� doit �tre compil�e sans pointeur � type contr�l�. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleCtrls, OleServer, StdVCL, Variants;
  


// *********************************************************************//
// GUIDS d�clar�s dans la biblioth�que de types. Pr�fixes utilis�s :    
//   Biblioth�ques de types : LIBID_xxxx                                      
//   CoClasses              : CLASS_xxxx                                      
//   DISPInterfaces         : DIID_xxxx                                       
//   Non-DISP interfaces    : IID_xxxx                                        
// *********************************************************************//
const
  // Versions majeure et mineure de la biblioth�que de types
  MSScriptControlMajorVersion = 1;
  MSScriptControlMinorVersion = 0;

  LIBID_MSScriptControl: TGUID = '{0E59F1D2-1FBE-11D0-8FF2-00A0D10038BC}';

  IID_IScriptProcedure: TGUID = '{70841C73-067D-11D0-95D8-00A02463AB28}';
  IID_IScriptProcedureCollection: TGUID = '{70841C71-067D-11D0-95D8-00A02463AB28}';
  IID_IScriptModule: TGUID = '{70841C70-067D-11D0-95D8-00A02463AB28}';
  IID_IScriptModuleCollection: TGUID = '{70841C6F-067D-11D0-95D8-00A02463AB28}';
  IID_IScriptError: TGUID = '{70841C78-067D-11D0-95D8-00A02463AB28}';
  IID_IScriptControl: TGUID = '{0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}';
  DIID_DScriptControlSource: TGUID = '{8B167D60-8605-11D0-ABCB-00A0C90FFFC0}';
  CLASS_Procedure_: TGUID = '{0E59F1DA-1FBE-11D0-8FF2-00A0D10038BC}';
  CLASS_Procedures: TGUID = '{0E59F1DB-1FBE-11D0-8FF2-00A0D10038BC}';
  CLASS_Module: TGUID = '{0E59F1DC-1FBE-11D0-8FF2-00A0D10038BC}';
  CLASS_Modules: TGUID = '{0E59F1DD-1FBE-11D0-8FF2-00A0D10038BC}';
  CLASS_Error: TGUID = '{0E59F1DE-1FBE-11D0-8FF2-00A0D10038BC}';
  CLASS_ScriptControl: TGUID = '{0E59F1D5-1FBE-11D0-8FF2-00A0D10038BC}';

// *********************************************************************//
// D�claration d'�num�rations d�finies dans la biblioth�que de types    
// *********************************************************************//
// Constantes pour enum ScriptControlStates
type
  ScriptControlStates = TOleEnum;
const
  Initialized = $00000000;
  Connected = $00000001;

type

// *********************************************************************//
// D�claration Forward des types d�finis dans la biblioth�que de types    
// *********************************************************************//
  IScriptProcedure = interface;
  IScriptProcedureDisp = dispinterface;
  IScriptProcedureCollection = interface;
  IScriptProcedureCollectionDisp = dispinterface;
  IScriptModule = interface;
  IScriptModuleDisp = dispinterface;
  IScriptModuleCollection = interface;
  IScriptModuleCollectionDisp = dispinterface;
  IScriptError = interface;
  IScriptErrorDisp = dispinterface;
  IScriptControl = interface;
  IScriptControlDisp = dispinterface;
  DScriptControlSource = dispinterface;

// *********************************************************************//
// D�claration de CoClasses d�finies dans la biblioth�que de types 
// (REMARQUE: On affecte chaque CoClasse � son Interface par d�faut)              
// *********************************************************************//
  Procedure_ = IScriptProcedure;
  Procedures = IScriptProcedureCollection;
  Module = IScriptModule;
  Modules = IScriptModuleCollection;
  Error = IScriptError;
  ScriptControl = IScriptControl;


// *********************************************************************//
// D�claration de structures, d'unions et d'alias.                        
// *********************************************************************//
  PPSafeArray1 = ^PSafeArray; {*}
  POleVariant1 = ^OleVariant; {*}


// *********************************************************************//
// Interface   : IScriptProcedure
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {70841C73-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptProcedure = interface(IDispatch)
    ['{70841C73-067D-11D0-95D8-00A02463AB28}']
    function Get_Name: WideString; safecall;
    function Get_NumArgs: Integer; safecall;
    function Get_HasReturnValue: WordBool; safecall;
    property Name: WideString read Get_Name;
    property NumArgs: Integer read Get_NumArgs;
    property HasReturnValue: WordBool read Get_HasReturnValue;
  end;

// *********************************************************************//
// DispIntf :  IScriptProcedureDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {70841C73-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptProcedureDisp = dispinterface
    ['{70841C73-067D-11D0-95D8-00A02463AB28}']
    property Name: WideString readonly dispid 0;
    property NumArgs: Integer readonly dispid 100;
    property HasReturnValue: WordBool readonly dispid 101;
  end;

// *********************************************************************//
// Interface   : IScriptProcedureCollection
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {70841C71-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptProcedureCollection = interface(IDispatch)
    ['{70841C71-067D-11D0-95D8-00A02463AB28}']
    function Get__NewEnum: IUnknown; safecall;
    function Get_Item(Index: OleVariant): IScriptProcedure; safecall;
    function Get_Count: Integer; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Item[Index: OleVariant]: IScriptProcedure read Get_Item; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf :  IScriptProcedureCollectionDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {70841C71-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptProcedureCollectionDisp = dispinterface
    ['{70841C71-067D-11D0-95D8-00A02463AB28}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Item[Index: OleVariant]: IScriptProcedure readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
  end;

// *********************************************************************//
// Interface   : IScriptModule
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {70841C70-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptModule = interface(IDispatch)
    ['{70841C70-067D-11D0-95D8-00A02463AB28}']
    function Get_Name: WideString; safecall;
    function Get_CodeObject: IDispatch; safecall;
    function Get_Procedures: IScriptProcedureCollection; safecall;
    procedure AddCode(const Code: WideString); safecall;
    function Eval(const Expression: WideString): OleVariant; safecall;
    procedure ExecuteStatement(const Statement: WideString); safecall;
    function Run(const ProcedureName: WideString; var Parameters: PSafeArray): OleVariant; safecall;
    property Name: WideString read Get_Name;
    property CodeObject: IDispatch read Get_CodeObject;
    property Procedures: IScriptProcedureCollection read Get_Procedures;
  end;

// *********************************************************************//
// DispIntf :  IScriptModuleDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {70841C70-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptModuleDisp = dispinterface
    ['{70841C70-067D-11D0-95D8-00A02463AB28}']
    property Name: WideString readonly dispid 0;
    property CodeObject: IDispatch readonly dispid 1000;
    property Procedures: IScriptProcedureCollection readonly dispid 1001;
    procedure AddCode(const Code: WideString); dispid 2000;
    function Eval(const Expression: WideString): OleVariant; dispid 2001;
    procedure ExecuteStatement(const Statement: WideString); dispid 2002;
    function Run(const ProcedureName: WideString; var Parameters: {??PSafeArray}OleVariant): OleVariant; dispid 2003;
  end;

// *********************************************************************//
// Interface   : IScriptModuleCollection
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {70841C6F-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptModuleCollection = interface(IDispatch)
    ['{70841C6F-067D-11D0-95D8-00A02463AB28}']
    function Get__NewEnum: IUnknown; safecall;
    function Get_Item(Index: OleVariant): IScriptModule; safecall;
    function Get_Count: Integer; safecall;
    function Add(const Name: WideString; var Object_: OleVariant): IScriptModule; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Item[Index: OleVariant]: IScriptModule read Get_Item; default;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf :  IScriptModuleCollectionDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {70841C6F-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptModuleCollectionDisp = dispinterface
    ['{70841C6F-067D-11D0-95D8-00A02463AB28}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Item[Index: OleVariant]: IScriptModule readonly dispid 0; default;
    property Count: Integer readonly dispid 1;
    function Add(const Name: WideString; var Object_: OleVariant): IScriptModule; dispid 2;
  end;

// *********************************************************************//
// Interface   : IScriptError
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {70841C78-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptError = interface(IDispatch)
    ['{70841C78-067D-11D0-95D8-00A02463AB28}']
    function Get_Number: Integer; safecall;
    function Get_Source: WideString; safecall;
    function Get_Description: WideString; safecall;
    function Get_HelpFile: WideString; safecall;
    function Get_HelpContext: Integer; safecall;
    function Get_Text: WideString; safecall;
    function Get_Line: Integer; safecall;
    function Get_Column: Integer; safecall;
    procedure Clear; safecall;
    property Number: Integer read Get_Number;
    property Source: WideString read Get_Source;
    property Description: WideString read Get_Description;
    property HelpFile: WideString read Get_HelpFile;
    property HelpContext: Integer read Get_HelpContext;
    property Text: WideString read Get_Text;
    property Line: Integer read Get_Line;
    property Column: Integer read Get_Column;
  end;

// *********************************************************************//
// DispIntf :  IScriptErrorDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {70841C78-067D-11D0-95D8-00A02463AB28}
// *********************************************************************//
  IScriptErrorDisp = dispinterface
    ['{70841C78-067D-11D0-95D8-00A02463AB28}']
    property Number: Integer readonly dispid 201;
    property Source: WideString readonly dispid 202;
    property Description: WideString readonly dispid 203;
    property HelpFile: WideString readonly dispid 204;
    property HelpContext: Integer readonly dispid 205;
    property Text: WideString readonly dispid -517;
    property Line: Integer readonly dispid 206;
    property Column: Integer readonly dispid -529;
    procedure Clear; dispid 208;
  end;

// *********************************************************************//
// Interface   : IScriptControl
// Indicateurs : (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID        : {0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}
// *********************************************************************//
  IScriptControl = interface(IDispatch)
    ['{0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}']
    function Get_Language: WideString; safecall;
    procedure Set_Language(const pbstrLanguage: WideString); safecall;
    function Get_State: ScriptControlStates; safecall;
    procedure Set_State(pssState: ScriptControlStates); safecall;
    procedure Set_SitehWnd(phwnd: Integer); safecall;
    function Get_SitehWnd: Integer; safecall;
    function Get_Timeout: Integer; safecall;
    procedure Set_Timeout(plMilleseconds: Integer); safecall;
    function Get_AllowUI: WordBool; safecall;
    procedure Set_AllowUI(pfAllowUI: WordBool); safecall;
    function Get_UseSafeSubset: WordBool; safecall;
    procedure Set_UseSafeSubset(pfUseSafeSubset: WordBool); safecall;
    function Get_Modules: IScriptModuleCollection; safecall;
    function Get_Error: IScriptError; safecall;
    function Get_CodeObject: IDispatch; safecall;
    function Get_Procedures: IScriptProcedureCollection; safecall;
    procedure _AboutBox; safecall;
    procedure AddObject(const Name: WideString; const Object_: IDispatch; AddMembers: WordBool); safecall;
    procedure Reset; safecall;
    procedure AddCode(const Code: WideString); safecall;
    function Eval(const Expression: WideString): OleVariant; safecall;
    procedure ExecuteStatement(const Statement: WideString); safecall;
    function Run(const ProcedureName: WideString; var Parameters: PSafeArray): OleVariant; safecall;
    property Language: WideString read Get_Language write Set_Language;
    property State: ScriptControlStates read Get_State write Set_State;
    property SitehWnd: Integer read Get_SitehWnd write Set_SitehWnd;
    property Timeout: Integer read Get_Timeout write Set_Timeout;
    property AllowUI: WordBool read Get_AllowUI write Set_AllowUI;
    property UseSafeSubset: WordBool read Get_UseSafeSubset write Set_UseSafeSubset;
    property Modules: IScriptModuleCollection read Get_Modules;
    property Error: IScriptError read Get_Error;
    property CodeObject: IDispatch read Get_CodeObject;
    property Procedures: IScriptProcedureCollection read Get_Procedures;
  end;

// *********************************************************************//
// DispIntf :  IScriptControlDisp
// Flags :     (4560) Hidden Dual NonExtensible OleAutomation Dispatchable
// GUID :      {0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}
// *********************************************************************//
  IScriptControlDisp = dispinterface
    ['{0E59F1D3-1FBE-11D0-8FF2-00A0D10038BC}']
    property Language: WideString dispid 1500;
    property State: ScriptControlStates dispid 1501;
    property SitehWnd: Integer dispid 1502;
    property Timeout: Integer dispid 1503;
    property AllowUI: WordBool dispid 1504;
    property UseSafeSubset: WordBool dispid 1505;
    property Modules: IScriptModuleCollection readonly dispid 1506;
    property Error: IScriptError readonly dispid 1507;
    property CodeObject: IDispatch readonly dispid 1000;
    property Procedures: IScriptProcedureCollection readonly dispid 1001;
    procedure _AboutBox; dispid -552;
    procedure AddObject(const Name: WideString; const Object_: IDispatch; AddMembers: WordBool); dispid 2500;
    procedure Reset; dispid 2501;
    procedure AddCode(const Code: WideString); dispid 2000;
    function Eval(const Expression: WideString): OleVariant; dispid 2001;
    procedure ExecuteStatement(const Statement: WideString); dispid 2002;
    function Run(const ProcedureName: WideString; var Parameters: {??PSafeArray}OleVariant): OleVariant; dispid 2003;
  end;

// *********************************************************************//
// DispIntf :  DScriptControlSource
// Flags :     (4112) Hidden Dispatchable
// GUID :      {8B167D60-8605-11D0-ABCB-00A0C90FFFC0}
// *********************************************************************//
  DScriptControlSource = dispinterface
    ['{8B167D60-8605-11D0-ABCB-00A0C90FFFC0}']
    procedure Error; dispid 3000;
    procedure Timeout; dispid 3001;
  end;

// *********************************************************************//
// La classe CoProcedure_ fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IScriptProcedure expos�e             
// par la CoClasse Procedure_. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoProcedure_ = class
    class function Create: IScriptProcedure;
    class function CreateRemote(const MachineName: string): IScriptProcedure;
  end;

// *********************************************************************//
// La classe CoProcedures fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IScriptProcedureCollection expos�e             
// par la CoClasse Procedures. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoProcedures = class
    class function Create: IScriptProcedureCollection;
    class function CreateRemote(const MachineName: string): IScriptProcedureCollection;
  end;

// *********************************************************************//
// La classe CoModule fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IScriptModule expos�e             
// par la CoClasse Module. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoModule = class
    class function Create: IScriptModule;
    class function CreateRemote(const MachineName: string): IScriptModule;
  end;

// *********************************************************************//
// La classe CoModules fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IScriptModuleCollection expos�e             
// par la CoClasse Modules. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoModules = class
    class function Create: IScriptModuleCollection;
    class function CreateRemote(const MachineName: string): IScriptModuleCollection;
  end;

// *********************************************************************//
// La classe CoError fournit une m�thode Create et CreateRemote pour          
// cr�er des instances de l'interface par d�faut IScriptError expos�e             
// par la CoClasse Error. Les fonctions sont destin�es � �tre utilis�es par            
// les clients d�sirant automatiser les objets CoClasse expos�s par       
// le serveur de cette biblioth�que de types.                                            
// *********************************************************************//
  CoError = class
    class function Create: IScriptError;
    class function CreateRemote(const MachineName: string): IScriptError;
  end;


// *********************************************************************//
// D�claration de classe proxy de contr�le OLE
// Nom du contr�le      : TScriptControl
// Cha�ne d'aide        : Control to host scripting engines that understand the ActiveX Scripting interface
// Interface par d�faut : IScriptControl
// DISP Int. D�f. ?     : No
// Interface �v�nements : DScriptControlSource
// TypeFlags            : (34) CanCreate Control
// *********************************************************************//
  TScriptControl = class(TOleControl)
  private
    FOnError: TNotifyEvent;
    FOnTimeout: TNotifyEvent;
    FIntf: IScriptControl;
    function  GetControlInterface: IScriptControl;
  protected
    procedure CreateControl;
    procedure InitControlData; override;
    function Get_Modules: IScriptModuleCollection;
    function Get_Error: IScriptError;
    function Get_CodeObject: IDispatch;
    function Get_Procedures: IScriptProcedureCollection;
  public
    procedure _AboutBox;
    procedure AddObject(const Name: WideString; const Object_: IDispatch; AddMembers: WordBool);
    procedure Reset;
    procedure AddCode(const Code: WideString);
    function Eval(const Expression: WideString): OleVariant;
    procedure ExecuteStatement(const Statement: WideString);
    function Run(const ProcedureName: WideString; var Parameters: PSafeArray): OleVariant;
    property  ControlInterface: IScriptControl read GetControlInterface;
    property  DefaultInterface: IScriptControl read GetControlInterface;
    property Modules: IScriptModuleCollection read Get_Modules;
    property Error: IScriptError read Get_Error;
    property CodeObject: IDispatch index 1000 read GetIDispatchProp;
    property Procedures: IScriptProcedureCollection read Get_Procedures;
  published
    property Anchors;
    property Language: WideString index 1500 read GetWideStringProp write SetWideStringProp stored False;
    property State: TOleEnum index 1501 read GetTOleEnumProp write SetTOleEnumProp stored False;
    property SitehWnd: Integer index 1502 read GetIntegerProp write SetIntegerProp stored False;
    property Timeout: Integer index 1503 read GetIntegerProp write SetIntegerProp stored False;
    property AllowUI: WordBool index 1504 read GetWordBoolProp write SetWordBoolProp stored False;
    property UseSafeSubset: WordBool index 1505 read GetWordBoolProp write SetWordBoolProp stored False;
    property OnError: TNotifyEvent read FOnError write FOnError;
    property OnTimeout: TNotifyEvent read FOnTimeout write FOnTimeout;
  end;

procedure Register;

resourcestring
  dtlServerPage = 'ActiveX';

  dtlOcxPage = 'ActiveX';

implementation

uses ComObj;

class function CoProcedure_.Create: IScriptProcedure;
begin
  Result := CreateComObject(CLASS_Procedure_) as IScriptProcedure;
end;

class function CoProcedure_.CreateRemote(const MachineName: string): IScriptProcedure;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Procedure_) as IScriptProcedure;
end;

class function CoProcedures.Create: IScriptProcedureCollection;
begin
  Result := CreateComObject(CLASS_Procedures) as IScriptProcedureCollection;
end;

class function CoProcedures.CreateRemote(const MachineName: string): IScriptProcedureCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Procedures) as IScriptProcedureCollection;
end;

class function CoModule.Create: IScriptModule;
begin
  Result := CreateComObject(CLASS_Module) as IScriptModule;
end;

class function CoModule.CreateRemote(const MachineName: string): IScriptModule;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Module) as IScriptModule;
end;

class function CoModules.Create: IScriptModuleCollection;
begin
  Result := CreateComObject(CLASS_Modules) as IScriptModuleCollection;
end;

class function CoModules.CreateRemote(const MachineName: string): IScriptModuleCollection;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Modules) as IScriptModuleCollection;
end;

class function CoError.Create: IScriptError;
begin
  Result := CreateComObject(CLASS_Error) as IScriptError;
end;

class function CoError.CreateRemote(const MachineName: string): IScriptError;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Error) as IScriptError;
end;

procedure TScriptControl.InitControlData;
const
  CEventDispIDs: array [0..1] of DWORD = (
    $00000BB8, $00000BB9);
  CControlData: TControlData2 = (
    ClassID: '{0E59F1D5-1FBE-11D0-8FF2-00A0D10038BC}';
    EventIID: '{8B167D60-8605-11D0-ABCB-00A0C90FFFC0}';
    EventCount: 2;
    EventDispIDs: @CEventDispIDs;
    LicenseKey: nil (*HR:$00000000*);
    Flags: $00000000;
    Version: 401);
begin
  ControlData := @CControlData;
  TControlData2(CControlData).FirstEventOfs := Cardinal(@@FOnError) - Cardinal(Self);
end;

procedure TScriptControl.CreateControl;

  procedure DoCreate;
  begin
    FIntf := IUnknown(OleObject) as IScriptControl;
  end;

begin
  if FIntf = nil then DoCreate;
end;

function TScriptControl.GetControlInterface: IScriptControl;
begin
  CreateControl;
  Result := FIntf;
end;

function TScriptControl.Get_Modules: IScriptModuleCollection;
begin
    Result := DefaultInterface.Modules;
end;

function TScriptControl.Get_Error: IScriptError;
begin
    Result := DefaultInterface.Error;
end;

function TScriptControl.Get_CodeObject: IDispatch;
begin
    Result := DefaultInterface.CodeObject;
end;

function TScriptControl.Get_Procedures: IScriptProcedureCollection;
begin
    Result := DefaultInterface.Procedures;
end;

procedure TScriptControl._AboutBox;
begin
  DefaultInterface._AboutBox;
end;

procedure TScriptControl.AddObject(const Name: WideString; const Object_: IDispatch; 
                                   AddMembers: WordBool);
begin
  DefaultInterface.AddObject(Name, Object_, AddMembers);
end;

procedure TScriptControl.Reset;
begin
  DefaultInterface.Reset;
end;

procedure TScriptControl.AddCode(const Code: WideString);
begin
  DefaultInterface.AddCode(Code);
end;

function TScriptControl.Eval(const Expression: WideString): OleVariant;
begin
  Result := DefaultInterface.Eval(Expression);
end;

procedure TScriptControl.ExecuteStatement(const Statement: WideString);
begin
  DefaultInterface.ExecuteStatement(Statement);
end;

function TScriptControl.Run(const ProcedureName: WideString; var Parameters: PSafeArray): OleVariant;
begin
  Result := DefaultInterface.Run(ProcedureName, Parameters);
end;

procedure Register;
begin
  RegisterComponents(dtlOcxPage, [TScriptControl]);
end;

end.
