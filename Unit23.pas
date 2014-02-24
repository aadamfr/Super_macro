unit Unit23;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, jpeg, ExtCtrls, ComCtrls,AdCPUUsage, DateUtils, Registry;

const MyUrl = 'http://adam.denadai.free.fr';
      MyUrlPlugins = 'http://adam.denadai.free.fr/index.php?page=Plugins';
      MyAddr = 'aadamfr@yahoo.fr';


type
  TForm23 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Timer1: TTimer;
    Shape1: TShape;
    Label7: TLabel;
    Label9: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Image1: TImage;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    ComboBox1: TComboBox;
    Label13: TLabel;
    Bevel1: TBevel;
    Label14: TLabel;
    Label15: TLabel;
    Label6: TLabel;
    Label16: TLabel;
    Bevel2: TBevel;
    Shape4: TShape;
    Shape5: TShape;
    Image2: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure Image2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  function ApplicationVersion() : String;
  function GetInternetExplorerVersion():String;
  function GetCPUPercent(): double;
  function PDHCPUTotal(): Double;
  function PDHCPUSM(): Double;
  function ComputerName: string;
  end;

var
  Form23: TForm23;
  ver : string = '0.00';
  Lng_LastUpdate : String = 'Dernière mise à jour : ';
  Lng_UsedCpu : String = 'Utilisation CPU %5.2f%%';
  Lng_Memory : String = 'Mémoire physique %d';
  Lng_TotalMemory : String = 'Total %.0n Ko';
  Lng_UsedMemory : String = 'Disponible %.0n Ko';
  hQuery : Thandle ;
  HCounter1,HCounter2 : Thandle;
  CanPDH : Boolean;
implementation
Uses ShellApi, Unit1, PDH;
{$R *.DFM}

function TForm23.ComputerName: string;
var
  lpBuffer: array[0..MAX_COMPUTERNAME_LENGTH] of char;
  nSize: dword;
begin
  nSize:= Length(lpBuffer);
  if GetComputerName(lpBuffer, nSize) then
    result:= lpBuffer
  else
    result:= '';
end;


function TForm23.PDHCPUTotal(): Double;
var PdhFmtCounterValue : PDH_FMT_COUNTERVALUE;
  ctrType : LongWord;
  dwResult  : Longint ;
begin
result := 0;
if CanPDH = False then exit;
dwResult:=PdhCollectQueryData(hQuery);
if dwResult=0
then begin
     dwResult:=PdhGetFormattedCounterValue(hCounter1, PDH_FMT_DOUBLE , @ctrType, @PdhFmtCounterValue);
     if dwResult=0 Then result := PdhFmtCounterValue.doubleValue;
     end;
end;


function TForm23.PDHCPUSM(): Double;
var PdhFmtCounterValue : PDH_FMT_COUNTERVALUE;
  ctrType : LongWord;
  dwResult  : Longint ;
begin
result := 0;
if CanPDH = False then exit;
dwResult:=PdhGetFormattedCounterValue(hCounter2, PDH_FMT_DOUBLE , @ctrType, @PdhFmtCounterValue);
If dwResult=0 Then result := PdhFmtCounterValue.doubleValue;
end;

function TForm23.ApplicationVersion(): String;
var
  VerInfoSize, VerValueSize, Dummy: DWord;
  VerInfo: Pointer;
  VerValue: PVSFixedFileInfo;
begin
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  {Deux solutions : }
  if VerInfoSize <> 0 then
  {- Les info de version sont inclues }
  begin
    {On alloue de la mémoire pour un pointeur sur les info de version : }
    GetMem(VerInfo, VerInfoSize);
    {On récupère ces informations : }
    GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
    VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
    {On traite les informations ainsi récupérées : }
    with VerValue^ do
    begin
      Result := IntTostr(dwFileVersionMS shr 16);
      Result := Result + '.' + IntTostr(dwFileVersionMS and $FFFF);
      Result := Result + '.' + IntTostr(dwFileVersionLS shr 16);
      Result := Result + '.' + IntTostr(dwFileVersionLS and $FFFF);
    end;

    {On libère la place précédemment allouée : }
    FreeMem(VerInfo, VerInfoSize);
  end

  else Result := '0';
end;

function TForm23.GetInternetExplorerVersion():String;
const USERS: array[Boolean] of Cardinal = (HKEY_CURRENT_USER, HKEY_LOCAL_MACHINE);
      KEY = 'SOFTWARE\Microsoft\Internet Explorer';
var Reg: TRegistry;
begin
Reg := TRegistry.Create;
try
   Reg.RootKey := USERS[True];
   Reg.OpenKey(Key, True);
   result := Reg.ReadString('Version');
   if result = '' then result := 'Unknow';
finally Reg.Free; end;
end;

procedure TForm23.Image2Click(Sender: TObject);
begin
ShellExecute(handle,'Open', Pchar('http://adam.denadai.free.fr/index.php?page=gratteware'),'','',SW_SHOWNORMAL);

end;

procedure TForm23.Button1Click(Sender: TObject);
begin
form23.Close;
end;

procedure TForm23.Label2Click(Sender: TObject);
begin
ShellExecute(handle,'Open',  'mailto:'+MyAddr+'?subject=SuperMacro&body= ','','',SW_SHOWNORMAL);
end;

