//{$WARNINGS OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
//=============================================================================
//  �t�@�C���֘A�_�C�A���O�R���|�[�l���g
//  Ver. 9.04
//
//-----------------------------------------------------------------------------
//
//  �y�g�p�������z
//
//  ���T�C�g�̃A�v���P�[�V�����ށC�R���|�[�l���g�C�R�[�h�ނ́C�]�ځC���ρC�z�z
//  (�I���W�i���C���ϔ�)�Ȃǂ͑S�Ď��R�ł��D���p���p�����R�ł��D�A���C�g�p�̋L
//  �ڋ`��������܂���D�������I���W�i�����̂��̂����p�Ƃ��邱�Ƃ͋֎~���܂��D
//  �Ȃ��C�{�T�C�g�̃v���O������R�[�h���g�p�������Ƃɂ���Đ������C�����Ȃ��
//  �Q�C�����Ɋւ��Ă���҂͈�؊֗^���Ȃ����̂Ƃ��܂��D�������������D
//
//-----------------------------------------------------------------------------
//
//  ����d�l�C�����C����m�F�����ɂ��Ă͓Y�t��Readme.txt���Q��
//
//  Presented by Mr.XRAY
//  http://mrxray.on.coocan.jp/
//=============================================================================
unit plFileDialog;

interface

uses
  Windows,SysUtils, Classes, Forms, Controls, Graphics, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, Messages, Menus, Dialogs, FileCtrl, CommCtrl, ShellAPI,
  ShlObj, ActiveX;

type
  //---------------------------------------------------------------------------
  //  �t�H���_�Q�ƃ_�C�A���O
  //---------------------------------------------------------------------------

  //����t�H���_�̗񋓌^�̒�`
  TplBFSpecialDir = (
      sfNone,
      sfDesktop,
      sfInternet,
      sfPrograms,
      sfControls,
      sfPrinters,
      sfPersonal,
      sfFavorites,
      sfStartup,
      sfRecent,
      sfSendTo,
      sfBitBucket,
      sfStartMenu,
      sfMyDocuments,
      sfMyMusic,
      sfMyVidio,
      sfDesktopDirectory,
      sfDrives,
      sfNetWork,
      sfNetHood,
      sfFonts,
      sfTemplates,
      sfCommon_StartMenu,
      sfCommon_Programs,
      sfCommon_Startup,
      sfCommon_DesktopDirectory,
      sfAppData,
      sfPrintHood,
      sfLocal_AppData,
      sfAltSartup,
      sfCommon_AltSartup,
      sfCommon_Favorites,
      sfInternet_Cache,
      sfCookies,
      sfHistory,
      sfComman_AppData,
      sfWindows,
      sfSystem,
      sfProgram_Files,
      sfMyPictures,
      sfProfile,
      sfSystemX86,
      sfProgram_filesX86,
      sfProgram_Files_Common,
      sfProgram_Files_CommanX86,
      sfCommon_Templates,
      sfCommon_Documents,
      sfCommon_Admintools,
      sfAdmintools,
      sfConnections,
      sfCommon_Music,
      sfCommon_Pictures,
      sfCommon_Video,
      sfResources,
      sfResources_Localized,
      sfCommon_OEM_links,
      sfCdburn_Area,
      sfComputersNearme,
      sfProfiles);

  //�t�H���_�Q�ƃ_�C�A���O�Ŏg�p  �w��\�ȃI�u�V�����̗v�f
  TplBrowseOption=(
      bifReturnOnlyFSDirs,
      bifDontGoBelowDomain,
      bifStatusText,
      bifReturnFSAncestors,
      bifEditBox,
      bifValidate,
      bifNewDialogStyle,
      bifUseNewUI,
      bifbrowseIncludeURLs,
      bifUAHint,
      bifNoNewFolderButton,
      bifNoTranslateTargets,
      bifBroowseForComputer,
      bifBrowseForPrinter,
      bifBrowseIncludeFiles,
      bifShareAble);

  //�w��\�ȃI�v�V�����������W����
  TplBrowseOptions     = set of TplBrowseOption;
  TplBrowseEvent       = procedure(Sender: TObject) of object;
  TplBrowseChangeEvent = procedure(Sender: TObject; Wnd: HWND; Directory: string; var StatusText: string;
                                   var OKBtnEnabled: Boolean) of object;

  TplBrowseFolder = class(TComponent)
  private
    OSVersionValueMajor  : Integer; //OS�̃o�[�W�����ԍ�
    OSVersionValueMinor  : Integer; //OS�̃o�[�W�����ԍ�
    IsOSBeforeVista      : Boolean; //OS��Vista���O�̃o�[�W������
    FHandle              : HWND;
    FRootDir             : String;
    FRootSpecialDir      : TplBFSpecialDir;
    FInitDir             : string;
    FInitSpecialDir      : TplBFSpecialDir;
    FOptions             : TplBrowseOptions;
    FDirectory           : string;
    FFolderName          : string;
    FCaption             : String;
    FTitle               : string;
    FFormTop             : Integer;
    FFormLeft            : Integer;
    FFormWidth           : Integer;
    FFormHeight          : Integer;
    FOnSelectionChanged  : TplBrowseChangeEvent;
    FOnShow              : TplBrowseEvent;
    RootPItemID          : PItemIDlist;
    FInitDirPItemID      : PItemIDList;
    FDialogPositionSet   : Boolean;

    OwnerControlOriginalProc : TWndMethod;

    procedure SetFormHeight(const Value: Integer);
    procedure SetFormWidth(const Value: Integer);
    procedure OwnerControlSubClassProc(var Message:TMessage);
    procedure SetDialogPosition;
  protected
    FormWidthDefault  : Integer;
    FormHeightDefault : Integer;
  public
    constructor Create(AOwner: TComponent); override;
    function Execute:Boolean;
    property Directory : string  read FDirectory;
    property FolderName: string  read FFolderName;
    property Handle    : HWND    read FHandle;
  published
    property RootDir            : String               read FRootDir            write FRootDir;
    property RootSpecialDir     : TplBFSpecialDir      read FRootSpecialDir     write FRootSpecialDir;
    property InitDir            : string               read FInitDir            write FInitDir;
    property InitSpecialDir     : TplBFSpecialDir      read FInitSpecialDir     write FInitSpecialDir;
    property Options            : TplBrowseOptions     read FOptions            write FOptions;
    property Title              : string               read FTitle              write FTitle;
    property Caption            : String               read FCaption            write FCaption;
    property FormWidth          : Integer              read FFormWidth          write SetFormWidth;
    property FormHeight         : Integer              read FFormHeight         write SetFormHeight;
    property FormLeft           : Integer              read FFormLeft           write FFormLeft;
    property FormTop            : Integer              read FFormTop            write FFormTop;
    property OnShow             : TplBrowseEvent       read FOnShow             write FOnShow;
    property OnSelectionChanged : TplBrowseChangeEvent read FOnSelectionChanged write FOnSelectionChanged;
  end;

  //---------------------------------------------------------------------------
  //  [�t�@�C���I��]��[�ۑ�]�_�C�A���O�֌W
  //---------------------------------------------------------------------------

  //�O���Q��
  TplOpenDialog             = class;
  TplSaveDialog             = class;
  TplCustomFileDialog       = class;
  TplFileDialogDataList     = class;
  TplFileDialogDataListItem = class;
  TplFileDialogListView     = class;

  //�t�@�C���I���ƕۑ��_�C�A���O�̃{�^���\���̗v�f
  TplDialogOption=(doFindBtn, doFolderBtn);

  TplDialogOptions         = set of TplDialogOption;
  TplDialogBeforeEvent     = procedure(Sender:TObject; FilePath:String; var Action:Boolean) of Object;
  TplDialogAfterEvent      = procedure(Sender:TObject; FilePath:String; Flag:Boolean) of Object;
  TplDialogBeforeExEvent   = procedure(Sender:TObject; OldFilePath,NewFilePath:String; var Action:Boolean) of Object;
  TplDialogAfterExEvent    = procedure(Sender:TObject; OldFilePath,NewFilePath:String; Flag:Boolean) of Object;
  TplDialogBFBtnEvent      = procedure(Sender:TObject; Directory:String; var DefautEvent: Boolean) of object;
  TplDialogFindBtnEvent    = procedure(Sender:TObject; Directory:String; var DefautEvent: Boolean; var AndFindText:String) of object;
  TplDialogFileListedEvent = procedure(Sender:TObject; Directory:String; Count: Integer; ItemList: TplFileDialogDataList; var Text: String) of object;

  TplDialogCustomDrawItem = procedure(Sender: TplFileDialogListView; Item: TListItem; State: TCustomDrawState;
                            Stage: TCustomDrawStage; var DefaultDraw: Boolean; ImgListHandle: THandle; ItemList: TplFileDialogDataList) of Object;

  //---------------------------------------------------------------------------
  //  [�t�@�C���I��]��[�ۑ�]�_�C�A���O
  //  �t�@�C�����X�g�Ŏg�p���郊�X�g�N���X
  //  ���̃��X�g�N���X�Ƀt�@�C���̖��O�����L�^���C���z���X�g�r���[�ŕ\��
  //---------------------------------------------------------------------------

  TplFileDialogDataList=class(TList)
  protected
    function Get(Index: Integer): TplFileDialogDataListItem;
    procedure Put(Index: Integer; Item: TplFileDialogDataListItem);
  public
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index:integer);
    function Add(Item: TplFileDialogDataListItem): Integer;
    function IndexOf(Item: TplFileDialogDataListItem): Integer;
    function Remove(Item: TplFileDialogDataListItem): Integer;
    property Items[Index: Integer]: TplFileDialogDataListItem read Get write Put; default;
  end;

  //---------------------------------------------------------------------------
  //  [�t�@�C���I��]��[�ۑ�]�_�C�A���O
  //  �t�@�C�����X�g�Ŏg�p���郊�X�g�N���X�̊eItem
  //---------------------------------------------------------------------------

  TplFileDialogDataListItem =class(TObject)
  private
    FFileFullPath : String;
    FFileName     : String;
    FIconIndex    : Integer;
    FFileAttrib   : Cardinal;
  public
    property FileFullPath : String    read FFileFullPath;
    property FileName     : String    read FFileName;
    property IconIndex    : Integer   read FIconIndex;
    property FileAttrib   : Cardinal  read FFileAttrib;
  end;

  //---------------------------------------------------------------------------
  //  [�t�@�C���I��]��[�ۑ�]�_�C�A���O�̊�{�N���X�̃��X�g�r���[�N���X
  //---------------------------------------------------------------------------

  TplFileDialogListView = class(TListView)
  private
    FDialog   : TplCustomFileDialog;
    procedure LVOnSelectItem(Sender: TObject; Item: TListItem;Selected: Boolean);
  protected
    procedure DblClick; override;
    procedure FileViewOnDataHint(Sender: TObject; StartIndex,
      EndIndex: Integer);
    procedure FileViewOnData(Sender: TObject; Item: TListItem);
    function CanEdit(Item: TListItem): Boolean; override;
    procedure Edit(const Item: TLVItem); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure FileViewOnAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure CNKeydown(var Message: TMessage); message CN_KEYDOWN;
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
  end;

  //---------------------------------------------------------------------------
  //  [�t�@�C���I��]��[�ۑ�]�_�C�A���O�̊�{�N���X
  //---------------------------------------------------------------------------

  TplCustomFileDialog = class(TComponent)
  private
    { Private �錾 }
    OSVersionValueMajor : Integer; //OS�̃o�[�W�����ԍ�
    OSVersionValueMinor : Integer; //OS�̃o�[�W�����ԍ�
    IsOSBeforeVista     : Boolean; //OS��Vista���O�̃o�[�W������
    FDialogForm         : TForm;
    FFormLeft           : Integer;
    FFormTop            : Integer;
    FFormHeight         : Integer;
    FFormWidth          : Integer;

    FImgListHandle      : THandle;
    FTopPanel           : TPanel;
    FListPanel          : TPanel;
    FBottomPanel        : TPanel;
    FDirectoryLabel     : TLabel;
    FListView           : TplFileDialogListView;
    FListViewItemHeight : Integer;
    FStateImgList       : TImageList;
    FFileEdit           : TEdit;
    FOKBtn              : TBitBtn;
    FCancelBtn          : TBitBtn;
    FFindBtn            : TSpeedButton;
    FFolderBtn          : TSpeedButton;
    FBrowseFolder       : TplBrowseFolder;
    FMargin             : Integer;
    FPopupMenu          : TPopupMenu;
    FPopFileRename      : TMenuItem;
    FPopFileDelete      : TMenuItem;
    FAndFindText        : String;
    FItemRightMargin    : Integer;
    FFontSize           : Integer;
    FFont               : TFont;

    FHandle             : HWND;
    FFileExt            : String;
    FDirectory          : String;
    FFilePath           : String;
    FFileName           : TFileName;
    FTitle              : String;
    FFindText           : String;
    FImeMode            : TImeMode;
    FModalResult        : TModalResult;
    FDisplayDirectory   : Boolean;
    FDisplayIcon        : Boolean;
    FDisplayGridLines   : Boolean;
    FOptions            : TplDialogOptions;
    FRootDir            : String;
    FBrowseTitle        : String;
    FBrowseCaption      : String;
    FDirectoryLabelText : String;

    FOnShow            : TNotifyEvent;
    FOnBeforeDelete    : TplDialogBeforeEvent;
    FOnBeforeClose     : TplDialogBeforeEvent;
    FOnReNameMenuClick : TplDialogBeforeEvent;
    FOnBeforeRename    : TplDialogBeforeExEvent;
    FOnAfterDelete     : TplDialogAfterEvent;
    FOnAfterRename     : TplDialogAfterExEvent;
    FOnFindBtnClick    : TplDialogFindBtnEvent;
    FOnFolderBtnClick  : TplDialogBFBtnEvent;
    FOnFileListed      : TplDialogFileListedEvent;
    FOnAdvancedCustomDrawItem : TplDialogCustomDrawItem;

    DialogFormOriginalProc  : TWndMethod;

    procedure SetDlgImeMode(const Value: TImeMode);
    function Execute : Boolean;
    procedure SetFilesListToItems(ADir, AFindText, AAddFindText, AFileExt: String; Select: Boolean);
    procedure DisplayDirectoryText(Text : String);
    procedure DialogFormSubClassProc(var Message:TMessage);
    procedure OKBtnOnClick(Sender: TObject);
    procedure CancelBtnOnClick(Sender: TObject);
    procedure FindBtnOnClick(Sender: TObject);
    procedure FolderBtnOnClick(Sender: TObject);
    procedure FileEditOnChange(Sender: TObject);
    procedure DialogOnCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure PopUpMenuOnPopup(Sender: TObject);
    procedure PopUpMenuFileRenameOnClick(Sender: TObject);
    procedure PopUpMenuFileDeleteOnClick(Sender: TObject);
    procedure BrowseSelectionChanged(Sender: TObject;Wnd: HWND; Directory:String;
                                     var StatusText: String; var OKBtnEnabled: Boolean);
    procedure SetFont(const Value: TFont);
  protected
    { Protected �錾 }
    procedure Loaded; override;
    procedure DoShow; dynamic;
    property FormLeft    : Integer read FFormLeft   write FFormLeft;
    property FormTop     : Integer read FFormTop    write FFormTop;
    property FormHeight  : Integer read FFormHeight write FFormHeight;
    property FormWidth   : Integer read FFormWidth  write FFormWidth;

    property Handle             : HWND                   read FHandle;
    property ModalResult        : TModalResult           read FModalResult;
    property ImgListHandle      : THandle                read FImgListHandle;
    property DialogForm         : TForm                  read FDialogForm;
    property ListView           : TplFileDialogListView  read FListView;
    property BrowseFolder       : TplBrowseFolder        read FBrowseFolder;
    property ListViewItemHeight : Integer                read FListViewItemHeight write FListViewItemHeight;
    property TopPanel           : TPanel                 read FTopPanel;
    property ListPanel          : TPanel                 read FListPanel;
    property BottomPanel        : TPanel                 read FBottomPanel;
    property DirectoryLabel     : TLabel                 read FDirectoryLabel;
    property FileEdit           : TEdit                  read FFileEdit;
    property OKBtn              : TBitBtn                read FOKBtn;
    property CancelBtn          : TBitBtn                read FCancelBtn;
    property FindBtn            : TSpeedButton           read FFindBtn;
    property FolderBtn          : TSpeedButton           read FFolderBtn;
    property PopupMenu          : TPopupMenu             read FPopupMenu;
    property PopFileRename      : TMenuItem              read FPopFileRename;
    property PopFileDelete      : TMenuItem              read FPopFileDelete;

    property ItemRightMargin    : Integer read FItemRightMargin  write FItemRightMargin;
    property FontSize           : Integer read FFontSize         write FFontSize;
    property Font               : TFont   read FFont             write SetFont;

    property RootDir           : String                    read FRootDir           write FRootDir;
    property Directory         : String                    read FDirectory         write FDirectory;
    property FilePath          : String                    read FFilePath          write FFilePath;
    property FileName          : TFileName                 read FFileName          write FFileName;
    property FileExt           : String                    read FFileExt           write FFileExt;
    property FindText          : String                    read FFindText          write FFindText;
    property Title             : String                    read FTitle             write FTitle;
    property AndFindText       : String                    read FAndFindText       write FAndFindText;
    property ImeMode           : TImeMode                  read FImeMode           write SetDlgImeMode;
    property DisplayDirectory  : Boolean                   read FDisplayDirectory  write FDisplayDirectory;
    property DisplayIcon       : Boolean                   read FDisplayIcon       write FDisplayIcon;
    property DisplayGridLines  : Boolean                   read FDisplayGridLines  write FDisplayGridLines;
    property Options           : TplDialogOptions          read FOptions           write FOptions;
    property BrowseTitle       : String                    read FBrowseTitle       write FBrowseTitle;
    property BrowseCaption     : String                    read FBrowseCaption     write FBrowseCaption;
    property OnShow            : TNotifyEvent              read FOnShow            write FOnShow;
    property OnBeforeDelete    : TplDialogBeforeEvent      read FOnBeforeDelete    write FOnBeforeDelete;
    property OnBeforeClose     : TplDialogBeforeEvent      read FOnBeforeClose     write FOnBeforeClose;
    property OnReNameMenuClick : TplDialogBeforeEvent      read FOnReNameMenuClick write FOnReNameMenuClick;
    property OnBeforeRename    : TplDialogBeforeExEvent    read FOnBeforeRename    write FOnBeforeRename;
    property OnAfterDelete     : TplDialogAfterEvent       read FOnAfterDelete     write FOnAfterDelete;
    property OnAfterRename     : TplDialogAfterExEvent     read FOnAfterRename     write FOnAfterRename;
    property OnFindBtnClick    : TplDialogFindBtnEvent     read FOnFindBtnClick    write FOnFindBtnClick;
    property OnFolderBtnClick  : TplDialogBFBtnEvent       read FOnFolderBtnClick  write FOnFolderBtnClick;
    property OnFileListed      : TplDialogFileListedEvent  read FOnFileListed      write FOnFileListed;

    property OnAdvancedCustomDrawItem : TplDialogCustomDrawItem read  FOnAdvancedCustomDrawItem write FOnAdvancedCustomDrawItem;
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetFilesList;
  end;

  //---------------------------------------------------------------------------
  //  [�t�@�C���I��]�_�C�A���O
  //---------------------------------------------------------------------------

  TplOpenDialog = class(TplCustomFileDialog)
  private
    { Private �錾 }
  protected
    { Protected �錾 }
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
    function Execute : Boolean;
    property Handle;
    property DialogForm;
    property BrowseFolder;
    property FileName;
    property FilePath;
    property ModalResult;
  published
    { Published �錾 }
    property FormTop;
    property FormLeft;
    property FormHeight;
    property FormWidth;
    property Font;

    property FileExt;
    property Directory;
    property Title;
    property FindText;
    property ImeMode;
    property DisplayDirectory;
    property DisplayIcon;
    property DisplayGridLines;
    property Options;
    property RootDir;
    property BrowseTitle;
    property BrowseCaption;
    property OnShow;
    property OnBeforeDelete;
    property OnBeforeClose;
    property OnReNameMenuClick;
    property OnBeforeRename;
    property OnAfterDelete;
    property OnAfterRename;
    property OnFindBtnClick;
    property OnFolderBtnClick;
    property OnFileListed;
    property OnAdvancedCustomDrawItem;
  end;

  //---------------------------------------------------------------------------
  //  [�ۑ�]�_�C�A���O
  //---------------------------------------------------------------------------

  TplSaveDialog = class(TplCustomFileDialog)
  private
    { Private �錾 }
  protected
    { Protected �錾 }
  public
    { Public �錾 }
    constructor Create(AOwner: TComponent); override;
    function Execute : Boolean;
    property Handle;
    property DialogForm;
    property BrowseFolder;
    property FilePath;
    property ModalResult;
  published
    { Published �錾 }
    property FormTop;
    property FormLeft;
    property FormHeight;
    property FormWidth;
    property Font;

    property FileExt;
    property Directory;
    property FileName;
    property Title;
    property FindText;
    property ImeMode;
    property DisplayDirectory;
    property DisplayIcon;
    property DisplayGridLines;
    property Options;
    property RootDir;
    property BrowseTitle;
    property BrowseCaption;
    property OnShow;
    property OnBeforeDelete;
    property OnBeforeClose;
    property OnReNameMenuClick;
    property OnBeforeRename;
    property OnAfterDelete;
    property OnAfterRename;
    property OnFindBtnClick;
    property OnFolderBtnClick;
    property OnFileListed;
    property OnAdvancedCustomDrawItem;
  end;

