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
    RequestExcluirProdutoPedido: TRESTRequest;
    RequestAdicionarProdutoPedido: TRESTRequest;
    RequestCancelarPedido: TRESTRequest;
    RequestObterStatusPedido: TRESTRequest;
    RequestEncerrarPedido: TRESTRequest;
    RequestAtualizarPedido: TRESTRequest;
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
    function InserirEmpresa(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade, Estado: String; out Erro: String): Boolean;
    function AtualizarEmpresa(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade, Estado: String; out Erro: String): Boolean;
    function RecuperarEmpresa(Qry: TFDQuery): Boolean;
    function BuscarEmpresa(CNPJ: String): Boolean;

    //Cardapio e produtos
    function ObterCardapio(out Qry: TFDQuery): Boolean;
    function InserirCardapio(SeqProduto: Integer; Nome, Categoria: String; Preco: Double; Descricao, Imagem, Mesa: String): Boolean;
    function ListarProduto(out JsonArray: TJSONArray; out Erro: String): Boolean;
    procedure ApagarCardapio;

    //Pedido local
    function InserirPedido(Mesa: String; out SeqPedido: Integer; out Erro: String): Boolean;
    function AtualizarItensPedido(Mesa: String; out Erro: String): Boolean;
    function InserirNroPedido(SeqPedido: Integer; NroPedido: String; out Erro: String): Boolean;
    function AtualizarStatusPedido(SeqPedido: Integer; Status: String; out Erro: String): Boolean;
    function VerificarPedidoAtivo: Boolean;
    function FinalizarPedidosPendentes: Boolean;
    function ObterItensPedidoAtual(Qry: TFDQuery): Boolean;
    function VerificarQtdItensPedido(SeqPedido: Integer; out Qtd: Integer; out Erro: String): Boolean;
    function StatusPedido(SeqPedido: Integer; out Status: String): Boolean;
    function ObterInfoPedido(Qry: TFDQuery): Boolean;
    function RemoverItemPedidoLocal(SeqProduto, Quantidade: Integer; Observacao: String; out Erro: String): Boolean;
    function VerificarItemPedidoLocal(SeqProduto, Quantidade: Integer; Observacao: String; out Erro: String): Boolean;

    //Pedido remoto
    function CriarPedido(out Erro: String; out NroPedido: String): Boolean;
    function ObterStatusPedido(SeqPedido: Integer; out Erro: String; out Status: String): Boolean;
    function FinalizarPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function CancelarPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function AtualizarPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function RemoverPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function RemoverItemPedidoRemoto(SeqProduto, Quantidade: Integer; Observacao: String; out Erro: String): Boolean;

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
  teste: string;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Erro := 'Erro ao obter a empresa';
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
        begin
//          Erro := Erro + ' nomeempresa ' + JSONObj.GetValue('nomeempresa').Value;
//          Erro := Erro + ' cnpj ' + JSONObj.GetValue('cnpj').Value;
//          Erro := Erro + ' endereco ' + JSONObj.GetValue('endereco').Value;
//          Erro := Erro + ' numero ' + JSONObj.GetValue('numero').Value;
//          Erro := Erro + ' cep ' + JSONObj.GetValue('cep').Value;
//          Erro := Erro + ' cidade ' + JSONObj.GetValue('cidade').Value;
//          Erro := Erro + ' estado ' + JSONObj.GetValue('estado').Value;
          Result := InserirEmpresa(
           JSONObj.GetValue('nomeempresa').Value,
           JSONObj.GetValue('cnpj').Value,
           JSONObj.GetValue('endereco').Value,
           JSONObj.GetValue('numero').Value,
           JSONObj.GetValue('cep').Value,
           JSONObj.GetValue('cidade').Value,
           JSONObj.GetValue('estado').Value,
           Erro);
          if not Result then
          begin
            Erro := 'Erro ao inserir a empresa';

          end;
        end
        else
        begin
          Result := AtualizarEmpresa(
           JSONObj.GetValue('nomeempresa').Value,
           JSONObj.GetValue('cnpj').Value,
           JSONObj.GetValue('endereco').Value,
           JSONObj.GetValue('numero').Value,
           JSONObj.GetValue('cep').Value,
           JSONObj.GetValue('cidade').Value,
           JSONObj.GetValue('estado').Value,
           Erro);
          if not Result then
            Erro := 'Erro ao atualizar a empresa';
        end;
      end
      else
      begin
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
        if Erro.Trim.IsEmpty then
          Erro := 'Erro ao comunicar com o servidor';
      end;
    end;
  finally
    if Result then
      NomeEmpresa := JSONObj.GetValue('nomeempresa').Value;
    Qry.DisposeOf;
    JSONObj.DisposeOf;
  end;
