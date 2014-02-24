Unit rm_Utils;

Interface
Uses windows, SysUtils, classes, Controls, ShellApi, Forms;

{$WARN SYMBOL_PLATFORM OFF}

Const
  shSmallIcon = SHGFI_SMALLICON;
  shLargeIcon = SHGFI_LARGEICON;
  shIcon = SHGFI_ICON;

Function FormatPath(Path : String) : String;
Function FilePathWithoutExt(FilePath : String) : String;
Function Encrypt1(Str : String;Index : Integer) : String;
Function FilePathWithoutDrive(FilePath : String) : String;
Function LastDir(Path : String) : String;
Procedure Kill(DirPath : String;Search : String;SubDirectories : Bool = False;KIllDir : Bool = False);
Procedure FindFiles(DirPath : String;Search : String;Var Files : TStrings;SubDirectories : Bool = False;FullPath : Bool = False);
Procedure GetFilesImageList(Option : Integer;Var ImageList : TImageList);
Function GetFileTypeDescription(FilePath : String;UseAttr : Bool) : String;
Function GetFileIconIndex(FilePath : String;UseAttr : Bool;Large : Bool = false;Open : Bool = False) : Integer;
Function GetFileStrSize(Size : Integer) : String;
Function GetFileStrAttrib(Attrib : Integer;FullName : Bool = True) : String;
Function IsInStrings(Str : String;Strings : TStrings) : Bool;
Function CompareBuf(Buf1 : Array Of Char;Buf2 : Array Of Char;NumRead : Integer) : Bool;
Function GetWinTempDir() : String;
Function ShellFile(FilePath : String;CommandLine : String;FileOp : String = 'OPEN';Sw : Integer = SW_SHOW) : Longword;
Function ShellFileEx(FilePath : String;Commandline : String;fileop : String = 'OPEN';Sw : Integer = SW_SHOW;WaitEnd : Bool = False) : Longword;

Implementation

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

Function LeftCut(Str : String;Delimiters : Array Of Char;Include : Bool;Complement : Bool) : String;
//Découpage d'une chaîne par la gauche
Var
  I, Pos : Integer;
Begin
  Result := Str;
  For I := 1 To Length(Str) Do
    If IsDelimiter(Delimiters, Str[I], 1) Then
    Begin
      If Complement Then
      Begin
        If Include Then
          Pos := I
        Else
          Pos := I + 1;
        Result := Copy(Str, Pos, Length(Str));
      End
      Else
      Begin
        If Include Then
          Pos := I
        Else
          Pos := I - 1;
        Result := Copy(Str, 1, Pos);
      End;
      Break;
    End;
End;

//------------------------------------------------------------------------------

Function RightCut(Str : String;Delimiters : Array Of Char;Include : Bool;Complement : Bool) : String;
//Découpage d'une chaîne par la droite
Var
  I, Pos : Integer;
Begin
  Result := Str;
  For I := Length(Str) Downto 1 Do
    If IsDelimiter(Delimiters, Str[I], 1) Then
    Begin
      If Complement Then
      Begin
        If Include Then
          Pos := I
        Else
          Pos := I - 1;
        Result := Copy(Str, 1, Pos);
      End
      Else
      Begin
        If Include Then
          Pos := I
        Else
          Pos := I + 1;
        Result := Copy(Str, Pos, Length(Str));
      End;
      Break;
    End;
End;

//------------------------------------------------------------------------------

Function FilePathWithoutExt(FilePath : String) : String;
// Renvoie un chemin sans l'extension du fichier
Var
  I : Integer;
Begin
  FilePath := Trim(FilePath);
  For I := Length(FilePath) Downto 1 Do
    If FilePath[I] = '.' Then
    Begin
      FilePath := Copy(FilePath, 1, I - 1);
      Break;
    End;
  Result := FilePath;
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

//------------------------------------------------------------------------------

Procedure Kill(DirPath : String;Search : String;SubDirectories : Bool = False;KIllDir : Bool = False);
// Supprime des fichiers d'un répertoire
Var
  FileInfo : TSearchRec;

