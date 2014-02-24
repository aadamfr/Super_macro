unit Unit13;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TForm13 = class(TForm)
    ComboBox1: TComboBox;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    ListBox2: TListBox;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox2: TComboBox;
    Bevel1: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    function ListBoxGetText(Sender: TObject): String; // donne le Texte S�lectionn� dans un TListBox
    procedure ListBoxSetText(Sender : TObject; Text : String); // S�lectionne le texte dans un TListBox
    procedure ListBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox2Click(Sender: TObject);
    procedure ComboBox1DropDown(Sender: TObject);
  private
    { D�clarations priv�es }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { D�clarations publiques }
  end;

var
  Form13: TForm13;

implementation

uses Unit1;

{$R *.DFM}

procedure TForm13.MessageAide(var msg:TMessage);
var HelpDir : String;
    WinCtrl : TWinControl;
begin
if ActiveControl = nil then Exit;
if ActiveControl.HelpContext = 0
then WinCtrl := ActiveControl.Parent
else WinCtrl := ActiveControl;

if WinCtrl.HelpContext <>0
then begin
     HelpDir := ExtractFileDir(Application.ExeName);
     if HtmlHelp(0, PChar(HelpDir+'\aide.chm'), HH_HELP_CONTEXT,WinCtrl.HelpContext) = 0
     then ShowMessage('Erreur: V�rifiez la pr�sence du fichier .chm dans le dossier de Super macro.');
     end;
end;

function TForm13.ListBoxGetText(Sender: TObject): String; // donne le Texte S�lectionn� dans un TListBox
var i : integer;
begin
if Sender is TListBox
then begin
     for i := 0 to (Sender as TListBox).Items.count -1 do
     begin
     if (Sender as TListBox).Selected[i] = True
     then result := (Sender as TListBox).Items.Strings[i];
     end;
end;
end;
procedure TForm13.ListBoxSetText(Sender : TObject; Text : String); // S�lectionne le texte dans un TListBox
var i : integer;
begin
if Sender is TListBox
then begin
     for i := 0 to (Sender as TListBox).Items.count -1 do
     begin
     if (Sender as TListBox).Items.Strings[i]= Text
     then (Sender as TListBox).ItemIndex := i;
     end;
end;
end;



procedure TForm13.ListBox1Click(Sender: TObject);
var selectionBox1 : string;
begin
if ListBoxGetText(Sender) = 'Date'
then begin
     Form13.HelpContext := HelpVarSysDate;
     ListBox2.Clear;
     ListBox2.Items.Add('JJ/MM/AAAA');
     ListBox2.Items.Add('JJMMAAAA');
     ListBox2.Items.Add('AAAAMMJJ');
     ListBox2.Items.Add('Jour');
     ListBox2.Items.Add('Mois');
     ListBox2.Items.Add('Ann�e');
     end;
if ListBoxGetText(Sender) = 'Heure'
then begin
     Form13.HelpContext := HelpVarSysHeure;
     ListBox2.Clear;
     ListBox2.Items.Add('HH:MM:SS');
     ListBox2.Items.Add('HHMMSS');
     ListBox2.Items.Add('Heure');
     ListBox2.Items.Add('Minute');
     ListBox2.Items.Add('Seconde');
     end;
if ListBoxGetText(Sender) = 'Clipboard'
then begin
     Form13.HelpContext := HelpVarSysClipboard;
     ListBox2.Clear;
     ListBox2.Items.Add('Texte');
     ListBox2.Items.Add('Format');
     end;

if ListBoxGetText(Sender) = 'Texte'
then begin
     Form13.HelpContext := HelpVarSysTexte;
     ListBox2.Clear;
     ListBox2.Items.Add('Longueur');
     ListBox2.Items.Add('Caract�re(s)/Position(s)');
     ListBox2.Items.Add('Caract�re(s)/Longueur');
     ListBox2.Items.Add('Majuscule');
     ListBox2.Items.Add('Minuscule');
     ListBox2.Items.Add('Remplace');
     ListBox2.Items.Add('Trouver');
     ListBox2.Items.Add('Explode');
     end;
