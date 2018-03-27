unit HideEdit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  THideEditW = class(TEdit)
  private
    { Private 宣言 }
		FAlignment : TAlignment;
    FEnableChar : String;
		procedure SetAlignment(AValue : TAlignment);
		procedure SetEnableChar(AValue : String);
  protected
    { Protected 宣言 }
    procedure CreateParams(var Params: TCreateParams); override;
    procedure KeyPress(var Key: Char); override;
  public
    { Public 宣言 }
  published
    { Published 宣言 }
    property UAlignment : TAlignment read FAlignment write SetAlignment;
    property UEnableChar : String read FEnableChar write SetEnableChar;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('HaS', [THideEditW]);
end;

{ THideEditW }

procedure THideEditW.CreateParams(var Params: TCreateParams);
const
	Alignments : array[TAlignment] of Word = (ES_LEFT, ES_RIGHT, ES_CENTER);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or Alignments[FAlignment];
  if FEnableChar <> '' then
    Hint := '入力可能:' + FEnableChar;
  ShowHint := True;
end;

procedure THideEditW.KeyPress(var Key: Char);
begin
  if Not CharInSet(Key, [char(VK_Back)])
      and (FEnableChar <> '')
      and (Pos(Key, FEnableChar) = 0) then
    Key := #0;
  inherited;
end;

procedure THideEditW.SetAlignment(AValue: TAlignment);
begin
  if FAlignment <> AValue then
  begin
    FAlignment := AValue;
    RecreateWnd;
  end;
end;

procedure THideEditW.SetEnableChar(AValue: String);
begin
  FEnableChar := AValue;
end;

end.
