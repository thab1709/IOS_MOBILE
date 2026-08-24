// @dart=2.9
import '../../../models/option_model.dart';

class ContentOptions {
  //EventType
  static final shiftForwarding = OptionModel('Giao nhận ca', 1);
  static final workUnit = OptionModel('Đơn vị công tác', 2);
  static final operationUnit = OptionModel('Đơn vị thao tác', 3);
  static final abnormal = OptionModel('Bất thường', 4);
  static final MCTTN = OptionModel('MC trung thế nhảy', 5);
  static final fullLoad = OptionModel('Thiết bị mang tải trên 80%', 6);
  static final troubleshot = OptionModel('Sự cố', 7);
  static final guaranteeElectricity = OptionModel('Đảm bảo điện', 8);
  static final other = OptionModel('Khác', 9);

  //WorkBase
  static final productionPlan = OptionModel('Kế hoạch sản xuất', 1);
  static final unExpected = OptionModel('Đột xuất', 2);
  static final scheduleWeek = OptionModel('Lịch tuần', 3);
  static final assignmentText = OptionModel('Văn bản giao nhiệm vụ', 4);

  //Classify
  static final equipmentInstallation = OptionModel('Lắp đặt thiết bị', 1);
  static final handle = OptionModel('Xử lý', 2);
  static final schedule = OptionModel('Định kỳ', 3);
  static final measurements = OptionModel('Đo kiểm', 4);
  static final operation = OptionModel('Vận hành', 5);
  static final inspectionTeam = OptionModel('Đoàn kiểm tra', 6);
  static final classify_other = OptionModel('Khác', 7);

  //EquipmentInstallation
  static final newAssembly = OptionModel('Lắp mới', 1);
  static final replace = OptionModel('Thay thế', 2);
  static final recall = OptionModel('Thu hồi', 3);
  static final electric = OptionModel('Đóng điện', 4);

  //Handle
  static final heatUp = OptionModel('Phát nhiệt', 1);
  static final exist = OptionModel('Tồn tại', 2);
  static final oilFilter = OptionModel('Lọc dầu', 3);
  static final replaceCable = OptionModel('Thay đầu cáp', 4);

  //Schedule
  static final VSHotline = OptionModel('VS Hotline', 1);
  static final TNKD = OptionModel('TNKĐ', 2);
  static final CBM = OptionModel('CBM', 3);
  static final checkBinary = OptionModel('Kiểm tra sơ bộ mạch nhị thứ', 4);

  //Measurements
  static final lineMeasure = OptionModel('Đo thông số đường dây', 1);
  static final resistanceMeasure = OptionModel('Đo điện trở tiếp địa', 2);
  static final PDMeasure = OptionModel('Đo PD', 3);
  static final csv = OptionModel('Chống sét van', 4);
  static final tsq = OptionModel('Tần số quét', 5);
  static final getOil = OptionModel('Lấy mẫu dầu', 6);

  //Operation
  static final lossSeparation = OptionModel('Tách tổn thất', 1);
  static final role = OptionModel('Chỉnh định Rơ le', 2);

  //InspectionTeam
  static final company = OptionModel('Công ty', 1);
  static final bigCompany = OptionModel('Tổng công ty', 2);
  static final electricCompany = OptionModel('Tập đoàn điện lực', 3);
  static final otherUnit = OptionModel('Đơn vị khác', 4);

  //TypeAbnormal
  static final first = OptionModel('Nhất thứ', 1);
  static final second = OptionModel('Nhị thứ', 2);
  static final scada = OptionModel('HT SCADA + HMI', 3);
  static final htOneDirection = OptionModel('HT 1 chiều', 4);
  static final channel = OptionModel('Kênh truyền', 5);
  static final line = OptionModel('Đường dây', 6);
  static final otherAbnormalType = OptionModel('Khác', 7);

  //ProtectType
  static final IFirst = OptionModel('I >', 1);
  static final ISecond = OptionModel('I >>', 2);
  static final IThird = OptionModel('I >>>', 3);
  static final INFirst = OptionModel('IN >', 4);
  static final INSecond = OptionModel('IN >>', 5);
  static final INThird = OptionModel('IN >>>', 6);
  static final ISef = OptionModel('ISef', 7);
  static final F81First = OptionModel('F81 >', 8);
  static final F81Second = OptionModel('F81 >>', 9);
  static final F81Third = OptionModel('F81 >>>', 10);
  static final F27First = OptionModel('F27 >', 11);
  static final F27Second = OptionModel('F27 >>', 12);
  static final F59First = OptionModel('F59 >', 13);
  static final F59Second = OptionModel('F59 >>', 14);
  static final U3 = OptionModel('3Uo', 15);
  static final otherProtectType = OptionModel('Khác', 16);

  //TroubleType
  static final DZGlimpse = OptionModel('Thoáng qua', 1);
  static final DZLong = OptionModel('Kéo dài', 2);
  static final TBA110 = OptionModel('Ngăn 110KV', 3);
  static final TBATA = OptionModel('Ngăn trung áp', 4);
  static final TBAMBA = OptionModel('Ngăn MBA', 5);
  static final TBAOTHER = OptionModel('Khác', 6);

  //CauseImpact
  static final secondCircuit = OptionModel('Mạch nhị thứ', 1);
  static final TuTi = OptionModel('TU-Ti', 2);
  static final Role = OptionModel('Rơle', 3);
  static final settingValue = OptionModel('giá trị chỉnh định', 4);
  static final InstallWork = OptionModel('Công tác cài đặt', 5);
  static final MC = OptionModel('MC', 6);
  static final Undefined = OptionModel('Chưa xác định', 7);

  //TeamCheck ImpactType
  static final x6 = OptionModel('X6', 1);
  static final evn_hn = OptionModel('EVNHN', 2);
  static final evn = OptionModel('EVN', 3);
  static final otherTeam = OptionModel('Đoàn kiểm tra khác', 0);

  // ImpactCuttingType
  static final DongNhayNgay = OptionModel('B1 Đóng nhảy ngay', 1);
  static final KP_Tot = OptionModel('B1 KP Tốt', 2);
  static final TDL_Tot = OptionModel('TĐL Tốt', 3);
  static final TDL_Xau = OptionModel('TĐL Xấu', 4);
  static final TramDongNhayNgay = OptionModel('Trạm đóng nhảy ngay', 5);
  static final TramKPTOT = OptionModel('Trạm KP tốt', 6);

  //TypeInspect
  static final subStationInspect = OptionModel('Trạm biến áp', 0);
  static final lineInspect = OptionModel('Đường dây', 1);
}

