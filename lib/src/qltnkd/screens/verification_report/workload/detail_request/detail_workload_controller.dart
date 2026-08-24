// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../list_workload/signature/signature_image_helper.dart';

import '../../../../../htld/models/profile_model.dart';
import '../../../../../htld/services/location_background_service.dart';
import '../../../../common/constance/report_work_status_type.dart';
import '../../../../common/constance/strings.dart';
import '../../../../common/utils/connection.dart';
import '../../../../dialog/popup.dart';
import '../../../../models/create_report_not_plan_model.dart';
import '../../../../models/form_report_copy_model.dart';
import '../../../../models/option_model.dart';
import '../../../../models/workload/confirm_mass_scene_schedules.dart';
import '../../../../models/workload/create_workload_request.dart';
import '../../../../models/workload/detail_workload_model.dart';
import '../../../../models/workload/request_model.dart';
import '../../../../models/workload/workload_model.dart';
import '../../../../offline_service/local_data_manager.dart';
import '../../../../services/responsitory/merge_form_report_repository.dart';
import '../../../../services/responsitory/report_repository.dart';
import '../../../../services/responsitory/workload_repository.dart';
import '../../list_work/copy_report/copy_report_screen.dart';
import '../../report/bb_cong_to/bb_cong_to.dart';
import '../../report/report_screen.dart';
import '../common/constance_workload.dart';
import '../list_request/list_request_controller.dart';

class DetailWorkloadController extends GetxController {
  final workloadRequestModel = WorkloadRequestModel();
  final timeController = TextEditingController();
  final _repo = WorkloadRepository();
  UserProfileModel userProfile = AppShared.instance.getUserProfile();
  DetailWorkloadModel detailWorkloadModel;
  final isLoaded = false.obs;
  bool isEdit = false;
  final serviceMergeReport = MergerFormReportRepository();
  final service = ReportRepository();

  RequestModel requestModel;
  final works = <ConfirmMassSceneSchedules>[].obs;
  final isCheckAll = false.obs;
  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  List<StringOptionModel> equipmentTypes = RxList.empty();
  final ListRequestController listWorkloadController = Get.find();

  void setCheckAllWorks({bool value}) {
    works.forEach((element) {element.isChecked = value;});
    isCheckAll.value = value;
    isCheckAll.refresh();
    works.refresh();
  }


  Future setupData(
      RequestModel requestModel, WorkloadModel workloadModel) async {
    this.requestModel = requestModel;
    await getDataEquipmentReport();
    if (requestModel != null) {
      initData();
      await getListWork(requestModel.id);
    } else {
      await getDetailWorkLoad(workloadModel.id);
    }
    _setHasEdit();
    isLoaded.value = true;
  }

  void _setHasEdit() {
    if (requestModel != null) {
      isEdit = true;
    } else if (detailWorkloadModel.status == WorkloadStatusCode.newWork ||
        detailWorkloadModel.status == WorkloadStatusCode.reject) {
      isEdit = true;
    } else {
      isEdit = false;
    }
  }

