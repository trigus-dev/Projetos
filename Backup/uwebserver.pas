unit UWebServer;

{$mode objfpc}{$H+}
{$codepage UTF8}

interface

uses
  Classes, SysUtils, IdHTTPServer, IdCustomHTTPServer, IdContext,
  Utility;

type

  TCommand = (cmdNone, cmdSort, cmdRefresh, cmdBackup, cmdOnOff, cmdClear, cmdInfo);
  TWebOutput = procedure(Sender: TObject; xMsg: String) of Object;

  { TWebServer }

  TWebServer = class
  private
    AContext: TIdContext;
    ARequestInfo: TIdHTTPRequestInfo;
    AResponseInfo: TIdHTTPResponseInfo;
    FOnOutput: TWebOutput;
    FDefPath: String;
    FAtivado: Boolean;
    function CodigoCSS(): String;
    function CodigoFoot(xMsg: String): String;
    function CodigoHead(): String;
    function CodigoScript(): String;
    procedure DoWebOutput(xMsg: String);
    function GetDocument(): String;
    function CommandLink1(xPrm: String): String;
    function CommandLink2(xPrm1, xPrm2: String): String;
    function DownloadLink(xFile: String): String;
    function ButtonLink(xId: String; xUrl: String; xText: String; xHint: String = ''): String;
    function ButtonDown(xId: String; xUrl: String; xText: String; xHint: String = ''): String;
    function ButtonInfo(xId: String; xUrl: String; xText: String; xHint: String = ''): String;
    function ClickSort(xId: String; xUrl: String; xText: String = ''; xHint: String = ''): String;
  public
    constructor Create(); overload;
    constructor Create(xContext: TIdContext; xRequestInfo: TIdHTTPRequestInfo; xResponseInfo: TIdHTTPResponseInfo); overload;
    destructor Destroy();
    function ServerName(): String;
    function FormatHtml(xDados: String): String;
    function ServerDoc(): Boolean;
    function MainPage(xSort: TMyFileSort = mfsNone): String;
    function DownFiles(xSort: TMyFileSort = mfsNone): String;
    function Download(): Boolean;
    function Command(): TCommand;
    procedure WriteContent(xMsg: String);
  published
    property Ativado: Boolean read FAtivado write FAtivado;
    property DefPath: String read FDefPath write FDefPath;
    property OnOutput: TWebOutput read FOnOutput write FOnOutput;
  end;

  function CommandToStr(xCmd: TCommand): String;
  function StrToCommand(xCmd: String): TCommand;
  function SortToStr(xCmd: TMyFileSort): String;
  function StrToSort(xCmd: String): TMyFileSort;

implementation

uses
  UConst;

const
  CntCommand: Array[0..6] of String = ('cmdNone', 'cmdSort', 'cmdRefresh', 'cmdBackup', 'cmdOnOff', 'cmdClear', 'cmdInfo');
  CntSort: Array[0..3] of String = ('mfsNone', 'mfsName', 'mfsDate', 'mfsSize');

  CntServerName    = 'http://%s:8000/';
  CntDownloadLink  = 'Download.api?Arquivo=%s';
  CntCommandLink1  = 'Command.api?Param1=%s';
  CntCommandLink2  = 'Command.api?Param1=%s&Param2=%s';
  CntButtonLink    = '<a id="%s" href="%s" data-tooltip="%s"><button class="bt bt-lj" type="button"><span>%s</span></button></a>';
  CntButtonDown    = '<span class="botao" data-tooltip="%s"><a id="%s" href="%s">%s</a></span>';
  CntButtonInfo    = '<span class="bt-info" data-tooltip="%s"><a id="%s" href="%s">%s</a></span>';
  CntSortLink      = '<a id="%s" href="%s" data-tooltip="%s">%s</a>';

function CommandToStr(xCmd: TCommand): String;
begin
  Result := CntCommand[Integer(xCmd)];
end;

function StrToCommand(xCmd: String): TCommand;
var
  Idx: Integer;
begin
  Result := cmdNone;
  for Idx := 0 to Length(CntCommand)-1 do
  begin
    if CntCommand[Idx].ToUpper.Equals(xCmd.ToUpper) then
      Result := TCommand(Idx);
  end;
end;

