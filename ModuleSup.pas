
unit ModuleSup;

interface

uses unit1,unit2,unit3,unit4,unit5,unit6,unit7,unit8,unit9,unit10,
     unit11,unit12,unit13,unit14,unit15,unit16,unit17,unit18,unit19,unit20,
     unit21,unit22,unit23,unit24,unit26,unit27,unit28,unit29,unit30,
     unit31,unit32,
     Controls,ShellApi,SysUtils,IniFiles,Messages,ExtCtrls, TLHelp32, Clipbrd,
     forms,Dialogs, mapi,classes,Registry, StdCtrls, ComCtrls, windows, CommCtrl;

Type TDetailOrder = record
     FrText_Order : String;
     LngText_Order : String;
     end;

Type TAllDetailOrder = record
     Items : array of TDetailOrder;
     Count : integer;
     end;

procedure OptionIni;
procedure LoadLanguage(Language : String);
function SendEMail(Handle: THandle; Mail: TStrings): Cardinal;
procedure AddAdrExeList(SList : TComboBox);
procedure Form1_LoadTreeView1();
procedure Form1_changeTxtTreeView1(Text : String; index : integer);

var AllDetailOrder : TAllDetailOrder;

implementation

procedure Form1_LoadTreeView1();
var i : integer;
begin
for i := 0 to Form1.TreeView1.Items.Count -1
do begin
   AllDetailOrder.count := length(AllDetailOrder.Items)+1;
   SetLength(AllDetailOrder.Items,AllDetailOrder.count);
   AllDetailOrder.Items[i].FrText_Order := Form1.TreeView1.Items[i].Text;
   AllDetailOrder.Items[i].LngText_Order := Form1.TreeView1.Items[i].Text;
   end;
end;

procedure Form1_changeTxtTreeView1(Text : String; index : integer);
begin
if index < 0 then Exit;
if index >length(AllDetailOrder.Items)-1 then Exit;
AllDetailOrder.Items[index].LngText_Order := Text;
Form1.TreeView1.Items[index].Text := Text;
end;

procedure AddAdrExeList(SList : TComboBox);
var Reg: TRegistry;
    i,j,UrlIndex : integer;
    Url, Exe, tmp : String;
begin
  Reg := TRegistry.Create;
  try
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU', False)
    then begin
         for i := ord('a') to ord('z')
         do begin
            Exe := Reg.ReadString(chr(i));
            tmp := '';
            for j := 1 to length(Exe)
            do if Exe[j] <> '\' then tmp := tmp + Exe[j] else break;

            if tmp <> '' then SList.Items.Add(tmp);
            end;
         end; Reg.CloseKey;

    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Internet Explorer\TypedURLs', False)
    then begin
         for UrlIndex := 1 to 100
         do begin
            Url := Reg.ReadString('url'+Inttostr(UrlIndex));
            if Url <> '' then SList.Items.Add(Url);
            end;
         end; Reg.CloseKey;

    finally Reg.Free; end;
end;

function SendEMail(Handle: THandle; Mail: TStrings): Cardinal;
type
 TAttachAccessArray = array [0..0] of TMapiFileDesc;
 PAttachAccessArray = ^TAttachAccessArray;
var 
 MapiMessage: TMapiMessage; 
 Receip: TMapiRecipDesc; 
 Attachments: PAttachAccessArray; 
 AttachCount: Integer; 
 i1: integer; 
 FileName: string; 
 dwRet: Cardinal; 
 MAPI_Session: Cardinal; 
 WndList: Pointer; 
