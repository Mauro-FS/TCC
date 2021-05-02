unit unMeusDados;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, unDM1,
  FireDAC.Comp.Client, Utils, unMensagem, unFrameFundo;

type
  TfrmMeusDados = class(TForm)
    recFundoMeusDados: TRectangle;
    lytCabecalhoMeusDados: TLayout;
    imgMDVoltar: TImage;
    lblTituloMeusDados: TLabel;
    ScrollMeusDados: TVertScrollBox;
    lytMDFundo: TLayout;
    lblMDUsuario: TLabel;
    edtMDUsuario: TEdit;
    recMDSalvar: TRectangle;
    lblMDSalvar: TLabel;
    edtMDSenha: TEdit;
    lblMDSenha: TLabel;
    lblMDEmail: TLabel;
    lblMDCPF: TLabel;
    edtMDEmail: TEdit;
    edtMDCPF: TEdit;
    procedure imgMDVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure recMDSalvarClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    Dlg: TfrmMensagem;
    FLoading: TframeFundo;
    procedure LimparCampos;
    function ValidarCampos: Boolean;
  public

  end;

var
  frmMeusDados: TfrmMeusDados;

implementation

{$R *.fmx}

procedure TfrmMeusDados.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  LimparCampos;
end;

procedure TfrmMeusDados.FormCreate(Sender: TObject);
begin
  Dlg := TfrmMensagem.Create(Self);
  FLoading := TframeFundo.Create(Self);
  FLoading.Parent := Self;
end;

procedure TfrmMeusDados.FormDestroy(Sender: TObject);
begin
  FLoading.DisposeOf;
  Dlg.DisposeOf;
end;

procedure TfrmMeusDados.FormShow(Sender: TObject);
var
  Qry: TFDQuery;
begin
  LimparCampos;
  Qry := TFDQuery.Create(nil);
  if DM1.ObterInfoUsuario(Qry) then
  begin
    edtMDUsuario.Text := Qry.FieldByName('nome').AsString;
    edtMDCPF.Text := Qry.FieldByName('cpf').AsString;
    edtMDEmail.Text := Qry.FieldByName('email').AsString;
    edtMDSenha.Text := Qry.FieldByName('senha').AsString;
  end;
end;

procedure TfrmMeusDados.imgMDVoltarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMeusDados.LimparCampos;
begin
  edtMDUsuario.Text := EmptyStr;
  edtMDCPF.Text := EmptyStr;
  edtMDEmail.Text := EmptyStr;
  edtMDSenha.Text := EmptyStr;
end;

procedure TfrmMeusDados.recMDSalvarClick(Sender: TObject);
begin
  if ValidarCampos then
  begin
    if not TUtils.ValidarEmail(edtMDEmail.Text.Trim) then
    begin
      FLoading.Exibir;
      Dlg.Mensagem('Email inválido');
      Dlg.ShowModal(
        procedure(ModalResult: TModalResult)
        begin
          if Dlg.ModalResult = mrOk then
            FLoading.Fechar;
        end);
    end;
  end;
end;

function TfrmMeusDados.ValidarCampos: Boolean;
begin
  Result := True;

  if ((edtMDUsuario.Text.Trim.IsEmpty)
   or (edtMDCPF.Text.Trim.IsEmpty)
   or (edtMDEmail.Text.Trim.IsEmpty)
   or (edtMDSenha.Text.Trim.IsEmpty)) then
  begin
    Result := False;
    FLoading.Exibir;
    Dlg.Mensagem('Preencha todos os campos!');
    Dlg.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if Dlg.ModalResult = mrOk then
          FLoading.Fechar;
      end);
  end;

end;

end.
