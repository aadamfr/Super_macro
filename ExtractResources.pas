{|===============================================================================|
 |                                                                               |
 |                              H E R E A   S O F T                              |
 |                         Unité : ExtractResources.pas                          |
 |                        Ecrit par : Alexandre le Grand                         |
 |                  e-mail : alexandre.le.grand@libertysurf.fr                   |
 |                    Copyright : (c)mercredi 21 février 2001                    |
 |                                                                               |
 |                                Version : 1.0.0                                |
 |                                                                               |
 |===============================================================================|}

Unit ExtractResources;

Interface
Uses SysUtils, classes, ZLib, ExtractUtils;

Var
  FileToOverWrite : String;

  // Mode d'extraction des fichiers
Const
  rmENormal = $00000000;
  rmEDirectory = $00000001;
  rmEFullPath = $00000002;

  // Message d'erreur pour le traitement des ressources
  MSG_EXTRACT = 'Erreur lors de l''extraction';
  MSG_INVALID_PASSWORD = 'Mot de passe invalide';
  MSG_FILE_ALREADY_EXISTS = 'Le fichier existe déjà';
  MSG_RES_NOT_FOUND = 'La ressource n''existe pas';

Type
  // Classes d'erreurs
  EResourcesMaker = Class(Exception);
  ErmResNotFound = Class(EResourcesMaker);
  ErmInvalidPassWord = Class(EResourcesMaker);
  ErmFileAlreadyExists = Class(EResourcesMaker);

  // Structure décrivant l'entrée du fichier des ressources
  PEntry = ^TEntry;
  TEntry = Record
    ID : Array[0..15] Of Char;
    FirstEntry : Integer;
    PassWord : Array[0..6] Of Char;
  End;

  // Structure décrivant l'en-tête de chaque ressource
  PHead = ^THead;
  THead = Record
    Key : Array[0..15] Of Char;
    FilePath : Array[0..MAX_PATH] Of Char;
    Size : Integer;
    SizeToDecomp : Integer;
    Attrib : Integer;
  End;

  // Structure décrivant un enregistrement de la table des ressources
  PRecTable = ^TRecTable;
  TRecTable = Record
    Index : Integer;
    Head : THead;
  End;


  //-----------------------------Déclaration de la classe-----------------------

  TExtractResources = Class(TObject)

  Private
    // Variables privées
    FID : String;
    FKey : String;
    FPassWord : String;
    FStream : TFileStream;
    FEntry : TEntry;
    FTable : TList;
    // Gestion des propriétés--------------------------------------------------
    Function GetTable : TList;

    // Utilitaire de décompression
    Procedure DecompressStream(Stream : TStream;SizeToDeComp : Integer);

    // Utilitaire d'interface privé-------------------------------------------
    Function MakePath(FromPath : String;FilePath : String;ExtractPath : Integer) : String;

    // Gestion et lecture de la table des ressources----------------------------
    Procedure CreateTable;
    Procedure ReadEntry;
    Function ReadResourceName(I : Integer) : String;

  Public
    Hdl : Hwnd;
    // Constructeur, destructeur------------------------------------------------
    Constructor Create(FilePath : String;PassWord : String);
    Destructor Destroy;Override;

    // Propriétés---------------------------------------------------------------
    Property Table : TList Read GetTable;

    // Fonction de lecture de la table------------------------------------------
    Function ReadHead(RessourceName : String;Out Head : THead) : Integer;

    // Procédures d'extraction-----------------------
    // 1 Méthodes de base
    Procedure ExtractFile(FromPath : String;ResourceName : String;ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False); // O
    // 2 Méthodes génériques
    Procedure ExtractAllFiles(FromPath : String;Const ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
  End;
Implementation


//Utilitaire--------------------------------------------------------------------

Function OverWriteDialog(HWnd, Msg, wParam, lParam : integer) : Integer;Stdcall;
Begin
  Result := -1;
  Case Msg Of
    WM_SHOWWINDOW : SetWindowText(GetDlgItem(HWnd, IDLABEL), pchar('Le Fichier : ' + FileToOverWrite + ', existe déjà dans le chemin destination, voulez-vous le remplacer?'));
    WM_COMMAND :
      Case wParam Of
          IDYES : EndDialog(HWnd, IDYES); // Exit
          IDNO : EndDialog(HWnd, IDNO); // Exit
          IDALL : EndDialog(HWnd, IDALL); // Exit
        End;
  Else
    Result := 0;
  End;
End;
//Fin utilitaire----------------------------------------------------------------

Constructor TExtractResources.Create(FilePath : String;PassWord : String);
Begin
  // Héritage de TObject
  Inherited Create;
  // Initialisation des variables
  FKey := '<$1801%%ODCDPH$>';
  FID := 'rmResourcesFiles';
  FPassWord := Encrypt1(UpperCase(PassWord), 2);
  FTable := TList.Create;
  // Création du fichier des ressources
  If FileExists(FilePath) Then
  Begin
    FStream := TFileStream.Create(FilePath, fmOpenRead Or fmShareDenyNone);
    ReadEntry;
    If UpperCase(String(FEntry.PassWord)) <> UpperCase(FPassWord) Then
      Raise ErmInvalidPassWord.Create(MSG_INVALID_PASSWORD);
    CreateTable;
  End;
End;

//------------------------------------------------------------------------------

Destructor TExtractResources.Destroy;
Begin
  // Libération des différentes variables
  FStream.Free;
  //Table.Free;
  Inherited Destroy;
End;

//------------------------------------------------------------------------------

Function TExtractResources.GetTable : TList;
// Obtention de la table des ressources
Begin
  Result := FTable;
End;

//------------------------------------------------------------------------------

Procedure TExtractResources.DecompressStream(Stream : TStream;SizeToDecomp : Integer);
// Décompression
Var
  S : TDecompressionStream;
Begin
  S := TDecompressionStream.Create(FStream);
  Try
    If SizeToDecomp <> 0 Then
      Stream.CopyFrom(S, SizeToDecomp);
  Finally
    S.Free;
  End;
End;

//------------------------------------------------------------------------------

Function TExtractResources.MakePath(FromPath : String;FilePath : String;ExtractPath : Integer) : String;
// Détermine le chemin d'extraction
Var
  FileName : String;
Begin
  FromPath := FormatPath(FromPath);
  FileName := ExtractFileName(FilePath);
  Case ExtractPath Of
    rmENormal :
      Begin
        ForceDirectories(FromPath);
        Result := FromPath + '\' + FileName;
      End;
    rmEDirectory :
      Begin
        FilePath := ExtractFilePath(FilePath);
        FilePath := LastDir(FilePath);
        If FilePath <> '' Then
        Begin
          ForceDirectories(FromPath + '\' + FilePath);
          Result := FromPath + '\' + FilePath + '\' + FileName;
        End
        Else
        Begin
          ForceDirectories(FromPath);
          Result := FromPath + '\' + FileName;
        End;
      End;
    rmEFullPath :
      Begin
        FilePath := ExtractFileDir(FilePath);
        FilePath := FilePathWithoutDrive(FilePath);
        If FilePath <> '' Then
        Begin
          ForceDirectories(FromPath + '\' + FilePath);
          Result := FromPath + '\' + FilePath + '\' + FileName;
        End
        Else
        Begin
          Result := FromPath + '\' + FileName;
          ForceDirectories(FromPath);
        End;
      End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TExtractResources.CreateTable;
// Création de la table des ressources
Var
  Incr : Integer;
  RecTable : PRecTable;
  Head : THead;
Begin
  Incr := 0;
  Table.Clear;
  FStream.Position := FEntry.FirstEntry;
  Repeat
    FStream.Read(Head, SizeOf(Head));
    If Head.Key = FKey Then
    Begin
      New(RecTable);
      RecTable.Index := FStream.Position;
      RecTable.Head := Head;
      Table.Add(RecTable);
      FStream.Position := FStream.Position + Head.Size;
    End
    Else
    Begin
      Incr := Incr + 1;
      FStream.Seek(Incr, soFromCurrent);
    End;
  Until FStream.Position >= Fstream.Size - SizeOf(TEntry);
End;

//------------------------------------------------------------------------------

Procedure TExtractResources.ReadEntry;
// Lecture de l'entrée du fichier des ressources
Begin
  ZeroMemory(@FEntry, SizeOf(TEntry));
  FStream.Position := Fstream.Size - SizeOf(TEntry);
  FStream.Read(FEntry, SizeOf(TEntry));
  If FEntry.ID <> FID Then
  Begin
    StrCopy(FEntry.ID, PChar(FID));
    FEntry.FirstEntry := FSTream.Size;
    StrCopy(FEntry.PassWord, PChar(FPassWord));
    FStream.Position := FStream.Size;
    FStream.Write(FEntry, SizeOf(TEntry));
  End;
End;

//------------------------------------------------------------------------------

Function TExtractResources.ReadResourceName(I : Integer) : String;
// Lecture du nom d'une ressource dans la table des ressources
Begin
  If I <= Table.Count - 1 Then
    Result := PRecTable(Table[I])^.Head.FilePath
  Else
    Result := '';

End;

//------------------------------------------------------------------------------

Function TExtractResources.ReadHead(RessourceName : String;Out Head : THead) : Integer;
// Lecture d'un en-tête
Var
  I : Integer;
Begin
  ZeroMemory(@Head, SizeOf(Head));
  For I := 0 To Table.Count - 1 Do
  Begin
    If UpperCase(PRecTable(Table[I])^.Head.FilePath) = UpperCase(RessourceName) Then
    Begin
      // Recherche des différentes infos de l'en-tête
      Head.Key := PRecTable(Table[I])^.Head.Key;
      Head.FilePath := PRecTable(Table[I])^.Head.FilePath;
      Head.Size := PRecTable(Table[I])^.Head.Size;
      Head.SizeToDecomp := PRecTable(Table[I])^.Head.SizeToDecomp;
      Head.Attrib := PRecTable(Table[I])^.Head.Attrib;
      Result := PRecTable(Table[I])^.Index;
      Exit;
    End;
  End;
  Raise ErmResNotFound.Create(MSG_RES_NOT_FOUND + ' (' + RessourceName + ')');
End;

//------------------------------------------------------------------------------

Procedure TExtractResources.ExtractFile(FromPath : String;ResourceName : String;ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
// Extraction d'un fichier contenu dans le fichier des ressources
Var
  ExtractPath : String;
  HeadInfo : THead;
  Tof : TFileStream;
Begin
  ZeroMemory(@HeadInfo, SizeOf(HeadInfo));
  FStream.Position := ReadHead(ResourceName, HeadInfo);
  SetWindowText(GetDlgItem(Hdl, IDLABEL), pchar('Extraction de : ' + ExtractFileName(ResourceName)));
  SendMessage(Hdl, WM_PAINT, 0, 0);
  ExtractPath := MakePath(FRomPath, HeadInfo.FilePath, ExtractPathFlag);
  If FileExists(ExtractPath) Then
    If OverWrite Then
    Begin
      If (FileGetAttr(ExtractPath) And fareadonly) > 0 Then FileSetAttr(ExtractPath, faarchive); // Change l'attribut si lecture seule
    End
    Else
      Raise ErmFileAlreadyExists.Create(MSG_FILE_ALREADY_EXISTS);
  ToF := TFileStream.Create(ExtractPath, fmCreate);
  Try
    DecompressStream(Tof, HeadInfo.SizeToDecomp);
  Finally
    Tof.Free;
  End;
  FileSetAttr(ExtractPath, HeadInfo.Attrib);
End;

//------------------------------------------------------------------------------

Procedure TExtractResources.ExtractAllFiles(FromPath : String;Const ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
// Extraction de tous les fichiers contenus dans le fichier des ressources
Var
  I : Integer;
  ResourceName : String;
Begin
  For I := 0 To Table.Count - 1 Do
  Begin
    Try
      ResourceName := ReadResourceName(I);
      ExtractFile(FromPath, ResourceName, ExtractPathFlag, OverWrite);
    Except
      On ErmFileAlreadyExists Do
      Begin
        If OverWrite = False Then
          FileToOverWrite := ExtractFileName(ResourceName);
        Case DialogBox(hInstance, 'ECRASEMENT', 0, @OverWriteDialog) Of
          IDYES : ExtractFile(FromPath, ResourceName, ExtractPathFlag, True);
          IDALL :
            Begin
              OverWrite := True;
              ExtractFile(FromPath, ResourceName, ExtractPathFlag, True);
            End;
        End;
      End;
      On E : Exception Do
        MessageBox(0, PChar(MSG_EXTRACT + ' pour la ressource (' + ResourceName + ' : ' + E.Message), 'Erreur', MB_OK);
    End;
  End;
End;
End.

