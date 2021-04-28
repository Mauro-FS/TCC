unit unFrameAdicional;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Objects, FMX.Controls.Presentation, FMX.Layouts;

type
  TframeAdicional = class(TFrame)
    lytFundoAdicional: TLayout;
    imgAddAdicional: TImage;
    lblNomeAdicional: TLabel;
    lblVlrAdicional: TLabel;
    imgVazioAdicional: TImage;
    procedure imgVazioAdicionalClick(Sender: TObject);
    procedure imgAddAdicionalClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

procedure TframeAdicional.imgAddAdicionalClick(Sender: TObject);
begin
  imgAddAdicional.Visible := False;
  imgVazioAdicional.Visible := True;
  lblVlrAdicional.TextSettings.FontColor := $FF404852;
end;

procedure TframeAdicional.imgVazioAdicionalClick(Sender: TObject);
begin
  imgVazioAdicional.Visible := False;
  imgAddAdicional.Visible := True;
  lblVlrAdicional.TextSettings.FontColor := $FF535BFE;
end;

end.
