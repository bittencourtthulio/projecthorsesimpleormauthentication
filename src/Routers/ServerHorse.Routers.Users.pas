unit ServerHorse.Routers.Users;

interface

uses
  System.JSON,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  ServerHorse.Controller;

procedure Registry;

implementation

uses
  System.Classes,
  ServerHorse.Controller.Interfaces,
  ServerHorse.Model.Entity.USERS,
  System.SysUtils,
  ServerHorse.Utils,
  System.DateUtils,
  ServerHorse.Utils.JWT, BCrypt;


procedure Registry;
begin
  THorse
  .Use(Jhonson)
  .Use(CORS)

  .Get('/users/:ID',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      iController : iControllerEntity<TUSERS>;
    begin
      iController := TController.New.USERS;
      iController.This.DAO.SQL.Where('GUUID = ' + QuotedStr(Req.Params['ID'])).&End.Find;
      Res.Send<TJsonArray>(iController.This.DataSetAsJsonArray);
    end)


  .Post('/users/auth',
   procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      iController : iControllerEntity<TUSERS>;
    begin
      iController := TController.New.USERS;
      iController.This.DAO.SQL.Where('EMAIL = ' + QuotedStr(Req.Body<TJSONObject>.GetValue<string>('email'))).&End.Find;

      if iController.This.DataSet.RecordCount <= 0 then
      begin
        Res.Status(401);
        exit;
      end;

      try
        Res
          .Status(200)
            .Send<TJsonObject>(
              TServerUtilsJWT
              .New
                .Password(Req.Body<TJSONObject>.GetValue<string>('password'))
                .Hash(iController.This.DataSet.FieldByName('password').AsString)
                .Issuer('ServerHorseAuthentication')
                .Subject(iController.This.DataSet.FieldByName('email').AsString)
                .Expiration(IncMinute(now, 30))
                .KeyJWT('67E685B6-ECC4-4967-8B31-BACB23F56417')
              .Token);
      except
        Res.Status(401);
      end;
    end)

  .Post('/users',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      vBody : TJsonObject;
      aGuuid: string;
      LHash : String;
    begin
      vBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      try
        LHash := TBCrypt.GenerateHash(vBody.GetValue<string>('password'));
        vBody.Get('password').JsonValue := TJSONString.Create(LHash);
        if not vBody.TryGetValue<String>('guuid', aGuuid) then
          vBody.AddPair('guuid', TServerUtils.New.AdjustGuuid(TGUID.NewGuid.ToString()));
        TController.New.USERS.This.Insert(vBody);
        Res.Status(200).Send<TJsonObject>(vBody);
      except
        Res.Status(500).Send('');
      end;
    end)

  .Put('/users/:ID',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      vBody : TJsonObject;
      aGuuid: string;
      LHash : String;
    begin
      vBody := TJSONObject.ParseJSONValue(Req.Body) as TJSONObject;
      try
        LHash := TBCrypt.GenerateHash(vBody.GetValue<string>('password'));
        vBody.Get('password').JsonValue := TJSONString.Create(LHash);
        if not vBody.TryGetValue<String>('guuid', aGuuid) then
          vBody.AddPair('guuid', Req.Params['ID'] );
        TController.New.USERS.This.Update(vBody);
        Res.Status(200).Send<TJsonObject>(vBody);
      except
        Res.Status(500).Send('');
      end;
    end)

  .Delete('/users/:id',
  procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
  begin
      try
        TController.New.USERS.This.Delete('guuid', QuotedStr(Req.Params['id']));
        Res.Status(200).Send('');
      except
        Res.Status(500).Send('');
      end;
    end);
end;

end.
