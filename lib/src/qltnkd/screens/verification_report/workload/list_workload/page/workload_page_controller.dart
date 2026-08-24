// @dart=2.9
import 'package:evnmobile/src/qltnkd/models/workload/workload_model.dart';
import 'package:evnmobile/src/qltnkd/models/workload/workload_handwritten_signature.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/signature/signature_image_helper.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/list_workload/signature/workload_signature_page.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/workload_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../htld/common/utils/progress_h_u_d.dart';
import '../../../../../../htdct/common/utils/snack_bar_h_u_d.dart';
import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../delegate/list_delegate.dart';
import '../../../../../enum/list.dart';
import '../list_workload_controller.dart';

class WorkloadPageController extends GetxController {
  static const _handwrittenSignatureExistsMessage =
      'Phi\u1ebfu \u0111\u00e3 c\u00f3 ch\u1eef k\u00fd tay';

  final isHasLoadMore = false.obs;
  int requestStatus;
  final searchTerm = ''.obs;

  final ListWorkloadController listWorkloadController = Get.find();

  final isShowLoading = false.obs;

  final requests = RxList<WorkloadModel>.empty();

  final repo = WorkloadRepository();

  bool isFirstLoad = false;

  final page = 1.obs;
  ListDelegate delegate;

  Future loadData(ListTypeLoad type) async {
    if (type == ListTypeLoad.loadMore) {
      page.value = page.value + 1;
    } else if (type == ListTypeLoad.load) {
      isShowLoading.value = true;
      page.value = 1;
    } else if (type == ListTypeLoad.refresh) {
      page.value = 1;
    }

    final response = await repo.getListWorkload(
        unitId: listWorkloadController.unit,
        fromDate: listWorkloadController.fromDate,
        toDate: listWorkloadController.toDate,
        status: requestStatus,
        requestType: listWorkloadController.requestTicketType.toString(),
        pageIndex: page.value,
        isBackgroundMode: type == ListTypeLoad.load);

    isFirstLoad = true;

    if (type == ListTypeLoad.loadMore) {
      delegate.onLoadMoreSuccess();
    } else if (type == ListTypeLoad.refresh) {
      requests.clear();
      delegate.onRefreshSuccess();
    } else if (type == ListTypeLoad.load) {
      requests.clear();
    }

    if (response.isLoadSuccess) {
      isShowLoading.value = false;
      requests.addAll(response.data.list);
      requests.refresh();
      update();
      _syncConsultantsImageStatus();
    } else {
      isShowLoading.value = false;
      await rShowDialogOneButton(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  Future sendRequest(String workloadID, {bool isSearch = false}) async {
    final model = requests.firstWhere((e) => e.id == workloadID, orElse: () => null);
    if (model != null && !SignatureImageHelper.isValidConsultantsImage(model.consultantsImage)) {
      await rShowDialogOneButton('Vui lòng ký tay trước khi gửi xác nhận');
      return;
    }
    final res = await repo.sendWorkloadToConfirm(workloadId: workloadID);
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Gửi xác nhận thành công');
      if (isSearch) {
        await search(ListTypeLoad.load);
      } else {
        await loadData(ListTypeLoad.load);
      }
    } else {
      await rShowDialogOneButton(res.message);
    }
  }

  Future openHandwrittenSignature(WorkloadModel model) async {
    // TODO Phase 2: integrate HSM digital signature.
    final detailResponse = await repo.getDetailWorkLoad(
        workloadId: model.id,
        fromDate: listWorkloadController.fromDate,
        toDate: listWorkloadController.toDate);
    if (!detailResponse.isLoadSuccess) {
      await rShowDialogOneButton(detailResponse.message);
      return;
    }

    if (detailResponse.data == null) {
      await rShowDialogOneButton(detailResponse.message);
      return;
    }

    if (SignatureImageHelper.isValidConsultantsImage(detailResponse.data.consultantsImage)) {
      model.consultantsImage = detailResponse.data.consultantsImage;
      await SignatureImageHelper.saveConsultantsImage(
          model.id, detailResponse.data.consultantsImage);
      requests.refresh();
      await _showHandwrittenSignatureExistsDialog();
      return;
    }

    final cachedImage = await SignatureImageHelper.getCachedConsultantsImage(model.id);
    if (cachedImage != null) {
      model.consultantsImage = cachedImage;
      requests.refresh();
      await _showHandwrittenSignatureExistsDialog();
      return;
    }

    final result = await Get.to(() => WorkloadSignaturePage(
      fullName: detailResponse.data.consultants,
      position: detailResponse.data.consultantsPosition,
      note: detailResponse.data.note,
    ));
    if (result is WorkloadHandwrittenSignature) {
      await saveHandwrittenSignature(model, result, detailResponse.data);
    }
  }

  Future saveHandwrittenSignature(
      WorkloadModel model, WorkloadHandwrittenSignature signature,
      [dynamic detail]) async {
    if (detail == null) {
      final detailResponse = await repo.getDetailWorkLoad(
          workloadId: model.id,
          fromDate: listWorkloadController.fromDate,
          toDate: listWorkloadController.toDate);
      if (!detailResponse.isLoadSuccess) {
        await rShowDialogOneButton(detailResponse.message);
        return;
      }
      detail = detailResponse.data;
    }
    if (detail == null) {
      await rShowDialogOneButton('Không tải được dữ liệu phiếu');
      return;
    }
    if (SignatureImageHelper.isValidConsultantsImage(detail.consultantsImage)) {
      model.consultantsImage = detail.consultantsImage;
      await SignatureImageHelper.saveConsultantsImage(model.id, detail.consultantsImage);
      requests.refresh();
      await _showHandwrittenSignatureExistsDialog();
      return;
    }

    detail.consultants = signature.fullName;
    detail.consultantsPosition = signature.position;
    if (signature.note?.isNotEmpty == true) {
      detail.note = signature.note;
    }
    detail.consultantsImage = SignatureImageHelper.toPngDataUri(signature.signatureImageBytes);

    final response = await repo.updateWorkloadSignature(
        workloadId: model.id,
        payload: detail.toJsonUpdateSignature());
    if (response.isLoadSuccess) {
      model.consultantsImage = detail.consultantsImage;
      await SignatureImageHelper.saveConsultantsImage(model.id, detail.consultantsImage);
      requests.refresh();
      SnackBarHUD.show('Lưu chữ ký thành công');
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future _showHandwrittenSignatureExistsDialog() {
    return rShowDialogOneButton(
      _handwrittenSignatureExistsMessage,
      buttonTitle: 'OK',
    );
  }

  Future search(ListTypeLoad type) async {
    if (type == ListTypeLoad.loadMore) {
      page.value = page.value + 1;
    } else if (type == ListTypeLoad.load) {
      isShowLoading.value = true;
      page.value = 1;
    } else if (type == ListTypeLoad.refresh) {
      page.value = 1;
    }

    final response = await repo.getListWorkload(
        pageIndex: page.value, searchTerm: searchTerm.value);

    isFirstLoad = true;

    if (type == ListTypeLoad.loadMore) {
      delegate.onLoadMoreSuccess();
    } else if (type == ListTypeLoad.refresh) {
      requests.clear();
      delegate.onRefreshSuccess();
    } else if (type == ListTypeLoad.load) {
      requests.clear();
    }

    if (response.isLoadSuccess) {
      isShowLoading.value = false;
      requests.addAll(response.data.list);
      requests.refresh();
      update();
      _syncConsultantsImageStatus();
    } else {
      isShowLoading.value = false;
      await rShowDialogOneButton(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  void _syncConsultantsImageStatus() {
    requests?.forEach((model) async {
      final cachedImage = await SignatureImageHelper.getCachedConsultantsImage(model.id);
      if (cachedImage != null &&
          !SignatureImageHelper.isValidConsultantsImage(model.consultantsImage)) {
        model.consultantsImage = cachedImage;
        requests.refresh();
        update();
      }
    });
    final listNeedSync = requests
        ?.where((element) =>
            element?.id != null &&
            !SignatureImageHelper.isValidConsultantsImage(element.consultantsImage))
        ?.toList();
    listNeedSync?.forEach((model) async {
      final detailResponse = await repo.getDetailWorkLoad(
          workloadId: model.id,
          fromDate: listWorkloadController.fromDate,
          toDate: listWorkloadController.toDate);
      if (detailResponse.isLoadSuccess &&
          SignatureImageHelper.isValidConsultantsImage(detailResponse.data?.consultantsImage)) {
        final currentModel = requests.firstWhere(
            (element) => element.id == model.id,
            orElse: () => null);
        if (currentModel != null) {
          currentModel.consultantsImage = detailResponse.data.consultantsImage;
          await SignatureImageHelper.saveConsultantsImage(
              currentModel.id, detailResponse.data.consultantsImage);
          requests.refresh();
          update();
        }
      }
    });
  }

  bool isHasItemSelected() {
    return requests.firstWhere((element) => element.isSelected == true,
            orElse: () => null) !=
        null;
  }

  List<String> _getIds() {
    return requests
        ?.where((element) => element.isSelected == true)
        ?.toList()
        ?.map((e) => e.id)
        ?.toList();
  }

  void selectItem(String workId, {@required bool isChecked}) {
    requests
        .firstWhere((element) => element.id == workId, orElse: () => null)
        .isSelected = isChecked;
    requests.refresh();
  }

  Future approval({bool isSearch = false}) async {
    if (!isHasItemSelected()) {
      await rShowDialogOneButton('Vui lòng chọn ít nhất một phiếu');
      return;
    }
    
    final note = await rShowInputDialog('Xác nhận phiếu KLCV');
    if (note == null) return; // User cancelled

    final result = await repo.approveWorkload(ids: _getIds(), note: note);
    if (result.isLoadSuccess) {
      SnackBarHUD.show('Xác nhận thành công');
      if (isSearch) {
        await search(ListTypeLoad.load);
      } else {
        await loadData(ListTypeLoad.load);
      }
    } else {
      await rShowDialogOneButton(result.message);
    }
  }

  Future reject({bool isSearch = false}) async {
    if (!isHasItemSelected()) {
      await rShowDialogOneButton('Vui lòng chọn ít nhất một phiếu');
      return;
    }
    
    final note = await rShowInputDialog('Từ chối phiếu KLCV');
    if (note == null) return; // User cancelled
    
    final result = await repo.rejectWorkload(ids: _getIds(), note: note);
    if (result.isLoadSuccess) {
      SnackBarHUD.show('Từ chối thành công');
      if (isSearch) {
        await search(ListTypeLoad.load);
      } else {
        await loadData(ListTypeLoad.load);
      }
    } else {
      await rShowDialogOneButton(result.message);
    }
  }

  Future deleteRequest(String id, {bool isSearch = false}) async {
    final result = await repo.deleteRequest(id: id);
    if (result.isLoadSuccess) {
      SnackBarHUD.show('Xóa phiếu thành công');
      if (isSearch) {
        await search(ListTypeLoad.load);
      } else {
        await loadData(ListTypeLoad.load);
      }
    } else {
      await rShowDialogOneButton(result.message);
    }
  }
}

