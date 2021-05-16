unit unObservacao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  unDM1, unVenda, unPedido, unProduto;

type
  TfrmObservacao = class(TForm)
    recFundoObservacao: TRectangle;
    lytCabecalhoObservacao: TLayout;
    imgObservacaoVoltar: TImage;
    lblTituloObservacao: TLabel;
    memoObservacao: TMemo;
    recObservacao: TRectangle;
    lblObservacao: TLabel;
    procedure FormShow(Sender: TObject);
  private
    {$IFDEF ANDROID}
    procedure imgObservacaoVoltarClick(Sender: TObject; const Point: TPointF);
    procedure recObservacaoClick(Sender: TObject; const Point: TPointF);
    {$ELSE}
    procedure imgObservacaoVoltarClick(Sender: TObject);
    procedure recObservacaoClick(Sender: TObject);
    {$ENDIF}
  public
    FObervacao: String;
  end;

var
  frmObservacao: TfrmObservacao;
  function AbrirObservacao(Observacao: String): String;

implementation

{$R *.fmx}

function AbrirObservacao(Observacao: String): String;
begin
  if not Assigned(frmObservacao) then
    frmObservacao := TfrmObservacao.Create(nil);
  frmObservacao.memoObservacao.Lines.Clear;
  if not Observacao.IsEmpty then
  begin
    frmObservacao.memoObservacao.Lines.Text := Observacao;
  end;
  {$IFDEF ANDROID}
  frmObservacao.imgObservacaoVoltar.OnTap := frmObservacao.imgObservacaoVoltarClick;
  frmObservacao.recObservacao.OnTap := frmObservacao.recObservacaoClick;
  {$ELSE}
  frmObservacao.imgObservacaoVoltar.OnClick := frmObservacao.imgObservacaoVoltarClick;
  frmObservacao.recObservacao.OnClick := frmObservacao.recObservacaoClick;
  {$ENDIF}
  frmObservacao.ShowModal(
  procedure(ModalResult: TModalResult)
  begin
    frmObservacao.Close;
  end);
  Result := frmObservacao.memoObservacao.Lines.Text.Trim;
end;

procedure TfrmObservacao.FormShow(Sender: TObject);
begin
  memoObservacao.SetFocus;
end;

{$IFDEF ANDROID}
procedure TfrmObservacao.imgObservacaoVoltarClick(Sender: TObject; const Point: TPointF);
begin
  FObervacao := frmObservacao.memoObservacao.Lines.Text.Trim;
  Self.Close;
end;
procedure TfrmObservacao.recObservacaoClick(Sender: TObject; const Point: TPointF);
begin
  FObervacao := frmObservacao.memoObservacao.Lines.Text.Trim;
  Self.Close;
end;
{$ELSE}
procedure TfrmObservacao.imgObservacaoVoltarClick(Sender: TObject);
begin
  FObervacao := frmObservacao.memoObservacao.Lines.Text.Trim;
  Self.Close;
end;
procedure TfrmObservacao.recObservacaoClick(Sender: TObject);
begin
  FObervacao := frmObservacao.memoObservacao.Lines.Text.Trim;
  Self.Close;
end;
{$ENDIF}

end.