  void initData() {
    isEdit = true;
    workloadRequestModel.requestId = requestModel.id;
    workloadRequestModel.date =
        DateTime.now().toStringFormat(RAppStrings.utcFormatNotZ, isUtc: true);
    workloadRequestModel.userRepresent = requestModel.unitName;
    workloadRequestModel.location = requestModel.unitName;
    workloadRequestModel.username = requestModel.userName;
    workloadRequestModel.userPosition = requestModel.userPosition;
    workloadRequestModel.performer = userProfile.name;
    workloadRequestModel.performerPosition =
        userProfile?.roleNames?.firstOrNull;
    workloadRequestModel.performerRepresent =
        'Công ty thí nghiệm điện lực Hà Nội';
    timeController.text = workloadRequestModel.date
        .fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy);
  }

  void _initDataEdit() {
    workloadRequestModel.username = detailWorkloadModel.username;
    workloadRequestModel.userRepresent = detailWorkloadModel.userRepresent;
    workloadRequestModel.userPosition = detailWorkloadModel.userPosition;

    workloadRequestModel.consultants = detailWorkloadModel.consultants;
    workloadRequestModel.location = detailWorkloadModel.location;
    workloadRequestModel.consultantsPosition =
        detailWorkloadModel.consultantsPosition;
    workloadRequestModel.consultantsRepresent =
        detailWorkloadModel.consultantsRepresent;
    workloadRequestModel.consultantsImage =
        detailWorkloadModel.consultantsImage;

    workloadRequestModel.performer = detailWorkloadModel.performer;
    workloadRequestModel.performerPosition =
        detailWorkloadModel.performerPosition;
    workloadRequestModel.performerRepresent =
        detailWorkloadModel.performerRepresent;

    workloadRequestModel.note =
        detailWorkloadModel.note;
  }

  Future createRequest() async {
    final messageError = workloadRequestModel.validate();
    if (messageError != null) {
      await rShowDialogOneButton(messageError);
      return;
    }

    if(!isHasWorkSelected()){
      await rShowDialogOneButton('Vui lòng chọn ít nhất một công việc');
      return;
    }
    workloadRequestModel.schedules =
        getWorksSelected().map((element) =>
        Schedules(scheduleId: element.id, reason: element.reason, note: element.note))
        .toList();
      final res = await _repo.createRequest(workloadRequestModel);
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Tạo yêu cầu thành công');
      await getDetailWorkLoad(res.data);
      requestModel = null;
      isLoaded.refresh();
      update();
    } else {
      await rShowDialogOneButton(res?.message ?? '');
    }
  }

  Future getDetailWorkLoad(String workloadId) async {
    final res = await _repo.getDetailWorkLoad(workloadId: workloadId, fromDate: listWorkloadController.fromDate, toDate: listWorkloadController.toDate);
    if (res.isLoadSuccess) {
      detailWorkloadModel = res.data;
      timeController.text = detailWorkloadModel.date
          .fromFormatUtcToFormatLocalNotZ(RAppStrings.ddMMyyyy);
      _initDataEdit();
      works.assignAll(res.data.confirmMassSceneSchedules);
      works.refresh();
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future getListWork(String requestId) async {
    final res = await _repo.getListWork(requestId, listWorkloadController.fromDate, listWorkloadController.toDate);

    if (res.isLoadSuccess) {
      works.assignAll(res.data);
      works.refresh();
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future updateRequest() async {
    final messageError = workloadRequestModel.validate();
    if (messageError != null) {
      await rShowDialogOneButton(messageError);
      return;
    }

    if(!isHasWorkSelected()){
      await rShowDialogOneButton('Vui lòng chọn ít nhất một công việc');
      return;
    }
    workloadRequestModel.schedules = getWorksSelected()
        .map((element) =>
            Schedules(scheduleId: element.id, reason: element.reason, note: element.note))
        .toList();
    final res = await _repo.updateWorkload(
        workloadRequestModel: workloadRequestModel,
        workloadId: detailWorkloadModel.id);
    if (res.isLoadSuccess) {
      checkShowBtnSend();
      SnackBarHUD.show('Lưu thành công');
    } else {
      await rShowDialogOneButton(res.message);
    }
  }

  void checkShowBtnSend() {
    final workNotHandle = works.firstWhereOrNull((p0) =>
        p0.status == ReportWorkStatusType.unfulfilled &&
        (p0.reason == null || p0.reason.isEmpty));
    if (workNotHandle == null) {
      detailWorkloadModel.isAllowSend = true;
      isLoaded.refresh();
      update();
    }
  }

  Future sendRequest() async {
    if (!SignatureImageHelper.isValidConsultantsImage(detailWorkloadModel?.consultantsImage)) {
      await rShowDialogOneButton('Vui lòng ký tay trước khi gửi xác nhận');
      return;
    }
    final res =
        await _repo.sendWorkloadToConfirm(workloadId: detailWorkloadModel.id);
    if (res.isLoadSuccess) {
      SnackBarHUD.show('Gửi xác nhận thành công');
      detailWorkloadModel.status = WorkloadStatusCode.waitConfirm;

      isLoaded.refresh();
      _setHasEdit();
      works.refresh();
    } else {
      await rShowDialogOneButton(res.message);
    }
  }

  Future setWorkReason(ConfirmMassSceneSchedules work, String reason) async {
    work.reason = reason;
    works.refresh();
  }

  Future setWorkNote(ConfirmMassSceneSchedules work, String note) async {
    work.note = note;
    works.refresh();
  }

  Future setCheckedWork(ConfirmMassSceneSchedules work, {bool checked}) async {
    work.isChecked = checked;
    if(works.any((element) => element.isChecked == null || element.isChecked == false)) {
      isCheckAll.value = false;
    } else {
      isCheckAll.value = true;
    }
    isCheckAll.refresh();
    works.refresh();
  }

  bool isHasWorkSelected() {
    return works.any((element) => element.isChecked == true);
  }


  List<ConfirmMassSceneSchedules> getWorksSelected() {
    return works.where((element) => element.isChecked == true).toList();
  }

  Future createIndividualJob(ConfirmMassSceneSchedules work) async {
    final response = await serviceMergeReport.createReports(
        work.id, work.equipmentTypeId, work.equipmentDetailId);
    if (response.isLoadSuccess) {
      service.sendLocation(response.data, type: 3);
      work.status = ReportWorkStatusType.doing;
      works.refresh();
      await Get.to(ReportScreen(
        reportId: response.data,
        isAllowEditing: true,
      ));
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future approval() async {
    final note = await rShowInputDialog('Xác nhận phiếu KLCV');
    if (note == null) return;

    final result = await _repo.approveWorkload(ids: [detailWorkloadModel.id], note: note);
    if (result.isLoadSuccess) {
      Get.back();
      SnackBarHUD.show('Xác nhận thành công');
    } else {
      await rShowDialogOneButton(result.message);
    }
  }

  Future reject() async {
    final note = await rShowInputDialog('Từ chối phiếu KLCV');
    if (note == null) return;

    final result = await _repo.rejectWorkload(ids: [detailWorkloadModel.id], note: note);
    if (result.isLoadSuccess) {
      SnackBarHUD.show('Từ chối thành công');
      Get.back();
    } else {
      await rShowDialogOneButton(result.message);
    }
  }

  Future getDataEquipmentReport() async {
    final response = await service.getDataUnscheduled();
    if (response.isLoadSuccess) {
      response.data.equipmentTypes.forEach((element) {
        equipmentTypes.add(StringOptionModel(element.name, element.id));
        equipmentTypeList.add(EquipmentTypes(
          id: element.id,
          name: element.name,
          equipmentDetails: element.equipmentDetails,
        ));
      });
    }
  }

  Future confirmComplete(ConfirmMassSceneSchedules work) async {
    final response = await serviceMergeReport.confirmComplete(work.id);
    if (response.isLoadSuccess) {
      service.sendLocation(work.id, type: 2);
      work.status = ReportWorkStatusType.done;
      works.refresh();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future handleCreateFormReport(ConfirmMassSceneSchedules workModel) async {
    if (workModel.isMeter == true &&
        AppShared.instance.getUserProfile().isHasCreateFormReport() &&
        workModel.status != ReportWorkStatusType.done) {
      final isOnline = await RConnection.shared.checkConnection();
      if (!isOnline) {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
        return;
      }

      await createMeterReport(workModel);
      return;
    }

    if (workModel.isConfirmComplete == true &&
        AppShared.instance.getUserProfile().isHasCreateFormReport() &&
        workModel.status != ReportWorkStatusType.done) {
      final isOnline = await RConnection.shared.checkConnection();
      if (!isOnline) {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
        return;
      }

      await rShowMyDialogOkCancel('Bạn có muốn xác nhận công việc này',
          secondFunction: () async {
            await confirmComplete(workModel);
          });
      return;
    }

    if (await RLocalDataManager.instance.checkReportExist(workModel.id)) {
      await rShowMyDialogOkCancel(
          'Biên bản này đã được tạo offline, nếu xác nhận tạo online thì biên bản offline sẽ bị xóa',
          secondFunction: () async {
            await RLocalDataManager.instance.deleteWorkOffline(workModel.id);
            //create
            final result = await showDialogConfirm(
                equipmentType: workModel.equipmentTypeId,
                equipmentDetail: workModel.equipmentDetailId,
                equipmentTypes: equipmentTypes,
                equipmentDetails: equipmentTypeList,
                workType: workModel.periodicType);
            if (result is List<String> && result.length > 1) {
              if (result.length == 3) {
                workModel.formId = result[2];
              }
              workModel.equipmentTypeId = result[0];
              workModel.equipmentDetailId = result[1];
              await createIndividualJob(workModel);
            }
          });
    } else {
      //create
      final result = await showDialogConfirm(
          equipmentType: workModel.equipmentTypeId,
          equipmentDetail: workModel.equipmentDetailId,
          workType: workModel.periodicType,
          equipmentTypes: equipmentTypes,
          equipmentDetails: equipmentTypeList);
      if (result is List<String> && result.length > 1) {
        if (result.length == 3) {
          workModel.formId = result[2];
        }
        workModel.equipmentTypeId = result[0];
        workModel.equipmentDetailId = result[1];
        await rShowMyDialogOkCancel(
            'Bạn có muốn sử dụng dữ liệu từ một biên bản khác?',
            firstTitle: 'Từ chối',
            firstAction: () async {
              await createIndividualJob(workModel);
            },
            secondTitle: 'Đồng ý',
            secondFunction: () async {
              final reportCopy =
              await Get.to(() => CopyReportScreen(scheduleId: workModel.id, equipmentDetailId: workModel.equipmentDetailId,));
              if (reportCopy != null) {
                await createIndividualJobCopy(workModel, reportCopy);
              }
            });
      }
    }
  }

  Future createIndividualJobCopy(
      ConfirmMassSceneSchedules workModel, FormReportCopyModel formReportCopyModel) async {
    if (!userProfile.isHasCreateFormReport()) {
      await rShowDialogOneButton(RAppStrings.userNotPermission);
      return;
    }

    Future createReportOnline() async {
      final response = await serviceMergeReport.createReportsCopy(
          workModel.id,
          formReportCopyModel.id,
          workModel.equipmentTypeId,
          workModel.equipmentDetailId);
      if (response.isLoadSuccess) {
        service.sendLocation(response.data, type: 3);
        await Get.to(ReportScreen(
          reportId: response.data,
          isAllowEditing: true,
        ));
        workModel.status = ReportWorkStatusType.doing;
        works.refresh();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    final isOnline = await RConnection.shared.checkConnection();
    final isLocationGranted =
    await LocationServiceBackground.shared.requestPermission();
    if (isLocationGranted) {
      if (isOnline) {
        await createReportOnline();
      } else {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
      }
    }
  }

  Future createMeterReport(ConfirmMassSceneSchedules work,) async {
    final response = await serviceMergeReport.createMeterReport(work.id);
    if (response.isLoadSuccess) {
      service.sendLocation(response.data, type: 3);
      await Get.to(BBCongToPage(
        reportID: response.data,
        isAllowEdit: true,
      ));
      work.status = ReportWorkStatusType.doing;
      works.refresh();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }
}

