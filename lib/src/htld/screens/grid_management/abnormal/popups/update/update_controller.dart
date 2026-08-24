// @dart=2.9
import 'dart:io';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:get/get.dart';

import '../../../../../common/constance/abnormal_constance.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../models/abnormal/abnormal_model.dart';
import '../../../../../models/abnormal/attach_image_model.dart';
import '../../../../../models/option_model.dart';
import '../../../../../services/responsitory/abnormal_repository.dart';
import '../../../../../services/responsitory/upload_service.dart';

class UpdateController extends GetxController {
  Rx<TAbnormalModel> model = TAbnormalModel().obs;
  final _abnormalRep = TAbnormalRepository();
  final imageService = UploadService();
  bool isAbnormal = false;

  List<OptionModel> listStatus = [
    OptionModel('Chưa xử lý', AbnormalStatus.notImplement),
    OptionModel('Đã xử lý', AbnormalStatus.implementing),
  ];

  RxList<OptionModelString> listUser = RxList.empty();
  RxList<OptionModelString> listDistributeDay = RxList.empty();
  RxList<OptionModelString> listDistributeNight = RxList.empty();
  RxList<OptionModelString> listInediateNight = RxList.empty();
  RxBool invalid = false.obs;

  Future getDetail(String id) async {
    final res =
        await _abnormalRep.getAbnormalDetail(id: id, isBackground: true);
    if (res.isLoadSuccess) {
      model.value.id = id;
      model.value.date = DateTime.now().toString();
      model.value.content = res.data.model.contentHandle;
      model.value.imageProblem = res.data.model.images ?? List.empty(growable: true);
      model.value.userId = res.data.model.userHandleId;
      model.value.status = res.data.model.status;
      model.refresh();
    } else {
      await showDialogOneButton(res.message);
    }
  }

  Future updateAbnormal() async {
    if (!checkValid()) {
      invalid.value = true;
      invalid.refresh();
      await showDialogOneButton(AppStrings.requireUpdatePopupText);
      return;
    }
    model.value.date = DateTime.parse(model.value.date)
        .toStringFormat(AppStrings.yyyyMMddHHmm, isUtc: true);
    final res = await _abnormalRep.updateAbnormal(params: model.value.toJson());

    if (res.isLoadSuccess) {
      Get.back();
    } else {
      await showDialogOneButton(res.message);
    }
  }

  //
  Future removeImage(TImages image) async {
    model.value.imageProblem.remove(image);
    model.refresh();
  }

  //
  Future uploadImage(File file) async {
    final response = await imageService.upload(file);

    if (response.isLoadSuccess) {
      final image = TImages(
          imageStorageId: response.data.imageStorageId,
          url: response.data.url,
      );
      model.value.imageProblem.add(image);
      model.refresh();
    } else {
      await showDialogOneButton(response.message);
    }
  }

  Future getUser() async {
    final res = await _abnormalRep.getUsersHandle(isBackground: true);
    if (res.isLoadSuccess) {
      listUser.assignAll(res.data);
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

