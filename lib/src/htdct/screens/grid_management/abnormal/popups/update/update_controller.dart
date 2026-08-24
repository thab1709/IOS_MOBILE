// @dart=2.9
import 'dart:io';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:get/get.dart';

import '../../../../../../app_common/shared/app_shared.dart';
import '../../../../../../qltnkd/services/responsitory/images_repository.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/constance/work_status.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../models/abnormal/abnormal_model.dart';
import '../../../../../models/day_night/popups/images_model.dart';
import '../../../../../models/option_model.dart';
import '../../../../../services/responsitory/abnormal_repository.dart';
import '../../../../../services/server_response.dart';

class UpdateController extends GetxController {
  UpdateController() {
    listUser.assignAll(AppShared.instance
        .getListUser()
        .map((e) => OptionModelString(e.name, e.id)));
    listUser.refresh();
  }

  Rx<AbnormalModel> model = AbnormalModel().obs;
  final _abnormalRep = AbnormalRepository();
  final imageService = ImageRepository();
  var isAbnormal = false;

  List<OptionModel> listStatus = [
    OptionModel('Chưa xử lý', HWorkStatus.notImplement),
    OptionModel('Đã xử lý', HWorkStatus.implementing),
  ];

  RxList<OptionModelString> listUser = RxList.empty();
  RxBool invalid = false.obs;

  Future getDetail(String id) async {
    final res = await _abnormalRep.getAbnormalDetail(id: id);
    if (res.isLoadSuccess) {
      model.value.id = res.data.model.id;
      model.value.violateId = res.data.model.violateId;
      model.value.date = DateTime.now().toString();
      model.value.content = res.data.model.content;
      model.value.imageProblem = res.data.model.images ?? [];
      model.value.userId = res.data.model.userId;
      model.value.status = isAbnormal ? res.data.model.trackingStatus : res.data.model.statusId;
      model.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future updateAbnormal() async {
    if (!checkValid()) {
      invalid.value = true;
      invalid.refresh();
      await hShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
      return;
    }
    model.value.date = DateTime.parse(model.value.date)
        .toStringFormat(HighElectricStrings.yyyyMMddHHmm, isUtc: true);
    ServerResponse<dynamic> res;
    if(isAbnormal) {
      res = await _abnormalRep.updateViolate(params: model.value.toJsonViolate());
    } else {
    res = await _abnormalRep.updateAbnormal(params: model.value.toJson());
    }

    if (res.isLoadSuccess) {
      Get.back();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  //
  Future removeImage(Images image) async {
    model.value.imageProblem.remove(image);
    model.refresh();
  }

  //
  Future uploadImage(List<File> files) async {
    final response = await imageService.upload(files);

    if (response.isLoadSuccess) {
      for (var i = 0; i < response.data.length; i++) {
        model.value.imageProblem.add(Images(
            problems: 0,
            name: response.data[i].name,
            imageStorageId: response.data[i].imageStorageId,
            url: response.data[i].url));
      }
      model.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  bool checkValid() {
    if (model.value.status == null ||
        model.value.date == null ||
        model.value.userId == null ||
        model.value.content == null) {
      return false;
    }
    return true;
  }
}

