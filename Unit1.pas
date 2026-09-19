unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList,
  Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.PlatformDefaultStyleActnCtrls,
  Vcl.ExtCtrls, System.Generics.Collections;

type
  TDataRecord = record
    sleeptime, shotsecond, shotcount: integer;
  end;

  TForm1 = class(TForm)
    ActionManager1: TActionManager;
    ActionToolBar1: TActionToolBar;
    Action1: TAction;
    Action2: TAction;
    Action3: TAction;
    Image1: TImage;
    Action4: TAction;
    Action5: TAction;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure Action2Execute(Sender: TObject);
    procedure Action3Execute(Sender: TObject);
    procedure Action4Execute(Sender: TObject);
    procedure Action5Execute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private 宣言 }
    List: TObjectList<TGraphic>;
    fname: string;
    data: TDataRecord;
    procedure CaptureScreenToImage(Sender: TImage);
  public
    { Public 宣言 }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Vcl.Imaging.GIFImg, Vcl.Imaging.pngimage, System.Threading, System.IOUtils, System.DateUtils,
  Unit2, OKCANCL2;

const
  title = 'GIF Capture %s';

var
  [weak] task: ITask;

function RunConsoleCommand(const Command: string): Boolean;
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  CmdLine: string;
begin
  Result := False;

  // 構造体の初期化
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  StartupInfo.cb := SizeOf(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := SW_HIDE; // ウィンドウを非表示にする

  // CreateProcessは第2引数の文字列を書き換える可能性があるため、独立したメモリを確保
  CmdLine := Command;
  UniqueString(CmdLine);

  // プロセスの起動
  if CreateProcess(
    nil,
    PChar(CmdLine), // 実行するコマンド
    nil,
    nil,
    False,
    CREATE_NO_WINDOW, // コンソール画面を生成しないフラグ
    nil,
    nil, // 実行ディレクトリ（nilなら現在のディレクトリ）
    StartupInfo,
    ProcessInfo) then
  begin
    // プロセスが終了するまで待機する
    WaitForSingleObject(ProcessInfo.hProcess, INFINITE);

    // メモリリークを防ぐためにハンドルを閉じる
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);

    Result := True;
  end;
end;

procedure SaveBitmapsToAnimatedGIF(const Bitmaps: array of TGraphic; const FileName: string);
var
  Frame: TGIFFrame;
begin
  if Length(Bitmaps) = 0 then Exit;

  var GIF := TGIFImage.Create;
  try
    // GIFのベースとなるサイズを1枚目の画像に合わせる
    GIF.Width := Bitmaps[0].Width;
    GIF.Height := Bitmaps[0].Height;

    for var i := Low(Bitmaps) to High(Bitmaps) do
    begin
      Frame := GIF.Add(Bitmaps[i]);

    // アニメーションのループ設定（0 = 無限ループ）
    // ※Netscape拡張ブロックを追加してループ回数を指定します
      TGIFAppExtNSLoop.Create(Frame).Loops:=0;
      TGIFGraphicControlExtension.Create(Frame).Delay:=Form1.data.shotcount div 10;
    end;

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
  List:=TObjectList<TGraphic>.Create;
  data.sleeptime:=3000;
  data.shotsecond:=30;
  data.shotcount:=250;
end;

procedure TForm1.Action1Execute(Sender: TObject);
var
  s, path: string;
  y,m,d,hour,minute, second, msec: Word;
