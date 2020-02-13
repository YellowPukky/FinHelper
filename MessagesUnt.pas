unit MessagesUnt;

interface
uses
  Dialogs, Controls, System.UITypes;

type
  TMessage = class
  public
    class procedure Error(aStrText: String);
    class procedure Information(aStrText: String);
    class procedure Warning(aStrText: String);
    class function QuestionYN(aStrText: String): TModalResult ;
  end;
implementation

{ TMessage }

class procedure TMessage.Error(aStrText: String);
begin
  MessageDlg(aStrText,mtError,[mbClose],0);
end;
class procedure TMessage.Information(aStrText: String);
begin
  MessageDlg(aStrText,mtInformation,[mbClose],0);
end;

class function TMessage.QuestionYN(aStrText: String): TModalResult ;
begin
  Result := MessageDlg(aStrText,mtConfirmation,[mbYes,mbNo],0);
end;

class procedure TMessage.Warning(aStrText: String);
begin
  MessageDlg(aStrText,mtWarning,[mbClose],0);
end;

end.
