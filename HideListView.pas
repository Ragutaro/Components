unit HideListView;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
  Vcl.ComCtrls, Winapi.Commctrl;

type
  TListItemData = record
    SubItemsImage : array of Integer;
    Checked : Boolean;
  end;

  TSortOrder = (soAscending, soDescending);
  TCustomHideListView = class(TListView)
  private
    { Private 宣言 }
    FHoverColor : TColor;
    FHoverFontColor : TColor;
    FUnevenColor : TColor;
    FEvenColor : TColor;
    FSortIndex : Integer;
    FSortOrder : TSortOrder;
    FCompareByString : Boolean;
    FWrapAround : Boolean;
    FStartIndex : Integer;
    FCurIndex : Integer;
    FClickedColumnIndex : Integer;
    FDefaultSortOrder: TSortOrder;

    procedure SetHoverColor(Value: TColor);
    procedure SetHoverFontColor(Value: TColor);
    procedure SetUnevenColor(Value: TColor);
    procedure SetEvenColor(Value: TColor);
    procedure SetSortIndex(Value : Integer);
    procedure SetSortOrder(Value : TSortOrder);
    procedure SetWrapAround(Value : Boolean);
    procedure GetListItemData(var id1, id2: TListItemData; UpItem: Boolean);
    procedure SetListItemData(var id1, id2: TListItemData; UpItem: Boolean);
    procedure SetDefaultSortOrder(const Value: TSortOrder);
    property  SortIndex : Integer read FSortIndex write SetSortIndex;
    procedure CompareEx(Sender: TObject; Item1, Item2: TListItem; Data: Integer; var Compare: Integer);
  protected
    { Protected 宣言 }
  public
    { Public 宣言 }
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    procedure SelectFirstItem;
    procedure SelectLastItem;
    procedure ShowLastItem;
    procedure MoveSelectedItem;
    procedure UpListItem;
    procedure DownListItem;
    procedure ColumnClickEx(Column: TListColumn; CompByStr : Boolean);
    procedure ChangeSortOrder;
    procedure DeleteAllSelectedItems;
    function  SearchString(SubStr: String; SubItems: Boolean): TListItem;
    function  SelectPrevItem: Boolean;
    function  SelectNextItem: Boolean;
    procedure MoveListItems;
    procedure KeyDown(var Key: Word; Shift: TShiftState);override;
    function  FindSubItem(const SubStr: String; const IndexOfSubItem: Integer): TListItem;
    procedure CheckAllItems;
    procedure UnCheckAllItems;
    procedure ReverseCheckedItems;
    procedure CheckSelectedItems;
    procedure UnCheckSelectedItems;
    procedure DeleteCheckedItems;
    function  CheckedCount: Integer;
    procedure SetBkColor(Item: TListItem);
    procedure SetHoverStyle(State: TCustomDrawState; var DefaultDraw: Boolean;
                            AFontStyles: TFontStyles = [fsUnderline]);
    procedure ColorizeLines(Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean;
                            AFontStyles: TFontStyles = [fsUnderline]);
    property SortOrder        : TSortOrder  read FSortOrder         write SetSortOrder;
    property WrapAround       : Boolean     read FWrapAround        write SetWrapAround;
    property DefaultSortOrder : TSortOrder  read FDefaultSortOrder  write SetDefaultSortOrder;
    property HoverColor       : TColor      read FHoverColor        write SetHoverColor;
    property HoverFontColor   : TColor      read FHoverFontColor    write SetHoverFontColor;
    property UnevenColor      : TColor      read FUnevenColor       write SetUnevenColor;
    property EvenColor        : TColor      read FEvenColor         write SetEvenColor;
  published
    { Published 宣言 }
  end;

  THideListView = class(TCustomHideListView)
  published
    property DefaultSortOrder;
    property EvenColor;
    property HoverColor;
    property HoverFontColor;
    property SortOrder;
    property UnevenColor;
    property WrapAround;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('HaS', [THideListView]);
end;

