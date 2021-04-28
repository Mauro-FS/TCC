unit unPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  uDWAbout, uRESTDWBase, FMX.Controls.Presentation, unDM1, System.Rtti,
  FMX.Grid.Style, FMX.Grid, FMX.ScrollBox, FMX.Objects, FMX.Layouts,
  FMX.TabControl, unFrameMesa, FireDAC.Comp.Client, Math, FMX.Printer,
  System.Generics.Collections, FMXDelphiZXingQRCode, Winsock, System.UIConsts,
  System.Threading, FMX.Memo, FMX.Edit, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView, FMX.Ani,
  Data.DB, unMensagem, unUtils, FMX.Effects, System.DateUtils, System.IOUtils;

type
  TfrmPrincipal = class(TForm)
    RESTServicePooler: TRESTServicePooler;
    TabControlPrincipal: TTabControl;
    TabMesas: TTabItem;
    TabProduto: TTabItem;
    TabQRCode: TTabItem;
    tabControlMesa: TTabControl;
    lytFundoMesa: TLayout;
    lytControleMesa: TLayout;
    recAdicionarMesa: TRectangle;
    lblAdicionarMesa: TLabel;
    recDesativarMesa: TRectangle;
    lblDesativarMesa: TLabel;
    recAtivarMesa: TRectangle;
    lblAtivarMesa: TLabel;
    recGerarQRCodeMesa: TRectangle;
    lblGerarQRCodeMesa: TLabel;
    imgQRCodeMesa: TImage;
    Layout3: TLayout;
    Rectangle5: TRectangle;
    Label5: TLabel;
    lytCabecalhoProdDetalhado: TLayout;
    lblGerarQRCode: TLabel;
    Layout5: TLayout;
    lblCadastroProdutos: TLabel;
    Layout6: TLayout;
    lblCadastroMesa: TLabel;
    Layout7: TLayout;
    Layout8: TLayout;
    recAdicionarProduto: TRectangle;
    Label6: TLabel;
    recDesativarProduto: TRectangle;
    Label7: TLabel;
    recAtivarProduto: TRectangle;
    Label8: TLabel;
    recAlterarProduto: TRectangle;
    Label9: TLabel;
    Layout9: TLayout;
    lblIDProduto: TLabel;
    edtProduto: TEdit;
    edtCategoria: TEdit;
    lblCategoriaProduto: TLabel;
    lblDescricao: TLabel;
    lblPrecoProduto: TLabel;
    edtPreco: TEdit;
    memoDescricao: TMemo;
    edtNomeProduto: TEdit;
    lblNomeProduto: TLabel;
    lvwProdutos: TListView;
    imgProduto: TImage;
    Layout10: TLayout;
    lblImagemProduto: TLabel;
    RectAnimation1: TRectAnimation;
    Rectangle6: TRectangle;
    Rectangle10: TRectangle;
    recPedidosRecebidos: TRectangle;
    Layout20: TLayout;
    Label22: TLabel;
    ShadowEffect1: TShadowEffect;
    TabControlLogin: TTabControl;
    TabConfig: TTabItem;
    Layout11: TLayout;
    Label12: TLabel;
    Layout12: TLayout;
    Layout14: TLayout;
    lblEndereco: TLabel;
    edtEndereco: TEdit;
    lblEstado: TLabel;
    lblCidade: TLabel;
    edtCidade: TEdit;
    edtEstado: TEdit;
    recSalvarConfiguracoes: TRectangle;
    Label16: TLabel;
    lblNomeEmpresa: TLabel;
    edtNomeEmpresa: TEdit;
    lblDistancia: TLabel;
    edtDistancia: TEdit;
    Layout13: TLayout;
    Layout15: TLayout;
    edtNumero: TEdit;
    lblNumero: TLabel;
    Layout16: TLayout;
    lblCEP: TLabel;
    edtCEP: TEdit;
    edtCNPJ: TEdit;
    lblCNPJ: TLabel;
    TabServidor: TTabItem;
    Layout17: TLayout;
    Label17: TLabel;
    Layout18: TLayout;
    Layout19: TLayout;
    recSalvarServidor: TRectangle;
    lblSalvarServidor: TLabel;
    lblIPServidor: TLabel;
    edtIPServidor: TEdit;
    edtPortaServidor: TEdit;
    lblPortaServidor: TLabel;
    Layout1: TLayout;
    Label1: TLabel;
    Switch: TSwitch;
    TabInicio: TTabItem;
    Image2: TImage;
    Label10: TLabel;
    recAcessar: TRectangle;
    Label14: TLabel;
    Label13: TLabel;
    TabAPP: TTabItem;
    lvwPedidosRecebidos: TListView;
    Rectangle1: TRectangle;
    lblGerenciarMesas: TLabel;
    lblConfigEstabelecimento: TLabel;
    lblConfigServidor: TLabel;
    lblGerenciarProdutos: TLabel;
    Layout21: TLayout;
    TabPedidos: TTabItem;
    lytDetalhesPedido: TLayout;
    lblDetalhesPedido: TLabel;
    lvwProdutosPedido: TListView;
    Layout22: TLayout;
    Timer1: TTimer;
    Rectangle2: TRectangle;
    Layout4: TLayout;
    Layout2: TLayout;
    recConfirmarPedido: TRectangle;
    lblConfirmarPedido: TLabel;
    recFinalizarPedido: TRectangle;
    lblFinalizarPedido: TLabel;
    recCancelarPedido: TRectangle;
    lblCancelarPedido: TLabel;
    recImprimirPedido: TRectangle;
    lblImprimirPedido: TLabel;
    Rectangle3: TRectangle;
    procedure SwitchSwitch(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ConectarBanco;
    procedure recAdicionarMesaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure recAtivarMesaClick(Sender: TObject);
    procedure recDesativarMesaClick(Sender: TObject);
    procedure recGerarQRCodeMesaClick(Sender: TObject);
    procedure Rectangle5Click(Sender: TObject);
    procedure recAcessarClick(Sender: TObject);
    procedure recAdicionarProdutoClick(Sender: TObject);
    procedure lblImagemProdutoClick(Sender: TObject);
    procedure lvwProdutosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure recAlterarProdutoClick(Sender: TObject);
    procedure recAtivarProdutoClick(Sender: TObject);
    procedure recDesativarProdutoClick(Sender: TObject);
    procedure recSairClick(Sender: TObject);
    procedure recSalvarConfiguracoesClick(Sender: TObject);
    procedure recSalvarServidorClick(Sender: TObject);
    procedure recSwitchClick(Sender: TObject);
    procedure lblGerenciarMesasClick(Sender: TObject);
    procedure lblGerenciarProdutosClick(Sender: TObject);
    procedure lblConfigEstabelecimentoClick(Sender: TObject);
    procedure lblConfigServidorClick(Sender: TObject);
    procedure lvwPedidosRecebidosItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Timer1Timer(Sender: TObject);
    procedure Label22Click(Sender: TObject);
    procedure recConfirmarPedidoClick(Sender: TObject);
    procedure recCancelarPedidoClick(Sender: TObject);
    procedure recFinalizarPedidoClick(Sender: TObject);
  private
    FIPLocal: String;
    FframeMesas: TObjectList<TframeMesa>;
    FMesaSelecionada: Integer;
    FProdutoSelecionado: TListViewItem;
    FAnimacao: TFloatAnimation;
    Dlg: TfrmMensagem;
    procedure QRCodeWin(imgQRCode: TImage; texto: string);
    procedure AnimarClick(Objeto: TObject);
    procedure FinalizaAnimacao(Sender: TObject);
  public
    procedure CriarMesas;
    function CriarAbaMesa: String;
    procedure SelecionarMesa(Mesa: Integer);
    procedure LimparCampos;
    procedure SetInfoServidor;
    procedure SetConfiguracoes;
    function GetIPLocal: String;
    function GetProdutos: Boolean;
    function VerificaCampos: Boolean;
    function VerificaCamposConfig: Boolean;
    function VerificaAbas: Boolean;
    function AdicionarPedido(Mesa, Status, ID: String): Boolean;
    function GetPedidos: Boolean;
    function ListarProdutosPedido: Boolean;
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

function TfrmPrincipal.AdicionarPedido(Mesa, Status, ID: String): Boolean;
var
  Item: TListViewItem;
  Texto: TListItemText;
begin
  Result := False;
  try
    lvwPedidosRecebidos.BeginUpdate;
    Item := lvwPedidosRecebidos.Items.Insert(0);
    with Item do
    begin
      Tag := ID.Trim.ToInteger;
      Texto := TListItemText(Objects.FindDrawable('Text1'));
      Texto.Text := 'Pedido ' + ID;
      Texto.TextColor := $FF404852;
      Texto := TListItemText(Objects.FindDrawable('Text2'));
      Texto.Text := 'Mesa ' + Mesa;
      Texto.TextColor := $FF404852;
      Texto := TListItemText(Objects.FindDrawable('Text3'));
      if Status = 'P' then
      begin
        Texto.Text := 'Pendente';
        Texto.TextColor := $FFB98D20;
      end
      else if Status = 'C'  then
      begin
        Texto.Text := 'Cancelado';
        Texto.TextColor := $FFEB5757;
      end
      else if Status = 'F'  then
      begin
        Texto.Text := 'Finalizado';
        Texto.TextColor := $FF227C22;
      end
      else if Status = 'A'  then
      begin
        Texto.Text := 'Em Preparo';
        Texto.TextColor := $FFB98D20;
      end;
    end;
  finally
    lvwPedidosRecebidos.EndUpdate;
    Result := True;
  end;
end;

procedure TfrmPrincipal.AnimarClick(Objeto: TObject);
begin
  if not Assigned(FAnimacao) then
    FAnimacao := TFloatAnimation.Create(Self);
  FAnimacao := TFloatAnimation.Create(nil);
  FAnimacao.Parent := TButton(Objeto);
  FAnimacao.StartValue := 1;
  FAnimacao.StopValue := 0.7;
  FAnimacao.Duration := 0.09;
  FAnimacao.Delay := 0;
  FAnimacao.AutoReverse := True;
  FAnimacao.PropertyName := 'Opacity';
  FAnimacao.AnimationType := TAnimationType.&In;
  FAnimacao.Interpolation := TInterpolationType.Linear;
  FAnimacao.OnFinish := FinalizaAnimacao;
  FAnimacao.Start;
end;

procedure TfrmPrincipal.FinalizaAnimacao(Sender: TObject);
begin
  if Assigned(FAnimacao) then
  begin
    FAnimacao.DisposeOf;
  end;
end;

function TfrmPrincipal.GetPedidos: Boolean;
var
  Item: TListViewItem;
  Texto: TListItemText;
  Qry: TFDQuery;
  I: Integer;
begin
  lvwPedidosRecebidos.Items.Clear;
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    with DM1 do
    begin
      if ListarPedidos(Qry) then
      begin
        Qry.First;
        lvwPedidosRecebidos.BeginUpdate;
        for I := 0 to Qry.RecordCount - 1 do
        begin
          if WithinPastHours(Now, Qry.FieldByName('dtaultalteracao').AsDateTime, 12) then
          begin
            Item := lvwPedidosRecebidos.Items.Add;
            with Item do
            begin
              Tag := Qry.FieldByName('seqpedido').AsInteger;
              TagString := Qry.FieldByName('status').AsString;
              Texto := TListItemText(Objects.FindDrawable('Text1'));
              Texto.Text := 'Pedido ' + Qry.FieldByName('Seqpedido').AsString;
              Texto := TListItemText(Objects.FindDrawable('Text2'));
              Texto.Text := 'Mesa ' + Qry.FieldByName('mesa').AsString;
              Texto := TListItemText(Objects.FindDrawable('Text3'));
              if Qry.FieldByName('status').AsString = 'P' then
              begin
                Texto.Text := 'Pendente';
                Texto.TextColor := $FFB98D20;
              end
              else if Qry.FieldByName('status').AsString = 'C'  then
              begin
                Texto.Text := 'Cancelado';
                Texto.TextColor := $FFEB5757;
              end
              else if Qry.FieldByName('status').AsString = 'F'  then
              begin
                Texto.Text := 'Finalizado';
                Texto.TextColor := $FF227C22;
              end
              else if Qry.FieldByName('status').AsString = 'A'  then
              begin
                Texto.Text := 'Em Preparo';
                Texto.TextColor := $FFB98D20;
              end;
            end;
          end;
          Qry.Next;
        end;
      end;
    end;
  finally
    lvwPedidosRecebidos.EndUpdate;
    Qry.DisposeOf;
    Result := True;
  end;
end;

function TfrmPrincipal.ListarProdutosPedido: Boolean;
var
  Item: TListViewItem;
  Texto: TListItemText;
  Qry: TFDQuery;
  I: Integer;
begin
  lvwProdutosPedido.Items.Clear;
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    with DM1 do
    begin
      if ListarProdutosPedido(Qry, lvwPedidosRecebidos.Selected.Tag.ToString) then
      begin
        Qry.First;
        lvwProdutosPedido.BeginUpdate;
        for I := 0 to Qry.RecordCount - 1 do
        begin

          Item := lvwProdutosPedido.Items.Add;
          with Item do
          begin
            Tag := Qry.FieldByName('seqpedidoitem').AsInteger;
            Texto := TListItemText(Objects.FindDrawable('Text1'));
            Texto.Text := 'Qtd ' + Qry.FieldByName('quantidade').AsString + ' X';
            Texto := TListItemText(Objects.FindDrawable('Text2'));
            Texto.Text := Qry.FieldByName('nome').AsString;
            Texto := TListItemText(Objects.FindDrawable('Text3'));
            Texto.Text := 'Obs: ' + Qry.FieldByName('observacao').AsString;
          end;

          Qry.Next;
        end;
        lvwProdutosPedido.EndUpdate;
      end;
    end;
  finally
    TabControlPrincipal.ActiveTab := TabPedidos;
    Qry.DisposeOf;
    Result := True;
  end;
end;

procedure TfrmPrincipal.ConectarBanco;
begin
  try
    DM1.conn.Params.Values['DriverID'] := 'SQLite';
    DM1.conn.Params.Values['Database'] :=  TDirectory.GetParent(GetCurrentDir) + PathDelim +  'db\banco.db';
    DM1.conn.Params.Values['User_Name'] := '';
    DM1.conn.Params.Values['Password'] := '';
    DM1.conn.Connected := true;
  except
    Dlg.Mensagem('Erro ao acessar o banco');
  end;
end;

function TfrmPrincipal.CriarAbaMesa: String;
var
  Tab: TTabItem;
  Grid: TGridLayout;
begin
  Result := EmptyStr;
  Tab := tabControlMesa.Add;
  Grid := TGridLayout.Create(tabControlMesa);
  Grid.Name := 'GridMesa' + tabControlMesa.TabCount.ToString;
  Grid.Align := TAlignLayout.Client;
  Grid.Margins.Left := 5;
  Grid.Margins.Right := 5;
  Grid.Margins.Bottom := 5;
  Grid.Margins.Top := 5;
  Padding.Left := 25;
  Padding.Top := 10;
  Grid.ItemHeight := 100;
  Grid.ItemWidth := 100;
  Grid.Orientation := TOrientation.Horizontal;
  Grid.Visible := True;
  Tab.Name := 'tabMesa' + tabControlMesa.TabCount.ToString;
  if tabControlMesa.TabCount = 1 then
    Tab.Text := 'Mesas 1-20'
  else if tabControlMesa.TabCount = 2 then
    Tab.Text := 'Mesas 21-40'
  else if tabControlMesa.TabCount = 3 then
    Tab.Text := 'Mesas 41-60'
  else if tabControlMesa.TabCount = 4 then
    Tab.Text := 'Mesas 61-80'
  else if tabControlMesa.TabCount = 5 then
    Tab.Text := 'Mesas 81-100';
  Tab.AddObject(Grid);
  Result := tabControlMesa.TabCount.ToString;
end;

procedure TfrmPrincipal.CriarMesas;
var
  LMesas : TFDQuery;
  I: Integer;
  Grid: TGridLayout;
begin
  try
    I := 0;
    LMesas := TFDQuery.Create(nil);
    if DM1.ObterMesas(LMesas) then
    begin
      LMesas.Active := True;
      if LMesas.RecordCount > 0 then
      begin
        LMesas.First;
        while not LMesas.Eof do
        begin
          if I < 20 then
          begin
            if I = 0 then
              CriarAbaMesa;
            Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa1'));
          end
          else if (I >= 20) and (I < 40) then
          begin
            if I = 20 then
              CriarAbaMesa;
            Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa2'));
          end
          else if (I >= 40) and (I < 60) then
          begin
            if I = 40 then
              CriarAbaMesa;
            Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa3'));
          end
          else if (I >= 60) and (I < 80) then
          begin
            if I = 60 then
              CriarAbaMesa;
            Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa4'));
          end
          else if (I >= 80) and (I < 100) then
          begin
            if I = 80 then
              CriarAbaMesa;
            Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa5'));
          end;

          FframeMesas.Add(TframeMesa.Create(Grid));
          FframeMesas.Items[I].Name := FframeMesas.Items[I].Name + I.ToString;
          FframeMesas.Items[I].Align := TAlignLayout.Center;
          FframeMesas.Items[I].lblNmrMesa.Text := LMesas.FieldByName('seqmesa').AsString;
          FframeMesas.Items[I].Tag := LMesas.FieldByName('seqmesa').AsInteger;
          Grid.AddObject(FframeMesas.Items[I]);

          if LMesas.FieldByName('status').AsString = 'I' then
            FframeMesas.Items[I].crcMesa.Fill.Color := $FFA6A5A5
          else
            FframeMesas.Items[I].crcMesa.Fill.Color := $FFEB5757;
          I := I + 1;
          LMesas.Next;
        end;
      end;
    end;
  finally
    LMesas.DisposeOf;
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FframeMesas := TObjectList<TframeMesa>.Create;
  FIPLocal := GetIPLocal;
  Dlg := TfrmMensagem.Create(frmPrincipal);
  Left:= Round((Screen.Width-Width) / 3 );
  Top:= Round((Screen.Height-Height) / 12 );
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  FframeMesas.Clear;
  FframeMesas.DisposeOf;
  lvwProdutos.Items.Clear;
  imgProduto := nil;
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  RESTServicePooler.ServerMethodClass := TDM1;
  RESTServicePooler.Active := Switch.IsChecked;

  ConectarBanco;
  CriarMesas;
  GetPedidos;
end;

function TfrmPrincipal.GetIPLocal: String;
type
  TaPInAddr = array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  Phe: PHostEnt;
  Pptr: PaPInAddr;
  Buffer: array [0..63] of Ansichar;
  I: Integer;
  GInitData: TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  Phe := GetHostByName(Buffer);
  if Phe = nil then
    Exit;
  Pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while Pptr^[i] <> nil do
  begin
    Result := StrPas(inet_ntoa(Pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

function TfrmPrincipal.GetProdutos: Boolean;
var
  Item: TListViewItem;
  Texto: TListItemText;
  Qry: TFDQuery;
  I: Integer;
begin
  lvwProdutos.Items.Clear;
  Result := False;
  Qry := TFDQuery.Create(nil);
  try
    with DM1 do
    begin
      if ListarProdutos(Qry) then
      begin
        Qry.First;
        lvwProdutos.BeginUpdate;
        for I := 0 to Qry.RecordCount - 1 do
        begin
          Item := lvwProdutos.Items.Add;
          with Item do
          begin
            Tag := Qry.FieldByName('seqproduto').AsInteger;
            TagString := Qry.FieldByName('status').AsString;
            Texto := TListItemText(Objects.FindDrawable('Text1'));
            Texto.Text := Qry.FieldByName('seqproduto').AsString;
            Texto := TListItemText(Objects.FindDrawable('Text2'));
            Texto.Text := Qry.FieldByName('nome').AsString;
            Texto := TListItemText(Objects.FindDrawable('Text3'));
            Texto.Text := Qry.FieldByName('categoria').AsString;
            Texto := TListItemText(Objects.FindDrawable('Text4'));
            Texto.Text :='R$' + FormatFloat('0.00', Qry.FieldByName('preco').AsFloat);
            Texto := TListItemText(Objects.FindDrawable('Text5'));
            if Qry.FieldByName('status').AsString = 'I' then
            begin
              Texto.Text := 'Inativo';
              Texto.TextColor := $FFB98D20
            end
            else
            begin
              Texto.Text := 'Ativo';
              Texto.TextColor := $FF227C22;
            end;
          end;
          Qry.Next;
        end;
         lvwProdutos.EndUpdate;
      end;
    end;
  finally
    Qry.DisposeOf;
    Result := True;
  end;
end;

procedure TfrmPrincipal.Label22Click(Sender: TObject);
begin
  AdicionarPedido('1', 'teste', 'aaaaaaa' );
end;

procedure TfrmPrincipal.lblConfigEstabelecimentoClick(Sender: TObject);
begin
  if VerificaAbas then
  begin
    SetConfiguracoes;
    TabControlPrincipal.ActiveTab := TabConfig;
  end;
end;

procedure TfrmPrincipal.lblConfigServidorClick(Sender: TObject);
begin
  if VerificaAbas then
  begin
    SetInfoServidor;
    TabControlPrincipal.ActiveTab := TabServidor;
  end;
end;

procedure TfrmPrincipal.lblGerenciarMesasClick(Sender: TObject);
begin
  if VerificaAbas then
  begin
    TabControlPrincipal.ActiveTab := TabMesas;
  end;
end;

procedure TfrmPrincipal.lblGerenciarProdutosClick(Sender: TObject);
begin
  if VerificaAbas then
  begin
    GetProdutos;
    TabControlPrincipal.ActiveTab := TabProduto;
  end;
end;

procedure TfrmPrincipal.lblImagemProdutoClick(Sender: TObject);
begin
  with TOpenDialog.Create(Self) do
    try
      Caption := 'Abrir Imagem';
      if Execute then
        imgProduto.Bitmap.LoadFromFile(FileName);
    finally
      DisposeOf;
    end;
end;

procedure TfrmPrincipal.LimparCampos;
begin
  FProdutoSelecionado := nil;
  lvwProdutos.Selected := nil;
  edtProduto.Text := EmptyStr;
  edtNomeProduto.Text := EmptyStr;
  edtCategoria.Text := EmptyStr;
  edtPreco.Text := EmptyStr;
  memoDescricao.Text := EmptyStr;
  imgProduto.Bitmap := nil;
end;

procedure TfrmPrincipal.lvwPedidosRecebidosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  ListarProdutosPedido;
end;

procedure TfrmPrincipal.lvwProdutosItemClick(const Sender: TObject;
  const AItem: TListViewItem);
var
  Qry: TFDQuery;
  Stream: TMemoryStream;
  Bmp: TBitmap;
begin
  if lvwProdutos.Selected = FProdutoSelecionado then
  begin
    LimparCampos;
  end
  else
  begin
    Qry := TFDQuery.Create(nil);
    Stream := TMemoryStream.Create;
    Bmp := TBitmap.Create;
    FProdutoSelecionado := TListViewItem(lvwProdutos.Selected);
    try
      with DM1 do
      begin
        Qry.SQL.Clear;
        if BuscarProduto(Qry, AItem.Tag) then
        begin
          edtProduto.Text := Qry.FieldByName('seqproduto').AsString;
          edtNomeProduto.Text := Qry.FieldByName('nome').AsString;
          edtCategoria.Text := Qry.FieldByName('categoria').AsString;
          edtPreco.Text := FormatFloat('0.00', Qry.FieldByName('preco').AsFloat);
          memoDescricao.Text := Qry.FieldByName('descricao').AsString;
          if not (Qry.FieldByName('imagem').AsString = '') then
          begin
            TBlobField(Qry.FieldByName('imagem')).SaveToStream(Stream);
            Bmp.LoadFromStream(Stream);
            imgProduto.Bitmap := Bmp;
          end
          else
            imgProduto.Bitmap := nil;
        end;
      end;
    finally
      Bmp.DisposeOf;
      Qry.DisposeOf;
      Stream.Clear;
      Stream.DisposeOf;
    end;
  end;
end;

procedure TfrmPrincipal.QRCodeWin(imgQRCode: TImage; texto: string);
var
  QRCode: TDelphiZXingQRCode;
  Row, Column: Integer;
  pixelColor : TAlphaColor;
  vBitMapData : TBitmapData;
begin
  imgQRCode.DisableInterpolation := true;
  imgQRCode.WrapMode := TImageWrapMode.iwStretch;

  QRCode := TDelphiZXingQRCode.Create;
  try
    QRCode.Data := texto;
    QRCode.Encoding := TQRCodeEncoding.qrAuto;
    QRCode.QuietZone := 4;
    imgQRCode.Bitmap.SetSize(QRCode.Rows, QRCode.Columns);

    for Row := 0 to QRCode.Rows - 1 do
    begin
      for Column := 0 to QRCode.Columns - 1 do
      begin
        if (QRCode.IsBlack[Row, Column]) then
          pixelColor := TAlphaColors.Black
        else
          pixelColor := TAlphaColors.White;

        if imgQRCode.Bitmap.Map(TMapAccess.maWrite, vBitMapData)  then
        try
          vBitMapData.SetPixel(Column, Row, pixelColor);
        finally
          imgQRCode.Bitmap.Unmap(vBitMapData);
        end;
      end;
    end;
  finally
    QRCode.Free;
  end;
end;

procedure TfrmPrincipal.recAdicionarMesaClick(Sender: TObject);
var
  LMesa: String;
  I: integer;
  Grid: TGridLayout;
begin
  AnimarClick(Sender);
  with DM1 do
  begin
    LMesa := AdicionarMesa;
    if not LMesa.IsEmpty then
    begin
      if LMesa.ToInteger < 20 then
      begin
        if LMesa.ToInteger = 0 then
          CriarAbaMesa;
        Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa1'));
      end
      else if (LMesa.ToInteger >= 20) and (LMesa.ToInteger < 40) then
      begin
        if LMesa.ToInteger = 20 then
          CriarAbaMesa;
        Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa2'));
      end
      else if (LMesa.ToInteger >= 40) and (LMesa.ToInteger < 60) then
      begin
        if LMesa.ToInteger = 40 then
          CriarAbaMesa;
        Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa3'));
      end
      else if (LMesa.ToInteger >= 60) and (LMesa.ToInteger < 80) then
      begin
        if LMesa.ToInteger = 60 then
          CriarAbaMesa;
        Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa4'));
      end
      else if (LMesa.ToInteger >= 80) and (LMesa.ToInteger < 100) then
      begin
        if LMesa.ToInteger = 80 then
          CriarAbaMesa;
        Grid := TGridLayout(tabControlMesa.FindComponent('GridMesa5'));
      end;

      FframeMesas.Add(TframeMesa.Create(Grid));
      FframeMesas.Items[LMesa.ToInteger - 1].Name := FframeMesas.Items[LMesa.ToInteger - 1].Name + LMesa;
      FframeMesas.Items[LMesa.ToInteger - 1].Align := TAlignLayout.Center;
      FframeMesas.Items[LMesa.ToInteger - 1].lblNmrMesa.Text := LMesa;
      FframeMesas.Items[LMesa.ToInteger - 1].Tag := StrToInt(TUtils.RemoveZeroEsquerda(LMesa));
      Grid.AddObject(FframeMesas.Items[LMesa.ToInteger - 1]);

      if ObterStatusMesa(LMesa) = 'I' then
        FframeMesas.Items[LMesa.ToInteger - 1].crcMesa.Fill.Color := $FFA6A5A5
      else
        FframeMesas.Items[LMesa.ToInteger - 1].crcMesa.Fill.Color := $FFEB5757;
    end;
  end;
end;

procedure TfrmPrincipal.recAdicionarProdutoClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if VerificaCampos then
  begin
    Dlg.Confirmar('Deseja adicionar o produto?');
    Dlg.Position := TFormPosition.OwnerFormCenter;
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
      with DM1 do
      begin
        if ModalResult = mrOK then
          if AdicionarProduto(edtNomeProduto.Text.Trim, edtCategoria.Text.Trim,
           edtPreco.Text.Trim, memoDescricao.Text.Trim, imgProduto) then
          begin
            lvwProdutos.Items.Clear;
            GetProdutos;
          end;
      end;
    end);
    Dlg.Close;
  end;
end;

procedure TfrmPrincipal.recAlterarProdutoClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if VerificaCampos then
  begin
    Dlg.Confirmar('Deseja alterar o produto?');
    Dlg.Position := TFormPosition.OwnerFormCenter;
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      with DM1 do
      begin
        if ModalResult = mrOK then
          if AlterarProduto(edtProduto.Text.Trim, edtNomeProduto.Text.Trim, edtCategoria.Text.Trim,
           edtPreco.Text.Trim, memoDescricao.Text.Trim, imgProduto) then
          begin
            lvwProdutos.Items.Clear;
            GetProdutos;
          end;
      end;
    end);
    Dlg.Close;
  end;
end;

procedure TfrmPrincipal.recAtivarMesaClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if FMesaSelecionada = 0 then
  begin
    Dlg.Mensagem('Nenhuma mesa selecionada');
    Exit;
  end;
  FframeMesas.Items[FMesaSelecionada - 1].AtivarMesa;
end;

procedure TfrmPrincipal.recAtivarProdutoClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if not edtProduto.Text.Trim.IsEmpty then
  begin
    Dlg.Confirmar('Deseja ativar o produto?');
    Dlg.Position := TFormPosition.OwnerFormCenter;
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      with DM1 do
      begin
        if ModalResult = mrOK then
          if AtivarProduto(edtProduto.Text.Trim) then
          begin
            lvwProdutos.Items.Clear;
            GetProdutos;
          end;
      end;
    end);
    Dlg.Close;
  end;
