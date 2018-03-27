{$WARNINGS OFF}
//=============================================================================
//  ファイル関連ダイアログコンポーネント
//
//  コンポーネント登録とプロパティエディタ関係
//  実際にはなくてもいいのであるが，コンポのテストには便利なので実装
//
//-----------------------------------------------------------------------------
//
//  Presented by Mr.XRAY
//  http://mrxray.on.coocan.jp/
//=============================================================================
unit plFileDialogReg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ShlObj, ActiveX,

  {$IFDEF VER130}
  DsgnIntf;
  {$ELSE}
  DesignIntf, DesignEditors;
  {$ENDIF}

type

  //---------------------------------------------------------------------------
  //  フォルダ選択ダイアログ用
  //  InitDirプロパティの設定
  //---------------------------------------------------------------------------
  TBrowseFolderInitDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  フォルダ選択ダイアログ
  //  RootDir設定用
  //---------------------------------------------------------------------------
  TBrowseFolderRootDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  ファイル選択ダイアログ
  //  Directoryプロパティ設定用
  //---------------------------------------------------------------------------
  TOpenDialogDirectoryProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  ファイル選択ダイアログ
  //  RootDirプロパティ設定用
  //---------------------------------------------------------------------------
  TOpenDialogRootDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  ファイル保存ダイアログ用
  //  Directoryプロパティの設定
  //---------------------------------------------------------------------------
  TSaveDialogDirectoryProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //   ファイル保存ダイアログ
  //    FileNameプロパティの設定
  //---------------------------------------------------------------------------
  TSaveDialogFileNameProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  ファイル保存ダイアログ
  //  RootDirプロパティ設定用
  //---------------------------------------------------------------------------
  TSaveDialogRootDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TplFileDialogReg = class(TComponent)
  end;

procedure Register;

implementation

uses plFileDialog, FileCtrl;

{ TBrowseFolderInitDirProperty }

//=============================================================================
//  フォルダ選択ダイアログ用
//  InitDirプロパティの設定
//=============================================================================
function TBrowseFolderInitDirProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TBrowseFolderInitDirProperty.Edit;
var
  CompoClass   : TplBrowseFolder;
  RootFolder   : String;
  SelectFolder : String;
begin
  CompoClass   := (GetComponent(0) as TplBrowseFolder);
  RootFolder   := CompoClass.RootDir;
  SelectFolder := CompoClass.InitDir;

  if SelectDirectory('初期選択フォルダの設定', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TBrowsFolderRootDirProperty }

//=============================================================================
//  フォルダ選択ダイアログ
//  RootDir設定用
//=============================================================================
function TBrowseFolderRootDirProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TBrowseFolderRootDirProperty.Edit;
var
  CompoClass   : TplBrowseFolder;
  RootFolder   : String;
  SelectFolder : String;
begin
  CompoClass := (GetComponent(0) as TplBrowseFolder);
  if CompoClass.InitDir <> '' then begin
    RootFolder   := CompoClass.InitDir;
    SelectFolder := CompoClass.InitDir;
  end else begin
    RootFolder   := '';
    SelectFolder := CompoClass.RootDir;
  end;

  if SelectDirectory('ルートフォルダの設定', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TOpenDirectoryProperty }

//=============================================================================
//  ファイル選択ダイアログ
//  Directoryプロパティ設定用
//=============================================================================
function TOpenDialogDirectoryProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TOpenDialogDirectoryProperty.Edit;
var
  CompoClass   : TplOpenDialog;
  RootFolder   : String;
  SelectFolder : String;
begin
  CompoClass   := (GetComponent(0) as TplOpenDialog);
  RootFolder   := CompoClass.RootDir;
  SelectFolder := CompoClass.Directory;

  if SelectDirectory('ファイル一覧フォルダの設定', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TOpenDialogRootDirProperty }