implementation

{$IF CompilerVersion > 23.99}
uses Types, UITypes;
{$IFEND}

{$R *.res}

const
  //[�t�@�C���I��][�ۑ�]�_�C�A���O�p
  ErrorReName1 = '�����̃t�@�C�������ɑ��݂��܂��D';
  ErrorReName2 = '���O�̕ύX�Ɏ��s���܂����D�s���ȕ��������邩.�ύX�̌������Ȃ��\��������܂��D';
  ErrorDelete  = '�폜�ł��܂���D�t�@�C���͓Ǐo����p���폜�̌���������܂���D';


  //�t�H���_�Q�ƃ_�C�A���O�p
  //���[�g�t�H���_�E�����I���t�H���_�̊e�I���}�ɑΉ�����l�̃��X�g
  //�Â�OS�ɂ͂Ȃ��萔������̂Ŏ��l���i�[

  CSIDL_Array : array [TplBFSpecialDir] of Integer=(
      $0000,    //  CSIDL_DESKTOP',            �w��Ȃ�.RootDir,InitDir�̎w��ɏ]��
      $0000,    //  CSIDL_DESKTOP',            �w��Ȃ�.RootDir,InitDir�̎w��ɏ]��
      $0001,    //  CSIDL_INTERNET',
      $0002,    //  CSIDL_PROGRAMS',
      $0003,    //  CSIDL_CONTROLS',
      $0004,    //  CSIDL_PRINTERS',
      $0005,    //  CSIDL_PERSONAL',
      $0006,    //  CSIDL_FAVORITES',
      $0007,    //  CSIDL_STARTUP',
      $0008,    //  CSIDL_RECENT',
      $0009,    //  CSIDL_SENDTO',
      $000A,    //  CSIDL_BITBUCKET',
      $000B,    //  CSIDL_STARTMENU',
      $000C,    //  CSIDL_MYDOCUMENTS',
      $000D,    //  CSIDL_MYMUSIC',
      $000E,    //  CSIDL_MYVIDEO',
      $0010,    //  CSIDL_DESKTOPDIRECTORY',
      $0011,    //  CSIDL_DRIVES',
      $0012,    //  CSIDL_NETWORK',
      $0013,    //  CSIDL_NETHOOD',
      $0014,    //  CSIDL_FONTS',
      $0015,    //  CSIDL_TEMPLATES',
      $0016,    //  CSIDL_COMMON_STARTMENU',
      $0017,    //  CSIDL_COMMON_PROGRAMS',
      $0018,    //  CSIDL_COMMON_STARTUP',
      $0019,    //  CSIDL_COMMON_DESKTOPDIRECTORY',
      $001A,    //  CSIDL_APPDATA',
      $001B,    //  CSIDL_PRINTHOOD',
      $001C,    //  CSIDL_LOCAL_APPDATA',
      $001D,    //  CSIDL_ALTSTARTUP',
      $001E,    //  CSIDL_COMMON_ALTSTARTUP',
      $001F,    //  CSIDL_COMMON_FAVORITES',
      $0020,    //  CSIDL_INTERNET_CACHE',
      $0021,    //  CSIDL_COOKIES',
      $0022,    //  CSIDL_HISTORY',
      $0023,    //  CSIDL_COMMON_APPDATA',
      $0024,    //  CSIDL_WINDOWS',
      $0025,    //  CSIDL_SYSTEM',
      $0026,    //  CSIDL_PROGRAM_FILES',
      $0027,    //  CSIDL_MYPICTURES',
      $0028,    //  CSIDL_PROFILE',
      $0029,    //  CSIDL_SYSTEMX86',
      $002A,    //  CSIDL_PROGRAM_FILESX86',
      $002B,    //  CSIDL_PROGRAM_FILES_COMMON',
      $002C,    //  CSIDL_PROGRAM_FILES_COMMONX86',
      $002D,    //  CSIDL_COMMON_TEMPLATES',
      $002E,    //  CSIDL_COMMON_DOCUMENTS',
      $002F,    //  CSIDL_COMMON_ADMINTOOLS',
      $0030,    //  CSIDL_ADMINTOOLS',
      $0031,    //  CSIDL_CONNECTIONS',
      $0035,    //  CSIDL_COMMON_MUSIC',
      $0036,    //  CSIDL_COMMON_PICTURES',
      $0037,    //  CSIDL_COMMON_VIDEO',
      $0038,    //  CSIDL_RESOURCES',
      $0039,    //  CSIDL_RESOURCES_LOCALIZED',
      $003A,    //  CSIDL_COMMON_OEM_LINKS',
      $003B,    //  CSIDL_CDBURN_AREA',
      $003D,    //  CSIDL_COMPUTERSNEARME',
      $003E);   //  CSIDL_PROFILES',

  //�t�H���_�Q�ƃ_�C�A���O�p
  //�I�v�V�����ݒ�p�̏W���^
  //�Â�OS�ɂ͂Ȃ��萔������̂Ŏ��l���i�[

  BrowseOptions : array [TplBrowseOption] of Cardinal = (
      $0001,    // BIF_RETURNONLYFSDIRS
      $0002,    // BIF_DONTGOBELOWDOMAIN
      $0004,    // BIF_STATUSTEXT
      $0008,    // BIF_RETURNFSANCESTORS
      $0010,    // BIF_EDITBOX
      $0020,    // BIF_VALIDATE
      $0040,    // BIF_NEWDIALOGSTYLE
      $0050,    // BIF_USENEWUI
      $0080,    // BIF_BROWSEINCLUDEURLS
      $0100,    // BIF_UAHINT
      $0200,    // BIF_NONEWFOLDERBUTTON
      $0400,    // BIF_NOTRANSLATETARGETS
      $1000,    // BIF_BROWSEFORCOMPUTER
      $2000,    // BIF_BROWSEFORPRINTER
      $4000,    // BIF_BROWSEINCLUDEFILES
      $8000);   // BIF_SHAREABLE