end;

procedure TfrmPrincipal.recCancelarPedidoClick(Sender: TObject);
begin
  AnimarClick(Sender);

  if lvwPedidosRecebidos.Selected.TagString = 'F' then
  begin
    Dlg.Mensagem('Não é possível cancelar pois o pedido já foi finalizado!');
    Exit;
  end;

  Dlg.Confirmar('Deseja cancelar o pedido?');
  Dlg.Position := TFormPosition.OwnerFormCenter;
  Dlg.ShowModal(
  procedure(ModalResult: TModalResult)
  begin
    if Dlg.ModalResult = mrOk then
    with DM1 do
    begin
      if ModalResult = mrOK then
        if AlterarStatusPedido('C', lvwPedidosRecebidos.Selected.Tag) then
        begin
          lvwPedidosRecebidos.Items.Clear;
          GetPedidos;
        end;
    end;
  end);
  Dlg.Close;
end;

procedure TfrmPrincipal.recConfirmarPedidoClick(Sender: TObject);
begin
  AnimarClick(Sender);
  // checar o selected antes de realizar a rotina
  if not (lvwPedidosRecebidos.Selected = nil) then
  begin
    if lvwPedidosRecebidos.Selected.TagString = 'P' then
    begin
      Dlg.Confirmar('Deseja confirmar o pedido?');
      Dlg.Position := TFormPosition.OwnerFormCenter;
      Dlg.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if Dlg.ModalResult = mrOk then
        with DM1 do
        begin
          if ModalResult = mrOK then
            if AlterarStatusPedido('A', lvwPedidosRecebidos.Selected.Tag) then
            begin
              lvwPedidosRecebidos.Items.Clear;
              GetPedidos;
            end;
        end;
      end);
      Dlg.Close;
    end
    else
    begin
      Dlg.Mensagem('Não é possível confirmar pois o status do pedido não é pendente!');
    end;
  end
  else
  begin
    Dlg.Mensagem('Selecione algum pedido!');
  end;