end;

function TDM1.ObterInfoPedido(Qry: TFDQuery): Boolean;
begin
  {$ZEROBASEDSTRINGS OFF}
  Result := False;
  if not Assigned(Qry) then
    Qry := TFDQuery.Create(nil);
  Qry.Connection := DM1.conn;

  Qry.SQL.Clear;
  Qry.SQL.Add('select * from tb_pedido where not ((status = ''F'') or (status = ''C'')) order by dtaultalteracao desc');
  Qry.Active := True;      
end;

function TDM1.ObterInfoUsuario(out Qry: TFDQuery): Boolean;
begin
  {$ZEROBASEDSTRINGS OFF}
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

function TDM1.ObterItensPedidoAtual(Qry: TFDQuery): Boolean;
var
  LPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  Result := False;
  if not Assigned(Qry) then
    Qry := TFDQuery.Create(nil);
  Qry.Connection := DM1.conn;

  Qry.SQL.Clear;
  Qry.SQL.Add('select * from tb_pedido where ((status = ''P'') or (status = ''A'')) order by dtaultalteracao desc');
  Qry.Active := True;

  LPedido := Qry.FieldByName('seqpedido').AsInteger;
  
  Qry.SQL.Clear;
  Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido order by seqpedidoitem asc');
  Qry.ParamByName('seqpedido').Value := LPedido;
  Qry.Active := True;      
end;

function TDM1.ObterStatusPedido(SeqPedido: Integer; out Erro: String; out Status: String): Boolean;
var
  JSON: String;
  JSONObj: TJsonObject;
  NroPedido: Integer;
  Qry : TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Erro := '';
    JSONObj := TJSONObject.Create;

    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select max(seqpedido) as seqpedido, nropedido from tb_pedido');
    Qry.Active := True;

    if not (Qry.FieldByName('nropedido').Value > 0) then
    begin
      Erro := 'Não foi possível encontrar o número do pedido';
      Exit;
    end;

    NroPedido := Qry.FieldByName('nropedido').Value;
    SeqPedido := Qry.FieldByName('seqpedido').Value;
    with RequestObterStatusPedido do
    begin
      Params.Clear;
      AddParameter('seqpedido', NroPedido.ToString, TRESTRequestParameterKind.pkGETorPOST);
      Execute;
    end;

    if RequestObterStatusPedido.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro ao obter o status do pedido: ' + RequestObterStatusPedido.Response.StatusCode.ToString;
    end
    else
    begin
      JSON := RequestObterStatusPedido.Response.JSONValue.ToString;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

      if JSONObj.GetValue('retorno').Value = 'OK' then
      begin
        Status := JSONObj.GetValue('status').Value;
        if AtualizarStatusPedido(SeqPedido, Status, Erro) then
          Result := True;
      end
      else
      begin
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
      end;
    end;
  finally
    Json := EmptyStr;
    FreeAndNil(JSONObj);
    Qry.DisposeOf;
  end;
end;

function TDM1.PrimeiroAcesso: Boolean;
var
  Qry : TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
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

function TDM1.RecuperarEmpresa(Qry: TFDQuery): Boolean;
begin
  {$ZEROBASEDSTRINGS OFF}
  Result := False;
  if not Assigned(Qry) then
    Qry := TFDQuery.Create(nil);
  Qry.Connection := DM1.conn;

  Qry.SQL.Clear;
  Qry.SQL.Add('select * from tb_empresa');
  Qry.Active := True;
end;

