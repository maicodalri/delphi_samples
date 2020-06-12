unit MyUtils.FileTextLog;

interface

uses
  System.SyncObjs, System.SysUtils;

type

  TFileTextLog = class
  class var FCriticalSection: TCriticalSection;
  public
    class constructor ClassCreate;
    class destructor ClassDestroy;
    class procedure SaveLog(const lText: string);
  end;

implementation

{ TFileTextLog }

class constructor TFileTextLog.ClassCreate;
begin
  TFileTextLog.FCriticalSection:= TCriticalSection.Create;
end;

class destructor TFileTextLog.ClassDestroy;
begin
  TFileTextLog.FCriticalSection.Free;
end;

class procedure TFileTextLog.SaveLog(const lText: string);
var
  lFileLogName: string;
  lArquivo: TextFile;
begin
  TFileTextLog.FCriticalSection.Enter;
  try
    lFileLogName:= ChangeFileExt(ParamStr(0), '.log');
    AssignFile(lArquivo, lFileLogName);
    try
      if not FileExists(lFileLogName) then
        Rewrite(lArquivo)
      else
        Append(lArquivo);
      WriteLn(lArquivo, FormatDateTime('dd/mm/yyyy hh:mm:ss:zzz', Now) + ' => ' + lText);
    finally
      CloseFile(lArquivo);
    end;
  finally
    TFileTextLog.FCriticalSection.Release;
  end;
end;

end.
