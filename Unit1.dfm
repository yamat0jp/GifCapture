object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'GifCapture'
  ClientHeight = 25
  ClientWidth = 264
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
  object ActionToolBar1: TActionToolBar
    Left = 0
    Top = 0
    Width = 264
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
