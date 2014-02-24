object Form22: TForm22
  Left = 284
  Top = 176
  HelpContext = 1125
  Caption = 'Trouve image'
  ClientHeight = 550
  ClientWidth = 751
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnDeactivate = FormDeactivate
  OnShow = FormShow
  DesignSize = (
    751
    550)
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 565
    Top = 379
    Width = 176
    Height = 121
    Anchors = [akRight, akBottom]
  end
  object Shape1: TShape
    Left = 563
    Top = 382
    Width = 175
    Height = 116
    Anchors = [akRight, akBottom]
    Brush.Color = clBtnFace
    Pen.Style = psClear
  end
  object Bevel2: TBevel
    Left = 678
    Top = 419
    Width = 33
    Height = 33
    Anchors = [akRight, akBottom]
  end
  object Label3: TLabel
    Left = 16
    Top = 40
    Width = 61
    Height = 13
    Caption = 'Position : 0,0'
    Transparent = True
  end
  object Label4: TLabel
    Left = 497
    Top = 509
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Position : 0,0'
    Transparent = True
  end
  object Label5: TLabel
    Left = 16
    Top = 16
    Width = 131
    Height = 16
    Caption = 'Zone de recherche'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label1: TLabel
    Left = 565
    Top = 26
    Width = 61
    Height = 13
    Anchors = [akTop, akRight]
    Caption = 'Position : 0,0'
    Transparent = True
  end
  object Label2: TLabel
    Left = 681
    Top = 177
    Width = 61
    Height = 13
    Alignment = taRightJustify
    Anchors = [akRight, akBottom]
    Caption = 'Position : 0,0'
    Transparent = True
  end
  object Label6: TLabel
    Left = 565
    Top = 3
    Width = 146
    Height = 16
    Anchors = [akTop, akRight]
    Caption = 'Graphique recherch'#233
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Image7: TImage
    Left = 686
    Top = 426
    Width = 25
    Height = 26
    Anchors = [akRight, akBottom]
    Transparent = True
  end
  object Label7: TLabel
    Left = 566
    Top = 363
    Width = 110
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Affiner les curseurs'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label8: TLabel
    Left = 678
    Top = 395
    Width = 36
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Curseur'
    Transparent = True
  end
  object Label9: TLabel
    Left = 584
    Top = 395
    Width = 47
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Directions'
    Transparent = True
  end
  object Label12: TLabel
    Left = 566
    Top = 184
    Width = 87
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Nom de l'#39'image'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label13: TLabel
    Left = 566
    Top = 227
    Width = 108
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'R'#233'sultat position X'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label14: TLabel
    Left = 566
    Top = 266
    Width = 108
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'R'#233'sultat position Y'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object SpeedButton1: TSpeedButton
    Left = 720
    Top = 199
    Width = 21
    Height = 22
    Anchors = [akRight, akBottom]
    Glyph.Data = {
      42020000424D4202000000000000420000002800000010000000100000000100
      1000030000000002000000000000000000000000000000000000007C0000E003
      00001F0000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C000000000000000000000000000000000000000000001F7C1F7C
      1F7C1F7C1F7C0000000000420042004200420042004200420042004200001F7C
      1F7C1F7C1F7C0000E07F00000042004200420042004200420042004200420000
      1F7C1F7C1F7C0000FF7FE07F0000004200420042004200420042004200420042
      00001F7C1F7C0000E07FFF7FE07F000000420042004200420042004200420042
      004200001F7C0000FF7FE07FFF7FE07F00000000000000000000000000000000
      0000000000000000E07FFF7FE07FFF7FE07FFF7FE07FFF7FE07F00001F7C1F7C
      1F7C1F7C1F7C0000FF7FE07FFF7FE07FFF7FE07FFF7FE07FFF7F00001F7C1F7C
      1F7C1F7C1F7C0000E07FFF7FE07F00000000000000000000000000001F7C1F7C
      1F7C1F7C1F7C1F7C0000000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000
      000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      000000001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C00001F7C1F7C1F7C0000
      1F7C00001F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C0000000000001F7C
      1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C1F7C
      1F7C1F7C1F7C}
    OnClick = SpeedButton1Click
  end
  object Label15: TLabel
    Left = 566
    Top = 307
    Width = 140
    Height = 13
    Anchors = [akRight, akBottom]
    Caption = 'Trouver la '#233'ni'#232'me image'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object ScrollBox1: TScrollBox
    Left = 16
    Top = 56
    Width = 541
    Height = 449
    HorzScrollBar.ButtonSize = 18
    HorzScrollBar.Tracking = True
    VertScrollBar.ButtonSize = 18
    VertScrollBar.Tracking = True
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = clBtnFace
    ParentColor = False
    TabOrder = 1
    DesignSize = (
      520
      428)
    object Image1: TImage
      Left = 0
      Top = 0
      Width = 673
      Height = 601
      AutoSize = True
      PopupMenu = PopupMenu3
      OnDragDrop = Image1DragDrop
      OnDragOver = Image1DragOver
      OnMouseMove = Image1MouseMove
      OnStartDrag = Image1StartDrag
    end
    object Label10: TLabel
      Left = 80
      Top = 224
      Width = 249
      Height = 65
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 
        'Pour capturer une zone de recherche utilisez la touche [Impr Sys' +
        't] de votre clavier, puis cliquez sur le bouton Coller.'
      Transparent = True
      WordWrap = True
      ExplicitWidth = 333
    end
    object Image2: TImage
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Cursor = crHandPoint
      AutoSize = True
      DragCursor = crHandPoint
      DragMode = dmAutomatic
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C40E0000C40E0000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF
        0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF
        0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FFC0C0C0FFFF
        FFFFFFFF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FFC0C0C00000FF0000FF0000FF0000FF0000FF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000
        FF0000FF0000FFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FF0000FF0000FF0000FFC0C0C0FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000
        FF0000FF0000FF0000FF0000FFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF
        C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      PopupMenu = PopupMenu1
      Transparent = True
      OnStartDrag = Image1StartDrag
    end
    object Image3: TImage
      Left = 440
      Top = 336
      Width = 16
      Height = 16
      Cursor = crHandPoint
      AutoSize = True
      DragCursor = crHandPoint
      DragMode = dmAutomatic
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C40E0000C40E0000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFC0C0C00000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C00000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFC0C0C00000FF0000FF0000FF0000FF0000FF0000FF0000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C00000FF
        0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FF0000FF0000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF
        0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF0000FF0000FF0000FF0000FF0000FFC0C0C00000FF0000FF0000FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FF
        FFFFFFFFFFFFC0C0C00000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000
        FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C00000FFFF
        FFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFFFF0000FF0000FF0000
        FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF0000FF0000FF0000FF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF0000FF0000FF0000FF0000
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF0000FF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      PopupMenu = PopupMenu2
      Transparent = True
      OnMouseMove = Image3MouseMove
      OnStartDrag = Image1StartDrag
    end
    object Image4: TImage
      Left = 68
      Top = 198
      Width = 16
      Height = 16
      Cursor = crHandPoint
      AutoSize = True
      DragCursor = crHandPoint
      DragMode = dmAutomatic
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C40E0000C40E0000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFF558CFF558CFF558CFF558CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFF558CFF558CFF558CFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF
        558CFF558CFF558CFF558CFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF558CFF558CFF558CFF558CFF558CFFFFFFFFFFFFFFFF
        FFFFFFFFFF558CFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFF558CFF
        558CFF558CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFFC0C0C0FFFF
        FFFFFFFF558CFF558CFF558CFF558CFF558CFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF558CFF558CFF558CFFC0C0C0558CFF558CFF558CFF558CFF558CFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFF558CFF558C
        FF558CFF558CFF558CFF558CFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF558CFF558CFF558CFF558CFF558CFF558CFF558CFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFF558CFF558C
        FF558CFF558CFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF558CFF558CFF558CFF558CFF558CFF558CFF558CFFC0C0C0FFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF558CFF558CFF558CFF558C
        FF558CFF558CFF558CFF558CFFC0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF558CFF558CFF558CFF558CFF558CFF558CFF558CFF558CFF558CFF
        C0C0C0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      Transparent = True
      OnEndDrag = Image4EndDrag
      OnStartDrag = Image1StartDrag
    end
    object Image5: TImage
      Left = 384
      Top = 252
      Width = 16
      Height = 16
      Cursor = crHandPoint
      AutoSize = True
      DragCursor = crHandPoint
      DragMode = dmAutomatic
      Picture.Data = {
        07544269746D617036030000424D360300000000000036000000280000001000
        000010000000010018000000000000030000C40E0000C40E0000000000000000
        0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFC0C0C04080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C04080FF4080FF4080FF
        4080FF4080FF4080FF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFC0C0C04080FF4080FF4080FF4080FF4080FF4080FF4080FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C04080FF
        4080FF4080FF4080FF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFF4080FF4080FF4080FF4080FF4080FF4080FF4080FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4080FF4080FF4080FF
        4080FF4080FF4080FF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FF4080FFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4080FF4080FF4080FF4080FF4080FF
        FFFFFFFFFFFFC0C0C04080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4080
        FF4080FF4080FF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFC0C0C04080FFFF
        FFFFFFFFFFFFFFFFFFFFFF4080FF4080FF4080FF4080FF4080FFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFC0C0C0FFFFFFFFFFFFFFFFFF4080FF4080FF4080
        FF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFF4080FF4080FF4080FF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF4080FF4080FF4080FF4080
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFF4080FF4080FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFF}
      Transparent = True
      OnEndDrag = Image5EndDrag
      OnStartDrag = Image1StartDrag
    end
  end
  object Button1: TButton
    Left = 481
    Top = 24
    Width = 74
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Coller'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ScrollBox2: TScrollBox
    Left = 566
    Top = 40
    Width = 175
    Height = 135
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 2
    DesignSize = (
      171
      131)
    object Label11: TLabel
      Left = 16
      Top = 40
      Width = 119
      Height = 40
      Alignment = taCenter
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = False
      Caption = 
        'Utiliser les fl'#232'ches orange pour s'#233'lectionner le graphique reche' +
        'rch'#233'.'
      Transparent = True
      WordWrap = True
      ExplicitWidth = 144
      ExplicitHeight = 56
    end
    object Image6: TImage
      Left = 0
      Top = 0
      Width = 151
      Height = 111
      Anchors = [akLeft, akTop, akRight, akBottom]
      AutoSize = True
      Center = True
      ExplicitWidth = 176
      ExplicitHeight = 127
    end
  end
  object Button2: TButton
    Left = 566
    Top = 513
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Valider'
    TabOrder = 5
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 674
    Top = 513
    Width = 67
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Annuler'
    TabOrder = 6
    OnClick = Button3Click
  end
  object ComboBox1: TComboBox
    Left = 566
    Top = 243
    Width = 177
    Height = 21
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 7
    OnDropDown = ComboBox1DropDown
  end
  object ComboBox2: TComboBox
    Left = 566
    Top = 283
    Width = 177
    Height = 21
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 8
    OnDropDown = ComboBox2DropDown
  end
  object UpDown1: TUpDown
    Tag = 999
    Left = 573
    Top = 425
    Width = 80
    Height = 23
    Anchors = [akRight, akBottom]
    Max = 32000
    Orientation = udHorizontal
    Position = 16000
    TabOrder = 3
    OnClick = UpDown1Click
  end
  object UpDown2: TUpDown
    Left = 606
    Top = 411
    Width = 16
    Height = 49
    Anchors = [akRight, akBottom]
    Max = 32000
    Position = 16000
    TabOrder = 4
    OnClick = UpDown2Click
  end
  object Edit2: TEdit
    Left = 620
    Top = 480
    Width = 121
    Height = 13
    Anchors = [akRight, akBottom]
    BorderStyle = bsNone
    Enabled = False
    ParentColor = True
    ReadOnly = True
    TabOrder = 9
    Text = 'Position souris : 0,0'
  end
  object ComboBox3: TComboBox
    Left = 566
    Top = 323
    Width = 176
    Height = 21
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 10
  end
  object ComboBox4: TComboBox
    Left = 566
    Top = 199
    Width = 150
    Height = 21
    Anchors = [akRight, akBottom]
    ItemHeight = 13
    TabOrder = 11
    OnChange = Edit1Change
  end
  object PopupMenu1: TPopupMenu
    Left = 160
    Top = 24
    object Placerlecureuralextremitdelimage1: TMenuItem
      Caption = 'Placer le cureur en haut '#224' gauche de l'#39'image.'
      OnClick = Placerlecureuralextremitdelimage1Click
    end
    object placerlescureursauxextremitsdelimage1: TMenuItem
      Caption = 'Placer les cureurs aux extremit'#233's de l'#39'image.'
      OnClick = placerlescureursauxextremitsdelimage1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 224
    Top = 24
    object Placerlecureurenbasdroitedelimage1: TMenuItem
      Caption = 'Placer le cureur en bas '#224' droite de l'#39'image.'
      OnClick = Placerlecureurenbasdroitedelimage1Click
    end
    object Placerlescureursauxextremitsdelimage2: TMenuItem
      Caption = 'Placer les cureurs aux extremit'#233's de l'#39'image.'
      OnClick = Placerlescureursauxextremitsdelimage2Click
    end
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp|Tous|*.*'
    Left = 256
    Top = 24
  end
  object PopupMenu3: TPopupMenu
    Left = 192
    Top = 24
    object Positiondescurseurs1: TMenuItem
      Caption = 'Position des curseurs'
      object Restaurer1: TMenuItem
        Caption = 'Restaurer'
        OnClick = Restaurer1Click
      end
      object Sauvegarder1: TMenuItem
        Caption = 'Sauvegarder'
        OnClick = Sauvegarder1Click
      end
    end
  end
end