end;

procedure TfrmPrincipal.recDesativarMesaClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if FMesaSelecionada = 0 then
  begin
    Dlg.Mensagem('Nenhuma mesa selecionada');
    Exit;
  end;
  FframeMesas.Items[FMesaSelecionada - 1].DesativarMesa;
end;

procedure TfrmPrincipal.recDesativarProdutoClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if not edtProduto.Text.Trim.IsEmpty then
  begin
    Dlg.Confirmar('Deseja desativar o produto?');
    Dlg.Position := TFormPosition.OwnerFormCenter;
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      with DM1 do
      begin
        if ModalResult = mrOK then
          if DesativarProduto(edtProduto.Text.Trim) then
          begin
            lvwProdutos.Items.Clear;
            GetProdutos;
          end;
      end;
    end);
  end;
end;

procedure TfrmPrincipal.recFinalizarPedidoClick(Sender: TObject);
begin
  AnimarClick(Sender);

  if lvwPedidosRecebidos.Selected.TagString = 'C' then
  begin
    Dlg.Mensagem('Não é possível finalizar o pedido pois ele já foi cancelado!');
    Exit;
  end;

  Dlg.Confirmar('Deseja confirmar o pedido?');
  Dlg.Position := TFormPosition.OwnerFormCenter;
  Dlg.ShowModal(
  procedure(ModalResult: TModalResult)
  begin
    if Dlg.ModalResult = mrOk then
    with DM1 do
    begin
      if ModalResult = mrOK then
        if AlterarStatusPedido('F', lvwPedidosRecebidos.Selected.Tag) then
        begin
          lvwPedidosRecebidos.Items.Clear;
          GetPedidos;
        end;
    end;
  end);
  Dlg.Close;
