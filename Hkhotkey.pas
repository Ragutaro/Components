(*
--- THookHotKey�R���|�[�l���g�@�d�l�� ---

THookHotKeyComponent : Copyright 1998 Hiki Takehito

�ETHookHotKey 1.0
�E����� 98/02/13
�E�C���� 98/02/13
�E����� �Ђ� �����Ђ�
�EHomePage http://www.vector.co.jp/authors/VA009712/take/
�EE-Mail takeone@pop06.odn.ne.jp
�E�]�� ���R(���O�܂��͎���ɘA����������)

�E����ۏ؁@Delphi 2.0/3.0
�E����ۏ�OS�@Windows95/WindowsNT4

<���쌠�Ȃ�>
�ETHookHotKey�R���|�[�l���g�̒��쌠�́u�Ђ� �����ЂƁv��
�@�����܂��B
�ETHookHotKey�R���|�[�l���g���g�p���Ă����Ȃ鑹�Q������
�@���Ă��A���쌠�҂͖������؂̐ӔC�𕉒S���Ȃ����Ƃ�
�@���Ȃ���܂��B

<�o�[�W��������>
98/02/13
�E���ō쐬

*)
(*
--- THookHotKey�R���|�[�l���g�@�g�p���@ ---

1.�T�v
�@�ǂ̃A�v���P�[�V�������A�N�e�B�u�ł����Ă��A����z�b�g�L�[��
�����ꂽ�玩���̃A�v���ɔ������������A�Ƃ������Ƃ͂���܂��񂩁H
���ɏ풓�^�A�v���Ȃ�΃z�b�g�L�[�̋@�\���g���@������ł��傤�B
THookHotKey�Ŕ������������z�b�g�L�[��o�^���Ă����΁A����
�z�b�g�L�[�������ꂽ�Ƃ������b�Z�[�W���擾���邱�Ƃ��ł��܂��B
�Ȃ��A���̃R���|�[�l���g�́uTHotKey�v�R���|�[�l���g�Ɛe�a����
�������Ă���̂ŁA����ƈꏏ�Ɏg�����������߂��܂��B

2.�C���X�g�[��
�@Delphi�̃}�j���A���ɏ]���ĕ��ʂɃC���X�g�[�����ĉ������B
�C���X�g�[������ƁuSystem�v�^�u�ɓo�^����܂��B

3.�g����
 (1)��{�I�Ȏg����
�@THookHotKey�R���|�[�l���g�P�ŕ����̃z�b�g�L�[��o�^�ł�
�܂��B�o�^����ɂ́uAdd�v���\�b�h���g���܂��B�uAdd�v�ƂȂ���
�܂����AListbox��StringList�́uAdd�v�Ƃ͕ʕ��ł��B�u�o�^����v
�Ƃ����Ӗ��Ŏg���ĉ������B
�@Add����Ƃ��ɂ͑������Ƃ��āuIndex�v�ԍ����w�肵�܂��B
Index�͓o�^�����z�b�g�L�[�́A�����ID�ł���A�Ȍ�͂���Index
�ŁA�o�^�����z�b�g�L�[���Ǘ����܂��BIndex�ɂ͓K���Ȕԍ���
�w�肵�ĉ������B
�@Add�̑������ɂ͓o�^����z�b�g�L�[���w�肵�܂��B������
THotKey�R���|�[�l���g�Ɛe�a�����������邽�߁uTShortcut�v�^
�ɂ��Ă���܂��BHotKey�v���p�e�B��TShortcut�^������ł��B

  (��)HookHotKey1.Add(1, HotKey1.HotKey);

�@���Ƃ́A�o�^�������ɂ́uDelete�v�A�ύX�́uChange�v���\�b�h
���g�p���ĉ������B

 (2)�C�x���g�̔���
�@�o�^�����z�b�g�L�[����������OnHotKey�C�x���g���������܂��B
�������ɁuIndex�v������܂��B(1)�ŏq�ׂ��悤�ɁA�o�^����
�z�b�g�L�[��Index�ŊǗ����Ă���̂ŁA�z�b�g�L�[�𕡐��o�^����
�ꍇ�͂���Index�����邱�Ƃŋ�ʂł��܂��B

  (��)
   procedure TForm1.HookHotKey1HotKey(Sender: TObject; Index: Integer);
   begin
     case Index of
      1: ShowMessage('Alt+1');
      2: ShowMessage('Ctrl+A');
     end;
   end;

 (3)�`�F�b�N�{�b�N�X�Ƃ̕��p
�@HotKey�R���|�[�l���g�ƃ`�F�b�N�{�b�N�X�Ƃ̕��p���l���āuApply�v
���\�b�h��p�ӂ��Ă��܂��B��O�����Ƀ`�F�b�N�{�b�N�X��Checked
�v���p�e�B���w�肷�邱�ƂŁATrue�Ȃ��Change���\�b�h���AFalse
�Ȃ��Delete���\�b�h�����s����悤�ɂ��Ă��܂��B

  (��)HookHotKey1.Apply(1, HotKey1.HotKey, Checkbox1.Checked);


4.���t�@�����X
<�v���p�e�B>
�EActivate: boolean;
�@OnHotKey�C�x���g�����������Ƃ��ATHookHotKey�R���|�[�l���g��
�@����Ă���t�H�[�����A�N�e�B�u�ɂ��邩���肵�܂��B

<���\�b�h>
�Efunction Add(Index:integer; HotKey:TShortcut): boolean;
�@�z�b�g�L�[��o�^���܂��B
�Efunction Delete(Index:integer): boolean;
�@�z�b�g�L�[�̓o�^���������܂��B
�Efunction Change(Index:integer; HotKey:TShortcut): boolean;
�@�o�^�����z�b�g�L�[��ύX���܂��B
�Efunction Apply(Index:integer; HotKey:TShortcut; DoHook:boolean): boolean;
�@�z�b�g�L�[�̕ύX��K�p���܂��B

<�C�x���g>
�EOnHotKey(Sender: TObject; Index: Integer):THotKeyEvent;
�@�o�^�����z�b�g�L�[�������ꂽ�Ƃ��ɔ������܂��B

*)

{THookHotKey Component}
unit Hkhotkey;

interface

uses
  Windows, Messages, SysUtils, Controls, Classes, Menus, Forms;

type
  //ERegistHotKey=class(Exception); {��O}

  THotKeyEvent = procedure(Sender: TObject; Index: Integer) of object;

  THookHotKey = class(TComponent)
  private
    { Private �錾 }
    FActivate:boolean;
    FOnHotKey:THotKeyEvent;
    FWindowHandle:HWND;
    procedure WndProc(var Msg: TMessage);
  protected
    { Protected �錾 }
    procedure GetHookKey(HotKey:TShortcut; var HookModi:UINT; var HookKey:Word);
    procedure CatchHotKey(Index:integer);dynamic;
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Add(Index:integer; HotKey:TShortcut): boolean;
    function Delete(Index:integer): boolean;
    function Change(Index:integer; HotKey:TShortcut): boolean;
    function Apply(Index:integer; HotKey:TShortcut; DoHook:boolean): boolean;
  published
    { Published �錾 }
    property Activate: boolean read FActivate write FActivate default True;
    property OnHotKey: THotKeyEvent read FOnHotKey write FOnHotKey;
  end;

procedure Register;

implementation


{�R���|�[�l���g���쐬�����Ƃ��ɂ��邱��}
constructor THookHotKey.Create(AOwner: TComponent);
begin
 inherited Create(AOwner);
 FActivate:=True;

 //THookHotKey�̌p������TComponent�Ȃ̂ŁA�E�B���h�E
 //�n���h�����Ȃ� -> �E�B���h�E���b�Z�[�W��߂܂����Ȃ��B
 //�������A�z�b�g�L�[�������ꂽ�Ƃ����E�B���h�E
 //�n���h��(WM_HOTKEY)��߂炦�����B�����ŁA�����ŃE�B���h�E
 //�n���h��������Ă��܂��܂��B
 FWindowHandle := AllocateHWnd(WndProc);
end;

{�R���|�[�l���g����������Ƃ��ɂ��邱��}
destructor THookHotKey.Destroy;
begin
 //�쐬�����E�C���h�E�n���h��������B
 DeallocateHWnd(FWindowHandle);

 inherited Destroy;
end;

{�E�B���h�E���b�Z�[�W���擾}
{��)TTimer�̃\�[�X���Q�l�ɂ��܂����B}
procedure THookHotKey.WndProc(var Msg: TMessage);
begin
 with Msg do
 if Msg = WM_HOTKEY then  //�z�b�g�L�[�������ꂽ��
  try
   CatchHotKey(wParam);   //OnHotKey�����B
  except
   Application.HandleException(Self);
  end
  else
   //���̑��̃��b�Z�[�W�͗ǂ��ɂ͂�����Ă����B
   Result:=DefWindowProc(FWindowHandle, Msg, wParam, lParam);
end;

{OnHotKey����}
procedure THookHotKey.CatchHotKey(Index:integer);
begin
 if Assigned(FOnHotKey) then
  begin
   if FActivate then SetForegroundWindow(TForm(Owner).Handle);
   FOnHotKey(Self,Index);
  end;
end;

{�z�b�g�L�[��o�^}
function THookHotKey.Add(Index:integer; HotKey:TShortcut): boolean;
var
 HookModi: UINT;
 HookKey: Word;
begin
 GetHookKey(HotKey,HookModi,HookKey);
 Result:=RegisterHotKey(FWindowHandle,Index,HookModi,HookKey);
end;

{�t�b�N����z�b�g�L�[�𕪐�}
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

{�z�b�g�L�[������}
function THookHotKey.Delete(Index:integer): boolean;
begin
 Result:=UnRegisterHotKey(FWindowHandle,Index);
end;

{�z�b�g�L�[��ύX}
function THookHotKey.Change(Index:integer; HotKey:TShortcut): boolean;
var
 Success1,Success2:boolean;
begin
 Success1:=Delete(Index);      //������������Ă���
 Success2:=Add(Index,HotKey);  //�ēo�^����B
 if Success1 and Success2 then Result:=True
 else Result:=False;
end;

{�z�b�g�L�[�̕ύX��K�p}
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

{�R���|�[�l���g�̓o�^}
procedure Register;
begin
  RegisterComponents('System', [THookHotKey]);
end;

end.
