unit VisualEffect;

interface

uses Windows,messages, SysUtils, Forms, ShellApi;

Const WM_VISUALEFFECTGIF = WM_USER + 8001;
      WM_VISUALEFFECTDESC = WM_USER + 8002;
      WM_VISUALEFFECTSHOW = WM_USER + 8003;
      WM_VISUALEFFECTHIDE = WM_USER + 8004;
      WM_VISUALEFFECTQUIT = WM_USER + 8005;
      WM_VISUALEFFECTRESIZE = WM_USER + 8006;
      WM_VISUALEFFECTMOVE = WM_USER + 8007;

procedure VisualEffectLoad(GifName : string; Pos,Size : Tpoint; Show : Boolean = True);
procedure VisualEffectHintInfo(Text : String);
procedure VisualEffectQuit();

implementation

procedure VisualEffectLoad(GifName : string; Pos,Size : Tpoint; Show : Boolean = True);
var Handle : HWND;
    VisualEffectExe : String;
    nAtom : word;
begin
Handle := FindWindow('TVisualEffectforSM',nil);
if Handle = 0
then begin
     VisualEffectExe := ExtractFileDir(Application.ExeName) + '\VisualEffect.exe';
     if not FileExists(VisualEffectExe) then Exit;
     ShellExecute(Application.MainFormHandle,'Open',  PChar(VisualEffectExe) ,'','',SW_SHOWNORMAL);
     SleepEx(800,False);
     Application.ProcessMessages;
     Handle := FindWindow('TVisualEffectforSM',nil);
     end;
if Handle = 0 then Exit;
nAtom := GlobalAddAtom(Pchar(GifName));
SendMessage(Handle,WM_VISUALEFFECTGIF,0,nAtom);
GlobalDeleteAtom(nAtom);
SendMessage(Handle,WM_VISUALEFFECTMOVE,Pos.X,Pos.Y);
SendMessage(Handle,WM_VISUALEFFECTSHOW,0,0);
end;

procedure VisualEffectHintInfo(Text : String);
var Handle : HWND;
    VisualEffectExe : String;
    nAtom : word;
begin
Handle := FindWindow('TVisualEffectforSM',nil);
if Handle = 0
then begin
     VisualEffectExe := ExtractFileDir(Application.ExeName) + '\VisualEffect.exe';
     if not FileExists(VisualEffectExe) then Exit;
     ShellExecute(Application.MainFormHandle,'Open',  PChar(VisualEffectExe) ,'','',SW_SHOWNORMAL);
     SleepEx(800,False);
     Application.ProcessMessages;
     Handle := FindWindow('TVisualEffectforSM',nil);
     end;
if Handle = 0 then Exit;
nAtom := GlobalAddAtom(Pchar(Text));
SendMessage(Handle,WM_VISUALEFFECTDESC,0,nAtom);
GlobalDeleteAtom(nAtom);
end;

procedure VisualEffectQuit();
var Handle : HWND;
    VisualEffectExe : String;
begin
Handle := FindWindow('TVisualEffectforSM',nil);
if Handle = 0
then begin
     VisualEffectExe := ExtractFileDir(Application.ExeName) + '\VisualEffect.exe';
     if not FileExists(VisualEffectExe) then Exit;
     ShellExecute(Application.MainFormHandle,'Open',  PChar(VisualEffectExe) ,'','',SW_SHOWNORMAL);
     SleepEx(800,False);
     Application.ProcessMessages;
     Handle := FindWindow('TVisualEffectforSM',nil);
     end;
if Handle = 0 then Exit;
SendMessage(Handle,WM_VISUALEFFECTQUIT,0,0);
end;

end.
