unit unDM1;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, REST.Types,
  REST.Client, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.JSON,
  Data.Bind.Components, Data.Bind.ObjectScope, REST.Authenticator.Basic,
  Datasnap.DBClient, FireDAC.Stan.StorageJSON, uDWJSONObject, uDWConstsCharset,
  FMX.Objects, System.Generics.Collections, unProduto, FireDAC.Comp.UI, System.IOUtils;

type
  TDM1 = class(TDataModule)
    conn: TFDConnection;
    HTTPBasicAuthenticator: THTTPBasicAuthenticator;
    qry_config: TFDQuery;
    RequestCriarPedido: TRESTRequest;
    RESTClient: TRESTClient;
    FDQuery1: TFDQuery;
    RequestListarProduto: TRESTRequest;
    RequestObterEmpresa: TRESTRequest;
    RequestSolicitarAtendente: TRESTRequest;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure connBeforeConnect(Sender: TObject);
  private
    { Private declarations }
  public
    //Usuário
    function CadastrarUsuario(Nome, Senha, Email, CPF: String; Lembrar: Boolean): Boolean;
    function ObterInfoUsuario(out Qry: TFDQuery): Boolean;
    function AtualizarSenhaUsuario(Email, Senha: String): Boolean;
    function LembrarUsuario(Lembrar: Boolean): Boolean;

    //Empresa
    function ObterEmpresa(out Erro: String; out NomeEmpresa: String): Boolean;
    function InserirEmpresa(out JSONObj: TJsonObject): Boolean;
    function AtualizarEmpresa(out JSONObj: TJsonObject): Boolean;
    function BuscarEmpresa(CNPJ: String): Boolean;

    //Cardapio e produtos
    function BuscarCardapio(out Qry: TFDQuery): Boolean;
    function InserirCardapio(SeqProduto: Integer; Nome, Categoria: String; Preco: Double; Descricao, Imagem, Mesa: String): Boolean;
    function ListarProduto(out JsonArray: TJSONArray; out Erro: String): Boolean;
    procedure ApagarCardapio;

    //Pedido
    function CriarPedido(out Erro: String; out NroPedido: String): Boolean;
    function InserirPedido(Mesa: String; out Erro: String): Boolean;
    function InserirNroPedido(SeqPedido: Integer; NroPedido: String; out Erro: String): Boolean;
    function AtualizarStatusPedido(SeqPedido: Integer; Status: String; out Erro: String): Boolean;
    function RemoverPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function VerificarPedidoAtivo: Boolean;

    //Outros
    function SolicitarAtendente(out Erro: String; Mesa: String): Boolean;
    function PrimeiroAcesso: Boolean;
    function ConectarBanco: Boolean;
  end;

var
  DM1: TDM1;

implementation

uses
  uDWConsts, unVenda;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

{ TDM1 }

function TDM1.ObterEmpresa(out Erro: String; out NomeEmpresa: String): Boolean;
var
  JSON: String;
  JSONObj: TJsonObject;
  Qry: TFDQuery;
begin
  try
    Result := False;
    Erro := '';
    JSONObj := TJSONObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    with RequestObterEmpresa do
    begin
      Params.Clear;
      Execute;
    end;

    if RequestObterEmpresa.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro ao buscar informações do estabelecimento: ' + RequestObterEmpresa.Response.StatusCode.ToString;
    end
    else
    begin
      JSON := RequestObterEmpresa.Response.JSONValue.ToString;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

      if JSONObj.GetValue('retorno').Value = 'OK' then
      begin
        Result := True;
        if not BuscarEmpresa(JSONObj.GetValue('cnpj').ToString) then
          Result := InserirEmpresa(JSONObj)
        else
         Result := AtualizarEmpresa(JSONObj);
      end
      else
      begin
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
      end;
    end;
  finally
    if Result then
      NomeEmpresa := JSONObj.GetValue('nomeempresa').Value;
    Qry.DisposeOf;
    JSONObj.DisposeOf;
  end;
