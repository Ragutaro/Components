unit HideLabel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Graphics;

type
  TPosi = (psKintou, psLeft, psCentar, psRight);
  TLayout = (tlTop, tlMiddle, tlBottom);
  TEllipsisPosition = (epNone, epEndEllipsis, epPathEllipsis, epWordEllipsis);
  THideLabel = class(TLabel)
  private
    FPosi: Tposi;
    FUEndEllipsis : Boolean;
    FDrawFrame : Boolean;
    FDrawColor : TColor;
    FDrawStyle : TPenStyle;
    FLayout : TLayout;
    FMargin : Integer;
    FEllipsis : TEllipsisPosition;
    FFitCaption: Boolean;
    procedure SetPosition(Value: TPosi);
    procedure SetUEndEllipsis(Value: Boolean);
    procedure SetUDrawFrame(Value: Boolean);
    procedure SetUDrawColor(Value: TColor);
    procedure SetUDrawStyle(Value: TPenStyle);
    procedure SetULayout(Value: TLayout);
    procedure SetUMargin(const Value: Integer);
    procedure SetUEllipsis(Value: TEllipsisPosition);
    procedure SetUFitCaption(const Value: Boolean);
  protected
    { Protected êÈåæ }
    procedure Paint; override;
  public
    { Public êÈåæ }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
  published
    { Published êÈåæ }
    property Align;
    property Autosize;
    property Anchors;
    property Caption;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Transparent;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnEndDrag;
    property OnDragOver;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property DrawFrame : Boolean read FDrawFrame write SetUDrawFrame default False;
    property DrawColor : TColor read FDrawColor write SetUDrawColor default clBlack;
    property DrawStyle : TPenStyle read FDrawStyle write SetUDrawStyle default psSolid;
    property EllipsisPosition : TEllipsisPosition read FEllipsis write SetUEllipsis default epNone;
    property EndEllipsis : Boolean read FUEndEllipsis write SetUEndEllipsis default False;
    property FitCaption : Boolean read FFitCaption write SetUFitCaption default False;
    property Layout : TLayout read FLayout write SetULayout default tlTop;
    property Margin : Integer read FMargin write SetUMargin default 0;
    property Position: TPosi read FPosi write SetPosition default psKintou;
  end;

procedure Register;

implementation
  
procedure THideLabel.SetULayout(Value: TLayout);
begin
  FLayout := Value;
  Invalidate;
end;

procedure THideLabel.SetUDrawStyle(Value: TPenStyle);
begin
  FDrawStyle := Value;
  Invalidate;
end;

procedure THideLabel.SetUDrawColor(Value: TColor);
begin
  FDrawColor := Value;
  Invalidate;
end;

procedure THideLabel.SetUDrawFrame(Value: Boolean);
begin
  FDrawFrame := Value;
  Invalidate;
end;

procedure THideLabel.SetUEndEllipsis(Value: Boolean);
begin
  FUEndEllipsis := Value;
  Invalidate;
end;

constructor THideLabel.Create(AOwner: TComponent);
begin
   inherited Create(AOwner);
   AutoSize := False;
   Position := psKintou;
   Transparent := False;
   FitCaption := False;
end;

destructor THideLabel.Destroy;
begin
   inherited Destroy;
end;

procedure THideLabel.Paint;
var
  LF:TLogFont;
  tm: TTextMetric;
  MyRect: TRect;
  Y: Double;
  Z: Double;
  X: integer;
  Leng, iWidth : integer;
