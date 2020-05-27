unit UInicial;

{$mode objfpc}{$H+}
{$codepage UTF8}
{$define TrayIcon}
//{$define NotBackup}

interface

uses
  Windows, Classes, SysUtils, FileUtil, RTTICtrls, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, IniFiles, LCLType, MaskEdit, Buttons, ComCtrls,
  EditBtn, Menus, BCRadialProgressBar, UFbackup, UWebServer, MMSystem, ShlObj,
  ActiveX, ComObj, IdHTTPServer, IdCustomHTTPServer, IdContext, LCLIntf,
  LMessages, UConst, IdCustomTCPServer, IdComponent, UZipFile;

type

  TStartMenuFolder = (sfDesktop, sfStartup);
  TWebState = (wsNone, wsActive, wsInactive);

  { TFrmInicial }

  TFrmInicial = class(TForm)
    BtnDownload: TSpeedButton;
    HTTPServer: TIdHTTPServer;
    Label2: TLabel;
    LblStatus2: TLabel;
    LblStatus1: TLabel;
    MnuIniciar: TMenuItem;
    MnuZipar: TMenuItem;
    MnuExcluir: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    OpenDialog1: TOpenDialog;
    PopupMenu1: TPopupMenu;
    PopupMenu2: TPopupMenu;
    ProgressBar: TBCRadialProgressBar;
    CbxHorarios: TComboBox;
    CbxOrigem: TComboBox;
    EditDestino: TLabeledEdit;
    EditMascara: TLabeledEdit;
    Label1: TLabel;
    EditHorarios: TMaskEdit;
    MemAvisos: TMemo;
    Panel1: TPanel;
    BtnOrigem: TSpeedButton;
    BtnDestino: TSpeedButton;
    Dialog1: TSelectDirectoryDialog;
    BtnParar: TSpeedButton;
    BtnIniciar: TSpeedButton;
    BtnFechar: TSpeedButton;
    BtnUnZip: TSpeedButton;
    BtnCopiar: TSpeedButton;
    Splitter1: TSplitter;
    StatusBar: TStatusBar;
    TmrBakup: TTimer;
    Timer2: TTimer;
    TmrInicial: TTimer;
    ToolBar1: TToolBar;
    TrayIcon1: TTrayIcon;
    procedure BtnUnZipClick(Sender: TObject);
    procedure BtnCopiarClick(Sender: TObject);
    procedure BtnDestinoClick(Sender: TObject);
    procedure BtnDownloadClick(Sender: TObject);
    procedure BtnFecharClick(Sender: TObject);
    procedure BtnIniciarClick(Sender: TObject);
    procedure BtnOrigemClick(Sender: TObject);
    procedure BtnPararClick(Sender: TObject);
    procedure CbxHorariosCloseUp(Sender: TObject);
    procedure EditHorariosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CbxOrigemKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HTTPServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure StatusBarDblClick(Sender: TObject);
    procedure TmrBakupTimer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TmrInicialTimer(Sender: TObject);
    procedure TrayIcon1Click(Sender: TObject);
  private
    DefFormHeight: Integer;
    Finalizar: Boolean;
    Cancelado: Boolean;
    WebState: TWebState;
    function AppFileName(): String;
    function AppName(): String;
    function AppPath(): String;
    function AppTitle(): String;
    procedure AtivarBackup();
    function CheckCompressFile(xFile: String): Boolean;
    function BackupAtivado(): Boolean;
    function DadosServidor(): String;
    procedure DoZipProgress(Sender: TObject; const Pct: Double);
    procedure GravarLojasIni(xDataBase: String);
    function InitState(): TWebState;

    procedure MyPostMessage(xMsg: Cardinal; WParam: WParam = 0; LParam: LParam = 0);
    function NewState(): TWebState;
    procedure OnMsgActivate(var msg: TLMessage); message LM_MSG_ACTIVATE;
    procedure OnMsgDeactivate(var msg: TLMessage); message LM_MSG_DEACTIVATE;
    procedure OnMsgBackup(var msg: TLMessage); message LM_MSG_BACKUP;

    procedure CreateShortcut(FileName, Parameters, ShortcutName, ShortcutTitle: String; ShortcutFolder: TStartMenuFolder = sfDesktop);
    procedure DeleteShortcut(ShortcutName: String; ShortcutFolder: TStartMenuFolder);
    procedure DesativarBackup();
    procedure DoOutput(Sender: TObject; msg: string; IBAdminAction: string);
    procedure DoWebOutput(Sender: TObject; xMsg: String);
    procedure ShowHint(xMsg: String);
    procedure FirebirdBackup(const FromFile, ToFile: String; out ErMsg: String);
    function BackupFileSize(const FileName: String): LargeInt;
    function DiskFreeSpace(Unidade: PChar): Int64;
    procedure ExecutarBackup(CopiaJa: Boolean);
    procedure Executar(out ErMsg: String);
    function FilesExistInPath(): TStringList; overload;
    function FilesExistInPath(out aFileList: TStringList): Boolean; overload;
    procedure CopyFileWithProgressBar(const FromFile, ToFile: String; out ErMsg: String);
    function ChecarHorario(): Boolean;
    procedure LimparArquivos(); overload;
    procedure LimparArquivos(xMask: String); overload;
    function NewStrTime(): String;
    function ServerName(): String;
    procedure SetFormVisible(Value: Boolean);
    function GetFormVisible(): Boolean;
    procedure SetIniciar();
    procedure SetProgressBar(Value: Boolean; MaxVal: Integer = 100); overload;
    procedure SetProgressBar(Value: Integer); overload;
    procedure GravarConfig();
    procedure LerConfig();
    function StartMenuFolder(MenuFolder: TStartMenuFolder): String;
    procedure TocarSom(FileWav: String);
    procedure ZiparArquivo(const FromFile, ToFile: String; out ErMsg: String);
    procedure UnZiparArquivo(const FromFile, ToPath: String; out ErMsg: String);
    { private declarations }
  public
    { public declarations }
  end;

