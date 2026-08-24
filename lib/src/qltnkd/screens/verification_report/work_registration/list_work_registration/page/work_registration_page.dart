// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/list_work_registration_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/widget/item_work_registration.dart';

class WorkRegistrationPage extends StatelessWidget {
  WorkRegistrationPage({Key key}) : super(key: key);

  final ListWorkRegistrationController _controller = Get.find();
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _controller.isLoading.value
          ? const Center(child: CupertinoActivityIndicator())
          : SmartRefresher(
              enablePullDown: true,
              enablePullUp: _controller.canLoadMore.value,
              header: const WaterDropHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = const Text('Kéo lên để tải thêm');
                  } else if (mode == LoadStatus.loading) {
                    body = const CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = const Text('Tải thêm thất bại');
                  } else if (mode == LoadStatus.canLoading) {
                    body = const Text('Thả ra để tải thêm');
                  } else {
                    body = const Text('Không còn dữ liệu');
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: () async {
                await _controller.refreshData();
                _refreshController.refreshCompleted();
              },
              onLoading: () async {
                await _controller.loadMore();
                _refreshController.loadComplete();
              },
              child: _controller.registrations.isEmpty
                  ? const Center(
                      child: Text(
                        'Không có dữ liệu',
                        style: TextStyle(
                            fontSize: TextSize.normal,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _controller.registrations.length,
                      itemBuilder: (context, index) {
                        return ItemWorkRegistration(
                          item: _controller.registrations[index],
                        );
                      },
                    ),
            ),
    );
  }
}