var
  FFileList         : TplFileDialogDataList;
  OriginItemWndProc : Pointer;


{ TplBrowseFolder }

//-----------------------------------------------------------------------------
//  ���ڎ��ʎq����t�H���_�܂��̓t�@�C���̕\���������߂�
//  �\�����Ƃ̓G�N�X�v���[���ɕ\������镶����
//  Win32 API��SHGetPathFromIDList�ł͓���t�H���_����GUID�̃p�X���͎擾�ł���
//  ���̂ł��̊֐����g�p����
//
//  ��1����  �Ώۂ̍��ڎ��ʎq���擾����ۂɎg�p�����V�F���t�H���_�I�u�W�F�N�g
//  ��2����  �Ώۂ̍��ڎ��ʎq
//
//  Flag(DWORD)�ɂ͈ȉ��̒l���w��\�ł��邪�C�����ł�SHGDN_NORMAL�̎擾��p
//  �\�����̎�ނňȉ��̂����ꂩ
//  SHGDN_NORMAL      �\���p(�f�t�H���g)
//  SHGDN_INFOLDER    �t�H���_���̕\����
//�@SHGDN_FORPARSING  �e�t�H���_��ParseDisplayName�ɓn���\����(GUID���܂�)
//
//  ParseDisplayName�̓t���p�X�����獀�ڎ��ʎq�����߂�֐��ł��̊֐��̋t�@�\
//
//  GetDisplayNameOf�̓t�@�C���I�u�W�F�N�g��T�u�t�H���_�̕\������TStrRet�\����
//  �Ŏ擾����V�F���t�H���_�I�u�W�F�N�g�̊֐�
//  ��1���� TItemIDList�\���̂ւ̃|�C���^
//  ��2���� �擾����\�����̎��
//  ��3���� �\�������i�[����TStrRet�\����
//
//  TStrRec�\����
//  uType ������̃t�H�[�}�b�g�t���O(�ȉ��̂����ꂩ)
//  �ESTRRET_CSTR    �������cStr�Ɋi�[
//  �ESTRRET_OFFSET  ������͍��ڎ��ʎq�̓�����uOffset�o�C�g�̈ʒu
//�@�ESTRRET_WSTR    �������pOleStr�̈ʒu
//  pOleStr OLE������ւ̃|�C���^
//  pStr    Ansi������ւ̃|�C���^
//  uOffset ���ڎ��ʎq�̃I�t�Z�b�g
//  cStr    Char�o�b�t�@
//-----------------------------------------------------------------------------
function GetDispNameFromPItemID(ShFolder: IShellFolder; ItemID: PItemIDList;
   Flag: DWORD=SHGDN_NORMAL): String;
var
  StrRet : TStrRet;
begin
  Result := '';
  if ShFolder = nil then exit;
  if ItemID = nil then exit;

  FillChar(StrRet, SizeOf(StrRet), 0);
  if NOERROR = ShFolder.GetDisplayNameOf(ItemID, Flag, StrRet) then begin
    case StrRet.uType of
    STRRET_CSTR:
      begin
        SetString(Result, StrRet.cStr, lStrLenA(StrRet.cStr));
      end;
    STRRET_OFFSET:
      begin
        //�|�C���^�̃I�t�Z�b�g
        Inc(pByte(ItemID), StrRet.uOffset);
        Result := PChar(ItemID);
      end;
    STRRET_WSTR:
      begin
        Result := StrRet.pOleStr;
      end;
    end;
  end;
end;

//-----------------------------------------------------------------------------
//  ���ڎ��ʎq���t�H���_�����Ƀt�H���_�������Ă����True
//  ���[�g�f�B���N�g���Ə����I���f�B���N�g�����m���Ƀt�H���_�ł���ΕK�v�Ȃ�
//  �����܂ł��O�̂���
//-----------------------------------------------------------------------------
function IsFolderPItemID(ShFolder: IShellFolder; ItemID: PItemIDList): BOOL;
var
  Attrib : Cardinal;
  V      : Cardinal;
begin
  V := SFGAO_HASSUBFOLDER or SFGAO_FOLDER;
  ShFolder.GetAttributesOf(1, ItemID, Attrib);
  Result := (V and Attrib) <> 0;
end;

//-----------------------------------------------------------------------------
//  �w�肵���f�B���N�g��(�t�H���_)�̍��ڎ��ʎqPItemIDList���擾
//
//  �f�B���N�g����������ŗ^����ꂽ�ꍇ�͂������D��
//  Dir      : �ʏ�̕�����ł̃f�B���N�g����(ex. 'C:\Windows')
//  SpDir    : CSIDL�l�̃f�B���N�g����
//  ShFolder : �t�H���_�̃V�F���I�u�W�F�N�g
//             �����ł̓f�B�N�X�g�b�v�̃I�u�W�F�N�g�Ƃ���
//-----------------------------------------------------------------------------
function GetDirPItemIDList(Dir: String; SpDir: TplBFSpecialDir;
  ShFolder: IShellFolder): PItemIDList;
var
  Len   : Cardinal;
  Flags : Cardinal;
  hr    : HResult;
begin
  Result := nil;

  //�ʏ�̃f�B���N�g�������f�B�X�N�g�b�v����ɂ������ڎ��ʎq�ɕϊ�
  if (SpDir = sfNone) and (Dir <> '') then begin
    Flags := 0;
    Len   := Length(Dir);
    hr    := ShFolder.ParseDisplayName(Application.Handle,
                                       nil,
                                       PWideChar(StringToOleStr(Dir)),
                                       Len,
                                       Result,
                                       Flags);
    if SUCCEEDED(hr) and IsFolderPItemID(ShFolder, Result) then begin
      exit;
    end;
  end else begin
    //CSIDL�l�����ڎ��ʎq�ɕϊ�
    SHGetSpecialFolderLocation(Application.Handle, CSIDL_Array[SpDir], Result);
  end;
end;

//-----------------------------------------------------------------------------
//  �t�H���_�[�̑I���_�C�A���O�̃R�[���o�b�N�֐�
//  �{�R���|�̈ȉ��̃C�x���g������
//
//  OnShow            �_�C�A���O�̏��������I���������ɔ���
//                    �\���ʒu�ƃT�C�Y�͂܂����ݒ�
//
//  OnSelectionChage  �_�C�A���O�Ńt�H���_��I��������
//                    �I�������t�H���_���̎擾���\
//                    �_�C�A���O�㕔(Title�p�̉�)�ɕ������\���\
//                    �����Options��bifStatusText��L���ɂ����ꍇ�̂�
//                    ���̓���̓R�[���o�b�N�֐����ł��������ł��Ȃ�
//                    [OK]�{�^���̗L���������w��\
//-----------------------------------------------------------------------------
function plBrowseFolderProc(hWindow: HWND; uMsg: UINT; lpParam: LPARAM;
                        lpData: LPARAM): Integer; stdcall;
var
  BF           : TplBrowseFolder;
  ADirectory   : array[0..MAX_PATH-1] of Char;
  WndOKBtn     : HWND;
  StatusText   : String;
  OKBtnEnabled : Boolean;
begin
  //���̃R�[���o�b�N�֐��͏��0��Ԃ��Ȃ���΂����Ȃ�
  Result := 0;

  BF := (TObject(lpData) as TplBrowseFolder);

  StatusText := '';
  ADirectory := '';

  case uMsg of
  BFFM_INITIALIZED:
    begin
      //�����I���t�H���_������łȂ���΁C�����I����Ԃɂ���
      //����ɂ̓_�C�A���O�E�B���h�E��BFFM_SETSELECTION���b�Z�[�W�𑗂�
      if BF.FInitDirPItemID <> nil then begin
        SendMessage(hWindow, BFFM_SETSELECTION, Integer(False), Integer(BF.FInitDirPItemID));
      end;

      if BF.FHandle = 0 then BF.FHandle := hWindow;
      //OnShow�C�x���g
      if Assigned(BF.FOnShow) then BF.OnShow(TplBrowseFolder(BF));
    end;
  BFFM_SELCHANGED:
    begin
      if BF.FHandle = 0 then BF.FHandle := hWindow;

      //�I�����Ă���t�H���_�̍��ڎ��ʎq���p�X������ɕϊ�
      SHGetPathFromIDList(PItemIDList(lpParam), @ADirectory);

      //OnSelectionChange�C�x���g����`���Ă���ꍇ
      if Assigned(BF.FOnSelectionChanged) then begin
        //[OK]�{�^���̏��(�����L��)�𒲍�
        WndOKBtn     := GetDlgItem(BF.Handle, 1);
        OKBtnEnabled := IsWindowEnabled(WndOKBtn);

        BF.FOnSelectionChanged(TplBrowseFolder(BF), hWindow, String(ADirectory), StatusText, OKBtnEnabled);
        //StatusText�̐ݒ�͐V�����X�^�C���̃_�C�A���O�ł͖���
        //ShowWindow(WndOkBtn, SH_HIDE)�͋@�\����
        SendMessage(hWindow, BFFM_SETSTATUSTEXT, 0, Integer(PChar(StatusText)));
        PostMessage(hWindow, BFFM_ENABLEOK, 0, Integer(OKBtnEnabled));
      end;
    end;
  end;
end;

//=============================================================================
//  �t�H���_�[�̑I���_�C�A���O
//  Create����
//=============================================================================
constructor TplBrowseFolder.Create(AOwner: TComponent);
var
  OSInfo : TOSVERSIONINFO;
begin
  inherited Create(AOwner);

  //OS�̃o�[�W�����l���擾���Ă���
  //�����������ł�Vista�ȍ~�ɑ΂��锻��Ȃ̂ł��ꂾ��
  OSInfo.dwOSVersionInfoSize := Sizeof(OSVERSIONINFO);
  GetVersionEx(osInfo);
  if OSInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then begin
    OSVersionValueMajor := OSInfo.dwMajorVersion;
    OSVersionValueMinor := OSInfo.dwMinorVersion;
    IsOSBeforeVista     := (OSVersionValueMajor <= 5) and (OSVersionValueMinor <= 1);
  end;

  FDialogPositionSet := False;
  FHandle            := 0;
  FormWidthDefault   := 390;
  FormHeightDefault  := 400;
  FFormWidth         := FormWidthDefault;
  FFormHeight        := FormHeightDefault;
  FFormLeft          := 0;
  FFormTop           := 0;
  FInitDir           := '';
  FRootSpecialDir    := sfDesktop;              //���[�g�̓f�X�N�g�b�v
  FInitSpecialDir    := sfNone;                 //�����I����InitDir�v���p�e�B�̒l
  FOptions           := [bifReturnOnlyFSDirs];  //�t�@�C���t�H���_�̂ݑI���\
end;