function TDM1.RemoverItemPedidoRemoto(SeqProduto, Quantidade: Integer; Observacao: String; out Erro: String): Boolean;
var
  Qry : TFDQuery;
  SeqPedido: Integer;
  NroPedido: Integer;
  JSON: String;
  JSONObj: TJsonObject;
  Status: String;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    try

      JSONObj := TJSONObject.Create;
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido) as seqpedido, nropedido from tb_pedido');
      Qry.Active := True;

      if not (Qry.FieldByName('seqpedido').Value > 0) then
      begin
        Erro := 'Não foi possível encontrar o pedido';
        Exit;
      end;

      SeqPedido := Qry.FieldByName('seqpedido').Value;
      NroPedido := Qry.FieldByName('nropedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido ');
      Qry.SQL.Add('and seqproduto = :seqproduto and quantidade = :quantidade ');
      Qry.SQL.Add('and observacao = :observacao');
      Qry.ParamByName('seqpedido').Value := SeqPedido;
      Qry.ParamByName('seqproduto').Value := SeqProduto;
      Qry.ParamByName('quantidade').Value := Quantidade;
      Qry.ParamByName('observacao').Value := Observacao;
      Qry.Active := True;

      if not (Qry.RecordCount > 0) then
      begin
        Erro := 'Não foi possível remover o item';
        Exit;
      end;

      if NroPedido > 0 then
      begin
        with RequestExcluirProdutoPedido do
        begin
          Params.Clear;
          AddParameter('seqpedido', NroPedido.ToString, TRESTRequestParameterKind.pkGETorPOST);
          AddParameter('seqproduto', IntToStr(SeqProduto), TRESTRequestParameterKind.pkGETorPOST);
          AddParameter('quantidade', IntToStr(Quantidade), TRESTRequestParameterKind.pkGETorPOST);
          AddParameter('observacao', Observacao, TRESTRequestParameterKind.pkGETorPOST);
          Execute;
        end;

        if RequestExcluirProdutoPedido.Response.StatusCode <> 200 then
        begin
          Result := False;
          Erro := 'Erro ao remover o item do pedido: ' + RequestExcluirProdutoPedido.Response.StatusCode.ToString;
        end
        else
        begin
          JSON := RequestExcluirProdutoPedido.Response.JSONValue.ToString;
          JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

          if JSONObj.GetValue('retorno').Value = 'OK' then
          begin
            Status := JSONObj.GetValue('status').Value;
            if Status <> 'P' then
            begin
              Result := False;
              Erro := 'Não foi possível remover o item do pedido';
            end
            else
            begin
              Qry.SQL.Clear;
              Qry.SQL.Add('delete from tb_pedidoitem where seqpedido = :seqpedido ');
              Qry.SQL.Add('and seqproduto = :seqproduto and quantidade = :quantidade ');
              Qry.SQL.Add('and observacao = :observacao');
              Qry.ParamByName('seqpedido').Value := SeqPedido;
              Qry.ParamByName('seqproduto').Value := SeqProduto;
              Qry.ParamByName('quantidade').Value := Quantidade;
              Qry.ParamByName('observacao').Value := Observacao;
              Qry.ExecSQL;
            end;
          end
          else
          begin
            Result := False;
            Erro := JSONObj.GetValue('mensagem').Value;
          end;
        end;
      end
      else
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('delete from tb_pedidoitem where seqpedido = :seqpedido ');
        Qry.SQL.Add('and seqproduto = :seqproduto and quantidade = :quantidade ');
        Qry.SQL.Add('and observacao = :observacao');
        Qry.ParamByName('seqpedido').Value := SeqPedido;
        Qry.ParamByName('seqproduto').Value := SeqProduto;
        Qry.ParamByName('quantidade').Value := Quantidade;
        Qry.ParamByName('observacao').Value := Observacao;
        Qry.ExecSQL;
      end;

      Result := True;
    finally
      Json := EmptyStr;
      FreeAndNil(JSONObj);
      Qry.DisposeOf;
    end;
  except
    Erro := 'Erro ao remover o pedido!';
    Result := False;
    Json := EmptyStr;
    FreeAndNil(JSONObj);
    Qry.DisposeOf;
  end;
end;

function TDM1.RemoverItemPedidoLocal(SeqProduto, Quantidade: Integer;
  Observacao: String; out Erro: String): Boolean;
var
  Qry : TFDQuery;
  SeqPedido: Integer;
  NroPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    try

      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido) as seqpedido, nropedido from tb_pedido');
      Qry.Active := True;

      if not (Qry.FieldByName('seqpedido').Value > 0) then
      begin
        Erro := 'Não foi possível encontrar o pedido';
        Exit;
      end;

      SeqPedido := Qry.FieldByName('seqpedido').Value;

      if not VerificarItemPedidoLocal(SeqProduto,Quantidade,Observacao, Erro) then
      begin
        if Erro = 'Não foi encontrado o produto' then
        begin
          Exit;
        end;
      end;

      if RemoverItemPedidoRemoto(SeqProduto,Quantidade,Observacao, Erro) then
      begin
        Result := True;
      end;

    except
      Erro := 'Erro ao remover o pedido!';
      Result := False;
      Qry.DisposeOf;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.RemoverPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
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
  {$ZEROBASEDSTRINGS OFF}
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

