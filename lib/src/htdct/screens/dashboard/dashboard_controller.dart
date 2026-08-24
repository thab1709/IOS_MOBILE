// @dart=2.9
import 'package:collection/collection.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../app_common/utils/utils.dart';
import '../../../htld/common/utils/global_app.dart';
import '../../common/constance/content_option.dart';
import '../../common/constance/option_type.dart';
import '../../common/constance/strings.dart';
import '../../common/utils/alert_dialog_utils.dart';
import '../../common/utils/common.dart';
import '../../models/dashboard/abnormal_dashboard_model.dart';
import '../../models/dashboard/guarantee_electricity_model.dart';
import '../../models/dashboard/inspect_dashboard_model.dart';
import '../../services/responsitory/dashboard_repository.dart';

class DashboardController extends GetxController {
  DashboardController() {
    initSearchDate();
  }
  RxDouble tempValue = 0.0.obs;
  RxDouble humiValue = 0.0.obs;


  final _dashboardRep = DashboardRepository();
  Rx guaranteeElectricityModel = GuaranteeElectricityModel().obs;
  Rx abnormalModel = AbnormalDashboardModel().obs;
  Rx electricalGridModel = AbnormalDashboardModel().obs;
  Rx abnormalSubstationSelected = true.obs;
  Rx abnormalTyleChart = 0.obs;
  Rx inspectModel = InspectDashboardModel().obs;
  Rx nightInspectModel = InspectDashboardModel().obs;
  Rx lineInspectModel = InspectDashboardModel().obs;
  Rx cableInspectModel = InspectDashboardModel().obs;
  Rx nightLineInspectModel = InspectDashboardModel().obs;
  Rx inspectDayModel = InspectDashboardModel().obs;
  String address = DateTime.now().toStringFormat(HighElectricStrings.ddMMyyyy);
  final numberAbnormalInDay = ''.obs;
  final numberPerformOnGrid = ''.obs;

  DateTime startSearchDateAbnormal = DateTime.now();
  DateTime endSearchDateAbnormal = DateTime.now();
  DateTime startSearchDateAbnormalTemp = DateTime.now();
  DateTime endSearchDateAbnormalTemp = DateTime.now();
  DateTime toStartSearchDateAbnormal = DateTime.now();
  DateTime toEndSearchDateAbnormal = DateTime.now();
  DateTime toStartSearchDateAbnormalTemp = DateTime.now();
  DateTime toEndSearchDateAbnormalTemp = DateTime.now();
  Rx dateAbnormalTextController = TextEditingController().obs;
  Rx toDateAbnormalTextController = TextEditingController().obs;
  Rx<int> calendarTypeAbnormal = ContentOptions.calendarWeek.value.obs;
  Rx<int> calendarTypeAbnormalTemp = ContentOptions.calendarWeek.value.obs;
  Rx<int> statusAbnormal = ContentOptions.workAllStatus.value.obs;
  Rx<int> typeChartAbnormal = 0.obs; // 0-biểu đồ cột, 1=biểu đồ đường
  int typeInspect = 0;
  int typeInspectTemp = 0;

  DateTime startSearchDateInspect = DateTime.now();
  DateTime endSearchDateInspect = DateTime.now();
  DateTime startSearchDateInspectTemp = DateTime.now();
  DateTime endSearchDateInspectTemp = DateTime.now();
  Rx dateInspectTextController = TextEditingController().obs;
  Rx<int> calendarTypeInspect = ContentOptions.calendarDay.value.obs;
  Rx<int> calendarTypeInspectTemp = ContentOptions.calendarDay.value.obs;
  DateTime toStartSearchDateInspect = DateTime.now();
  DateTime toEndSearchDateInspect = DateTime.now();
  DateTime toStartSearchDateInspectTemp = DateTime.now();
  DateTime toEndSearchDateInspectTemp = DateTime.now();
  Rx toDateInspectTextController = TextEditingController().obs;

