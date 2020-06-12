unit MyUtils.FileTextLog;

interface

uses
  System.SyncObjs, System.SysUtils;

type

  //Class to abstract the method for writing
  // the log to the file
  TFileTextLog = class
  class var FCriticalSection: TCriticalSection;
  public
    class constructor ClassCreate;
    class destructor ClassDestroy;
    class procedure WriteLog(const lText: string);
  end;

implementation

{ TFileTextLog }

class constructor TFileTextLog.ClassCreate;
begin
  //Create a TCriticalSection to use before the application startup
  //Remembering that all class methods occur before the application starts
  TFileTextLog.FCriticalSection:= TCriticalSection.Create;
end;

class destructor TFileTextLog.ClassDestroy;
begin
  //Destroy a TCriticalSection when applications end
  TFileTextLog.FCriticalSection.Free;
end;

class procedure TFileTextLog.WriteLog(const lText: string);
var
  lFileLogName: string;
  lFile: TextFile;
begin
  //Enter in the Critical Section (resource to be protected)
  TFileTextLog.FCriticalSection.Enter;
  
  try //Protected block

    //Set the file name
    lFileLogName:= ChangeFileExt(ParamStr(0), '.log');
    //Assigne the file name to the file
    AssignFile(lFile, lFileLogName);
    try
      if not FileExists(lFileLogName) then  //If not file exist
        Rewrite(lFile) //Then create it
      else
        Append(lFile); //Else only open to add lines

      //Write line into the text file
      WriteLn(lFile,
              FormatDateTime('dd/mm/yyyy hh:mm:ss:zzz', Now) + ' => ' + lText);
    finally
      //Tells the operating system that the file will no
      // longer be used in this procedure
      CloseFile(lFile); //CLose the file
    end;
  finally
    //Exit to the crítical section
    TFileTextLog.FCriticalSection.Release;
  end;
end;

end.
