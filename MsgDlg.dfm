object frmMessageDlg: TfrmMessageDlg
  Left = 328
  Top = 354
  BorderStyle = bsDialog
  Caption = 'frmMessageDlg'
  ClientHeight = 110
  ClientWidth = 450
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  StyleElements = []
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 18
  object HideBack1: THideBack
    Left = 0
    Top = 0
    Width = 450
    Height = 69
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = ' '
    Color = clWhite
    ParentColor = False
    Transparent = False
  end
  object imgIcon: TImage
    Left = 10
    Top = 10
    Width = 32
    Height = 32
  end
  object lblMsg: TLabel
    Left = 56
    Top = 16
    Width = 36
    Height = 18
    Caption = 'lblMsg'
  end
end
