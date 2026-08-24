// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/constance/work_status_type.dart';
import 'package:evnmobile/src/htld/common/utils/common.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/inter_content_night.dart';
import 'package:evnmobile/src/htld/models/day_night/popups/intermediate_transformer_station/temperature.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/distribution_inspect_model.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/general_data_model.dart';
import 'package:evnmobile/src/htld/models/intermediate_content.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_content_day.dart';
import 'package:evnmobile/src/htld/models/line/line_general.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_beam_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_breaker.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_capacitor_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_cutting_machine_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_disconnectors_switch_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_earthing_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_fundament_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_fuse_cut_out_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_insulation_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_lightning_arrester_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_measure_the_boundary_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_pole_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_recloser_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_rmu.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_rod_gap_model.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_ti.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_tu.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_underground_cable.dart';
import 'package:evnmobile/src/htld/models/line/popups/line_wire_model.dart';
import 'package:evnmobile/src/htld/models/line/selected_branch_model.dart';
import 'package:evnmobile/src/htld/models/popup_base_model.dart';
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/models/result_model.dart';
import 'package:evnmobile/src/htld/models/transformer_model.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/user_location.dart';
import 'package:evnmobile/src/htld/services/responseModel/distribution_content_night_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:g_json/g_json.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:uuid/uuid.dart';


class DatabaseBoxName {
  static const listWorks = 'list_work';
  static const listEquipemnt = 'list_equipment';
  static const general = 'general';
  static const content = 'content';
  static const contentPopup = 'content_popups';
  static const contentTransformer = 'content_transformers';
  static const popupDevice = 'popupDevice';
  static const result = 'result';
  static const workers = 'workers';
  static const interContentNight = 'interContentNight';
  static const equipmentLine = 'equipmentLine';
  static const line = 'line';
  static const location = 'location';
  static const allNodeInLine = 'allNodeInLine';
  static const allEquipmentInLine = 'allEquipmentInLine';
  static const allEquipmentDistinctInBranch = 'allEquipmentDistinctInBranch';
  static const lineBranchContent = 'lineBranchContent';
  static const lineContent = 'lineContent';
  static const linePopup = 'linePopup';
}

class LocalDataManager {
  static final shared = LocalDataManager();
  RxList<WorkModel> works = RxList.empty();
  RxList<EquipmentModel> equips = RxList.empty();

  String getUserId() {
    return AppShared.instance.getUserProfile().id;
  }

  Future<void> initHive() async {
    // Khi tạo 1 box mới call openBox ở đây
    // Hàm này sẽ call trong main.dart mỗi khi mở app
    final directory = await path_provider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    await Hive.openBox(DatabaseBoxName.listWorks);
    await Hive.openBox(DatabaseBoxName.listEquipemnt);
    await Hive.openBox(DatabaseBoxName.general);
    await Hive.openBox(DatabaseBoxName.content);
    await Hive.openBox(DatabaseBoxName.workers);
    await Hive.openBox(DatabaseBoxName.popupDevice);
    await Hive.openBox(DatabaseBoxName.contentPopup);
    await Hive.openBox(DatabaseBoxName.contentTransformer);
    await Hive.openBox(DatabaseBoxName.result);
    await Hive.openBox(DatabaseBoxName.equipmentLine);
    await Hive.openBox(DatabaseBoxName.line);
    await Hive.openBox(DatabaseBoxName.location);
    await Hive.openBox(DatabaseBoxName.allNodeInLine);
    await Hive.openBox(DatabaseBoxName.allEquipmentInLine);
    await Hive.openBox(DatabaseBoxName.lineBranchContent);
    await Hive.openBox(DatabaseBoxName.lineContent);
    await Hive.openBox(DatabaseBoxName.linePopup);
    await Hive.openBox(DatabaseBoxName.allEquipmentDistinctInBranch);
  }

  //Hàm này để update lại list works khi mình change value của item và muốn update lại vào local
  // Chỉ cần chọc vào works thay đổi value va update lại vao local bằng function này
  Future updateWorks(SubStationType subStationType, String workType) async {
    await syncWorks(LocalDataManager.shared.works, subStationType, workType);
  }

  //Đồng bộ danh sách công việc từ server và lưu vào local

  Future<void> syncWorks(List<WorkModel> works, SubStationType subStationType,
      String workType) async {
    //local
    // final existWorks =
    //     await LocalDataManager.shared.getWorks(subStationType, workType);
    // final doingWork =
    //     existWorks.where((element) => element.workStatus == 2).toList();
    // final workFromServer = works
    //     .where((element) =>
    //         doingWork?.map((e) => e.workId)?.toList()?.contains(element.workId) ==
    //         false)
    //     .toList();
    // final syncWork = workFromServer + doingWork;
     final prefs = Hive.box(DatabaseBoxName.listWorks);
    // final data = jsonEncode(syncWork?.map((e) => e.toJson())?.toList());
     final data = jsonEncode(works?.map((e) => e.toJson())?.toList());
    final key =
        '${DatabaseBoxName.listWorks}_${AppShared.instance.getUserProfile().id}_${subStationType.index}_$workType';

    await prefs.put(key, data);
  }

  Future<void> saveWorks(List<WorkModel> works, SubStationType subStationType,
      String workType) async {
    //local
    final prefs = Hive.box(DatabaseBoxName.listWorks);
    final data = jsonEncode(works?.map((e) => e.toJson())?.toList());
    final key =
        '${DatabaseBoxName.listWorks}_${getUserId()}_${subStationType.index}_$workType';

    await prefs.put(key, data);
  }

  Future updateLineStatus(String ticketId, String lineBranchId) async {
    final model = LocalDataManager.shared.getLineContent(ticketId);
    final model2 = model.firstWhere((element) => element.id == lineBranchId);
    model2.isSaved = true;
    await LocalDataManager.shared.saveLineContent(contents: model, ticketId: ticketId);
  }

  //Uodate trạng thái của 1 công việc khi thực hiện tạo phiếu hoặc hoàn thành ...
  Future updateWorkStatus(String ticketId, int statusId, String substationId,
      SubStationType subStationType, String workType) async {
    final model = LocalDataManager.shared.works
        .firstWhere((element) => element.substationModel.id == substationId);
    model.workStatus = statusId;
    model.workStatusName = model.getWorkStatusName();
    model.entityId = ticketId;
    await saveWorks(LocalDataManager.shared.works, subStationType, workType);
  }

  Future updateWorkEntityId(String ticketId, WorkModel workModel,
      SubStationType subStationType, String workType) async {
    final model = LocalDataManager.shared.works
        .firstWhere((element) => element.workId == workModel.workId);
    model.entityId = ticketId;
    await saveWorks(LocalDataManager.shared.works, subStationType, workType);
  }

