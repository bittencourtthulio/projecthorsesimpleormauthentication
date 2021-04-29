program ServerHorseAuthentication;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  ServerHorse.Model.Entity.USERS in 'src\Model\Entity\ServerHorse.Model.Entity.USERS.pas',
  ServerHorse.Model.DAO in 'src\Model\DAO\ServerHorse.Model.DAO.pas',
  ServerHorse.Model.Connection in 'src\Model\Connection\ServerHorse.Model.Connection.pas',
  ServerHorse.Controller.Generic in 'src\Controller\ServerHorse.Controller.Generic.pas',
  ServerHorse.Controller.Interfaces in 'src\Controller\ServerHorse.Controller.Interfaces.pas',
  ServerHorse.Controller in 'src\Controller\ServerHorse.Controller.pas',
  ServerHorse.Routers.Users in 'src\Routers\ServerHorse.Routers.Users.pas',
  ServerHorse.Utils in 'src\Utils\ServerHorse.Utils.pas',
  ServerHorse.Utils.JWT in 'src\Utils\ServerHorse.Utils.JWT.pas';

begin
  ServerHorse.Routers.Users.Registry;
  THorse.Listen(9005);
end.
