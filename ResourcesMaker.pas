{===============================================================================|
 |                                                                              |
 |                             H E R E A   S O F T                              |
 |                          Unité : ResourcesMaker.pas                          |
 |                        Ecrit par : Alexandre le Grand                        |
 |                  e-mail : alexandre.le.grand@libertysurf.fr                  |
 |                      Copyright : (c)jeudi 31 août 2000                       |
 |                                                                              |
 |                               Version : 2.0.0                                |
 |                                                                              |
 |==============================================================================|}

// Cette classe est libre d'utilisation.
// Les seules restrictions sont :
// 1) Me faire parvenir toute modification de son code.
// 2) Si une modification s'impose : garder le nom de la classe et le nom de l'auteur
// en modifiant simplement le numéro de version
// 3) Pour une meilleure compréhension et afin de faire partager le plus lisiblement
// possible le code, commenter largement les modifications
// 4) Respecter les conventions de codage de cette classe (français pour les
// commentaires et anglais pour le code (nom des fonctions, variables...)
//
// J'espère que vous trouverez entière satisfaction dans l'utilisation de TResourcesMaker

Unit ResourcesMaker;
{$WARN SYMBOL_PLATFORM OFF}

Interface
Uses Windows, classes, SysUtils, Forms, Controls, Dialogs, FileCtrl, Comctrls, Messages, ZLib;

//---------------------------Déclaration pour l'unité---------------------------

Const
  // Mode de mise à jour
  rmToResource = $00000000;
  rmToFile = $00000001;

  // Mode d'extraction des fichiers
  rmENormal = $00000000;
  rmEDirectory = $00000001;
  rmEFullPath = $00000002;

  // Message d'erreur pour le traitement des ressources
  MSG_ADD = 'Erreur lors de l''ajout d''une ressource';
  MSG_EXTRACT = 'Erreur lors de l''extraction';
  MSG_DELETE_RESOURCE = 'Erreur lors de la suppression de ressource(s)';
  MSG_INVALID_PASSWORD = 'Mot de passe invalide';
  MSG_RES_ALREADY_EXISTS = 'La ressource existe déjà';
  MSG_FILE_ALREADY_EXISTS = 'Le fichier existe déjà';
  MSG_RES_NOT_FOUND = 'La ressource n''existe pas';
  MSG_EXECUTE = 'Erreur lors de  l''exécution de la ressource';
  MSG_COMPARE_RES = 'Erreur lors de la comparaison de la ressource avec un fichier';

  // Mode de Compression
  rmSlowest = $00000000;
  rmNormal = $00000001;
  rmFastest = $00000002;
  rmNone = $00000003;

