unit unFramePromocao;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts,
  unProdutoDetalhado, FMX.Effects;

type
  TframePromocao = class(TFrame)
    recPromocao: TRectangle;
    imgPromocao: TImage;
    lblProdPromocao: TLabel;
    lytInfoPromocao: TLayout;
    lblProdPrecoPromocao: TLabel;
    ShadowEffect1: TShadowEffect;
    procedure recPromocaoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TframePromocao.recPromocaoClick(Sender: TObject);
begin
  frmProdutoDetalhado.LimparInfo;
  frmProdutoDetalhado.CarregarProduto(1, imgPromocao.Bitmap);
end;

end.
