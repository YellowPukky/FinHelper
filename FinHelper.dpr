program FinHelper;

uses
  Vcl.Forms,
  MainFrm in 'Forms\MainFrm.pas' {frmMain},
  DMUnt in 'Forms\DMUnt.pas' {DM: TDataModule},
  TDBManagerUnt in 'Modules\TDBManagerUnt.pas',
  MessagesUnt in 'Modules\MessagesUnt.pas',
  TableListFrm in 'Forms\TableListFrm.pas' {frmTableList},
  CategoryListFrm in 'Forms\CategoryListFrm.pas' {frmCategoryList},
  TTblRecordUnt in 'Modules\TTblRecordUnt.pas',
  TViewApplicationUnt in 'Modules\TViewApplicationUnt.pas',
  TTableRecFrm in 'Forms\TTableRecFrm.pas' {frmTblRecord},
  CardListFrm in 'Forms\CardListFrm.pas' {frmCardList},
  TCardRecordUnt in 'Modules\TCardRecordUnt.pas',
  CardRecordFrm in 'Forms\CardRecordFrm.pas' {frmCardlRecord},
  OrderListFrm in 'Forms\OrderListFrm.pas' {frmOrderList},
  TOrderRecordUnt in 'Modules\TOrderRecordUnt.pas',
  OrderRecordFrm in 'Forms\OrderRecordFrm.pas' {frmOrderRecord},
  TComboboxAdapterUnt in 'Modules\TComboboxAdapterUnt.pas',
  TIBDBHelperUnt in 'Modules\TIBDBHelperUnt.pas',
  DBManagerUtilsUnt in 'Modules\DBManagerUtilsUnt.pas',
  TOrderTableUnt in 'Modules\TOrderTableUnt.pas',
  TOrderLineUnt in 'Modules\TOrderLineUnt.pas',
  OrdLineRecordFrm in 'Forms\OrdLineRecordFrm.pas' {frmOrdLineRecord};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfrmCardList, frmCardList);
  Application.CreateForm(TfrmCardlRecord, frmCardlRecord);
  Application.CreateForm(TfrmOrderList, frmOrderList);
  Application.CreateForm(TfrmOrderRecord, frmOrderRecord);
  Application.CreateForm(TfrmOrdLineRecord, frmOrdLineRecord);
  Application.Run;
end.
