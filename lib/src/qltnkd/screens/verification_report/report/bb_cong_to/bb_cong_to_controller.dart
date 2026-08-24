// @dart=2.9
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/htdct/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/constance/strings.dart';
import '../../../../models/meter/meter_update.dart';
import '../../../../models/option_model.dart';
import '../../../../services/responsitory/bb_cong_to_repository.dart';
import '../../../../services/responsitory/report_repository.dart';

//- Nếu địa điểm là [Công tơ tại hiện trường] => sinh ra form theo tempalte file [BM-QT KĐHC-01.04- Hiện trường các loại công tơ]
//- Nếu địa điểm là [Công tơ tại phòng] 1F3G, 3F1G, 3F3GTT, 3F3GGT=> sinh ra form theo tempalte file [BM-QT KĐHC-01.03-3F điện tử]
//- Nếu địa điểm là [Công tơ tại phòng] + 1FC, 1F1G,3FC=> sinh ra form theo tempalte file [BM-QT KĐHC-01.02-1F, 3F cơ khí và 1F1G điện tử]
//(riêng 3F1G form nhập ẩn R1,R2,R3 đi) => khi in BB nó show dấu "\"

class BBCongToController extends GetxController {
  final meteDetailModel = MeterDetail().obs;
  final _repo = BBCongToRepository();
  final _reportRepo = ReportRepository();
  final listEquipmentInspection = <ThietBiKiemModel>[].obs;
  final listMeasuringCommentMeterElectric = <StringOptionModel>[].obs;
  final listMeasuringCommentCircuit = <StringOptionModel>[].obs;
  final listMeasuringCommentAnotherIdea = <StringOptionModel>[].obs;
  final focusNode = FocusNode();

  void unFocus() {
    focusNode.requestFocus();
    focusNode.unfocus();
  }

  final reportType = 1.obs;
  final type1 = 1; //BM-QT KĐHC-01.04- Hiện trường các loại công tơ
  final type2 = 2; //BM-QT KĐHC-01.03-3F điện tử 	1F3G 3F1G 3F3GTT 3F3GGT
  final type3 = 3; //BM-QT KĐHC-01.02-1F, 3F cơ khí và 1F1G điện tử 1FC 1F1G 3FC

  final _groupConclusion = 0.obs;

  int get groupConclusion => _groupConclusion.value;

  set groupConclusion(int value) {
    _groupConclusion.value = value;
    meteDetailModel.value.conclusion = value;
  }

  final int pass = 1; //đạt
  final int fail = 2; //chưa đạt
  final int other = 3; // Khác

  String meterId = '';

  bool enable;

  final isRefresh = false.obs;
  final _isChiSoSauKiem = false.obs;

  bool get isChiSoSauKiem => _isChiSoSauKiem.value;

  set isChiSoSauKiem(bool val) {
    if (!val) {
      meteDetailModel.value.chiSoSauKiemPtGiao = null;
      meteDetailModel.value.chiSoSauKiemQtGiao = null;
      meteDetailModel.value.chiSoSauKiemR1Giao = null;
      meteDetailModel.value.chiSoSauKiemR2Giao = null;
      meteDetailModel.value.chiSoSauKiemR3Giao = null;
      meteDetailModel.value.chiSoSauKiemPtNhan = null;
      meteDetailModel.value.chiSoSauKiemQtNhan = null;
      meteDetailModel.value.chiSoSauKiemR1Nhan = null;
      meteDetailModel.value.chiSoSauKiemR2Nhan = null;
      meteDetailModel.value.chiSoSauKiemR3Nhan = null;
    }
    _isChiSoSauKiem.value = val;
    meteDetailModel.value.chiSoSauKiem = val;
  }

  void setEquipmentInspection(String idEquipment) {
    meteDetailModel.value.thietBiKiemModel = listEquipmentInspection
        .firstWhere((element) => element.id == idEquipment);
    meteDetailModel.refresh();
  }

  void refreshUI() {
    isRefresh.value = true;
    isRefresh.refresh();
  }

  bool isEnable() {
    return enable;
  }

  final _groupErrorType = 0.obs;

  int get groupErrorType => _groupErrorType.value;

  set groupErrorType(int type) {
    _groupErrorType.value = type;
    meteDetailModel.value.errorType = type;
  }

  final _groupValuePlace = 0.obs;

  int get groupValuePlace => _groupValuePlace.value;

  set groupValuePlace(int type) {
    _groupValuePlace.value = type;
    meteDetailModel.value.diaDiem = type;
    _selectReportType();
  }

  void _selectReportType() {
    if (_groupValuePlace.value.toString() == optionsPlace.first.value) {
      reportType.value = type1;
    } else {
      if (_groupValuePhase.value == 0) {
        reportType.value = type3;
      } else {
        if (_groupValuePhase.value == phase1FC ||
            _groupValuePhase.value == phase1F1G ||
            _groupValuePhase.value == phase3FC) {
          reportType.value = type3;
        } else {
          reportType.value = type2;
        }
      }
    }
  }

  final int meterElectric = 1; // công tơ điện
  final int measuring = 2; // mạch đo lường
  final int otherComment = 3; // ý kiến khác

  final int byRequire = 1;
  final int customerQA = 2;
  final int meterError = 3;
  final int errorViolate = 4;

  final _groupValuePhase = 0.obs;

  int get groupValuePhase => _groupValuePhase.value;

  set groupValuePhase(int type) {
    _groupValuePhase.value = type;
    meteDetailModel.value.pha = type;
    _selectReportType();
  }

