unit SearchUtils;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, System.SysUtils, System.UITypes, Vcl.Graphics, System.StrUtils,
  System.Classes;

  function SearchStrings(Source, SubStr: String; IsAnd, IgnoreCase: Boolean): Boolean;

implementation

uses
  HideUtils;

function SearchStrings(Source, SubStr: String; IsAnd, IgnoreCase: Boolean): Boolean;
var
  sl : TStringList;
  i : Integer;
begin
  Result := True;
  SubStr := Trim(SubStr);

  sl := TStringList.Create;
  try
    sl.CommaText := SubStr;
    Case IsAnd of
      True :
        begin
          //すべてを含む場合
          for i := 0 to sl.Count-1 do
          begin
            if IgnoreCase then
            begin
              if Not ContainsText(Source, sl[i]) then
              begin
                Result := False;
                Break;
              end;
            end
            else
            begin
              if Not ContainsStr(Source, sl[i]) then
              begin
                Result := False;
                Break;
              end;
            end;
          end;
        end;
      False :
        begin
          //一つでもヒットした場合
          for i := 0 to sl.Count-1 do
          begin
            if IgnoreCase then
            begin
              if ContainsText(Source, sl[i]) then
              begin
                Result := True;
                Break;
              end else
                Result := False;
            end
            else
            begin
              if ContainsStr(Source, sl[i]) then
              begin
                Result := True;
                Break;
              end else
                Result := False;
            end;
          end;
        end;
    end;
  finally
    sl.Free;
  end;
end;

end.