//=============================================================================
//  �t�H���_�[�̑I���_�C�A���O
//  �_�C�A���O�̍���
//=============================================================================
procedure TplBrowseFolder.SetFormHeight(const Value: Integer);
begin
  if Value <= FormWidthDefault then begin
    FFormHeight := FormHeightDefault;
  end else begin
    FFormHeight := Value;
  end;
end;

//=============================================================================
//  �t�H���_�[�̑I���_�C�A���O
//  �_�C�A���O�̕�
//=============================================================================
procedure TplBrowseFolder.SetFormWidth(const Value: Integer);
begin
  if Value <= FormWidthDefault then begin
    FFormWidth := FormWidthDefault;
  end else begin
    FFormWidth := Value;
  end;
end;

//=============================================================================
//  SHBrowseForFolder�֐��Ńt�H���_�̎Q�ƃ_�C�A���O��\��
//  SHBrowseForFolder�ł́C�t�H���_�̐ݒ���擾�����ڎ��ʎq���g�p����
//
//  FInitDir(�_�C�A���O��\���������ɑI����Ԃɂ���t�H���_)��FRootDir�̊K�w��
//  �ɂ��邩�̃`�b�N�͍s���Ă��Ȃ�
//=============================================================================
function TplBrowseFolder.Execute: Boolean;
var
  Malloc           : IMalloc;
  FDesktopSHFolder : IShellFolder;
  FolderPItemID    : PItemIDList;
  BrowseInfo       : TBrowseInfo;
  Option           : TplBrowseOption;
  BDisplayName     : array[0..MAX_PATH-1] of Char;
  OwnerControl     : TWinControl;
  OldErrorMode     : Cardinal;
  AFullPath        : String;
begin
  SHGetMalloc(Malloc);

  Result      := False;
  FFolderName := '';
  FDirectory  := '';

  //�f�X�N�g�b�v�̃V�F���t�H���_�I�u�W�F�N�g���擾
  if Failed (SHGetDesktopFolder(FDesktopSHFolder)) then begin
    FHandle := 0;
    Malloc  := nil;
    Result  := False;
    exit;
  end;

  FolderPItemID := nil;
  //���[�g�ƕ\������f�B���N�g���̍��ڎ��ʎq���擾
  //FRootDir,FInitDir�͂��̃R���|��published�ȃv���p�e�B
  RootPItemID     := GetDirPItemIDList(FRootDir, FRootSpecialDir, FDesktopSHFolder);
  FInitDirPItemID := GetDirPItemIDList(FInitDir, FInitSpecialDir, FDesktopSHFolder);

  if (RootPItemID = nil) or (FInitDirPItemID = nil) then begin
    FHandle := 0;
    Malloc  := nil;
    Result  := False;
    exit;
  end;

  OwnerControl             := TWinControl(Owner);
  OwnerControlOriginalProc := OwnerControl.WindowProc;
  OwnerControl.WindowProc  := OwnerControlSubClassProc;

  BrowseInfo.hwndOwner      := OwnerControl.Handle;
  BrowseInfo.pidlRoot       := RootPItemID;
  BrowseInfo.pszDisplayName := BDisplayName;
  BrowseInfo.lpszTitle      := PChar(FTitle);

  BrowseInfo.ulFlags:= 0;
  for Option := Low(Option) to High(Option) do begin
    if Option in FOptions then begin
      BrowseInfo.ulFlags := BrowseInfo.ulFlags or BrowseOptions[Option];
    end;
  end;

  //�R�[���o�b�N�֐��w��
  BrowseInfo.lpfn   := @plBrowseFolderProc;
  BrowseInfo.lParam := Integer(Self);

  //�t�H���_�̑I���_�C�A���O��\��
  OldErrorMode := 0;
  try
    //�t���b�s�[�f�B�X�N��I/O�G���[�΍�
    OldErrorMode  := SetErrorMode(SEM_FAILCRITICALERRORS);
    FolderPItemID := SHBrowseForFolder(BrowseInfo);
  except
    Result := False;
  end;
  FHandle            := 0;
  FDialogPositionSet := False;
  //�t���b�s�[�f�B�X�N��I/O�G���[�΍����
  SetErrorMode(OldErrorMode);

  //�I�[�i��WindowProc�����ɖ߂��Ă���
  OwnerControl.WindowProc := OwnerControlOriginalProc;

  //SHBrowseForFolder�֐��̖߂�l(���ڎ��ʎq)��nil�łȂ���Ίe�ϐ���
  //BrowseInfo�̃����o�[�Ɋ��蓖�Ă��ϐ��ɒl���i�[�����
  if FolderPItemID <> nil then begin
    AFullPath   := GetDispNameFromPItemID(FDesktopSHFolder,
                                          FolderPItemID,
                                          SHGDN_FORPARSING);
    FDirectory  := AFullPath;
    FFolderName := BDisplayName;

    CoTaskMemFree(FolderPItemID);
    Result := True;
  end;

  Malloc  := nil;
end;

//=============================================================================
//  �t�H���_�̎Q�ƃ_�C�A���O�̃I�[�i�[�̃T�u�N���X�֐�
//
//  �t�H���_�̎Q�ƃ_�C�A���O���\�����ꂽ��\���ʒu�ƃT�C�Y��ݒ�
//  �t�H���_�̎Q�ƃ_�C�A���O������ە\���ʒu�ƃT�C�Y���擾
//  FHandle�̓_�C�A���O�̃n���h���DSHBrowseForFolder�̃R�[���o�b�N�֐����Ŏ擾
//
//  �_�C�A���O��������WM_Activate��������Ă΂��̂Ńt���O�Ƃ���
//  FDialogPositionSet���g�p
//=============================================================================
procedure TplBrowseFolder.OwnerControlSubClassProc(var Message: TMessage);
var
  AWnd  : HWND;
  ARect : TRect;
begin
  OwnerControlOriginalProc(Message);

  if Message.Msg = WM_ACTIVATE then begin
    if Message.WParam = WA_INACTIVE then begin
      AWnd := Message.LParam;
      if (FHandle = AWnd) and (FDialogPositionSet = False) then begin
        FDialogPositionSet := True;
        SetDialogPosition;
      end;
    end else
    if Message.WParam <> WA_INACTIVE then begin
      AWnd := Message.LParam;
      if (FHandle = AWnd) and (FDialogPositionSet) then begin
        FDialogPositionSet := False;

        GetWindowRect(FHandle, ARect);
        FFormLeft   := ARect.Left;
        FFormTop    := ARect.Top;
        FFormWidth  := ARect.Right  - ARect.Left;
        FFormHeight := ARect.Bottom - ARect.Top;
      end;
    end;
  end;
end;

//=============================================================================
//  �t�H���_�̎Q�ƃ_�C�A���O�̈ʒu�ƃT�C�Y�̕ύX
//
//  �R�[���o�b�N�֐��Őݒ肷��ꍇ�C�T�C�Y�ς̐V�����X�^�C���̃_�C�A���O�̃T
//  �C�Y�̏����l�͏�ɓ����D�����\����ɕύX���Ă���炵���D���������ăT�C�Y��
//  �ύX�ł��Ȃ��D����̈ʒu�����͎w��\
//  �����ŁC�_�C�A���O�̃I�[�i�[�̃T�u�N���X�֐����`���Ă��̒��Őݒ肷��
//=============================================================================
procedure TplBrowseFolder.SetDialogPosition;
var
  ALeft        : Integer;
  ATop         : Integer;
  FormRect     : TRect;
  BtnRect      : TRect;
  TreeRect     : TRect;
  CSX          : integer;
  CSY          : integer;
  WndTreeView  : HWND;
  WndOKBtn     : HWND;
  WndCancelBtn : HWND;
  TreeHeight   : Integer;
  BtnLeft      : Integer;
  BtnTop       : Integer;
  BtnWidth     : Integer;
  BtnHeight    : Integer;
begin
  //�L���v�V�����v���p�e�B��\��
  if FCaption <> '' then SetWindowText(FHandle, PChar(FCaption));

  //�܂��f�t�H���g�̃t�H���_�Q�ƃ_�C�A���O�̃T�C�Y�����߂Ď擾
  GetWindowRect(FHandle, FormRect);

  if FFormWidth  < FormWidthDefault  then FFormWidth  := FormWidthDefault;
  if FFormHeight < FormHeightDefault then FFormHeight := FormHeightDefault;

  //FormLeft,FormTop�v���p�e�B������0�Ȃ��ʂ̒����ɕ\������
  CSX := GetSystemMetrics(SM_CXSCREEN);
  CSY := GetSystemMetrics(SM_CYSCREEN);

  if (FFormLeft = 0) and (FFormTop = 0) then begin
    ALeft := (CSX - FFormWidth)  div 2;
    ATop  := (CSY - FFormHeight) div 2;
  end else begin
    ALeft := FFormLeft;
    ATop  := FFormTop;
  end;

  //�V�����X�^�C���̃_�C�A���O�̈ʒu�ƃT�C�Y�ݒ�
  if (bifNewDialogStyle in FOptions) then begin
    SetWindowPos(FHandle, 0, ALeft, ATop, FFormWidth, FFormHeight, SWP_NOZORDER or SWP_SHOWWINDOW);
  end else begin

    //�eWindow�̃n���h�����擾
    //ID=14146����Titel,14147����StatusText������p�̂�Window
    WndTreeView  := GetDlgItem(FHandle, 14145);
    WndOKBtn     := GetDlgItem(FHandle, 1);
    WndCancelBtn := GetDlgItem(FHandle, 2);

    //�eWindow�̈ʒu�ƃT�C�Y�𒲐�����
    SetWindowPos(FHandle, 0, ALeft, ATop, FFormWidth, FFormHeight, SWP_NOZORDER or SWP_SHOWWINDOW);
    GetWindowRect(WndOKBtn, BtnRect);
    GetWindowRect(FHandle, FormRect);
    GetWindowRect(WndTreeView, TreeRect);

    BtnWidth  := BtnRect.Right  - BtnRect.Left;
    BtnHeight := BtnRect.Bottom - BtnRect.Top;
    BtnLeft   := FFormWidth  - BtnWidth * 2 - 25;
    BtnTop    := FFormHeight - BtnHeight - 35;

    TreeHeight := (FormRect.Bottom - BtnHeight-18) - TreeRect.Top;
    SetWindowPos(WndTreeView, 0, 0, 0, FFormWidth - 32, TreeHeight,
                 SWP_NOMOVE or SWP_NOZORDER or SWP_SHOWWINDOW);

    //[OK][�L�����Z��]�{�^��
    SetWindowPos(WndOKBtn, 0, BtnLeft, BtnTop, 0, 0,
                 SWP_NOSIZE or SWP_NOZORDER or SWP_SHOWWINDOW);

    SetWindowPos(WndCancelBtn, 0, BtnLeft + BtnWidth + 5, BtnTop, 0, 0,
                 SWP_NOSIZE or SWP_NOZORDER or SWP_SHOWWINDOW);
  end;
end;

//-----------------------------------------------------------------------------
//
//
//  [�t�@�C���I��]��[�ۑ�]�_�C�A���O�̊�{�N���X
//
//
//-----------------------------------------------------------------------------

{ TplCustomFileDialog }

//=============================================================================
//  Create����
//  ���̃R���g���[���ނ�Loaded�Ő���
//=============================================================================
constructor TplCustomFileDialog.Create(AOwner: TComponent);
var
  ARect  : TRect;
  OSInfo : TOSVERSIONINFO;
begin
  inherited Create(AOwner);

  //OS�̃o�[�W�����l���擾���Ă���
  //�����������ł�Vista�ȍ~�ɑ΂��锻��Ȃ̂ł��ꂾ��
  OSInfo.dwOSVersionInfoSize := Sizeof(OSVERSIONINFO);
  GetVersionEx(osInfo);
  if OSInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then begin
    OSVersionValueMajor := OSInfo.dwMajorVersion;
    OSVersionValueMinor := OSInfo.dwMinorVersion;
    IsOSBeforeVista     := (OSVersionValueMajor <= 5) and (OSVersionValueMinor <= 1);
  end;

  SystemParametersInfo(SPI_GETWORKAREA, 0, @ARect, 0);

  //�_�C�A���O�t�H�[���̕\���ʒu�ƃT�C�Y�̏����l
  FFormWidth  := (ARect.Right - ARect.Left) * 2 div 5;
  FFormHeight := (ARect.Bottom - ARect.Top) div 2;
  FFormLeft   := ((ARect.Right + ARect.Left) - FFormWidth) div 2;
  FFormTop    := ((ARect.Bottom + ARect.Top) - FFormHeight) div 2;

  //���̑��̕ϐ��̏�����
  FModalResult        := mrNone;
  FRootDir            := '';          //���[�g�f�B���N�g��
  FDirectory          := '';          //�t�@�C���ꗗ���Ă���f�B���N�g����
  FTitle              := '';          //�_�C�A���O�̃L���v�V����
  FFindText           := '';          //�\���t�@�C���̕�����v��������
  FAndFindText        := '';          //�i���ݒv��������
  FBrowseTitle        := '';          //�t�H���_�I���_�C�A���O�̐���������
  FBrowseCaption      := '';          //�t�H���_�I���_�C�A���O�̃L���v�V����������
  FDisplayDirectory   := False;       //�_�C�A���O�̏㕔�Ƀf�B���N�g������\��
  FDisplayIcon        := True;        //�t�@�C���ꗗ�̃t�@�C���̃A�C�R���\��
  FDisplayGridLines   := True;        //ListView�̃O���b�h��
  FImeMode            := imDontCare;  //IME�ݒ�
  FOptions            := [];          //�i���݂ƃt�H���_�I���_�C�A���O�\���{�^��
  FListViewItemHeight := 19;          //ListView��Item�̍���
  FMargin             := 4;           //Form��ListView�̕\���}�[�W��
  FDirectoryLabelText := '';          //�f�B���N�g���\�����x���̕�����
  FFontSize           := 9;
  FFont               := TFont.Create;
  FFont.Size          := FFontSize;

  if IsOSBeforeVista then begin
    FItemRightMargin := 6;
  end else begin
    FItemRightMargin := 0;
  end;
