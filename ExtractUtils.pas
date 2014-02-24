{|===============================================================================|
 |                                                                               |
 |                              H E R E A   S O F T                              |
 |                           Unité : ExtractUtils.pas                            |
 |                        Ecrit par : Alexandre le Grand                         |
 |                  e-mail : alexandre.le.grand@libertysurf.fr                   |
 |                    Copyright : (c)mercredi 21 février 2001                    |
 |                                                                               |
 |                                Version : 1.0.0                                |
 |                                                                               |
 |===============================================================================|}

Unit ExtractUtils;

Interface
Uses SysUtils;

Type
  MakeIntResource = PAnsiChar;
  THandle = LongWord;
  BOOL = LongBool;
  DWORD = LongWord;
  UINT = LongWord;
  HWND = LongWord;
  HICON = LongWord;
  LPARAM = Longint;
  WPARAM = LongInt;
  LRESULT = Longint;
  HCURSOR = HICON;
  HINST = LongWord;
  TFNDlgProc = Pointer;
  TBrowseInfo = Packed Record
    hwndOwner : HWND;
    pidlRoot : THandle;
    pszDisplayName : PAnsiChar;
    lpszTitle : PAnsiChar;
    ulFlags : UINT;
    lpfn : pointer;
    lParam : LPARAM;
    iImage : Integer;
  End;
Const
  IDC_WAIT = MakeIntResource(32514);
  FILE_ATTRIBUTE_DIRECTORY = $00000010;
  MAX_PATH = 260;
  IDOK = 1;
  IDCANCEL = 2;
  IDYES = 6;
  IDNO = 7;
  IDALL = 9;
  IDLABEL = 10;
  IDTEXT = 11;
  IDBROWSE = 12;
  MB_OK = $00000000;
  WM_PAINT = $000F;
  WM_COMMAND = $0111;
  WM_SHOWWINDOW = $0018;

Function SendMessage(hWnd : HWND;Msg : UINT;wParam : WPARAM;lParam : LPARAM) : LRESULT;stdcall;external 'user32.dll' name 'SendMessageA';
Function GetCursor : HCURSOR;Stdcall;External 'user32.dll' name 'GetCursor';
Function LoadCursor(hInstance : HINST;lpCursorName : PAnsiChar) : HCURSOR;Stdcall;External 'user32.dll' name 'LoadCursorA';
Function SetCursor(hCursor : HICON) : HCURSOR;Stdcall;External 'user32.dll' name 'SetCursor';
Function GetWindowText(hWnd : HWND;lpString : PChar;nMaxCount : Integer) : Integer;Stdcall;External 'user32.dll' name 'GetWindowTextA';
Function EndDialog(hDlg : HWND;nResult : Integer) : BOOL;Stdcall;External 'user32.dll' name 'EndDialog';
Function DialogBoxParam(hInstance : HINST;lpTemplateName : PChar;
  hWndParent : HWND;lpDialogFunc : TFNDlgProc;dwInitParam : LPARAM) : Integer;Stdcall;External 'user32.dll' name 'DialogBoxParamA';
Function MessageBox(hWnd : HWND;lpText, lpCaption : PChar;uType : UINT) : Integer;Stdcall;External 'user32.dll' name 'MessageBoxA';
Function GetCommandLine : PChar;Stdcall;External 'kernel32.dll' name 'GetCommandLineA';
Function SetWindowText(hWnd : HWND;lpString : PChar) : BOOL;Stdcall;External 'user32.dll' name 'SetWindowTextA';
Function GetDlgItem(hDlg : HWND;nIDDlgItem : Integer) : HWND;Stdcall;External 'user32.dll' name 'GetDlgItem';
Function GetFileAttributes(lpFileName : PChar) : DWORD;stdcall;external 'kernel32.dll' name 'GetFileAttributesA';
Function SetFocus(hWnd : HWND) : HWND;stdcall;external 'user32.dll' name 'SetFocus';
Function SHBrowseForFolder(Var bi : TBrowseInfo) : THandle;Stdcall;External
'shell32.dll' name 'SHBrowseForFolderA';
Function SHGetPathFromIDList(id : THandle;Path : PChar) : Bool;Stdcall;External
'shell32.dll' name 'SHGetPathFromIDListA';
Function DialogBox(hInstance : HINST;lpTemplate : PChar;
  hWndParent : HWND;lpDialogFunc : TFNDlgProc) : Integer;
Procedure ZeroMemory(Destination : Pointer;Length : DWORD);
Function DirectoryExists(Const Name : String) : Boolean;
Procedure ForceDirectories(Dir : String);
Function FormatPath(Path : String) : String;
Function Encrypt1(Str : String;Index : Integer) : String;
Function FilePathWithoutDrive(FilePath : String) : String;
Function LastDir(Path : String) : String;

Implementation

Function DialogBox(hInstance : HINST;lpTemplate : PChar;
  hWndParent : HWND;lpDialogFunc : TFNDlgProc) : Integer;
Begin
  Result := DialogBoxParam(hInstance, lpTemplate, hWndParent,
    lpDialogFunc, 0);
End;

//------------------------------------------------------------------------------

Procedure ZeroMemory(Destination : Pointer;Length : DWORD);
Begin
  FillChar(Destination^, Length, 0);
End;

//------------------------------------------------------------------------------

Function DirectoryExists(Const Name : String) : Boolean;
Var
  Code : Integer;
Begin
  Code := GetFileAttributes(PChar(Name));
  Result := (Code <> -1) And (FILE_ATTRIBUTE_DIRECTORY And Code <> 0);
End;

//------------------------------------------------------------------------------

Procedure ForceDirectories(Dir : String);
Begin
  If (AnsiLastChar(Dir) <> Nil) And (AnsiLastChar(Dir)^ = '\') Then
    Delete(Dir, Length(Dir), 1);
  If (Length(Dir) < 3) Or DirectoryExists(Dir)
    Or (ExtractFilePath(Dir) = Dir) Then Exit;
  ForceDirectories(ExtractFilePath(Dir));
  CreateDir(Dir);
End;

//------------------------------------------------------------------------------

Function FormatPath(Path : String) : String;
// Formate un chemin sans anti-slash après le dernier répertoire
Var
  I : Integer;
Begin
  Path := Trim(Path);
  For I := Length(Path) Downto 1 Do
    If Path[I] = '\' Then
      Path := Copy(Path, 1, I - 1)
    Else
      Break;
  Result := Path;
End;

//------------------------------------------------------------------------------

Function Encrypt1(Str : String;Index : Integer) : String;
//En cryptage d'une chaîne avec un décalage de Index et une inversion de la chaîne
Var
  I : Integer;
Begin
  Result := '';
  For I := Length(Str) Downto 1 Do
  Begin
    Str[I] := Chr(Ord(Str[I]) + Index);
    Result := Result + Str[I];
  End;
End;

//------------------------------------------------------------------------------

Function FilePathWithoutDrive(FilePath : String) : String;
// Renvoie le chemin sans le lecteur
Begin
  FilePath := Copy(FilePath, Pos(':', FilePath) + 1, Length(FilePath));
  While Pos('\', FilePath) = 1 Do
    FilePath := Copy(FilePath, 2, Length(FilePath));
  Result := FilePath;
End;

//------------------------------------------------------------------------------

Function LastDir(Path : String) : String;
// Renvoie le dernier répertoire d'un chemin
Var
  I : Integer;
Begin
  Path := FormatPath(Path);
  For I := Length(Path) Downto 1 Do
    If Path[I] = '\' Then
    Begin
      Path := Copy(Path, I + 1, Length(Path));
      Break;
    End;
  Result := Path;
End;
End.

