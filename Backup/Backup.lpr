program Backup;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, mplayercontrollaz, indylaz, runtimetypeinfocontrols, UInicial,
  UFbackup, UConst, UAppMutex, Utility, UWebServer, uzipfile;

{$R *.res}

var
  Assinatura: TAppCarregado;
begin

  Assinatura := TAppCarregado.Create(True);
  if not Assinatura.Carregado then
  begin

  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TFrmInicial, FrmInicial);
  Application.Run;

  end;


end.

