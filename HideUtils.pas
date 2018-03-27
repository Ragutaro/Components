unit HideUtils;
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.WinInet, System.StrUtils, Winapi.ShlObj, Winapi.ImageHlp,
  Winapi.ShellAPI, Vcl.StdCtrls, System.UITypes, System.Notification,
  System.Win.Registry, System.Masks, VCL.Themes, System.IOUtils,
  InputBoxEx, untShowMessage, MsgDlg;

  type TFileSizeSegment = (fsB, fsKB, fsMB, fsGB, fsTB, fsAuto);
  type TInputBoxOptions = set of (ibFileName, ibConvert);

  function ConvertToValidFileName(AFileName: String): String;
  function GetFileSize(const Filename: String): UInt64;
  function FormatFileSize(const AFileSize: UInt64; ASegment: TFileSizeSegment = fsKB): String;
  function GetFileSizeString(const Filename: String; ASegment: TFileSizeSegment = fsKB): String;
  function GetFolderSize(const ADir,AMask:string; const AAttr:Integer; const ASubFolders:Boolean): Integer;
  function FileExistsByWildCard(const Filename: String): Boolean;
  function ConvertJapaneseDateToYYYMMDD(const JPDate: String): String;
  function DownloadFile(URL, SaveDir: String): Boolean;
  function DownloadFileAsNewName(URL, SaveDir, NewName: String): Boolean;
  function DownloadHttp(const URL: String; ms: TMemoryStream): Boolean;
  function DownloadHttpToStringList(const URL: String; sl: TStringList; EncodeType: TEncoding): Boolean;
  function DownloadHttpToStringListProxy(const URL, sProxtServer, sPort: String; sl: TStringList; EncodeType: TEncoding): Boolean;
  function CopyStrEx(Source: String; const StrFrom, StrTo: String; StartIndex: Integer; IgnoreCase: Boolean=False): String;
  function CopyStr(Source: String; const StrFrom, StrTo: String; IgnoreCase: Boolean=False): String;
  function CopyStrToEnd(Source: String; const StrFrom: String; IgnoreCase: Boolean=False): String;
  function CopyStrToStr(Source: String; const StrTo: String; IgnoreCase: Boolean=False): String;
  function CopyStrNext(Source: String; const StrFrom, StrTo: String; Include: Integer=1): String;
  function CopyStrFromN(Source: String; const StrFrom, StrTo: String; n: Integer=2): String;
  function RemoveStringFromAtoB(S, sFrom, sTo : String; IgnoreCase: Boolean=False): String;
  function RemoveStringFromA(const S, sFrom: String): String;
  function RemoveHTMLTags(S: String; IsTrim: Boolean = True): String;
  function RemoveRight(const S: String; const Count: Integer): String;
  function RemoveLeft(const S: String; const Count: Integer): String;
  function GetWeeklyJapaneseName(const dDate: TDate; const bShortName: Boolean): String;
  function ExtractStringsFromAtoB(const Source, FromStr, ToStr: String): String;
  function ExtractHTMLElements(const Source: String): String;
  function ExtractSelectedChar(const Source, SelectedChar: String): String;
  function EraseSpace(const S: String): String;
  function EraseNumber0to9(const S: String): String;
  function EraseString(Source, EraseChar: String): String;
  procedure SplitByString(S: String; const delimiter: String; var sl: TStringList);
  function MakeRelativePath(const S: String; const BaseName: String = ''): String;
  procedure SplitStringsToAandB(const Source, Token: String; var s1, s2: String);
  function ReplaceAtoB(sSource, sStart, sEnd, sReplace:String): String;
  function ReplaceAtoBEx(sSource: String; AFromValue, AEndValue, AReplaceValue: array of String): String;
  function ExtractNumber(const S: String; ContainPlus, ContainMinus: Boolean): String; overload;
  function ExtractNumber(const S: String): String; overload;
  function StrToIntDefEx(const S: String; Default: Integer): Integer;
  function StrToIntEx(const S: String): Integer;
  function ExtractFileBody(s: String): String;
  procedure CopyFile(AFromName, AToName: String);
  procedure CopyFolder(AFromFolder, AToFolder: String; ShowProgress: Boolean = False);
  procedure DeleteFolder(FolderPath: String; ShowProgress: Boolean = False);
  procedure DeleteFile(FilePath: String; ShowProgress: Boolean = False);
  function  DeletedFile(FilePath: String; ShowProgress: Boolean = False): Boolean;
  procedure MoveFolder(AFromDir, AToDir: String);
  procedure RenameFile(AFromName, AToName: String);
  procedure RenameFiles(AFromName, AToName: String);
  procedure RenameFolder(AFromName, AToName: String);
  procedure CreateFolder(AFolder: String);
  procedure CreateFile(FilePath: String);
  function CountStrings(SubStr: String; Source: String; IgnoreCase: Boolean = False): Integer;
  function ConvertMBENtoSBENW(const s: String): String;
  function WideExtractLastDirectory(const FilePath: String): String;
  function PosText(substr, str: String): Integer;
  function PosTextEx(substr, str: String; Offset: Integer): Integer;
  function PosBackText(substr, str: String): Integer;
  function RightStr(const AText, ASubstr: String): string; overload;
  function LeftStr(const AText, ASubstr: String): string; overload;
  function ReplaceTextEx(const AText: String; AFromValues, AToValues: array of String): String;
  function GetStringsFromDll(const DllFile, ProcName: String): String;
  function IndexOfText(const Substr: string; const AValues: array of string; AExactMatch: Boolean): Integer;
  function GetHtmlElement(const Source, Element: String): String;
  function ExtractFileNameFromUrl(const Url: String): String;
  function GetIniFileName: String;
  function GetSpecialFolderPath(const FolderName: Integer = CSIDL_DESKTOP): String;
  function GetDllFilePath: String;
  function StrDef(const S, DefaultStr: String): String;
  function ExtractParentPath(const FileName: String): String;
  function ExtractParentDir(const FileName: String): String;
  function TrimString(const Source: String; LeftCount: Integer = 1; RightCount: Integer = 1): String;
  procedure ShellExecuteSimple(const FileName: String);
  function GetFileVersion(GetType: String = 'FileVersion'): String;
  function ContainsTextInStringList(AStrings: TStringList; const ASubText: string): Boolean;
  function ContainsTextIndexInStringList(AStrings: TStringList; const ASubText: string): Integer;
  function IsValidFileName(const Filename: String): Boolean;
  function IsFileOpend(const Filename: String): Boolean;
  function RemoveFileExt(const Filename: String): String;
  function FindFile(const FindName: String): String;
  procedure ShowNotification(Sender: TNotificationCenter; const sName, sTitle, sAlertBody: String);
  function GetApplicationPath: String;
  procedure WriteIEVersionToRegistry;
  procedure GetFiles(SearchPath, SearchPattern: String; AList: TStringList; SearchSubfolders: Boolean);
  procedure GetFolders(SearchPath, SearchPattern: String; AList: TStringList; SearchSubfolders: Boolean);
  function IsExistFile(Path: String; SearchPattern: array of string): Boolean; overload;
  function IsExistFile(Path: String; SearchPattern: array of string; FileRecord: TSearchRec): Boolean; overload;
  function IfThenColor(AValue: Boolean; ATrue: TColor; AFalse: TColor): TColor;
  function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer = 0): Integer; overload; inline;
  function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64 = 0): Int64; overload; inline;
  function IfThen(AValue: Boolean; const ATrue: UInt64; const AFalse: UInt64 = 0): UInt64; overload; inline;
  function IfThen(AValue: Boolean; const ATrue: Single; const AFalse: Single = 0.0): Single; overload; inline;
  function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double = 0.0): Double; overload; inline;
  function IfThen(AValue: Boolean; const ATrue: Extended; const AFalse: Extended = 0.0): Extended; overload; inline;
  procedure DisableVclStyles(Control : TControl;const ClassToIgnore:string='');
  function ConvertSBJPtoMBJP(Source: String): String;
  function HexToInt(const Hex: String): Integer;
  function FormatNumber(const S: String): String;
  function Quote(const S: String): String;
  function IsDebugMode: Boolean;
  function ContainsInteger(AInt: array of Integer; const ASubInt:Integer): Boolean; overload
  function DriveExists(Drive: Char): Boolean;
  function ContainsInteger(const ASubInt, AStartInt, AEndInt: Integer): Boolean; overload;
  function CheckInteger(const ASubInt, AMinInt, AMaxInt: Integer): Integer; overload;
  function CheckInteger(const ASubString: String; const AMinInt, AMaxInt: Integer): Integer; overload;

  procedure FileCopy(ASrcFile, ADstFile: String; overwrite: Boolean);
  procedure FileDelete(ASrcFile: String);
  procedure FileMove(AFromFile, AToFile: String);
  procedure FileRename(ASrcFile, ANewFile: String);
  procedure FileRecycle(ASrcFile: String);
  procedure FolderCopy(ASrcFolder, ADstFolder: String);
  procedure FolderDelete(ASrcFolder: String; DeleteSubFolder: Boolean);
  procedure FolderMove(AFromFolder, AToFolder: String);
  procedure FolderRename(ASrcFolder, ANewFolder: String);
  procedure FolderRecycle(ASrcFolder: String);
  procedure FolderCreate(ASrcName: String);

  procedure SetStringListLength(StringList: TStringList; Length: Integer);
  function GetWindowText(hWnd: THandle): String;  //あるウィンドウのテキストを取得する
  function InputBox(const ACaption, APrompt, ADefault: string; InputBoxOptions: TInputBoxOptions): string; overload;
  function InputBox(const ACaption, APrompt, ADefault: string): string; overload;

  procedure ShowMessage(const Msg: String; DlgType: TMsgDlgType; ACaption: String); overload;
  procedure ShowMessage(const Msg: String; DlgType: TMsgDlgType); overload;
  procedure ShowMessage(const Msg: String); overload;

  function MessageDlg(const Msg: String; DlgType: TMsgDlgType; ATitleStr: String; Buttons: TMsgDlgButtons): Integer; overload;
  function MessageDlg(const Msg: String; DlgType: TMsgDlgType; ATitleStr: String): Integer; overload;
  function MessageDlg(const Msg: String; DlgType: TMsgDlgType): Integer; overload;

