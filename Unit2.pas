unit Unit2;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

type
  TForm2 = class(TForm)
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private êÈåæ }
  public
    { Public êÈåæ }
    rect: TRect;
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

uses System.Math;

var
  mdown: Boolean;
  sx, sy: Integer;

procedure TForm2.FormCreate(Sender: TObject);
begin
  AlphaBlend := true;
  AlphaBlendValue := 200;
end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mdown := true;
  sx := X;
  sy := Y;
end;

procedure TForm2.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if mdown then
  begin
    Canvas.Brush.Color := clBlack;
    Canvas.FillRect(ClientRect);
    Canvas.Brush.Color := clWhite;
    Canvas.Rectangle(TRect.Create(sx, sy, X, Y));
  end;
end;

procedure TForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mdown := false;
  rect := TRect.Create(min(sx, X), min(sy, Y), max(sx, X), max(sy, Y));
  ModalResult := mrOK;
end;

end.