{ THideListView }

procedure TCustomHideListView.ChangeSortOrder;
begin
  if SortOrder = soAscending then
    Self.SortOrder := soDescending
  else
    Self.SortOrder := soAscending;
end;

procedure TCustomHideListView.CheckAllItems;
var
  i : Integer;
begin
  for i := 0 to Self.Items.Count-1 do
  begin
    Self.Items[i].Checked := True;
  end;
end;

function TCustomHideListView.CheckedCount: Integer;
var
  item : TListItem;
  i, iCnt : Integer;
begin
  iCnt := 0;
  for i := 0 to Self.Items.Count-1 do
  begin
    item := Self.Items[i];
    if item.Checked then
      iCnt := iCnt + 1;
  end;
  Result := iCnt;
end;

procedure TCustomHideListView.CheckSelectedItems;
var
  item : TListItem;
  i : Integer;
begin
  for i := 0 to Self.Items.Count-1 do
  begin
    item := Self.Items[i];
    if item.Selected then
      item.Checked := True;
  end;
end;

procedure TCustomHideListView.ColorizeLines(Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean;
                                            AFontStyles: TFontStyles = [fsUnderline]);
begin
  SetBkColor(Item);
  SetHoverStyle(State, DefaultDraw, AFontStyles);
//  with Self.Canvas do
//  begin
//    Brush.Style := bsSolid;
//    if Not Odd(Item.Index) then
//      Brush.Color := FUnevenColor
//    else
//      Brush.Color := clWindow;
//
//    if cdsHot in State then
//    begin
//      Brush.Color := FHoverColor;
//      Font.Color  := clWindowText;
//      Font.Color  := FHoverFontColor;
//      Font.Style  := AFontStyles;
//    end
//  end;
end;

procedure TCustomHideListView.ColumnClickEx(Column: TListColumn; CompByStr: Boolean);
begin
  FCompareByString := CompByStr;
  Self.SortIndex   := Column.Index;
  if Column.Index <> FClickedColumnIndex then
  begin
    Self.SortOrder := soAscending;
  end;
  Self.AlphaSort;
  Self.ChangeSortOrder;
  FClickedColumnIndex := Column.Index;
end;

function StrToIntDefEx(const S: WideString; Default: Integer): Integer;
var
  i : Cardinal;
  Value : String;
begin
  Value := '';
  for i := 1 to Length(S) do
  begin
    if Pos(S[i], '0123456789-') > 0 then
      Value := Value + S[i];
  end;
  if Value = '' then
    Value := IntToStr(Default);
  Result := StrToInt(Value);
end;

procedure TCustomHideListView.CompareEx(Sender: TObject; Item1, Item2: TListItem;
  Data: Integer; var Compare: Integer);
var
  iKey, iMask, iMax : Integer;
  s1, s2 : String;
begin
  iKey := Self.SortIndex;

  if Self.SortOrder = soAscending then
    iMask := 1
  else
    iMask := -1;

  try
    if FCompareByString then
    begin
      //デフォルト機能(文字列でソート)
      if iKey = 0 then
        Compare := iMask * CompareStr(Item1.Caption, Item2.Caption)
      else
        Compare := iMask * CompareStr(Item1.SubItems[iKey-1], Item2.SubItems[iKey-1]);
    end else
    begin
      //拡張機能版(数値でソート)
      iMax := iMask * MaxInt;
      if iKey = 0 then
      begin
        s1 := Item1.Caption;
        s2 := Item2.Caption;
      end else
      begin
        s1 := Item1.SubItems[iKey-1];
        s2 := Item2.SubItems[iKey-1];
      end;

      if StrToIntDefEx(s1, iMax) < StrToIntDefEx(s2, iMax) then
        Compare := iMask * -1
      else if StrToIntDefEx(s1, iMax) = StrToIntDefEx(s2, iMax) then
        Compare := 0
      else
        Compare := iMask * 1;
    end;
  except
    //
  end;
end;

