unit unFrameQtdProduto;

interface

uses
  System.Types, System.UITypes, System.Classes, System.Variants, System.SysUtils,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts;

type
  TframeQtdProduto = class(TFrame)
    lytQtdProduto: TLayout;
    imgRemoveProduto: TImage;
    imgAddItem: TImage;
    lblVlrTotal: TLabel;
    lblQtdProduto: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
