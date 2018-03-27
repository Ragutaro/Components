unit InputBoxEx;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, HideBack, System.StrUtils,
  System.Math;

type
  TfrmInputBoxEx = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    HideBack1: THideBack;
    lblDesc: TLabel;
    memImput: TMemo;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure memImputChange(Sender: TObject);
  private
    { Private 宣言 }
    FPreviousCount : Integer;
    procedure _SetSize;
  public
    { Public 宣言 }
    FUseAsFileName : Boolean;
    FConvertFileName : Boolean;
  end;

var
  frmInputBoxEx: TfrmInputBoxEx;

implementation

{$R *.dfm}

uses
  HideUtils,
  dp;

procedure TfrmInputBoxEx.btnCancelClick(Sender: TObject);
begin
  HAS_INPUTBOX_VALUE := '';
  Close;
end;

procedure TfrmInputBoxEx.btnOKClick(Sender: TObject);
begin
  if FUseAsFileName then
  begin
    if FConvertFileName then
    	HAS_INPUTBOX_VALUE := Trim(ConvertToValidFileName(memImput.Text))
    else
    begin
      if IsValidFileName(memImput.Text) then
      begin
      	if FUseAsFileName then
          HAS_INPUTBOX_VALUE := Trim(ReplaceText(memImput.Text, #13#10, ''))
        else
          HAS_INPUTBOX_VALUE := Trim(memImput.Text);
      end else
      begin
        memImput.SetFocus;
        Exit;
      end;
    end;
  end else
  begin
  	if FUseAsFileName then
      HAS_INPUTBOX_VALUE := Trim(ReplaceText(memImput.Text, #13#10, ''))
    else
      HAS_INPUTBOX_VALUE := Trim(memImput.Text);
  end;
  Close;
end;

procedure TfrmInputBoxEx.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
  frmInputBoxEx := nil;
end;

procedure TfrmInputBoxEx.FormCreate(Sender: TObject);
begin
  DisableVclStyles(Self);
  FPreviousCount := 0;
end;

procedure TfrmInputBoxEx.memImputChange(Sender: TObject);
var
  iCnt : Integer;
begin
  iCnt := memImput.Lines.Count;
  if (memImput.Text = '') or (iCnt <> FPreviousCount) then
  begin
    FPreviousCount := iCnt;
  	_SetSize;
  end;
end;

procedure TfrmInputBoxEx._SetSize;
begin
	memImput.Height := Max(memImput.Lines.Count * Self.Canvas.TextHeight('あ') + 7, 25);
  Self.ClientHeight := memImput.Height + 87;
end;

end.
