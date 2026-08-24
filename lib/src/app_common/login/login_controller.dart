// @dart=2.9
import 'dart:async';

import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/app_common/login/select_module.dart';
import 'package:evnmobile/src/app_common/repository/authen_repository.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/services/responsitory/authen_repository.dart'
    as authen_repository_htdct;
import 'package:evnmobile/src/htdct/services/responsitory/user_repository.dart'
    as user_repository_htdct;
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/services/responseModel/login_response.dart';
import 'package:evnmobile/src/htld/services/responsitory/authen_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/user_repository.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:evnmobile/src/htld/shared_preferences/app_shared.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/user_repository.dart';
import 'package:evnmobile/src/qltnkd/services/qr_deep_link_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';

import '../../../routes.dart';
import '../../qltnkd/screens/verification_report/workload/list_request/list_request_controller.dart';
import '../utils/utils.dart';

mixin ChangePasswordExpired {
  void onChangePasswordExpiredSuccess();
}

class AppLoginController extends GetxController {
  final isShowPassword = false.obs;
  final service = AppAuthRepository();
  final appVersionName = ''.obs;
  final savePassword = AppShared.instance.getHAutoFillPassword().obs;
  bool _loginInWebSSO = false;

  bool get loginInWebSSO => _loginInWebSSO;

  ChangePasswordExpired listener;

  void updateStatusLoginSSO({bool status = false}) {
    _loginInWebSSO = status;
  }

  void togglePassword() {
    isShowPassword.value = !isShowPassword.value;
    update();
  }

