unit dp;

interface

uses
  WinApi.Windows, Winapi.Messages, System.SysUtils, Vcl.Graphics;

  procedure dpStr(sMessages: String); overload;
  procedure dpStr(iMessages: Integer); overload;
  procedure dpStr(bMessages: Boolean); overload;
	procedure dpStr(fMessages: Single); overload;
  procedure dpColor(cColor: TColor);
  procedure dpDateTime(dDate: TDate); overload;
  procedure dpDateTime(dTime: TTime); overload;
  procedure dpDateTime(dDateTime: TDateTime); overload;

implementation

procedure dpStr(sMessages: String); overload;
begin
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + sMessages));
end;

procedure dpStr(iMessages: Integer); overload;
begin
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + IntToStr(iMessages)));
end;

procedure dpStr(bMessages: Boolean); overload;
begin
  if bMessages then
    OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + 'True'))
  else
    OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + 'False'));
end;

procedure dpStr(fMessages: Single); overload;
begin
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + FloatToStr(fMessages)));
end;

procedure dpColor(cColor: TColor);
var
  sInteger, sRGB : String;
begin
  sInteger := IntToStr(ColorToRGB(cColor));
  sRGB := ColorToString(cColor);
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + sInteger));
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + sRGB));
end;

procedure dpDateTime(dDate: TDate); overload;
begin
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + DateToStr(dDate)));
end;

procedure dpDateTime(dTime: TTime); overload;
begin
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + TimeToStr(dTime)));
end;

procedure dpDateTime(dDateTime: TDateTime); overload;
begin
  OutputDebugString(PWideChar(FormatDateTime('HH:NN:SS ', Now) + DateTimeToStr(dDateTime)));
end;

end.
