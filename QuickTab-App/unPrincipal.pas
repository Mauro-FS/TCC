unit unPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.MultiView, FMX.Objects, FMX.Layouts,
  FMX.TabControl, FMX.StdCtrls, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, FMX.TextLayout, System.Permissions,
  unFrameCategoria, unFramePromocao, unProdutoDetalhado, unMeusDados,
  unOnboarding, unVenda, unFrameItemMenu, Utils, System.Threading,
  System.Generics.Collections, FMX.ListBox, FMX.Media, FMX.Platform,
  FMX.VirtualKeyboard, unCamera,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
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
    Label3: TLabel;
    TabBtnPedido: TTabControl;
    TabBtnFazerPedido: TTabItem;
    TabBtnPedidoFeito: TTabItem;
    recFinalizarPedido: TRectangle;
    lblFinalizarPedido: TLabel;
    recCancelarPedido: TRectangle;
    lblCancelarPedido: TLabel;
    lblNomeEmpresa: TLabel;
    Layout3: TLayout;
    lvwPedido: TListView;
    Layout4: TLayout;
    lblStatusPedido: TLabel;
    TimerStatusPedido: TTimer;
    Layout5: TLayout;
    lblCardapioPlaceHolder: TLabel;
    procedure lvwMenuUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvwPerfilUpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure FormCreate(Sender: TObject);
    procedure lvwMenuItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure FormDestroy(Sender: TObject);
    procedure lvwPerfilItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure lvwMenuScrollViewChange(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
    procedure lvwPedidoItemClickEx(const Sender: TObject; ItemIndex: Integer;
      const LocalClickPos: TPointF; const ItemObject: TListItemDrawable);
    procedure TimerStatusPedidoTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FframeCategoriasProdutos: TObjectList<TframeCategoria>;
    FframeItensMenu: TObjectList<TframeItemMenu>;
    procedure AjustarLayout;
    procedure AddProduto(NomeProduto, DescricaoProduto, PrecoProduto: String; ImgProduto: TStream);
    procedure AddItensPerfil(Titulo, Descricao: String);
    procedure MontarPedido;
    procedure CategoriaClick(Sender: TObject);
    {$IFDEF ANDROID}
    procedure imgPerfilClick(Sender: TObject; const Point: TPointF);
    procedure imgMenuClick(Sender: TObject; const Point: TPointF);
    procedure imgPedidoClick(Sender: TObject; const Point: TPointF);
    procedure imgQrCodeClick(Sender: TObject; const Point: TPointF);
    procedure recCancelarPedidoClick(Sender: TObject; const Point: TPointF);
    procedure AtualizarPedidoClick(Sender: TObject; const Point: TPointF);
    procedure FinalizarPedidoClick(Sender: TObject; const Point: TPointF);
    procedure recEnviarPedidoClick(Sender: TObject; const Point: TPointF);
    {$ELSE}
    procedure imgPerfilClick(Sender: TObject);
    procedure imgMenuClick(Sender: TObject);
    procedure imgPedidoClick(Sender: TObject);
    procedure imgQrCodeClick(Sender: TObject);
    procedure recCancelarPedidoClick(Sender: TObject);
    procedure AtualizarPedidoClick(Sender: TObject);
    procedure FinalizarPedidoClick(Sender: TObject);
    procedure recEnviarPedidoClick(Sender: TObject);
    {$ENDIF}
  public
    Dlg: TfrmMensagem;
    FLoading: TframeFundo;
    procedure CriarItemCardapio;
    procedure CriarCategorias;
    function ApagarCardapio: Boolean;
    function RemoverItemPedido(Index: integer): Boolean;
    function PedidoFinalizado: Boolean;
    function PedidoCancelado: Boolean;
    function ResetarInterface: Boolean;
    function DescricaoCategoria(AValue: String): String;
    function AddItemPedido(Quantidade, Nome, Valor: String): Boolean;
    function NovosItensPedido: Boolean;
    function ClickOuTap: Boolean;
    procedure CancelarPedido;
    procedure AtualizarPedido;
    procedure FinalizarPedido;
    procedure EnviarPedido;
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

function TfrmPrincipal.AddItemPedido(Quantidade, Nome, Valor: String): Boolean;
var
  Item: TListViewItem;
  Bmp: TBitmap;
  Texto: TListItemText;
  Img: TListItemImage;
begin
  Bmp := TBitmap.Create;
  try
    lvwPedido.BeginUpdate;
    Item := lvwPedido.Items.Add;
    with Item do
    begin
      Texto := TListItemText(Objects.FindDrawable('Text1'));
      Texto.Text := Quantidade + ' X ';
      Texto := TListItemText(Objects.FindDrawable('Text2'));
      Texto.Text := Nome;
      Texto := TListItemText(Objects.FindDrawable('Text3'));
      Texto.Text := Valor;
      Img := TListItemImage(Objects.FindDrawable('Image4'));
    {$IF DEFINED(iOS) or DEFINED(ANDROID)}
      Bmp.LoadFromFile(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, 'Fechar.png'));
    {$ELSE}
      Bmp.LoadFromFile(TDirectory.GetParent(GetCurrentDir) + PathDelim +  'resources\imagens\Fechar.png');
    {$ENDIF}

      Img.Bitmap := Bmp;
      Img.OwnsBitmap := True;
    end;

  finally
    lvwPedido.EndUpdate;
  end;
