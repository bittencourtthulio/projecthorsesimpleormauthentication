unit ServerHorse.Utils.JWT;

interface

uses
  BCrypt,
  JOSE.Core.JWT,
  JOSE.Core.Builder,
  JOSE.Types.JSON;

type
   iServerUtilsJWT = interface
    function Expiration( aValue : TDateTime ) : iServerUtilsJWT;
    function Hash( aValue : String ) : iServerUtilsJWT;
    function Issuer( aValue : String ): iServerUtilsJWT;
    function KeyJWT( aValue : String ) : iServerUtilsJWT;
    function Password( aValue : String ) : iServerUtilsJWT;
    function Subject( aValue : String ) : iServerUtilsJWT;
    function Token : TJsonObject;
  end;

  TServerUtilsJWT = class(TInterfacedObject, iServerUtilsJWT)
    private
      FExpiration : TDateTime;
      FHash : String;
      FIssuer : String;
      FKeyJWT : String;
      FPassword : String;
      FSubject : String;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iServerUtilsJWT;
      function Expiration( aValue : TDateTime ) : iServerUtilsJWT;
      function Hash( aValue : String ) : iServerUtilsJWT;
      function Issuer( aValue : String ): iServerUtilsJWT;
      function KeyJWT( aValue : String ) : iServerUtilsJWT;
      function Password( aValue : String ) : iServerUtilsJWT;
      function Subject( aValue : String ) : iServerUtilsJWT;
      function Token : TJsonObject;
  end;

implementation

uses
  System.SysUtils;

{ TServerUtilsJWT }

constructor TServerUtilsJWT.Create;
begin

end;

destructor TServerUtilsJWT.Destroy;
begin

  inherited;
end;

function TServerUtilsJWT.Expiration(aValue: TDateTime): iServerUtilsJWT;
begin
  Result := Self;
  FExpiration := aValue;
end;

function TServerUtilsJWT.Hash(aValue: String): iServerUtilsJWT;
begin
  Result := Self;
  FHash := aValue;
end;

function TServerUtilsJWT.Issuer(aValue: String): iServerUtilsJWT;
begin
  Result := Self;
  FIssuer := aValue;
end;

function TServerUtilsJWT.KeyJWT(aValue: String): iServerUtilsJWT;
begin
  Result := Self;
  FKeyJWT := aValue;
end;

class function TServerUtilsJWT.New: iServerUtilsJWT;
begin
  Result := Self.Create;
end;

function TServerUtilsJWT.Password(aValue: String): iServerUtilsJWT;
begin
  Result := Self;
  FPassword := aValue;
end;

function TServerUtilsJWT.Subject(aValue: String): iServerUtilsJWT;
begin
  Result := Self;
  FSubject := aValue;
end;

function TServerUtilsJWT.Token: TJsonObject;
var
  LToken : TJWT;
begin
  if TBCrypt
        .CompareHash(
          FPassword,
          FHash
        )
      then
      begin
        LToken := TJWT.Create;
        try
          LToken.Claims.Issuer := FIssuer;
          LToken.Claims.Subject := FSubject;
          LToken.Claims.Expiration := FExpiration;

          Result :=
            TJsonObject.Create
              .AddPair('token', TJOSE
                  .SHA256CompactToken(
                    '67E685B6-ECC4-4967-8B31-BACB23F56417',
                    LToken
                  ));
        finally
          LToken.Free;
        end
      end
      else
        raise Exception.Create('Hash Inválido');
end;

end.