function SortToStr(xCmd: TMyFileSort): String;
begin
  Result := CntSort[Integer(xCmd)];
end;

function StrToSort(xCmd: String): TMyFileSort;
var
  Idx: Integer;
begin
  Result := mfsNone;
  for Idx := 0 to Length(CntSort)-1 do
  begin
    if CntSort[Idx].ToUpper.Equals(xCmd.ToUpper) then
      Result := TMyFileSort(Idx);
  end;
end;

{ TWebServer }

constructor TWebServer.Create();
begin
  inherited;
  FAtivado := False;
  FDefPath := ApplicationPath() + 'Arquivos\';
  AContext := nil;
  ARequestInfo := nil;
  AResponseInfo := nil;
end;

constructor TWebServer.Create(xContext: TIdContext; xRequestInfo: TIdHTTPRequestInfo; xResponseInfo: TIdHTTPResponseInfo);
begin
  inherited Create();
  AContext := xContext;
  ARequestInfo := xRequestInfo;
  AResponseInfo := xResponseInfo;
end;

destructor TWebServer.Destroy();
begin

end;

procedure TWebServer.DoWebOutput(xMsg: String);
begin
  if Assigned(FOnOutput) then
    FOnOutput(Self, xMsg);
end;

function TWebServer.ServerName(): String;
begin
  Result := Format(CntServerName, [NomeDaMaquina()]);
end;

function TWebServer.DownloadLink(xFile: String): String;
begin
  Result := Format(CntDownloadLink, [xFile]);
end;

function TWebServer.CommandLink1(xPrm: String): String;
begin
  Result := Format(CntCommandLink1, [xPrm]);
end;

function TWebServer.CommandLink2(xPrm1, xPrm2: String): String;
begin
  Result := Format(CntCommandLink2, [xPrm1, xPrm2]);
end;

function TWebServer.ButtonLink(xId: String; xUrl: String; xText: String; xHint: String): String;
begin
  Result := Format(CntButtonLink, [xId, xUrl, xHint, xText]);
end;

function TWebServer.ButtonDown(xId: String; xUrl: String; xText: String; xHint: String): String;
begin
  Result := Format(CntButtonDown, [xHint, xId, xUrl, xText]);
end;

function TWebServer.ButtonInfo(xId: String; xUrl: String; xText: String; xHint: String): String;
begin
  Result := Format(CntButtonInfo, [xHint, xId, xUrl, xText]);
end;

function TWebServer.ClickSort(xId: String; xUrl: String; xText: String; xHint: String): String;
begin
  Result := Format(CntSortLink, [xId, xUrl, xHint, xText]);
end;

function TWebServer.CodigoCSS(): String;
begin
  Result := '';
end;

function TWebServer.CodigoScript(): String;
begin
  Result := '';
end;

function TWebServer.CodigoHead(): String;
begin
  Result :=
    String('<!DOCTYPE html>') + pFIMLIN +
    String('<html lang="pt-br">') + pFIMLIN +
    String('<head>') + pFIMLIN +
    String('<title>') + CntAppFull + '</title>' + pFIMLIN +
    String('<meta Content-Type="text/html"; charset="UTF-8">') + pFIMLIN +
    String('<meta name="viewport" content="width=device-width, initial-scale=1.0">') + pFIMLIN +
    String('<meta http-equiv="X-UA-Compatible" content="ie=edge">') + pFIMLIN +
    String('<link rel="stylesheet" type="text/css" href="arquivos/trigus.css"/>') + pFIMLIN +
    String('<link rel="stylesheet" type="text/css" href="arquivos/button.css"/>') + pFIMLIN +
    //CodigoCSS() +
    String('</head>') + pFIMLIN +
    String('<body>') + pFIMLIN +
    //'<div id="x2"><span id="mensagem">Avisos/Alertas</span></div>' + pFIMLIN +
    String('<div id="status"><span class="avisos show">Avisos/Alertas</span></div>') + pFIMLIN +
    String('');
end;

function TWebServer.CodigoFoot(xMsg: String): String;
begin
  Result :=
    String('<div id="x3">') + CntAppCopy +  '</div>' + pFIMLIN +
    String('<script charset="utf-8" src="arquivos/jquery-1.11.0.min.js"></script>') + pFIMLIN +
    String('<script charset="utf-8" src="arquivos/trigus.js"></script>') + pFIMLIN +
    //CodigoScript() + pFIMLIN +
    String('</body>') + pFIMLIN +
    String('</html>') + pFIMLIN +
    String('');
