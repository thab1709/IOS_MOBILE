// @dart=2.9
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_content_day.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/line_repository.dart';
import 'package:get/get.dart';

import '../../../models/abnormal/abnormal_raw.dart';
import '../../../services/responsitory/abnormal_repository.dart';
import '../grid_management_controller.dart';

class BaseLineBranchController extends GetxController {
  GridManagementController gridManagementController = Get.find();
  final abnormalRepository = TAbnormalRepository();

  List<AbnormalRaw> abnormalsRightOfWay = [];
  List<AbnormalRaw> abnormalsJoint = [];
  List<AbnormalRaw> abnormalsInsulation = [];
  List<AbnormalRaw> abnormalsWire = [];

  Future setAbnormalLine(
      String categoryName,
      PopupBaseModel model,
      String nameAbnormal,
      int index,
      int optionCategory,
      int inspectionCategory) async {
    model.abnormals ??= [];
    AbnormalRaw existAbnormal;
    if (inspectionCategory == InspectionCategory.lineRightsOfWay) {
      existAbnormal = abnormalsRightOfWay
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    } else if (inspectionCategory == InspectionCategory.lineNightInsulation) {
      existAbnormal = abnormalsInsulation
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    } else if (inspectionCategory == InspectionCategory.lineNightJoint) {
      existAbnormal = abnormalsJoint
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    } else if (inspectionCategory == InspectionCategory.lineNightWire) {
      existAbnormal = abnormalsWire
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    }
    if (nameAbnormal != null) {
      if (existAbnormal != null) {
        final abnormalOld = model.abnormals.firstWhereOrNull((element) =>
            element.categoryIndex == index &&
            optionCategory == element.optionCategory && element.abnormalId != null);
        if (abnormalOld != null) {
          abnormalOld.abnormalId = null;
        }
        final abnormal = TAbnormal(
            abnormalId: existAbnormal.id,
            categoryIndex: index,
            optionCategory: optionCategory,
            childCategory: categoryName,
            description: nameAbnormal);
        model.abnormals.add(abnormal);
      } else {
        final result = await addAbnormalOption(
            index: index, name: nameAbnormal, categoryName: categoryName, inspectionCategory: inspectionCategory);
        if (result != null) {
          model.abnormals.add(result);
        }
      }
    } else {
      final abnormal =
          model.abnormals.where((element) => element.categoryIndex == index);
      if (abnormal != null) {
        abnormal.forEach((element) {
          element.abnormalId = null;
        });
      }
    }
  }

  Future setAbnormal(String categoryName, PopupBaseModel model,
      String nameAbnormal, int index, int inspectionCategory) async {
    model.abnormals ??= [];
    AbnormalRaw existAbnormal;
    if (inspectionCategory == InspectionCategory.lineRightsOfWay) {
      existAbnormal = abnormalsRightOfWay
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    } else if (inspectionCategory == InspectionCategory.lineNightInsulation) {
      existAbnormal = abnormalsInsulation
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    } else if (inspectionCategory == InspectionCategory.lineNightJoint) {
      existAbnormal = abnormalsJoint
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    } else if (inspectionCategory == InspectionCategory.lineNightWire) {
      existAbnormal = abnormalsWire
          ?.firstWhereOrNull((element) => element.name == nameAbnormal);
    }
    if (nameAbnormal != null) {
      if (existAbnormal != null) {
        final abnormalOld = model.abnormals.firstWhereOrNull((element) => element.categoryIndex == index && element.abnormalId != null);
        if (abnormalOld != null) {
          abnormalOld.abnormalId = null;
        }
        final abnormal = TAbnormal(
            abnormalId: existAbnormal.id,
            categoryIndex: index,
            childCategory: categoryName,
            description: nameAbnormal);
        model.abnormals.add(abnormal);
      } else {
        final result = await addAbnormalOption(
            index: index, name: nameAbnormal, categoryName: categoryName, inspectionCategory: inspectionCategory);
        if (result != null) {
          model.abnormals.add(result);
        }
      }
    } else {
      final abnormal = model.abnormals.firstWhereOrNull((element) => element.categoryIndex == index && element.abnormalId != null);
      if (abnormal != null) {
        abnormal.abnormalId = null;
      }
    }
  }