end;

//=============================================================================
//  �I�����̏���
//=============================================================================
destructor TplCustomFileDialog.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

//=============================================================================
//  �_�C�A���O�̃t�H�[���Ƃ��̊֌W�R���g���[���𐶐�
//  �����Ő������Ă���̂�Create��ɂ��낢��Ȑݒ�ύX���\�ƂȂ�
//
//  OS�⑼�̃A�v�����l��Execute���\�b�h���s���ɐ������Ă��悢���C�����Ő�����
//  �Ă����ƁCExecute���s�O�Ɋe��̐ݒ肪�\
//=============================================================================
procedure TplCustomFileDialog.Loaded;
begin
  inherited Loaded;

  //�_�C�A���O�t�H�[���{��
  FDialogForm := TForm.Create(Self);
  with FDialogForm do begin
    Left        := FFormLeft;
    Top         := FFormTop;
    Height      := FFormHeight;
    Width       := FFormWidth;
    Position    := poDesigned;
    BorderIcons := [biSystemMenu];
    Scaled      := False;
    FHandle     := FDialogForm.Handle;
    Icon        := Application.Icon;
    KeyPreview  := True;

    OnCloseQuery           := DialogOnCloseQuery;
    DialogFormOriginalProc := FDialogForm.WindowProc;
    FDialogForm.WindowProc := DialogFormSubClassProc;
  end;

  //�|�b�v�A�b�v���j���[�֌W�̍쐬
  FPopupMenu := TPopupMenu.Create(FDialogForm);
  with FPopupMenu do begin
    AutoHotkeys       := maManual;
    AutoLineReduction := maManual;
    OnPopup           := PopUpMenuOnPopup;
  end;

  FPopFileRename := TMenuItem.Create(FPopupMenu);
  with FPopFileRename do begin
    Caption           := '�t�@�C�����ύX';
    AutoHotkeys       := maManual;
    AutoLineReduction := maManual;
    Bitmap            := nil;
    OnClick           := PopUpMenuFileRenameOnClick;
  end;
  FPopupMenu.Items.Add(FPopFileRename);

  FPopFileDelete := TMenuItem.Create(FPopupMenu);
  with FPopFileDelete do begin
    Caption           := '�t�@�C���폜';
    AutoHotkeys       := maManual;
    AutoLineReduction := maManual;
    Bitmap            := nil;
    OnClick           := PopUpMenuFileDeleteOnClick;
  end;
  FPopupMenu.Items.Add(FPopFileDelete);

  //�t�H���_���\���p�ƍi���ݕ\���ƃt�H���_�I���_�C�A���O�\���{�^���z�u�p�l��
  FTopPanel := TPanel.Create(FDialogForm);
  with FTopPanel do begin
    Parent         := FDialogForm;
    Height         := 27;
    Align          := alTop;
    Alignment      := taLeftJustify;
    BevelOuter     := bvNone;
    Visible        := FDisplayDirectory;
    Font.Size      := FFontSize;
    DoubleBuffered := True;
    ControlStyle := ControlStyle + [csOpaque];
  end;

  //[�t�@�C���I��][�ۑ�][�L�����Z��]�{�^���z�u�p�p�l��
  FBottomPanel := TPanel.Create(FDialogForm);
  with FBottomPanel do begin
    Parent     := FDialogForm;
    Height     := 30;
    Align      := alBottom;
    Alignment  := taCenter;
    BevelOuter := bvNone;
  end;

  //�t�@�C���ꗗ��ListView��z�u����p�l��
  FListPanel := TPanel.Create(FDialogForm);
  with FListPanel do begin
    Parent      := FDialogForm;
    Height      := 32;
    Align       := alClient;
    Alignment   := taCenter;
    BevelOuter  := bvNone;
    BevelWidth  := 1;
    BorderWidth := FMargin;
  end;

  //[�L�����Z��]�{�^��
  FCancelBtn := TBitBtn.Create(FDialogForm);
  with FCancelBtn do begin
    Parent      := FBottomPanel;
    Height      := 25;
    Width       := 75;
    Top         := FBottomPanel.Height - Height - 4;
    Left        := FBottomPanel.Width - Width - FMargin;
    Anchors     := [akRight, akBottom];
    Caption     := '�L�����Z��';
    Cancel      := True;
    Default     := False;
    ModalResult := mrCancel;
    Visible     := True;
    OnClick     := CancelBtnOnClick;
  end;

  //[�t�@�C���I��][�ۑ�]�{�^��(���p)
  FOKBtn := TBitBtn.Create(FDialogForm);
  with FOKBtn do begin
    Parent       := FBottomPanel;
    Height       := 26;
    Width        := 75;
    Top          := FCancelBtn.Top;
    Left         := FCancelBtn.Left - 2 - Width;
    Anchors      := [akRight, akBottom];
    Default      := True;
    ModalResult  := mrOK;
    Visible      := True;
    OnClick      := OKBtnOnClick;
  end;

  //�t�@�C�����ҏWEdit
  FFileEdit := TEdit.Create(FDialogForm);
  with FFileEdit do begin
    Parent             := FBottomPanel;
    Height             := 21;
    Top                := FBottomPanel.Height - Height - 6;
    Left               := FMargin;
    Width              := FBottomPanel.Width -
                          (FBottomPanel.Width - FOKBtn.Left) -
                          FMargin - 2;
    Anchors            := [akLeft, akTop, akRight, akBottom];
    Visible            := False;
    Font               := FFont;
    HideSelection      := True;
    ImeMode            := FImeMode;
    FFileEdit.OnChange := FileEditOnChange;
  end;

  //�t�H���_�I���_�C�A���O�\���p�{�^��
  FFolderBtn := TSpeedButton.Create(FDialogForm);
  with FFolderBtn do begin
    Parent            := FTopPanel;
    Height            := FTopPanel.Height;
    Width             := 24;
    Top               := 0;
    Left              := FTopPanel.Width - Width - FMargin;
    Anchors           := [akRight, akBottom];
    Flat              := True;
    Hint              := '�t�H���_�I��';
    ShowHint          := True;
    Layout            := blGlyphTop;
    Visible           := doFolderBtn in FOptions;
    FolderBtn.OnClick := FolderBtnOnClick;
  end;

  //�i���ݕ\���p�{�^��
  FFindBtn := TSpeedButton.Create(FDialogForm);
  with FFindBtn do begin
    Parent           := FTopPanel;
    Height           := FTopPanel.Height;
    Width            := 24;
    Top              := 0;
    if FFolderBtn.Visible then begin
      Left := FFolderBtn.Left - 4 - Width;
    end else begin
      Left := FTopPanel.Width - Width - FMargin;
    end;
    Anchors          := [akRight, akBottom];
    Flat             := True;
    Hint             := '�i���ݕ\��';
    ShowHint         := True;
    Layout           := blGlyphTop;
    Visible          := doFindBtn in FOptions;
    FFindBtn.OnClick := FindBtnOnClick;
  end;
  FTopPanel.Visible := FFolderBtn.Visible or FFindBtn.Visible or FDisplayDirectory;

  //�f�B���N�g������\�����郉�x��
  FDirectoryLabel := TLabel.Create(FDialogForm);
  with FDirectoryLabel do begin
    Parent      := FTopPanel;
    AutoSize    := False;
    Alignment   := taLeftJustify;
    Layout      := tlCenter;
    Anchors     := [akLeft, akTop, akRight, akBottom];
    Font.Size   := FFontSize;
    Height      := FTopPanel.Height;
    Top         := 0;
    Left        := FMargin + 5;
    Width       := FTopPanel.Width - Left - FMargin - 15;
    if FFolderBtn.Visible then Width := Width - FFolderBtn.Width;
    if FFindBtn.Visible   then Width := Width - FFindBtn.Width;
  end;

  //�t�@�C�����ꗗ�\������ListView
  FListView := TplFileDialogListView.Create(FDialogForm);
  with FListView do begin
    Parent            := FListPanel;
    Align             := alClient;
    GridLines         := FDisplayGridLines;
    HideSelection     := False;
    ShowColumnHeaders := False;
    ViewStyle         := vsReport;
    PopupMenu         := FPopupMenu;
    FDialog           := Self;
    DoubleBuffered    := True;
    OwnerData         := True;
    RowSelect         := True;
    Font              := FFont;
    MultiSelect       := True;
    FDialog           := Self;
    MultiSelect       := False;
    OwnerDraw         := False;
    OnDataHint        := FileViewOnDataHint;
    OnData            := FileViewOnData;
    OnSelectItem      := LVOnSelectItem;
    OnAdvancedCustomDrawItem := FileViewOnAdvancedCustomDrawItem;
    Columns.Add;
  end;

  //�t�H���_�̎Q�ƃ_�C�A���O����
  FBrowseFolder := TplBrowseFolder.Create(FDialogForm);
  FBrowseFolder.RootSpecialDir      := sfNone;
  FBrowseFolder.RootDir             := FRootDir;
  FBrowseFolder.InitDir             := FDirectory;
  FBrowseFolder.OnSelectionChanged  := BrowseSelectionChanged;
  if FBrowseFolder.Title = '' then FBrowseFolder.Title := FBrowseTitle;

  FStateImgList := TImageList.Create(FDialogForm);
  with FStateImgList do begin
    Width       := 1;
    Height      := FListViewItemHeight;
    ShareImages := True;
  end;
  FListView.StateImages := FStateImgList;

  FFindBtn.Glyph.LoadFromResourceName(hInstance, 'plFileDialogFilterBmp');
  FFolderBtn.Glyph.LoadFromResourceName(hInstance, 'plFileDialogFolderBmp');

  //IME�̐ݒ�
  SetDlgImeMode(FImeMode);
end;

//=============================================================================
//  Font�v���p�e�B
//=============================================================================
procedure TplCustomFileDialog.SetFont(const Value: TFont);
begin
  if Value = nil then begin
    FFont.Assign(Value);
  end;
end;

//=============================================================================
//  ���s(Execute)���\�b�h
//=============================================================================
function TplCustomFileDialog.Execute: Boolean;
var
  ARect : TRect;
begin
  if FDirectory            = '' then FDirectory            := ExtractFileDir(Application.ExeName);
  if FBrowseFolder.RootDir = '' then FBrowseFolder.RootDir := FRootDir;
  if FBrowseFolder.InitDir = '' then FBrowseFolder.InitDir := FDirectory;

  //�_�C�A���O�t�H�[���̕\���ʒu�ƃT�C�Y�̍Čv�Z
  SystemParametersInfo(SPI_GETWORKAREA, 0, @ARect, 0);

  if (FFormLeft = 0) and (FFormTop = 0) then begin
    FFormLeft := ((ARect.Right + ARect.Left) - FFormWidth) div 2;
    FFormTop  := ((ARect.Bottom + ARect.Top) - FFormHeight) div 2;
  end;
  FDialogForm.Left   := FFormLeft;
  FDialogForm.Top    := FFormTop;
  FDialogForm.Width  := FFormWidth;
  FDialogForm.Height := FFormHeight;

  FListView.GridLines := FDisplayGridLines;

  FFileList := TplFileDialogDataList.Create;
  try
    //���[�_���\��
    FDialogForm.ShowModal;
    Result := FModalResult = mrOK;
  finally
    FListView.Items.Clear;
    FreeAndNil(FFileList);
  end;

  FFormLeft   := FDialogForm.Left;
  FFormTop    := FDialogForm.Top;
  FFormWidth  := FDialogForm.Width;
  FFormHeight := FDialogForm.Height;
end;

