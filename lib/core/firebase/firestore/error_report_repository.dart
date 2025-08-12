import 'dart:io';

import 'package:benin_poulet/constants/firebase_collections/errorReportsCollection.dart';
import 'package:benin_poulet/models/error_report.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FirebaseErrorReportRepository {
  final _errorReportsRef =
      FirebaseFirestore.instance.collection('errorReports');

  Future<Map> getDeviceInfos() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    return allInfo;
  }

  Future<void> sendErrorReport(ErrorReport errorReport) async {
    final docRef = _errorReportsRef.doc();
    final deviceInfos = await getDeviceInfos();

    final error = {
      ErrorReportsCollection.errorMessage: errorReport.errorMessage,
      ErrorReportsCollection.platform: Platform.operatingSystem,
      ErrorReportsCollection.date: DateTime.now(),
      ErrorReportsCollection.deviceInfos: deviceInfos,
      ErrorReportsCollection.errorPage: errorReport.errorPage
    };
    await docRef.set(error);
  }
}
