// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../common/constance/image_path.dart';
import '../../common/constance/inspection_type.dart';
import '../../common/constance/strings.dart';

enum TestType { subStation, line, unKnow } //dong.lt

enum TicketType {
  periodicMonth,
  periodicDay,
  periodicNight,
  periodicCBM,
  tunnelCable,
  experiment,
  operationLog,
  userGroupLog,
}

extension TicketTypeName on TicketType {
  String get title {
    switch (this) {
      case TicketType.periodicDay:
        return HighElectricStrings.periodicDay;
      case TicketType.periodicMonth:
        return HighElectricStrings.periodicMonth;
      case TicketType.periodicNight:
        return HighElectricStrings.periodicNight;
      case TicketType.periodicCBM:
        return HighElectricStrings.periodicCBM;
      case TicketType.tunnelCable:
        return HighElectricStrings.tunnelCable;
      case TicketType.experiment:
        return HighElectricStrings.experiment;
      case TicketType.operationLog:
        return HighElectricStrings.operationLog;
      case TicketType.userGroupLog:
        return HighElectricStrings.userGroupLog;
      default:
        return '';
    }
  }

  SvgPicture get icon {
    switch (this) {
      case TicketType.periodicDay:
        return SvgPicture.asset(
          HighElectricImagePath.iconPeriodicDay,
          color: Colors.black,
        );
      case TicketType.periodicMonth:
        return SvgPicture.asset(
          HighElectricImagePath.iconPeriodicDay,
          color: Colors.black,
        );
      case TicketType.periodicNight:
        return SvgPicture.asset(
          HighElectricImagePath.iconPeriodicNight,
          color: Colors.white,
        );
      case TicketType.periodicCBM:
        return SvgPicture.asset(
          HighElectricImagePath.iconPeriodicCBM,
          color: Colors.white,
        );
      case TicketType.tunnelCable:
        return SvgPicture.asset(
          HighElectricImagePath.iconTunnelCable,
          color: Colors.white,
        );
      case TicketType.experiment:
        return SvgPicture.asset(
          HighElectricImagePath.iconPeriodicDay,
          color: Colors.black,
        );
      default:
        return SvgPicture.asset(
          HighElectricImagePath.iconPeriodicNight,
          color: Colors.white,
        );
    }
  }

  Color get bgColor {
    switch (this) {
      case TicketType.periodicDay:
        return const Color(0xffFFE615);
      case TicketType.periodicMonth:
        return const Color(0xffFFE615);
      case TicketType.periodicNight:
        return const Color(0xff254BB7);
      case TicketType.periodicCBM:
        return const Color(0xff008000);
      case TicketType.tunnelCable:
        return const Color(0xff7F15D1);
      case TicketType.experiment:
        return const Color(0xffFFE615);
      default:
        return const Color(0xff1F59DE);
    }
  }

