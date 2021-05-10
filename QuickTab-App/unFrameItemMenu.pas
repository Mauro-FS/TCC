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
  private
    function AddProduto: Boolean;
  public
    {$IFDEF ANDROID}
    procedure imgAddProdutoClick(Sender: TObject; const Point: TPointF);
    procedure FrameClick(Sender: TObject; const Point: TPointF);
    {$ELSE}
    procedure imgAddProdutoClick(Sender: TObject);
    procedure FrameClick(Sender: TObject);
    {$ENDIF}
  end;

implementation

uses
  unPrincipal, unPedido;

{$R *.fmx}

function TframeItemMenu.AddProduto: Boolean;
begin
  if not Assigned(Venda.Pedido) then
    Venda.Pedido := TPedido.Create;
  if Venda.Pedido.AdicionarProduto(Self.Tag) then
  begin
    Venda.AtualizarTotalPedido;
    TToast.ToastMessage(frmPrincipal, 'Produto Adicionado');
  end;
end;

{$IFDEF ANDROID}
procedure TframeItemMenu.FrameClick(Sender: TObject; const Point: TPointF);
begin
  frmProdutoDetalhado.CarregarProduto(Self.Tag, imgProduto.Bitmap);
end;

procedure TframeItemMenu.imgAddProdutoClick(Sender: TObject;
  const Point: TPointF);
begin
  AddProduto;
end;
{$ELSE}
procedure TframeItemMenu.imgAddProdutoClick(Sender: TObject);
begin
  AddProduto;
end;

procedure TframeItemMenu.FrameClick(Sender: TObject);
begin
  frmProdutoDetalhado.CarregarProduto(Self.Tag, imgProduto.Bitmap);
end;

{$ENDIF}

end.
