// @dart=2.9
import 'package:evnmobile/src/app_common/login/login_controller.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app_common/shared/app_shared.dart';
import '../../common/constance/strings.dart';
import '../grid_management/containers/e_text_form_field.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<ProfileScreen> {
  final controller = AppLoginController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        title: const Text('Thông tin cá nhân'),
        actions: [
          IconButton(
            onPressed: () {
              logout();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
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
    final user = AppShared.instance.getUserProfileDCT();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        children: [
          ETextFormField(
              title: 'Tên tài khoản', value: user.name, readOnly: true),
          ETextFormField(
              title: 'Mã nhân viên', value: user.code, readOnly: true),
          ETextFormField(
              title: 'Tên đăng nhập', value: user.username, readOnly: true),
          ETextFormField(
              title: 'Ngày sinh',
              value: user.dob.fromFormatUTCToFormat(
                  HighElectricStrings.utcFormat, HighElectricStrings.ddMMyyyy),
              readOnly: true),
          ETextFormField(
            title: 'Số điện thoại',
            value: user.phoneNumber,
            readOnly: true,
          ),
          ETextFormField(
            title: 'Đơn vị',
            value: user.unitName,
            readOnly: true,
          ),
          ETextFormField(
            title: 'Đội/phòng',
            value: user.userGroup,
            readOnly: true,
          ),
          ETextFormField(
            title: 'Tổ',
            value: user.userTeam,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  void logout() {
      hShowMyDialogOkCancel('Bạn có chắc muốn đăng xuất không?',
        secondFunction: () {
      controller.logout();
    });
  }
}

