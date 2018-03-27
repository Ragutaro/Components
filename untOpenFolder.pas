unit untOpenFolder;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList,
  Vcl.ImgList, PngImageList, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfraOpenFolder = class(TFrame)
    lblCaption: TLabel;
    edtPath: TButtonedEdit;
    pngImage: TPngImageList;
    OpenDialog: TOpenDialog;
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

implementation

{$R *.dfm}

end.