var
  FrmInicial: TFrmInicial;

implementation

{$R *.lfm}

uses
  Utility;

{ TFrmInicial }

procedure TFrmInicial.FormCreate(Sender: TObject);
begin
  TmrBakup.Enabled := False;
  Timer2.Enabled := False;
  TmrInicial.Enabled := False;
  TrayIcon1.Visible := True;
  Finalizar := False;
  //CopiaJa := False;

  Self.Caption := CntAppFull;
  StatusBar.SimplePanel := True;
  StatusBar.SimpleText := CntAppCopy;
  DefFormHeight := Self.Height;
  //DefFormHeight := Self.Height - ProgressBar.Height;

  CbxHorarios.Clear;
  EditHorarios.Clear;
  CbxOrigem.Clear;
  EditDestino.Clear;
  EditMascara.Clear;
  MemAvisos.Clear;
  LerConfig();

  Panel1.Enabled := True;
  BtnIniciar.Enabled := Panel1.Enabled;
  BtnParar.Enabled := not Panel1.Enabled;
  BtnCopiar.Enabled := True;

  HTTPServer.DefaultPort := 8000;
  HTTPServer.Active := True;
  ShowHint('Servidor: ' + ServerName());
  WebState := wsNone;
  SetProgressBar(False);

  SetIniciar();
  Timer2.Enabled := MnuIniciar.Checked;
  TmrInicial.Enabled := True;
end;

procedure TFrmInicial.FormDestroy(Sender: TObject);
begin
  HTTPServer.Active := False;
end;

procedure TFrmInicial.MyPostMessage(xMsg: Cardinal; WParam: WParam; LParam: LParam);
begin
  LCLIntf.PostMessage(Self.Handle, xMsg, WParam, LParam);
end;

procedure TFrmInicial.OnMsgBackup(var msg: TLMessage);
begin
  ExecutarBackup(True);
end;

procedure TFrmInicial.OnMsgActivate(var msg: TLMessage);
begin
  AtivarBackup();
end;

procedure TFrmInicial.OnMsgDeactivate(var msg: TLMessage);
begin
  DesativarBackup();
end;

procedure TFrmInicial.DoWebOutput(Sender: TObject; xMsg: String);
begin
  ShowHint(xMsg);
end;

procedure TFrmInicial.ShowHint(xMsg: String);
begin
  MemAvisos.Lines.Add(xMsg);
end;

procedure TFrmInicial.LimparArquivos();
begin
  LimparArquivos('*.fbk');
  LimparArquivos('*.fbz');
end;

procedure TFrmInicial.LimparArquivos(xMask: String);
var
  TmpPath: String;
  TmpArq: String;
  TmpIdx: Integer;
  TmpQtd: Integer;
  FileList: TMyFileList;
begin
  TmpQtd := 0;
  TmpPath := IncludeTrailingPathDelimiter(EditDestino.Text);
  FileList := ListarArquivos(TmpPath, xMask, mfsDate);
  for TmpIdx := 10 to FileList.Count - 1 do
  begin
    TmpArq := TmpPath + TMyFile(FileList.Items[TmpIdx]).Nome;
    if FileExists(TmpArq) then
    begin
      DeleteFile(TmpArq);
      Inc(TmpQtd);
    end;
  end;
  ShowHint(TmpQtd.ToString + String(' arquivo(s) de backup "') + xMask + '" excluídos(s).');
end;

function TFrmInicial.ServerName(): String;
begin
  with TWebServer.Create() do
  begin
    Result := ServerName();
    Free;
  end;
end;

function TFrmInicial.InitState(): TWebState;
begin
  if (WebState = wsNone) then
  begin
    if TmrBakup.Enabled then
      WebState := wsInactive
    else
      WebState := wsActive;
  end;
  Result := WebState;
end;

function TFrmInicial.NewState(): TWebState;
begin
  Result := WebState;
  if (WebState = wsActive) then
    WebState := wsInactive
  else
    WebState := wsActive;
end;

procedure TFrmInicial.HTTPServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  TmpCmd: TCommand;
  TmpPrm: String;
  TmpMain: String;
