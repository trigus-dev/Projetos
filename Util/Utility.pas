unit Utility;

{$mode objfpc}{$H+}
//{$codepage UTF8}

interface

uses
  Windows, SysUtils, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DB, MaskEdit, ExtCtrls, DBGrids, Contnrs, DateUtils,
  Printers, Clipbrd, Variants, Zipper,
  Registry, WinSock, Math, TypInfo, Process, LCLProc, LazHelpHTML, UTF8Process;

type

  TMyFileSort = (mfsNone, mfsName, mfsDate, mfsSize);

  TMyFile = class(TPersistent)
  private
    FDataHoras: TDateTime;
    FTamanho: Int64;
    FLocal: String;
    FNome: String;
  public
    constructor Create();
  published
    property DataHoras: TDateTime read FDataHoras write FDataHoras;
    property Tamanho: Int64 read FTamanho write FTamanho;
    property Local: String read FLocal write FLocal;
    property Nome: String read FNome write FNome;
  end;

  TMyFileList = class(TObjectList)
  public
    constructor Create();
    function NewFile(): TMyFile;
  end;

  TPassThroughData = Record
    nLen : Integer;
    Data : Array[0..255] of byte;
  end;
  TArray = Array of String;

  Posicao = (tbEsquerdo,tbCentro,tbDireito);
  SndType = (SndErro, SndCaixa, SndAlerta, SndErroCupom);
  DrvType = (drREMOVABLE,drFIXED,drREMOTE);

  TShortcutPlace = (stDesktop, stStartMenu);
  TRegis = String[3];

const
  pFIMLIN=CHR(13)+CHR(10);


{ Public declarations }
function Tabula(Texto: String; Tamanho: Integer; Opcao: Posicao):String;
function ZeraCodigo(Codigo:Variant; Tamanho:Integer; Caractere:Char): String;
function Iif(Valor:Boolean; RetornoT, RetornoF: Variant): Variant;
function Replicate(cChar: String; nTam:Integer):String;
function IsDigit(var Texto: String):Boolean;
function DataExtenso(xData: TDate):String;
function SemanaExtenso(xData: TDate):String;
function DataValida(Data:String): Boolean;
function HoraValida(Hora: String): Boolean;
function ChecaData(Text: String): Variant;
procedure CriarAtalho(Path, Nome, Menu, Param: String);
procedure CriaShortCut(aNome, aFileName: String; aLocation: integer);
procedure CreateShortcut(FileName, Parameters, InitialDir, ShortcutName,ShortcutFolder : Pchar; Place: TShortcutPlace);
procedure DeskLink(Nome: String);
function WindowsDir():String;
function SystemDir():String;
function TempDir():String;
function WimTempDir():String;
function InternetTempDir():String;
procedure CriarLink(Menu, Param: String);
function NomeDoUsuario(): String;
function NomeDaMaquina(): String;
function MyFileSize(FileName: String): Int64;
procedure EraseFile(Arquivo: String);
function CopyFile(Origem, Destino: String; FalhaExistindo: Boolean = False): Boolean;
function ExtractFileBase(Path: String): String;
function StrTran(const Source, Find, Replace: String): String;
function LeArquivo(Arquivo: String): String;
procedure GravaArquivo(Arquivo, Valor: String);
function CalculaDigito(Codigo: String): String;
function CheckDigito(Codigo: String): Boolean;
function SetDigito(Codigo: String): String;
function LimpaCodigo(Codigo: String): String;
function LimpaTudo(Texto: String): String;
function NetFile(NetExt: String): String;
function NetArquivo(NetExt: String): String;
function Space(nTam:Integer):String;
function StrZero(cStr: Variant; Tamanho:Integer): String;
function StrListScan(MyStrList: TStringList;MyStr: String): Integer;
function SemAcento(xDad: String): String;
function CalculoDeJuros(xDtv, xDtp: TDate; xVal, xTaxa: Currency): Currency;
procedure MsgSound(Som: SndType);
procedure AppendArquivo(Arquivo, Valor: String);
function Linha(Memo: TMemo): Integer;
function Semana(ADate: TDateTime):String;
function CheckDrive(Drv: DrvType):Boolean;
procedure EscondeBarra(Esconder: Boolean);
procedure AutoInicializa(const TodosUsuarios: boolean = False; const Apaga: boolean = False);
function DelphiCarregado(): Boolean;
function Codifica(Texto : String): String;
function Decodifica(Texto : String): String;
function TempRegistro(): Integer;
function Fracionado(Valor: Currency): Boolean;
procedure FormatQuery(Qry: TDataSet; const Mask: String = ',##0.00'); overload;
procedure FormatTable(Tbl: TDataSet; const Mask: String = ',##0.00');
function ApplicationPath(): String;
function Captaliza(Texto: String): String;
function CaptalizaAcentos(xDad: String): String;
function ExtractDiskSerial(Drive: String): String;
function FormataDecimal(Valor: Double; Decimal: Integer = 2): Double;
function SoNumero(Text: String): String;
function SoLetras(Text: String): String;
function DataVazia(Data: String): Boolean;
procedure SetDateTime(Valor: TDateTime);
function DacModulo10(const Value: String): String;
function LimpaData(Value: String): String;
function MemoLine(Memo: TMemo): Integer;
function Encriptar(Texto: String): String;
function Decriptar(Texto: String): String;
function RoundDecimal(const Value: Double; const Decimal: Integer = 2): Double;
function RoundValue(Value: Extended; Decimals: Integer = 2): Extended;
function DivideValor(const Valor1, Valor2: Currency; const Trunca: Boolean = True; Decimal: Integer = 2): Currency;
function DisplayTruncaDecimal(const Value: Double; const Decimal: Integer = 2): String;
procedure CopiaEstrutura(DS1, DS2: TDataSet);
procedure CopiaDados(DS1, DS2: TDataSet);
function TestaCnpj(xCNPJ: String): Boolean;
function GetWordField(Field, Value, Option: String): String; overload;
function GetWordField(var List: TStringList; Field, Value: String; Option: String = 'OR'): String; overload;
function GetOrder(List: TStringList; Find: String): String; //overload;
function TempFile(const Start: String = 'TMP'): String;
function NumeroControle(): String;
function GerarControle(): String;
function GerarRegistro(Ctrl: TRegis = ''): String;
function CharToAsc(const Value: String): String;
function CtrlD(): Double;
function CtrlS(): String;
function BoolToStr(Value: Boolean): String;
function StrToBool(Value: String): Boolean;
function BollToMyStr(const Value: Boolean): String;
function MyStrToBoll(const Value: String): Boolean;
function DateStr(Value: String): String; overload;
function DateStr(Value: TDate): String; overload;
procedure CopyMem(Value: String);
function Inverte(Value: String): String;
function CheckCombo(Value: TComboBox): String; overload;
function CheckCombo(Value: String): ShortInt; overload;
function AplicativosRodando(): String;
function CheckRunning(CloseApp: Boolean = False): Boolean;
function FloatValor(Valor: String): Double;
function CheckForm(Form: TForm): Boolean;
function AsInteger(Valor: String): Integer;
function AsFloat(Valor: String): Double;
function DoubleTruncate(const Value: Double; const Decimal: Integer = 2): Double;
function TxtToFloat(Valor: String; Decimal: Integer = 2): Double;
procedure SetCursor(NewCursor: TCursor = crNo);
function DeleteFileWithUndo(sFileName : String): Boolean;
procedure LimparArquivosTemporarios();
function FeriadosMoveis(Ano: Integer; V: Integer): TDateTime;
function PadL(Text: String; Len: Integer): String;
function PadR(Text: String; Len: Integer): String;
function PadC(Text: String; Len: Integer): String;
function DateTimeStr(): String;
function LerLinha(Arquivo: String; Linha: Integer): String;
function GetOSInfo(): String;
function GetLocalIP(): String;
function GetIP(): String;
function StrIsNumber(const S: String): Boolean;
function ToUpper(Text: String): String;
function ToLower(Text: String): String;
function NewID(): Double;
procedure GetSubDirs(Folder: string; sList: TStringList);
function IndexOffCol(Columns: TDBGridColumns; FieldName: String): Integer;
function IndexOffFil(Fields: TFields; FieldName: String): Integer;
function AscToString(AString: String): String;
function MyExitWindows(RebootParam: Longword): Boolean;
function ExecAndWait(const FileName, Params: String; const WinState: Word): boolean; export;
procedure RunCommand(Command: String; Params: String; Wait : Boolean; WindowState : Word);
procedure AddStrArray(var MyArray: TArray; MyValue: String);
function EncryptSTR(const InString:string; StartKey, MultKey, AddKey:Integer): string;
function DecryptSTR(const InString:string; StartKey, MultKey, AddKey:Integer): string;
function SerialNumHD(FDrive: String) :String;
function ChecaDiferenca(Valor1, Valor2: Currency; Diferenca: Currency = 0.10): Boolean;
procedure ListaArquivos(Filter, Folder: String; Recurse: Boolean; FileList: TStringList);
function ListarArquivos(const xPath, xMask: String; xSort: TMyFileSort = mfsName): TMyFileList;
function SetFileDateTime(FileName: string; CreateTime, ModifyTime, AcessTime: TDateTime): Boolean;
function MyFileTimeToDateTime(FTime: TFileTime): TDateTime;
function MyFileDateTime(aFilePath: String): TDateTime;
function MyFileLength(aFilePath: String): Int64;
function HtmlContentType(FileName: String): String;
function LinhaSimples(nLen: Integer = 40): String;
function FileFormatStr(FileName: String): String;
function FileSizeFormatStr(xFileSize: Double): String;
procedure ShellExecute(FileName: String);
procedure CompactarArquivo(xFileIn, xFileOut: String);
procedure DescompactarArquivo(xFileIn, xPathOut: String);
function NavegadorPadrao(): String;

implementation

uses
  ComObj, ActiveX, ShlObj, ShellAPI, MMSystem;

{ TMyFile }

constructor TMyFile.Create();
begin
  inherited Create();
  FDataHoras := Now();
  FTamanho := 0;
  FNome := '';
end;

{ TMyFileList }

constructor TMyFileList.Create();
begin
  inherited Create();

end;

function TMyFileList.NewFile(): TMyFile;
begin
  Result := TMyFile.Create();
  Self.Add(Result);
end;

function StrListScan(MyStrList: TStringList; MyStr: String): Integer;
var
  nFor:Integer;
begin
  for nFor := 00 to MyStrList.Count-01 do
  begin
		if Trim(MyStrList[nFor]) = Trim(MyStr) then
    begin
      Result:=nFor;Exit
    end;
  end;
  Result := -01;
end;

function LerLinha(Arquivo: String; Linha: Integer): String;
var
  MyFile: TextFile;
  MyLinha: String;
  MyPos: Integer;
begin
  if FileExists(Arquivo) then
  begin
    MyPos:=1;
    AssignFile(MyFile, Arquivo);
    Reset(MyFile);
    while not(eof(MyFile)) do
    begin
	    ReadLn(MyFile, MyLinha);
      if MyPos = Linha then Break;
      Inc(MyPos);
    end;
 	  CloseFile(MyFile);
  end;
  Result := MyLinha;
end;

function SetDigito(Codigo: String): String;
var
  StrCorpo : String;
  //StrDigito: String;
  StrResult: String;
begin
  StrCorpo :=Copy(Codigo,1,Length(Codigo)-1);
  //StrDigito:=Copy(Codigo,Length(Codigo),1);
  StrResult:=CalculaDigito(StrCorpo);
  Result:=StrCorpo+StrResult;
end;

function LimpaCodigo(Codigo: String): String;
type
  Digitos = set of Char;
