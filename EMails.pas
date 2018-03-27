unit EMails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, IdMessage, IdSMTP, IdSSLOpenSSL, IdGlobal,
  IdExplicitTLSClientServerBase;

type
  TEMailStructure = record
    SMTP_Host : String;
    SMTP_Port : Integer;
    SMTP_Username : String;
    SMTP_Password : String;
    EMail_FromAddress : String;
    EMail_ToAddress : String;
    EMail_Subject : String;
    EMail_Body : String;
  end;

  procedure SendEmail(es: TEMailStructure; Information: TLabel = nil);

implementation

procedure SendEmail(es: TEMailStructure; Information: TLabel = nil);
var
  SMTP: TIdSMTP;
  Email: TIdMessage;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  SMTP := TIdSMTP.Create(nil);
  Email := TIdMessage.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    SSLHandler.MaxLineAction := maException;
    SSLHandler.SSLOptions.Method := sslvTLSv1;
    SSLHandler.SSLOptions.Mode := sslmUnassigned;
    SSLHandler.SSLOptions.VerifyMode := [];
    SSLHandler.SSLOptions.VerifyDepth := 0;
    SMTP.IOHandler := SSLHandler;
    SMTP.Host := es.SMTP_Host;  //smtp.gmail.com
    SMTP.Port := es.SMTP_Port;  //587
    SMTP.Username := es.SMTP_Username;// 'hidetoshiinoki@gmail.com';
    SMTP.Password := es.SMTP_Password;// 'Kq6DmKHR5OLA';
    SMTP.UseTLS := utUseExplicitTLS;
    Email.From.Address := es.EMail_FromAddress;// 'hidetoshiinoki@gmail.com';
    Email.Recipients.EmailAddresses := es.EMail_ToAddress;// Recipients;
    Email.Subject := es.EMail_Subject;// Subject;
    Email.Body.Text := es.EMail_Body;// Body;
    if Information <> nil then
    begin
    	Information.Caption := es.EMail_ToAddress + ' にメールを送信中...';
      Application.ProcessMessages;
    end;
    SMTP.Connect;
    try
      SMTP.Send(Email);
      if Information <> nil then
      begin
        Information.Caption := es.EMail_ToAddress + ' にメールを送信しました';
        Application.ProcessMessages;
      end;
    finally
      SMTP.Disconnect;
    end;
  finally
    SMTP.Free;
    Email.Free;
    SSLHandler.Free;
  end;
end;

end.
