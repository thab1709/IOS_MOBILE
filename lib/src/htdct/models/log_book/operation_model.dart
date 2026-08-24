// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:g_json/g_json.dart';

import '../../screens/log_book/common/content_option.dart';
import '../day_night/popups/images_model.dart';

class OperationModel {
  String id;
  String createdDate;
  int eventType; //Loại kiểm tra

  //Giao nhận ca
  String modeOperation; // Phương thức vận hành
  String statusOperation; // TÌnh hình vận hành
  String expectedAction; // Thao tác dự kiến ca sau
  String existence; // Các tồn tại trong ca
  String statusAction; // Tình trạng hoạt động bộ đàm điện thoại di động
  String vscnStatus; // Tình trạng VSCN
  String users; // Nhân viên nhận ca

  //Đơn vị công tác
  String startDatePlan; // Thời gian kế hoạch bắt đầu
  String endDatePlan; // Thời gain kế hoạch kết thúc
  String startDateReal; // Thời gian thực tế bắt đầu
  String endDateReal; // Thời gian thực tế kết thúc
  int workBase; // Căn cứ công tác
  String equipmentInstallation; // Lắp đặt thiết bị
  String handle; // Xử lý
  String schedule; // Định kỳ
  String measurements; // Đo kiểm
  String operation; // Vận hành
  String inspectionTeam; // Đoàn kiểm tra
  String other; // Khác
  String substationId; // Trạm
  String lineId; // Đường dây
  String pmisEquipmentCategories; // Đối tượng công tác
  String scopeWork; // PHạm vi công tác
  String unitWork; // đơn vị công tác
  String contentWork; // Nội dung công tác
  String leadDirect; // CHỉ huy trực tiếp
  String monitorElectric; // Giám sát an toàn điện
  String pmisEquipmentCategoriesChecks; // Đã thực hiện
  String pmisEquipmentCategoriesNonChecks; // Chưa thực hiện
  String reason; // Lý do
  String note; // Ghi chú

  //Đơn vị thao tác
  String operationName; // Tên nhóm thao tác
  String userOperations; // Danh sách người thao tác
  String purposeOperation; // Mục đích thao tác
  String oderTime; // Giờ nhận lệnh
  String userCommand; //  Người ra lệnh
  String completeTime; // Giờ thao tác xong
  String reporters; // người báo
  String receiver; // Người nhận
  String otherReceiver; // Người nhận khác

  //Bất thường
  String dateStart; // Thời gian bắt đầu
  String endDate; // Thời gian kết thúc
  int typeAbnormal; // PHân loại bất thường
  String contentAbnormal; // Nội dung bất thường
  String reasonAbnormal; // Nguyên nhân bất thường
  String solution; // Biện pháp xử lý
  String unitHandle; // Đơn vị xử lý
  String resultHandler; // Kết quả xử lý

  //MC trung thế nhảy
  String timeJump; // Thời gian nhảy
  String timeRecover; // Thời gian khôi phục
  String protectType; // Loại bảo vệ tác động
  int linePhaseA; // Dòng sự cố pha A
  int linePhaseB; // Dòng sự cố pha B
  int linePhaseC; // Dòng sự cố pha C
  int linePhaseN; // Dòng sự cố pha N
  int voltagePhaseA; // Điện áp sự cố pha A
  int voltagePhaseB; // Điện áp sự cố pha B
  int voltagePhaseC; // Điện áp sự cố pha C
  int voltagePhaseN; // Điện áp sự cố pha N
  String mcEquipmentId; //Máy cắt
  String mbaEquipmentId; // Máy biến áp
  String powerSupply; // Cấp cho điện lực
  String otherUnit; // Đơn vị khác
  String impactType; //loại tác động của máy cắt

  //Đầy tải
  String equipmentsName; // Tên thiết bị
  double loadCarry; // Dòng mang tải
  double ratedCurrent; // Dòng định mức

  //Sự cố
  int troubleType; // PHân loại sự cố
  String incidentTrouble; // diễn biến sự cố
  int causeImpact; // NGuyên nhân tác động
  String detailReason; // Chi tiêt nguyên nhân
  String responsibleUnit; // ĐƠn vị chịu trách nhiệm