Begin
  Try
    If FindFirst(DirPath + '\*.*', faAnyFile, FileInfo) = 0 Then
    Begin
      Repeat
        If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then
        Begin
          If (FileInfo.Attr And faDirectory) = faDirectory Then
          Begin
            If SubDirectories Then
              KIll(DirPath + '\' + FileInfo.Name, Search, SubDirectories, KillDir);
          End
          Else
          Begin
            If (UpperCase('*' + ExtractFileExt(FileInfo.Name)) = UpperCase(Search)) Or (Search = '*.*') Then
            Begin
              If (FileGetAttr(DirPath + '\' + FileInfo.Name) And faReadOnly) > 0 Then
                FileSetAttr(DirPath + '\' + FileInfo.Name, faArchive);
              DeleteFile(DirPath + '\' + FileInfo.Name);
            End;
          End;
        End;
      Until FindNext(FileInfo) <> 0;
    End;
  Finally
    FindClose(FileInfo);
  End;
  If KillDir Then RemoveDir(DirPath);
End;

//------------------------------------------------------------------------------

Procedure FindFiles(DirPath : String;Search : String;Var Files : TStrings;SubDirectories : Bool = False;FullPath : Bool = False);
// Renvoie les fichiers d'un répertoire
Var
  FileInfo : TSearchRec;
Begin
  If Not Assigned(Files) Then Files := TStringList.Create;
  DirPath := FormatPath(DirPath);
  Try
    If FindFirst(DirPath + '\*.*', faAnyFile, FileInfo) = 0 Then
    Begin
      Repeat
        If (FileInfo.Name <> '.') And (FileInfo.Name <> '..') Then
        Begin
          If (FileInfo.Attr And faDirectory) = faDirectory Then
          Begin
            If SubDirectories Then
              FindFiles(DirPath + '\' + FileInfo.Name, Search, Files, SubDirectories, FullPath);
          End
          Else If (UpperCase('*' + ExtractFileExt(FileInfo.Name)) = UpperCase(Search)) Or (Search = '*.*') Then
          Begin
            If FullPath Then
              Files.Add(DirPath + '\' + FileInfo.Name)
            Else
              Files.Add(FileInfo.Name);
          End;
        End;
      Until FindNext(FileInfo) <> 0;
    End;
  Finally
    FindClose(FileInfo);
  End;
End;

//------------------------------------------------------------------------------

Procedure GetFilesImageList(Option : Integer;Var ImageList : TImageList);
// Place dans une ImageList toutes les icônes associées aux différents types de fichier
Var
  SHFILEINFO : TSHFileInfo;
Begin
  If Not Assigned(ImageList) Then ImageList := TImageList.Create(Nil);
  With ImageList Do
  Begin
    ShareImages := True;
    Handle := SHGetFileInfo('', 0, SHFILEINFO, SizeOf(TSHFileInfo), Option Or SHGFI_SYSICONINDEX);
  End;
End;

//------------------------------------------------------------------------------

Function GetFileTypeDescription(FilePath : String;UseAttr : Bool) : String;
// Récupère la description d'un type de fichier
Var
  Info : TSHFileInfo;
  Flags : Cardinal;
Begin
  FillChar(Info, SizeOf(Info), 0);
  Flags := SHGFI_TYPENAME;
  If UseAttr Then Flags := Flags Or SHGFI_USEFILEATTRIBUTES;
  // Bug Windows 2000 beta 3 et NT4, normalement sous un environnement Unicode
  // SHGetFileInfo appelle SHGetFileInfoW, mais cet appel échoue.
  // voir http://support.microsoft.com/support/kb/articles/Q236/3/76.ASP
  SHGetFileInfo(PChar(FilePath), 0, Info, SizeOf(Info), Flags);
  Result := Info.szTypeName;
End;

//------------------------------------------------------------------------------

Function GetFileIconIndex(FilePath : String;UseAttr : Bool;Large : Bool = false;Open : Bool = False) : Integer;
// Récupère l'index de l'icône associée à un fichier
Var
  Info : TSHFileInfo;
  Flags : Cardinal;
Begin
  FillChar(Info, SizeOf(Info), 0);
  Flags := SHGFI_ICON;
  If Open Then Flags := Flags Or SHGFI_OPENICON;
  If Large Then
    Flags := Flags Or SHGFI_LARGEICON
  Else
    Flags := Flags Or SHGFI_SMALLICON;
  If UseAttr Then Flags := Flags Or SHGFI_USEFILEATTRIBUTES;
  // Bug Windows 2000 beta 3 et NT4, normalement sous un environnement Unicode
  // SHGetFileInfo appelle SHGetFileInfoW, mais cet appel échoue.
  // voir http://support.microsoft.com/support/kb/articles/Q236/3/76.ASP
  SHGetFileInfo(PChar(FilePath), 0, Info, SizeOf(Info), Flags);
  Result := Info.iIcon;
End;

//------------------------------------------------------------------------------

Function GetFileStrSize(Size : Integer) : String;
// Renvoie la taille d'un fichier sous forme de chaîne
Begin
  result := '';
  Case Size Of
    0..999 :
      Result := IntToStr(Size) + ' Octets';
    1000..999999 :
      Result := FloatToStr(Size / 1000) + ' Ko';
    1000000..999999999 :
      Result := FloatToStr(Size / 1000000) + ' Mo';
  Else
    Result := FloatToStr(Size / 1000000000) + ' Go';
  End;
End;

//------------------------------------------------------------------------------

Function GetFileStrAttrib(Attrib : Integer;FullName : Bool = True) : String;
// Décoche une série d'attributs
Begin
  Result := '';
  If (Attrib And faReadOnly > 0) Then
    If FullName Then
      result := Result + 'Lecture seule/'
    Else
      Result := Result + 'L';
  If (Attrib And faHidden > 0) Then
    If FullName Then
      result := Result + 'Fichier caché/'
    Else
      Result := Result + 'C';
  If (Attrib And faSysFile > 0) Then
    If FullName Then
      result := Result + 'Fichier Système/'
    Else
      Result := Result + 'S';
  If (Attrib And faArchive > 0) Then
    If FullName Then
      result := Result + 'Archive'
    Else
      Result := Result + 'A';
End;

//------------------------------------------------------------------------------

Function IsInStrings(Str : String;Strings : TStrings) : Bool;
//Recherche l'occurrence Str dans une TStrings
Begin
  If Strings.IndexOf(Str) <> -1 Then
    Result := True
  Else
    Result := False;
End;

//------------------------------------------------------------------------------

Function CompareBuf(Buf1 : Array Of Char;Buf2 : Array Of Char;NumRead : Integer) : Bool;
//Compare deux buffers
Var
  I : Integer;
Begin
  Result := True;
  For I := 0 To Numread - 1 Do
  Begin
    If Buf1[I] <> Buf2[I] Then
    Begin
      Result := False;
      Break;
    End;
  End;
End;

//------------------------------------------------------------------------------

Function GetWinTempDir() : String;
// Récupère le répertoire temporaire de Windows
Var
  WTDir : Array[0..MAX_PATH] Of Char;
Begin
  GetTempPath(SizeOf(WTdir), WTdir);
  Result := FormatPath(WTDir);
End;

//------------------------------------------------------------------------------

Procedure WaitForEnd2(hProcess : Longword);
// Attend q'un processus soit fini mais laisse la main à l'appli
Var
  R : Longword;
Begin
  WaitForInputIdle(hProcess, infinite);
  Repeat
    R := WaitForSingleObject(hprocess, 0);
    Application.ProcessMessages;
  Until R <> WAIT_TIMEOUT;
  CloseHandle(hProcess);
End;

//------------------------------------------------------------------------------

Function ShellFile(FilePath : String;CommandLine : String;FileOp : String = 'OPEN';Sw : Integer = SW_SHOW) : Longword;
// Ouvre l'application correspondante à un fichier donné
Begin
  Result := ShellExecute(Application.Handle, PChar(FileOp), PChar(FilePath), PChar(CommandLine), PChar(ExtractFilePath(FilePath)), Sw); //Lance l'exécution
End;

//------------------------------------------------------------------------------

Function ShellFileEx(FilePath : String;Commandline : String;fileop : String = 'OPEN';Sw : Integer = SW_SHOW;WaitEnd : Bool = False) : Longword;
// Ouvre l'application correspondante à un fichier donné et récupère son hProcess
Var
  Info : SHELLEXECUTEINFO;
  Flag : Integer;
Begin
  Info.cbSize := SizeOf(Info);
  If WaitEnd = False Then
    Flag := SEE_MASK_INVOKEIDLIST
  Else
    Flag := SEE_MASK_IDLIST;
  Info.fMask := SEE_MASK_FLAG_NO_UI Or SEE_MASK_CONNECTNETDRV
    Or SEE_MASK_NOCLOSEPROCESS Or Flag;
  Info.Wnd := Application.Handle;
  Info.lpFile := PChar(FilePath);
  Info.lpVerb := PChar(FileOp);
  Info.lpParameters := PChar(CommandLine);
  Info.nShow := SW;
  Info.lpDirectory := PChar(ExtractFilePath(FilePath));
  Info.lpIDList := Nil;
  ShellexecuteEx(@Info);
  If WaitEnd Then
  Begin
    WaitForEnd2(Info.hProcess);
    Result := INVALID_HANDLE_VALUE;
  End
  Else
    Result := Info.hProcess;
End;
End.