constructor TCustomHideListView.Create(AOwner: TComponent);
begin
  Self.OnCompare  := CompareEx;
  HotTrackStyles  := [htHandPoint, htUnderlineHot];
  RowSelect       := True;
  ReadOnly        := True;
  FStartIndex     := 0;
  FClickedColumnIndex := -1;
  FHoverColor     := $00FFF3E5;
  FHoverFontColor := clTeal;
  FUnevenColor    := $00FEFAF8;
  FEvenColor      := clWindow;
  inherited Create(AOwner);
end;

procedure TCustomHideListView.DeleteAllSelectedItems;
begin
  Self.Items.BeginUpdate;
  Self.OnChange := nil;
  try
    while Self.SelCount > 0 do
      Self.Selected.Delete;
  finally
    Self.OnChange := OnChange;
    Self.Items.EndUpdate;
  end;
end;

procedure TCustomHideListView.DeleteCheckedItems;
var
  i : Integer;
begin
  Self.Items.BeginUpdate;
  Self.OnChange := nil;
  try
    for i := Self.Items.Count-1 downto 0 do
    begin
      if Self.Items[i].Checked then
        Self.Items[i].Delete;
    end;
  finally
    Self.OnChange := OnChange;
    Self.Items.EndUpdate;
  end;
end;

destructor TCustomHideListView.Destroy;
begin
  inherited;
end;

procedure TCustomHideListView.DownListItem;
var
  item, tempItem: TListItem;
  iIndex : Integer;
  lid1, lid2 : TListItemData;
begin
  item := Self.Selected;
  if item = nil Then
    Exit
  else
    iIndex := item.Index;

  tempItem := TListItem.Create(Self.Items);
  try
    if iIndex = Self.Items.Count-1 then Exit;

    SetLength(lid1.SubItemsImage, item.SubItems.Count);
    SetLength(lid2.SubItemsImage, item.SubItems.Count);
    with Self.Items do
    begin
      GetListItemData(lid1, lid2, False);
      tempItem.Assign(Item[iIndex]);
      Item[iIndex].Assign(Self.Items.Item[iIndex+1]);
      Item[iIndex+1].Assign(tempItem);
      Item[iIndex].Focused    := False;
      Item[iIndex].Selected   := False;
      Item[iIndex+1].Focused  := True;
      Item[iIndex+1].Selected := True;
      Item[iIndex+1].MakeVisible(True);
      SetListItemData(lid1, lid2, False);
    end;
  finally
    tempItem.Free;
  end;
end;

function TCustomHideListView.FindSubItem(const SubStr: String; const IndexOfSubItem: Integer): TListItem;
var
  item : TListItem;
  i : Integer;
  s : String;
begin
  Result := nil;
  s := LowerCase(SubStr);
  for i := 0 to Self.Items.Count-1 do
  begin
    item := Self.Items[i];
    if s = LowerCase(item.SubItems[IndexOfSubItem]) then
    begin
    	Result := item;
      Break;
    end;
  end;
end;

procedure TCustomHideListView.GetListItemData(var id1, id2: TListItemData; UpItem: Boolean);
var
  i : Integer;
begin
  FCurIndex := Self.Selected.Index;
  Case UpItem of
    True :
      begin
        if FCurIndex = 0 then Exit;
        for i := 0 to Length(id1.SubItemsImage)-1 do
        begin
          id1.SubItemsImage[i] := Self.Items.Item[FCurIndex].SubItemImages[i];
          id2.SubItemsImage[i] := Self.Items.Item[FCurIndex-1].SubItemImages[i];
        end;
        id1.Checked := Self.Items.Item[FCurIndex].Checked;
        id2.Checked := Self.Items.Item[FCurIndex-1].Checked;
      end;
    False :
      begin
        if FCurIndex = Self.Items.Count-1 then Exit;
        for i := 0 to Length(id1.SubItemsImage)-1 do
        begin
          id1.SubItemsImage[i] := Self.Items.Item[FCurIndex].SubItemImages[i];
          id2.SubItemsImage[i] := Self.Items.Item[FCurIndex+1].SubItemImages[i];
        end;
        id1.Checked := Self.Items.Item[FCurIndex].Checked;
        id2.Checked := Self.Items.Item[FCurIndex+1].Checked;
      end;
  end;