var
  Dig      : Digitos;
  IFor     : Integer;
  StrCodigo:String;
begin
  Dig := ['0'..'9'];
  StrCodigo:='';
	for IFor := 01 to Length(Codigo) do
  begin
		if Codigo[IFor] in Dig then
      StrCodigo := StrCodigo + Codigo[IFor]
  end;
  Result:=StrCodigo;
end;

function LimpaTudo(Texto: String): String;
type
  Digitos = set of Char;
var
  Dig      : Digitos;
  IFor     : Integer;
  StrCodigo:String;
begin
  Dig := ['0'..'9','A'..'Z','a'..'z'];
  StrCodigo:='';
	for IFor := 01 to Length(Texto) do
  begin
		if Texto[IFor] in Dig then
      StrCodigo := StrCodigo + Texto[IFor]
  end;
  Result:=StrCodigo;
end;

function CheckDigito(Codigo: String): Boolean;
var
  StrCorpo : String;
  StrDigito: String;
  StrResult: String;
begin
  Result:=True;
	StrCorpo :=Copy(Codigo,01,Length(Codigo)-01);
  StrDigito:=Copy(Codigo,Length(Codigo),01);
	StrResult:=CalculaDigito(StrCorpo);
  if StrDigito <> StrResult then
    Result:=False;
end;

function CalculaDigito(Codigo: String): String;
var
  StrCorpo    : String;
  DoublePeso  : Double;
  DoubleResult: Double;
  IntDigito   : Integer;
  IFor        : Integer;
begin
  StrCorpo:=LimpaCodigo(Codigo);
	DoublePeso  := Length(StrCorpo) + 01;
  DoubleResult:= 00;
  for IFor := 01 to Length(StrCorpo) do
  begin
    DoubleResult:=DoubleResult+(StrToFloat(Copy(StrCorpo,IFor,01))*DoublePeso);
    DoublePeso  :=DoublePeso - 01;
  end;
  IntDigito:= 11 - (Trunc(DoubleResult) mod 11);
  if IntDigito = 10 then IntDigito := 0;
  if IntDigito = 11 then IntDigito := 1;
	Result:=IntToStr(IntDigito);
end;

function ExtractFileBase(Path: String): String;
var
  Nome   : String;
  Posicao: Integer;
begin
  Nome:=ExtractFileName(Path);
  Posicao:=Pos('.',Nome);
  if (Posicao > 00) then
		Nome:=Copy(Nome,00,Posicao-01);
  Result:=Nome;
end;

function StrTran(const Source, Find, Replace: String): String;
//const
  //tmpStr = '¶';
var
  //Posicao: Integer;
  Retorno: String;
begin
  Retorno := Source.Replace(Find, Replace);
  {
	Retorno := Source;
  ///////////////////////////////////////////////////
	Posicao := Pos(UpperCase(Find), UpperCase(Retorno));
  while (Posicao > 0) do
  begin
    Delete(Retorno, Posicao, Length(Find));
    Insert(tmpStr, Retorno, Posicao);
   	Posicao := Pos(UpperCase(Find), UpperCase(Retorno));
  end;
  ///////////////////////////////////////////////////
	Posicao := Pos(tmpStr, UpperCase(Retorno));
  while (Posicao > 0) do
  begin
    Delete(Retorno, Posicao, Length(tmpStr));
    Insert(Replace, Retorno, Posicao);
   	Posicao := Pos(tmpStr, UpperCase(Retorno));
  end;
  ///////////////////////////////////////////////////
  }
  Result := Retorno;
end;

function MyFileSize(FileName: String): Int64;
var
  iFileHandle: Integer;
begin
  iFileHandle := FileOpen(FileName, fmOpenRead);
  try
    try
      Result := FileSeek(iFileHandle,0,2);
    except
      Result := 0;
    end;
  finally
    FileClose(iFileHandle);
  end;
  {ShowMessage(
    'Arquivo.: ' + FileName + #13 +
    'Tamanho:' + Result.ToString
  );}
end;

procedure EraseFile(Arquivo: String);
var
  F:TextFile;
begin
  AssignFile(F, Arquivo);
  try
    Reset(F);
    CloseFile(F);
    Erase(F);
  except
    on EInOutError do
      MessageDlg('Erro ao Excluir o Arquivo '+Arquivo, mtError, [mbOk], 0);
  end;
end;

function CopyFile(Origem, Destino: String; FalhaExistindo: Boolean = False): Boolean;
begin
  Result := Windows.CopyFile(PChar(Origem), PChar(Destino), FalhaExistindo);
end;

procedure AppendArquivo(Arquivo, Valor: String);
var
  MyFile:TextFile;
begin
  AssignFile(MyFile,Arquivo);
  if FileExists(Arquivo) then
    Append(MyFile)
  else
    Rewrite(MyFile);
  WriteLn(MyFile,Valor);
  Flush(MyFile);
  CloseFile(MyFile);
end;

procedure GravaArquivo(Arquivo, Valor: String);
var
  MyFile:TextFile;
begin
  AssignFile(MyFile,Arquivo);
  Rewrite(MyFile);
  Write(MyFile,Valor);
  CloseFile(MyFile);
end;

function LeArquivo(Arquivo: String): String;
var
  MyFile:TextFile;
  MyStr :String;
begin
  if not FileExists(Arquivo) then
  begin
  	ShowMessage('Arquivo não encontrado '+Arquivo);
    Result:='';Exit;
  end;

  AssignFile(MyFile,Arquivo);
  try
    Reset(MyFile);
	except
  	ShowMessage('Erro ao abrir o arquivo '+Arquivo);
    Result:='';Exit;
  end;

  try
    try
  	  Read(MyFile,MyStr);
    except
			ShowMessage('Erro ao ler o arquivo '+Arquivo);
    end;
  finally
	  CloseFile(MyFile);
  end;
  Result:=MyStr;
end;

function NetFile(NetExt: String): String;
var
  NetNome: String;
  NetPath: String;
  NetTemp: Integer;
begin
	NetPath := 'C:\Temp\';
  if not DirectoryExists(NetPath) then
    ForceDirectories(NetPath);

  //NetNome:=NomeDoUsuario();
  NetNome:=NomeDaMaquina();
  if Length(NetNome)=00 then NetNome:='TEMP';
  NetTemp:=00;
  while FileExists(NetPath+NetNome+ZeraCodigo(IntToStr(NetTemp),05,'0')+'.'+NetExt) do
	  NetTemp:=NetTemp+01;
  Result:=NetPath+NetNome+ZeraCodigo(IntToStr(NetTemp),05,'0')+'.'+NetExt;
end;

function NetArquivo(NetExt: String): String;
var
  NetNome: String;
begin
  //NetNome:=NomeDoUsuario();
  NetNome:=NomeDaMaquina();
  if Length(NetNome)=00 then NetNome:='TEMP';
  Result:=NetNome+Iif(NetExt <> '', '.'+NetExt, '');
end;

function NomeDoUsuario(): String;
const
  TamBuffer = 256;
var
  lnwTam : LongWord;
  bufTemp: array[0..TamBuffer] of char;
  Nome: String;
begin
  lnwTam:=TamBuffer;
  if not GetUserName(bufTemp, lnwTam) then
    bufTemp := '';
  Nome:=StrPas(bufTemp);
  if Length(Nome) > 00 then
		Nome:=UpperCase(Copy(Nome,01,01))+LowerCase(Copy(Nome,02,Length(Nome)-01));
  Result:=Nome;
end;

function GetWordField(Field, Value, Option: String): String;
var
  List: TStringList;
begin
  List:= TStringList.Create;
  Result:=GetWordField(List, Field, Value, Option);
  List.Free;
end;

function GetWordField(var List: TStringList; Field, Value: String; Option: String = 'OR'): String;
var
  I,J,N:Integer;
  ST1:TStringList;
  A1,A2:Integer;
begin
  Result:='';
  Option:= ' ' + Option + ' ';
  Value:=Trim(Value);
  if Value = '' then Exit;
  ST1:=TStringList.Create;
  List:=TStringList.Create;
  ST1.Clear;
  List.Clear;

  if Value[Length(Value)]<>',' then
    Value:=Value+',';

  N:=Pos(',', Value);
  if N > 0 then
  begin
    while N > 0 do
    begin
      ST1.Add(Copy(Value, 1, N - 1));
      Delete(Value, 1, N);
      N:=Pos(',', Value);
    end;
  end;

  for I := 0 to ST1.Count - 1 do
  begin
    N:=Pos('-', ST1[I]);
    if N > 0 then
    begin
      A1:=StrToInt(Copy(ST1[I], 1, N - 1));
      A2:=StrToInt(Copy(ST1[I], N + 1, Length(ST1[I])));
      for J := A1 to A2 do
        List.Add(IntToStr(J));
    end
    else
      List.Add(ST1[I]);
  end;

  if List.Count > 0 then
  begin
    Result:='( ';
    for I := 0 to List.Count - 1 do
      Result:=Result+Field+' Like ''%'+List[I]+'%'''+Iif(I < List.Count - 1, Option, '');
    Result:=Result+' )';
  end;

  ST1.Free;
end;

function NomeDaMaquina(): String;
const
  TamBuffer = 256;
var
  lnwTam : LongWord;
  bufTemp: array[0..TamBuffer] of char;
  Nome: String;
begin
  lnwTam:=TamBuffer;
  if not GetComputerName(bufTemp, lnwTam) then
    bufTemp := '';
  Nome:=StrPas(bufTemp);
  if Length(Nome) > 0 then
		Nome:=UpperCase(Copy(Nome,01,01))+LowerCase(Copy(Nome,02,Length(Nome)-01));
  Result:=Nome;
end;

function TempFile(const Start: String = 'TMP'): String;
var
  bufTemp:  Array[0..256] of Char;
begin
  GetTempFileName(PChar(TempDir()), PChar(Start), 0, bufTemp);
  Result := StrPas(bufTemp);
end;

function Tabula(Texto: String; Tamanho: Integer; Opcao: Posicao):String;
var
  Diferenca:Integer;
begin
  Result:='';

  if Length(Texto) > Tamanho then
  begin
    Result:=Copy(Texto,1,Tamanho);
    Exit;
  end;

  if Length(Texto) = Tamanho then
  begin
    Result:=Texto;
    Exit;
  end;

  Diferenca:=Tamanho-Length(Texto);

  if Opcao=tbEsquerdo then
	  Result:=Texto+Replicate(' ',Diferenca)
  else if Opcao=tbCentro then
		Result:=Replicate(' ',Diferenca div 2)+Texto+
             Replicate(' ',Diferenca div 2)
  else if Opcao=tbDireito then
		Result:=Replicate(' ',Diferenca)+Texto;

  if Length(Result) < Tamanho then
    Result:=Result+' ';

end;

function ZeraCodigo(Codigo:Variant; Tamanho:Integer; Caractere:Char): String;
begin
  ZeraCodigo:=Replicate(Caractere,Tamanho-Length(Trim(Codigo))) + Trim(Codigo);
end;

function StrZero(cStr: Variant; Tamanho:Integer): String;
begin
  Result:=Replicate('0',Tamanho-Length(Trim(cStr))) + Trim(cStr);
end;

function Iif(Valor:Boolean; RetornoT, RetornoF: Variant): Variant;
begin
 if Valor then
   Iif:=RetornoT
 else
   Iif:=RetornoF
end;

function Space(nTam:Integer):String;
begin
  Result:=Replicate(' ',nTam);
end;

function Replicate(cChar:String; nTam:Integer):String;
var
  nPos:Integer;
  cStr:String;
begin
	cStr:='';
	for nPos := 01 to nTam do
	begin
	  cStr:=cStr+cChar;
	end;
	Replicate:=cStr;
