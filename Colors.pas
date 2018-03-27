unit Colors;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, System.SysUtils, System.UITypes, Vcl.Graphics, System.Win.Registry,
  System.StrUtils, System.Classes;

  procedure GetRGB(Color: TColor; var R, G, B: Integer);          //r,g,bに分解
  function GetTitlebarColor: TColor;                              //タイトルバーの色を取得
  function SetTitlebarCaptionColor(cTitleColor: TColor): TColor;  //タイトルバーのフォント色を作成
  function GetOppositeColor(SrcColor: TColor): TColor;            //反対色を取得
  function GetComplementaryColor(SrcColor: TColor): TColor;       //補色を取得
  function ColorToRGBString(Color: TColor): String;               //r,g,b形式の文字列を取得
  function RGBStringToColor(RGBString: String): TColor;                 //r,g,b形式の文字列をTColorに変換
  function HtmlToColor(sHtml: String): TColor;                    //#RRGGBBをTColorに変換
  procedure WriteAccentColor(Color: TColor);                      //AccentColorをレジストリに保存する
  function CreateRandomColor: TColor;                             //ランダムな色を作成する

implementation

uses
  HideUtils;

procedure GetRGB(Color: TColor; var R, G, B: Integer);
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
end;

function GetTitlebarColor;
var
  r, g, b, sHex : String;
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKeyReadOnly('SOFTWARE\Microsoft\Windows\DWM');
    sHex := IntToHex(reg.ReadInteger('AccentColor'), 8);
    b := Copy(sHex, 3, 2);
    g := Copy(sHex, 5, 2);
    r := Copy(sHex, 7, 2);
    Result := RGB(HexToInt(r), HexToInt(g), HexToInt(b));
  finally
    reg.Free;
  end;
end;

procedure WriteAccentColor(Color: TColor);
var
  r, g, b, iColor : Integer;
  reg : TRegistry;
begin
  reg := TRegistry.Create;
  try
    reg.RootKey := HKEY_CURRENT_USER;
    reg.OpenKey('SOFTWARE\Microsoft\Windows\DWM', False);
    GetRGB(Color, r, g, b);
//    iColor := HexToInt('ff' + IntToHex(b, 2) + IntToHex(g, 2) + IntToHex(r, 2));
//    reg.WriteInteger('AccentColor', iColor);
    iColor := HexToInt('c4' + IntToHex(r, 2) + IntToHex(g, 2) + IntToHex(b, 2));
    reg.WriteInteger('ColorizationAfterglow', iColor);
    reg.WriteInteger('ColorizationColor', iColor);
  finally
    reg.Free;
  end;
end;

function SetTitlebarCaptionColor(cTitleColor: TColor): TColor;
var
  s : Single;
begin
  s := ((GetRValue(cTitleColor)*299) + (GetGValue(cTitleColor)*587) + (GetBValue(cTitleColor)*114)) / 1000;
  if s > 160 then
    Result := clBlack
  else
    Result := clWhite;
//  if Trunc((0.2126 * GetRValue(cTitleColor)) + (0.7152 * GetGValue(cTitleColor)) + (0.0722 * GetBValue(cTitleColor))) > 140 then
//    Result := clBlack
//  else
//    Result := clWhite;
end;

// TColor を r,g,b 形式の文字列にする
function ColorToRGBString(Color: TColor): String;
var
  r, g, b : Integer;
begin
  r := Color and $ff;
  g := Color and $ff00 shr 8;
  b := Color and $ff0000 shr 16;
  Result := Format('%d,%d,%d', [r,g,b]);
end;

function RGBStringToColor(RGBString: String): TColor;
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.CommaText := RGBString;
    Result := RGB(StrToInt(sl[0]), StrToInt(sl[1]), StrToInt(sl[2]));
  finally
    sl.Free;
  end;
end;

function HtmlToColor(sHtml: String): TColor;
var
  r, g, b : String;
begin
  sHtml := ReplaceText(sHtml, '#', '');
  r := Copy(sHtml, 1, 2);
  g := Copy(sHtml, 3, 2);
  b := Copy(sHtml, 5, 2);
  Result := RGB(StrToInt('$'+r), StrToInt('$'+g), StrToInt('$'+b));
end;

//反対色を作成する
function GetOppositeColor(SrcColor: TColor): TColor;
var
  r, g, b : Integer;
begin
  //反対色の作成
  r := 255 - GetRValue(ColorToRGB(SrcColor));
  g := 255 - GetGValue(ColorToRGB(SrcColor));
  b := 255 - GetBValue(ColorToRGB(SrcColor));
  Result := RGB(r, g, b);
end;

//補色を作成する
function GetComplementaryColor(SrcColor: TColor): TColor;
var
  r, g, b, r1, g1, b1, iMax, iMin, iTotal : Integer;
begin
  r := GetRValue(ColorToRGB(SrcColor));
  g := GetGValue(ColorToRGB(SrcColor));
  b := GetBValue(ColorToRGB(SrcColor));
  //補色の作成
  //最大値を求める
  iMax := 0;
  if r > iMax then iMax := r;
  if g > iMax then iMax := g;
  if b > iMax then iMax := b;
  //最小値を求める
  iMin := 255;
  if r < iMin then iMin := r;
  if g < iMin then iMin := g;
  if b < iMin then iMin := b;
  iTotal := iMax + iMin;
  r1 := iTotal - r;
  g1 := iTotal - g;
  b1 := iTotal - b;
  Result := RGB(r1, g1, b1);
end;

function CreateRandomColor: TColor;
var
  r, g, b : Integer;
begin
  Randomize;
  r := Random(256);
  g := Random(256);
  b := Random(256);
  Result := RGB(r, g, b);
end;

end.
