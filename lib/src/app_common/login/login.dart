// @dart=2.9
import 'package:evnmobile/src/app_common/rescource/images_common.dart';
import 'package:evnmobile/src/app_common/rescource/strings_common.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/validator/auth_validator.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../app_env.dart';
import '../../../routes.dart';
import '../enum/app_code.dart';
import '../utils/utils.dart';
import 'login_controller.dart';

class AppLoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppLoginScreenState();
  }
}

class _AppLoginScreenState extends State<AppLoginScreen>
    implements ChangePasswordExpired {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keyUsername = GlobalKey<FormState>();
  final _keyPassword = GlobalKey<FormState>();
  final AppLoginController _controller = Get.put(AppLoginController());
  final ssoMethodChanel = const MethodChannel('com.evn.pmis/ssoWeb');

  @override
  void initState() {
    super.initState();

    _usernameController.text = AppShared.instance.getUserName();
    _passwordController.text = AppShared.instance.getUserPassword();
    _controller.listener = this;
    _controller.getDeviceInfo();

    ssoMethodChanel.setMethodCallHandler((call) async {
      String appCode;
      if (AppShared.instance.getAppType() == AppType.KDTN) {
        appCode = AppCode.KDTN;
      } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
        appCode = AppCode.CAOTHE;
      } else {
        return;
      }

      String arguments = call.arguments ?? '';
      var ticket = '';
      try {
        final uri = Uri.parse(arguments);
        ticket = uri.pathSegments.firstOrNull;
      } catch (e) {}

      if (ticket.isNotNullOrEmpty() && _controller.loginInWebSSO) {
        _controller.updateStatusLoginSSO(status: false);
        await _controller.login(ticket: ticket, appCode: appCode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildContent(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.updateStatusLoginSSO(status: false);
    super.dispose();
  }

  Widget _buildContent() {
    final isLargeScreen = Get.size.width >= 600;

    var moduleNameSelected = '';
    if (AppShared.instance.getAppType() == AppType.HTLDTT) {
      moduleNameSelected = StringsCommon.moduleName2;
    } else if (AppShared.instance.getAppType() == AppType.HTDCT) {
      moduleNameSelected = StringsCommon.moduleName3;
    } else if (AppShared.instance.getAppType() == AppType.HTLDHT) {
      moduleNameSelected = StringsCommon.moduleName4;
    } else {
      moduleNameSelected = StringsCommon.moduleName1;
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: isLargeScreen ? 100 : 20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: isLargeScreen ? 90 : 30,
                        ),
                        Container(
                            width: isLargeScreen ? 400 : 250,
                            height: isLargeScreen ? 150 : 130,
                            child: Image.asset(
                              ImagesCommon.evnLodoHighElectric,
                              fit: BoxFit.contain,
                            )),
                        SizedBox(
                          height: isLargeScreen ? 60 : 20,
                        ),
                        Text(
                          moduleNameSelected.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColor.highlightColor70,
                              fontSize: isLargeScreen ? 26 : 20,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: isLargeScreen ? 60 : 30,
                        ),
                        Form(
                            key: _keyUsername,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    AppStrings.usernamePlaceholder,
                                    style: TextStyle(
                                        color: AppColor.inActiveColor,
                                        fontSize: 16),
                                  ),
                                ),
                                TextFormField(
                                  controller: _usernameController,
                                  onChanged: (value) {
                                    _keyUsername.currentState.validate();
                                  },
                                  validator: (value) =>
                                      AuthValidator().userName(value),
                                  decoration: InputDecoration(
                                      prefixIcon: Container(
                                          padding: const EdgeInsets.all(12),
                                          child: SvgPicture.asset(
                                              ImagesCommon.icUser)),
                                      // labelText: AppStrings.usernamePlaceholder,
                                      hintText: AppStrings.usernamePlaceholder,
                                      border: const OutlineInputBorder()),
                                ),
                              ],
                            )),
                        SizedBox(
                            width: double.infinity,
                            height: isLargeScreen ? 30 : 24),
                        Form(
                          key: _keyPassword,
                          child: Obx(() => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      AppStrings.passwordPlaceholder,
                                      style: TextStyle(
                                          color: AppColor.inActiveColor,
                                          fontSize: 16),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _passwordController,
                                    onChanged: (value) {
                                      _keyPassword.currentState.validate();
                                    },
                                    validator: (value) =>
                                        AuthValidator().passwordEmpty(value),
                                    obscureText:
                                        !_controller.isShowPassword.value,
                                    decoration: InputDecoration(
                                        prefixIcon: Container(
                                          padding: const EdgeInsets.all(12),
                                          child: SvgPicture.asset(
                                            ImagesCommon.icPassword,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                            icon: Icon(
                                              Icons.remove_red_eye,
                                              color: _controller
                                                      .isShowPassword.value
                                                  ? AppColor.highlightColor70
                                                  : AppColor.borderColor1,
                                            ),
                                            onPressed: () {
                                              _controller.togglePassword();
                                            }),
                                        // labelText: AppStrings.passwordPlaceholder,
                                        hintText:
                                            AppStrings.passwordPlaceholder,
                                        border: const OutlineInputBorder()),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(width: 1, height: isLargeScreen ? 30 : 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(
                              () => Checkbox(
                                  value: _controller.savePassword.value,
                                  onChanged: (value) {
                                    _controller.savePasswordOnChange(
                                        isSave: value);
                                  }),
                            ),
                            const Text(
                              AppStrings.savePassword,
                              style: TextStyle(
                                  color: AppColor.inActiveColor, fontSize: 16),
                            ),
                          ],
                        ),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(top: 20),
                          child: EButton(
                              title: AppStrings.loginButtonTitle,
                              action: () {
                                if (_keyUsername.currentState.validate() &&
                                    _keyPassword.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _controller.login(
                                      username: _usernameController.text,
                                      password: _passwordController.text);
                                }
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        OutlinedButton(
                            onPressed: () async {
                              await openAppSSO('loginSSO');
                            },
                            child: const Text('Đăng nhập SSO')),
                        const SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.selectModule);
                            },
                            child: const Text(
                              StringsCommon.selectModule,
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            ))
                      ],
                    ),
                  ),
                ),
                KeyboardVisibilityBuilder(
                    builder: (context, isKeyboardVisible) {
                  if (isKeyboardVisible) {
                    return Container();
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                              'Phiên bản: ${_controller.appVersionName} ${AppEnv.getName()}',
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54),
                            )),
                        const SizedBox(width: 1, height: 10),
                      ],
                    );
                  }
                })
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onChangePasswordExpiredSuccess() {
    _passwordController.text = AppShared.instance.getUserPassword();
    setState(() {});
  }
}

