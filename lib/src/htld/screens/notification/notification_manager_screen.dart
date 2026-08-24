// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/screens/notification/notification_manager_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationManagerScreen extends StatefulWidget {
  const NotificationManagerScreen({Key key}) : super(key: key);

  @override
  State<NotificationManagerScreen> createState() =>
      _NotificationManagerScreenState();
}

class _NotificationManagerScreenState extends State<NotificationManagerScreen> {
  final controller = Get.put(NotificationManagerController());
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), controller.refreshAll);
  }

  Future<void> _onRefresh() async {
    await controller.refreshAll();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
        actions: [
          Obx(() => Container(
                margin: const EdgeInsets.only(right: 16),
                alignment: Alignment.center,
                child: controller.unreadCount.value > 0
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${controller.unreadCount.value} chưa đọc',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              )),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.notifications.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.notifications.isEmpty) {
          return SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(
              refresh: Container(),
              complete: const Icon(
                Icons.done,
                color: AppColor.highlightColor70,
              ),
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            child: const Center(child: Text('Chưa có thông báo nào')),
          );
        }
        return SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(
            refresh: Container(),
            complete: const Icon(
              Icons.done,
              color: AppColor.highlightColor70,
            ),
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColor.highlightColor70.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColor.highlightColor70,
                    ),
                  ),
                  title: Text(
                    notification.content ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      notification.createdDate?.fromFormatUTCToFormat(
                              AppStrings.utcFormat, AppStrings.ddmmyyyyHHmm) ??
                          '',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

