// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htdct/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/models/result_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../../../../routes.dart';
import '../../../../../../app_common/utils/utils.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../common/utils/common.dart';
import '../../../../../services/request_model/post_result_request.dart';
import '../../../../../services/responsitory/tba_repository.dart';
import '../../transformer_ticket_controller.dart';

class ConcludeController extends GetxController {
  final timeController = TextEditingController();
  Rx<TextEditingController> timeController2 = TextEditingController().obs;
  DateTime fromDateTime = DateTime.now().subtract(const Duration(days: 10));
  DateTime toDateTime = DateTime.now();
  RxString fromDate = ''.obs;
  RxString toDate = ''.obs;
  final _tbaRep = TBARepository();
  final result = ResultModel().obs;
  final TransformerTicketController transformerTicketController = Get.find();
  final invalid = false.obs;

  DateTime clickTime;


  Future getResult() async {
    final res = await _tbaRep.getResult(
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType);
    if (res.isLoadSuccess) {
      result.value = res.data.resultModel;
      if (transformerTicketController.testType == TestType.line) {
        result.value.dueDate = result.value.settlementTime;
        result.value.substationSituation = result.value.lineStatus;
        result.value.solution = result.value.suggestionSolution;
      }
      if (transformerTicketController.testType == TestType.subStation &&
          result.value.substationSituation.isNullOrBlank()) {
        result.value.substationSituation = result.value.voltageCabinetsResult;
      }
      timeController.text = result.value.dueDate
          .fromFormatUtcToFormatLocal(HighElectricStrings.ddMMyyyy);
      timeController2.value.text =
          '${result.value.updateBy} - ${result.value.updatedTime.fromFormatUtcToFormatLocal(HighElectricStrings.hhmmddMMyyyy)}';
      update();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future<bool> postResult({bool isBackground = false}) async {
    if (!checkValid()) {
      final error = [];
      if (result.value.substationSituation.isNullOrEmpty()) {
        error.add(
            'Tình hình ${transformerTicketController.testType == TestType.subStation ? 'trạm' : 'đường dây'}');
      }
      if (result.value.solution.isNullOrBlank()) {
        error.add('Biện pháp đề nghị giải quyết các tồn tại');
      }
      if (result.value.dueDate.isNullOrBlank()) {
        error.add('Thời gian giải quyết các tồn tại');
      }
      await hShowDialogOneButton(
          'Bạn cần nhập đủ các trường ${error.map((e) => e).join(', ')}');
      return false;
    }
    var request = PostResultRequest.createRequest(
        substationSituation: result.value.substationSituation,
        solution: result.value.solution,
        dueDate: result.value.dueDate);

    if (transformerTicketController.testType == TestType.line) {
      request = PostResultRequest.createRequestLine(
          lineStatus: result.value.substationSituation,
          suggestionSolution: result.value.solution,
          settlementTime: result.value.dueDate);
    }

    final res = await _tbaRep.postResult(
        ticketId: transformerTicketController.ticketId,
        testType: transformerTicketController.testType,
        isBackground: isBackground,
        request: request);

    if (res.isLoadSuccess) {
      await getResult();
      invalid.refresh();
      if (!isBackground) {
        SnackBarHUD.show('Lưu kết luận thành công');
      }
      return true;
    } else {
      await hShowDialogOneButton(res.message);
    }
    return false;
  }

  Future<bool> completeTicket() async {

    if(!isClickAble((p0) => clickTime = p0, clickTime)) {
      return false;
    }

    ProgressHUD.show();
    final updateResult = await postResult(isBackground: true);

    if (updateResult) {
      final location = await getCurrentPosition();
      if (location?.isMocked == true) {
        ProgressHUD.dismiss();
        await hShowDialogOneButton('${HighElectricStrings.isMockedLocation}');
        return false;
      }
      await transformerTicketController.sendLocation();
      final res = await _tbaRep.completeTicket(
          ticketId: transformerTicketController.ticketId,
          testType: transformerTicketController.testType,
          isBackground: true);
      ProgressHUD.dismiss();
      if (res.isLoadSuccess) {
        Get.until((route) => [Routes.testPlan].contains(route.settings.name));
        SnackBarHUD.show('Hoàn thành công việc kiểm tra thành công');
        return true;
      } else {
        await hShowDialogOneButton(res.message);
        return false;
      }
    } else {
      ProgressHUD.dismiss();
    }
    return false;
  }

  bool isEnableFinishBtn() {
    if (result?.value?.isAbnormal == false && result?.value?.isAllowComplete == true) {
      return true;
    }

    if (result.value.isAllowComplete == false ||
        result.value.substationSituation.isNullOrEmpty() ||
        result.value.solution.isNullOrBlank() ||
        result.value.dueDate.isNullOrBlank()) {
      return false;
    }

    return true;
  }

  bool checkValid() {
    //isAbnormal == false else not required;
    if(result?.value?.isAbnormal == false) {
      return true;
    }
    if (result.value.substationSituation.isNullOrEmpty() ||
        (result.value.dueDate.isNullOrBlank() ||
            result.value.solution.isNullOrBlank())) {
      invalid.value = true;
      invalid.refresh();
      return false;
    }
    return true;
  }

  void refreshView() {
    invalid.refresh();
  }
}

