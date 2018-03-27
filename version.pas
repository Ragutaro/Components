unit version;

interface

type
  TEXEVersionData = record
    CompanyName,
    FileDescription,
    FileVersion,
    InternalName,
    LegalCopyright,
    LegalTrademarks,
    OriginalFileName,
    ProductName,
    ProductVersion,
    Comments,
    PrivateBuild,
    SpecialBuild: string;
  end;

var
  VersionData: TEXEVersionData;

implementation

uses Windows, SysUtils, Forms;

procedure LoadVersionInfo;
type
  PLandCodepage = ^TLandCodepage;
  TLandCodepage = record
    wLanguage,
    wCodePage: word;
  end;
var
  dummy,
  len: cardinal;
  buf, pntr: pointer;
  lang, key: string;
begin
  len := GetFileVersionInfoSize(PChar(Application.ExeName), dummy);
  if len = 0 then
    RaiseLastOSError;
  GetMem(buf, len);
  try
    if not GetFileVersionInfo(PChar(Application.ExeName), 0, len, buf) then
      RaiseLastOSError;

    if not VerQueryValue(buf, '\VarFileInfo\Translation\', pntr, len) then
      RaiseLastOSError;

    lang := Format('%.4x%.4x', [PLandCodepage(pntr)^.wLanguage, PLandCodepage(pntr)^.wCodePage]);

    key := '\StringFileInfo\' + lang + '\CompanyName';
    if VerQueryValue(buf, PChar(Key), pntr, len) then
      VersionData.CompanyName := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\FileDescription';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.FileDescription := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\FileVersion';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.FileVersion := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\InternalName';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.InternalName := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\LegalCopyright';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.LegalCopyright := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\LegalTrademarks';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.LegalTrademarks := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\OriginalFileName';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.OriginalFileName := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\ProductName';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.ProductName := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\ProductVersion';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.ProductVersion := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\Comments';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.Comments := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\PrivateBuild';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.PrivateBuild := PChar(pntr);
    key := '\StringFileInfo\' + lang + '\SpecialBuild';
    if VerQueryValue(buf, PChar(key), pntr, len) then
      VersionData.SpecialBuild := PChar(pntr);
  finally
    FreeMem(buf);
  end;
end;

initialization
  LoadVersionInfo;

end.