if ListBoxGetText(Sender) = 'Curseur'
then begin
     Form13.HelpContext := HelpVarSysCurseur;
     ListBox2.Clear;
     ListBox2.Items.Add('Position X');
     ListBox2.Items.Add('Position Y');
     end;
if ListBoxGetText(Sender) = 'Handle'
then begin
     Form13.HelpContext := HelpVarSysHandle;
     ListBox2.Clear;
     ListBox2.Items.Add('Texte');
     ListBox2.Items.Add('Longueur');
     ListBox2.Items.Add('Largeur');
     ListBox2.Items.Add('Position X');
     ListBox2.Items.Add('Position Y');
     ListBox2.Items.Add('Etat');
     end;
if ListBoxGetText(Sender) = 'Hasard'
then begin
     Form13.HelpContext := HelpVarSysHazard;
     ListBox2.Clear;
     ListBox2.Items.Add('Nombre');
     ListBox2.Items.Add('Lettre');
     end;
if ListBoxGetText(Sender) = 'Fichier'
then begin
     Form13.HelpContext := HelpVarSysFichier;
     ListBox2.Clear;
     ListBox2.Items.Add('Existe');
     ListBox2.Items.Add('Extrait nom de fichier');
     ListBox2.Items.Add('Extrait r�pertoire');
     ListBox2.Items.Add('Extrait extension');
     ListBox2.Items.Add('Nombre d''enregistrement');
     ListBox2.Items.Add('Taille octets');
     ListBox2.Items.Add('Date Cr�ation Fichier');
     ListBox2.Items.Add('Date Modification Fichier');
     ListBox2.Items.Add('Date Acc�s Fichier');
     ListBox2.Items.Add('en lecture seule?');
     ListBox2.Items.Add('cach�?');
     ListBox2.Items.Add('syst�me?');
     ListBox2.Items.Add('d''identification de volume?');
     ListBox2.Items.Add('r�pertoire?');
     ListBox2.Items.Add('archive?');
     end;

if ListBoxGetText(Sender) = 'Nombre'
then begin
     Form13.HelpContext := 0;
     ListBox2.Clear;
     ListBox2.Items.Add('Abs');
     ListBox2.Items.Add('Cos');
     ListBox2.Items.Add('Cotang');
     ListBox2.Items.Add('D�cimales');
     ListBox2.Items.Add('Mon�taire');
     ListBox2.Items.Add('Tang');
     ListBox2.Items.Add('Tronc');
     ListBox2.Items.Add('Sin');
     end;

if ListBoxGetText(Sender) = 'R�pertoire syst�me'
then begin
     Form13.HelpContext := HelpVarSysRepertoire;
     ListBox2.Clear;
     ListBox2.Items.Add('Rep Maison');
     ListBox2.Items.Add('Rep Fichier prog');
     ListBox2.Items.Add('Rep Temporaire');
     ListBox2.Items.Add('Rep Windows');
     ListBox2.Items.Add('Rep Super Macro');
     ListBox2.Items.Add('Rep Fichier Macro');
     end;
if ListBoxGetText(Sender) = 'Ecran'
then begin
     Form13.HelpContext := HelpVarSysEcran;
     ListBox2.Clear;
     ListBox2.Items.Add('Longueur');
     ListBox2.Items.Add('Largeur');
     end;

if ListBoxGetText(Sender) = 'Param�tre d''ex�cution'
then begin
     Form13.HelpContext := HelpGeneral;
     ListBox2.Clear;
     ListBox2.Items.Add('Param�tre n�');
     ListBox2.Items.Add('Nombre de param�tre');
     end;

if ListBoxGetText(Sender) = 'Disque'
then begin
     Form13.HelpContext := HelpVarSysEcran;
     ListBox2.Clear;
     ListBox2.Items.Add('Type de disque');
     ListBox2.Items.Add('Taille Totale');
     ListBox2.Items.Add('Taille Disponible');
     end;


SelectionBox1 := ListBoxGetText(ListBox1);

