unit BeginEnd;

// Original http://do.sakura.ne.jp/~junkroom/cgi-bin/megabbs/readres.cgi?bo=lounge&vi=1007345219&rm=100
// Extended by YT

{$DEFINE END_WITH_UNINDENT}
{$DEFINE DISTINGUISH_ESC}
{x$DEFINE USE_NORMAL_PARENTHESIS}

interface

uses
	Windows, SysUtils, Classes, ToolsAPI, Menus;

const
	DisplayName = 'Begin End';
	BeginShortCut = 'Ctrl+[';
	EndShortCut = 'Ctrl+]';
	BeginShortCut2 = 'Ctrl+9';
	EndShortCut2 = 'Ctrl+0';
	BeginText = 'begin'#13#10#9;
	EndText = 'end;';

implementation

type
	TBeginEnd = class(TNotifierObject, IOTAKeyboardBinding)
	private
{$IFDEF DISTINGUISH_ESC}
		FEscape: TKeyBindingProc;
{$ENDIF}
		procedure BeginProc(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
		procedure EndProc(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
	public
		function GetBindingType: TBindingType;
		function GetDisplayName: string;
		function GetName: string;
		procedure BindKeyboard(const BindingServices: IOTAKeyBindingServices);
	end;

procedure TBeginEnd.BeginProc(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
	EP: IOTAEditPosition;
begin
	{IDEの取り扱いではコントロールコードなんでESCもCtrl+[も27になる}

{$IFDEF DISTINGUISH_ESC}
	if GetKeyState(VK_ESCAPE) and $80 = 0 then
	begin
		EP := Context.EditBuffer.EditPosition;
		EP.InsertText(BeginText);
		BindingResult := krHandled;
	end
	else if Assigned(FEscape) then
		FEscape(Context, KeyCode, BindingResult)
{$ELSE}
	EP := Context.EditBuffer.EditPosition;
	EP.InsertText(BeginText);
	BindingResult := krHandled;
{$ENDIF}
end;

procedure TBeginEnd.EndProc(const Context: IOTAKeyContext; KeyCode: TShortCut; var BindingResult: TKeyBindingResult);
var
	EP: IOTAEditPosition;
	i, col, row: Integer;
	isNewLine: Boolean;
begin
	EP := Context.EditBuffer.EditPosition;
{$IFDEF END_WITH_UNINDENT}
	isNewLine := false;
	col := EP.Column;
	row := EP.Row;
	for i := col - 1 downto 1 do
	begin
		EP.Move(row, i);
		isNewLine := EP.IsWhiteSpace;
		if not isNewLine then
			Break;
	end;
	EP.Move(row, col);
	if isNewLine then
		EP.Tab(-1);
{$ENDIF END_WITH_UNINDENT}
	EP.InsertText(EndText);
	BindingResult := krHandled;
end;

function TBeginEnd.GetBindingType: TBindingType;
begin
	Result := btPartial;
end;

function TBeginEnd.GetDisplayName: string;
begin
	Result := DisplayName;
end;

function TBeginEnd.GetName: string;
begin
	Result := ClassName
end;

procedure TBeginEnd.BindKeyboard(const BindingServices: IOTAKeyBindingServices);
var
	tmp: TShortCut;
	R: TKeyBindingRec;
begin
{$IFDEF DISTINGUISH_ESC}
	if (BorlandIDEServices as IOTAKeyBoardServices).LookupKeyBinding(
					[ShortCut(VK_ESCAPE, [])], R) then
		FEscape := R.KeyProc;
{$ENDIF}

	tmp := TextToShortCut(BeginShortCut);
	if tmp <> 0 then
		BindingServices.AddKeyBinding([tmp], BeginProc, nil);

	tmp := TextToShortCut(EndShortCut);
	if tmp <> 0 then
		BindingServices.AddKeyBinding([tmp], EndProc, nil);

{$IFDEF USE_NORMAL_PARENTHESIS}
	tmp := TextToShortCut(BeginShortCut2);
	if tmp <> 0 then
		BindingServices.AddKeyBinding([tmp], BeginProc, nil);

	tmp := TextToShortCut(EndShortCut2);
	if tmp <> 0 then
		BindingServices.AddKeyBinding([tmp], EndProc, nil);
{$ENDIF}
end;

var
	Bind: Integer;

initialization

	Bind := (BorlandIDEServices as IOTAKeyBoardServices).
					AddKeyboardBinding(TBeginEnd.Create);

finalization

	(BorlandIDEServices as IOTAKeyBoardServices).RemoveKeyboardBinding(Bind);

end.
