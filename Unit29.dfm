object Form29: TForm29
  Left = 415
  Top = 278
  Anchors = [akLeft, akBottom]
  BorderIcons = []
  Caption = 'Chargement'
  ClientHeight = 94
  ClientWidth = 404
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  DesignSize = (
    404
    94)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 153
    Height = 13
    Caption = 'Description du chargement'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = True
  end
  object Label2: TLabel
    Left = 9
    Top = 59
    Width = 286
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Appuiez sur la touche Echap pour interrompre la progression.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object ProgressBar1: TProgressBar
    Left = 7
    Top = 24
    Width = 323
    Height = 17
    TabOrder = 0
  end
end
