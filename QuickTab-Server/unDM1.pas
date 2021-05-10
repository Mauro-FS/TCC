unit unDM1;

interface

uses
  System.SysUtils, System.Classes, uDWDataModule, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.FMXUI.Wait, Data.DB, FireDAC.Comp.Client, uDWAbout,
  uRESTDWServerEvents, System.JSON, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, uDWJSONObject,
  uDWConsts, REST.Types, Data.Bind.Components, Data.Bind.ObjectScope,
  REST.Client, uDWConstsData, uRESTDWBase, uRESTDWPoolerDB, uDWDataset,
  FMX.Dialogs, FMX.Objects,unUtils, FireDAC.VCLUI.Wait;

type
  TDM1 = class(TServerMethodDataModule)
    conn: TFDConnection;
    DWEvents: TDWServerEvents;
    QryLogin: TFDQuery;
    procedure DWEventsEventsListarProdutoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsAdicionarProdutoPedidoReplyEvent(
      var Params: TDWParams; var Result: string);
    procedure DWEventsEventsExcluirProdutoPedidoReplyEvent(
      var Params: TDWParams; var Result: string);
    procedure DWEventsEventsObterStatusPedidoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsEncerrarPedidoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsCriarPedidoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsListarProdutoPedidoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsObterEmpresaReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsSolicitarAtendenteReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsCancelarPedidoReplyEvent(var Params: TDWParams;
      var Result: string);
    procedure DWEventsEventsAtualizarPedidoReplyEvent(var Params: TDWParams;
      var Result: string);

  private
    { Private declarations }
  public
    function AdicionarMesa: String;
    function TrocarStatusMesa(Mesa: String): Boolean;
    function ObterStatusMesa(Mesa: String): String;
    function ObterMesas(var Mesas: TFDQuery): Boolean;
    function AdicionarConfiguracoes(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade, Estado: String): Boolean;
    function AtualizarConfiguracoes(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade, Estado: String): Boolean;
    function AtualizarInfoServidor(PortaServidor: String): Boolean;
    function ChecarConfiguracoes: Boolean;
    function BuscarConfiguracoes(var Qry: TFDQuery): Boolean;
    function ChecarInfoServidor: Boolean;
    function BuscarInfoServidor(var Qry: TFDQuery): Boolean;
    function CarregarCategorias(var Qry: TFDQuery): Boolean;
    function BuscarCategoria(SeqCategoria: String): String;
    function DescricaoCategoria(NomeCategoria: String): String;
    function BuscarSeqCategoria(NomeCategoria: String): Integer;

    function AdicionarProduto(Nome, Categoria, Preco, Descricao: String; Imagem: TImage = nil): Boolean;
    function AlterarProduto(Seqproduto, Nome, Categoria, Preco, Descricao: String; Imagem: TImage = nil): Boolean;
    function AtivarProduto(Seqproduto: String): Boolean;
    function DesativarProduto(Seqproduto: String): Boolean;
    function ListarProdutos(var Qry: TFDQuery): Boolean;
    function BuscarProduto(var Qry: TFDQuery; SeqProduto: Integer): Boolean;

    function ListarPedidos(var Qry: TFDQuery): Boolean;
    function ListarPedidosRecebidos(var Qry: TFDQuery): Boolean;
    function AlterarStatusPedido(Status: String; SeqPedido: Integer): Boolean;
    function ListarProdutosPedido(var Qry: TFDQuery; Seqpedido: String): Boolean;
    function CancelarPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function FinalizarPedido(SeqPedido: Integer; out Erro: String): Boolean;
    function VerificarStatusPedido(SeqPedido: Integer; out Status: String): Boolean;
    function AtualizarStatusItensPedido(SeqPedido: Integer; Status: String): Boolean;
  end;

var
  DM1: TDM1;

implementation