  //Đảm bảo điện
  String contentDBD; // Nội dung DBD
  String mcElectric; // Máy cắt đảm bảo điện

  //Khác
  String otherContent; // Nội dung khác
  List<Images> images;

  String createdUser;
  String userGroupName;

  OperationModel(
      {this.id,
      this.createdDate,
      this.eventType,
      this.modeOperation,
      this.statusOperation,
      this.expectedAction,
      this.existence,
      this.statusAction,
      this.vscnStatus,
      this.users,
      this.startDatePlan,
      this.endDatePlan,
      this.startDateReal,
      this.endDateReal,
      this.workBase,
      this.equipmentInstallation,
      this.handle,
      this.schedule,
      this.measurements,
      this.operation,
      this.inspectionTeam,
      this.other,
      this.substationId,
      this.lineId,
      this.pmisEquipmentCategories,
      this.scopeWork,
      this.unitWork,
      this.contentWork,
      this.leadDirect,
      this.monitorElectric,
      this.pmisEquipmentCategoriesChecks,
      this.pmisEquipmentCategoriesNonChecks,
      this.reason,
      this.note,
      this.operationName,
      this.userOperations,
      this.purposeOperation,
      this.oderTime,
      this.userCommand,
      this.completeTime,
      this.reporters,
      this.receiver,
      this.otherReceiver,
      this.dateStart,
      this.endDate,
      this.typeAbnormal,
      this.contentAbnormal,
      this.reasonAbnormal,
      this.solution,
      this.unitHandle,
      this.resultHandler,
      this.timeJump,
      this.timeRecover,
      this.protectType,
      this.linePhaseA,
      this.linePhaseB,
      this.linePhaseC,
      this.linePhaseN,
      this.voltagePhaseA,
      this.voltagePhaseB,
      this.voltagePhaseC,
      this.voltagePhaseN,
      this.mcEquipmentId,
      this.mbaEquipmentId,
      this.powerSupply,
      this.otherUnit,
      this.impactType,
      this.equipmentsName,
      this.loadCarry,
      this.ratedCurrent,
      this.troubleType,
      this.incidentTrouble,
      this.causeImpact,
      this.detailReason,
      this.responsibleUnit,
      this.contentDBD,
      this.mcElectric,
      this.otherContent,
      this.images,
      this.createdUser,
      this.userGroupName});

