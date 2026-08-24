// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/models/create_report_not_plan_model.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

import '../unscheduled_report_controller.dart';

class AddUnScheduleController extends GetxController {
  final UnscheduledReportController listReportController = Get.find();
  String content;
  String location = '';
  DateTime dateTimeNow = DateTime.now();
  DateTime dateNow = DateTime.now();
  String workType = '0';
  UserProfileModel user = AppShared.instance.getUserProfile();
  String unit = '0';
  bool isHanding = false;
  final equipmentType = '0'.obs;
  final equipmentDetail = '0'.obs;
  RxList<Forms> forms = RxList.empty();
  EquipmentDetails equipment;
  RxList<EquipmentDetails> equipmentDetails = RxList.empty();
  RxList<StringOptionModel> optionEquipment = RxList.empty();
  final service = ReportRepository();
  final workTypeOptions = const [
    IntOptionModel('Vui lòng chọn', 0),
    IntOptionModel(RAppStrings.experiment, WorkType.experiment),
    IntOptionModel(RAppStrings.accreditation, WorkType.accreditation),
  ];

  @override
  void onInit() {
    super.onInit();
    _initDate();
  }

  void _initDate() {
    final currentDate = DateTime.now();
    final date = DateTime(currentDate.year, currentDate.month, currentDate.day);
    dateTimeNow = date;
  }

  void renderEquipmentDetail(String idEquipmentType) {
    optionEquipment.clear();

    if (idEquipmentType != '0') {
      final equipmentType = listReportController.equipmentTypeList.firstWhere(
          (element) => idEquipmentType == element.id,
          orElse: () => null);
      optionEquipment.add(StringOptionModel('Vui lòng chọn', '0'));
      for (final element in equipmentType?.equipmentDetails ?? List.empty()) {
        equipmentDetails.add(EquipmentDetails(
            id: element.id, name: element.name, forms: element.forms));
        optionEquipment.add(StringOptionModel(element.name, element.id));
      }
    }
    equipmentDetail.value = '0';
  }

  void renderListForms(String idEquipmentDetail){
    forms.clear();
    if (idEquipmentDetail != '0') {
      equipment = equipmentDetails
          .firstWhere((equipment) => equipment.id == idEquipmentDetail, orElse: () => null);
      equipment.forms.forEach((element) {
        forms.add(Forms(id: element.id, name: element.name, type: element.type));
      });
    }
  }

  Future createdReportNotPlan() async {
    isHanding = true;
    if (workType == '0') {
      isHanding = false;
      return rShowDialogOneButton('Vui lòng chọn loại công việc');
    }
    if (unit == '0') {
      isHanding = false;
      return rShowDialogOneButton('Vui lòng chọn đơn vị yêu cầu');
    }
    if (equipmentType.value == '0') {
      isHanding = false;
      return rShowDialogOneButton('Vui lòng chọn loại thiết bị');
    }

    if (equipmentDetail.value == '0') {
      isHanding = false;
      return rShowDialogOneButton('Vui lòng chọn chi tiết thiết bị');
    }
    if (location == null || location?.isEmpty == true) {
      isHanding = false;
      return rShowDialogOneButton('Vui lòng điền địa điểm');
    }

    Future createUnscheduledReportOnline() async {
      final response = await service.createReportNotPlan(
          workType: workType,
          unitId: unit,
          createdDate: dateNow.toUTC(),
          content: content,
          userId: user.id,
          teamId: user.teamId,
          equipmentTypeId: equipmentType.value,
          equipmentDetailId: equipmentDetail.value,
          departmentId: user.departmentId,
          location: location);
      if (response.isLoadSuccess) {
        Get.back(result: true);
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    Future createUnscheduledReportOffline() async {
      final reportTypeName = workTypeOptions.firstWhere(
          (element) => element.value == workType.toIntOrNull(),
          orElse: () => null);
      final response = await RLocalDataManager.instance.createUnscheduledReportOffline(
        workType: workType,
        unitId: unit,
        createdDate: dateNow.toStringFormat(RAppStrings.utcFormatNotZ,isUtc: true),
        content: content,
        userId: user.id,
        teamId: user.teamId,
        equipmentTypeId: equipmentType.value,
        equipmentDetailId: equipmentDetail.value,
        equipmentDetailName: equipment.name,
        departmentId: user.departmentId,
        department: user.departmentName,
        location: location,
        reportNumber: 'Biên bản được tạo offline',
        teamName: user.teamName,
        username: user.name,
        reportTypeName:reportTypeName.title,
        forms: forms
      );
      if (response.isLoadSuccess) {
        Get.back(result: true);
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
    final isOnline = await RConnection.shared.checkConnection();
    if (isOnline) {
      await createUnscheduledReportOnline();
    } else {
      await createUnscheduledReportOffline();
    }
    isHanding = false;
  }
}

