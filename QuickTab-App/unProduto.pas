unit unProduto;

interface

uses
  System.SysUtils, System.Types, System.Generics.Collections, System.Classes, System.Variants,
  FMX.Graphics;

type
  TProduto = class
  private
    FIDProduto: Integer;
    FQuantidade: Integer;
    FImagem: TMemoryStream;
    FNomeProduto: String;
    FDescricao: String;
    FPreco: Double;
    FCategoria: String;
    FObservacao: String;
    function GetIdProduto: Integer;
    function GetQuantidade: Integer;
    function GetImagem: TMemoryStream;
    function GetNome: String;
    function GetDescricao: String;
    function GetPreco: Double;
    function GetCategoria: String;
    function GetObservacao: String;
    procedure SetIdProduto(AValue: Integer);
    procedure SetQuantidade(AValue: Integer);
    procedure SetImagem(AValue: TMemoryStream);
    procedure SetNome(AValue: String);
    procedure SetDescricao(AValue: String);
    procedure SetPreco(AValue: Double);
    procedure SetCategoria(AValue: String);
    procedure SetObservacao(AValue: String);
  published
    constructor Create;
    destructor Destroy; override;
    property IDProduto: Integer read GetIdProduto write SetIdProduto;
    property Quantidade: Integer read GetQuantidade write SetQuantidade;
    property Observacao: String read GetObservacao write SetObservacao;
    property Imagem: TMemoryStream read GetImagem write SetImagem;
    property Nome: String read GetNome write SetNome;
    property Descricao: String read GetDescricao write SetDescricao;
    property Preco: Double read GetPreco write SetPreco;
    property Categoria: String read GetCategoria write SetCategoria;
  public
    function VlrTotal: Double;
    function GetDescCategoria: String;
  end;

implementation

{ TProduto }

constructor TProduto.Create;
begin
  inherited Create;
  IDProduto := 0;
  Quantidade := 1;
  Nome := EmptyStr;
  Descricao := EmptyStr;
  Preco := 0;
  FIDProduto := IDProduto;
  Imagem := TMemoryStream.Create;
end;



function TProduto.GetImagem: TMemoryStream;
begin
  Result := FImagem;
end;

destructor TProduto.Destroy;
begin
  IDProduto := 0;
  Quantidade := 0;
  Imagem.Clear;
  Nome := EmptyStr;
  Descricao := EmptyStr;
  Preco := 0;
  FreeAndNil(FImagem);
  inherited;
end;

function TProduto.GetCategoria: String;
begin
  Result := FCategoria;
end;

function TProduto.GetDescCategoria: String;
var
  DescCategoria: String;
begin
  if FCategoria = 'catPrato' then
   DescCategoria := 'Pratos';
  if FCategoria = 'catBurguer' then
   DescCategoria := 'Lanches';
  if FCategoria = 'catPizza' then
   DescCategoria := 'Pizzas';
  if FCategoria = 'catFrutosDoMar' then
   DescCategoria := 'Frutos do Mar';
  if FCategoria = 'catEntrada' then
   DescCategoria := 'Entradas';
  if FCategoria = 'catBebida' then
   DescCategoria := 'Bebidas';
  if FCategoria = 'catDrink' then
   DescCategoria := 'Drinks';
  if FCategoria = 'catCafe' then
   DescCategoria := 'Cafés';
  if FCategoria = 'catChocolate' then
   DescCategoria := 'Chocolates';
  if FCategoria = 'catSopa' then
   DescCategoria := 'Sopas';
  if FCategoria = 'catTaco' then
   DescCategoria := 'Tacos';
  if FCategoria = 'catEspeto' then
   DescCategoria := 'Espetos';
  if FCategoria = 'catFrango' then
   DescCategoria := 'Frangos';
  if FCategoria = 'catMacarrao' then
   DescCategoria := 'Macarrão';
  if FCategoria = 'catPadaria' then
   DescCategoria := 'Lanches';
  if FCategoria = 'catPanqueca' then
   DescCategoria := 'Panquecas';
  Result := DescCategoria;
end;

function TProduto.GetDescricao: String;
begin
  Result := FDescricao;
end;

function TProduto.GetQuantidade: Integer;
begin
  Result := FQuantidade;
end;

function TProduto.GetIdProduto: Integer;
begin
  Result := FIDProduto;
end;

function TProduto.GetNome: String;
begin
  Result := FNomeProduto;
end;

function TProduto.GetObservacao: String;
begin
  Result := FObservacao;
end;

function TProduto.GetPreco: Double;
begin
  Result := FPreco;
end;

procedure TProduto.SetImagem(AValue: TMemoryStream);
begin
  FImagem := AValue;
end;

procedure TProduto.SetCategoria(AValue: String);
begin
  FCategoria := AValue;
end;

procedure TProduto.SetDescricao(AValue: String);
begin
  FDescricao := AValue;
end;

procedure TProduto.SetQuantidade(AValue: Integer);
begin
  FQuantidade := AValue;
end;

function TProduto.VlrTotal: Double;
begin
  Result := Preco * Quantidade;
end;

procedure TProduto.SetIdProduto(AValue: Integer);
begin
  FIDProduto := AValue;
end;

procedure TProduto.SetNome(AValue: String);
begin
  FNomeProduto := AValue;
end;

procedure TProduto.SetObservacao(AValue: String);
begin
  FObservacao := AValue;
end;

procedure TProduto.SetPreco(AValue: Double);
begin
  FPreco := AValue;
end;

end.

