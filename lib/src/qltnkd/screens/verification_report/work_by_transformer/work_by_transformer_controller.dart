// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/models/work_by_transformer_model.dart';
import 'package:get/get.dart';

import '../../../../app_common/shared/app_shared.dart';
import '../../../../htdct/common/utils/progress_h_u_d.dart';
import '../../../../htld/services/location_background_service.dart';
import '../../../common/constance/r_user_role_type.dart';
import '../../../common/constance/report_work_status_type.dart';
import '../../../common/constance/strings.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../common/utils/common.dart';
import '../../../common/utils/connection.dart';
import '../../../delegate/list_delegate.dart';
import '../../../dialog/popup.dart';
import '../../../models/create_report_not_plan_model.dart';
import '../../../models/form_report_copy_model.dart';
import '../../../models/option_model.dart';
import '../../../models/report_work.dart';
import '../../../offline_service/local_data_manager.dart';
import '../../../services/responsitory/merge_form_report_repository.dart';
import '../../../services/responsitory/report_repository.dart';
import '../../../services/responsitory/user_repository.dart';
import 'copy_report/copy_report_screen.dart';
import '../report/bb_cong_to/bb_cong_to.dart';
import '../report/report_screen.dart';

class WorkByTransformerController extends GetxController {
  final service = ReportRepository();
  final profileService = ReportUserRepository();
  final serviceMergeReport = MergerFormReportRepository();

  RxList<WorkByTransformerModel> works = RxList.empty();

  String workStatus = '0';

  final isShowLoading = false.obs;

  bool isFirstLoad = false;

  final isFilter = true.obs;
  final isSearching = false.obs;
  bool isSearched = false;

  final searchTerm = ''.obs;
  final workGroupType = 0.obs;
  int _loadDataToken = 0;
  
  int pageIndex = 1;
  final canLoadMore = false.obs;
  final isLoadMore = false.obs;

  ListDelegate delegate;

  List<StringOptionModel> unitOptions = <StringOptionModel>[];

  // Cache kết quả kiểm tra mạng để tránh gọi lại nhiều lần
  bool _isOnlineCache;
  DateTime _lastConnectionCheck;

  Future<bool> _isOnline() async {
    final now = DateTime.now();
    if (_isOnlineCache != null &&
        _lastConnectionCheck != null &&
        now.difference(_lastConnectionCheck).inSeconds < 10) {
      return _isOnlineCache;
    }
    _isOnlineCache = await RConnection.shared.checkConnection();
    _lastConnectionCheck = now;
    return _isOnlineCache;
  }

  DateTime fromDateTime = DateTime.now();
  DateTime toDateTime = DateTime.now();

  String fromDate = DateTime.now().subtract(const Duration(days: 30)).formatFirstDate();
  String toDate = DateTime.now().formatFirstDate();
  String equipment = '';
  String reportNumber = '';
  String stampNumber = '';
  String performer = '';
  String equipmentType = '0';
  String detailEquipmentType;

  String unit = '0';
  String statusWork = '0';
  String workType = '0';
  final isPaperReport = false.obs;

  final workStatusOptions = const [
    IntOptionModel(RAppStrings.all, ReportWorkStatusType.all),
    IntOptionModel(RAppStrings.unfulfilled, ReportWorkStatusType.unfulfilled),
    IntOptionModel(RAppStrings.doing, ReportWorkStatusType.doing),
    IntOptionModel(RAppStrings.done, ReportWorkStatusType.done),
  ];

  void checkFiltered() {
    if (equipment.isNotEmpty ||
        reportNumber.isNotEmpty ||
        stampNumber.isNotEmpty ||
        performer.isNotEmpty ||
        equipmentType.isNotEmpty ||
        equipmentType != '0' ||
        detailEquipmentType == null ||
        workType != '0' ||
        isPaperReport.value ||
        workStatus != ReportWorkStatusType.all.toString() ||
        unit != '0') {
      isFilter.value = true;
    } else {
      isFilter.value = false;
    }
  }

  void clearFilter() {
    equipment = '';
    reportNumber = '';
    stampNumber = '';
    performer = '';
    fromDateTime = DateTime.now();
    toDateTime = DateTime.now();
    unit = '0';
    statusWork = '0';
    workType = '0';
    fromDate = '';
    toDate = '';
    equipmentType = '0';
    detailEquipmentType = null;
    isPaperReport.value = false;
  }



  List<EquipmentTypes> equipmentTypeList = RxList.empty();
  final detailEquipmentList = <StringOptionModel>[].obs;
  List<StringOptionModel> equipmentTypes = RxList.empty();