  TextStyle get textStyle {
    switch (this) {
      case TicketType.periodicDay:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black);
      case TicketType.periodicMonth:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black);
      case TicketType.periodicNight:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
      case TicketType.periodicCBM:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
      case TicketType.tunnelCable:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
      case TicketType.experiment:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black);
      default:
        return const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white);
    }
  }

  //Loại công việc từ PMIS
  String workTypeCode(TestType testType) {
    switch (this) {
      case TicketType.periodicDay:
        switch (testType) {
          case TestType.subStation:
            return '1';
          //tram bien ap ngay
          case TestType.line:
            return '0';
            break;
          case TestType.unKnow:
            return '';
            break;
        }
        break;
      case TicketType.periodicNight:
        switch (testType) {
          case TestType.subStation:
            return '2';
          // tram bien ap dem
          case TestType.line:
            return '4';
          //duong day dem
          case TestType.unKnow:

            break;
        }
        break;

      case TicketType.periodicMonth:
        // duong day thang
        switch (testType) {
          case TestType.line:
            return '3';
            break;
          case TestType.subStation:
            return '0';
            break;
          case TestType.unKnow:

            break;
        }
        break;
      case TicketType.tunnelCable:
        switch (testType) {
          case TestType.line:
            return '5';
            break;
          case TestType.subStation:
            break;
          case TestType.unKnow:
            break;
        }
        break;
      case TicketType.experiment:
        switch (testType) {
          case TestType.subStation:
            return '7';
            break;
          case TestType.line:
            return '5';
            break;
          case TestType.unKnow:
            break;
        }
        break;

      case TicketType.periodicCBM:
        break;
      case TicketType.operationLog:
        break;
      case TicketType.userGroupLog:
        break;
    }
    return '0';
  }

  //Loại phiếu kiểm tra
  String testTypeCode() {
    switch (this) {
      case TicketType.periodicNight:
        return '2';

      case TicketType.periodicMonth:
        return '1';
        break;
      case TicketType.tunnelCable:
        return '4';

      case TicketType.periodicCBM:
        return '3';

      case TicketType.experiment:
        return '5';

      case TicketType.periodicDay:
        break;
      case TicketType.operationLog:
        break;
      case TicketType.userGroupLog:
        break;
    }
    return '0';
  }

  String tabbarTitle(TestType testType) {
    switch (this) {
      case TicketType.periodicDay:
        switch (testType) {
          case TestType.subStation:
            return 'Kiểm tra ngày TBA';
          //tram bien ap ngay
          case TestType.line:
            return 'Kiểm tra ngày đường dây';
          // duong day thang
          case TestType.unKnow:
            break;
        }
        break;
      case TicketType.periodicMonth:
        return 'Kiểm tra tháng đường dây';
        break;
      case TicketType.periodicNight:
        switch (testType) {
          case TestType.subStation:
            return 'Kiểm tra đêm TBA';
          // tram bien ap dem
          case TestType.line:
            return 'Kiểm tra đêm đường dây';
          //duong day dem
          case TestType.unKnow:
            break;
        }
        break;
      case TicketType.experiment:
        return 'Thí nghiệm';
        break;
      case TicketType.operationLog:
        return 'Sổ vận hành';
        break;
      case TicketType.userGroupLog:
        return 'Sổ ghi ý kiến các đoàn kiểm tra';
        break;
      case TicketType.tunnelCable:
        return 'Kiểm tra hầm nối cáp ngầm';
        break;
      case TicketType.periodicCBM:
        break;
    }
    return '0';
  }

}

extension SubStationName on TestType {
  String get title {
    switch (this) {
      case TestType.subStation: //dong.lt
        return HighElectricStrings.subStation;
      case TestType.line: //dong.lt
        return HighElectricStrings.line;
      default:
        return '';
    }
  }

  int get code {
    switch (this) {
      case TestType.subStation: //dong.lt
        return 1;
      case TestType.line: //dong.lt
        return 2;
      default:
        return 3;
    }
  }

  List<TicketType> get tickets {
    switch (this) {
      case TestType.subStation: //dong.lt
        return [
          TicketType.periodicDay,
          TicketType.periodicNight,
          // TicketType.periodicCBM
        ];
      case TestType.line: //dong.lt
        return [
          TicketType.periodicMonth,
          TicketType.periodicNight,
          // TicketType.periodicCBM,
          TicketType.tunnelCable
        ];
      default:
        return <TicketType>[];
    }
  }

  List<TicketType> get ticketsNotPMIS {
    switch (this) {
      case TestType.subStation: //dong.lt
        return [
          TicketType.experiment,
        ];
      case TestType.line: //dong.lt
        return [TicketType.experiment];
      default:
        return <TicketType>[];
    }
  }

}

extension TicketTypeCode on num {
  TicketType get getTicket {
    switch (this) {
      case HighElectricInspectionType.dayTime:
        return TicketType.periodicDay;

      case HighElectricInspectionType.monthTime:
        return TicketType.periodicMonth;

      case HighElectricInspectionType.nightTime:
        return TicketType.periodicNight;

      case HighElectricInspectionType.cbm:
        return TicketType.periodicCBM;

      case HighElectricInspectionType.experiment:
        return TicketType.experiment;

      case HighElectricInspectionType.operationLog:
        return TicketType.operationLog;

      default:
        return TicketType.tunnelCable;
    }
  }
}

class TicketModel {
  String sub;
}

