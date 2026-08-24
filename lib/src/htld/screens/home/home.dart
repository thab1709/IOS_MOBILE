// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/screens/grid_management/grid_management_screen.dart';
import 'package:evnmobile/src/htld/screens/worker_location/list_location_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/constance/strings.dart';
import '../../common/themes/colorx.dart';
import '../../models/tabbar_item.dart';
import '../profile/profile.dart';
import 'home_controller.dart';

class MainScreen extends StatefulWidget {
  @override
  MainState createState() => MainState();
}

class MainState extends State<MainScreen> {
  final homeController = HomeController();
  final _userProfile = AppShared.instance.getUserProfile();
  var _tabs = <TabBarItem>[];

  @override
  void initState() {
    super.initState();
    homeController.checkVersionApp();
    _tabs = <TabBarItem>[
      TabBarItem(
        title: AppStrings.tabBarListWorkTitle,
        icon: const Icon(
          Icons.assignment_outlined,
        ),
      ),
      // if(_userProfile?.position != UserRole.worker)
      TabBarItem(
        title: AppStrings.tabBarLocationTitle,
        icon: const Icon(
          Icons.location_on_outlined,
        ),
      ),

      TabBarItem(
        title: AppStrings.tabBarProfileTitle,
        icon: const Icon(
          Icons.perm_identity_outlined,
        ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: AppColor.appBackgroundColor,
            activeColor: AppColor.highlightColor,
            inactiveColor: AppColor.inActiveColor,
            iconSize: 25,
            items: _tabs.map((tab) {
              return BottomNavigationBarItem(
                  icon: tab.icon,
                  // ignore: deprecated_member_use
                  label: tab.title);
            }).toList(),
          ),
          tabBuilder: (context, index) {
            return _renderTabView(_tabs[index]);
          }),
    );
  }

  CupertinoTabView _renderTabView(TabBarItem item) {
    Widget rootView;
    switch (item.title) {
      case AppStrings.tabBarListWorkTitle:
        rootView = GridManagementScreen();
        break;
      case AppStrings.tabBarLocationTitle:
        rootView = const ListLocationScreen();
        break;
      case AppStrings.tabBarProfileTitle:
        rootView = ProfileScreen();
        break;
    }
    return CupertinoTabView(
      builder: (context) => rootView,
    );
  }
}