  void renderEquipmentDetail(String idEquipmentType) {
    detailEquipmentList.clear();

    if (idEquipmentType != '0') {
      final equipmentType = equipmentTypeList.firstWhere(
              (element) => idEquipmentType == element.id,
          orElse: () => null);
      for (final element in equipmentType?.equipmentDetails ?? List.empty()) {
        detailEquipmentList.add(StringOptionModel(element.name, element.id));
      }
    }
    detailEquipmentType = detailEquipmentList.firstOrNull?.value;
    detailEquipmentList.refresh();
  }

  final userProfile = AppShared.instance.getUserProfile();


  Future getUnits() async {
    Future online () async {
      final response = await service.getUnits();
      if (response.isLoadSuccess) {
        unitOptions =
            response.data.map((e) => StringOptionModel(e.name, e.id)).toList();
        unit = response?.data?.first?.id ?? '';
      } else {
        await rShowDialogOneButton(response.message);
      }
    }
    Future offline () async {
      unitOptions.clear();
      final response = await RLocalDataManager.instance.getUnitWorkOffline() ?? List.empty();
      unitOptions.add(StringOptionModel(RAppStrings.all, '0'));
      response.forEach((element) {
        unitOptions.add(StringOptionModel(element.name, element.id));
      });
    }
    final isOnline = await _isOnline();
    if (isOnline) {
      await online();
    }else{
      await offline();
    }
  }

  Future<bool> checkVersionApp() async {
    final isOnline = await _isOnline();
    if(!isOnline){
      return true;
    }
    final appVerSion = await getDeviceInfo();
    final userProfileResponse = await profileService.getUserProfile(isBackgroundMode: true);
    if (userProfileResponse.isLoadSuccess && userProfileResponse?.data != null) {
      if (!userProfileResponse.data.getAppVersion().contains(appVerSion)) {
        return false;
      }
    }

    return true;
  }

  Future loadData() async {
    pageIndex = 1;
    final currentToken = ++_loadDataToken;

    Future getWorksOnline() async {
      ProgressHUD.show();
      final List<ReportWorkItem> reportWorkItems = [];
      works.clear();

      // Gọi trang đầu tiên để biết tổng số trang
      final response = await service.getListWork(
          unitId: unit,
          equipmentName: equipment,
          fromDate: fromDate,
          toDate: toDate,
          equipmentType: equipmentType,
          detailEquipmentType: detailEquipmentType,
          workProgress: workStatus,
          isPaperFormReport: isPaperReport.value ? true : null,
          groupType: workGroupType.value,
          reportNumber: reportNumber,
          stampNumber: stampNumber,
          searchTerm: searchTerm.value,
          workType: workType,
          pageIndex: 1,
          isNotShowLoading: true);

      isFirstLoad = true;

      if (currentToken != _loadDataToken) {
        ProgressHUD.dismiss();
        return;
      }

      if (response.isLoadSuccess && response.data.list.isNotEmpty) {
        reportWorkItems.addAll(response.data.list);
        final totalPages = response.data.paging.totalPages;

        // When no date filter, load ALL pages at once; otherwise load up to 5
        final bool noDateFilter = fromDate == null || fromDate.isEmpty || toDate == null || toDate.isEmpty;
        final maxInitialPages = noDateFilter ? totalPages : (totalPages > 5 ? 5 : totalPages);
        if (maxInitialPages > 1) {
          final futures = <Future<List<ReportWorkItem>>>[];
          for (int i = 2; i <= maxInitialPages; i++) {
            futures.add(service.getListWork(
                unitId: unit,
                equipmentName: equipment,
                fromDate: fromDate,
                toDate: toDate,
                equipmentType: equipmentType,
                detailEquipmentType: detailEquipmentType,
                workProgress: workStatus,
                isPaperFormReport: isPaperReport.value ? true : null,
                groupType: workGroupType.value,
                reportNumber: reportNumber,
                stampNumber: stampNumber,
                searchTerm: searchTerm.value,
                workType: workType,
                pageIndex: i,
                isNotShowLoading: true).then((res) {
              if (currentToken != _loadDataToken) return [];
              if (res.isLoadSuccess && res.data.list.isNotEmpty) {
                return res.data.list;
              }
              return <ReportWorkItem>[];
            }));
          }
          final results = await Future.wait(futures);
          if (currentToken != _loadDataToken) return;
          for (var list in results) {
            reportWorkItems.addAll(list);
          }
          pageIndex = maxInitialPages;
        }

        // Tối ưu hóa: Nhóm danh sách công việc theo Trạm Biến Áp bằng Map thay vì vòng lặp lồng nhau (O(N) thay vì O(N^2))
        final Map<String, WorkByTransformerModel> groupedWorks = {};
        
        for (final element in reportWorkItems) {
          final key = element.substationId ?? element.location ?? 'unknown';
          
          if (groupedWorks.containsKey(key)) {
            groupedWorks[key].mergeModels.add(element);
          } else {
            final newGroup = WorkByTransformerModel(
                transformerName: element.location,
                transformerId: element.substationId,
                mergeModels: [element]);
            groupedWorks[key] = newGroup;
          }
        }
        works.addAll(groupedWorks.values);

        if (totalPages > pageIndex) {
          canLoadMore.value = true;
        } else {
          canLoadMore.value = false;
        }
        ProgressHUD.dismiss();
      } else {
        ProgressHUD.dismiss();
        if (!response.isLoadSuccess) {
          await rShowDialogOneButton(response.message);
        }
      }
      works.refresh();
    }

    Future getWorksOffline() async {
      works.clear();
      final response = await RLocalDataManager.instance.getWorksOffline(
          workStatus: int.parse(workStatus),
          equipmentName: equipment,
          reportNumber: reportNumber,
          unitId: unit == '0' ? '' : unit,
          searchTerm: searchTerm.value,
          stampNumber: stampNumber,
          reportType:  workType == '0'
              ? ''
              : workType,
          toDate: toDate,
          fromDate: fromDate);
      if (currentToken != _loadDataToken) return;
      if (response != null) {
        final Map<String, WorkByTransformerModel> groupedWorks = {};
        
        for (final element in response) {
          final key = element.substationId ?? element.location ?? 'unknown';
          
          if (groupedWorks.containsKey(key)) {
            groupedWorks[key].mergeModels.add(element);
          } else {
            groupedWorks[key] = WorkByTransformerModel(
                transformerName: element.location,
                transformerId: element.substationId,
                mergeModels: [element]);
          }
        }
        works.addAll(groupedWorks.values);
      }
      works.refresh();
    }

    final isOnline = await _isOnline();

    if (isOnline) {
      await getWorksOnline();
    } else {
      await getWorksOffline();
    }
  }

