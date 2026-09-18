object OKRightDlg: TOKRightDlg
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = #12480#12452#12450#12525#12464
  ClientHeight = 179
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  Position = poScreenCenter
  TextHeight = 15
  object Bevel1: TBevel
    Left = 8
    Top = 10
    Width = 281
    Height = 161
    Shape = bsFrame
  end
  object Label1: TLabel
    Left = 312
    Top = 88
    Width = 43
    Height = 15
    Caption = 'ver 1.1.0'
  end
  object Label2: TLabel
    Left = 24
    Top = 27
    Width = 75
    Height = 15
    Caption = #38283#22987#24453#12385#26178#38291
  end
  object Label3: TLabel
    Left = 215
    Top = 27
    Width = 28
    Height = 15
    Caption = 'msec'
  end
  object Label4: TLabel
    Left = 24
    Top = 70
    Width = 52
    Height = 15
    Caption = #25774#20687#26178#38291
  end
  object Label5: TLabel
    Left = 24
    Top = 115
    Width = 52
    Height = 15
    Caption = #25774#20687#38291#38548
  end
  object Label6: TLabel
    Left = 215
    Top = 70
    Width = 17
    Height = 15
    Caption = 'sec'
  end
  object Label7: TLabel
    Left = 215
    Top = 115
    Width = 28
    Height = 15
    Caption = 'msec'
  end
  object OKBtn: TButton
    Left = 300
    Top = 8
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 300
    Top = 38
    Width = 75
    Height = 25
    Cancel = True
    Caption = #12461#12515#12531#12475#12523
    ModalResult = 2
    TabOrder = 1
  end
  object Edit1: TEdit
    Left = 106
    Top = 24
    Width = 81
    Height = 23
    TabOrder = 2
    Text = '0'
  end
  object UpDown1: TUpDown
    Left = 187
    Top = 24
    Width = 16
    Height = 23
    Associate = Edit1
    Max = 10000
    TabOrder = 3
  end
  object Edit2: TEdit
    Left = 106
    Top = 67
    Width = 81
    Height = 23
    TabOrder = 4
    Text = '0'
  end
  object Edit3: TEdit
    Left = 106
    Top = 112
    Width = 81
    Height = 23
    TabOrder = 5
    Text = '100'
  end
  object UpDown2: TUpDown
    Left = 187
    Top = 67
    Width = 16
    Height = 23
    Associate = Edit2
    TabOrder = 6
  end
  object UpDown3: TUpDown
    Left = 187
    Top = 112
    Width = 16
    Height = 23
    Associate = Edit3
    Min = 100
    Max = 750
    Position = 100
    TabOrder = 7
  end
end
