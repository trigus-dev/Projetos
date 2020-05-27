unit UConst;

{$mode objfpc}{$H+}
{$codepage UTF8}

interface

uses
  Forms, Classes, SysUtils, LMessages;

const
  LM_MSG_ACTIVATE    = LM_USER + 1;
  LM_MSG_DEACTIVATE  = LM_USER + 2;
  LM_MSG_BACKUP      = LM_USER + 3;
  //LM_MSG_CLEAR       = LM_USER + 4;

  CntCfgSessao1  = 'Global';
  CntCfgSessao2  = 'Firebird';
  CntCfgArquivo  = 'Config.ini';

  CntBufLength   = 1024 * 4;

  {$ifdef win64}
  CntSOPlatform  = 'Win-64bits';
  {$else}
  CntSOPlatform  = 'Win-32bits';
  {$endif}

  CntAppVersion  = '1.14';
  CntAppName     = 'SISBAPRO';
  CntAppDescr    = 'Sistema de Backup Programado';
  CntAppCopy     = 'Copyright © TRIGU''S Software 2019. All Rights Reserved.';
  CntAppFull     = CntAppName + ' - ' + CntAppDescr + ' - Versão: ' + CntAppVersion + ' - ' + CntSOPlatform;


implementation

end.