procedure TForm23.FormShow(Sender: TObject);
var szCounterPath     : String;
    dwResult  : Longint ;
begin
Label6.Caption := 'Internet Explorer Version : '+ GetInternetExplorerVersion;
Timer1.Enabled := True;
label3.Caption := Lng_LastUpdate +  unit1.DateCreation;
case VersionType of
 1: label15.Caption := ver;
 2: Label15.Caption := ver +' BETA';
 3: Label15.Caption := ver +' TEST';
 end;
Label16.Caption := Format(Lng_UsedCpu,[0.00]);
if Combobox1.Items.Count = 6
then begin
     if GetPriorityClass(GetCurrentProcess) = REALTIME_PRIORITY_CLASS then Combobox1.ItemIndex := 0;
     if GetPriorityClass(GetCurrentProcess) = HIGH_PRIORITY_CLASS then Combobox1.ItemIndex := 1;
     if GetPriorityClass(GetCurrentProcess) = NORMAL_PRIORITY_CLASS then Combobox1.ItemIndex := 3;
     if GetPriorityClass(GetCurrentProcess) = IDLE_PRIORITY_CLASS then Combobox1.ItemIndex := 5;
     end;

//PDH

CanPDH := PDH.LoadPdh;
if CanPDH = False then Exit;
dwResult:=PdhOpenQuery(nil,0, @hQuery);
If dwResult=0
then begin
     szCounterPath:='\Processeur(_Total)\\% Temps Processeur';
     try
     if PdhAddCounter(hQuery,Pchar(szCounterPath),0,@hcounter1) <> ERROR_SUCCESS
     then CanPDH := False;
     except CanPDH := False end;
     szCounterPath:='\Processus(super_macro)\% Temps processeur';
     try
     if PdhAddCounter(hQuery,Pchar(szCounterPath),0,@hcounter2) <> ERROR_SUCCESS
     then CanPDH := False
     except CanPDH := False end;
     end;
end;

procedure TForm23.Label4Click(Sender: TObject);
begin
ShellExecute(handle,'Open', Pchar(MyUrl),'','',SW_SHOWNORMAL);
end;

function TForm23.GetCPUPercent(): double;
var i : integer;
begin
Result :=0;
CollectCPUData; // Get the data for all processors
for i:=0 to GetCPUCount-1 do // Show data for each processor
result := GetCPUUsage(i)*100;
if result < 0 then result := 0;
if result > 100 then result := 100;
end;


procedure TForm23.Timer1Timer(Sender: TObject);
var ms : TMemoryStatus;
// DPH
  CPUTotal, CPUSM : Double;
begin
ms.dwLength := sizeof(ms);
GlobalMemoryStatus(ms);

if CanPDH = False// test si est possible d'utiliser la dll PDH.dll suivant la version Win (95, ME = False)
then begin
     CPUTotal := GetCPUPercent;
     Shape4.Width := 0;
     Label16.Caption := Format(Lng_UsedCpu,[CPUTotal]);
     Shape5.width := Trunc(CPUTotal) * (Bevel2.Width div 100);
     end
else begin
     try
     CPUTotal :=  PDHCPUTotal;
     CPUSM := PDHCPUSM;
     CPUSM := (CPUTotal /100) * CPUSM;
     Shape4.Width := (Bevel2.Width div 100) * Trunc(CPUSM);
     Label16.Caption := Format(Lng_UsedCpu,[CPUTotal]) +' - SM CPU '+Format('%5.2f%%',[CPUSM]);
     Shape5.Width := Trunc(CPUTotal) * (Bevel2.Width  div 100);;
     except CanPDH := False end;
     end;

label10.caption := Format(Lng_Memory,[ms.dwMemoryLoad]) + ' %';
label11.caption := Format(Lng_TotalMemory, [ms.dwTotalPhys     / 1024]);
label12.caption := Format(Lng_UsedMemory, [ms.dwAvailPhys     / 1024]);
if label2.Caption <> MyAddr then label2.Caption := MyAddr;
if label4.Caption <> MyURL then label4.Caption := MyURL;
end;

procedure TForm23.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Timer1.Enabled := False;
PdhCloseQuery(hQuery);
end;

procedure TForm23.FormCreate(Sender: TObject);
begin
ver := ApplicationVersion;
image1.Picture.Assign(Application.Icon);
end;

procedure TForm23.ComboBox1Change(Sender: TObject);
var return : Boolean;
    MainProcessId : cardinal;
const THREAD_PRIORITY_CRITICAL = 15;
begin

// ABOVE_NORMAL_PRIORITY_CLASS // +
// BELOW_NORMAL_PRIORITY_CLASS // -

MainProcessId := GetCurrentProcess;
case ComboBox1.ItemIndex of
    0,1 : return := SetPriorityClass(MainProcessId,REALTIME_PRIORITY_CLASS);
      2 : return := SetPriorityClass(MainProcessId,HIGH_PRIORITY_CLASS);
      3 : return := SetPriorityClass(MainProcessId,NORMAL_PRIORITY_CLASS);
    4,5 : return := SetPriorityClass(MainProcessId,IDLE_PRIORITY_CLASS);
    else return := False;
    end;
if return = False then ShowMessage(SysErrorMessage(GetLastError)+ ' (Priority ['+ IntToStr(ComboBox1.ItemIndex) +'])');
if Form23.Visible = True then Form23.SetFocus;
end;

end.
