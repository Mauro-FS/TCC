object DM1: TDM1
  OldCreateOrder = False
  Height = 477
  Width = 504
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Delphi\TCC\QuickTab-App\db\banco.db'
      'OpenMode=ReadWrite'
      'LockingMode=Normal'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 24
    Top = 16
  end
  object HTTPBasicAuthenticator: THTTPBasicAuthenticator
    Left = 120
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
    Left = 72
    Top = 176
  end
  object RESTClient: TRESTClient
    Authenticator = HTTPBasicAuthenticator
    Accept = 'application/json, text/plain; q=0.9, text/html;q=0.8,'
    AcceptCharset = 'utf-8, *;q=0.8'
    BaseURL = 'http://localhost:8082'
    Params = <>
    RaiseExceptionOn500 = False
    Left = 24
    Top = 80
  end
  object FDQuery1: TFDQuery
    Connection = conn
    FetchOptions.AssignedValues = [evMode]
    SQL.Strings = (
      'select * from tb_usuario;')
    Left = 368
    Top = 64
  end
  object RequestListarProduto: TRESTRequest
    Client = RESTClient
    Method = rmPOST
    Params = <>
    Resource = 'ListarProduto'
    SynchronizedEvents = False
    Left = 197
    Top = 176
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
    Left = 432
    Top = 168
  end
end
