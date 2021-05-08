unit unPedido;

interface

uses
  System.SysUtils, System.Types, System.Generics.Collections, System.Classes, System.Variants,
   FMX.Graphics, FMX.DialogService, unProduto, Utils;

type
  TPedido = class
  private
    FIDPedido: Integer;
    FIDEmpresa: Integer;
    FIDUsuario: Integer;
    FUsuarioCPF: String;
    FMesa: Integer;
    FEmailUsuario: String;
    FNomeUsuario: String;
    FData: TDateTime;
    FStatus: String;
    FVlrTotal: Double;
    FListaProdutos: TObjectList<TProduto>;
    function GetIdPedido: Integer;
    function GetIdEmpresa: Integer;
    function GetIdUsuario: Integer;
    function GetUsuarioCPF: String;
    function GetMesa: Integer;
    function GetData: TDateTime;
    function GetStatus: String;
    function GetVlrTotal: Double;
    function GetEmailUsuario: String;
    function GetNomeUsuario: String;
    function GetListaProdutos: TObjectList<TProduto>;
    procedure SetIdPedido(AValue: Integer);
    procedure SetIdEmpresa(AValue: Integer);
    procedure SetIdUsuario(AValue: Integer);
    procedure SetUsuarioCPF(AValue: String);
    procedure SetMesa(AValue: Integer);
    procedure SetData(AValue: TDateTime);
    procedure SetStatus(AValue: String);
    procedure SetVlrTotal(AValue: Double);
    procedure SetEmailUsuario(Avalue: String);
    procedure SetNomeUsuario(Avalue: String);
    procedure SetListaProdutos(Avalue: TObjectList<TProduto>);
  public
    constructor Create;
    destructor Destroy; override;
    property IDPedido: Integer read GetIDPedido write SetIDPedido;
    property IDEmpresa: Integer read GetIDEmpresa write SetIDEmpresa;
    property IDUsuario: Integer read GetIdUsuario write SetIdUsuario;
    property EmailUsuario: String read GetEmailUsuario write SetEmailUsuario;
    property NomeUsuario: String read GetNomeUsuario write SetNomeUsuario;
    property UsuarioCPF: String read GetUsuarioCPF write SetUsuarioCPF;
    property Mesa: Integer read GetMesa write SetMesa;
    property Data: TDateTime read GetData write SetData;
    property Status: String read GetStatus write SetStatus;
    property VlrTotal: Double read GetVlrTotal write SetVlrTotal;
    property ListaProdutos: TObjectList<TProduto> read GetListaProdutos write SetListaProdutos;
    function RemoverQtdProduto(IDProduto: Integer): Boolean;
    function AdicionarQtdProduto(IDProduto: Integer): Boolean;
    function AdicionarProduto(IDProduto: Integer; Quantidade: Integer = 1): Boolean;
    function DeletarProduto(IDProduto: Integer): Boolean;
    function GetTotalPedido: Double;
  end;

implementation

uses
  unVenda;

{ TPedido }

function TPedido.AdicionarProduto(IDProduto: Integer; Quantidade: Integer = 1): Boolean;
var
  Produto: TProduto;
begin
  try
    Produto := TProduto.Create;
    Produto.Nome := Venda.ProdutosCardapio.Items[Idproduto].Nome;
    Produto.IDProduto := Venda.ProdutosCardapio.Items[Idproduto].IDProduto;
    Produto.Quantidade := Quantidade;
    Produto.Descricao := Venda.ProdutosCardapio.Items[Idproduto].Descricao;
    Produto.Preco := Venda.ProdutosCardapio.Items[Idproduto].Preco;
    Produto.Categoria := Venda.ProdutosCardapio.Items[Idproduto].Categoria;
    Produto.Imagem.LoadFromStream(Venda.ProdutosCardapio.Items[Idproduto].Imagem);
    Produto.Quantidade := Quantidade;
    if Assigned(ListaProdutos) then
      ListaProdutos.Add(Produto);
    Result := True;
  except
    Result := False;
  end;
end;

function TPedido.AdicionarQtdProduto(IDProduto: Integer): Boolean;
begin
 Result := False;
  try
    ListaProdutos.Items[IDProduto].Quantidade := ListaProdutos.Items[IDProduto].Quantidade + 1;
  finally
    Result := True;
  end;