end;

procedure TCustomHideListView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited;
  if FWrapAround then
  begin
    if Self.ItemIndex = 0 then
    begin
      if Key = VK_UP then
      begin
        Key := 0;
        Self.Items[0].Selected := False;
        Self.ItemIndex := Self.Items.Count - 1;
        Self.ItemFocused := Self.Items[Self.ItemIndex];
        Self.Items[Self.ItemIndex].MakeVisible(True);
      end;
    end else
    if Self.ItemIndex = Self.Items.Count - 1 then
    begin
      if Key = VK_DOWN then
      begin
        Key := 0;
        Self.Items[Self.Items.Count-1].Selected := False;
        Self.ItemIndex := 0;
        Self.ItemFocused := Self.Items[Self.ItemIndex];
        Self.Items[Self.ItemIndex].MakeVisible(True);
      end;
    end;
  end;
end;

procedure TCustomHideListView.MoveSelectedItem;
var
  id1, id2, i : Integer;
  li : TListItemData;
begin
  id1 := Self.Selected.Index;
  id2 := Self.DropTarget.Index;

  if (id1 = -1) or (id2 = -1) or (id1 = id2) then
    Exit;

  with Self.Items do
  begin
    BeginUpdate;
    //SubitemImageを保存する配列の設定
    SetLength(li.SubItemsImage, Item[id1].SubItems.Count);
    for i := 0 to Length(li.SubItemsImage)-1 do
      li.SubItemsImage[i] := Item[id1].SubItemImages[i];

    if id1 > id2 then
    begin
      //上にドロップ
      Insert(id2);
      Item[id2] := Item[id1+1];
      Delete(id1+1);
      Item[id2].Selected := True;
      Item[id2].Focused  := True;
      //SubitemImageを設定
      for i := 0 to Length(li.SubItemsImage)-1 do
        Item[id2].SubItemImages[i] := li.SubItemsImage[i];
    end else
    begin
      //下にドロップ
      Insert(id2+1);
      Item[id2+1] := Item[id1];
      Delete(id1);
      Item[id2].Selected := True;
      Item[id2].Focused  := True;
      //SubitemImageを設定
      for i := 0 to Length(li.SubItemsImage)-1 do
        Item[id2].SubItemImages[i] := li.SubItemsImage[i];
    end;
    EndUpdate;
  end;//with
  Self.SetFocus;
end;

procedure TCustomHideListView.ReverseCheckedItems;
var
  item : TListItem;
  i : Integer;
begin
  for i := 0 to Self.Items.Count-1 do
  begin
    item := Self.Items[i];
    item.Checked := Not item.Checked;
  end;
end;

procedure TCustomHideListView.MoveListItems;
var
  newItem, item : TListItem;
  idx, i : Integer;
  bMoveUp : Boolean;
begin
  idx := Self.DropTarget.Index;

  //上下動のチェック
  bMoveUp := False;
  for i := 0 to Self.Items.Count-1 do
  begin
    item := Self.Items[i];
    if item.Selected then
    begin
    	if idx = item.Index then
        Exit
      else if idx < item.Index then
      begin
    	  bMoveUp := True;
        Break;
      end;
    end;
  end;

  //上に移動
  idx := idx + 1;
  Case bMoveUp of
    True :
      begin
        for i := 0 to Self.Items.Count-1 do
        begin
          item := Self.Items[i];
          if item.Selected then
          begin
            newItem := Self.Items.Insert(idx);
            newItem.Assign(item);
            newItem.Selected := True;
            newItem.Focused := True;
            item.Delete;
            Inc(idx);
          end;
        end;
      end;
    False :
      begin
        for i := Self.Items.Count-1 downto 0 do
        begin
          item := Self.Items[i];
          if item.Selected then
          begin
            newItem := Self.Items.Insert(idx);
            newItem.Assign(item);
            newItem.Selected := True;
            newItem.Focused := True;
            item.Delete;
            Dec(idx);
          end;
        end;
      end;
  end;
