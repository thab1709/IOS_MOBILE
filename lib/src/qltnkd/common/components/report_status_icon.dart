// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:flutter/material.dart';

class ReportStatusIcon {
  const ReportStatusIcon._();

  static Widget build({
    int status,
    String statusText,
    bool isRejected = false,
    double size,
    double rightPadding = 4,
  }) {
    final effectiveStatus = status ?? int.tryParse(statusText?.trim() ?? '');

    if (isRejected ||
        effectiveStatus == ReportStatusType.Rejected ||
        _isRejectedText(statusText)) {
      return _icon(Icons.warning_amber_rounded, Colors.red, size, rightPadding);
    }

    if (effectiveStatus != null && effectiveStatus != 0) {
      switch (effectiveStatus) {
        case ReportStatusType.Completed:
          return _icon(Icons.check_circle_outline, Colors.green, size, rightPadding);
        case ReportStatusType.WaitingForTeamApproval:
        case ReportStatusType.WaitingForCenterApproval:
        case ReportStatusType.WaitingForCompanyApproval:
          return _icon(Icons.access_time_outlined, Colors.blue, size, rightPadding);
        case ReportStatusType.Implementing:
          return _icon(Icons.pending_outlined, Colors.orange, size, rightPadding);
      }
    }

    if (_isCompletedText(statusText)) {
      return _icon(Icons.check_circle_outline, Colors.green, size, rightPadding);
    }
    if (_isWaitingText(statusText)) {
      return _icon(Icons.access_time_outlined, Colors.blue, size, rightPadding);
    }
    if (statusText?.isNotEmpty == true) {
      return _icon(Icons.pending_outlined, Colors.orange, size, rightPadding);
    }

    return const SizedBox.shrink();
  }

  static Widget _icon(
    IconData icon,
    Color color,
    double size,
    double rightPadding,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: rightPadding),
      child: Icon(icon, color: color, size: size),
    );
  }

  static bool _isRejectedText(String value) {
    final text = value?.trim()?.toLowerCase();
    if (text == null || text.isEmpty) return false;
    return text == ReportStatusType.Rejected.toString() ||
        text == '7' ||
        text.contains('từ chối') ||
        text.contains('tu choi') ||
        text.contains('tá»« chá»‘i') ||
        text.contains('bá»‹ tá»« chá»‘i');
  }

  static bool _isCompletedText(String value) {
    final text = value?.trim()?.toLowerCase();
    if (text == null || text.isEmpty) return false;
    return text == ReportStatusType.Completed.toString() ||
        text == '6' ||
        text.contains('hoàn thành') ||
        text.contains('hoÃ n thÃ nh') ||
        text.contains('đạt') ||
        text.contains('Äáº¡t');
  }

  static bool _isWaitingText(String value) {
    final text = value?.trim()?.toLowerCase();
    if (text == null || text.isEmpty) return false;
    return text.contains('chờ') ||
        text.contains('chá»') ||
        text.contains('duyệt') ||
        text.contains('duyá»‡t') ||
        text.contains('phê') ||
        text.contains('phÃª');
  }
}

