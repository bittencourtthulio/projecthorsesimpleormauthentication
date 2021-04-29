unit ServerHorse.Model.Entity.USERS;

interface

uses
  SimpleAttributes;

type
  [Tabela('Users')]
  TUsers = class
  private
    FNAME: String;
    FEMAIL: String;
    FPASSWORD: String;
    FGUUID: String;
    procedure SetEMAIL(const Value: String);
    procedure SetGUUID(const Value: String);
    procedure SetNAME(const Value: String);
    procedure SetPASSWORD(const Value: String);

  public
    constructor Create;
    destructor Destroy; override;
    [Campo('GUUID'), Pk]
    property GUUID : String read FGUUID write SetGUUID;
    [Campo('NAME')]
    property NAME :String read FNAME write SetNAME;
    [Campo('PASSWORD')]
    property PASSWORD : String read FPASSWORD write SetPASSWORD;
    [Campo('EMAIL')]
    property EMAIL : String read FEMAIL write SetEMAIL;

end;

implementation

uses
  System.SysUtils;

{ TUsers }

constructor TUsers.Create;
begin

end;

destructor TUsers.Destroy;
begin

  inherited;
end;

procedure TUsers.SetEMAIL(const Value: String);
begin
  FEMAIL := Value;
end;

procedure TUsers.SetGUUID(const Value: String);
begin
  FGUUID := Value;
end;

procedure TUsers.SetNAME(const Value: String);
begin
  FNAME := Value;
end;

procedure TUsers.SetPASSWORD(const Value: String);
begin
  FPASSWORD := Value;
end;

end.
