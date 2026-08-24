// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';

class ReportStatusType {
  static const all = 0;
  static const Implementing = 2; // Đã tạo biên bản nhưng chưa gửi phê duyệt
  static const WaitingForTeamApproval = 3; // Hoàn thành nhập biên bản và gửi phê duyệt cho cấp Tổ đội
  static const WaitingForCenterApproval = 4; // Trường hợp biên bản thí nghiệm cần phê duyệt cấp trung taa
  static const WaitingForCompanyApproval = 5; //  Trường hợp biên bản thí nghiệm cần phê duyệt cấp công ty
  static const Completed = 6; //  Biên bản đã được phê duyệt qua các cấp
  static const Rejected = 7; // Phiếu gửi phê duyệt nhưng bị từ chối
}

class CertificateStatusType {
  static const all = 0;
  static const Implementing = 2; // Đã tạo biên bản nhưng chưa gửi phê duyệt
  static const WaitingForTeamApproval = 3; // Hoàn thành nhập biên bản và gửi phê duyệt cho cấp Tổ đội
  static const WaitingForCenterApproval = 4; // Trường hợp biên bản thí nghiệm cần phê duyệt cấp công ty
  static const WaitingForCompanyApproval = 5; //  Trường hợp biên bản thí nghiệm cần phê duyệt cấp công ty
  static const Completed = 6; //  Biên bản đã được phê duyệt qua các cấp
  static const Rejected = 7; // Phiếu gửi phê duyệt nhưng bị từ chối
}

class ReportWorkStatusType {
  static const all = 0; // Chưa thực hiện
  static const unfulfilled = 1; // Chưa thực hiện
  static const doing = 2; //đang làm
  static const done = 3; //hoàn thành
}

class WorkType {
  static const allWorks = 0;
  static const experiment = 1; // thí nghiệm
  static const accreditation = 2; // kiểm định
  static const accreditationExperiment = 3; // thí nghiệm kiểm định

  static int getCodeByName(String name){
    switch(name) {
      case WorkTypeName.experiment: return experiment;
      case WorkTypeName.accreditation: return accreditation;
      case WorkTypeName.accreditationExperiment: return accreditationExperiment;
      default: return 0;
    }
  }
}

class WorkTypeName {
  static const experiment = 'Thí nghiệm'; // thí nghiệm
  static const accreditation = 'Kiểm định'; // kiểm định
  static const accreditationExperiment = 'Thí nghiệm và kiểm định'; // thí nghiệm kiểm định
}

class RReportType {
  static const accreditation = 2;
  static const experiment = 1;
}

class CertificateType {
  static const all = 0;
  static const accreditation = 1;
  static const test = 2;
}

class ReportStatus {
  static const allReportType = 0; // tất cả
  static const reportPlan = 1;    // theo kế hoạch
  static const reportNotPlan = 2; // không theo kế hoạch
}

class FormType {
  static const report = 1;
  static const certificate = 2;
}

class StatusReportForDirectorCompany {
  static const implement = 4; // Chưa hoàn thành
  static const needSign = 5; //cần ký
  static const complete = 6; //hoàn thành

  static const listStatus = [implement, needSign, complete];
}

const workTypeOptions = [
  IntOptionModel(RAppStrings.allWorks, WorkType.allWorks),
  IntOptionModel(RAppStrings.experiment, WorkType.experiment),
  IntOptionModel(RAppStrings.accreditation, WorkType.accreditation),
  IntOptionModel(
      RAppStrings.accreditationExperiment, WorkType.accreditationExperiment),
];

const workTypeUnscheduledReportOptions = [
  IntOptionModel(RAppStrings.allWorks, WorkType.allWorks),
  IntOptionModel(RAppStrings.experiment, WorkType.experiment),
  IntOptionModel(RAppStrings.accreditation, WorkType.accreditation),
  // IntOptionModel(
  //     RAppStrings.accreditationExperiment, WorkType.accreditationExperiment),
];
const reportTypeOptions = [
  IntOptionModel(RAppStrings.allReportType, ReportStatus.allReportType),
  IntOptionModel(RAppStrings.reportPlan, ReportStatus.reportPlan),
  IntOptionModel(RAppStrings.reportNotPlan, ReportStatus.reportNotPlan),
];

const certificateTypeOptions = [
  IntOptionModel(RAppStrings.all, CertificateType.all),
  IntOptionModel(RAppStrings.certificateAccreditation, CertificateType.accreditation),
  IntOptionModel(RAppStrings.certificateTest, CertificateType.test),
];

