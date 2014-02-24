unit uDebugEx;

interface

uses
  Contnrs, Windows, Classes, SysUtils, Dialogs, Forms;

  function LoadAndParseMapFile: Boolean;
  procedure CleanUpMapFile;
  function GetMapAddressFromAddress(const Address: DWORD): DWORD;
  function GetMapFileName: string;
  function GetModuleNameFromAddress(const Address: DWORD): string;
  function GetProcNameFromAddress(const Address: DWORD): string;
  function GetLineNumberFromAddress(const Address: DWORD): string;

var
  Units,
  Procedures,
  LineNumbers: TList;

implementation

const
  { Sections in .map file }
  NAME_CLASS          = 'StartLengthNameClass';
  SEGMENT_MAP          = 'Detailedmapofsegments';
  PUBLICS_BY_NAME      = 'AddressPublicsbyName';
  PUBLICS_BY_VAL      = 'AddressPublicsbyValue';
  LINE_NUMBERS        = 'Linenumbersfor';
  RESOURCE_FILES      = 'Boundresourcefiles';

type
  { Sections as enum }
  THeaderType = (htNameClass, htSegmentMap, htPublicsByName, htPublicsByValue,
    htLineNumbers, htResourceFiles);

  { unitname / pointeraddress pair -> olUnits }
  PUnitItem = ^TUnitItem;
  TUnitItem = record
    UnitName: string;
    UnitStart,
    UnitEnd: DWORD;
  end;

  { procedurename / pointeraddress pair -> olProcedures }
  PProcedureItem = ^TProcedureItem;
  TProcedureItem = record
    ProcName: string;
    ProcStart: DWORD;
  end;

  { linenumber / pointeraddress pair -> olLineNumbers }
  PLineNumberItem = ^TLineNumberItem;
  TLineNumberItem = record
    UnitName,
    LineNo: string;
    LineStart: DWORD;
  end;

function StripFromString(const Strip: char; var AString: string): string;
var
  Pos: Cardinal;
begin
  Pos := Length(AString);
  while Pos > 0 do
  begin
    Application.ProcessMessages;
    if AString[Pos] = Strip then
      Delete(AString, Pos, Length(Strip))
    else
      Dec(Pos);
  end;
  Result := AString;
end;

function LoadAndParseMapFile: Boolean;
var
  F: TextFile;
  CurrentLine,
  CurrentUnit: string;
  CurrentHeader: THeaderType;

  { helper func of SyncHeaders }
  function CompareHeaders(AHeader, ALine: string): Boolean;
  begin
    Result := Copy(ALine, 1, Length(AHeader)) = AHeader;
  end;

  { Keeps track of section in .map file }
  procedure SyncHeaders(var Header: THeaderType; Line: string);
  const
    Pfx = Length('Line numbers for ');
  begin
    Application.ProcessMessages;
    Line := StripFromString(' ', Line);

    if CompareHeaders(NAME_CLASS, Line)      then Header := htNameClass;
    if CompareHeaders(SEGMENT_MAP, Line)    then Header := htSegmentMap;
    if CompareHeaders(PUBLICS_BY_NAME, Line) then Header := htPublicsByName;
    if CompareHeaders(PUBLICS_BY_VAL, Line)  then Header := htPublicsByValue;
    if CompareHeaders(LINE_NUMBERS, Line)    then
    begin
      Header := htLineNumbers;
      CurrentUnit := Copy(Line, Pfx -2, Pos('(', Line) - Pfx + 2);
    end;
    if CompareHeaders(RESOURCE_FILES, Line)  then Header := htResourceFiles;
  end;

  { Adds a segment from .map to segment-list }
  procedure AddUnit(ALine: string);
  var
    SStart: string;
    SLength: string;
    AUnitItem: PUnitItem;
  begin
    if StrToInt(Trim(Copy(ALine, 1, Pos(':', ALine) -1))) = 1 then
    begin
      Application.ProcessMessages;
      SStart  := Copy(ALine, Pos(':', ALine) + 1, 8);
      SLength := Copy(ALine, Pos(':', ALine) + 10, 8);
      New(AUnitItem);
      with AUnitItem^ do
      begin
        UnitStart := StrToInt('$' + SStart);
        UnitEnd  := UnitStart + DWORD(StrToInt('$' + SLength));
        Delete(ALine, 1, Pos('M', ALine) + 1);
        UnitName := Copy(ALine, 1, Pos(' ', ALine) -1);
      end;
      Units.Add(AUnitItem);
    end;
  end;

  { Adds a public procedure from .map to procedure-list }
  procedure AddProcedure(ALine: string);
  var
    SStart: string;
    AProcedureItem: PProcedureItem;
  begin
    Application.ProcessMessages;
    if StrToInt(Trim(Copy(ALine, 1, Pos(':', ALine) -1))) = 1 then
    begin
      SStart  := Copy(ALine, Pos(':', ALine) + 1, 8);
      New(AProcedureItem);
      with AProcedureItem^ do
      begin
        ProcStart := StrToInt('$' + SStart);
        Delete(ALine, 1, Pos(':', ALine) + 1);
        ProcName  := Trim(Copy(ALine, Pos(' ', ALine), Length(ALine) - Pos(' ', ALine) + 1));
      end;
      Procedures.Add(AProcedureItem);
    end;
  end;

  { Adds a lineno from .map to lineno-list }
  procedure AddLineNo(ALine: string);
  var
    ALineNumberItem: PLineNumberItem;
  begin
    while Length(Trim(ALine)) > 0 do
    begin
      Application.ProcessMessages;
      New(ALineNumberItem);
      with ALineNumberItem^ do
      begin
        Aline    := Trim(ALine);
        UnitName  := CurrentUnit;
        LineNo    := Copy(ALine, 1, Pos(' ', ALine)-1);
        Delete(ALine, 1, Pos(' ', ALine) + 5);
        LineStart := StrToInt('$' + Copy(ALine, 1, 8));
        Delete(ALine, 1, 8);
      end;
      Application.ProcessMessages;
      LineNumbers.Add(ALineNumberItem);
    end;
  end;