  // Update trạng thái vật tư thiết bị cua 1 trạm biến áp khi thực hiện tạo phiếu từ công việc
  Future updateCheckedEquipment(
      String substationId,
      SubStationType subStationType,
      TicketType ticketType,
      List<EquipmentModel> equipmentsSelected) async {
    final workModel = LocalDataManager.shared.works
        .firstWhere((element) => element.substationModel.id == substationId);
    final equipments = await getEquipmentForWork(subStationType.code.toString(),
        substationId, ticketType.code.toString());
    equipments?.forEach((element) {
      element.isChecked =
          equipmentsSelected?.map((e) => e.id)?.toList()?.contains(element.id);
    });

    await syncEquipmentForWork(equipments, subStationType, workModel.entityId,
        substationId, ticketType.code.toString());
  }

  // Get màn thông tin chung
  Future<GeneralDataModel> getGenerals(String entityId) async {
    final prefs = Hive.box(DatabaseBoxName.general);
    final key =
        '${DatabaseBoxName.general}_${getUserId()}_$entityId';
    final jsonString = prefs.get(key);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString);
    final info = GeneralDataModel.fromJson(JSON(json));

    return info;
  }

  // Save màn thông tin chung
  Future<void> saveGeneral(GeneralDataModel model, String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.general);
    final data = jsonEncode(model.toJson());
    final key =
        '${DatabaseBoxName.general}_${getUserId()}_$ticketId';
    await prefs.put(key, data);
  }

  Future<void> syncGenerals(DistributionInspectModel distributionInspectModel,
      String entityId) async {
    final general = GeneralDataModel();
    final workModel = LocalDataManager.shared.works.firstWhereOrNull((element) =>
        element.substationModel.id == distributionInspectModel.subStationId);

    if(workModel == null) {
      return;
    }

    general.id ??= distributionInspectModel.workId ?? '';
    //general.type = ;
    //general.typeName = '';
    general.substationName ??= workModel.substationModel.name ?? '';
    general.code ??= workModel.substationModel.code ?? '';
    general.lineName ??= workModel.substationModel.lineName ?? '';
    general.inspectTime ??= distributionInspectModel.inspectTime ?? '';
    general.lastInspection ??=
        workModel.substationModel.latestInspectTime ?? '';
    general.inspectionRequest ??= distributionInspectModel.inspectRequest ?? '';
    general.assetManagementUnit ??=
        workModel.substationModel.assetManagementUnitName ?? '';
    //general.expireRemainingTime = '';
    //general.immediaryInspectGeneralEquipmentModels = '';
    general.temperature1 ??= distributionInspectModel.temperature_1 ?? '';
    general.temperature2 ??= distributionInspectModel.temperature_2 ?? '';
    general.weather1 ??= distributionInspectModel.weather_1 ?? '';
    general.weather2 ??= distributionInspectModel.weather_2 ?? '';

    final prefs = Hive.box(DatabaseBoxName.general);
    final data = jsonEncode(general.toJson());
    final key =
        '${DatabaseBoxName.general}_${getUserId()}_$entityId';

    await prefs.put(key, data);
  }

  Future<void> savePopupForTicket(String ticketId, List<PopupsDataModel> popups,
      SubStationType stationType, TicketType ticketType) async {
    final prefs = Hive.box(DatabaseBoxName.contentPopup);
    final key =
        '${DatabaseBoxName.contentPopup}_${getUserId()}_$ticketId';
    final data = jsonEncode(popups?.map((e) => e.toJson())?.toList());
    await prefs.put(key, data);
  }

  Future<void> createPopupForTicket(
      String ticketId,
      List<EquipmentModel> equipments,
      SubStationType stationType,
      TicketType ticketType) async {
    final prefs = Hive.box(DatabaseBoxName.contentPopup);
    final key =
        '${DatabaseBoxName.contentPopup}_${getUserId()}_$ticketId';
    //create Popups phan phoi
    final popups = <PopupsDataModel>[];

    if (stationType == SubStationType.distribution) {
      if (ticketType == TicketType.periodicNight) {
        final substationRoom = PopupsDataModel(
            equipmentName: 'Trạm biến áp',
            inspectionCategory: InspectionCategory.substationNightTime,
            isSaved: false,
            equipmentId: InspectionCategory.substationNightTime.toString());
        final groundingSystem = PopupsDataModel(
            equipmentName: 'Mối nối, tiếp xúc (khi tắt hệ thống chiếu sáng)',
            inspectionCategory: InspectionCategory.jointNightTime,
            isSaved: false,
            equipmentId: InspectionCategory.jointNightTime.toString());
        final buildingStructure = PopupsDataModel(
            equipmentName: 'Hệ thống chiếu sáng',
            inspectionCategory: InspectionCategory.lightingSystemNightTime,
            isSaved: false,
            equipmentId: InspectionCategory.lightingSystemNightTime.toString());
        popups.addAll([substationRoom, groundingSystem, buildingStructure]);
        // Tao data content content
        final transformers = equipments
            .where((element) =>
                element.inspectionCategory ==
                InspectionCategory.distributionTransformer)
            .toList()
            ?.map((e) => TransformerModel(e.id))
            ?.toList();
        final contentModel = DistributionContentNightResponse(
            abnormalPhenomenon: '', processed: '', equipments: transformers);
        final params = contentModel.toJson();
        params['equipments'] = transformers?.map((e) => e.toJson())?.toList();
        await saveContent(params, ticketId);
      } else {
        final substationRoom = PopupsDataModel(
            equipmentName: 'Buồng trạm biến áp',
            inspectionCategory: InspectionCategory.distributionSubstationRoom,
            isSaved: false,
            equipmentId:
                InspectionCategory.distributionSubstationRoom.toString());
        final groundingSystem = PopupsDataModel(
            equipmentName: 'Hệ thống nối đất',
            inspectionCategory: InspectionCategory.distributionGroundingSystem,
            isSaved: false,
            equipmentId:
                InspectionCategory.distributionGroundingSystem.toString());
        final buildingStructure = PopupsDataModel(
            equipmentName: 'Kết cấu xây dựng',
            inspectionCategory:
                InspectionCategory.distributionConstructionStructure,
            isSaved: false,
            equipmentId: InspectionCategory.distributionConstructionStructure
                .toString());
        popups.addAll(equipments
            ?.map((e) => PopupsDataModel(
                equipmentName: e.name,
                inspectionCategory: e.inspectionCategory,
                isSaved: false,
                equipmentId: e.id))
            ?.toList());
        popups.addAll([substationRoom, groundingSystem, buildingStructure]);
      }
    } else if (stationType == SubStationType.intermediate) {
      if (ticketType == TicketType.periodicNight) {
        final substation = PopupsDataModel(
            equipmentName: 'Trạm biến áp',
            inspectionCategory: InspectionCategory.substationNightTime,
            isSaved: false,
            equipmentId: InspectionCategory.substationNightTime.toString());
        final joint = PopupsDataModel(
            equipmentName: 'Mối nối, tiếp xúc  (khi tắt hệ thống chiếu sáng)',
            inspectionCategory: InspectionCategory.jointNightTime,
            isSaved: false,
            equipmentId: InspectionCategory.jointNightTime.toString());
        final lightingSystem = PopupsDataModel(
            equipmentName: 'Hệ thống chiếu sáng',
            inspectionCategory: InspectionCategory.lightingSystemNightTime,
            isSaved: false,
            equipmentId: InspectionCategory.lightingSystemNightTime.toString());

        final fixedPopups = [substation, joint, lightingSystem];
        popups.addAll(fixedPopups);

        // Tao data content content
        final temperature = equipments
            .where((element) =>
                element.inspectionCategory ==
                InspectionCategory.immediaryTransformer)
            .toList()
            ?.map((e) => Temperature(equipmentId: e.id, equipmentName: e.name))
            ?.toList();
        final listInterEquipment = equipments
            .where((element) =>
                element.inspectionCategory ==
                InspectionCategory.immediaryTransformer)
            .toList()
            ?.map((e) =>
                InterEquipments(equipmentId: e.id, equipmentName: e.name))
            ?.toList();
        final listOutlines = List.generate(3, (index) => OutLines()).toList();

        final contentModel = IntermediateContentNightModel(
            abnormalPhenomenon: '',
            processed: '',
            equipments: listInterEquipment,
            temperatures: temperature,
            outLines: listOutlines);
        final params = contentModel.toJson();
        params['equipments'] =
            listInterEquipment?.map((e) => e.toJson())?.toList();
        params['equipmentTemps'] = temperature?.map((e) => e.toJson())?.toList();
        params['outlines'] = listOutlines?.map((e) => e.toJson())?.toList();
        await saveContent(params, ticketId);
      } else {
        final contentResponse = IntermediateContentModel();
        final lstInterEquipments = equipments
            .where((element) =>
                element.inspectionCategory ==
                InspectionCategory.immediaryTransformer)
            .toList()
            ?.map((e) => InterEquipments(equipmentId: e.id))
            ?.toList();
        contentResponse.equipments = lstInterEquipments;
        contentResponse.outLines = RxList.generate(3, (index) => OutLines());

        final substationRoom = PopupsDataModel(
            equipmentName: 'Buồng trạm biến áp',
            inspectionCategory: InspectionCategory.immediarySubstationRoom,
            isSaved: false,
            equipmentId: InspectionCategory.immediarySubstationRoom.toString());
        final groundingSystem = PopupsDataModel(
            equipmentName: 'Hệ thống nối đất',
            inspectionCategory: InspectionCategory.immediaryGroundingSystem,
            isSaved: false,
            equipmentId:
                InspectionCategory.immediaryGroundingSystem.toString());
        final buildingStructure = PopupsDataModel(
            equipmentName: 'Kết cấu xây dựng',
            inspectionCategory:
                InspectionCategory.immediaryConstructionStructure,
            isSaved: false,
            equipmentId:
                InspectionCategory.immediaryConstructionStructure.toString());
        final clampRow = PopupsDataModel(
            equipmentName: 'Hàng kẹp và các đầu nối nhị thứ',
            inspectionCategory: InspectionCategory.immediaryClampRow,
            isSaved: false,
            equipmentId: InspectionCategory.immediaryClampRow.toString());
        final joint = PopupsDataModel(
            equipmentName: 'Mối nối',
            inspectionCategory: InspectionCategory.immediaryJoint,
            isSaved: false,
            equipmentId: InspectionCategory.immediaryJoint.toString());
        final fixedPopups = [
          substationRoom,
          groundingSystem,
          buildingStructure,
          clampRow,
          joint
        ];
        popups.addAll(equipments
            ?.map((e) => PopupsDataModel(
                equipmentName: e.name,
                inspectionCategory: e.inspectionCategory,
                isSaved: false,
                equipmentId: e.id))
            ?.toList());
        popups.addAll(fixedPopups);
        await saveContent(contentResponse.toJson(), ticketId);
      }
    }
    final data = jsonEncode(popups?.map((e) => e.toJson())?.toList());
    await prefs.put(key, data);
  }

  Future<void> updatePopupForTicket(
      String ticketId, List<PopupsDataModel> popups) async {
    final prefs = Hive.box(DatabaseBoxName.contentPopup);
    final key =
        '${DatabaseBoxName.contentPopup}_${getUserId()}_$ticketId';
    final data = jsonEncode(popups?.map((e) => e.toJson())?.toList());
    await prefs.put(key, data);
  }

  Future<void> updatePopupByEquipmentForTicket(
      String ticketId, List<EquipmentModel> equipments) async {
    final existPopups =
        await LocalDataManager.shared.getPopupsForTicket(ticketId);
    final prefs = Hive.box(DatabaseBoxName.contentPopup);
    final key =
        '${DatabaseBoxName.contentPopup}_${getUserId()}_$ticketId';
    final newPopups = equipments
        .map((e) => PopupsDataModel(
            inspectionCategory: e.inspectionCategory,
            equipmentId: e.id,
            equipmentName: e.name,
            isSaved: false))
        .where((element) => !existPopups
            .map((e) => e.equipmentId)
            .toList()
            .contains(element.equipmentId))
        .toList();
    final popups = existPopups + newPopups;
    final data = jsonEncode(popups?.map((e) => e.toJson())?.toList());
    await prefs.put(key, data);
  }

  Future<List<PopupsDataModel>> getPopupsForTicket(String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.contentPopup);
    final key =
        '${DatabaseBoxName.contentPopup}_${getUserId()}_$ticketId';
    final jsonString = prefs.get(key);
    if (jsonString == null) {
      return [];
    }
    final json = JSON(jsonDecode(jsonString));
    final popups = json.list?.map((e) => PopupsDataModel.fromJson(e))?.toList();
    return popups;
  }

  Future<void> updateStatusPopup(
      String ticketId, PopupsDataModel popupsDataModel) async {
    final popups = await getPopupsForTicket(ticketId);
    final popup = popups.firstWhere((element) {
      return element.equipmentId == popupsDataModel.equipmentId;
    }, orElse: () => null);
    if (popup != null) {
      final index = popups.indexOf(popup);
      popups[index].isSaved = true;
    }
    await updatePopupForTicket(ticketId, popups);
  }

  // Create May bien ap
  Future<void> saveTransformers(
      String ticketId, List<TransformerModel> transformers) async {
    final prefs = Hive.box(DatabaseBoxName.contentTransformer);
    final key =
        '${DatabaseBoxName.contentTransformer}_${getUserId()}_$ticketId';
    final string = jsonEncode(transformers?.map((e) => e.toJson())?.toList());
    await prefs.put(key, string);
  }

  Future<List<TransformerModel>> getTransformers(String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.contentTransformer);
    final key =
        '${DatabaseBoxName.contentTransformer}_${getUserId()}_$ticketId';
    final string = await prefs.get(key);
    if (string == null) {
      return [];
    }
    final json = JSON(jsonDecode(string));
    final data = json.list?.map((e) => TransformerModel.fromJson(e))?.toList();
    return data;
  }

  // Lấy danh sach công việc đã lưu
  Future<List<WorkModel>> getWorks(
      SubStationType subStationType, String workType) async {
    final prefs = Hive.box(DatabaseBoxName.listWorks);
    final key =
        '${DatabaseBoxName.listWorks}_${getUserId()}_${subStationType.index}_$workType';
    final jsonString = prefs.get(key);
    if (jsonString == null) {
      return [];
    }
    final json = jsonDecode(jsonString);

    final works = JSON(json).list?.map((e) => WorkModel.fromJson(e))?.toList();
    LocalDataManager.shared.works.value = works;
    return works;
  }

  // Lưu vật tư thiết bị của trạm biến áp theo mỗi công việc
  Future<void> syncEquipmentForWork(
      List<EquipmentModel> equipments,
      SubStationType subStationType,
      String ticketId,
      String substationId,
      String ticketType) async {
    final prefs = Hive.box(DatabaseBoxName.listEquipemnt);
    final data = jsonEncode(equipments?.map((e) => e.toMap())?.toList());
    final key =
        '${DatabaseBoxName.listEquipemnt}_${getUserId()}_${subStationType.code.toString()}_${ticketType}_$substationId';
    LocalDataManager.shared.equips.value = equipments;
    await prefs.put(key, data);
  }

  // LẤy vật tư cho công việc
  Future<List<EquipmentModel>> getEquipmentForWork(
      String subStationType, String substationId, String ticketType) async {
    final prefs = Hive.box(DatabaseBoxName.listEquipemnt);
    final key =
        '${DatabaseBoxName.listEquipemnt}_${getUserId()}_${subStationType}_${ticketType}_$substationId';
    final jsonString = prefs.get(key);
    if (jsonString == null) {
      return [];
    }
    final json = jsonDecode(jsonString);

    final works =
        JSON(json).list?.map((e) => EquipmentModel.fromJson(e))?.toList();

    return works;
  }

  // Lưu nội dung kiểm tra
  Future<void> saveContent(Map<String, dynamic> data, String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.content);
    final key =
        '${DatabaseBoxName.content}_${getUserId()}_$ticketId';
    await prefs.put(key, data);
  }

  // Lấy nội dung kiểm tra
  Future<JSON> getContent(String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.content);
    final key =
        '${DatabaseBoxName.content}_${getUserId()}_$ticketId';
    final data = await prefs.get(key);
    return JSON(data);
  }

  // Get popup content
  Future<JSON> getPopup(String ticketId, {@required String equipmentId}) async {
    final prefs = Hive.box(DatabaseBoxName.popupDevice);
    final key =
        '${DatabaseBoxName.popupDevice}_${getUserId()}_${ticketId}_${equipmentId ?? ''}';
    final json = prefs.get(key);
    return JSON(json);
  }

  Future<void> savePopup(
      String endPoint, Map<String, dynamic> data, String ticketId,
      {@required PopupsDataModel popupsDataModel}) async {
    final json = JSON(data);
    final prefs = Hive.box(DatabaseBoxName.popupDevice);
    json['endPoint'] = endPoint;
    final key =
        '${DatabaseBoxName.popupDevice}_${getUserId()}_${ticketId}_${popupsDataModel?.equipmentId ?? ''}';
    await prefs.put(key, json?.mapObject);
    await updateStatusPopup(ticketId, popupsDataModel);
  }

  Future<void> saveResult(Map<String, dynamic> data, String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.result);
    final key =
        '${DatabaseBoxName.result}_${getUserId()}_$ticketId';
    await prefs.put(key, data);
  }

  Future<JSON> getResult(String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.result);
    final key =
        '${DatabaseBoxName.result}_${getUserId()}_$ticketId';
    final json = prefs.get(key);
    if (json == null) {
      return null;
    }
    return JSON(json);
  }

  Future<void> syncLocation(String ticketId) async {
    final location = Location();
    final prefs = Hive.box(DatabaseBoxName.location);
    await Geolocator.getCurrentPosition().then((position)  {
      location.latitude = position.latitude;
      location.longitude = position.longitude;
    });
    final data = jsonEncode(location.toJson());
    final key = '${DatabaseBoxName.location}_${getUserId()}_$ticketId';
    await prefs.put(key, data);
  }

  Future<Location> getLocation(String ticketId) async {
    final prefs = Hive.box(DatabaseBoxName.location);
    final key = '${DatabaseBoxName.location}_${getUserId()}_$ticketId';
    final jsonString = prefs.get(key);

    if (jsonString == null) { return null; }
    final json = jsonDecode(jsonString);
    final location = Location.fromJson(JSON(json));

    return location;
  }
  /// Đường dây
  Future<void> saveLine(String lineId, LineModel line) async {
    final prefs = Hive.box(DatabaseBoxName.line);
    final key = '${DatabaseBoxName.line}_${getUserId()}_$lineId';
    final json = line.toMap();
    await prefs.put(key, json);
  }

  Future<LineModel> getLine(String lineId) async {
    final prefs = Hive.box(DatabaseBoxName.line);
    final key = '${DatabaseBoxName.line}_${getUserId()}_$lineId';
    final json = prefs.get(key);
    return LineModel.fromJson(JSON(json));
  }

  Future<void> saveEquipmentLine(
      {String lineBranchId, List<EquipmentModel> equipments}) async {
    final prefs = Hive.box(DatabaseBoxName.equipmentLine);
    final key =
        '${DatabaseBoxName.equipmentLine}_${getUserId()}_$lineBranchId';
    if (equipments != null) {
      final data = jsonEncode(equipments?.map((e) => e.toMap())?.toList());
      await prefs.put(key, data);
    }
  }

  Future<List<EquipmentModel>> getEquipmentKinks(String lineBranchId, List<String> kinkId) async {
    final prefs = Hive.box(DatabaseBoxName.equipmentLine);
    final key =
        '${DatabaseBoxName.equipmentLine}_${getUserId()}_$lineBranchId';
    final json = JSON(jsonDecode(prefs.get(key)));
    final data = json.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    final result = <EquipmentModel>[];

    data.forEach((element) {
    final equip = kinkId.firstWhere((e) => e == element.nodeId, orElse: () => null);
      if (equip != null) {
        result.add(element);
      }
    });
    return result;
  }

  Future createContentLineBranch(
      String offlineTicketId,
      List<EquipmentModel> kinks,
      List<EquipmentModel> equipments,
      String lineBranchId,
      List<LineBranchInfo> listLineBranchInfo,
      LineBranchInfo lineBranchInfo) async {
    //save list line branch
    await saveLineContent(contents: listLineBranchInfo, ticketId: offlineTicketId);

    //save nodes selected
    kinks?.forEach((element) {
      element.isChecked = false;
      element.isUsed = false;
    });
    await saveAllNodeBranchSelected(ticketId: offlineTicketId, lineBranchId: lineBranchId, equipments: kinks);

    //save content branch
    final equipmentsDistinct = <EquipmentModel>[];
    equipments?.forEach((element) {
      final item = equipmentsDistinct.firstWhere(
          (elementDistinct) => elementDistinct?.inspectionCategory == element.inspectionCategory,
          orElse: () => null);
      if (item == null) {
        equipmentsDistinct.add(element);
      }
    });

    equipmentsDistinct.removeWhere((element) => InspectionCategory.isLinePopup(element.inspectionCategory) == false);

    await saveEquipmentDistinctBranchSelected(ticketId: offlineTicketId, lineBranchId: lineBranchId, equipments: equipmentsDistinct);

    final popups = <PopupsDataModel>[];
    equipmentsDistinct?.forEach((element) {
      popups.add(PopupsDataModel(
          equipmentId: 'offline${element.id}',
          isSaved: false,
          equipmentName: element.name,
          inspectionCategory: element.inspectionCategory));
    });

    final lineContentModel = LineContentModel();

    final equipmentTi = equipments.where((element) => element.inspectionCategory == InspectionCategory.lineTI).toList() ?? List.empty();
    final nodesHasTi = <EquipmentModel>[];
    equipmentTi.forEach((element) {
      final data = kinks.firstWhere((e) => e.id == element.nodeId, orElse: () => null);
      if (data != null) {
        final dataExist = nodesHasTi.firstWhere((element) => element.id == data.id, orElse: () => null);
        if (dataExist == null) {
          nodesHasTi.add(data);
        }
      }
    });

    final equipmentRmu = equipments.where((element) => element.inspectionCategory == InspectionCategory.lineRMU).toList() ?? List.empty();
    final nodesHasRmu = <EquipmentModel>[];
    equipmentRmu.forEach((element) {
      final data = kinks.firstWhere((e) => e.id == element.nodeId, orElse: () => null);
      if (data != null) {
        final dataExist = nodesHasRmu.firstWhere((element) => element.id == data.id, orElse: () => null);
        if (dataExist == null) {
          nodesHasRmu.add(data);
        }
      }
    });

    final equipmentTu = equipments.where((element) => element.inspectionCategory == InspectionCategory.lineTU).toList() ?? List.empty();
    final nodesHasTu = <EquipmentModel>[];
    equipmentTu.forEach((element) {
      final data = kinks.firstWhere((e) => e.id == element.nodeId, orElse: () => null);
      if (data != null) {
        final dataExist = nodesHasTu.firstWhere((element) => element.id == data.id, orElse: () => null);
        if (dataExist == null) {
          nodesHasTu.add(data);
        }
      }
    });

    final equipmentUnderGroundCables = equipments.where((element) => element.inspectionCategory == InspectionCategory.ineUndergroundCables).toList() ?? List.empty();
    final nodesHasUnderGroundCables = <EquipmentModel>[];
    equipmentUnderGroundCables.forEach((element) {
      final data = kinks.firstWhere((e) => e.id == element.nodeId, orElse: () => null);
      if (data != null) {
        final dataExist = nodesHasUnderGroundCables.firstWhere((element) => element.id == data.id, orElse: () => null);
        if (dataExist == null) {
          nodesHasUnderGroundCables.add(data);
        }
      }
    });

    final equipmentCapacitor = equipments.where((element) => element.inspectionCategory == InspectionCategory.lineCapacitor).toList() ?? List.empty();
    final nodesHasCapacitor = <EquipmentModel>[];
    equipmentCapacitor.forEach((element) {
      final data = kinks.firstWhere((e) => e.id == element.nodeId, orElse: () => null);
      if (data != null) {
        final dataExist = nodesHasCapacitor.firstWhere((element) => element.id == data.id, orElse: () => null);
        if (dataExist == null) {
          nodesHasCapacitor.add(data);
        }
      }
    });

    final equipmentBreaker = equipments.where((element) => element.inspectionCategory == InspectionCategory.lineBreaker).toList() ?? List.empty();
    final nodesHasBreaker = <EquipmentModel>[];
    equipmentBreaker.forEach((element) {
      final data = kinks.firstWhere((e) => e.id == element.nodeId, orElse: () => null);
      if (data != null) {
        final dataExist = nodesHasBreaker.firstWhere((element) => element.id == data.id, orElse: () => null);
        if (dataExist == null) {
          nodesHasBreaker.add(data);
        }
      }
    });

    lineContentModel.popups = popups;
    lineContentModel.tis = nodesHasTi;
    lineContentModel.rmus = nodesHasRmu;
    lineContentModel.tus = nodesHasTu;
    lineContentModel.underGroundCables = nodesHasUnderGroundCables;
    lineContentModel.capacitor = nodesHasCapacitor;
    lineContentModel.breakers = nodesHasBreaker;

    await saveLineBranchContent(
        ticketId: offlineTicketId,
        lineBranchId: lineBranchInfo.id,
        contentModel: lineContentModel);
  }

  Future<String> createLineTicket(
      {TicketType inspectionType,
        String lineId,
        String branchId,
        String workId,
        List<EquipmentModel> kinks,
        List<EquipmentModel> equipments,
        bool isAll = false,
        bool isSingleBranch = false,
        LineTicketArgument lineTicketArgument,
        List<LineModel> branchSelected}) async {
    ///Tạo thông tin chung
    final line = await getLine(lineId);
    final branch = await getLine(branchId);
    final offlineTicketId = 'offlineID_${const Uuid().v1()}';
    final lineGeneral = LineGeneral();
    lineGeneral.lineId = lineId;
    lineGeneral.lineName = line.name;
    lineGeneral.owned = line.owned;
    lineGeneral.isAll = isAll;
    lineGeneral.inspectionRequest = lineTicketArgument.fre;
    lineGeneral.isSingleBranch = isSingleBranch;

    // tao nhanh duong day
    final branchInfo = LineBranchInfo();
    final lineBranchId = 'offline_$branchId';
    branchInfo.id = lineBranchId;
    branchInfo.startNode = kinks.first.name;
    branchInfo.startNodeId = kinks.first.id;
    branchInfo.endNode = kinks.last.name;
    branchInfo.endNodeId = kinks.last.id;
    branchInfo.lineBranchId = branchId;
    branchInfo.outOfLine = branch.name;
    branchInfo.outOfLineId = branch.id;
    branchInfo.lineBranchName = branch.name;
    branchInfo.selectedBranchModel = branchSelected?.map((e) => SelectedBranchModel.fromLineModel(e))?.toList();
    lineGeneral.listLineBranchInfo = [branchInfo];

    await createContentLineBranch(offlineTicketId, kinks, equipments,
        lineBranchId, lineGeneral.listLineBranchInfo, branchInfo);

    await saveLineGeneral(general: lineGeneral, ticketId: offlineTicketId);
    return offlineTicketId;
  }

  Future<void> addOneBranch(String ticketId,
      {String lineBranchId,
        String lineChild,
        String workId,
        TicketType ticketType,
        List<EquipmentModel> kinks,
        List<EquipmentModel> equipments,
        List<LineModel> branchSelected}) async {
    final branchLine = await getLine(lineBranchId);
    final generalInfo = await getLineGeneral(ticketId: ticketId);
    final existLineBranchInfo = LocalDataManager.shared.getLineContent(ticketId) ?? List.empty();

    final branchInfo = LineBranchInfo();
    branchInfo.id = 'offline_$lineBranchId';
    branchInfo.startNode = kinks.first.name;
    branchInfo.startNodeId = kinks.first.id;
    branchInfo.endNode = kinks.last.name;
    branchInfo.endNodeId = kinks.last.id;
    branchInfo.lineBranchId = lineBranchId;
    branchInfo.lineChildId = lineChild;
    branchInfo.outOfLine = branchLine.name;
    branchInfo.outOfLineId = branchLine.id;
    branchInfo.lineBranchName = branchLine.name;
    branchInfo.selectedBranchModel = branchSelected?.map((e) => SelectedBranchModel.fromLineModel(e))?.toList();

    existLineBranchInfo.add(branchInfo);
    generalInfo.listLineBranchInfo = existLineBranchInfo;
    generalInfo.isUpdateOffline = true;

    await createContentLineBranch(ticketId, kinks, equipments, branchInfo.id,
        generalInfo.listLineBranchInfo, branchInfo);

    await saveLineGeneral(general: generalInfo, ticketId: ticketId, workId: workId, ticketType: ticketType, isOffline: true);
  }

  Future changeStatusLineWorkWhenCreate(TicketType ticketType, String workId, String ticketId) async {
    if (workId == null) {
      return;
    }
    //change work status
    final workType = getWorkType(SubStationType.mediumVoltage, ticketType).toString();
    final works = await getWorks(SubStationType.mediumVoltage, workType);
    final work = works.firstWhere((element) => element.workId == workId, orElse: () => null);
    if (work != null) {
      work.entityId = ticketId;
      work.workStatus = WorkStatusType.Inprogress;
      work.workStatusName = 'Đang thực hiện';
      work.isCreateOffline = true;
    }

    await saveWorks(works, SubStationType.mediumVoltage, workType);
  }

  //update work isHasDataUpdateOffline
  Future changeStatusLineWorkWhenUpdate(TicketType ticketType, String workId, String ticketId, {bool isHasDataUpdateOffline = false}) async {
    //change work status
    if (workId == null) {
      return;
    }
    final workType = getWorkType(SubStationType.mediumVoltage, ticketType).toString();
    final works = await getWorks(SubStationType.mediumVoltage, workType);
    final work = works.firstWhere((element) => element.workId == workId, orElse: () => null);
    if (work != null) {
      work.isHasDataUpdateOffline = isHasDataUpdateOffline;
    }
    await saveWorks(works, SubStationType.mediumVoltage, workType);
  }

  Future updateLineResultOffline(String time, String ticketId, String workId, TicketType ticketType, {bool isOffline = true}) async {
    //Update popup: nếu không tìm thấy data offline hoặc không tìm thấy công việc thì trả về lỗi
    if (!isOffline) {
      final resultJSON = await getResult(ticketId);
      if (resultJSON == null || workId == null) {
        return;
      }
    }


    final result = await getResult(ticketId);
    LineResultModel resultModel;
    if (result != null) {
      resultModel =  LineResultModel.fromJson(result);
    } else {
      resultModel =  LineResultModel();
    }

    resultModel.settlementTime = time ?? DateTime.now().add(const Duration(days: 1));
    resultModel.isUpdateOffline = isOffline;
    await saveResult(resultModel.toJson(), ticketId);

    await changeStatusLineWorkWhenUpdate(ticketType, workId, ticketId,
        isHasDataUpdateOffline:
        await hasDataHandleOffline(workId, ticketId, ticketType));

    return true;
  }

  Future<bool> saveLineGeneral({LineGeneral general, String ticketId, String workId, TicketType ticketType, bool isOffline}) async {
     if (isOffline != null) {
       final data = await getLineGeneral(ticketId: ticketId);
       if (data == null || workId == null ) {
         return false;
       }
     }

    final prefs = Hive.box(DatabaseBoxName.general);
    final key =
        '${DatabaseBoxName.general}_${getUserId()}_$ticketId';

    if (general == null) {
      await prefs.put(key, null);
      return true;
    }

    await prefs.put(key, general.toJson());

    await changeStatusLineWorkWhenUpdate(ticketType, workId, ticketId,
        isHasDataUpdateOffline:
            await hasDataHandleOffline(workId, ticketId, ticketType));

    return true;
  }

  Future<LineGeneral> getLineGeneral({@required String ticketId}) async {
    final prefs = Hive.box(DatabaseBoxName.general);
    final key =
        '${DatabaseBoxName.general}_${getUserId()}_$ticketId';
    final json = prefs.get(key);
    if (json == null) {
      return null;
    }
    return LineGeneral.fromJson(JSON({'data': json}));
  }

  Future<bool> saveLinePopup<T>(
      T dataPopup, String ticketId, String lineBranchId, String equipmentId,
      {String workId,
      TicketType ticketType,
      bool isOffline,
      int inspectionCategory}) async {
    //Update popup: nếu không tìm thấy popup hoặc không tìm thấy công việc thì trả về lỗi
    if (isOffline != null) {
      final data = getLineContent(ticketId);
      if (data == null  ) {
        return false;
      }
    }

    final prefs = Hive.box(DatabaseBoxName.linePopup);
    final key =
        '${DatabaseBoxName.linePopup}_${getUserId()}_${ticketId}_${lineBranchId}_$equipmentId';
    if (dataPopup is LineBeamModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }if (dataPopup is LinePoleModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineFundamentModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineWireModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineInsulationModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineRodGadModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineLightningArresterModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineEarthingModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineDisconnectorsSwitchModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineRecloserModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    } else if (dataPopup is LineCuttingMachineModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineFuseCutOutModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineCapacitorModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineMeasureTheBoundaryModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineUndergroundCable) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineTUModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineTiModel) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineRmu) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }else if (dataPopup is LineBreaker) {
      final data = dataPopup.toJson();
      await prefs.put(key, data);
    }

    await changeStatusLineWorkWhenUpdate(ticketType, workId, ticketId,
        isHasDataUpdateOffline:
            await hasDataHandleOffline(workId, ticketId, ticketType));

    return true;
  }

  Future<bool> hasDataHandleOffline(String workId, String ticketId, TicketType ticketType) async {
    final general = await getLineGeneral(ticketId: ticketId);
    if (general == null) {
      return false;
    }
    if (general?.isUpdateOffline == true) {
      return true;
    }

    final resultJSON = await getResult(ticketId);
    if (resultJSON == null) {
      return false;
    }

    final result = LineResultModel.fromJson(resultJSON);
    if (result?.isUpdateOffline == true) {
      return true;
    }

    final content = getLineContent(ticketId);
    if (content == null) {
      return false;
    }
    for(final element in content){
      final branchContent = getLineBranchContent(ticketId: ticketId, lineBranchId: element.id);
      if (branchContent?.isUpdateOffline == true) {
        return true;
      }

      var hasPopupUpdateOffline = false;
      for(final popup in branchContent?.popups ?? List<PopupsDataModel>.empty()){
        final popupModel = getLinePopup<PopupBaseModel>(ticketId, element.id, popup.equipmentId, popup.inspectionCategory);
        if (popupModel?.isUpdateOffline == true) {
          hasPopupUpdateOffline = true;
          break;
        }
      }

      if (hasPopupUpdateOffline) {
        return true;
      }
    }


    return false;
  }

  T getLinePopup<T>(String ticketId, String lineBranchId, String equipmentId, int inspectionCategory, {bool isReturnMap = false}) {
    final prefs = Hive.box(DatabaseBoxName.linePopup);
    final key =
        '${DatabaseBoxName.linePopup}_${getUserId()}_${ticketId}_${lineBranchId}_$equipmentId';
    final json = prefs.get(key);
    if (json == null) {
      return null;
    }
    switch (inspectionCategory) {
      case InspectionCategory.linePole:
        if (isReturnMap) {
          return LinePoleModel.fromJson(JSON(json)).toJson() as T;
        }
        return LinePoleModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineBeam:
        if (isReturnMap) {
          return LineBeamModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineBeamModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineFundament:
        if (isReturnMap) {
          return LineFundamentModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineFundamentModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineWire:
        if (isReturnMap) {
          return LineWireModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineWireModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineInsulation:
        if (isReturnMap) {
          return LineInsulationModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineInsulationModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineRodGap:
        if (isReturnMap) {
          return LineRodGadModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineRodGadModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineLightningArrester:
        if (isReturnMap) {
          return LineLightningArresterModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineLightningArresterModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineEarthing:
        if (isReturnMap) {
          return LineEarthingModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineEarthingModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineDisconnectorsSwitch:
        if (isReturnMap) {
          return LineDisconnectorsSwitchModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineDisconnectorsSwitchModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineRecloser:
        if (isReturnMap) {
          return LineRecloserModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineRecloserModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineCuttingMachine:
        if (isReturnMap) {
          return LineCuttingMachineModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineCuttingMachineModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineFuseCutOut:
        if (isReturnMap) {
          return LineFuseCutOutModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineFuseCutOutModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineCapacitor:
        if (isReturnMap) {
          return LineCapacitorModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineCapacitorModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.lineMeasureTheBoundary:
        if (isReturnMap) {
          return LineMeasureTheBoundaryModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineMeasureTheBoundaryModel.fromJson(JSON(json)) as T;
        break;
      case InspectionCategory.ineUndergroundCables:
        if (isReturnMap) {
          return LineUndergroundCable.fromJson(JSON(json)).toJson() as T;
        }
        return LineUndergroundCable.fromJson(JSON(json)) as T;
        break;

      case InspectionCategory.lineTI:
        if (isReturnMap) {
          return LineTiModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineTiModel.fromJson(JSON(json)) as T;
        break;

      case InspectionCategory.lineTU:
        if (isReturnMap) {
          return LineTUModel.fromJson(JSON(json)).toJson() as T;
        }
        return LineTUModel.fromJson(JSON(json)) as T;
        break;

      case InspectionCategory.lineRMU:
        if (isReturnMap) {
          return LineRmu.fromJson(JSON(json)).toJson() as T;
        }
        return LineRmu.fromJson(JSON(json)) as T;
        break;

      case InspectionCategory.lineBreaker:
        if (isReturnMap) {
          return LineBreaker.fromJson(JSON(json)).toJson() as T;
        }
        return LineBreaker.fromJson(JSON(json)) as T;
        break;
      default:
        break;
    }

    return null;
  }

  Future<bool> saveLineBranchContent({LineContentModel contentModel, String ticketId, String lineBranchId, String workId, TicketType ticketType, bool isOffline, bool isClear = false}) async {
    final prefs = Hive.box(DatabaseBoxName.lineBranchContent);
    final key =
        '${DatabaseBoxName.lineBranchContent}_${getUserId()}_${ticketId}_$lineBranchId';
    if (isClear) {
      await prefs.put(key, null);
      await changeStatusLineWorkWhenUpdate(ticketType, workId, ticketId, isHasDataUpdateOffline: await hasDataHandleOffline(workId, ticketId, ticketType));
      return true;
    }


    if (isOffline != null) {
      final data = getLineBranchContent(ticketId: ticketId, lineBranchId: lineBranchId);
      if (data == null || workId == null) {
        return false;
      }
    }

    await prefs.put(key, contentModel.toDataJson());

    await changeStatusLineWorkWhenUpdate(ticketType, workId, ticketId, isHasDataUpdateOffline: await hasDataHandleOffline(workId, ticketId, ticketType));

    return true;
  }

  LineContentModel getLineBranchContent({@required String ticketId, @required String lineBranchId}) {
    final prefs = Hive.box(DatabaseBoxName.lineBranchContent);
    final key =
        '${DatabaseBoxName.lineBranchContent}_${getUserId()}_${ticketId}_$lineBranchId';
    final json = prefs.get(key);
    if (json == null) {
      return null;
    }
    return LineContentModel.fromJson(JSON(json));
  }

  Future<void> saveLineContent({List<LineBranchInfo> contents, String ticketId}) async {
    final prefs = Hive.box(DatabaseBoxName.lineContent);
    final key =
        '${DatabaseBoxName.lineContent}_${getUserId()}_$ticketId';
    if (contents != null) {
      final data = jsonEncode(contents?.map((e) => e.toJson())?.toList());
      await prefs.put(key, data);
    }
  }

  List<LineBranchInfo> getLineContent(String ticketId) {
    final prefs = Hive.box(DatabaseBoxName.lineContent);
    final key =
        '${DatabaseBoxName.lineContent}_${getUserId()}_$ticketId';
    if (prefs.get(key) == null) {
      return null;
    }
    final jsonData = jsonDecode(prefs.get(key));
    final json = JSON(jsonData);
    final data = json.list?.map((e) => LineBranchInfo.fromJson(e))?.toList();
    return data;
  }

  Future<void> updateBranch(String ticketId,
      {String lineBranchId,
        String lineChild,
        List<EquipmentModel> kinks,
        List<EquipmentModel> equipments,
        List<LineModel> branchSelected,
        String workId, TicketType ticketType, bool isOffline = false
      }) async {
    await removeBranch(ticketId, lineBranchId, workId, ticketType, isOffline: isOffline);
    await addOneBranch(ticketId,
        lineBranchId: lineBranchId,
        kinks: kinks,
        equipments: equipments,
        branchSelected: branchSelected);

  }

  Future clearWorkOffline(WorkModel workModel, SubStationType subStationType,
      TicketType ticketType) async {
    final works = await getWorks(subStationType, getWorkType(subStationType, ticketType).toString());
    works?.removeWhere((element) => element.workId == workModel.workId);
    await saveWorks(works, subStationType, getWorkType(subStationType, ticketType).toString());
    final general = await getLineGeneral(ticketId: workModel.entityId);
    general?.listLineBranchInfo?.forEach((element) {
      removeBranch(workModel.entityId, element.id, workModel.entityId, ticketType);
    });
    await saveLineGeneral(general: null, workId: workModel.entityId, ticketId: workModel.entityId, ticketType: ticketType, isOffline: true);
    await saveResult(null, workModel.entityId);
  }

  Future<void> removeBranch(String ticketId, String branchId, String workId, TicketType ticketType, {bool isOffline = false}) async {
    final generalInfo = await getLineGeneral(ticketId: ticketId);
    if(generalInfo == null) return;
    generalInfo.listLineBranchInfo.removeWhere((element) => element.lineBranchId == branchId);
    final lineBranchContent = getLineBranchContent(ticketId: ticketId, lineBranchId: branchId);
    lineBranchContent?.popups?.forEach((element) {
      saveLinePopup(null, ticketId, branchId, element.equipmentId, workId: workId, ticketType: ticketType, isOffline: isOffline, inspectionCategory: element.inspectionCategory);
    });
    await saveLineContent(ticketId : ticketId, contents: generalInfo.listLineBranchInfo);
    await saveAllNodeBranchSelected(ticketId: ticketId, lineBranchId: branchId, isClear: true);
    await saveLineBranchContent(isClear: true);
    await saveLineGeneral(general: generalInfo, ticketId: ticketId);
  }

  Future<void> saveAllNodeInLine(
      {String lineId, List<EquipmentModel> equipments}) async {
    final prefs = Hive.box(DatabaseBoxName.allNodeInLine);
    final key =
        '${DatabaseBoxName.allNodeInLine}_${getUserId()}_$lineId';
    if (equipments != null) {
      final data = jsonEncode(equipments?.map((e) => e.toMap())?.toList());
      await prefs.put(key, data);
    }
  }

  List<EquipmentModel> getAllNodeInLine(String lineId) {
    final prefs = Hive.box(DatabaseBoxName.allNodeInLine);
    final key =
        '${DatabaseBoxName.allNodeInLine}_${getUserId()}_$lineId';
    final json = JSON(jsonDecode(prefs.get(key)));
    final data = json?.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    return data;
  }

  Future<void> saveAllEquipmentInLine(
      {String lineId, List<EquipmentModel> equipments}) async {
    final prefs = Hive.box(DatabaseBoxName.allEquipmentInLine);
    final key =
        '${DatabaseBoxName.allEquipmentInLine}_${getUserId()}_$lineId';
    if (equipments != null) {
      final data = jsonEncode(equipments?.map((e) => e.toMap())?.toList());
      await prefs.put(key, data);
    }
  }

  List<EquipmentModel> getAllEquipmentInLine(String lineId) {
    final prefs = Hive.box(DatabaseBoxName.allEquipmentInLine);
    final key =
        '${DatabaseBoxName.allEquipmentInLine}_${getUserId()}_$lineId';
    final json = JSON(jsonDecode(prefs.get(key)));
    final data = json.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    return data;
  }

  Future<void> saveAllNodeBranchSelected(
      {String ticketId, String lineBranchId, List<EquipmentModel> equipments, bool isClear = false}) async {
    final prefs = Hive.box(DatabaseBoxName.allEquipmentInLine);
    final key =
        '${DatabaseBoxName.allEquipmentInLine}_${getUserId()}_$ticketId$lineBranchId';
    if (isClear) {
      await prefs.put(key, null);
      return;
    }
    if (equipments != null) {
      final data = jsonEncode(equipments?.map((e) => e.toMap())?.toList());
      await prefs.put(key, data);
    }
  }

  List<EquipmentModel> getAllNodeBranchSelected(String ticketId, String lineBranchId) {
    final prefs = Hive.box(DatabaseBoxName.allEquipmentInLine);
    final key =
        '${DatabaseBoxName.allEquipmentInLine}_${getUserId()}_$ticketId$lineBranchId';

    if (prefs.get(key) == null) {
      return null;
    }
    final json = JSON(jsonDecode(prefs.get(key)));
    final data = json.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    return data;
  }

  Future<void> saveEquipmentDistinctBranchSelected(
      {String ticketId, String lineBranchId, List<EquipmentModel> equipments}) async {
    final prefs = Hive.box(DatabaseBoxName.allEquipmentDistinctInBranch);
    final key =
        '${DatabaseBoxName.allEquipmentDistinctInBranch}_${getUserId()}_$ticketId$lineBranchId';
    if (equipments != null) {
      final data = jsonEncode(equipments?.map((e) => e.toMap())?.toList());
      await prefs.put(key, data);
    }
  }

  List<EquipmentModel> getEquipmentDistinctBranchSelected(String ticketId, String lineBranchId) {
    final prefs = Hive.box(DatabaseBoxName.allEquipmentDistinctInBranch);
    final key =
        '${DatabaseBoxName.allEquipmentDistinctInBranch}_${getUserId()}_$ticketId$lineBranchId';
    final json = JSON(jsonDecode(prefs.get(key)));
    final data = json.list?.map((e) => EquipmentModel.fromJson(e))?.toList();
    return data;
  }
}

