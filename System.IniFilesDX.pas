﻿{*******************************************************}
{                                                       }
{           CodeGear Delphi Runtime Library             }
{                                                       }
{ Copyright(c) 1995-2015 Embarcadero Technologies, Inc. }
{                                                       }
{*******************************************************}

unit IniFilesDX;

{$R-,T-,H+,X+}

interface

uses
  System.SysUtils, System.Classes, System.Generics.Collections, Vcl.Forms;

type
  EIniFileException = class(Exception);

  TCustomIniFile = class(TObject)
  private
    FFileName: string;
  protected
    const SectionNameSeparator: string = '\';
    procedure InternalReadSections(const Section: string; Strings: TStrings;
      SubSectionNamesOnly, Recurse: Boolean); virtual;
  public
    constructor Create(const FileName: string);
    function SectionExists(const Section: string): Boolean;
    function ReadString(const Section, Ident, Default: string): string; virtual; abstract;
    procedure WriteString(const Section, Ident, Value: String); virtual; abstract;
    function ReadInteger(const Section, Ident: string; Default: Integer): Integer; virtual;
    procedure WriteInteger(const Section, Ident: string; Value: Integer); virtual;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
    function ReadBinaryStream(const Section, Name: string; Value: TStream): Integer; virtual;
    function ReadDate(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    function ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    function ReadFloat(const Section, Name: string; Default: Double): Double; virtual;
    function ReadTime(const Section, Name: string; Default: TDateTime): TDateTime; virtual;
    procedure WriteBinaryStream(const Section, Name: string; Value: TStream); virtual;
    procedure WriteDate(const Section, Name: string; Value: TDateTime); virtual;
    procedure WriteDateTime(const Section, Name: string; Value: TDateTime); virtual;
    procedure WriteFloat(const Section, Name: string; Value: Double); virtual;
    procedure WriteTime(const Section, Name: string; Value: TDateTime); virtual;
    procedure ReadSection(const Section: string; Strings: TStrings); virtual; abstract;
    procedure ReadSections(Strings: TStrings); overload; virtual; abstract;
    procedure ReadSections(const Section: string; Strings: TStrings); overload; virtual;
    procedure ReadSubSections(const Section: string; Strings: TStrings; Recurse: Boolean = False); virtual;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); virtual; abstract;
    procedure EraseSection(const Section: string); virtual; abstract;
    procedure DeleteKey(const Section, Ident: String); virtual; abstract;
    procedure UpdateFile; virtual; abstract;
    function ValueExists(const Section, Ident: string): Boolean; virtual;
    property FileName: string read FFileName;
    procedure WriteWindowPosition(const Section: String; Form: TForm);
    procedure ReadWindowPosition(const Section: String; Form: TForm);
    procedure WriteWindow(const Section: String; Form: TForm);
    procedure ReadWindow(const Section: String; Form: TForm);
  end;

  { TStringHash - used internally by TMemIniFile to optimize searches. }

  TStringHash = class
  private type
    THashItem = record
      Key: string;
      Value: Integer;
    end;
  private
    Buckets: array of TList<THashItem>;
  protected
    function Find(const Key: string; var AItem:THashItem): Integer;
    function HashOf(const Key: string): Cardinal; virtual;
  public
    constructor Create(Size: Cardinal = 256);
    destructor Destroy; override;
    procedure Add(const Key: string; Value: Integer);
    procedure Clear;
    procedure Remove(const Key: string);
    function Modify(const Key: string; Value: Integer): Boolean;
    function ValueOf(const Key: string): Integer;
  end;

  { THashedStringList - A TStringList that uses TStringHash to improve the speed of Find }
  THashedStringList = class(TStringList)
  private
    FValueHash: TStringHash;
    FNameHash: TStringHash;
    FValueHashValid: Boolean;
    FNameHashValid: Boolean;
    procedure UpdateValueHash;
    procedure UpdateNameHash;
  protected
    procedure Changed; override;
  public
    destructor Destroy; override;
    function IndexOf(const S: string): Integer; override;
    function IndexOfName(const Name: string): Integer; override;
  end;

  { TMemIniFile - loads an entire INI file into memory and allows all operations to be performed on the memory image.
    The image can then be written out to the disk file }

  TMemIniFile = class(TCustomIniFile)
  private
    FSections: TStringList;
    FEncoding: TEncoding;
    function AddSection(const Section: string): TStrings;
    function GetCaseSensitive: Boolean;
    procedure LoadValues;
    procedure SetCaseSensitive(Value: Boolean);
  public
    constructor Create(const FileName: string); overload;
    constructor Create(const FileName: string; const Encoding: TEncoding); overload;
    destructor Destroy; override;
    procedure Clear;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure EraseSection(const Section: string); override;
    procedure GetStrings(const List: TStrings);
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure Rename(const FileName: string; Reload: Boolean);
    procedure SetStrings(const List: TStrings);
    procedure UpdateFile; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    property CaseSensitive: Boolean read GetCaseSensitive write SetCaseSensitive;
    property Encoding: TEncoding read FEncoding write FEncoding;
  end;

