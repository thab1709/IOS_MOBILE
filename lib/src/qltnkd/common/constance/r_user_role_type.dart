// @dart=2.9
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';

class UserPosition {
  static const Administrator = 0;

  /// giám đốc/phó giám đốc
  static const KDTN_PresidentCompany = 1;

  ///giám đốc phó giám đốc trung tâm
  static const KDTN_PresidentCenter = 2;

  ///Chuyên viên P2
  static const KDTN_ExpertP2 = 3;

  ///Bộ phận tổng hợp
  static const constKDTN_Expert = 4;

  ///Đội trưởng
  static const constKDTN_Captain = 5;

  ///Kiểm định
  static const KDTN_Worker = 6;

  ///Lãnh đạo
  static const KDTN_Leader = 7;

  ///Chuyên viên công ty điện lực
  static const KDTN_ExpertElectric = 8;

  ///Lái xe
  static const KDTN_Driver = 9;

  ///Chuyên viên Vận hành
  static const KDTN_Operation = 10;
}

class RUserRole {
  static bool isWorkView = false;

  static bool isFormReportView = false;

  static bool isAdmin = false;
  static bool isPresidentCompany = false;
  static bool isPresidentCenter = false;
  static bool isExpertP2 = false;
  static bool isExpert = false;
  static bool isCaptain = false;
  static bool isWorker = false;
  static bool isLeader = false;
  static bool isExpertElectric = false;
  static bool isOperator = false;
  static bool isDriver = false;

  // form report
  static const _workView = 'personalWork.view';

  static const _formReportView = 'formReport.view';

  static const _all = 'all';

  static void checkPermission(UserProfileModel userProfileModel) {
    isWorkView = false;
    isFormReportView = false;
    isAdmin = false;
    isPresidentCompany = false;
    isPresidentCenter = false;
    isExpertP2 = false;
    isExpert = false;
    isCaptain = false;
    isWorker = false;
    isLeader = false;
    isExpertElectric = false;
    isDriver = false;
    isOperator = false;

    if (userProfileModel?.permissions?.firstOrNull == _all) {
      isFormReportView = true;
      isWorkView = true;
    } else {
      isFormReportView =
          userProfileModel?.permissions?.contains(_formReportView);
      isWorkView = userProfileModel?.permissions?.contains(_workView);
    }

    switch (userProfileModel.positionId) {
      case UserPosition.Administrator:
        isAdmin = true;
        break;
      case UserPosition.KDTN_PresidentCompany:
        isPresidentCompany = true;
        break;
      case UserPosition.KDTN_PresidentCenter:
        isPresidentCenter = true;
        break;
      case UserPosition.KDTN_ExpertP2:
        isExpertP2 = true;
        break;
      case UserPosition.constKDTN_Expert:
        isExpert = true;
        break;
      case UserPosition.constKDTN_Captain:
        isCaptain = true;
        break;
      case UserPosition.KDTN_Worker:
        isWorker = true;
        break;
      case UserPosition.KDTN_Leader:
        isLeader = true;
        break;
      case UserPosition.KDTN_ExpertElectric:
        isExpertElectric = true;
        isWorkView = true;
        break;
      case UserPosition.KDTN_Operation:
        isOperator = true;
        break;
      case UserPosition.KDTN_Driver:
        isDriver = true;
        break;
    }
  }
}