  Future<void> loadMore() async {
    if (!canLoadMore.value || isLoadMore.value) return;
    final isOnline = await _isOnline();
    if (!isOnline) {
      canLoadMore.value = false;
      return;
    }

    pageIndex++;
    isLoadMore.value = true;

    try {
      final response = await service.getListWork(
          unitId: unit,
          equipmentName: equipment,
          fromDate: fromDate,
          toDate: toDate,
          equipmentType: equipmentType,
          detailEquipmentType: detailEquipmentType,
          workProgress: workStatus,
          isPaperFormReport: isPaperReport.value ? true : null,
          groupType: workGroupType.value,
          reportNumber: reportNumber,
          stampNumber: stampNumber,
          searchTerm: searchTerm.value,
          workType: workType,
          pageIndex: pageIndex,
          isNotShowLoading: true);

      if (response.isLoadSuccess && response.data.list.isNotEmpty) {
        final Map<String, WorkByTransformerModel> currentGroups = {
          for (var group in works)
            group.transformerId ?? group.transformerName ?? 'unknown': group
        };

        for (final element in response.data.list) {
          final key = element.substationId ?? element.location ?? 'unknown';
          if (currentGroups.containsKey(key)) {
            currentGroups[key].mergeModels.add(element);
          } else {
            final newGroup = WorkByTransformerModel(
                transformerName: element.location,
                transformerId: element.substationId,
                mergeModels: [element]);
            currentGroups[key] = newGroup;
            works.add(newGroup);
          }
        }
        works.refresh();

        if (response.data.paging.totalPages > pageIndex) {
          canLoadMore.value = true;
        } else {
          canLoadMore.value = false;
        }
      } else {
        canLoadMore.value = false;
      }
    } catch (e) {
      print('Error loadMore works: $e');
    } finally {
      isLoadMore.value = false;
    }
  }

