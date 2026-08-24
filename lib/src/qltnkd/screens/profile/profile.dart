// @dart=2.9
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/drawer_app.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/utils/common.dart';
import 'package:evnmobile/src/qltnkd/screens/profile/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_common/utils/utils.dart';

class RProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<RProfileScreen> {
  final controller = RProfileController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: true,
        title: const Text('Hồ sơ cá nhân'),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      drawer: AppDrawer(
        index: 3,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [_renderContent()],
          ),
        ),
      ),
    );
  }

  Widget _renderContent() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          RTextField(
            title: 'Tên tài khoản',
            margin: const EdgeInsets.only(top: 20),
            isEnable: false,
            value: controller.user.name,
          ),
          RTextField(
            title: 'Tên đăng nhập',
            margin: const EdgeInsets.only(top: 20),
            isEnable: false,
            value: controller.user.username,
          ),
          // RTextField(
          //   title: 'Ngày sinh',
          //   isEnable: false,
          //   margin: const EdgeInsets.only(top: 20),
          //   value: controller.user.dob.fromFormatUTCToFormat(
          //       AppStrings.utcFormat, AppStrings.ddMMyyyy),
          // ),
          // RTextField(
          //   title: 'Số điện thoại',
          //   isEnable: false,
          //   margin: const EdgeInsets.only(top: 20),
          //   value: controller.user.phoneNumber,
          // ),
          RTextField(
            title: 'Đơn vị',
            isEnable: false,
            margin: const EdgeInsets.only(top: 20),
            value: controller.user.unitName,
          ),
          RTextField(
            title: 'Phòng ban',
            isEnable: false,
            margin: const EdgeInsets.only(top: 20),
            value: controller.user.departmentName,
          ),
          const SizedBox(height: 16,),
          RButton(
              maxSize: true,
              title: 'Đổi mật khẩu SSO',
              action: () async {
                await openAppSSO('changepassword');
              }),
          const SizedBox(height: 16,),
          RButton(
              maxSize: true,
              title: 'Cập nhật hồ sơ',
              action: () async {
                await openAppSSO('updateprofile');
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: FutureBuilder(
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    'Phiên bản: ${snapshot.data} ${AppEnv.getName()}',
                    style: const TextStyle(
                        fontSize: 16,
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
}

