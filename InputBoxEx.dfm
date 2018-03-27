object frmInputBoxEx: TfrmInputBoxEx
  Left = 322
  Top = 399
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'frmInputBoxEx'
  ClientHeight = 112
  ClientWidth = 500
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    500
    112)
  PixelsPerInch = 96
  TextHeight = 18
  object HideBack1: THideBack
    Left = 0
    Top = 0
    Width = 500
    Height = 71
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Caption = ' '
    Color = clWhite
    ParentColor = False
    Transparent = False
    ExplicitWidth = 489
  end
  object lblDesc: TLabel
    Left = 12
    Top = 10
    Width = 41
    Height = 18
    Caption = 'lblDesc'
  end
  object btnOK: TButton
    Left = 334
    Top = 79
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 417
    Top = 79
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object memImput: TMemo
    Left = 10
    Top = 30
    Width = 482
    Height = 25
    TabOrder = 0
    OnChange = memImputChange
  end
end