end;

function DataExtenso(xData: TDate):String;
begin
	Result:=  FormatDateTime('dddd, d "de" mmmm "de" yyyy ', xData);
end;

function SemanaExtenso(xData: TDate):String;
begin
	Result:=  FormatDateTime('dddd', xData);
end;

function IsDigit(var Texto: String):Boolean;
type
	KeysType = set of Char;
var
  nPos  :Integer;
  Keys  :KeysType;
  MyStr :String;
begin
	Texto:=Trim(Texto);
  MyStr:='';

	for nPos := 01 to Length(Texto) do
    if not (Texto[nPos]='.') then
			MyStr:=MyStr+Texto[nPos];

  Texto:=MyStr;
  Keys :=['0'..'9',',','.'];
	for nPos := 01 to Length(Texto) do
  begin
    if not (Texto[nPos] in Keys) then
    begin
      IsDigit:=False;
      exit;
    end;
  end;
  IsDigit:=True;
end;

function DataValida(Data: String): Boolean;
begin
  Result := True;
  try
    StrToDate(Data);
  except
    Result := False;
  end;
end;

function HoraValida(Hora: String): Boolean;
begin
  Result := True;
  try
    StrToTime(Hora);
  except
    Result := False;
  end;
end;

function DataOk(Dt:String):Boolean;
var
  Dia,Mes: Byte;
  Ano: Integer;
  function AnoBissesto(Year :Integer): boolean ;
  begin
    AnoBissesto:=(ano mod 4=0) and ( ano mod 100 <> 0) or (ano Mod 400 =0);
  end;
begin
  Result := False;
  if Length(Trim(Dt)) = 8 then
  begin
    Dia := StrToIntDef(Copy(Dt,1,2),0);
    Mes := StrToIntDef(Copy(Dt,4,2),0);
    Ano := StrToInt(Copy(Dt,7,2));
    if ( (Mes in [1,3,5,7,8,10,12]) and (Dia in [1..31]) ) or
       ( (Mes in [4,6,9,11]) and (Dia in [1..30]) ) or
       ( (Mes = 2) and ( AnoBissesto(Ano)) and (Dia in [1..29]) ) or
       ( (Mes = 2) and (not AnoBissesto(Ano)) and (Dia in [1..28]) ) then
      Result := True;
  end;
end;

function ChecaData(Text: String): Variant;
begin
	if not DataValida(Text) then
    Result := Null
  else
	  Result:= Text;
end;

{
procedure MyAppExcept(E: Exception);
const
	Bloquado=10241;
  Duplicado=9729;
var
  Erro:EDBEngineError;
begin
  Beep;
  if (E is EDBEngineError) then
  begin
	  Erro:=EDBEngineError(E);
	  if Erro.Errors[00].ErrorCode=Bloquado then
  		ShowMessage('Registro bloqueado por outro usuário !')
    else if Erro.Errors[00].ErrorCode=Duplicado then
		  ShowMessage('Registro duplicado !')
   	else
	  	ShowMessage('Erro: '+Erro.Errors[00].Message+ ' '+IntToStr(Erro.Errors[0].ErrorCode));
  end
  else
    ShowMessage('O seguinte erro ocorreu no aplicativo.'+#13+E.Message);
end;
}
function WindowsDir():String;
var
  WinDir : array[0..144] of char;
begin
  GetWindowsDirectory(Windir,144);
  Result := StrPas(Windir);
end;

function SystemDir():String;
var
  SysDir : Array[0..144] of char;
begin
  GetSystemDirectory(Sysdir,144);
  Result := StrPas(Sysdir);
  if Result[Length(Result)] <> '\' then
    Result := Result + '\';
end;

function TempDir():String;
begin
  Result:='C:\Temp\';
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

function WimTempDir():String;
var
  TmpDir : Array[0..256] of char;
begin
  GetTempPath(256, TmpDir);
  Result := StrPas(TmpDir);
end;

function InternetTempDir():String;
begin
  Result := WimTempDir();
  Result := StrTran(Result, '\Temp', '\Temporary Internet Files');
end;

function DeleteFileWithUndo(sFileName : String): Boolean;
var
  Fos: TSHFileOpStruct;
begin
  FillChar( fos, SizeOF( fos ), 0 );
  with Fos do
  begin
    wFunc := FO_DELETE;
    pFrom := PChar(sFileName);
    fFlags:= FOF_ALLOWUNDO or FOF_NOCONFIRMATION or FOF_SILENT;
  end;
  Result := (0 = ShFileOperation(Fos));
end;

procedure CriarLink(Menu, Param: String);
var
  ExeNome:String;
  Posicao:Integer;
begin
  ExeNome:=ExtractFileName(Application.ExeName);
  Posicao:=Pos('.',ExeNome);
  if (Posicao > 00) then
  begin
		ExeNome:=Copy(ExeNome,00,Posicao-01);
  end;
	ExeNome:=UpperCase(Copy(ExeNome,01,01))+
           LowerCase(Copy(ExeNome,02,Length(ExeNome)));
  CriarAtalho(Application.ExeName, ExeNome, Menu, Param);
end;

procedure CriarAtalho(Path, Nome, Menu, Param: String);
var
  AnObj: IUnknown;
  ShLink: IShellLink;
  PFile: IPersistFile;
  WFileName: WideString;
begin
  //ShowMessage(Path + '-' + Nome + '-' + Menu + '-' + Param);
  // Acesso à interfaces do objeto
  AnObj := CreateComObject (CLSID_ShellLink);
  ShLink := AnObj as IShellLink;
  PFile := AnObj as IPersistFile;
  // Especifica as propriedades do vínculo
  ShLink.SetPath(PChar(Path));
  ShLink.SetArguments(PChar(Param));
  ShLink.SetWorkingDirectory(PChar(ExtractFilePath(Path)));
  // Salva o arquivo, utilizando uma WideString!
  WFileName := WindowsDir + '\'+Menu+'\' + Nome + '.lnk';
  //WFileName := '%HOMEDRIVE%%HOMEPATH%' + '\' + Menu + '\' + Nome + '.lnk';
  PFile.Save(PWChar(WFileName),False);
end;

procedure DeskLink(Nome: String);
var
  AnObj: IUnknown;
  ShLink: IShellLink;
  PFile: IPersistFile;
  WFileName: WideString;
  Registry: TRegistry;
  Iniciar: String;
  AppPath: String;
begin
  AppPath := Application.ExeName;

  // Acesso à interfaces do objeto
  AnObj := CreateComObject (CLSID_ShellLink);
  ShLink := AnObj as IShellLink;
  PFile := AnObj as IPersistFile;
  // Especifica as propriedades do vínculo
  ShLink.SetPath(PChar(AppPath));
  ShLink.SetArguments(nil);
  ShLink.SetWorkingDirectory(PChar(ExtractFilePath(AppPath)));
  // Salva o arquivo, utilizando uma WideString !

  Registry:=TRegistry.Create;
  Registry.RootKey:=HKEY_LOCAL_MACHINE;
  Registry.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False);
  Iniciar:=Registry.ReadString('Common Desktop');
  WFileName := Iniciar + '\' + Nome + '.Lnk';

  PFile.Save(PWChar(WFileName),False);
  Registry.Free;
end;

procedure CriaShortCut(aNome, aFileName: String; aLocation: integer);
var
  IObject : IUnknown;
  ISLink : IShellLink;
  IPFile : IPersistFile;
  PIDL : PItemIDList;
  InFolder : array[0..MAX_PATH] of Char;
  TargetName : String;
  LinkName,s : WideString;
begin
  TargetName := aFileName;

  IObject := CreateComObject(CLSID_ShellLink);
  ISLink := IObject as IShellLink;
  IPFile := IObject as IPersistFile;

  with ISLink do
  begin
    SetPath(pChar(TargetName));
    SetWorkingDirectory(pChar(ExtractFilePath(TargetName)));
  end;

  SHGetSpecialFolderLocation(0, aLocation, PIDL);
  SHGetPathFromIDList(PIDL, InFolder);

  s := InFolder;
  LinkName := s + '\' + aNome + '.LNK';

  //if not FileExists(LinkName) then
    IPFile.Save(PWChar(LinkName), False);
  //else
  //  ShowMessage('Atalho já existe!')

end;

procedure CreateShortcut(FileName, Parameters, InitialDir, ShortcutName,ShortcutFolder : Pchar; Place: TShortcutPlace);
var
  MyObject : IUnknown;
  MySLink : IShellLink;
  MyPFile : IPersistFile;
  Directory : String;
  WFileName : WideString;
  MyReg : TRegIniFile;
begin
  MyObject := CreateComObject(CLSID_ShellLink);
  MySLink := MyObject as IShellLink;
  MyPFile := MyObject as IPersistFile;
  with MySLink do
  begin
    SetArguments(Parameters);
    SetPath(PChar(FileName));
    SetWorkingDirectory(PChar(InitialDir));
  end;
  MyReg := TRegIniFile.Create('Software\MicroSoft\Windows\CurrentVersion\Explorer');
  if Place = stDesktop then
    Directory := MyReg.ReadString ('Shell Folders','Desktop','');
  if Place = stStartMenu then
  begin
    Directory := MyReg.ReadString('Shell Folders', 'Start Menu','') + '\' +ShortcutFolder;
    CreateDir(Directory);
  end;
  WFileName := Directory + '\' + ShortcutName + '.lnk';
  MyPFile.Save (PWChar (WFileName), False);
  MyReg.Free;
end;

function SemAcento(xDad: String): String;
var
  aCento: Array[01..32] of String;
  nFor, nPos: Integer;
  Char1, Char2: Char;
begin
  aCento[01]:='ÃA';
  aCento[02]:='ãa';
  aCento[03]:='ÀA';
  aCento[04]:='àa';
  aCento[05]:='ÁA';
  aCento[06]:='áa';
  aCento[07]:='ÄA';
  aCento[08]:='äa';
  aCento[09]:='ÈE';
  aCento[10]:='èe';
  aCento[11]:='ÉE';
  aCento[12]:='ée';
  aCento[13]:='ÊE';
  aCento[14]:='êe';
  aCento[15]:='ÌI';
  aCento[16]:='ìi';
  aCento[17]:='ÍI';
  aCento[18]:='íi';
  aCento[19]:='ÒO';
  aCento[20]:='òo';
  aCento[21]:='ÓO';
  aCento[22]:='óo';
  aCento[23]:='ÕO';
  aCento[24]:='õo';
  aCento[25]:='ÔO';
  aCento[26]:='ôo';
  aCento[27]:='ÙU';
  aCento[28]:='ùu';
  aCento[29]:='ÚU';
  aCento[30]:='úu';
  aCento[31]:='ÇC';
  aCento[32]:='çc';

  for nFor := 1 to Length( xDad ) do
  begin
    Char1 := xDad[nFor];
    for nPos := Low(aCento) to High(aCento) do
    begin
      Char2 := aCento[nPos][1];
      if Char1 = Char2 then
        xDad[nFor] := aCento[nPos][2];
    end;
  end;

  Result := xDad;
end;

function CalculoDeJuros(xDtv, xDtp: TDate; xVal, xTaxa: Currency): Currency;
var
  nDias : Integer;
  nTaxa : Double;
  nJuro : Double;
  xJuro : Double;
begin
  nDias := Round(xDtp-xDtv);
  nTaxa := xTaxa/30;
  xJuro := 00;

	if nDias > 00 then
  begin
	  while nDias > 00 do
  	begin
	    if nDias >= 30 then
  	  begin
	      nJuro := (xVal*(30*nTaxa))/100;
  	    xVal  := xVal + nJuro;
	      nDias := nDias - 30;
  	  end
	    else
  	  begin
	      nJuro := (xVal*(nDias*nTaxa))/100;
  	    xVal  := xVal + nJuro;
	      nDias := nDias - nDias;
  	  end;
	    xJuro := xJuro + nJuro;
  	end;
	end;
	Result := xJuro;
