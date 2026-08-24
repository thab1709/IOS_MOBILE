// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';

class UserRole {
  static const president = 1;
  static const manager = 2;
  static const teamLead = 3;
  static const worker = 4;
  static const employee = 5;
  static const chairman = 6;
  static const viceChairman = 7;
  static const technicalChief = 8;
  static const deputyChief = 9;
  static const expert = 10;

  static const X6Chairman = 11; //Giám đốc
  static const X6ViceChairman = 12; //Phó giám đốc
  static const X6TechnicalChief = 13; //Trưởng phòng kỹ thuật
  static const X6DeputyChief = 14; //Phó phòng kỹ thuật
  static const X6Expert = 15; //Chuyên viên phòng
  static const X6Captain = 16; //Đội trưởng/Trưởng phòng
  static const X6ViceCaptain = 17; //Đội phó
  static const X6Leader = 18; //Tổ trưởng
  static const X6Employee = 19; //Nhân viên

  static bool hasPermissionCreate() {
    final roleValid = [UserRole.teamLead, UserRole.worker];
    return roleValid.contains(AppShared.instance.getUserProfile().position);
  }

  static String getNamePosition(int position) {
    switch (position) {
      case X6Chairman:
        return 'Giám đốc';
        break;
      case X6ViceChairman:
        return 'Phó giám đốc';
        break;
      case X6TechnicalChief:
        return 'Trưởng phòng kỹ thuật';
        break;
      case X6DeputyChief:
        return 'Phó phòng kỹ thuật';
        break;
      case X6Expert:
        return 'Chuyên viên phòng';
        break;
      case X6Captain:
        return 'Đội trưởng/Trưởng phòng';
        break;
      case X6ViceCaptain:
        return 'Đội phó';
        break;
      default :
        return 'Nhân viên';
        break;
    }
  }
}

