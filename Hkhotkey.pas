(*
--- THookHotKeyコンポーネント　仕様書 ---

THookHotKeyComponent : Copyright 1998 Hiki Takehito

・THookHotKey 1.0
・製作日 98/02/13
・修正日 98/02/13
・製作者 ひき たけひと
・HomePage http://www.vector.co.jp/authors/VA009712/take/
・E-Mail takeone@pop06.odn.ne.jp
・転載 自由(事前または事後に連絡ください)

・動作保証　Delphi 2.0/3.0
・動作保証OS　Windows95/WindowsNT4

<著作権など>
・THookHotKeyコンポーネントの著作権は「ひき たけひと」に
　属します。
・THookHotKeyコンポーネントを使用していかなる損害が発生
　しても、著作権者は民事上一切の責任を負担しないことと
　見なされます。

<バージョン履歴>
98/02/13
・初版作成

*)
(*
--- THookHotKeyコンポーネント　使用方法 ---

1.概要
　どのアプリケーションがアクティブであっても、あるホットキーが
押されたら自分のアプリに反応させたい、ということはありませんか？
特に常駐型アプリならばホットキーの機能を使う機会が多いでしょう。
THookHotKeyで反応させたいホットキーを登録しておけば、その
ホットキーが押されたというメッセージを取得することができます。
なお、このコンポーネントは「THotKey」コンポーネントと親和性を
持たせてあるので、これと一緒に使う事をお勧めします。

2.インストール
　Delphiのマニュアルに従って普通にインストールして下さい。
インストールすると「System」タブに登録されます。

3.使い方
 (1)基本的な使い方
　THookHotKeyコンポーネント１つで複数のホットキーを登録でき
ます。登録するには「Add」メソッドを使います。「Add」となって
ますが、ListboxやStringListの「Add」とは別物です。「登録する」
という意味で使って下さい。
　Addするときには第一引数として「Index」番号を指定します。
Indexは登録したホットキーの、いわばIDであり、以後はこのIndex
で、登録したホットキーを管理します。Indexには適当な番号を
指定して下さい。
　Addの第二引数には登録するホットキーを指定します。ここは
THotKeyコンポーネントと親和性を持たせるため「TShortcut」型
にしてあります。HotKeyプロパティがTShortcut型だからです。

  (例)HookHotKey1.Add(1, HotKey1.HotKey);

　あとは、登録を消すには「Delete」、変更は「Change」メソッド
を使用して下さい。

 (2)イベントの発生
　登録したホットキーが押されるとOnHotKeyイベントが発生します。
第二引数に「Index」があります。(1)で述べたように、登録した
ホットキーはIndexで管理しているので、ホットキーを複数登録した
場合はこのIndexを見ることで区別できます。

  (例)
   procedure TForm1.HookHotKey1HotKey(Sender: TObject; Index: Integer);
   begin
     case Index of
      1: ShowMessage('Alt+1');
      2: ShowMessage('Ctrl+A');
     end;
   end;

 (3)チェックボックスとの併用
　HotKeyコンポーネントとチェックボックスとの併用を考えて「Apply」
メソッドを用意しています。第三引数にチェックボックスのChecked
プロパティを指定することで、TrueならばChangeメソッドを、False
ならばDeleteメソッドを実行するようにしています。

  (例)HookHotKey1.Apply(1, HotKey1.HotKey, Checkbox1.Checked);


4.リファレンス
<プロパティ>
・Activate: boolean;
　OnHotKeyイベントが発生したとき、THookHotKeyコンポーネントが
　乗っているフォームをアクティブにするか決定します。

<メソッド>
・function Add(Index:integer; HotKey:TShortcut): boolean;
　ホットキーを登録します。
・function Delete(Index:integer): boolean;
　ホットキーの登録を解除します。
・function Change(Index:integer; HotKey:TShortcut): boolean;
　登録したホットキーを変更します。
・function Apply(Index:integer; HotKey:TShortcut; DoHook:boolean): boolean;
　ホットキーの変更を適用します。

<イベント>
・OnHotKey(Sender: TObject; Index: Integer):THotKeyEvent;
　登録したホットキーが押されたときに発生します。

*)

{THookHotKey Component}
unit Hkhotkey;

interface

uses
  Windows, Messages, SysUtils, Controls, Classes, Menus, Forms;

