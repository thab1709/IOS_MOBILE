// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';

class QRReportResult {
  QRReportResult({
    this.rawCode,
    this.reportId,
    this.searchTerm,
    this.subPath,
  });

  final String rawCode;
  final String reportId;
  final String searchTerm;
  final String subPath;

  String get searchValue {
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      return searchTerm.trim();
    }
    return reportId;
  }

  String get statusReport {
    switch (subPath?.trim()?.toLowerCase()) {
      case 'doing':
      case 'implementing':
        return ReportStatusType.Implementing.toString();
      case 'rejected':
        return ReportStatusType.Rejected.toString();
      case 'waiting-for-team-approval':
      case 'waitingforteamapproval':
        return ReportStatusType.WaitingForTeamApproval.toString();
      case 'waiting-for-center-approval':
      case 'waitingforcenterapproval':
        return ReportStatusType.WaitingForCenterApproval.toString();
      case 'waiting-for-company-approval':
      case 'waitingforcompanyapproval':
        return ReportStatusType.WaitingForCompanyApproval.toString();
      case 'completed':
      case 'done':
        return ReportStatusType.Completed.toString();
      default:
        return null;
    }
  }

  static QRReportResult fromCode(String code) {
    final jsonResult = _fromJson(code);
    if (jsonResult != null) return jsonResult;

    final queryParameters = _extractQueryParameters(code);
    final searchTerm = queryParameters['searchTerm'];
    final reportId = queryParameters['formReportId'] ??
        queryParameters['reportId'] ??
        queryParameters['id'];
    if (_hasValue(searchTerm) || _hasValue(reportId)) {
      return QRReportResult(
        rawCode: code,
        reportId: reportId,
        searchTerm: searchTerm,
        subPath: queryParameters['subPath'],
      );
    }

    final uuidRegex = RegExp(
      r'[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}',
    );
    final match = uuidRegex.firstMatch(code);
    if (match != null) {
      return QRReportResult(rawCode: code, reportId: match.group(0));
    }

    if (code.length > 10 && !code.contains(' ')) {
      return QRReportResult(rawCode: code, reportId: code);
    }

    return null;
  }

  static QRReportResult _fromJson(String code) {
    try {
      final json = jsonDecode(code) as Map<String, dynamic>;
      final searchTerm = json['searchTerm']?.toString();
      final reportId = json['formReportId']?.toString() ??
          json['reportId']?.toString() ??
          json['id']?.toString();
      if (_hasValue(searchTerm) || _hasValue(reportId)) {
        return QRReportResult(
          rawCode: code,
          reportId: reportId,
          searchTerm: searchTerm,
          subPath: json['subPath']?.toString(),
        );
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static Map<String, String> _extractQueryParameters(String code) {
    final queryStartIndex = code.indexOf('?');
    if (queryStartIndex < 0 || queryStartIndex == code.length - 1) {
      return {};
    }

    final hashIndex = code.indexOf('#', queryStartIndex);
    final query = code.substring(
      queryStartIndex + 1,
      hashIndex >= 0 ? hashIndex : code.length,
    );
    final result = <String, String>{};

    for (final part in query.split('&')) {
      if (part.isEmpty) continue;
      final separatorIndex = part.indexOf('=');
      final key = separatorIndex >= 0 ? part.substring(0, separatorIndex) : part;
      final value = separatorIndex >= 0 ? part.substring(separatorIndex + 1) : '';
      result[_decodeQueryComponent(key)] = _decodeQueryComponent(value);
    }

    return result;
  }

  static String _decodeQueryComponent(String value) {
    try {
      return Uri.decodeQueryComponent(value);
    } catch (_) {
      return value;
    }
  }

  static bool _hasValue(String value) {
    return value != null && value.isNotEmpty;
  }
}