//=============================================================================
//  �t�H�[����\�����鎞�̃��\�b�h
//  �V�X�e���̃C���[�W���X�g���擾���ăC���[�W�n���h�����擾
//  �C���[�W���X�g�̍쐬�́CFDisplayIcon�̒l�Ɋ֌W����̂�Execute���s��Ɏ��s
//  ����邱�̃��\�b�h�ōs��
//=============================================================================
procedure TplCustomFileDialog.DoShow;
var
  SHFileInfo : TSHFileInfo ;
begin
  if FDisplayIcon then begin
    //�V�X�e���̃C���[�W���X�g�̃n���h�����擾
    if FImgListHandle = 0 then begin
      FImgListHandle := SHGetFileInfo('',
                        0,
                        SHFileInfo,
                        SizeOf(SHFileInfo),
                        SHGFI_SYSICONINDEX or
                        SHGFI_ICON or
                        SHGFI_SMALLICON);
      ListView_SetImageList(FListView.Handle, FImgListHandle, LVSIL_SMALL);
    end;
  end;
  SetFilesListToItems(FDirectory, FFindText, '', FFileExt, True);

  if Assigned(FOnShow) then FOnShow(Self);
end;

//=============================================================================
//  �_�C�A���O�t�H�[��DialogForm�̃T�u�N���X
//=============================================================================
procedure TplCustomFileDialog.DialogFormSubClassProc(var Message: TMessage);
var
  ScrH      : Integer;
  AWnd      : HWND;
  MsgWnd    : HWND;
  InputWnd  : HWND;
  ARect     : TRect;
  AWidth    : Integer;
  AHeight   : Integer;
  AHitTest  : Integer;
begin
  DialogFormOriginalProc(Message);

  if Message.Msg = WM_SHOWWINDOW then begin
    DoShow;
  end else
  if Message.Msg = WM_SIZE then begin
    ScrH := GetSystemMetrics(SM_CYVSCROLL);
    FListView.Column[0].Width := FListView.ClientWidth - FItemRightMargin;
    FListView.Scroll(0, ScrH);
    DisplayDirectoryText(FDirectoryLabelText);
  end else
  if Message.Msg = WM_ACTIVATE then begin
    if Message.WParam = WA_INACTIVE then begin
      AWnd     := Message.LParam;
      MsgWnd   := FindWindow('TMessageForm', nil);
      InputWnd := FindWindow('TForm', nil);
      if (MsgWnd = AWnd) or (InputWnd = AWnd) then begin
        Application.ProcessMessages;
        GetWindowRect(AWnd, ARect);
        AWidth  := ARect.Right - ARect.Left;
        AHeight := ARect.Bottom - ARect.Top;
        Windows.SetWindowPos(AWnd,
                             0,
                             FDialogForm.Left + (FDialogForm.Width - AWidth) div 2,
                             FDialogForm.Top  + (FDialogForm.Height - AHeight) div 2,
                             0,
                             0,
                             SWP_NOZORDER	or SWP_NOSIZE);
        Windows.SetFocus(AWnd);
        if InputWnd = AWnd then begin
          SetImeMode(AWnd, FImeMode);
        end;
      end;
    end;
  end else
  if Message.Msg = WM_NCLBUTTONDOWN then begin
    AHitTest := Message.WParam;
    if AHitTest = HTCLOSE then begin
      FModalResult := mrCancel;
      Message.Result := 0;
    end;
  end;
end;

//=============================================================================
//  �t�H�[������鎞�̏���
//
//  [�ۑ�]�_�C�A���O����鎞�C�v���p�e�BFileExt���󕶎��܂���*�̕����������
//  ���͌��ʂ�FilePath�v���p�e�B�Ɋg���q�͕t���Ȃ�
//  �󕶎��̎���[Enter]�ł͕��Ȃ�
//=============================================================================
procedure TplCustomFileDialog.DialogOnCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  AIndex    : Integer;
  AFullPath : String;
begin
  if Self is TplOpenDialog then begin
    if (FListView.SelCount = 1) then begin
      AIndex    := FListView.Selected.Index;
      FFilePath := FFileList[AIndex].FFileFullPath;
      FFileName := ChangeFileExt(ExtractFileName(FFilePath), '');
    end;
  end else begin
    if Pos('*', FFileExt) > 0 then begin
      AFullPath := FDirectory + Trim(FFileEdit.Text);
    end else begin
      AFullPath := FDirectory + Trim(FFileEdit.Text) + FFileExt;
    end;
    FFilePath := AFullPath;
    FFileName := ChangeFileExt(ExtractFileName(FFilePath), '');
  end;

  if Assigned(FOnBeforeClose) then begin
    FOnBeforeClose(Self, FFilePath, CanClose);
  end;

  if CanClose then FImgListHandle := 0;
end;

//=============================================================================
//  [�t�@�C���I��][�ۑ�]�{�^���N���b�N
//  ���[�_���t�H�[���Ȃ̂�ModalResult��mrOK��������ƃt�H�[��������
//  Close���\�b�h�͕s�v
//=============================================================================
procedure TplCustomFileDialog.OKBtnOnClick(Sender: TObject);
begin
  FModalResult := mrOK;
end;

//=============================================================================
//  [�L�����Z��]�{�^���N���b�N
//  ���[�_���t�H�[���Ȃ̂�ModalResult��mrCancel��������ƃt�H�[��������
//  Close���\�b�h�͕s�v
//=============================================================================
procedure TplCustomFileDialog.CancelBtnOnClick(Sender: TObject);
begin
  FModalResult := mrCancel;
end;

//=============================================================================
//  �t�@�C�������͗��ɕ����񂪂����[�ۑ�]�{�^����L���ɂ���
//=============================================================================
procedure TplCustomFileDialog.FileEditOnChange(Sender: TObject);
begin
  FOKBtn.Enabled := Length(FileEdit.Text) > 0;
end;

//=============================================================================
//  �i���ݕ\���{�^���N���b�N
//  �i���ނ̂͌��̃v���p�e�BFindText�̏����ŕ\�������t�@�C��
//  ����ōi�荞��ŕ\���������X�g����X�ɍi���ݕ\���͂ł��Ȃ�
//=============================================================================
procedure TplCustomFileDialog.FindBtnOnClick(Sender: TObject);
var
  Flag : Boolean;
begin
  Flag := True;
  if Assigned(FOnFindBtnClick) then begin
    FOnFindBtnClick(Self, FDirectory, Flag, FAndFindText);
  end;

  if Flag then begin
    if InputQuery('�t�@�C����������v����', '����������', FAndFindText) then begin
      SetFilesListToItems(FDirectory, FFindText, FAndFindText, FFileExt, True);

      if (FAndFindText <> '') then begin
        FDialogForm.Caption := FDialogForm.Caption + '   [' + FAndFindText + '] ���܂ރt�@�C�����X�g';
      end;
    end;
  end;
end;

//=============================================================================
//  �t�H���_�I���_�C�A���O�{�^���N���b�N
//  OnFolderBtnClick�C�x���g��Flag��False�ɂ���ƃt�H���_�Q�ƃ_�C�A���O��\��
//  ���Ȃ��D�Ǝ��̃R�[�h�����s����ꍇ���Ɏg�p�ł���
//=============================================================================
procedure TplCustomFileDialog.FolderBtnOnClick(Sender: TObject);
var
  Flag      : Boolean;
  AIndex    : Integer;
  TopIndex  : Integer;
  OriginDir : String;
begin
  Flag := True;

  //�_�C�A���O�̈ʒu�ƃT�C�Y���L���ł���ΐݒ�
  if FBrowseFolder.FFormLeft = 0 then begin
    FBrowseFolder.FFormLeft := FDialogForm.Left + FDialogForm.Width - FBrowseFolder.FormWidthDefault;
  end;
  if FBrowseFolder.FFormTop = 0 then begin
    FBrowseFolder.FFormTop := FDialogForm.Top  + 40;
  end;

  //�{�^���N���b�N�C�x���g
  //�t�H���_�̎Q�ƃ_�C�A���O�͐����ς�
  //�t�@�C�����X�g�̃t�H�[������������(���\��)
  if Assigned(FOnFolderBtnClick) then begin
    FOnFolderBtnClick(Self, FDirectory, Flag);
  end;

  if Flag then begin
    OriginDir := FDirectory;

    TopIndex := -1;
    AIndex   := -1;
    if FListView.Items.Count > 0 then begin
      AIndex   := FListView.ItemIndex;
      TopIndex := FListView.TopItem.Index;
    end;

    if SysUtils.DirectoryExists(FDirectory) then begin
      FBrowseFolder.FInitDir := FDirectory;
    end else begin
      FBrowseFolder.FInitDir := FRootDir;
    end;
    FBrowseFolder.Title    := FBrowseTitle;
    FBrowseFolder.Caption  := FBrowseCaption;
    if FBrowseFolder.Execute then begin
      FDirectory := FBrowseFolder.FDirectory;
    end else begin
      //[�L�����Z��]�őI�������������\�������ɖ߂�
      FDirectory := OriginDir;
      SetFilesListToItems(FDirectory, FFindText, '', FFileExt, False);
      FListView.Selected := nil;

      //�X�N���[��
      if TopIndex >= 0 then begin
        FListView.Items[TopIndex].Selected := True;
        FListView.Items[TopIndex].MakeVisible(False);
        FListView.Scroll(0, FListView.Selected.Top - FListView.TopItem.Top);

        //���̑I�����ڂ�I����Ԃ�
        if AIndex >= 0 then begin
          FListView.Selected := nil;
          FListView.Items[AIndex].Selected := True;
          FListView.Items[AIndex].Focused  := True;
        end;
      end;
    end;
  end;
  FListView.Column[0].Width := FListView.ClientWidth - FItemRightMargin;
  FListView.Invalidate;
end;

//=============================================================================
//  �t�H���_�̎Q�ƃ_�C�A���O�őI���t�H���_��ύX�����烊�X�g���X�V
//  �t�H���_�̎Q�ƃ_�C�A���O����Ȃ��Ă��C���A���^�C���łǂ�ȃt�@�C��������
//  �����m�F
//  �i���݌���������͉��������
//=============================================================================
procedure TplCustomFileDialog.BrowseSelectionChanged(Sender: TObject; Wnd: HWND;
  Directory: String; var StatusText: String; var OKBtnEnabled: Boolean);
begin
  SetFilesListToItems(Directory, FFindText, '', FFileExt, False);
end;

//=============================================================================
//  Popup���j���[��[�t�@�C�����ύX]��[�t�@�C���폜]�̕\������
//=============================================================================
procedure TplCustomFileDialog.PopUpMenuOnPopup(Sender: TObject);
var
  i : Integer;
begin
  if (FListView.SelCount = 0) then begin
    for i := 0 to FPopupMenu.Items.Count - 1 do FPopupMenu.Items[i].Visible := False;
  end else
  if (FListView.SelCount <> 1) then begin
    FPopupMenu.Items[0].Enabled := False;
  end else begin
    for i := 0 to FPopupMenu.Items.Count - 1 do begin
      FPopupMenu.Items[i].Visible := True;
      FPopupMenu.Items[i].Enabled := True;
    end;
  end;
end;

//=============================================================================
//  �t�@�C�����̕ύX�J�n
//  �Ǐo����p�t�@�C���͕ύX�ł��Ȃ�(�s���ȕ���������Ƃ̕\��)
//  �����[�U�쐬�̃t�@�C�����ύX�ł��Ȃ�(���L�t�H���_���Őݒ�ɂ���Ă͉\)
//=============================================================================
procedure TplCustomFileDialog.PopUpMenuFileRenameOnClick(Sender: TObject);
var
  AIndex        : Integer;
  AAction       : Boolean;
  AFileFullPath : String;
begin
  AAction := True;

  if (FListView.SelCount = 1) then begin
    AIndex        := FListView.Selected.Index;
    AFileFullPath := FFileList[AIndex].FFileFullPath;

    //���O�ύX�{�^�����N���b�N�������̃C�x���g
    if Assigned(FOnReNameMenuClick) then begin
      FOnReNameMenuClick(Self, AFileFullPath, AAction);
    end;

    if AAction then begin
      AIndex := FListView.Selected.Index;
      FListView.Items[AIndex].Selected := True;
      FListView.Items[AIndex].Focused;
      FListView.Items[AIndex].EditCaption;
    end;
  end;
end;

//=============================================================================
//  �|�b�v�A�b�v���j���[[�t�@�C���폜]
//  �I�𒆂̃t�@�C�����폜
//  �Ǐo����p�t�@�C���͍폜�ł��Ȃ�
//  �����[�U�쐬�̃t�@�C�����폜�ł��Ȃ�(���L�t�H���_���Őݒ�ɂ���Ă͉\)
//
//  �폜�m�F�̃_�C�A���O�͕\�����Ȃ�
//  �K�v�ł����OnBeforeDelete���g�p����
//
//  ���̃R���|�ł͍폜��1�����ł��Ȃ��悤�ɂ��Ă���
//=============================================================================
procedure TplCustomFileDialog.PopUpMenuFileDeleteOnClick(Sender: TObject);
var
  AIndex        : Integer;
  AAction       : Boolean;
  DeletedFlag   : Boolean;
  AFileFullPath : String;