end;

function TDM1.ObterInfoUsuario(out Qry: TFDQuery): Boolean;
begin
  Result := False;
  if not Assigned(Qry) then
    Qry := TFDQuery.Create(nil);

  Qry.Connection := DM1.conn;

  Qry.SQL.Clear;
  Qry.SQL.Add('select * from tb_usuario ');
  Qry.Active := True;

  if Qry.RecordCount > 0 then
    Result := True;
end;

function TDM1.PrimeiroAcesso: Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := True;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_usuario');
      Qry.Active := True;

      if Qry.RecordCount > 0 then
        Result := False;
    except
      Result := False;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.RemoverPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  try
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('delete from tb_pedidoitem where seqpedido = :seqpedido');
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.ExecSQL;

    Qry.SQL.Clear;
    Qry.SQL.Add('delete from tb_pedido where seqpedido = :seqpedido');
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.ExecSQL;

    Result := True;
  except
    Erro := 'Erro ao remover o pedido!';
    Result := False;
  end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.SolicitarAtendente(out Erro: String; Mesa: String): Boolean;
var
  JSON: String;
  JSONObj: TJsonObject;
begin
  try
    Result := False;
    Erro := '';
    JSONObj := TJSONObject.Create;

    with RequestSolicitarAtendente do
    begin
      Params.Clear;
      AddParameter('mesa', Mesa, TRESTRequestParameterKind.pkGETorPOST);
      Execute;
    end;

    if RequestSolicitarAtendente.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro solicitar o atendente: ' + RequestSolicitarAtendente.Response.StatusCode.ToString;
    end
    else
    begin
      JSON := RequestObterEmpresa.Response.JSONValue.ToString;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

      if JSONObj.GetValue('retorno').Value = 'OK' then
      begin
        Result := True;
      end
      else
      begin
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
      end;
    end;
  finally
    JSONObj.DisposeOf;
  end;
end;

function TDM1.VerificarPedidoAtivo: Boolean;
var
  Qry: TFDQuery;
begin
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido where not ((status = ''F'') or (status = ''P''))');
    Qry.Active := True;

    if Qry.RecordCount > 0 then
      Result := True;

  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.InserirEmpresa(out JSONObj: TJsonObject): Boolean;
var
  Qry: TFDQuery;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    try
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_empresa(nomeempresa, cnpj, endereco, numero, cep, cidade, estado, distancia) ');
      Qry.SQL.Add('values(:nomeempresa, :cnpj, :endereco, :numero, :cep, :cidade, :estado, :distancia)');
      Qry.ParamByName('nomeempresa').Value := JSONObj.GetValue('nomeempresa').Value;
      Qry.ParamByName('cnpj').Value := JSONObj.GetValue('cnpj').Value;
      Qry.ParamByName('endereco').Value := JSONObj.GetValue('endereco').Value;
      Qry.ParamByName('numero').Value := JSONObj.GetValue('numero').Value;
      Qry.ParamByName('cep').Value := JSONObj.GetValue('cep').Value;
      Qry.ParamByName('cidade').Value := JSONObj.GetValue('cidade').Value;
      Qry.ParamByName('estado').Value := JSONObj.GetValue('estado').Value;
      Qry.ParamByName('distancia').Value := JSONObj.GetValue('distancia').Value;
      Qry.ExecSQL;
      Result := True
    finally
      Qry.DisposeOf;
    end;
  except
    Result := False;
  end;
end;

