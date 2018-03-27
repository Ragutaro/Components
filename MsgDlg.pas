unit MsgDlg;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Winapi.Shellapi, HideBack;

type
  TfrmMessageDlg = class(TForm)
    HideBack1: THideBack;
    imgIcon: TImage;
    lblMsg: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private 宣言 }
    procedure ReturnClick(Sender: TObject);
  public
    { Public 宣言 }
    procedure SetWindowSize;
    procedure LoadIcon(MsgDlgType : TMsgDlgType);
    procedure CreateButtons(MsgDlgButtons: TMsgDlgButtons);
  end;

var
  frmMessageDlg: TfrmMessageDlg;

implementation

{$R *.dfm}

uses
  HideUtils;

var
  iLeftPos : Integer;

procedure TfrmMessageDlg.CreateButtons(MsgDlgButtons: TMsgDlgButtons);
  procedure _CreateButton(ACaption, AName: String; ATag, ALeft: Integer);
  var
    btn : TButton;
  begin
    btn := TButton.Create(Self);
    btn.Parent  := frmMessageDlg;
    btn.Caption := ACaption;
    btn.Name    := AName;
    btn.Tag     := ATag;
    btn.OnClick := ReturnClick;
    btn.Left    := Self.ClientWidth - ALeft;
    btn.Top     := HideBack1.Height + 8;
    iLeftPos    := iLeftPos + 83;
  end;

begin
  iLeftPos := 83;
  if mbClose    in MsgDlgButtons then _CreateButton('閉じる',     'btnClose',   mrClose,    iLeftPos);
  if mbYesToAll in MsgDlgButtons then _CreateButton('全てはい',   'btnYesAll',  mrYesToAll, iLeftPos);
  if mbNoToAll  in MsgDlgButtons then _CreateButton('全ていいえ', 'btnNoAll',   mrNoToAll,  iLeftPos);
  if mbAll      in MsgDlgButtons then _CreateButton('すべて',     'btnAll',     mrAll,      iLeftPos);
  if mbIgnore   in MsgDlgButtons then _CreateButton('無視(&I)',   'btnIgnore',  mrIgnore,   iLeftPos);
  if mbRetry    in MsgDlgButtons then _CreateButton('再試行(&R)', 'btnRetry',   mrRetry,    iLeftPos);
  if mbAbort    in MsgDlgButtons then _CreateButton('中止(&A)',   'btnAbort',   mrAbort,    iLeftPos);
  if mbCancel   in MsgDlgButtons then _CreateButton('キャンセル', 'btnCancel',  mrCancel,   iLeftPos);
  if mbOK       in MsgDlgButtons then _CreateButton('OK',         'btnOK',      mrOk,       iLeftPos);
  if mbNo       in MsgDlgButtons then _CreateButton('いいえ(&N)', 'btnNo',      mrNo,       iLeftPos);
  if mbYes      in MsgDlgButtons then _CreateButton('はい(&Y)',   'btnYes',     mrYes,      iLeftPos);
  DisableVclStyles(Self);
end;

procedure TfrmMessageDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
  frmMessageDlg := nil;
end;

procedure TfrmMessageDlg.LoadIcon(MsgDlgType: TMsgDlgType);
var
  icon : TIcon;
  idx : Integer;
begin
  idx := -1;
  Case MsgDlgType of
    mtWarning       : idx := 79;
    mtError         : idx := 93;
    mtInformation   : idx := 76;
    mtConfirmation  : idx := 94;
    mtCustom        : idx := -1;
  end;
  icon := TIcon.Create;
  try
    icon.Handle := ExtractIcon(hInstance, PChar('imageres.dll'), idx);
    if icon.Handle > 0 then
    begin
      imgIcon.Canvas.Draw(0, 0, icon);
    end;
  finally
    icon.Free;
  end;
end;

procedure TfrmMessageDlg.ReturnClick(Sender: TObject);
begin
  HAS_MESSAGEDLG_VALUE := TButton(Sender).Tag;
  Close;
end;

procedure TfrmMessageDlg.SetWindowSize;
begin
  lblMsg.Width      := 382;
  lblMsg.WordWrap   := True;
  Self.ClientHeight := lblMsg.Height + 73;
end;

end.