function TDM1.StatusPedido(SeqPedido: Integer; out Status: String): Boolean;
var
  Qry: TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('select status from tb_pedido where seqpedido = :seqpedido');
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.Active := True;

    if Qry.RecordCount > 0 then
    begin
      Status := Qry.FieldByName('status').Value;
      Result := True;
    end;

  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.VerificarItemPedidoLocal(SeqProduto, Quantidade: Integer;
  Observacao: String; out Erro: String): Boolean;
var
  Qry : TFDQuery;
  SeqPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    try

      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido) as seqpedido, nropedido from tb_pedido');
      Qry.Active := True;

      if not (Qry.FieldByName('seqpedido').Value > 0) then
      begin
        Erro := 'Não foi possível encontrar o pedido';
        Exit;
      end;

      SeqPedido := Qry.FieldByName('seqpedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido ');
      Qry.SQL.Add('and seqproduto = :seqproduto and quantidade = :quantidade ');
      Qry.SQL.Add('and observacao = :observacao');
      Qry.ParamByName('seqpedido').Value := SeqPedido;
      Qry.ParamByName('seqproduto').Value := SeqProduto;
      Qry.ParamByName('quantidade').Value := Quantidade;
      Qry.ParamByName('observacao').Value := Observacao;
      Qry.Active := True;

      if not (Qry.RecordCount > 0) then
      begin
        Erro := 'Não foi encontrado o produto';
        Exit;
      end;
      Result := True;
    except
      Erro := 'Erro ao encontrar o pedido!';
      Result := False;
      Qry.DisposeOf;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.VerificarPedidoAtivo: Boolean;
