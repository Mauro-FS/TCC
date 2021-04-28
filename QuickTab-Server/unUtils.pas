unit unUtils;

interface

uses
  System.SysUtils, System.Types,System.Classes, System.Variants,
  Math, FMX.DialogService, FMX.Edit, System.MaskUtils, System.IOUtils;

type
  TUtils = class
    class function RemoveZeroEsquerda(Value: String): String;
    class function AdicionarZeroEsquerda(Value: String): String;
  end;

implementation
{ TUtils }

class function TUtils.AdicionarZeroEsquerda(Value: String): String;
var
  I: Integer;
begin
  for I := 0 to Value.Length do
    if Value.Length < 3 then
      Value.Insert(0, '0');    
  Result := Value;
end;

class function TUtils.RemoveZeroEsquerda(Value: String): String;
var
  I: Integer;
begin
  for I := 1 to Value.Length do
    if Value[I] <> '0' then
    begin
      Result := Copy(Value, I, MaxInt);
      Exit;
    end;
  Result := '';
end;

end.
