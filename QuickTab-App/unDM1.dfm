object DM1: TDM1
  OldCreateOrder = False
  Height = 477
  Width = 590
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Delphi\TCC\QuickTab-App\db\banco.db'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = connBeforeConnect
    Left = 24
    Top = 16
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Left = 128
    Top = 80
  end
  object qry_config: TFDQuery
    Connection = conn
    Left = 127
    Top = 16
  end
  object RequestCriarPedido: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'teste'
      end>
    Resource = 'CriarPedido'
    SynchronizedEvents = False
    Left = 216
    Top = 184
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://192.168.15.2:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 32
    Top = 80
  end
  object FDQuery1: TFDQuery
    Connection = conn
    FetchOptions.AssignedValues = [evMode]
    SQL.Strings = (
      'select * from tb_usuario;')
    Left = 360
    Top = 24
  end
  object RequestListarProduto: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'ListarProduto'
    SynchronizedEvents = False
    Left = 69
    Top = 184
  end
  object RequestObterEmpresa: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'ObterEmpresa'
    SynchronizedEvents = False
    Left = 69
    Top = 256
  end
  object RequestSolicitarAtendente: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'mesa'
      end>
    Resource = 'SolicitarAtendente'
    SynchronizedEvents = False
    Left = 69
    Top = 328
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 448
    Top = 32
  end
  object RequestExcluirProdutoPedido: TRESTRequest
    Client = RESTClient
    Params = <>
    Resource = 'ExcluirProdutoPedido'
    SynchronizedEvents = False
    Left = 216
    Top = 256
  end
  object RequestAdicionarProdutoPedido: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'AdicionarProdutoPedido'
    SynchronizedEvents = False
    Left = 221
    Top = 328
  end
  object RequestCancelarPedido: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'CancelarPedido'
    SynchronizedEvents = False
    Left = 365
    Top = 256
  end
  object RequestObterStatusPedido: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'ObterStatusPedido'
    SynchronizedEvents = False
    Left = 493
    Top = 184
  end
  object RequestEncerrarPedido: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'EncerrarPedido'
    SynchronizedEvents = False
    Left = 365
    Top = 328
  end
  object RequestAtualizarPedido: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <
      item
        Name = 'teste'
      end>
    Resource = 'AtualizarPedido'
    SynchronizedEvents = False
    Left = 360
    Top = 184
  end
end
