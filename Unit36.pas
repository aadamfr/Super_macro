unit Unit36;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm36 = class(TForm)
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    ComboBox1: TComboBox;
    Button1: TButton;
    Button2: TButton;
    SpeedButton1: TSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure Form36Show(Rubrique : string);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure MessageAide  (var msg:TMessage); message WM_HELP;
  public
    { Déclarations publiques }
  end;

var
  Form36: TForm36;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm36.MessageAide(var msg:TMessage);
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

procedure TForm36.Form36Show(Rubrique : string);
begin
if Rubrique = 'Déclaration' then begin radioButton1.Checked := True; ComboBox1.SetFocus; end;
if Rubrique = 'Fin' then begin radioButton2.Checked := True; Button1.SetFocus; end;
if Rubrique = 'Appel' then begin radioButton3.Checked := True; ComboBox1.SetFocus; end;
Application.ProcessMessages;
end;

procedure TForm36.FormShow(Sender: TObject);
var actionType : cardinal;
    procName : String;
    param : string;
    i : integer;
begin
if Form1.ListView1.Selected <> nil
then i := Form1.listview1.Selected.Index
else i := Form1.ListView1.Items.Count-1;

RadioButton2.Enabled := Form1.CanGetEndofProcedure(Form1.ListView1,i,True);

if unit1.sw_modif = true
then begin
     param := form1.listview1.Selected.SubItems.Strings[0];
     procName := '';
     ActionType := 1;
     if copy(param,0,3) = 'END' then ActionType := 2;
     if copy(param,0,5) = 'CALL ' then ActionType := 3;
     if ActionType = 1 then begin RadioButton1.Checked := True; ComboBox1.Text := param; end;
     if ActionType = 2 then begin RadioButton2.Checked := True; ComboBox1.Text := ''; end;
     if ActionType = 3 then begin RadioButton3.Checked := True; ComboBox1.Text := copy(param,6,length(param)); end;
     end
else begin
     ComboBox1.Text := '';
     RadioButton1.Checked := True;
     end;
if (Form36.Visible) and (ComboBox1.Enabled) then ComboBox1.SetFocus;
end;

procedure TForm36.Button1Click(Sender: TObject);
var actionType : String;
    MsgError : string;
begin
     if RadioButton1.Checked then ActionType := ComboBox1.Text;
     if RadioButton2.Checked then ActionType := 'END';
     if RadioButton3.Checked then ActionType := 'CALL '+ ComboBox1.Text;

     MsgError := '';
     if RadioButton1.Checked // test sur nouvelle procédure
     then begin
          if Trim(ComboBox1.Text) = '' then MsgError := 'Veuillez donner un nom à la procédure.';
          if Form1.procedure_exists(Form1.ListView1,ComboBox1.Text) > -1 then MsgError := 'Cette procédure existe déjà.';
          if ComboBox1.Text = 'END' then MsgError := 'Cette procédure ne peut pas s''appeler END.';
          end;
     if RadioButton3.Checked // test sur appel de procédure
     then begin
          if Form1.procedure_exists(Form1.ListView1,ComboBox1.Text) <0 then MsgError := 'La procédure que vous voulez appeler n''existe pas.';
          end;

     if unit1.sw_modif = false
     then begin
          if MsgError <> ''
          then begin ShowMessage(MsgError); ComboBox1.SetFocus; Exit; end
          else form1.add_insert('Procedure',actionType,form1.GetImageIndex('Procedure'))
          end
     else begin
          if MsgError <> ''
          then begin ShowMessage(MsgError); ComboBox1.SetFocus; Exit; end
          else begin
               Form1.ListView1.Selected.SubItems.Strings[0] := actionType;
               Form1.SaveBeforeChange(Form1.ListView1.Selected);
               end;
          end;
     form36.close;
     unit1.sw_modif := false;
end;

procedure TForm36.FormClose(Sender: TObject; var Action: TCloseAction);
begin
unit1.sw_modif := false;
end;

procedure TForm36.Button2Click(Sender: TObject);
begin
Form36.Close;
end;

procedure TForm36.RadioButton3Click(Sender: TObject);
begin
form1.List_procedure(ComboBox1);
ComboBox1.Enabled := True;
ComboBox1.Text := ComboBox1.Items[0];
if Form36.Visible then ComboBox1.SetFocus;
SpeedButton1.Enabled := False;
end;

procedure TForm36.RadioButton2Click(Sender: TObject);
begin
ComboBox1.Clear;
ComboBox1.Enabled := False;
SpeedButton1.Enabled := False;
end;

procedure TForm36.RadioButton1Click(Sender: TObject);
begin
SpeedButton1.Enabled := True;
ComboBox1.Clear;
ComboBox1.Enabled := True;
if Form36.Visible then ComboBox1.SetFocus;
end;

procedure TForm36.SpeedButton1Click(Sender: TObject);
begin
ComboBox1.Clear;
ComboBox1.Items.Add('[EVENT.KEYPRESS]');
ComboBox1.Items.Add('[EVENT.MOUSEDOWN]');
ComboBox1.Items.Add('[EVENT.MOUSEUP]');
ComboBox1.Perform(CB_SHOWDROPDOWN, Integer(True), 0);
end;

end.