uses
  unPrincipal, System.IOUtils;
{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

function TDM1.AdicionarProduto(Nome, Categoria, Preco, Descricao: String;
  Imagem: TImage = nil): Boolean;
var
  Qry : TFDQuery;
  Stream: TMemoryStream;
begin
  Result := False;
  Stream := TMemoryStream.Create;
  if Imagem.Bitmap.IsEmpty then
    Imagem.Bitmap.LoadFromFile(TDirectory.GetParent(GetCurrentDir) + PathDelim +  'resources\imagens\Produto.png' );

  Imagem.Bitmap.SaveToStream(Stream);
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;

    Qry.SQL.Add('insert into tb_produto(nome, descricao, categoria, preco, status, imagem) ');
    Qry.SQL.Add('values(:nome, :descricao, :categoria, :preco, ''A'', :imagem )');
    Qry.ParamByName('nome').Value := Nome;
    Qry.ParamByName('descricao').Value := Descricao;
    Qry.ParamByName('categoria').Value := BuscarCategoria(Categoria);
    Qry.ParamByName('preco').Value := StrToFloatDef(Preco, 0.00);
    if not (Imagem.Bitmap.IsEmpty) then
      Qry.ParamByName('imagem').AsStream := Stream
    else
      Qry.ParamByName('imagem').Value := '';

    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.AlterarProduto(Seqproduto, Nome, Categoria, Preco,
  Descricao: String; Imagem: TImage): Boolean;
var
  Qry : TFDQuery;
  Stream: TMemoryStream;
begin
  Result := False;
  Stream := TMemoryStream.Create;
  if Imagem.Bitmap.IsEmpty then
    Imagem.Bitmap.LoadFromFile(TDirectory.GetParent(GetCurrentDir) + PathDelim +  'resources\imagens\Produto.png' );
  Imagem.Bitmap.SaveToStream(Stream);
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('update tb_produto set nome = :nome, descricao = :descricao, ');
    Qry.SQL.Add('categoria = :categoria, preco = :preco, imagem = :imagem ');
    Qry.SQL.Add('where seqproduto = :seqproduto ');
    Qry.ParamByName('nome').Value := Nome;
    Qry.ParamByName('descricao').Value := Descricao;
    Qry.ParamByName('categoria').Value := BuscarCategoria(Categoria);
    Qry.ParamByName('preco').Value := StrToFloatDef(Preco, 0.00);
    Qry.ParamByName('seqproduto').Value := SeqProduto.ToInteger;
    if not (Imagem.Bitmap.IsEmpty) then
      Qry.ParamByName('imagem').AsStream := Stream
    else
      Qry.ParamByName('imagem').Value := '';
    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.AlterarStatusPedido(Status: String; SeqPedido: Integer): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('update tb_pedido set status = :status , dtaultalteracao = current_timestamp');
    Qry.SQL.Add('where seqpedido = :seqpedido');
     Qry.ParamByName('status').Value := Status;
    Qry.ParamByName('seqpedido').Value := SeqPedido;
    Qry.ExecSQL;

    AtualizarStatusItensPedido(SeqPedido, Status);
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.AtivarProduto(Seqproduto: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('update tb_produto set status = ''A'' ');
    Qry.SQL.Add('where seqproduto = :seqproduto');
    Qry.ParamByName('seqproduto').Value := SeqProduto.ToInteger;
    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.AtualizarConfiguracoes(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade,
  Estado: String): Boolean;
var
  Qry : TFDQuery;
begin
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
    Qry.ParamByName('numero').Value := Numero.ToInteger;
    Qry.ParamByName('cep').Value := CEP.ToInteger;
    Qry.ParamByName('cidade').Value := Cidade;
    Qry.ParamByName('estado').Value := Estado;
    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.AtualizarInfoServidor(PortaServidor: String): Boolean;
var
  Qry : TFDQuery;
begin
  try
    Result := False;
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_empresa set portaservidor = :portaservidor ');
      Qry.ParamByName('portaservidor').Value := PortaServidor;
      Qry.ExecSQL;
    finally
      Result := True;
      Qry.DisposeOf;
    end;
  except
    Result := False;
  end;
end;

function TDM1.AtualizarStatusItensPedido(SeqPedido: Integer;
  Status: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('update tb_pedidoitem set status = :status where seqpedido = :seqpedido ');
    Qry.ParamByName('seqpedido').Value := Seqpedido;
    Qry.ParamByName('status').Value := Status;
    Qry.ExecSQL;

    Result := True;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.BuscarCategoria(SeqCategoria: String): String;
var
  Qry: TFDQuery;
begin
  try
    try
      Result := 'catPrato';
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_categoria where seqcategoria = :seqcategoria ');
      Qry.ParamByName('seqcategoria').Value := SeqCategoria;
      Qry.Active := True;
    finally
      if Qry.RecordCount > 0 then
        Result := Qry.FieldByName('nome').AsString;
      Qry.DisposeOf;
    end;
  except
    Result := 'catPrato';
  end;
end;

function TDM1.BuscarConfiguracoes(var Qry: TFDQuery): Boolean;
begin
  try
    try
      Result := False;
      if Qry = nil then
        Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_empresa ');
      Qry.Active := True;
    finally
      if Qry.RecordCount > 0 then
        Result := True;
    end;
  except
    Result := False;
  end;
end;

function TDM1.BuscarInfoServidor(var Qry: TFDQuery): Boolean;
begin
  try
    try
      Result := False;
      if Qry = nil then
        Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select portaservidor from tb_empresa where not (portaservidor is null)');
      Qry.Active := True;
    finally
      if Qry.RecordCount > 0 then
        Result := True;
    end;
  except
    Result := False;
  end;
end;

function TDM1.BuscarProduto(var Qry: TFDQuery; SeqProduto: Integer): Boolean;
begin
  try
    Result := False;
    if Qry = nil then
      Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_produto where seqproduto = :seqproduto');
    Qry.ParamByName('seqproduto').Value := SeqProduto;
    Qry.Active := True;
  finally
    if Qry.RecordCount > 0 then
      Result := True;
  end;
end;

function TDM1.BuscarSeqCategoria(NomeCategoria: String): Integer;
var
  Qry: TFDQuery;
begin
  try
    try
      Result := 1;
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_categoria where nome = :nome ');
      Qry.ParamByName('nome').Value := NomeCategoria;
      Qry.Active := True;
    finally
      if Qry.RecordCount > 0 then
        Result := Qry.FieldByName('seqcategoria').AsInteger;
      Qry.DisposeOf;
    end;
  except
    Result := 1;
  end;
end;

function TDM1.DesativarProduto(Seqproduto: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('update tb_produto set status = ''I'' ');
    Qry.SQL.Add('where seqproduto = :seqproduto');
    Qry.ParamByName('seqproduto').Value := SeqProduto.ToInteger;
    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.DescricaoCategoria(NomeCategoria: String): String;
var
  Qry: TFDQuery;
begin
  try
    try
      Result := 'Pratos';
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_categoria where nome = :nome ');
      Qry.ParamByName('nome').Value := NomeCategoria;
      Qry.Active := True;
    finally
      if Qry.RecordCount > 0 then
        Result := Qry.FieldByName('descricao').AsString;
      Qry.DisposeOf;
    end;
  except
    Result := 'Pratos';
  end;
end;

procedure TDM1.DWEventsEventsAdicionarProdutoPedidoReplyEvent(
  var Params: TDWParams; var Result: string);
var
  Json : TJsonObject;
  Qry : TFDQuery;
begin
  try
    Json := TJsonObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    // Validar parametros...
    if (Params.ItemsString['seqproduto'].AsString = '') or
       (Params.ItemsString['seqpedido'].AsString = '') or
       (Params.ItemsString['quantidade'].AsString = '') then
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', 'Parametros não informados');
      Result := Json.ToString;
      Exit;
    end;

    try

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('update tb_pedido set status = ''A'', ');
      Qry.SQL.Add('dtaultalteracao = coalesce(dtaultalteracao, current_timestamp) ');
      Qry.SQL.Add('where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := Params.ItemsString['seqpedido'].AsString;
      Qry.ExecSQL;

      // Insere o item no consumo...
      Qry.Active := false;
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_pedidoitem(seqpedido, seqproduto, quantidade, observacao) ');
      Qry.SQL.Add('values(:seqpedido, :seqproduto, :quantidade, :observacao ');
      Qry.ParamByName('seqpedido').Value := Params.ItemsString['seqpedido'].AsInteger;
      Qry.ParamByName('seqproduto').Value := Params.ItemsString['seqproduto'].AsInteger;
      Qry.ParamByName('quantidade').Value := Params.ItemsString['quantidade'].AsInteger;
      Qry.ParamByName('observacao').Value := Params.ItemsString['observacao'].AsString;
      Qry.ExecSQL;

      Json.AddPair('retorno', 'OK');
      Json.AddPair('mensagem', 'Produto adicionado');

    except on ex:exception do
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', ex.Message);
    end;
    end;

    Result := Json.ToString;

  finally
    Qry.DisposeOf;
    Json.DisposeOf;
  end;

end;

procedure TDM1.DWEventsEventsAtualizarPedidoReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Qry : TFDQuery;
  Json : TJsonObject;
  DataSet: TFDDataSet;
  LUsuario: Integer;
  LPedido: Integer;
  I: Integer;
  LMesa: String;
  LStatus: String;
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Json := TJsonObject.Create;
    JSONValue := TJSONValue.Create;
    try
      if (Params.ItemsString['seqpedido'].AsString = '') or
       (Params.ItemsString['pedido'].AsString = '')then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Informações incompletas');
        Result := Json.ToString;
        Exit;
      end;

      JSONArray := TJSONObject.ParseJSONValue(TEncoding.UTF8
       .GetBytes(Params.ItemsString['pedido'].AsString), 0) as TJSONArray;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedido ');
      Qry.SQL.Add('where seqpedido = :seqpedido' );
      Qry.ParamByName('seqpedido').Value := Params.ItemsString['seqpedido'].AsString;
      Qry.Active := True;

      if Qry.RecordCount = 0 then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Pedido não encontrado');
        Result := Json.ToString;
        Exit;
      end;

      LPedido := Qry.FieldByName('seqpedido').AsInteger;

      if not AlterarStatusPedido('P', LPedido) then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Não foi possível alterar o status do pedido');
        Result := Json.ToString;
        Exit;
      end;

      if JSONArray.Size > 0 then
      begin
        for I := 0 to JSONArray.Size - 1 do
        begin
          Qry.Active := false;
          Qry.SQL.Clear;
          Qry.SQL.Add('insert into tb_pedidoitem(seqpedido, seqproduto, quantidade, observacao, status)');
          Qry.SQL.Add('values(:seqpedido, :seqproduto, :quantidade, :observacao, :status)');
          Qry.ParamByName('seqpedido').Value := LPedido;
          Qry.ParamByName('seqproduto').Value := JSONArray.Items[I].GetValue<Integer>('seqproduto');
          Qry.ParamByName('quantidade').Value := JSONArray.Items[I].GetValue<Integer>('quantidade');
          Qry.ParamByName('observacao').Value := JSONArray.Items[I].GetValue<String>('observacao');
          Qry.ParamByName('status').Value := 'P';
          Qry.ExecSQL;
        end;
      end;

      Json.AddPair('retorno', 'OK');
      Json.AddPair('mensagem', 'Pedido criado');
      Json.AddPair('nropedido', LPedido.ToString);
      Result := Json.ToString;

      frmPrincipal.AtualizarPedido(LMesa, 'P', LPedido.ToString);
    except
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', 'Erro ao cadastrar o pedido');
      Result := Json.ToString;
    end;
  finally
    Json.DisposeOf;
    Qry.DisposeOf;
    JSONValue.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsCancelarPedidoReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Json : TJsonObject;
  Qry : TFDQuery;
  Erro: String;
begin
  try
    Json := TJsonObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    // Validar parametros...
    if Params.ItemsString['seqpedido'].AsString = '' then
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', 'Parametros não informados');
      Result := Json.ToString;
      Exit;
    end;

    try
     if not (CancelarPedido(Params.ItemsString['seqpedido'].AsInteger, Erro)) then
     begin
       Json.AddPair('retorno', 'Erro');
       Json.AddPair('mensagem', Erro);
       Result := Json.ToString;
       Exit;
     end;

     Json.AddPair('retorno', 'OK');
     Json.AddPair('mensagem', 'Pedido cancelado');

    except on ex:exception do
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', ex.Message);
    end;
    end;

    frmPrincipal.GetPedidos;
    Result := Json.ToString;
  finally
    Qry.DisposeOf;
    Json.DisposeOf;
  end;

end;

procedure TDM1.DWEventsEventsCriarPedidoReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Qry : TFDQuery;
  Json : TJsonObject;
  DataSet: TFDDataSet;
  LUsuario: Integer;
  LPedido: Integer;
  I: Integer;
  LMesa: String;
  LStatus: String;
  JSONValue: TJSONValue;
  JSONArray: TJSONArray;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Json := TJsonObject.Create;
    JSONValue := TJSONValue.Create;
    try
      if (Params.ItemsString['cpf'].AsString = '') or
       (Params.ItemsString['nome'].AsString = '') or
       (Params.ItemsString['email'].AsString = '') or
       (Params.ItemsString['mesa'].AsString = '') or
       (Params.ItemsString['pedido'].AsString = '')then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Informações incompletas');
        Result := Json.ToString;
        Exit;
      end;

      JSONArray := TJSONObject.ParseJSONValue(TEncoding.UTF8
       .GetBytes(Params.ItemsString['pedido'].AsString), 0) as TJSONArray;
//      DWMemtable.Close;
//      DWMemtable.Open;
//      JSONValue.WriteToDataset(dtFull, Params.ItemsString['pedido'].AsString, DWMemtable);

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_usuario where cpf = :cpf');
      Qry.ParamByName('cpf').Value := Params.ItemsString['cpf'].AsString;
      Qry.Active := True;

      if not (Qry.RecordCount > 0) then
      begin
        Qry.Active := False;
        Qry.SQL.Clear;
        Qry.SQL.Add('insert into tb_usuario(nome, cpf, email) values(:nome, :cpf, :email)');
        Qry.ParamByName('nome').Value := Params.ItemsString['nome'].AsString;
        Qry.ParamByName('cpf').Value := Params.ItemsString['cpf'].AsString;
        Qry.ParamByName('email').Value := Params.ItemsString['email'].AsString;
        Qry.Active := true;

        Qry.Active := False;
        Qry.SQL.Clear;
        Qry.SQL.Add('select * from tb_usuario where cpf = :cpf');
        Qry.ParamByName('cpf').Value := Params.ItemsString['cpf'].AsString;
        Qry.Active := True;
      end;

      LUsuario := Qry.FieldByName('sequsuario').AsInteger;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_pedido(sequsuario, mesa, status, statusimpressao, ');
      Qry.SQL.Add('dtaabertura, dtaultalteracao) values(:sequsuario, :mesa, ''P'', ');
      Qry.SQL.Add('''P'', current_timestamp, current_timestamp)');
      Qry.ParamByName('sequsuario').Value := LUsuario;
      Qry.ParamByName('mesa').Value := Params.ItemsString['mesa'].AsString;
      Qry.ExecSQL;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select max(seqpedido) as seqpedido from tb_pedido ');
      Qry.SQL.Add('where sequsuario = :sequsuario and mesa = :mesa' );
      Qry.ParamByName('sequsuario').Value := LUsuario;
      Qry.ParamByName('mesa').Value := Params.ItemsString['mesa'].AsString;
      Qry.Active := True;

      LPedido := Qry.FieldByName('seqpedido').AsInteger;
      LMesa := Params.ItemsString['mesa'].AsString;
      LStatus := 'P';

      if JSONArray.Size > 0 then
      begin
        for I := 0 to JSONArray.Size - 1 do
        begin
          Qry.Active := false;
          Qry.SQL.Clear;
          Qry.SQL.Add('insert into tb_pedidoitem(seqpedido, seqproduto, quantidade, observacao, status)');
          Qry.SQL.Add('values(:seqpedido, :seqproduto, :quantidade, :observacao, :status)');
          Qry.ParamByName('seqpedido').Value := LPedido;
          Qry.ParamByName('seqproduto').Value := JSONArray.Items[I].GetValue<Integer>('seqproduto');
          Qry.ParamByName('quantidade').Value := JSONArray.Items[I].GetValue<Integer>('quantidade');
          Qry.ParamByName('observacao').Value := JSONArray.Items[I].GetValue<String>('observacao');
          Qry.ParamByName('status').Value := 'P';
          Qry.ExecSQL;
        end;
      end;


      Json.AddPair('retorno', 'OK');
      Json.AddPair('mensagem', 'Pedido criado');
      Json.AddPair('nropedido', LPedido.ToString);
      Result := Json.ToString;

      frmPrincipal.AdicionarPedido(LMesa, LStatus, LPedido.ToString);
    except
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', 'Erro ao cadastrar o pedido');
      Result := Json.ToString;
    end;
  finally
    Json.DisposeOf;
    Qry.DisposeOf;
    JSONValue.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsEncerrarPedidoReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Json : TJsonObject;
  Qry : TFDQuery;
  Erro: String;
begin
  try
    Json := TJsonObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    if (Params.ItemsString['seqpedido'].AsString = '') then
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', 'Parametro não informado');
      Result := Json.ToString;
      Exit;
    end;

    try
      if not (FinalizarPedido(Params.ItemsString['seqpedido'].AsInteger, Erro)) then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', Erro);
        Result := Json.ToString;
        Exit;
      end;

      Json.AddPair('retorno', 'OK');
      Json.AddPair('mensagem', 'Pedido encerrado, aguarde sua conta');

    except on ex:exception do
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', ex.Message);
    end;
    end;

    frmPrincipal.GetPedidos;
    Result := Json.ToString;

  finally
    Qry.DisposeOf;
    Json.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsExcluirProdutoPedidoReplyEvent(
  var Params: TDWParams; var Result: string);
var
  Json : TJsonObject;
  Qry : TFDQuery;
begin
  try
    Json := TJsonObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    // Validar parametros...
    if (Params.ItemsString['seqpedido'].AsString = '') or
       (Params.ItemsString['seqpedidoitem'].AsString = '') then
    begin
      Json.AddPair('retorno', 'Parametros não informados');
      Result := Json.ToString;
      Exit;
    end;

    try
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedido where seqpedido = :seqpedido');
      Qry.Active := True;
      if (Qry.RecordCount > 0) then
      begin
        if (Qry.FieldByName('status').AsString = 'F') then
        begin
          Json.AddPair('retorno', 'Erro');
          Json.AddPair('mensagem', 'Pedido fechado, não é possível excluir o produto');
          Result := Json.ToString;
          Exit;
        end;

        if (Qry.FieldByName('status').AsString = 'C') then
        begin
          Json.AddPair('retorno', 'Erro');
          Json.AddPair('mensagem', 'Pedido cancelado, não é possível excluir o produto');
          Result := Json.ToString;
          Exit;
        end;
      end;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('delete from tb_pedidoitem where seqpedido = :seqpedido and ');
      Qry.SQL.Add('seqpedidoitem = :seqpedidoitem ');
      Qry.ParamByName('seqpedido').Value := Params.ItemsString['seqpedido'].AsString;
      Qry.ParamByName('seqpedidoitem').Value := Params.ItemsString['seqpedidoitem'].AsString;
      Qry.ExecSQL;

      Json.AddPair('retorno', 'OK');
      Json.AddPair('mensagem', 'Produto removido com sucesso');

    except on ex:exception do
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', ex.Message);
    end;
    end;

    Result := Json.ToString;

  finally
    Qry.DisposeOf;
    Json.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsListarProdutoPedidoReplyEvent(
  var Params: TDWParams; var Result: string);
var
  Qry : TFDQuery;
  Json : uDWJSONObject.TJSONValue;
begin
  try
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;

      Json := uDWJSONObject.TJSONValue.Create;

      if (Params.ItemsString['seqpedido'].AsString = '') then
      begin
        Result := 'Erro';
        Exit;
      end;

      Qry.Active := false;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_pedidoitem where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := Params.ItemsString['seqpedido'].AsString;
      Qry.Active := True;

      Json.LoadFromDataset('', Qry, False, jmPureJSON);
      Result := Json.ToJSON;
    except
      Result := 'Erro';
    end;
  finally
    Json.DisposeOf;
    Qry.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsListarProdutoReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Qry : TFDQuery;
  Json : uDWJSONObject.TJSONValue;
begin
  try
    try
      Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;

      Json := uDWJSONObject.TJSONValue.Create;

      Qry.Active := false;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_produto order by categoria asc');
      Qry.Active := True;

      Json.LoadFromDataset('', Qry, False, jmPureJSON);
      Result := Json.ToJSON;
    except
      Result := 'Erro';
    end;
  finally
    Json.DisposeOf;
    Qry.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsObterEmpresaReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Json : TJsonObject;
  Qry : TFDQuery;
begin
  try
    Json := TJsonObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    try
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_empresa');
      Qry.Active := True;
      if Qry.RecordCount = 0 then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Informações do estabelecimento não encontradas');
        Result := Json.ToString;
        Exit;
      end;

      Result := Json.ToString;
      Json.AddPair('retorno', 'OK');
      Json.AddPair('nomeempresa', Qry.FieldByName('nomeempresa').AsString);
      Json.AddPair('endereco', Qry.FieldByName('endereco').AsString);
      Json.AddPair('numero', Qry.FieldByName('numero').AsString);
      Json.AddPair('cnpj', Qry.FieldByName('cnpj').AsString);
      Json.AddPair('cep', Qry.FieldByName('cep').AsString);
      Json.AddPair('cidade', Qry.FieldByName('cidade').AsString);
      Json.AddPair('estado', Qry.FieldByName('estado').AsString);
      Json.AddPair('portaservidor', Qry.FieldByName('portaservidor').AsString);

    except on ex:exception do
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', ex.Message);
    end;
    end;

    Result := Json.ToString;

  finally
    Qry.DisposeOf;
    Json.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsObterStatusPedidoReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Json : TJsonObject;
  Qry : TFDQuery;
begin
  try
    Json := TJsonObject.Create;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    // Validar parametros...
    if (Params.ItemsString['seqpedido'].AsString = '') then
    begin
      Json.AddPair('retorno', 'Parametro não informado');
      Result := Json.ToString;
      Exit;
    end;

    try
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select status from tb_pedido where seqpedido = :seqpedido');
      Qry.ParamByName('seqpedido').Value := Params.ItemsString['seqpedido'].AsString;
      Qry.Active := True;
      if Qry.RecordCount = 0 then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Pedido não encontrado');
        Result := Json.ToString;
        Exit;
      end;

      Result := Json.ToString;
      Json.AddPair('retorno', 'OK');
      Json.AddPair('status', Qry.FieldByName('status').AsString);

    except on ex:exception do
    begin
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', ex.Message);
    end;
    end;

    Result := Json.ToString;

  finally
    Qry.DisposeOf;
    Json.DisposeOf;
  end;
end;

procedure TDM1.DWEventsEventsSolicitarAtendenteReplyEvent(var Params: TDWParams;
  var Result: string);
var
  Json : TJsonObject;
begin
  try
    Json := TJsonObject.Create;
    try
      if (Params.ItemsString['mesa'].AsString = '') then
      begin
        Json.AddPair('retorno', 'Erro');
        Json.AddPair('mensagem', 'Mesa não informada');
        Result := Json.ToString;
        Exit;
      end;

      Json.AddPair('retorno', 'OK');
      Json.AddPair('mensagem', 'Atendente solicitado');
      Result := Json.ToString;
    except
      Json.AddPair('retorno', 'Erro');
      Json.AddPair('mensagem', 'Erro ao solicitar o atendente');
      Result := Json.ToString;
    end;
  finally
    Json.DisposeOf;
  end;
end;

function TDM1.VerificarStatusPedido(SeqPedido: Integer;
  out Status: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select status from tb_pedido where seqpedido = :seqpedido ');
    Qry.ParamByName('seqpedido').Value := Seqpedido;
    Qry.Active := True;

    if not (Qry.RecordCount > 0) then
    begin
      Status := '';
      Exit;
    end;
    Status := Qry.FieldByName('status').AsString;
    Result := True;
  finally
    Qry.DisposeOf;
  end;
end;


function TDM1.CancelarPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido where seqpedido = :seqpedido ');
    Qry.ParamByName('seqpedido').Value := Seqpedido;
    Qry.Active := True;

    if not (Qry.RecordCount > 0) then
    begin
      Erro := 'Pedido não encontrado';
      Exit;
    end;

    if Qry.FieldByName('status').Value = 'C' then
    begin
      Erro := 'Pedido já cancelado';
      Exit;
    end;
    if Qry.FieldByName('status').Value = 'F' then
    begin
      Erro := 'Pedido já finalizado';
      Exit;
    end;
    if Qry.FieldByName('status').Value = 'A' then
    begin
      Erro := 'Pedido já está em produção';
      Exit;
    end;

    if AlterarStatusPedido('C', SeqPedido) then
      Result := True;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.FinalizarPedido(SeqPedido: Integer; out Erro: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido where seqpedido = :seqpedido ');
    Qry.ParamByName('seqpedido').Value := Seqpedido;
    Qry.Active := True;

    if not (Qry.RecordCount > 0) then
    begin
      Erro := 'Pedido não encontrado';
      Exit;
    end;

    if Qry.FieldByName('status').Value = 'C' then
    begin
      Erro := 'Pedido já cancelado';
      Exit;
    end;
    if Qry.FieldByName('status').Value = 'F' then
    begin
      Erro := 'Pedido já finalizado';
      Exit;
    end;

    if AlterarStatusPedido('F', SeqPedido) then
      Result := True;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.CarregarCategorias(var Qry: TFDQuery): Boolean;
begin
  try
    try
      Result := False;
      if Qry = nil then
        Qry := TFDQuery.Create(nil);
      Qry.Connection := DM1.conn;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select * from tb_categoria');
      Qry.Active := True;
    finally
      if Qry.RecordCount > 0 then
        Result := True;
    end;
  except
    Result := False;
  end;
end;

function TDM1.ChecarConfiguracoes: Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select 1 from tb_empresa');
    Qry.Active := True;
  finally
    if Qry.RecordCount > 0 then
      Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.ChecarInfoServidor: Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_empresa where not (portaservidor is null)');
    Qry.Active := True;
  finally
    if Qry.RecordCount > 0 then
      Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.ListarPedidos(var Qry: TFDQuery): Boolean;
begin
  try
    Result := False;
    if Qry = nil then
      Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido order by dtaultalteracao desc');

    Qry.Active := True;
    if Qry.RecordCount = 0 then
      Exit;
  finally
    Result := True;
  end;
end;

function TDM1.ListarPedidosRecebidos(var Qry: TFDQuery): Boolean;
begin
  try
    Result := False;
    if Qry = nil then
      Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido where status = ''P''');
    Qry.Active := True;
    if Qry.RecordCount = 0 then
      Exit;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_pedido order by seqpedido asc');
    Qry.Active := True;
  finally
    Result := True;
  end;
end;


function TDM1.ListarProdutos(var Qry: TFDQuery): Boolean;
begin
  try
    Result := False;
    if Qry = nil then
      Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;
    Qry.SQL.Add('select * from tb_produto order by seqproduto asc');
    Qry.Active := True;
  finally
    Result := True;
  end;
end;

function TDM1.ListarProdutosPedido(var Qry: TFDQuery;
  Seqpedido: String): Boolean;
begin
  try
    Result := False;
    if Qry = nil then
      Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;

    Qry.Active := False;
    Qry.SQL.Clear;

    Qry.SQL.Add('select a.*, b.nome from tb_pedidoitem a ');
    Qry.SQL.Add('left join tb_produto b ON a.seqproduto = b.seqproduto ');
    Qry.SQL.Add('where a.seqpedido = :seqpedido order by a.seqpedidoitem asc');

    Qry.ParamByName('seqpedido').Value := Seqpedido;
    Qry.Active := True;
    if Qry.RecordCount = 0 then
      Exit;
  finally
    Result := True;
  end;
end;

function TDM1.AdicionarConfiguracoes(NomeEmpresa, CNPJ, Endereco, Numero, CEP, Cidade,
  Estado: String): Boolean;
var
  Qry : TFDQuery;
begin
  Result := False;
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    Qry.SQL.Clear;
    Qry.SQL.Add('insert into tb_empresa(nomeempresa, cnpj, endereco, numero, cep, cidade, estado) ');
    Qry.SQL.Add('values(:nomeempresa, :cnpj, :endereco, :numero, :cep, :cidade, :estado)');
    Qry.ParamByName('nomeempresa').Value := NomeEmpresa;
    Qry.ParamByName('cnpj').Value := CNPJ;
    Qry.ParamByName('endereco').Value := Endereco;
    Qry.ParamByName('numero').Value := Numero.ToInteger;
    Qry.ParamByName('cep').Value := CEP.ToInteger;
    Qry.ParamByName('cidade').Value := Cidade;
    Qry.ParamByName('estado').Value := Estado;
    Qry.ExecSQL;
  finally
    Result := True;
    Qry.DisposeOf;
  end;
end;

function TDM1.AdicionarMesa: String;
var
  Qry : TFDQuery;
begin
  try
    Result := EmptyStr;
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    try
      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('insert into tb_mesa(status) values(''I'')');
      Qry.ExecSQL;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select substr(''000''|| max(seqmesa), -3) as seqmesa from tb_mesa');
      Qry.Active := True;

      if Qry.RecordCount = 0 then
      begin
        ShowMessage('Mesa não adicionada');
        Exit;
      end;

      Result := Qry.FieldByName('seqmesa').AsString;
    except on ex:exception do
    begin
      Result := EmptyStr;
      ShowMessage('Erro: ' + ex.Message);
    end;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.ObterMesas(var Mesas: TFDQuery): Boolean;
begin
  try
    Mesas.Connection := DM1.conn;

    Mesas.Active := False;
    Mesas.SQL.Clear;
    Mesas.SQL.Add('select * from tb_mesa');
    Mesas.Active := True;

    if Mesas.RecordCount = 0 then
    begin
      Result := False;
      Exit;
    end;

    Result := True;
  finally

  end;
end;

function TDM1.ObterStatusMesa(Mesa: String): String;
var
  Qry : TFDQuery;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    try
      if Mesa.Trim = '' then
      begin
        Result := EmptyStr;
        ShowMessage('Mesa não informada');
        Exit;
      end;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select status from tb_mesa where seqmesa = :seqmesa');
      Qry.ParamByName('seqmesa').Value := Mesa.ToInteger;
      Qry.Active := True;
      if Qry.RecordCount = 0 then
      begin
        Showmessage('Mesa não encontrada');
        Result := EmptyStr;
        Exit;
      end;

      Result := Qry.FieldByName('Status').AsString.Trim;
    except on ex:exception do
    begin
      Result := EmptyStr;
      ShowMessage('Erro: ' + ex.Message);
    end;
    end;
  finally
    Qry.DisposeOf;
  end;
end;

function TDM1.TrocarStatusMesa(Mesa: String): Boolean;
var
  StatusMesa : String;
  Qry : TFDQuery;
begin
  try
    Qry := TFDQuery.Create(nil);
    Qry.Connection := DM1.conn;
    try
      if Mesa.Trim = '' then
      begin
        Result := False;
        Exit;
      end;

      Qry.Active := False;
      Qry.SQL.Clear;
      Qry.SQL.Add('select status from tb_mesa where seqmesa = :seqmesa');
      Qry.ParamByName('seqmesa').Value := Mesa.ToInteger;
      Qry.Active := True;
      if Qry.RecordCount = 0 then
      begin
        Showmessage('Mesa não encontrada');
        Result := False;
        Exit;
      end;

      StatusMesa := Qry.FieldByName('Status').AsString;

      if StatusMesa = 'A' then
      begin
        Qry.Active := False;
        Qry.SQL.Clear;
        Qry.SQL.Add('update tb_mesa set status = ''I'' where seqmesa = :seqmesa');
        Qry.ParamByName('seqmesa').Value := Mesa.ToInteger;
        Qry.ExecSQL;
      end
      else
      begin
        Qry.Active := False;
        Qry.SQL.Clear;
        Qry.SQL.Add('update tb_mesa set status = ''A'' where seqmesa = :seqmesa');
        Qry.ParamByName('seqmesa').Value := Mesa.ToInteger;
        Qry.ExecSQL;
      end;

      Result := True;
    except on ex:exception do
      ShowMessage('Erro: ' + ex.Message);
    end;
  finally
    Qry.DisposeOf;
  end;
end;

end.
