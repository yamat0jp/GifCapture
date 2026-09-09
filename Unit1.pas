unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ExtCtrls, System.Generics.Collections;

type
  TForm1 = class(TForm)
    ActionManager1: TActionManager;
    ActionToolBar1: TActionToolBar;
    Action1: TAction;
    Timer1: TTimer;
    Action2: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private 宣言 }
    List: TObjectList<TBitmap>;
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

uses Vcl.Imaging.GIFImg, System.Threading;

const
  title = 'GIF Capture %s';

var
  task: ITask;

{$R *.dfm}

// 画面全体をキャプチャしてTBitmapに返す関数
function CaptureScreen: TBitmap;
var
  bmp: TBitmap;
  DesktopCanvas: TCanvas;
  DC: HDC;
begin
  Result := TBitmap.Create;
  try
    // 画面の解像度を取得
    Result.Width := Screen.Width;
    Result.Height := Screen.Height;
    Result.PixelFormat := pf16bit;

    // デスクトップのデバイスコンテキスト(DC)を取得
    DC := GetDC(0);
    try
      DesktopCanvas := TCanvas.Create;
      try
        DesktopCanvas.Handle := DC;
        // BitBltで画面のピクセルデータをTBitmapに高速コピー
        BitBlt(Result.Canvas.Handle, 0, 0, Result.Width, Result.Height,
               DesktopCanvas.Handle, 0, 0, SRCCOPY);
      finally
        DesktopCanvas.Free;
      end;
    finally
      ReleaseDC(0, DC);
    end;
    bmp:=TBitmap.Create(Result.Width div 2, Result.Height div 2);
    try
      bmp.Canvas.StretchDraw(TRect.Create(0,0,bmp.Width,bmp.Height),Result);
      Result.Assign(bmp);
    finally
      bmp.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

procedure SaveBitmapsToAnimatedGIF(const Bitmaps: array of TBitmap; const FileName: string);
var
  GIF: TGIFImage;
  Frame: TGIFFrame;
begin
  if Length(Bitmaps) = 0 then Exit;

  GIF := TGIFImage.Create;
  try
    // GIFのベースとなるサイズを1枚目の画像に合わせる
    GIF.Width := Bitmaps[0].Width;
    GIF.Height := Bitmaps[0].Height;

    Frame := nil;
    for var i := Low(Bitmaps) to High(Bitmaps) do
      Frame := GIF.Add(Bitmaps[i]);

    // アニメーションのループ設定（0 = 無限ループ）
    // ※Netscape拡張ブロックを追加してループ回数を指定します
    TGIFAppExtNSLoop.Create(Frame).Loops:=0;
    TGIFGraphicControlExtension.Create(Frame).Delay:=100;

    // GIFファイルとして書き出し
    GIF.SaveToFile(FileName);
  finally
    GIF.Free;
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  List.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  List:=TObjectList<TBitmap>.Create;
end;

procedure TForm1.Action1Execute(Sender: TObject);
begin
  if Assigned(task) then
    Exit;
  Caption:=Format(title,['[録画中]']);
  WindowState:=TWindowState.wsMinimized;
  List.Clear;
  Timer1.Enabled:=true;
end;

procedure TForm1.Action2Execute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(task) then
  begin
    CanClose:=false;
    Showmessage('動作中です');
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  if List.Count < 10 then
    List.Add(CaptureScreen)
  else
  begin
    Caption:=Format(title,['[処理中]']);
    WindowState:=TWindowState.wsNormal;
    Application.ProcessMessages;
    Timer1.Enabled:=false;
    task:=TTask.Run(
      procedure
      begin
        try
          SaveBitmapsToAnimatedGIF(List.ToArray,'capture.gif');
        finally
          TThread.Queue(nil,
            procedure
            begin
              task:=nil;
              Showmessage('完成');
              Caption:=Format(title,['']);
            end);
        end;
      end);
  end;
end;

end.
