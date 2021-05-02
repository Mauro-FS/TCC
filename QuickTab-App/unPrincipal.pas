unit unPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.StdCtrls, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.TextLayout, System.Permissions,
  unFrameCategoria, unFramePromocao, unProdutoDetalhado, unMeusDados,
  unOnboarding, unVenda, unFrameItemPedido, unFrameItemMenu, Utils, System.Threading,
  System.Generics.Collections, FMX.ListBox, FMX.Media, FMX.Platform,
  FMX.VirtualKeyboard, unCamera,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  MobilePermissions.Model.Signature, MobilePermissions.Model.Dangerous,
  MobilePermissions.Model.Standard, MobilePermissions.Component,
  {$ENDIF}
  ZXing.BarcodeFormat, ZXing.ReadResult, ZXing.ScanManager, FMX.DialogService,
  System.Sensors, System.Sensors.Components, unProduto, unMensagem,
  unFrameFundo;

type
  TfrmPrincipal = class(TForm)
    recFundoMenu: TRectangle;
    lblMenu: TLabel;
    tabControlPrincipal: TTabControl;
    tabMenu: TTabItem;
    ScrollCategorias: THorzScrollBox;
    lvwMenu: TListView;
    vsbMenu: TVertScrollBox;
    StyleBook1: TStyleBook;
    recNavegacao: TRectangle;
    imgMenu: TImage;
    imgPerfil: TImage;
    imgPedido: TImage;
    lblIcoPedido: TLabel;
    lblIcoPerfil: TLabel;
    lblIcoMenu: TLabel;
    tabPerfil: TTabItem;
    lvwPerfil: TListView;
    lytPerfilCabecalho: TLayout;
    Rectangle1: TRectangle;
    lblPerfilDados: TLabel;
    lblPerfilNome: TLabel;
    tabPedido: TTabItem;
    recFundoPedido: TRectangle;
    lytFundoTotalPedido: TLayout;
    lytAddProdDetalhado: TLayout;
    recEnviarPedido: TRectangle;
    lblAddProdDetalhado: TLabel;
    Layout2: TLayout;
    Layout1: TLayout;
    lblNomeProdDetalhado: TLabel;
    lblVlrTotPedido: TLabel;
    lblNroPedido: TLabel;
    lytTopoMenu: TLayout;
    imgQrCode: TImage;
    LocationSensor1: TLocationSensor;
    vsbPedido: TVertScrollBox;
    Label3: TLabel;
    TabBtnPedido: TTabControl;
    TabBtnFazerPedido: TTabItem;
    TabBtnPedidoFeito: TTabItem;
    recFinalizarPedido: TRectangle;
    lblFinalizarPedido: TLabel;
    recCancelarPedido: TRectangle;
    lblCancelarPedido: TLabel;
    lblNomeEmpresa: TLabel;
    procedure lvwMenuUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvwPerfilUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure lvwMenuItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure FormDestroy(Sender: TObject);
    procedure imgPerfilClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure lvwPerfilItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvwMenuScrollViewChange(Sender: TObject);
    procedure imgPedidoClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure imgQrCodeClick(Sender: TObject);
    procedure recEnviarPedidoClick(Sender: TObject);
  private
    FframeCategoriasProdutos: TObjectList<TframeCategoria>;
    FframeItensMenu: TObjectList<TframeItemMenu>;
    FframeProdutosPedido: TObjectList<TframeItemPedido>;
    procedure AjustarLayout;
    procedure AddProduto(NomeProduto, DescricaoProduto, PrecoProduto: String; ImgProduto: TStream);
    procedure AddItensPerfil(Titulo, Descricao: String);
    procedure MontarPedido;
    procedure CategoriaClick(Sender: TObject);
  public
    Dlg: TfrmMensagem;
    FLoading: TframeFundo;
    procedure CriarItemCardapio;
    procedure CriarCategorias;
    function ApagarCardapio: Boolean;
    function RemoverItemPedido(Index: integer): Boolean;
    function PedidoFeito: Boolean;
    function ResetarInterface: Boolean;
    function DescricaoCategoria(AValue: String): String;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  unDM1;

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

procedure TfrmPrincipal.AddItensPerfil(Titulo, Descricao: String);
var
  Item: TListViewItem;
  Bmp: TBitmap;
  Texto: TListItemText;