begin
  if Assigned(task) then
    Exit;
  Caption:=Format(title,['[準備中]']);
  Image1.Hide;
  List.Clear;
  DecodeDateTime(Now, y, m, d, hour, minute, second, msec);
  s:= Format('ScreenShot-%u-%u-%u-%u%u%u.gif', [y, m, d, hour, minute, second]);
  path := TPath.Combine(TPath.GetPicturesPath, 'ScreenShots','GifShot');
  fname := TPath.Combine(path,s);
  if not TDirectory.Exists(path) then
    TDirectory.CreateDirectory(path);
  if Action4.Checked and(Form2.ShowModal = mrCancel) then
    Exit;
  Sleep(data.sleeptime);
  WindowState:=TWindowState.wsMinimized;
  Caption:=Format(title,['撮影中']);
  Sleep(200);

  task := TTask.Run(
    procedure
    var
      png: TPngImage;
    begin
      png:=nil;
      try
        var bmp:=TBitmap.Create;
        for var i := 1 to (data.shotsecond*1000) div data.shotcount do
        begin
          png := TPngImage.Create;
          TThread.Synchronize(nil,
            procedure
            begin
              CaptureScreenToImage(Image1);
            end);
          if Action4.Checked then
          begin
            bmp.SetSize(Form2.rect.Width,Form2.rect.Height);
            bmp.Canvas.CopyRect(TRect.Create(0, 0, bmp.Width, bmp.Height),
              Image1.Canvas, Form2.rect);
            png.Assign(bmp);
          end
          else
            png.Assign(Image1.Picture.Graphic);
          List.Add(png);
          Sleep(data.shotcount);
        end;
        bmp.Free;
      except
        png.Free;
      end;
      TThread.Queue(nil,
        procedure
        begin
          Caption:=Format(title,['処理中']);
        end);
      WindowState:=TWindowState.wsNormal;
      SaveBitmapsToAnimatedGIF(List.ToArray,fname);
      RunConsoleCommand(Format('magick %s -layers optimize %s',[fname, fname]));
      TThread.Queue(nil,
        procedure
        begin
          Showmessage('完成');
          Caption:=Format(title,['']);
          Image1.Show;
          Action3Execute(nil);
        end);
    end);
end;

procedure TForm1.Action2Execute(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Action3Execute(Sender: TObject);
begin
  if FileExists(fname) then
  begin
    Image1.Picture.LoadFromFile(fname);
    with Image1.Picture.Graphic as TGifImage do
    begin
      Animate := true;
      AnimateLoop := TGIFAnimationLoop.glEnabled;
    end;
  end;
end;

procedure TForm1.Action4Execute(Sender: TObject);
begin
  //
end;

procedure TForm1.Action5Execute(Sender: TObject);
begin
  with OKRightDlg do
  begin
    Updown1.Position:=data.sleeptime;
    Updown2.Position:=data.shotsecond;
    Updown3.Position:=data.shotcount;
    if ShowModal = mrOK then
    begin
      data.sleeptime:=UpDown1.Position;
      data.shotsecond:=UpDown2.Position;
      data.shotcount:=UpDown3.Position;
    end;
  end;
end;

procedure TForm1.CaptureScreenToImage(Sender: TImage);
var
  DesktopDC, MemDC: HDC;
  DesktopHandle: HWND;
  Bitmap: TBitmap;
  rect: TRect;
begin
  // デスクトップのハンドルを取得
  DesktopHandle := GetDesktopWindow;
  // デスクトップのデバイスコンテキスト（DC）を取得
  DesktopDC := GetDC(DesktopHandle);
  try
    // デスクトップのサイズを取得
    GetWindowRect(DesktopHandle, rect);

    // メモリ上のデバイスコンテキストを作成
    MemDC := CreateCompatibleDC(DesktopDC);

    Bitmap := TBitmap.Create;
    try
      Bitmap.Width := rect.Width;
      Bitmap.Height := rect.Height;

      // ビットマップに描画
      SelectObject(MemDC, Bitmap.Handle);
      BitBlt(MemDC, 0, 0, rect.Width, rect.Height, DesktopDC, 0, 0, SRCCOPY);

      // TImage に割り当てる
      Sender.Picture.Assign(Bitmap);
    finally
      Bitmap.Free;
      DeleteDC(MemDC);
    end;
  finally
    ReleaseDC(DesktopHandle, DesktopDC);
  end;
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Assigned(task) then
  begin
    CanClose:=false;
    Showmessage('動作中です');
  end;
end;

end.