end;

function TWebServer.FormatHtml(xDados: String): String;
begin
  Result := xDados;
  Result := Result.Replace(pFIMLIN,'<br>');
end;

function TWebServer.ServerDoc(): Boolean;
var
  TmpDoc: String;
begin
  Result := False;
  TmpDoc := GetDocument();
  if not TmpDoc.IsEmpty then
  begin
    if FileExists(TmpDoc) then
    begin
      Result := True;
      DoWebOutput('Baixando Arquivo "' + TmpDoc + '"...');
      AResponseInfo.ServeFile(AContext, TmpDoc);
    end;
  end;
end;

function TWebServer.GetDocument(): String;
begin
  Result := ARequestInfo.Document;
  if Result.Equals('/') then
    Result := '';
  if Result.Contains('favicon') then
    Result := '';
  if Copy(Result,1,1) = '/' then
    Result := Copy(Result, 2, Length(Result));
end;

function TWebServer.DownFiles(xSort: TMyFileSort): String;
var
  TmpArq: String;
  TmpLnk: String;
  ImgLnk: String;
  TmpMsg: String;
  TmpRes: String;
  TmpIdx: Integer;
  FileList: TMyFileList;
begin
  FDefPath := IncludeTrailingPathDelimiter(FDefPath);
  FileList := ListarArquivos(FDefPath, '*.*', xSort);

  TmpRes := '' + pFIMLIN;
  TmpRes := TmpRes + '<!-- COMEÇO DA LISTA DE ARQUIVOS -->' + pFIMLIN;
  TmpRes := TmpRes + '<div>' + pFIMLIN;
  TmpRes := TmpRes + '<section class="container grid grid-template-columns">' + pFIMLIN;
  for TmpIdx := 0 to FileList.Count - 1 do
  begin
    TmpArq := TMyFile(FileList.Items[TmpIdx]).Nome;
    TmpLnk := DownloadLink(TmpArq);
    ImgLnk := ButtonDown((TmpIdx+1).ToString, TmpLnk, '', 'Baixar o Arquivo ' + TmpArq + '...');
    TmpRes := TmpRes + '<div class="item"">' + ImgLnk + '</div>' + pFIMLIN;
    TmpRes := TmpRes + '<div class="item" style="text-align: left;">' + TmpArq + '</div>' + pFIMLIN;
    TmpRes := TmpRes + '<div class="item">' + FormatDateTime('dd/mm/yyyy hh:nn:ss', TMyFile(FileList.Items[TmpIdx]).DataHoras) + '</div>' + pFIMLIN;
    TmpRes := TmpRes + '<div class="item">' + FileSizeFormatStr(TMyFile(FileList.Items[TmpIdx]).Tamanho) + '</div>' + pFIMLIN;
  end;
  TmpMsg := '' + FileList.Count.ToString + ' arquivo(s) de backup encontrado(s).';
  TmpRes := TmpRes + '<div class="item one"><h2>' + TmpMsg + '</h2></div>' + pFIMLIN;
  TmpRes := TmpRes + '</section>' + pFIMLIN;
  TmpRes := TmpRes + '</div>' + pFIMLIN;
  TmpRes := TmpRes + '<!-- FINAL DA LISTA DE ARQUIVOS -->' + pFIMLIN;
  Result := TmpRes;
end;

function TWebServer.MainPage(xSort: TMyFileSort): String;
var
  TmpArq: String;
  TmpLnk: String;
  ImgLnk: String;
  TmpRes: String;