begin
  try
    lvwPerfil.BeginUpdate;
    Item := lvwPerfil.Items.Add;
    with Item do
    begin
      Texto := TListItemText(Objects.FindDrawable('Text1'));
      Texto.Text := Titulo;
      Texto := TListItemText(Objects.FindDrawable('Text4'));
      Texto.Text := Descricao;
    end;
  finally
     lvwPerfil.Items.Item[lvwPerfil.Items.Count - 1].TagString :=
      StringReplace(TUtils.RemoverAcentos(Titulo), ' ', EmptyStr, [rfReplaceAll]);
     lvwPerfil.EndUpdate;
  end;
end;

procedure TfrmPrincipal.AddProduto(NomeProduto, DescricaoProduto,
  PrecoProduto: String; ImgProduto: TStream);
var
  Item: TListViewItem;
  Imagem: TListItemImage;
  ImagemAdd: TListItemImage;
  Bmp: TBitmap;
  LBmp: TBitmap;
  Texto: TListItemText;
  Caminho: string;
begin
  try
    Item := lvwMenu.Items.Add;
    with Item do
    begin
      //carregar foto do produto
      Imagem := TListItemImage(Objects.FindDrawable('Image4'));
      Imagem.OwnsBitmap := True;

      Caminho := TUtils.CaminhoImagens + 'Produto.png';
      if ImgProduto <> nil then
      begin
        Bmp := TBitmap.Create;
        Bmp.LoadFromStream(ImgProduto);
        Imagem.Bitmap := Bmp;
      end
      else
      begin
        Bmp := TBitmap.Create;
        Bmp.LoadFromFile(Caminho);
        Imagem.Bitmap := Bmp;
      end;

      //Icone de adição
      Caminho := TUtils.CaminhoImagens + 'IconeAdd.png';
      LBmp := TBitmap.Create;
      LBmp.LoadFromFile(Caminho);
      ImagemAdd := TListItemImage(Objects.FindDrawable('Image5'));
      ImagemAdd.OwnsBitmap := True;
      ImagemAdd.Bitmap := LBmp;

      //Nome do produto;
      Texto := TListItemText(Objects.FindDrawable('Text1'));
      Texto.Text := NomeProduto;

      //Descricao do produto;
      Texto := TListItemText(Objects.FindDrawable('Text2'));
      Texto.Text := Copy(DescricaoProduto, 1, 37);

      //Preço do produto;
      Texto := TListItemText(Objects.FindDrawable('Text3'));
      Texto.Text := 'R$' + PrecoProduto;
    end;
  finally

  end;
end;

procedure TfrmPrincipal.AjustarLayout;
begin

end;

function TfrmPrincipal.ApagarCardapio: Boolean;
begin
  if Assigned(FframeCategoriasProdutos) then
    FframeCategoriasProdutos.DisposeOf;
  if Assigned(FframeItensMenu) then
    FframeItensMenu.DisposeOf;
  FframeCategoriasProdutos := TObjectList<TframeCategoria>.Create;
  FframeItensMenu := TObjectList<TframeItemMenu>.Create;
end;

