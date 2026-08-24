// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/validator/auth_validator.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/screens/change_password/change_password_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class RChangePasswordExpireScreen extends StatefulWidget {
  const RChangePasswordExpireScreen({this.isExpired = true});

  final bool isExpired;

  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordExpireState();
  }
}

class _ChangePasswordExpireState extends State<RChangePasswordExpireScreen> {
  final _usernameController = TextEditingController();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _retypePasswordController = TextEditingController();

  final _keyUsername = GlobalKey<FormState>();
  final _keyOldPassword = GlobalKey<FormState>();
  final _keyNewPassword = GlobalKey<FormState>();
  final _keyRetypePassword = GlobalKey<FormState>();

  final _controller = ChangePasswordController();
  String username = '';

  @override
  void initState() {
    username = Get.arguments;
    super.initState();
    _usernameController.text = username;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: RAppColor.highlightColor70,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text(
          'Đổi mật khẩu',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (widget.isExpired)
                  const SizedBox(width: double.infinity, height: 24),
                if (widget.isExpired)
                  Form(
                      key: _keyUsername,
                      child: TextFormField(
                        controller: _usernameController,
                        onChanged: (value) {
                          _keyUsername.currentState.validate();
                        },
                        validator: (value) => AuthValidator().userName(value),
                        decoration: const InputDecoration(
                            labelText: AppStrings.usernamePlaceholder,
                            hintText: AppStrings.usernamePlaceholder,
                            border: OutlineInputBorder()),
                      )),
                const SizedBox(width: double.infinity, height: 24),
                Form(
                  key: _keyOldPassword,
                  child: TextFormField(
                    controller: _oldPasswordController,
                    onChanged: (value) {
                      _keyOldPassword.currentState.validate();
                    },
                    validator: (value) => AuthValidator().passwordEmpty(value),
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: AppStrings.oldPassword,
                        hintText: AppStrings.oldPassword,
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: double.infinity, height: 24),
                Form(
                  key: _keyNewPassword,
                  child: TextFormField(
                    controller: _newPasswordController,
                    onChanged: (value) {
                      _keyNewPassword.currentState.validate();
                    },
                    validator: (value) => AuthValidator().password(value),
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: AppStrings.newPassword,
                        hintText: AppStrings.newPassword,
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: double.infinity, height: 24),
                Form(
                  key: _keyRetypePassword,
                  child: TextFormField(
                    controller: _retypePasswordController,
                    onChanged: (value) {
                      _keyRetypePassword.currentState.validate();
                    },
                    validator: (value) => AuthValidator()
                        .retypePassword(value, _newPasswordController.text),
                    obscureText: true,
                    decoration: const InputDecoration(
                        labelText: AppStrings.retypePassword,
                        hintText: AppStrings.retypePassword,
                        border: OutlineInputBorder()),
                  ),
                ),
                const SizedBox(width: 1, height: 10),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.only(top: 30),
                  child: RButton(
                      title: AppStrings.submitButton,
                      action: () {
                        if (widget.isExpired) {
                          if (_keyUsername.currentState.validate() &&
                              _keyOldPassword.currentState.validate() &&
                              _keyNewPassword.currentState.validate() &&
                              _keyRetypePassword.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            _controller.changePasswordExpired(
                                _usernameController.text,
                                _oldPasswordController.text,
                                _newPasswordController.text,
                                _retypePasswordController.text);
                          }
                        } else {
                          if (_keyOldPassword.currentState.validate() &&
                              _keyNewPassword.currentState.validate() &&
                              _keyRetypePassword.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            _controller.changePassword(
                                _oldPasswordController.text,
                                _newPasswordController.text,
                                _retypePasswordController.text);
                          }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