begin
  //�ҏW���̓|�b�v�A�b�v��\���Ƃ��Ă���̂ł��̃R���|�ł͕s�v�ł��邪�O�̂���
  FListView.Selected.CancelEdit;

  //�I���t�@�C����1�����̎���������
  if (FListView.SelCount <> 1) then exit;

  AIndex        := FListView.Selected.Index;
  AFileFullPath := FFileList[AIndex].FFileFullPath;
  AAction       := True;
  DeletedFlag   := True;

  //�t�@�C���폜�O�̃C�x���g
  if Assigned(FOnBeforeDelete) then begin
    FOnBeforeDelete(Self, AFileFullPath, AAction);
  end;

  if AAction then begin
    if DeleteFile(AFileFullPath) then begin
      FFileList.Delete(AIndex);
      FListView.Items.Count := FFileList.Count;
      FListView.Refresh;

      if FFileList.Count > 0 then begin
        ListView.Items[AIndex].Selected := True;
        ListView.Items[AIndex].Focused  := True;
      end;
    end else begin
      DeletedFlag := False;
    end;
    FOKBtn.Enabled := FFileList.Count <> 0;

    //�t�@�C���폜��̃C�x���g
    //�폜�m�F�p�ɁC�폜�����t�@�C�����������ɓn��
    if Assigned(FOnAfterDelete) then begin
      FOnAfterDelete(Self, AFileFullPath, DeletedFlag);
    end else begin
      //�폜�ł��Ȃ������ꍇ
      if not DeletedFlag then begin
        MessageDlgPos(ErrorDelete, mtInformation, [mbOK], 0, FDialogForm.Left, FDialogForm.Top);
      end;
    end;
  end;
end;

//=============================================================================
//  ���{����̓��[�h�̐ݒ� ImeMode�v���p�e�B
//  �����ł̓t�@�C��������TEid�̂ݐݒ�
//  ListView��Item��ҏW(�t�@�C�����ύX)�ł͕ҏW���[�h�ɓ�������ݒ�
//  �i���݌����̓��̓_�C�A���O�����̐ݒ�ɂ�������
//=============================================================================
procedure TplCustomFileDialog.SetDlgImeMode(const Value: TImeMode);
begin
  FImeMode := Value;
  if FDialogForm <> nil then begin
    SetImeMode(FFileEdit.Handle, FImeMode);
  end;
end;

//=============================================================================
//  �t�H���_��(�f�B���N�g����)��\��
//=============================================================================
procedure TplCustomFileDialog.DisplayDirectoryText(Text : String);
var
  AWidth : Integer;
begin
  if FDisplayDirectory = False then begin
    FDirectoryLabel.Caption := '';
  end else begin
    FDirectoryLabel.Left := FMargin + 5;

    AWidth := FTopPanel.Width - FDirectoryLabel.Left - FMargin - 15;
    if FFolderBtn.Visible then AWidth := AWidth - FFolderBtn.Width;
    if FFindBtn.Visible   then AWidth := AWidth - FFindBtn.Width;
    FDirectoryLabel.Width := AWidth;
    if Text = FDirectory then begin
      FDirectoryLabel.Caption := MinimizeName(Text, FDirectoryLabel.Canvas, AWidth);
    end else begin
      FDirectoryLabel.Caption := Text;
    end;
  end;
end;

//=============================================================================
//  �t�@�C�����X�g�̍X�V���\�b�h(���J���\�b�h)
//
//  ���݂�Directory��FindText�v���p�e�B�̒l�ōX�V
//  �i���ݕ\���Őݒ肵���l�͖���
//  ���̃��\�b�h�̌ďo�O�ɂ����̃v���p�e�B��ύX���Ă����ƁC���̒l���g�p��
//  �čĕ\��
//=============================================================================
procedure TplCustomFileDialog.GetFilesList;
begin
  SetFilesListToItems(FDirectory, FFindText, FAndFindText, FFileExt, False);
end;

//-----------------------------------------------------------------------------
//  FFileList(TList)�p�̃\�[�g�̃R�[���o�b�N�֐�
//  Item1>Item2�̎�<0 Item10 Item1=Item2�̎�0��Ԃ��Ə���
//  �I�u�W�F�N�g�������Ȃ�TList�̏����\�[�g��Sort���\�b�h�����s����΂悢
//  �~����I�u�W�F�N�g�Ń\�[�g����ꍇ�̓R�[���o�b�N�֐����g�p����K�v������
//-----------------------------------------------------------------------------
function SortFFileList(Item1, Item2: Pointer): Integer;
var
  Index1 : Integer;
  Index2 : Integer;
  Str1   : String;
  Str2   : String;
  Dir1   : Boolean;
  Dir2   : Boolean;
begin
  Index1 := FFileList.IndexOf(Item1);
  Index2 := FFileList.IndexOf(Item2);

  Result := 0;

  Dir1 := (FFileList[Index1].FFileAttrib and faDirectory) <> 0;
  Dir2 := (FFileList[Index2].FFileAttrib and faDirectory) <> 0;
  Str1 := FFileList[Index1].FFileName;
  Str2 := FFileList[Index2].FFileName;

  //�ǂ�����t�H���_���ǂ�����t�H���_�łȂ��ꍇ
  if (Dir1 and Dir2) or not(Dir1 or Dir2) then begin
    Result := CompareText(Str1, Str2);
  end else
  //Item1�ɊY������̂��t�H���_�̏ꍇ
  if Dir1 then begin
    Result := -1;
  end else
  //Item2�ɊY������̂��t�H���_�̏ꍇ
  if Dir2 then begin
    Result := 1;
  end;
end;

//=============================================================================
//  �t�@�C�����X�g�̍쐬
//  ���݂�Directory,FindText�v���p�e�B�ƍi���݌����Őݒ肵���l���g�p����
//
//  ADir        : �����Ώۃf�B���N�g��(�t�H���_)
//  AFindText   : �t�@�C���̌���������
//  AAddFinText : �i���݂Őݒ肵��������
//  AFileExt    : �g���q(.txt�̂悤��.��t�����Ďw��)
//=============================================================================
procedure TplCustomFileDialog.SetFilesListToItems(ADir, AFindText,
  AAddFindText, AFileExt: String; Select: Boolean);
var
  SearchRec  : TSearchRec;
  AFullPath  : String;
  AFileName  : String;
  AExt       : String;
  ACount     : Integer;
  AFindStr   : String;
  FItem      : TplFileDialogDataListItem;
  Attrib     : Integer;
  AttribFlag : Cardinal;
  AText      : String;
begin
  LockWindowUpdate(FDialogForm.Handle);
  FListView.Items.Clear;
  FFileList.Clear;

  if ADir <> '' then begin

    //����������
    if (Pos('*', AFileExt) > 0) or (AFileExt = '') then AFileExt := '.*';
    if AFindText = '' then begin
      AFindText := '*';
    end else begin
      if Pos('*', AFindText) = 0 then AFindText := '*' + AFindText + '*';
    end;
    AFindStr := IncludeTrailingPathDelimiter(ADir) + AFindText + AFileExt;


    AttribFlag := faHidden or faSysFile or faDirectory;
    if FindFirst(AFindStr, faAnyFile, SearchRec) = 0 then begin
      repeat
        //OS�ɂ����SearchRec.Name�̓t���p�X�Ɩ��O�����̂��Ƃ�����
        AFullPath := IncludeTrailingPathDelimiter(ADir) + ExtractFileName(SearchRec.Name);
        Attrib    := SearchRec.Attr;
        AFileName := ChangeFileExt(ExtractFileName(AFullPath), '');
        AExt      := UpperCase(ExtractFileExt(AFullPath));

        if (AExt = UpperCase(AFileExt)) or (Pos('*', AFileExt) > 0) then begin
          if (AAddFindText = '') or
             (Pos(UpperCase(AAddFindText), UpperCase(AFileName)) > 0) then begin
            if AExt <> '.LNK' then begin
              if ((Attrib and AttribFlag) = 0) then begin
                FItem := TplFileDialogDataListItem.Create;
                FItem.FIconIndex    := -1;
                FItem.FFileFullPath := AFullPath;
                FItem.FFileName     := AFileName;
                FItem.FFileAttrib   := Attrib;
                FFileList.Add(FItem);
              end;
            end;
          end;
          Application.ProcessMessages;
        end;
      until FindNext(SearchRec) <> 0;

      FindClose(SearchRec);
    end;
  end;


  ACount := FFileList.Count;
  if ACount > 0 then FFileList.Sort(Addr(SortFFileList));
  FListView.Items.Count := ACount;

  FListView.Column[0].Width := FListView.ClientWidth;
  if Self is TplOpenDialog then begin
    if ACount > 0 then begin
      if FListView.Enabled then FListView.SetFocus;

      if Select then begin
        FListView.Items[ACount - 1].Selected := True;
        FListView.Items[ACount - 1].Focused  := True;
        FListView.Items[ACount - 1].MakeVisible(True);
      end;
    end else begin
      FOKBtn.Enabled := False;
    end;
  end else begin
    if ACount > 0 then begin
      if Select then begin
        FListView.Items[ACount - 1].MakeVisible(True);
      end;
    end;
    FFileEdit.SetFocus;
    FOKBtn.Enabled := (FFileEdit.Text <> '');
  end;

  FDialogForm.Caption := FTitle;
  FDirectoryLabelText := ADir;
  if Assigned(FOnFileListed) then begin
    AText := '';
    FOnFileListed(Self, ADir, ACount, FFileList, AText);
    if AText <> '' then FDirectoryLabelText := AText;
  end;
  DisplayDirectoryText(FDirectoryLabelText);
  LockWindowUpdate(0);
end;

//-----------------------------------------------------------------------------
//
//
//  [�t�@�C���I��]�_�C�A���O�N���X
//
//
//-----------------------------------------------------------------------------

{ TplOpenDialog }

//=============================================================================
//  [�t�@�C���I��]�_�C�A���O��Create����
//=============================================================================
constructor TplOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  FTitle := '�t�@�C�����J��';
end;

//=============================================================================
//  [�t�@�C���I��]�_�C�A���O�̎��s���\�b�h
//  OnCreate�ł͂܂��{�^���ނ̃R���g���[���͐�������Ă��Ȃ��̂ł����Őݒ�
//=============================================================================
function TplOpenDialog.Execute: Boolean;
begin
  FOKBtn.Caption    := '�J��';
  FOKBtn.Enabled    := False;
  FFileEdit.Visible := False;

  Result := inherited Execute;
end;

//-----------------------------------------------------------------------------
//
//
//  [�ۑ�]�_�C�A���O�N���X
//
//
//-----------------------------------------------------------------------------


{ TplSaveDialog }

//=============================================================================
//  [�ۑ�]�_�C�A���O��Create����
//=============================================================================
constructor TplSaveDialog.Create(AOwner: TComponent);
begin
  inherited;
  FTitle := '���O��t���ĕۑ�';
end;

//=============================================================================
//  [�ۑ�]�_�C�A���O�̎��s���\�b�h
//  OnCreate�ł͂܂��{�^���ނ̃R���g���[���͐�������Ă��Ȃ��̂ł����Őݒ�
//
//  FileExt���󕶎������ꍇ�͎��o�����t�@�C���Ɋg���q�͕t���Ȃ�
//  FileExt��*���܂܂��ꍇ�����ʂ̃t�@�C�����Ɋg���q�͕t���Ȃ�
//=============================================================================
function TplSaveDialog.Execute: Boolean;
begin
  FOKBtn.Caption    := '�ۑ�';
  FOKBtn.Enabled    := False;
  FFileEdit.Visible := True;
  FFileEdit.Text    := ChangeFileExt(FFileName, '');

  Result := inherited Execute;
end;

//-----------------------------------------------------------------------------
//
//
//  �t�@�C���ꗗ�\���p��ListView�֌W
//
//
//-----------------------------------------------------------------------------

{ TplFileDialogDataList }

//-----------------------------------------------------------------------------
//  �t�@�C�������i�[����TplFileDialogDataList�̊֐��ƃ��\�b�h��
//  TList�̂����̊֐��C���\�b�h�̈�����ߒl��Pointer�ł��邪�C�����ł�
//  TplFileDialogDataListItem�ɃL���X�g���邽�߂ɍĒ�`�@�@
//  Clear���\�b�h��TplFileDialogDataList�̃I�u�W�F�N�g������邽�ߍĒ�`
//-----------------------------------------------------------------------------
destructor TplFileDialogDataList.Destroy;
var
  i : Integer;