type
  //ERegistHotKey=class(Exception); {例外}

  THotKeyEvent = procedure(Sender: TObject; Index: Integer) of object;

  THookHotKey = class(TComponent)
  private
    { Private 宣言 }
    FActivate:boolean;
    FOnHotKey:THotKeyEvent;
    FWindowHandle:HWND;
    procedure WndProc(var Msg: TMessage);
  protected
    { Protected 宣言 }
    procedure GetHookKey(HotKey:TShortcut; var HookModi:UINT; var HookKey:Word);
    procedure CatchHotKey(Index:integer);dynamic;
  public
    { Public 宣言 }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Add(Index:integer; HotKey:TShortcut): boolean;
    function Delete(Index:integer): boolean;
    function Change(Index:integer; HotKey:TShortcut): boolean;
    function Apply(Index:integer; HotKey:TShortcut; DoHook:boolean): boolean;
  published
    { Published 宣言 }
    property Activate: boolean read FActivate write FActivate default True;
    property OnHotKey: THotKeyEvent read FOnHotKey write FOnHotKey;
  end;

procedure Register;

implementation


{コンポーネントが作成されるときにすること}
constructor THookHotKey.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FActivate:=True;

 //THookHotKeyの継承元はTComponentなので、ウィンドウ
 //ハンドルがない -> ウィンドウメッセージを捕まえられない。
 //しかし、ホットキーが押されたというウィンドウ
 //ハンドル(WM_HOTKEY)を捕らえたい。そこで、ここでウィンドウ
 //ハンドルを作ってしまいます。
 FWindowHandle := AllocateHWnd(WndProc);
end;

{コンポーネントが解放されるときにすること}
destructor THookHotKey.Destroy;
begin
 //作成したウインドウハンドルを解放。
 DeallocateHWnd(FWindowHandle);

 inherited Destroy;
end;

{ウィンドウメッセージを取得}
{註)TTimerのソースを参考にしました。}
procedure THookHotKey.WndProc(var Msg: TMessage);
begin
 with Msg do
 if Msg = WM_HOTKEY then  //ホットキーが押されたら
  try
   CatchHotKey(wParam);   //OnHotKey発生。
  except
   Application.HandleException(Self);
  end
  else
   //その他のメッセージは良きにはからっておく。
   Result:=DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

{OnHotKey発生}
procedure THookHotKey.CatchHotKey(Index:integer);
begin
 if Assigned(FOnHotKey) then
  begin
   if FActivate then SetForegroundWindow(TForm(Owner).Handle);
   FOnHotKey(Self,Index);
  end;
end;

{ホットキーを登録}
function THookHotKey.Add(Index:integer; HotKey:TShortcut): boolean;
var
 HookModi: UINT;
 HookKey: Word;
begin
 GetHookKey(HotKey,HookModi,HookKey);
 Result:=RegisterHotKey(FWindowHandle,Index,HookModi,HookKey);
end;

{フックするホットキーを分析}
procedure THookHotKey.GetHookKey(HotKey:TShortcut; var HookModi: UINT; var HookKey:Word);
var
 Shift: TShiftState;
begin
 HookModi:=0;
 HookKey:=$00;
 ShortcutToKey(HotKey,HookKey,Shift);
 if ssAlt in Shift then HookModi:=HookModi or MOD_ALT;
 if ssShift in Shift then HookModi:=HookModi or MOD_SHIFT;
 if ssCtrl in Shift then HookModi:=HookModi or MOD_CONTROL;
end;

{ホットキーを解除}
function THookHotKey.Delete(Index:integer): boolean;
begin
 Result:=UnRegisterHotKey(FWindowHandle,Index);
end;

{ホットキーを変更}
function THookHotKey.Change(Index:integer; HotKey:TShortcut): boolean;
var
 Success1,Success2:boolean;
begin
 Success1:=Delete(Index);      //いったん消してから
 Success2:=Add(Index,HotKey);  //再登録する。
 if Success1 and Success2 then Result:=True
 else Result:=False;
end;

{ホットキーの変更を適用}
function THookHotKey.Apply(Index:integer; HotKey:TShortcut; DoHook:boolean): boolean;
var
 Success1,Success2:boolean;
begin
 Success1:=False;
 Success2:=False;
 
 if DoHook then Success1:=Change(Index,HotKey)
 else Success2:=Delete(Index);

 if Success1 or Success2 then Result:=True
 else Result:=False;
end;

{コンポーネントの登録}
procedure Register;
begin
  RegisterComponents('System', [THookHotKey]);
end;

end.