end;

procedure TfrmPrincipal.recGerarQRCodeMesaClick(Sender: TObject);
var
  Texto: String;
  PortaServidor: String;
  Qry: TFDQuery;
begin
  AnimarClick(Sender);
  Qry := TFDQuery.Create(nil);
  try
    if DM1.BuscarInfoServidor(Qry) then
      PortaServidor := Qry.FieldByName('portaservidor').AsString
    else
    begin
      Dlg.Mensagem('Configure a porta do servidor antes de criar QRcodes');
      Exit;
    end;

    if FMesaSelecionada = 0 then
    begin
      Dlg.Mensagem('Nenhuma mesa selecionada');
      Exit;
    end;

    Texto := FIPLocal + ':' + PortaServidor + '|' + TUtils.AdicionarZeroEsquerda(FMesaSelecionada.ToString);
    QRCodeWin(imgQRCodeMesa, Texto);
    TabControlPrincipal.ActiveTab := TabQRCode;
  finally
    Qry.DisposeOf;
  end;
end;

procedure TfrmPrincipal.recSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmPrincipal.recSalvarConfiguracoesClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if VerificaCamposConfig then
  begin
    with DM1 do
    begin
      if ChecarConfiguracoes then
      begin
        if AtualizarConfiguracoes(edtNomeEmpresa.Text.Trim, edtCNPJ.Text.Trim, edtEndereco.Text.Trim, edtNumero.Text.Trim,
         edtCEP.Text.Trim, edtCidade.Text.Trim, edtEstado.Text.Trim, edtDistancia.Text.Trim) then
          Dlg.Mensagem('Informações atualizadas com sucesso');
      end
      else
      begin
        if AdicionarConfiguracoes(edtNomeEmpresa.Text.Trim, edtCNPJ.Text.Trim, edtEndereco.Text.Trim, edtNumero.Text.Trim,
         edtCEP.Text.Trim, edtCidade.Text.Trim, edtEstado.Text.Trim, edtDistancia.Text.Trim) then
          Dlg.Mensagem('Informações inseridas com sucesso');
      end;
    end;
  end;
