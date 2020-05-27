unit UFbackup;

{$mode objfpc}{$H+}
{$codepage UTF8}

interface

uses
  Classes, SysUtils, IniFiles, FBAdmin;

type

  { TClassFBackup }

  TClassFBackup = class
    private
      FOnOtput: TIBOnOutput;
      FAdmin: TFBAdmin;
      procedure DoOutput(Sender: TObject; msg: string; IBAdminAction: string);
      procedure GravarConfig();
      procedure LerConfig();
    public
      constructor Create();
      destructor Destroy();
      procedure Backup(Database, Backupfile: string);
      procedure Restore(Database, Backupfile: string);

      property OnOtput: TIBOnOutput read FOnOtput write FOnOtput;
  end;

implementation

uses
  UConst;

{ TClassFBackup }

procedure TClassFBackup.DoOutput(Sender: TObject; msg: string; IBAdminAction: string);
begin
  if Assigned(FOnOtput) then
    FOnOtput(Sender, msg, IBAdminAction);
end;

constructor TClassFBackup.Create();
begin
  inherited;
  FAdmin := TFBAdmin.Create(nil);
  FAdmin.OnOutput := @DoOutput;
  FAdmin.Protocol := IBSPTCPIP;
  FAdmin.UseExceptions := True;
  LerConfig();
end;

destructor TClassFBackup.Destroy();
begin
  GravarConfig();
  FreeAndNil(FAdmin);
  inherited;
end;

procedure TClassFBackup.Backup(Database, Backupfile: string);
begin
  try
    FAdmin.Connect();
    FAdmin.Backup(Database, Backupfile, [IBBkpVerbose]);
    FAdmin.Disconnect();
  finally

  end;
end;

procedure TClassFBackup.Restore(Database, Backupfile: string);
begin
  try
    FAdmin.Connect();
    FAdmin.Restore(Database, Backupfile, [IBResVerbose, IBResReplace]);
    FAdmin.Disconnect();
  finally

  end;
end;

procedure TClassFBackup.LerConfig();
var
  IniFile: TIniFile;
begin
  if not FileExists(CntCfgArquivo) then Exit;

  IniFile := TIniFile.Create(CntCfgArquivo);
  FAdmin.Host := IniFile.ReadString(CntCfgSessao2, 'Host', 'localhost');
  FAdmin.User := IniFile.ReadString(CntCfgSessao2, 'User', 'sysdba');
  FAdmin.Password := IniFile.ReadString(CntCfgSessao2, 'Password', 'masterkey');
  FAdmin.Port := IniFile.ReadInteger(CntCfgSessao2, 'Port', 3050);
  if not IniFile.SectionExists('Host') then
    GravarConfig();
  FreeAndNil(IniFile);

end;

procedure TClassFBackup.GravarConfig();
var
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(CntCfgArquivo);
  IniFile.WriteString(CntCfgSessao2, 'Host', FAdmin.Host);
  IniFile.WriteString(CntCfgSessao2, 'User', FAdmin.User);
  IniFile.WriteString(CntCfgSessao2, 'Password', FAdmin.Password);
  IniFile.WriteInteger(CntCfgSessao2, 'Port', FAdmin.Port);
  FreeAndNil(IniFile);
end;

end.

