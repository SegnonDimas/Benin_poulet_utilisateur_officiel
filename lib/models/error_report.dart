class ErrorReport {
  final String errorMessage;
  final String errorPage;
  String? platform;
  DateTime? date = DateTime.now();
  Map deviceInfo = {};

  ErrorReport(
      {required this.errorMessage,
      required this.errorPage,
      this.platform = 'android',
      this.date,
      this.deviceInfo = const {}});
}
