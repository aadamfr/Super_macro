object Form33: TForm33
  Left = 313
  Top = 284
  HelpContext = 1171
  Caption = 'Ajout de fichiers suppl'#232'mentaires'
  ClientHeight = 344
  ClientWidth = 557
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    557
    344)
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 557
    Height = 57
    Align = alTop
    TabOrder = 0
    DesignSize = (
      557
      57)
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 555
      Height = 55
      Align = alClient
      Stretch = True
      ExplicitWidth = 641
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 531
      Height = 39
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = 
        'Cette assistant vous permet d'#39'ajouter des fichiers suppl'#233'mentair' +
        'es a l'#39'ex'#233'cutable. Vous trouverez ci-dessous les fichiers utilis' +
        #233's dans votre macro. Au cas, o'#249' d'#39'autres fichiers utilis'#233's n'#39'ont' +
        ' pas '#233't'#233' trouv'#233's, vous pouvez toujours les ajouter manuellement.'
      Transparent = True
      WordWrap = True
    end
  end
  object ListView1: TListView
    Tag = 999
    Left = 0
    Top = 57
    Width = 557
    Height = 237
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = 'Fichier'
      end>
    ReadOnly = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object Button1: TButton
    Left = 8
    Top = 305
    Width = 97
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Tout s'#233'l'#233'ctionner'
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 112
    Top = 305
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Ajouter'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 389
    Top = 305
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Valider'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 470
    Top = 305
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Annuler'
    TabOrder = 5
    OnClick = Button4Click
  end
  object OpenDialog1: TOpenDialog
    Left = 16
    Top = 200
  end
end
