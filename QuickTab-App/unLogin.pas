unit unLogin;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.TabControl, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Objects, System.Threading,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  FMX.Platform.Android,
  Androidapi.JNI.GraphicsContentViewText,
  {$ENDIF}
  Utils, unPrincipal, unDM1, unOnboarding, unMensagem, unFrameFundo, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, unAlterarSenha,
  unVenda;

type
  TfrmLogin = class(TForm)
    Rectangle1: TRectangle;
    TabControl: TTabControl;
    TabLogin: TTabItem;
    Layout1: TLayout;
    lblEmailUsuario: TLabel;
    edtEmailUsuario: TEdit;
    recLogin: TRectangle;
    Label3: TLabel;
    lblNConta: TLabel;
    TabConfig: TTabItem;
    edtSenha: TEdit;
    lblSenha: TLabel;
    Label1: TLabel;
    Label8: TLabel;
    lytCadastreSe: TLayout;
    lblCadastrese: TLabel;
    Layout2: TLayout;
    lblCadUsuario: TLabel;
    edtCadUsuario: TEdit;
    recCadastrar: TRectangle;
    Label5: TLabel;
    edtCadSenha: TEdit;
    lblCadSenha: TLabel;
    Layout3: TLayout;
    Label11: TLabel;
    lblCadAcesse: TLabel;
    lblEmail: TLabel;
    lblCPF: TLabel;
    edtCadEmail: TEdit;
    edtCadCPF: TEdit;
    TabInicio: TTabItem;
    Image1: TImage;
    Switch1: TSwitch;
    Label4: TLabel;
    Image2: TImage;
    Label10: TLabel;
    Label13: TLabel;
    recAcessar: TRectangle;
    Label14: TLabel;
    Layout4: TLayout;
    Layout5: TLayout;
    Label15: TLabel;
    lblCadastre: TLabel;
    Layout6: TLayout;
    lblEsqueceSenha: TLabel;
    lblAlterarSenha: TLabel;
    procedure edtCadCPFTyping(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLoading: TframeFundo;
    Dlg: TfrmMensagem;
    procedure BarColor(TransparentBar : boolean; BarColor : Cardinal = $FF004F9E);
    procedure TextColor(TextDark : boolean);
    function VerificaCamposCadastro: Boolean;
    function VerificaCamposLogin: Boolean;
    function LimparCamposCadastro: Boolean;
    {$IFDEF ANDROID}
    procedure lblCadastreseClick(Sender: TObject; const Point: TPointF);
    procedure recAcessarClick(Sender: TObject; const Point: TPointF);
    procedure lblCadastreClick(Sender: TObject; const Point: TPointF);
    procedure recLoginClick(Sender: TObject; const Point: TPointF);
    procedure recCadastrarClick(Sender: TObject; const Point: TPointF);
    procedure lblCadAcesseClick(Sender: TObject; const Point: TPointF);
    procedure lblAlterarSenhaClick(Sender: TObject; const Point: TPointF);
    {$ELSE}
    procedure lblCadastreseClick(Sender: TObject);
    procedure recAcessarClick(Sender: TObject);
    procedure lblCadastreClick(Sender: TObject);
    procedure recLoginClick(Sender: TObject);
    procedure recCadastrarClick(Sender: TObject);
    procedure lblCadAcesseClick(Sender: TObject);
    procedure lblAlterarSenhaClick(Sender: TObject);
    {$ENDIF}
  public
    ModoDark : Boolean;
    StatusBarColor : Cardinal;
    StatusBarTransparent : Boolean;
    procedure TapOuClick;
  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.fmx}

procedure TfrmLogin.BarColor(TransparentBar: boolean; BarColor: Cardinal);
begin
  if TransparentBar then
  begin
    frmLogin.StatusBarColor := $00FFFFFF;
    frmLogin.StatusBarTransparent := true;
   {$IFDEF ANDROID}
    TAndroidHelper.Activity.getWindow.addFlags(
     TJWindowManager_LayoutParams.JavaClass.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS);
    TAndroidHelper.Activity.getWindow.setFlags(
     TJWindowManager_LayoutParams.JavaClass.FLAG_TRANSLUCENT_STATUS,
     TJWindowManager_LayoutParams.JavaClass.FLAG_TRANSLUCENT_STATUS);
    TAndroidHelper.Activity.getWindow.setFlags(
     TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS,
     TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS);
   {$ENDIF}
  end else
  begin
    frmLogin.StatusBarColor := BarColor;
    frmLogin.StatusBarTransparent := false;
   {$IFDEF ANDROID}
    TAndroidHelper.Activity.getWindow.clearFlags(
     TJWindowManager_LayoutParams.JavaClass.FLAG_TRANSLUCENT_STATUS);
    TAndroidHelper.Activity.getWindow.clearFlags(
     TJWindowManager_LayoutParams.JavaClass.FLAG_LAYOUT_NO_LIMITS);
    TAndroidHelper.Activity.getWindow.setStatusBarColor(BarColor);
   {$ENDIF}
  end;
