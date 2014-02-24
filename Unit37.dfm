object Form37: TForm37
  Left = 335
  Top = 263
  HelpContext = 1172
  Caption = 'OtherLanguageEditor'
  ClientHeight = 355
  ClientWidth = 371
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 371
    Height = 49
    Align = alTop
    ExplicitWidth = 379
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 277
    Height = 13
    Caption = 'S'#233'lectionnez le langage souhait'#233' parmis la liste ci-dessous.'
    Transparent = True
  end
  object ListBox1: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 52
    Width = 365
    Height = 248
    Align = alClient
    ItemHeight = 13
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 303
    Width = 371
    Height = 52
    Align = alBottom
    TabOrder = 1
    object Button1: TButton
      Left = 168
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Valider'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 272
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Annuler'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
end