if ((SelectionBox1 = 'Fichier') or (SelectionBox1 = 'Texte')) then form1.list_var(ComboBox2.Items, True, True);
if SelectionBox1 = 'Handle' then form1.list_var_and_objet(ComboBox2);
if ListBox2.SelCount = -1 then ListBox2.Selected[0] := True;
ListBox2.OnClick(self);

end;

procedure TForm13.FormShow(Sender: TObject);
var listParam : Tparam;
    param : string;
    i : integer;
begin
Form1.List_Var(Form13.ComboBox1.Items, True, True);
if unit1.sw_modif
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     listParam := form1.GetParam(param);
     ComboBox1.Text := listParam.Param[1];
     ListBoxSetText(ListBox1,listParam.Param[2]);
     ListBox1click(ListBox1);
     ListBoxSetText(ListBox2,listParam.Param[3]);
     ListBox2click(ListBox2);
     ComboBox2.Text := '';
     for i := 4 to ListParam.nbr_param-1
     do if i = ListParam.nbr_param-1
        then ComboBox2.Text := ComboBox2.Text+listParam.Param[i]
        else ComboBox2.Text := ComboBox2.Text+listParam.Param[i] + SprPr;
     end
else begin
     ComboBox1.Text := '';
     ListBox2.Clear;
     ComboBox2.Text := '';
     ListBox2.Items.Add('JJ/MM/AAAA');
     ListBox2.Items.Add('JJMMAAAA');
     ListBox2.Items.Add('AAAAMMJJ');
     ListBox2.Items.Add('Jour');
     ListBox2.Items.Add('Mois');
     ListBox2.Items.Add('Ann�e');
     ComboBox2.enabled := False;
     label4.Enabled := False;
     ListBoxSetText(ListBox1,'Date');
     ListBox1click(ListBox1);
     ListBoxSetText(ListBox2,'JJ/MM/AAAA');
     ComboBox2.Text := '';
     end;
end;

procedure TForm13.Button2Click(Sender: TObject);
begin
Form13.Close;
end;

procedure TForm13.Button1Click(Sender: TObject);
var Param : String;
    ListParam : TParam;
    Category,Fonction : string;
begin
if ((ListBoxGetText(ListBox2) <> '') and (ComboBox1.Text <> ''))
then begin
     Category := ListBoxGetText(ListBox1);
     Fonction := ListBoxGetText(ListBox2);
     Param := ComboBox1.Text+ SprPr +  Category + SprPr +  Fonction + SprPr + ComboBox2.Text;
     if Param[length(Param)]<> SprPr
     then Param := Param+SprPr;
     ListParam := Form1.GetParam(Param);
     if (Category = 'Texte') and (Fonction = 'Caract�re(s)/Position(s)')
     then begin
          if ListParam.nbr_param <> 7
          then begin
               MessageBox(Form13.Handle,Pchar('Veuillez s�lectionner les param�tres suivant: Text, position de d�part, position de fin entrecoup� du caract�re "'+SprPr+'".'),'Information',MB_OK or MB_TOPMOST);
               exit;
               end;
          end;
     if (Category = 'Texte') and (Fonction = 'Caract�re(s)/Longueur')
     then begin
          if ListParam.nbr_param <> 7
          then begin
               MessageBox(Form13.Handle,Pchar('Veuillez s�lectionner les param�tres suivant: Text, position de d�part, nombre de caract�re "'+SprPr+'".'),'Information',MB_OK or MB_TOPMOST);
               exit;
               end;
          end;

     if (Category = 'Texte') and (Fonction = 'Longueur')
     then if ListParam.nbr_param <> 5
          then begin
               MessageBox(Form13.Handle,Pchar('Veuillez s�lectionner dans les param�tres uniquement le texte a traiter.'),'Information.',MB_OK or MB_TOPMOST);
               exit;
               end;

     if unit1.sw_modif = false
     then form1.add_insert('Fonction',Param,13)
     else begin
          Form1.ListView1.Selected.SubItems.Strings[0] := Param;
          Form1.SaveBeforeChange(Form1.ListView1.Selected);
          end;

     Form13.Close;
     end;
end;

