unit unCamera;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Threading,
  FMX.Media, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,
  FMX.Platform, System.Permissions,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  {$ENDIF}
  ZXing.BarcodeFormat, ZXing.ReadResult, ZXing.ScanManager, FMX.DialogService,
  MobilePermissions.Model.Signature, MobilePermissions.Model.Dangerous,
  MobilePermissions.Model.Standard, MobilePermissions.Component, unVenda;

type
  TfrmCamera = class(TForm)
    recFundoCamera: TRectangle;
    lytCabecalhoCamera: TLayout;
    imgCameraVoltar: TImage;
    lblTituloCamera: TLabel;
    Camera: TCameraComponent;
    imgCamera: TImage;
    MobilePermissions1: TMobilePermissions;
    procedure CameraSampleBufferReady(Sender: TObject; const ATime: TMediaTime);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLanternaAcesa: Boolean;
    FPermissionCamera: String;
    FScanManager: TScanManager;
    FScanInProgress: Boolean;
    FFrameTake: Integer;
    procedure GetImage;
    function AppEvent(AAppEvent: TApplicationEvent; AContext: TObject): Boolean;
  public
    procedure FecharCamera;
    procedure AbrirCamera;
    procedure AtualizarCamera;
    procedure AtivarLanterna;
  end;

var
  frmCamera: TfrmCamera;

implementation

{$R *.fmx}

procedure TfrmCamera.AbrirCamera;
begin
  if not MobilePermissions1.Dangerous.Camera then
  begin
    MobilePermissions1.Dangerous.CAMERA := true;
    MobilePermissions1.Apply;
  end;

  if MobilePermissions1.Dangerous.Camera  then
  begin
  TTask.Run(
    procedure
    begin
      Camera.Active := False;
      Camera.Quality := FMX.Media.TVideoCaptureQuality.MediumQuality;
      Camera.Kind := FMX.Media.TCameraKind.BackCamera;
      Camera.FocusMode := FMX.Media.TFocusMode.ContinuousAutoFocus;
      Camera.Active := True;
    end);
  end
  else
    TDialogService.ShowMessage('Não foi possível escanear o QRCode, as permissões da câmera são nécessárias');
end;

function TfrmCamera.AppEvent(AAppEvent: TApplicationEvent;
  AContext: TObject): Boolean;
begin
  case AAppEvent of
    TApplicationEvent.WillBecomeInactive, TApplicationEvent.EnteredBackground,
      TApplicationEvent.WillTerminate:
    begin
      Camera.Active := False;
      Camera.Quality := FMX.Media.TVideoCaptureQuality.LowQuality;
      imgCamera.Bitmap.Clear(TAlphaColors.White);
    end;
  end;
end;

procedure TfrmCamera.AtivarLanterna;
begin
  if FLanternaAcesa then
  begin
    Camera.TorchMode := TTorchMode.ModeOff;
    FLanternaAcesa := False;
  end
  else
  begin
    Camera.TorchMode := TTorchMode.ModeOn;
    FLanternaAcesa := True;
  end;
end;

procedure TfrmCamera.AtualizarCamera;
begin
  if Camera.Active = False then
  begin
    imgCamera.Bitmap.Clear(TAlphaColors.White);
    Camera.Quality := FMX.Media.TVideoCaptureQuality.LowQuality;
    {$IFDEF ANDROID}
      AbrirCamera;
    {$ENDIF}
    imgCamera.Bitmap.Clear(TAlphaColors.White);
  end;
end;

procedure TfrmCamera.CameraSampleBufferReady(Sender: TObject;
  const ATime: TMediaTime);
begin
  TThread.Synchronize(TThread.CurrentThread, GetImage);
end;

procedure TfrmCamera.FecharCamera;
begin
  if not MobilePermissions1.Dangerous.Camera then
  begin
    MobilePermissions1.Dangerous.CAMERA := true;
    MobilePermissions1.Apply;
  end;

  Camera.Active := False;
  Camera.Quality := FMX.Media.TVideoCaptureQuality.LowQuality;
end;

procedure TfrmCamera.FormCreate(Sender: TObject);
var
  AppEventSvc: IFMXApplicationEventService;
begin
  if TPlatformServices.Current.SupportsPlatformService
    (IFMXApplicationEventService, IInterface(AppEventSvc)) then
  begin
    AppEventSvc.SetApplicationEventHandler(AppEvent);
  end;

  FFrameTake := 0;
  FScanManager := TScanManager.Create(TBarcodeFormat.QR_CODE, nil);

  {$IFDEF ANDROID}
  FPermissionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
  {$ENDIF}
end;

procedure TfrmCamera.FormDestroy(Sender: TObject);
begin
  FScanManager.DisposeOf;
end;

procedure TfrmCamera.GetImage;
var
  ScanBitmap: TBitmap;
  ReadResult: TReadResult;
  ASyncService : IFMXDialogServiceASync;
begin

  Camera.SampleBufferToBitmap(imgCamera.Bitmap, True);
  if (FScanInProgress) then
  begin
    Exit
  end;

  Inc(FFrameTake);
  if (FFrameTake mod 4 <> 0) then
  begin
    Exit;
  end;

  TTask.Run(
    procedure
    begin
      try
        ScanBitmap := TBitmap.Create();
        ScanBitmap.Assign(imgCamera.Bitmap);

        FScanInProgress := True;

        ScanBitmap.Assign(imgCamera.Bitmap);

        ReadResult := FScanManager.Scan(ScanBitmap);

        FScanInProgress := False;
      except
        on E: Exception do
        begin
          FScanInProgress := False;

          TThread.Synchronize(nil,
            procedure
            begin
              if TPlatformServices.Current.SupportsPlatformService(IFMXDialogServiceAsync, IInterface (ASyncService)) then
              begin
                ASyncService.ShowMessageAsync(E.Message);
              end;
            end);

          if (ScanBitmap <> nil) then
          begin
            FreeAndNil(ScanBitmap);
          end;

          Exit;
        end;

      end;
       TThread.Synchronize(nil,
        procedure
        begin
          if(ReadResult <> nil)  then
          begin
            Venda.BuscarCardapio(ReadResult.text);
          end;

          if (scanBitmap <> nil) then
          begin
            FreeAndNil(scanBitmap);
          end;

          FreeAndNil(ReadResult);
        end)

    end);
end;

end.
