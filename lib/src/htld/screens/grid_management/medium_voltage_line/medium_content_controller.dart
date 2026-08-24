// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/medium_content_branch_controller.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/line_repository.dart';
import 'package:get/get.dart';

import 'common/line_ticket_screen.dart';

mixin LineMediumContentDelegate {
  void updateContentSuccess();
}

class MediumContentController {
  final LineTicketRepository _repository = LineTicketRepository();
  LineTicketController ticketController = Get.find();

  LineMediumContentDelegate delegate;

  final listLineBranchInfo = <LineBranchInfo>[].obs;

  final listController = <MediumContentBranchController>[];

  Future getContent() async {
    if (ticketController.ticketId == null) {
      await showDialogError(
          'Không thể lấy dữ liệu khi chưa tạo công việc kiểm tra.');
      return;
    }

    Future online() async {
      final response = await _repository.getContent(ticketController.ticketId,
          isBackgroundMode: false);
      if (response.isLoadSuccess) {
        listLineBranchInfo.assignAll(response.data);
        listLineBranchInfo.refresh();

        listController.clear();
        listLineBranchInfo?.forEach((element) {
          listController.add(MediumContentBranchController());
        });
      } else {
        await showDialogError(response?.message ?? '');
      }
    }

    void offline() {
      final response =
          LocalDataManager.shared.getLineContent(ticketController.ticketId);

      if (response != null) {
        listLineBranchInfo.assignAll(response);
        listLineBranchInfo.refresh();

        listController.clear();
        listLineBranchInfo?.forEach((element) {
          listController.add(MediumContentBranchController());
        });
      }
    }

    final isHandleDataOnline = await ticketController.isHandleDataOnline();

    if (isHandleDataOnline) {
      await online();
    } else {
      offline();
    }
  }

  // Future updateContent() async {
  //   if (ticketController.ticketId == null) {
  //     await showDialogError('Không thể cập nhật khi chưa tạo công việc kiểm tra.');
  //     return;
  //   }
  //
  //   final branchNotSave = listLineBranchInfo.firstWhere((element) => element.isSaved == true, orElse: () => null);
  //
  //   if(branchNotSave != null){
  //     await showDialogError('Nhánh ${branchNotSave.lineBranchName} chưa được lưu. Vui long kiểm tra lại');
  //
  //     return;
  //   }
  //
  //   //final response = await _repository.updateContent(ticketController.ticketId);
  //   delegate.updateContentSuccess();
  //
  //   // if(response.isLoadSuccess){
  //   //   delegate.updateContentSuccess();
  //   // } else {
  //   //   await showDialogError(response?.message ?? '');
  //   // }
  //
  // }
}