{ procedure TExtExceptionInfo.LoadAndParseMapFile }
begin
  Units      := TList.Create;
  Procedures  := TList.Create;
  LineNumbers := TList.Create;

  if FileExists(GetMapFileName) then
  begin
    AssignFile(F, GetMapFileName);
    Reset(F);
    while not EOF(F) do
    begin
      Application.ProcessMessages;
      ReadLn(F, CurrentLine);
      SyncHeaders(CurrentHeader, CurrentLine);
      if Length(CurrentLine) > 0 then
        if (Pos(':', CurrentLine) > 0) and (CurrentLine[1] = ' ') then
          case CurrentHeader of
            htSegmentMap:    AddUnit(CurrentLine);
            htPublicsByValue: AddProcedure(CurrentLine);
            htLineNumbers:    AddLineNo(CurrentLine);
          end;
      Application.ProcessMessages;
    end;
    CloseFile(F);
    Result :=
      (Units.Count > 0) and
      (Procedures.Count > 0) and
      (LineNumbers.Count > 0);
  end
  else
    Result := False;
end;

procedure CleanUpMapFile;
begin
  if Units.Count > 0 then
    while Units.Count > 0 do
    begin
      Dispose(PUnitItem(Units.Items[0]));
      Units.Delete(0);
    end;
  if Procedures.Count > 0 then
    while Procedures.Count > 0 do
    begin
      Dispose(PProcedureItem(Procedures.Items[0]));
      Procedures.Delete(0)
    end;
  if LineNumbers.Count > 0 then
    while LineNumbers.Count > 0 do
    begin
      Dispose(PLineNumberItem(LineNumbers.Items[0]));
      LineNumbers.Delete(0);
    end;

  FreeAndNil(Units);
  FreeAndNil(Procedures);
  FreeAndNil(LineNumbers);
end;

function GetModuleNameFromAddress(const Address: DWORD): string;
var
  i: Integer;
begin
  for i := Units.Count -1 downto 0 do
    if ((PUnitItem(Units.Items[i])^.UnitStart <= Address) and
      (PUnitItem(Units.Items[i])^.UnitEnd >= Address)) then
    begin
      Result := PUnitItem(Units.Items[i])^.UnitName;
      Break;
    end;
end;

function GetProcNameFromAddress(const Address: DWORD): string;
var
  i: Integer;
begin
  for i := Procedures.Count -1 downto 0 do
    if (PProcedureItem(Procedures.Items[i])^.ProcStart <= Address) then
    begin
      Result := PProcedureItem(Procedures.Items[i])^.ProcName;
      Break;
    end;
end;

function GetLineNumberFromAddress(const Address: DWORD): string;
var
  i: Cardinal;
  LastLineNo: string;
  UnitName: string;
begin
  Result    := '';
  LastLineNo := '';
  UnitName  := GetModuleNameFromAddress(Address);

  for i := 0 to LineNumbers.Count -1 do
    if PLineNumberItem(LineNumbers.Items[i])^.UnitName = UnitName then
      if (PLineNumberItem(LineNumbers.Items[i])^.LineStart >= Address) then
      begin
        Result := LastLineNo;
        Break;
      end
      else
        LastLineNo := PLineNumberItem(LineNumbers.Items[i])^.LineNo;
end;

function GetMapFileName: string;
begin
  Result := ChangeFileExt(ParamStr(0), '.map');
end;

function GetMapAddressFromAddress(const Address: DWORD): DWORD;
const
  CodeBase = $1000;
var
  OffSet: DWORD;
  ImageBase: DWORD; //$400000: hInstance or GetModuleHandle(0)
begin
  ImageBase := hInstance;
  OffSet := ImageBase + CodeBase;

  // Map file address = Access violation address - Offset
  Result := Address - OffSet;
end;

end.

 