end;

procedure MsgSound(Som: SndType);
var
  SndArq: String;
begin
  if Som = SndErro then
    SndArq := 'Error.wav'
  else if Som = SndCaixa then
    SndArq := 'Type.wav'
  else if Som = SndAlerta then
    SndArq := 'Whistle.wav'
  else if Som = SndErroCupom then
    SndArq := 'ErrorCupom.wav';

  if not FileExists(ApplicationPath() + SndArq) then
    SndArq := 'Sons\' +  SndArq;

  if FileExists(ApplicationPath() + SndArq) then
    PlaySound(PChar(ApplicationPath() + SndArq), 0, SND_ASYNC)
  else Beep;
end;

function Linha(Memo: TMemo): Integer;
begin
  Result:=SendMessage(
    Memo.Handle,
    EM_LINEFROMCHAR,
    Memo.SelStart, 0);
end;

function Semana(ADate: TDateTime):String;
var
  Days: Array[1..7] of String;
begin
  Days[1] := 'Domingo';
  Days[2] := 'Segunda';
  Days[3] := 'Terça';
  Days[4] := 'Quarta';
  Days[5] := 'Quinta';
  Days[6] := 'Sexta';
  Days[7] := 'Sábado';
  Result:=Days[DayOfWeek(ADate)];
end;

function CheckDrive(Drv: DrvType):Boolean;
var
  x,z:Integer;
  d:String[2];
  c:String[2];
  t:Byte;
  p:String;
