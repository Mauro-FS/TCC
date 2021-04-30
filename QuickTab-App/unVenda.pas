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
    function RecuperarVenda: Boolean;
    function VerificarStatusPedido: Boolean;
    function BuscarIDUltimoPedido: Integer;
    function AdicionarPedido(out Erro: String; NroPedido: String): Boolean;
    function GetCategorias(out ListaCategorias: TStringList): Boolean;
    function BuscarCardapio(QRCode: String): Boolean;
    function CriarCardapio(Cardapio: TJSONArray): Boolean;
    function ApagarCardapioAtual: Boolean;
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
var
  I: Integer;
begin
  for I := ProdutosCardapio.Count - 1 downto 0 do
  begin
    ProdutosCardapio.Items[I].Imagem.Clear;
  end;
end;

function TVenda.BuscarCardapio(QRCode: String): Boolean;
var
  BaseUrl: String;
  Mensagem: String;
  I: Integer;
  JSONArray: TJSONArray;
  Erro: string;
begin

  frmPrincipal.FLoading.Exibir('Buscando cardápio');
  TThread.CreateAnonymousThread(procedure
  begin
    try
      QRCode := stringreplace(QrCode, '|', '',    [rfReplaceAll, rfIgnoreCase]);
      BaseUrl := Copy(QRCode, 1, QRCode.Length - 3);
      FMesa := Copy(QRCode, BaseUrl.Length + 1, QRCode.Length);
      with DM1 do
      begin
        RESTClient.BaseURL := BaseUrl;
        if not ObterEmpresa(Mensagem) then
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
          if CriarCardapio(JSONArray) then
          begin
            frmPrincipal.CriarItemCardapio;
            frmPrincipal.CriarCategorias;
            frmPrincipal.FLoading.Fechar;
          end;
        end);
      end;

    except
    on E: Exception do
      begin
        TThread.Synchronize(nil,
        procedure
        begin
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
  ApagarCardapioAtual;
  FreeAndNil(FPedido);

  FreeAndNil(FProdutosCardapio);
  inherited;
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

function TVenda.RecuperarVenda: Boolean;
begin

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
