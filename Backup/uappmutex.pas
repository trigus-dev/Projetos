unit UAppMutex;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs;

type

  TArquivoTrava = class
  private
    { Private declarations }
    FArquivo: String;
    function GetExecucoes(): Integer;
  public
    { Public declarations }
 		constructor Create();
    //destructor Destroy(); override;
  protected
    { Protected declarations }
  published
    { Published declarations }
    property Arquivo: String read FArquivo;
    property Execucoes: Integer read GetExecucoes;
  end;

  TAppCarregado = class(TArquivoTrava)
  private
    { Private declarations }
    //FAppName: String;
    FArqStream: TFileStream;
    FCarregado: Boolean;
  public
    { Public declarations }
 		constructor Create(ShowInfo: Boolean = False);
    function GetCarregado(): Boolean;
    destructor Destroy(); override;
  protected
    { Protected declarations }
  published
    { Published declarations }
    //property AppName: String read FAppName write FAppName;
    property Carregado: Boolean read GetCarregado;
  end;


implementation

uses
  Utility;

{ TArquivoTrava }

constructor TArquivoTrava.Create();
var
  TmpParam: String;
begin
  TmpParam := SoNumero(ParamStr(1));
  if TmpParam = '' then TmpParam := '0';
  TmpParam := StrZero(TmpParam, 3);
  FArquivo := ApplicationPath() + NomeDaMaquina() + '-' + NomeDoUsuario() + '-' + TmpParam + '.lck';
end;

function TArquivoTrava.GetExecucoes(): Integer;
var
  I: Integer;
  FileList: TMyFileList;
begin

  FileList := ListarArquivos(ExtractFilePath(FArquivo), '*.lck');
  for I := 0 to FileList.Count - 1 do
    DeleteFile(TMyFile(FileList.Items[I]).Nome);

  FileList := ListarArquivos(ExtractFilePath(FArquivo), '*.lck');
  Result := FileList.Count;

  FreeAndNil(FileList);
end;

{ TAppCarregado }

constructor TAppCarregado.Create(ShowInfo: Boolean);
begin
  inherited Create();
  FCarregado := False;

  try
    FArqStream := TFileStream.Create(Arquivo, fmCreate or fmShareExclusive);
  except
    FArqStream := nil;
    FCarregado := True;
  end;

  if FCarregado and ShowInfo then
  begin
    ShowMessage('A aplicação já se encontra rodando no sistema!');
  end;

end;

destructor TAppCarregado.Destroy();
begin
  FreeAndNil(FArqStream);
  DeleteFile(Arquivo);
  inherited;
end;

function TAppCarregado.GetCarregado(): Boolean;
begin
  Result := FCarregado;
end;

end.

