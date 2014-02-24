program super_macro;
{%TogetherDiagram 'ModelSupport_super_macro\default.txaPackage'}

uses
  Forms,
  windows,
  Unit1 in 'Unit1.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4},
  Unit5 in 'Unit5.pas' {Form5},
  Unit6 in 'Unit6.pas' {Form6},
  Unit7 in 'Unit7.pas' {Form7},
  Unit8 in 'Unit8.pas' {Form8},
  Unit9 in 'Unit9.pas' {Form9},
  Unit10 in 'Unit10.pas' {Form10},
  Unit11 in 'Unit11.pas' {Form11},
  Unit12 in 'Unit12.pas' {Form12},
  Unit13 in 'Unit13.pas' {Form13},
  Unit14 in 'Unit14.pas' {Form14},
  Unit15 in 'Unit15.pas' {Form15},
  Unit16 in 'Unit16.pas' {Form16},
  Unit17 in 'Unit17.pas' {Form17},
  Unit18 in 'Unit18.pas' {Form18},
  Unit19 in 'Unit19.pas' {Form19},
  Unit21 in 'Unit21.pas' {Form21},
  Unit22 in 'Unit22.pas' {Form22},
  Unit23 in 'Unit23.pas' {Form23},
  Unit24 in 'Unit24.pas' {Form24},
  Unit26 in 'Unit26.pas' {Form26},
  Unit27 in 'Unit27.pas' {Form27},
  Unit28 in 'Unit28.pas' {Form28},
  Unit29 in 'Unit29.pas' {Form29},
  Unit30 in 'Unit30.pas' {Form30},
  Unit31 in 'Unit31.pas' {Form31},
  Unit32 in 'Unit32.pas' {Form32},
  Debug in 'Debug.pas',
  ModuleSup in 'ModuleSup.pas',
  adCpuUsage in 'adCpuUsage.pas',
  GestionCommande in 'GestionCommande.pas',
  Unit34 in 'Unit34.pas' {Form34},
  uDebugEx in 'uDebugEx.pas',
  Unit20 in 'Unit20.pas' {Form20},
  ContextOfExecute in 'ContextOfExecute.pas',
  mdlfnct in 'mdlfnct.pas',
  Unit25 in 'Unit25.pas' {Form25},
  Erreurcompil in 'Erreurcompil.pas' {Form35},
  UBackGround in 'UBackGround.pas',
  Unit33 in 'Unit33.pas' {Form33},
  Unit36 in 'Unit36.pas' {Form36},
  CplBrd in 'CplBrd.pas',
  PDH in 'PDH.pas',
  Unit37 in 'Unit37.pas' {Form37},
  VisualEffect in 'VisualEffect.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Super Macro';
  Application.HelpFile := 'C:\super macro\Aide.chm';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TForm12, Form12);
  Application.CreateForm(TForm13, Form13);
  Application.CreateForm(TForm14, Form14);
  Application.CreateForm(TForm15, Form15);
  Application.CreateForm(TForm16, Form16);
  Application.CreateForm(TForm17, Form17);
  Application.CreateForm(TForm18, Form18);
  Application.CreateForm(TForm19, Form19);
  Application.CreateForm(TForm20, Form20);
  Application.CreateForm(TForm21, Form21);
  Application.CreateForm(TForm22, Form22);
  Application.CreateForm(TForm23, Form23);
  Application.CreateForm(TForm24, Form24);
  Application.CreateForm(TForm26, Form26);
  Application.CreateForm(TForm27, Form27);
  Application.CreateForm(TForm29, Form29);
  Application.CreateForm(TForm30, Form30);
  Application.CreateForm(TForm31, Form31);
  Application.CreateForm(TForm32, Form32);
  Application.CreateForm(TForm34, Form34);
  Application.CreateForm(TForm25, Form25);
  Application.CreateForm(TForm35, Form35);
  Application.CreateForm(TForm33, Form33);
  Application.CreateForm(TForm36, Form36);
  Application.CreateForm(TForm37, Form37);
  Form1.InitForm1();

  if MiniFrame = True
  then Application.ShowMainForm := False;


  if (Form1.OpenDialog1.FileName <> '') and (unit1.OpenEdt = False)
  then begin
           //ShowMainForm ne peut être parametre qu'au demarrage.
           Application.ShowMainForm := False;
           Form1.ListView1.Visible := False;
           Application_close := True;
           if Unit1.DirectFromExport = False
           then Form1.Execute1.Click
           else begin
                Form1.Exporterversexecutable1.Click;
                Application.Terminate;
                end;
       end;
  // Test la fin de l'execution de la macro
  If Application.Terminated = False
  Then Application.Run;

end.
