unit HideListBox;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.StdCtrls;

type
  THideListBox = class(TListBox)
  private
    { Private 宣言 }
  protected
    { Protected 宣言 }
  public
    { Public 宣言 }
    procedure UpListItem;
    procedure DownListItem;
    procedure SelectLastItem;
  published
    { Published 宣言 }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('HaS', [THideListBox]);
end;

{ THideListBox }

procedure THideListBox.DownListItem;
var
  idx : Integer;
begin
  idx := Self.ItemIndex;
  if (idx <> -1) and (idx < Self.Items.Count-1) then
    Self.Items.Exchange(idx, idx+1);
end;

procedure THideListBox.SelectLastItem;
var
  idx : Integer;
begin
  idx := Self.Items.Count-1;
  Self.TopIndex := idx;
end;

procedure THideListBox.UpListItem;
var
  idx : Integer;
begin
  idx := Self.ItemIndex;
  if (idx <> -1) and (idx > 0) then
    Self.Items.Exchange(idx, idx-1);
end;

end.