  Future getAbnormalOptions({bool isBackground, int inspectionCategory}) async {
    if (gridManagementController?.argument?.ticketType == null) {
      return [];
    }
    final response = await abnormalRepository.getAbnormalOptions(
        equipmentCategory: inspectionCategory,
        entityType: gridManagementController?.argument?.subStationType?.code,
        inspectionType: gridManagementController?.argument?.ticketType?.code,
        isBackground: isBackground ?? true);
    if (inspectionCategory == InspectionCategory.lineRightsOfWay) {
      abnormalsRightOfWay = [];
    } else if (inspectionCategory == InspectionCategory.lineNightInsulation) {
      abnormalsInsulation = [];
    } else if (inspectionCategory == InspectionCategory.lineNightJoint) {
      abnormalsJoint = [];
    } else if (inspectionCategory == InspectionCategory.lineNightWire) {
      abnormalsWire = [];
    }
    if (response.isLoadSuccess) {
      if (inspectionCategory == InspectionCategory.lineRightsOfWay) {
        abnormalsRightOfWay.addAll(response.data.list);
      } else if (inspectionCategory == InspectionCategory.lineNightInsulation) {
        abnormalsInsulation.addAll(response.data.list);
      } else if (inspectionCategory == InspectionCategory.lineNightJoint) {
        abnormalsJoint.addAll(response.data.list);
      } else if (inspectionCategory == InspectionCategory.lineNightWire) {
        abnormalsWire.addAll(response.data.list);
      }
    } else {
      await showDialogOneButton(response.message);
    }
  }

  Future<TAbnormal> addAbnormalOption(
      {int index,
      String name,
      String categoryName,
      int inspectionCategory}) async {
    final response = await abnormalRepository.addAbnormalOption(
      name: name,
      equipmentCategory: inspectionCategory,
      entityType: gridManagementController?.argument?.subStationType?.code,
      inspectionType: gridManagementController?.argument?.ticketType?.code,
    );

    if (response.isLoadSuccess) {
      abnormalsRightOfWay.add(response.data);
      if (inspectionCategory == InspectionCategory.lineRightsOfWay) {
        abnormalsRightOfWay.add(response.data);
      } else if (inspectionCategory == InspectionCategory.lineNightInsulation) {
        abnormalsInsulation.add(response.data);
      } else if (inspectionCategory == InspectionCategory.lineNightJoint) {
        abnormalsJoint.add(response.data);
      } else if (inspectionCategory == InspectionCategory.lineNightWire) {
        abnormalsWire.add(response.data);
      }
      return TAbnormal(
          abnormalId: response.data.id,
          categoryIndex: index,
          childCategory: categoryName,
          description: name);
    } else {
      await showDialogOneButton(response.message);
      return null;
    }
  }
}

class MediumContentBranchController extends BaseLineBranchController {
  final LineTicketRepository _repository = LineTicketRepository();
  final lineContent = LineContentModel().obs;

  LineTicketController ticketController = Get.find();
  RxBool loadDataSuccess = false.obs;
  RxBool showDetailContent = false.obs;

  final listPopups = <PopupsDataModel>[].obs;
  final listSubstations = <EquipmentModel>[].obs;
  List<EquipmentModel> undergroundCables = [];
  List<EquipmentModel> tus = [];
  List<EquipmentModel> tis = [];
  List<EquipmentModel> rmus = [];
  List<EquipmentModel> breakers = [];
  List<EquipmentModel> capacitors = [];

  final lineBranchInfo = LineBranchInfo().obs;

