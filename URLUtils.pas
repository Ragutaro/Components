unit URLUtils;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.StrUtils, Vcl.StdCtrls, System.UITypes;

  function ReplaceUrl(SrcUrl: String; ReplaceIndex: Integer; ReplaceString: String): String;
  function InsertPathToUrl(SrcUrl: String; InsertIndex: Integer; InsertString: String): String;
  function DeletePathFromUrl(SrcUrl: String; DeleteIndex: Integer): String;
  function ExtractElements(SrcUrl: String; ExtractIndex: Integer): String;

implementation

function ReplaceUrl(SrcUrl: String; ReplaceIndex: Integer; ReplaceString: String): String;
var
  sl : TStringList;
begin
{ www.test.jp の部分が ReplaceIndex = 2 となる }
  sl := TStringList.Create;
  try
    sl.Delimiter := '/';
    sl.DelimitedText := SrcUrl;
    sl[ReplaceIndex] := ReplaceString;
    Result := sl.DelimitedText;
  finally
    sl.Free;
  end;
end;

function InsertPathToUrl(SrcUrl: String; InsertIndex: Integer; InsertString: String): String;
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '/';
    sl.DelimitedText := SrcUrl;
    sl.Insert(InsertIndex, InsertString);
    Result := sl.DelimitedText;
  finally
    sl.Free;
  end;
end;

function DeletePathFromUrl(SrcUrl: String; DeleteIndex: Integer): String;
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '/';
    sl.DelimitedText := SrcUrl;
    sl.Delete(DeleteIndex);
    Result := sl.DelimitedText;
  finally
    sl.Free;
  end;
end;

function ExtractElements(SrcUrl: String; ExtractIndex: Integer): String;
var
  sl : TStringList;
begin
  sl := TStringList.Create;
  try
    sl.Delimiter := '/';
    sl.DelimitedText := SrcUrl;
    Result := sl[ExtractIndex];
  finally
    sl.Free;
  end;
end;

end.
