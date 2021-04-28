program QuickTabServer;

uses
  {$IFDEF DEBUG}
  {$IFDEF MSWINDOWS}
  FastMM4,
  {$ENDIF }
  {$ENDIF }
  System.StartUpCopy,
  FMX.Forms,
  unPrincipal in 'unPrincipal.pas' {frmPrincipal},
  unDM1 in 'unDM1.pas' {DM1: TDataModule},
  unFrameMesa in 'unFrameMesa.pas' {frameMesa: TFrame},
  FMXDelphiZXIngQRCode in 'FMXDelphiZXIngQRCode.pas',
  unMensagem in 'unMensagem.pas' {frmMensagem},
  unUtils in 'unUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TfrmMensagem, frmMensagem);
  ReportMemoryLeaksOnShutdown := True;
  Application.Run;
end.
