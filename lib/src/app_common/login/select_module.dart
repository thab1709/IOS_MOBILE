// @dart=2.9
import 'dart:async';

import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/app_common/login/login_controller.dart';
import 'package:evnmobile/src/app_common/rescource/images_common.dart';
import 'package:evnmobile/src/app_common/rescource/strings_common.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../enum/app_code.dart';
import '../utils/utils.dart';

class SelectModuleScreen extends StatefulWidget {
  const SelectModuleScreen({this.isLogoutSSO = false, Key key})
      : super(key: key);

  final bool isLogoutSSO;

  @override
  State<SelectModuleScreen> createState() => _SelectModuleScreenState();
}

class _SelectModuleScreenState extends State<SelectModuleScreen> {
  String ticket;
  String appCode;

  Future loginSSO() async {
    const ssoMethodChanel = MethodChannel('com.evn.pmis/sso');
    unawaited(ssoMethodChanel.invokeMethod('getSSO'));
    ssoMethodChanel.setMethodCallHandler((call) async {
      if (!AppEnv.firstLoad && call.method == 'ssoResultFirst') return;
      AppEnv.firstLoad = false;
      if (call.arguments == null) return;
      final uri = Uri.parse(call.arguments.toString());
      ticket = uri.queryParameters['ticket'];
      if (ticket == null) return;
      appCode = uri.queryParameters['appCode'];
      final loginController = AppLoginController();
      if (appCode == AppCode.KDTN) {
        await AppShared.instance.persistentAppType(AppType.KDTN);
      } else if (appCode == AppCode.CAOTHE) {
        await AppShared.instance.persistentAppType(AppType.HTDCT);
      }
      // else if (appCode == "HTLTT") {
      //   await AppShared.instance.persistentAppType(AppType.HTLD);
      // }
      await loginController.getDeviceInfo();
      await loginController.login(ticket: ticket, appCode: appCode);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await loginSSO();
      if (widget.isLogoutSSO == true) {
        await openAppSSO('logout');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = Get.size.width >= 600;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          color: HighElectricAppColor.nature01,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: isLargeScreen ? 100 : 30),
              child: Column(
                children: [
                  Image.asset(
                    ImagesCommon.bgSelectModule,
                  ),
                  _buildItem(ImagesCommon.icSettings, StringsCommon.moduleName1,
                      () {
                    AppShared.instance.persistentAppType(AppType.KDTN);
                    Get.toNamed(Routes.login);
                  }, const Color(0xff008000)),
                  _buildItem(
                      ImagesCommon.icHighElectric, StringsCommon.moduleName3,
                      () async {
                    await AppShared.instance.persistentAppType(AppType.HTDCT);
                    await Get.toNamed(Routes.login);
                    // Get.toNamed(Routes.homeDCT);
                  }, const Color(0xff1F59DE)),
                  _buildItem(ImagesCommon.icElectric, StringsCommon.moduleName2,
                      () {
                    AppShared.instance.persistentAppType(AppType.HTLDTT);
                    Get.toNamed(Routes.login);
                  }, const Color(0xff7F15D1)),
                  _buildItem(ImagesCommon.icElectric, StringsCommon.moduleName4,
                      () {
                    AppShared.instance.persistentAppType(AppType.HTLDHT);
                    Get.toNamed(Routes.login);
                  }, Color.fromARGB(255, 184, 8, 178)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      String icon, String title, Function() onTap, Color bgColor) {
    var marginVertical = 10.0;
    var marginHorizontal = 10.0;
    final isLargeScreenSize = Get.size.width >= 600;
    if (isLargeScreenSize) {
      marginVertical = 20;
      marginHorizontal = 100;
    }
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: marginVertical, horizontal: marginHorizontal),
        child: Card(
          color: bgColor,
          child: Container(
            padding: EdgeInsets.symmetric(
                vertical: isLargeScreenSize ? 20 : 16,
                horizontal: isLargeScreenSize ? 20 : 12),
            child: Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: SvgPicture.asset(
                      icon,
                      color: Colors.white,
                    )),
                Expanded(
                    child: Text(
                  title ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: SvgPicture.asset(
                    ImagesCommon.icBack,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

