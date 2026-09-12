object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'GifCapture'
  ClientHeight = 326
  ClientWidth = 452
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Image1: TImage
    Left = 0
    Top = 25
    Width = 452
    Height = 301
    Align = alClient
    Proportional = True
    Stretch = True
    ExplicitTop = 31
    ExplicitWidth = 409
    ExplicitHeight = 297
  end
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 452
    Height = 25
    ActionManager = ActionManager1
    Caption = 'ActionToolBar1'
    Color = clMenuBar
    ColorMap.DisabledFontColor = 10461087
    ColorMap.HighlightColor = clWhite
    ColorMap.BtnSelectedFont = clBlack
    ColorMap.UnusedColor = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    Spacing = 0
  end
  object ActionManager1: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Action = Action1
            Caption = #23455#34892'(&X)'
          end
          item
            Action = Action3
            Caption = #38283#12367'(&Z)'
          end
          item
            Caption = '-'
          end
          item
            Action = Action2
            Caption = #32066#20102'(&Y)'
          end>
        ActionBar = ActionToolBar1
      end>
    Left = 336
    Top = 72
    StyleName = 'Platform Default'
    object Action1: TAction
      Caption = #23455#34892
      OnExecute = Action1Execute
    end
    object Action3: TAction
      Caption = #38283#12367
      OnExecute = Action3Execute
    end
    object Action2: TAction
      Caption = #32066#20102
      OnExecute = Action2Execute
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 240
    Top = 72
  end
end
