unit CplBrd;

interface

uses SysUtils, Classes, Windows, Clipbrd;

function GetFormatNumber(const Name: WideString): UInt;
function GetFormatName(const Format: UInt): WideString;
procedure LoadClipboardFromFile(const FileName: WideString);
procedure SaveClipboardToFile(const FileName: WideString);
function SaveToCplFile(FileName : String) : Boolean;
function OpenToCplFile(FileName : String) : Boolean;

implementation

uses Unit1;


function GetFormatNumber(const Name: WideString): UInt;
begin
   if Name[1] = '#' then begin
     Result := StrToInt(Copy(Name, 2, MaxInt));
   end else begin
     Result := RegisterClipboardFormatW(PWideChar(Name));
   end;
end;

function GetFormatName(const Format: UInt): WideString;
var
   Len: Integer;
begin
   if Format < $c000 then begin
     Result := SysUtils.Format('#%u', [Format]);
   end else begin
     Len := 400;
     SetLength(Result, Len);
     Len := GetClipboardFormatNameW(Format, PWideChar(Result), Len);
     Win32Check(Len <> 0);
     SetLength(Result, Len);
   end;
end;

procedure LoadClipboardFromFile(const FileName: WideString);
var
   InHandle: THandle;
   InFile: TStream;
   Format: DWord;
   FormatName: WideString;
   NameLen: LongWord;
   Data: THandle;
   DataBuffer: Pointer;
   DataSize: LongWord;
begin
   Win32Check(OpenClipboard(0));
   try
     Win32Check(EmptyClipboard);
     InHandle := CreateFileW(PWideChar(FileName), Generic_Read, 0, nil, 
Open_Existing, File_Attribute_Archive or File_Flag_Sequential_Scan, 0);
     Win32Check(InHandle <> Invalid_Handle_Value);
     try
       InFile := THandleStream.Create(Integer(InHandle));
       try
         InFile.ReadBuffer(NameLen, SizeOf(NameLen));
         while NameLen <> 0 do begin
           SetLength(FormatName, NameLen);
           InFile.ReadBuffer(FormatName[1], NameLen * SizeOf(FormatName[1]));
           Format := GetFormatNumber(FormatName);

           InFile.ReadBuffer(DataSize, SizeOf(DataSize));
           Data := GlobalAlloc(GMem_Moveable or GMem_DDEShare, DataSize);
           Win32Check(Data <> 0);
           try
             DataBuffer := GlobalLock(Data);
             //Win32Check(Assigned(DataBuffer));
             try
               InFile.ReadBuffer(DataBuffer^, DataSize);
               SetClipboardData(Format, Data);
             finally
               GlobalUnlock(Data);
             end;
           except
             GlobalFree(Data);
             Form1.ErrorComportement(SysErrorMessage(GetlastError),4);
           end;

           InFile.ReadBuffer(NameLen, SizeOf(NameLen));
         end;
       finally
         InFile.Free;
       end;
     finally
       CloseHandle(InHandle);
     end;
   finally
     CloseClipboard;
   end;
end;

procedure SaveClipboardToFile(const FileName: WideString);
var
   OutHandle: THandle;
   OutFile: TStream;
   Format: DWord;
   FormatName: WideString;
   NameLen: LongWord;
   Data: THandle;
   DataBuffer: Pointer;
   DataSize: LongWord;
begin
   Win32Check(OpenClipboard(0));
   try
     OutHandle := CreateFileW(PWideChar(FileName), Generic_Write, 0,
nil, Create_Always, File_Attribute_Archive or File_Flag_Sequential_Scan, 0);
     Win32Check(OutHandle <> Invalid_Handle_Value);
     try
       OutFile := THandleStream.Create(Integer(OutHandle));
       try
         Format := EnumClipboardFormats(0);
         while Format <> 0 do try
           FormatName := GetFormatName(Format);
           NameLen := Length(FormatName);
           if NameLen = 0 then continue;
           OutFile.Write(NameLen, SizeOf(NameLen));
           if NameLen > 0 then OutFile.Write(FormatName[1], NameLen * SizeOf(FormatName[1]));
           Data := GetClipboardData(Format);
           //Win32Check(Data <> 0);

           DataBuffer := GlobalLock(Data);
           try
             DataSize := GlobalSize(Data);
             OutFile.Write(DataSize, SizeOf(DataSize));
             OutFile.Write(DataBuffer^, DataSize);
           finally
             GlobalUnlock(Data);
           end;
         finally
           Format := EnumClipboardFormats(Format);
         end;
         Assert(Format = 0);
         if GetLastError <> Error_Success then RaiseLastOSError;
         // Use 0 to designate end of data
         OutFile.Write(Format, SizeOf(Format));
       finally
         OutFile.Free;
       end;
     finally
       CloseHandle(OutHandle);
     end;
   finally
     CloseClipboard;
   end;
end;

function SaveToCplFile(FileName : String) : Boolean;
begin
result := False;
if ExtractFileExt(FileName) <> '.clp'
then Exit;
try
SaveClipboardToFile(FileName);
finally Result := True; end;
end;

function OpenToCplFile(FileName : String) : Boolean;
begin
result := False;
if ExtractFileExt(FileName) <> '.clp'
then Exit;
try
LoadClipboardFromFile(FileName);
finally Result := True; end;
end;

end.
