unit unMensagem;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Effects;

type
  TfrmMensagem = class(TForm)
    lblMensagem: TLabel;
    lytMensagem: TLayout;
    lytBotoes: TLayout;
    recCancelar: TRectangle;
    lblCancelar: TLabel;
    recAceitar: TRectangle;
    lblAceitar: TLabel;
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
  Top := TForm(Owner).Top + Round(TForm(Owner).Height / 2) - 40;
  Left := TForm(Owner).Left  + Round(TForm(Owner).Width / 2) - 40;
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
  ShowModal;
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
