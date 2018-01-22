object mf: Tmf
  Left = 296
  Top = 145
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Debase Master'
  ClientHeight = 382
  ClientWidth = 440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ldbl: TLabel
    Left = 8
    Top = 8
    Width = 138
    Height = 45
    Caption = 'DeBase'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object ldbd: TLabel
    Left = 16
    Top = 56
    Width = 171
    Height = 13
    Caption = 'Delphi basic self extraction program'
  end
  object lv: TListView
    Left = 8
    Top = 80
    Width = 425
    Height = 217
    BevelKind = bkFlat
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Name'
        Width = 100
      end
      item
        Caption = 'Size'
        Width = 100
      end
      item
        Caption = 'Type'
        Width = 100
      end
      item
        Caption = 'Added Date'
        Width = 100
      end>
    ColumnClick = False
    FlatScrollBars = True
    GridLines = True
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
  end
  object pc: TPanel
    Left = 0
    Top = 362
    Width = 440
    Height = 20
    Align = alBottom
    BevelOuter = bvNone
    Caption = #169' 2016 Arachmadi Putra Pambudi'
    TabOrder = 1
  end
  object bbsa: TBitBtn
    Left = 8
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 2
    OnClick = bbsaClick
    Kind = bkOK
  end
  object bbda: TBitBtn
    Left = 88
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = bbdaClick
    Kind = bkCancel
  end
  object bbe: TBitBtn
    Left = 360
    Top = 328
    Width = 75
    Height = 25
    Caption = 'Create'
    TabOrder = 4
    OnClick = bbeClick
    Kind = bkRetry
  end
  object pb: TProgressBar
    Left = 8
    Top = 304
    Width = 425
    Height = 12
    TabOrder = 5
  end
end