  RxString abnormalPhenomenon = ''.obs;

  Future updatePopupSuccess(PopupsDataModel popupsDataModel) async {
    final isHandleDataOnline = await ticketController.isHandleDataOnline();

    listPopups
        .firstWhere(
            (element) => element.equipmentId == popupsDataModel.equipmentId)
        ?.isSaved = true;
    listPopups.refresh();
    update();

    if (!isHandleDataOnline) {
      await LocalDataManager.shared.saveLineBranchContent(
          contentModel: lineContent.value,
          ticketId: ticketController.ticketId,
          lineBranchId: lineBranchInfo.value.id);
    }
  }

  Future getBranchNodes() async {
    Future online() async {
      final listData = <List<EquipmentModel>>[];
      Future getPage(int page) async {
        final response = await _repository.getBranchNodes(
            ticketController.ticketId, lineBranchInfo.value.id, page,
            isBackgroundMode: true);
        if (response.isLoadSuccess && response.data.list != null) {
          listData.insert(page - 1, response.data.list);
        }
      }

      final response = await _repository.getBranchNodes(
          ticketController.ticketId, lineBranchInfo.value.id, 1,
          isBackgroundMode: true);

      if (response.isLoadSuccess) {
        listData.add(response.data?.list);

        final totalPage = response.data.paging.totalPages;
        if (totalPage != null) {
          final futures = <Future>[];
          if (totalPage > 1) {
            for (var pageIndex = 2; pageIndex <= totalPage; pageIndex++) {
              listData.add(List.empty());
              futures.add(getPage(pageIndex));
            }
          }
          await Future.wait(futures);
          listData?.forEach(listSubstations.addAll);
          listSubstations.refresh();
        }
      } else {
        await showDialogError(response.message);
      }
    }

    void offline() {
      final res = LocalDataManager.shared.getAllNodeBranchSelected(
          ticketController.ticketId, lineBranchInfo.value.id);
      if (res != null) {
        listSubstations.assignAll(res);
        listSubstations.refresh();
      }
    }

    final isHandleDataOnline = await ticketController.isHandleDataOnline();
    if (isHandleDataOnline) {
      await online();
    } else {
      offline();
    }
  }

  Future<void> getAbnormalPhenomenon() async {
    final isConnectInternet = await Connection.shared.checkConnection();

    if (ticketController.ticketId == null) {
      return;
    }

    if (isConnectInternet) {
      final response = await _repository.getAbnormalPhenomenon(
          ticketController.ticketId, lineBranchInfo.value.id);

      if (response.isLoadSuccess) {
        if (response?.data != null) {
          abnormalPhenomenon.value = response.data.map((e) => e).join('');
          lineContent.value.specificPhenomena =
              '${lineContent.value.getAbnormalPhenomenonOffline()}${abnormalPhenomenon.value}';
          abnormalPhenomenon.value = lineContent.value.specificPhenomena;
          update();
        }
      } else {
        await showDialogError(response.message);
      }
    } else {
      final allAbnormalString = <String>[];

      listPopups.forEach((element) {
        final data = LocalDataManager.shared.getLinePopup<PopupBaseModel>(
            ticketController.ticketId,
            lineBranchInfo.value.id,
            element.equipmentId,
            element.inspectionCategory);
        final description = data?.description ?? '';
        if (description?.isNotEmpty == true) {
          allAbnormalString.add(description);
        }

        abnormalPhenomenon.value = '';
        abnormalPhenomenon.value = allAbnormalString.map((e) => e).join('\n');
        // lineContent.specificPhenomena = abnormalPhenomenon.value;
        lineContent.value.specificPhenomena =
            '${lineContent.value.getAbnormalPhenomenonOffline()}${abnormalPhenomenon.value}';
        abnormalPhenomenon.value = lineContent.value.specificPhenomena;
        update();
      });
    }
  }

