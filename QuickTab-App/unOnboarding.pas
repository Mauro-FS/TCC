unit unOnboarding;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects,
  FMX.TabControl, FMX.Gestures, System.Actions, FMX.ActnList;

type
  TfrmOnboarding = class(TForm)
    recFundoOnboarding: TRectangle;
    TabControlOnboarding: TTabControl;
    tabOB1: TTabItem;
    tabOB2: TTabItem;
    tabOB3: TTabItem;
    tabOB4: TTabItem;
    imgOB1: TImage;
    lytOB1: TLayout;
    lblOB1: TLabel;
    lytOB2: TLayout;
    lblOB2: TLabel;
    imgOB2: TImage;
    imgOB3: TImage;
    lytOB3: TLayout;
    lblOB3: TLabel;
    imgOB4: TImage;
    lytOB4: TLayout;
    lblOB4: TLabel;
    tabOB0: TTabItem;
    imgOB0: TImage;
    lytOB0: TLayout;
    lblOB0: TLabel;
    tabOB5: TTabItem;
    imgOB5: TImage;
    lytOB5: TLayout;
    lblOB5: TLabel;
    lytBtnOB5: TLayout;
    recBtnOB5: TRectangle;
    lblBtnOB5: TLabel;
    ActionList1: TActionList;
    NextTabAction1: TNextTabAction;
    PreviousTabAction1: TPreviousTabAction;
    GestureManager1: TGestureManager;
    procedure recBtnOB5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure TabControlOnboardingGesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOnboarding: TfrmOnboarding;

implementation

{$R *.fmx}

procedure TfrmOnboarding.FormShow(Sender: TObject);
begin
  TabControlOnboarding.ActiveTab := tabOB0;
end;

procedure TfrmOnboarding.recBtnOB5Click(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmOnboarding.TabControlOnboardingGesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
begin
  if EventInfo.GestureID = sgiLeft then
    NextTabAction1.Execute
  else if EventInfo.GestureID = sgiRight  then
    PreviousTabAction1.Execute;
end;

end.
