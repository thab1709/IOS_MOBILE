// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/delegate/list_delegate.dart';
import 'package:evnmobile/src/qltnkd/enum/list.dart';
import 'package:evnmobile/src/qltnkd/models/form_report_copy_model.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_screen.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/merge_form_report_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/constance/report_work_status_type.dart';
import '../../../../dialog/popup.dart';
import '../../report/bb_cong_to/bb_cong_to.dart';
import '../copy_report/copy_report_screen.dart';
import '../work_report_controller.dart';

class ListWorkController extends GetxController {
  final service = ReportRepository();
  final serviceMergeReport = MergerFormReportRepository();

  RxList<ReportWorkItem> works = RxList.empty();

  final isHasLoadMore = false.obs;
  String workStatus = '0';

  final isShowLoading = false.obs;

  bool isFirstLoad = false;

  final searchTerm = ''.obs;

  final page = 1.obs;
  ListDelegate delegate;
  final WorkReportController listReportController = Get.find();
  final userProfile = AppShared.instance.getUserProfile();

  Future searchData(ListTypeLoad type) async {
    Future searchOnlineWorks() async {
      if (type == ListTypeLoad.loadMore) {
        page.value = page.value + 1;
      } else {
        page.value = 1;
      }

      final response = await service.getListWork(
        searchTerm: searchTerm.value,
        pageIndex: page.value,
      );

      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        works.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        works.clear();
      }
      if (response.isLoadSuccess) {
        works.addAll(response.data.list);
        works.refresh();
        update();
      } else {
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    Future searchOfflineWorks({String searchTerm}) async {
      works.clear();
      final response = await RLocalDataManager.instance
          .getWorksOffline(searchTerm: searchTerm);
      if (response != null) {
        if (type == ListTypeLoad.loadMore) {
          delegate.onLoadMoreSuccess();
        } else if (type == ListTypeLoad.refresh) {
          delegate.onRefreshSuccess();
        } else if (type == ListTypeLoad.load) {}

        works.assignAll(response);
        works.refresh();
      }
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await searchOnlineWorks();
    } else {
      await searchOfflineWorks(searchTerm: searchTerm.value.toString());
    }
  }

  Future loadData(ListTypeLoad type) async {
    if (RUserRole?.isWorkView == false) {
      isFirstLoad = true;
      works.refresh();
      return;
    }

    Future getWorksOnline() async {
      if (type == ListTypeLoad.loadMore) {
        page.value = page.value + 1;
      } else if (type == ListTypeLoad.load) {
        isShowLoading.value = true;
        page.value = 1;
      } else if (type == ListTypeLoad.refresh) {
        page.value = 1;
      }

      final response = await service.getListWork(
          unitId: listReportController.unit,
          equipmentName: listReportController.equipment,
          fromDate: listReportController.fromDate,
          toDate: listReportController.toDate,
          equipmentType: listReportController.equipmentType,
          detailEquipmentType: listReportController.detailEquipmentType,
          workProgress: workStatus,
          reportNumber: listReportController.reportNumber,
          stampNumber: listReportController.stampNumber,
          workType: listReportController.workType,
          groupType: listReportController.workGroupType.value,
          pageIndex: page.value,
          isNotShowLoading: type == ListTypeLoad.load);

      isFirstLoad = true;

      if (type == ListTypeLoad.loadMore) {
        delegate.onLoadMoreSuccess();
      } else if (type == ListTypeLoad.refresh) {
        works.clear();
        delegate.onRefreshSuccess();
      } else if (type == ListTypeLoad.load) {
        works.clear();
      }

      if (response.isLoadSuccess) {
        isShowLoading.value = false;
        works.addAll(response.data.list);
        works.refresh();
        update();
      } else {
        isShowLoading.value = false;
        await rShowDialogOneButton(response.message);
      }

      isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
    }

    Future getWorksOffline(
        {int workStatus,
        String equipmentName,
        String reportNumber,
        String stampNumber,
        String reportType,
        String unitId,
        String fromDate,
        String toDate}) async {
      works.clear();
      final response = await RLocalDataManager.instance.getWorksOffline(
          workStatus: workStatus,
          equipmentName: equipmentName,
          reportNumber: reportNumber,
          unitId: unitId,
          stampNumber: stampNumber,
          reportType: reportType,
          toDate: toDate,
          fromDate: fromDate);
      if (response != null) {
        if (type == ListTypeLoad.loadMore) {
          delegate.onLoadMoreSuccess();
        } else if (type == ListTypeLoad.refresh) {
          delegate.onRefreshSuccess();
        } else if (type == ListTypeLoad.load) {}

        works.assignAll(response);

        works.refresh();
      }
    }

    final isOnline = await RConnection.shared.checkConnection();

    if (isOnline) {
      await getWorksOnline();
    } else {
      await getWorksOffline(
          workStatus: int.parse(workStatus),
          equipmentName: listReportController.equipment,
          reportNumber: listReportController.reportNumber,
          unitId:
              listReportController.unit == '0' ? '' : listReportController.unit,
          stampNumber: listReportController.stampNumber,
          reportType: listReportController.workType == '0'
              ? ''
              : listReportController.workType,
          toDate: listReportController.toDate,
          fromDate: listReportController.fromDate);
    }
  }

  Future confirmComplete(String scheduleId, {@required bool isSearch}) async {
    final response = await serviceMergeReport.confirmComplete(scheduleId);
    if (response.isLoadSuccess) {
      service.sendLocation(scheduleId, type: 2);

      if (isSearch) {
        await searchData(ListTypeLoad.refresh);
      } else {
        await loadData(ListTypeLoad.refresh);
      }
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future createMeterReport(String scheduleId, {@required bool isSearch}) async {
    final response = await serviceMergeReport.createMeterReport(scheduleId);
    if (response.isLoadSuccess) {
      service.sendLocation(response.data, type: 3);
      await Get.to(BBCongToPage(
        reportID: response.data,
        isAllowEdit: true,
      ));
      if (isSearch) {
        await searchData(ListTypeLoad.refresh);
      } else {
        await loadData(ListTypeLoad.refresh);
      }
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future createIndividualJob(ReportWorkItem workModel,
      {@required bool isSearch}) async {
    if (!userProfile.isHasCreateFormReport()) {
      await rShowDialogOneButton(RAppStrings.userNotPermission);
      return;
    }

    Future createReportOnline() async {
      final response = listReportController.workGroupType.value == 1
          ? await serviceMergeReport.createConstructionReports(
              workModel.id,
              workModel.equipmentTypeId,
              workModel.equipmentDetailId)
          : await serviceMergeReport.createReports(
              workModel.id,
              workModel.equipmentTypeId,
              workModel.equipmentDetailId);
      if (response.isLoadSuccess) {
        service.sendLocation(response.data, type: 3);
        await Get.to(ReportScreen(
          reportId: response.data,
          isAllowEditing: true,
        ));
        if (isSearch) {
          await searchData(ListTypeLoad.refresh);
        } else {
          await loadData(ListTypeLoad.refresh);
        }
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    Future createReportOffline() async {
      final response =
          await RLocalDataManager.instance.createReportOffline(workModel);
      if (response.isLoadSuccess) {
        //service.sendLocation(workModel.id);
        await Get.to(ReportScreen(
          reportId: response.data,
          isAllowEditing: true,
        ));
        if (isSearch) {
          await searchData(ListTypeLoad.refresh);
        } else {
          await loadData(ListTypeLoad.refresh);
        }
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
        await createReportOffline();
      }
    }
  }

  Future createIndividualJobCopy(
      ReportWorkItem workModel, FormReportCopyModel formReportCopyModel,
      {@required bool isSearch}) async {
    if (!userProfile.isHasCreateFormReport()) {
      await rShowDialogOneButton(RAppStrings.userNotPermission);
      return;
    }

    Future createReportOnline() async {
      final response = listReportController.workGroupType.value == 1
          ? await serviceMergeReport.copyConstructionReports(
              formReportCopyModel.id,
              workModel.id,
              workModel.equipmentTypeId,
              workModel.equipmentDetailId)
          : await serviceMergeReport.createReportsCopy(
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
        if (isSearch) {
          await searchData(ListTypeLoad.refresh);
        } else {
          await loadData(ListTypeLoad.refresh);
        }
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

  Future handleCreateFormReport(ReportWorkItem workModel,
      {@required bool isSearch}) async {
    if (workModel.isMeter == true &&
        AppShared.instance.getUserProfile().isHasCreateFormReport() &&
        workModel.workProgress != ReportWorkStatusType.done) {
      final isOnline = await RConnection.shared.checkConnection();
      if (!isOnline) {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
        return;
      }

      await createMeterReport(workModel.id, isSearch: isSearch);
      return;
    }

    if (workModel.isConfirmComplete == true &&
        AppShared.instance.getUserProfile().isHasCreateFormReport() &&
        workModel.workProgress != ReportWorkStatusType.done) {
      final isOnline = await RConnection.shared.checkConnection();
      if (!isOnline) {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
        return;
      }

      await rShowMyDialogOkCancel('Bạn có muốn xác nhận công việc này',
          secondFunction: () async {
        await confirmComplete(workModel.id, isSearch: isSearch);
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
            equipmentTypes: listReportController.equipmentTypes,
            equipmentDetails: listReportController.equipmentTypeList,
            workType: WorkType.getCodeByName(workModel.workTypeName));
        if (result is List<String> && result.length > 1) {
          if (result.length == 3) {
            workModel.formId = result[2];
          }
          workModel.equipmentTypeId = result[0];
          workModel.equipmentDetailId = result[1];
          await createIndividualJob(workModel, isSearch: isSearch);
        }
      });
    } else {
      //create
      final result = await showDialogConfirm(
          equipmentType: workModel.equipmentTypeId,
          equipmentDetail: workModel.equipmentDetailId,
          workType: workModel.periodicType,
          equipmentTypes: listReportController.equipmentTypes,
          equipmentDetails: listReportController.equipmentTypeList);
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
              await createIndividualJob(workModel, isSearch: isSearch);
            },
            secondTitle: 'Đồng ý',
            secondFunction: () async {
              final reportCopy =
                  await Get.to(() => CopyReportScreen(
                        scheduleId: workModel.id,
                        equipmentDetailId: workModel.equipmentDetailId,
                        equipmentTypeId: workModel.equipmentTypeId,
                        groupType: listReportController.workGroupType.value ?? 0,
                      ));
              if (reportCopy != null) {
                await createIndividualJobCopy(workModel, reportCopy,
                    isSearch: isSearch);
              }
            });
      }
    }
  }
}

