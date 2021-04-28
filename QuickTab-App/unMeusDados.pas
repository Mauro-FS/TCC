unit unMeusDados;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects;

type
  TfrmMeusDados = class(TForm)
    recFundoMeusDados: TRectangle;
    lytCabecalhoMeusDados: TLayout;
    imgMDVoltar: TImage;
    lblTituloMeusDados: TLabel;
    ScrollMeusDados: TVertScrollBox;
    lytMDFundo: TLayout;
    lblMDUsuario: TLabel;
    edtMDUsuario: TEdit;
    recMDSalvar: TRectangle;
    lblMDSalvar: TLabel;
    edtMDSenha: TEdit;
    lblMDSenha: TLabel;
    lblMDEmail: TLabel;
    lblMDCPF: TLabel;
    edtMDEmail: TEdit;
    edtMDCPF: TEdit;
    procedure imgMDVoltarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMeusDados: TfrmMeusDados;

implementation

{$R *.fmx}

procedure TfrmMeusDados.FormShow(Sender: TObject);
begin
  edtMDUsuario.Text := 'Usuario';
  edtMDCPF.Text := '123.456.789-09';
  edtMDEmail.Text := 'abcusuario@gmail.com';
  edtMDSenha.Text := 'aaaaa';
  edtMDSenha.Text := 'aaaaa';
end;

procedure TfrmMeusDados.imgMDVoltarClick(Sender: TObject);
begin
  Self.Close;
end;

end.
