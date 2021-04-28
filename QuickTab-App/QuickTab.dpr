program QuickTab;

uses
  {$IFDEF DEBUG}
  {$IFDEF MSWINDOWS}
  FastMM4,
  {$ENDIF }
  {$ENDIF }
  System.StartUpCopy,
  FMX.Forms,
  unLogin in 'unLogin.pas' {frmLogin},
  Utils in 'Utils.pas',
  unPrincipal in 'unPrincipal.pas' {frmPrincipal},
  unFrameCategoria in 'unFrameCategoria.pas' {frameCategoria: TFrame},
  unFramePromocao in 'unFramePromocao.pas' {framePromocao: TFrame},
  unProdutoDetalhado in 'unProdutoDetalhado.pas' {frmProdutoDetalhado},
  unFrameAdicional in 'unFrameAdicional.pas' {frameAdicional: TFrame},
  unPedido in 'unPedido.pas',
  unProduto in 'unProduto.pas',
  unVenda in 'unVenda.pas',
  unMeusDados in 'unMeusDados.pas' {frmMeusDados},
  unOnboarding in 'unOnboarding.pas' {frmOnboarding},
  unHistorico in 'unHistorico.pas' {frmHistorico},
  unFrameItemPedido in 'unFrameItemPedido.pas' {frameItemPedido: TFrame},
  unDM1 in 'unDM1.pas' {DM1: TDataModule},
  unToast in 'unToast.pas',
  unNotificacao in 'unNotificacao.pas',
  unCamera in 'unCamera.pas' {frmCamera},
  unFrameItemMenu in 'unFrameItemMenu.pas' {frameItemMenu: TFrame},
  unMensagem in 'unMensagem.pas' {frmMensagem},
  unAlterarSenha in 'unAlterarSenha.pas' {frmAlterarSenha},
  unFrameFundo in 'unFrameFundo.pas' {frameFundo: TFrame};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TfrmProdutoDetalhado, frmProdutoDetalhado);
  Application.CreateForm(TfrmMeusDados, frmMeusDados);
  Application.CreateForm(TfrmOnboarding, frmOnboarding);
  Application.CreateForm(TfrmHistorico, frmHistorico);
  Application.CreateForm(TDM1, DM1);
  Application.CreateForm(TfrmCamera, frmCamera);
  Application.CreateForm(TfrmMensagem, frmMensagem);
  Application.CreateForm(TfrmAlterarSenha, frmAlterarSenha);
  Application.Run;
end.
