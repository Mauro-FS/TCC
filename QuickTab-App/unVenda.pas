unit unVenda;

interface

uses
  System.SysUtils, System.Types, System.Generics.Collections, System.Classes, System.Variants,
   FMX.Graphics, unProduto, unPedido, Utils, unDM1, FMX.DialogService,
   FMX.Platform, System.JSON, FMX.Dialogs, System.NetEncoding,
  FireDAC.Comp.Client;

type
  TVenda = class(TObject)
  private
    FMesa: String;
    FPedido: TPedido;
    FProdutosCardapio: TObjectList<TProduto>;
    ASyncService : IFMXDialogServiceASync;
    function GetPedido: TPedido;
    procedure SetPedido(Avalue: TPedido);
    function GetProdutosCardapio: TObjectList<TProduto>;
    procedure SetProdutosCardapio(Avalue: TObjectList<TProduto>);
  public
    constructor Create;
    destructor Destroy; override;
    property Mesa: String read FMesa write FMesa;
    property Pedido: TPedido read GetPedido write SetPedido;
    property ProdutosCardapio: TObjectList<TProduto> read GetProdutosCardapio write SetProdutosCardapio;
    function Acessar(out Erro: String; Email, Senha: String; Lembrar: Boolean): Boolean;
    function Cadastrar(out Erro: String; Nome, Senha, Email, CPF: String): Boolean;    
    function VerificarStatusPedido: Boolean;
    function BuscarIDUltimoPedido: Integer;    
    function AtualizarStatusPedido: Boolean;
    function GetCategorias(out ListaCategorias: TStringList): Boolean;
    function BuscarCardapio(QRCode: String): Boolean;
    function RecuperarVenda: Boolean;
    function RecuperarPedido: Boolean;
    function CriarCardapio(Cardapio: TJSONArray): Boolean;
    function ApagarCardapioAtual: Boolean;
    function ApagarPedidoAtual: Boolean;
    function AtualizarTotalPedido: Boolean;
    function AdicionarPedido(out Erro: String; NroPedido: String): Boolean;
    function AtualizarPedido(out Erro: String): Boolean;
    function FinalizarPedido(out Erro: String): Boolean;
    function CancelarPedido(out Erro: String): Boolean;
  end;

var Venda: TVenda;

implementation

uses
  unPrincipal, System.UITypes;

{ TVenda }
function TVenda.Acessar(out Erro: String; Email, Senha: String; Lembrar: Boolean): Boolean;
var
  Qry: TFDQuery;
begin
  Result:= False;

  if not TUtils.ValidarEmail(Email) then
  begin
    Erro := 'Email inválido';
    Exit;
  end;

  FPedido.EmailUsuario := Email;
  Qry := TFDQuery.Create(nil);
  if not DM1.ObterInfoUsuario(Qry) then
  begin
    Erro := 'Erro ao carregar informações do usuário';
    Qry.DisposeOf;
    Exit;
  end;

  if not (Email = Qry.FieldByName('email').AsString) then
  begin
    Erro := 'O email está errado'; 
    Qry.DisposeOf;
    Exit;
  end;
       
  if not (Senha = Qry.FieldByName('senha').AsString) then
  begin
    Erro := 'A senha está errada'; 
    Qry.DisposeOf;
    Exit;
  end;
  
  DM1.LembrarUsuario(Lembrar);

  Pedido.IDUsuario := Qry.FieldByName('sequsuario').AsInteger;
  Pedido.NomeUsuario := Qry.FieldByName('nome').AsString;
  Pedido.UsuarioCPF := Qry.FieldByName('cpf').AsString;
  Result:= True;

  Qry.DisposeOf;
end;

function TVenda.AdicionarPedido(out Erro: String; NroPedido: String): Boolean;
begin
  Result := False;
  if not Assigned(FPedido) then
    FPedido := TPedido.Create;

  if not (DM1.CriarPedido(Erro, NroPedido))then
    Exit;

  Pedido.IDPedido := NroPedido.ToInteger;
  Result := True;
end;

function TVenda.ApagarCardapioAtual: Boolean;
begin
  Result := False;
  if FProdutosCardapio.Count > 0 then
  begin
    TThread.Synchronize(nil,
    procedure
    begin
      frmPrincipal.ApagarCardapio;
    end);
    FreeAndNil(FProdutosCardapio);
    FProdutosCardapio := TObjectList<TProduto>.Create(True);
    FProdutosCardapio.Clear;
    Result := True;
  end;
