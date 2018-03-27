object frmDialogType: TfrmDialogType
  Left = 331
  Top = 117
  BorderStyle = bsDialog
  Caption = 'frmDialogType'
  ClientHeight = 210
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #12513#12452#12522#12458
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesigned
  StyleElements = []
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyPress = FormKeyPress
  DesignSize = (
    310
    210)
  PixelsPerInch = 96
  TextHeight = 18
  object HideBack1: THideBack
    Left = 0
    Top = 0
    Width = 310
    Height = 169
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    AutoSize = False
    Color = clWhite
    ParentColor = False
    Transparent = False
    ExplicitWidth = 285
    ExplicitHeight = 159
  end
  object btnCancel: TButton
    Left = 227
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #12461#12515#12531#12475#12523
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object btnOK: TButton
    Left = 144
    Top = 177
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
end