function TDM1.InserirNroPedido(SeqPedido: Integer; NroPedido: String;
  out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_pedido set nropedido = :nropedido where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := SeqPedido;
      Qry.ParamByName('nropedido').Value := NroPedido.ToInteger;
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Erro := 'Erro ao Inserir o número do pedido';
    Result := False;
  end;
end;

function TDM1.InserirPedido(Mesa: String;
  out Erro: String): Boolean;
var
  Qry : TFDQuery;
  LUsuario: Integer;
  LPedido: Integer;
  I: Integer;
begin
  try
    try
      Result := False;
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_usuario');
      Qry.Active := True;

      if Qry.RecordCount = 0 then
      begin
        Erro := 'Erro de usuário. Verifique as suas informações!';
        Exit;
      end;

      LUsuario := Qry.FieldByName('sequsuario').AsInteger;

      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_pedido(sequsuario, mesa, status, dtaabertura, dtaultalteracao) ');
      Qry.SQL.Add('values(:sequsuario, :mesa, :status, current_timestamp, current_timestamp) ');
      Qry.ParamByName('sequsuario').Value := LUsuario;
      Qry.ParamByName('mesa').Value := Mesa;
      Qry.ParamByName('status').Value := 'P';
      Qry.ExecSQL;

      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedido');
      Qry.Active := True;

      if (Qry.RecordCount = 0) or (Venda.Pedido.ListaProdutos.Count = 0) then
      begin
        Erro := 'Erro ao criar o pedido! Tente novamente ou chame um atendente';
        Exit;
      end;

      LPedido := Qry.FieldByName('seqpedido').Value;

      for I := 0 to Venda.Pedido.ListaProdutos.Count - 1 do
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('insert into tb_pedidoitem(seqpedido, seqproduto, quantidade, observacao) ');
        Qry.SQL.Add('values(:seqpedido, :seqproduto, :quantidade, :observacao) ');
        Qry.ParamByName('seqpedido').Value := LPedido;
        Qry.ParamByName('seqproduto').Value := Venda.Pedido.ListaProdutos.Items[I].IDProduto;
        Qry.ParamByName('quantidade').Value := Venda.Pedido.ListaProdutos.Items[I].Quantidade;
        Qry.ParamByName('observacao').Value := Venda.Pedido.ListaProdutos.Items[I].Observacao;
        Qry.ExecSQL;
      end;

    finally
      Result := True;
      Qry.DisposeOf;
    end;
  except
    Result := False;
    Erro := 'Erro ao inserir o Pedido';
  end;
end;

procedure TDM1.ApagarCardapio;
var
  Qry : TFDQuery;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('delete from tb_cardapio');
    Qry.ExecSQL;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.AtualizarEmpresa(out JSONObj: TJsonObject): Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_empresa set nomeempresa = :nomeempresa, cnpj = :cnpj, endereco = :endereco, ');
      Qry.SQL.Add('numero = :numero, cep = :cep, cidade = :cidade, estado = :estado, distancia = :distancia');
      Qry.ParamByName('nomeempresa').Value := JSONObj.GetValue('nomeempresa').Value;
      Qry.ParamByName('cnpj').Value := JSONObj.GetValue('cnpj').Value;
      Qry.ParamByName('endereco').Value := JSONObj.GetValue('endereco').Value;
      Qry.ParamByName('numero').Value := JSONObj.GetValue('numero').Value;
      Qry.ParamByName('cep').Value := JSONObj.GetValue('cep').Value;
      Qry.ParamByName('cidade').Value := JSONObj.GetValue('cidade').Value;
      Qry.ParamByName('estado').Value := JSONObj.GetValue('estado').Value;
      Qry.ParamByName('distancia').Value := JSONObj.GetValue('distancia').Value;
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Result := False;
  end;
end;

function TDM1.AtualizarSenhaUsuario(Email, Senha: String): Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_usuario where email = :email');
      Qry.ParamByName('email').Value := Email;
      Qry.Active := True;

      if Qry.RecordCount = 0 then
      begin
        Result := False;
        Exit;
      end;

      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_usuario set senha = :senha');
      Qry.ParamByName('senha').Value := Senha;
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Result := False;
  end;
end;

function TDM1.AtualizarStatusPedido(SeqPedido: Integer; Status: String;
  out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_pedido set status = :status where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := SeqPedido;
      Qry.ParamByName('status').Value := Status;
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Erro := 'Erro ao atualizar o status do pedido';
    Result := False;
  end;
end;

function TDM1.BuscarCardapio(out Qry: TFDQuery): Boolean;
begin
  Result := False;
  Qry := TFDQuery.Create(nil);
  Qry.Connection := DM1.conn;

  Qry.SQL.Clear;
  Qry.SQL.Add('select * from tb_cardapio ');
  Qry.Active := True;

  if Qry.RecordCount > 0 then
    Result := True;
end;

function TDM1.BuscarEmpresa(CNPJ: String): Boolean;
var
  Qry: TFDQuery;
begin
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.SQL.Clear;
    Qry.SQL.Add('select 1 from tb_empresa ');
    Qry.SQL.Add('where cnpj = :cnpj');
    Qry.ParamByName('cnpj').Value := CNPJ;
    Qry.Active := True;

    if Qry.RecordCount > 0 then
      Result := True;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.InserirCardapio(SeqProduto: Integer; Nome, Categoria: String;
  Preco: Double; Descricao, Imagem, Mesa: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
//    Qry.SQL.Clear;
//    Qry.SQL.Add('select 1 from tb_cardapio');
//    Qry.Active := True;

//    if not Qry.IsEmpty then
//    begin
//      Qry.Active := False;
//      ApagarCardapio;
//    end;

    Qry.SQL.Clear;
    Qry.SQL.Add('insert into tb_cardapio(seqproduto, nome, descricao, categoria, preco, imagem, mesa) ');
    Qry.SQL.Add('values(:seqproduto, :nome, :descricao, :categoria, :preco, :imagem, :mesa )');
    Qry.ParamByName('seqproduto').Value := SeqProduto;
    Qry.ParamByName('nome').Value := Nome;
    Qry.ParamByName('descricao').Value := Descricao;
    Qry.ParamByName('categoria').Value := Categoria;
    Qry.ParamByName('preco').Value := Preco;
    Qry.ParamByName('imagem').Value := Imagem;
    Qry.ParamByName('mesa').Value := Mesa;

    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.CadastrarUsuario(Nome, Senha, Email, CPF: String; Lembrar: Boolean): Boolean;
var
  Qry: TFDQuery;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    try
      Qry.SQL.Clear;
      Qry.SQL.Add('delete from tb_usuario');
      Qry.ExecSQL;

      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_usuario(nome, senha, cpf, email, lembrar) ');
      Qry.SQL.Add('values(:nome, :senha, :cpf, :email, :lembrar)');
      Qry.ParamByName('nome').Value := Nome;
      Qry.ParamByName('senha').Value := Senha;
      Qry.ParamByName('cpf').Value := CPF;
      Qry.ParamByName('email').Value := Email;
      if Lembrar then
        Qry.ParamByName('lembrar').Value := 'S'
      else
        Qry.ParamByName('lembrar').Value := 'N';
      Qry.ExecSQL;
      Result := True
    finally
      Qry.DisposeOf;
    end;
  except
    Result := False;
  end;
end;

function TDM1.ConectarBanco: Boolean;
begin
  try
    conn.Params.Values['DriverID'] := 'SQLite';
    conn.Params.Values['Database'] := TDirectory.GetParent(GetCurrentDir) + PathDelim +  'db\banco.db';
    conn.Params.Values['User_Name'] := '';
    conn.Params.Values['Password'] := '';
    conn.Connected := True;
  except
  end;
end;

procedure TDM1.connBeforeConnect(Sender: TObject);
var
  dbPath: string;
begin
{$IF DEFINED(iOS) or DEFINED(ANDROID)}
  dbPath := TPath.Combine(TPath.GetDocumentsPath, 'banco.db');
{$ELSE}
  dbPath := TDirectory.GetParent(GetCurrentDir) + PathDelim +  'db\banco.db';
{$ENDIF}
  conn.Params.Values['Database'] := dbPath;
end;

function TDM1.CriarPedido(out Erro: String; out NroPedido: String): Boolean;
var
  Json : String;
  JSONObj: TJsonObject;
  JSONValue: uDWJSONObject.TJSONValue;
  Qry : TFDQuery;
  LCPF : String;
  LNome: String;
  LEmail: String;
  LMesa: String;
  LPedido: Integer;
begin
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    JSONValue := uDWJSONObject.TJSONValue.Create;
    JSONObj := TJSONObject.Create;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_usuario');
    Qry.Active := True;
    if Qry.RecordCount = 0 then
    begin
      Erro := 'Erro de informações do usuário';
      Exit;
    end;

    LCPF := Qry.FieldByName('cpf').AsString;
    LNome := Qry.FieldByName('nome').AsString;
    LEmail := Qry.FieldByName('email').AsString;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_cardapio');
    Qry.Active := True;

    if Qry.RecordCount = 0 then
    begin
      Erro := 'Não existe mesa selecionada';
      Exit;
    end;

    LMesa := Qry.FieldByName('mesa').AsString;

    if not InserirPedido(LMesa, Erro) then
      Exit;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedidoitem');
    Qry.Active := True;

    if Qry.RecordCount = 0 then
    begin
      Erro := 'Não existem itens no pedido';
      Exit;
    end;

    LPedido := Qry.FieldByName('seqpedido').Value;
    JSONValue.Encoding := TEncodeSelect.esUtf8;
    JSONValue.LoadFromDataset('', Qry, False, jmPureJSON);
    Erro := '';

    try
      with RequestCriarPedido do
      begin
        Params.Clear;
        AddParameter('cpf', LCPF, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('nome', LNome, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('email', LEmail, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('mesa', LMesa, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('pedido', JSONValue.ToJSON, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
      end;
    except on ex:exception do
      begin
        Result := false;
        Erro := 'Erro ao criar pedido: ' + ex.Message;
        Exit;
      end;
    end;

    if RequestCriarPedido.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro ao criar pedido: ' + RequestListarProduto.Response.StatusCode.ToString;
    end
    else
    begin
      Json := RequestCriarPedido.Response.JSONValue.ToString;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

      if JSONObj.GetValue('retorno').Value = 'OK' then
      begin
        if JSONObj.GetValue('nropedido').Value.Trim = '' then
        begin
          RemoverPedido(LPedido, Erro);
          Result := False;
          Erro := 'Número do pedido não foi criado. Tente novamente ou solicite um atendente';
        end;
        InserirNroPedido(LPedido, JSONObj.GetValue('nropedido').Value, Erro);
        NroPedido := JSONObj.GetValue('nropedido').Value;
      end
      else
      begin
        RemoverPedido(LPedido, Erro);
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
      end;

  //    JsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Json), 0) as TJSONArray;
      Result := True;
    end;
  finally
    Qry.DisposeOf;
    Json := EmptyStr;
    FreeAndNil(JSONValue);
    FreeAndNil(JSONObj);
  end;
end;

function TDM1.LembrarUsuario(Lembrar: Boolean): Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_usuario set lembrar = :lembrar');
      if Lembrar then
        Qry.ParamByName('lembrar').Value := 'S'
      else
        Qry.ParamByName('lembrar').Value := 'N';
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Result := False;
  end;
end;

function TDM1.ListarProduto(out JsonArray: TJSONArray;
  out Erro: String): Boolean;
var
  Json : String;
begin
  Erro := '';
  Result := False;
  try
    with RequestListarProduto do
    begin
      Params.Clear;
      Execute;
    end;
  except on ex:exception do
    begin
      Erro := 'Erro ao listar produto: ' + ex.Message;
      Exit;
    end;
  end;

  if RequestListarProduto.Response.StatusCode <> 200 then
  begin
    Result := False;
    Erro := 'Erro ao listar produto: ' + RequestListarProduto.Response.StatusCode.ToString;
  end
  else
  begin
    Json := RequestListarProduto.Response.JSONValue.ToString;
    JsonArray := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Json), 0) as TJSONArray;
    Result := True;
  end;
end;

end.