end;

function TVenda.ApagarPedidoAtual: Boolean;
begin
  Result := False;
  if Pedido.ListaProdutos.Count > 0 then
  begin
    FreeAndNil(FPedido);
    FPedido := TPedido.Create;
  end;
end;

function TVenda.AtualizarPedido(out Erro: String): Boolean;
begin
  Result := False;
  if DM1.AtualizarPedido(Pedido.IDPedido, Erro) then
    Result := True;  
end;

function TVenda.AtualizarStatusPedido: Boolean;
var
  Erro: String;
  Status: String;
begin
  if not (DM1.ObterStatusPedido(Venda.Pedido.IDPedido, Erro, Status)) then
  begin
    Exit;
  end;
  Venda.Pedido.Status := Status;
  if Status = 'P' then
    frmPrincipal.lblStatusPedido.Text := 'Pendente'
  else if Status = 'A' then
    frmPrincipal.lblStatusPedido.Text := 'Em Preparo'
  else if Status = 'C' then
  begin
    frmPrincipal.lblStatusPedido.Text := 'Status';
    frmPrincipal.lblNroPedido.Text := 'Nro. Pedido';
    frmPrincipal.lblVlrTotPedido.Text := 'R$0,00';
    frmPrincipal.TabBtnPedido.ActiveTab := frmPrincipal.TabBtnFazerPedido;
    frmPrincipal.tabControlPrincipal.ActiveTab := frmPrincipal.tabMenu;
    ApagarPedidoAtual;
    frmPrincipal.TimerStatusPedido.Enabled := False;
  end
  else if Status = 'F' then
  begin
    frmPrincipal.lblStatusPedido.Text := 'Finalizado';
    ApagarPedidoAtual;
    ApagarCardapioAtual;
    frmPrincipal.PedidoFinalizado;
    FMesa := EmptyStr;
    frmPrincipal.TimerStatusPedido.Enabled := False;
  end;
end;

function TVenda.AtualizarTotalPedido: Boolean;
begin
  frmPrincipal.lblVlrTotPedido.Text := 'R$' + FormatFloat('0.00', Venda.Pedido.GetTotalPedido);
end;

function TVenda.BuscarCardapio(QRCode: String): Boolean;
var
  BaseUrl: String;
  Mensagem: String;
  I: Integer;
  JSONArray: TJSONArray;
  Erro: String;
  NomeEmpresa: String;
begin  
  frmPrincipal.FLoading.Exibir('Buscando cardápio');
  TThread.CreateAnonymousThread(procedure
  begin
    try
//      JSONArray := TJSONArray.Create;
      QRCode := stringreplace(QrCode, '|', '',    [rfReplaceAll, rfIgnoreCase]);
      BaseUrl := Copy(QRCode, 1, QRCode.Length - 3);
      FMesa := Copy(QRCode, BaseUrl.Length + 1, QRCode.Length);
      with DM1 do
      begin
        RESTClient.BaseURL := BaseUrl;
        if not ObterEmpresa(Mensagem, NomeEmpresa) then
        begin
          {$IFDEF ANDROID}
          if TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceAsync, IInterface (ASyncService)) then
          begin
            ASyncService.ShowMessageAsync(Mensagem);
          end;
          {$ELSE}
          ShowMessage(Mensagem);
          {$ENDIF}
          Exit;
        end;

        if not ListarProduto(JSONArray, Erro) then
        begin
          raise Exception.Create('Erro ao listar produto: ' + erro);
        end;

        TThread.Synchronize(nil,
        procedure
        begin
          if not (NomeEmpresa.Trim.IsEmpty) then
            frmPrincipal.lblNomeEmpresa.Text := NomeEmpresa;
          if CriarCardapio(JSONArray) then
          begin
            frmPrincipal.CriarItemCardapio;
            frmPrincipal.CriarCategorias;
            frmPrincipal.lblCardapioPlaceHolder.Visible := False;
            frmPrincipal.FLoading.Fechar;
          end;
        end);
      end;
//      FreeAndNil(JSONArray);
    except
    on E: Exception do
      begin
