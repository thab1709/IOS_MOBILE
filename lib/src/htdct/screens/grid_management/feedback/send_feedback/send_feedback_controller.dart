// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../common/enum/notification_type.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../models/work_model.dart';
import '../../../../services/responsitory/feed_back_repository.dart';
import '../../../../services/responsitory/test_plan_repository.dart';
import '../../transformer/transformer_ticket_controller.dart';

class SendFeeBackController extends GetxController {
  final textFieldController = TextEditingController();
  final textFieldControllerSearch = TextEditingController();

  final _workRep = TestPlanRepository();
  final workList = <WorkModel>[].obs;
  List<WorkModel> listWorkOriginal = List.empty();
  final service = FeedbackRepository();
  String workType = '';
  final isCheckAll = false.obs;
  String searchTerm = '';
  final TransformerTicketController transformerTicketController = Get.find();

  Future getWorkList() async {
    ProgressHUD.show();
    workList.clear();
    Future<void> getByPage(int pageIndex) async {

      final res = await _workRep.getWorkList(
          searchTerm: '',
          id: '',
          isBackground: true,
          workType: workType,
          pageSize: 200,
          pageIndex: pageIndex,
          isPMIS: workType != '0');
      if (res.isLoadSuccess) {
        workList.addAll(res.data.list ?? []);
      }
    }

    final res = await _workRep.getWorkList(
        searchTerm: '',
        id: '',
        workType: workType,
        pageSize: 100,
        isBackground: true,
        pageIndex: 1,
        isPMIS: workType != '0');
    if (res.isLoadSuccess) {

      workList.addAll(res.data.list ?? []);
      final totalPage = res.data.paging.totalPages;

      if (totalPage != null && totalPage > 1) {
        final futures = <Future>[];
        for (int i = 2; i < totalPage; i++) {
          futures.add(getByPage(i));
        }
        await Future.wait(futures);
      }

      final item = res.data.list
          .where((element) =>
      element.workId == transformerTicketController.workId)
          ?.first;
      if (item != null) {
        item.isChecked = true;
      }
      listWorkOriginal = workList.value;
      workList.refresh();
      update();
      ProgressHUD.dismiss();
    } else {
      ProgressHUD.dismiss();
      await hShowDialogOneButton(res.message);
    }

  }

  void checkAllWork({@required bool value}) {
    isCheckAll.value = value;
    workList.forEach((element) {
      element.isChecked = value;
    });
    workList.refresh();
    update();
  }

  Future setChecked(WorkModel model) async {
    model.isChecked = !model.isChecked;
    workList.refresh();
    update();
  }

  Future searchData() {
    workList.value = List.from(listWorkOriginal);
    if (!searchTerm.isNullOrBlank()) {
      if (workType == '0') {
        workList.removeWhere((element) =>
            !TiengViet.parse(element.name.toLowerCase())
                .contains(searchTerm.trim().toLowerCase()));
      } else {
        workList.removeWhere((element) =>
            !TiengViet.parse(element.entity.name.toLowerCase())
                .contains(searchTerm.trim().toLowerCase()));
      }
    }

    workList.refresh();
    update();
  }

  Future sendFeedback(
      {
        @required bool isFromPmis,
        @required String ticketId,
      @required bool isHasCreateInspectTicket}) async {
    final listId = [];

    workList.forEach((element) {
      if (element.isChecked) {
        listId.add(element.workId);
      }
    });

    if (listId.isEmpty) {
      await hShowDialogOneButton('Chọn ít nhất 1 kế hoạch kiểm tra');
    } else if (textFieldController.text.isNullOrEmpty()) {
      await hShowDialogOneButton('Nhập nội dung phản hồi');
    } else {
      final response = await service.creatFeedback(params: {
        'workIds': listId,
        'desciption': textFieldController.text,
        'ticketId': ticketId,
        'notificationType': NotificationType.getNotificationType(
            isFromPmis: isFromPmis,
            isHasCreateInspectTicket: isHasCreateInspectTicket)
      });
      if (response.isLoadSuccess) {
        Get.back();
        update();
      } else {
        await hShowDialogOneButton(response.message);
      }
    }
  }
}

