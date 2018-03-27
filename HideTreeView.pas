unit HideTreeView;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Controls,
  Vcl.ComCtrls, Vcl.Forms, WinApi.ShellAPI, System.Types, VCL.Graphics;

type
  TCustomHideTreeView = class(TTreeView)
  private
    { Private 宣言 }
    FHoverColor : TColor;
    FHoverFontColor : TColor;
    FIncludeRoot : Boolean;
    FIncludeAppPath : Boolean;
    FInsertFolder : String;
    procedure SetHoverColor(Value : TColor);
    procedure SetHoverFontColor(Value : TColor);
    procedure SetIncludeRoot(AValue: Boolean);
    procedure SetIncludeAppPath(AValue: Boolean);
    procedure SetInsertFolder(AValue: String);
  protected
    { Protected 宣言 }
  public
    { Public 宣言 }
    constructor Create(AOwner:TComponent);override;
    destructor Destroy;override;
    function GetFullNodePath(Node: TTreeNode; Demiliter: String = '\'): String;
    procedure VisibleNode(Path: String);
    procedure SaveToFileEx(const FileName: String);
    procedure LoadFromFileEx(const FileName: String);
    procedure AddChildNode(const Caption: String; const ImageIndex, SelectedImage : Integer);
    procedure ExecuteByExplorer(const RootFolder: String);
    procedure AddChildNodes(Node: TTreeNode; Path: String; Imageindex, SelectedImage: Integer); overload;
    procedure AddChildNodes(Node: TTreeNode; Path: TStringDynArray; ErasePath: String; Imageindex, SelectedImage: Integer); overload;
    procedure ColorizeNodes(Node: TTreeNode; State: TCustomDrawState; var DefaultDraw: Boolean; AFontStyles: TFontStyles = [fsUnderline]);
    function IsExistSameNode(Parent: TTreeNode; substr: String): Boolean;
    function IndexofSameNode(Parent: TTreeNode; substr: String): Integer;
    function GetSelectedNodeLevel: Integer;
    function GetNodeLevel(node: TTreeNode): Integer;
    function IsExistChild(Node: TTreeNode; substr: String): Boolean;
    function IndexofChildNode(Node: TTreeNode; substr: String): Integer;
    function GetChildNode(ParentNode: TTreeNode; substr: String): TTreeNode;
  published
    { Published 宣言 }
    property IncludeRootNode: Boolean read FIncludeRoot write SetIncludeRoot;
    property IncludeAppPath: Boolean read FIncludeAppPath write SetIncludeAppPath;
    property InsertFolder: String read FInsertFolder write SetInsertFolder;
    property HoverColor: TColor read FHoverColor write SetHoverColor;
    property HoverFontColor: TColor read FHoverFontColor write SetHoverFontColor;
  end;

  THideTreeView = class(TCustomHideTreeView)
  published
    property IncludeRootNode default False;
    property IncludeAppPath default False;
    property InsertFolder;
    property HoverColor;
    property HoverFontColor;
  end;

procedure Register;

implementation

uses System.StrUtils;

procedure Register;
begin
  RegisterComponents('HaS', [THideTreeView]);
end;

procedure TCustomHideTreeView.SetInsertFolder(AValue: String);
begin
  FInsertFolder := AValue;
  if FInsertFolder <> '' then Invalidate;
end;

procedure TCustomHideTreeView.SetIncludeRoot(AValue: Boolean);
begin
  FIncludeRoot := AValue;
  if FIncludeRoot then Invalidate; { FInclude = True のときだけ表示更新 }
end;

procedure TCustomHideTreeView.ColorizeNodes(Node: TTreeNode; State: TCustomDrawState;
  var DefaultDraw: Boolean; AFontStyles: TFontStyles = [fsUnderline]);
begin
  with Self.Canvas do
  begin
    if cdsHot in State then
    begin
      Brush.Style := bsSolid;
      Brush.Color := HoverColor;
      Font.Color  := HoverFontColor;
      Font.Style  := AFontStyles;
    end;
  end;
end;

procedure TCustomHideTreeView.SetHoverColor(Value: TColor);
begin
  if FHoverColor <> Value then
    FHoverColor := Value;
end;

procedure TCustomHideTreeView.SetHoverFontColor(Value: TColor);
begin
  if FHoverColor <> Value then
    FHoverFontColor := Value;
end;

procedure TCustomHideTreeView.SetIncludeAppPath(AValue: Boolean);
begin
  FIncludeAppPath := AValue;
  if FIncludeAppPath then Invalidate; { FInclude = True のときだけ表示更新 }
end;

function TCustomHideTreeView.GetChildNode(ParentNode: TTreeNode;
  substr: String): TTreeNode;
var
  n: TTreeNode;
begin
  Result := nil;
  n := ParentNode.getFirstChild;
  while n <> nil do
  begin
    if SameText(n.Text, substr) then
    begin
    	Result := n;
      Exit;
    end;
    n := ParentNode.GetNextChild(n);
  end;
end;

function TCustomHideTreeView.GetFullNodePath(Node: TTreeNode; Demiliter: String = '\'): String;
var
  n : TTreeNode;
  s, sApp, sFolder : String;
begin
  s := '';
	sApp := '';
	sFolder := '';
  n := TTreeNode(node);
  //アプリケーションパスの指定が True の場合
  if FIncludeAppPath then
    sApp := ExtractFilePath(Application.Exename);

  //アプリケーションパスとツリービューのフォルダパスの間に
  //フォルダ名を挿入する場合
  if FInsertFolder <> '' then
    sFolder := FInsertFolder;

  //引数Node が nil の場合
  if n = nil then
    n := Self.Selected;

  if FIncludeRoot then
  begin
    // IncludeRootNode = True
    while n <> nil do
    begin
      Insert(Demiliter + n.Text, s, 1);
      n := n.Parent;
    end;
  end else
  begin
    // IncludeRootNode = False
    while n.Parent <> nil do
    begin
      Insert(Demiliter + n.Text, s, 1);
      n := n.Parent;
    end;
  end;

  //戻り値の設定
  Result := sApp + sFolder + s;
end;

function TCustomHideTreeView.GetNodeLevel(node: TTreeNode): Integer;
begin
  Result := 0;
  while node.Parent <> nil do
  begin
    Result := Result + 1;
    node := node.Parent;
  end;
end;

function TCustomHideTreeView.GetSelectedNodeLevel: Integer;
begin
  Result := GetNodeLevel(Self.Selected);
end;

function TCustomHideTreeView.IndexofChildNode(Node: TTreeNode;
  substr: String): Integer;
var
  n: TTreeNode;
begin
  Result := -1;
  n := Node.getFirstChild;
  while n <> nil do
  begin
    if  SameText(n.Text, substr) then
    begin
    	Result := n.Index;
      Exit;
    end;
    n := Node.GetNextChild(n);
  end;
end;

function TCustomHideTreeView.IndexofSameNode(Parent: TTreeNode;
  substr: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  for i := 0 to Parent.Count-1 do
  begin
    if SameText(substr, Parent.Item[i].Text) then
    begin
    	Result := i;
      Break;
    end;
  end;
end;

function TCustomHideTreeView.IsExistChild(Node: TTreeNode; substr: String): Boolean;
begin
  if IndexofChildNode(Node, substr) = -1 then
    Result := False
  else
    Result := True;
end;

function TCustomHideTreeView.IsExistSameNode(Parent: TTreeNode;
  substr: String): Boolean;
var
  i : Integer;
begin
  Result := False;
  for i := 0 to Parent.Count-1 do
  begin
    if SameText(substr, Parent.Item[i].Text) then
    begin
    	Result := True;
      Break;
    end;
  end;
end;

//Path には Son\Grandson の形式で値を渡す
procedure TCustomHideTreeView.AddChildNodes(Node: TTreeNode; Path: String; Imageindex, SelectedImage: Integer);
var
  sList : TStringDynArray;
  s : String;
  i : Integer;
begin
  sList := SplitString(Path, '\');
  for s in sList do
  begin
    i := IndexofSameNode(Node, s);
    if i > -1 then
      Node := Node.Item[i]
    else
    begin
    	Node := Self.Items.AddChild(Node, s);
      Node.ImageIndex    := Imageindex;
      Node.SelectedIndex := SelectedImage;
    end;
  end;
end;

//  Path        TstringDynArray型で作成したいフォルダのリストを渡す。
//  ErasePath   置換したいパスがある場合は、そのパスを渡す。
//              ex. C:\Users\Test\Create1\Create2\Create3 で、
//                  ErasePath = C:\Users\Test\ とすると、
//                  Create1\Create2\Create3 が次の関数に渡される。
procedure TCustomHideTreeView.AddChildNodes(Node: TTreeNode;
  Path: TStringDynArray; ErasePath: String; Imageindex, SelectedImage: Integer);
var
  s : String;
begin
  for s in Path do
  begin
    AddChildNodes(Node, ReplaceText(s, ErasePath, ''), Imageindex, SelectedImage);
  end;
  Node.AlphaSort(True);
end;

constructor TCustomHideTreeView.Create(AOwner: TComponent);
begin
  HotTrack        := True;
  FIncludeRoot    := False;
  FIncludeAppPath := False;
  FHoverColor     := $00FFF3E5;
  FHoverFontColor := clTeal;
  inherited Create(AOwner);
end;

destructor TCustomHideTreeView.Destroy;
begin
  inherited Destroy;
end;

procedure TCustomHideTreeView.ExecuteByExplorer(const RootFolder: String);
var
  n : TTreeNode;
  sFilename, sParam, sDirectory : String;
begin
  n := Selected;
  if n <> nil then
  begin
    sFilename := 'explorer.exe';
    sParam := '/root, /select, ' + RootFolder + GetFullNodePath(n);
    sDirectory := '';
    ShellExecuteW(Self.Handle, 'open', PWideChar(sFilename), PWideChar(sParam), PWideChar(sDirectory), SW_NORMAL);
  end;
end;

procedure TCustomHideTreeView.LoadFromFileEx(const FileName: String);
  procedure GetBufStart(Buffer: String; var Level: Integer);
  var
    i : Integer;
  begin
    Level := 0;
    for i := 1 to Length(Buffer) do
    begin
      if (Buffer[i] = ' ') or (Buffer[i] = #9) then
      begin
        Inc(Level);
      end else
      begin
        Break;
      end;
    end;
  end;

var
  sm, sl: TStringList;
  node, NextNode: TTreeNode;
  ALevel, i: Integer;
  bExpand : Boolean;
begin
  sm := TStringList.Create;
  sl := TStringList.Create;
  Self.Items.BeginUpdate;
  try
    Self.Items.Clear;
    sm.LoadFromFile(FileName, TEncoding.UTF8);
    bExpand := False;
    node := nil;
    for i := 0 to sm.Count - 1 do
    begin
      GetBufStart(sm[i], ALevel);
      sl.CommaText := Trim(sm[i]);
      if node = nil then
      begin
        node := Self.Items.AddChild(nil, sl[0]);
      end
      else if node.Level = ALevel then
      begin
        node := Self.Items.AddChild(node.Parent, sl[0]);
      end
      else if node.Level = (ALevel - 1) then
      begin
        node := Self.Items.AddChild(node, sl[0]);
      end
      else if node.Level > ALevel then
      begin
        NextNode := node.Parent;
        while NextNode.Level > ALevel do
          NextNode := NextNode.Parent;
        node := Self.Items.AddChild(NextNode.Parent, sl[0]);
      end;
      node.ImageIndex := StrToInt(sl[1]);
      node.SelectedIndex := StrToInt(sl[2]);
      if bExpand then
        node.Parent.Expanded := True;
      bExpand := StrToBool(sl[3]);
      node.Selected := StrToBool(sl[4]);
    end;
  finally
    sm.Free;
    sl.Free;
    Self.Items.EndUpdate;
  end;
end;

procedure TCustomHideTreeView.SaveToFileEx(const FileName: String);
const
  sTab = #9;
  sNull = '';
  q1 = '"';
  q2 = '","';
var
  sl, sm : TStringList;
  i: Integer;
  node: TTreeNode;
  NodeStr: String;
begin
  if Self.Items.Count > 0 then
  begin
    sl := TStringList.Create;
    sm := TStringList.Create;
    try
      node := Self.Items[0];
      while node <> nil do
      begin
        NodeStr := sNull;
        for i := 0 to node.Level - 1 do
        begin
          NodeStr := NodeStr + sTab;
        end;
        sm.Clear;
        sm.Add(node.Text);
        sm.Add(IntToStr(node.ImageIndex));
        sm.Add(IntToStr(node.SelectedIndex));
        sm.Add(BoolToStr(node.Expanded));
        sm.Add(BoolToStr(node.Selected));
        sl.Add(NodeStr + sm.CommaText);
        node := node.GetNext;
      end;
      sl.SaveToFile(FileName, TEncoding.UTF8);
    finally
      sl.Free;
      sm.Free;
    end;
  end;
end;

procedure TCustomHideTreeView.VisibleNode(Path: String);
const
  RETURN : String = #13#10;
var
  n, m : TTreeNode;
  sl : TStringList;
  i : Integer;
begin
  n := Self.Items[0];
  if n = nil then Exit;

  sl := TStringList.Create;
  try
    sl.Text := ReplaceText(Path, '\', RETURN);
    for i := 0 to sl.Count-1 do
    begin
      m := n.getFirstChild;
      if m.Text <> sl[i] then
      begin
        repeat
          m := n.GetNextChild(m);
        until m.Text = sl[i];
      end;
      n := m;
    end;

    if n <> nil then
    begin
      n.Selected := True;
      n.MakeVisible;
    end;
  finally
    sl.Free;
  end;
end;

procedure TCustomHideTreeView.AddChildNode(const Caption: String; const ImageIndex,
  SelectedImage: Integer);
var
  node : TTreeNode;
begin
  node := Self.Selected;
  if node <> nil then
  begin
    node := Self.Items.AddChild(node, Caption);
    node.ImageIndex   := ImageIndex;
    node.SelectedIndex:= SelectedImage;
    node.Parent.AlphaSort(True);
  end;
end;

end.