  OperationModel.fromJson(JSON json) {
    id = json['id'].string;
    createdDate = json['createdDate'].string;
    eventType = json['eventType'].integer;
    modeOperation = json['modeOperation'].string;
    statusOperation = json['statusOperation'].string;
    expectedAction = json['expectedAction'].string;
    existence = json['existence'].string;
    statusAction = json['statusAction'].string;
    vscnStatus = json['vscnStatus'].string;
    users = json['users'].string;
    startDatePlan = json['startDatePlan'].string;
    endDatePlan = json['endDatePlan'].string;
    startDateReal = json['startDateReal'].string;
    endDateReal = json['endDateReal'].string;
    workBase = json['workBase'].integer;
    equipmentInstallation = json['equipmentInstallation'].string;
    handle = json['handle'].string;
    schedule = json['schedule'].string;
    measurements = json['measurements'].string;
    operation = json['operation'].string;
    inspectionTeam = json['inspectionTeam'].string;
    other = json['other'].string;
    substationId = json['substationId'].string;
    lineId = json['lineId'].string;
    pmisEquipmentCategories = json['pmisEquipmentCategories'].string;
    scopeWork = json['scopeWork'].string;
    unitWork = json['unitWork'].string;
    contentWork = json['contentWork'].string;
    leadDirect = json['leadDirect'].string;
    monitorElectric = json['monitorElectric'].string;
    pmisEquipmentCategoriesChecks =
        json['pmisEquipmentCategoriesChecks'].string;
    pmisEquipmentCategoriesNonChecks =
        json['pmisEquipmentCategoriesNonChecks'].string;
    reason = json['reason'].string;
    note = json['note'].string;
    operationName = json['operationName'].string;
    userOperations = json['userOperations'].string;
    purposeOperation = json['purposeOperation'].string;
    oderTime = json['oderTime'].string;
    userCommand = json['userCommand'].string;
    completeTime = json['completeTime'].string;
    reporters = json['reporters'].string;
    receiver = json['receiver'].string;
    otherReceiver = json['otherReceiver'].string;
    dateStart = json['dateStart'].string;
    endDate = json['endDate'].string;
    typeAbnormal = json['typeAbnormal'].integer;
    contentAbnormal = json['contentAbnormal'].string;
    reasonAbnormal = json['reasonAbnormal'].string;
    solution = json['solution'].string;
    unitHandle = json['unitHandle'].string;
    resultHandler = json['resultHandler'].string;
    timeJump = json['timeJump'].string;
    timeRecover = json['timeRecover'].string;
    protectType = json['protectType'].string;
    linePhaseA = json['linePhaseA'].integer;
    linePhaseB = json['linePhaseB'].integer;
    linePhaseC = json['linePhaseC'].integer;
    linePhaseN = json['linePhaseN'].integer;
    voltagePhaseA = json['voltagePhaseA'].integer;
    voltagePhaseB = json['voltagePhaseB'].integer;
    voltagePhaseC = json['voltagePhaseC'].integer;
    voltagePhaseN = json['voltagePhaseN'].integer;
    mcEquipmentId = json['mcEquipmentId'].string;
    mbaEquipmentId = json['mbaEquipmentId'].string;
    powerSupply = json['powerSupply'].string;
    otherUnit = json['otherUnit'].string;
    impactType = json['impactType'].string;
    equipmentsName = json['equipmentsName'].string;
    loadCarry = json['loadCarry'].ddouble;
    ratedCurrent = json['ratedCurrent'].ddouble;
    troubleType = json['troubleType'].integer;
    incidentTrouble = json['incidentTrouble'].string;
    causeImpact = json['causeImpact'].integer;
    detailReason = json['detailReason'].string;
    responsibleUnit = json['responsibleUnit'].string;
    contentDBD = json['contentDBD'].string;
    mcElectric = json['mcElectric'].string;
    otherContent = json['otherContent'].string;
    createdUser = json['createdUser'].string;
    userGroupName = json['userGroupName'].string;
    if (json['images'] != null) {
      final data = json['images'].listObject;
      images = data?.map((e) => Images.fromJsonNotMap(JSON(e)))?.toList();
    } else {
      images = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['createdDate'] = createdDate;
    data['eventType'] = eventType;
    data['modeOperation'] = modeOperation;
    data['statusOperation'] = statusOperation;
    data['expectedAction'] = expectedAction;
    data['existence'] = existence;
    data['statusAction'] = statusAction;
    data['vscnStatus'] = vscnStatus;
    data['users'] = users;
    data['startDatePlan'] = startDatePlan;
    data['endDatePlan'] = endDatePlan;
    data['startDateReal'] = startDateReal;
    data['endDateReal'] = endDateReal;
    data['workBase'] = workBase;
    data['equipmentInstallation'] = equipmentInstallation;
    data['handle'] = handle;
    data['schedule'] = schedule;
    data['measurements'] = measurements;
    data['operation'] = operation;
    data['inspectionTeam'] = inspectionTeam;
    data['other'] = other;
    data['substationId'] = substationId;
    data['lineId'] = lineId;
    data['pmisEquipmentCategories'] = pmisEquipmentCategories;
    data['scopeWork'] = scopeWork;
    data['unitWork'] = unitWork;
    data['contentWork'] = contentWork;
    data['leadDirect'] = leadDirect;
    data['monitorElectric'] = monitorElectric;
    data['pmisEquipmentCategoriesChecks'] = pmisEquipmentCategoriesChecks;
    data['pmisEquipmentCategoriesNonChecks'] = pmisEquipmentCategoriesNonChecks;
    data['reason'] = reason;
    data['note'] = note;
    data['operationName'] = operationName;
    data['userOperations'] = userOperations;
    data['purposeOperation'] = purposeOperation;
    data['oderTime'] = oderTime;
    data['userCommand'] = userCommand;
    data['completeTime'] = completeTime;
    data['reporters'] = reporters;
    data['receiver'] = receiver;
    data['otherReceiver'] = otherReceiver;
    data['dateStart'] = dateStart;
    data['endDate'] = endDate;
    data['typeAbnormal'] = typeAbnormal;
    data['contentAbnormal'] = contentAbnormal;
    data['reasonAbnormal'] = reasonAbnormal;
    data['solution'] = solution;
    data['unitHandle'] = unitHandle;
    data['resultHandler'] = resultHandler;
    data['timeJump'] = timeJump;
    data['timeRecover'] = timeRecover;
    data['protectType'] = protectType;
    data['linePhaseA'] = linePhaseA;
    data['linePhaseB'] = linePhaseB;
    data['linePhaseC'] = linePhaseC;
    data['linePhaseN'] = linePhaseN;
    data['voltagePhaseA'] = voltagePhaseA;
    data['voltagePhaseB'] = voltagePhaseB;
    data['voltagePhaseC'] = voltagePhaseC;
    data['voltagePhaseN'] = voltagePhaseN;
    data['mcEquipmentId'] = mcEquipmentId;
    data['mbaEquipmentId'] = mbaEquipmentId;
    data['powerSupply'] = powerSupply;
    data['otherUnit'] = otherUnit;
    data['impactType'] = impactType;
    data['equipmentsName'] = equipmentsName;
    data['loadCarry'] = loadCarry;
    data['ratedCurrent'] = ratedCurrent;
    data['troubleType'] = troubleType;
    data['incidentTrouble'] = incidentTrouble;
    data['causeImpact'] = causeImpact;
    data['detailReason'] = detailReason;
    data['responsibleUnit'] = responsibleUnit;
    data['contentDBD'] = contentDBD;
    data['mcElectric'] = mcElectric;
    data['otherContent'] = otherContent;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    }
    return data;
  }

