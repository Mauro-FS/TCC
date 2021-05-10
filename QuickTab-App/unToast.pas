unit unToast;

interface

uses System.SysUtils, System.UITypes, FMX.Types, FMX.Controls, FMX.StdCtrls,
     FMX.Objects, FMX.Effects, FMX.Layouts, FMX.Forms, FMX.Graphics, FMX.Ani,
     FMX.VirtualKeyboard, FMX.Platform;

type
  TToast = class
  private
    class var LayoutToast: TLayout;
    class var FundoToast: TRectangle;
    class var AnimacaoToast: TFloatAnimation;
    class var MensagemToast: TLabel;
    class procedure DeleteToast(Sender: TObject);
  public
    class procedure ToastMessage(const AForm: Tform; const AMensagem: string;
     AAlinhamento: TAlignLayout = TAlignLayout.Top; ACorFundo: Cardinal = $FF00B28E;
     ACorFonte: Cardinal = $FFFFFFFF);
  end;

implementation

{ TToast }

class procedure TToast.DeleteToast(Sender: TObject);
begin
  if Assigned(FundoToast) then
  begin
    FundoToast.Visible := false;
  end;
end;

class procedure TToast.ToastMessage(const AForm: Tform; const AMensagem: string;
 AAlinhamento: TAlignLayout = TAlignLayout.Top; ACorFundo: Cardinal = $FF00B28E;
 ACorFonte: Cardinal = $FFFFFFFF);
var
  FService: IFMXVirtualKeyboardService;
begin

  LayoutToast := TLayout.Create(AForm);
  LayoutToast.Opacity := 1;
  LayoutToast.Parent := AForm;
  LayoutToast.Visible := True;
  LayoutToast.Align := TAlignLayout.Contents;
  LayoutToast.Visible := True;
  LayoutToast.HitTest := False;
  LayoutToast.BringToFront;

  FundoToast := TRectangle.Create(AForm);
  FundoToast.Opacity := 0;
  FundoToast.Parent := LayoutToast;
  FundoToast.Height := 40;
  FundoToast.Align := AAlinhamento;
  FundoToast.Margins.Left := 20;
  FundoToast.Margins.Right := 20;
  FundoToast.Margins.Bottom := 20;
  FundoToast.Margins.Top := 20;
  FundoToast.Fill.Color := ACorFundo;
  FundoToast.Fill.Kind := TBrushKind.Solid;
  FundoToast.Stroke.Kind := TBrushKind.None;
  FundoToast.XRadius := 12;
  FundoToast.YRadius := 12;
  FundoToast.Visible := True;

  AnimacaoToast := TFloatAnimation.Create(AForm);
  AnimacaoToast.Parent := FundoToast;
  AnimacaoToast.StartValue := 0;
  AnimacaoToast.StopValue := 2;
  AnimacaoToast.Duration := 0.8;
  AnimacaoToast.Delay := 0;
  AnimacaoToast.AutoReverse := True;
  AnimacaoToast.PropertyName := 'Opacity';
  AnimacaoToast.AnimationType := TAnimationType.&In;
  AnimacaoToast.Interpolation := TInterpolationType.Linear;
  AnimacaoToast.OnFinish := TToast.DeleteToast;

  MensagemToast := TLabel.Create(AForm);
  MensagemToast.Parent := FundoToast;
  MensagemToast.Align := TAlignLayout.Client;
  MensagemToast.Font.Size := 18;
  MensagemToast.FontColor := ACorFonte;
  MensagemToast.Font.Family := 'Nunito Sans';
  MensagemToast.Font.Style := [TFontStyle.fsBold];
  MensagemToast.TextSettings.HorzAlign := TTextAlign.Center;
  MensagemToast.TextSettings.VertAlign := TTextAlign.Center;
  MensagemToast.StyledSettings := [];
  MensagemToast.Text := AMensagem;
  MensagemToast.VertTextAlign := TTextAlign.Center;
  MensagemToast.Trimming := TTextTrimming.None;
  MensagemToast.TabStop := False;

  // Esconde o teclado virtual...
  TPlatformServices.Current.SupportsPlatformService(IFMXVirtualKeyboardService,
                                                    IInterface(FService));
  if (FService <> nil) then
  begin
      FService.HideVirtualKeyboard;
  end;
  FService := nil;

  AnimacaoToast.Enabled := True;
end;

end.