end;

function TCustomHideListView.SearchString(SubStr: String;
  SubItems: Boolean): TListItem;
var
  item : TListItem;
  i, j : Integer;
  bFound, bSubFound : Boolean;
begin
  //初期値設定
  Result := nil;
  bFound := False;
  bSubFound := False;

  //リストが空の場合
  if Self.Items.Count = 0 then
  begin
    Exit;
  end;
  //処理開始
  SubStr := LowerCase(SubStr);
  for i := FStartIndex to Self.Items.Count-1 do
  begin
    item := Self.Items.Item[i];
    if AnsiPos(SubStr, LowerCase(item.Caption)) > 0 then
    begin
      Result := item;
      FStartIndex := item.Index+1;
      bFound := True;
      Break;
    end;
    //SubItems = Trueの時
    if SubItems then
    begin
      for j := 0 to item.SubItems.Count-1 do
      begin
        if AnsiPos(SubStr, LowerCase(item.SubItems[j])) > 0 then
        begin
          Result := item;
          FStartIndex := item.Index+1;
          bSubFound := True;
          Break;
        end;
      end;
      if bSubFound then
        Break;
    end;
  end;
  //見つからなかった場合
  if (Not bFound) and (Not bSubFound) then
  begin
//    Beep;
    FStartIndex := 0;
  end;
end;

procedure TCustomHideListView.SelectFirstItem;
begin
  if Self.Items.Count > 0 then
  begin
    with Self.Items[0] do
    begin
      MakeVisible(True);
      Selected := True;
      Focused  := True;
    end;//with
  end;
end;

procedure TCustomHideListView.SelectLastItem;
begin
  if Self.Items.Count > 0 then
  begin
    with Self.Items[Self.Items.Count-1] do
    begin
      MakeVisible(True);
      Selected := True;
      Focused  := True;
    end;//with
  end;
end;

function TCustomHideListView.SelectNextItem: Boolean;
var
  idx : Integer;
begin
  idx := Self.ItemIndex;
  if idx + 1 < Self.Items.Count then
  begin
    Self.Items.Item[idx].Selected   := False;
    Self.Items.Item[idx].Focused    := False;
    Self.Items.Item[idx+1].Selected := True;
    Self.Items.Item[idx+1].Focused  := True;
    Result := True;
  end else
    Result := False;
end;

function TCustomHideListView.SelectPrevItem: Boolean;
var
  idx : Integer;
begin
  idx := Self.ItemIndex;
  if idx > 0 then
  begin
    Self.Items.Item[idx-1].Selected := True;
    Self.Items.Item[idx-1].Focused  := True;
    Result := True;
  end else
    Result := False;
end;

procedure TCustomHideListView.SetBkColor(Item: TListItem);
begin
  with Self.Canvas do
  begin
    Brush.Style := bsSolid;
    if Not Odd(Item.Index) then
      Brush.Color := FUnevenColor
    else
      Brush.Color := FEvenColor;
  end;
end;

procedure TCustomHideListView.SetDefaultSortOrder(const Value: TSortOrder);
begin
  FDefaultSortOrder := Value;
//  Invalidate;
end;


procedure TCustomHideListView.SetEvenColor(Value: TColor);
begin
  if FEvenColor <> Value then
    FEvenColor := Value;
end;

procedure TCustomHideListView.SetHoverColor(Value: TColor);
begin
  if FHoverColor <> Value then
  	FHoverColor := Value;
end;

procedure TCustomHideListView.SetHoverFontColor(Value: TColor);
begin
  if FHoverFontColor <> Value then
    FHoverFontColor := Value;
end;

procedure TCustomHideListView.SetHoverStyle(State: TCustomDrawState;
  var DefaultDraw: Boolean; AFontStyles: TFontStyles = [fsUnderline]);
