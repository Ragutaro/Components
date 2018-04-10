unit HideBack;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls, Vcl.Graphics;

type
  TCustomHideBack = class(TLabel)
  private
    { Private 宣言 }
  protected
    { Protected 宣言 }
    procedure Paint; override;
  public
    { Public 宣言 }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    { Published 宣言 }
  end;

  THideBack = class(TCustomHideBack)
  private
    { Private 宣言 }
  protected
    { Protected 宣言 }
  public
    { Public 宣言 }
  published
    { Published 宣言 }
  end;

procedure Register;

implementation

uses
dp;

procedure Register;
begin
  RegisterComponents('HaS', [THideBack]);
end;

{ TCustomHideBack }

constructor TCustomHideBack.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align       := alTop;
  Anchors     := [akLeft, akTop, akRight, akBottom];
  AutoSize    := False;
  Caption     := ' ';
  Color       := clWhite;
  Transparent := False;
end;

destructor TCustomHideBack.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomHideBack.Paint;
begin
  inherited;
  with Self.Canvas do
  begin
    Pen.Style := psSolid;
    Pen.Color := $00DFDFDF;
    Pen.Width := 1;
    MoveTo(0, Self.Height-1);
    LineTo(Self.Width, Self.Height-1);
  end;
end;


end.
