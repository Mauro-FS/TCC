unit unAlterarSenha;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  unFrameFundo, unMensagem, unDM1;

type
  TfrmAlterarSenha = class(TForm)
    recFundoAlterarSenha: TRectangle;
    lytCabecalhoAlterarSenha: TLayout;
    imgMDVoltar: TImage;
    lblTituloAlteraSenha: TLabel;
    ScrollMeusDados: TVertScrollBox;
    lytMDFundo: TLayout;
    edtSenhaConfirmar: TEdit;
    recSalvar: TRectangle;
    lblMDSalvar: TLabel;
    edtSenha: TEdit;
    lblMDSenha: TLabel;
    lblMDEmail: TLabel;
    edtEmail: TEdit;
    lblSenhaConfirmar: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure recSalvarClick(Sender: TObject);
    procedure imgMDVoltarClick(Sender: TObject);
  private
    FLoading: TframeFundo;
    Dlg: TfrmMensagem;
    function CompararSenhas: Boolean;
    function VerificarCampos: Boolean;
    procedure LimparCampos;
  public
    { Public declarations }
  end;

var
  frmAlterarSenha: TfrmAlterarSenha;

implementation

{$R *.fmx}

function TfrmAlterarSenha.CompararSenhas: Boolean;
begin
  Result := False;
  if edtSenha.Text.Trim = edtSenhaConfirmar.Text.Trim then
  begin
    Result := True;
    Exit;
  end;

  FLoading.Exibir;
  Dlg.Mensagem('As senhas são diferentes!');
  Dlg.ShowModal(
  procedure(ModalResult: TModalResult)
  begin
    if Dlg.ModalResult = mrOk then
      FLoading.Fechar;
      Exit;
  end);
end;

procedure TfrmAlterarSenha.FormCreate(Sender: TObject);
begin
  FLoading := TframeFundo.Create(Self);
  Dlg := TfrmMensagem.Create(frmAlterarSenha);
  FLoading.Parent := Self;
end;

procedure TfrmAlterarSenha.FormDestroy(Sender: TObject);
begin
  FLoading.DisposeOf;
  Dlg.DisposeOf;
end;

procedure TfrmAlterarSenha.imgMDVoltarClick(Sender: TObject);
begin
  LimparCampos;
  Close;
end;

procedure TfrmAlterarSenha.LimparCampos;
begin
  edtSenha.Text := EmptyStr;
  edtSenhaConfirmar.Text := EmptyStr;
  edtEmail.Text := EmptyStr;
end;

procedure TfrmAlterarSenha.recSalvarClick(Sender: TObject);
begin
  if not VerificarCampos then
    Exit;
  if not CompararSenhas then
    Exit;

  FLoading.Exibir;
  if not DM1.AtualizarSenhaUsuario(edtEmail.Text.Trim, edtSenha.Text.Trim) then
  begin
    Dlg.Mensagem('Não foi possível alterar a senha do usuário!');
  end
  else
    Dlg.Mensagem('Senha Alterada com sucesso!');
  Dlg.ShowModal(
  procedure(ModalResult: TModalResult)
  begin
    if Dlg.ModalResult = mrOk then
      FLoading.Fechar;
      Exit;
  end);
  LimparCampos;
end;

function TfrmAlterarSenha.VerificarCampos: Boolean;
begin
  if (edtSenha.Text.Trim = EmptyStr)
   or (edtSenhaConfirmar.Text.Trim = EmptyStr)
   or (edtEmail.Text.Trim = EmptyStr)  then
  begin
    Result := False;
    FLoading.Exibir;
    Dlg.Mensagem('Preencha todas as informações!');
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        Exit;
    end);
  end;
  Result := True;
end;

end.