begin
  for i := 0 to Count - 1 do Items[i].Free;
  inherited;
end;
//-----------------------------------------------------------------------------
procedure TplFileDialogDataList.Clear;
begin
  inherited Clear;
end;

//-----------------------------------------------------------------------------
procedure TplFileDialogDataList.Delete(Index: Integer);
begin
  Remove(Items[Index]);
end;

//-----------------------------------------------------------------------------
procedure TplFileDialogDataList.Put(Index: Integer; Item: TplFileDialogDataListItem);
begin
  inherited Items[Index] := Item;
end;

//-----------------------------------------------------------------------------
function TplFileDialogDataList.Get(Index: Integer): TplFileDialogDataListItem;
begin
  Result := TplFileDialogDataListItem(inherited Items[Index]);
end;

//-----------------------------------------------------------------------------
function TplFileDialogDataList.Add(Item: TplFileDialogDataListItem): Integer;
begin
  Result := inherited Add(Item);
end;

//-----------------------------------------------------------------------------
function TplFileDialogDataList.IndexOf(Item: TplFileDialogDataListItem): Integer;
begin
  Result := inherited IndexOf(Item);
end;

//-----------------------------------------------------------------------------
function TplFileDialogDataList.Remove(Item: TplFileDialogDataListItem): Integer;
begin
  Result := inherited Remove(Item);
  Item.Free;
end;


//-----------------------------------------------------------------------------
//  TListItem��WndProc�̃T�u�N���X�֐�
//  CanEdit�Ŏg�p���Ă��邾��
//  �ҏW���̃R���e�L�X�g���j���[�͔�\���Ƃ���
//  �����ɂ��Ă�[Ctrl]+[C],[Ctrl]+[V]���͎g�p�\
//-----------------------------------------------------------------------------
function ItemEditorWndProc(AWnd: HWND; uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;
begin
  //���b�Z�[�W��WM_CONTEXTMENU�Ȃ珈�����o�C�p�X
  if uMsg = WM_CONTEXTMENU then begin
    Result := 1;
  end else begin
    if uMsg = WM_DESTROY then begin
      //���Ȋ������͂����
      SetImeMode(AWnd,imClose);
    end;
    Result := CallWindowProc(OriginItemWndProc, AWnd, uMsg, wParam, lParam);
  end;
end;

{ TplFileDialogListView }

//=============================================================================
//  ���z���X�g�r���[����
//=============================================================================
constructor TplFileDialogListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

//=============================================================================
//  OnDataHint(OnData�����O��1�񂾂�����)�C�x���g����
//  OnDataHint�͕\����(StartIndex�`EndIndex)�ɊԂɔ�������
//  �V�X�e���̃C���[�W���X�g����t�@�C���A�C�R���̃C���[�W�C���f�b�N�X���擾
//  ���̃C�x���g��ListView1.OwnerData:=True;�łȂ��Ƌ@�\���Ȃ�
//=============================================================================
procedure TplFileDialogListView.FileViewOnDataHint(Sender: TObject; StartIndex,
  EndIndex: Integer);
var
  FullPath   : String;
  SHFileInfo : TSHFileInfo;
  i          : Integer;
begin
  if (StartIndex > FFileList.Count) or (EndIndex > FFileList.Count) then Exit;

  if FDialog.FDisplayIcon then begin
    for i := StartIndex to EndIndex do begin
      if FFileList[i].FIconIndex < 0 then begin
        FullPath := FFileList[i].FFileFullPath;
        SHGetFileInfo(PChar(FullPath),
                      0,
                      SHFileInfo,
                      SizeOf(SHFileInfo),
                      SHGFI_SMALLICON or
                      SHGFI_ICON or
                      SHGFI_SYSICONINDEX);
        FFileList[i].FIconIndex := SHFileInfo.iIcon;
      end;
    end;
  end;
end;

//=============================================================================
//  ListView��OnData�C�x���g
//  ListView�̊eItem�̕`�悪�K�v�ƂȂ����ꍇ�ɔ���
//  ListView��Item�ɒl���Z�b�g����
//  ���̃C�x���g��ListView1.OwnerData:=True;�łȂ��Ƌ@�\���Ȃ�
//=============================================================================
procedure TplFileDialogListView.FileViewOnData(Sender: TObject;
  Item: TListItem);
begin
  if Item.Index > FFileList.Count then exit;

  Item.Caption := FFileList.Items[Item.Index].FFileName;
  if FDialog.FDisplayIcon then begin
    Item.ImageIndex := FFileList.Items[Item.Index].FIconIndex;
  end;
end;

//=============================================================================
//  OnAdvancedCustomDrawItem�C�x���g�p�̃��\�b�h
//  Vista�ȍ~�ł�ListView�����Ȃ�f�U�C�����悭�Ȃ����̂ŕK�v���͂��܂�Ȃ���
//  ���m��Ȃ�������
//=============================================================================
procedure TplFileDialogListView.FileViewOnAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if Assigned(FDialog.FOnAdvancedCustomDrawItem) then begin
    FDialog.FOnAdvancedCustomDrawItem(TplFileDialogListView(Sender), Item, State, Stage,
                              DefaultDraw, FDialog.FImgListHandle, FFileList);
  end;
end;

//=============================================================================
//  ���X�g�̃t�@�C�������N���b�N�܂��͑I�𓮍���s������
//  �ۑ��_�C�A���O�̏ꍇ��TEdit�Ƀt�@�C������\��
//=============================================================================
procedure TplFileDialogListView.LVOnSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
var
  AIndex : Integer;
begin
  if (SelCount = 1) then begin
    AIndex := Item.Index;
    FDialog.FOKBtn.Enabled := True;

    if FDialog.FFileEdit.Visible then begin
      FDialog.FFileEdit.Text := FFileList[AIndex].FFileName;
    end;
  end else begin
    //MultiSelect := False�ɂ��Ă���̂Ŏ��ۂɂ͈ȉ��͎��s���Ȃ�(�����̊g���p)
    if (FDialog is TplSaveDialog) and (FDialog.FFileEdit.Text <> '') then begin
      FDialog.FOKBtn.Enabled := True;
    end else begin
      FDialog.FOKBtn.Enabled := False;
    end;
  end;
end;

//=============================================================================
//  OnEditing(Item��Text�̕ҏW�J�n)�C�x���g�p���\�b�h
//  Item�̃C���v���[�X�G�f�B�^�̉E�N���b�N�̃R���e�L�X�g���j���[���\���ɂ���
//  ���߂�Item��WndProc�̃T�u�N���X�֐���ݒ�
//=============================================================================
function TplFileDialogListView.CanEdit(Item: TListItem): Boolean;
var
  EditorHandle : THandle;
begin
  Result := inherited CanEdit(Item);

  if Result then begin
    //�C���v���[�X�G�f�B�^�̃n���h�����擾
    //�ҏW���ł����>0�ƂȂ�
    EditorHandle := ListView_GetEditControl(Handle);
    if EditorHandle > 0 then begin
      SetImeMode(Self.Handle, FDialog.ImeMode);
      OriginItemWndProc := Pointer(SetWindowLong(EditorHandle,
                                   GWL_WNDPROC,
                                   LongInt(Addr(ItemEditorWndProc))));
    end;
  end;
end;

//=============================================================================
//  �t�@�C�����̕ҏW���I��([Enter]����)�����玩�����s����郁�\�b�h
//  �ύX���Ȃ������ꍇ�C���̃��\�b�h�͌Ă΂�Ȃ�
//=============================================================================
procedure TplFileDialogListView.Edit(const Item: TLVItem);
var
  AIndex      : Integer;
  AFullPath   : String;
  AFileName   : String;
  AExt        : String;
  NewFileName : String;
  NewFullPath : String;
  AAction     : Boolean;
  IsReName    : Boolean;
  IsSort      : Boolean;
  i           : Integer;
begin
  //���̃��\�b�h�����s
  inherited Edit(Item);

  AIndex := Selected.Index;

  AAction := True;
  IsSort  := False;

  //�ύX�O�̏��
  AFullPath := FFileList[AIndex].FFileFullPath;
  AFileName := ChangeFileExt(ExtractFileName(AFullPath), '');
  AExt      := ExtractFileExt(AFullPath);

  NewFileName := Item.pszText;
  NewFullPath := IncludeTrailingPathDelimiter(FDialog.FDirectory) + NewFileName + AExt;

  if Assigned(FDialog.FOnBeforeRename) then begin
    FDialog.FOnBeforeRename(TplCustomFileDialog(FDialog), AFullPath, NewFullPath, AAction);
  end;

  if AAction then begin
    //�����̃t�@�C�������݂���ꍇ�̓_�C�A���O��\��
    if FileExists(NewFullPath) then begin
      MessageDlgPos(ErrorReName1, mtInformation, [mbOK], 0, FDialog.DialogForm.Left, FDialog.DialogForm.Top);
    end else begin
      IsReName := ReNameFile(AFullPath, NewFullPath);

      if IsReName then begin
        FFileList[AIndex].FFileFullPath := NewFullPath;
        FFileList[AIndex].FFileName     := NewFileName;

        if Assigned(FDialog.FOnAfterRename) then begin
          FDialog.FOnAfterRename(TplCustomFileDialog(FDialog), AFullPath, NewFullPath, IsReName);
        end;

        //�p�r�ɂ���Ă̓\�[�g�������������ꍇ������
        //���z���X�g�r���[�Ȃ̂�FindCaption�͎g�p�ł��Ȃ�
        if IsSort then begin
          FFileList.Sort(Addr(SortFFileList));
          for i := 0 to FFileList.Count - 1 do begin
            if FFileList[i].FFileName = NewFileName then begin
              AIndex := i;
              break;
            end;
          end;
          if AIndex >= 0 then begin
            Items[AIndex].MakeVisible(True);
            ItemIndex := AIndex;
          end;
        end else begin
          //��������Ȃ��Ă��I����Ԃł��邪�C���z���X�g�r���[�Ȃ̂ŕ\���X�V�̂���
          Items[AIndex].Selected := True;
          Items[AIndex].Focused;
        end;
      end else begin
        //���O�ύX�Ɏ��s�����ꍇ�C�C�x���g����`���Ă���΃_�C�A���O�͕\�����Ȃ�
        if Assigned(FDialog.FOnAfterRename) then begin
          FDialog.FOnAfterRename(TplCustomFileDialog(FDialog), AFullPath, NewFullPath, IsReName);
        end else begin
          MessageDlgPos(ErrorReName2, mtInformation, [mbOK], 0, FDialog.DialogForm.Left, FDialog.DialogForm.Top);
        end;
        //��������Ȃ��Ă��I����Ԃł��邪�C���z���X�g�r���[�Ȃ̂ŕ\���X�V�̂���
        Items[AIndex].Selected := True;
        Items[AIndex].Focused;
      end;
    end;
  end;
end;

//=============================================================================
//  �}�E�X�_�u���N���b�N���̓���
//  [�t�@�C���I��][�ۑ�]�{�^���������Ɠ�������
//=============================================================================
procedure TplFileDialogListView.DblClick;
begin
  inherited;

  if Selected = nil then exit;

  TplCustomFileDialog(FDialog).FModalResult := mrOk;
  TForm(FDialog.DialogForm).Close;
end;

//=============================================================================
//  OnKeyDown�C�x���g�p���\�b�h
//  �I���A�C�e���̃t�H���_���[Enter]�̓_�u���N���b�N�Ɠ�������Ƃ���
//=============================================================================
procedure TplFileDialogListView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key,Shift);


 if not IsEditing then begin
   if Shift = [] then begin
     if Key = VK_RETURN then begin
       if Selected <> nil then begin
         DblClick;
       end;
     end else
     if Key = VK_ESCAPE then begin
       FDialog.FModalResult := mrCancel;
       FDialog.FDialogForm.Close;
     end else
     if Key = VK_F2 then begin
       if Selected <> nil then FDialog.PopUpMenuFileRenameOnClick(nil);
     end else
     if Key = VK_F3 then begin
       FDialog.FindBtnOnClick(nil);
     end else
     if Key = VK_DELETE then begin
       if Selected <> nil then FDialog.PopUpMenuFileDeleteOnClick(nil);
     end;
    end;
  end;
end;

//=============================================================================
//  ListView��CN_KEYDOWN���b�Z�[�W����
//  Result := 0 �ɂ��Ď��g�Ƀ��b�Z�[�W�𑗂�
//  �������Ȃ���ListView��OnKeyDown���b�Z�[�W���������Ȃ��̂ŁC���ڕҏW���ł�
//  �_�C�A���O�t�H�[��(DialogForm)��[Enter],[ESC]���L���ɂȂ��Ă��܂��C�_�C�A
//  ���O�����Ă��܂�
//=============================================================================
procedure TplFileDialogListView.CNKeydown(var Message: TMessage);
begin
  Message.Result := 0;
end;

end.