procedure TForm13.FormClose(Sender: TObject; var Action: TCloseAction);
begin
KeyPreview := False;
ComboBox1.Text := '';
ListBoxSetText(ListBox1,'Date');
ListBoxSetText(ListBox2,'HH:MM:SS');
unit1.sw_modif := False;
ComboBox2.enabled := False;
label4.Enabled := False;
end;

procedure TForm13.ListBox2Click(Sender: TObject);
var SelectionBox1, SelectionBox2 : String;
begin
// remplissage des info;
SelectionBox1 := ListBoxGetText(ListBox1);
SelectionBox2 := ListBoxGetText(ListBox2);
label6.caption := 'Aucune';
if (SelectionBox1 = 'Date')
then label6.Caption := 'Si vous souhaitez avoir la date d''hier inserez la valeur -1 dans la cellule param�tre, pour demain inserez 1, etc... ';
if ((SelectionBox1 = 'Hasard') and (SelectionBox2 = 'Nombre'))
then begin
     label6.caption := 'Entrez la valeur maximale souhait�e.';
     form1.list_var(ComboBox2.Items, False, True);
     end;
if SelectionBox1 = 'Fichier' 
then label6.caption := 'Entrez le nom de fichier complet avec son chemin.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Longueur'))
then label6.caption := 'Entrez votre texte ou sp�cifiez une variable.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Caract�re(s)/Position(s)'))
then label6.caption := 'Inserez le texte ou la variable + ' + SprPr + ' + Position d�part + ' + SprPr + ' + Position Fin.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Caract�re(s)/Longueur'))
then label6.caption := 'Inserez le texte ou la variable + ' + SprPr + ' + Position d�part + ' + SprPr + ' + Nombre de caract�re.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Majuscule'))
then label6.caption := 'Inserez le texte ou la variable � convertir en majuscule.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Minuscule'))
then label6.caption := 'Inserez le texte ou la variable � convertir en minuscule.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Remplace'))
then label6.caption := 'Inserez le texte recherch� + '+SprPr+' + le texte de remplacement.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Trouver'))
then label6.caption := 'Inserez le texte + '+SprPr+' + puis le texte recherch�.';
if ((SelectionBox1 = 'Texte') and (SelectionBox2 = 'Explode'))
then label6.caption := 'Inserez le texte + '+SprPr+' + puis le caract�re de s�paration +'+SprPr+' + Index';

if ((SelectionBox1 = 'Param�tre d''ex�cution') and (SelectionBox2 = 'Param�tre n�'))
then begin label6.caption := 'Inserez la position du param�tre voulu.'; form1.list_var(ComboBox2.Items, False, True); end;
if (SelectionBox1 = 'Disque')
then begin
     label6.caption := 'Entrez la lettre du lecteur.';
     form1.list_var(ComboBox2.Items, True, False);
     if Copy(SelectionBox2,1,6) = 'Taille' then Label6.Caption := Label6.Caption + ' La valeur de retour est en Mega octets.';
     end;


if (SelectionBox1 = 'Clipboard')
then if SelectionBox2 = 'Format'
     then begin
          Label6.Caption := 'Retourne le format du presse-papier. Valeur possible 1(Format Texte), 2(Bitmap), 3(Fichier), 4(Picture), 5(Autre).'
          end;

if (SelectionBox1 = 'Handle')
then begin
     label6.caption := 'Entrez le numero du handle ou sp�cifiez une variable.';
     if SelectionBox2 = 'Etat' then label6.caption := label6.caption + chr(VK_RETURN) + 'Normal' +
                                                                       chr(VK_RETURN) +'R�duit' +
                                                                       chr(VK_RETURN) + 'Agrandi'+
                                                                       chr(VK_RETURN) + 'Ind�termin�';
     end;
if label6.caption <> 'Aucune'
then begin ComboBox2.enabled := True; label4.Enabled := True; end
else begin ComboBox2.enabled := False; label4.Enabled := False; ComboBox2.text := ''end;

end;

procedure TForm13.ComboBox1DropDown(Sender: TObject);
var SaveText : String;
begin
SaveText := ComboBox1.Text;
Form1.List_Var(ComboBox1.Items, True, True);
ComboBox1.Text := SaveText;
end;

end.