end;

procedure TfrmPrincipal.recSalvarServidorClick(Sender: TObject);
begin
  AnimarClick(Sender);
  if DM1.ChecarConfiguracoes then
  begin
    if not edtPortaServidor.Text.IsEmpty then
    begin
      if DM1.AtualizarInfoServidor(edtPortaServidor.Text.Trim) then
        Dlg.Mensagem('Porta do servidor inserida com sucesso');
    end
    else
      Dlg.Mensagem('Insira a porta do servidor');
  end
  else
  begin
    Dlg.Mensagem('Configure as informações do estabelecimento antes do servidor');
    TabControlPrincipal.ActiveTab := TabConfig
  end;
end;

procedure TfrmPrincipal.recSwitchClick(Sender: TObject);
begin
  RESTServicePooler.Active := Switch.IsChecked;
  if Switch.IsChecked then
    Label1.Text := 'Servidor Ativo'
  else
    Label1.Text := 'Servidor Inativo';
end;

procedure TfrmPrincipal.recAcessarClick(Sender: TObject);
begin
  AnimarClick(Sender);
  TabControlLogin.ActiveTab := TabAPP;
  if DM1.ChecarConfiguracoes then
    TabControlPrincipal.ActiveTab := TabMesas
  else
    TabControlPrincipal.ActiveTab := TabConfig;