end;

procedure TfrmLogin.edtCadCPFTyping(Sender: TObject);
begin
  TUtils.Formatar(Sender, TFormato.CPF);
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  FLoading := TframeFundo.Create(Self);
  Dlg := TfrmMensagem.Create(frmLogin);
  FLoading.Parent := Self;
end;

procedure TfrmLogin.FormDestroy(Sender: TObject);
begin
  FLoading.DisposeOf;
  Dlg.DisposeOf;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  LTask: ITask;
  Qry: TFDQuery;
begin
  TapOuClick;
  Qry := TFDQuery.Create(nil);
  FLoading.Fechar;
  LTask := TTask.Create(procedure
  begin
    BarColor(False, $FFFFFFFF);
    TextColor(False);
  end);
  LTask.Start;

  if DM1.PrimeiroAcesso then
  begin
    frmOnboarding.Show;
    frmOnboarding.FormStyle := TFormStyle.StayOnTop;
  end;

  if DM1.ObterInfoUsuario(Qry) then
  begin
    if Qry.FieldByName('lembrar').AsString = 'S' then
    begin
      edtEmailUsuario.Text := Qry.FieldByName('email').AsString;
      edtSenha.Text := Qry.FieldByName('senha').AsString;
      Switch1.IsChecked := True;
    end;
  end;

  Qry.DisposeOf;
end;
{$IFDEF ANDROID}

procedure TfrmLogin.lblAlterarSenhaClick(Sender: TObject; const Point: TPointF);
begin
  frmAlterarSenha.Show;
end;

procedure TfrmLogin.lblCadAcesseClick(Sender: TObject; const Point: TPointF);
begin
  LimparCamposCadastro;
  TabControl.ActiveTab := TabLogin;
end;

procedure TfrmLogin.lblCadastreClick(Sender: TObject; const Point: TPointF);
begin
  TabControl.ActiveTab := TabConfig;
end;

procedure TfrmLogin.lblCadastreseClick(Sender: TObject; const Point: TPointF);
begin
  TabControl.ActiveTab := TabConfig;
end;

procedure TfrmLogin.recAcessarClick(Sender: TObject; const Point: TPointF);
begin
  TabControl.ActiveTab := TabLogin;
end;

procedure TfrmLogin.recCadastrarClick(Sender: TObject; const Point: TPointF);
var
  Erro: String;
begin
  if not VerificaCamposCadastro then
    Exit;

  FLoading.Exibir;
  if not Venda.Cadastrar(Erro, edtCadUsuario.Text.Trim, edtCadSenha.Text.Trim,
   edtCadEmail.Text.Trim, edtCadCPF.Text.Trim) then
  begin
    Dlg.Mensagem(Erro);
  end
  else
    Dlg.Mensagem('Cadastro efetuado!');
  Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        TabControl.ActiveTab := TabLogin;
        LimparCamposCadastro;
    end);
end;

procedure TfrmLogin.recLoginClick(Sender: TObject; const Point: TPointF);
var
  Erro: String;
begin
  if not VerificaCamposLogin then
    Exit;
  if not Venda.Acessar(Erro, edtEmailUsuario.Text.Trim, edtSenha.Text.Trim, Switch1.IsChecked) then
  begin
    FLoading.Exibir;
    Dlg.Mensagem(Erro);
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        Exit;
    end);
  end
  else
    frmPrincipal.Show;
end;

{$ELSE}
procedure TfrmLogin.lblCadAcesseClick(Sender: TObject);
begin
  LimparCamposCadastro;
  TabControl.ActiveTab := TabLogin;
end;

procedure TfrmLogin.lblCadastreClick(Sender: TObject);
begin
  TabControl.ActiveTab := TabConfig;
end;

procedure TfrmLogin.lblAlterarSenhaClick(Sender: TObject);
begin
  frmAlterarSenha.Show;
end;

