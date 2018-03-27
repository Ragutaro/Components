unit InetUtils;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Winapi.WinInet, System.StrUtils;

  function DownloadFile(URL, SaveDir: String): Boolean;
  function DownloadHttp(const URL: String; ms: TMemoryStream): Boolean;
  function DownloadHttpToStringList(const URL: String; sl: TStringList; EncodeType: TEncoding): Boolean;
  function GetHtmlElement(const Source, Element: String): String;

implementation

uses
  HideUtils;

procedure GetHtmlToMemoryStream(sUrl: String; ms: TMemoryStream);
var
  hOpen, hURL : HINTERNET;
  pBuf : pointer;
  ReadBytes : DWORD;
begin
  hOpen := InternetOpen('HaS', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if not Assigned(hOpen) then
  begin
  	exit;
  end;

  hURL := InternetOpenUrl(hOpen, PWideChar(sURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
  if not Assigned(hURL) then
  begin
    InternetCloseHandle(hOpen);
    exit;
  end;

  GetMem(pBuf, 1024);
  ms.Position := 0;
  try
    repeat
      InternetReadFile(hURL, pBuf, 1024, ReadBytes);
      ms.Write(pBuf^, ReadBytes);
    until ReadBytes = 0;
  finally
    FreeMem(pBuf);
    InternetCloseHandle(hURL);
    InternetCloseHandle(hOpen);
  end;

  if ms.Size = 0 then
    Exit
  else
  begin
    ms.Position := 0;
  end;
end;

function DownloadFile(URL, SaveDir: String): Boolean;
var
  ms : TMemoryStream;
  sName : String;
begin
  ms := TMemoryStream.Create;
  try
    GetHtmlToMemoryStream(URL, ms);
    if ms.Size > 0 then
    begin
      if RightStr(SaveDir, 1) <> '\' then
        SaveDir := SaveDir + '\';

      CreateDir(SaveDir);

      sName := ReplaceText(URL, '/', '\');
      sName := ExtractFileName(sName);
      ms.Position := 0;
      ms.SaveToFile(SaveDir + sName);
      Result := True;
    end
    else
    begin
      Result := False;
    end;
  finally
    ms.Free;
  end;
end;

function DownloadHttp(const URL: String; ms: TMemoryStream): Boolean;
begin
  GetHtmlToMemoryStream(URL, ms);
  if ms.Size > 0 then
  begin
    ms.Position := 0;
    Result := True;
  end else
    Result := False;
end;

function DownloadHttpToStringList(const URL: String; sl: TStringList; EncodeType: TEncoding): Boolean;
//  EncodeType  取得するページの文字コードに合わせる
var
  ms : TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    GetHtmlToMemoryStream(URL, ms);
    if ms.Size > 0 then
    begin
      ms.Position := 0;
      sl.LoadFromStream(ms, EncodeType);
      Result := True;
    end else
      Result := False;
  finally
    ms.Free;
  end;
end;

function GetHtmlElement(const Source, Element: String): String;
var
  sl : TStringList;
  s, sExt, sTmp : String;
  i : Integer;
  bStart : Boolean;
begin
  bStart := False;

  sExt := ReplaceText(Source, '<', '');
  sExt := ReplaceText(sExt, '>', ' ');
  sExt := ReplaceText(sExt, #13#10, ' ');

  sl := TStringList.Create;
  try
    for i := 1 to Length(sExt) do
    begin
      s := Copy(sExt, i, 1);
      if s = '"' then
        bStart := Not bStart;

      if s = ' ' then
      begin
        if bStart then
          sTmp := sTmp + s
        else
        begin
          sl.Add(sTmp);
          sTmp := '';
        end;
      end
      else
        sTmp := sTmp + s;
    end;
    sl.Add(sTmp);
    s := sl.Values[Element];
    if LeftStr(s, 1) = '"'  then s := RemoveLeft(s, 1);
    if RightStr(s, 1) = '"' then s := RemoveRight(s, 1);
    Result := s;
  finally
    sl.Free;
  end;
end;

end.