end;

constructor TPedido.Create;
begin
  IDPedido := 0;
  IDEmpresa := 0;
  IDUsuario := 0;
  Data := Now;
  Status := EmptyStr;
  NomeUsuario := EmptyStr;
  VlrTotal := 0;
  FListaProdutos := TObjectList<TProduto>.Create(True);
  FListaProdutos.Clear;

  FIDPedido := IDPedido;
end;

function TPedido.DeletarProduto(IDProduto: Integer): Boolean;
var
  A: Integer;
begin
  try
    Result := False;
//    ListaProdutos.Items[IDProduto].DisposeOf;
    ListaProdutos.Remove(ListaProdutos.Items[IDProduto]);
    Result := True;
  except
    Result := False;
  end;
end;

destructor TPedido.Destroy;
begin
  IDPedido := 0;
  IDEmpresa := 0;
  IDUsuario := 0;
  Data := Now;
  Status := EmptyStr;
  NomeUsuario := EmptyStr;
  VlrTotal := 0;
  FreeAndNil(FListaProdutos);
end;

function TPedido.GetData: TDateTime;
begin
  Result := FData;
end;

function TPedido.GetEmailUsuario: String;
begin
  Result := FEmailUsuario;
end;

function TPedido.GetIdEmpresa: Integer;
begin
  Result := FIDEmpresa;
end;

function TPedido.GetIdPedido: Integer;
begin
  Result := FIDPedido;
end;

function TPedido.GetIdUsuario: Integer;
begin
  if FIDUsuario = 0 then
  begin
    if not EmailUsuario.Trim.IsEmpty then
    begin
      //conectar no banco e buscar a partir do email

    end;
  end;
  Result := FIDUsuario;
end;

function TPedido.GetListaProdutos: TObjectList<TProduto>;
begin
  Result := FListaProdutos;
end;

function TPedido.GetMesa: Integer;
begin
  Result := FMesa;
end;

function TPedido.GetNomeUsuario: String;
begin
  Result := FNomeUsuario;
end;

function TPedido.GetStatus: String;
begin
  Result := FStatus;
end;

function TPedido.GetTotalPedido: Double;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to ListaProdutos.Count - 1 do
  begin
    Result := Result + (ListaProdutos.Items[I].Quantidade * ListaProdutos.Items[I].VlrTotal);
  end;
end;

function TPedido.GetUsuarioCPF: String;
begin
  Result := FUsuarioCPF;
end;

function TPedido.GetVlrTotal: Double;
begin
  Result := FVlrTotal;
end;

function TPedido.RemoverQtdProduto(IDProduto: Integer): Boolean;
begin
  Result := False;
  try
    ListaProdutos.Items[IDProduto].Quantidade := ListaProdutos.Items[IDProduto].Quantidade - 1;
  finally
    Result := True;
  end;
end;

procedure TPedido.SetData(AValue: TDateTime);
begin
  FData := AValue;
end;

procedure TPedido.SetEmailUsuario(Avalue: String);
begin
  FEmailUsuario := Avalue;
end;

procedure TPedido.SetIdEmpresa(AValue: Integer);
begin
  FIDEmpresa := AValue;
end;

procedure TPedido.SetIdPedido(AValue: Integer);
begin
  FIDPedido := AValue;
end;

procedure TPedido.SetIdUsuario(AValue: Integer);
begin
  FIDUsuario := AValue;
end;

procedure TPedido.SetListaProdutos(Avalue: TObjectList<TProduto>);
begin
  FListaProdutos := Avalue;
end;

procedure TPedido.SetMesa(AValue: Integer);
begin
  FMesa := AValue;
end;

procedure TPedido.SetNomeUsuario(Avalue: String);
begin
  FNomeUsuario := Avalue;
end;

procedure TPedido.SetStatus(AValue: String);
begin
  FStatus := AValue;
end;

procedure TPedido.SetUsuarioCPF(AValue: String);
begin
  FUsuarioCPF := AValue;
end;

procedure TPedido.SetVlrTotal(AValue: Double);
begin
  FVlrTotal := AValue;
end;

end.
