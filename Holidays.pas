unit Holidays;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  System.SysUtils, System.Classes, Vcl.Controls, System.StrUtils;

  procedure GetHolidays(const AYear: String);
  function  IsHoliday(const ADate: String = 'YYYY/MM/DD'): Boolean;
  procedure HolidaysListCreate;
  procedure HolidaysListFree;

var
  slHolidaysList : TStringList;

implementation

procedure HolidaysListCreate;
begin
  slHolidaysList := TStringList.Create;
end;

procedure HolidaysListFree;
begin
  slHolidaysList.Free;
end;

procedure GetHolidays(const AYear: String);
const
  f : Single = 0.242194;
var
  iDay, iYear : Integer;
  dTemp : TDate;
begin
  iYear := StrToInt(AYear);

  //一月
  slHolidaysList.Add(AYear + '/01/01'); //元日
  iDay := DayOfWeek(StrToDate(AYear + '/01/01'));
  Case iDay of
    1 :
      begin
        slHolidaysList.Add(AYear + '/01/02');	//振り替え休日
        slHolidaysList.Add(AYear + '/01/09'); //成人の日
      end;
    2 : slHolidaysList.Add(AYear + '/01/08');
    3..7 : slHolidaysList.Add(AYear + '/01/' + IntToStr(14-(iDay-3)));
  end;

  //2月
  slHolidaysList.Add(AYear + '/02/11');
  if DayOfWeek(StrToDate(AYear + '/02/11')) = 1 then
    slHolidaysList.Add(AYear + '/02/12');

  //3月 春分の日
  if iYear < 1980 then
    iDay := Trunc(20.8357 + 0.242194*(iYear-1980) - Trunc((iYear-1983) / 4))
  else
    iDay := Trunc(20.8431 + 0.242194*(iYear-1980) - Trunc((iYear-1980) / 4));
  dTemp := EncodeDate(iYear, 3, iDay);
  slHolidaysList.Add(FormatDateTime('yyyy/mm/dd', dTemp));
  if DayOfWeek(dTemp) = 1 then
    slHolidaysList.Add(DateToStr(dTemp+1));

  //4月
  slHolidaysList.Add(AYear + '/04/29');
  if DayOfWeek(StrToDate(AYear + '/04/29')) = 1 then
    slHolidaysList.Add(AYear + '/04/30');

  //5月
  slHolidaysList.Add(AYear + '/05/03');
  slHolidaysList.Add(AYear + '/05/04');
  slHolidaysList.Add(AYear + '/05/05');
  iDay := DayOfWeek(StrToDate(AYear + '/05/03'));
  Case iDay of
    1, 6, 7 : slHolidaysList.Add(AYear + '/05/06');
  end;

  //7月
  iDay := DayOfWeek(StrToDate(AYear + '/07/01'));
  Case iDay of
    1 : slHolidaysList.Add(AYear + '/07/16');
    2..7 : slHolidaysList.Add(AYear + '/07/' + IntToStr(21-(iDay-3)));
  end;

  //8月
  slHolidaysList.Add(AYear + '/08/11');
  if DayOfWeek(StrToDate(AYear + '/08/11')) = 1 then
    slHolidaysList.Add(AYear + '/08/12');

  //9月
  iDay := DayOfWeek(StrToDate(AYear + '/09/01'));
  Case iDay of
    1, 2 : slHolidaysList.Add(AYear + '/09/' + Format('%.2d', [9-(iDay-1)]));
    3..7 : slHolidaysList.Add(AYear + '/09/' + IntToStr(22-(iDay-2)));
  end;
    //秋分の日
    if iYear < 1980 then
      iDay := Trunc(23.2588 + 0.242194*(iYear - 1980) - Trunc((iYear-1983) / 4))
    else
      iDay := Trunc(23.2488 + 0.242194*(iYear - 1980) - Trunc((iYear-1980) / 4));
    dTemp := EncodeDate(iYear, 9, iDay);
    slHolidaysList.Add(FormatDateTime('yyyy/mm/dd', dTemp));
    if DayOfWeek(dTemp) = 1 then
      slHolidaysList.Add(DateToStr(dTemp+1));

  //10月
  iDay := DayOfWeek(StrToDate(AYear + '/10/01'));
  case iDay of
    1, 2 : slHolidaysList.Add(AYear + '/10/' + Format('%.2d', [9-(iDay-1)]));
    3..7 : slHolidaysList.Add(AYear + '/10/' + IntToStr(14-(iDay-3)));
  end;

  //11月
  slHolidaysList.Add(AYear + '/11/03');
  if DayOfWeek(StrToDate(AYear + '/11/03')) = 1 then
    slHolidaysList.Add(AYear + '/11/04');
  slHolidaysList.Add(AYear + '/11/23');
  if DayOfWeek(StrToDate(AYear + '/11/23')) = 1 then
    slHolidaysList.Add(AYear + '/11/24');

  //12月
  slHolidaysList.Add(AYear + '/12/23');
  if DayOfWeek(StrToDate(AYear + '/12/23')) = 1 then
    slHolidaysList.Add(AYear + '/12/24');
end;

function IsHoliday(const ADate: String = 'YYYY/MM/DD'): Boolean;
begin
  Result := False;
  if slHolidaysList.IndexOf(ADate) > -1 then
    Result := True;
end;

end.
 