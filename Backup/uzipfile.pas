unit uzipfile;

{$mode objfpc}{$H+}
{$codepage UTF8}

interface

uses
  Classes, SysUtils, Dialogs, TplZipUnit, TplZlibUnit, TplLzmaUnit; //, zStream, zLib;

type

  { TZipFile }

  TZipFile = class
  private
    FOnZipProgress: TProgressEvent;
    procedure DoZipProgress(Sender: TObject; const Pct: Double);
    procedure DoZLibProgress(Sender: TObject; FileIndex: Integer; FileSize, FilePos: Int64);
    procedure DoUnZLibProgress(Sender: TObject; FileSize, FilePos: Int64);
    function SaveFileCopy(const xFileIn: String): Boolean;
  public
    constructor Create(); overload;
    destructor Destroy();

    procedure ZmaCompress(const xFileIn: String; const xFileOut: String);
    procedure ZmaUnCompress(const xFileIn, xPathOut: String);

    procedure ZLibCompress(const xFileIn: String; const xFileOut: String);
    procedure ZLibUnCompress(const xFileIn, xPathOut: String);

    procedure ZipCompress(const xFileIn: String; const xFileOut: String);
    procedure ZipUnCompress(const xFileIn, xPathOut: String);
  published
    property OnZipProgress: TProgressEvent read FOnZipProgress write FOnZipProgress;
  end;


implementation

constructor TZipFile.Create();
begin
  inherited;
end;

destructor TZipFile.Destroy();
begin

  inherited;
end;

procedure TZipFile.DoZipProgress(Sender: TObject; const Pct: Double);
begin
  if Assigned(FOnZipProgress) then
    FOnZipProgress(Sender, Pct);
end;

procedure TZipFile.DoZLibProgress(Sender: TObject; FileIndex: Integer; FileSize, FilePos: Int64);
begin
  if not Assigned(FOnZipProgress) then Exit;
  if FileSize > 0 then
    FOnZipProgress(Sender, 100 * (FilePos / FileSize))
  else
    FOnZipProgress(Sender, 0);
end;

procedure TZipFile.DoUnZLibProgress(Sender: TObject; FileSize, FilePos: Int64);
begin
  if not Assigned(FOnZipProgress) then Exit;
  if FileSize > 0 then
    FOnZipProgress(Sender, 100 * (FilePos / FileSize))
  else
    FOnZipProgress(Sender, 0);
end;

function TZipFile.SaveFileCopy(const xFileIn: String): Boolean;
var
  fFileOut: String;
  fFileExt: String;
begin
  Result := True;
  if not FileExists(xFileIn) then Exit;

  fFileExt := ExtractFileExt(xFileIn);
  fFileOut := FormatDateTime('_nnsszzz."' + fFileExt + '"', Now());
  fFileOut := ChangeFileExt(xFileIn, fFileOut);
  Result := RenameFile(xFileIn, fFileOut);
end;

procedure TZipFile.ZmaCompress(const xFileIn: String; const xFileOut: String);
var
  FSOut: TfileStream;
  FZipper: TplLzmaCompress;
  FFileOut: String;
begin
  if not FileExists(xFileIn) then Exit;

  FFileOut := xFileOut;
  if FFileOut.IsEmpty then
    FFileOut := ChangeFileExt(xFileIn, '.zip');

  FZipper := TplLzmaCompress.Create(nil);
  FZipper.OnCompress := @DoZLibProgress;

  FSOut := TFileStream.Create(FFileOut, fmCreate);
  FSOut.Position := 0;
  FZipper.OutStream := FSOut;
  FZipper.InputFiles.Clear;
  FZipper.InputFiles.Add(ExpandFileName(SetDirSeparators(xFileIn)));

  try
    FZipper.CreateArchive();
  finally
    FreeAndNil(FSOut);
    FreeAndNil(FZipper);
  end;

end;

procedure TZipFile.ZmaUnCompress(const xFileIn, xPathOut: String);
var
  FUnZipper: TplLzmaUnCompress;
  FSIn, FSOut: TFileStream;
  FTmpName: String;
  FPathOut: String;
  Idx: Integer;
begin
  FPathOut := IncludeTrailingPathDelimiter(xPathOut);

  FSIn := TFileStream.Create(xFileIn, fmOpenRead);
  FSIn.Position := 0;

  FUnZipper := TplLzmaUnCompress.Create(nil);
  FUnZipper.OnExtract := @DoUnZLibProgress;
  FUnZipper.InStream := FSIn;

  try
    if FUnZipper.Count = 0 then Exit;
    FTmpName := ExtractFileName(FUnZipper.FilesInArchive[0].FileName);
    DoUnZLibProgress(Self, 0, 0);

    if not SaveFileCopy(FPathOut + FTmpName) then
    begin
      ShowMessage('O arquivo de destino existe e não foi possível renomea-lo!');
      Exit;
    end;

    try
      FSOut := TFileStream.Create(FPathOut + FTmpName, fmCreate);
      FSOut.Position := 0;
      FUnZipper.ExtractFileToStream(FTmpName, FSOut);
    finally
      FreeAndNil(FSOut);
    end;
  finally
    FreeAndNil(FSIn);
    FreeAndNil(FUnZipper);
  end;