  Future getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    appVersionName.value = packageInfo.version;
    update();
  }

  Future<void> logout() async {
    if (AppShared.instance.getAppType() == AppType.HTLDTT ||
        AppShared.instance.getAppType() == AppType.HTLDHT) {
      final gridService = AuthRepository();
      final response = await gridService.logout();
      if (response.isLoadSuccess) {
        MAppShared.shared.units.clear();
        MAppShared.shared.groups.clear();
        await AppShared.instance.persistentUserToken('');
        await Get.offAllNamed(Routes.selectModule);
      } else {
        await showDialogError(response.message);
        return;
      }
    } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
      final gridService = authen_repository_htdct.AuthRepository();
      final response = await gridService.logout();
      if (response.isLoadSuccess) {
        await AppShared.instance.persistentUserToken('');
        await AppShared.instance.clearTeamsHTDCT();
        await Get.offAll(const SelectModuleScreen(
          isLogoutSSO: true,
        ));
      } else {
        await showDialogError(response.message);
        return;
      }
    } else {}
  }

  Future<bool> login(
      {String username, String password, String ticket, String appCode}) async {
    ServerResponse<LoginResponse> response;
    if (username != null) {
      response = await service.login(username, password);
    } else if (ticket != null) {
      response = await service.loginSSO(ticket, appCode);
    }
    if (response.statusCode == 1000) {
      // password expire code
      await showDialogError(response.message, action: () async {
        final result =
            await Get.toNamed(Routes.changePassword, arguments: username);
        if (result == true) {
          listener.onChangePasswordExpiredSuccess();
        }
      });
      return false;
    }

    if (response.isLoadSuccess) {
      await AppShared.instance.persistentUserName(username);

      await AppShared.instance
          .persistentUserPassword(savePassword.value == true ? password : '');

      final token = response.data.accessToken;
      // AppEnv.type = response?.data?.appType ?? 2;
      await AppShared.instance.persistentUserToken(token);
      debugPrint(token);
      // NOTE(hau): login to app ha the
      if (AppShared.instance.getAppType() == AppType.HTLDTT ||
          AppShared.instance.getAppType() == AppType.HTLDHT) {
        final profileService = UserRepository();
        final unitsFuture = profileService.getUserUnits();
        final userProfileFuture = profileService.getUserProfile();
        final units = await unitsFuture;
        final userProfileResponse = await userProfileFuture;

        if (units.isLoadSuccess) {
          MAppShared.shared.units = units.data;
          units?.data?.forEach((element) {
            if (element.id != '0') {
              profileService.getUserGroup(unitId: element.id);
            }
          });
        }

        if (userProfileResponse.isLoadSuccess) {
          if (userProfileResponse.data.userProfile.appVersion != null &&
              userProfileResponse.data.userProfile.appVersion.isNotEmpty) {
            if (userProfileResponse.data.userProfile.getAppVersion().firstWhere(
                    (element) => element == appVersionName.value,
                    orElse: () => null) ==
                null) {
              // await showDialogUpdateApp();
              await Get.toNamed(Routes.home);
            } else {
              await Get.toNamed(Routes.home);
            }
          } else {
            await Get.toNamed(Routes.home);
          }
        }
      } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
        await AppShared.instance.clearTeamsHTDCT();
        final profileService = user_repository_htdct.UserRepository();
        await profileService.clearDataDummy();
        final userProfileResponse =
            await profileService.getUserProfile(backgroundMode: false);
        if (userProfileResponse.isLoadSuccess) {
          if (userProfileResponse.data.userProfile.appVersion != null &&
              userProfileResponse.data.userProfile.appVersion.isNotEmpty) {
            if (userProfileResponse.data.userProfile.getAppVersion().firstWhere(
                    (element) => element == appVersionName.value,
                    orElse: () => null) ==
                null) {
              // await showDialogUpdateApp();
              profileService.getDataDummy();
              await Get.toNamed(Routes.homeDCT);
            } else {
              profileService.getDataDummy();
              await Get.toNamed(Routes.homeDCT);
            }
          } else {
            profileService.getDataDummy();
            await Get.toNamed(Routes.homeDCT);
          }
        }
      } else {
        final profileService = ReportUserRepository();
        final userProfileResponse = await profileService.getUserProfile();
        if (!Get.isRegistered<ListRequestController>()) {
          Get.put(ListRequestController(), permanent: true);
        }

        if (userProfileResponse.isLoadSuccess) {
          if (userProfileResponse.data.appVersion != null &&
              userProfileResponse.data.appVersion.isNotEmpty) {
            if (userProfileResponse.data
                .getAppVersion()
                .contains(appVersionName.value)) {
              RUserRole.checkPermission(userProfileResponse.data);

              if (RUserRole.isPresidentCompany) {
                await Get.toNamed(Routes.listReportForDirectorCompanyScreen);
              } else if (RUserRole.isPresidentCenter) {
                await Get.toNamed(Routes.listReportScreen);
              } else if (RUserRole.isExpertElectric) {
                await Get.toNamed(Routes.workloadHome);
              } else {
                await Get.toNamed(Routes.reportHome);
              }
            } else {
              // await showDialogUpdateApp();
              RUserRole.checkPermission(userProfileResponse.data);

              if (RUserRole.isPresidentCompany) {
                await Get.toNamed(Routes.listReportForDirectorCompanyScreen);
              } else if (RUserRole.isPresidentCenter) {
                await Get.toNamed(Routes.listReportScreen);
              } else if (RUserRole.isExpertElectric) {
                await Get.toNamed(Routes.workloadHome);
              } else {
                await Get.toNamed(Routes.reportHome);
              }
            }
          } else {
            RUserRole.checkPermission(userProfileResponse.data);

            if (RUserRole.isPresidentCompany) {
              await Get.toNamed(Routes.listReportForDirectorCompanyScreen);
            } else if (RUserRole.isPresidentCenter) {
              await Get.toNamed(Routes.listReportScreen);
            } else if (RUserRole.isExpertElectric) {
              await Get.toNamed(Routes.workloadHome);
            } else {
              await Get.toNamed(Routes.reportHome);
            }
          }
          await QrDeepLinkHandler.openPendingReport();
        }
      }
    } else {
      await showDialogError(response.message);
    }

    return false;
  }

  Future savePasswordOnChange({bool isSave}) async {
    savePassword.value = isSave;
    await AppShared.instance.persistentHAutoFillPassword(isAutoFill: isSave);
    update();
  }
}

