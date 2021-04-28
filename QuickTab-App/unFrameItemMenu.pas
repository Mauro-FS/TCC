unit unFrameItemMenu;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Effects, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,
  unProdutoDetalhado, unVenda, unToast;

type
  TframeItemMenu = class(TFrame)
    recFundo: TRectangle;
    imgProduto: TImage;
    Layout1: TLayout;
    Layout2: TLayout;
    lblNomeProduto: TLabel;
    lblDescricaoProduto: TLabel;
    ShadowEffect1: TShadowEffect;
    Layout3: TLayout;
    lblPrecoProduto: TLabel;
    imgAddProduto: TImage;
    procedure FrameClick(Sender: TObject);
    procedure imgAddProdutoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses
  unPrincipal, unPedido;

{$R *.fmx}

procedure TframeItemMenu.FrameClick(Sender: TObject);
begin
  frmProdutoDetalhado.CarregarProduto(Self.Tag, imgProduto.Bitmap);
end;

procedure TframeItemMenu.imgAddProdutoClick(Sender: TObject);
begin
  if not Assigned(Venda.Pedido) then
    Venda.Pedido := TPedido.Create;
  if Venda.Pedido.AdicionarProduto(Self.Tag) then
    TToast.ToastMessage(frmPrincipal, 'Produto Adicionado');
end;

end.
