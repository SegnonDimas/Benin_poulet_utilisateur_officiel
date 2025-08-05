class ErrorReport {
  final String errorMessage;
  String? platform;
  DateTime? date = DateTime.now();
  Map deviceInfo = {};

  ErrorReport(
      {required this.errorMessage,
      this.platform = 'android',
      this.date,
      this.deviceInfo = const {}});
}