procedure TfrmPrincipal.CategoriaClick(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 10 do
  begin
    if FframeItensMenu.Items[I].TagString = TframeCategoria(Sender).TagString then
    begin
      vsbMenu.ScrollBy(0, -FframeItensMenu.Items[I].Position.Y);
      Exit;
    end;
  end;

end;

procedure TfrmPrincipal.CriarCategorias;
var
  I: Integer;
  Categorias: TStringList;
begin
  Categorias := TStringList.Create;
  Venda.GetCategorias(Categorias);
  if Categorias.Count > 0 then
  begin
    with FframeCategoriasProdutos do
    begin
      for I := 0 to Categorias.Count - 1 do
      begin
        Add(TframeCategoria.Create(ScrollCategorias));
        Items[I].Name := Items[I].Name + I.ToString;
        Items[I].lblCategoria.Text :=  DescricaoCategoria(Categorias[I]);
        Items[I].Align := TAlignLayout.MostLeft;
        Items[I].TagString := Categorias[I];
        Items[I].OnClick := CategoriaClick;

       {$IF DEFINED(iOS) or DEFINED(ANDROID)}
        Items[I].imgCategoria.Bitmap.LoadFromFile(Path.Combine(TPath.GetDocumentsPath, Categorias[I] + '.png'));
       {$ELSE}
        Items[I].imgCategoria.Bitmap.LoadFromFile(TDirectory.GetParent(GetCurrentDir) + PathDelim + 'resources\imagens\' + Categorias[I] +'.png' );
       {$ENDIF}
        ScrollCategorias.AddObject(Items[I]);
      end;
    end;
  end;
  Categorias.Clear;
  FreeAndNil(Categorias);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  C: TControl;
  AppEventSvc: IFMXApplicationEventService;
begin
  Dlg := TfrmMensagem.Create(frmPrincipal);
  FLoading := TframeFundo.Create(Self);
  FLoading.Parent := Self;
  AddItensPerfil('Meus Dados', 'Minhas informações pessoais');
  AddItensPerfil('Histórico', 'Estabelecimentos já visitados');
  AddItensPerfil('Onboarding', 'Como usar o app');
  AddItensPerfil('Ajuda', 'Solicite um atendente');

  for C in lvwMenu.Controls do
    if C is TScrollBar then
      C.Width := 0;

  FframeCategoriasProdutos := TObjectList<TframeCategoria>.Create;
  FframeProdutosPedido := TObjectList<TframeItemPedido>.Create;
  FframeItensMenu := TObjectList<TframeItemMenu>.Create;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  ResetarInterface;
  FLoading.DisposeOf;
  Dlg.DisposeOf;
  FframeCategoriasProdutos.DisposeOf;
  FframeProdutosPedido.DisposeOf;
  FframeItensMenu.DisposeOf;
end;

procedure TfrmPrincipal.FormKeyUp(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
{$IFDEF ANDROID}
var
   FService : IFMXVirtualKeyboardService;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  if (Key = vkHardwareBack) then
  begin
    TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService, IInterface(FService));
    if (FService <> nil) and
     (TVirtualKeyboardState.Visible in FService.VirtualKeyBoardState) then
    begin
      // Botao back pressionado e teclado visivel apenas fecha o teclado
    end
    else
      Key := 0;
  end
  {$ENDIF}
end;

procedure TfrmPrincipal.imgMenuClick(Sender: TObject);
begin
  tabControlPrincipal.ActiveTab := tabMenu;
end;

procedure TfrmPrincipal.imgPedidoClick(Sender: TObject);
begin
  MontarPedido;
  tabControlPrincipal.ActiveTab := tabPedido;

  if DM1.VerificarPedidoAtivo then
  begin
    PedidoFeito;
    TabBtnPedido.ActiveTab := TabBtnPedidoFeito;
  end;
end;

procedure TfrmPrincipal.imgPerfilClick(Sender: TObject);
begin
  tabControlPrincipal.ActiveTab := tabPerfil;
end;

procedure TfrmPrincipal.imgQrCodeClick(Sender: TObject);
begin
{$IFDEF ANDROID}
  with frmCamera do
  begin
    Show;
    FecharCamera;
    AbrirCamera;
  end;
{$ELSE}
  Venda.BuscarCardapio('http://localhost:8082|001');
{$ENDIF}
end;

procedure TfrmPrincipal.lvwMenuItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  try

    if TListView(Sender).Selected <> nil then
    begin
      if ItemObject is TListItemImage then
      begin
        if TListItemImage(ItemObject).Name = 'Image5' then
        begin
          ShowMessage('Add');
        end;
      end
      else
      begin

        frmProdutoDetalhado.CarregarProduto(1,
         TListItemImage(lvwMenu.Selected.View.FindDrawable('Image4')).Bitmap);
      end;
    end;
  finally

  end;
end;

procedure TfrmPrincipal.lvwMenuScrollViewChange(Sender: TObject);
begin
  //testar android
  if (lvwMenu.ScrollViewPos >= 0) and (lvwMenu.ScrollViewPos <= 300) then
    vsbMenu.Touch.InteractiveGestures := [TInteractiveGesture.Pan]
  else
    vsbMenu.Touch.InteractiveGestures := [];
end;

procedure TfrmPrincipal.lvwMenuUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  Bmp: TBitmap;
  Imagem: TListItemImage;
  Texto: TListItemText;
  AuxPos: Single;
  AuxHItem: Integer;
begin
  try
    //ajustes nos posicionametos dos items da lista
    with AItem do
    begin
      Imagem := TListItemImage(Objects.FindDrawable('Image4'));
      Imagem.OwnsBitmap := True;
      Imagem.PlaceOffset.Y := 8;
      Imagem.Opacity := 0.8;
      Imagem.Height := 64;
      Imagem.Width := 65;

      Texto := TListItemText(Objects.FindDrawable('Text1'));
      Texto.PlaceOffset.Y := 11;
      Texto.WordWrap := True;
      Texto.Width := Width - Texto.PlaceOffset.X - 160;
      Texto.Height := GetTextHeight(Texto, Texto.Width, Texto.Text) + 3;
      AuxPos := Texto.Height;
      AuxHItem := Texto.Height.ToString.ToInteger;

      Texto := TListItemText(Objects.FindDrawable('Text2'));
      Texto.PlaceOffset.Y := AuxPos - 10;
      Texto.WordWrap := True;
      Texto.Width := Width - Texto.PlaceOffset.X - 170;
      Texto.Height := GetTextHeight(Texto, Texto.Width, Texto.Text) + 3;
      AuxHItem := AuxHItem + Texto.Height.ToString.ToInteger - 8;

      Texto := TListItemText(Objects.FindDrawable('Text3'));
      Texto.PlaceOffset.Y := 11 + Trunc(AuxPos / 2 );
      Texto.Height := 24;

      Imagem := TListItemImage(Objects.FindDrawable('Image5'));
      Imagem.OwnsBitmap := True;
      Imagem.PlaceOffset.Y := 11 + Texto.Height + 20;
      Imagem.Opacity := 0.8;
      Imagem.Height := 19;
      Imagem.Width := 19;

      Height := AuxHItem;
    end;
  finally
  end;
end;

procedure TfrmPrincipal.lvwPerfilItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  Mensagem: String;
begin
  if AItem.TagString = 'MeusDados' then
  begin
    frmMeusDados.Show;
  end
  else
  if AItem.TagString = 'Onboarding' then
  begin
    frmOnboarding.Show;
  end
  else
  if AItem.TagString = 'Ajuda' then
  begin
    if DM1.SolicitarAtendente(Mensagem, Venda.Pedido.Mesa.ToString ) then
    // enviar solicitação de atendente no servidor, se ok exibir um toast
  end;

end;


procedure TfrmPrincipal.lvwPerfilUpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  Texto: TListItemText;
  AuxPos: Single;
begin
  try
    //ajustes nos posicionametos dos items da lista
    with AItem do
    begin
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

procedure TfrmPrincipal.CriarItemCardapio;
var
  I: Integer;
begin
  lvwMenu.Visible := False;
  for I := 0 to Venda.ProdutosCardapio.Count - 1 do
  begin
    with FframeItensMenu do
    begin
      Add(TframeItemMenu.Create(vsbMenu));
      Items[I].Name := Items[I].Name + I.ToString;
      Items[I].Align := TAlignLayout.None;
      Items[I].Position.Y := 2000 + I;
      Items[I].Align := TAlignLayout.Top;
      Items[I].TagString := Venda.ProdutosCardapio.Items[I].Categoria;
      Items[I].imgProduto.Bitmap.LoadFromStream(Venda.ProdutosCardapio.Items[I].Imagem);
      Items[I].lblNomeProduto.Text := Venda.ProdutosCardapio.Items[I].Nome;
      Items[I].lblDescricaoProduto.Text := Venda.ProdutosCardapio.Items[I].Descricao;
      Items[I].lblPrecoProduto.Text := 'R$' + FormatFloat('0.00', Venda.ProdutosCardapio.Items[I].Preco);
      Items[I].Tag := I;
      Items[I].TagFloat := Venda.ProdutosCardapio.Items[I].IDProduto;

      vsbMenu.AddObject(FframeItensMenu.Items[I]);
    end;
  //    AddProduto('prod', 'testetestetestetestetestetestetestetesteteste',' 99,99', nil);
  end;
  lvwMenu.Height := vsbMenu.Height + 700;
end;

function TfrmPrincipal.DescricaoCategoria(AValue: String): String;
var
  DescCategoria: String;
begin
  DescCategoria := EmptyStr;
  if AValue = 'catPrato' then
    DescCategoria := 'Pratos';
  if AValue = 'catBurguer' then
    DescCategoria := 'Lanches';
  if AValue = 'catPizza' then
    DescCategoria := 'Pizzas';
  if AValue = 'catFrutosDoMar' then
    DescCategoria := 'Frutos do Mar';
  if AValue = 'catEntrada' then
    DescCategoria := 'Entradas';
  if AValue = 'catBebida' then
    DescCategoria := 'Bebidas';
  if AValue = 'catDrink' then
    DescCategoria := 'Drinks';
  if AValue = 'catCafe' then
    DescCategoria := 'Cafés';
  if AValue = 'catChocolate' then
    DescCategoria := 'Chocolates';
  if AValue = 'catSopa' then
    DescCategoria := 'Sopas';
  if AValue = 'catTaco' then
    DescCategoria := 'Tacos';
  if AValue = 'catEspeto' then
    DescCategoria := 'Espetos';
  if AValue = 'catFrango' then
    DescCategoria := 'Frangos';
  if AValue = 'catMacarrao' then
    DescCategoria := 'Macarrão';
  if AValue = 'catPadaria' then
    DescCategoria := 'Lanches';
  if AValue = 'catPanqueca' then
    DescCategoria := 'Panquecas';
  if DescCategoria = EmptyStr then
    DescCategoria := 'Pratos';

  Result := DescCategoria;
end;

procedure TfrmPrincipal.MontarPedido;
var
  I: Integer;
begin
  if Venda.Pedido.ListaProdutos.Count > 0 then
  begin
    vsbPedido.BeginUpdate;
    for I := 0 to Venda.Pedido.ListaProdutos.Count - 1 do
      begin
      if (FframeProdutosPedido.Count - 1) < I then
      begin
      with FframeProdutosPedido do
      begin
        Add(TframeItemPedido.Create(vsbPedido));
        Items[I].Name := Items[I].Name + I.ToString;
        Items[I].Align := TAlignLayout.None;
        Items[I].Position.Y := 2000 + I;
        Items[I].Align := TAlignLayout.Top;
        Items[I].Tag := I;
        Items[I].imgProduto.Bitmap.LoadFromStream(Venda.Pedido.ListaProdutos.Items[I].Imagem);
        Items[I].lblQtdProduto.Text := Venda.Pedido.ListaProdutos.Items[I].Quantidade.ToString;
        Items[I].lblNomeProduto.Text:= Venda.Pedido.ListaProdutos.Items[I].Nome;
        Items[I].lblPrecoProduto.Text := FormatFloat('0.00', Venda.Pedido.ListaProdutos.Items[I].Quantidade
         * Venda.Pedido.ListaProdutos.Items[I].VlrTotal);
        vsbPedido.AddObject(Items[I]);
//        lytFundoPedido.Height := lytFundoPedido.Height + Items[I].Height + 500;
        lytFundoTotalPedido.Align := TAlignLayout.None;
        lytFundoTotalPedido.Position.Y := 40000 + I;
        lytFundoTotalPedido.Align := TAlignLayout.Top;
      end;
      end;
    end;
    vsbPedido.EndUpdate;
  end;
end;

function TfrmPrincipal.PedidoFeito: Boolean;
var
  I : Integer;
begin
  for I := 0 to FframeProdutosPedido.Count -1 do
  begin
    FframeProdutosPedido.Items[I].lytQtdProduto.Visible := False;
  end;
end;

procedure TfrmPrincipal.recEnviarPedidoClick(Sender: TObject);
var
  Erro: String;
  NroPedido: String;
begin
  // enviar para o servidor e salvar o pedido no banco
//  if not (DM1.CriarPedido(Erro, NroPedido))then
//  begin
//    ShowMessage(Erro);
//    Exit;
//  end;
  FLoading.Exibir;
  if not Venda.AdicionarPedido(Erro, NroPedido) then
  begin
    Dlg.Mensagem(Erro);
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        Exit;
    end);
    Exit;
  end;
  PedidoFeito;
  lblNroPedido.Text := 'Nro. Pedido: ' + NroPedido;
  lblVlrTotPedido.Text := 'R$' + FormatFloat('0.00', Venda.Pedido.GetTotalPedido);
  TabBtnPedido.ActiveTab := TabBtnPedidoFeito;
end;

function TfrmPrincipal.RemoverItemPedido(Index: integer): Boolean;
var
  I,a: Integer;
begin
  a := FframeProdutosPedido.Count;
  FframeProdutosPedido.ExtractAt(Index);

  for I := 0 to FframeProdutosPedido.Count - 1 do
  begin
    FframeProdutosPedido.Items[I].Tag := I;
  end;
end;

function TfrmPrincipal.ResetarInterface: Boolean;
var
  I: Integer;
begin
  lblNroPedido.Text := 'Nro. Pedido: ';
  lblVlrTotPedido.Text := '0,00';
  TabBtnPedido.ActiveTab := TabBtnFazerPedido;
  tabControlPrincipal.ActiveTab := tabPedido;

  FframeCategoriasProdutos.Clear;
  FframeProdutosPedido.Clear;
  FframeItensMenu.Clear;
end;

end.