begin
  Result := False;
  p:=Application.ExeName;
  case Drv of
    drREMOVABLE: t := DRIVE_REMOVABLE;
    drFIXED    : t := DRIVE_FIXED;
    drREMOTE   : t := DRIVE_REMOTE;
  else
    t := 0;
  end;

  c := Copy(p,1,2);
  for x := 0 to 25 do
  begin
    z := GetDriveType(Pchar(Char(x+65) + ':\'));
    if z = t then
    begin
      d := Char(x+65) + ':';
      if c = d then
      begin
        Result:=True;
        Break;
      end;
    end;
  end;
end;

procedure EscondeBarra(Esconder: Boolean);
var
  wndHandle: THandle;
  wndClass: Array[0..50] of Char;
begin
  StrPCopy(@wndClass[0], 'Shell_TrayWnd');
  wndHandle:=FindWindow(@wndClass[0], nil);
  if Esconder then
    ShowWindow(wndHandle, SW_HIDE)
  else
    ShowWindow(wndHandle, SW_RESTORE);
end;

{--------------------------------------------------------------------------
Utilização:
AutoInicializa(False);      // Inicia o programa no logon do usuário atual
AutoInicializa(True);       // Inicia o programa no logon de todos usuários
AutoInicializa(False,True); // Apaga o programa do logon do usuário atual
AutoInicializa(True,True);  // Apaga o programa do logon de todos usuários
--------------------------------------------------------------------------}
procedure AutoInicializa(const TodosUsuarios: boolean = False; const Apaga: boolean = False);
var
  Registro : TRegistry;
begin
  Registro := TRegistry.create;
  try
    Registro.RootKey:=byte(TodosUsuarios)+$80000001;
    if Registro.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Run',True) then
    begin
      if not Apaga then
        Registro.WriteString(Application.Title,Application.ExeName)
      else Registro.DeleteValue(Application.Title);
    end;
    Registro.CloseKey;
  finally
    Registro.Free;
  end;
end;

{
function DelphiCarregado(): Boolean;
  function JanelaExiste(Classe, Janela: String): Boolean;
  var
    PClasse, PJanela:Array[0..79] of Char;
  begin
    if Classe = '' then
      PClasse[0]:=#0
    else
      StrPCopy(PClasse, Classe);
    if Janela = '' then
      PJanela :=#0
    else
      StrPCopy(PJanela, Janela);
    Result:=(FindWindow(PClasse, PJanela) <> 0);
  end;
begin
  Result:=JanelaExiste('TPropertyInspector','Object Inspector');
end;
}

function DelphiCarregado(): Boolean;
//var
  //StrTemp: String;
begin
  //StrTemp := AplicativosRodando();
  //Result := (Pos('Borland Developer Studio 2006', StrTemp)<>0);
  //Result := (Pos('CodeGear Delphi for Microsoft Windows', StrTemp)<>0);
  Result := FileExists('C:\DelphiCarregado');
end;

function Codifica(Texto : String): String;
var
  Letra : String;
  I     : Integer;
begin
  Letra:='';
  for I:=Length(Texto) downto 1 do
     Letra:=Letra+Texto[I];
  Texto:= '';
  for I:= 1 to Length(Letra) do
    Texto:= Texto + Chr(Ord(Letra[I])+Length(Letra));
  Result:= Texto;
End;

function Decodifica(Texto : String): String;
var
  Letra : String;
  I     : Integer;
Begin
  Letra:='';
  for I:=Length(Texto) downto 1 do
    Letra:=Letra+Texto[I];
  Texto:= '';
  for I:= 1 to Length(Letra) do
    Texto:= Texto + Chr(Ord(Letra[I])-Length(Letra));
  Result:= Texto;
end;

procedure FormatQuery(Qry: TDataSet; const Mask: String = ',##0.00');
var
  I:Integer;
begin
  for I := 1 to Qry.Fields.Count + 1 do
  begin
    if (Qry.Fields.FieldByNumber(I) is TNumericField) then
      if (Qry.Fields.FieldByNumber(I).DataType<>ftSmallint)	and
         (Qry.Fields.FieldByNumber(I).DataType<>ftInteger) then
        (Qry.Fields.FieldByNumber(I) as TNumericField).DisplayFormat:=Mask;
  end;
end;

procedure FormatTable(Tbl: TDataSet; const Mask: String = ',##0.00');
begin
  FormatQuery(Tbl, Mask);
end;

function ApplicationPath(): String;
begin
  Result:=ExtractFilePath(Application.ExeName);
end;

function Captaliza(Texto: String): String;
var
  TempStr:String;
  S:String;
  N:Integer;
  List:TStringList;
begin
  if Trim(Texto)='' then Exit;

  List:=TStringList.Create;
  List.Add('das');
  List.Add('dos');
  List.Add('com');
  List.Add('para');
  List.Add('por');
  List.Add('nao');
  List.Add('não');
  List.Add('sim');

  TempStr:=Trim(CaptalizaAcentos(LowerCase(Texto)));
  TempStr:=StrTran(TempStr,' ','Þ')+'Þ';
  Result:='';

  N:=Pos('Þ',TempStr);
  while N > 0 do
  begin
    S:=Copy(TempStr,1,N-1);
    if Length(S) > 2 then
      if List.IndexOf(S) < 0 then
        S[1]:=UpCase(S[1]);
    Delete(TempStr,1,N);
    N:=Pos('Þ',TempStr);
    Result:=Result+S+' ';
  end;
  Result:=Trim(Result);
  List.Free;
end;

function CaptalizaAcentos(xDad: String): String;
var
  aCento: Array[01..32] of String;
  nFor,nPos:Integer;
  StrTemp1:String;
  StrTemp2:String;
begin
  aCento[01]:='Ãã';
  aCento[03]:='Àà';
  aCento[05]:='Áá';
  aCento[07]:='Ää';
  aCento[09]:='Èè';
  aCento[11]:='Éé';
  aCento[13]:='Êê';
  aCento[15]:='Ìì';
  aCento[17]:='Íí';
  aCento[19]:='Òò';
  aCento[21]:='Óó';
  aCento[23]:='Ôô';
  aCento[25]:='Ùù';
  aCento[27]:='Úú';
  aCento[29]:='Çç';
  aCento[31]:='Ââ';

  for nFor := 01 to High(aCento) do
  begin
    StrTemp1:=Copy(aCento[nFor],01,01);
    nPos:=Pos(StrTemp1,xDad);
    if nPos > 00 then
      StrTemp2:=Copy(aCento[nFor],02,01);
      xDad:=StrTran(xDad,StrTemp1,StrTemp2);
  end;

  Result := xDad;
end;

{
//Ja existe outra...
function Capitaliza(Texto: String): String;
var
  S: String;
begin
  S := Trim(Texto);
  S := UpperCase(Copy(S,1,1)) + LowerCase(Copy(S,2,Length(S)));
  Result := S;
end;
}

function ExtractDiskSerial(Drive: String): String;
var
  Serial: DWord;
  DirLen, Flags: DWord;
  DLabel: Array[0..11] of Char;
begin
  GetVolumeInformation(PChar(Drive+':\'), DLabel, 12, @Serial, DirLen, Flags, Nil, 0);
  Result:=IntToHex(Serial, 8);
  System.Insert('-',Result,05);
end;

function DataVazia(Data: String): Boolean;
begin
	Result:=SoNumero(Data)=''
end;

function SoNumero(Text: String): String;
type
  Digitos = set of Char;
var
  Dig      : Digitos;
  IFor     : Integer;
  StrCodigo:String;
begin
  Dig := ['0'..'9'];
  StrCodigo:='';
	for IFor := 01 to Length(Text) do
  begin
		if Text[IFor] in Dig then
      StrCodigo := StrCodigo + Text[IFor]
  end;
  Result:=StrCodigo;
end;

function SoLetras(Text: String): String;
type
  Digitos = set of Char;
var
  Dig      : Digitos;
  IFor     : Integer;
  StrCodigo:String;
begin
  Dig := ['a'..'z','A'..'Z',' '];
  StrCodigo:='';
	for IFor := 1 to Length(Text) do
  begin
		if Text[IFor] in Dig then
      StrCodigo := StrCodigo + Text[IFor]
  end;
  Result:=StrCodigo;
end;

procedure SetDateTime(Valor: TDateTime);
var
  SystemTime:TSystemTime;
begin
  GetLocalTime(SystemTime);
  with SystemTime do
  begin
    wYear  := StrToInt(FormatDateTime('yyyy',Valor));
    wMonth := StrToInt(FormatDateTime('mm',Valor));
    wDay   := StrToInt(FormatDateTime('dd',Valor));
  end;
  SetLocalTime(SystemTime);
end;

function NumeroControle(): String;
const
  Soma: Integer = 1;
var
  Valor: Integer;
begin
  Valor := StrToIntDef(FormatDateTime('hhnnss', Now), 0);
  Valor := Valor + Soma;
  Result := StrZero(Valor, 6);
  Inc(Soma);
  if Soma >= 40 then Soma := 1;
  Sleep(100);
end;

function GerarControle(): String;
const
  Z:Integer = 0;
var
  //Y,S,X:String;
  //R,V,I,N,P:Integer;
  D:Extended;
  Y:String;
begin
  Sleep(60);
  D:=Sysutils.Time;
  Y:=Trim(FloatToStr(D));
  Y:=Trim(Copy(Y,Pos(',',Y)+1,Length(Y)));
  Y:=Trim(Copy(Y,1,10));
  Result:=StrZero(Y,10);
  //ShowMessage(DateTimeToStr(D));
  //ShowMessage(FloatToStr(D));
  //ShowMessage(FormatDateTime('dd-mm-yyyy hh:nn:ss:zzz', Now()));
  //ShowMessage(FormatDateTime('ddmmyyyyhhnnsszzz', Now()));
  {
  Inc(Z);
  Z:=Iif(Z>999,1,Z);
  Randomize;
  R:=Random(99);
  S:=FormatDateTime('dhnsz',Now);
  S:=S+CharToAsc(ExtractDiskSerial('C'));
  //S:=S+CharToAsc(NomeDaMaquina());
  P:=1;X:='';V:=0;
  for I := 1 to Length(S) do
  begin
    N:=StrToInt(Copy(S,I,1));
    X:=X+FloatToStr(N*P);
    Inc(P);
  end;
  for I := 1 to Length(X) do
  begin
    N:=StrToInt(Copy(X,I,1));
    V:=Abs(V+N+Random(99));
  end;
  V:=StrToInt(IntToStr(V)+IntToStr(Z)+IntToStr(R));
  Result:=StrZero(V,10);
  }
end;

function GerarRegistro(Ctrl: TRegis = ''): String;
begin
  if Trim(Ctrl) = '' then Ctrl := 'XXX';
  Result := Ctrl + FormatDateTime('ddmmyyyyhhnnsszzz', Now());
end;

function CharToAsc(const Value: String): String;
var
  I:Integer;
  S:Char;
begin
  Result:='';
  for I := 1 to Length(Value) do
  begin
    S:=Value[I];
    Result:=Result+IntToStr(Ord(S));
  end;
end;

function DacModulo10(const Value: String): String;
var
  Mult:Integer;
  Total:Integer;
  N:Integer;
  Res:Integer;
begin
	Mult :=(Length(Value) mod 2);
	Mult := Mult+1;
	Total:= 0;
	for N := 1 to Length(Value) do
  begin
		Res := StrToInt(Copy(Value, N, 1)) * Mult;
		if Res > 9 then
			Res := Trunc((Res / 10) + (Res mod 10));
		Total := Total + Res;
		if Mult = 2 then
			Mult := 1
		else
			mult := 2
	end;
	Total := ((10-(Total mod 10)) mod 10 );
	Result := IntToStr(Total);
end;

function LimpaData(Value: String): String;
type
  Digitos = set of Char;
var
  Dig     : Digitos;
  IFor    : Integer;
  StrData :String;
begin
  Dig := ['0'..'9'];
  StrData:='';
	for IFor := 01 to Length(Value) do
  begin
		if Value[IFor] in Dig then
      StrData := StrData + Value[IFor]
  end;
  Result:=StrData;
end;

function MemoLine(Memo: TMemo): Integer;
begin
  Result:=SendMessage(
    Memo.Handle,
    EM_LINEFROMCHAR,
    Memo.SelStart, 0);
end;

function Encriptar(Texto: String): String;
const
  Shift: Integer = 119;
var
  Pos: integer;
begin
  for Pos := 1 to Length(Texto) do
    Texto[Pos] := Chr(Ord(Texto[Pos]) + Shift);
  Result:=Texto;
end;

function Decriptar(Texto: String): String;
const
  Shift: Integer = 119;
var
  Pos: integer;
begin
  for Pos := 1 to Length(Texto) do
    Texto[Pos] := Chr(Ord(Texto[Pos]) - Shift);
  Result:=Texto;
end;

{$R-} {$Q-} {Função de Criptografia de 32 Bits }
function EncryptSTR(const InString:string; StartKey, MultKey, AddKey:Integer): string;
var 
  I : Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(Result[I]) + StartKey) * MultKey + AddKey;
  end;
end;

function DecryptSTR(const InString:string; StartKey, MultKey, AddKey:Integer): string;
var 
  I : Byte;
begin
  Result := '';
  for I := 1 to Length(InString) do
  begin
    Result := Result + CHAR(Byte(InString[I]) xor (StartKey shr 8));
    StartKey := (Byte(InString[I]) + StartKey) * MultKey + AddKey;
  end;
end;
{$R+} {$Q+}

function SerialNumHD(FDrive: String): String;
var
  Serial: DWord;
  DirLen, Flags: DWord;
  DLabel: Array[0..11] of Char;
begin
  try
    GetVolumeInformation(PChar(FDrive + ':\'), dLabel, 12, @Serial, DirLen, Flags, nil, 0);
    Result := IntToHex(Serial, 8);
  except
    Result := '';
  end;
end;

procedure CopiaEstrutura(DS1, DS2: TDataSet);
var
  I: Integer;
  Campo: String;
begin

  DS1.FieldDefs.Update;
  DS2.Close;
  DS2.FieldDefs.Clear;

  for I := 0 to DS1.Fields.Count - 1 do
  begin
    Campo := DS1.Fields[I].FieldName;
    if DS2.FieldDefs.IndexOf(Campo) < 0 then
    begin
      DS2.FieldDefs.Add(
        Campo,
        DS1.Fields[I].DataType,
        DS1.Fields[I].Size,
        DS1.Fields[I].Required
      );
    end;
  end;

end;

procedure CopiaDados(DS1, DS2: TDataSet);
var
  I: Integer;
begin

  DS2.FieldDefs.Update;
  for I := 0 to DS2.FieldDefs.Count - 1 do
  begin
    //if DS2.FieldDefs[I].DataType = ftBCD then
    //  DS2.FieldDefs[I].DataType := ftFloat;
    DS2.Fields[I].FieldKind     := fkData;
    DS2.Fields[I].ReadOnly      := False;
  end;

  DS1.DisableControls;
  DS1.First;
  while not DS1.Eof do
  begin
    DS2.Append;
    for I := 0 to DS1.FieldCount - 1 do
      DS2.Fields[I].Value := DS1.Fields[I].Value;
    DS2.Post;
    DS1.Next;
  end;
  DS1.First;
  DS1.EnableControls;
end;

function TestaCnpj(xCNPJ: String): Boolean;
var
  d1,d4,xx,nCount,fator,resto,digito1,digito2 : Integer;
  Check : String;
begin
  d1 := 0;
  d4 := 0;
  xx := 1;
  for nCount := 1 to Length( xCNPJ )-2 do
  begin
    if Pos( Copy( xCNPJ, nCount, 1 ), '/-.' ) = 0 then
    begin
      if xx < 5 then
      begin
        fator := 6 - xx;
      end
      else
      begin
       fator := 14 - xx;
      end;
    d1 := d1 + StrToInt( Copy( xCNPJ, nCount, 1 ) ) * fator;
    if xx < 6 then
    begin
      fator := 7 - xx;
    end
    else
    begin
      fator := 15 - xx;    end;
      d4 := d4 + StrToInt( Copy( xCNPJ, nCount, 1 ) ) * fator;
      xx := xx+1;
    end;
  end;
  resto := (d1 mod 11);
  if resto < 2 then
  begin
    digito1 := 0;
  end
  else
  begin
    digito1 := 11 - resto;
  end;
  d4 := d4 + 2 * digito1;
  resto := (d4 mod 11);
  if resto < 2 then
  begin
    digito2 := 0;
  end
  else
  begin
    digito2 := 11 - resto;
  end;
  Check := IntToStr(Digito1) + IntToStr(Digito2);
  if Check <> copy(xCNPJ,succ(length(xCNPJ)-2),2) then
  begin
    Result := False;
  end
  else
  begin
    Result := True;
  end;
end;

{
function GetOrder(Text, Find: String): String;
var
  S,Str: String;
  N:Integer;
  List:TStringList;
begin
  List:=TStringList.Create;
  N:=Pos('FROM ', UpperCase(Text));
  if N > 0 then
  begin
    Str:=Copy(Text,1,N-1);
    //ShowMessage(Str);
  end;
  N:=Pos(' ', Trim(Str));
  if N > 0 then
  begin
    Str:=Copy(Str,N+1,Length(Str));
    //ShowMessage(Str);
  end;
  N:=Pos(',', Str);
  while N > 0 do
  begin
    S:=Trim(Copy(Str,1,N-1));
    Delete(Str,1,N);
    if (S <> '') and (Pos('SUM',UpperCase(S))=0) then
      List.Add(S);
    N:=Pos(',', Str);
  end;
  //Str:='';
  Result:='';
  for N := 0 to List.Count - 1 do
  begin
    if Pos(UpperCase(Find),UpperCase(List.Strings[N]))>0 then
    begin
      Result:=List.Strings[N];
      Break;
    end
    //Str:=Str+List.Strings[N]+ #13;
  end;
  //ShowMessage(Str);
  List.Free;
  //ShowMessage(Result);
end;
}

function GetOrder(List: TStringList; Find: String): String;
var
  S: String;
  I,N:Integer;
begin
  Result:='';
  Find:='.'+UpperCase(Find);
  S:=''; N:=0;
  for I := 0 to List.Count - 1 do
  begin
    N := Pos(Find, UpperCase(List[I]));
    if N > 0 then
    begin
      S:=List[I];Break;
    end;
  end;
  if S <> '' then
  begin
    for I := N downto 1 do
      if S[I] = ' ' then Break;
    Result := Copy(S, I, N - I);
    for I := N to Length(S) do
      if S[I] = ' ' then Break;
    Result := Result + Copy(S, N, I - N);
    N := Pos(',', Result);
    if N > 0 then Result[N]:=#32;
  end;
end;

function CtrlD(): Double;
begin
  Result := StrToFloat(CtrlS());
end;

function TempRegistro(): Integer;
begin
  Result := StrToInt(FormatDateTime('hhnnsszzz', SysUtils.Now));
  Sleep(100);
end;

function CtrlS(): String;
const
  Contar: Integer = 0;
var
  S: String;
begin
  if (Contar = 0) or (Contar > 9999) then
  begin
    Randomize();
    Contar := Random(99);
  end
  else
    Inc(Contar);

  S := UpperCase(NomeDaMaquina());
  S := Copy(S, 1, 2) + Copy(S, Length(S)-1, 2);
  S := S + FormatDateTime('yyyymmddhhnnsszzz', SysUtils.Now);
  S := S + StrZero(Contar, 4);
  Result := S;
end;

function BoolToStr(Value: Boolean): String;
begin
	if Value then
    Result:='T'
  else
	  Result:='F';
end;

function StrToBool(Value: String): Boolean;
begin
	if (UpperCase(Value)='T') or (UpperCase(Value)='TRUE')then
    Result:=True
  else
	  Result:=False;
end;

function CheckCombo(Value: TComboBox): String;
begin
  Result := Copy(Trim(Value.Items[Value.ItemIndex]), 1, 1);
end;

function CheckCombo(Value: String): ShortInt;
begin
  try
    Result := StrToInt(Value) - 1;
  except
    Result := -1;
  end;
end;

function DateStr(Value: String): String;
begin
  if DataValida(Value) then
    Result := FormatDateTime('yyyy-mm-dd', StrToDate(Value))
  else
	  Result := '0000-00-00';
end;

function DateStr(Value: TDate): String;
begin
  try
    Result := FormatDateTime('yyyy-mm-dd', Value)
  except
	  Result := '0000-00-00';
  end;
end;

function BollToMyStr(const Value: Boolean): String;
begin
  if Value then Result := 'S'
  else Result := 'N';
end;

function MyStrToBoll(const Value: String): Boolean;
begin
  if UpperCase(Value) = 'S' then Result := True
  else Result := False;
end;

procedure CopyMem(Value: String);
begin
  Clipboard.AsText:=Value;
end;

function Inverte(Value: String): String;
var
  I:Integer;
begin
  Result:='';
  for I := Length(Value) downto 1 do
    Result := Result + Value[I];
end;

function AplicativosRodando(): String;
const
  MAX_WINDOW = 16364;
var
  I      : Integer;
  Caption: Array[0..255]Of Char;
  Lista  : TStringList;
begin
  Lista:=TStringList.Create;
  Lista.Sorted:=True;
  for I:=1 To MAX_WINDOW Do
  begin
    if((GetWindowText(I,Caption,255)<>0) and (GetWindowLong(I,GWL_EXSTYLE)<>0) and
      (GetWindowLong(I,GWL_HWNDPARENT)=0) and (GetWindowLong(I,GWL_HINSTANCE)<>0))then
      if(IsWindowVisible(I)) then
        Lista.Add('V '+IntToStr(I)+'# '+Caption)
      else
        Lista.Add('I '+IntToStr(I)+'# '+Caption);
  end;
  Result:=Lista.Text;
  Lista.Free
end;

function CheckRunning(CloseApp: Boolean = False): Boolean;
var
  RunFile: String;
  RunMsg: String;
begin
  Result := True;
  RunFile:= ApplicationPath() + ExtractFileBase(Application.ExeName) + '.off';
  if CloseApp then
  begin
    RunMsg := Tabula(ExtractFileName(Application.ExeName), 43, tbCentro) + pFIMLIN +
              Tabula(Replicate('-', Length(ExtractFileName(Application.ExeName))), 43, tbCentro) + pFIMLIN +
              '       !!! SISTEMA EM MANUTENÇÃO !!!       ' + pFIMLIN +
              '       -----------------------------       ' + pFIMLIN +
              'NÃO UTILIZE O SISTEMA ATÉ QUE SEJA LIBERADO' + pFIMLIN;
    GravaArquivo(RunFile, RunMsg);Sleep(1000);
  end else
  begin
    if FileExists(RunFile) then
    begin
      RunMsg := LeArquivo(RunFile);
      WinExec(PChar('NOTEPAD.EXE '''+RunFile+''''), SW_SHOW);
      Result := False;
    end;
  end;
end;

function RoundDecimal(const Value: Double; const Decimal: Integer = 2): Double;
var
  strVal: String;
begin
  strVal := FloatToStrF(Value, ffFixed, 18, Decimal);
  Result := StrToFloat(strVal);
end;
{
function TruncateDecimal(const Value: Double; const Decimal: Integer = 2): Double;
var
  strVal: String;
  strInt: String;
  strDec: String;
  intPos: Integer;
begin
  strVal := Format('%15.10f', [Value]);
  intPos := Pos(DecimalSeparator, strVal);
  strInt := Copy(strVal, 1, intPos - 1);
  strDec := Copy(strVal, intPos + 1, Decimal);
  strVal := strInt + DecimalSeparator + strDec;
  try
    Result := StrToFloat(strVal);
  except
    Result := 0;
  end;
end;
}

function DisplayTruncaDecimal(const Value: Double; const Decimal: Integer = 2): String;
var
  strVal: String;
  strInt: String;
  strDec: String;
  intPos: Integer;
begin
  strVal := Format('%15.10f', [Value]);
  intPos := Pos(DecimalSeparator, strVal);
  strInt := Copy(strVal, 1, intPos - 1);
  strDec := Copy(strVal, intPos + 1, Decimal);
  Result := strInt + DecimalSeparator + strDec;
end;

//Esta função funcionou bem...
function DoubleTruncate(const Value: Double; const Decimal: Integer = 2): Double;
var
  dblVal : Double;
  strVal : String;
  intVal : Longint;
  tmpMult: Integer;
  I: Integer;
begin
  tmpMult := 1;
  for I := 1 to Decimal do
    tmpMult := tmpMult * 10;

  dblVal := Value * tmpMult;
  strVal := FormatFloat('#0.0', dblVal);
  dblVal := StrToFloat(strVal);
  intVal := Trunc(dblVal);
  dblVal := intVal / tmpMult;
  Result := dblVal;
end;

{
function TruncateDecimal(const Value: Double; const Decimal: Integer = 2): Double;
var
  tmpValor: Double;
  tmpMult : Integer;
  I: Integer;
begin
  tmpMult := 1;
  for I := 1 to Decimal do
    tmpMult := tmpMult * 10;

  tmpValor := Value * tmpMult;
  //Mistéééériooo...
  tmpValor := tmpValor; //+ 0.01;
  tmpValor := Trunc(tmpValor);
  tmpValor := tmpValor / tmpMult;
  Result := tmpValor;

end;
}
function RoundValue(Value: Extended; Decimals: Integer = 2): Extended;
var
  Factor, Fraction: Extended;
begin
  Factor := IntPower(10, Decimals);
  Value := StrToFloat(FloatToStr(Value * Factor));
  Result := Int(Value);
  Fraction := Frac(Value);
  if Fraction >= 0.5 then
    Result := Result + 1
  else if Fraction <= -0.5 then
    Result := Result - 1;
  Result := Result / Factor;
end;

function DivideValor(const Valor1, Valor2: Currency; const Trunca: Boolean = True; Decimal: Integer = 2): Currency;
begin
  Result := 0;
  //if Valor2 = 0 then
  //  raise Exception.Create('@Erro de divisao por zero!');
  if Valor2 <> 0 then
  begin
    if Trunca then
      //Result := TruncateDecimal(Valor1 / Valor2, Decimal)
      Result := DoubleTruncate(Valor1 / Valor2, Decimal)
    else
      Result := RoundValue(Valor1 / Valor2, Decimal);
  end;
end;

function FormataDecimal(Valor: Double; Decimal: Integer = 2): Double;
begin
  try
    Result:=StrToFloat(FormatFloat('#0.'+Replicate('0',Decimal),Valor));
  except
    Result:=Valor;
  end;
end;

function FloatValor(Valor: String): Double;
var
  StrTemp: String;
  //DblTemp: Double;
begin
  StrTemp:= StrTran(Valor, ThousandSeparator, '');
  Result := StrToFloatDef(StrTemp, 0);
  {
  try
    StrTemp := StrTran(Valor, '.', '');
    DblTemp := StrToFloat(StrTemp);
  except
    raise Exception.Create('O valor passado não é válido para ponto flutuante. ['+Valor+']');
  end;
  Result := DblTemp;
  }
end;

function AsFloat(Valor: String): Double;
var
  StrTemp: String;
begin
  StrTemp:= StrTran(Valor, ThousandSeparator, '');
  Result := StrToFloatDef(StrTemp, 0);
  {
  try
    StrTemp:= StrTran(Valor, '.', '');
    Result := StrToFloat(StrTemp);
  except
    Result := 0;
  end;
  }
end;

function AsInteger(Valor: String): Integer;
begin
  Result := StrToIntDef(Valor, 0);
  {
  try
    Result := StrToInt(Valor);
  except
    Result := 0;
  end;
  }
end;

function TxtToFloat(Valor: String; Decimal: Integer = 2): Double;
var
  StrTemp: String;
  Index: Integer;
begin
  Result := 0;
  if Decimal > 0 then
  begin
    StrTemp := SoNumero(Trim(Valor));
    Index   := Length(StrTemp) - Decimal + 1;
    Insert(',', StrTemp, Index);
    try
      Result := StrToFloat(StrTemp);
    except
      Result := 0;
    end;
  end;
end;

function CheckForm(Form: TForm): Boolean;
var
  HWnd: THandle;
  Name: String;
begin
  Result := False;
  if not Assigned(Form) then Exit;
  Name  := Form.ClassName;
  HWnd  := FindWindow(PChar(Name), PChar(Form.Caption));
  Result:= (HWnd <> 0);
end;

procedure SetCursor(NewCursor: TCursor = crNo);
const
  OldCursor: TCursor = crDefault;
begin
  if NewCursor <> crNo then
  begin
    OldCursor:=Screen.Cursor;
    Screen.Cursor:=NewCursor;
  end
  else
    Screen.Cursor:=OldCursor;
end;

procedure ListaArquivos(Filter, Folder: String; Recurse: Boolean; FileList: TStringList);
var
  sr: TSearchRec;
  sDirList: TStringList;
  i: Integer;
begin
  Folder := IncludeTrailingPathDelimiter(Folder);

  if FindFirst (Folder + Filter, faAnyFile, sr) = 0 then
  repeat
    if (sr.Name <> '.') and (sr.Name <> '..') then
      FileList.Add(Folder + sr.Name);
  until FindNext(sr) <> 0;
  FindClose(sr);
  if Recurse then
  begin
    sDirList := TStringList.Create;
    try
      GetSubDirs(Folder, sDirList);
      for i := 0 to sDirList.Count - 1 do
        if (sDirList[i] <> '.') and (sDirList[i] <> '..') then
        begin
          ListaArquivos(Filter, Folder + sDirList[i], Recurse, FileList);
        end;
    finally
      sDirList.Free;
    end;
  end;

end;

procedure GetSubDirs(Folder: string; sList: TStringList);
var
  sr: TSearchRec;
begin
  if FindFirst (Folder + '*.*', faDirectory, sr) = 0 then
  try
    repeat
      if (sr.Attr and faDirectory) = faDirectory then
        sList.Add (sr.Name);
    until FindNext(sr) <> 0;
  finally
    FindClose(sr);
  end;
end;

procedure LimparArquivosTemporarios();
var
  FileList: TStringList;
  Attrib, NewAttrib: Word;
  I,N: Integer;
begin
  //HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders

  FileList := TStringList.Create;
  Screen.Cursor := crHourGlass;
  ListaArquivos('*.*', TempDir(), True, FileList);
  ListaArquivos('*.*', WimTempDir(), True, FileList);
  ListaArquivos('*.*', InternetTempDir(), True, FileList);
  ListaArquivos('*.*', WindowsDir() + '\Temp\', True, FileList);

  for N := 1 to 4 do {Executa 4 vezes}
  begin
    for I := 0 to FileList.Count -1 do
    begin
      if FileExists(FileList[I]) or DirectoryExists(FileList[I]) then
      begin
        Attrib := FileGetAttr(FileList[I]);
        NewAttrib := Attrib;
        if (Attrib and FILE_ATTRIBUTE_READONLY) = FILE_ATTRIBUTE_READONLY then
          NewAttrib := NewAttrib and not FILE_ATTRIBUTE_READONLY;
        if (Attrib and FILE_ATTRIBUTE_HIDDEN) = FILE_ATTRIBUTE_HIDDEN then
          NewAttrib := NewAttrib and not FILE_ATTRIBUTE_HIDDEN;
        if (Attrib and FILE_ATTRIBUTE_SYSTEM) = FILE_ATTRIBUTE_SYSTEM then
          NewAttrib := NewAttrib and not FILE_ATTRIBUTE_SYSTEM;
        FileSetAttr(FileList[I], NewAttrib);
        if (Attrib and FILE_ATTRIBUTE_DIRECTORY) = FILE_ATTRIBUTE_DIRECTORY then
          RemoveDir(FileList[I])
        else
          DeleteFile(FileList[I]);
      end;
    end;
    Sleep(100);
  end;
  Screen.Cursor := crDefault;
  FileList.Free;
end;

function FeriadosMoveis(Ano: Integer; V: Integer): TDateTime;
var
  n1, n2, n3, n4 ,n5, n6, n7, n8: integer;
  n9, n10,n11, n12, mes, dia: integer;
begin
  result := VarEmpty;
  n1 :=ano mod 19 ;
  n2 := ano div 100;
  n3 := ano mod 100;
  n4 := n2 div 4;
  n5 := n2 mod 4;
  n6 := (n2 + 8) div 25;
  n7 := (n2 - n6 + 1) div 3;
  n8 := (19 * n1 + n2 - n4 - n7 + 15) mod 30;
  n9 := n3 div 4;
  n10:= n3 mod 4;
  n11:= (32 + 2 * n5 + 2 * n9 - n8 - n10) mod 7;
  n12:= (n1 + 11 * n8 + 22 * n11) div 451;
  mes:= (n8 + n11 - 7 * n12 + 114) div 31;
  dia:= (n8 + n11 - 7 * n12 + 114) mod 31;
  if v = 1 then //Carnaval
    result := encodedate(ano,mes,dia + 1)-47;
  if v = 2 then //Sexta-feira Santa
    result:= encodedate(ano,mes,(dia -1));
  if v = 3 then //PÁSCOA
    result:=encodedate(ano,mes,(dia + 1));
  if v = 4 then //Corpus Crist
    result:= encodedate(ano,mes,dia + 1)+60;
end;

function PadL(Text: String; Len: Integer): String;
begin
  Result := Text + Space(Len - Length(Text));
  if Length(Result) > Len then
    Result := Copy(Result, 1, Len);
end;

function PadR(Text: String; Len: Integer): String;
begin
  Result := Space(Len - Length(Text)) + Text;
  if Length(Result) > Len then
    Result := Copy(Result, 1, Len);
end;

function PadC(Text: String; Len: Integer): String;
begin
  Result := Space(Len div 2 - Length(Text) div 2) + Text + Space(Len div 2 - Length(Text) div 2);
  if Length(Result) > Len then
    Result := Copy(Result, 1, Len);
end;

function DateTimeStr(): String;
begin
  Result := FormatDateTime('yyyy-mm-dd_hh-nn-ss', Now);
end;

function GetOSInfo(): String;
var
  Platforma: String;
  BuildNumber: Integer;
begin
  case Win32Platform of
    VER_PLATFORM_WIN32_WINDOWS:
      begin
        BuildNumber := Win32BuildNumber and $0000FFFF;
        Platforma := 'Windows '+Iif(BuildNumber>=1998,'98','95');
      end;
    VER_PLATFORM_WIN32_NT:
      begin
        BuildNumber := Win32BuildNumber;
        Platforma := 'Windows NT';
      end;
      else
      begin
        Platforma := 'Windows';
        BuildNumber := 0;
      end;
  end;
  if (Win32Platform = VER_PLATFORM_WIN32_WINDOWS) or
    (Win32Platform = VER_PLATFORM_WIN32_NT) then
  begin
    if Trim(Win32CSDVersion) = '' then
      Result := Format('%s %d.%d (Build %d)', [Platforma, Win32MajorVersion,
        Win32MinorVersion, BuildNumber])
    else
      Result := Format('%s %d.%d (Build %d: %s)', [Platforma, Win32MajorVersion,
        Win32MinorVersion, BuildNumber, Win32CSDVersion]);
  end
  else
    Result := Format('%s %d.%d', [Platforma, Win32MajorVersion,
      Win32MinorVersion])
end;

function GetLocalIP(): String;
type
  TaPInAddr = Array [0..10] of PInAddr;
  PaPInAddr = ^TaPInAddr;
var
  phe : PHostEnt;
  pptr : PaPInAddr;
  Buffer : Array [0..63] of Char;
  I : Integer;
  GInitData : TWSADATA;
begin
  WSAStartup($101, GInitData);
  Result := '';
  GetHostName(Buffer, SizeOf(Buffer));
  phe := GetHostByName(buffer);
  if phe = nil then Exit;

  pptr := PaPInAddr(Phe^.h_addr_list);
  I := 0;
  while pptr^[I] <> nil do
  begin
    Result := StrPas(inet_ntoa(pptr^[I]^));
    Inc(I);
  end;
  WSACleanup;
end;

function GetIP(): String;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name: String;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := GetHostByName(PChar(Name));
  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d',
      [Byte(h_addr^[0]),Byte(h_addr^[1]),
      Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;
  WSACleanup;
end;

function StrIsNumber(const S: String): Boolean;

function CharIsNum(const C: Char): Boolean;
begin
  Result := ( C in ['0'..'9'] ) ;
end ;

var
  A : Integer ;
begin
  Result := True ;
  A      := 1 ;
  while Result and ( A <= Length( S ) )  do
  begin
     Result := CharIsNum( S[A] ) ;
     Inc(A) ;
  end;
end ;

function ToUpper(Text: String): String;
const
  LW = 'áâãàéêíóôõúüûçñ';
  UP = 'ÁÂÃÀÉÊÍÓÔÕÚÜÛÇÑ';
var
  Ind: Integer;
begin
  Result := '';
  for Ind := 1 to Length(Text) do
    if Pos(Copy(Text, Ind, 1), LW) > 0 then
      Result := Result + Copy(UP, Pos(Copy(Text, Ind, 1), LW), 1)
    else
      Result := Result + UpperCase(Copy(Text, Ind, 1));
end;

function ToLower(Text: String): String;
const
  LW = 'áâãàéêíóôõúüûçñ';
  UP = 'ÁÂÃÀÉÊÍÓÔÕÚÜÛÇÑ';
var
  Ind: Integer;
begin
  Result := '';
  for Ind := 1 to Length(Text) do
    if Pos(Copy(Text, Ind, 1), UP) > 0 then
      Result := Result + Copy(LW, Pos(Copy(Text, Ind, 1), UP), 1)
    else
      Result := Result + LowerCase(Copy(Text, Ind, 1));
end;

function NewID(): Double;
begin
  Result := Now;
  while Result = Now do;
end;

function IndexOffCol(Columns: TDBGridColumns; FieldName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Columns.Count - 1 do
  begin
    if UpperCase(Columns[I].FieldName) = UpperCase(FieldName) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function IndexOffFil(Fields: TFields; FieldName: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Fields.Count - 1 do
  begin
    if UpperCase(Fields[I].FieldName) = UpperCase(FieldName) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function AscToString(AString: String): String;
var
  A: Integer;
  Token: String;
  C: Char;
begin
  A      := 1;
  Token  := '';
  Result := '';
  while A <= length( AString ) + 1 do
  begin
     if A > length( AString ) then
        C := ','
     else
        C := AString[A];

     if (C = ',') and (Length( Token ) > 1) then
      begin
        if Token[1] = '#' then
        try
           Token := chr( StrToInt( copy(Token,2,length(Token)) ) );
        except
        end;

        Result := Result + Token;
        Token := '';
      end
     else
        Token := Token + C;

     A := A + 1;
  end;
end;

{-------------------------------------------------
Código de Barras 2x5i
Como Usar: CriaCodigo('03213213241',Image1.Canvas);
--------------------------------------------------}
Procedure CriaCodigo(Cod : String; Imagem : TCanvas);
const
  Digitos: Array['0'..'9'] of String[5] = (
    '00110',
    '10001',
    '01001',
    '11000',
    '00101',
    '10100',
    '01100',
    '00011',
    '10010',
    '01010');
var
  Numero : String;
  Cod1 : Array[1..1000] Of Char;
  Cod2 : Array[1..1000] Of Char;
  Codigo : Array[1..1000] Of Char;
  Digito : String;
  c1,c2 : Integer;
  x,y,z,h : LongInt;
  a,b,c,d : TPoint;
  I : Boolean;
Begin
  Numero := Cod;
  For x := 1 to 1000 Do
  Begin
    Cod1 [x] := #0;
    Cod2 [x] := #0;
    Codigo[x] := #0;
  End;
  c1 := 1;
  c2 := 1;
  x := 1;
  For y := 1 to Length(Numero) div 2 do
  Begin
    Digito := Digitos[Numero[x ]];
    For z := 1 to 5 do
    Begin
      Cod1[c1] := Digito[z];
      Inc(c1);
    End;
    Digito := Digitos[Numero[x+1]];
    For z := 1 to 5 do
    Begin
      Cod2[c2] := Digito[z];
      Inc(c2);
    End;
    Inc(x,2);
  End;
  y := 5;
  Codigo[1] := '0';
  Codigo[2] := '0';
  Codigo[3] := '0';
  Codigo[4] := '0'; { Inicio do Codigo }
  For x := 1 to c1-1 do
  begin
    Codigo[y] := Cod1[x]; Inc(y);
    Codigo[y] := Cod2[x]; Inc(y);
  end;
  Codigo[y] := '1'; Inc(y); { Final do Codigo }
  Codigo[y] := '0'; Inc(y);
  Codigo[y] := '0';
  Imagem.Pen .Width := 1;
  Imagem.Brush.Color := ClWhite;
  Imagem.Pen .Color := ClWhite;
  a.x := 1; a.y := 0;
  b.x := 1; b.y := 79;
  c.x := 2000; c.y := 79;
  d.x := 2000; d.y := 0;
  Imagem.Polygon([a,b,c,d]);
  Imagem.Brush.Color := ClBlack;
  Imagem.Pen .Color := ClBlack;
  x := 0;
  i := True;
  for y:=1 to 1000 do
  begin
    If Codigo[y] <> #0 Then
    Begin
      If Codigo[y] = '0' then
        h := 1
      Else
        h := 3;
      a.x := x; a.y := 0;
      b.x := x; b.y := 79;
      c.x := x+h-1; c.y := 79;
      d.x := x+h-1; d.y := 0;
      If i Then
        Imagem.Polygon([a,b,c,d]);
      i := Not(i);
      x := x + h;
    end;
  end;
end;

function MyExitWindows(RebootParam: Longword): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    tpResult := OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY, TTokenHd);
    if tpResult then
    begin
      tpResult := LookupPrivilegeValue(nil, SE_SHUTDOWN_NAME, TTokenPvg.Privileges[0].Luid);
      TTokenPvg.PrivilegeCount := 1;
      TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      cbtpPrevious := SizeOf(rTTokenPvg);
      pcbtpPreviousRequired := 0;
      if tpResult then
        Windows.AdjustTokenPrivileges(TTokenHd, False, TTokenPvg, cbtpPrevious, rTTokenPvg, pcbtpPreviousRequired);
    end;
  end;
  Result := ExitWindowsEx(RebootParam, 0);
end;

function ExecAndWait(const FileName, Params: String; const WinState: Word): boolean; export;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: String;
begin
  { Coloca o nome do arquivo entre aspas, devido a possibilidade de existir espaços nos nomes longos do Windows 9x }
  CmdLine := '"' + Filename + '" ' + Params;
  FillChar(StartInfo, SizeOf(StartInfo), #0);
  with StartInfo do
  begin
    cb := SizeOf(StartInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WinState;
  end;
  Result := CreateProcess(nil, PChar( String( CmdLine ) ), nil, nil, false, CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil, PChar(ExtractFilePath(Filename)),StartInfo,ProcInfo);
  { Aguarda o encerramento do programa executado }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles utilizados }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

procedure RunCommand(Command: String; Params: String; Wait : Boolean; WindowState : Word); 
var 
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  Executed : Boolean ;
  Path     : PChar ;
  ConnectCommand : PChar;
begin
  ConnectCommand := PChar(Command + ' ' + Params);
  if not Wait then
    WinExec(ConnectCommand, WindowState)
  else
  begin
    Path := PChar(ExtractFilePath(Command)) ;
    if Length(Path) = 0 then
      Path := nil ;
    FillChar(SUInfo, SizeOf(SUInfo), #0);
    with SUInfo do
    begin
      cb          := SizeOf(SUInfo);
      dwFlags     := STARTF_USESHOWWINDOW;
      wShowWindow := WindowState;
    end;

    Executed := CreateProcess(nil, ConnectCommand, nil, nil, false,
                CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                Path, SUInfo, ProcInfo);
    try
      { Aguarda até ser finalizado }
      if Executed then
        WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    finally
      { Libera os Handles }
      CloseHandle(ProcInfo.hProcess);
      CloseHandle(ProcInfo.hThread);
    end;
  end;
end;

procedure AddStrArray(var MyArray: TArray; MyValue: String);
begin
  if not Assigned(MyArray) then
    SetLength(MyArray, 1);

  SetLength(MyArray, High(MyArray) + 1);
  MyArray[High(MyArray)] := MyValue;
end;

function Fracionado(Valor: Currency): Boolean;
begin
  Result := (Valor - Trunc(Valor)) > 0;
end;

function ChecaDiferenca(Valor1, Valor2: Currency; Diferenca: Currency = 0.10): Boolean;
var
  VarTotal1: Double;
  VarTotal2: Double;
  VarDiferenca: Double;
begin

  VarTotal1    := Trunc(Valor1 * 100) / 100;
  VarTotal2    := Trunc(Valor2 * 100) / 100;
  VarDiferenca := Abs(VarTotal1 - VarTotal2);

  Result := (VarDiferenca > Diferenca);

end;
{
function ListarArquivos(const xPath, xMask: String; xSubDir: Boolean): TMyFileList;
var
  SR: TSearchRec;
  fPath: String;
begin
  Result := TMyFileList.Create();
  if FindFirst(xPath + xMask, faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        with Result.NewFile() do
        begin
          //DataHoras := SR.Time;
          DataHoras := MyFileDateTime(xPath + SR.Name);
          Tamanho   := SR.Size;
          Local     := xPath;
          Nome      := SR.Name;
        end;
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;
}
function ListarArquivos(const xPath, xMask: String; xSort: TMyFileSort): TMyFileList;
var
  SR: TSearchRec;
  Idx1, Idx2: Integer;
  fSort: String;
  fFile: String;
  fDesc: Boolean;
  fList: TStringList;
  fSize: Int64;
  fDate: TDateTime;
begin

  fList := TStringList.Create();
  //Folder := IncludeTrailingPathDelimiter(Folder);
  //FindAllFiles(fList, xPath, xMask, True, faDirectory);
  Result := TMyFileList.Create();
  try
    if FindFirst(xPath + xMask, faAnyFile, SR) = 0 then
    begin
      repeat
        if (SR.Attr <> faDirectory) then
        begin
          fFile := xPath + '' + SR.Name;
          fSize := SR.Size;

          //fDate := MyFileTimeToDateTime(SR.FindData.ftCreationTime);
          fDate := MyFileTimeToDateTime(SR.FindData.ftLastAccessTime);
          //fDate := MyFileTimeToDateTime(SR.FindData.ftLastWriteTime);

          if xSort = mfsDate then
          begin
            fSort := FormatDateTime('yyyymmddhhnnss', fDate);
          end else
          if xSort = mfsSize then
          begin
            fSort := FormatFloat('00000000000000', fSize);
          end else
          begin
            fSort := StrZero('0', 14);
          end;
          fList.Add(fSort + '' + fFile);
        end;
      until FindNext(SR) <> 0;
      FindClose(SR);
    end;

    if xSort <> mfsNone then
      fList.Sort();

    Idx2 := 0;
    fDesc :=xSort = mfsDate;
    if fDesc then
      Idx2 := fList.Count-1;

    for Idx1 := 0 to fList.Count-1 do
    begin
      fFile := Copy(fList[Idx2], 15, Length(fList[Idx2]));
      with Result.NewFile() do
      begin
        DataHoras := MyFileDateTime(fFile);
        Tamanho   := MyFileLength(fFile);
        Local     := ExtractFilePath(fFile);
        Nome      := ExtractFileName(fFile);
      end;
      if fDesc then Dec(Idx2) else Inc(Idx2);
    end;

  finally
    FreeAndNil(fList);
  end;
end;

function SetFileDateTime(FileName: string; CreateTime, ModifyTime, AcessTime: TDateTime): Boolean;
  function ConvertToFileTime(DateTime :TDateTime) :PFileTime;
  var
    FileTime :TFileTime;
    LFT: TFileTime;
    LST: TSystemTime;
  begin
    Result := nil;
    if DateTime > 0 then
    begin
      DecodeDate(DateTime, LST.wYear, LST.wMonth, LST.wDay);
      DecodeTime(DateTime, LST.wHour, LST.wMinute, LST.wSecond, LST.wMilliSeconds);
      if SystemTimeToFileTime(LST, LFT) then
        if LocalFileTimeToFileTime(LFT, FileTime) then
        begin
          New(Result);
          Result^ := FileTime;
        end;
    end;
  end;
var
  FileHandle: Integer;
  ftCreateTime,
  ftModifyTime,
  ftAcessTime: PFileTime;
begin
  //Result := False;
  ftCreateTime := ConvertToFileTime(CreateTime);
  ftModifyTime := ConvertToFileTime(ModifyTime);
  ftAcessTime  := ConvertToFileTime(AcessTime);
  FileHandle   := FileOpen(FileName, fmOpenReadWrite or fmShareExclusive);
  try
    Result := SetFileTime(FileHandle, ftCreateTime, ftAcessTime, ftModifyTime);
  finally
    FileClose(FileHandle);
    Dispose(ftCreateTime);
    Dispose(ftAcessTime);
    Dispose(ftModifyTime);
  end;
end;

function MyFileTimeToDateTime(FTime: TFileTime): TDateTime;
var
  STime: TSystemTime;
  LTime: TFileTime;
begin
  FileTimeToLocalFileTime(FTime, LTime);
  FileTimeToSystemTime(LTime, STime);
  Result := SystemTimeToDateTime(STime);
end;

function MyFileDateTime(aFilePath: String): TDateTime;
var
  SR: TSearchRec;
  TmpAttr: String;
begin
  Result := varEmpty;
  TmpAttr := 'X';
  if FindFirst(aFilePath, faAnyFile, SR) = 0 then
  begin
    //SR.FindData.nFileSizeHigh;
    case SR.FindData.dwFileAttributes of
      FILE_ATTRIBUTE_ARCHIVE             : TmpAttr := 'A';
      FILE_ATTRIBUTE_NORMAL              : TmpAttr := 'N';
      FILE_ATTRIBUTE_DIRECTORY           : TmpAttr := 'D';
      FILE_ATTRIBUTE_HIDDEN              : TmpAttr := 'H';
      FILE_ATTRIBUTE_READONLY            : TmpAttr := 'R';
      FILE_ATTRIBUTE_SYSTEM              : TmpAttr := 'S';
      FILE_ATTRIBUTE_TEMPORARY           : TmpAttr := 'T';
      FILE_ATTRIBUTE_SPARSE_FILE         : TmpAttr := 'F';
      FILE_ATTRIBUTE_REPARSE_POINT       : TmpAttr := 'P';
      FILE_ATTRIBUTE_COMPRESSED          : TmpAttr := 'C';
      FILE_ATTRIBUTE_OFFLINE             : TmpAttr := 'O';
      FILE_ATTRIBUTE_NOT_CONTENT_INDEXED : TmpAttr := 'I';
      FILE_ATTRIBUTE_ENCRYPTED           : TmpAttr := 'E';
      FILE_ATTRIBUTE_VIRTUAL             : TmpAttr := 'V';
    end;

    //Result := MyFileTimeToDateTime(SR.FindData.ftCreationTime);
    Result := MyFileTimeToDateTime(SR.FindData.ftLastAccessTime);
    //Result := MyFileTimeToDateTime(SR.FindData.ftLastWriteTime);

  end else
    ShowMessage('MyFileDateTime() => Arquivo não encontrado!');
  FindClose(SR);
end;

function MyFileLength(aFilePath: String): Int64;
var
  SR: TSearchRec;
begin
  Result := 0;
  if FindFirst(aFilePath, faAnyFile, SR) = 0 then
    Result := SR.Size
  else
    ShowMessage('MyFileLength() => Arquivo não encontrado!');
  FindClose(SR);
end;

function HtmlContentType(FileName: String): String;
var
  TmpExt: String;
begin
  Result := '';
  TmpExt := UpperCase(ExtractFileExt(FileName));

  if TmpExt.Equals('.ZIP') then
    Result := 'application/zip'
  else if TmpExt.Equals('.7Z') then
    Result := 'application/x-7z-compressed'
  else if TmpExt.Equals('.APK') then
    Result := 'application/vnd.android.package-archive';
end;

function LinhaSimples(nLen: Integer): String;
begin
  Result := Replicate('-', nLen);
end;

function FileFormatStr(FileName: String): String;
var
  TmpSize: Int64;
begin
  TmpSize := MyFileLength(FileName);
  Result := FileSizeFormatStr(TmpSize);
end;

function FileSizeFormatStr(xFileSize: Double): String;
begin
  Result := '';

  if xFileSize >= 1024000000000 then
  begin
    xFileSize := xFileSize / 1024000000000;
    Result := FormatFloat(',##0.000', xFileSize) + ' TB';
  end else
  if xFileSize >= 1024000000 then
  begin
    xFileSize := xFileSize / 1024000000;
    Result := FormatFloat(',##0.000', xFileSize) + ' GB';
  end else
  if xFileSize >= 1024000 then
  begin
    xFileSize := xFileSize / 1024000;
    Result := FormatFloat(',##0.000', xFileSize) + ' MB';
  end else
  if xFileSize >= 1024 then
  begin
    xFileSize := xFileSize / 1024;
    Result := FormatFloat(',##0.000', xFileSize) + ' KB';
  end else
  begin
    Result := FloatToStr(xFileSize) + ' Bytes';
  end;

end;

function NavegadorPadrao(): String;
var
  Viewer: THTMLBrowserHelpViewer;
  BrowserPath, BrowserParams: String;
  p: LongInt;
  URL: String;
  BrowserProcess: TProcessUTF8;
begin
  Viewer := THTMLBrowserHelpViewer.Create(nil);
  try
    Viewer.FindDefaultBrowser(BrowserPath, BrowserParams);
    Result := BrowserPath;
    URL:='http://www.lazarus.freepascal.org';
    p:=System.Pos('%s', BrowserParams);
    System.Delete(BrowserParams,p,2);
    System.Insert(URL,BrowserParams,p);
    // start browser
    BrowserProcess := TProcessUTF8.Create(nil);
    try
      BrowserProcess.CommandLine:=BrowserPath + '.exe ' + BrowserParams;
      BrowserProcess.Execute;
    finally
      BrowserProcess.Free;
    end;
  finally
    Viewer.Free;
  end;
end;

procedure ShellExecute(FileName: String);
var
  AProcess: TProcess;
begin
  // Agora nós criaremos o objeto TProcess, e
  // associamos ele à variável AProcess.
  AProcess := TProcess.Create(nil);

  // Mostraremos ao novo AProcess qual é o comando para ele executar.
  // Vamos usar o Compilador FreePascal
  AProcess.CommandLine := FileName;

  // Nós definiremos uma opção para onde o programa
  // é executado. Esta opção verificará que nosso programa
  // não continue enquanto o programa que nós executamos
  // não pare de executar.               vvvvvvvvvvvvvv
  //AProcess.Options := AProcess.Options + [poWaitOnExit];

  // Agora que AProcess sabe qual é a linha de comando
  // nós executaremos ele.
  AProcess.Execute;

  // Esta parte não é alcançada enquanto ppc386 não parar a execução.
  AProcess.Free;
end;

procedure CompactarArquivo(xFileIn, xFileOut: String);
var
  FZipper: TZipper;
  SL: TStringList;
begin
  FZipper := TZipper.Create();
  SL := TStringList.Create();
  try
    SL.Add(xFileIn);
    FZipper.ZipFiles(xFileOut, SL);
  finally
    FZipper.Free;
    SL.Free;
  end;
end;

procedure DescompactarArquivo(xFileIn, xPathOut: String);
var
  FUnZipper: TUnZipper;
begin
  FUnZipper := TUnZipper.Create();
  try
    FUnZipper.FileName := xFileIn;
    FUnZipper.OutputPath := xPathOut;
    FUnZipper.UnZipAllFiles();
  finally
    FUnZipper.Free;
  end;
end;

initialization
  TwoDigitYearCenturyWindow := 80;

finalization

end.