begin
  with Self.Canvas do
  begin
    if cdsHot in State then
    begin
      Brush.Style := bsSolid;
      Brush.Color := HoverColor;
      Font.Style  := AFontStyles;
      Font.Color  := HoverFontColor;
    end;
  end;
end;

procedure TCustomHideListView.SetListItemData(var id1, id2: TListItemData;
  UpItem: Boolean);
var
  i : Integer;
begin
  Case UpItem of
    True :
      begin
        //SubitemImageを設定
        for i := 0 to Length(id1.SubItemsImage)-1 do
        begin
          Self.Items.Item[FCurIndex-1].SubItemImages[i] := id1.SubItemsImage[i];
          Self.Items.Item[FCurIndex].SubItemImages[i]   := id2.SubItemsImage[i];
        end;
        Self.Items.Item[FCurIndex-1].Checked := id1.Checked;
        Self.Items.Item[FCurIndex].Checked := id2.Checked;
      end;
    False :
      begin
        for i := 0 to Length(id1.SubItemsImage)-1 do
        begin
          Self.Items.Item[FCurIndex+1].SubItemImages[i] := id1.SubItemsImage[i];
          Self.Items.Item[FCurIndex].SubItemImages[i]   := id2.SubItemsImage[i];
        end;
        Self.Items.Item[FCurIndex+1].Checked := id1.Checked;
        Self.Items.Item[FCurIndex].Checked := id2.Checked;
      end;
  end;
end;

procedure TCustomHideListView.SetSortIndex(Value: Integer);
begin
  FSortIndex := Value;
  Invalidate;
end;

procedure TCustomHideListView.SetSortOrder(Value: TSortOrder);
begin
  FSortOrder := Value;
  Invalidate;
end;

procedure TCustomHideListView.SetUnevenColor(Value: TColor);
begin
  if FUnevenColor <> Value then
    FUnevenColor := Value;
end;

procedure TCustomHideListView.SetWrapAround(Value: Boolean);
begin
  FWrapAround := Value;
  if FWrapAround then Invalidate;
end;

procedure TCustomHideListView.ShowLastItem;
begin
  if Self.Items.Count > 0 then
  begin
    with Self.Items[Self.Items.Count-1] do
    begin
      MakeVisible(True);
    end;//with
  end;
end;

procedure TCustomHideListView.UnCheckAllItems;
var
  i : Integer;
begin
  for i := 0 to Self.Items.Count-1 do
  begin
    Self.Items[i].Checked := False;
  end;
end;

procedure TCustomHideListView.UnCheckSelectedItems;
var
  item : TListItem;
  i : Integer;
begin
  for i := 0 to Self.Items.Count-1 do
  begin
    item := Self.Items[i];
    if item.Selected then
      item.Checked := False;
  end;
end;

procedure TCustomHideListView.UpListItem;
var
  item, tempItem: TListItem;
  iIndex : Integer;
  lid1, lid2 : TListItemData;
begin
  item := Self.Selected;
  if item = nil Then
    Exit
  else
    iIndex := item.Index;

  tempItem := TListItem.Create(Self.Items);
  try
    if iIndex = 0 then Exit;

    SetLength(lid1.SubItemsImage, item.SubItems.Count);
    SetLength(lid2.SubItemsImage, item.SubItems.Count);
    with Self.Items do
    begin
      GetListItemData(lid1, lid2, True);
      tempItem.Assign(Item[iIndex]);
      Item[iIndex].Assign(Item[iIndex-1]);
      Item[iIndex-1].Assign(tempItem);
      Item[iIndex].Focused    := False;
      Item[iIndex].Selected   := False;
      Item[iIndex-1].Focused  := True;
      Item[iIndex-1].Selected := True;
      Item[iIndex-1].MakeVisible(True);
      SetListItemData(lid1, lid2, True);
    end;
  finally
    tempItem.Free;
  end;
end;

end.