begin
Result := 0; 
 dwRet := MapiLogon(Handle, 
   PChar(''), 
   PChar(''), 
   MAPI_LOGON_UI or MAPI_NEW_SESSION, 
   0, @MAPI_Session); 

 if (dwRet <> SUCCESS_SUCCESS) then 
 begin 
   MessageBox(Handle, 
     PChar('Error while trying to send email'), 
     PChar('Error'), 
     MB_ICONERROR or MB_OK); 
 end 
 else 
 begin 
   FillChar(MapiMessage, SizeOf(MapiMessage), #0); 
   Attachments := nil; 
   FillChar(Receip, SizeOf(Receip), #0); 

   if Mail.Values['to'] <> '' then 
   begin 
     Receip.ulReserved := 0; 
     Receip.ulRecipClass := MAPI_TO; 
     Receip.lpszName := StrNew(PChar(Mail.Values['to'])); 
     Receip.lpszAddress := StrNew(PChar('SMTP:' + Mail.Values['to'])); 
     Receip.ulEIDSize := 0; 
     MapiMessage.nRecipCount := 1; 
     MapiMessage.lpRecips := @Receip; 
   end; 

   AttachCount := 0; 

   for i1 := 0 to MaxInt do 
   begin 
     if Mail.Values['attachment' + IntToStr(i1)] = '' then 
       break; 
     Inc(AttachCount); 
   end; 

   if AttachCount > 0 then 
   begin 
     GetMem(Attachments, SizeOf(TMapiFileDesc) * AttachCount); 

     for i1 := 0 to AttachCount - 1 do 
     begin 
       FileName := Mail.Values['attachment' + IntToStr(i1)]; 
       Attachments[i1].ulReserved := 0; 
       Attachments[i1].flFlags := 0; 
       Attachments[i1].nPosition := ULONG($FFFFFFFF); 
       Attachments[i1].lpszPathName := StrNew(PChar(FileName)); 
       Attachments[i1].lpszFileName := 
         StrNew(PChar(ExtractFileName(FileName))); 
       Attachments[i1].lpFileType := nil; 
     end; 
     MapiMessage.nFileCount := AttachCount; 
     MapiMessage.lpFiles := @Attachments^; 
   end; 

   if Mail.Values['subject'] <> '' then 
     MapiMessage.lpszSubject := StrNew(PChar(Mail.Values['subject'])); 
   if Mail.Values['body'] <> '' then 
     MapiMessage.lpszNoteText := StrNew(PChar(Mail.Values['body'])); 

   WndList := DisableTaskWindows(0); 
   try 
   Result := MapiSendMail(MAPI_Session, Handle, 
     MapiMessage, MAPI_DIALOG, 0); 
   finally 
     EnableTaskWindows( WndList ); 
   end; 

   for i1 := 0 to AttachCount - 1 do 
   begin 
     StrDispose(Attachments[i1].lpszPathName); 
     StrDispose(Attachments[i1].lpszFileName); 
   end; 

   if Assigned(MapiMessage.lpszSubject) then 
     StrDispose(MapiMessage.lpszSubject); 
   if Assigned(MapiMessage.lpszNoteText) then 
     StrDispose(MapiMessage.lpszNoteText); 
   if Assigned(Receip.lpszAddress) then 
     StrDispose(Receip.lpszAddress); 
   if Assigned(Receip.lpszName) then 
     StrDispose(Receip.lpszName); 
   MapiLogOff(MAPI_Session, Handle, 0, 0); 
 end; 
end; 



procedure OptionIni;
begin
if not FileExists(Form1.GetFileIniName)
then ShowMessage('Veuillez régler les options avant d''executer une macro.');
end;

procedure LoadLanguage(Language : String);
var  FileLng : TIniFile;
     FileNameLng : String;
     i : integer;
begin
// pour la description des commandes
if unit1.Description <> nil
then begin
     unit1.Description.Clear;
     if FileExists(ExtractFileDir(Application.ExeName) + '\'+ form19.ComboBox3.Text + '.lng')
     then unit1.Description.LoadFromFile(ExtractFileDir(Application.ExeName) + '\'+ form19.ComboBox3.Text + '.lng');
     end;
     
FileNameLng := ExtractFilePath(Application.ExeName) +  Language + '.lng';
if not Fileexists(FileNameLng) then begin Exit; end;
FileLng := TIniFile.Create(FileNameLng);


Form1.Macro1.caption := FileLng.ReadString('Menu1','Macro1',Form1.Macro1.caption);
Form1.Nouveau1.caption := FileLng.ReadString('Menu1','Macro2',Form1.Nouveau1.caption);
Form1.Ouvrir1.caption := FileLng.ReadString('Menu1','Macro3',Form1.Ouvrir1.caption);
Form1.Enregistrer1.caption := FileLng.ReadString('Menu1','Macro4',Form1.Enregistrer1.caption);
Form1.Enregistersous1.caption := FileLng.ReadString('Menu1','Macro5',Form1.Enregistersous1.caption);
Form1.Recents1.caption := FileLng.ReadString('Menu1','Macro6',Form1.Recents1.caption);
Form1.Options1.caption := FileLng.ReadString('Menu1','Macro7',Form1.Options1.caption);
Form1.Imprimer1.caption := FileLng.ReadString('Menu1','Macro8',Form1.Imprimer1.caption);
Form1.Crypter1.caption := FileLng.ReadString('Menu1','Macro9',Form1.Crypter1.caption);
Form1.Quitter1.caption := FileLng.ReadString('Menu1','Macro10',Form1.Quitter1.caption);
Form1.Aperuavantimpression1.caption := FileLng.ReadString('Menu1','Macro11',Form1.Aperuavantimpression1.caption);
Form1.Exporterversexecutable1.caption := FileLng.ReadString('Menu1','Macro12',Form1.Exporterversexecutable1.caption);

Form1.Edition1.caption := FileLng.ReadString('Menu1','Edit1',Form1.Edition1.caption);
Form1.Dfaire1.caption := FileLng.ReadString('Menu1','Edit2',Form1.Dfaire1.caption);
Form1.Editer1.caption := FileLng.ReadString('Menu1','Edit3',Form1.Editer1.caption);
Form1.Mode1.caption := FileLng.ReadString('Menu1','Edit4',Form1.Mode1.caption);
Form1.Edition2.caption := FileLng.ReadString('Menu1','Edit5',Form1.Edition2.caption);
Form1.Insertion1.caption := FileLng.ReadString('Menu1','Edit6',Form1.Insertion1.caption);
Form1.Couper2.caption := FileLng.ReadString('Menu1','Edit7',Form1.Couper2.caption);
Form1.Copier2.caption := FileLng.ReadString('Menu1','Edit8',Form1.Copier2.caption);
Form1.Coller2.caption := FileLng.ReadString('Menu1','Edit9',Form1.Coller2.caption);
Form1.Supprimer1.caption := FileLng.ReadString('Menu1','Edit10',Form1.Supprimer1.caption);
Form1.Rechercher2.Caption := FileLng.ReadString('Menu1','Edit11',Form1.Rechercher2.caption);
Form1.Danslescommandes1.Caption := FileLng.ReadString('Menu1','Edit12',Form1.Danslescommandes1.caption);
Form1.Danslesparamtres1.Caption := FileLng.ReadString('Menu1','Edit13',Form1.Danslesparamtres1.caption);
Form1.Danslescommandesetparamtres1.Caption := FileLng.ReadString('Menu1','Edit14',Form1.Danslescommandesetparamtres1.caption);
Form1.Remplacer1.Caption := FileLng.ReadString('Menu1','Edit15',Form1.Remplacer1.caption);
Form1.N2.Caption := FileLng.ReadString('Menu1','Edit16',Form1.N2.caption);



Form1.Executer1.caption := FileLng.ReadString('Menu1','Exec1',Form1.Executer1.caption);
Form1.Execute1.caption := FileLng.ReadString('Menu1','Exec2',Form1.Execute1.caption);
Form1.Paspas1.caption := FileLng.ReadString('Menu1','Exec3',Form1.Paspas1.caption);
Form1.Stop1.caption := FileLng.ReadString('Menu1','Exec4',Form1.Stop1.caption);
Lng_Point_darret := FileLng.ReadString('Menu1','Exec5',Form1.Pointdarrt1.caption);
Form1.Pointdarrt1.caption := Lng_Point_darret;
Form1.Reprendrelexcution1.caption := FileLng.ReadString('Menu1','Exec6',Form1.Reprendrelexcution1.caption);
Lng_Delete_Point_darret := FileLng.ReadString('Menu1','Exec7',Form1.Pointdarrt1.caption);
Lng_MenuContextExeSave := FileLng.ReadString('Menu1','Exec8',Lng_MenuContextExeSave);
Lng_MenuContextExeDownLoad := FileLng.ReadString('Menu1','Exec9',Lng_MenuContextExeDownLoad);
Form1.Sauvegardeducontextedexcution1.Caption := Lng_MenuContextExeDownLoad;

Form1.Pointdarrt1.caption := Unit1.Lng_Delete_Point_darret;
Lng_Error_with_edit := FileLng.ReadString('Form1','Error_with_edit',Lng_Error_with_edit);
Lng_Error_without_edit := FileLng.ReadString('Form1','Error_without_edit',Lng_Error_without_edit);


Form1.Outils1.caption := FileLng.ReadString('Menu1','Tool1',Form1.Outils1.caption);
Form1.Dtailcommandes1.caption := FileLng.ReadString('Menu1','Tool2',Form1.Dtailcommandes1.caption);
Form1.Panel4.Caption := Form1.Dtailcommandes1.caption;
Form1.Enregistrerunesequence1.caption := FileLng.ReadString('Menu1','Tool3',Form1.Enregistrerunesequence1.caption);
Form1.Spy1.caption := FileLng.ReadString('Menu1','Tool4',Form1.Spy1.caption);
Form1.RechercherObjet1.caption := FileLng.ReadString('Menu1','Tool5',Form1.RechercherObjet1.caption);
Form1.mesoutils1.caption := FileLng.ReadString('Menu1','Tool6',Form1.mesoutils1.caption);
Form1.Gestiondesnouvellecommandes1.Caption := FileLng.ReadString('Menu1','Tool8',Form1.Gestiondesnouvellecommandes1.caption);
Form1.valuer2.Caption := FileLng.ReadString('Menu1','Tool9',Form1.valuer2.Caption);
Form1.Aide1.caption := FileLng.ReadString('Menu1','Help1',Form1.Aide1.caption);
Form1.Consulter1.caption := FileLng.ReadString('Menu1','Help2',Form1.Consulter1.caption);
Form1.Apropos1.caption := FileLng.ReadString('Menu1','Help3',Form1.Apropos1.caption);

Form1.Monterdunniveau1.Caption := FileLng.ReadString('Menu2','Chx1',Form1.Monterdunniveau1.caption);
Form1.Descendredunniveau1.Caption := FileLng.ReadString('Menu2','Chx2',Form1.Descendredunniveau1.caption);
Form1.Couper1.Caption := FileLng.ReadString('Menu2','Chx3',Form1.Couper1.caption);
Form1.Copier1.Caption := FileLng.ReadString('Menu2','Chx4',Form1.Copier1.caption);
Form1.Coller1.Caption := FileLng.ReadString('Menu2','Chx5',Form1.Coller1.caption);
Form1.Supprimer2.Caption := FileLng.ReadString('Menu2','Chx6',Form1.Supprimer2.caption);
Form1.Insereruncommentaire1.Caption := FileLng.ReadString('Menu2','Chx7',Form1.Insereruncommentaire1.caption);

Form1.Rafr1.Caption := FileLng.ReadString('Menu3','Chx1',Form1.Rafr1.caption);
Form1.Enregistrer1.Caption := FileLng.ReadString('Menu3','Chx2',Form1.Enregistrer1.caption);
Form1.Imprimer2.Caption := FileLng.ReadString('Menu3','Chx3',Form1.Imprimer2.caption);
Form1.Rechercher1.Caption := FileLng.ReadString('Menu3','Chx4',Form1.Rechercher1.caption);

Form1.Quitter2.Caption := FileLng.ReadString('Menu4','Chx1',Form1.Quitter2.Caption);

Form1.Annuler1.Caption := FileLng.ReadString('Menu5','Chx1',Form1.Annuler1.Caption);
Form1.Couper3.Caption := FileLng.ReadString('Menu5','Chx2',Form1.Couper3.Caption);
Form1.Copier3.Caption := FileLng.ReadString('Menu5','Chx3',Form1.Copier3.Caption);
Form1.Coller3.Caption := FileLng.ReadString('Menu5','Chx4',Form1.Coller3.Caption);
Form1.Supprimer3.Caption := FileLng.ReadString('Menu5','Chx5',Form1.Supprimer3.Caption);
Form1.SlctionnerTout1.Caption := FileLng.ReadString('Menu5','Chx6',Form1.SlctionnerTout1.Caption);
Form1.Enregistrer2.Caption := FileLng.ReadString('Menu5','Chx7',Form1.Enregistrer2.Caption);
Form1.Envoyeralauteur1.Caption := FileLng.ReadString('Menu5','Chx8',Form1.Envoyeralauteur1.Caption);

Form1.Ajouter1.Caption := FileLng.ReadString('Menu6','Chx1',Form1.Ajouter1.Caption);
Form1.Modifier1.Caption := FileLng.ReadString('Menu6','Chx2',Form1.Modifier1.Caption);
Form1.Supprimer4.Caption := FileLng.ReadString('Menu6','Chx3',Form1.Supprimer4.Caption);
Form1.Reinitialiertouteslesvariable1.Caption := FileLng.ReadString('Menu6','Chx4',Form1.Reinitialiertouteslesvariable1.Caption);
Form1.Supprimertouteslesvariables1.Caption := FileLng.ReadString('Menu6','Chx5',Form1.Supprimertouteslesvariables1.Caption);

Form1.TabSheet1.Caption := FileLng.ReadString('Form1','TabSheet1',Form1.TabSheet1.Caption);
Form1.TabSheet2.Caption := FileLng.ReadString('Form1','TabSheet2',Form1.TabSheet2.Caption);
Form1.TabSheet3.Caption := FileLng.ReadString('Form1','TabSheet3',Form1.TabSheet3.Caption);
Form1.TabSheet4.Caption := FileLng.ReadString('Form1','TabSheet4',Form1.TabSheet4.Caption);
Form1.TabSheet5.Caption := FileLng.ReadString('Form1','TabSheet5',Form1.TabSheet5.Caption);
Form1.TabSheet6.Caption := FileLng.ReadString('Form1','TabSheet6',Form1.TabSheet6.Caption);
Form1.TabSheet7.Caption := FileLng.ReadString('Form1','TabSheet7',Form1.TabSheet7.Caption);

// ---------------------------- Par le Fichier Component Sort -------------------------------------------
for i := 1 to 136
do moduleSup.Form1_changeTxtTreeView1(FileLng.ReadString('Form1','Item'+IntToStr(i),Form1.TreeView1.Items[i-1].Text),i-1);

Form1.SpeedButton100.Hint := Form1.Nouveau1.Caption;
Form1.SpeedButton101.Hint := Form1.Ouvrir1.Caption;
Form1.SpeedButton102.Hint := Form1.Enregistrer1.Caption;
Form1.SpeedButton103.Hint := Form1.Execute1.Caption;
Form1.SpeedButton104.Hint := Form1.Paspas1.Caption;
Form1.SpeedButton105.Hint := Form1.Stop1.Caption;
Form1.SpeedButton106.Hint := Form1.Couper2.Caption;
Form1.SpeedButton107.Hint := Form1.Copier2.Caption;
Form1.SpeedButton108.Hint := Form1.Coller2.Caption;
Form1.SpeedButton109.Hint := Form1.Supprimer1.Caption;
Form1.SpeedButton110.Hint := Form1.valuer1.Caption;
Form1.SpeedButton111.Hint := Form1.Pointdarrt1.Caption;

Form1.SpeedButton1.Hint := AllDetailOrder.Items[10].LngText_Order;
Form1.SpeedButton2.Hint := AllDetailOrder.Items[9].LngText_Order;
Form1.SpeedButton3.Hint := AllDetailOrder.Items[67].LngText_Order;
Form1.SpeedButton4.Hint := AllDetailOrder.Items[34].LngText_Order;
Form1.SpeedButton5.Hint := AllDetailOrder.Items[18].LngText_Order;
Form1.SpeedButton6.Hint := 'Label';
Form1.SpeedButton7.Hint := 'Goto';
Form1.SpeedButton8.Hint := AllDetailOrder.Items[63].LngText_Order;
Form1.SpeedButton9.Hint := AllDetailOrder.Items[71].LngText_Order;
Form1.SpeedButton10.Hint := AllDetailOrder.Items[24].LngText_Order;
Form1.SpeedButton11.Hint := AllDetailOrder.Items[13].LngText_Order;
Form1.SpeedButton12.Hint := AllDetailOrder.Items[0].LngText_Order;
Form1.SpeedButton13.Hint := AllDetailOrder.Items[74].LngText_Order;
Form1.SpeedButton14.Hint := AllDetailOrder.Items[65].LngText_Order;
Form1.SpeedButton15.Hint := AllDetailOrder.Items[28].LngText_Order;
Form1.SpeedButton16.Hint := AllDetailOrder.Items[41].LngText_Order;
Form1.SpeedButton17.Hint := AllDetailOrder.Items[42].LngText_Order;
Form1.SpeedButton18.Hint := AllDetailOrder.Items[7].LngText_Order;
Form1.SpeedButton19.Hint := AllDetailOrder.Items[70].LngText_Order;
Form1.SpeedButton22.Hint := AllDetailOrder.Items[1].LngText_Order;


Form2.Caption  := AllDetailOrder.Items[10].LngText_Order;  // frappe de texte
Form4.Caption  := AllDetailOrder.Items[9].LngText_Order;   // saisie de touche
Form5.Caption  := AllDetailOrder.Items[34].LngText_Order;  // déplacement curseur
Form6.Caption  := AllDetailOrder.Items[67].LngText_Order;  // Clique souris
Form26.Caption := AllDetailOrder.Items[18].LngText_Order;  // Commande Exécute
Form7.Caption  := AllDetailOrder.Items[63].LngText_Order;  // Pause
Form8.Caption  := AllDetailOrder.Items[71].LngText_Order;  // Déclaration de variable
Form30.Caption := AllDetailOrder.Items[7].LngText_Order;   // définition de Champ
Form9.Caption  := AllDetailOrder.Items[24].LngText_Order;  // Question
Form11.Caption := AllDetailOrder.Items[13].LngText_Order;  // Examine
Form12.Caption := AllDetailOrder.Items[0].LngText_Order;   // calcul variable
Form24.Caption := AllDetailOrder.Items[1].LngText_Order;   // calcul évolué
Form13.Caption := AllDetailOrder.Items[74].LngText_Order;  // Fonction
Form15.Caption := AllDetailOrder.Items[28].LngText_Order;  // Lire écrire
Form18.Caption := AllDetailOrder.Items[41].LngText_Order;  // manipulation objet
Form27.Caption := AllDetailOrder.Items[42].LngText_Order;  // Boite à outils
Form22.Caption := AllDetailOrder.Items[70].LngText_Order;  // trouve image
Form23.Caption := Form1.Apropos1.Caption;

Form1.SpeedButton19.caption := FileLng.ReadString('Form1','SpeedButton19',Form1.SpeedButton19.caption);
Form1.SpeedButton20.caption := FileLng.ReadString('Form1','SpeedButton20',Form1.SpeedButton20.caption);
Form1.SpeedButton21.caption := FileLng.ReadString('Form1','SpeedButton21',Form1.SpeedButton21.caption);
Form1.SpeedButton22.caption := FileLng.ReadString('Form1','SpeedButton22',Form1.SpeedButton22.caption);
Form1.SpeedButton23.caption := FileLng.ReadString('Form1','SpeedButton23',Form1.SpeedButton23.caption);
Form1.SpeedButton24.caption := FileLng.ReadString('Form1','SpeedButton24',Form1.SpeedButton24.caption);
Form1.SpeedButton25.caption := FileLng.ReadString('Form1','SpeedButton25',Form1.SpeedButton25.caption);
Form1.SpeedButton28.caption := FileLng.ReadString('Form1','SpeedButton28',Form1.SpeedButton28.caption);
Form1.CheckBox1.Caption := FileLng.ReadString('Form1','CheckBox1',Form1.CheckBox1.caption);
Form1.CheckBox3.Caption := FileLng.ReadString('Form1','CheckBox3',Form1.CheckBox3.caption);
Form1.ListView1.Columns[0].Caption := FileLng.ReadString('Form1','Order',Form1.ListView1.Columns[0].Caption);
Form1.ListView1.Columns[1].Caption := FileLng.ReadString('Form1','Parameter',Form1.ListView1.Columns[1].Caption);
Form1.ListView4.Columns[2].Caption := FileLng.ReadString('Form1','Order',Form1.ListView4.Columns[2].Caption);
Form1.ListView4.Columns[3].Caption := FileLng.ReadString('Form1','Parameter',Form1.ListView4.Columns[3].Caption);

Form2.Button1.caption := FileLng.ReadString('Form2','Button1',Form2.Button1.caption);
Form2.Button2.caption := FileLng.ReadString('Form2','Button2',Form2.Button2.caption);
Form3.Button1.caption := FileLng.ReadString('Form3','Button1',Form3.Button1.caption);
Form3.Button2.caption := FileLng.ReadString('Form3','Button2',Form3.Button2.caption);
Form4.Button1.caption := FileLng.ReadString('Form4','Button1',Form4.Button1.caption);
Form4.Button2.caption := FileLng.ReadString('Form4','Button2',Form4.Button2.caption);

Form5.Label1.caption := FileLng.ReadString('Form5','Label1',Form5.Label1.caption);
Form5.Label2.caption := FileLng.ReadString('Form5','Label2',Form5.Label2.caption);
Form5.Label3.caption := FileLng.ReadString('Form5','Label3',Form5.Label3.caption);
Form5.Label4.caption := FileLng.ReadString('Form5','Label4',Form5.Label4.caption);
Form5.Label5.caption := FileLng.ReadString('Form5','Label5',Form5.Label5.caption);
Form5.Button1.caption := FileLng.ReadString('Form5','Button1',Form5.Button1.caption);
Form5.Button2.caption := FileLng.ReadString('Form5','Button2',Form5.Button2.caption);
Form6.Label1.caption := FileLng.ReadString('Form6','Label1',Form6.Label1.caption);
Form6.Label2.caption := FileLng.ReadString('Form6','Label2',Form6.Label2.caption);
//Form6.Label3.caption := FileLng.ReadString('Form6','Label3',Form6.Label3.caption);
Form6.Label4.caption := FileLng.ReadString('Form6','Label4',Form6.Label4.caption);
//Form6.Label5.caption := FileLng.ReadString('Form6','Label5',Form6.Label5.caption);
Form6.Label6.caption := FileLng.ReadString('Form6','Label6',Form6.Label6.caption);
//Form6.Label7.caption := FileLng.ReadString('Form6','Label7',Form6.Label7.caption);
Form6.Label8.caption := FileLng.ReadString('Form6','Label8',Form6.Label8.caption);
Form6.Button1.caption := FileLng.ReadString('Form6','Button1',Form6.Button1.caption);
Form6.Button2.caption := FileLng.ReadString('Form6','Button2',Form6.Button2.caption);
Form7.Label1.caption := FileLng.ReadString('Form7','Label1',Form7.Label1.caption);
Form7.Button1.caption := FileLng.ReadString('Form7','Button1',Form7.Button1.caption);
Form7.Button2.caption := FileLng.ReadString('Form7','Button2',Form7.Button2.caption);
Form8.Label1.caption := FileLng.ReadString('Form8','Label1',Form8.Label1.caption);
Form8.Label2.caption := FileLng.ReadString('Form8','Label2',Form8.Label2.caption);
Form8.Label3.caption := FileLng.ReadString('Form8','Label3',Form8.Label3.caption);
Form8.Label4.caption := FileLng.ReadString('Form8','Label4',Form8.Label4.caption);
Form8.Label5.caption := FileLng.ReadString('Form8','Label5',Form8.Label5.caption);
Form8.Edit1.Text := FileLng.ReadString('Form8','Edit1',Form8.Edit1.Text);
Form8.Edit2.Text := FileLng.ReadString('Form8','Edit2',Form8.Edit2.Text);
Form8.Button1.caption := FileLng.ReadString('Form8','Button1',Form8.Button1.caption);
Form8.Button2.caption := FileLng.ReadString('Form8','Button2',Form8.Button2.caption);
Form9.Label1.caption := FileLng.ReadString('Form9','Label1',Form9.Label1.caption);
Form9.Label2.caption := FileLng.ReadString('Form9','Label2',Form9.Label2.caption);
Form9.Label3.caption := FileLng.ReadString('Form9','Label3',Form9.Label3.caption);
Form9.Button1.caption := FileLng.ReadString('Form9','Button1',Form9.Button1.caption);
Form9.Button2.caption := FileLng.ReadString('Form9','Button2',Form9.Button2.caption);
Form10.Label1.caption := FileLng.ReadString('Form10','Label1',Form10.Label1.caption);
Form10.Edit1.Text := FileLng.ReadString('Form10','Edit1',Form10.Edit1.Text);
Form10.Button1.caption := FileLng.ReadString('Form10','Button1',Form10.Button1.caption);
Form10.Button2.caption := FileLng.ReadString('Form10','Button2',Form10.Button2.caption);
Form11.Label1.caption := FileLng.ReadString('Form11','Label1',Form11.Label1.caption);
Form11.Label2.caption := FileLng.ReadString('Form11','Label2',Form11.Label2.caption);
Form11.Label3.caption := FileLng.ReadString('Form11','Label3',Form11.Label3.caption);
Form11.Label4.caption := FileLng.ReadString('Form11','Label4',Form11.Label4.caption);
Form11.Label5.caption := FileLng.ReadString('Form11','Label5',Form11.Label5.caption);
Form11.Label6.caption := FileLng.ReadString('Form11','Label6',Form11.Label6.caption);
Form11.Button1.caption := FileLng.ReadString('Form11','Button1',Form11.Button1.caption);
Form11.Button2.caption := FileLng.ReadString('Form11','Button2',Form11.Button2.caption);
Form12.Label1.caption := FileLng.ReadString('Form12','Label1',Form12.Label1.caption);
Form12.Label2.caption := FileLng.ReadString('Form12','Label2',Form12.Label2.caption);
Form12.Label3.caption := FileLng.ReadString('Form12','Label3',Form12.Label3.caption);
Form12.Label4.caption := FileLng.ReadString('Form12','Label4',Form12.Label4.caption);
Form12.Label5.caption := FileLng.ReadString('Form12','Label5',Form12.Label5.caption);
Form12.Label6.caption := FileLng.ReadString('Form12','Label6',Form12.Label6.caption);
Form12.Button1.caption := FileLng.ReadString('Form12','Button1',Form12.Button1.caption);
Form12.Button2.caption := FileLng.ReadString('Form12','Button2',Form12.Button2.caption);
Form13.Label1.caption := FileLng.ReadString('Form13','Label1',Form13.Label1.caption);
Form13.Label2.caption := FileLng.ReadString('Form13','Label2',Form13.Label2.caption);
Form13.Label3.caption := FileLng.ReadString('Form13','Label3',Form13.Label3.caption);
Form13.Label4.caption := FileLng.ReadString('Form13','Label4',Form13.Label4.caption);
Form13.Label5.caption := FileLng.ReadString('Form13','Label5',Form13.Label5.caption);
Form13.Label6.caption := FileLng.ReadString('Form13','Label6',Form13.Label6.caption);
Form13.Button1.caption := FileLng.ReadString('Form13','Button1',Form13.Button1.caption);
Form13.Button2.caption := FileLng.ReadString('Form13','Button2',Form13.Button2.caption);
Form14.Button1.caption := FileLng.ReadString('Form14','Button1',Form14.Button1.caption);
Form14.Button2.caption := FileLng.ReadString('Form14','Button2',Form14.Button2.caption);
Form15.Label1.caption := FileLng.ReadString('Form15','Label1',Form15.Label1.caption);
Form15.Label2.caption := FileLng.ReadString('Form15','Label2',Form15.Label2.caption);
Form15.Label3.caption := FileLng.ReadString('Form15','Label3',Form15.Label3.caption);
Form15.Label4.caption := FileLng.ReadString('Form15','Label4',Form15.Label4.caption);
Form15.Label5.caption := FileLng.ReadString('Form15','Label5',Form15.Label5.caption);
Form15.Label6.caption := FileLng.ReadString('Form15','Label6',Form15.Label6.caption);
Form15.Button1.caption := FileLng.ReadString('Form15','Button1',Form15.Button1.caption);
Form15.Button2.caption := FileLng.ReadString('Form15','Button2',Form15.Button2.caption);
Form15.SpeedButton1.caption := FileLng.ReadString('Form15','SpeedButton1',Form15.SpeedButton1.caption);
Form16.Label1.caption := FileLng.ReadString('Form16','Label1',Form16.Label1.caption);
Form16.Label2.caption := FileLng.ReadString('Form16','Label2',Form16.Label2.caption);
Form16.Label3.caption := FileLng.ReadString('Form16','Label3',Form16.Label3.caption);
Form16.Label4.caption := FileLng.ReadString('Form16','Label4',Form16.Label4.caption);
Form16.Label5.caption := FileLng.ReadString('Form16','Label5',Form16.Label5.caption);
Form16.Label6.caption := FileLng.ReadString('Form16','Label6',Form16.Label6.caption);
Form16.Label7.caption := FileLng.ReadString('Form16','Label7',Form16.Label7.caption);
Form16.Label8.caption := FileLng.ReadString('Form16','Label8',Form16.Label8.caption);
Form16.Label9.caption := FileLng.ReadString('Form16','Label9',Form16.Label9.caption);
Form16.Label10.caption := FileLng.ReadString('Form16','Label10',Form16.Label10.caption);
Form16.Label11.caption := FileLng.ReadString('Form16','Label11',Form16.Label11.caption);
Form16.Label12.caption := FileLng.ReadString('Form16','Label12',Form16.Label12.caption);
Form16.Label13.caption := FileLng.ReadString('Form16','Label13',Form16.Label13.caption);
Form16.Button1.caption := FileLng.ReadString('Form16','Button1',Form16.Button1.caption);
Form16.Button2.caption := FileLng.ReadString('Form16','Button2',Form16.Button2.caption);
Form16.Button3.caption := FileLng.ReadString('Form16','Button3',Form16.Button3.caption);
Form16.CheckBox1.caption := FileLng.ReadString('Form16','CheckBox1',Form16.CheckBox1.caption);
Form16.CheckBox2.caption := FileLng.ReadString('Form16','CheckBox2',Form16.CheckBox2.caption);
Form16.CheckBox3.caption := FileLng.ReadString('Form16','CheckBox3',Form16.CheckBox3.caption);

Form16.RadioGroup1.Caption := FileLng.ReadString('Form16','RadioGroup1',Form16.RadioGroup1.caption);
Form16.RadioGroup1.Items[0] := FileLng.ReadString('Form16','RadioGroup1Ch1',Form16.RadioGroup1.Items[0]);
Form16.RadioGroup1.Items[1] := FileLng.ReadString('Form16','RadioGroup1Ch2',Form16.RadioGroup1.Items[1]);
Form16.RadioGroup2.Caption := FileLng.ReadString('Form16','RadioGroup2',Form16.RadioGroup2.caption);
Form16.RadioGroup2.Items[0] := FileLng.ReadString('Form16','RadioGroup2Ch1',Form16.RadioGroup2.Items[0]);
Form16.RadioGroup2.Items[1] := FileLng.ReadString('Form16','RadioGroup2Ch2',Form16.RadioGroup2.Items[1]);
Form16.RadioGroup2.Items[2] := FileLng.ReadString('Form16','RadioGroup2Ch3',Form16.RadioGroup2.Items[2]);

//Form17.Label1.caption := FileLng.ReadString('Form17','Label1',Form17.Label1.caption);
Form17.Label2.caption := FileLng.ReadString('Form17','Label2',Form17.Label2.caption);
Form17.Edit1.Text := FileLng.ReadString('Form17','Edit1',Form17.Edit1.Text);
Form17.Button1.caption := FileLng.ReadString('Form17','Button1',Form17.Button1.caption);
Form17.Button2.caption := FileLng.ReadString('Form17','Button2',Form17.Button2.caption);
Form17.Button3.caption := FileLng.ReadString('Form17','Button3',Form17.Button3.caption);
Form17.SpeedButton1.caption := FileLng.ReadString('Form17','SpeedButton1',Form17.SpeedButton1.caption);
Form18.Label1.caption := FileLng.ReadString('Form18','Label1',Form18.Label1.caption);
Form18.Label2.caption := FileLng.ReadString('Form18','Label2',Form18.Label2.caption);
Form18.Label3.caption := FileLng.ReadString('Form18','Label3',Form18.Label3.caption);
Form18.Label4.caption := FileLng.ReadString('Form18','Label4',Form18.Label4.caption);
Form18.Label5.caption := FileLng.ReadString('Form18','Label5',Form18.Label5.caption);
Form18.Label6.caption := FileLng.ReadString('Form18','Label6',Form18.Label6.caption);
Form18.Label7.caption := FileLng.ReadString('Form18','Label7',Form18.Label7.caption);
Form18.Label8.caption := FileLng.ReadString('Form18','Label8',Form18.Label8.caption);
Form18.Button1.caption := FileLng.ReadString('Form18','Button1',Form18.Button1.caption);
Form18.Button2.caption := FileLng.ReadString('Form18','Button2',Form18.Button2.caption);

Unit18.lng_Restaurer := FileLng.ReadString('Form18','lng_Restaurer',Unit18.lng_restaurer);
Unit18.lng_Deplacer := FileLng.ReadString('Form18','lng_Deplacer',Unit18.lng_Deplacer);
Unit18.lng_Taille := FileLng.ReadString('Form18','lng_Taille',Unit18.lng_Taille);
Unit18.lng_Reduire := FileLng.ReadString('Form18','lng_Reduire',Unit18.lng_Reduire);
Unit18.lng_Agrandir := FileLng.ReadString('Form18','lng_Agrandir',Unit18.lng_Agrandir);
Unit18.lng_Fermer := FileLng.ReadString('Form18','lng_Fermer',Unit18.lng_Fermer);

Unit18.lng_msgInit := FileLng.ReadString('Form18','lng_msgInit',Unit18.lng_msgInit);
Unit18.lng_msgNotParam := FileLng.ReadString('Form18','lng_msgNotParam',Unit18.lng_msgNotParam);
Unit18.lng_msgDeplace := FileLng.ReadString('Form18','lng_msgDeplace',Unit18.lng_msgDeplace);
Unit18.lng_msgTaille := FileLng.ReadString('Form18','lng_msgTaille',Unit18.lng_msgTaille);
Unit18.lng_msgChgText := FileLng.ReadString('Form18','lng_msgChgText',Unit18.lng_msgChgText);
Unit18.lng_msgNoAction := FileLng.ReadString('Form18','lng_Fermer',Unit18.lng_msgNoAction);

Form19.Label1.caption := FileLng.ReadString('Form19','Label1',Form19.Label1.caption);
Form19.Label2.caption := FileLng.ReadString('Form19','Label2',Form19.Label2.caption);
Form19.Label3.caption := FileLng.ReadString('Form19','Label3',Form19.Label3.caption);
Form19.Label4.caption := FileLng.ReadString('Form19','Label4',Form19.Label4.caption);
Form19.Label5.caption := FileLng.ReadString('Form19','Label5',Form19.Label5.caption);
Form19.Label6.caption := FileLng.ReadString('Form19','Label6',Form19.Label6.caption);
Form19.Label7.caption := FileLng.ReadString('Form19','Label7',Form19.Label7.caption);
Form19.Label8.caption := FileLng.ReadString('Form19','Label8',Form19.Label8.caption);
Form19.Label9.caption := FileLng.ReadString('Form19','Label9',Form19.Label9.caption);
Form19.Label10.caption := FileLng.ReadString('Form19','Label10',Form19.Label10.caption);
Form19.Label11.caption := FileLng.ReadString('Form19','Label11',Form19.Label11.caption);
Form19.Label12.caption := FileLng.ReadString('Form19','Label12',Form19.Label12.caption);
Form19.Label13.caption := FileLng.ReadString('Form19','Label13',Form19.Label13.caption);
Form19.Label14.caption := FileLng.ReadString('Form19','Label14',Form19.Label14.caption);
Form19.Label15.caption := FileLng.ReadString('Form19','Label15',Form19.Label15.caption);
Form19.Label17.caption := FileLng.ReadString('Form19','Label17',Form19.Label17.caption);
Form19.Label18.caption := FileLng.ReadString('Form19','Label18',Form19.Label18.caption);
Form19.Label19.caption := FileLng.ReadString('Form19','Label19',Form19.Label19.caption);
Form19.Label21.caption := FileLng.ReadString('Form19','Label21',Form19.Label21.caption);
Form19.Label23.caption := FileLng.ReadString('Form19','Label23',Form19.Label23.caption);
Form19.Label24.caption := FileLng.ReadString('Form19','Label24',Form19.Label24.caption);
Form19.Label25.caption := FileLng.ReadString('Form19','Label25',Form19.Label25.caption);
Form19.Label26.caption := FileLng.ReadString('Form19','Label26',Form19.Label26.caption);
Form19.Label27.caption := FileLng.ReadString('Form19','Label27',Form19.Label27.caption);
Form19.Label28.caption := FileLng.ReadString('Form19','Label28',Form19.Label28.caption);
Form19.Label29.caption := FileLng.ReadString('Form19','Label29',Form19.Label29.caption);
Form19.Label30.caption := FileLng.ReadString('Form19','Label30',Form19.Label30.caption) +' '+ unit1.DateCreation;
Form19.Label31.caption := FileLng.ReadString('Form19','Label31',Form19.Label31.caption);
Form19.Label33.caption := FileLng.ReadString('Form19','Label33',Form19.Label33.caption);
Form19.Label34.caption := FileLng.ReadString('Form19','Label34',Form19.Label34.caption);
Form19.Label35.caption := FileLng.ReadString('Form19','Label35',Form19.Label35.caption) +' '+Form19.Label36.caption;
Form19.Label36.caption := FileLng.ReadString('Form19','Label36',Form19.Label36.caption);
Form19.Label37.caption := FileLng.ReadString('Form19','Label37',Form19.Label37.caption);
Form19.Label38.caption := FileLng.ReadString('Form19','Label38',Form19.Label38.caption);
Form19.Label39.caption := FileLng.ReadString('Form19','Label39',Form19.Label39.caption);
Form19.Label40.caption := FileLng.ReadString('Form19','Label40',Form19.Label40.caption);
Form19.Label41.caption := FileLng.ReadString('Form19','Label41',Form19.Label41.caption);
Form19.Label43.caption := FileLng.ReadString('Form19','Label43',Form19.Label43.caption);
Form19.Label44.caption := FileLng.ReadString('Form19','Label44',Form19.Label44.caption);
Form19.Label45.caption := FileLng.ReadString('Form19','Label45',Form19.Label45.caption);
Form19.Label46.caption := FileLng.ReadString('Form19','Label46',Form19.Label46.caption);
Form19.Label47.caption := FileLng.ReadString('Form19','Label47',Form19.Label47.caption);
Form19.Label48.caption := FileLng.ReadString('Form19','Label48',Form19.Label48.caption);
Form19.Label49.caption := FileLng.ReadString('Form19','Label49',Form19.Label49.caption);
Form19.Label50.caption := FileLng.ReadString('Form19','Label50',Form19.Label50.caption);
Form19.Label51.caption := FileLng.ReadString('Form19','Label51',Form19.Label51.caption);
Form19.Label52.caption := FileLng.ReadString('Form19','Label52',Form19.Label52.caption);
Form19.Label53.caption := FileLng.ReadString('Form19','Label53',Form19.Label53.caption);
Form19.Label54.caption := FileLng.ReadString('Form19','Label54',Form19.Label54.caption);
Form19.Label55.caption := FileLng.ReadString('Form19','Label55',Form19.Label55.caption);

Form19.Button1.caption := FileLng.ReadString('Form19','Button1',Form19.Button1.caption);
Form19.Button2.caption := FileLng.ReadString('Form19','Button2',Form19.Button2.caption);
Form19.Button3.caption := FileLng.ReadString('Form19','Button3',Form19.Button3.caption);
Form19.Button4.caption := FileLng.ReadString('Form19','Button4',Form19.Button4.caption);
Form19.Button6.caption := FileLng.ReadString('Form19','Button6',Form19.Button6.caption);
Form19.Button7.caption := FileLng.ReadString('Form19','Button7',Form19.Button7.caption);
Form19.Button8.caption := FileLng.ReadString('Form19','Button8',Form19.Button8.caption);
Form19.Button9.caption := FileLng.ReadString('Form19','Button9',Form19.Button9.caption);
Form19.SpeedButton1.caption := FileLng.ReadString('Form19','SpeedButton1',Form19.SpeedButton1.caption);
Form19.SpeedButton2.caption := FileLng.ReadString('Form19','SpeedButton2',Form19.SpeedButton2.caption);
Form19.SpeedButton3.caption := FileLng.ReadString('Form19','SpeedButton3',Form19.SpeedButton3.caption);
Form19.TabSheet1.Caption := FileLng.ReadString('Form19','TabSheet1',Form19.TabSheet1.caption);
Form19.TabSheet2.Caption := FileLng.ReadString('Form19','TabSheet2',Form19.TabSheet2.caption);
Form19.TabSheet3.Caption := FileLng.ReadString('Form19','TabSheet3',Form19.TabSheet3.caption);
Form19.TabSheet4.Caption := FileLng.ReadString('Form19','TabSheet4',Form19.TabSheet4.caption);
Form19.TabSheet5.Caption := FileLng.ReadString('Form19','TabSheet5',Form19.TabSheet5.caption);
Form19.TabSheet6.Caption := FileLng.ReadString('Form19','TabSheet6',Form19.TabSheet6.caption);
Form19.TabSheet8.Caption := FileLng.ReadString('Form19','TabSheet8',Form19.TabSheet8.caption);
Unit19.Lgn_LastExecution := FileLng.ReadString('Form19','Lng_LastExecution',Unit19.Lgn_LastExecution);

Unit19.Lgn_No_Change := FileLng.ReadString('Form19','Lgn_No_Change',Unit19.Lgn_No_Change);
if Form19.ComboBox1.Text <> Form19.ComboBox1.Items[Form19.ComboBox1.Items.Count -1]
then Form19.ComboBox1.Items[Form19.ComboBox1.Items.Count -1] := Unit19.Lgn_No_Change
else begin
     Form19.ComboBox1.Items[Form19.ComboBox1.Items.Count -1] := Unit19.Lgn_No_Change;
     Form19.ComboBox1.Text := Unit19.Lgn_No_Change;
     end;
     
Form21.Label1.caption := FileLng.ReadString('Form21','Label1',Form21.Label1.caption);
Form21.Button1.caption := FileLng.ReadString('Form21','Button1',Form21.Button1.caption);
Form22.Label1.caption := FileLng.ReadString('Form22','Label1',Form22.Label1.caption);
Form22.Label2.caption := FileLng.ReadString('Form22','Label2',Form22.Label2.caption);
Form22.Label3.caption := FileLng.ReadString('Form22','Label3',Form22.Label3.caption);
Form22.Label4.caption := FileLng.ReadString('Form22','Label4',Form22.Label4.caption);
Form22.Label5.caption := FileLng.ReadString('Form22','Label5',Form22.Label5.caption);
Form22.Label6.caption := FileLng.ReadString('Form22','Label6',Form22.Label6.caption);
Form22.Label7.caption := FileLng.ReadString('Form22','Label7',Form22.Label7.caption);
Form22.Label8.caption := FileLng.ReadString('Form22','Label8',Form22.Label8.caption);
Form22.Label9.caption := FileLng.ReadString('Form22','Label9',Form22.Label9.caption);
Form22.Label10.caption := FileLng.ReadString('Form22','Label10',Form22.Label10.caption);
Form22.Label11.caption := FileLng.ReadString('Form22','Label11',Form22.Label11.caption);
Form22.Label12.caption := FileLng.ReadString('Form22','Label12',Form22.Label12.caption);
Form22.Label13.caption := FileLng.ReadString('Form22','Label13',Form22.Label13.caption);
Form22.Label14.caption := FileLng.ReadString('Form22','Label14',Form22.Label14.caption);
Form22.Edit2.Text := FileLng.ReadString('Form22','Label15',Form22.Edit2.Text);
Form22.ComboBox1.Text := FileLng.ReadString('Form22','ComboBox1',Form22.ComboBox1.Text);
Form22.Button1.caption := FileLng.ReadString('Form22','Button1',Form22.Button1.caption);
Form22.Button2.caption := FileLng.ReadString('Form22','Button2',Form22.Button2.caption);
Form22.Button3.caption := FileLng.ReadString('Form22','Button3',Form22.Button3.caption);
Form22.SpeedButton1.caption := FileLng.ReadString('Form22','SpeedButton1',Form22.SpeedButton1.caption);
Unit23.Lng_LastUpdate := FileLng.ReadString('Form23','Lng_LastUpdate',Unit23.Lng_LastUpdate);

Unit23.Lng_Memory := FileLng.ReadString('Form23','Lng_Memory',Unit23.Lng_Memory);
Unit23.Lng_TotalMemory := FileLng.ReadString('Form23','Lng_TotalMemory',Unit23.Lng_TotalMemory);
Unit23.Lng_UsedMemory := FileLng.ReadString('Form23','Lng_UsedMemory',Unit23.Lng_UsedMemory);

Unit23.Lng_UsedCpu := FileLng.ReadString('Form23','Lng_UsedCpu',Unit23.Lng_UsedCpu);
Form24.Label1.caption := FileLng.ReadString('Form24','Label1',Form24.Label1.caption);
Form24.Label2.caption := FileLng.ReadString('Form24','Label2',Form24.Label2.caption);
Form24.Label3.caption := FileLng.ReadString('Form24','Label3',Form24.Label3.caption);
Form24.Edit1.Text := FileLng.ReadString('Form24','Edit1',Form24.Edit1.Text);
Form24.Button1.caption := FileLng.ReadString('Form24','Button1',Form24.Button1.caption);
Form24.Button2.caption := FileLng.ReadString('Form24','Button2',Form24.Button2.caption);
Form24.SpeedButton1.caption := FileLng.ReadString('Form24','SpeedButton1',Form24.SpeedButton1.caption);
Form24.SpeedButton2.caption := FileLng.ReadString('Form24','SpeedButton2',Form24.SpeedButton2.caption);
Form24.SpeedButton3.caption := FileLng.ReadString('Form24','SpeedButton3',Form24.SpeedButton3.caption);
Form24.SpeedButton4.caption := FileLng.ReadString('Form24','SpeedButton4',Form24.SpeedButton4.caption);
Form24.SpeedButton5.caption := FileLng.ReadString('Form24','SpeedButton5',Form24.SpeedButton5.caption);
Form24.SpeedButton6.caption := FileLng.ReadString('Form24','SpeedButton6',Form24.SpeedButton6.caption);
Form24.SpeedButton7.caption := FileLng.ReadString('Form24','SpeedButton7',Form24.SpeedButton7.caption);
Form24.SpeedButton8.caption := FileLng.ReadString('Form24','SpeedButton8',Form24.SpeedButton8.caption);
Form24.SpeedButton9.caption := FileLng.ReadString('Form24','SpeedButton9',Form24.SpeedButton9.caption);
Form24.SpeedButton10.caption := FileLng.ReadString('Form24','SpeedButton10',Form24.SpeedButton10.caption);
Form24.SpeedButton11.caption := FileLng.ReadString('Form24','SpeedButton11',Form24.SpeedButton11.caption);
Form24.SpeedButton12.caption := FileLng.ReadString('Form24','SpeedButton12',Form24.SpeedButton12.caption);
Form24.SpeedButton13.caption := FileLng.ReadString('Form24','SpeedButton13',Form24.SpeedButton13.caption);
Form24.SpeedButton14.caption := FileLng.ReadString('Form24','SpeedButton14',Form24.SpeedButton14.caption);
Form24.SpeedButton15.caption := FileLng.ReadString('Form24','SpeedButton15',Form24.SpeedButton15.caption);
Form24.SpeedButton16.caption := FileLng.ReadString('Form24','SpeedButton16',Form24.SpeedButton16.caption);
Form24.SpeedButton17.caption := FileLng.ReadString('Form24','SpeedButton17',Form24.SpeedButton17.caption);
Form24.SpeedButton18.caption := FileLng.ReadString('Form24','SpeedButton18',Form24.SpeedButton18.caption);
Form26.Button1.caption := FileLng.ReadString('Form26','Button1',Form26.Button1.caption);
Form26.Button2.caption := FileLng.ReadString('Form26','Button2',Form26.Button2.caption);
Form26.Button3.caption := FileLng.ReadString('Form26','Button3',Form26.Button3.caption);
Form26.Label1.Caption := FileLng.ReadString('Form26','Label1',Form26.Label1.caption);
Form26.Label2.Caption := FileLng.ReadString('Form26','Label2',Form26.Label2.caption);
Form27.Label1.caption := FileLng.ReadString('Form27','Label1',Form27.Label1.caption);
Form27.Label2.caption := FileLng.ReadString('Form27','Label2',Form27.Label2.caption);
Form27.Label3.caption := FileLng.ReadString('Form27','Label3',Form27.Label3.caption);
Form27.Label4.caption := FileLng.ReadString('Form27','Label4',Form27.Label4.caption);
Form27.Label5.caption := FileLng.ReadString('Form27','Label5',Form27.Label5.caption);
Form27.Label6.caption := FileLng.ReadString('Form27','Label6',Form27.Label6.caption);
Form27.Button1.caption := FileLng.ReadString('Form27','Button1',Form27.Button1.caption);
Form27.Button2.caption := FileLng.ReadString('Form27','Button2',Form27.Button2.caption);
Form27.SpeedButton1.caption := FileLng.ReadString('Form27','SpeedButton1',Form27.SpeedButton1.caption);
Form27.SpeedButton2.caption := FileLng.ReadString('Form27','SpeedButton2',Form27.SpeedButton2.caption);
Form27.SpeedButton3.caption := FileLng.ReadString('Form27','SpeedButton3',Form27.SpeedButton3.caption);
if Application.FindComponent('Form28') <> nil
then begin
     Form28.Label1.caption := FileLng.ReadString('Form28','Label1',Form28.Label1.caption);
     Form28.Label2.caption := FileLng.ReadString('Form28','Label2',Form28.Label2.caption);
     Form28.Button1.caption := FileLng.ReadString('Form28','Button1',Form28.Button1.caption);
     Form28.Button2.caption := FileLng.ReadString('Form28','Button2',Form28.Button2.caption);
     Form28.SpeedButton1.caption := FileLng.ReadString('Form28','SpeedButton1',Form28.SpeedButton1.caption);
     Form28.SpeedButton2.caption := FileLng.ReadString('Form28','SpeedButton2',Form28.SpeedButton2.caption);
     Form28.SpeedButton3.caption := FileLng.ReadString('Form28','SpeedButton3',Form28.SpeedButton3.caption);
     end;
Form29.Label1.caption := FileLng.ReadString('Form29','Label1',Form29.Label1.caption);
Form30.Label1.caption := FileLng.ReadString('Form30','Label1',Form30.Label1.caption);
Form30.Label2.caption := FileLng.ReadString('Form30','Label2',Form30.Label2.caption);
Form30.Label3.caption := FileLng.ReadString('Form30','Label3',Form30.Label3.caption);
Form30.Label4.caption := FileLng.ReadString('Form30','Label4',Form30.Label4.caption);
Form30.Label5.caption := FileLng.ReadString('Form30','Label5',Form30.Label5.caption);
Form30.Label6.caption := FileLng.ReadString('Form30','Label6',Form30.Label6.caption);
Form30.Label7.caption := FileLng.ReadString('Form30','Label7',Form30.Label7.caption);
Form30.Label8.caption := FileLng.ReadString('Form30','Label8',Form30.Label8.caption);
Form30.Label9.caption := FileLng.ReadString('Form30','Label9',Form30.Label9.caption);
Form30.Label10.caption := FileLng.ReadString('Form30','Label10',Form30.Label10.caption);
Form30.Label11.caption := FileLng.ReadString('Form30','Label11',Form30.Label11.caption);
Form30.Label12.caption := FileLng.ReadString('Form30','Label12',Form30.Label12.caption);
Form30.Label13.caption := FileLng.ReadString('Form30','Label13',Form30.Label13.caption);
Form30.Label14.caption := FileLng.ReadString('Form30','Label14',Form30.Label14.caption);
Form30.Label15.caption := FileLng.ReadString('Form30','Label15',Form30.Label15.caption);
Form30.Label16.caption := FileLng.ReadString('Form30','Label16',Form30.Label16.caption);
Form30.Label17.caption := FileLng.ReadString('Form30','Label17',Form30.Label17.caption);
Form30.Label18.caption := FileLng.ReadString('Form30','Label18',Form30.Label18.caption);
Form30.Label19.caption := FileLng.ReadString('Form30','Label19',Form30.Label19.caption);
Form30.Label20.caption := FileLng.ReadString('Form30','Label20',Form30.Label20.caption);
Form30.Label21.caption := FileLng.ReadString('Form30','Label21',Form30.Label21.caption);
Form30.Label22.caption := FileLng.ReadString('Form30','Label22',Form30.Label22.caption);
Form30.Label23.caption := FileLng.ReadString('Form30','Label23',Form30.Label23.caption);
Form30.Label24.caption := FileLng.ReadString('Form30','Label24',Form30.Label24.caption);
Form30.Edit1.Text := FileLng.ReadString('Form30','Edit1',Form30.Edit1.Text);
Form30.BitBtn1.Caption := FileLng.ReadString('Form30','BitBtn1',Form30.Bitbtn1.Caption);
Form30.Button1.caption := FileLng.ReadString('Form30','Button1',Form30.Button1.caption);
Form30.Button2.caption := FileLng.ReadString('Form30','Button2',Form30.Button2.caption);
Form30.Button3.caption := FileLng.ReadString('Form30','Button3',Form30.Button3.caption);
Form30.Button4.caption := FileLng.ReadString('Form30','Button4',Form30.Button4.caption);
Form30.Button5.caption := FileLng.ReadString('Form30','Button5',Form30.Button5.caption);
Form32.Label1.caption := FileLng.ReadString('Form32','Label1',Form32.Label1.caption);
Form32.Edit1.Text := FileLng.ReadString('Form32','Edit1',Form32.Edit1.Text);
Form32.Button1.caption := FileLng.ReadString('Form32','Button1',Form32.Button1.caption);
Form32.Button2.caption := FileLng.ReadString('Form32','Button2',Form32.Button2.caption);

Form19.CheckBox1.caption := FileLng.ReadString('Form19','CheckBox1',Form19.CheckBox1.caption);
Form19.CheckBox2.caption := FileLng.ReadString('Form19','CheckBox2',Form19.CheckBox2.caption);
Form19.CheckBox3.caption := FileLng.ReadString('Form19','CheckBox3',Form19.CheckBox3.caption);
Form19.CheckBox4.caption := FileLng.ReadString('Form19','CheckBox4',Form19.CheckBox4.caption);
Form19.CheckBox5.caption := FileLng.ReadString('Form19','CheckBox5',Form19.CheckBox5.caption);
Form19.CheckBox6.caption := FileLng.ReadString('Form19','CheckBox6',Form19.CheckBox6.caption);
Form19.CheckBox7.caption := FileLng.ReadString('Form19','CheckBox7',Form19.CheckBox7.caption);
Form19.CheckBox8.caption := FileLng.ReadString('Form19','CheckBox8',Form19.CheckBox8.caption);
Form19.RadioButton1.caption := FileLng.ReadString('Form19','RadioButton1',Form19.RadioButton1.caption);
Form19.RadioButton2.caption := FileLng.ReadString('Form19','RadioButton2',Form19.RadioButton2.caption);

// Debug
unit1.Dbg_NoError := FileLng.ReadString('Debug','Dbg_NoError',Unit1.Dbg_NoError);
form1.StatusBar1.Refresh; // pour changement du symbole dans de langue;

FileLng.Free;
end;

end.
