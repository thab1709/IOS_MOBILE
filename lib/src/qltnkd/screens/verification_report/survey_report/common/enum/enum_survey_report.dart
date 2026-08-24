// @dart=2.9
class SurveyReportStatusCode {
  static const int all = 0;
  static const int newReport = 1;
  static const int reject = 4;
  static const int waitConfirm = 2;
  static const int confirmed = 3;
  static const int deleted = 5;
}

enum EnumSurveyReport { all, newReport, reject, waitConfirm, confirmed }

extension SurveyReportExt on EnumSurveyReport {
  String getName() {
    switch (this) {
      case EnumSurveyReport.all:
        return 'Tất cả';
      case EnumSurveyReport.newReport:
        return 'Mới';
      case EnumSurveyReport.reject:
        return 'Bị từ chối';
      case EnumSurveyReport.waitConfirm:
        return 'Chờ xác nhận';
      case EnumSurveyReport.confirmed:
        return 'Đã xác nhận';
    }
    return '';
  }

  int getCode() {
    switch (this) {
      case EnumSurveyReport.all:
        return SurveyReportStatusCode.all;
      case EnumSurveyReport.newReport:
        return SurveyReportStatusCode.newReport;
      case EnumSurveyReport.reject:
        return SurveyReportStatusCode.reject;
      case EnumSurveyReport.waitConfirm:
        return SurveyReportStatusCode.waitConfirm;
      case EnumSurveyReport.confirmed:
        return SurveyReportStatusCode.confirmed;
    }
    return SurveyReportStatusCode.all;
  }
}