  Future confirmComplete(String scheduleId) async {
    final response = await serviceMergeReport.confirmComplete(scheduleId);
    if (response.isLoadSuccess) {
      service.sendLocation(scheduleId, type: 2);

      await loadData();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future createMeterReport(String scheduleId) async {
    final response = await serviceMergeReport.createMeterReport(scheduleId);
    if (response.isLoadSuccess) {
      service.sendLocation(response.data, type: 3);
      await Get.to(BBCongToPage(
        reportID: response.data,
        isAllowEdit: true,
      ));
      await loadData();
    } else {
      await rShowDialogOneButton(response.message);
    }
  }

  Future createIndividualJob(ReportWorkItem workModel) async {
    if (!userProfile.isHasCreateFormReport()) {
      await rShowDialogOneButton(RAppStrings.userNotPermission);
      return;
    }

    Future createReportOnline() async {
      final response = workGroupType.value == 1
          ? await serviceMergeReport.createConstructionReports(
              workModel.id, workModel.equipmentTypeId, workModel.equipmentDetailId)
          : await serviceMergeReport.createReports(
              workModel.id, workModel.equipmentTypeId, workModel.equipmentDetailId);
      if (response.isLoadSuccess) {
        service.sendLocation(response.data, type: 3);
        await Get.to(ReportScreen(
          reportId: response.data,
          isAllowEditing: true,
        ));
        await loadData();
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
        await loadData();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    final isOnline = await _isOnline();
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
      ReportWorkItem workModel, FormReportCopyModel formReportCopyModel) async {
    if (!userProfile.isHasCreateFormReport()) {
      await rShowDialogOneButton(RAppStrings.userNotPermission);
      return;
    }

    Future createReportOnline() async {
      final response = workGroupType.value == 1
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
        await loadData();
      } else {
        await rShowDialogOneButton(response.message);
      }
    }

    final isOnline = await _isOnline();
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

  Future handleChangePaperReport(ReportWorkItem work) async {
    work.isPaperReport = !(work.isPaperReport ?? false);
    final result = await changeStatusPaperReport(work);
    if(result == false) {
      work.isPaperReport = !work.isPaperReport;
    }

    works.refresh();
  }

  Future changeStatusPaperReport(ReportWorkItem work) async {
    final res = await serviceMergeReport.updatePaperForm(work.id, isPaperFormReport: work.isPaperReport, isNotShowLoading: false);
    if(res?.isLoadSuccess == true) {
      return true;
    } else {
      await rShowDialogOneButton(res.message);
      return false;
    }
  }

  Future handleCreateFormReport(ReportWorkItem workModel) async {
    if (workModel.isMeter == true &&
        AppShared.instance.getUserProfile().isHasCreateFormReport() &&
        workModel.workProgress != ReportWorkStatusType.done) {
      final isOnline = await _isOnline();
      if (!isOnline) {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
        return;
      }

      await createMeterReport(workModel.id);
      return;
    }

    if (workModel.isConfirmComplete == true &&
        AppShared.instance.getUserProfile().isHasCreateFormReport() &&
        workModel.workProgress != ReportWorkStatusType.done) {
      final isOnline = await _isOnline();
      if (!isOnline) {
        await rShowDialogOneButton('Công việc này phải thực hiện online');
        return;
      }

      await rShowMyDialogOkCancel('Bạn có muốn xác nhận công việc này',
          secondFunction: () async {
            await confirmComplete(workModel.id);
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
                workType: WorkType.getCodeByName(workModel.workTypeName));
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
              await Get.to(() => CopyReportScreen(workModel, groupType: workGroupType.value));
              if (reportCopy != null) {
                await createIndividualJobCopy(workModel, reportCopy);
              }
            });
      }
    }
  }

  Future getDataEquipmentReport() async {
    final isOnline = await _isOnline();
    if (isOnline) {
      final response = await service.getDataUnscheduled();
      if (response.isLoadSuccess) {
        equipmentTypes.clear();
        detailEquipmentList.clear();
        equipmentTypes.add(StringOptionModel(RAppStrings.all, '0'));
        response.data.equipmentTypes.forEach((element) {
          equipmentTypes.add(StringOptionModel(element.name, element.id));
          equipmentTypeList.add(EquipmentTypes(
            id: element.id,
            name: element.name,
            equipmentDetails: element.equipmentDetails,
          ));
        });
      }
    } else {
      equipmentTypes.clear();
      final response = await RLocalDataManager.instance.getUnscheduledReportOffline();
      equipmentTypes.clear();
      detailEquipmentList.clear();
      equipmentTypes.add(StringOptionModel(RAppStrings.all, '0'));

      response?.equipmentTypes?.forEach((element) {
        equipmentTypes.add(StringOptionModel(element.name, element.id));
        equipmentTypeList.add(EquipmentTypes(
          id: element.id,
          name: element.name,
          equipmentDetails: element.equipmentDetails,
        ));
      });
    }
  }
}
