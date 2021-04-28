unit Utils;

interface

uses
  System.SysUtils, System.Types,System.Classes, System.Variants, System.RegularExpressions,
  Math, FMX.DialogService, FMX.Edit, System.MaskUtils, System.IOUtils,
  FMX.Graphics, System.NetEncoding;

const
  EMAIL_REGEX = '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]*[a-zA-Z0-9]+$';


type
  TFormato = (CPF, TelefoneFixo, Celular, Valor, Money);

  TUtils = class
    class procedure Formatar(AObj: TObject; Formato : TFormato; Extra : string = '');
    class function ValidarEmail(AEmail: String): Boolean;
    class function FormatarValor(AValor: String): String;
    class function SomenteNumeros(AString: String): String;
    class function InsereMascara(AMascara, AValor: String): String;
    class function CaminhoResources: String;
    class function CaminhoImagens: String;
    class function RemoverAcentos(AValue :string): String;
    class function Base64FromBitmap(Bitmap: TBitmap): string;
    class function BitmapFromBase64(const base64: String; out Imagem: TBitmap): Boolean;
  end;

  TMessage = class
    class procedure ExibirMensagem(AMensagem: String);
  end;


implementation

{ TUtils }

class function TUtils.Base64FromBitmap(Bitmap: TBitmap): string;
var
  Input: TBytesStream;
  Output: TStringStream;
  Encoding: TBase64Encoding;
begin
  Input := TBytesStream.Create;
  try
    Bitmap.SaveToStream(Input);
    Input.Position := 0;
    Output := TStringStream.Create('', TEncoding.ASCII);

    try
      Encoding := TBase64Encoding.Create(0);
      Encoding.Encode(Input, Output);
      Result := Output.DataString;
    finally
      Encoding.Free;
      Output.Free;
    end;

  finally
    Input.Free;
  end;
end;

class function TUtils.BitmapFromBase64(const base64: String;
  out Imagem: TBitmap): Boolean;
var
  Input: TStringStream;
  Output: TBytesStream;
  Encoding: TBase64Encoding;
begin
  Result := False;
  Input := TStringStream.Create(base64, TEncoding.ASCII);
  try
    Output := TBytesStream.Create;
    try
      Encoding := TBase64Encoding.Create(0);
      Encoding.Decode(Input, Output);
      try
        Imagem.LoadFromStream(Output);
      except
        raise;
      end;
    finally
      Output.Free;
    end;
  finally
    Input.Free;
    Encoding.Free;
  end;
end;

class function TUtils.CaminhoImagens: String;
begin
{$IFDEF ANDROID}
  Result := CaminhoResources + PathDelim;
{$ELSE}
  Result := CaminhoResources + 'imagens' + PathDelim;
{$ENDIF}
end;

class function TUtils.CaminhoResources: String;
var
  Caminho: String;
begin
{$IFDEF ANDROID}
  Caminho := System.IOUtils.TPath.GetDocumentsPath + PathDelim;
{$ELSE}
  Caminho := System.IOUtils.TPath.GetLibraryPath;
  Caminho := System.IOUtils.TDirectory.GetParent(Caminho);
  Caminho := System.IOUtils.TDirectory.GetParent(Caminho);
  Caminho := System.IOUtils.TDirectory.GetParent(Caminho);
  Caminho := Caminho + PathDelim + 'resources' + PathDelim;
{$ENDIF}
  Result := Caminho;
end;

class procedure TUtils.Formatar(AObj: TObject; Formato: TFormato; Extra: string);
var
  LTexto : string;
begin
  TThread.Queue(nil, procedure
  begin
    if AObj is TEdit then
      LTexto := TEdit(AObj).Text;

    if formato = CPF then
      LTexto := InsereMascara('###.###.###-##', SomenteNumeros(LTexto));

    if Formato = Valor then
      LTexto := FormatarValor(SomenteNumeros(lTexto));

    if Formato = Money then
    begin
      if Extra = '' then
        Extra := 'R$';

      LTexto := Extra + ' ' + FormatarValor(SomenteNumeros(LTexto));
    end;

    if AObj is TEdit then
    begin
      TEdit(AObj).Text := LTexto;
      TEdit(AObj).CaretPosition := TEdit(AObj).Text.Length;
    end;
  end);
end;

class function TUtils.FormatarValor(AValor: String): String;
begin
  if AValor = '' then
    AValor := '0';

  try
    Result := FormatFloat('#,##0.00', strtofloat(AValor) / 100);
  except
    Result := FormatFloat('#,##0.00', 0);
  end;
end;

class function TUtils.InsereMascara(AMascara, AValor: String): String;
var
  I, J : integer;
begin
  J := 0;
  Result := '';

  if AValor.IsEmpty then
    exit;

  for I := 0 to Length(AMascara) - 1 do
  begin
    if AMascara.Chars[I] = '#' then
    begin
      Result := Result + AValor.Chars[J];
      inc(J);
    end
    else
      Result := Result + AMascara.Chars[I];
      if J = Length(AValor) then
          Break;
  end;
end;

class function TUtils.RemoverAcentos(AValue :string): String;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸Ò˝¿¬ ‘€√’¡…Õ”⁄«‹—›';
  SemAcento = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  I: Cardinal;
begin;
  for I := 1 to Length(AValue) do
  try
    if (Pos(AValue[I], ComAcento) <> 0) then
      AValue[I] := SemAcento[ Pos(AValue[I], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro no processo.');
  end;

  Result := AValue;
end;

class function TUtils.SomenteNumeros(AString: String): String;
var
  I : integer;
begin
  Result := '';
  for I := 0 to Length(AString) - 1 do
    if (AString.Chars[I] In ['0'..'9']) then
      Result := Result + AString.Chars[I];
end;

class function TUtils.ValidarEmail(AEmail: String): Boolean;
begin
  Result := TRegEx.IsMatch(AEmail, EMAIL_REGEX);
end;

{ TMessage }

class procedure TMessage.ExibirMensagem(AMensagem: String);
begin
  TDialogService.ShowMessage(AMensagem);
end;

end.