begin

  TmpRes := '' + pFIMLIN;
  TmpRes := TmpRes + '<!-- COMEÇO DA TABELA DE CABEÇALHO -->' + pFIMLIN;
  TmpRes := TmpRes + '<div>' + pFIMLIN;
  TmpRes := TmpRes + '<section class="container grid-top grid-template-columns-top">' + pFIMLIN;

  TmpLnk := CommandLink1(CommandToStr(cmdBackup));
  ImgLnk := ButtonLink('btn1', TmpLnk, 'Backup', 'Fazer uma Cópia Agora');
  TmpRes := TmpRes + '<div class="item item-top">' + ImgLnk + '</div>' + pFIMLIN;

  if FAtivado then
  begin
    TmpLnk := CommandLink1(CommandToStr(cmdOnOff));
    ImgLnk := ButtonLink('btn2', TmpLnk, 'Ativar', 'Ativar o Servidor');
  end else
  begin
    TmpLnk := CommandLink1(CommandToStr(cmdOnOff));
    ImgLnk := ButtonLink('btn2', TmpLnk, 'Desativar', 'Desativar o Servidor');
  end;
  TmpRes := TmpRes + '<div class="item item-top">' + ImgLnk + '</div>' + pFIMLIN;

  TmpLnk := CommandLink1(CommandToStr(cmdRefresh));
  ImgLnk := ButtonLink('btn3', TmpLnk, 'Atualizar', 'Atualizar a Página');
  TmpRes := TmpRes + '<div class="item item-top">' + ImgLnk + '</div>' + pFIMLIN;

  TmpLnk := CommandLink1(CommandToStr(cmdClear));
  ImgLnk := ButtonLink('btn4', TmpLnk, 'Limpeza', 'Limpar os Arquivos mais Velhos');
  TmpRes := TmpRes + '<div class="item item-top">' + ImgLnk + '</div>' + pFIMLIN;

  TmpRes := TmpRes + '</section>' + pFIMLIN;
  TmpRes := TmpRes + '</div>' + pFIMLIN;
  TmpRes := TmpRes + '<!-- FINAL DA TABELA DE CABEÇALHO -->' + pFIMLIN;

  //////////////////////////////////////////////////////////////////////////////
  TmpRes := TmpRes + '<br>' + pFIMLIN;

  TmpRes := TmpRes + '<!-- COMEÇO DA TABELA DE ARQUIVOS -->' + pFIMLIN;
  TmpRes := TmpRes + '<div>' + pFIMLIN;

  TmpRes := TmpRes + '<section class="container grid grid-template-columns">' + pFIMLIN;

  TmpLnk := CommandLink1(CommandToStr(cmdInfo));
  ImgLnk := ButtonInfo('col1', TmpLnk, '', 'Informações do Servidor');
  TmpRes := TmpRes + '<div class="item item-cab">' + ImgLnk + '</div>' + pFIMLIN;

  TmpLnk := CommandLink2(CommandToStr(cmdSort), SortToStr(mfsName));
  ImgLnk := ClickSort('col2', TmpLnk, 'ARQUIVO', 'Ordenar por Nome do Arquivo');
  TmpRes := TmpRes + '<div class="item item-cab">' + ImgLnk + '</div>' + pFIMLIN;

  TmpLnk := CommandLink2(CommandToStr(cmdSort), SortToStr(mfsDate));
  ImgLnk := ClickSort('col3', TmpLnk, 'DATA', 'Ordenar por Data Descendente ');
  TmpRes := TmpRes + '<div class="item item-cab">' + ImgLnk + '</div>' + pFIMLIN;

  TmpLnk := CommandLink2(CommandToStr(cmdSort), SortToStr(mfsSize));
  ImgLnk := ClickSort('col4', TmpLnk, 'TAMANHO', 'Ordenar por Tamanho do Arquivo');
  TmpRes := TmpRes + '<div class="item item-cab">' + ImgLnk + '</div>' + pFIMLIN;
  TmpRes := TmpRes + '</section>' + pFIMLIN;
  TmpRes := TmpRes + '</div>' + pFIMLIN;

  TmpRes := TmpRes + '<div id="files-show"><span id="corpo">' + pFIMLIN;
  TmpRes := TmpRes + DownFiles(xSort);
  TmpRes := TmpRes + '</span>' + pFIMLIN;

  TmpRes := TmpRes + '<!-- FINAL DA TABELA DE ARQUIVOS -->' + pFIMLIN;

  Result :=
    CodigoHead() +
    '<p id="p01">' + CntAppFull + '</p>' + pFIMLIN +
    '<p id="p02">' + TmpRes + '</p>' + pFIMLIN +
    CodigoFoot('') +
    '';

end;

