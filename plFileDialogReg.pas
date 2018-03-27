{$WARNINGS OFF}
//=============================================================================
//  �t�@�C���֘A�_�C�A���O�R���|�[�l���g
//
//  �R���|�[�l���g�o�^�ƃv���p�e�B�G�f�B�^�֌W
//  ���ۂɂ͂Ȃ��Ă������̂ł��邪�C�R���|�̃e�X�g�ɂ͕֗��Ȃ̂Ŏ���
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
  //  �t�H���_�I���_�C�A���O�p
  //  InitDir�v���p�e�B�̐ݒ�
  //---------------------------------------------------------------------------
  TBrowseFolderInitDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  �t�H���_�I���_�C�A���O
  //  RootDir�ݒ�p
  //---------------------------------------------------------------------------
  TBrowseFolderRootDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  �t�@�C���I���_�C�A���O
  //  Directory�v���p�e�B�ݒ�p
  //---------------------------------------------------------------------------
  TOpenDialogDirectoryProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  �t�@�C���I���_�C�A���O
  //  RootDir�v���p�e�B�ݒ�p
  //---------------------------------------------------------------------------
  TOpenDialogRootDirProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  �t�@�C���ۑ��_�C�A���O�p
  //  Directory�v���p�e�B�̐ݒ�
  //---------------------------------------------------------------------------
  TSaveDialogDirectoryProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //   �t�@�C���ۑ��_�C�A���O
  //    FileName�v���p�e�B�̐ݒ�
  //---------------------------------------------------------------------------
  TSaveDialogFileNameProperty = class(TStringProperty)
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  //---------------------------------------------------------------------------
  //  �t�@�C���ۑ��_�C�A���O
  //  RootDir�v���p�e�B�ݒ�p
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
//  �t�H���_�I���_�C�A���O�p
//  InitDir�v���p�e�B�̐ݒ�
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

  if SelectDirectory('�����I���t�H���_�̐ݒ�', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TBrowsFolderRootDirProperty }

//=============================================================================
//  �t�H���_�I���_�C�A���O
//  RootDir�ݒ�p
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

  if SelectDirectory('���[�g�t�H���_�̐ݒ�', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TOpenDirectoryProperty }

//=============================================================================
//  �t�@�C���I���_�C�A���O
//  Directory�v���p�e�B�ݒ�p
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

  if SelectDirectory('�t�@�C���ꗗ�t�H���_�̐ݒ�', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TOpenDialogRootDirProperty }

//=============================================================================
//  �t�@�C���I���_�C�A���O
//  RootDir�v���p�e�B�ݒ�p
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

  if SelectDirectory('���[�g�t�H���_�̐ݒ�', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TSaveFileNameProperty }

//=============================================================================
//  �t�@�C���ۑ��_�C�A���O
//   FileName�v���p�e�B�̐ݒ�
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
    Title      := '�ۑ��t�@�C�����̎w��';

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
//  �t�@�C���ۑ��_�C�A���O�p
//  Directory�v���p�e�B�̐ݒ�
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

  if SelectDirectory('�ۑ��t�H���_�̐ݒ�', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

{ TSaveDialogRootDirProperty }

//=============================================================================
//  �t�@�C���ۑ��_�C�A���O
//  RootDir�v���p�e�B�ݒ�p
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

  if SelectDirectory('���[�g�t�H���_�̐ݒ�', RootFolder, SelectFolder) then begin
    SetStrValue(SelectFolder);
  end;
end;

//=============================================================================
//  �R���|�[�l���g�o�^���
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