Type
  // Classes d'erreurs
  EResourcesMaker = Class(Exception);
  ErmResNotFound = Class(EResourcesMaker);
  ErmInvalidPassWord = Class(EResourcesMaker);
  ErmResAlreadyExists = Class(EResourcesMaker);
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

  // Structure décrivant les informations supplémentaires d'une ressource
  PHeadExtraInfos = ^THeadExtraInfos;
  THeadExtraInfos = Record
    Path : String;
    ResourceName : String;
    FileTypeDescription : String;
    Size : String;
    CompressSize : String;
    Ratio : String;
    StrAttrib : String;
    IconIndex : Integer;
  End;

  // Structure décrivant un enregistrement de la table des ressources
  PRecTable = ^TRecTable;
  TRecTable = Record
    Index : Integer;
    Head : THead;
  End;

  //-----------------------------Déclaration de la classe-----------------------

  TResourcesMaker = Class(TObject)

  Private
    // Variables privées
    FID : String;
    FKey : String;
    FPassWord : String;
    FErrorMSG : Bool;
    FTemp : String;
    FCurrentRes : String;
    FStream : TFileStream;
    FEntry : TEntry;
    FTmpStream : TFileStream;
    FListView : TListView;
    FStatusBar : TStatusBar;
    FFileProgressBar : TProgressBar;
    FGeneralProgressBar : TProgressBar;
    LImageList : TImageList;
    SImageList : TImageList;
    MaxProgress : Integer;
    FCompressionLevel : Integer;
    FErrTable : TStrings;
    FTable : TList;
    FUpDatesTable : TStrings;

    // Gestion des propriétés--------------------------------------------------
    Function GetTemp : String;
    Procedure SetTemp(Const Value : String);
    Function GetErrorMSG : Bool;
    Procedure SetErrorMSG(Const Value : Bool);
    Function GetCurrentRes : String;
    Function GetListView : TListView;
    Procedure SetListView(Const Value : TListView);
    Function GetStatusBar : TStatusBar;
    Procedure SetStatusBar(Const Value : TStatusBar);
    Function GetFileProgressBar : TProgressBar;
    Procedure SetFileProgressBar(Const Value : TProgressBar);
    Function GetGeneralProgressBar : TProgressBar;
    Procedure SetGeneralProgressBar(Const Value : TProgressBar);
    Function GetCompressionLevel : Integer;
    Procedure SetCompressionLevel(Const Value : Integer);
    Function GetErrTable : TStrings;
    Function GetTable : TList;
    Function GetUpDatesTable : TStrings;


    // Utilitaires de compression
    Function CompressStream(Stream : TStream) : Integer;
    Procedure DecompressStream(Stream : TStream;SizeToDeComp : Integer);

    // Utilitaires d'interface privés-------------------------------------------
    Function MakePath(FromPath : String;FilePath : String;ExtractPath : Integer) : String;
    Procedure OnFileProgress(Sender : TObject);
    Procedure GeneralProgress(Max : Integer);
    Procedure AddToListView(ExtraInfos : THeadExtraInfos);
    Procedure DeleteFromListView(ResourceName : String);

    // Gestion et lecture de la table des ressources----------------------------
    Procedure CreateTable;
    Procedure AddToTable(Head : THead;Index : Integer);
    Procedure ReadEntry;
    Function ReadResourceName(I : Integer) : String;
    Function ReadSize(I : Integer) : Integer;
    Function ReadSizeToDecomp(I : Integer) : Integer;
    Function ReadAttrib(I : Integer) : Integer;

  Public

    // Constructeur, destructeur------------------------------------------------
    Constructor Create(FilePath : String;PassWord : String);
    Destructor Destroy;Override;

    // Propriétés---------------------------------------------------------------
    Property CurrentRes : String Read GetCurrentRes;
    Property MsgError : Bool Read GetErrorMSG Write SetErrorMSG;
    Property TempPath : String Read GetTemp Write SetTemp;
    Property ListView : TListView Read GetListView Write SetListView;
    Property StatusBar : TStatusBar Read GetStatusBar Write SetStatusBar;
    Property FileProgressBar : TProgressBar Read GetFileProgressBar Write SetFileProgressBar;
    Property GeneralProgressBar : TProgressBar Read GetGeneralProgressBar Write SetGeneralProgressBar;
    Property CompressionLevel : Integer Read GetCompressionLevel Write SetCompressionLevel;
    Property ErrTable : TStrings Read GetErrTable;
    Property Table : TList Read GetTable;
    Property UpDatesTable : TStrings Read GetUpdatesTable;

    // Fonctions de lecture de la table------------------------------------------
    Function ReadHead(RessourceName : String;Out Head : THead) : Integer;
    Function ReadIndex(I : Integer) : Integer;

    // Gestion des erreurs-----------------------------------------------------
    Procedure LastErrorDialog;

    // Utilitaires d'interface publics------------------------------------------
    Function GetExtraInfos(I : Integer) : THeadExtraInfos;
    Function CompareResourceToFile(ResourceName : String;FilePath : String) : Bool;
    Procedure ExecuteAndUpdate(ResourceToExecute : String);
    Procedure UpdateResources(ResourcesName : TStrings;Direction : Integer = rmToResource);
    Function IsResource(ResourceName : String) : Bool;
    Procedure FillingListView;
    Procedure InfoStatusBar(MSG : String);

    // Procédures d'ajout, de suppression et d'extraction-----------------------
    // 1 Méthodes de base
    Procedure AddFile(FilePath : String;Alias : String = '';OverWrite : Bool = False);
    Procedure AddStream(Stream : TMemoryStream;Alias : String = '';OverWrite : Bool = False);
    Procedure ExtractFile(FromPath : String;ResourceName : String;ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False); // O
    Procedure ExtractToStream(ResourceName : String;Out MemoryStream : TMemoryStream);
    Procedure DeleteResource(ResourceName : String);
    // 2 Méthodes génériques
    Procedure AddFiles(FilesPath : TStrings;OverWrite : Bool = False);
    Procedure AddDirectory(SourceDir : String;SubDirectories : Bool;OverWrite : Bool = False);
    Procedure ExtractFiles(FromPath : String;ResourcesName : TStrings;ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
    Procedure ExtractAllFiles(FromPath : String;Const ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
    Procedure DeleteResources(ResourcesName : TStrings);
    Function MakeAutoExtract(AutoExtractFilePath : String) : Bool;
  End;
Implementation
Uses rm_Utils;

Constructor TResourcesMaker.Create(FilePath : String;PassWord : String);
Begin
  // Héritage de TObject
  Inherited Create;
  // Initialisation des variables
  FCurrentRes := FilePath;
  FKey := '<$1801%%ODCDPH$>';
  FID := 'rmResourcesFiles';
  FTemp := GetWinTempDir + '\rmTemp';
  FErrorMSG := True;
  FPassWord := Encrypt1(UpperCase(PassWord), 2);
  FCompressionLevel := rmNormal;
  // Création des tables
  FTable := TList.Create;
  FErrTable := TStringList.Create;
  FUpdateSTable := TStringList.Create;
  // Création d'un répertoire temporaire
  If DirectoryExists(TempPath) = False Then MkDir(TempPath);
  // Création du fichier des ressources
  If FileExists(FilePath) Then
  Begin
    If UpperCase(FCurrentRes) = UpperCase(Application.ExeName) Then
      FStream := TFileStream.Create(FilePath, fmOpenRead Or fmShareDenyNone)
    Else
      FStream := TFileStream.Create(FilePath, fmOpenReadWrite Or fmShareExclusive);
    ReadEntry;
    If UpperCase(String(FEntry.PassWord)) <> UpperCase(FPassWord) Then
      Raise ErmInvalidPassWord.Create(MSG_INVALID_PASSWORD);
    CreateTable;
  End
  Else
  Begin
    FStream := TFileStream.Create(FilePath, FmCreate Or fmShareExclusive);
    ReadEntry;
  End;
End;

//------------------------------------------------------------------------------

Destructor TResourcesMaker.Destroy;
Begin
  // Libération des différentes variables
  FStream.Free;
  FTmpStream.Free;
  Table.Free;
  ErrTable.Free;
  UpdatesTable.Free;
  LImageList.Free;
  SImageList.Free;
  // Destruction du répertoire temporaire
  If DirectoryExists(TempPath) Then
  Begin
    KIll(TempPath, '*.*', True, True);
  End;
  Inherited Destroy;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetTemp : String;
// Obtention du chemin temporaire
Begin
  Result := FTemp;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetTemp(Const Value : String);
// Affectation du chemin temporaire
Begin
  If UpperCase(Value) <> UpperCase(FTemp) Then
  Begin
    If DirectoryExists(Value) = False Then MkDir(Value);
    KIll(FTemp, '*.*', True, True);
    Ftemp := Value;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetErrorMSG(Const Value : Bool);
// Affectation de la bascule pour l'affichage des msg d'erreurs
Begin
  If Value <> MSGError Then
    FErrorMSG := Value;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetErrorMSG : Bool;
// Obtention de la bascule pour l'affichage des msg d'erreurs
Begin
  Result := FErrorMSG;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetCurrentRes : String;
// Obtention du fichier des ressources
Begin
  Result := FCurrentRes;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetListView : TListView;
// Obtention du ListView
Begin
  Result := FListView;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetListView(Const Value : TListView);
// Affectation d'un ListView
Begin
  If Assigned(Value) Then
  Begin
    // Initialisation des propriétés du ListView
    FListView := Value;
    With ListView Do
    Begin
      MultiSelect := True;
      GetFilesImageList(shLargeIcon, LImageList);
      GetFilesImageList(shSmallIcon, SImageList);
      LargeImages := LImageList;
      SmallImages := SImageList;
    End;
  End;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetStatusBar : TStatusBar;
// Obtention de la barre d'état
Begin
  Result := FStatusBar;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetStatusBar(Const Value : TStatusBar);
// Affectation de la barre d'état
Begin
  FStatusBar := Value;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetFileProgressBar(Const Value : TProgressBar);
// Affectation de la barre de progression pour la compression d'un fichier
Begin
  FFileProgressBar := Value;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetFileProgressBar : TProgressBar;
// Obtention de la barre de progression pour la compression d'un fichier
Begin
  Result := FFileProgressBar;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetGeneralProgressBar : TProgressBar;
// Obtention de la barre de progression pour le traitement de plusieurs fichiers
Begin
  Result := FGeneralProgressBar;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetGeneralProgressBar(Const Value : TProgressBar);
// Affectation de la barre de progression pour le traitement de plusieurs fichiers
Begin
  FGeneralProgressBar := Value;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetCompressionLevel : Integer;
// Obtention du niveau de compression
Begin
  Result := FCompressionLevel;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.SetCompressionLevel(Const Value : Integer);
// Affectation du niveau de compression
Begin
  If Value <> FCompressionLevel Then
    FCompressionLevel := Value;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetErrTable : TStrings;
// Obtention de la table des erreurs
Begin
  Result := FErrTable;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetTable : TList;
// Obtention de la table des ressources
Begin
  Result := FTable;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetUpDatesTable : TStrings;
// Obtention de la tables des mises à jour
Begin
  Result := FUpDatesTable;
End;

//------------------------------------------------------------------------------

Function TResourceSMaker.CompressStream(Stream : TStream) : Integer;
// Compression
Var
  S : TCompressionStream;
  L : TCompressionLevel;
Begin
  Case CompressionLevel Of
    rmFastest : L := clFastest;
    rmNormal : L := clDefault;
    rmSlowest : L := clMax;
  Else
    L := clNone;
  End;
  Stream.Position := 0;
  FTmpStream.Free;
  FTmpStream := Nil;
  // Compression dans un fichier temporaire
  If FileExists(TempPath + '\~tmp') Then
    DeleteFile(TempPath + '\~tmp');
  FTmpStream := TFileStream.Create(TempPath + '\~tmp', fmcreate);
  If Stream.Size <> 0 Then
  Begin
    MaxProgress := Stream.Size;
    S := TCompressionStream.Create(L, FTmpStream);
    Try
      S.OnProgress := OnFileProgress;
      S.CopyFrom(Stream, Stream.Size);
      If Assigned(FileProgressBar) Then FileProgressBar.Position := 0;
    Finally
      S.Free;
    End;
  End;
  Result := FTmpStream.Size;
  FTmpStream.Position := 0;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.DecompressStream(Stream : TStream;SizeToDecomp : Integer);
// Décompression
Var
  S : TDecompressionStream;
Begin
  S := TDecompressionStream.Create(FStream);
  Try
    If SizeToDecomp <> 0 Then
    Begin
      MaxProgress := SizeToDecomp;
      Stream.CopyFrom(S, SizeToDecomp);
      If Assigned(FileProgressBar) Then FileProgressBar.Position := 0;
    End;
  Finally
    S.Free;
  End;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.MakePath(FromPath : String;FilePath : String;ExtractPath : Integer) : String;
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

Procedure TResourcesMaker.OnFileProgress(Sender : TObject);
// Gestion de la progression pour la compression d'un fichier
Begin
  If Assigned(FileProgressBar) Then
  Begin
    FileProgressBar.Max := MaxProgress;
    FileProgressbar.Position := TCustomZLibStream(Sender).Position;
    SendMessage(FileProgressBar.Handle, WM_PAINT, 0, 0);
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.GeneralProgress(Max : Integer);
// Gestion de la progression pour le traitement de plusieurs fichiers
Begin
  If Assigned(GeneralProgressBar) Then
  Begin
    GeneralProgressBar.Max := Max;
    GeneralProgressBar.Step := 1;
    GeneralProgressBar.StepIt;
    If GeneralProgressBar.Position = GeneralProgressBar.Max Then GeneralProgressBar.Position := 0;
    SendMessage(GeneralProgressBar.Handle, WM_PAINT, 0, 0);
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.AddToListView(ExtraInfos : THeadExtraInfos);
// Ajoute un Item à la ListView
Var
  Item : TListItem;
Begin
  If Assigned(ListView) Then
  Begin
    With ListView Do
    Begin
      InfoStatusBar(ExtraInfos.ResourceName + ExtraInfos.Path);
      SortType := stnone;
      Items.BeginUpdate;
      Item := Items.Add;
      Item.Caption := ExtraInfos.ResourceName;
      Item.SubItems.Text := ExtraInfos.Path + Chr(10)
        + ExtraInfos.FileTypeDescription + Chr(10)
        + ExtraInfos.Size + Chr(10)
        + ExtraInfos.CompressSize + Chr(10)
        + ExtraInfos.Ratio + Chr(10)
        + ExtraInfos.StrAttrib;
      Item.ImageIndex := ExtraInfos.IconIndex;
      Items.EndUpdate;
      SortType := stText;
    End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.DeleteFromListView(ResourceName : String);
// Supprime un Item de la ListView
Var
  I : Integer;
  Item : TListItem;
Begin
  If Assigned(ListView) Then
  Begin
    For I := 0 To ListView.Items.Count - 1 Do
    Begin
      Item := ListView.Items.Item[I];
      If UpperCase(Item.SubItems[0] + Item.Caption) = UpperCase(Resourcename) Then
      Begin
        InfoStatusBar(ResourceName);
        ListView.Items.BeginUpdate;
        Item.Delete;
        ListView.Items.EndUpdate;
        Break;
      End;
    End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.CreateTable;
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

Procedure TResourcesMaker.AddToTable(Head : THead;Index : Integer);
// Ajoute une ressource à la table des ressources
Var
  RecTable : PRecTable;
Begin
  New(RecTable);
  RecTable.Head := Head;
  RecTable.Index := Index;
  Table.Add(RecTable);
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.ReadEntry;
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

Function TResourcesMaker.ReadResourceName(I : Integer) : String;
// Lecture du nom d'une ressource dans la table des ressources
Begin
  If I <= Table.Count - 1 Then
    Result := PRecTable(Table[I])^.Head.FilePath
  Else
    Result := '';

End;

//------------------------------------------------------------------------------

Function TResourcesMaker.ReadIndex(I : Integer) : Integer;
// Lecture de l'index d'une ressource dans la table des ressources
Begin
  If I <= Table.Count - 1 Then
    Result := PRecTable(Table[I])^.Index
  Else
    Result := -1;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.ReadSize(I : Integer) : Integer;
// Lecture de la taille d'une ressource après compression dans la table des ressources
Begin
  If I <= Table.Count - 1 Then
    Result := PRecTable(Table[I])^.Head.Size
  Else
    Result := -1;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.ReadSizeToDecomp(I : Integer) : Integer;
// Lecture de la taille réelle d'une ressource dans la table des ressources
Begin
  If I <= Table.Count - 1 Then
    Result := PRecTable(Table[I])^.Head.SizeToDecomp
  Else
    Result := -1;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.ReadAttrib(I : Integer) : Integer;
// Lecture de l'attribut d'une ressource dans la table des ressources
Begin
  If I <= Table.Count - 1 Then
    Result := PRectable(Table[I])^.Head.Attrib
  Else
    Result := -1;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.ReadHead(RessourceName : String;Out Head : THead) : Integer;
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

Procedure TResourcesMaker.LastErrorDialog;
// Affiche la dernière erreur
Begin
  If ErrTable.Count <> 0 Then
    MessageDlg(ErrTable.Strings[ErrTable.Count - 1], mtError, [mbOK, mbHelp], 0)
  Else
    MessageDlg('Aucune erreur', mtError, [mbOK, mbHelp], 0);
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.GetExtraInfos(I : Integer) : THeadExtraInfos;
// Récupère des informations supplémentaires pour une ressource
Var
  FilePath : String;
Begin
  With Result Do
  Begin
    Size := GetFileStrSize(ReadSizeToDecomp(I));
    CompressSize := GetFileStrSize(ReadSize(I));
    If ReadSizeToDecomp(I) = 0 Then
      Ratio := '0%'
    Else
      Ratio := IntToStr(100 - ((ReadSize(I) * 100) Div ReadSizeToDecomp(I))) + '%';
    StrAttrib := GetFileStrAttrib(ReadAttrib(I));
    FilePath := ReadResourceName(I);
    ResourceName := ExtractFileName(FilePath);
    If ResourceName = FilePath Then
      Path := ''
    Else
      Path := ExtractFilePath(FilePath);
    FileTypeDescription := GetFileTypeDescription(FilePath, True);
    IconIndex := GetFileIconIndex(FilePath, True);
  End;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.CompareResourceToFile(ResourceName : String;FilePath : String) : Bool;
// Compare une ressource avec un fichier existant
Const
  BufferSize = 2048;
Var
  HeadInfo : THead;
  TempSize, NumRead : Integer;
  F : TFileStream;
  ZStream : TDecompressionStream;
  Buf1 : Array[1..BufferSize] Of Char;
  Buf2 : Array[1..BufferSize] Of Char;
Begin
  Result := True;
  TempSize := 0;
  FStream.Position := ReadHead(ResourceName, HeadInfo);
  ZStream := TDecompressionStream.Create(FStream);
  F := TFileStream.Create(FilePath, fmOpenRead);
  Try
    If F.Size <> HeadInfo.SizeToDecomp Then
      Result := False
    Else
      Repeat
        If HeadInfo.SizeToDecomp - TempSize < BufferSize Then
          Numread := HeadInfo.SizeToDecomp - TempSize
        Else
          NumRead := BufferSize;
        ZStream.Read(Buf1, NumRead);
        TempSize := TempSize + numread;
        F.Read(Buf2, Numread);
        If CompareBuf(Buf1, Buf2, Numread) = False Then
        Begin
          Result := False;
          Break;
        End;
      Until (TempSize = HeadInfo.SizeTodecomp);
  Finally
    F.Free;
    ZStream.Free;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.ExecuteAndUpdate(ResourceToExecute : String);
// Exécute et met à jour si nécessaire une ressource
Begin
  Try
    ExtractFile(TempPath, ResourceToExecute, rmENormal, True);
    ShellFileEX(TempPath + '\' + ExtractFileName(ResourceToExecute), '', 'open', SW_SHOW, True);
    If CompareResourceToFile(ResourceToExecute, TempPath + '\' + ExtractFileName(ResourceToExecute)) = False Then
      If MessageDlg('Le fichier a été modifié, voulez-vous le mettre à jour?',
        mtConfirmation, [mbYes, mbNo], 0) = mrYes Then
      Begin
        DeleteResource(ResourceToExecute);
        AddFile(TempPath + '\' + ExtractFileName(ResourceToExecute), ResourceToExecute, True);
      End;
  Except
    On E : Exception Do
    Begin
      If MsgError Then MessageDlg(MSG_EXECUTE + ' : ' + E.Message, mtError, [mbOK, mbHelp], E.HelpContext);
      ErrTable.Add(MSG_EXECUTE + ' : ' + E.Message);
    End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.UpdateResources(ResourcesName : TStrings;Direction : Integer = rmToResource);
// Met à jour des ressources à partir de leur fichier d'origine ou met à jour les fichier d'origines à partir de la ressource
Var
  FilesToUpdate : TStrings;
  I : Integer;
Begin
  FilesToUpdate := TStringList.Create;
  //Comparaison
  For I := 0 To ResourcesName.Count - 1 Do
  Begin
    GeneralProgress(ResourcesName.Count);
    InfoStatusBar(ResourcesName[I]);
    Try
      If FileExists(ResourcesName[I]) Then
        If CompareResourceToFile(ResourcesName[I], ResourcesName[I]) = False Then
          FilesToUpdate.Add(ResourcesName[I]);
    Except
      On E : Exception Do
      Begin
        If MsgError Then MessageDlg(E.Message, mtError, [mbOK, mbHelp], E.HelpContext);
        UpdatesTable.Add(ResourcesName[I] + ' : échec lors de la comparaison. ' + E.Message);
      End;
    End;
  End;

  // Mise à jour
  For I := 0 To FilesToUpdate.Count - 1 Do
  Begin
    InfoStatusBar(FilesToUpdate[I]);
    GeneralProgress(FilesToUpdate.Count);
    Try
      Case Direction Of
        rmToResource : AddFile(FilesToUpdate[I], '', True);
        rmToFile : ExtractFile(ExtractFilePath(FilesToUpdate[I]), FilesToUpdate[I], rmENormal, True);
      End;
      UpdatesTable.Add(FilesToUpdate[I] + ': OK')
    Except
      On E : Exception Do
      Begin
        If MsgError Then MessageDlg(E.Message, mtError, [mbOK, mbHelp], E.HelpContext);
        UpdatesTable.Add(FilesToUpdate[I] + ' : échec lors de la mise à jour. ' + E.Message);
      End;
    End;
  End;
  FilesToUpdate.Free;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.IsResource(ResourceName : String) : Bool;
// Vérifie l'existence d'une ressource
Var
  I : Integer;
Begin
  Result := False;
  For I := 0 To Table.Count - 1 Do
    If UpperCase(ResourceName) = UpperCase(ReadResourceName(I)) Then
    Begin
      Result := True;
      Break;
    End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.FillingListView;
// Remplit la ListView
Var
  VStyle : TViewStyle;
  I : Integer;
  Item : TListItem;
  ExtraInfos : THeadExtraInfos;
Begin
  If Assigned(ListView) Then
  Begin
    With ListView Do
    Begin
      Items.Clear;
      SortType := stnone;
      Items.BeginUpdate;
      VStyle := ListView.ViewStyle;
      ListView.ViewStyle := VsReport;
      For I := 0 To Table.Count - 1 Do
      Begin
        InfoStatusBar(ExtraInfos.Path + ExtraInfos.ResourceName);
        ExtraInfos := GetExtraInfos(I);
        Item := Items.Add;
        Item.Caption := ExtraInfos.ResourceName;
        Item.SubItems.Text := ExtraInfos.Path + Chr(10)
          + ExtraInfos.FileTypeDescription + Chr(10)
          + ExtraInfos.Size + Chr(10)
          + ExtraInfos.CompressSize + Chr(10)
          + ExtraInfos.Ratio + Chr(10)
          + ExtraInfos.StrAttrib;
        Item.ImageIndex := ExtraInfos.IconIndex;
        GeneralProgress(Table.Count);
      End;
      Items.EndUpdate;
      ListView.ViewStyle := VStyle;
      SortType := stText;
    End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.InfoStatusBar(MSG : String);
// Gestion de l'affichage de la barre d'état
Begin
  If Assigned(StatusBar) Then
  Begin
    If StatusBar.SimplePanel = True Then
      StatusBar.SimpleText := MSG
    Else If StatusBar.Panels.Count <> 0 Then
      StatusBar.Panels.Items[0].Text := MSG;
    StatusBar.Refresh;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.AddFile(FilePath : String;Alias : String = '';OverWrite : Bool = False);
// Ajoute un fichier au fichier des ressources
Var
  Head : Thead;
  FromF : TFileStream;
Begin
  If Alias = '' Then Alias := FilePath;
  // Vérification pour un doublon éventuel
  If IsResource(Alias) Then
    If OverWrite Then
      DeleteResource(Alias)
    Else
      Raise ErmResAlreadyExists.Create(MSG_RES_ALREADY_EXISTS);
  ZeroMemory(@Head, SizeOf(Head));
  InfoStatusBar(Alias);
  StrCopy(Head.Key, PChar(Fkey));
  StrCopy(Head.FilePath, PChar(Alias));
  Head.Attrib := FileGetAttr(FilePath);
  FRomF := TFileStream.Create(FilePath, fmOpenRead);
  Try
    Head.SizeToDecomp := FromF.Size;
    Head.Size := CompressStream(FromF);
  Finally
    FromF.Free;
  End;
  FStream.Position := FStream.Size - SizeOf(TEntry);
  FStream.Write(Head, SizeOf(Head));
  FStream.CopyFrom(FtmpStream, FTmpStream.Size);
  FStream.Write(FEntry, SizeOf(TEntry));
  AddtoTable(Head, FStream.Position - (SizeOf(TEntry) + Head.Size));
  AddToListView(GetExtraInfos(Table.Count - 1));
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.AddStream(Stream : TMemoryStream;Alias : String = '';OverWrite : Bool = False);
// Ajoute un flux au fichier des ressources (attention le flux mémoire n'est pas libéré. Ceci en vue d'un traitement ultérieur éventuel)
Var
  Head : THead;
Begin
  If Alias = '' Then alias := 'Stream' + IntToStr(Table.Count);
  // Vérification pour un doublon éventuel
  If IsResource(Alias) Then
    If OverWrite Then
      DeleteResource(Alias)
    Else
      Raise ErmResAlreadyExists.Create(MSG_RES_ALREADY_EXISTS);
  ZeroMemory(@Head, SizeOf(Head));
  InfoStatusBar(Alias);
  StrCopy(Head.Key, PChar(Fkey));
  StrCopy(Head.FilePath, PChar(Alias));
  Head.Attrib := 32;
  Head.SizeToDecomp := Stream.Size;
  Head.Size := CompressStream(Stream);
  FStream.Position := FStream.Size - SizeOf(TEntry);
  FStream.Write(Head, SizeOf(Head));
  FStream.CopyFrom(FtmpStream, FTmpStream.Size);
  FStream.Write(FEntry, SizeOf(TEntry));
  AddtoTable(Head, FStream.Position - (SizeOf(TEntry) + Head.Size));
  AddToListView(GetExtraInfos(Table.Count - 1));
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.ExtractFile(FromPath : String;ResourceName : String;ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
// Extraction d'un fichier contenu dans le fichier des ressources
Var
  ExtractPath : String;
  HeadInfo : THead;
  Tof : TFileStream;
Begin
  ZeroMemory(@HeadInfo, SizeOf(HeadInfo));
  FStream.Position := ReadHead(ResourceName, HeadInfo);
  InfoStatusBar(HeadInfo.FilePath);
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

Procedure TResourcesMaker.ExtractToStream(ResourceName : String;Out MemoryStream : TMemoryStream);
// Extraction dans un flux mémoire d'un fichier contenu dans le fichier des ressources
Var
  HeadInfo : THead;
  Tof : TStream;
Begin
  ZeroMemory(@HeadInfo, SizeOf(HeadInfo));
  MemoryStream := Nil;
  FStream.Position := ReadHead(ResourceName, HeadInfo);
  InfoStatusBar(HeadInfo.FilePath);
  Tof := TMemoryStream.Create;
  Try
    DecompressStream(Tof, HeadInfo.SizeToDecomp);
    MemoryStream := TMemoryStream.Create;
    MemoryStream.LoadFromStream(Tof);
  Finally
    Tof.Free;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.DeleteResource(ResourceName : String);
// Suppression d'une ressource dans le fichier des ressources
Var
  Pos : Integer;
  ToF : TFileStream;
  HeadInfo : THead;
Begin
  ZeroMemory(@HeadInfo, SizeOf(HeadInfo));
  FStream.Position := 0;
  Pos := ReadHead(ResourceName, HeadInfo) - SizeOf(THead);
  InfoStatusBar(HeadInfo.FilePath);
  Tof := TFileStream.Create(TempPath + '\' + ExtractFileName(CurrentRes), FmCreate);
  Try
    If Pos <> 0 Then Tof.CopyFrom(FStream, Pos);
    FStream.Position := FStream.Position + SizeOf(HeadInfo) + HeadInfo.Size;
    Tof.CopyFrom(FStream, FStream.Size - FStream.Position);
    DeleteFromListView(ResourceName);
  Finally
    Tof.Free;
  End;
  FStream.Free;
  DeleteFile(CurrentRes);
  MoveFile(PChar(TempPath + '\' + ExtractFileName(CurrentRes)), PChar(CurrentRes));
  FStream := TFileStream.Create(CurrentRes, fmOpenReadwrite);
  CreateTable;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.AddFiles(FilesPath : TStrings;OverWrite : Bool = False);
// Ajoute plusieurs fichiers au fichier des ressources
Var
  I : Integer;
Begin
  For I := 0 To FilesPath.Count - 1 Do
  Begin
    Try
      GeneralProgress(FilesPath.Count);
      AddFile(FilesPath.Strings[I], '', OverWrite);
    Except
      On ErmResAlreadyExists Do
      Begin
        If OverWrite = False Then
          Case MessageDlg('Le nom : ' + FilesPath.Strings[I] + 'est déjà utilisé, voulez-vous mettre à jour cette ressource?', mtInformation, [mbYes, mbNo, mbAll], 0) Of
            mrYes :
              Begin
                AddFile(FilesPath.Strings[I], '', True);
              End;
            mrAll :
              Begin
                OverWrite := True;
                AddFile(FilesPath.Strings[I], '', True);
              End;
          End;
      End;
      On E : Exception Do
      Begin
        If MsgError Then MessageDlg(MSG_ADD + ' : ' + E.Message, mtError, [mbOK, mbHelp], E.HelpContext);
        ErrTable.Add(MSG_ADD + ' : ' + E.Message);
      End;
    End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.AddDirectory(SourceDir : String;SubDirectories : Bool;OverWrite : Bool = False);
// Ajoute un répertoire au fichier des ressources
Var
  Files : TStrings;
Begin
  Files := Nil;
  FindFiles(SourceDir, '*.*', Files, SubDirectories, True);
  AddFiles(Files, OverWrite);
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.ExtractFiles(FromPath : String;ResourcesName : TStrings;ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
// Extraction de plusieurs fichiers contenus dans le fichier des ressources
Var
  I : Integer;
Begin
  For I := 0 To ResourcesName.Count - 1 Do
  Begin
    GeneralProgress(ResourcesName.Count);
    Try
      ExtractFile(FromPath, ResourcesName.Strings[I], ExtractPathFlag, OverWrite);
    Except
      On ErmFileAlreadyExists Do
      Begin
        If OverWrite = False Then
          Case MessageDlg('Le Fichier : ' + ResourcesName.Strings[I] + ', existe déjà, voulez-vous le remplacer?', mtInformation, [mbYes, mbNo, mbAll], 0) Of
            mrYes : ExtractFile(FromPath, ResourcesName.Strings[I], ExtractPathFlag, True);
            mrAll :
              Begin
                OverWrite := True;
                ExtractFile(FromPath, ResourcesName.Strings[I], ExtractPathFlag, True);
              End;
          End;
      End;
      On E : Exception Do
      Begin
        If MsgError Then
          MessageDlg(MSG_EXTRACT + ' pour la ressource (' + ResourcesName.Strings[I] + ' : ' + E.Message, mtError, [mbOK], 0);
        ErrTable.Add(MSG_EXTRACT + ' pour la ressource (' + ResourcesName.Strings[I] + ' : ' + E.Message);
      End;
    End;
  End;
End;

//------------------------------------------------------------------------------

Procedure TResourcesMaker.ExtractAllFiles(FromPath : String;Const ExtractPathFlag : Integer = rmENormal;OverWrite : Bool = False);
// Extraction de tous les fichiers contenus dans le fichier des ressources
Var
  I : Integer;
  ResourceName : String;
Begin
  For I := 0 To Table.Count - 1 Do
  Begin
    GeneralProgress(Table.Count);
    Try
      ResourceName := ReadResourceName(I);
      ExtractFile(FromPath, ResourceName, ExtractPathFlag, OverWrite);
    Except
      On ErmFileAlreadyExists Do
      Begin
        If OverWrite = False Then
          Case MessageDlg('Le Fichier : ' + ResourceName + ', existe déjà, voulez-vous le remplacer?', mtInformation, [mbYes, mbNo, mbAll], 0) Of
            mrYes : ExtractFile(FromPath, ResourceName, ExtractPathFlag, True);
            mrAll :
              Begin
                OverWrite := True;
                ExtractFile(FromPath, ResourceName, ExtractPathFlag, True);
              End;
          End;
      End;
      On E : Exception Do
      Begin
        If MsgError Then
          MessageDlg(MSG_EXTRACT + ' pour la ressource (' + ResourceName + ' : ' + E.Message, mtError, [mbOK], 0);
        ErrTable.Add(MSG_EXTRACT + ' pour la ressource (' + ResourceName + ' : ' + E.Message);
      End;
    End;
  End;
End;


//------------------------------------------------------------------------------

Procedure TResourcesMaker.DeleteResources(ResourcesName : TStrings);
// Suppression de plusieurs ressources dans le fichier des ressources
Var
  I, Ct : Integer;
  ToF : TFileStream;
Begin
  FStream.Position := 0;
  CT := 0;
  Tof := TFileStream.Create(TempPath + '\' + ExtractFileName(CurrentRes), fmCreate);
  Try
    Try
      //On sauvegarde le début si les ressources sont dans un exe
      If FEntry.FirstEntry <> 0 Then Tof.CopyFrom(FStream, FEntry.FirstEntry);
      FStream.Position := FEntry.FirstEntry;
      For I := 0 To Table.Count - 1 Do
      Begin
        GeneralProgress(Table.Count);
        If IsInStrings(ReadResourceName(I), ResourcesName) Then
        Begin
          InfoStatusBar(ReadResourceName(I));
          If Ct <> 0 Then
          Begin
            Tof.CopyFrom(FStream, Ct);
            Ct := 0;
          End;
          FStream.Position := FStream.Position + SizeOf(THead) + ReadSize(I);
          DeleteFromListView(ReadResourceName(I));
        End
        Else
          Ct := Ct + SizeOf(THead) + ReadSize(I);
      End;
      Tof.CopyFrom(FStream, Ct + SizeOf(TEntry));
    Finally
      Tof.Free;
    End;
    FStream.Free;
    DeleteFile(CurrentRes);
    MoveFile(PChar(TempPath + '\' + ExtractFileName(CurrentRes)), PChar(CurrentRes));
    FStream := TFileStream.Create(CurrentRes, fmOpenReadwrite);
    CreateTable;
  Except
    On E : Exception Do
    Begin
      If MsgError Then MessageDlg(MSG_DELETE_RESOURCE + ' : ' + E.Message, mtError, [mbOK, mbHelp], E.HelpContext);
      ErrTable.Add(MSG_DELETE_RESOURCE + ' : ' + E.Message);
    End;
  End;
End;

//------------------------------------------------------------------------------

Function TResourcesMaker.MakeAutoExtract(AutoExtractFilePath : String) : Bool;
// Crée un auto extractible à partir du fichier des ressources courant
Var
  ExtractExe : TFileStream;
  NewAutoPath : String;
  NewEntry : TEntry;
Begin
  Result := True;
  NewAutoPath := FilePathWithoutExt(CurrentRes) + '.exe';
  CopyFile(PChar(AutoExtractFilePath), PChar(NewAutoPath), false);
  ZeroMemory(@NewEntry, SizeOf(TEntry));
  FStream.Position := FStream.Size - SizeOf(TEntry);
  FStream.Read(NewEntry, SizeOf(TEntry));
  ExtractExe := TFileStream.Create(NewAutoPath, fmOpenReadWrite);
  Try
    ExtractExe.Position := ExtractExe.Size;
    NewEntry.FirstEntry := ExtractExe.Position;
    FStream.Position := 0;
    ExtractExe.CopyFrom(FStream, FStream.size);
    ExtractExe.Position := ExtractExe.Size - SizeOf(TEntry);
    ExtractExe.Write(NewEntry, SizeOf(TEntry));
    ExtractExe.Free;
  Except
    Result := False;
    ExtractExe.Free;
  End;
End;
End.

