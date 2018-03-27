unit FontTypeSize;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  SpTBXEditors, SpTBXExtEditors;

type
  TfraFont = class(TFrame)
    grpFont: TGroupBox;
    lblFontName: TLabel;
    cmbFontName: TSpTBXFontComboBox;
    edtFontSize: TEdit;
    lblFontSize: TLabel;
  private
    { Private 宣言 }
  public
    { Public 宣言 }
  end;

implementation

{$R *.dfm}

end.
