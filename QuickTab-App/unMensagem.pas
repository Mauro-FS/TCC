unit unMensagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts;

type
  TfrmMensagem = class(TForm)
    lytBotoes: TLayout;
    recCancelar: TRectangle;
    lblCancelar: TLabel;
    recAceitar: TRectangle;
    lblAceitar: TLabel;
    lytMensagem: TLayout;
    lblMensagem: TLabel;
    Layout1: TLayout;
    procedure recCancelarClick(Sender: TObject);
    procedure recAceitarClick(Sender: TObject);
  private
    Resultado: Boolean;
  public
    procedure Mensagem(Texto: String);
    procedure Confirmar(Texto: String);
    procedure AlinharForm;
  end;

var
  frmMensagem: TfrmMensagem;

implementation

{$R *.fmx}

{ TfrmMensagem }

procedure TfrmMensagem.AlinharForm;
begin
  Top := TForm(Owner).Top + Round((TForm(Owner).Height - Height) / 2) - 10;
  Left := TForm(Owner).Left + Round((TForm(Owner).Width - Width) / 2) + 7;
end;

procedure TfrmMensagem.Confirmar(Texto: String);
begin
  lblAceitar.Text := 'Sim';
  lblCancelar.Text := 'Não';
  lblMensagem.Text := Texto.Trim;
  recCancelar.Align := TAlignLayout.Left;
  recAceitar.Align := TAlignLayout.Right;
  AlinharForm;
end;

procedure TfrmMensagem.Mensagem(Texto: String);
begin
  Position := TFormPosition.OwnerFormCenter;
  lblAceitar.Text := 'OK';
  lblMensagem.Text := Texto.Trim;
  recAceitar.Align := TAlignLayout.Center;
  recCancelar.Visible := False;
  AlinharForm;
end;

procedure TfrmMensagem.recAceitarClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmMensagem.recCancelarClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