(*
function TWebServer.DownFiles(xSort: TMyFileSort): String;
var
  TmpArq: String;
  TmpLnk: String;
  ImgLnk: String;
  TmpMsg: String;
  TmpIdx: Integer;
  FileList: TMyFileList;
begin
  FDefPath := IncludeTrailingPathDelimiter(FDefPath);
  FileList := ListarArquivos(FDefPath, '*.*', xSort);

  Result := '';
  Result := Result + '<!-- COMEÇO DA LISTA DE ARQUIVOS -->' + pFIMLIN;
  Result := Result + '<table style="width:100%">' + pFIMLIN;
  for TmpIdx := 0 to FileList.Count - 1 do
  begin
    TmpArq := TMyFile(FileList.Items[TmpIdx]).Nome;
    TmpLnk := DownloadLink(TmpArq);
    ImgLnk := ClickDown((TmpIdx+1).ToString, TmpLnk, ImageLink((TmpIdx+1).ToString, 'download.png'));
    Result := Result + '<tr>' + pFIMLIN;
    Result := Result + '<td id="d01">' + ImgLnk + '</td>' + pFIMLIN;
    Result := Result + '<td id="d02" style="width:60%;text-align:left;">' + TmpArq + '</td>' + pFIMLIN;
    Result := Result + '<td id="d01" style="width:20%;text-align:center;">' + FormatDateTime('dd/mm/yyyy hh:nn:ss', TMyFile(FileList.Items[TmpIdx]).DataHoras) + '</td>' + pFIMLIN;
    Result := Result + '<td id="d01" style="width:20%;text-align:right;">' + FileSizeFormatStr(TMyFile(FileList.Items[TmpIdx]).Tamanho) + '</td>' + pFIMLIN;
    Result := Result + '</tr>' + pFIMLIN;
  end;
  TmpMsg := '' + FileList.Count.ToString + ' arquivo(s) de backup encontrado(s).';
  Result := Result + '<tr>' + pFIMLIN;
  Result := Result + '<td id="d01" colspan="4"><h2>' + TmpMsg + '</h2></td>' + pFIMLIN;
  Result := Result + '</tr>' + pFIMLIN;
  Result := Result + '</table>' + pFIMLIN;
  Result := Result + '<!-- FINAL DA LISTA DE ARQUIVOS -->' + pFIMLIN;
end;

function TWebServer.MainPage(xSort: TMyFileSort): String;
var
  TmpArq: String;
  TmpLnk: String;
  ImgLnk: String;
  TmpRes: String;
begin

  TmpRes := '' + pFIMLIN;
  TmpRes := TmpRes + '<!-- COMEÇO DA TABELA DE CABEÇALHO -->' + pFIMLIN;
  TmpRes := TmpRes + '<table id="t01" align="center">' + pFIMLIN;
  TmpRes := TmpRes + '<tr>' + pFIMLIN;
  TmpLnk := CommandLink1(CommandToStr(cmdBackup));
  ImgLnk := ClickDown('btn1', TmpLnk, ImageLink('img1', 'backup.png'));
  TmpRes := TmpRes + '<td style="text-align:center;">' + ImgLnk + '</td>' + pFIMLIN;
  if FAtivado then
  begin
    TmpLnk := CommandLink1(CommandToStr(cmdOnOff));
    ImgLnk := ClickDown('btn2', TmpLnk, ImageLink('img2', 'ativar.png'));
  end else
  begin
    TmpLnk := CommandLink1(CommandToStr(cmdOnOff));
    ImgLnk := ClickDown('btn2', TmpLnk, ImageLink('img2', 'desativar.png'));
  end;
  TmpRes := TmpRes + '<td style="text-align:center;">' + ImgLnk + '</td>' + pFIMLIN;

  TmpLnk := CommandLink1(CommandToStr(cmdRefresh));
  ImgLnk := ClickDown('btn3', TmpLnk, ImageLink('img3', 'atualizar.png'));
  TmpRes := TmpRes + '<td style="text-align:center;">' + ImgLnk + '</td>' + pFIMLIN;
  TmpRes := TmpRes + '</tr>' + pFIMLIN;
  TmpRes := TmpRes + '</table>' + pFIMLIN;
  TmpRes := TmpRes + '<!-- FINAL DA TABELA DE CABEÇALHO -->' + pFIMLIN;

  //////////////////////////////////////////////////////////////////////////////
  TmpRes := TmpRes + '<br>' + pFIMLIN;

  TmpRes := TmpRes + '<!-- COMEÇO DA TABELA DE ARQUIVOS -->' + pFIMLIN;
  TmpRes := TmpRes + '<table id="t02" align="center" style="width:50%">' + pFIMLIN;
  TmpRes := TmpRes + '<tr style="background-color:#b4b4b4">' + pFIMLIN;
  //TmpRes := TmpRes + '<th style="width:208px; display:block;">&nbsp;</th>' + pFIMLIN;
  TmpRes := TmpRes + '<th id="d01"><img id="img1" style="display: block;" src="imagens/download.png" alt=""></th>' + pFIMLIN;
  TmpLnk := CommandLink2(CommandToStr(cmdSort), SortToStr(mfsName));
  ImgLnk := ClickDown('col1', TmpLnk, 'Arquivo');
  TmpRes := TmpRes + '<th style="width:61%;">' + ImgLnk + '</th>' + pFIMLIN;
  TmpLnk := CommandLink2(CommandToStr(cmdSort), SortToStr(mfsDate));
  ImgLnk := ClickDown('col2', TmpLnk, 'Data');
  TmpRes := TmpRes + '<th style="width:21%;">' + ImgLnk + '</th>' + pFIMLIN;
  TmpLnk := CommandLink2(CommandToStr(cmdSort), SortToStr(mfsSize));
  ImgLnk := ClickDown('col3', TmpLnk, 'Tamanho');
  TmpRes := TmpRes + '<th style="width:20%;">' + ImgLnk + '</th>' + pFIMLIN;
  TmpRes := TmpRes + '</tr>' + pFIMLIN;

  TmpRes := TmpRes + '<tr>' + pFIMLIN;
  TmpRes := TmpRes + '<td colspan="4">' + pFIMLIN;

  TmpRes := TmpRes + '<div id="files-show"><span id="corpo">' + pFIMLIN;
  TmpRes := TmpRes + DownFiles(xSort);
  TmpRes := TmpRes + '</span></div>' + pFIMLIN;

  TmpRes := TmpRes + '</td>' + pFIMLIN;
  TmpRes := TmpRes + '</tr>' + pFIMLIN;

  TmpRes := TmpRes + '</table>' + pFIMLIN;
  TmpRes := TmpRes + '<!-- FINAL DA TABELA DE ARQUIVOS -->' + pFIMLIN;

  Result :=
    CodigoHead() +
    '<p id="p01">' + CntAppFull + '</p>' + pFIMLIN +
    '<p id="p02">' + TmpRes + '</p>' + pFIMLIN +
    CodigoFoot('') +
    '';

end;
*)