  Future getBranchData() async {
    Future online() async {
      final response = await _repository.getBranchContent(
          ticketController.ticketId, lineBranchInfo.value.id);
      LocationServiceBackground.shared
          .updateLocationToServer(ticketController.line.lineId);
      if (response.isLoadSuccess) {
        lineContent.value = response.data;
        abnormalPhenomenon.value = response.data.specificPhenomena;
        listPopups.assignAll(response.data?.popups ?? <PopupsDataModel>[]);
        listPopups.forEach((element) {
          element.equipmentName =
              InspectionCategory.getPopupName(element.inspectionCategory);
        });
        listPopups.refresh();
        loadDataSuccess.value = true;
        tis = lineContent.value.tis;
        tus = lineContent.value.tus;
        rmus = lineContent.value.rmus;
        breakers = lineContent.value.breakers;
        capacitors = lineContent.value.capacitor;
        undergroundCables = response.data.underGroundCables;
        update();
      } else {
        await showDialogError(response.message);
      }
    }

    void offline() {
      final response = LocalDataManager.shared.getLineBranchContent(
          ticketId: ticketController.ticketId,
          lineBranchId: lineBranchInfo.value.id);
      if (response != null) {
        lineContent.value = response;
        abnormalPhenomenon.value = response.specificPhenomena;
        listPopups.assignAll(response?.popups ?? <PopupsDataModel>[]);
        listPopups.forEach((element) {
          element.equipmentName =
              InspectionCategory.getPopupName(element.inspectionCategory);
        });
        listPopups.refresh();
        loadDataSuccess.value = true;
        tis = lineContent.value.tis;
        tus = lineContent.value.tus;
        rmus = lineContent.value.rmus;
        breakers = lineContent.value.breakers;
        capacitors = lineContent.value.capacitor;
        undergroundCables = response.underGroundCables;
        update();
      }
    }

    final isHandleDataOnline = await ticketController.isHandleDataOnline();
    if (isHandleDataOnline) {
      await online();
    } else {
      offline();
    }

    createDefaultValue();
  }

