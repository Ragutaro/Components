unit PngUtils;
{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}
{$WARN SYMBOL_DEPRECATED OFF}
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, System.StrUtils, IniFilesDX, System.Types, VCL.Imaging.PngImage;

  procedure pngSmoothResize(APng: TPngObject; NuWidth, NuHeight: integer);
  procedure pngSetOpacity(APng: TPNGObject; Opacity: Integer);

implementation

procedure pngSmoothResize(APng: TPngObject; NuWidth, NuHeight: integer);
var
  xscale, yscale, sfrom_y, sfrom_x, weight, total_red, total_green, total_blue, total_alpha: Single;
  ifrom_y, ifrom_x, to_y, to_x, new_red, new_green, new_blue, new_alpha, new_colortype, iX, iY : Integer;
  weight_x, weight_y     : array[0..1] of Single;
  IsAlpha : Boolean;
  bTmp : TPNGObject;
  sli, slo : pRGBLine;
  ali, alo: pbytearray;
begin
  ali := nil;
  alo := nil;
  new_alpha := 0;
  if not (apng.Header.ColorType in [COLOR_RGBALPHA, COLOR_RGB]) then
    raise Exception.Create('Only COLOR_RGBALPHA and COLOR_RGB formats' +
    ' are supported');
  IsAlpha := apng.Header.ColorType in [COLOR_RGBALPHA];
  if IsAlpha then new_colortype := COLOR_RGBALPHA else
    new_colortype := COLOR_RGB;
  bTmp := Tpngobject.CreateBlank(new_colortype, 8, NuWidth, NuHeight);
  try
    xscale := bTmp.Width / (apng.Width-1);
    yscale := bTmp.Height / (apng.Height-1);
    for to_y := 0 to bTmp.Height-1 do begin
      sfrom_y := to_y / yscale;
      ifrom_y := Trunc(sfrom_y);
      weight_y[1] := sfrom_y - ifrom_y;
      weight_y[0] := 1 - weight_y[1];
      for to_x := 0 to bTmp.Width-1 do begin
        sfrom_x := to_x / xscale;
        ifrom_x := Trunc(sfrom_x);
        weight_x[1] := sfrom_x - ifrom_x;
        weight_x[0] := 1 - weight_x[1];

        total_red   := 0.0;
        total_green := 0.0;
        total_blue  := 0.0;
        total_alpha  := 0.0;
        for ix := 0 to 1 do begin
          for iy := 0 to 1 do begin
            sli := apng.Scanline[ifrom_y + iy];
            if IsAlpha then ali := apng.AlphaScanline[ifrom_y + iy];
            new_red := sli[ifrom_x + ix].rgbtRed;
            new_green := sli[ifrom_x + ix].rgbtGreen;
            new_blue := sli[ifrom_x + ix].rgbtBlue;
            if IsAlpha then new_alpha := ali[ifrom_x + ix];
            weight := weight_x[ix] * weight_y[iy];
            total_red   := total_red   + new_red   * weight;
            total_green := total_green + new_green * weight;
            total_blue  := total_blue  + new_blue  * weight;
            if IsAlpha then total_alpha  := total_alpha  + new_alpha  * weight;
          end;
        end;
        slo := bTmp.ScanLine[to_y];
        if IsAlpha then alo := bTmp.AlphaScanLine[to_y];
        slo[to_x].rgbtRed := Round(total_red);
        slo[to_x].rgbtGreen := Round(total_green);
        slo[to_x].rgbtBlue := Round(total_blue);
        if isAlpha then alo[to_x] := Round(total_alpha);
      end;
    end;
    apng.Assign(bTmp);
  finally
    bTmp.Free;
  end;
end;

procedure pngSetOpacity(APng: TPNGObject; Opacity: Integer);
var
  png : TPngImage;
  iX, iY : Integer;
begin
  png := TPngImage.Create;
  try
    png.Assign(APng);
    png.CreateAlpha;
    for iX := 0 to png.Width-1 do
    begin
      for iY := 0 to png.Height-1 do
      begin
        if png.AlphaScanline[iX]^[iY] > Opacity then
        png.AlphaScanline[iX]^[iY] := Opacity;
      end;
    end;
    APng.Assign(png);
  finally
    png.Free;
  end;
end;

end.
