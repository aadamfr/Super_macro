object Form20: TForm20
  Left = 295
  Top = 205
  HelpContext = 1138
  Caption = 'Liste syst'#232'me'
  ClientHeight = 256
  ClientWidth = 410
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 33
    Width = 410
    Height = 153
    Align = alClient
    Columns = <>
    HotTrackStyles = [htHandPoint, htUnderlineCold, htUnderlineHot]
    TabOrder = 0
    ViewStyle = vsReport
    OnClick = ListView1Click
    OnColumnClick = ListView1ColumnClick
    OnDblClick = ListView1DblClick
    OnKeyDown = ListView1KeyDown
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 410
    Height = 33
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 46
      Height = 13
      Caption = 'syst'#232'me'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 186
    Width = 410
    Height = 70
    Align = alBottom
    Color = clBtnFace
    HideSelection = False
    ReadOnly = True
    TabOrder = 2
    WantTabs = True
  end
end