  bool checkValid({bool isSubstationInppect = true}) {
    if (eventType == ContentOptions.workUnit.value) {
      if (
          // startDatePlan.isNullOrEmpty() ||
          //     endDatePlan.isNullOrEmpty() ||
          startDateReal.isNullOrEmpty() ||
              isBefore(
                  dateTimeStart: startDatePlan, dateTimeEnd: endDatePlan) ||
              isBefore(
                  dateTimeStart: startDateReal, dateTimeEnd: endDateReal) ||
              workBase == null ||
              checkValidEquipmentInstallation() == false ||
              checkPmisEquipmentCategories() == false ||
              (!pmisEquipmentCategoriesNonChecks.isNullOrEmpty() &&
                  reason.isNullOrBlank()) ||
              (isSubstationInppect && substationId.isNullOrEmpty()) ||
              (!isSubstationInppect && lineId.isNullOrEmpty()) ||
              pmisEquipmentCategories.isNullOrEmpty() ||
              scopeWork.isNullOrEmpty() ||
              unitWork.isNullOrEmpty() ||
              contentWork.isNullOrEmpty() ||
              images == null ||
              images.isEmpty) {
        return false;
      }
    } else if (eventType == ContentOptions.abnormal.value) {
      if (dateStart.isNullOrEmpty() ||
          isBefore(dateTimeStart: dateStart, dateTimeEnd: endDate) ||
          (isSubstationInppect && substationId.isNullOrEmpty()) ||
          (!isSubstationInppect && lineId.isNullOrEmpty()) ||
          pmisEquipmentCategories.isNullOrEmpty() ||
          typeAbnormal == null ||
          contentAbnormal.isNullOrBlank() ||
          images == null ||
          images.isEmpty) {
        return false;
      }
    } else if (eventType == ContentOptions.MCTTN.value) {
      if (timeJump.isNullOrEmpty() ||
          isBefore(dateTimeStart: timeJump, dateTimeEnd: timeRecover) ||
          !checkPhase() ||
          substationId.isNullOrEmpty() ||
          mcEquipmentId.isNullOrEmpty() ||
          mbaEquipmentId.isNullOrEmpty() ||
          powerSupply.isNullOrEmpty()) {
        return false;
      }
    } else if (eventType == ContentOptions.fullLoad.value) {
      if (dateStart.isNullOrEmpty() ||
          isBefore(dateTimeStart: dateStart, dateTimeEnd: endDate) ||
          (isSubstationInppect && substationId.isNullOrEmpty()) ||
          (!isSubstationInppect && lineId.isNullOrEmpty()) ||
          equipmentsName.isNullOrEmpty() ||
          loadCarry == null ||
          ratedCurrent == null) {
        return false;
      }
    } else if (eventType == ContentOptions.troubleshot.value) {
      if (dateStart.isNullOrEmpty() ||
          isBefore(dateTimeStart: dateStart, dateTimeEnd: endDate) ||
          (isSubstationInppect && substationId.isNullOrEmpty()) ||
          (!isSubstationInppect && lineId.isNullOrEmpty()) ||
          equipmentsName.isNullOrEmpty() ||
          troubleType == null ||
          incidentTrouble.isNullOrEmpty() ||
          images == null ||
          images.isEmpty) {
        return false;
      }
    } else if (eventType == ContentOptions.guaranteeElectricity.value) {
      if (dateStart.isNullOrEmpty() ||
          isBefore(dateTimeStart: dateStart, dateTimeEnd: endDate) ||
          (isSubstationInppect &&
              (mcElectric.isNullOrEmpty() || substationId.isNullOrEmpty())) ||
          (!isSubstationInppect && lineId.isNullOrEmpty()) ||
          contentDBD.isNullOrEmpty() ||
          images == null ||
          images.isEmpty) {
        return false;
      }
    } else if (eventType == ContentOptions.other.value) {
      if (dateStart.isNullOrEmpty() ||
          isBefore(dateTimeStart: dateStart, dateTimeEnd: endDate) ||
          receiver.isNullOrEmpty() ||
          otherContent.isNullOrEmpty() ||
          images == null ||
          images.isEmpty) {
        return false;
      }
    }
    return true;
  }