  DateTime startSearchDateNightInspect = DateTime.now();
  DateTime endSearchDateNightInspect = DateTime.now();
  DateTime startSearchDateNightInspectTemp = DateTime.now();
  DateTime endSearchDateNightInspectTemp = DateTime.now();
  Rx dateNightInspectTextController = TextEditingController().obs;
  Rx<int> calendarTypeNightInspect = ContentOptions.calendarWeek.value.obs; // Dung de xac dinh loc theo ngay/tuan/thang/nam o dashboard
  Rx<int> calendarTypeNightInspectTemp = ContentOptions.calendarWeek.value.obs;  // Dung de xac dinh loc theo ngay/tuan/thang/nam o popup filter
  DateTime toStartSearchDateNightInspect = DateTime.now();
  DateTime toEndSearchDateNightInspect = DateTime.now();
  DateTime toStartSearchDateNightInspectTemp = DateTime.now();
  DateTime toEndSearchDateNightInspectTemp = DateTime.now(); // Dung de hien thi ngay ket thuc o popup filter
  Rx toDateNightInspectTextController = TextEditingController().obs;


  DateTime startSearchDateLineInspect = DateTime.now();
  DateTime endSearchDateLineInspect = DateTime.now();
  DateTime startSearchDateLineInspectTemp = DateTime.now();
  DateTime endSearchDateLineInspectTemp = DateTime.now();
  Rx dateLineInspectTextController= TextEditingController().obs;
  DateTime toStartSearchDateLineInspect = DateTime.now();
  DateTime toEndSearchDateLineInspect = DateTime.now();
  DateTime toStartSearchDateLineInspectTemp = DateTime.now();
  DateTime toEndSearchDateLineInspectTemp = DateTime.now();
  Rx toDateLineInspectTextController = TextEditingController().obs;
  Rx<int> calendarTypeLineInspect = ContentOptions.calendarMonth.value.obs;
  Rx<int> calendarTypeLineInspectTemp = ContentOptions.calendarMonth.value.obs;

  DateTime startSearchDateCableInspect = DateTime.now();
  DateTime endSearchDateCableInspect = DateTime.now();
  DateTime startSearchDateCableInspectTemp = DateTime.now();
  DateTime endSearchDateCableInspectTemp = DateTime.now();
  Rx dateCableInspectTextController= TextEditingController().obs;
  DateTime toStartSearchDateCableInspect = DateTime.now();
  DateTime toEndSearchDateCableInspect = DateTime.now();
  DateTime toStartSearchDateCableInspectTemp = DateTime.now();
  DateTime toEndSearchDateCableInspectTemp = DateTime.now();
  Rx toDateCableInspectTextController = TextEditingController().obs;
  Rx<int> calendarTypeCableInspect = ContentOptions.calendarYear.value.obs;
  Rx<int> calendarTypeCableInspectTemp = ContentOptions.calendarYear.value.obs;

  DateTime startSearchDateNightLineInspect = DateTime.now();
  DateTime endSearchDateNightLineInspect = DateTime.now();
  DateTime startSearchDateNightLineInspectTemp = DateTime.now();
  DateTime endSearchDateNightLineInspectTemp = DateTime.now();
  Rx dateNightLineInspectTextController= TextEditingController().obs;
  DateTime toStartSearchDateNightLineInspect = DateTime.now();
  DateTime toEndSearchDateNightLineInspect = DateTime.now();
  DateTime toStartSearchDateNightLineInspectTemp = DateTime.now();
  DateTime toEndSearchDateNightLineInspectTemp = DateTime.now();
  Rx toDateNightLineInspectTextController = TextEditingController().obs;
  Rx<int> calendarTypeNightLineInspect = ContentOptions.calendarMonth.value.obs;
  Rx<int> calendarTypeNightLineInspectTemp = ContentOptions.calendarMonth.value.obs;

  DateTime startSearchDateElectricalGrid = DateTime.now();
  DateTime endSearchDateElectricalGrid = DateTime.now();
  DateTime startSearchDateElectricalGridTemp = DateTime.now();
  DateTime endSearchDateElectricalGridTemp = DateTime.now();
  Rx dateElectricalGridTextController = TextEditingController().obs;
  DateTime toStartSearchDateElectricalGrid = DateTime.now();
  DateTime toEndSearchDateElectricalGrid = DateTime.now();
  DateTime toStartSearchDateElectricalGridTemp = DateTime.now();
  DateTime toEndSearchDateElectricalGridTemp = DateTime.now();
  Rx toDateElectricalGridTextController = TextEditingController().obs;
  int typeInspectGrid = 0;
  int typeInspectGridTemp = 0;