{$IFDEF MSWINDOWS}
  { TIniFile - Encapsulates the Windows INI file interface (Get/SetPrivateProfileXXX functions) }

  TIniFile = class(TCustomIniFile)
  public
    destructor Destroy; override;
    function ReadString(const Section, Ident, Default: string): string; override;
    procedure WriteString(const Section, Ident, Value: String); override;
    procedure ReadSection(const Section: string; Strings: TStrings); override;
    procedure ReadSections(Strings: TStrings); override;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); override;
    procedure EraseSection(const Section: string); override;
    procedure DeleteKey(const Section, Ident: String); override;
    procedure UpdateFile; override;
  end;
{$ELSE}
    TIniFile = class(TMemIniFile)
    public
      destructor Destroy; override;
    end;
{$ENDIF}


implementation

uses
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF}
  System.IOUtils, System.RTLConsts;

{ TCustomIniFile }

constructor TCustomIniFile.Create(const FileName: string);
begin
  FFileName := FileName;
end;

function TCustomIniFile.SectionExists(const Section: string): Boolean;
var
  S: TStrings;
begin
  S := TStringList.Create;
  try
    ReadSection(Section, S);
    Result := S.Count > 0;
  finally
    S.Free;
  end;
end;

function TCustomIniFile.ReadInteger(const Section, Ident: string; Default: Integer): Integer;
var
  IntStr: string;
begin
  IntStr := ReadString(Section, Ident, '');
  if (IntStr.Length > 2) and (IntStr.StartsWith('0x',true)) then
    IntStr := '$' + IntStr.Substring( 2);
  Result := StrToIntDef(IntStr, Default);
end;

procedure TCustomIniFile.WriteInteger(const Section, Ident: string; Value: Integer);
begin
  WriteString(Section, Ident, IntToStr(Value));
end;

function TCustomIniFile.ReadBool(const Section, Ident: string;
  Default: Boolean): Boolean;
begin
  Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