function TWebServer.Download(): Boolean;
var
  TmpDoc: String;
  TmpArq: String;
begin
  Result := False;
  FDefPath := IncludeTrailingPathDelimiter(FDefPath);
  TmpDoc := GetDocument();
  if TmpDoc.Contains('Download.api') then
  begin
    TmpArq := FDefPath + ARequestInfo.Params.Values['Arquivo'];
    if not TmpArq.IsEmpty then
    begin
      if FileExists(TmpArq) then
      begin
        Result := True;
        DoWebOutput('Baixando Arquivo "' + ExtractFileName(TmpArq) + '"...');
        AResponseInfo.ServeFile(AContext, TmpArq);
      end;
    end;
  end;
end;

function TWebServer.Command(): TCommand;
var
  TmpDoc: String;
  TmpCmd: String;
begin
  Result := cmdNone;
  TmpDoc := GetDocument();
  if TmpDoc.Contains('Command.api') then
  begin
    TmpCmd := ARequestInfo.Params.Values['Param1'];
    Result := StrToCommand(TmpCmd);
  end;
end;

procedure TWebServer.WriteContent(xMsg: String);
begin
  AResponseInfo.ContentType   := 'text/html';
  AResponseInfo.CharSet       := 'utf-8';
  AResponseInfo.ContentStream := TMemoryStream.Create();
  try
    AResponseInfo.ContentStream.Write(Pointer(xMsg)^, Length(xMsg));
    AResponseInfo.ContentStream.Position := 0;
    AResponseInfo.WriteContent();
  finally
    AResponseInfo.ContentStream := nil;
  end;
end;

end.