begin
  InitState();
  with TWebServer.Create(AContext, ARequestInfo, AResponseInfo) do
  begin
    Ativado  := (WebState = wsActive);
    DefPath  := EditDestino.Text;
    OnOutput := @DoWebOutput;
    //OnOutput(Self, ARequestInfo.Document);

    TmpMain := '';
    TmpCmd := Command();
    if TmpCmd <> cmdNone then
    begin
      if TmpCmd = cmdBackup then
      begin
        OnOutput(Self, 'Comando de Backup Aceito...');
        MyPostMessage(LM_MSG_BACKUP);
        TmpMain := MainPage();
      end else
      if TmpCmd = cmdSort then
      begin
        OnOutput(Self, 'Comando de Ordenação Aceito...');
        TmpPrm := ARequestInfo.Params.Values['Param2'];
        TmpMain := DownFiles(StrToSort(TmpPrm));
      end else
      if TmpCmd = cmdClear then
      begin
        OnOutput(Self, 'Comando de Limpeza Aceito...');
        LimparArquivos();
        //LimparArquivos('*.fbk');
        //LimparArquivos('*.fbz');
        TmpMain := DownFiles(mfsDate);
      end else
      if TmpCmd = cmdRefresh then
      begin
        OnOutput(Self, 'Comando de Atualização Aceito...');
        TmpMain := DownFiles();
      end else
      if TmpCmd = cmdInfo then
      begin
        OnOutput(Self, 'Comando de Informações Aceito...');
        TmpMain := FormatHtml(DadosServidor());
      end else
      if TmpCmd = cmdOnOff then
      begin
        if Ativado then
        begin
          WebState := wsInactive;
          OnOutput(Self, 'Comando de Desativar Aceito...');
        end else
        begin
          WebState := wsActive;
          OnOutput(Self, 'Comando de Ativar Aceito...');
        end;
        Ativado := (WebState = wsActive);
        if Ativado then
        begin
          MyPostMessage(LM_MSG_DEACTIVATE);
          TmpMain := 'NO';
        end
        else
        begin
          MyPostMessage(LM_MSG_ACTIVATE);
          TmpMain := 'OK';
        end;
      end;
    end else
    begin
      if not Download() then
      begin
        if not ServerDoc() then
        begin
          if TmpMain.IsEmpty then
            TmpMain := MainPage();
          OnOutput(Self, 'Nenhum Comando Recebido...');
        end;
      end;
    end;

    WriteContent(TmpMain);
    {///////////////////////////////////////////////////////////////////////////
    // Não funciona acentuação, Bug...
    AResponseInfo.ResponseNo  := 200;
    AResponseInfo.CharSet     := 'UTF-8';
    AResponseInfo.ContentType := 'text/html; charset=utf-8';
    AResponseInfo.ContentText := TmpMain;
    ///////////////////////////////////////////////////////////////////////////}
  end;
end;

procedure TFrmInicial.MenuItem2Click(Sender: TObject);
begin
  ShowMessage(Self.Caption + #13#10 + StatusBar.SimpleText);
end;

procedure TFrmInicial.MenuItem4Click(Sender: TObject);
begin
  Finalizar := True;
  Self.Close;
end;

procedure TFrmInicial.PopupMenu2Popup(Sender: TObject);
begin
  MnuIniciar.Enabled := Panel1.Enabled;
  MnuExcluir.Enabled := Panel1.Enabled;
  MnuZipar.Enabled := Panel1.Enabled;
end;

function TFrmInicial.AppPath(): String;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function TFrmInicial.AppName(): String;
begin
  Result := ExtractFileName(Application.ExeName);
end;

function TFrmInicial.AppFileName(): String;
begin
  Result := AppPath() + AppName();
end;

function TFrmInicial.AppTitle(): String;
begin
  Result := ExtractFileName(Application.Title);
end;

procedure TFrmInicial.TocarSom(FileWav: String);
var
  TmpFile: String;
  TmpExt: String;
begin
  TmpExt := '';
  if not UpperCase(ExtractFileExt(FileWav)).Contains('WAV') then
    TmpExt := '.wav';
  TmpFile := AppPath() + FileWav + TmpExt;
  if not FileExists(TmpFile) then
    TmpFile := AppPath() + 'sons\' + FileWav + TmpExt;
  if FileExists(TmpFile) then
    PlaySound(PChar(TmpFile), 0, SND_ASYNC);
end;

function TFrmInicial.StartMenuFolder(MenuFolder: TStartMenuFolder): String;
var
  DirStartMenu: String;
  ItemIDList: PItemIDList;
begin
  SetLength(DirStartMenu, MAX_PATH);
  case MenuFolder of
    sfDesktop: SHGetSpecialFolderLocation(Self.Handle, CSIDL_DESKTOPDIRECTORY, ItemIDList);
    sfStartup: SHGetSpecialFolderLocation(Self.Handle, CSIDL_COMMON_STARTUP, ItemIDList);
  end;
  SHGetPathFromIDList(ItemIdList, PChar(DirStartMenu));
  SetLength(DirStartMenu, StrLen(PChar(DirStartMenu)));
  Result := DirStartMenu;
end;

procedure TFrmInicial.DeleteShortcut(ShortcutName: String; ShortcutFolder: TStartMenuFolder);
var
  DirStartMenu: String;
  NomeLnk: String;
begin
  DirStartMenu := StartMenuFolder(ShortcutFolder);
  NomeLnk := DirStartMenu + '\' + ShortcutName + ' - Atalho.lnk';
  if FileExists(NomeLnk) then
    DeleteFile(NomeLnk);
end;

procedure TFrmInicial.CreateShortcut(FileName, Parameters, ShortcutName, ShortcutTitle: String; ShortcutFolder: TStartMenuFolder);
var
  DirStartMenu: String;
  ShellLink: IShellLink;
  PersistFile: IPersistFile;
  NomeLnk: String;
begin
  DirStartMenu := StartMenuFolder(ShortcutFolder);
  NomeLnk := DirStartMenu + '\' + ShortcutName + ' - Atalho.lnk';
  if FileExists(NomeLnk) then Exit;

  ShellLink := CreateComObject(CLSID_ShellLink) as IShellLink;
  PersistFile := ShellLink as IPersistFile;
  with ShellLink do
  begin
    // Informe o título do ícone.
    SetDescription(PChar(ShortcutTitle));
    // Informe o caminho e o arquivo.
    SetPath(PChar(FileName));
    // Argumentos para linha de comando, caso existam.
    SetArguments(PChar(Parameters));
    // Informe o caminho do arquivo.
    SetWorkingDirectory(PChar(ExtractFilePath(FileName)));
  end;
  PersistFile.Save(PWideChar(NomeLnk),False);
end;

procedure TFrmInicial.StatusBarDblClick(Sender: TObject);
//var
  //TmpMsg: String;
begin
  //GravarLojasIni('C:\Work\Dados\Katuxa\KatuxaS.fdb');
  //GravarLojasIni('C:\Work\Dados\Katuxa\KatuxaM.fdb');

  //TocarSom('Backup');
  {with TZipFile.Create() do
  begin
    Comprimir('C:\Temp\CasaRosaV.fdb', 'C:\Temp\CasaRosaV.zip');
    Free;
  end;}
  //ZiparArquivo('C:\Temp\Backup\Gestao_05-11-2019_13-35-51.fbk', 'C:\Temp\Backup\Gestao_05-11-2019_13-35-51.fbz', TmpMsg);
  //UnZiparArquivo('C:\Temp\Backup\Gestao_05-11-2019_13-35-51.fbz', 'C:\Temp\Backup', TmpMsg);

  //ZiparArquivo('C:\Work\Dados\Katuxa\KatuxaS_24-10-2019_22-02-39.fbk', 'C:\Work\Dados\Katuxa\KatuxaS_24-10-2019_22-02-39.fbz', TmpMsg);
  //UnZiparArquivo('C:\Work\Dados\Katuxa\KatuxaS_24-10-2019_22-02-39.fbz', 'C:\Work\Dados\Katuxa', TmpMsg);
  //ZiparArquivo('C:\Work\Dados\Katuxa\KatuxaM_15-10-2019_21-00-00.fbk', 'C:\Work\Dados\Katuxa\KatuxaM_15-10-2019_21-00-00.fbz', TmpMsg);

  //ZiparArquivo('C:\Temp\CasaRosaV.fdb', 'C:\Temp\CasaRosaV.zip', TmpMsg);
  //Application.ProcessMessages;
  //UnZiparArquivo('C:\Temp\CasaRosaV.zip', 'C:\Temp\', TmpMsg);

  //ZiparArquivo('C:\Temp\Gestao.fdb', 'C:\Temp\Gestao.zip', TmpMsg);
  //CopyFileWithProgressBar('C:\Users\Claudio\Downloads\VirtualBox-6.0.4-128413-Win.exe', 'C:\Temp\Backup\VirtualBox-6.0.4-128413-Win.exe', TmpMsg);
  //if not TmpMsg.IsEmpty then
  //  ShowHint(TmpMsg)
end;

function TFrmInicial.NewStrTime(): String;
begin
  Result := FormatDateTime('hh:nn', Now());
end;

procedure TFrmInicial.TmrBakupTimer(Sender: TObject);
begin
  if ChecarHorario() then
    ExecutarBackup(False);
end;

function TFrmInicial.ChecarHorario(): Boolean;
const
  CntHoras: String = '99:99';
var
  TmpHoras: String;
begin
  TmpHoras := NewStrTime();
  Result := ((TmpHoras <> CntHoras) and (CbxHorarios.Items.IndexOf(TmpHoras) >= 0));
  if Result then
    CntHoras := TmpHoras;
end;

procedure TFrmInicial.ExecutarBackup(CopiaJa: Boolean);
var
  TmpAtivo: Boolean;
  TmpVisivel: Boolean;
  TmpHoras: String;
  ErMsg: String;
begin
  TmpAtivo := BackupAtivado();
  if TmpAtivo then
    TmrBakup.Enabled := False;
  TmpVisivel := GetFormVisible();
  if not TmpVisivel then
    SetFormVisible(True);

  BtnCopiar.Enabled := False;
  TmpHoras := NewStrTime();
  Cancelado := False;
  TocarSom('Backup');

  if CopiaJa then
    ShowHint(String('Executando backup às ') + TmpHoras + '...')
  else
    ShowHint('Executando backup programado para ' + TmpHoras + '...');

  Executar(ErMsg);

  if not ErMsg.IsEmpty then
    ShowHint(ErMsg)
  else
  begin
    if Cancelado then
    begin
      if CopiaJa then
        ShowHint(String('Backup cancelado às ') + NewStrTime() + '...')
      else
        ShowHint(String('Backup programado cancelado às ') + NewStrTime() + '!');
    end else
    begin
      if CopiaJa then
        ShowHint(String('Backup comcluído às ') + NewStrTime() + '...')
      else
        ShowHint(String('Backup programado concluído às ') + NewStrTime() + '!');
    end;
  end;

  if MnuExcluir.Checked then
    LimparArquivos();

  BtnCopiar.Enabled := True;
  TocarSom('Concluido');

  if not TmpVisivel then
    SetFormVisible(False);
  if TmpAtivo then
    TmrBakup.Enabled := True;
end;

procedure TFrmInicial.Timer2Timer(Sender: TObject);
begin
  Timer2.Enabled := False;
  if MnuIniciar.Checked then
    BtnIniciarClick(Self);
end;

procedure TFrmInicial.TmrInicialTimer(Sender: TObject);
begin
  TmrInicial.Enabled := False;

end;

procedure TFrmInicial.Executar(out ErMsg: String);
var
  FileList: TStringList;
  TmpFile1: String;
  TmpFile2: String;
  TmpPath2: String;
  Firebird: Boolean;
  Idx: Integer;
begin
  ErMsg := '';
  if FilesExistInPath(FileList) then
  begin
    for Idx := 0 to FileList.Count-1 do
    begin
      TmpFile1 := FileList.ValueFromIndex[Idx];
      TmpFile2 := EditDestino.Text + '\' + ExtractFileName(TmpFile1);
      TmpPath2 := ExtractFilePath(TmpFile2);
      Firebird := UpperCase(ExtractFileExt(TmpFile1)).Contains('FDB');

      if not DirectoryExists(TmpPath2) then
        ForceDirectories(TmpPath2);

      ShowHint('Copiando ' + TmpFile1 + '...');
      if FileExists(TmpFile2) then
        ShowHint('Arquivo de destino já existente!' + #13 + TmpFile2);

      if not Firebird then
      begin
        {$ifndef NotBackup}
        CopyFileWithProgressBar(TmpFile1, TmpFile2, ErMsg);
        if not ErMsg.IsEmpty then ShowHint(ErMsg);
        {$endif}
      end else
      begin
        {$ifndef NotBackup}
        FirebirdBackup(TmpFile1, TmpFile2, ErMsg);
        if not ErMsg.IsEmpty then ShowHint(ErMsg);
        {$endif}
      end;
    end;
  end;
end;

procedure TFrmInicial.SetFormVisible(Value: Boolean);
begin
  if Value then
  begin
    if not GetFormVisible() then Self.Show;
  end else
  begin
    {$ifdef TrayIcon}
    if GetFormVisible() then Self.Hide;
    {$endif}
  end;
end;

function TFrmInicial.GetFormVisible(): Boolean;
begin
  Result := Self.Visible;
end;

procedure TFrmInicial.TrayIcon1Click(Sender: TObject);
begin
  SetFormVisible(True);
end;

function TFrmInicial.FilesExistInPath(): TStringList;
begin
  Result := TStringList.Create();
  FilesExistInPath(Result);
end;

function TFrmInicial.FilesExistInPath(out aFileList: TStringList): Boolean;
var
  Idx, I: Integer;
  fPath: String;
  fMask: String;
  fList: TStringList;
begin
  Result := False;
  aFileList := TStringList.Create();
  fList := TStringList.Create();
  fMask := EditMascara.Text;

  for Idx := 0 to CbxOrigem.Items.Count-1 do
  begin
    fList.Clear;
    fPath := IncludeTrailingPathDelimiter(CbxOrigem.Items[Idx]);
    FindAllFiles(fList, fPath, fMask, True, faDirectory);
    if fList.Count > 0 then
    begin
      Result := True;
      for I := 0 to fList.Count-1 do
        aFileList.Add(FormatDateTime('yyyymmddhhnnss', MyFileDateTime(fList[I])) + '=' + fList[I]);
    end;
  end;

  FreeAndNil(fList);
  aFileList.Sort();

end;

procedure TFrmInicial.SetProgressBar(Value: Boolean; MaxVal: Integer);
begin
  ProgressBar.MaxValue := MaxVal;
  ProgressBar.MinValue := 0;
  ProgressBar.Value := 0;
  ProgressBar.Visible := Value;
  LblStatus1.Visible := Value;
  LblStatus1.Caption := '';
  LblStatus2.Visible := Value;
  LblStatus2.Caption := '';

  if Value then
    Self.Height := DefFormHeight
  else
    Self.Height := DefFormHeight - ProgressBar.Height;

  Application.ProcessMessages;
end;

procedure TFrmInicial.SetProgressBar(Value: Integer);
begin
  ProgressBar.Value := Value;
end;

function TFrmInicial.BackupFileSize(const FileName: String): LargeInt;
var
  TmpFile: File;
begin
  try
    AssignFile(TmpFile, FileName);
    FileMode := fmOpenRead;
    Reset(TmpFile, 1); { Record size = 1 }
    Result := FileSize(TmpFile);
    CloseFile(TmpFile);
  except
    Result := 0;
  end;
end;

function TFrmInicial.DiskFreeSpace(Unidade: PChar): Int64;
var
  FreeAvailable, TotalSpace, TotalFree: ^LargeInt;
begin
  GetDiskFreeSpaceEx(Unidade, @FreeAvailable, @TotalSpace, @TotalFree);
  Result := Int64(@TotalFree);
  //Pointer(Result) := @TotalFree;
  {
  ShowMessage(
    'Espaço Livre: ' + FormatFloat('#,0', LargeInt(TotalFree)) + #13 +
    'Espaço Disponível: ' + FormatFloat('#,0', LargeInt(FreeAvailable)) + #13 +
    'Espaço Total do Disco: ' + FormatFloat('#,0', LargeInt(TotalSpace)));
  }
end;

procedure TFrmInicial.DoOutput(Sender: TObject; msg: string; IBAdminAction: string);
begin
  ShowHint(msg);
  Application.ProcessMessages;
end;

procedure TFrmInicial.DoZipProgress(Sender: TObject; const Pct: Double);
begin
  SetProgressBar(Round(Pct));
  LblStatus2.Caption := 'Progresso ' + FormatFloat(',##0', Pct) + '%...';
  Application.ProcessMessages;
end;

procedure TFrmInicial.ZiparArquivo(const FromFile, ToFile: String; out ErMsg: String);
var
  ZipFile: TZipFile;
  TmpAtivo: Boolean;
begin
  if not FileExists(FromFile) then Exit;
  ShowHint('Compactando ' + FromFile + '...');

  TmpAtivo := BackupAtivado();
  if TmpAtivo then
    TmrBakup.Enabled := False;

  SetProgressBar(True);
  ZipFile := TZipFile.Create();
  ZipFile.OnZipProgress := @DoZipProgress;
  try
    try
      //ZipFile.ZipCompress(FromFile, ToFile);
      ZipFile.ZLibCompress(FromFile, ToFile);
      //ZipFile.ZmaCompress(FromFile, ToFile);
    except
      on E: Exception do
      begin
        ShowHint('Erro ao compactar o arquivo...');
        ShowHint(E.Message);
      end;
    end;
  finally
    FreeAndNil(ZipFile);
    if TmpAtivo then
      TmrBakup.Enabled := True;
    SetProgressBar(False);
  end;
end;

procedure TFrmInicial.UnZiparArquivo(const FromFile, ToPath: String; out ErMsg: String);
var
  ZipFile: TZipFile;
  TmpAtivo: Boolean;
begin
  if not FileExists(FromFile) then Exit;
  ShowHint('Descompactando ' + FromFile + '...');

  TmpAtivo := BackupAtivado();
  if TmpAtivo then
    TmrBakup.Enabled := False;

  SetProgressBar(True);
  ZipFile := TZipFile.Create();
  ZipFile.OnZipProgress := @DoZipProgress;
  try
    try
      //ZipFile.ZipUnCompress(FromFile, ToPath);
      ZipFile.ZLibUnCompress(FromFile, ToPath);
      //ZipFile.ZmaUnCompress(FromFile, ToPath);
    except
      on E: Exception do
      begin
        ShowHint('Erro ao descompactar o arquivo...');
        ShowHint(E.Message);
      end;
    end;
  finally
    FreeAndNil(ZipFile);
    if TmpAtivo then
      TmrBakup.Enabled := True;
    SetProgressBar(False);
  end;
end;

procedure TFrmInicial.FirebirdBackup(const FromFile, ToFile: String; out ErMsg: String);
var
  FBackup: TClassFBackup;
  FZipar: Boolean;
  FromName: String;
  ToName: String;
  FErro: Boolean;
begin
  FErro := False;

  FromName := FromFile;
  ToName   := FormatDateTime('_dd-mm-yyyy_hh-nn-ss."fbk"', Now());
  ToName   := ChangeFileExt(ToFile, ToName);

  //GravarLojasIni(FromFile); Exit;

  FBackup := TClassFBackup.Create();
  FBackup.OnOtput := @DoOutput;
  try
    FBackup.Backup(FromName, ToName);
  except
    on E: Exception do
    begin
      FErro := True;
      ErMsg := E.Message;
    end;
  end;
  FreeAndNil(FBackup);
  if FErro then Exit;
  GravarLojasIni(FromFile);

  FZipar := MnuZipar.Checked and not CheckCompressFile(ToName);
  if FZipar then
  begin
    FromName := ToName;
    ToName   := ChangeFileExt(ToName, '.fbz');
    ZiparArquivo(FromName, ToName, ErMsg);
  end;

end;

procedure TFrmInicial.CopyFileWithProgressBar(const FromFile, ToFile: String; out ErMsg: String);
var
  FromDate: TDateTime;
  FromName: String;
  FromZipar: Boolean;
  TempName: String;
  ToName: String;
  ////////////////////////////////////
  FromF, ToF: File;
  NumRead, NumWritten: Word;
  Buf: Array[1..CntBufLength] of Char;
  FileLength: Int64;
  DiskFree: Int64;
  FileLen: Int64;
  TmpRead: Int64;
  Indice: Double;
  Progres: Integer;
  TmpStr: String;
  Drive: PChar;
begin

  if not FileExists(FromFile) then
  begin
    ErMsg := 'Arquivo de origem "' +  ExtractFileName(FromFile) + '" inexistente!'; Exit;
  end;

  FromName := FromFile;
  ToName   := ToFile;
  FromZipar := MnuZipar.Checked and not CheckCompressFile(FromFile);
  if FromZipar then
  begin
    TempName := TempFile();
    FromDate := MyFileDateTime(FromFile);
    FromName := TempName;
    ToName   := FormatDateTime('_dd-mm-yyyy_hh-nn-ss."zip"', FromDate);
    ToName   := ChangeFileExt(ToFile, ToName);
  end;

  if FileExists(ToName) then
  begin
    ErMsg := 'Arquivo de destino "' +  ExtractFileName(ToName) + String('" já existente!'); Exit;
  end;

  if FromZipar then
    ZiparArquivo(FromFile, TempName, ErMsg);

  //////////////////////////////////////////////////////////////////////////////
  ErMsg := '';
  AssignFile(FromF, FromName);
  FileMode := fmOpenRead;
  Reset(FromF, 1);         { Record size = 1 }
  AssignFile(ToF, ToName); { Open output file }
  Rewrite(ToF, 1);         { Record size = 1 }
  FileLength := FileSize(FromF);
  FileLen := FileLength;
  Indice := 100 / FileLength;

  Drive := PChar(EditDestino.Text);
  DiskFree := DiskFreeSpace(Drive);
  TmpStr := '';

  TmpStr := TmpStr + String('Espaço em Disco...: ') + FormatFloat(',##0', DiskFree) + ' bytes' + #13#10;
  TmpStr := TmpStr + 'Tamanho do Arquivo: ' + FormatFloat(',##0', FileLength) + ' bytes';
  ShowHint(TmpStr);

  Drive := PChar(EditDestino.Text);
  if DiskFree < FileLength then
  begin
    ErMsg := 'Espaço em disco insuficiente para esta operação!'; Exit;
  end;

  TmpRead := 0;
  SetProgressBar(True);
  LblStatus1.Caption := TmpStr;

  while FileLength > 0 do
  begin
    NumRead := 0;
    NumWritten := 0;
    BlockRead(FromF, Buf, SizeOf(Buf), NumRead);
    BlockWrite(ToF, Buf, NumRead, NumWritten);

    FileLength := FileLength - NumRead;
    TmpRead := TmpRead + NumRead;
    Progres := Trunc(TmpRead * Indice);

    LblStatus2.Caption :=
      'Copiados ' + FormatFloat(',##0', TmpRead) + ' bytes de ' + FormatFloat(',##0', FileLen);

    SetProgressBar(Progres);
    Application.ProcessMessages;

    if Cancelado then Break;

  end;

  CloseFile(FromF);
  CloseFile(ToF);

  if FromZipar then
    DeleteFile(TempName);

  if Cancelado then
    DeleteFile(ToFile);

  Sleep(1000);
  SetProgressBar(False);

end;

procedure TFrmInicial.GravarLojasIni(xDataBase: String);
var
  IniFile: TIniFile;
  fLojasIni: String;
  fDataBase: String;
  fChrPos: Integer;
  fSessao: String;
  fIdx: Integer;
begin
  //ShowMessage('DataBase: ' + xDataBase);

  if not FileExists(CntCfgArquivo) then Exit;
  IniFile := TIniFile.Create(CntCfgArquivo);
  fLojasIni := IniFile.ReadString(CntCfgSessao1, 'LojasIni', '');
  FreeAndNil(IniFile);

  if not FileExists(fLojasIni) then Exit;
  IniFile := TIniFile.Create(fLojasIni);

  for fIdx := 1 to 10 do
  begin
    fSessao := 'Loja' + StrZero(fIdx, 2);
    fDataBase := IniFile.ReadString(fSessao, 'DataBase', '');

    fChrPos := Pos(':', fDataBase);
    if fChrPos > 0 then
      fDataBase := Copy(fDataBase, fChrPos + 1 , Length(fDataBase));

    if fDataBase.ToUpper.Equals(xDataBase.ToUpper) then
    begin
      IniFile.WriteDate(fSessao, 'DataBackup', Now());
      ShowHint('Data do Backup Atualizada!');
      Break;
    end;

  end;
  FreeAndNil(IniFile);
end;

procedure TFrmInicial.GravarConfig();
var
  Idx: Integer;
  IniFile: TIniFile;
begin
  IniFile := TIniFile.Create(CntCfgArquivo);
  IniFile.WriteBool(CntCfgSessao1, 'Iniciar', MnuIniciar.Checked);
  IniFile.WriteBool(CntCfgSessao1, 'Excluir', MnuExcluir.Checked);
  IniFile.WriteBool(CntCfgSessao1, 'Compactar', MnuZipar.Checked);
  IniFile.WriteString(CntCfgSessao1, 'Destino', EditDestino.Text);
  IniFile.WriteString(CntCfgSessao1, 'Mascara', EditMascara.Text);

  for Idx := 0 to CbxOrigem.Items.Count -1 do
    IniFile.WriteString(CntCfgSessao1, 'Origem' + IntToStr(Idx+1), CbxOrigem.Items[Idx]);

  for Idx := 0 to CbxHorarios.Items.Count -1 do
    IniFile.WriteString(CntCfgSessao1, 'Horario' + IntToStr(Idx+1), CbxHorarios.Items[Idx]);

  FreeAndNil(IniFile);
end;

procedure TFrmInicial.LerConfig();
var
  Idx: Integer;
  IniFile: TIniFile;
begin
  if not FileExists(CntCfgArquivo) then Exit;

  IniFile := TIniFile.Create(CntCfgArquivo);
  MnuIniciar.Checked := IniFile.ReadBool(CntCfgSessao1, 'Iniciar', False);
  MnuExcluir.Checked := IniFile.ReadBool(CntCfgSessao1, 'Excluir', False);
  MnuZipar.Checked := IniFile.ReadBool(CntCfgSessao1, 'Compactar', False);
  EditDestino.Text := IniFile.ReadString(CntCfgSessao1, 'Destino', '');
  EditMascara.Text := IniFile.ReadString(CntCfgSessao1, 'Mascara', '');
  for Idx := 0 to 9 do
  begin
    if IniFile.ValueExists(CntCfgSessao1, 'Origem' + IntToStr(Idx+1)) then
      CbxOrigem.Items.Add(IniFile.ReadString(CntCfgSessao1, 'Origem' + IntToStr(Idx+1), ''));
  end;
  for Idx := 0 to 9 do
  begin
    if IniFile.ValueExists(CntCfgSessao1, 'Horario' + IntToStr(Idx+1)) then
      CbxHorarios.Items.Add(IniFile.ReadString(CntCfgSessao1, 'Horario' + IntToStr(Idx+1), ''));
  end;
  FreeAndNil(IniFile);

  if CbxOrigem.Items.Count > 0 then
    CbxOrigem.ItemIndex := 0;
  if CbxHorarios.Items.Count > 0 then
  begin
    CbxHorarios.ItemIndex := 0;
    EditHorarios.Text := CbxHorarios.Text;
  end;

end;

function TFrmInicial.CheckCompressFile(xFile: String): Boolean;
const
  CntFilesCompress = '.zip .rar .7z';
begin
  Result := (Pos(UpperCase(ExtractFileExt(xFile)), UpperCase(CntFilesCompress)) > 0);
end;

procedure TFrmInicial.EditHorariosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    if CbxHorarios.Items.IndexOf(EditHorarios.Text) < 0 then
      CbxHorarios.Items.Add(EditHorarios.Text);
  end;
end;

procedure TFrmInicial.CbxOrigemKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_Return then
  begin
    if CbxOrigem.Items.IndexOf(Trim(CbxOrigem.Text)) < 0 then
      CbxOrigem.Items.Add(Trim(CbxOrigem.Text));
  end;
end;

procedure TFrmInicial.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  GravarConfig();
  if Finalizar then
  begin
    TmrBakup.Enabled := False;
  end else
  begin
    {$ifdef TrayIcon}
    CloseAction := caNone;
    SetFormVisible(False);
    {$endif}
  end;
end;

procedure TFrmInicial.CbxHorariosCloseUp(Sender: TObject);
begin
  EditHorarios.Text := CbxHorarios.Text;
end;

procedure TFrmInicial.BtnOrigemClick(Sender: TObject);
begin
  Dialog1.Filter := 'Todos os arquivos|*.*';
  if not Dialog1.Execute then Exit;
  CbxOrigem.Text := Dialog1.FileName;
end;

procedure TFrmInicial.BtnDestinoClick(Sender: TObject);
begin
  Dialog1.Filter := 'Todos os arquivos|*.*';
  if not Dialog1.Execute then Exit;
  EditDestino.Text := Dialog1.FileName;
end;

procedure TFrmInicial.BtnDownloadClick(Sender: TObject);
begin
  OpenURL(ServerName());
end;

procedure TFrmInicial.SetIniciar();
begin
  if MnuIniciar.Checked then
  begin
    //BtnUnZip.Glyph.Assign(Image1.Picture.Bitmap);
    CreateShortCut(AppFileName(), '', AppTitle(), Self.Caption, sfStartup);
 end else
  begin
    //BtnUnZip.Glyph.Assign(Image2.Picture.Bitmap);
    DeleteShortcut(AppTitle(), sfStartup);
  end;
  CreateShortCut(AppFileName(), '', AppTitle(), Self.Caption, sfDesktop);
end;

procedure TFrmInicial.BtnFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmInicial.BtnIniciarClick(Sender: TObject);
begin
  MyPostMessage(LM_MSG_ACTIVATE);
end;

procedure TFrmInicial.BtnPararClick(Sender: TObject);
begin
  MyPostMessage(LM_MSG_DEACTIVATE);
end;

procedure TFrmInicial.BtnCopiarClick(Sender: TObject);
begin
  MyPostMessage(LM_MSG_BACKUP);
end;

procedure TFrmInicial.BtnUnZipClick(Sender: TObject);
var
  TmpMsg: String;
  TmpOrg: String;
  TmpDst: String;
begin
  OpenDialog1.Filter := 'Arquivos de Backup|*.fbz|Todos os arquivos|*.*';
  if not OpenDialog1.Execute then Exit;

  TmpOrg := OpenDialog1.FileName;
  TmpDst := ExtractFilePath(TmpOrg);

  //ShowHint('Origem.: ' + TmpOrg + '...');
  //ShowHint('Destino: ' + TmpDst + '...');

  UnZiparArquivo(TmpOrg, TmpDst, TmpMsg);
end;

function TFrmInicial.BackupAtivado(): Boolean;
begin
  Result := TmrBakup.Enabled;
end;

function TFrmInicial.DadosServidor(): String;
var
  DiskFree: Int64;
  Idx: Integer;
begin
  Result := '';
  with FilesExistInPath() do
  begin
    Sort();
    if Count > 0 then
    begin
      Result := Result + IntToStr(Count) + ' arquivo(s) para backup.' + pFIMLIN;
      for Idx := 0 to Count-1 do
        Result := Result + 'Arquivo' + (Idx+1).ToString + ': ' + ValueFromIndex[Idx] + '...' + pFIMLIN;
    end else
      Result := Result + 'Nenhum arquivo encontrado para backup.' + pFIMLIN;
    Result := Result + LinhaSimples() + pFIMLIN;
    Free;
  end;
  with CbxOrigem.Items do
  begin
    Result := Result + IntToStr(Count) + ' local(is) de origem(ns) para backup.' + pFIMLIN;
    for Idx := 0 to Count-1 do
      Result := Result + 'Origem' + (Idx+1).ToString + ': ' + Strings[Idx] + '...' + pFIMLIN;
    Result := Result + LinhaSimples() + pFIMLIN;
  end;
  with CbxHorarios.Items do
  begin
    Result := Result + IntToStr(Count) + String(' horário(s) programado(s) para backup.') + pFIMLIN;
    for Idx := 0 to Count-1 do
      Result := Result + String('Horário') + (Idx+1).ToString + ': ' + Strings[Idx] + '...' + pFIMLIN;
    Result := Result + LinhaSimples() + pFIMLIN;
  end;

  Result := Result + 'Iniciar automaticamente.: ' + Iif(MnuIniciar.Checked, 'SIM', 'NÃO') + pFIMLIN;
  Result := Result + 'Excluir arquivos antigos: ' + Iif(MnuExcluir.Checked, 'SIM', 'NÃO') + pFIMLIN;
  Result := Result + 'Compactar arquivo final.: ' + Iif(MnuZipar.Checked, 'SIM', 'NÃO') + pFIMLIN;

  DiskFree := DiskFreeSpace(PChar(EditDestino.Text));
  Result := Result + String('Espaço livre em Disco...: ') + FileSizeFormatStr(DiskFree) + pFIMLIN;

end;

procedure TFrmInicial.AtivarBackup();
begin
  MemAvisos.Clear;
  Panel1.Enabled := False;
  BtnIniciar.Enabled := Panel1.Enabled;
  BtnParar.Enabled := not Panel1.Enabled;
  SetFormVisible(False);

  ShowHint(DadosServidor());
  ShowHint('Sistema inicializado em ' + FormatDateTime('dd/mm/yyy', Now()) + String(' às ') + FormatDateTime('hh:nn:ss', Now()) + '...');
  ShowHint('Servidor: ' + ServerName());
  TmrBakup.Enabled := True;

end;

procedure TFrmInicial.DesativarBackup();
begin
  Cancelado := True;
  TmrBakup.Enabled := False;
  Panel1.Enabled := True;
  BtnIniciar.Enabled := Panel1.Enabled;
  BtnParar.Enabled := not Panel1.Enabled;
  ShowHint('Sistema interrompido!');
end;

initialization

end.

