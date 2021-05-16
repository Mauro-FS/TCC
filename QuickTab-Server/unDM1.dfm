object DM1: TDM1
  OldCreateOrder = False
  Encoding = esUtf8
  Height = 318
  Width = 318
  object conn: TFDConnection
    Params.Strings = (
      'Database=D:\Delphi\TCC\QuickTab-Server\db\banco.db'
      'DriverID=SQLite')
    LoginPrompt = False
    Left = 40
    Top = 24
  end
  object DWEvents: TDWServerEvents
    IgnoreInvalidParams = False
    Events = <
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'cpf'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'nome'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'email'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'mesa'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'pedido'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'CriarPedido'
        OnReplyEvent = DWEventsEventsCriarPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'ListarProduto'
        OnReplyEvent = DWEventsEventsListarProdutoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'seqproduto'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'quantidade'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'observacao'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'AdicionarProdutoPedido'
        OnReplyEvent = DWEventsEventsAdicionarProdutoPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'ListarProdutoPedido'
        OnReplyEvent = DWEventsEventsListarProdutoPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'ObterStatusPedido'
        OnReplyEvent = DWEventsEventsObterStatusPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'seqproduto'
            Encoded = False
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'quantidade'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'observacao'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'ExcluirProdutoPedido'
        OnReplyEvent = DWEventsEventsExcluirProdutoPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odIN
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = False
          end>
        JsonMode = jmPureJSON
        Name = 'EncerrarPedido'
        OnReplyEvent = DWEventsEventsEncerrarPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'mesa'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'SolicitarAtendente'
        OnReplyEvent = DWEventsEventsSolicitarAtendenteReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <>
        JsonMode = jmPureJSON
        Name = 'ObterEmpresa'
        OnReplyEvent = DWEventsEventsObterEmpresaReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'CancelarPedido'
        OnReplyEvent = DWEventsEventsCancelarPedidoReplyEvent
      end
      item
        Routes = [crAll]
        DWParams = <
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'seqpedido'
            Encoded = True
          end
          item
            TypeObject = toParam
            ObjectDirection = odINOUT
            ObjectValue = ovString
            ParamName = 'pedido'
            Encoded = True
          end>
        JsonMode = jmPureJSON
        Name = 'AtualizarPedido'
        OnReplyEvent = DWEventsEventsAtualizarPedidoReplyEvent
      end>
    Left = 56
    Top = 104
  end
  object QryLogin: TFDQuery
    Connection = conn
    Left = 88
    Top = 24
  end
end
