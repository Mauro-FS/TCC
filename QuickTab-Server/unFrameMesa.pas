unit unFrameMesa;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Objects, unDM1, unUtils;

type
  TframeMesa = class(TFrame)
    crcMesa: TCircle;
    lblNmrMesa: TLabel;
    imgSelecionado: TImage;
    procedure crcMesaClick(Sender: TObject);
  private
    { Private declarations }
  public
    procedure TrocarStatusMesa(Mesa: String);
    procedure Selecionar;
    procedure AtivarMesa;
    procedure DesativarMesa;
  end;

implementation
uses
  unPrincipal;
{$R *.fmx}

procedure TframeMesa.AtivarMesa;
begin
  with DM1 do
    if not (ObterStatusMesa(Self.Tag.ToString) = 'A') then
      if TrocarStatusMesa(Self.Tag.ToString) then
        crcMesa.Fill.Color := $FFEB5757;
end;

procedure TframeMesa.crcMesaClick(Sender: TObject);
begin
  Selecionar;
end;

procedure TframeMesa.DesativarMesa;
begin
  with DM1 do
    if not (ObterStatusMesa(Self.Tag.ToString) = 'I') then
      if TrocarStatusMesa(Self.Tag.ToString) then
        crcMesa.Fill.Color := $FFA6A5A5;
end;

procedure TframeMesa.Selecionar;
begin
  with frmPrincipal do
    SelecionarMesa(Self.Tag);
end;

procedure TframeMesa.TrocarStatusMesa(Mesa: String);
begin
  with DM1 do
    TrocarStatusMesa(Mesa);
end;

end.