end;

procedure TfrmPrincipal.Rectangle5Click(Sender: TObject);
var
  SrcRect, DestRect: TRectF;
begin
  AnimarClick(Sender);
  { Set the default DPI for the printer. The SelectDPI routine defaults
    to the closest available resolution as reported by the driver. }

  TThread.CreateAnonymousThread( procedure
  begin
    Printer.ActivePrinter.SelectDPI(600, 600);

    { Set canvas filling style. }
    Printer.Canvas.Fill.Color := claBlack;
    Printer.Canvas.Fill.Kind := TBrushKind.Solid;

    { Start printing. }
    Printer.BeginDoc;

    { Set the Source and Destination TRects. }
    SrcRect := imgQRCodeMesa.LocalRect;
    DestRect := TRectF.Create(0, 0, Printer.PageWidth * 6, Printer.PageHeight * 4);

    { Print the picture, on all the surface of the page and all opaque. }
    Printer.Canvas.DrawBitmap(imgQRCodeMesa.Bitmap, SrcRect, DestRect, 1);

    { Finish the printing job. }
    Printer.EndDoc;
  end).Start;
end;

procedure TfrmPrincipal.SelecionarMesa(Mesa: Integer);
begin
  if (Mesa > 0) and (Mesa <> FMesaSelecionada) then
  begin
    if FMesaSelecionada > 0 then
      FframeMesas.Items[FMesaSelecionada - 1].imgSelecionado.Visible := False;
    FMesaSelecionada := Mesa;
    FframeMesas.Items[Mesa - 1].imgSelecionado.Visible := True;
  end
  else if Mesa = FMesaSelecionada then
  begin
    FframeMesas.Items[FMesaSelecionada - 1].imgSelecionado.Visible := False;
    FMesaSelecionada := 0;
  end;
