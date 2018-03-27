unit untProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmProgress = class(TForm)
    lblInfo: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private 宣言 }
  public
    { Public 宣言 }
    procedure ChangeStatus(const AText: String);
  end;

var
  frmProgress: TfrmProgress;

implementation

{$R *.dfm}

procedure TfrmProgress.ChangeStatus(const AText: String);
begin
  lblInfo.Caption := AText;
  Application.ProcessMessages;
end;

procedure TfrmProgress.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Release;
  frmProgress := nil;
end;

end.