function TCustomIniFile.ReadDate(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDate(DateStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TCustomIniFile.ReadDateTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  DateStr: string;
begin
  DateStr := ReadString(Section, Name, '');
  Result := Default;
  if DateStr <> '' then
  try
    Result := StrToDateTime(DateStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TCustomIniFile.ReadFloat(const Section, Name: string; Default: Double): Double;
var
  FloatStr: string;
begin
  FloatStr := ReadString(Section, Name, '');
  Result := Default;
  if FloatStr <> '' then
  try
    Result := StrToFloat(FloatStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

function TCustomIniFile.ReadTime(const Section, Name: string; Default: TDateTime): TDateTime;
var
  TimeStr: string;
begin
  TimeStr := ReadString(Section, Name, '');
  Result := Default;
  if TimeStr <> '' then
  try
    Result := StrToTime(TimeStr);
  except
    on EConvertError do
      // Ignore EConvertError exceptions
    else
      raise;
  end;
end;

procedure TCustomIniFile.ReadWindow(const Section: String; Form: TForm);
begin
  Form.Top := ReadInteger(Section, 'Top', Form.Top);
  Form.Left := ReadInteger(Section, 'Left', Form.Left);
end;

procedure TCustomIniFile.ReadWindowPosition(const Section: String; Form: TForm);
begin
  Form.Top := ReadInteger(Section, 'Top', Form.Top);
  Form.Left := ReadInteger(Section, 'Left', Form.Left);
  Form.Width := ReadInteger(Section, 'Width', Form.Width);
  Form.Height := ReadInteger(Section, 'Height', Form.Height);
end;

procedure TCustomIniFile.WriteDate(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateToStr(Value));
end;

procedure TCustomIniFile.WriteDateTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, DateTimeToStr(Value));
end;

procedure TCustomIniFile.WriteFloat(const Section, Name: string; Value: Double);
begin
  WriteString(Section, Name, FloatToStr(Value));
end;

procedure TCustomIniFile.WriteTime(const Section, Name: string; Value: TDateTime);
begin
  WriteString(Section, Name, TimeToStr(Value));
end;

procedure TCustomIniFile.WriteWindow(const Section: String; Form: TForm);
begin
  WriteInteger(Section, 'Top', Form.Top);
  WriteInteger(Section, 'Left', Form.Left);
end;

procedure TCustomIniFile.WriteWindowPosition(const Section: String;
  Form: TForm);
begin
  WriteInteger(Section, 'Top', Form.Top);
  WriteInteger(Section, 'Left', Form.Left);
  WriteInteger(Section, 'Width', Form.Width);
  WriteInteger(Section, 'Height', Form.Height);
end;

procedure TCustomIniFile.WriteBool(const Section, Ident: string; Value: Boolean);
const
  Values: array[Boolean] of string = ('0', '1');
begin
  WriteString(Section, Ident, Values[Value]);
end;

function TCustomIniFile.ValueExists(const Section, Ident: string): Boolean;
var
  S: TStrings;
begin
  S := TStringList.Create;
  try
    ReadSection(Section, S);
    Result := S.IndexOf(Ident) > -1;
  finally
    S.Free;
  end;
end;

function TCustomIniFile.ReadBinaryStream(const Section, Name: string; Value: TStream): Integer;
var
  Text: string;
  Stream: TMemoryStream;
  Pos: Integer;
  dataLen: Integer;
  DataBytes: TBytes;
begin
  Text := ReadString(Section, Name, '');
  if Text <> '' then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;

    try
      dataLen := Length(Text) div 2;
      SetLength(DataBytes, dataLen);
      Pos := Stream.Position;
      HexToBin(BytesOf(Text), 0, DataBytes, 0, dataLen);
      Stream.Write(DataBytes[0], dataLen);
      Stream.Position := Pos;
      if Value <> Stream then
        Value.CopyFrom(Stream, dataLen);
      Result := Stream.Size - Pos;
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end
  else
    Result := 0;
end;

procedure TCustomIniFile.WriteBinaryStream(const Section, Name: string;
  Value: TStream);
var
  Text: string;
  Stream: TMemoryStream;
  Buffer: TBytes;
begin
  SetLength(Text, (Value.Size - Value.Position) * 2);
  if Text.Length > 0 then
  begin
    if Value is TMemoryStream then
      Stream := TMemoryStream(Value)
    else
      Stream := TMemoryStream.Create;

    try
      if Stream <> Value then
      begin
        Stream.CopyFrom(Value, Value.Size - Value.Position);
        Stream.Position := 0;
      end;
      SetLength(Buffer, Stream.Size * 2);
      BinToHex(Stream.Memory, Stream.Position, Buffer, 0, Stream.Size - Stream.Position);
      Text := StringOf(Buffer);
    finally
      if Value <> Stream then
        Stream.Free;
    end;
  end;
  WriteString(Section, Name, Text);
end;

procedure TCustomIniFile.InternalReadSections(const Section: string; Strings: TStrings;
  SubSectionNamesOnly, Recurse: Boolean);
var
  SLen, SectionLen, SectionEndOfs, I: Integer;
  S, SubSectionName: string;
  AllSections: TStringList;
begin
  AllSections := TStringList.Create;
  try
    ReadSections(AllSections);
    SectionLen := Section.Length;
    // Adjust end offset of section name to account for separator when present.
    SectionEndOfs := (SectionLen) + Integer(SectionLen > 0);
    Strings.BeginUpdate;
    try
      for I := 0 to AllSections.Count - 1 do
      begin
        S := AllSections[I];
        SLen := S.Length;
        if (SectionLen = 0) or
          (SubSectionNamesOnly and (SLen > SectionLen) and SameText(Section, S.SubString( 0, SectionLen))) or
          (not SubSectionNamesOnly and (SLen >= SectionLen) and SameText(Section, S.Substring( 0, SectionLen))) then
        begin
          SubSectionName := S.Substring( SectionEndOfs, SLen + 1 - SectionEndOfs); // +1 to skip '=' ??
          if not Recurse and (SubSectionName.IndexOf(SectionNameSeparator) >= 0) then
            Continue;
          if SubSectionNamesOnly then
            S := SubSectionName;
          Strings.Add(S);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    AllSections.Free;
  end;
end;

procedure TCustomIniFile.ReadSections(const Section: string; Strings: TStrings);
begin
  InternalReadSections(Section, Strings, False, True);
end;

procedure TCustomIniFile.ReadSubSections(const Section: string; Strings: TStrings; Recurse: Boolean = False);
begin
  InternalReadSections(Section, Strings, True, Recurse);
end;

{ TStringHash }

procedure TStringHash.Add(const Key: string; Value: Integer);
var
  Hash: Integer;
  item: THashItem;
begin
  Hash := HashOf(Key) mod Cardinal(Length(Buckets));
  item.Key := Key;
  item.Value := Value;
  Buckets[Hash].Add(item);
end;

procedure TStringHash.Clear;
var
  I: Integer;
begin
  for I := 0 to Length(Buckets) - 1 do
  begin
    Buckets[I].Clear;
  end;
end;

constructor TStringHash.Create(Size: Cardinal);
var
  i:integer;
begin
  inherited Create;
  SetLength(Buckets, Size);
  for i:= 0 to Size-1 do
  begin
    Buckets[i] := TList<THashItem>.Create;
  end;
end;

destructor TStringHash.Destroy;
var
  i:integer;
begin
  Clear;
  for I := 0 to Length(Buckets) - 1 do
  begin
    Buckets[I].Free;
    Buckets[I] := nil;
  end;
  inherited Destroy;
end;

function TStringHash.Find(const Key: string; var AItem: THashItem): Integer;
var
  Hash: Integer;
  pos:Integer;
begin
  Result := -1;
  Hash := HashOf(Key) mod Cardinal(Length(Buckets));
  if Buckets[Hash] <> nil then
  begin
    pos := 0;
    while pos < Buckets[Hash].Count do
    begin
      if Buckets[Hash][pos].Key = Key then
      begin
        Result := pos;
        AItem := Buckets[Hash][pos];
        break;
      end;
      Inc(pos, 1);
    end;
  end;
end;

function TStringHash.HashOf(const Key: string): Cardinal;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to Key.Length - 1 do
    Result := ((Result shl 2) or (Result shr (SizeOf(Result) * 8 - 2))) xor
      Ord(Key.Chars[I]);
end;

function TStringHash.Modify(const Key: string; Value: Integer): Boolean;
var
  Hash: Integer;
  Pos: Integer;
  Item: THashItem;
begin
  Pos := Find(Key, Item);
  if Pos >= 0 then
  begin
    Result := True;
    Hash := HashOf(Key) mod Cardinal(Length(Buckets));
    Item.Value := Value;
    Buckets[Hash].Items[pos] := Item;
  end
  else
    Result := False;
end;

procedure TStringHash.Remove(const Key: string);
var
  Hash: Integer;
  Item: THashItem;
  Pos:Integer;
begin
  Pos := Find(Key, Item);
  if Pos >= 0 then
  begin
    Hash := HashOf(Key) mod Cardinal(Length(Buckets));
    Buckets[Hash].Delete(Pos);
  end;
end;

function TStringHash.ValueOf(const Key: string): Integer;
var
  Item: THashItem;
  Pos:Integer;
begin
  Pos := Find(Key, Item);
  if Pos >= 0 then
    Result := Item.Value
  else
    Result := -1;
end;

{ THashedStringList }

procedure THashedStringList.Changed;
begin
  inherited Changed;
  FValueHashValid := False;
  FNameHashValid := False;
end;

destructor THashedStringList.Destroy;
begin
  FValueHash.Free;
  FNameHash.Free;
  inherited Destroy;
end;

function THashedStringList.IndexOf(const S: string): Integer;
begin
  UpdateValueHash;
  if not CaseSensitive then
    Result := FValueHash.ValueOf(AnsiUpperCase(S))
  else
    Result := FValueHash.ValueOf(S);
end;

function THashedStringList.IndexOfName(const Name: string): Integer;
begin
  UpdateNameHash;
  if not CaseSensitive then
    Result := FNameHash.ValueOf(AnsiUpperCase(Name))
  else
    Result := FNameHash.ValueOf(Name);
end;

procedure THashedStringList.UpdateNameHash;
var
  I: Integer;
  P: Integer;
  Key: string;
begin
  if FNameHashValid then Exit;

  if FNameHash = nil then
    FNameHash := TStringHash.Create
  else
    FNameHash.Clear;
  for I := 0 to Count - 1 do
  begin
    Key := Get(I);
    P := Key.IndexOf(NameValueSeparator);
    if P >= 0 then
    begin
      if not CaseSensitive then
        Key := AnsiUpperCase(Key.SubString( 0, P))
      else
        Key := Key.SubString( 0, P);
      FNameHash.Add(Key, I);
    end;
  end;
  FNameHashValid := True;
end;

procedure THashedStringList.UpdateValueHash;
var
  I: Integer;
begin
  if FValueHashValid then Exit;

  if FValueHash = nil then
    FValueHash := TStringHash.Create
  else
    FValueHash.Clear;
  for I := 0 to Count - 1 do
    if not CaseSensitive then
      FValueHash.Add(AnsiUpperCase(Self[I]), I)
    else
      FValueHash.Add(Self[I], I);
  FValueHashValid := True;
end;

{ TMemIniFile }

constructor TMemIniFile.Create(const FileName: string);
begin
  Create(Filename, nil);
end;

constructor TMemIniFile.Create(const FileName: string; const Encoding: TEncoding);
begin
  inherited Create(FileName);
  FEncoding := Encoding;
  FSections := THashedStringList.Create;
{$IFDEF LINUX}
  FSections.CaseSensitive := True;
{$ENDIF}
  LoadValues;
end;

destructor TMemIniFile.Destroy;
begin
  if FSections <> nil then
    Clear;
  FSections.Free;
  inherited Destroy;
end;

function TMemIniFile.AddSection(const Section: string): TStrings;
begin
  Result := THashedStringList.Create;
  try
    THashedStringList(Result).CaseSensitive := CaseSensitive;
    FSections.AddObject(Section, Result);
  except
    Result.Free;
    raise;
  end;
end;

procedure TMemIniFile.Clear;
{$IFNDEF AUTOREFCOUNT}
var
  I: Integer;
{$ENDIF !AUTOREFCOUNT}
begin
{$IFNDEF AUTOREFCOUNT}
  for I := 0 to FSections.Count - 1 do
  begin
    FSections.Objects[I].Free;
  end;
{$ENDIF !AUTOREFCOUNT}
  FSections.Clear;
end;

procedure TMemIniFile.DeleteKey(const Section, Ident: String);
var
  I, J: Integer;
  Strings: TStrings;
begin
  I := FSections.IndexOf(Section);
  if I >= 0 then
  begin
    Strings := TStrings(FSections.Objects[I]);
    J := Strings.IndexOfName(Ident);
    if J >= 0 then
      Strings.Delete(J);
  end;
end;

procedure TMemIniFile.EraseSection(const Section: string);
var
  I: Integer;
begin
  I := FSections.IndexOf(Section);
  if I >= 0 then
  begin
{$IFNDEF AUTOREFCOUNT}
    FSections.Objects[I].Free;
{$ENDIF !AUTOREFCOUNT}
    FSections.Delete(I);
  end;
end;

function TMemIniFile.GetCaseSensitive: Boolean;
begin
  Result := FSections.CaseSensitive;
end;

procedure TMemIniFile.GetStrings(const List: TStrings);
var
  I, J: Integer;
  Strings: TStrings;
begin
  List.BeginUpdate;
  try
    for I := 0 to FSections.Count - 1 do
    begin
      List.Add('[' + FSections[I] + ']');
      Strings := TStrings(FSections.Objects[I]);
      for J := 0 to Strings.Count - 1 do List.Add(Strings[J]);
      List.Add('');
    end;
  finally
    List.EndUpdate;
  end;
end;

procedure TMemIniFile.LoadValues;
var
  Size: Integer;
  Buffer: TBytes;
  List: TStringList;
  Stream: TFileStream;
begin
  if (FileName <> '') and FileExists(FileName) then
  begin
    Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
     // Load file into buffer and detect encoding
      Size := Stream.Size - Stream.Position;
      SetLength(Buffer, Size);
      Stream.Read(Buffer[0], Size);
      Size := TEncoding.GetBufferEncoding(Buffer, FEncoding);

      // Load strings from buffer
      List := TStringList.Create;
      try
        List.Text := FEncoding.GetString(Buffer, Size, Length(Buffer) - Size);
        SetStrings(List);
      finally
        List.Free;
      end;
    finally
      Stream.Free;
    end;
  end
  else
    Clear;
end;

procedure TMemIniFile.ReadSection(const Section: string; Strings: TStrings);
var
  I, J: Integer;
  SectionStrings: TStrings;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    I := FSections.IndexOf(Section);
    if I >= 0 then
    begin
      SectionStrings := TStrings(FSections.Objects[I]);
      for J := 0 to SectionStrings.Count - 1 do
        Strings.Add(SectionStrings.Names[J]);
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TMemIniFile.ReadSections(Strings: TStrings);
begin
  Strings.Assign(FSections);
end;

procedure TMemIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  I: Integer;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    I := FSections.IndexOf(Section);
    if I >= 0 then
      Strings.Assign(TStrings(FSections.Objects[I]));
  finally
    Strings.EndUpdate;
  end;
end;

function TMemIniFile.ReadString(const Section, Ident, Default: string): string;
var
  I: Integer;
  Strings: TStrings;
begin
  I := FSections.IndexOf(Section);
  if I >= 0 then
  begin
    Strings := TStrings(FSections.Objects[I]);
    I := Strings.IndexOfName(Ident);
    if I >= 0 then
    begin
      Result := Strings[I].SubString( Ident.Length + 1);
      Exit;
    end;
  end;
  Result := Default;
end;

procedure TMemIniFile.Rename(const FileName: string; Reload: Boolean);
begin
  FFileName := FileName;
  if Reload then
    LoadValues;
end;

procedure TMemIniFile.SetCaseSensitive(Value: Boolean);
var
  I: Integer;
begin
  if Value <> FSections.CaseSensitive then
  begin
    FSections.CaseSensitive := Value;
    for I := 0 to FSections.Count - 1 do
    begin
      THashedStringList(FSections.Objects[I]).CaseSensitive := Value;
      THashedStringList(FSections.Objects[I]).Changed;
    end;
    THashedStringList(FSections).Changed;
  end;
end;

procedure TMemIniFile.SetStrings(const List: TStrings);
var
  I, J: Integer;
  S: string;
  Strings: TStrings;
begin
  Clear;
  Strings := nil;
  for I := 0 to List.Count - 1 do
  begin
    S := List[I].Trim;
    if (S <> '') and (S.Chars[0] <> ';') then
      if (S.Chars[0] = '[') and (S.Chars[S.Length-1] = ']') then
      begin
        // Remove Brackets
        Strings := AddSection(S.Substring(1, S.Length-2).Trim);
      end
      else
        if Strings <> nil then
        begin
          J := S.IndexOf('=');
          if J >= 0 then // remove spaces before and after '='
            Strings.Add(S.SubString(0, J).Trim + '=' + S.SubString( J+1).Trim)
          else
            Strings.Add(S);
        end;
  end;
end;

procedure TMemIniFile.UpdateFile;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    GetStrings(List);
    List.SaveToFile(FFileName, FEncoding);
  finally
    List.Free;
  end;
end;

procedure TMemIniFile.WriteString(const Section, Ident, Value: String);
var
  I: Integer;
  S: string;
  Strings: TStrings;
begin
  I := FSections.IndexOf(Section);
  if I >= 0 then
    Strings := TStrings(FSections.Objects[I])
  else
    Strings := AddSection(Section);
  S := Ident + '=' + Value;
  I := Strings.IndexOfName(Ident);
  if I >= 0 then
    Strings[I] := S
  else
    Strings.Add(S);
end;

{$IFDEF MSWINDOWS}

{ TIniFile }

destructor TIniFile.Destroy;
begin
  UpdateFile;         // flush changes to disk
  inherited Destroy;
end;

function TIniFile.ReadString(const Section, Ident, Default: string): string;
var
  Buffer: array[0..2047] of Char;
begin
                                                                                                                   
  SetString(Result, Buffer, GetPrivateProfileString(MarshaledString(Section),
    MarshaledString(Ident), MarshaledString(Default), Buffer, Length(Buffer),
    MarshaledString(FFileName)));
end;

procedure TIniFile.WriteString(const Section, Ident, Value: string);
begin
  if not WritePrivateProfileString(MarshaledString(Section), MarshaledString(Ident),
                                   MarshaledString(Value), MarshaledString(FFileName)) then
    raise EIniFileException.CreateResFmt(@SIniFileWriteError, [FileName]);
end;

procedure TIniFile.ReadSections(Strings: TStrings);
const
  CStdBufSize = 16384; // chars
var
  LEncoding: TEncoding;
  LRawBuffer: TBytes;
  P, LBuffer: PChar;
  LCharCount: Integer;
begin
  LEncoding := nil;
  LBuffer := nil;
  try
    // try to read the file in a 16Kchars buffer
    GetMem(LBuffer, CStdBufSize * SizeOf(Char));
    Strings.BeginUpdate;
    try
      Strings.Clear;
      LCharCount := GetPrivateProfileString(nil, nil, nil, LBuffer, CStdBufSize,
        PChar(FFileName));

      // the buffer is too small; approximate the buffer size to fit the contents
      if LCharCount = CStdBufSize - 2 then
      begin
        LRawBuffer := TFile.ReadAllBytes(FFileName);
        TEncoding.GetBufferEncoding(LRawBuffer, LEncoding);
        LCharCount := LEncoding.GetCharCount(LRawBuffer);
        ReallocMem(LBuffer, LCharCount * LEncoding.GetMaxByteCount(1));

        LCharCount := GetPrivateProfileString(nil, nil, nil, LBuffer, LCharCount,
          MarshaledString(FFileName));
      end;

      // chars were read from the file; get the section names
      if LCharCount <> 0 then
      begin
        P := LBuffer;
        while P^ <> #0 do
        begin
          Strings.Add(P);
          Inc(P, StrLen(P) + 1);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  finally
    FreeMem(LBuffer);
  end;
end;

procedure TIniFile.ReadSection(const Section: string; Strings: TStrings);
var
  Buffer, P: PChar;
  CharCount: Integer;
  BufSize: Integer;

  procedure ReadStringData;
  begin
    Strings.BeginUpdate;
    try
      Strings.Clear;
      if CharCount <> 0 then
      begin
        P := Buffer;
        while P^ <> #0 do
        begin
          Strings.Add(P);
          Inc(P, StrLen(P) + 1);
        end;
      end;
    finally
      Strings.EndUpdate;
    end;
  end;

begin
  BufSize := 1024;

  while True do
  begin
    GetMem(Buffer, BufSize * SizeOf(Char));
    try
      CharCount := GetPrivateProfileString(MarshaledString(Section), nil, nil, Buffer, BufSize, MarshaledString(FFileName));
      if CharCount < BufSize - 2 then
      begin
        ReadStringData;
        Break;
      end;
    finally
      FreeMem(Buffer, BufSize);
    end;
    BufSize := BufSize * 4;
  end;
end;

procedure TIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  KeyList: TStringList;
  I: Integer;
begin
  KeyList := TStringList.Create;
  try
    ReadSection(Section, KeyList);
    Strings.BeginUpdate;
    try
      Strings.Clear;
      for I := 0 to KeyList.Count - 1 do
        Strings.Add(KeyList[I] + '=' + ReadString(Section, KeyList[I], ''))
    finally
      Strings.EndUpdate;
    end;
  finally
    KeyList.Free;
  end;
end;

procedure TIniFile.EraseSection(const Section: string);
begin
  if not WritePrivateProfileString(MarshaledString(Section), nil, nil, MarshaledString(FFileName)) then
    raise EIniFileException.CreateResFmt(@SIniFileWriteError, [FileName]);
end;

procedure TIniFile.DeleteKey(const Section, Ident: String);
begin
  WritePrivateProfileString(MarshaledString(Section), MarshaledString(Ident), nil, MarshaledString(FFileName));
end;

procedure TIniFile.UpdateFile;
begin
  WritePrivateProfileString(nil, nil, nil, MarshaledString(FFileName));
end;
{$ELSE MSWINDOWS}

destructor TIniFile.Destroy;
begin
  UpdateFile;
  inherited Destroy;
end;

{$ENDIF MSWINDOWS}

end.
