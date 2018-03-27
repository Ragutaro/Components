unit HideComboBox;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, StdCtrls, Forms, Graphics;

type
  TAddType = (atTop, atBottom, atSorted);
  THideComboBox = class(TComboBox)
  private
    { Private 宣言 }
    FItemWidth    : Integer;
    FAutoSizeList : Boolean;
    FCanDeleteItem: Boolean;
    FShowDefaultStr : Boolean;
    FDefaultStr : String;
    function  GetTextWidth(S : String) : Integer;
    procedure SetAutoSizeList(const Value: Boolean);
    procedure SetCanDeleteItem(const Value: Boolean);
    procedure SetShowDefaultStr(const Value: Boolean);
    procedure SetDefaultStr(const Value: String);
  protected
    { Protected 宣言 }
    procedure DropDown; override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter;override;
    procedure DoExit;override;
  public
    { Public 宣言 }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy;override;
    procedure UAddItem(at: TAddType);
    procedure UAddNewItem(AddString: String; at: TAddType);
  published
    { Published 宣言 }
    property ItemWidth : Integer read FItemWidth write FItemWidth;
    property UAutoSizeList : Boolean read FAutoSizeList write SetAutoSizeList default True;
    property UCanDeleteItem: Boolean read FCanDeleteItem write SetCanDeleteItem default False;
    property UShowDefaultStr: Boolean read FShowDefaultStr write SetShowDefaultStr default False;
    property UDefaultStr: String read FDefaultStr write SetDefaultStr;
  end;

procedure Register;

implementation

uses Math;

procedure Register;
begin
  RegisterComponents('HaS', [THideComboBox]);
end;

constructor THideComboBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  AutoComplete := False;
  UAutoSizeList:= True;
end;

procedure THideComboBox.DropDown;
var
  i, iScrollBar : Integer;
begin
  inherited DropDown;
  if FAutoSizeList then
  begin
    if UAutoSizeList then
    begin
      ItemWidth := 0;
      iScrollBar := GetSystemMetrics(SM_CXVSCROLL);
      for i := 0 to Items.Count - 1 do
      begin
        if GetTextWidth(Items[i]) > ItemWidth then
          ItemWidth := GetTextWidth(Items[i]);
      end;
      SendMessage(Self.Handle, CB_SETDROPPEDWIDTH, ItemWidth + iScrollBar + 16, 0);
    end;
  end;
end;

function THideComboBox.GetTextWidth(S : String) : Integer;
begin
  Result := TForm(Owner).Canvas.TextWidth(S);
end;

procedure THideComboBox.SetAutoSizeList(const Value: Boolean);
begin
  FAutoSizeList := Value;
  Invalidate;
end;

destructor THideComboBox.Destroy;
begin
  inherited Destroy;
end;

procedure THideComboBox.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if UCanDeleteItem then
  begin
    if (Key = VK_DELETE) and Self.DroppedDown then
    begin
      Self.Items.Delete(Self.ItemIndex);
    end;
  end;
end;

procedure THideComboBox.SetCanDeleteItem(const Value: Boolean);
begin
  FCanDeleteItem := Value;
  Invalidate;
end;

procedure THideComboBox.UAddItem(at: TAddType);
var
  iRes : Integer;
  s : String;
begin
  s := Trim(Text);
  if (s <> '') and (s <> FDefaultStr) then
  begin
    iRes := Items.IndexOf(s);
    if iRes = -1 then
    begin
      Case at of
        atTop :
          begin
            Items.Insert(0, s);
          end;
        atBottom :
          begin
            Items.Add(s);
          end;
        atSorted :
          begin
            Items.Add(s);
            Sorted := True;
          end;
      end;
    end
    else
    begin
      Items.Delete(iRes);
      UAddNewItem(s, atTop);
    end;
  end;
  Text := s;
end;

procedure THideComboBox.UAddNewItem(AddString: String; at: TAddType);
var
  iRes : Integer;
  s : String;
begin
  s := Trim(AddString);
  if s <> '' then
  begin
    iRes := Items.IndexOf(s);
    if iRes = -1 then
    begin
      Case at of
        atTop :
          begin
            Items.Insert(0, s);
          end;
        atBottom :
          begin
            Items.Add(s);
          end;
        atSorted :
          begin
            Items.Add(s);
            Sorted := True;
          end;
      end;
    end;
  end;
end;

procedure THideComboBox.SetShowDefaultStr(const Value: Boolean);
begin
  FShowDefaultStr := Value;
  Invalidate;
end;

procedure THideComboBox.SetDefaultStr(const Value: String);
begin
  FDefaultStr := Value;
  Invalidate;
end;

procedure THideComboBox.DoEnter;
begin
  inherited;
  if FShowDefaultStr then
  begin
    if Text = FDefaultStr then
    begin
      Text := '';
      Font.Color := clWindowText;
    end;
  end;
end;

procedure THideComboBox.DoExit;
begin
  inherited;
  if FShowDefaultStr then
  begin
    if (Text = '') or (Text = FDefaultStr) then
    begin
      Font.Color := $00C8C8C8;
      Text := FDefaultStr;
    end;
  end;
end;

end.

