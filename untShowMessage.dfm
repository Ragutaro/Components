object frmShowMessage: TfrmShowMessage
  Left = 328
  Top = 502
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'frmShowMessage'
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
  OnCreate = FormCreate
  DesignSize = (
    450
    110)
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
    Color = clBtnFace
    ParentColor = False
    Transparent = True
  end
  object btnOK: TButton
    Left = 367
    Top = 77
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 0
    OnClick = btnOKClick
  end
end
