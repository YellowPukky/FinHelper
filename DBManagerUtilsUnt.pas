unit DBManagerUtilsUnt;

interface
uses
  System.SysUtils, IBX.IB;

type

  TIndexMetaData = record
    OwnTable: string;
    FKTable: string;
    procedure FillByIndexName(aNdxName:String);
  end;
  //================================================
  TDBMExceptionFactory = class;

  EDBManagerException = class(Exception)
  private
    FLocalMessage: String;
  public
    property LocalMessage: String read FLocalMessage;
    constructor Create(const Msg: string);
  end;

  EDBMForeignKeyException = class(EDBManagerException)
  private
    FCurTblName: String;
    FRefTblName: String;
    FIndexName: String;
    FCurID: Integer;
  public
    property CurTblName: String read FCurTblName;
    property RefTblName: String read FRefTblName;
    property IndexName: String read FIndexName;
    property CurID: Integer read FCurID;
    constructor Create(const Msg: string);
  end;

  TDBMExceptionFactory = class
    class function GetIndexMetaData(aNdxName: String): TIndexMetaData;
    class function GetNdxName_530(aIBErrMessage: String): String;
    class function GetID_530(aIBErrMessage: String): Integer;
    class function GetErrMessage_530(aIBErrMessage: String): String;
    class function CreateByIBXException(aEx:EIBInterbaseError ):EDBManagerException;
  end;
implementation
uses
  System.RegularExpressions, TDBManagerUnt, IBX.IBErrorCodes;

{ TDBManagerException }

constructor EDBManagerException.Create(const Msg: string);
begin
  inherited Create(Msg);
  FLocalMessage := Msg;
end;

class function TDBMExceptionFactory.GetErrMessage_530(
  aIBErrMessage: String): String;
var
  IndicesName: String;
  meta : TIndexMetaData;
  id: Integer;
  //MyClass: TObject;
begin
  IndicesName := GetNdxName_530(aIBErrMessage);
  try
    meta.FillByIndexName(IndicesName);
    id := GetID_530(aIBErrMessage);
    Result := Format('Ошибка удаления записи из справочника "%s" (id = %d). Запись связана с таблицей "%s"',
                     [meta.FKTable, id, meta.OwnTable]);
  except
    Result := aIBErrMessage;
  end;
end;

class function TDBMExceptionFactory.GetID_530(aIBErrMessage: String): Integer;
var
  tmp:String;
begin
  //tmp := TRegEx.Match(aIBErrMessage,'key value is ("ID" = 1)').Value;
  tmp := TRegEx.Match(aIBErrMessage,'\("[\w]+" = [0-9]+\)').Value;
  tmp := TRegEx.Match(tmp,'= [0-9]+\)').Value;
  tmp := tmp.Remove(0,2);
  tmp := tmp.Remove(tmp.Length-1);
  Result:=tmp.ToInteger;
end;

class function TDBMExceptionFactory.GetIndexMetaData(
  aNdxName: String): TIndexMetaData;
begin
  Result.FillByIndexName(aNdxName);
end;

class function TDBMExceptionFactory.GetNdxName_530(
  aIBErrMessage: String): String;
begin
  Result := TRegEx.Match(aIBErrMessage,'constraint "[\w]+"').Value;
  Result := Result.Remove(0,12);
  Result := Result.Remove(Result.Length-1);
end;

{ TIndexMetaData }

procedure TIndexMetaData.FillByIndexName(aNdxName: String);
begin
  if aNdxName = 'FK_ORDERS_1' then
  begin
    OwnTable := 'Документы';
    FKTable := 'Карты';
  end
  else if aNdxName = 'FK_ORDLINES_1' then
  begin
    OwnTable := 'Строки документа';
    FKTable := 'Документы';
  end
  else if aNdxName = 'FK_ORDLINES_2' then
  begin
    OwnTable := 'Строки документа';
    FKTable := 'Категории';
  end

  else
  begin
    raise EDBMException.Create('Ошибка получения метаданных индекса. Неизвестный индекс '+aNdxName);
  end;
end;

{ TDBMExceptionFactory }

class function TDBMExceptionFactory.CreateByIBXException(
  aEx: EIBInterbaseError): EDBManagerException;
begin
  // создание своего исключения на основе исключения IB
  case aEx.SQLCode of
    -530:
      begin
        Result := EDBMForeignKeyException.Create(aEx.Message);
      end

  else
    Result := EDBManagerException.Create(Format('Ошибка сервера! %d; %s ',[aEx.SQLCode,aEx.Message]));
  end;
end;

{ TDBMForeignKeyException }

constructor EDBMForeignKeyException.Create(const Msg: string);
var
  locMsg: String;
  meta: TIndexMetaData;
begin
  locMsg :=TDBMExceptionFactory.GetErrMessage_530(Msg);
  inherited Create(locMsg);
  FIndexName := TDBMExceptionFactory.GetNdxName_530(Msg);
  FCurID := TDBMExceptionFactory.GetID_530(Msg);
  meta.FillByIndexName(FIndexName);
  FCurTblName := meta.OwnTable;
  FRefTblName := meta.FKTable;
end;

end.