const
  clHover = $00FFF3E5;
  clUneven = $00FEFAF8;

var
  HAS_INPUTBOX_VALUE : String;
  HAS_MESSAGEDLG_VALUE : Integer;

implementation

var
  WideCopyIndex : Integer;

function ConvertToValidFileName(AFileName: String): String;
const
  sInvalid : array[1..11] of String = ('\', '/', ';', ':', '*', '?', '<', '>', '|', ',', '"');
  sValid   : array[1..11] of String = ('￥', '／', '；', '：', '＊', '？', '＜', '＞', '｜', '，', '”');
var
  i : Integer;
begin
  Result := AFileName;
  for i := 1 to 11 do
  begin
    if Pos(sInvalid[i], AFileName) > 0 then
    begin
      Result := ReplaceText(Result, sInvalid[i], sValid[i]);
    end;
  end;
end;

function GetFileSize(const Filename: String): UInt64;
var
  sr : TSearchRec;
  iHnd : Integer;
begin
  iHnd := FindFirst(Filename, faAnyFile, sr);
  try
    if iHnd = 0 then
      Result := sr.Size
    else
      Result := 0;
  finally
    FindClose(sr);
  end;
end;

function FormatFileSize(const AFileSize: UInt64; ASegment: TFileSizeSegment = fsKB): String;
begin
  if ASegment = fsTB then
    Result := FormatFloat('#,##0.#', AFileSize / 1024000000000) + ' TB'
  else if ASegment = fsGB then
    Result := FormatFloat('#,##0.#', AFileSize / 1024000000) + ' GB'
  else if ASegment = fsMB then
    Result := FormatFloat('#,##0.#', AFileSize / 1024000) + ' MB'
  else if ASegment = fsKB then
    Result := FormatFloat('#,##0.#', AFileSize / 1024) + ' KB'
  else if ASegment = fsB then
    Result := IntToStr(AFileSize) + ' B'
  else if ASegment = fsAuto then
  begin
    if AFileSize div 1024000000000 > 0 then
      Result := FormatFloat('#,##0.#', AFileSize / 1024000000000) + ' TB'
    else if AFileSize div 1024000000 > 0 then
      Result := FormatFloat('#,##0.#', AFileSize / 1024000000) + ' GB'
    else if AFileSize div 1024000 > 0 then
      Result := FormatFloat('#,##0.#', AFileSize / 1024000) + ' MB'
    else if AFileSize div 1024 > 0 then
      Result := FormatFloat('#,##0.#', AFileSize / 1024) + ' KB'
    else
      Result := IntToStr(AFileSize) + ' B';
  end;
end;

function GetFileSizeString(const Filename: String; ASegment: TFileSizeSegment = fsKB): String;
var
  iSize : Integer;
begin
  iSize := GetFileSize(Filename);
  Result := FormatFileSize(iSize, ASegment);
end;

function GetFolderSize(const ADir,AMask:string; const AAttr:Integer; const ASubFolders:Boolean): Integer;
var
  FDir:string;
  FAttr,FRes,FSize:Integer;
  FFile:TSearchRec;
begin
  FSize := 0;
  FAttr := AAttr;
  if not IsDelimiter('\', ADir, Length(ADir)) then
    FDir := ADir + '\'
  else
    FDir := ADir;
  FRes := FindFirst(FDir+AMask, FAttr, FFile);
  if FRes = 0 then
  begin
    try
      repeat
        if (FFile.Attr and faDirectory) > 0 then
        begin
          if (FFile.Name[1] <> '.') and ASubFolders then
            FSize := FSize + GetFolderSize(FDir+FFile.Name, AMask, FAttr, ASubFolders);
        end else
        begin
          FSize := FSize + FFile.Size;
        end;
        FRes := FindNext(FFile);
      until FRes <> 0;
    finally
      FindClose(FFile);
    end;
  end;
  Result := FSize;
end;

function FileExistsByWildCard(const Filename: String): Boolean;
const
  faFile = System.SysUtils.faReadOnly or System.SysUtils.faHidden or
           System.SysUtils.faSysFile or System.SysUtils.faArchive or
           System.SysUtils.faNormal;
var
  sr: TSearchRec;
begin
  try
    result := (FindFirst(FileName, faFile, sr) = 0);
  finally
    FindClose(sr);
  end;
end;

//日本式の日付「YYYY年MM月DD日」を「YYYY/MM/DD」に変換する
function ConvertJapaneseDateToYYYMMDD(const JPDate: String): String;
var
  sTmp : String;
begin
  sTmp := ReplaceText(JPDate, '年', '/');
  sTmp := ReplaceText(sTmp, '月', '/');
  Result := ReplaceText(sTmp, '日', '');
end;

function GetHtmlToMemoryStreamPROXY(sUrl, sProxySever, sPort: String; ms: TMemoryStream): Boolean;
var
  hOpen, hURL : HINTERNET;
  pBuf : pointer;
  ReadBytes : DWORD;
  iTimeOut : Integer;
begin
  Result := False;
  hOpen := InternetOpen('HaS', INTERNET_OPEN_TYPE_PROXY, PWideChar(Format('%s:%s', [sProxySever, sPort])), nil, 0);
  if Assigned(hOpen) then
  begin
    //タイムアウトの設定  10秒
    iTimeOut := 10 * 1000;
    InternetSetOption(hOpen, INTERNET_OPTION_RECEIVE_TIMEOUT, @iTimeOut, SizeOf(iTimeOut));
    hURL := InternetOpenUrl(hOpen, PWideChar(sURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if Assigned(hURL) then
    begin
      Result := True;
      GetMem(pBuf, 1024);
      ms.Position := 0;
      try
        repeat
          InternetReadFile(hURL, pBuf, 1024, ReadBytes);
          ms.Write(pBuf^, ReadBytes);
        until ReadBytes = 0;
      finally
        FreeMem(pBuf);
      end;
      ms.Position := 0;
    end;
    InternetCloseHandle(hURL);
  end;
  InternetCloseHandle(hOpen);
end;

function GetHtmlToMemoryStream(sUrl: String; ms: TMemoryStream): Boolean;
var
  hOpen, hURL : HINTERNET;
  pBuf : pointer;
  ReadBytes : DWORD;
  iTimeOut : Integer;
begin
  Result := False;
  hOpen := InternetOpen('HaS', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
  if Assigned(hOpen) then
  begin
    //タイムアウトの設定  10秒
    iTimeOut := 10 * 1000;
    InternetSetOption(hOpen, INTERNET_OPTION_RECEIVE_TIMEOUT, @iTimeOut, SizeOf(iTimeOut));
    hURL := InternetOpenUrl(hOpen, PWideChar(sURL), nil, 0, INTERNET_FLAG_RELOAD, 0);
    if Assigned(hURL) then
    begin
      Result := True;
      GetMem(pBuf, 1024);
      ms.Position := 0;
      try
        repeat
          InternetReadFile(hURL, pBuf, 1024, ReadBytes);
          ms.Write(pBuf^, ReadBytes);
        until ReadBytes = 0;
      finally
        FreeMem(pBuf);
      end;
      ms.Position := 0;
    end;
    InternetCloseHandle(hURL);
  end;
  InternetCloseHandle(hOpen);
end;

function DownloadFile(URL, SaveDir: String): Boolean;
var
  ms : TMemoryStream;
  sName : String;
begin
  ms := TMemoryStream.Create;
  try
    Result := False;
    if GetHtmlToMemoryStream(URL, ms) then
    begin
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
      end;
    end;
  finally
    ms.Free;
  end;
end;

function DownloadFileAsNewName(URL, SaveDir, NewName: String): Boolean;
var
  ms : TMemoryStream;
begin
  ms := TMemoryStream.Create;
  try
    Result := False;
    if GetHtmlToMemoryStream(URL, ms) then
    begin
      if ms.Size > 0 then
      begin
        if RightStr(SaveDir, 1) <> '\' then
          SaveDir := SaveDir + '\';
        CreateDir(SaveDir);
        ms.Position := 0;
        ms.SaveToFile(SaveDir + NewName);
        Result := True;
      end;
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
  Result := False;
  ms := TMemoryStream.Create;
  try
    try
      if GetHtmlToMemoryStream(URL, ms) then
      begin
        if ms.Size > 0 then
        begin
          ms.Position := 0;
          sl.LoadFromStream(ms, EncodeType);
          Result := True;
        end else
          Result := False;
      end;
    except
      Result := False;
      MessageDlg('Error : HideUtils.DownloadHttpToStringList', mtWarning, '', [mbOK]);
    end;
  finally
    ms.Free;
  end;
end;

function DownloadHttpToStringListProxy(const URL, sProxtServer, sPort: String; sl: TStringList; EncodeType: TEncoding): Boolean;
//  EncodeType  取得するページの文字コードに合わせる
var
  ms : TMemoryStream;
begin
  Result := False;
  ms := TMemoryStream.Create;
  try
    if GetHtmlToMemoryStreamPROXY(URL, sProxtServer, sPort, ms) then
    begin
      if ms.Size > 0 then
      begin
        ms.Position := 0;
        sl.LoadFromStream(ms, EncodeType);
        Result := True;
      end else
        Result := False;
    end;
  finally
    ms.Free;
  end;
end;

//  StrFrom     : 抜き出す文字列の開始文字列
//  StrTo       : 抜き出す文字列の終了文字列。結果には含まれない。
//  StartIndex  : 検索を開始する Index値
//  IgnoreCase  : 大文字小文字を区別するか否か
function CopyStrEx(Source: String; const StrFrom, StrTo: String; StartIndex: Integer; IgnoreCase: Boolean=False): String;
var
  i : Integer;
begin
  Result := '';
  for i := 1 to StartIndex -1 do
  begin
    Source[i] := '*';
  end;
  Result := CopyStr(Source, StrFrom, StrTo, IgnoreCase);
end;

function CopyStr(Source: String; const StrFrom, StrTo: String; IgnoreCase: Boolean=False): String;
var
  sTmp : String;
  iStart, iEnd : Integer;
begin
  Result := '';
  sTmp := Source;
  Case IgnoreCase of
    True:
      begin
        iStart := PosText(StrFrom, sTmp);
        WideCopyIndex := iStart;
        if iStart > 0 then
        begin
          repeat
            if StrTo = '' then
              iEnd := Length(sTmp)
            else
            begin
              iEnd := PosText(StrTo, sTmp);
              if iEnd <= 0 then
                iEnd := MaxInt
              else
                sTmp[iEnd] := '*';
            end;
          until iEnd > iStart;
          Result := Copy(Source, iStart, iEnd - iStart);
        end;
      end;
    False :
      begin
        iStart := Pos(StrFrom, sTmp);
        WideCopyIndex := iStart;
        if iStart > 0 then
        begin
          repeat
            if StrTo = '' then
              iEnd := Length(sTmp)
            else
            begin
              iEnd := Pos(StrTo, sTmp);
              if iEnd <= 0 then
                iEnd := MaxInt
              else
                sTmp[iEnd] := '*';
            end;
          until iEnd > iStart;
          Result := Copy(Source, iStart, iEnd - iStart);
        end;
      end;
  end;
end;

function CopyStrToEnd(Source: String; const StrFrom: String; IgnoreCase: Boolean=False): String;
var
  iStart : Integer;
begin
  iStart := 0;
  Result := '';
  Case IgnoreCase of
    True : iStart := PosText(StrFrom, Source);
    False: iStart := Pos(StrFrom, Source);
  end;
  if iStart = 0 then
    Exit;

  Result := Copy(Source, iStart, MaxInt);
  Source[iStart+1] := '/';
end;

function CopyStrToStr(Source: String; const StrTo: String; IgnoreCase: Boolean=False): String;
var
  iEnd : Integer;
begin
  iEnd := 0;
  Result := '';
  Case IgnoreCase of
    True : iEnd := PosText(StrTo, Source);
    False: iEnd := Pos(StrTo, Source);
  end;
  if iEnd = 0 then
  begin
    iEnd := MaxInt;
  end;
  Result := Copy(Source, 0, iEnd);
end;

function CopyStrNext(Source: String; const StrFrom, StrTo: String; Include: Integer=1): String;
var
  iPos : Integer;
begin
  iPos := Pos(StrFrom, Source);
  Result := CopyStrEx(Source, StrFrom, StrTo, iPos + Include);
end;

function CopyStrFromN(Source: String; const StrFrom, StrTo: String; n: Integer=2): String;
var
  i, iPos : Integer;
begin
  iPos := 0;
  for i := 1 to n do
  begin
    iPos := PosEx(StrFrom, Source, iPos+1);
    if iPos = 0 then
      Result := ''
    else
      Result := CopyStrEx(Source, StrFrom, StrTo, iPos);
  end;
end;

function RemoveStringFromAtoB(S, sFrom, sTo : String; IgnoreCase: Boolean=False): String;
var
  i, iStart, iEnd : Integer;
begin
  iStart := 0;
  repeat
    iEnd := 0;
    Case IgnoreCase of
      True : iStart := PosText(sFrom, S);
      False: iStart := Pos(sFrom, S);
    end;
    if iStart <> 0 then
    begin
      for i := iStart to MaxInt do
      begin
        if S[i] = sTo then
        begin
          iEnd := i;
          Break;
        end;
      end;
    end;
    Delete(S, iStart, iEnd - iStart +1);
  until iStart = 0;
  Result := S;
end;

function RemoveStringFromA(const S, sFrom: String): String;
var
  iPos : Integer;
begin
//  sFrom が文字列Sに存在しない場合は、元の文字列Sをそのまま返す。
//  存在する場合は、sFrom以下を削除した文字列を返す。
  iPos := Pos(sFrom, S);
  if iPos > 0 then
    Result := Copy(S, 1, iPos-1)
  else
    Result := S;
end;

function RemoveHTMLTags(S: String; IsTrim: Boolean = True): String;
begin
	Result := RemoveStringFromAtoB(S, '<', '>');
  if IsTrim then
    Result := Trim(Result);
end;

function RemoveRight(const S: String; const Count: Integer): String;
begin
  Result := Copy(S, 1, Length(S)-Count);
end;

function RemoveLeft(const S: String; const Count: Integer): String;
begin
  Result := Copy(S, Count+1, MaxInt);
end;

function GetWeeklyJapaneseName(const dDate: TDate; const bShortName: Boolean): String;
const
  sShortName : array[1..7] of String = ('日', '月', '火', '水', '木', '金', '土');
  sLongName  : array[1..7] of String = ('日曜日', '月曜日', '火曜日', '水曜日', '木曜日', '金曜日', '土曜日');
begin
  Case bShortName of
    True :  Result := sShortName[DayOfWeek(dDate)];
    False : Result := sLongName[DayOfWeek(dDate)];
  end;
end;

function ExtractStringsFromAtoB(const Source, FromStr, ToStr: String): String;
var
  iStart, iEnd : Integer;
begin
  Result := '';
  iStart := Pos(FromStr, Source);
  iEnd := Pos(ToStr, Source, iStart + 1);
  if iStart <> 0 then
    Result := Copy(Source, iStart, iEnd - iStart + 1);
end;

function ExtractHTMLElements(const Source: String): String;
begin
  Result := RemoveLeft(ExtractStringsFromAtoB(Source, '<', '>'), 1);
end;

function ExtractSelectedChar(const Source, SelectedChar: String): String;
var
  i, iCount : Cardinal;
  sTemp : String;
begin
  iCount := 0;
  sTemp := StringOfChar(' ', Length(Source));
  for i := 1 to Length(Source) do
  begin
    if Pos(Source[i], SelectedChar) > 0 then
    begin
      Inc(iCount);
      sTemp[iCount] := Source[i];
    end;
  end;
  Result := Trim(sTemp);
end;

function EraseString(Source, EraseChar: String): String;
var
  i : Integer;
  sTmp : String;
begin
  for i := 1 to Length(Source) do
  begin
    if Not ContainsText(EraseChar, Source[i]) then
      sTmp := sTmp + Source[i];
  end;
  Result := sTmp;
end;

function EraseSpace(const S: String): String;
begin
  Result := EraseString(S, ' 　');  //全角と半角のスペース
end;

function EraseNumber0to9(const S: String): String;
begin
  Result := EraseString(S, '0123456789');
end;

procedure SplitByString(S: String; const delimiter: String; var sl: TStringList);
var
  iPos, iSubLength : Integer;
begin
  sl.Clear;
  iSubLength := Length(delimiter);
  while Pos(delimiter, S) <> 0 do
  begin
    iPos := Pos(delimiter, S);
    sl.Add(Copy(S, 1, iPos-1));
    S := Copy(S, iPos+iSubLength, MaxInt);
  end;
  sl.Add(S);
end;

function MakeRelativePath(const S: String; const BaseName: String = ''): String;
var
  sAppPath : String;
begin
//  BaseName = '' の時、実行ファイルのパスを指定する。
  if BaseName = '' then
    sAppPath := ExtractFilePath(Application.ExeName)
  else
  begin
    if RightStr(BaseName, 1) <> '\' then
      sAppPath := BaseName + '\'
    else
      sAppPath := BaseName;
  end;
  Result := ExtractRelativePath(sAppPath, S);
end;

procedure SplitStringsToAandB(const Source, Token: String; var s1, s2: String);
var
  iStart : Integer;
begin
  s1 := ''; s2 := '';
  iStart := Pos(Token, Source);
  if iStart > 0 then
  begin
    s1 := LeftStr(Source, iStart-1);
    s2 := Copy(Source, iStart+Length(Token), MaxInt);
  end;
end;

function ReplaceAtoB(sSource, sStart, sEnd, sReplace:String): String;
var
  iStart, iEnd : Integer;
  sBefor, sAfter : String;
begin
  repeat
    iStart := Pos(sStart, sSource);
    if iStart > 0 then
    begin
      iEnd := PosEx(sEnd, sSource, iStart+1);
      if iEnd = 0 then
      begin
        Result := sSource;
        Exit;
      end
      else
      begin
        sBefor := LeftStr(sSource, iStart-1);
        sAfter := Copy(sSource, iEnd+1, MaxInt);
        sSource := sBefor + sReplace + sAfter;
      end;
    end;
  until iStart = 0;
  Result := sSource;
end;

function ReplaceAtoBEx(sSource: String; AFromValue, AEndValue, AReplaceValue: array of String): String;
var
  i : Integer;
begin
  for i := low(AFromValue) to high(AFromValue) do
  begin
    sSource := ReplaceAtoB(sSource, AFromValue[i], AEndValue[i], AReplaceValue[i]);
  end;
  Result := sSource;
end;

function ExtractNumber(const S: String; ContainPlus, ContainMinus: Boolean): String; overload;
var
  i : Integer;
  Num, sTmp : String;
begin
  sTmp := '';

  NUM := '0123456789';
  if ContainPlus and ContainMinus then
    NUM := NUM + '+-'
  else if ContainPlus then
    NUM := NUM + '+'
  else if ContainMinus then
    NUM := NUM + '-';

  for i := 1 to Length(S) do
  begin
    if Pos(S[i], NUM) > 0 then
      sTmp := sTmp + S[i];
  end;
  Result := sTmp;
end;

function ExtractNumber(const S: String): String; overload;
begin
  Result := ExtractNumber(S, False, False);
end;

function StrToIntDefEx(const S: String; Default: Integer): Integer;
const
  NUMBER = '0123456789-';
var
  i, iCount : Cardinal;
  temp : String;
begin
  iCount := 1;
  temp := StringOfChar(' ', Length(S));
  for i := 1 to Length(S) do
  begin
    if AnsiPos(S[i], NUMBER) > 0 then
    begin
      temp[iCount] := S[i];
      Inc(iCount);
    end;
  end;
  Result := StrToIntDef(Trim(temp), Default);
end;

function StrToIntEx(const S: String): Integer;
const
  NUMBER = '0123456789-';
var
  i, iCount : Cardinal;
  temp : String;
begin
  iCount := 1;
  temp := StringOfChar(' ', Length(S));
  for i := 1 to Length(S) do
  begin
    if AnsiPos(S[i], NUMBER) > 0 then
    begin
      temp[iCount] := S[i];
      Inc(iCount);
    end;
  end;
  Result := StrToInt(Trim(temp));
end;

function ExtractFileBody(s: String): String;
begin
  Result := ChangeFileExt(ExtractFileName(s), '');
end;

procedure CopyFile(AFromName, AToName: String);
var
  sh : TSHFileOpStructW;
begin
  with sh do
  begin
    Wnd   := Application.Handle;
    wFunc := FO_COPY;
    pFrom := PWideChar(AFromName + #0);
    pTo   := pwidechar(AToName + #0);
    fFlags:= FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOERRORUI;
  end;
  SHFileOperationW(sh);
end;

procedure CopyFolder(AFromFolder, AToFolder: String; ShowProgress: Boolean = False);
var
  sh : TSHFileOpStructW;
begin
  if RightStr(AFromFolder, 1) <> '\' then
    AFromFolder := AFromFolder + '\';
  if RightStr(AToFolder, 1) <> '\' then
    AToFolder := AToFolder + '\';

  with sh do
  begin
    Wnd   := Application.Handle;
    wFunc := FO_COPY;
    pFrom := PChar(AFromFolder + #0#0);
    pTo   := PChar(AToFolder + #0#0);
    if ShowProgress then
      fFlags:= FOF_ALLOWUNDO or FOF_NOERRORUI
    else
      fFlags:= FOF_ALLOWUNDO or FOF_SILENT or FOF_NOERRORUI;
  end;
  SHFileOperationW(sh);
end;

procedure DeleteFolder(FolderPath: String; ShowProgress: Boolean = False);
var
  sh : TSHFileOpStructW;
begin
  if RightStr(FolderPath, 1) = '\' then
    FolderPath := Copy(FolderPath, 1, Length(FolderPath)-1);

  if DirectoryExists(FolderPath) then
  begin
    with sh do
    begin
      Wnd   := Application.Handle;
      wFunc := FO_DELETE;
      pFrom := PChar(FolderPath + #0);
      pTo   := nil;
      if ShowProgress then
        fFlags:= FOF_MULTIDESTFILES or FOF_ALLOWUNDO or FOF_NOERRORUI
      else
        fFlags:= FOF_MULTIDESTFILES or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOERRORUI;
    end;
    SHFileOperationW(sh);
  end;
end;

procedure DeleteFile(FilePath: String; ShowProgress: Boolean = False);
var
  sh : TSHFileOpStructW;
begin
  with sh do
  begin
    Wnd   := Application.Handle;
    wFunc := FO_DELETE;
    pFrom := PChar(FilePath + #0);
    pTo   := nil;
    if ShowProgress then
      fFlags:= FOF_MULTIDESTFILES or FOF_ALLOWUNDO or FOF_NOERRORUI
    else
      fFlags:= FOF_NOCONFIRMATION or FOF_MULTIDESTFILES or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOERRORUI;
  end;
  SHFileOperationW(sh);
end;

procedure MoveFolder(AFromDir, AToDir: String);
var
  sh : TSHFileOpStructW;
begin
  if RightStr(AFromDir, 1) = '\' then
    AFromDir := RemoveRight(AFromDir, 1);

  if RightStr(AToDir, 1) = '\' then
    AFromDir := RemoveRight(AToDir, 1);

  if DirectoryExists(AFromDir) then
  begin
    with sh do
    begin
      Wnd   := Application.Handle;
      wFunc := FO_MOVE;
      pFrom := PChar(AFromDir + #0);
      pTo   := PChar(AToDir + #0);
      fFlags:= FOF_MULTIDESTFILES or FOF_NOCONFIRMMKDIR or FOF_SILENT;
    end;
    SHFileOperationW(sh);
  end;
end;

procedure RenameFile(AFromName, AToName: String);
var
  sh : TSHFileOpStructW;
begin
  if RightStr(AFromName, 1) = '\' then
    Exit;

  if FileExists(AFromName) and (Not FileExists(AToName)) then
  begin
    with sh do
    begin
      Wnd   := Application.Handle;
      wFunc := FO_MOVE;
      pFrom := PChar(AFromName + #0);
      pTo   := PChar(AToName + #0);
      fFlags:= FOF_SILENT or FOF_NOCONFIRMMKDIR or FOF_NOCONFIRMATION;
    end;
    SHFileOperationW(sh);
  end;
end;

procedure RenameFiles(AFromName, AToName: String);
var
  sr : TSearchRec;
  sFromDir, sToDir, sFromBody, sToBody, sExt : String;
begin
  sFromDir := ExtractFilePath(AFromName);
  sToDir := ExtractFilePath(AToName);
  sFromBody := ExtractFileBody(AFromName);
  sToBody := ExtractFileBody(AToName);
  if FindFirst(sFromDir + sFromBody + '.*', faAnyFile, sr) = 0 then
  begin
    repeat
      sExt := ExtractFileExt(sr.Name);
      if FileExists(sFromDir + sr.Name) then
        RenameFile(sFromDir + sr.Name, sToDir + sToBody + sExt);
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;
end;

procedure RenameFolder(AFromName, AToName: String);
var
  sh : TSHFileOpStructW;
begin
  if RightStr(AFromName, 1) <> '\' then
    AFromName := AFromName + '\';
  if RightStr(AToName, 1) <> '\' then
    AToName := AToName + '\';

  if DirectoryExists(AFromName) then
  begin
    with sh do
    begin
      Wnd   := Application.Handle;
      wFunc := FO_RENAME;
      pFrom := PChar(AFromName + #0#0);
      pTo   := PChar(AToName + #0#0);
      fFlags:= FOF_SILENT;
    end;
    SHFileOperationW(sh);
  end;
end;

procedure CreateFolder(AFolder: String);
begin
  if RightStr(AFolder, 1) = '\' then
    AFolder := RemoveRight(AFolder, 1);
  ForceDirectories(AFolder);
end;

procedure CreateFile(FilePath: String);
var
  iHandle : Integer;
begin
  iHandle := FileCreate(FilePath);
  FileClose(iHandle);
end;

function CountStrings(SubStr: String; Source: String; IgnoreCase: Boolean = False): Integer;
var
  iPos : Integer;
begin
  Result := 0;

  if IgnoreCase then
  begin
    SubStr := UpperCase(SubStr);
    Source := UpperCase(Source);
  end;

  repeat
    iPos := Pos(SubStr, Source);
    if iPos > 0 then
    begin
      Inc(Result);
      Source[iPos] := '*';
    end;
  until iPos = 0;
end;

function ConvertMBENtoSBENW(const s: String): String;
  function Conv(const Str: String; LCMAP: Cardinal): String;
  var
    Len : Integer;
  begin
    Result := '';
    Len := Length(Str);
    SetLength(Result, Len);
    LCMapString(GetUserDefaultLCID, LCMAP, PWideChar(Str), Len+1, PWideChar(Result), Len+1);
  end;

const
  WideENG : String =
    'ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ' +
    'ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚ' +
    '１２３４５６７８９０－' +
    '，．／＜＞？＿！”＃＄％＆’（）＠｀［］｛｝；＋：＊￥｜＝～';
var
  sTmp : String;
  i : Integer;
begin
  sTmp := '';
  for i := 1 to Length(s) do
  begin
    if AnsiPos(s[i], WideENG) > 0 then
      sTmp := sTmp + Conv(s[i], LCMAP_HALFWIDTH)
    else
      sTmp := sTmp + s[i];
  end;
  Result := ReplaceText(sTmp, '　', ' ');
end;

function PosText(substr, str: String): Integer;
begin
  substr := LowerCase(substr);
  str := LowerCase(str);
  Result := Pos(substr, str);
end;

function PosTextEx(substr, str: String; Offset: Integer): Integer;
begin
  substr := LowerCase(substr);
  str := LowerCase(str);
  Result := PosEx(substr, str, Offset);
end;

function PosBackText(substr, str: String): Integer;
var
  iPos : Integer;
begin
//  Result := 0;
  iPos := PosText(substr, str);
  repeat
    Result := iPos;
    iPos := PosTextEx(substr, str, iPos+1);
  until iPos = 0;
end;

function RightStr(const AText, ASubstr: String): string; overload;
var
  iPos : Integer;
begin
  iPos := PosBackText(ASubstr, AText);
  if iPos = 0 then
    Result := ''
  else
    Result := MidStr(AText, iPos, MaxInt);
end;

function LeftStr(const AText, ASubstr: String): string; overload;
var
  iPos : Integer;
begin
  iPos := PosBackText(ASubstr, AText);
  if iPos = 0 then
    Result := AText
  else
    Result := LeftStr(AText, iPos-1);
end;

function WideExtractLastDirectory(const FilePath: String): String;
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    SplitByString(FilePath, '\', sl);
    if ExtractFileExt(sl[sl.count-1]) = '' then
      Result := sl[sl.count-1]
    else
      Result := sl[sl.count-2];
  finally
    sl.Free;
  end;
end;

function ReplaceTextEx(const AText: String; AFromValues, AToValues: array of String): String;
var
  i : Integer;
begin
  Result := AText;
  if High(AFromValues) <> High(AToValues) then
    ShowMessage('置換前文字列配列と置換後文字列配列の要素数が異なっています。')
  else
  begin
    for i := Low(AFromValues) to High(AFromValues) do
      Result := ReplaceText(Result, AFromValues[i], AToValues[i]);
  end;
end;

function IsValidFileName(const Filename: String): Boolean;
ResourceString
  m1 = 'はフォルダ名またはファイル名に使用できません。';
  m2 = 'はWindowsの予約語ですので使用できません。';
const
  sReserved : array[1..23] of String = ('CON', 'PRN', 'AUX', 'NUL',
                                        'COM1', 'COM2', 'COM3', 'COM4', 'COM5', 'COM6', 'COM7', 'COM8', 'COM9',
                                        'LPT1', 'LPT2', 'LPT3', 'LPT4', 'LPT5', 'LPT6', 'LPT7', 'LPT8', 'LPT9',
                                        'CLOCK$');
  sInvalid : array[1..11] of String = ('\', '/', ';', ':', '*', '?', '<', '>', '|', ',', '"');
var
  i : Integer;
begin
  Result := True;

  if Filename = '' then
  begin
    Result := False;
  	Exit;
  end;

  //使用可能な文字か
  for i := 1 to 11 do
  begin
    if Pos(sInvalid[i], Filename) > 0 then
    begin
      MessageDlg(sInvalid[i] + m1, mtWarning, '使用できない文字です', [mbOK]);
      Result := False;
      Exit;
    end;
  end;

  //システムの予約語か否か
  for i := 1 to 23 do
  begin
    if Pos(sReserved[i], Filename) > 0 then
    begin
      MessageDlg(sReserved[i] + m2, mtWarning, '使用できない文字です', [mbOK]);
      Result := False;
      Exit;
    end;
  end;
end;
//
//function  WideRemoveExtention(const S: String): String;
//begin
//  Result := WideChangeFileExt(S, '');
//end;
//
//function AvoideDivZero(const AValue, ADiv: Extended): Extended;
//begin
//  if ADiv = 0 then
//    Result := AValue / 1
//  else
//    Result := AValue / ADiv;
//end;
//
////閉じるボタンの有効無効
////hHandle には TForm.Handle を指定
//procedure SetCloseButtonToDisable(hHandle: HWND);
//var
//  hMenuHandle : HMENU;
//begin
//  hMenuHandle := GetSystemMenu(hHandle, False);
//  if hMenuHandle <> 0 then
//  begin
//    EnableMenuItem(hMenuHandle, SC_CLOSE, (MF_BYCOMMAND or MF_DISABLED or MF_GRAYED));
//  end;
//  DrawMenuBar(hHandle);
//end;
//
//procedure SetCloseButtonToEnable(hHandle: HWND);
//var
//  hMenuHandle : HMENU;
//begin
//  hMenuHandle := GetSystemMenu(hHandle, False);
//  if hMenuHandle <> 0 then
//  begin
//    EnableMenuItem(hMenuHandle, SC_CLOSE, (MF_BYCOMMAND or MF_ENABLED));
//  end;
//  DrawMenuBar(hHandle);
//end;
//
function GetStringsFromDll(const DllFile, ProcName: String): String;
var
  _DLLFile: function: String;
  h: THandle;
  p1: TFarProc;
begin
  Result := '';
  _DLLFile := nil;

  if not FileExists(DllFile) then exit;

  h := LoadLibrary(PWideChar(DllFile));
  if not (h < HINSTANCE_ERROR) then
  begin
    p1 := GetProcAddress(h, PWideChar(ProcName));
    if p1 <> nil then
    begin
      @_DLLFile := p1;
    end;
    if p1 <> nil then
    begin
      Result := _DLLFile;
    end;
//    p1 := nil;
    FreeLibrary(h);
  end;
end;

function IndexOfText(const Substr: string; const AValues: array of string; AExactMatch: Boolean): Integer;
var
  i: Integer;
begin
  Result := -1;
  Case AExactMatch of
    True:
      begin
        for i := Low(AValues) to High(AValues) do
        begin
          if substr = AValues[i] then
          begin
            Result := i;
            Break;
          end;
        end;
      end;
    False:
      begin
        for i := Low(AValues) to High(AValues) do
        begin
          if ContainsText(AValues[i], substr) then
          begin
            Result := i;
            Break;
          end;
        end;
      end;
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

function ExtractFileNameFromUrl(const Url: String): String;
var
  sTmp : String;
begin
  sTmp := ReplaceText(Url, '/', '\');
  Result := ExtractFileName(sTmp);
end;

function GetIniFileName: String;
begin
  Result := ChangeFileExt(Application.ExeName, '.ini');
end;

function GetSpecialFolderPath(const FolderName: Integer = CSIDL_DESKTOP): String;
var
  pIdl: PItemIDList;
  Path: array[0..MAX_PATH] of char;
begin
  SHGetSpecialFolderLocation(Application.Handle, FolderName, pIdl);
  SHGetPathFromIDList(pIdl, Path);
  Result := Path;
end;

function GetDllFilePath: String;
var
  ModuleName: array[0..255] of WideChar;
begin
  GetModuleFileName(HInstance, ModuleName, Sizeof(ModuleName));
  Result := ModuleName;
end;

function StrDef(const S, DefaultStr: String): String;
begin
  if S <> '' then
    Result := S
  else
    Result := DefaultStr;
end;

function ExtractParentPath(const FileName: String): String;
begin
  Result := ExtractFileDir(FileName);
  Result := ExtractFilePath(Result);
end;

function ExtractParentDir(const FileName: String): String;
begin
  Result := ExtractParentPath(FileName);
  Result := RemoveRight(Result, 1);
end;

function TrimString(const Source: String; LeftCount: Integer = 1; RightCount: Integer = 1): String;
begin
  Result := RemoveLeft(Source, LeftCount);
  Result := RemoveRight(Result, RightCount);
end;

procedure ShellExecuteSimple(const FileName: String);
begin
  ShellExecuteW(Application.Handle, 'OPEN', PWideChar(FileName), nil, nil, SW_SHOW);
end;

function GetFileVersion(GetType: String = 'FileVersion'): String;
{
下記のコード中の"FileVersion"を以下に変更するとバージョン番号以外の情報も取得可能です。
会社名: "CompanyName"
説明  : "FileDescription"
内部名: "InternalName"
著作権: "LegalCopyright"
正式ファイル名: "OriginalFilename"
コメント: "Comment"
}
{
  この関数実行時にエラーが出る場合は、[プロジェクト]-[オプション]-[バージョン情報]-[言語]
  で [日本語]を選ぶ
}
var
  size, sizeFileInfo, ret: DWord;
  pData, pInfo:	Pointer;
  iLocaleId : Cardinal;
  sLocale, sCodePage : String;
begin
  iLocaleId := GetUserDefaultLCID;
  sLocale := IntToHex(iLocaleId, 4);
  iLocaleId := GetACP;
  sCodePage := IntToHex(iLocaleId, 4);

  size := GetFileVersionInfoSize(PWideChar(Application.ExeName), ret);
  GetMem(pData, size);
  try
    try
      Assert(GetFileVersionInfo(PWideChar(Application.Exename), 0, size, pData));
      Assert(VerQueryValue(pData, PWideChar('\StringFileInfo\' + sLocale + sCodePage + '\' + GetType), pInfo, sizeFileInfo));
      GetFileVersion := PWideChar(pInfo);
    except
      MessageDlg('バージョン情報取得時にエラーが発生しました。', mtWarning, '', [mbOK]);
    end;
  finally
    FreeMem(pData);
  end;
end;

function ContainsTextInStringList(AStrings: TStringList; const ASubText: string): Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := 0 to AStrings.Count-1 do
  begin
    if ContainsText(AStrings[i], ASubText) then
    begin
      Result := True;
      Break;
    end;
  end;
end;

function ContainsTextIndexInStringList(AStrings: TStringList; const ASubText: string): Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to AStrings.Count-1 do
  begin
    if ContainsText(AStrings[i], ASubText) then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function DeletedFile(FilePath: String; ShowProgress: Boolean = False): Boolean;
begin
  Result := False;
  if FileExists(FilePath) then
  begin
    try
      DeleteFile(FilePath);
      Result := True;
    except
      Result := False;
    end;
  end;
end;

function IsFileOpend(const Filename: String): Boolean;
var
  iHnd : Integer;
begin
  iHnd := FileOpen(Filename, fmOpenRead);
  try
    if iHnd = -1 then
      Result := True    //開かれている
    else
      Result := False;  //開かれていない
  finally
    FileClose(iHnd);
  end;
end;

function RemoveFileExt(const Filename: String): String;
var
  sPath, sName, sBody : String;
begin
  sPath := ExtractFilePath(Filename);
  sName := ExtractFileName(Filename);
  sBody := LeftStr(sName, '.');
  Result := sPath + sBody;
end;

function FindFile(const FindName: String): String;
var
  sr : TSearchRec;
begin
  if FindName = '' then
  begin
  	Result := '';
    Exit;
  end;

  try
    if FindFirst(FindName, faAnyFile, sr) = 0 then
      Result := ExtractFilePath(FindName) + sr.Name
    else
      Result := '';
  finally
    FindClose(sr);
  end;
end;

procedure ShowNotification(Sender: TNotificationCenter; const sName, sTitle, sAlertBody: String);
var
  n : TNotification;
begin
  n := Sender.CreateNotification;
  try
    n.Name := sName;
    n.Title := sTitle;
    n.AlertBody := sAlertBody;
    Sender.PresentNotification(n);
  finally
    n.Free;
  end;
end;

function GetApplicationPath: String;
begin
  //C:\Test\ の形で値が戻る
  Result := ExtractFilePath(Application.ExeName);
end;

procedure WriteIEVersionToRegistry;
var
  r : TRegistry;
begin
  r := TRegistry.Create;
  try
    r.RootKey := HKEY_CURRENT_USER;
    r.OpenKey('\Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION', False);
    r.WriteInteger(ExtractFileName(Application.ExeName), 11000);
  finally
    r.Free;
  end;
end;

procedure GetFiles(SearchPath, SearchPattern: String; AList: TStringList; SearchSubfolders: Boolean);
var
  m : TMask;
  sr : TSearchRec;
begin
  if RightStr(SearchPath, 1) <> '\' then
    SearchPath := SearchPath + '\';

  if FindFirst(SearchPath + '*.*', faAnyFile, sr) = 0 then
  begin
    m := TMask.Create(SearchPattern);
    try
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          if (sr.Attr and faDirectory > 0) then
          begin
            if SearchSubfolders then
              GetFiles(SearchPath + sr.Name, SearchPattern, AList, SearchSubfolders);
          end
          else
          begin
            if m.Matches(sr.Name) then
              AList.Add(SearchPath + sr.Name);
          end;
        end;
      until FindNext(sr) <> 0;
    finally
      FindClose(sr);
      m.Free;
    end;
  end;
end;

procedure GetFolders(SearchPath, SearchPattern: String; AList: TStringList; SearchSubfolders: Boolean);
var
  m : TMask;
  sr : TSearchRec;
begin
  if RightStr(SearchPath, 1) <> '\' then
    SearchPath := SearchPath + '\';

  if FindFirst(SearchPath + '*', faAnyFile, sr) = 0 then
  begin
    m := TMask.Create(SearchPattern);
    try
      repeat
        if (sr.Name <> '.') and (sr.Name <> '..') then
        begin
          if (sr.Attr and faDirectory > 0) then
          begin
            if m.Matches(sr.Name) then
              AList.Add(SearchPath + sr.Name);
            if SearchSubfolders then
              GetFolders(SearchPath + sr.Name, SearchPattern, AList, SearchSubfolders);
          end;
        end;
      until FindNext(sr) <> 0;
    finally
      FindClose(sr);
      m.Free;
    end;
  end;
end;

function IsExistFile(Path: String; SearchPattern: array of string; FileRecord: TSearchRec): Boolean; overload;
var
  sr : TSearchRec;
  i : Integer;
begin
  if RightStr(Path, 1) <> '\' then
    Path := Path + '\';

  Result := False;
  for i := 0 to High(SearchPattern) do
  begin
    if FindFirst(Path + SearchPattern[i], faAnyFile, sr) = 0 then
    begin
    	Result := True;
      FileRecord := sr;
      Break;
    end;
    FindClose(sr);
  end;
end;

function IsExistFile(Path: String; SearchPattern: array of string): Boolean; overload;
var
  sr : TSearchRec;
begin
  Result := IsExistFile(Path, SearchPattern, sr);
end;

function IfThenColor(AValue: Boolean; ATrue: TColor; AFalse: TColor): TColor;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Integer; const AFalse: Integer): Integer;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Int64; const AFalse: Int64): Int64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: UInt64; const AFalse: UInt64): UInt64;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Single; const AFalse: Single): Single;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Double; const AFalse: Double): Double;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

function IfThen(AValue: Boolean; const ATrue: Extended; const AFalse: Extended): Extended;
begin
  if AValue then
    Result := ATrue
  else
    Result := AFalse;
end;

//VCLStyleを適用しない
//ClassToIgnore には、適用したいコンポーネントを 'TButton' のように指定する。
procedure DisableVclStyles(Control : TControl;const ClassToIgnore:string = '');
var
  i : Integer;
begin
  if Control=nil then
    Exit;

  if not Control.ClassNameIs(ClassToIgnore) then
    Control.StyleElements:=[];

  if Control is TWinControl then
  begin
  	for i := 0 to TWinControl(Control).ControlCount-1 do
      DisableVclStyles(TWinControl(Control).Controls[i], ClassToIgnore);
  end;
  TStyleManager.SystemHooks := TStyleManager.SystemHooks - [shMenus, shDialogs];
end;

//半角カタカナを全角に変換する
function ConvertSBJPtoMBJP(Source: String): String;
var
  Buf : array [0 .. 1023] of Char;
begin
  LCMapStringW(GetUserDefaultLCID, LCMAP_FULLWIDTH, PWideChar(Source), Length(Source)+1, Buf, 1024);
  Result := ConvertMBENtoSBENW(String(Buf));
end;

function HexToInt(const Hex: String): Integer;
begin
  Result := StrToInt('$'+Hex);
end;

function FormatNumber(const S: String): String;
begin
  Result := FormatFloat('#,###', StrToIntEx(S));
end;

function Quote(const S: String): String;
begin
  Result := '"' + S + '"';
end;

function IsDebugMode: Boolean;
begin
  if System.DebugHook <> 0 then
    Result := True
  else
    Result := False;
end;

//ASubIntがAIntに含まれるかどうかを判定する
function ContainsInteger(AInt: array of Integer; const ASubInt:Integer): Boolean; overload;
var
  i : Integer;
begin
  Result := False;
  for i := 0 to Length(AInt)-1 do
  begin
    if AInt[i] = ASubInt then
    begin
    	Result := True;
      Break;
    end;
  end;
end;

function DriveExists(Drive: Char): Boolean;
var ErrorMode: word;
begin
  { 大文字へ変更 }
  if CharInSet(Drive, ['a'..'z']) then
    Dec(Drive, $20);

  { ['A'..'Z'] の文字であることを確認 }
  if not (CharInSet(Drive, ['A'..'Z'])) then
    raise EConvertError.Create('無効なドライブ');

  { クリティカルエラーをオフにする }
  ErrorMode := SetErrorMode(SEM_FailCriticalErrors);
  try
    { ドライブ 1 = a, 2 = b, 3 = c, 以下同様 }
    if DiskSize(Ord(Drive) - $40) = -1 then
      Result := False else Result := True;
  finally
    { error mode を復元 }
    SetErrorMode(ErrorMode);
  end;
end;

function ContainsInteger(const ASubInt, AStartInt, AEndInt: Integer): Boolean; overload;
begin
  if (ASubInt >= AStartInt) and (ASubInt <= AEndInt) then
    Result := True
  else
    Result := False;
end;

function CheckInteger(const ASubInt, AMinInt, AMaxInt: Integer): Integer; overload;
begin
  Result := ASubInt;
  if ASubInt < AMinInt then Result := AMinInt;
  if ASubInt > AMaxInt then Result := AMaxInt;
end;

function CheckInteger(const ASubString: String; const AMinInt, AMaxInt: Integer): Integer; overload;
begin
  Result := CheckInteger(StrToIntDefEx(ASubString, 0), AMinInt, AMaxInt);
end;

procedure FileCopy(ASrcFile, ADstFile: String; overwrite: Boolean);
begin
  TFile.Copy(ASrcFile, ADstFile, overwrite);
end;

procedure FileDelete(ASrcFile: String);
begin
  TFile.Delete(ASrcFile);
end;

procedure FileMove(AFromFile, AToFile: String);
begin
  TFile.Move(AFromFile, AToFile);
end;

procedure FileRename(ASrcFile, ANewFile: String);
begin
  TFile.Move(ASrcFile, ANewFile);
end;

procedure FileRecycle(ASrcFile: String);
var
  sh : TSHFileOpStructW;
begin
  with sh do
  begin
    Wnd   := Application.Handle;
    wFunc := FO_DELETE;
    pFrom := PWideChar(ASrcFile+#0#0);
    pTo   := nil;
    fFlags:= FOF_NOCONFIRMATION or FOF_MULTIDESTFILES or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOERRORUI;
  end;
  SHFileOperationW(sh);
end;

procedure FolderCopy(ASrcFolder, ADstFolder: String);
begin
  //末尾の \ はあってもなくても良い
  TDirectory.Copy(ASrcFolder, ADstFolder);
end;

procedure FolderDelete(ASrcFolder: String; DeleteSubFolder: Boolean);
begin
  TDirectory.Delete(ASrcFolder, DeleteSubFolder);
end;

procedure FolderMove(AFromFolder, AToFolder: String);
begin
  TDirectory.Move(AFromFolder, AToFolder);
end;

procedure FolderRename(ASrcFolder, ANewFolder: String);
begin
  TDirectory.Move(ASrcFolder, ANewFolder);
end;

procedure FolderRecycle(ASrcFolder: String);
var
  sh : TSHFileOpStructW;
begin
  if RightStr(ASrcFolder, 1) = '\' then
    ASrcFolder := Copy(ASrcFolder, 1, Length(ASrcFolder)-1);

  if DirectoryExists(ASrcFolder) then
  begin
    with sh do
    begin
      Wnd   := Application.Handle;
      wFunc := FO_DELETE;
      pFrom := PWideChar(ASrcFolder+#0#0);
      pTo   := nil;
      fFlags:= FOF_MULTIDESTFILES or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOERRORUI;
    end;
    SHFileOperationW(sh);
  end;
end;

procedure FolderCreate(ASrcName: String);
begin
  if LeftStr(ASrcName, 1) = '\' then
    ASrcName := RemoveRight(ASrcName, 1);
  //渡されたのがファイル名の場合は、そのフォルダを取得する
  if TPath.HasExtension(ASrcName) then
    ASrcName := TPath.GetDirectoryName(ASrcName);
  ForceDirectories(ASrcName);
end;

procedure SetStringListLength(StringList: TStringList; Length: Integer);
var
  i : Cardinal;
begin
  if StringList.Count > Length then
  begin
    for i := StringList.Count-1 downto Length do
      StringList.Delete(i);
  end;
end;

function GetWindowText(hWnd: THandle): String;
var
  iLen : Cardinal;
begin
  iLen := SendMessageW(hWnd, WM_GETTEXTLENGTH, 0, 0);
  SetLength(Result, iLen);
  SendMessageW(hWnd, WM_GETTEXT, iLen, lParam(PWideChar(Result)));
end;

function InputBox(const ACaption, APrompt, ADefault: string; InputBoxOptions: TInputBoxOptions): string; overload;
begin
  Application.CreateForm(TfrmInputBoxEx, frmInputBoxEx);
  frmInputBoxEx.Caption         := ACaption;
  frmInputBoxEx.lblDesc.Caption := APrompt;
  frmInputBoxEx.memImput.Text   := ADefault;
  frmInputBoxEx.FUseAsFilename  := ibFileName in InputBoxOptions;
  frmInputBoxEx.FConvertFileName:= ibConvert in InputBoxOptions;
  frmInputBoxEx.memImput.SelectAll;
  frmInputBoxEx.ShowModal;
  Result := HAS_INPUTBOX_VALUE;
end;

function InputBox(const ACaption, APrompt, ADefault: string): string; overload;
begin
  Result := InputBox(ACaption, APrompt, ADefault, [ibFileName, ibConvert]);
end;

//
// ShowMessage
//
procedure ShowMessage(const Msg: String; DlgType: TMsgDlgType; ACaption: String); overload;
begin
  Application.CreateForm(TfrmShowMessage, frmShowMessage);
  frmShowMessage.Caption        := ACaption;
  frmShowMessage.lblMsg.Caption := Msg;
  frmShowMessage.LoadIcon(DlgType);
  frmShowMessage.SetWindowSize;
  frmShowMessage.ShowModal;
end;

procedure ShowMessage(const Msg: String; DlgType: TMsgDlgType); overload;
begin
  ShowMessage(Msg, DlgType, Application.Title);
end;

procedure ShowMessage(const Msg: String); overload;
begin
  ShowMessage(Msg, mtCustom, Application.Title);
end;

//
// MessageDialog
//
function MessageDlg(const Msg: String; DlgType: TMsgDlgType; ATitleStr: String; Buttons: TMsgDlgButtons): Integer; overload;
begin
  Application.CreateForm(TfrmMessageDlg, frmMessageDlg);
  frmMessageDlg.Caption         := ATitleStr;
  frmMessageDlg.lblMsg.Caption  := Msg;
  frmMessageDlg.LoadIcon(DlgType);
  frmMessageDlg.SetWindowSize;
  frmMessageDlg.CreateButtons(Buttons);
  frmMessageDlg.ShowModal;
  Result := HAS_MESSAGEDLG_VALUE;
end;

function MessageDlg(const Msg: String; DlgType: TMsgDlgType; ATitleStr: String): Integer; overload;
begin
  result := MessageDlg(Msg, DlgType, ATitleStr, [mbYes, mbNo]);
end;

function MessageDlg(const Msg: String; DlgType: TMsgDlgType): Integer; overload;
begin
  Result := MessageDlg(Msg, DlgType, Application.Title, [mbYes, mbNo]);
end;

end.
