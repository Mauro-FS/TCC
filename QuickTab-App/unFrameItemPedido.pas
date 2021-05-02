unit unFrameItemPedido;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.Effects, unVenda;

type
  TframeItemPedido = class(TFrame)
    recFundo: TRectangle;
    ShadowEffect1: TShadowEffect;
    imgProduto: TImage;
    lytQtdProduto: TLayout;
    imgRemoveItem: TImage;
    imgAddItem: TImage;
    lblQtdProduto: TLabel;
    Layout1: TLayout;
    Layout2: TLayout;
    lblNomeProduto: TLabel;
    lblPrecoProduto: TLabel;
    imgDeletarProduto: TImage;
    procedure imgRemoveItemClick(Sender: TObject);
    procedure imgAddItemClick(Sender: TObject);
    procedure imgDeletarProdutoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  unPrincipal;

{$R *.fmx}

procedure TframeItemPedido.imgAddItemClick(Sender: TObject);
begin
  with Venda do
  begin
    if Pedido.AdicionarProduto(Self.Tag) then
    begin
      Venda.AtualizarTotalPedido;
      lblQtdProduto.Text := IntToStr(lblQtdProduto.Text.ToInteger + 1);
    end;
  end;
end;

procedure TframeItemPedido.imgDeletarProdutoClick(Sender: TObject);
begin
  with Venda do
  begin
    if Pedido.DeletarProduto(Self.Tag) then
    begin
      Venda.AtualizarTotalPedido;
      Self.DisposeOf;
    end;
  end;
end;

procedure TframeItemPedido.imgRemoveItemClick(Sender: TObject);
begin
  with Venda do
  begin
    if Pedido.RemoverQtdProduto(Self.Tag) then
    begin
      lblQtdProduto.Text := IntToStr(lblQtdProduto.Text.ToInteger - 1);

      if lblQtdProduto.Text.ToInteger = 0 then
      begin
        if Pedido.DeletarProduto(Self.Tag) then
        begin
          frmPrincipal.RemoverItemPedido(Self.Tag);
          Self.Release;
        end;

      end;
      Venda.AtualizarTotalPedido;
    end;
  end;
end;

end.
