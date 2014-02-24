object Form37: TForm37
  Left = 369
  Top = 197
  Width = 463
  Height = 679
  Caption = 'Macro charts'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 455
    Height = 33
    Align = alTop
    TabOrder = 0
    object Button1: TButton
      Left = 8
      Top = 4
      Width = 75
      Height = 25
      Caption = '< Prec'#233'dent'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 92
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Suivant >'
      TabOrder = 1
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 33
    Width = 455
    Height = 612
    Align = alClient
    Color = clAppWorkSpace
    TabOrder = 1
    object ScrollBox1: TScrollBox
      Left = 1
      Top = 1
      Width = 453
      Height = 610
      Align = alClient
      TabOrder = 0
      object Prv: TPaintBox
        Left = 16
        Top = 10
        Width = 420
        Height = 594
        Color = clWhite
        ParentColor = False
        OnPaint = PrvPaint
      end
    end
  end
end