begin
  Leng := 0;
  with Canvas do
  begin
    // +++++ îwåiÇÃï`âÊ +++++
    if not Transparent then
    begin
      Brush.Style := bsSolid;
      Brush.Color := Self.Color;
      FillRect(ClientRect);
    end;

    if FDrawFrame then
    begin
      Pen.Style := FDrawStyle;// psSolid;
      Pen.Color := FDrawColor;// $00B99D7F;
      Rectangle(ClientRect);
    end;

    Pen.Style := psClear;
    Brush.Style := bsClear;

    if Enabled then
    begin
      MyRect := ClientRect;
      MyRect.Left := MyRect.Left + FMargin;
      MyRect.Top := MyRect.Top + FMargin;
      MyRect.Right := MyRect.Right - FMargin;
      MyRect.Bottom := MyRect.Bottom - FMargin;
      Font := Self.Font;
      GetObject(Font.Handle, SizeOf(LF), @LF);
      GetTextMetrics(Handle, tm);
      if Caption <> '' then
      begin
        //ÉåÉCÉAÉEÉgÇÃê›íË
        Case FLayout of
          tlMiddle :
            MyRect.Top := (Self.Height - TextHeight(Caption)) div 2;
          tlBottom :
            MyRect.Top := Self.Height - TextHeight(Caption) -1;
        end;

        if FitCaption and (TextWidth(Caption) > Self.Width - 6) then
        begin
          iWidth := Trunc(Self.Width / TextWidth(Caption) * 10);
          LF.lfWidth := iWidth;
          Font.Handle := CreateFontIndirect(LF);
        end;

        if (TextWidth(Caption) + FMargin > Self.Width) and (FUEndEllipsis) then
        begin
          //â°ïùÇí¥Ç¶ÇÈèÍçá
          Case FEllipsis of
            epNone : DrawTextW(Handle, PWideChar(Caption), -1, MyRect, DT_EDITCONTROL);
            epEndEllipsis : DrawTextW(Handle, PWideChar(Caption), -1, MyRect, DT_END_ELLIPSIS);
            epPathEllipsis : DrawTextW(Handle, PWideChar(Caption), -1, MyRect, DT_PATH_ELLIPSIS);
            epWordEllipsis : DrawTextW(Handle, PWideChar(Caption), -1, MyRect, DT_WORD_ELLIPSIS);
          end;
          exit;
        end;

        case Position of
          psKintou :
            begin
              if Length(Caption) > 1 then
              begin
                Leng := Length(Caption);
                Y := ((MyRect.Right - MyRect.Left)
                    - TextWidth(Copy(Caption, Leng,1))) / (Leng - 1);
                Z := MyRect.Left+1;
                for X := 1 to Leng do
                begin
                  TextRect(MyRect, Trunc(Z), MyRect.Top+1, Copy(Caption,X,1));
                  Z := Z + Y;
                end;
              end else
              begin
                Y := Trunc(((MyRect.Right - MyRect.Left)
                   - TextWidth(Copy(Caption, Leng,1))) / 2);
                TextRect(MyRect, Trunc(Y)+1, MyRect.Top+1, Caption);
              end;
            end;
          psLeft :
            begin
              if WordWrap then
                DrawTextW(Canvas.Handle, PWideChar(Caption), -1, MyRect, DT_WORDBREAK)
              else
                TextRect(MyRect, MyRect.Left, MyRect.Top+1, Caption);
            end;
          psCentar :
            begin
              Y := Trunc(((MyRect.Right - MyRect.Left) - TextWidth(Caption)) / 2);
              TextRect(MyRect, Trunc(Y), MyRect.Top+1, Caption);
            end;
          psRight :
            begin
              Y := (MyRect.Right - MyRect.Left) - TextWidth(Caption);
              TextRect(MyRect, MyRect.Left+Trunc(Y), MyRect.Top, Caption);
            end;
        end;//case
        LF.lfWidth := tm.tmAveCharWidth;
        Font.Handle := CreateFontIndirect(LF);
      end;
    end;
  end;//with
end;

procedure THideLabel.SetPosition(Value: TPosi);
begin
  FPosi := Value;
  Invalidate;
end;

procedure Register;
begin
  RegisterComponents('HaS', [THideLabel]);
end;

function Shisya(X: Extended): Integer;
begin
  if x >= 0 then
    Result := Trunc(x + 0.5)
  else
    Result := Trunc(x - 0.5);
end;

procedure THideLabel.SetUMargin(const Value: Integer);
begin
  FMargin := Value;
  Invalidate;
end;

procedure THideLabel.SetUEllipsis(Value: TEllipsisPosition);
begin
  FEllipsis := Value;
  Invalidate;
end;

procedure THideLabel.SetUFitCaption(const Value: Boolean);
begin
  FFitCaption := Value;
  Invalidate;
end;

end.