procedure TfrmLogin.lblCadastreseClick(Sender: TObject);
begin
  TabControl.ActiveTab := TabConfig;
end;

procedure TfrmLogin.recCadastrarClick(Sender: TObject);
var
  Erro: String;
begin
  if not VerificaCamposCadastro then
    Exit;

  FLoading.Exibir;
  if not Venda.Cadastrar(Erro, edtCadUsuario.Text.Trim, edtCadSenha.Text.Trim,
   edtCadEmail.Text.Trim, edtCadCPF.Text.Trim) then
  begin
    Dlg.Mensagem(Erro);
  end
  else
    Dlg.Mensagem('Cadastro efetuado!');
  Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        TabControl.ActiveTab := TabLogin;
        LimparCamposCadastro;
    end);
end;

procedure TfrmLogin.recAcessarClick(Sender: TObject);
begin
  TabControl.ActiveTab := TabLogin;
end;

procedure TfrmLogin.recLoginClick(Sender: TObject);
var
  Erro: String;
begin
  if not VerificaCamposLogin then
    Exit;
  if not Venda.Acessar(Erro, edtEmailUsuario.Text.Trim, edtSenha.Text.Trim, Switch1.IsChecked) then
  begin
    FLoading.Exibir;
    Dlg.Mensagem(Erro);
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        Exit;
    end);
  end
  else
    frmPrincipal.Show;
end;
{$ENDIF}

function TfrmLogin.LimparCamposCadastro: Boolean;
begin
  edtCadUsuario.Text := EmptyStr;
  edtCadCPF.Text := EmptyStr;
  edtCadSenha.Text := EmptyStr;
  edtCadEmail.Text := EmptyStr;
end;

procedure TfrmLogin.TapOuClick;
begin
  {$IFDEF ANDROID}
  recAcessar.OnTap := recAcessarClick;
  recLogin.OnTap := recLoginClick;
  recCadastrar.OnTap := recCadastrarClick;
  lblCadastrese.OnTap := lblCadastreseClick;
  lblCadastre.OnTap  := lblCadastreseClick;
  lblAlterarSenha.OnTap  := lblAlterarSenhaClick;
  lblCadAcesse.OnTap := lblCadAcesseClick;
  {$ELSE}
  recAcessar.OnClick := recAcessarClick;
  recLogin.OnClick := recLoginClick;
  recCadastrar.OnClick := recCadastrarClick;
  lblCadastrese.OnClick := lblCadastreseClick;
  lblCadastre.OnClick  := lblCadastreseClick;
  lblAlterarSenha.OnClick  := lblAlterarSenhaClick;
  lblCadAcesse.OnClick := lblCadAcesseClick;
  {$ENDIF}
end;

procedure TfrmLogin.TextColor(TextDark: boolean);
begin
  frmLogin.ModoDark := TextDark;
 {$IFDEF ANDROID}
  if TextDark then
    TAndroidHelper.Activity.getWindow.getDecorView.setSystemUiVisibility(
     TJView.JavaClass.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
  else
    TAndroidHelper.Activity.getWindow.getDecorView.setSystemUiVisibility(
     TJView.JavaClass.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR xor
     TJView.JavaClass.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR);
  BarColor(frmLogin.StatusBarTransparent, frmLogin.StatusBarColor);
 {$ENDIF}
end;

function TfrmLogin.VerificaCamposCadastro: Boolean;
begin
  Result := False;
  if( (edtCadUsuario.Text.Trim = EmptyStr) or (edtCadEmail.Text.Trim = EmptyStr) or
   (edtCadCPF.Text.Trim = EmptyStr) or (edtCadSenha.Text.Trim = EmptyStr)) then
  begin
    FLoading.Exibir;
    Dlg.Mensagem('Preencha todas as informações!');
    Dlg.ShowModal(
    procedure(ModalResult: TModalResult)
    begin
      if Dlg.ModalResult = mrOk then
        FLoading.Fechar;
        Exit;
    end);
  end;
  Result := True;
end;

function TfrmLogin.VerificaCamposLogin: Boolean;
begin
  Result := False;
  if ((edtEmailUsuario.Text.Trim = EmptyStr) or (edtSenha.Text.Trim = EmptyStr)) then
  begin
    FLoading.Exibir;
    Dlg.Mensagem('Preencha todas as informações!');
    Dlg.ShowModal(
      procedure(ModalResult: TModalResult)
      begin
        if Dlg.ModalResult = mrOk then
          FLoading.Fechar;
      end);
  end
  else
    Result := True;
end;

end.
