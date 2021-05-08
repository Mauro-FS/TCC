unit unFrameFundo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Ani, FMX.Controls.Presentation, FMX.Layouts;

type
  TframeFundo = class(TFrame)
    recFundo: TRectangle;
    recMensagem: TRectangle;
    lytAnimacao: TLayout;
    lytMensagem: TLayout;
    lblMensagem: TLabel;
    Arc1: TArc;
    FloatAnimar: TFloatAnimation;
  private
    { Private declarations }
  public
    function Animar: Boolean;
    function Exibir(Mensagem: String = ''): Boolean;
    function AtualizarMensagem(Mensagem: String): Boolean;
    function Fechar: Boolean;
  end;

implementation

{$R *.fmx}

{ TFrame1 }

function TframeFundo.Animar: Boolean;
begin
  FloatAnimar.Enabled := (not FloatAnimar.Enabled);
end;

function TframeFundo.AtualizarMensagem(Mensagem: String): Boolean;
begin
  lblMensagem.Text := Mensagem;
  Result := True;
end;

function TframeFundo.Exibir(Mensagem: String): Boolean;
begin
  if Mensagem.Trim = EmptyStr then
  begin
    FloatAnimar.Enabled := False;
    recMensagem.Visible := False;
  end
  else
  begin
    lblMensagem.Text := Mensagem;
    recMensagem.Visible := True;
    FloatAnimar.Enabled := True;
    FloatAnimar.Start;
  end;
  Self.Visible := True;
  BringToFront;
end;

function TframeFundo.Fechar: Boolean;
begin
  Visible := False;
  FloatAnimar.Stop;
  lblMensagem.Text := EmptyStr;
  FloatAnimar.Enabled := False;
  recMensagem.Visible := False;
end;

end.
