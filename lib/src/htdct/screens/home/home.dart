// @dart=2.9
import 'package:badges/badges.dart' as badges;
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes.dart';
import '../../../app_common/utils/utils.dart';
import '../../../htdct/common/constance/strings.dart';
import '../../../htdct/common/themes/colorx.dart';
import '../../../htdct/models/tabbar_item.dart';
import '../dashboard/dashboard_screen.dart';
import '../grid_management/grid_management_screen.dart';
import '../log_book/grid_menu/grid_menu_screen.dart';
import '../notify/notify_screen.dart';
import '../profile/profile.dart';
import '../worker_location/list_location_screen.dart';
import 'home_controller.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key key}) : super(key: key);

  @override
  MainState createState() => MainState();
}

class MainState extends State<MainScreen> {
  final profile = AppShared.instance.getUserProfileDCT();
  var _tabs = <TabBarItem>[];
  final _controller = Get.put(HomeCTController());
  GlobalKey globalKey = GlobalKey();
  var _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = <TabBarItem>[
      if (profile.isViewWork())
        TabBarItem(
          title: HighElectricStrings.tabManage,
          icon: const Icon(
            Icons.article_outlined,
          ),
        ),
      TabBarItem(
          title: HighElectricStrings.tabNotify,
          icon: const Icon(
            Icons.notification_important_outlined,
          ),
          badgeIcon: _controller.notifyQuantity > 0
              ? badges.Badge(
                  badgeContent: Text(
                    '${_controller.notifyQuantity > 99 ? '99+' : _controller.notifyQuantity}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  child: const Icon(
                    Icons.notification_important_outlined,
                  ),
                )
              : null),
      if (!profile.isStaff())
        TabBarItem(
          title: HighElectricStrings.tabLocation,
          icon: const Icon(
            Icons.map,
          ),
        ),
      if (profile.isX6 == true)
        TabBarItem(
          title: HighElectricStrings.tabLogBook,
          icon: const Icon(
            Icons.sticky_note_2_outlined,
          ),
        ),
      // if (false)
      TabBarItem(
        title: HighElectricStrings.tabDashboard,
        icon: const Icon(
          Icons.dashboard_outlined,
        ),
      ),
      TabBarItem(
        title: HighElectricStrings.tabProfile,
        icon: const Icon(
          Icons.person,
        ),
      )
    ];

    _controller.getWeather();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.getNotifyQuantityNotSeen();
      final result = await _controller.checkVersionApp();
      if (!result) {
       // await showDialogUpdateApp();
      }
      await updateNotifyQuantity();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            key: globalKey,
            backgroundColor: AppColor.appBackgroundColor,
            activeColor: AppColor.highlightColor70,
            inactiveColor: AppColor.highlightColor,
            iconSize: 25,
            items: _tabs.map((tab) {
              return BottomNavigationBarItem(
                  icon: tab.badgeIcon ?? tab.icon, label: tab.title);
            }).toList(),
            onTap: (value) {
              _tabIndex = value;
            },
          ),
          tabBuilder: (context, index) {
            return _renderTabView(_tabs[index]);
          }),
    );
  }

  CupertinoTabView _renderTabView(TabBarItem item) {
    Widget rootView;
    switch (item.title) {
      case HighElectricStrings.tabManage:
        rootView = GridManagementScreen();
        break;
      case HighElectricStrings.tabNotify:
        rootView = NotifyScreen(
          functionCallback: updateNotifyQuantity,
          key: Routes.notifyScreenKey,
        );
        if ((profile.isViewWork() && _tabIndex == 1) ||
            (!profile.isViewWork() && _tabIndex == 0)) {
          if (Routes.notifyScreenKey.currentState != null &&
              Routes.notifyScreenKey.currentState.tabController != null) {
            // Routes.notifyScreenKey.currentState.controller.loadData(ListTypeLoad.refresh,
            //     typeNotify: NotifyModel.type_inbox);
            Routes.notifyScreenKey.currentState.setState(() {});
            _tabIndex = -1;
          }
        }
        break;
      case HighElectricStrings.tabProfile:
        rootView = ProfileScreen();
        break;
      case HighElectricStrings.tabLogBook:
        if ((profile.isViewWork() && !profile.isStaff() && _tabIndex == 3) ||
            (!profile.isViewWork() && profile.isStaff() && _tabIndex == 0) ||
            (((profile.isViewWork() && profile.isStaff()) ||
                    (!profile.isViewWork() && !profile.isStaff())) &&
                _tabIndex == 2)) {
          rootView = GridMenuScreen();
          _tabIndex = 0;
          break;
        }
        rootView = ProfileScreen();
        break;
      case HighElectricStrings.tabLocation:
        rootView = const ListLocationScreen();
        break;
      case HighElectricStrings.tabDashboard:
        if ((profile.isViewWork() &&
                !profile.isStaff() &&
                profile.isX6 == true &&
                _tabIndex == 4) ||
            (profile.isViewWork() &&
                !profile.isStaff() &&
                profile.isX6 == false &&
                _tabIndex == 3) ||
            (!profile.isViewWork() &&
                profile.isStaff() &&
                profile.isX6 == true &&
                _tabIndex == 2) ||
            (!profile.isViewWork() &&
                profile.isStaff() &&
                profile.isX6 == false &&
                _tabIndex == 0) ||
            (((profile.isViewWork() &&
                        profile.isStaff() &&
                        profile.isX6 == true) ||
                    (!profile.isViewWork() &&
                        !profile.isStaff() &&
                        profile.isX6 == true)) &&
                _tabIndex == 3) ||
            (((profile.isViewWork() &&
                        profile.isStaff() &&
                        profile.isX6 == false) ||
                    (!profile.isViewWork() &&
                        !profile.isStaff() &&
                        profile.isX6 == false)) &&
                _tabIndex == 2)) {
          rootView = DashboardScreen();
          _tabIndex = 0;
          break;
        }
        rootView = ProfileScreen();
        break;
    }
    return CupertinoTabView(
      builder: (context) => rootView,
    );
  }

  Future updateNotifyQuantity() async {
    await _controller.getNotifyQuantityNotSeen();
    final tabNotify = _tabs
        .where((element) => element.title == HighElectricStrings.tabNotify)
        .first;
    tabNotify.badgeIcon = (_controller?.notifyQuantity ?? 0) != 0
        ? badges.Badge(
            badgeContent: Text(
              '${_controller.notifyQuantity > 99 ? '99+' : _controller.notifyQuantity}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            child: const Icon(
              Icons.notification_important_outlined,
            ),
          )
        : const SizedBox();
    if(mounted) {
      setState(() {});
    }
  }

  void onChangeTabIndex({int tabIndex = 0}) {
    final CupertinoTabBar cupertinoTabBar = globalKey.currentWidget;
    cupertinoTabBar.onTap(tabIndex);
  }
}

