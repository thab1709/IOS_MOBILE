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

  static bool hasPermissionCreate() {
    final roleValid = [UserRole.teamLead, UserRole.worker];
    return roleValid.contains(AppShared.instance.getUserProfile().position);
  }

}