  bool checkValidEquipmentInstallation() {
    if (equipmentInstallation.isNullOrEmpty() &&
        handle.isNullOrEmpty() &&
        schedule.isNullOrEmpty() &&
        measurements.isNullOrEmpty() &&
        operation.isNullOrEmpty() &&
        inspectionTeam.isNullOrEmpty()) {
      return false;
    }
    return true;
  }

  bool checkPmisEquipmentCategories() {
    if (pmisEquipmentCategoriesChecks.isNullOrEmpty() &&
        pmisEquipmentCategoriesNonChecks.isNullOrEmpty()) {
      return false;
    }
    return true;
  }

  bool isBefore({String dateTimeStart, String dateTimeEnd}) {
    if (!dateTimeStart.isNullOrEmpty() && !dateTimeEnd.isNullOrEmpty()) {
      return DateTime.parse(dateTimeEnd)
          .isBefore(DateTime.parse(dateTimeStart));
    }
    return false;
  }

  bool checkPhase() {
    if (linePhaseA == null &&
        linePhaseB == null &&
        linePhaseC == null &&
        linePhaseN == null &&
        voltagePhaseA == null &&
        voltagePhaseB == null &&
        voltagePhaseC == null &&
        voltagePhaseN == null) {
      return false;
    }
    return true;
  }

  String get dateStartLocalTZ =>
      dateStart?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get endDateLocalTZ =>
      endDate?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get timeJumpLocalTZ =>
      timeJump?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get timeRecoverLocalTZ =>
      timeRecover?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get startDatePlanLocalTZ =>
      startDatePlan?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get endDatePlanLocalTZ =>
      endDatePlan?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get startDateRealLocalTZ =>
      startDateReal?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);

  String get endDateRealLocalTZ =>
      endDateReal?.fromFormatUtcToFormatLocal(HighElectricStrings.utcFormat);
}