//=============================================================================
//  ファイル選択ダイアログ
//  RootDirプロパティ設定用
//=============================================================================
function TOpenDialogRootDirProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TOpenDialogRootDirProperty.Edit;
var
  CompoClass   : TplOpenDialog;
  RootFolder   : String;
  SelectFolder : String;
begin
  CompoClass := (GetComponent(0) as TplOpenDialog);
  if CompoClass.Directory <> '' then begin
    RootFolder   := CompoClass.Directory;
    SelectFolder := CompoClass.Directory;
  end else begin
    RootFolder   := '';
    SelectFolder := CompoClass.RootDir;
  end;

  if SelectDirectory('ルートフォルダの設定', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TSaveFileNameProperty }

//=============================================================================
//  ファイル保存ダイアログ
//   FileNameプロパティの設定
//=============================================================================
function TSaveDialogFileNameProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TSaveDialogFileNameProperty.Edit;
var
  OpenDialog : TOpenDialog;
  CompoClass : TplSaveDialog;
begin
  CompoClass := (GetComponent(0) as TplSaveDialog);
  OpenDialog := TOpenDialog.Create(Application);

  with OpenDialog do begin
    InitialDir := CompoClass.Directory;
    Filter     := CompoClass.FileExt + '|*.' + CompoClass.FileExt;
    FileName   := CompoClass.FileName;
    Title      := '保存ファイル名の指定';

    try
      if Execute then begin
        SetStrValue(ExtractFileName(FileName));
      end;
    finally
      Free;
    end;
  end;
end;

//=============================================================================
//  ファイル保存ダイアログ用
//  Directoryプロパティの設定
//=============================================================================
function TSaveDialogDirectoryProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TSaveDialogDirectoryProperty.Edit;
var
  CompoClass   : TplSaveDialog;
  RootFolder   : String;
  SelectFolder : String;
begin
  CompoClass   := (GetComponent(0) as TplSaveDialog);
  RootFolder   := CompoClass.RootDir;
  SelectFolder := CompoClass.Directory;

  if SelectDirectory('保存フォルダの設定', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TSaveDialogRootDirProperty }

//=============================================================================
//  ファイル保存ダイアログ
//  RootDirプロパティ設定用
//=============================================================================
function TSaveDialogRootDirProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog];
end;

procedure TSaveDialogRootDirProperty.Edit;
var
  CompoClass   : TplSaveDialog;
  RootFolder   : String;
  SelectFolder : String;
begin
  CompoClass := (GetComponent(0) as TplSaveDialog);
  if CompoClass.Directory <> '' then begin
    RootFolder   := CompoClass.Directory;
    SelectFolder := CompoClass.Directory;
  end else begin
    RootFolder   := '';
    SelectFolder := CompoClass.RootDir;
  end;

  if SelectDirectory('ルートフォルダの設定', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

//=============================================================================
//  コンポーネント登録情報
//=============================================================================
procedure register;
begin
  RegisterComponents('Dialogs', [TplBrowseFolder]);
  RegisterComponents('Dialogs', [TplOpenDialog]);
  RegisterComponents('Dialogs', [TplSaveDialog]);

  RegisterPropertyEditor(TypeInfo(String),    TplBrowseFolder, 'InitDir',   TBrowseFolderInitDirProperty);
  RegisterPropertyEditor(TypeInfo(String),    TplBrowseFolder, 'RootDir',   TBrowseFolderRootDirProperty);
  RegisterPropertyEditor(TypeInfo(String),    TplOpenDialog,   'Directory', TOpenDialogDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(String),    TplOpenDialog,   'RootDir',   TOpenDialogRootDirProperty);
  RegisterPropertyEditor(TypeInfo(String),    TplSaveDialog,   'Directory', TSaveDialogDirectoryProperty);
  RegisterPropertyEditor(TypeInfo(String),    TplSaveDialog,   'RootDir' ,  TSaveDialogRootDirProperty);
  RegisterPropertyEditor(TypeInfo(TFileName), TplSaveDialog,   'FileName',  TSaveDialogFileNameProperty);
end;

end.