end;

function TfrmPrincipal.PedidoCancelado: Boolean;
begin
  lblStatusPedido.Text := 'Status';
  lblNroPedido.Text := 'Nro. Pedido';
  lblVlrTotPedido.Text := 'R$0,00';
  TabBtnPedido.ActiveTab := TabBtnFazerPedido;
  tabControlPrincipal.ActiveTab := tabMenu;
  TimerStatusPedido.Enabled := False;
end;

function TfrmPrincipal.PedidoFinalizado: Boolean;
begin
  lblNroPedido.Text := 'Nro. Pedido';
  lblVlrTotPedido.Text := 'R$0,00';
  lblStatusPedido.Text := 'Status';
  TabBtnPedido.ActiveTab := TabBtnFazerPedido;
  frmPrincipal.lblCardapioPlaceHolder.Visible := True;
  lblNomeEmpresa.Text := EmptyStr;
  lvwPedido.Items.Clear;
  FLoading.Fechar;
  FLoading.Exibir;
  TimerStatusPedido.Enabled := False;
  Dlg.Mensagem('Pedido Finalizado!');
  Dlg.ShowModal(
  procedure(ModalResult: TModalResult)
  begin
  if Dlg.ModalResult = mrOk then
  begin
    tabControlPrincipal.ActiveTab := tabMenu;
    FLoading.Fechar;
  end;
  end);

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
  {$ZEROBASEDSTRINGS OFF}
  for I := 0 to 10 do
  begin
    if FframeItensMenu.Items[I].TagString = TframeCategoria(Sender).TagString then
    begin
      vsbMenu.ScrollBy(0, -FframeItensMenu.Items[I].Position.Y);
      Exit;
    end;
  end;

end;

function TfrmPrincipal.ClickOuTap: Boolean;
begin
  {$IFDEF ANDROID}
    recEnviarPedido.OnTap := recEnviarPedidoClick;
    recCancelarPedido.OnTap := recCancelarPedidoClick;
    imgQrCode.OnTap := imgQrCodeClick;
    imgPedido.OnTap := imgPedidoClick;
    imgPerfil.OnTap := imgPerfilClick;
    imgMenu.OnTap := imgMenuClick;
  {$ELSE}
    recEnviarPedido.OnClick := recEnviarPedidoClick;
    recCancelarPedido.OnClick := recCancelarPedidoClick;
    imgQrCode.OnClick := imgQrCodeClick;
    imgPedido.OnClick := imgPedidoClick;
    imgPerfil.OnClick := imgPerfilClick;
    imgMenu.OnClick := imgMenuClick;
  {$ENDIF}
end;

procedure TfrmPrincipal.CriarCategorias;
var
  I: Integer;
  Categorias: TStringList;
begin
  {$ZEROBASEDSTRINGS OFF}
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
        Items[I].imgCategoria.Bitmap.LoadFromFile(System.IOUtils.TPath.Combine(System.IOUtils.TPath.GetDocumentsPath, Categorias[I] + '.png'));
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

{$IFDEF ANDROID}

procedure TfrmPrincipal.FinalizarPedidoClick(Sender: TObject;
  const Point: TPointF);
