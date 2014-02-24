object Form30: TForm30
  Left = 259
  Top = 57
  HelpContext = 1124
  Caption = 'D'#233'finition de champs'
  ClientHeight = 650
  ClientWidth = 813
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel3: TBevel
    Left = 336
    Top = 112
    Width = 449
    Height = 76
  end
  object Bevel1: TBevel
    Left = 16
    Top = 112
    Width = 297
    Height = 73
  end
  object Label1: TLabel
    Left = 16
    Top = 96
    Width = 69
    Height = 13
    Caption = 'S'#233'parateurs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Bevel2: TBevel
    Left = 16
    Top = 208
    Width = 793
    Height = 289
  end
  object Label2: TLabel
    Left = 16
    Top = 192
    Width = 117
    Height = 13
    Caption = 'Aper'#231'u des donn'#233'es'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label3: TLabel
    Left = 248
    Top = 509
    Width = 85
    Height = 13
    Caption = 'Nom du champ'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label4: TLabel
    Left = 432
    Top = 509
    Width = 26
    Height = 13
    Caption = 'Bloc'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label5: TLabel
    Left = 16
    Top = 509
    Width = 85
    Height = 13
    Caption = 'Nom du champ'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label6: TLabel
    Left = 336
    Top = 96
    Width = 151
    Height = 13
    Caption = 'Information de la s'#233'l'#233'ction'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 344
    Top = 136
    Width = 63
    Height = 13
    Caption = 'Position Fin : '
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label9: TLabel
    Left = 344
    Top = 168
    Width = 45
    Height = 13
    Caption = 'Curseur : '
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label10: TLabel
    Left = 440
    Top = 120
    Width = 6
    Height = 13
    Caption = '1'
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label11: TLabel
    Left = 440
    Top = 136
    Width = 6
    Height = 13
    Caption = '1'
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label12: TLabel
    Left = 440
    Top = 168
    Width = 6
    Height = 13
    Caption = '1'
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 208
    Top = 16
    Width = 95
    Height = 13
    Caption = 'Variable '#224' traiter'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 528
    Top = 509
    Width = 67
    Height = 13
    Caption = 'Position Fin'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
    Visible = False
  end
  object Bevel4: TBevel
    Left = 16
    Top = 32
    Width = 177
    Height = 57
  end
  object Label15: TLabel
    Left = 16
    Top = 16
    Width = 93
    Height = 13
    Caption = 'Type de donn'#233'e'
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
    Transparent = True
  end
  object Label16: TLabel
    Left = 344
    Top = 152
    Width = 27
    Height = 13
    Caption = 'Bloc :'
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label17: TLabel
    Left = 440
    Top = 152
    Width = 6
    Height = 13
    Caption = '1'
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label7: TLabel
    Left = 344
    Top = 120
    Width = 81
    Height = 13
    Caption = 'Position Depart : '
    Color = clSilver
    ParentColor = False
    Transparent = True
  end
  object Label18: TLabel
    Left = 40
    Top = 48
    Width = 40
    Height = 13
    Cursor = crHandPoint
    Caption = ' D'#233'limit'#233
    Transparent = True
    OnClick = Label18Click
  end
  object Label19: TLabel
    Left = 40
    Top = 64
    Width = 67
    Height = 13
    Cursor = crHandPoint
    Caption = ' Longueur fixe'
    Transparent = True
    OnClick = Label19Click
  end
  object Label20: TLabel
    Left = 48
    Top = 130
    Width = 53
    Height = 13
    Cursor = crHandPoint
    Caption = ' Tabulation'
    Transparent = True
    OnClick = Label20Click
  end
  object Label21: TLabel
    Left = 48
    Top = 154
    Width = 39
    Height = 13
    Cursor = crHandPoint
    Caption = ' Espace'
    Transparent = True
    OnClick = Label21Click
  end
  object Label22: TLabel
    Left = 152
    Top = 130
    Width = 58
    Height = 13
    Cursor = crHandPoint
    Caption = 'Point virgule'
    Transparent = True
    OnClick = Label22Click
  end
  object Label23: TLabel
    Left = 152
    Top = 154
    Width = 34
    Height = 13
    Cursor = crHandPoint
    Caption = ' Autre :'
    Transparent = True
    OnClick = Label23Click
  end
  object Label24: TLabel
    Left = 256
    Top = 130
    Width = 35
    Height = 13
    Cursor = crHandPoint
    Caption = ' Virgule'
    Transparent = True
    OnClick = Label24Click
  end
  object BitBtn1: TBitBtn
    Left = 208
    Top = 64
    Width = 113
    Height = 25
    Caption = 'Ouvrir un fichier'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object StringGrid1: TStringGrid
    Left = 24
    Top = 216
    Width = 777
    Height = 273
    Hint = 
      'Pour obtenir un aper'#231'u des donn'#233'es, vous devez ouvrir un fichier' +
      '.'
    ColCount = 1
    DefaultColWidth = 12
    DefaultRowHeight = 14
    FixedColor = clWindowText
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    GridLineWidth = 0
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = StringGrid1Click
    OnDblClick = StringGrid1DblClick
    OnDrawCell = StringGrid1DrawCell
  end
  object CheckBox1: TCheckBox
    Left = 32
    Top = 128
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Color = clBtnFace
    ParentColor = False
    TabOrder = 2
    OnClick = CheckBox1Click
  end
  object CheckBox2: TCheckBox
    Left = 32
    Top = 152
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Color = clBtnFace
    ParentColor = False
    TabOrder = 3
    OnClick = CheckBox2Click
  end
  object CheckBox3: TCheckBox
    Left = 136
    Top = 128
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Color = clBtnFace
    ParentColor = False
    TabOrder = 4
    OnClick = CheckBox3Click
  end
  object CheckBox4: TCheckBox
    Left = 240
    Top = 128
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Color = clBtnFace
    ParentColor = False
    TabOrder = 5
    OnClick = CheckBox4Click
  end
  object CheckBox5: TCheckBox
    Left = 136
    Top = 152
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Color = clBtnFace
    ParentColor = False
    TabOrder = 6
    OnClick = CheckBox5Click
  end
  object Edit1: TEdit
    Left = 192
    Top = 152
    Width = 25
    Height = 21
    MaxLength = 1
    TabOrder = 7
    OnKeyPress = Edit1KeyPress
    OnKeyUp = Edit1KeyUp
  end
  object Button1: TButton
    Left = 737
    Top = 588
    Width = 75
    Height = 25
    Caption = 'Fermer'
    TabOrder = 8
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 641
    Top = 588
    Width = 75
    Height = 25
    Caption = 'Valider'
    TabOrder = 9
    OnClick = Button2Click
  end
  object ListBox1: TListBox
    Left = 248
    Top = 524
    Width = 185
    Height = 89
    ItemHeight = 13
    TabOrder = 10
    OnClick = ListBox1Click
    OnEnter = ListBox1Enter
    OnExit = ListBox1Exit
    OnKeyUp = ListBox1KeyUp
  end
  object ListBox2: TListBox
    Left = 432
    Top = 524
    Width = 97
    Height = 89
    ItemHeight = 13
    TabOrder = 11
    OnClick = ListBox2Click
    OnEnter = ListBox1Enter
    OnExit = ListBox1Exit
    OnKeyUp = ListBox2KeyUp
  end
  object Button3: TButton
    Left = 152
    Top = 524
    Width = 75
    Height = 25
    Caption = 'Ajouter'
    Enabled = False
    TabOrder = 12
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 152
    Top = 557
    Width = 75
    Height = 25
    Caption = 'Modifier'
    Enabled = False
    TabOrder = 13
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 152
    Top = 588
    Width = 75
    Height = 25
    Caption = 'Supprimer'
    Enabled = False
    TabOrder = 14
    OnClick = Button5Click
  end
  object ListBox3: TListBox
    Left = 528
    Top = 524
    Width = 89
    Height = 89
    ItemHeight = 13
    TabOrder = 15
    Visible = False
    OnClick = ListBox3Click
    OnEnter = ListBox1Enter
    OnExit = ListBox1Exit
    OnKeyUp = ListBox3KeyUp
  end
  object ComboBox1: TComboBox
    Left = 208
    Top = 32
    Width = 185
    Height = 21
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 16
    OnDropDown = ComboBox1DropDown
  end
  object ComboBox2: TComboBox
    Left = 16
    Top = 524
    Width = 129
    Height = 21
    ItemHeight = 13
    TabOrder = 17
    OnChange = ComboBox2Change
    OnDropDown = ComboBox2DropDown
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 631
    Width = 813
    Height = 19
    Panels = <>
  end
  object RadioButton1: TRadioButton
    Left = 24
    Top = 48
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Checked = True
    Color = clBtnFace
    ParentColor = False
    TabOrder = 19
    TabStop = True
    OnClick = RadioButton1Click
  end
  object RadioButton2: TRadioButton
    Left = 24
    Top = 64
    Width = 14
    Height = 14
    Cursor = crHandPoint
    Color = clBtnFace
    ParentColor = False
    TabOrder = 20
    OnClick = RadioButton2Click
  end
  object OpenDialog1: TOpenDialog
    Left = 320
    Top = 64
  end
end