//        FreeAndNil(JSONArray);
        TThread.Synchronize(nil,
        procedure
        begin
          frmPrincipal.lblNomeEmpresa.Text := EmptyStr;
          frmPrincipal.lblCardapioPlaceHolder.Visible := True;
          frmPrincipal.FLoading.Fechar;
          frmPrincipal.FLoading.Exibir;
          frmPrincipal.Dlg.Mensagem( E.Message);
          frmPrincipal.Dlg.ShowModal(
          procedure(ModalResult: TModalResult)
          begin
            if frmPrincipal.Dlg.ModalResult = mrOk then
              frmPrincipal.FLoading.Fechar;
          end);
        end);
      end;
    end;
  end).Start;

end;

function TVenda.BuscarIDUltimoPedido: Integer;
begin

end;

function TVenda.Cadastrar(out Erro: String; Nome, Senha, Email, CPF: String): Boolean;
begin
  Result := False;

  if not TUtils.ValidarEmail(Email) then
  begin
    Erro := 'Email inválido';
    Exit;
  end;

  if not DM1.CadastrarUsuario(Nome, Senha, Email, CPF, False) then
  begin
    Erro := 'Não foi possível cadastrar o usuário';
    Exit;
  end;

  Result := True;
end;

function TVenda.CancelarPedido(out Erro: String): Boolean;
begin
  Result := False;
  if DM1.CancelarPedido(Pedido.IDPedido, Erro) then
  begin
    ApagarPedidoAtual;
    Result := True;
    frmPrincipal.TimerStatusPedido.Enabled := False;
  end;  
end;

constructor TVenda.Create;
begin  
  FPedido := TPedido.Create;
  FProdutosCardapio := TObjectList<TProduto>.Create(True);
  FProdutosCardapio.Clear;
end;

function TVenda.CriarCardapio(Cardapio: TJSONArray): Boolean;
var
  I: Integer;
  Produto: TProduto;
  StringStream: TStringStream;
begin
  try
    Result := False;

    with DM1 do
    begin
      ApagarCardapioAtual;
      ApagarCardapio;
      for I := 0 to Cardapio.Size - 1 do
      begin
        if  InserirCardapio(
          Cardapio.Items[I].GetValue<Integer>('seqproduto'),
          Cardapio.Items[I].GetValue<String>('nome'),
          Cardapio.Items[I].GetValue<String>('categoria'),
          Cardapio.Items[I].GetValue<Double>('preco'),
          Cardapio.Items[I].GetValue<String>('descricao'),
          Cardapio.Items[I].GetValue<String>('imagem'),
          Mesa) then
        begin

          ProdutosCardapio.OwnsObjects := True;
          Produto := TProduto.Create;
          Produto.IDProduto := Cardapio.Items[I].GetValue<Integer>('seqproduto');
          Produto.Nome := Cardapio.Items[I].GetValue<String>('nome');
          Produto.Categoria := Cardapio.Items[I].GetValue<String>('categoria');
          Produto.Descricao := Cardapio.Items[I].GetValue<String>('descricao');
          Produto.Preco := Cardapio.Items[I].GetValue<Double>('preco');

          StringStream := TStringStream.Create(Cardapio.Items[I].GetValue<String>('imagem'));
          StringStream.Position := 0;

          TNetEncoding.Base64.Decode(StringStream, Produto.Imagem);
          Produto.Imagem.Position := 0;

          ProdutosCardapio.Add(Produto);
          StringStream.Clear;
          StringStream.Free;

        end;
      end;
    end;
  finally
    FreeAndNil(Cardapio);
    Result := True;
  end;
end;

destructor TVenda.Destroy;
begin
  FreeAndNil(FPedido);
  FreeAndNil(FProdutosCardapio);
  inherited;
end;

function TVenda.FinalizarPedido(out Erro: String): Boolean;
begin            
  Result := False;
  if DM1.FinalizarPedido(Pedido.IDPedido, Erro) then
  begin
    ApagarPedidoAtual;
    ApagarCardapioAtual;
    FMesa := EmptyStr;
    Result := True;
    frmPrincipal.TimerStatusPedido.Enabled := False;
  end;  
end;

function TVenda.GetCategorias(out ListaCategorias: TStringList): Boolean;
var
  I: Integer;
begin
  Result := False;
  ListaCategorias.Sorted := True;
  ListaCategorias.Duplicates := dupIgnore;

  for I := 0 to ProdutosCardapio.Count - 1 do
  begin
    ListaCategorias.Add(ProdutosCardapio.Items[I].Categoria);
  end;
  Result := True;
end;