var
  Qry: TFDQuery;
  LPedido : Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido where ((status = ''P'') or (status = ''A'')) order by dtaultalteracao desc');
    Qry.Active := True;

    if Qry.RecordCount > 0 then
    begin
      LPedido := Qry.FieldByName('seqpedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := LPedido;
      Qry.Active := True;

      if Qry.RecordCount > 0 then
        Result := True;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.VerificarQtdItensPedido(SeqPedido: Integer; out Qtd: Integer;
  out Erro: String): Boolean;
var
  Qry: TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido');
      Qry.Active := True;

      if not (Qry.FieldByName('seqpedido').Value > 0) then
      begin
        Erro := 'Não foi possível encontrar o pedido';
        Exit;
      end;

      SeqPedido := Qry.FieldByName('seqpedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := SeqPedido;
      Qry.Active := True;

      Qtd := Qry.RecordCount;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Erro := 'Erro ao verificar a quantidade de itens do pedido';
  end;
end;

function TDM1.InserirEmpresa(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade, Estado: String; out Erro: String): Boolean;
var
  Qry: TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_empresa(nomeempresa, cnpj, endereco, numero, cep, cidade, estado) ');
      Qry.SQL.Add('values(:nomeempresa, :cnpj, :endereco, :numero, :cep, :cidade, :estado)');
      Qry.ParamByName('nomeempresa').Value := NomeEmpresa;
      Qry.ParamByName('cnpj').Value := CNPJ;
      Qry.ParamByName('endereco').Value := Endereco;
      Qry.ParamByName('numero').Value := Numero;
      Qry.ParamByName('cep').Value := CEP;
      Qry.ParamByName('cidade').Value := Cidade;
      Qry.ParamByName('estado').Value := Estado;
      Qry.ExecSQL;
      Result := True
    finally
      Qry.DisposeOf;
    end;
  except
    on E: Exception do
    begin
      Erro := E.Message;
      Result := False;
    end;
  end;
end;

function TDM1.InserirNroPedido(SeqPedido: Integer; NroPedido: String;
  out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
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

function TDM1.InserirPedido(Mesa: String; out SeqPedido: Integer;
  out Erro: String): Boolean;
var
  Qry : TFDQuery;
  LUsuario: Integer;
  I: Integer;
  LMaxPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    try
      LMaxPedido := 0;
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
      Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido');
      Qry.Active := True;
      if (Qry.RecordCount > 0) then
        LMaxPedido := Qry.FieldByName('seqpedido').AsInteger;
      
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_pedido(sequsuario, mesa, status, dtaabertura, dtaultalteracao) ');
      Qry.SQL.Add('values(:sequsuario, :mesa, :status, current_timestamp, current_timestamp) ');
      Qry.ParamByName('sequsuario').Value := LUsuario;
      Qry.ParamByName('mesa').Value := Mesa;
      Qry.ParamByName('status').Value := 'P';
      Qry.ExecSQL;

      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido');
      Qry.Active := True;

      if (Qry.RecordCount = 0) or (Venda.Pedido.ListaProdutos.Count = 0) then
      begin
        Erro := 'Erro ao criar o pedido! Tente novamente ou chame um atendente';
        Exit;
      end;

      if not (Qry.FieldByName('seqpedido').AsInteger = LMaxPedido + 1)then
      begin        
        Erro := 'Erro ao criar o pedido! Tente novamente ou chame um atendente';
        Exit;
      end;
      SeqPedido := Qry.FieldByName('seqpedido').Value;

      for I := 0 to Venda.Pedido.ListaProdutos.Count - 1 do
      begin
        Qry.SQL.Clear;
        Qry.SQL.Add('insert into tb_pedidoitem(seqpedido, seqproduto, quantidade, observacao) ');
        Qry.SQL.Add('values(:seqpedido, :seqproduto, :quantidade, :observacao) ');
        Qry.ParamByName('seqpedido').Value := SeqPedido;
        Qry.ParamByName('seqproduto').Value := Venda.Pedido.ListaProdutos.Items[I].IDProduto;
        Qry.ParamByName('quantidade').Value := Venda.Pedido.ListaProdutos.Items[I].Quantidade;
        Qry.ParamByName('observacao').Value := Venda.Pedido.ListaProdutos.Items[I].Observacao;
        Qry.ExecSQL;
      end;
      Result := True;
    finally      
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
  {$ZEROBASEDSTRINGS OFF}
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

function TDM1.AtualizarEmpresa(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade, Estado: String; out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_empresa set nomeempresa = :nomeempresa, cnpj = :cnpj, endereco = :endereco, ');
      Qry.SQL.Add('numero = :numero, cep = :cep, cidade = :cidade, estado = :estado');
      Qry.ParamByName('nomeempresa').Value := NomeEmpresa;
      Qry.ParamByName('cnpj').Value := CNPJ;
      Qry.ParamByName('endereco').Value := Endereco;
      Qry.ParamByName('numero').Value := Numero;
      Qry.ParamByName('cep').Value := CEP;
      Qry.ParamByName('cidade').Value := Cidade;
      Qry.ParamByName('estado').Value := Estado;
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    on E: Exception do
    begin
      Erro := E.Message;
      Result := False;
    end;
  end;
end;

function TDM1.AtualizarItensPedido(Mesa: String; out Erro: String): Boolean;
var
  Qry : TFDQuery;
  LUsuario: Integer;
  LPedido: Integer;
  I: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
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
      Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido');
      Qry.Active := True;

      if (Qry.RecordCount = 0) or (Venda.Pedido.ListaProdutos.Count = 0) then
      begin
        Erro := 'Erro ao inserir novos itens no pedido! Tente novamente ou chame um atendente';
        Exit;
      end;

      LPedido := Qry.FieldByName('seqpedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := LPedido;
      Qry.Active := True;

      for I := Qry.RecordCount to Venda.Pedido.ListaProdutos.Count - 1 do
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
    Erro := 'Erro ao inserir novos itens no Pedido';
  end;
end;

function TDM1.AtualizarSenhaUsuario(Email, Senha: String): Boolean;
var
  Qry : TFDQuery;
begin
  {$ZEROBASEDSTRINGS OFF}
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
  NroPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido), nropedido from tb_pedido');
      Qry.Active := True;
      if Qry.RecordCount = 0 then
        Exit;

      if (Qry.FieldByName('nropedido').IsNull) or (Qry.FieldByName('nropedido').Value = 0) then
        Exit;

      NroPedido := Qry.FieldByName('nropedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_pedido set status = :status where nropedido = :nropedido');
      Qry.ParamByName('nropedido').Value := NroPedido;
      Qry.ParamByName('status').Value := Status;
      Qry.ExecSQL;
      Result := True;
    finally
      Qry.DisposeOf;
    end;
  except
    Erro := 'Erro ao atualizar o status do pedido';
    Qry.DisposeOf;
    Result := False;
  end;
end;

function TDM1.ObterCardapio(out Qry: TFDQuery): Boolean;
begin
  {$ZEROBASEDSTRINGS OFF}
  Result := False;
  if not Assigned(Qry) then
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
  {$ZEROBASEDSTRINGS OFF}
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
  {$ZEROBASEDSTRINGS OFF}
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

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
  {$ZEROBASEDSTRINGS OFF}
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

function TDM1.FinalizarPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Json : String;
  JSONObj: TJsonObject;
  JSONValue: uDWJSONObject.TJSONValue;
  Qry : TFDQuery;
  Status: String;
  NroPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    JSONValue := uDWJSONObject.TJSONValue.Create;
    JSONObj := TJSONObject.Create;
    JSONValue.Encoding := TEncodeSelect.esUtf8;
    Erro := '';

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select max(seqpedido) as seqpedido, nropedido from tb_pedido ');
    Qry.Active := True;

    if not (Qry.FieldByName('nropedido').Value > 0) then
    begin
      Erro := 'Não foi possível encontrar o número do pedido';
      Exit;
    end;

    NroPedido := Qry.FieldByName('nropedido').Value;
    SeqPedido := Qry.FieldByName('seqpedido').Value;

    if not ObterStatusPedido(SeqPedido, Erro, Status) then
      Exit;

    try
      with RequestEncerrarPedido do
      begin
        Params.Clear;
        AddParameter('seqpedido', NroPedido.ToString, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
      end;
    except on ex:exception do
      begin
        Result := False;
        Erro := 'Erro ao encerrar o pedido: ' + ex.Message;
        Exit;
      end;
    end;

    if RequestEncerrarPedido.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro ao encerrar o pedido: ' + RequestEncerrarPedido.Response.StatusCode.ToString;
    end
    else
    begin
      Json := RequestEncerrarPedido.Response.JSONValue.ToString;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

      if JSONObj.GetValue('retorno').Value = 'OK' then
      begin
        if AtualizarStatusPedido(SeqPedido, 'F', Erro) then
          Result := True;
      end
      else
      begin
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
      end;
    end;
  finally
    Json := EmptyStr;
    FreeAndNil(JSONValue);
    FreeAndNil(JSONObj);
    Qry.DisposeOf;
  end;
end;

function TDM1.FinalizarPedidosPendentes: Boolean;
var
  Qry: TFDQuery;
  LPedido : Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido where ((status = ''P'') or (status = ''A'')) order by dtaultalteracao desc');
    Qry.Active := True;

    if Qry.RecordCount > 0 then
    begin
      if Qry.FieldByName('seqpedido').IsNull then
        Exit;

      LPedido := Qry.FieldByName('seqpedido').Value;

      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_pedido set status = ''C'' where not (seqpedido = :seqpedido)');
      Qry.ParamByName('seqpedido').Value := LPedido;
      Qry.ExecSQL;

      Result := True;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.CancelarPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Json : String;
  JSONObj: TJsonObject;
  JSONValue: uDWJSONObject.TJSONValue;
  Qry : TFDQuery;
  Status: String;
  NroPedido: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    JSONValue := uDWJSONObject.TJSONValue.Create;
    JSONObj := TJSONObject.Create;
    JSONValue.Encoding := TEncodeSelect.esUtf8;
    Erro := '';

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select max(seqpedido) as seqpedido, nropedido from tb_pedido ');
    Qry.Active := True;

    if not (Qry.FieldByName('nropedido').Value > 0) then
    begin
      Erro := 'Não foi possível encontrar o número do pedido';
      Exit;
    end;

    NroPedido := Qry.FieldByName('nropedido').Value;
    SeqPedido := Qry.FieldByName('seqpedido').Value;

    if not ObterStatusPedido(SeqPedido, Erro, Status ) then
      Exit;

    try
      with RequestCancelarPedido do
      begin
        Params.Clear;
        AddParameter('seqpedido', NroPedido.ToString, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
      end;
    except on ex:exception do
      begin
        Result := False;
        Erro := 'Erro ao cancelar o pedido: ' + ex.Message;
        Exit;
      end;
    end;

    if RequestCancelarPedido.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro ao cancelar o pedido: ' + RequestCancelarPedido.Response.StatusCode.ToString;
    end
    else
    begin
      Json := RequestCancelarPedido.Response.JSONValue.ToString;
      JSONObj := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(JSON), 0) as TJSONObject;

      if JSONObj.GetValue('retorno').Value = 'OK' then
      begin
        if AtualizarStatusPedido(SeqPedido, 'C', Erro) then
          Result := True;
      end
      else
      begin
        Result := False;
        Erro := JSONObj.GetValue('mensagem').Value;
      end;
    end;
  finally
    Qry.DisposeOf;
    Json := EmptyStr;
    FreeAndNil(JSONValue);
    FreeAndNil(JSONObj);
  end;
end;

function TDM1.AtualizarPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Json : String;
  JSONObj: TJsonObject;
  JSONValue: uDWJSONObject.TJSONValue;
  Qry : TFDQuery;
  LMesa: String;
  LPedido: Integer;
  LCount: Integer;
  LMaxItemBefore: Integer;
begin
  {$ZEROBASEDSTRINGS OFF}
  try
    Result := False;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    JSONValue := uDWJSONObject.TJSONValue.Create;
    JSONObj := TJSONObject.Create;

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

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido ');
    Qry.Active := True;
    SeqPedido := Qry.FieldByName('seqpedido').Value;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select max(seqpedidoitem) as seqpedidoitem from tb_pedidoitem where seqpedido = :seqpedido');
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.Active := True;

    LMaxItemBefore := Qry.FieldByName('seqpedidoitem').Value;

    if not AtualizarItensPedido(LMesa, Erro) then
      Exit;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido ');
    Qry.SQL.Add('and seqpedidoitem > :maxitem');
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.ParamByName('maxitem').Value := LMaxItemBefore;
    Qry.Active := True;

    if Qry.RecordCount = 0 then
    begin
      Erro := 'Não existem itens no pedido';
      Exit;
    end;

    JSONValue.Encoding := TEncodeSelect.esUtf8;
    JSONValue.LoadFromDataset('', Qry, False, jmPureJSON);

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select nropedido from tb_pedido where seqpedido = :seqpedido ');
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.Active := True;

    if not (Qry.FieldByName('nropedido').Value > 0) then
    begin
      Erro := 'Não foi possível encontrar o número do pedido';
      Exit;
    end;

    LPedido := Qry.FieldByName('nropedido').Value;  // nropedido = seqpedido da tb_pedido remota
    Erro := '';

    try
      with RequestAtualizarPedido do
      begin
        Params.Clear;
        AddParameter('seqpedido', LPedido.ToString, TRESTRequestParameterKind.pkGETorPOST);
        AddParameter('pedido', JSONValue.ToJSON, TRESTRequestParameterKind.pkGETorPOST);
        Execute;
      end;
    except on ex:exception do
      begin
        Result := false;
        Erro := 'Erro ao atualizar os itens do pedido: ' + ex.Message;
        Exit;
      end;
    end;

    if RequestAtualizarPedido.Response.StatusCode <> 200 then
    begin
      Result := False;
      Erro := 'Erro ao atualizar os itens do pediddo: ' + RequestAtualizarPedido.Response.StatusCode.ToString;
    end
    else
    begin
      Json := RequestAtualizarPedido.Response.JSONValue.ToString;
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
    Qry.DisposeOf;
    Json := EmptyStr;
    FreeAndNil(JSONValue);
    FreeAndNil(JSONObj);
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
  {$ZEROBASEDSTRINGS OFF}
  try
    FinalizarPedidosPendentes;

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

    if not InserirPedido(LMesa, LPedido, Erro) then   // out numero pedido criado
      Exit;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido');
    Qry.ParamByName('seqpedido').Value := LPedido;
    Qry.Active := True;

    if Qry.RecordCount = 0 then
    begin
      Erro := 'Não existem itens no pedido';
      Exit;
    end;

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
      Erro := 'Erro ao criar pedido: ' + RequestCriarPedido.Response.StatusCode.ToString;
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
  {$ZEROBASEDSTRINGS OFF}
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
  {$ZEROBASEDSTRINGS OFF}
  Erro := '';
  Result := False;
  try
    with RequestListarProduto do
    begin
      Params.Clear;
      Execute;
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
      Json := EmptyStr;
    end;
  except on ex:exception do
    begin
      Erro := 'Erro ao listar produto: ' + ex.Message;
      Exit;
    end;
  end;

end;

end.
