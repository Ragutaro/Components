unit untShowMessage;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, HideLabel, Vcl.ExtCtrls, Winapi.Shellapi, HideBack;

type
  TfrmShowMessage = class(TForm)
    btnOK: TButton;
    HideBack1: THideBack;
    imgIcon: TImage;
    lblMsg: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    procedure SetWindowSize;
    procedure LoadIcon(MsgDlgType: TMsgDlgType);
  end;

var
  frmShowMessage: TfrmShowMessage;

implementation

{$R *.dfm}
uses
  HideUtils;

procedure TfrmShowMessage.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmShowMessage.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
  frmShowMessage := nil;
end;

procedure TfrmShowMessage.FormCreate(Sender: TObject);
begin
  DisableVclStyles(Self);
end;

procedure TfrmShowMessage.LoadIcon(MsgDlgType: TMsgDlgType);
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
  //アイコンがある場合は、メッセージ欄を右にずらす
  if idx > -1 then
  begin
  	lblMsg.Left := 56;
    lblMsg.Width := 382;
  end else
  begin
  	lblMsg.Left := 16;
    lblMsg.Width := 418;
    imgIcon.Visible := False;
  end;
end;

procedure TfrmShowMessage.SetWindowSize;
begin
  lblMsg.WordWrap   := True;
  Self.ClientHeight := lblMsg.Height + 73;
end;

end.