begin
  FinalizarPedido;
end;

procedure TfrmPrincipal.imgMenuClick(Sender: TObject; const Point: TPointF);
begin
  tabControlPrincipal.ActiveTab := tabMenu;
  TimerStatusPedido.Enabled := False;
end;

procedure TfrmPrincipal.imgPedidoClick(Sender: TObject; const Point: TPointF);
begin
  MontarPedido;
  tabControlPrincipal.ActiveTab := tabPedido;
  NovosItensPedido;
  if DM1.VerificarPedidoAtivo then
  begin
    TabBtnPedido.ActiveTab := TabBtnPedidoFeito;
    Venda.AtualizarStatusPedido;
    TimerStatusPedido.Enabled := True;
    NovosItensPedido;
  end;
end;

procedure TfrmPrincipal.imgPerfilClick(Sender: TObject; const Point: TPointF);
begin
  tabControlPrincipal.ActiveTab := tabPerfil;
  TimerStatusPedido.Enabled := False;
end;

procedure TfrmPrincipal.imgQrCodeClick(Sender: TObject; const Point: TPointF);
begin
  with frmCamera do
  begin
    if FecharCamera then
     if AbrirCamera then
       Show;
  end;
end;

procedure TfrmPrincipal.recCancelarPedidoClick(Sender: TObject;
  const Point: TPointF);
begin
  CancelarPedido;
end;

procedure TfrmPrincipal.recEnviarPedidoClick(Sender: TObject;
  const Point: TPointF);
begin
  EnviarPedido;
end;

procedure TfrmPrincipal.AtualizarPedidoClick(Sender: TObject;
  const Point: TPointF);
begin
  AtualizarPedido;
end;

{$ELSE}
procedure TfrmPrincipal.imgMenuClick(Sender: TObject);
begin
  tabControlPrincipal.ActiveTab := tabMenu;
  TimerStatusPedido.Enabled := False;
end;

procedure TfrmPrincipal.imgPedidoClick(Sender: TObject);
begin
  MontarPedido;
  tabControlPrincipal.ActiveTab := tabPedido;
  NovosItensPedido;
  if DM1.VerificarPedidoAtivo then
  begin
    TabBtnPedido.ActiveTab := TabBtnPedidoFeito;
    Venda.AtualizarStatusPedido;
    TimerStatusPedido.Enabled := True;
    NovosItensPedido;
  end;
end;

procedure TfrmPrincipal.imgPerfilClick(Sender: TObject);
begin
  tabControlPrincipal.ActiveTab := tabPerfil;
  TimerStatusPedido.Enabled := False;
end;

procedure TfrmPrincipal.imgQrCodeClick(Sender: TObject);
begin
  Venda.BuscarCardapio('localhost:8082|001');
end;

procedure TfrmPrincipal.recCancelarPedidoClick(Sender: TObject);
begin
  CancelarPedido;
end;

procedure TfrmPrincipal.recEnviarPedidoClick(Sender: TObject);
begin
  EnviarPedido;
end;

procedure TfrmPrincipal.AtualizarPedidoClick(Sender: TObject);
begin
  AtualizarPedido;
end;

procedure TfrmPrincipal.FinalizarPedidoClick(Sender: TObject);
begin
  FinalizarPedido;
end;
{$ENDIF}


procedure TfrmPrincipal.AtualizarPedido;
var
  Erro: String;
begin
  FLoading.Exibir('Atualizando o Pedido');

  TThread.CreateAnonymousThread(procedure
  begin
    try
      if not Venda.AtualizarPedido(Erro) then
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          Dlg.Mensagem(Erro);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
              FLoading.Fechar;
          end);
        end);
      end
      else
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          lblVlrTotPedido.Text := 'R$' + FormatFloat('0.00', Venda.Pedido.GetTotalPedido);
          Venda.AtualizarStatusPedido;
          FLoading.Fechar;
        end);
      end;
    except
    on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          FLoading.Exibir;
          Dlg.Mensagem(E.Message);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
              FLoading.Fechar;
          end);
        end);
      end;
    end;
  end).Start;
end;

procedure TfrmPrincipal.EnviarPedido;
var
  Erro: String;
  NroPedido: String;
