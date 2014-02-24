unit Unit20;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls;

type
  TForm20 = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Label1: TLabel;
    Memo1: TMemo;
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1Click(Sender: TObject);
    procedure ListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form20: TForm20;
  SortIndex : integer = 0;
  SortAssending : Boolean = False;
implementation

uses Unit1, Unit8;

{$R *.dfm}

procedure TForm20.MessageAide(var msg:TMessage);
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
     then ShowMessage('Erreur: Vérifiez la présence du fichier .chm dans le dossier de Super macro.');
     end;
end;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
begin
if SortAssending = False
then Begin
     if SortIndex = 0
     then Result := lstrcmp(PChar(TListItem(Item1).Caption), PChar(TListItem(Item2).Caption))
     else Result := lstrcmp(PChar(TListItem(Item1).SubItems.Strings[SortIndex-1]), PChar(TListItem(Item2).SubItems.Strings[SortIndex-1]));
     end
else begin
     if SortIndex = 0
     then Result := -lstrcmp(PChar(TListItem(Item1).Caption), PChar(TListItem(Item2).Caption))
     else Result := -lstrcmp(PChar(TListItem(Item1).SubItems.Strings[SortIndex-1]), PChar(TListItem(Item2).SubItems.Strings[SortIndex-1]));
     end;
end;

procedure TForm20.ListView1DblClick(Sender: TObject);
var i : integer;
    Exist : Boolean;
begin
if listView1.Selected = nil then exit;
Exist := False;
for i := Low(ListOfSysVar) to High(ListOfSysVar)
do if ListOfSysVar[i].VName = ListView1.Selected.Caption
   then begin Exist := True; break; end;

if Exist
then begin
     Form8.Edit1.Text := ListView1.Selected.Caption;
     if ListOfSysVar[i].VRW = 1
     then Form8.Edit2.Text := ListView1.Selected.Caption
     else if ListOfSysVar[i].VType = 1
          then Form8.Edit2.Text := ''
          else Form8.Edit2.Text := '0';
     Form20.Close;
     end;
end;

procedure TForm20.ListView1Click(Sender: TObject);
var i : integer;
begin
if listView1.Selected = nil then exit;
Memo1.Lines.Clear;
for i := 0 to length(ListOfSysVar)-1
do if ListOfSysVar[i].VName = listView1.Selected.Caption then Memo1.Lines.Add(ListOfSysVar[i].VDescr);

end;

procedure TForm20.ListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var i : integer;
     NewListItem : TListItem;
begin
if Key = VK_F5
then begin
     listView1.Items.Clear;
     Memo1.Lines.Clear;
     Memo1.Lines.Add('Faites un simple clic pour avoir une description de la variable séléctionnée.');
     Memo1.Lines.Add('Faites un double clic pour placer la variable système dans la nouvelle variable.');
     Memo1.Lines.Add('Appuyez sur F5 pour actualiser les valeurs.');
     form8.InitListOfSysVar();
     for i := 0 to length(ListOfSysVar)-1
     do begin
        NewListItem := listView1.Items.Add;
        NewListItem.Caption := ListOfSysVar[i].VName;
        if ListOfSysVar[i].VType = 0
        then NewListItem.SubItems.Add('Num')
        else NewListItem.SubItems.Add(TAlpha);
        NewListItem.SubItems.Add(Inttostr(ListOfSysVar[i].VRW));
        NewListItem.SubItems.Add(ListOfSysVar[i].VValue);
        end;
      end;
     if Key = VK_Escape then Form20.Close;
end;

procedure TForm20.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
begin
SortIndex := Column.Index;
ListView1.CustomSort(@CustomSortProc, 0);
if SortAssending = True
then SortAssending := False
else SortAssending := True;
end;

end.