  Rx<int> calendarTypeElectricalGrid = ContentOptions.calendarDay.value.obs;
  Rx<int> calendarTypeElectricalGridTemp = ContentOptions.calendarDay.value.obs;

Future getAddress({bool isShowLoading = false}) async {
    try {
      final location = await getCurrentPosition(isShowLoading: isShowLoading);
      address = await getNameByLocation(location?.latitude, location?.longitude);
      if(address.isNotEmpty) {
        address += ' ';
      }
      address += DateTime.now().toStringFormat(HighElectricStrings.ddMMyyyy);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future getGuaranteeElectricity() async {
    
    final res = await _dashboardRep.getGuaranteeElectricity();

    if (res.isLoadSuccess) {
      guaranteeElectricityModel.value = res.data.model;
    } else {
      await hShowDialogOneButton(res.message);
    }

    guaranteeElectricityModel.refresh();
    update();
  }

  Future getAbnormal({bool electricalGrid = false, bool isBackground = false}) async {
    if (!electricalGrid) {
      final res = await _dashboardRep.getAbnormal(
          isSubstation: typeInspect == 0,
          isBackground: isBackground,
          fromDate:
              calendarTypeAbnormal.value == ContentOptions.calendarAll.value
                  ? '1900/1/1'
                  : startSearchDateAbnormal
                      .toStringFormat(HighElectricStrings.yyyyMMddMode2),
          toDate: calendarTypeAbnormal.value == ContentOptions.calendarAll.value
              ? DateTime.now().toStringFormat(HighElectricStrings.yyyyMMddMode2)
              : toEndSearchDateAbnormal.toStringFormat(HighElectricStrings.yyyyMMddMode2));
      if (res.isLoadSuccess) {
        Map<String, List<AbnormalData>> listAbnormalData;
        if (calendarTypeAbnormal.value == ContentOptions.calendarWeek.value) {
          listAbnormalData = res.data.model.abnormalData
              .groupListsBy((element) => element.weekOfYear);
        } else if (calendarTypeAbnormal.value ==
            ContentOptions.calendarMonth.value) {
          listAbnormalData = res.data.model.abnormalData
              .groupListsBy((element) => element.monthOfYear);
        } else if (calendarTypeAbnormal.value ==
            ContentOptions.calendarYear.value) {
          listAbnormalData = res.data.model.abnormalData
              .groupListsBy((element) => element.year);
        } else {
          listAbnormalData = res.data.model.abnormalData
              .groupListsBy((element) => element.createdDate);
        }
        res.data.model.abnormalData = [];
        listAbnormalData.forEach((key, value) {
          var sumAbnormal = 0;
          var notHandler = 0;
          var handler = 0;
          final weekOfYear = key;
          var createdDate = DateTime.now().toString();
          final monthOfYear = key;
          final year = key;

          if (calendarTypeAbnormal.value == ContentOptions.calendarDay.value ||
              calendarTypeAbnormal.value == ContentOptions.calendarAll.value) {
            createdDate = key;
          }

          value.forEach((element) {
            sumAbnormal += element.sumAbnormal;
            notHandler += element.notHandler;
            handler += element.handler;
          });
          res.data.model.abnormalData.add(AbnormalData(
              createdDate: createdDate,
              handler: handler,
              notHandler: notHandler,
              sumAbnormal: sumAbnormal,
              monthOfYear: monthOfYear,
              weekOfYear: weekOfYear,
              year: year));
        });
        abnormalModel.value = res.data.model;
      } else {
        await hShowDialogOneButton(res.message);
      }

      abnormalModel.refresh();
    } else {
      final res = await _dashboardRep.getAbnormal(
          isSubstation: typeInspectGrid == 0,
          isBackground: isBackground,
          fromDate: calendarTypeElectricalGrid.value ==
                  ContentOptions.calendarAll.value
              ? '1900/1/1'
              : startSearchDateElectricalGrid
                  .toStringFormat(HighElectricStrings.yyyyMMddMode2),
          toDate: calendarTypeElectricalGrid.value ==
                  ContentOptions.calendarAll.value
              ? DateTime.now().toStringFormat(HighElectricStrings.yyyyMMddMode2)
              : toEndSearchDateElectricalGrid
                  .toStringFormat(HighElectricStrings.yyyyMMddMode2));
      if (res.isLoadSuccess) {
        electricalGridModel.value = res.data.model;
      } else {
        await hShowDialogOneButton(res.message);
      }
      electricalGridModel.refresh();
    }
    update();
  }

  Future getInspect({bool isSubstaion = true, bool isDateTime = true, bool isCable = false, bool isBackground = false}) async {
    if(isCable)
      {
        final res = await _dashboardRep.getInspect(
            isBackground: isBackground,
            params: {
              'FromDateCable':
              calendarTypeCableInspect.value == ContentOptions.calendarAll.value
                  ? '1900/1/1'
                  : startSearchDateCableInspect
                  .toStringFormat(HighElectricStrings.yyyyMMddMode2),
              'ToDateCable': calendarTypeCableInspect.value ==
                  ContentOptions.calendarAll.value
                  ? DateTime.now().toStringFormat(
                  HighElectricStrings.yyyyMMddMode2)
                  : toEndSearchDateCableInspect
                  .toStringFormat(HighElectricStrings.yyyyMMddMode2)});
        if (res.isLoadSuccess) {
          cableInspectModel.value = res.data.model;
        } else {
          await hShowDialogOneButton(res.message);
        }
        cableInspectModel.refresh();
        update();
      }
    else if (isSubstaion) {
      if(isDateTime) {
        final res = await _dashboardRep.getInspect(
            isBackground: isBackground,
          params: {
        'FromDateDay':
        calendarTypeInspect.value == ContentOptions.calendarAll.value
        ? '1900/1/1'
            : startSearchDateInspect
            .toStringFormat(HighElectricStrings.yyyyMMddMode2),
        'ToDateDay': calendarTypeInspect.value ==
        ContentOptions.calendarAll.value
        ? DateTime.now().toStringFormat(
        HighElectricStrings.yyyyMMddMode2)
            : toEndSearchDateInspect
            .toStringFormat(HighElectricStrings.yyyyMMddMode2)
        }
        );
        if (res.isLoadSuccess) {
          inspectModel.value = res.data.model;
        } else {
          await hShowDialogOneButton(res.message);
        }

        inspectModel.refresh();
        update();
      }
      else {
        final res = await _dashboardRep.getInspect(
            isBackground: isBackground,
          params: {
            'FromDateSubstationNight':
            calendarTypeNightInspect.value == ContentOptions.calendarAll.value
                ? '1900/1/1'
                : startSearchDateNightInspect
                .toStringFormat(HighElectricStrings.yyyyMMddMode2),
            'ToDateSubstationNight': calendarTypeNightInspect.value ==
                ContentOptions.calendarAll.value
                ? DateTime.now().toStringFormat(
                HighElectricStrings.yyyyMMddMode2)
                : toEndSearchDateNightInspect
                .toStringFormat(HighElectricStrings.yyyyMMddMode2)});

        if (res.isLoadSuccess) {
          nightInspectModel.value = res.data.model;
        } else {
          await hShowDialogOneButton(res.message);
        }

        nightInspectModel.refresh();
        update();
      }
    } else {
      if(isDateTime) {
        final res = await _dashboardRep.getInspect(
            isBackground: isBackground,
            params: {
              'FromDateLineMoth':
              calendarTypeLineInspect.value == ContentOptions.calendarAll.value
                  ? '1900/1/1'
                  : startSearchDateLineInspect
                  .toStringFormat(HighElectricStrings.yyyyMMddMode2),
              'ToDateLineMonth': calendarTypeLineInspect.value ==
                  ContentOptions.calendarAll.value
                  ? DateTime.now().toStringFormat(
                  HighElectricStrings.yyyyMMddMode2)
                  : toEndSearchDateLineInspect
                  .toStringFormat(HighElectricStrings.yyyyMMddMode2)});

        if (res.isLoadSuccess) {
          lineInspectModel.value = res.data.model;
        } else {
          await hShowDialogOneButton(res.message);
        }
        lineInspectModel.refresh();
        update();
      }
      else
        {
          final res = await _dashboardRep.getInspect(
              isBackground: isBackground,
              params: {
                'FromDateLineNight':
                calendarTypeNightLineInspect.value == ContentOptions.calendarAll.value
                    ? '1900/1/1'
                    : startSearchDateNightLineInspect
                    .toStringFormat(HighElectricStrings.yyyyMMddMode2),
                'ToDateLineNight': calendarTypeNightLineInspect.value ==
                    ContentOptions.calendarAll.value
                    ? DateTime.now().toStringFormat(
                    HighElectricStrings.yyyyMMddMode2)
                    : toEndSearchDateNightLineInspect
                    .toStringFormat(HighElectricStrings.yyyyMMddMode2)});

          if (res.isLoadSuccess) {
            nightLineInspectModel.value = res.data.model;
          } else {
            await hShowDialogOneButton(res.message);
          }
          nightLineInspectModel.refresh();
          update();
        }
    }
  }

  Future getNumberAbnormalInDay() async {
    final res = await _dashboardRep.getNumberAbnormalInDay(isBackground: true);
    if(res.isLoadSuccess) {
      numberAbnormalInDay.value = res.data;
    }
  }

  Future getPerformOnGrid() async {
    final res = await _dashboardRep.getPerformOnGrid(isBackground: false);
    if(res.isLoadSuccess) {
      numberPerformOnGrid.value = res.data;
    }
  }


  void initSearchDate() {
    final now = DateTime.now();
    final currentDay = now.weekday;

    startSearchDateAbnormal = now.subtract(Duration(days: currentDay - 1));
    startSearchDateAbnormalTemp = startSearchDateAbnormal;
    endSearchDateAbnormal = now.subtract(Duration(days: currentDay - 7));
    endSearchDateAbnormalTemp = endSearchDateAbnormal;

    toStartSearchDateAbnormal = startSearchDateAbnormal;
    toStartSearchDateAbnormalTemp = toStartSearchDateAbnormal;
    toEndSearchDateAbnormal = endSearchDateAbnormal;
    toEndSearchDateAbnormalTemp = toEndSearchDateAbnormal;
    dateAbnormalTextController.value.text =
        '${getCalendarType(calendarTypeAbnormal.value)} ${getWeekOfYear(startSearchDateAbnormalTemp.toString())}';
    toDateAbnormalTextController.value.text =
        '${getCalendarType(calendarTypeAbnormal.value)} ${getWeekOfYear(toStartSearchDateAbnormalTemp.toString())}';


    startSearchDateInspect = DateTime.now();
    startSearchDateInspectTemp = DateTime.now();
    endSearchDateInspect = DateTime.now();
    endSearchDateInspectTemp = endSearchDateInspect;
    dateInspectTextController.value.text =
        '${getCalendarType(calendarTypeInspect.value)} ${endSearchDateInspect.day}/${endSearchDateInspect.month}/${endSearchDateInspect.year}';
    toDateInspectTextController.value.text =
        dateInspectTextController.value.text;

    //Checklist kiểm tra > 1. Trạm biến áp > Đêm:
    startSearchDateNightInspect = now.subtract(Duration(days: currentDay - 1));
    startSearchDateNightInspectTemp = startSearchDateNightInspect;
    endSearchDateNightInspect = now.subtract(Duration(days: currentDay - 7));
    endSearchDateNightInspectTemp = endSearchDateNightInspect;
    toEndSearchDateNightInspect = endSearchDateNightInspect;
    toEndSearchDateNightInspectTemp = toEndSearchDateNightInspect;

    dateNightInspectTextController.value.text =
        '${getCalendarType(calendarTypeNightInspect.value)} ${getWeekOfYear(startSearchDateNightInspect.toString())}';
    toDateNightInspectTextController.value.text =
        '${getCalendarType(calendarTypeNightInspect.value)} ${getWeekOfYear(endSearchDateNightInspect.toString())}';

    startSearchDateLineInspect = DateTime(now.year, now.month, 1);
    startSearchDateLineInspectTemp = startSearchDateLineInspect;
    endSearchDateLineInspect = DateTime(now.year, now.month+1, 0);
    endSearchDateLineInspectTemp = endSearchDateLineInspect;
    dateLineInspectTextController.value.text =
        '${getCalendarType(calendarTypeLineInspect.value)} ${startSearchDateLineInspect.month}/${endSearchDateLineInspect.year}';
    toDateLineInspectTextController.value.text =
        dateLineInspectTextController.value.text;

    //Dashboard -> Check list kiem tra -> Duong day -> Doi voi ham noi cap ngam
    startSearchDateCableInspect = DateTime(now.year, 1, 1);
    startSearchDateCableInspectTemp = startSearchDateCableInspect;
    toStartSearchDateCableInspect = startSearchDateCableInspect;
    toStartSearchDateCableInspectTemp = toStartSearchDateCableInspect;

    endSearchDateCableInspect = DateTime(now.year, 12, 31);
    endSearchDateCableInspectTemp = endSearchDateCableInspect;
    toEndSearchDateCableInspect = endSearchDateCableInspect;
    toEndSearchDateCableInspectTemp = toEndSearchDateCableInspect;

    dateCableInspectTextController.value.text =
        '${getCalendarType(calendarTypeCableInspect.value)} ${startSearchDateCableInspect.year}';
    toDateCableInspectTextController.value.text =
        '${getCalendarType(calendarTypeCableInspect.value)} ${endSearchDateCableInspect.year}';

    //Dashboard -> Check list kiem tra -> Duong day -> Doi voi loai Thang/Dem -> Dem
    startSearchDateNightLineInspect = DateTime(now.year, now.month - 2, 1);
    startSearchDateNightLineInspectTemp = startSearchDateNightLineInspect;
    toStartSearchDateNightLineInspect = startSearchDateNightLineInspect;
    toStartSearchDateNightInspectTemp = toStartSearchDateNightLineInspect;

    endSearchDateNightLineInspect = DateTime(now.year, now.month + 1, 0);
    endSearchDateNightLineInspectTemp = endSearchDateNightLineInspect;
    toEndSearchDateNightLineInspect = endSearchDateNightLineInspect;
    toEndSearchDateNightLineInspectTemp = toEndSearchDateNightLineInspect;

    dateNightLineInspectTextController.value.text =
        '${getCalendarType(calendarTypeNightLineInspect.value)} ${startSearchDateNightLineInspect.month}/${startSearchDateNightLineInspect.year}';
    toDateNightLineInspectTextController.value.text =
        '${getCalendarType(calendarTypeNightLineInspect.value)} ${endSearchDateNightLineInspect.month}/${endSearchDateNightLineInspect.year}';

    startSearchDateElectricalGrid = DateTime.now();
    startSearchDateElectricalGridTemp = startSearchDateElectricalGrid;
    endSearchDateElectricalGrid = DateTime.now();
    endSearchDateElectricalGridTemp = endSearchDateElectricalGrid;

    toStartSearchDateElectricalGrid = startSearchDateElectricalGrid;
    toStartSearchDateElectricalGridTemp = startSearchDateElectricalGridTemp;
    toEndSearchDateElectricalGrid = endSearchDateElectricalGrid;
    toEndSearchDateElectricalGridTemp = endSearchDateElectricalGridTemp;

    dateElectricalGridTextController.value.text =
        '${getCalendarType(calendarTypeElectricalGrid.value)} ${startSearchDateElectricalGrid.toStringFormat(HighElectricStrings.ddMMyyyy)}';
    toDateElectricalGridTextController.value.text =
        '${getCalendarType(calendarTypeElectricalGrid.value)} ${toStartSearchDateElectricalGridTemp.toStringFormat(HighElectricStrings.ddMMyyyy)}';
  }

  String ddMMyyyy({DateTime datetime}) {
    return datetime.toStringFormat(HighElectricStrings.ddMMyyyy);
  }

  String getCalendarType(int option) {
  final getOptions =
    OptionsType.calendar_type.getOptions;
  return getOptions.firstWhereIndexedOrNull((index, element) => element.value == option)
        .title;
  }

  int getMaxYAbnormal(List<AbnormalData> data) {
    var max = 0;
    if (abnormalTyleChart.value !=
        ContentOptions.dashboardAbmorder.value) {
      data.forEach((element) {
        if (ContentOptions.workNotHandle.value != statusAbnormal.value &&
            element.sumAbnormal > max) {
          max = element.sumAbnormal;
        }
        if (ContentOptions.workNotHandle.value == statusAbnormal.value &&
            element.notHandler > max) {
          max = element.notHandler;
        }
      });
    } else {
      data.forEach((element) {
        if (ContentOptions.workNotHandle.value == statusAbnormal.value) {
          max += element.notHandler;
        }
        else{
          max += element.sumAbnormal;
        }
      });
    }
    return max + 10;
  }

  DateTime startOrEndDay({DateTime dateTime, bool startDay}) {
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
      startDay ? 0 : 24,
      0,
      0,
    );
  }

  Future getWeather() async {
    final res = await _dashboardRep.getWeather();

    if (res != null && res['main'] != null) {
      tempValue.value = res['main']['temp'] - 273.5;
      humiValue.value = res['main']['humidity'] - 0.0;
      App.tempValue = tempValue.value;
      App.humiValue = humiValue.value;
      tempValue.refresh();
      humiValue.refresh();
    }
  }
}