  final phase1FC = 1; // 1_FC
  final phase1F1G = 2; // 1F1G
  final phase1F3G = 3; // 1F3G
  final phase3FC = 4; // 3FC
  final phase3F1G = 5; // 3F1G
  final phase3F3GTT = 6; // 3F3GTT
  final phase3F3GGT = 7; // 3F3GGT

  final optionsWh = <StringOptionModel>[
    StringOptionModel('KWh', '1'),
    StringOptionModel('MWh', '2'),
  ];

  final optionsVARh = <StringOptionModel>[
    StringOptionModel('kVARh', '3'),
    StringOptionModel('MVARh', '4'),
  ];

  final optionsPlace = <StringOptionModel>[
    StringOptionModel('Tại phòng', '1'),
    StringOptionModel('Tại hiện trường', '2'),
  ];

  final optionsMeterMasterData = <StringOptionModel>[
    StringOptionModel('Công tơ điện', '1'),
    StringOptionModel('Mạch đo lường', '2'),
    StringOptionModel('ý kiến khác', '3'),
  ];

  final optionsStatusWrite = <StringOptionModel>[
    StringOptionModel('Còn nguyên', '1'),
    StringOptionModel('Không còn nguyên', '2'),
    StringOptionModel('Mất', '3'),
    StringOptionModel('Mở', '4'),
    StringOptionModel('Không xác định', '5'),
    StringOptionModel('Không', '6'),
  ];

  final optionsStampType = <StringOptionModel>[
    StringOptionModel('Còn nguyên', '1'),
    StringOptionModel('Không còn nguyên', '2'),
    StringOptionModel('Mất', '3'),
    StringOptionModel('Mở', '4'),
    StringOptionModel('Không xác định', '5'),
    StringOptionModel('Không', '6'),
  ];

  bool validateGeneralInfo() {
    if (meteDetailModel.value.diaDiem == null) {
      rShowDialogOneButton('Vui lòng chọn địa điểm');
      return false;
    }

    if(meteDetailModel.value.diaDiem.toString() != optionsPlace.first.value) {
      if (meteDetailModel.value.pha == null) {
        rShowDialogOneButton('Vui lòng chọn loại pha');
        return false;
      }
    }


    return true;
  }

  Future getEquipmentInspection() async {
    final res = await _repo.getEquipmentInspection();
    if (res.isLoadSuccess && res?.data?.isNotEmpty == true) {
      listEquipmentInspection.assignAll(res.data);
      meteDetailModel.value.thietBiKiemModel ??=
          res.data.firstWhereOrNull((element) => element.isDefault);
      update();
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future getMeterDetail() async {
    final res = await _repo.getMeterDetail(meterId);
    if (res.isLoadSuccess) {
      meteDetailModel.value = res.data;
      meteDetailModel.value.dateInFormReport ??=
          DateTime.now().toStringFormat(RAppStrings.utcFormatNotZ, isUtc: true);
      _groupValuePlace.value = meteDetailModel.value.diaDiem;
      _groupErrorType.value = meteDetailModel.value.errorType;
      _groupConclusion.value = meteDetailModel.value.conclusion;
      _groupValuePhase.value = meteDetailModel.value.pha;
      _isChiSoSauKiem.value = meteDetailModel.value.chiSoSauKiem;
      _selectReportType();
      update();
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future createEquipment(String name, String code, String ccx) async {
    final res = await _repo.createEquipmentInspection(name, code, ccx);
    if (res.isLoadSuccess) {
      listEquipmentInspection.add(res.data);
      listEquipmentInspection.refresh();
      SnackBarHUD.show('Tạo thiết bị thành công');
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future updateMeter() async {
    final isLocationGranted = await LocationServiceBackground.shared.requestPermission();
    if (!isLocationGranted) return;

    final res = await _repo.updateMeterDetail(meteDetailModel.value);
    if (res.isLoadSuccess) {
      await _reportRepo.sendLocation(meterId, type: 2);
      SnackBarHUD.show('Cập nhật thành công');
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  Future addMeterMeasuringComment(int type, String name) async {
    ProgressHUD.show();
    final res = await _repo.addMeterMeasuringComment(type.toString(), name);
    if (res.isLoadSuccess) {
      await getMeterMeasuringComment(type);
      ProgressHUD.dismiss();
      SnackBarHUD.show('Thêm tùy chọn thành công');
    } else {
      ProgressHUD.dismiss();
      await rShowDialogOneButton(res?.message);
    }
  }

  Future getMeterMeasuringComment(int type) async {
    final res = await _repo.getMeterMeasuringComment(type.toString());
    if (res.isLoadSuccess) {
      if (type == meterElectric) {
        listMeasuringCommentMeterElectric.assignAll(res.data);
        listMeasuringCommentMeterElectric.refresh();
      } else if (type == measuring) {
        listMeasuringCommentCircuit.assignAll(res.data);
        listMeasuringCommentCircuit.refresh();
      } else if (type == otherComment) {
        listMeasuringCommentAnotherIdea.assignAll(res.data);
        listMeasuringCommentAnotherIdea.refresh();
      }
      meteDetailModel.refresh();
      update();
    } else {
      await rShowDialogOneButton(res?.message);
    }
  }

  void setListError(List<StringOptionModel> errors) {
    meteDetailModel.value.tinhTrangCongToTruocKiemDinhCode =
        errors.map((e) => e.value).join(',');
    meteDetailModel.value.tinhTrangCongToTruocKiemDinh =
        errors.map((e) => e.title).join('\n');
    meteDetailModel.refresh();
    update();
  }

  void setDateReport(DateTime date) {
    meteDetailModel.value.dateInFormReport =
        date.toStringFormat(RAppStrings.utcFormatNotZ, isUtc: true);
    update();
  }
}

