// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:get/get.dart';

import '../../../common/utils/snack_bar_h_u_d.dart';
import '../../../models/notification_request_model.dart';
import '../../../models/option_model.dart';
import '../../../services/responsitory/notify_respository.dart';

class SendNotificationController extends GetxController {
  final x6Chairmans = <OptionModelString>[].obs;
  final x6ViceChairmans = <OptionModelString>[].obs;
  final x6TechnicalChiefs = <OptionModelString>[].obs;
  final x6DeputyChiefs = <OptionModelString>[].obs;
  final x6Experts = <OptionModelString>[].obs;
  final groups = <OptionModelString>[].obs;
  final teams = <OptionModelString>[].obs;
  final employees = <OptionModelString>[].obs;

  final content = ''.obs;
  final x6ChairmansID = <OptionModelString>[].obs;
  final x6ViceChairmanID = <OptionModelString>[].obs;
  final x6TechnicalChiefID = <OptionModelString>[].obs;
  final x6DeputyChiefID = <OptionModelString>[].obs;
  final x6ExpertsID = <OptionModelString>[].obs;
  final groupID = <OptionModelString>[].obs;
  final teamID = <OptionModelString>[].obs;
  final x6EmployeeID = <OptionModelString>[].obs;
  final isHasPermissionSend = false.obs;

  final service = NotifyRepository();

  Future getDataByRole(int role) async {
    final res = await service.getUserByPosition(
        userPosition: role, backgroundMode: true);
    if (res.isLoadSuccess) {
      switch (role) {
        case UserRole.X6Chairman:
          x6Chairmans.assignAll(res.data);
          x6Chairmans.refresh();
          break;
        case UserRole.X6ViceChairman:
          x6ViceChairmans.assignAll(res.data);
          x6ViceChairmans.refresh();
          break;
        case UserRole.X6TechnicalChief:
          x6TechnicalChiefs.assignAll(res.data);
          x6TechnicalChiefs.refresh();
          break;

        case UserRole.X6DeputyChief:
          x6DeputyChiefs.assignAll(res.data);
          x6DeputyChiefs.refresh();
          break;

        case UserRole.X6Expert:
          x6Experts.assignAll(res.data);
          x6Experts.refresh();
          break;
      }
    } else {
      await rShowDialogOneButton(res.message ?? '');
    }
  }

  Future getAllGroupX6() async {
    final res = await service.getListGroup(isBackground: true);
    if (res.isLoadSuccess) {
      groups.assignAll(res.data);
      groups.refresh();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  Future getTeamByGroupX6() async {
    final res = await service.getListTeam(
        idGroup: groupID.map((e) => e.value).join(','), isBackground: true);
    if (res.isLoadSuccess) {
      teams.assignAll(res.data);
      teams.refresh();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  Future getEmployees() async {
    final res = await service.getListEmployees(
        groupID: groupID.map((e) => e.value).join(','),
        teamID: teamID.map((e) => e.value).join(','),
        isBackground: true);
    if (res.isLoadSuccess) {
      employees.assignAll(res.data);
      employees.refresh();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  void checkHasPermissionSend() {
    isHasPermissionSend.value = null;
    isHasPermissionSend.value = content.value.isNotEmpty &&
        (x6ChairmansID.isNotEmpty ||
            x6ViceChairmanID.isNotEmpty ||
            x6TechnicalChiefID.isNotEmpty ||
            x6DeputyChiefID.isNotEmpty ||
            x6ExpertsID.isNotEmpty ||
            x6EmployeeID.isNotEmpty ||
            groupID.isNotEmpty ||
            teamID.isNotEmpty);
  }

  Future initData() async {
    ProgressHUD.show();
    final futures = <Future>[];
    futures.add(getDataByRole(UserRole.X6Chairman));
    futures.add(getDataByRole(UserRole.X6ViceChairman));
    futures.add(getDataByRole(UserRole.X6TechnicalChief));
    futures.add(getDataByRole(UserRole.X6DeputyChief));
    futures.add(getDataByRole(UserRole.X6Expert));
    futures.add(getAllGroupX6());
    await Future.wait(futures);
    ProgressHUD.dismiss();
  }

  void clearTeamData() {
    employees.clear();
    x6EmployeeID.clear();
    teams.clear();
    teamID.clear();
    employees.refresh();
    teams.refresh();
  }

  void clearEmployee() {
    employees.clear();
    x6EmployeeID.clear();
    employees.refresh();
  }


  Future sendFeedback() async {
    final userIds = [
      ...x6ChairmansID.map((element) => element.value).toList(),
      ...x6ViceChairmanID.map((element) => element.value).toList(),
      ...x6TechnicalChiefID.map((element) => element.value).toList(),
      ...x6DeputyChiefID.map((element) => element.value).toList(),
      ...x6ExpertsID.map((element) => element.value).toList(),
      ...x6EmployeeID.map((element) => element.value).toList(),
    ];

    final request = NotificationRequestModel(
            content: content.value,
            userGroupIds: groupID.map((element) => element.value).toList(),
            userTeamIds: teamID.map((element) => element.value).toList(),
            userIds: userIds,
            isMonitoring: false)
        .toJson();

    final res = await service.sendFeedback(request: request);
    if (res.isLoadSuccess) {
      Get.back();
      SnackBarHUD.show('Gửi phản hồi thành công');
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }
}

