//{$WARNINGS OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}
//=============================================================================
//  ファイル関連ダイアログコンポーネント
//  Ver. 9.04
//
//-----------------------------------------------------------------------------
//
//  【使用条件等】
//
//  当サイトのアプリケーション類，コンポーネント，コード類は，転載，改変，配布
//  (オリジナル，改変版)などは全て自由です．商用利用も自由です．連絡，使用の記
//  載義務もありません．ただしオリジナルそのものを商用とすることは禁止します．
//  なお，本サイトのプログラムやコードを使用したことによって生じた，いかなる障
//  害，損失に関しても作者は一切関与しないものとします．ご了承下さい．
//
//-----------------------------------------------------------------------------
//
//  動作仕様，履歴，動作確認環境等については添付のReadme.txtを参照
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
  //  フォルダ参照ダイアログ
  //---------------------------------------------------------------------------

  //特殊フォルダの列挙型の定義
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

  //フォルダ参照ダイアログで使用  指定可能なオブションの要素
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

  //指定可能なオプションを示す集合体
  TplBrowseOptions     = set of TplBrowseOption;
  TplBrowseEvent       = procedure(Sender: TObject) of object;
  TplBrowseChangeEvent = procedure(Sender: TObject; Wnd: HWND; Directory: string; var StatusText: string;
                                   var OKBtnEnabled: Boolean) of object;

  TplBrowseFolder = class(TComponent)
  private
    OSVersionValueMajor  : Integer; //OSのバージョン番号
    OSVersionValueMinor  : Integer; //OSのバージョン番号
    IsOSBeforeVista      : Boolean; //OSがVistaより前のバージョンか
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
  //  [ファイル選択]と[保存]ダイアログ関係
  //---------------------------------------------------------------------------

  //前方参照
  TplOpenDialog             = class;
  TplSaveDialog             = class;
  TplCustomFileDialog       = class;
  TplFileDialogDataList     = class;
  TplFileDialogDataListItem = class;
  TplFileDialogListView     = class;

  //ファイル選択と保存ダイアログのボタン表示の要素
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
  //  [ファイル選択]と[保存]ダイアログ
  //  ファイルリストで使用するリストクラス
  //  このリストクラスにファイルの名前等を記録し，仮想リストビューで表示
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
  //  [ファイル選択]と[保存]ダイアログ
  //  ファイルリストで使用するリストクラスの各Item
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
  //  [ファイル選択]と[保存]ダイアログの基本クラスのリストビュークラス
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
    { Public 宣言 }
    constructor Create(AOwner: TComponent); override;
  end;

  //---------------------------------------------------------------------------
  //  [ファイル選択]と[保存]ダイアログの基本クラス
  //---------------------------------------------------------------------------

  TplCustomFileDialog = class(TComponent)
  private
    { Private 宣言 }
    OSVersionValueMajor : Integer; //OSのバージョン番号
    OSVersionValueMinor : Integer; //OSのバージョン番号
    IsOSBeforeVista     : Boolean; //OSがVistaより前のバージョンか
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
    { Protected 宣言 }
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
    { Public 宣言 }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure GetFilesList;
  end;

  //---------------------------------------------------------------------------
  //  [ファイル選択]ダイアログ
  //---------------------------------------------------------------------------

  TplOpenDialog = class(TplCustomFileDialog)
  private
    { Private 宣言 }
  protected
    { Protected 宣言 }
  public
    { Public 宣言 }
    constructor Create(AOwner: TComponent); override;
    function Execute : Boolean;
    property Handle;
    property DialogForm;
    property BrowseFolder;
    property FileName;
    property FilePath;
    property ModalResult;
  published
    { Published 宣言 }
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
  //  [保存]ダイアログ
  //---------------------------------------------------------------------------

  TplSaveDialog = class(TplCustomFileDialog)
  private
    { Private 宣言 }
  protected
    { Protected 宣言 }
  public
    { Public 宣言 }
    constructor Create(AOwner: TComponent); override;
    function Execute : Boolean;
    property Handle;
    property DialogForm;
    property BrowseFolder;
    property FilePath;
    property ModalResult;
  published
    { Published 宣言 }
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
  //[ファイル選択][保存]ダイアログ用
  ErrorReName1 = '同名のファイルが既に存在します．';
  ErrorReName2 = '名前の変更に失敗しました．不正な文字があるか.変更の権限がない可能性があります．';
  ErrorDelete  = '削除できません．ファイルは読出し専用か削除の権限がありません．';


  //フォルダ参照ダイアログ用
  //ルートフォルダ・初期選択フォルダの各選択枝に対応する値のリスト
  //古いOSにはない定数があるので実値を格納

  CSIDL_Array : array [TplBFSpecialDir] of Integer=(
      $0000,    //  CSIDL_DESKTOP',            指定なし.RootDir,InitDirの指定に従う
      $0000,    //  CSIDL_DESKTOP',            指定なし.RootDir,InitDirの指定に従う
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

  //フォルダ参照ダイアログ用
  //オプション設定用の集合型
  //古いOSにはない定数があるので実値を格納

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
//  項目識別子からフォルダまたはファイルの表示名を求める
//  表示名とはエクスプローラに表示される文字列
//  Win32 APIのSHGetPathFromIDListでは特殊フォルダ等のGUIDのパス名は取得できな
//  いのでこの関数を使用する
//
//  第1引数  対象の項目識別子を取得する際に使用したシェルフォルダオブジェクト
//  第2引数  対象の項目識別子
//
//  Flag(DWORD)には以下の値を指定可能であるが，ここではSHGDN_NORMALの取得専用
//  表示名の種類で以下のいずれか
//  SHGDN_NORMAL      表示用(デフォルト)
//  SHGDN_INFOLDER    フォルダ内の表示名
//　SHGDN_FORPARSING  親フォルダのParseDisplayNameに渡す表示名(GUIDを含む)
//
//  ParseDisplayNameはフルパス名から項目識別子を求める関数でこの関数の逆機能
//
//  GetDisplayNameOfはファイルオブジェクトやサブフォルダの表示名をTStrRet構造体
//  で取得するシェルフォルダオブジェクトの関数
//  第1引数 TItemIDList構造体へのポインタ
//  第2引数 取得する表示名の種類
//  第3引数 表示名を格納したTStrRet構造体
//
//  TStrRec構造体
//  uType 文字列のフォーマットフラグ(以下のいずれか)
//  ・STRRET_CSTR    文字列はcStrに格納
//  ・STRRET_OFFSET  文字列は項目識別子の頭からuOffsetバイトの位置
//　・STRRET_WSTR    文字列はpOleStrの位置
//  pOleStr OLE文字列へのポインタ
//  pStr    Ansi文字列へのポインタ
//  uOffset 項目識別子のオフセット
//  cStr    Charバッファ
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
        //ポインタのオフセット
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
//  項目識別子がフォルダか下にフォルダをもっていればTrue
//  ルートディレクトリと初期選択ディレクトリが確実にフォルダであれば必要ない
//  あくまでも念のため
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
//  指定したディレクトリ(フォルダ)の項目識別子PItemIDListを取得
//
//  ディレクトリが文字列で与えられた場合はそちらを優先
//  Dir      : 通常の文字列でのディレクトリ名(ex. 'C:\Windows')
//  SpDir    : CSIDL値のディレクトリ名
//  ShFolder : フォルダのシェルオブジェクト
//             ここではディクストップのオブジェクトとする
//-----------------------------------------------------------------------------
function GetDirPItemIDList(Dir: String; SpDir: TplBFSpecialDir;
  ShFolder: IShellFolder): PItemIDList;
var
  Len   : Cardinal;
  Flags : Cardinal;
  hr    : HResult;
begin
  Result := nil;

  //通常のディレクトリ名をディスクトップを基準にした項目識別子に変換
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
    //CSIDL値を項目識別子に変換
    SHGetSpecialFolderLocation(Application.Handle, CSIDL_Array[SpDir], Result);
  end;
end;

//-----------------------------------------------------------------------------
//  フォルダーの選択ダイアログのコールバック関数
//  本コンポの以下のイベントを処理
//
//  OnShow            ダイアログの初期化が終了した時に発生
//                    表示位置とサイズはまだ未設定
//
//  OnSelectionChage  ダイアログでフォルダを選択した時
//                    選択したフォルダ名の取得が可能
//                    ダイアログ上部(Title用の下)に文字列を表示可能
//                    これはOptionsのbifStatusTextを有効にした場合のみ
//                    この動作はコールバック関数内でしか処理できない
//                    [OK]ボタンの有効無効が指定可能
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
  //このコールバック関数は常に0を返さなければいけない
  Result := 0;

  BF := (TObject(lpData) as TplBrowseFolder);

  StatusText := '';
  ADirectory := '';

  case uMsg of
  BFFM_INITIALIZED:
    begin
      //初期選択フォルダ名が空でなければ，それを選択状態にする
      //それにはダイアログウィンドウにBFFM_SETSELECTIONメッセージを送る
      if BF.FInitDirPItemID <> nil then begin
        SendMessage(hWindow, BFFM_SETSELECTION, Integer(False), Integer(BF.FInitDirPItemID));
      end;

      if BF.FHandle = 0 then BF.FHandle := hWindow;
      //OnShowイベント
      if Assigned(BF.FOnShow) then BF.OnShow(TplBrowseFolder(BF));
    end;
  BFFM_SELCHANGED:
    begin
      if BF.FHandle = 0 then BF.FHandle := hWindow;

      //選択しているフォルダの項目識別子をパス文字列に変換
      SHGetPathFromIDList(PItemIDList(lpParam), @ADirectory);

      //OnSelectionChangeイベントが定義してある場合
      if Assigned(BF.FOnSelectionChanged) then begin
        //[OK]ボタンの状態(無効有効)を調査
        WndOKBtn     := GetDlgItem(BF.Handle, 1);
        OKBtnEnabled := IsWindowEnabled(WndOKBtn);

        BF.FOnSelectionChanged(TplBrowseFolder(BF), hWindow, String(ADirectory), StatusText, OKBtnEnabled);
        //StatusTextの設定は新しいスタイルのダイアログでは無効
        //ShowWindow(WndOkBtn, SH_HIDE)は機能する
        SendMessage(hWindow, BFFM_SETSTATUSTEXT, 0, Integer(PChar(StatusText)));
        PostMessage(hWindow, BFFM_ENABLEOK, 0, Integer(OKBtnEnabled));
      end;
    end;
  end;
end;

//=============================================================================
//  フォルダーの選択ダイアログ
//  Create処理
//=============================================================================
constructor TplBrowseFolder.Create(AOwner: TComponent);
var
  OSInfo : TOSVERSIONINFO;
begin
  inherited Create(AOwner);

  //OSのバージョン値を取得しておく
  //ただしここではVista以降に対する判定なのでこれだけ
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
  FRootSpecialDir    := sfDesktop;              //ルートはデスクトップ
  FInitSpecialDir    := sfNone;                 //初期選択はInitDirプロパティの値
  FOptions           := [bifReturnOnlyFSDirs];  //ファイルフォルダのみ選択可能
end;

//=============================================================================
//  フォルダーの選択ダイアログ
//  ダイアログの高さ
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
//  フォルダーの選択ダイアログ
//  ダイアログの幅
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
//  SHBrowseForFolder関数でフォルダの参照ダイアログを表示
//  SHBrowseForFolderでは，フォルダの設定も取得も項目識別子を使用する
//
//  FInitDir(ダイアログを表示した時に選択状態にするフォルダ)がFRootDirの階層下
//  にあるかのチックは行っていない
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

  //デスクトップのシェルフォルダオブジェクトを取得
  if Failed (SHGetDesktopFolder(FDesktopSHFolder)) then begin
    FHandle := 0;
    Malloc  := nil;
    Result  := False;
    exit;
  end;

  FolderPItemID := nil;
  //ルートと表示するディレクトリの項目識別子を取得
  //FRootDir,FInitDirはこのコンポのpublishedなプロパティ
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

  //コールバック関数指定
  BrowseInfo.lpfn   := @plBrowseFolderProc;
  BrowseInfo.lParam := Integer(Self);

  //フォルダの選択ダイアログを表示
  OldErrorMode := 0;
  try
    //フロッピーディスクのI/Oエラー対策
    OldErrorMode  := SetErrorMode(SEM_FAILCRITICALERRORS);
    FolderPItemID := SHBrowseForFolder(BrowseInfo);
  except
    Result := False;
  end;
  FHandle            := 0;
  FDialogPositionSet := False;
  //フロッピーディスクのI/Oエラー対策解除
  SetErrorMode(OldErrorMode);

  //オーナのWindowProcを元に戻しておく
  OwnerControl.WindowProc := OwnerControlOriginalProc;

  //SHBrowseForFolder関数の戻り値(項目識別子)がnilでなければ各変数に
  //BrowseInfoのメンバーに割り当てた変数に値が格納される
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
//  フォルダの参照ダイアログのオーナーのサブクラス関数
//
//  フォルダの参照ダイアログが表示されたら表示位置とサイズを設定
//  フォルダの参照ダイアログが閉じる際表示位置とサイズを取得
//  FHandleはダイアログのハンドル．SHBrowseForFolderのコールバック関数内で取得
//
//  ダイアログ生成時はWM_Activateが何回も呼ばれるのでフラグとして
//  FDialogPositionSetを使用
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
//  フォルダの参照ダイアログの位置とサイズの変更
//
//  コールバック関数で設定する場合，サイズ可変の新しいスタイルのダイアログのサ
//  イズの初期値は常に同じ．初期表示後に変更しているらしい．したがってサイズは
//  変更できない．左上の位置だけは指定可能
//  そこで，ダイアログのオーナーのサブクラス関数を定義してその中で設定する
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
  //キャプションプロパティを表示
  if FCaption <> '' then SetWindowText(FHandle, PChar(FCaption));

  //まずデフォルトのフォルダ参照ダイアログのサイズを改めて取得
  GetWindowRect(FHandle, FormRect);

  if FFormWidth  < FormWidthDefault  then FFormWidth  := FormWidthDefault;
  if FFormHeight < FormHeightDefault then FFormHeight := FormHeightDefault;

  //FormLeft,FormTopプロパティが共に0なら画面の中央に表示する
  CSX := GetSystemMetrics(SM_CXSCREEN);
  CSY := GetSystemMetrics(SM_CYSCREEN);

  if (FFormLeft = 0) and (FFormTop = 0) then begin
    ALeft := (CSX - FFormWidth)  div 2;
    ATop  := (CSY - FFormHeight) div 2;
  end else begin
    ALeft := FFormLeft;
    ATop  := FFormTop;
  end;

  //新しいスタイルのダイアログの位置とサイズ設定
  if (bifNewDialogStyle in FOptions) then begin
    SetWindowPos(FHandle, 0, ALeft, ATop, FFormWidth, FFormHeight, SWP_NOZORDER or SWP_SHOWWINDOW);
  end else begin

    //各Windowのハンドルを取得
    //ID=14146だとTitel,14147だとStatusText文字列用ののWindow
    WndTreeView  := GetDlgItem(FHandle, 14145);
    WndOKBtn     := GetDlgItem(FHandle, 1);
    WndCancelBtn := GetDlgItem(FHandle, 2);

    //各Windowの位置とサイズを調整する
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

    //[OK][キャンセル]ボタン
    SetWindowPos(WndOKBtn, 0, BtnLeft, BtnTop, 0, 0,
                 SWP_NOSIZE or SWP_NOZORDER or SWP_SHOWWINDOW);

    SetWindowPos(WndCancelBtn, 0, BtnLeft + BtnWidth + 5, BtnTop, 0, 0,
                 SWP_NOSIZE or SWP_NOZORDER or SWP_SHOWWINDOW);
  end;
end;

//-----------------------------------------------------------------------------
//
//
//  [ファイル選択]と[保存]ダイアログの基本クラス
//
//
//-----------------------------------------------------------------------------

{ TplCustomFileDialog }

//=============================================================================
//  Create処理
//  他のコントロール類はLoadedで生成
//=============================================================================
constructor TplCustomFileDialog.Create(AOwner: TComponent);
var
  ARect  : TRect;
  OSInfo : TOSVERSIONINFO;
begin
  inherited Create(AOwner);

  //OSのバージョン値を取得しておく
  //ただしここではVista以降に対する判定なのでこれだけ
  OSInfo.dwOSVersionInfoSize := Sizeof(OSVERSIONINFO);
  GetVersionEx(osInfo);
  if OSInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then begin
    OSVersionValueMajor := OSInfo.dwMajorVersion;
    OSVersionValueMinor := OSInfo.dwMinorVersion;
    IsOSBeforeVista     := (OSVersionValueMajor <= 5) and (OSVersionValueMinor <= 1);
  end;

  SystemParametersInfo(SPI_GETWORKAREA, 0, @ARect, 0);

  //ダイアログフォームの表示位置とサイズの初期値
  FFormWidth  := (ARect.Right - ARect.Left) * 2 div 5;
  FFormHeight := (ARect.Bottom - ARect.Top) div 2;
  FFormLeft   := ((ARect.Right + ARect.Left) - FFormWidth) div 2;
  FFormTop    := ((ARect.Bottom + ARect.Top) - FFormHeight) div 2;

  //その他の変数の初期化
  FModalResult        := mrNone;
  FRootDir            := '';          //ルートディレクトリ
  FDirectory          := '';          //ファイル一覧しているディレクトリ名
  FTitle              := '';          //ダイアログのキャプション
  FFindText           := '';          //表示ファイルの部分一致索文字列
  FAndFindText        := '';          //絞込み致索文字列
  FBrowseTitle        := '';          //フォルダ選択ダイアログの説明文字列
  FBrowseCaption      := '';          //フォルダ選択ダイアログのキャプション文字列
  FDisplayDirectory   := False;       //ダイアログの上部にディレクトリ名を表示
  FDisplayIcon        := True;        //ファイル一覧のファイルのアイコン表示
  FDisplayGridLines   := True;        //ListViewのグリッド線
  FImeMode            := imDontCare;  //IME設定
  FOptions            := [];          //絞込みとフォルダ選択ダイアログ表示ボタン
  FListViewItemHeight := 19;          //ListViewのItemの高さ
  FMargin             := 4;           //FormとListViewの表示マージン
  FDirectoryLabelText := '';          //ディレクトリ表示ラベルの文字列
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
//  終了時の処理
//=============================================================================
destructor TplCustomFileDialog.Destroy;
begin
  FreeAndNil(FFont);
  inherited;
end;

//=============================================================================
//  ダイアログのフォームとその関係コントロールを生成
//  ここで生成しているのでCreate後にいろいろな設定変更が可能となる
//
//  OSや他のアプリ同様にExecuteメソッド実行時に生成してもよいが，ここで生成し
//  ておくと，Execute実行前に各種の設定が可能
//=============================================================================
procedure TplCustomFileDialog.Loaded;
begin
  inherited Loaded;

  //ダイアログフォーム本体
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

  //ポップアップメニュー関係の作成
  FPopupMenu := TPopupMenu.Create(FDialogForm);
  with FPopupMenu do begin
    AutoHotkeys       := maManual;
    AutoLineReduction := maManual;
    OnPopup           := PopUpMenuOnPopup;
  end;

  FPopFileRename := TMenuItem.Create(FPopupMenu);
  with FPopFileRename do begin
    Caption           := 'ファイル名変更';
    AutoHotkeys       := maManual;
    AutoLineReduction := maManual;
    Bitmap            := nil;
    OnClick           := PopUpMenuFileRenameOnClick;
  end;
  FPopupMenu.Items.Add(FPopFileRename);

  FPopFileDelete := TMenuItem.Create(FPopupMenu);
  with FPopFileDelete do begin
    Caption           := 'ファイル削除';
    AutoHotkeys       := maManual;
    AutoLineReduction := maManual;
    Bitmap            := nil;
    OnClick           := PopUpMenuFileDeleteOnClick;
  end;
  FPopupMenu.Items.Add(FPopFileDelete);

  //フォルダ名表示用と絞込み表示とフォルダ選択ダイアログ表示ボタン配置パネル
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

  //[ファイル選択][保存][キャンセル]ボタン配置用パネル
  FBottomPanel := TPanel.Create(FDialogForm);
  with FBottomPanel do begin
    Parent     := FDialogForm;
    Height     := 30;
    Align      := alBottom;
    Alignment  := taCenter;
    BevelOuter := bvNone;
  end;

  //ファイル一覧のListViewを配置するパネル
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

  //[キャンセル]ボタン
  FCancelBtn := TBitBtn.Create(FDialogForm);
  with FCancelBtn do begin
    Parent      := FBottomPanel;
    Height      := 25;
    Width       := 75;
    Top         := FBottomPanel.Height - Height - 4;
    Left        := FBottomPanel.Width - Width - FMargin;
    Anchors     := [akRight, akBottom];
    Caption     := 'キャンセル';
    Cancel      := True;
    Default     := False;
    ModalResult := mrCancel;
    Visible     := True;
    OnClick     := CancelBtnOnClick;
  end;

  //[ファイル選択][保存]ボタン(兼用)
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

  //ファイル名編集Edit
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

  //フォルダ選択ダイアログ表示用ボタン
  FFolderBtn := TSpeedButton.Create(FDialogForm);
  with FFolderBtn do begin
    Parent            := FTopPanel;
    Height            := FTopPanel.Height;
    Width             := 24;
    Top               := 0;
    Left              := FTopPanel.Width - Width - FMargin;
    Anchors           := [akRight, akBottom];
    Flat              := True;
    Hint              := 'フォルダ選択';
    ShowHint          := True;
    Layout            := blGlyphTop;
    Visible           := doFolderBtn in FOptions;
    FolderBtn.OnClick := FolderBtnOnClick;
  end;

  //絞込み表示用ボタン
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
    Hint             := '絞込み表示';
    ShowHint         := True;
    Layout           := blGlyphTop;
    Visible          := doFindBtn in FOptions;
    FFindBtn.OnClick := FindBtnOnClick;
  end;
  FTopPanel.Visible := FFolderBtn.Visible or FFindBtn.Visible or FDisplayDirectory;

  //ディレクトリ名を表示するラベル
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

  //ファイルを一覧表示するListView
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

  //フォルダの参照ダイアログ生成
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

  //IMEの設定
  SetDlgImeMode(FImeMode);
end;

//=============================================================================
//  Fontプロパティ
//=============================================================================
procedure TplCustomFileDialog.SetFont(const Value: TFont);
begin
  if Value = nil then begin
    FFont.Assign(Value);
  end;
end;

//=============================================================================
//  実行(Execute)メソッド
//=============================================================================
function TplCustomFileDialog.Execute: Boolean;
var
  ARect : TRect;
begin
  if FDirectory            = '' then FDirectory            := ExtractFileDir(Application.ExeName);
  if FBrowseFolder.RootDir = '' then FBrowseFolder.RootDir := FRootDir;
  if FBrowseFolder.InitDir = '' then FBrowseFolder.InitDir := FDirectory;

  //ダイアログフォームの表示位置とサイズの再計算
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
    //モーダル表示
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
//  フォームを表示する時のメソッド
//  システムのイメージリストを取得してイメージハンドルを取得
//  イメージリストの作成は，FDisplayIconの値に関係するのでExecute実行後に実行
//  されるこのメソッドで行う
//=============================================================================
procedure TplCustomFileDialog.DoShow;
var
  SHFileInfo : TSHFileInfo ;
begin
  if FDisplayIcon then begin
    //システムのイメージリストのハンドルを取得
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
//  ダイアログフォームDialogFormのサブクラス
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
//  フォームを閉じる時の処理
//
//  [保存]ダイアログを閉じる時，プロパティFileExtが空文字または*の文字がある場
//  合は結果のFilePathプロパティに拡張子は付かない
//  空文字の時は[Enter]では閉じない
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
//  [ファイル選択][保存]ボタンクリック
//  モーダルフォームなのでModalResultにmrOKを代入するとフォームが閉じる
//  Closeメソッドは不要
//=============================================================================
procedure TplCustomFileDialog.OKBtnOnClick(Sender: TObject);
begin
  FModalResult := mrOK;
end;

//=============================================================================
//  [キャンセル]ボタンクリック
//  モーダルフォームなのでModalResultにmrCancelを代入するとフォームが閉じる
//  Closeメソッドは不要
//=============================================================================
procedure TplCustomFileDialog.CancelBtnOnClick(Sender: TObject);
begin
  FModalResult := mrCancel;
end;

//=============================================================================
//  ファイル名入力欄に文字列があれは[保存]ボタンを有効にする
//=============================================================================
procedure TplCustomFileDialog.FileEditOnChange(Sender: TObject);
begin
  FOKBtn.Enabled := Length(FileEdit.Text) > 0;
end;

//=============================================================================
//  絞込み表示ボタンクリック
//  絞込むのは元のプロパティFindTextの条件で表示したファイル
//  これで絞り込んで表示したリストから更に絞込み表示はできない
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
    if InputQuery('ファイル名部分一致検索', '検索文字列', FAndFindText) then begin
      SetFilesListToItems(FDirectory, FFindText, FAndFindText, FFileExt, True);

      if (FAndFindText <> '') then begin
        FDialogForm.Caption := FDialogForm.Caption + '   [' + FAndFindText + '] を含むファイルリスト';
      end;
    end;
  end;
end;

//=============================================================================
//  フォルダ選択ダイアログボタンクリック
//  OnFolderBtnClickイベントでFlagをFalseにするとフォルダ参照ダイアログを表示
//  しない．独自のコードを実行する場合等に使用できる
//=============================================================================
procedure TplCustomFileDialog.FolderBtnOnClick(Sender: TObject);
var
  Flag      : Boolean;
  AIndex    : Integer;
  TopIndex  : Integer;
  OriginDir : String;
begin
  Flag := True;

  //ダイアログの位置とサイズが有効であれば設定
  if FBrowseFolder.FFormLeft = 0 then begin
    FBrowseFolder.FFormLeft := FDialogForm.Left + FDialogForm.Width - FBrowseFolder.FormWidthDefault;
  end;
  if FBrowseFolder.FFormTop = 0 then begin
    FBrowseFolder.FFormTop := FDialogForm.Top  + 40;
  end;

  //ボタンクリックイベント
  //フォルダの参照ダイアログは生成済み
  //ファイルリストのフォームも生成すみ(未表示)
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
      //[キャンセル]で選択を取消したら表示を元に戻す
      FDirectory := OriginDir;
      SetFilesListToItems(FDirectory, FFindText, '', FFileExt, False);
      FListView.Selected := nil;

      //スクロール
      if TopIndex >= 0 then begin
        FListView.Items[TopIndex].Selected := True;
        FListView.Items[TopIndex].MakeVisible(False);
        FListView.Scroll(0, FListView.Selected.Top - FListView.TopItem.Top);

        //元の選択項目を選択状態に
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
//  フォルダの参照ダイアログで選択フォルダを変更したらリストを更新
//  フォルダの参照ダイアログを閉じなくても，リアルタイムでどんなファイルがある
//  かを確認
//  絞込み検索文字列は解除される
//=============================================================================
procedure TplCustomFileDialog.BrowseSelectionChanged(Sender: TObject; Wnd: HWND;
  Directory: String; var StatusText: String; var OKBtnEnabled: Boolean);
begin
  SetFilesListToItems(Directory, FFindText, '', FFileExt, False);
end;

//=============================================================================
//  Popupメニューの[ファイル名変更]と[ファイル削除]の表示処理
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
//  ファイル名の変更開始
//  読出し専用ファイルは変更できない(不正な文字があるとの表示)
//  他ユーザ作成のファイルも変更できない(共有フォルダ内で設定によっては可能)
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

    //名前変更ボタンをクリックした時のイベント
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
//  ポップアップメニュー[ファイル削除]
//  選択中のファイルを削除
//  読出し専用ファイルは削除できない
//  他ユーザ作成のファイルも削除できない(共有フォルダ内で設定によっては可能)
//
//  削除確認のダイアログは表示しない
//  必要であればOnBeforeDeleteを使用する
//
//  このコンポでは削除は1つしかできないようにしている
//=============================================================================
procedure TplCustomFileDialog.PopUpMenuFileDeleteOnClick(Sender: TObject);
var
  AIndex        : Integer;
  AAction       : Boolean;
  DeletedFlag   : Boolean;
  AFileFullPath : String;
begin
  //編集中はポップアップ非表示としているのでこのコンポでは不要であるが念のため
  FListView.Selected.CancelEdit;

  //選択ファイルが1つだけの時だけ処理
  if (FListView.SelCount <> 1) then exit;

  AIndex        := FListView.Selected.Index;
  AFileFullPath := FFileList[AIndex].FFileFullPath;
  AAction       := True;
  DeletedFlag   := True;

  //ファイル削除前のイベント
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

    //ファイル削除後のイベント
    //削除確認用に，削除したファイル名を引数に渡す
    if Assigned(FOnAfterDelete) then begin
      FOnAfterDelete(Self, AFileFullPath, DeletedFlag);
    end else begin
      //削除できなかった場合
      if not DeletedFlag then begin
        MessageDlgPos(ErrorDelete, mtInformation, [mbOK], 0, FDialogForm.Left, FDialogForm.Top);
      end;
    end;
  end;
end;

//=============================================================================
//  日本語入力モードの設定 ImeModeプロパティ
//  ここではファイル名入力TEidのみ設定
//  ListViewのItemを編集(ファイル名変更)では編集モードに入ったら設定
//  絞込み検索の入力ダイアログもこの設定にしたがう
//=============================================================================
procedure TplCustomFileDialog.SetDlgImeMode(const Value: TImeMode);
begin
  FImeMode := Value;
  if FDialogForm <> nil then begin
    SetImeMode(FFileEdit.Handle, FImeMode);
  end;
end;

//=============================================================================
//  フォルダ名(ディレクトリ名)を表示
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
//  ファイルリストの更新メソッド(公開メソッド)
//
//  現在のDirectoryとFindTextプロパティの値で更新
//  絞込み表示で設定した値は無視
//  このメソッドの呼出前にこれらのプロパティを変更しておくと，その値を使用し
//  て再表示
//=============================================================================
procedure TplCustomFileDialog.GetFilesList;
begin
  SetFilesListToItems(FDirectory, FFindText, FAndFindText, FFileExt, False);
end;

//-----------------------------------------------------------------------------
//  FFileList(TList)用のソートのコールバック関数
//  Item1>Item2の時<0 Item10 Item1=Item2の時0を返すと昇順
//  オブジェクトを持たないTListの昇順ソートはSortメソッドを実行すればよい
//  降順やオブジェクトでソートする場合はコールバック関数を使用する必要がある
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

  //どちらもフォルダかどちらもフォルダでない場合
  if (Dir1 and Dir2) or not(Dir1 or Dir2) then begin
    Result := CompareText(Str1, Str2);
  end else
  //Item1に該当するのがフォルダの場合
  if Dir1 then begin
    Result := -1;
  end else
  //Item2に該当するのがフォルダの場合
  if Dir2 then begin
    Result := 1;
  end;
end;

//=============================================================================
//  ファイルリストの作成
//  現在のDirectory,FindTextプロパティと絞込み検索で設定した値を使用する
//
//  ADir        : 検索対象ディレクトリ(フォルダ)
//  AFindText   : ファイルの検索文字列
//  AAddFinText : 絞込みで設定した文字列
//  AFileExt    : 拡張子(.txtのように.を付加して指定)
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

    //検索文字列
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
        //OSによってSearchRec.Nameはフルパスと名前だけのことがある
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
//  [ファイル選択]ダイアログクラス
//
//
//-----------------------------------------------------------------------------

{ TplOpenDialog }

//=============================================================================
//  [ファイル選択]ダイアログのCreate処理
//=============================================================================
constructor TplOpenDialog.Create(AOwner: TComponent);
begin
  inherited;
  FTitle := 'ファイルを開く';
end;

//=============================================================================
//  [ファイル選択]ダイアログの実行メソッド
//  OnCreateではまだボタン類のコントロールは生成されていないのでここで設定
//=============================================================================
function TplOpenDialog.Execute: Boolean;
begin
  FOKBtn.Caption    := '開く';
  FOKBtn.Enabled    := False;
  FFileEdit.Visible := False;

  Result := inherited Execute;
end;

//-----------------------------------------------------------------------------
//
//
//  [保存]ダイアログクラス
//
//
//-----------------------------------------------------------------------------


{ TplSaveDialog }

//=============================================================================
//  [保存]ダイアログのCreate処理
//=============================================================================
constructor TplSaveDialog.Create(AOwner: TComponent);
begin
  inherited;
  FTitle := '名前を付けて保存';
end;

//=============================================================================
//  [保存]ダイアログの実行メソッド
//  OnCreateではまだボタン類のコントロールは生成されていないのでここで設定
//
//  FileExtを空文字した場合は取り出したファイルに拡張子は付かない
//  FileExtに*が含まれる場合も結果のファイル名に拡張子は付かない
//=============================================================================
function TplSaveDialog.Execute: Boolean;
begin
  FOKBtn.Caption    := '保存';
  FOKBtn.Enabled    := False;
  FFileEdit.Visible := True;
  FFileEdit.Text    := ChangeFileExt(FFileName, '');

  Result := inherited Execute;
end;

//-----------------------------------------------------------------------------
//
//
//  ファイル一覧表示用のListView関係
//
//
//-----------------------------------------------------------------------------

{ TplFileDialogDataList }

//-----------------------------------------------------------------------------
//  ファイル情報を格納するTplFileDialogDataListの関数とメソッド類
//  TListのこれらの関数，メソッドの引数や戻値はPointerであるが，ここでは
//  TplFileDialogDataListItemにキャストするために再定義　　
//  ClearメソッドはTplFileDialogDataListのオブジェクト解放するため再定義
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
//  TListItemのWndProcのサブクラス関数
//  CanEditで使用しているだけ
//  編集中のコンテキストメニューは非表示とする
//  無効にしても[Ctrl]+[C],[Ctrl]+[V]等は使用可能
//-----------------------------------------------------------------------------
function ItemEditorWndProc(AWnd: HWND; uMsg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;
begin
  //メッセージがWM_CONTEXTMENUなら処理をバイパス
  if uMsg = WM_CONTEXTMENU then begin
    Result := 1;
  end else begin
    if uMsg = WM_DESTROY then begin
      //かな漢字入力を閉じる
      SetImeMode(AWnd,imClose);
    end;
    Result := CallWindowProc(OriginItemWndProc, AWnd, uMsg, wParam, lParam);
  end;
end;

{ TplFileDialogListView }

//=============================================================================
//  仮想リストビュー生成
//=============================================================================
constructor TplFileDialogListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

//=============================================================================
//  OnDataHint(OnDataよりも前に1回だけ発生)イベント処理
//  OnDataHintは表示分(StartIndex～EndIndex)に間に発生する
//  システムのイメージリストからファイルアイコンのイメージインデックスを取得
//  このイベントはListView1.OwnerData:=True;でないと機能しない
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
//  ListViewのOnDataイベント
//  ListViewの各Itemの描画が必要となった場合に発生
//  ListViewのItemに値をセットする
//  このイベントはListView1.OwnerData:=True;でないと機能しない
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
//  OnAdvancedCustomDrawItemイベント用のメソッド
//  Vista以降ではListViewもかなりデザインがよくなったので必要性はあまりないか
//  も知れないが実装
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
//  リストのファイル名をクリックまたは選択動作を行ったら
//  保存ダイアログの場合はTEditにファイル名を表示
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
    //MultiSelect := Falseにしているので実際には以下は実行しない(将来の拡張用)
    if (FDialog is TplSaveDialog) and (FDialog.FFileEdit.Text <> '') then begin
      FDialog.FOKBtn.Enabled := True;
    end else begin
      FDialog.FOKBtn.Enabled := False;
    end;
  end;
end;

//=============================================================================
//  OnEditing(ItemのTextの編集開始)イベント用メソッド
//  Itemのインプレースエディタの右クリックのコンテキストメニューを非表示にする
//  ためにItemのWndProcのサブクラス関数を設定
//=============================================================================
function TplFileDialogListView.CanEdit(Item: TListItem): Boolean;
var
  EditorHandle : THandle;
begin
  Result := inherited CanEdit(Item);

  if Result then begin
    //インプレースエディタのハンドルを取得
    //編集中であれば>0となる
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
//  ファイル名の編集が終了([Enter]押下)したら自動実行されるメソッド
//  変更がなかった場合，このメソッドは呼ばれない
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
  //元のメソッドを実行
  inherited Edit(Item);

  AIndex := Selected.Index;

  AAction := True;
  IsSort  := False;

  //変更前の情報
  AFullPath := FFileList[AIndex].FFileFullPath;
  AFileName := ChangeFileExt(ExtractFileName(AFullPath), '');
  AExt      := ExtractFileExt(AFullPath);

  NewFileName := Item.pszText;
  NewFullPath := IncludeTrailingPathDelimiter(FDialog.FDirectory) + NewFileName + AExt;

  if Assigned(FDialog.FOnBeforeRename) then begin
    FDialog.FOnBeforeRename(TplCustomFileDialog(FDialog), AFullPath, NewFullPath, AAction);
  end;

  if AAction then begin
    //同名のファイルが存在する場合はダイアログを表示
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

        //用途によってはソートした方がいい場合もある
        //仮想リストビューなのでFindCaptionは使用できない
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
          //これをしなくても選択状態であるが，仮想リストビューなので表示更新のため
          Items[AIndex].Selected := True;
          Items[AIndex].Focused;
        end;
      end else begin
        //名前変更に失敗した場合，イベントが定義してあればダイアログは表示しない
        if Assigned(FDialog.FOnAfterRename) then begin
          FDialog.FOnAfterRename(TplCustomFileDialog(FDialog), AFullPath, NewFullPath, IsReName);
        end else begin
          MessageDlgPos(ErrorReName2, mtInformation, [mbOK], 0, FDialog.DialogForm.Left, FDialog.DialogForm.Top);
        end;
        //これをしなくても選択状態であるが，仮想リストビューなので表示更新のため
        Items[AIndex].Selected := True;
        Items[AIndex].Focused;
      end;
    end;
  end;
end;

//=============================================================================
//  マウスダブルクリック時の動作
//  [ファイル選択][保存]ボタン押下時と同じ動作
//=============================================================================
procedure TplFileDialogListView.DblClick;
begin
  inherited;

  if Selected = nil then exit;

  TplCustomFileDialog(FDialog).FModalResult := mrOk;
  TForm(FDialog.DialogForm).Close;
end;

//=============================================================================
//  OnKeyDownイベント用メソッド
//  選択アイテムのフォルダ上の[Enter]はダブルクリックと同じ動作とする
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
//  ListViewのCN_KEYDOWNメッセージ処理
//  Result := 0 にして自身にメッセージを送る
//  こうしないとListViewのOnKeyDownメッセージが発生しないので，項目編集中でも
//  ダイアログフォーム(DialogForm)の[Enter],[ESC]が有効になってしまい，ダイア
//  ログが閉じてしまう
//=============================================================================
procedure TplFileDialogListView.CNKeydown(var Message: TMessage);
begin
  Message.Result := 0;
end;

end.
