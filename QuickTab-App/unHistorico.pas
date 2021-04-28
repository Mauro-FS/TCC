unit unHistorico;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TextLayout;

type
  TfrmHistorico = class(TForm)
    recFundoHistorico: TRectangle;
    lytCabecalhoHistorico: TLayout;
    imgHistorico: TImage;
    lblTituloHistorico: TLabel;
    lvwHistorico: TListView;
    procedure lvwHistoricoUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
  private
    { Private declarations }
  public
    procedure addItensHistorico;
  end;

var
  frmHistorico: TfrmHistorico;

implementation

{$R *.fmx}

function GetTextHeight(const D: TListItemText; const Width: single; const Text: string): Integer;
var
  Layout: TTextLayout;
begin
  // Create a TTextLayout to measure text dimensions
  Layout := TTextLayoutManager.DefaultTextLayout.Create;
  try
    Layout.BeginUpdate;
    try
      // Initialize layout parameters with those of the drawable
      Layout.Font.Assign(D.Font);
      Layout.VerticalAlign := D.TextVertAlign;
      Layout.HorizontalAlign := D.TextAlign;
      Layout.WordWrap := D.WordWrap;
      Layout.Trimming := D.Trimming;
      Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
      Layout.Text := Text;
    finally
      Layout.EndUpdate;
    end;
    // Get layout height
    Result := Round(Layout.Height);
    // Add one em to the height
    Layout.Text := 'm';
    Result := Result + Round(Layout.Height);
  finally
    Layout.Free;
  end;
end;


procedure TfrmHistorico.addItensHistorico;
var
  Item: TListViewItem;
  Imagem: TListItemImage;
  Bmp: TBitmap;
  Texto: TListItemText;
begin
  try
    //buscar do banco tb_historicoempresa
    lvwHistorico.BeginUpdate;
    Item := lvwHistorico.Items.Add;
    with Item do
    begin
      // adiconar rotina da imagem
      Texto := TListItemText(Objects.FindDrawable('Text1'));
//      Texto.Text := Titulo;
//      Texto := TListItemText(Objects.FindDrawable('Text4'));
//      Texto.Text := Descricao;
    end;
  finally
//     lvwHistorico.Items.Item[lvwHistorico.Items.Count - 1].TagString :=
//      StringReplace(TUtils.RemoverAcentos(Titulo), ' ', EmptyStr, [rfReplaceAll]);
     lvwHistorico.EndUpdate;
  end;
end;

procedure TfrmHistorico.lvwHistoricoUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  Bmp: TBitmap;
  Imagem: TListItemImage;
  Texto: TListItemText;
  AuxPos: Single;
begin
  try
    //ajustes nos posicionametos dos items da lista
    with AItem do
    begin
      Imagem := TListItemImage(Objects.FindDrawable('Image2'));
      Imagem.OwnsBitmap := True;
      Imagem.PlaceOffset.Y := 0;
      Imagem.Opacity := 0.8;
      Imagem.Height := 80;
      Imagem.Width := 40;

      Texto := TListItemText(Objects.FindDrawable('Text1'));
      Texto.PlaceOffset.Y := 0;
      Texto.WordWrap := True;
      Texto.Width := Width - Texto.PlaceOffset.X - 45;
      Texto.Height := GetTextHeight(Texto, Texto.Width, Texto.Text) + 3;
      AuxPos := Texto.Height;

      Texto := TListItemText(Objects.FindDrawable('Text4'));
      Texto.PlaceOffset.Y := AuxPos - 10;
      Texto.WordWrap := True;
      Texto.Width := Width - Texto.PlaceOffset.X - 45;
      Texto.Height := GetTextHeight(Texto, Texto.Width, Texto.Text) + 3;
    end;
  finally
  end;

end;

end.