end;

procedure TfrmPrincipal.SetConfiguracoes;
var
  Qry : TFDQuery;
begin
  Qry := TFDQuery.Create(nil);
  try
    with DM1 do
    begin
      if BuscarConfiguracoes(Qry) then
        edtNomeEmpresa.Text := Qry.FieldByName('nomeempresa').AsString;
        edtCNPJ.Text := Qry.FieldByName('cnpj').AsString;
        edtEndereco.Text := Qry.FieldByName('endereco').AsString;
        edtNumero.Text := Qry.FieldByName('numero').AsString;
        edtCEP.Text := Qry.FieldByName('cep').AsString;
        edtCidade.Text := Qry.FieldByName('cidade').AsString;
        edtEstado.Text := Qry.FieldByName('estado').AsString;
        edtDistancia.Text := Qry.FieldByName('distancia').AsString;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

procedure TfrmPrincipal.SetInfoServidor;
var
  Qry : TFDQuery;
begin
  edtIPServidor.Text := FIPLocal;
  Qry := TFDQuery.Create(nil);
  try
    with DM1 do
    begin
      if BuscarInfoServidor(Qry) then
        edtPortaServidor.Text := Qry.FieldByName('portaservidor').AsString;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

procedure TfrmPrincipal.SwitchSwitch(Sender: TObject);
begin
  RESTServicePooler.Active := Switch.IsChecked;
  if Switch.IsChecked then
    Label1.Text := 'Servidor Ativo'
  else
    Label1.Text := 'Servidor Inativo';
