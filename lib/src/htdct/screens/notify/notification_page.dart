// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/equipment_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/content/equipment_list/equipment_list_controller.dart'
as night_equipment_list_controller;
import 'package:evnmobile/src/htdct/screens/log_book/operation_logs/operation_log_screen.dart';
import 'package:evnmobile/src/htdct/screens/notify/detail_screen/detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../routes.dart';
import '../../../htld/common/themes/colorx.dart';
import '../../common/constance/strings.dart';
import '../../common/enum/list.dart';
import '../../common/enum/ticket_enum.dart';
import '../../models/day_night/ticket.dart';
import '../../models/notify/notify_model.dart';
import '../grid_management/base/list_delegate.dart';
import '../grid_management/line/tab_check/tunnel_cable_content/tunnel_cable_controller.dart';
import '../grid_management/not_pmis/test_plan/test_plan_screen.dart';
import '../grid_management/transformer/equipment_list/equipment_list_controller.dart';
import '../grid_management/transformer/transformer_ticket_controller.dart';
import 'notify_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage(
      {@required this.type, @required this.functionCallback, Key key})
      : super(key: key);
  final int type;
  final Function functionCallback;

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>
    implements ListDelegate {
  final controller = NotifyController();
  final _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    controller.delegate = this;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.loadData(ListTypeLoad.refresh, typeNotify: widget.type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _renderContent();
  }

  Widget _renderContent() {
    return Obx(() {
      if (controller.isShowLoading.value) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: 40,
                  width: 40,
                  margin: const EdgeInsets.only(top: 30),
                  child: const CircularProgressIndicator(),
                ),
              )
            ],
          ),
        );
      } else {
        return Stack(
          children: [
            if (controller?.notifications?.obs?.value?.isEmpty == true &&
                controller.isFirstLoad)
              const Center(
                child: Text(
                  HighElectricStrings.emptyList,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            _renderList()
          ],
        );
      }
    });
  }

  Widget _renderList() {
    return Column(
      children: [
        Expanded(
          child: SmartRefresher(
            enablePullDown: true,
            enablePullUp: controller.isHasLoadMore.value ?? false,
            header: WaterDropHeader(
              refresh: Container(),
              complete: const Icon(
                Icons.done,
                color: AppColor.highlightColor70,
              ),
            ),
            footer: const ClassicFooter(
              loadStyle: LoadStyle.HideAlways,
              loadingText: '',
              noDataText: '',
              canLoadingText: '',
              failedText: '',
              idleText: '',
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoadMore,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                );
              },
              itemBuilder: (context, index) {
                final model = controller.notifications[index];
                return _buildFeedBackItem(model);
              },
              itemCount: controller.notifications.length,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onRefresh() async {
    await controller.loadData(ListTypeLoad.refresh, typeNotify: widget.type);
  }

  Future<void> _onLoadMore() async {
    await controller.loadData(ListTypeLoad.loadMore, typeNotify: widget.type);
  }

  @override
  void onLoadMoreSuccess() {
    _refreshController.loadComplete();
  }

  @override
  void onRefreshSuccess() {
    _refreshController.refreshCompleted();
  }

  Widget _buildFeedBackItem(NotifyModel model) {
    return GestureDetector(
      onTap: () async {
        await _routerInspect(model);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                '${model.workName == 'null' ? '' : model.workName ?? ''}',
                style: TextStyle(
                    fontWeight: (model.isRead == true ||
                        NotifyModel.type_sent == widget.type)
                        ? FontWeight.normal
                        : FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      (model.entityName?.isNotEmpty == true) ? "${model.entityName} - ${model.description}" :  model.description,
                      style: TextStyle(
                          fontWeight: (model.isRead == true ||
                              NotifyModel.type_sent == widget.type)
                              ? FontWeight.normal
                              : FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(model.getCreateDate()),
            ),
          ],
        ),
      ),
    );
  }

  Future _routerInspect(NotifyModel notifyModel) async {
    if (notifyModel.reportType == NotifyModel.report_type_operation_log) {
      await controller.seenNotify(notifyModel.id);
      if (!notifyModel.checkOperationNoteId.isNullOrBlank()) {
        final transformerTicketController =
            Get.put(TransformerTicketController());

        transformerTicketController.actionTicketType = ActionTicketType.edit;
        transformerTicketController.actionPopupType = ActionTicketType.view;
        unawaited(Get.to(
            () => OperationLogScreen(id: notifyModel.checkOperationNoteId)));
      }

      await controller.loadData(ListTypeLoad.refresh, typeNotify: widget.type);
      widget.functionCallback();
      return;
    }

    if (notifyModel.isDefault == true) {
      await controller.seenNotify(notifyModel.id);
      await Get.to(DetailScreen(id: notifyModel.id));
    } else if (notifyModel.isPMIS == false) {
      await controller.seenNotify(notifyModel.id);
      await Get.deleteAll(force: true);
      Get.put(
          (notifyModel.substationInspectId ??
              notifyModel.lineInspectId ??
              notifyModel.nonInspectId) ??
              '',
          tag: 'ticketIdNotify');
      Get.put(notifyModel.workId ?? '', tag: 'workIdNotify');
      await Get.to(() =>
          TestPlanView(
              ticketIdNotify: notifyModel.substationInspectId ??
                  notifyModel.lineInspectId ??
                  notifyModel.nonInspectId,
              workIdNotify: notifyModel.workId));
    } else if (!notifyModel.isAbnormal) {
      await Get.deleteAll(force: true);
      if (notifyModel.workType == 1) {
        Get.put(TestType.subStation, tag: 'testType');
        Get.put(TicketType.periodicDay, tag: 'ticketType');
        Get.put(notifyModel.substationInspectId ?? '', tag: 'ticketIdNotify');
        Get.put(notifyModel.workId ?? '', tag: 'workIdNotify');
        await controller.seenNotify(notifyModel.id);
      } else if (notifyModel.workType == 2) {
        Get.put(TestType.subStation, tag: 'testType');
        Get.put(TicketType.periodicNight, tag: 'ticketType');
        Get.put(notifyModel.substationInspectId ?? '', tag: 'ticketIdNotify');
        Get.put(notifyModel.workId ?? '', tag: 'workIdNotify');
        await controller.seenNotify(notifyModel.id);
      } else if (notifyModel.workType == 3) {
        Get.put(TestType.line, tag: 'testType');
        Get.put(TicketType.periodicMonth, tag: 'ticketType');
        Get.put(notifyModel.lineInspectId ?? '', tag: 'ticketIdNotify');
        Get.put(notifyModel.workId ?? '', tag: 'workIdNotify');
        await controller.seenNotify(notifyModel.id);
      } else if (notifyModel.workType == 4) {
        Get.put(TestType.line, tag: 'testType');
        Get.put(TicketType.periodicNight, tag: 'ticketType');
        Get.put(notifyModel.lineInspectId ?? '', tag: 'ticketIdNotify');
        Get.put(notifyModel.workId ?? '', tag: 'workIdNotify');
        await controller.seenNotify(notifyModel.id);
      } else if (notifyModel.workType == 5) {
        Get.put(TestType.line, tag: 'testType');
        Get.put(TicketType.tunnelCable, tag: 'ticketType');
        Get.put(notifyModel.lineInspectId ?? '', tag: 'ticketIdNotify');
        Get.put(notifyModel.workId ?? '', tag: 'workIdNotify');
        await controller.seenNotify(notifyModel.id);
      }
      await Get.toNamed(Routes.testPlan);
    } else {
      Get.until((route) => route.settings.name == Routes.homeDCT);
      await Get.deleteAll(force: true);
      final transformerTicketController = TransformerTicketController(
          abnormalNotify: true, titleAbnormalNotify: notifyModel.description);
      transformerTicketController.ticketId = notifyModel.ticketId;
      transformerTicketController.workType = notifyModel.workType;
      transformerTicketController.testType =
      (notifyModel.workType == 1 || notifyModel.workType == 2)
          ? TestType.subStation
          : TestType.line;

      transformerTicketController.ticketType = notifyModel.workType == 1
          ? TicketType.periodicDay
          : (notifyModel.workType == 2 || notifyModel.workType == 4)
          ? TicketType.periodicNight
          : notifyModel.workType == 3
          ? TicketType.periodicMonth
          : TicketType.tunnelCable;
      transformerTicketController.actionTicketType = ActionTicketType.view;
      transformerTicketController.actionPopupType = ActionTicketType.view;
      transformerTicketController.equipmentNameNotify =
          notifyModel.equipmentName;
      transformerTicketController.nodeNameNotify = notifyModel.substationName;
      Get.put(transformerTicketController);

      final model = EquipmentModel();
      model.id = notifyModel.equipmentId;
      model.equipmentCategory = notifyModel.categoryId;
      await controller.seenNotify(notifyModel.id);
      if (notifyModel.workType == 1 || notifyModel.workType == 2) {
        final equipmentController = EquipmentController();
        equipmentController.fromNotify = true;
        equipmentController.categoryId = notifyModel.categoryId;
        unawaited(equipmentController.onRouter(model));
      } else if (notifyModel.workType == 3) {
        final equipmentController =
        night_equipment_list_controller.EquipmentLineController();
        equipmentController.fromNotify = true;
        equipmentController.categoryId = notifyModel.categoryId;
        unawaited(equipmentController.onRouter(model,
            ticketId: notifyModel.ticketId));
      } else if (notifyModel.workType == 5) {
        final tunnelCableContentController = TunnelCableContentController();
        tunnelCableContentController.fromNotify = true;
        unawaited(tunnelCableContentController.onRouter(model,
            ticketId: notifyModel.ticketId));
      } else if (notifyModel.workType == 4) {
        unawaited(Get.toNamed(Routes.nightContentNotify));
      }
    }

    await controller.loadData(ListTypeLoad.refresh, typeNotify: widget.type);
    widget.functionCallback();
  }

  Future refreshWorkList() async {
    await controller.loadData(ListTypeLoad.load,
        typeNotify: NotifyModel.type_inbox);
  }
}