  Future updateBranchData() async {
    if (ticketController.ticketId == null) {
      await showDialogError(
          'Không thể cập nhật khi chưa tạo công việc kiểm tra.');
      return;
    }

    // Ensure default values are set before validation
    _ensureDefaultValues();

    if (!(ticketController.argument.ticketType == TicketType.periodicNight)) {
      if (!lineContent.value.validateDataIncidentOrDay()) {
        lineBranchInfo.refresh();
        await showDialogValidateData();
        return;
      }
    } else {
      if (!lineContent.value.validateDataNight()) {
        lineBranchInfo.refresh();
        await showDialogValidateData();
        return;
      }
    }

    // final popups = lineContent.popups.firstWhere((element) => element.isSaved == false, orElse: () => null);
    //
    // if(popups != null){
    //   await showDialogError('Thiết bị ${InspectionCategory.getPopupName(popups.inspectionCategory)} chưa được lưu. Vui long kiểm tra lại');
    //
    //   return;
    // }

    Future offline({bool isOffline = true}) async {
      lineContent.value.isUpdateOffline = isOffline;
      final result = await LocalDataManager.shared.saveLineBranchContent(
          contentModel: lineContent.value,
          ticketId: ticketController.ticketId,
          ticketType: ticketController.argument.ticketType,
          workId: ticketController?.argument?.workModel?.workId,
          lineBranchId: lineBranchInfo.value.id);

      if (isOffline) {
        if (!result) {
          SnackBarHUD.show(AppStrings.updateOfflineFalse);
          return;
        }

        SnackBarHUD.show(
            'Cập nhật offline nhánh ${lineBranchInfo.value.lineBranchName} thành công');
        await LocalDataManager.shared.updateLineStatus(
            ticketController.ticketId, lineBranchInfo.value.id);
        lineBranchInfo.value.isSaved = true;
        lineBranchInfo.refresh();
        update();
      }
    }

    Future online() async {
      final response = await _repository.updateBranchContent(
          ticketId: ticketController.ticketId,
          params: lineContent.value
              .toUpdateJson(ticketController.argument.ticketType),
          lineBranchInspectId: lineBranchInfo.value.id);
      LocationServiceBackground.shared
          .updateLocationToServer(ticketController.line.lineId);
      if (response.isLoadSuccess) {
        await offline(isOffline: false);
        lineBranchInfo.value.isSaved = true;
        lineBranchInfo.refresh();
        SnackBarHUD.show(
            'Cập nhật nhánh ${lineBranchInfo.value.lineBranchName} thành công');
      } else {
        await showDialogError(response.message);
      }
    }

    final isHandleDataOnline = await ticketController.isHandleDataOnline();

    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      if (isHandleDataOnline) {
        await online();
      } else {
        await offline();
      }
    }
  }

  void _ensureDefaultValues() {
    // Set default values for lineRightsOfWay to pass validation
    // KCOptions.first = ContentOptions.no (value = 12)
    // CutTreeOptions.first = OptionModel("Xử lý ngay tại thời điểm kiểm tra", 0)
    lineContent.value.lineRightsOfWay.anotherLineCrossing ??= 12; // ContentOptions.no
    lineContent.value.lineRightsOfWay.violation ??= 12; // ContentOptions.no
    lineContent.value.lineRightsOfWay.changesConstruction ??= 12; // ContentOptions.no
    lineContent.value.lineRightsOfWay.possibleProblematic ??= 12; // ContentOptions.no
    lineContent.value.lineRightsOfWay.subjectOfViolation ??= "Không";
    lineContent.value.lineRightsOfWay.treeFellingCondition ??= 12; // ContentOptions.no
    lineContent.value.lineRightsOfWay.informationOnTreeFellingAndPlanting ??= 0; // CutTreeOptions.first
    lineContent.value.lineRightsOfWay.informationConstructionPlan ??= "Không";
    lineContent.value.lineRightsOfWay.theWorksAreUnderConstruction ??= "Không";
    lineContent.value.lineRightsOfWay.handlingImmediatelyInspection ??= 12; // ContentOptions.no
    lineContent.value.lineRightsOfWay.suggestedHandlingOfAbnormal ??= "Không";

    // Set default values for other required fields
    lineContent.value.specificPhenomena ??= "Không";
    lineContent.value.processed ??= "Không";
  }

  void createDefaultValue() {
    // lineContent.lineRightsOfWay.possibleProblematic ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.changesConstruction ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.anotherLineCrossing ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.treeFall ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.violation ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.treeFellingCondition ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.informationOnTreeFellingAndPlanting ??= CutTreeOptions.first.value;
    // lineContent.lineRightsOfWay.rockSlide ??= KCOptions.first.value;
    // lineContent.lineRightsOfWay.handlingImmediatelyInspection ??= KCOptions.first.value;
    //
    // lineContent.lineJoint.jointSituation ??= LineOption.DBVH_D_PN_Option.first.value;
    // lineContent.lineJoint.possibleProblematic ??= KCOptions.first.value;
    // lineContent.lineJoint.jointHandlingImmediatelyInspection ??= KCOptions.first.value;
    //
    // lineContent.lineWire.unusualSound ??= KCOptions.first.value;
    // lineContent.lineWire.electricDischarge ??= KCOptions.first.value;
    // lineContent.lineWire.possibleProblematic ??= KCOptions.first.value;
    // lineContent.lineWire.handlingImmediatelyInspection ??= KCOptions.first.value;
    //
    // lineContent.lineInsulationContent.electricDischarge ??= KCOptions.first.value;
    // lineContent.lineInsulationContent.possibleProblematic ??= KCOptions.first.value;
    // lineContent.lineInsulationContent.handlingImmediatelyInspection ??= KCOptions.first.value;
  }
}