begin
  {$ZEROBASEDSTRINGS OFF}
  TimerStatusPedido.Enabled := False;
  if lvwPedido.Items.Count = 0 then
  begin
    FLoading.Exibir;
    Dlg.Mensagem('Adicione itens ao pedido antes de fazer o pedido!');
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
    end);
    Exit;
  end;

  FLoading.Fechar;
  FLoading.Exibir('Fazendo o Pedido');

  TThread.CreateAnonymousThread(procedure
  begin
    try
      if not Venda.AdicionarPedido(Erro, NroPedido) then
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Exibir;
          Dlg.Mensagem(Erro);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
            begin
              FLoading.Fechar;
              TimerStatusPedido.Enabled := True;
            end;
          end);
        end);
      end
      else
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          lblNroPedido.Text := 'Nro. Pedido: ' + NroPedido;
          lblVlrTotPedido.Text := 'R$' + FormatFloat('0.00', Venda.Pedido.GetTotalPedido);
          Venda.AtualizarStatusPedido;
          TabBtnPedido.ActiveTab := TabBtnPedidoFeito;
          TimerStatusPedido.Enabled := True;
          FLoading.Fechar;
        end);
      end;
    except
    on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          FLoading.Exibir;
          Dlg.Mensagem(E.Message);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
            begin
              FLoading.Fechar;
              TimerStatusPedido.Enabled := True;
            end;
          end);
        end);
      end;
    end;
  end).Start;
end;

procedure TfrmPrincipal.FinalizarPedido;
var
  Erro: String;
begin
  FLoading.Fechar;
  FLoading.Exibir('Finalizando o Pedido');
  TimerStatusPedido.Enabled := False;
  TThread.CreateAnonymousThread(procedure
  begin
    try
      if not Venda.FinalizarPedido(Erro) then
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          Dlg.Mensagem(Erro);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
            begin
              FLoading.Fechar;
              TimerStatusPedido.Enabled := True;
            end;
          end);
        end);
      end
      else
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          PedidoFinalizado;
          Dlg.Mensagem('Pedido Finalizado, aguarde a sua conta');
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
            begin
              FLoading.Fechar;
              TimerStatusPedido.Enabled := False;
            end;
          end);
          ResetarInterface;
        end);
      end;
    except
    on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          FLoading.Exibir;
          Dlg.Mensagem(E.Message);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
              FLoading.Fechar;
          end);
        end);
      end;
    end;
  end).Start;
end;

procedure TfrmPrincipal.CancelarPedido;
var
  Erro: String;
begin
  TimerStatusPedido.Enabled := False;
  FLoading.Exibir('Cancelando o Pedido');
  TThread.CreateAnonymousThread(procedure
  begin
    try
      if not Venda.CancelarPedido(Erro) then
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          Dlg.Mensagem(Erro);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
            begin
              FLoading.Fechar;
              TimerStatusPedido.Enabled := True;
            end;
          end);
        end);
      end
      else
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          PedidoCancelado;
          FLoading.Fechar;
        end);
      end;
    except
    on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          FLoading.Exibir;
          Dlg.Mensagem(E.Message);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
            begin
              FLoading.Fechar;
              TimerStatusPedido.Enabled := True;
            end;
          end);
        end);
      end;
    end;
  end).Start;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
var
  C: TControl;
  AppEventSvc: IFMXApplicationEventService;
begin
  {$ZEROBASEDSTRINGS OFF}
  Dlg := TfrmMensagem.Create(frmPrincipal);
  FLoading := TframeFundo.Create(Self);
  FLoading.Parent := Self;
  AddItensPerfil('Meus Dados', 'Minhas informações pessoais');
  AddItensPerfil('Onboarding', 'Como usar o app');
  AddItensPerfil('Ajuda', 'Solicite um atendente');

  for C in lvwMenu.Controls do
    if C is TScrollBar then
      C.Width := 0;

  FframeCategoriasProdutos := TObjectList<TframeCategoria>.Create;
  FframeItensMenu := TObjectList<TframeItemMenu>.Create;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  ResetarInterface;
  FreeAndNil(FLoading);
  FreeAndNil(Dlg);
  if Assigned(FframeCategoriasProdutos) then
    FreeAndNil(FframeCategoriasProdutos);
  if Assigned(FframeItensMenu) then
    FreeAndNil(FframeItensMenu);
