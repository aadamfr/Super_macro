unit ContextOfExecute;

interface

uses Forms, SysUtils, Dialogs, Controls,
     unit1, unit31;

type TContext = record
     MacroName : String[255];
     MacroDate : TDateTime;
     CurrentPosition : integer;
     command_disable : integer;
     NbrOrderExecute : integer;
     TempDepart : string[255];
     MainFormStatus : TWindowstate;
     VariableCount : integer;
     ListFileCount : integer;
     end;

const  NotRun = 0; Run = 1; StepByStep = 2; Pause = 3; BreakPoint = 4; StepByStepAndRun = 5;


procedure SaveContext(filename : String);
function LoadContext(filename : String) : TContext;
function LoadContextSimpleInfo(filename : String) : TContext;

procedure BlockReadAutoLen(var Fic : file; var Resultat : String);
procedure BlockWriteAutoLen(var Fic : file; Str : String);

var ExecutionType : cardinal = NotRun;
    FileName : String;

implementation

procedure BlockReadAutoLen(var Fic : file; var Resultat : String);
var Size: integer;
    Buffer: PChar;
begin
    BlockRead(Fic, Size, 4);
    GetMem(Buffer, Size);
    try
      BlockRead(Fic, Buffer^, Size);
      resultat := StrPas(Buffer);
      SetLength(resultat,Size);
    finally
      FreeMem(Buffer);
    end;
end;

procedure BlockWriteAutoLen(var Fic : file; Str : String);
var Size: integer;
    Buffer: PChar;
begin
    Size := length(Str);
    //GetMem(Buffer, Size);
    Buffer := Pchar(Str);
    try
      BlockWrite(Fic, Size, 4);
      BlockWrite(Fic, Buffer^, Size);
    finally
      //FreeMem(Buffer);
    end;
end;

procedure SaveContext(filename : String);
var FileSave : file;
    Context : TContext;
    i : integer;
begin
Context.MacroName := Form1.StatusBar1.Panels[0].Text;
Context.MacroDate := FileAge(Form1.StatusBar1.Panels[0].Text);
Context.CurrentPosition := unit1.pos_command;
//Context.command_disable := unit1.command_disable;
Context.NbrOrderExecute := unit1.NbrOrderExecute;
Context.TempDepart := unit1.TempDepart;
Context.MainFormStatus := unit1.MainFormStatus;
Context.VariableCount := Length(unit1.variable);
Context.ListFileCount := Length(unit1.ListFile.Name);

AssignFile(FileSave,filename);
rewrite(FileSave,1);
try
BlockWrite(FileSave,Context,SizeOf(TContext));

if length(unit1.variable) > 0
then begin
     for i := 0 to length(unit1.variable)-1
     do begin
        BlockWriteAutoLen(FileSave, unit1.variable[i].Name);
        BlockWriteAutoLen(FileSave, unit1.variable[i].Value);
        end;
     end;

if length(unit1.variable) > 0
then begin
     for i := 0 to length(unit1.ListFile.Name)-1
     do begin
        BlockWriteAutoLen(FileSave, unit1.ListFile.Name[i]);
        BlockWriteAutoLen(FileSave, IntToStr(FileAge(unit1.ListFile.Name[i])));
        BlockWriteAutoLen(FileSave, IntToStr(unit1.ListFile.Index[i]));
        end;
     end;

finally closefile(FileSave); end;
end;

function LoadContext(filename : String) : TContext;
var FileLoad : file;
    Context : TContext;
    i,j : integer;
    VarName, VarValue : String;
    StrFileAge, StrFilePos : String;
begin
AssignFile(FileLoad,filename);
reset(FileLoad,1);
try
BlockRead(FileLoad,Context,SizeOf(TContext));

if Context.MacroDate <> FileAge(Context.MacroName)
then if MessageDlg('La macro a été enregistrée après la sauvegarde du contexte d''exécution, voulez-vous tout de même reprendre l''exécution?',mtConfirmation, [mbYes, mbNo], 0) = mrNo
     then Exit;

if Context.MacroName <> Form1.StatusBar1.Panels[0].Text
then  Form1.openfilemacro(Context.MacroName,Form1.ListView1, -1,'Chargement des commandes en cours, veuillez patient SVP.');

unit1.pos_command := Context.CurrentPosition;
//unit1.command_disable := Context.command_disable;
unit1.NbrOrderExecute := Context.NbrOrderExecute;
unit1.TempDepart := Context.TempDepart;
unit1.MainFormStatus := Context.MainFormStatus;

SetLength(unit1.Variable,Context.VariableCount);

for i := 0 to Context.VariableCount -1
do begin
    BlockReadAutoLen(FileLoad, VarName);
    BlockReadAutoLen(FileLoad, VarValue);
   form1.WriteVariable('VAR',VarName,VarValue);
   end;

SetLength(unit1.ListFile.Name,Context.ListFileCount);
SetLength(unit1.ListFile.MemFile,Context.ListFileCount);
SetLength(unit1.ListFile.Index,Context.ListFileCount);

for i := 0 to Context.ListFileCount-1
do begin
   BlockReadAutoLen(FileLoad, unit1.ListFile.Name[i]);
   BlockReadAutoLen(FileLoad, StrFileAge);
   BlockReadAutoLen(FileLoad, StrFilePos);
   unit1.ListFile.Index[i] := StrToInt(StrFilePos);
   try
   assignfile(ListFile.memFile[i], ListFile.Name[i]);
   reset(ListFile.memFile[i]);
   for j := 1 to unit1.ListFile.Index[i]
   do readln(ListFile.memFile[i]);
   except Form1.ShowApplicationError('Fichier introuvable ou modifié après la sauvegarde du contexte.') end;
   end;


finally closefile(FileLoad); end;
end;

function LoadContextSimpleInfo(filename : String) : TContext;
var FileLoad : file;
    Context : TContext;
begin
AssignFile(FileLoad,filename);
reset(FileLoad,1);
try
BlockRead(FileLoad,Context,SizeOf(TContext));
finally closefile(FileLoad); end;
result := Context;
end;

end.