function TVenda.GetProdutosCardapio: TObjectList<TProduto>;
begin
  Result := FProdutosCardapio;
end;

function TVenda.GetPedido: TPedido;
begin
  Result := FPedido;
end;

function TVenda.RecuperarPedido: Boolean;
var
  I: Integer;
  Qry: TFDQuery;  
  Produto: TProduto;
begin
  Qry := TFDQuery.Create(nil);
  Pedido.IDPedido := 0;

  DM1.ObterInfoUsuario(Qry);
  Pedido.IDUsuario := Qry.FieldByName('sequsuario').AsInteger;
  Pedido.UsuarioCPF := Qry.FieldByName('cpf').AsString;
  Pedido.NomeUsuario := Qry.FieldByName('nome').AsString;
  Pedido.EmailUsuario := Qry.FieldByName('email').AsString;  

  DM1.ObterInfoPedido(Qry);
  Pedido.Data := Qry.FieldByName('dtaabertura').AsDateTime;  
  Pedido.Mesa := Qry.FieldByName('mesa').AsInteger;  
  Pedido.IDPedido := Qry.FieldByName('nropedido').AsInteger;  
  Pedido.Status := Qry.FieldByName('status').AsString;  

  DM1.ObterItensPedidoAtual(Qry);
  Qry.First;
  while not Qry.Eof do
  begin    
    for I := 0 to Venda.ProdutosCardapio.Count - 1 do
    begin
      if Venda.ProdutosCardapio.Items[I].IDProduto = Qry.FieldByName('seqproduto').AsInteger then
        Break;
    end;
    if Venda.Pedido.AdicionarProduto(I , Qry.FieldByName('quantidade').AsInteger) then      
      Venda.AtualizarTotalPedido;        
    Qry.Next;
  end;    
  Qry.DisposeOf;  
end;

function TVenda.RecuperarVenda: Boolean;
var
  Qry : TFDQuery;    
  Produto: TProduto;
  StringStream: TStringStream;
begin
  Qry := TFDQuery.Create(nil);

  Result := False;
  if DM1.VerificarPedidoAtivo then
  begin
    TThread.Synchronize(nil,
    procedure
    begin
      frmPrincipal.FLoading.Exibir('Recuperando Cardápio');
    end);
    if DM1.ObterCardapio(Qry) then
    begin
       Qry.First;
       Mesa := Qry.FieldByName('mesa').AsString;
       ProdutosCardapio.OwnsObjects := True;
       while not Qry.Eof do
       begin
         Produto := TProduto.Create;
         Produto.IDProduto := Qry.FieldByName('seqproduto').AsInteger;
         Produto.Nome := Qry.FieldByName('nome').AsString;
         Produto.Categoria := Qry.FieldByName('categoria').AsString;
         Produto.Descricao := Qry.FieldByName('descricao').AsString;
         Produto.Preco := Qry.FieldByName('preco').AsFloat;

         StringStream := TStringStream.Create(Qry.FieldByName('imagem').AsString);
         StringStream.Position := 0;

         TNetEncoding.Base64.Decode(StringStream, Produto.Imagem);
         Produto.Imagem.Position := 0;

         ProdutosCardapio.Add(Produto);
         StringStream.Clear;
         StringStream.Free;
         Qry.Next;
       end;
    end;
    RecuperarPedido;

    Qry.Active := False;
    Qry.SQL.Clear;
    DM1.RecuperarEmpresa(Qry);
    TThread.Synchronize(nil,
    procedure
    begin
      frmPrincipal.lblNomeEmpresa.Text := Qry.FieldByName('nomeempresa').AsString;
      frmPrincipal.lblCardapioPlaceHolder.Visible := False;
    end);    
    Pedido.IDEmpresa := Qry.FieldByName('seqempresa').AsInteger;
    Result := True;     
  end;    
  Qry.DisposeOf;
end;

procedure TVenda.SetProdutosCardapio(Avalue: TObjectList<TProduto>);
begin
  FProdutosCardapio := Avalue;
end;

procedure TVenda.SetPedido(Avalue: TPedido);
begin
  FPedido := Avalue;
end;

function TVenda.VerificarStatusPedido: Boolean;
begin
  if FPedido.IDPedido > 0 then
  begin
    // conectar no banco e verificar status
  end;
end;

initialization
begin
  Venda := TVenda.Create;
end;

finalization
begin
  if Assigned(Venda) then
     FreeAndNil(Venda);
end;

end.