end;

procedure TZipFile.ZLibCompress(const xFileIn: String; const xFileOut: String);
var
  FSOut: TfileStream;
  FZipper: TplZlibCompress;
  FFileOut: String;
begin
  if not FileExists(xFileIn) then Exit;

  FFileOut := xFileOut;
  if FFileOut.IsEmpty then
    FFileOut := ChangeFileExt(xFileIn, '.zip');

  FZipper := TplZlibCompress.Create(nil);
  FZipper.OnCompress := @DoZLibProgress;

  FSOut := TFileStream.Create(FFileOut, fmcreate);
  FSOut.Position := 0;
  FZipper.OutStream := FSOut;
  FZipper.InputFiles.Clear;
  FZipper.InputFiles.Add(ExpandFileName(SetDirSeparators(xFileIn)));

  try
    FZipper.CreateArchive();
  finally
    FreeAndNil(FSOut);
    FreeAndNil(FZipper);
  end;

end;

procedure TZipFile.ZLibUnCompress(const xFileIn, xPathOut: String);
var
  FUnZipper: TplZLibUnCompress;
  FSIn, FSOut: TFileStream;
  FTmpName: String;
  FPathOut: String;
  Idx: Integer;
begin
  FPathOut := IncludeTrailingPathDelimiter(xPathOut);

  FSIn := TFileStream.Create(xFileIn, fmOpenRead);
  FSIn.Position := 0;

  FUnZipper := TplZLibUnCompress.Create(nil);
  FUnZipper.OnExtract := @DoUnZLibProgress;
  FUnZipper.InStream := FSIn;

  try
    if FUnZipper.Count = 0 then Exit;
    FTmpName := ExtractFileName(FUnZipper.FilesInArchive[0].FileName);
    DoUnZLibProgress(Self, 0, 0);

    if not SaveFileCopy(FPathOut + FTmpName) then
    begin
      ShowMessage('O arquivo de destino existe e não foi possível renomea-lo!');
      Exit;
    end;

    try
      FSOut := TFileStream.Create(FPathOut + FTmpName, fmCreate);
      FSOut.Position := 0;
      FUnZipper.ExtractFileToStream(FTmpName, FSOut);
    finally
      FreeAndNil(FSOut);
    end;
  finally
    FreeAndNil(FSIn);
    FreeAndNil(FUnZipper);
  end;

end;

procedure TZipFile.ZipCompress(const xFileIn: String; const xFileOut: String);
var
  FZipper: TplZipCompress;
  ZipFile: TZipFileEntry;
  FFileOut: String;
begin
  if not FileExists(xFileIn) then Exit;

  FFileOut := xFileOut;
  if FFileOut.IsEmpty then
    FFileOut := ChangeFileExt(xFileIn, '.zip');
  FZipper := TplZipCompress.Create(nil);

 FZipper.FileName := FFileOut;
 FZipper.OnProgress := @DoZipProgress;
 ZipFile := FZipper.Entries.AddFileEntry(xFileIn);

 //Set only the file name NOT and the path of file.
 //Define apenas o nome do arquivo e NÃO o caminho do arquivo.
 if ZipFile <> nil then
   ZipFile.ArchiveFileName := ExtractFileName(xFileIn);

 try
   FZipper.ZipAllFiles();
 finally
   FreeAndNil(FZipper);
 end;

end;

procedure TZipFile.ZipUnCompress(const xFileIn, xPathOut: String);
var
  FUnZipper: TplZipUnCompress;
  FTmpName: String;
  FPathOut: String;
begin
  FPathOut := IncludeTrailingPathDelimiter(xPathOut);
  FUnZipper := TplZipUnCompress.Create(nil);
  FUnZipper.OnProgress := @DoZipProgress;
  FUnZipper.FileName := xFileIn;
  FUnZipper.OutputPath := FPathOut;

  try
    if FUnZipper.Entries.Count = 0 then Exit;
    FTmpName := ExtractFileName(FUnZipper.Entries[0].DiskFileName);

    if not SaveFileCopy(FPathOut + FTmpName) then
    begin
      ShowMessage('O arquivo de destino existe e não foi possível renomea-lo!');
      Exit;
    end;

    FUnZipper.UnZipAllFiles();
  finally
    FreeAndNil(FUnZipper);
  end;
end;

end.

