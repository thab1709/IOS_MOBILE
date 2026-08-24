// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:get/get.dart';

class ReportDirectorCompanyController extends GetxController {
  final service = ReportRepository();

  String fromDate = '';
  String toDate = '';
  String unitId = '0';
  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();
  List<StringOptionModel> unitOptions = <StringOptionModel>[];
  bool isNewToOld = true;

  StreamController<int> filterController = StreamController<int>.broadcast();

  @override
  void dispose() {
    filterController.close();
    super.dispose();
  }


  final optionsStatus = [
    const IntOptionModel('Đang thực hiện', StatusReportForDirectorCompany.implement),
    const IntOptionModel('Cần ký', StatusReportForDirectorCompany.needSign),
    const IntOptionModel('Hoàn thành', StatusReportForDirectorCompany.complete),
  ];

  void clearFilter() {
    fromDate = '';
    toDate = '';
    unitId = '0';
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
  }

  void reloadPage(int index) {
    filterController.sink.add(index);
  }


  Future getUnitsOnline() async {
    final response = await service.getUnits();
    if (response.isLoadSuccess) {
      unitOptions.clear();
      unitOptions =
          response.data.map((e) => StringOptionModel(e.name, e.id)).toList();
      unitId = '0';
    } else {
      await rShowDialogOneButton(response.message);
    }
  }
}
