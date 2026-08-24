// @dart=2.9
import 'package:evnmobile/src/app_common/login/login_controller.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/image_path.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/screens/change_password/change_password_expire.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info/package_info.dart';
import 'package:evnmobile/src/htld/screens/email/email_manager_screen.dart';
import 'package:evnmobile/src/htld/screens/notification/notification_manager_controller.dart';
import 'package:evnmobile/src/htld/screens/notification/notification_manager_screen.dart';

import '../../../../app_env.dart';
import '../../../app_common/utils/utils.dart';
import '../../../qltnkd/common/components/app_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<ProfileScreen> {
  final controller = AppLoginController();
  final notificationController = Get.put(NotificationManagerController());

  @override
  void initState() {
    super.initState();
    // Lấy số notification chưa đọc khi vào màn profile
    Future.delayed(const Duration(milliseconds: 200),
        notificationController.fetchUnreadCount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          alignment: Alignment.centerLeft,
          child:
              Image.asset(ImagePath.logoEVN, fit: BoxFit.contain, height: 40),
        ),
        actions: [
          if (AppShared.instance.getAppType() == AppType.HTLDHT)
            Obx(() => Stack(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.to(() => const NotificationManagerScreen());
                        },
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.black54,
                        )),
                    if (notificationController.unreadCount.value > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            '${notificationController.unreadCount.value > 99 ? '99+' : notificationController.unreadCount.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                )),
          IconButton(
              onPressed: () {
                Get.to(const ChangePasswordExpireScreen(
                  isExpired: false,
                ));
              },
              icon: const Icon(
                Icons.vpn_key,
                color: Colors.black54,
              )),
          IconButton(
              onPressed: () {
                logout();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              )),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // _headerView(),
              _renderContent()
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderContent() {
    final user = AppShared.instance.getUserProfile();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          ETextField(
            title: 'Tên tài khoản',
            enable: false,
            value: user.name,
          ),
          ETextField(
            title: 'Mã nhân viên',
            enable: false,
            value: user.code,
          ),
          ETextField(
            title: 'Tên đăng nhập',
            enable: false,
            value: user.username,
          ),
          ETextField(
            title: 'Ngày sinh',
            enable: false,
            value: user.dob.fromFormatUTCToFormat(
                AppStrings.utcFormat, AppStrings.ddMMyyyy),
          ),
          ETextField(
            title: 'Số điện thoại',
            enable: false,
            value: user.phoneNumber,
          ),
          ETextField(
            title: 'Đơn vị',
            enable: false,
            value: user.unitName,
          ),
          ETextField(
            title: 'Phòng ban',
            enable: false,
            value: user.departmentName,
          ),
          const SizedBox(
            height: 16,
          ),
          RButton(
              maxSize: true,
              title: 'Đổi mật khẩu SSO',
              action: () async {
                await openAppSSO('changepassword');
              }),
          const SizedBox(
            height: 16,
          ),
          RButton(
              maxSize: true,
              title: 'Cập nhật hồ sơ',
              action: () async {
                await openAppSSO('updateprofile');
              }),
          const SizedBox(
            height: 16,
          ),
          RButton(
              maxSize: true,
              title: 'Quản lý Email',
              action: () async {
                Get.to(() => const EmailManagerScreen());
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Phiên bản: ${snapshot.data} ${AppEnv.getName()}',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  );
                } else {
                  return Container();
                }
              },
              future: getDeviceInfo(),
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    controller.logout();
  }

  Future<String> getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

