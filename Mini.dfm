object Form38: TForm38
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Mini'
  ClientHeight = 63
  ClientWidth = 165
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnShow = FormShow
  DesignSize = (
    165
    63)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 6
    Top = 27
    Width = 21
    Height = 20
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 33
    Top = 27
    Width = 21
    Height = 20
    OnClick = SpeedButton2Click
  end
  object SpeedButton3: TSpeedButton
    Left = 149
    Top = 0
    Width = 16
    Height = 17
    Anchors = [akTop, akRight]
    OnClick = SpeedButton3Click
    ExplicitLeft = 223
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 43
    Height = 13
    Caption = 'FileName'
    ParentShowHint = False
    ShowHint = True
  end
end
