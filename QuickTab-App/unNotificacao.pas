unit unNotificacao;

interface

uses System.SysUtils, System.UITypes, System.Notification, FMX.Types, FMX.Controls, FMX.StdCtrls,
     FMX.Objects, FMX.Effects, FMX.Layouts, FMX.Forms, FMX.Graphics, FMX.Ani,
     FMX.VirtualKeyboard, FMX.Platform;

type
  TNotificacao = class
  private
    class var Notificacao: TNotification;
    class var NotificationCenter: TNotificationCenter;
  public
    class procedure ExibirNotificacao(ANomeNotificacao: string = 'QuickTab'; ATextoNotificacao: string = '');
    class procedure RemoverNotficacao(ANomeNotificacao: string);
  end;
implementation

{ TNotificacao }


class procedure TNotificacao.ExibirNotificacao(ANomeNotificacao,
  ATextoNotificacao: string);
begin
  try
    NotificationCenter := TNotificationCenter.Create(nil);
    Notificacao := NotificationCenter.CreateNotification;
    Notificacao.Name := ANomeNotificacao;
    Notificacao.AlertBody := ATextoNotificacao;
    Notificacao.EnableSound := False;
    NotificationCenter.PresentNotification(Notificacao);
  finally
    Notificacao.DisposeOf;
    NotificationCenter.DisposeOf;
  end;
end;

class procedure TNotificacao.RemoverNotficacao(ANomeNotificacao: string);
begin
  if Assigned(NotificationCenter) then
    NotificationCenter.CancelNotification(ANomeNotificacao);
end;

end.