end;

procedure TfrmPrincipal.Timer1Timer(Sender: TObject);
begin
  if WithinPastHours(Now, Now, 12) then
  begin
    // atualizar a lista de pedidos a cada 1 hora removendo pedido antigos
  end;
end;

function TfrmPrincipal.VerificaAbas: Boolean;
begin
  Result := False;
  if TabControlPrincipal.ActiveTab = TabConfig then
    begin
    if not DM1.ChecarConfiguracoes then
    begin
      Dlg.Mensagem('Insira as informações do estabelecimento!');
      Exit;
    end;
  end;
  if TabControlPrincipal.ActiveTab = TabServidor then
  begin
    if not DM1.ChecarInfoServidor then
    begin
      Dlg.Mensagem('Insira as informações do servidor!');
      Exit;
    end;
  end;
  Result := True;
end;

function TfrmPrincipal.VerificaCampos: Boolean;
begin
  Result := False;
  if edtNomeProduto.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o nome do produto');
    Exit
  end;
  if memoDescricao.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha a descrição do produto');
    Exit
  end;
  if edtPreco.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o Preço do produto');
    Exit
  end;
  Result := True;
end;

function TfrmPrincipal.VerificaCamposConfig: Boolean;
begin
  Result := False;
  if edtNomeEmpresa.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o nome do estabelecimento');
    Exit
  end;
  if edtCNPJ.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o CNPJ do estabelecimento');
    Exit
  end;
  if edtEndereco .Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o endereço');
    Exit
  end;
  if edtNumero.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o número do endereço');
    Exit
  end;
  if edtCEP.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o CEP');
    Exit
  end;
  if edtCidade.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha cidade');
    Exit
  end;
  if edtEstado.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha o estado');
    Exit
  end;
  if edtDistancia.Text.Trim.IsEmpty then
  begin
    Dlg.Mensagem('Preencha a distância');
    Exit
  end;
  Result := True;
end;

end.
