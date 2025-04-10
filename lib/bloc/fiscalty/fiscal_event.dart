part of 'fiscal_bloc.dart';

class FiscalEvent {}

class SubmitFiscalInfo extends FiscalEvent {
  final FiscalInfo info;
  SubmitFiscalInfo(this.info);
}
