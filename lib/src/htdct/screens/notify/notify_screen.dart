// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../common/constance/app_color.dart';
import '../../models/notify/notify_model.dart';
import 'notification_page.dart';
import 'send_notification/send_notification.dart';

class NotifyScreen extends StatefulWidget {
  final Function functionCallback;

  const NotifyScreen({Key key, this.functionCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return NotifyState();
  }
}

class NotifyState extends State<NotifyScreen> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final _views = <Widget>[
      NotificationPage(
        type: NotifyModel.type_inbox,
        functionCallback: widget.functionCallback,
      ),
      NotificationPage(
        type: NotifyModel.type_sent,
        functionCallback: widget.functionCallback,
      )
    ];

    return Scaffold(
      appBar: _renderAppbar(),
      backgroundColor: HighElectricAppColor.nature02,
      body: Container(
        color: HighElectricAppColor.bgColor,
        child: TabBarView(
          controller: tabController,
          children: _views,
        ),
      ),
    );
  }

  AppBar _renderAppbar() {
    final _tabs = <Tab>[
      const Tab(text: 'Đã nhận'),
      const Tab(text: 'Đã gửi'),
    ];
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      title: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          'Thông báo',
          style: TextStyle(
              fontSize: 20,
              color: HighElectricAppColor.nature01,
              fontWeight: FontWeight.w600),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(const SendNotification());
          },
          tooltip: 'Gửi phản hồi',
          icon: const Icon(
            Icons.feedback,
            color: Colors.white,
          ),
        )
      ],
      bottom: TabBar(
        isScrollable: false,
        controller: tabController,
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelColor: HighElectricAppColor.nature04,
        labelColor: HighElectricAppColor.orange,
        indicatorColor: HighElectricAppColor.orange,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: _tabs,
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }
}