//  FframeCategoriasProdutos.DisposeOf;
//  FframeItensMenu.DisposeOf;
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

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin

  FLoading.Fechar;

  TThread.CreateAnonymousThread(procedure
  begin
    try
      if Venda.RecuperarVenda then
      begin
        Sleep(100);
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.AtualizarMensagem('Recuperando Pedido');
        end);
        TThread.Synchronize(TThread.CurrentThread,
        procedure
        begin
          CriarItemCardapio;
          CriarCategorias;
          MontarPedido;
        end);
        Sleep(100);
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          frmCamera.PermissaoCamera;
        end);
      end
      else
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          frmCamera.PermissaoCamera;
        end);
      end;
    except
    on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          FLoading.Fechar;
          FLoading.Exibir;
          Dlg.Mensagem(E.Message);
          Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if Dlg.ModalResult = mrOk then
              FLoading.Fechar;
          end);
        end);
      end;
    end;
  end).Start;
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

procedure TfrmPrincipal.lvwPedidoItemClickEx(const Sender: TObject;
  ItemIndex: Integer; const LocalClickPos: TPointF;
  const ItemObject: TListItemDrawable);
begin
  if ItemObject.Name = 'Image4' then
  begin
    with Venda do
    begin
      if Pedido.DeletarProduto(ItemIndex) then
      begin
        lvwPedido.Items.Delete(ItemIndex);
        Venda.AtualizarTotalPedido;
      end;
    end;
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
  {$ZEROBASEDSTRINGS OFF}
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
      {$IFDEF ANDROID}
      Items[I].OnTap := Items[I].FrameClick;
      Items[I].imgAddProduto.OnTap := Items[I].imgAddProdutoClick;
      {$ELSE}
      Items[I].OnClick := Items[I].FrameClick;
      Items[I].imgAddProduto.OnClick := Items[I].imgAddProdutoClick;
      {$ENDIF}

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
  try
    {$ZEROBASEDSTRINGS OFF}
    lvwPedido.Items.Clear;
    lvwPedido.BeginUpdate;

    for I := 0 to Venda.Pedido.ListaProdutos.Count - 1 do
    begin
      AddItemPedido(Venda.Pedido.ListaProdutos.Items[I].Quantidade.ToString,
       Venda.Pedido.ListaProdutos.Items[I].Nome,
       FormatFloat('0.00', Venda.Pedido.ListaProdutos.Items[I].VlrTotal));
    end;
  finally
    lvwPedido.EndUpdate;
  end;
end;

function TfrmPrincipal.NovosItensPedido: Boolean;
var
  QtdPedido: Integer;
  Erro: String;
begin
  Result := False;
  if DM1.VerificarQtdItensPedido(Venda.Pedido.IDPedido, QtdPedido, Erro) then
  begin
    if Venda.Pedido.ListaProdutos.Count > QtdPedido then
    begin
      lblFinalizarPedido.Text := 'Atualizar';
      {$IFDEF ANDROID}
      recFinalizarPedido.OnTap := AtualizarPedidoClick;
      {$ELSE}
      recFinalizarPedido.OnClick := AtualizarPedidoClick;
      {$ENDIF}
    end
    else
    begin
      lblFinalizarPedido.Text := 'Finalizar';
      {$IFDEF ANDROID}
      recFinalizarPedido.OnTap := FinalizarPedidoClick;
      {$ELSE}
      recFinalizarPedido.OnClick := FinalizarPedidoClick;
      {$ENDIF}
    end;
  end;

end;

function TfrmPrincipal.RemoverItemPedido(Index: integer): Boolean;
begin

end;

function TfrmPrincipal.ResetarInterface: Boolean;
var
  I: Integer;
begin
  lblNroPedido.Text := 'Nro. Pedido: ';
  lblVlrTotPedido.Text := '0,00';
  TabBtnPedido.ActiveTab := TabBtnFazerPedido;
  tabControlPrincipal.ActiveTab := tabMenu;

  FframeCategoriasProdutos.Clear;
  FframeItensMenu.Clear;
end;

procedure TfrmPrincipal.TimerStatusPedidoTimer(Sender: TObject);
begin
  try
    Venda.AtualizarStatusPedido;
  except
    frmPrincipal.TimerStatusPedido.Enabled := False;
  end;
end;

end.
