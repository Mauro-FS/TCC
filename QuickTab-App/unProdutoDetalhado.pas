unit unProdutoDetalhado;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  System.Generics.Collections, unVenda, unToast;

type
  TfrmProdutoDetalhado = class(TForm)
    lytCabecalhoProdDetalhado: TLayout;
    recFundoProdDetalhado: TRectangle;
    imgPDVoltar: TImage;
    lblTituloProdDetalhado: TLabel;
    ScrollProdutoDetalhado: TVertScrollBox;
    imgProdDetalhado: TImage;
    lytImgProdDetalhado: TLayout;
    lytDescProdDetalhado: TLayout;
    lblNomeProdDetalhado: TLabel;
    lblDescProdDetalhado: TLabel;
    recLAddProdDetalhado: TRectangle;
    lblAddProdDetalhado: TLabel;
    lytAddProdDetalhado: TLayout;
    lytFundoQtd: TLayout;
    lytQtdProduto: TLayout;
    imgRemoveProduto: TImage;
    imgAddItem: TImage;
    lblQtdProduto: TLabel;
    Layout2: TLayout;
    lblVlrTotal: TLabel;
    lytFundoProd: TLayout;
    procedure imgPDVoltarClick(Sender: TObject);
    procedure imgAddItemClick(Sender: TObject);
    procedure imgRemoveProdutoClick(Sender: TObject);
    procedure recLAddProdDetalhadoClick(Sender: TObject);
  private
    FIdProduto: Integer;
    function Calcular: Currency;
  public
    procedure CarregarProduto(IdProduto: Integer; ImagemProduto: TBitmap);
    procedure LimparInfo;
  end;

var
  frmProdutoDetalhado: TfrmProdutoDetalhado;

implementation

uses
  unPrincipal, unPedido;

{$R *.fmx}

function TfrmProdutoDetalhado.Calcular: Currency;
begin
  Result :=  lblQtdProduto.Tag * Venda.ProdutosCardapio.Items[FIdProduto].VlrTotal;
end;

procedure TfrmProdutoDetalhado.CarregarProduto(IdProduto: Integer;
  ImagemProduto: TBitmap);
begin
  LimparInfo;
  FIdProduto := IdProduto;
  imgProdDetalhado.Bitmap := ImagemProduto;
  lblNomeProdDetalhado.Text := Venda.ProdutosCardapio.Items[FIdProduto].Nome;
  lblDescProdDetalhado.Text := Venda.ProdutosCardapio.Items[FIdProduto].Descricao;
  lblQtdProduto.Text := '1';
  lblVlrTotal.Text := 'R$' + FormatFloat('0.00', Venda.ProdutosCardapio.Items[IdProduto].VlrTotal);
  Self.Show;
end;

procedure TfrmProdutoDetalhado.imgPDVoltarClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmProdutoDetalhado.imgAddItemClick(Sender: TObject);
begin
  lblQtdProduto.Tag := StrToint(lblQtdProduto.Text.Trim);
  lblQtdProduto.Tag := lblQtdProduto.Tag + 1;
  lblQtdProduto.Text := lblQtdProduto.Tag.ToString;
  lblVlrTotal.Text := 'R$' + FormatFloat('0.00', Calcular);
end;

procedure TfrmProdutoDetalhado.imgRemoveProdutoClick(Sender: TObject);
begin
  lblQtdProduto.Tag := StrToint(lblQtdProduto.Text.Trim);
  if lblQtdProduto.Tag > 1 then
  begin
    lblQtdProduto.Tag := lblQtdProduto.Tag - 1;
    lblQtdProduto.Text := lblQtdProduto.Tag.ToString;
  end;
  lblVlrTotal.Text := 'R$' + FormatFloat('0.00', Calcular);
end;

procedure TfrmProdutoDetalhado.LimparInfo;
var
  I: Integer;
begin
  lblDescProdDetalhado.Text := EmptyStr;
  imgProdDetalhado.Bitmap := nil;
  lblVlrTotal.Text := 'R$0,00';
  lblVlrTotal.Tag := 0;
  lblVlrTotal.TagFloat := 0;
  lblQtdProduto.Tag := 1;
  lblQtdProduto.TagFloat := 1;
  lblQtdProduto.Text := '1';
end;

procedure TfrmProdutoDetalhado.recLAddProdDetalhadoClick(Sender: TObject);
begin
  if not Assigned(Venda.Pedido) then
    Venda.Pedido := TPedido.Create;
  if Venda.Pedido.AdicionarProduto(FIdProduto, lblQtdProduto.Tag) then
  begin
    Venda.AtualizarTotalPedido;
    TToast.ToastMessage(frmPrincipal, 'Produto Adicionado');
    Self.Close;
  end;
end;

end.
