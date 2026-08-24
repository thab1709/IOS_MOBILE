// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/common/utils/connection.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/models/form_info.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/form_reppository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/images_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/merge_form_report_repository.dart';
import 'package:evnmobile/src/qltnkd/services/responsitory/report_repository.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RSyncManager {
  factory RSyncManager() => _instance;
  static final RSyncManager _instance = RSyncManager._internal();
  ReportRepository _reportRepository;
  MergerFormReportRepository _mergerFormReportRepository;
  FormRepository _formRepository;
  ImageRepository _imageRepository;

  RSyncManager._internal() {
    _reportRepository = ReportRepository();
    _formRepository = FormRepository();
    _mergerFormReportRepository = MergerFormReportRepository();
    _imageRepository = ImageRepository();
  }

  static RSyncManager get instance => _instance;

  Future doAutoSync() async {
    await EasyLoading.show(
        status:
            'Đang đồng bộ công việc tự động, sẽ mất một khoảng thời gian. Vui lòng chờ...',
        maskType: EasyLoadingMaskType.none);

    final errorSyncReport = await _syncUpReport();
    if (errorSyncReport != null) {
      await EasyLoading.dismiss(animation: true);
      await rShowMyDialogOkCancel(
          'Đồng bộ thất bại ${errorSyncReport?.trim()?.isNotEmpty == true ? '\n\nCó một số lỗi đã xảy ra khi đồng bộ: \n-$errorSyncReport' : ''}',
          secondTitle: 'Thử lại',
          secondFunction: () async { await doAutoSync(); });
      return;
    }

    final errorSyncMergeReport = await _syncUpReportMerge();

    if (errorSyncMergeReport != null) {
      await EasyLoading.dismiss(animation: true);
      await rShowMyDialogOkCancel(
          'Đồng bộ thất bại ${errorSyncMergeReport?.trim()?.isNotEmpty == true ? '\n\nCó một số lỗi đã xảy ra khi đồng bộ: \n-$errorSyncMergeReport' : ''}',
          secondTitle: 'Thử lại',
          secondFunction: () async { await doAutoSync(); });
      return;
    }

    Future.delayed(const Duration(milliseconds: 300), () async {
      await EasyLoading.showSuccess('Đồng bộ thành công');
    });
  }

  Future doSync() async {
    if( await RConnection.shared.checkConnection()){
      await EasyLoading.show(
          status: 'Đang đồng bộ công việc, sẽ mất một khoảng thời gian. Vui lòng chờ...',
          maskType: EasyLoadingMaskType.custom);
      final res = await _sync();
      if (res?.isNotEmpty == true) {
        await EasyLoading.dismiss(animation: true);
        await rShowDialogOneButton(
            'Đồng bộ thất bại ${res?.trim()?.isNotEmpty == true ? '\n\nCó một số lỗi đã xảy ra khi đồng bộ: \n-$res' : ''}');
        return;
      }
      Future.delayed(const Duration(milliseconds: 300), () async {
        await EasyLoading.showSuccess('Đồng bộ thành công');
      });
    } else {
      await rShowDialogOneButton('Vui lòng kiểm tra mạng internet') ;
    }
  }

  ///Đồng bộ biên bản lên server xong rồi đồng bộ về
  Future<String> _sync() async {
    final errorSyncReport = await _syncUpReport();
    if(errorSyncReport != null){
      return errorSyncReport;
    }

    final errorSyncMergeReport = await _syncUpReportMerge();

    if(errorSyncMergeReport != null) {
      return errorSyncMergeReport;
    }

    return _syncDown();
  }

  Future<String> _syncUpReportMerge() async {
    final dataLocalManager = RLocalDataManager.instance;
    final reportsMerge = await dataLocalManager.getMergeReportsOffline() ?? List.empty();
    for (final reportMerge in reportsMerge) {
      final report = await dataLocalManager.getReportFormDetail(reportMerge.formReportId);
      if (report?.reportId?.contains(RDatabaseBoxName.nameTemp) == true) {
        final createReportRes = await _mergerFormReportRepository.createReports(
            reportMerge.id, reportMerge.equipmentTypeId,
            reportMerge.equipmentDetailId);
        if(createReportRes.isLoadSuccess) {
          final formReportId = createReportRes.data;
          reportMerge.isSync = true;
          reportMerge.formReportId = formReportId;
          report.reportId = formReportId;

          final locationOffline = await dataLocalManager.getReportLocation(reportMerge.id);
          if(locationOffline != null){
            await _reportRepository.sendLocationOffline(reportMerge.id, locationOffline.lat, locationOffline.long);
            await dataLocalManager.clearLocationOffline(locationOffline);
          }

          await dataLocalManager.saveReportFormDetail(report);
          await dataLocalManager.clearMergeReports();
          await dataLocalManager.saveMergeReports(reportsMerge);

          if(report?.isSync == false) {
            //upload image
            final fieldModelData = report.reportModel.fieldsModel
                .firstWhere((element) => element.fieldType == FieldType.taps, orElse: () => null);
            await uploadImage(fieldModelData);
            //update content report
            final updateRes = await _reportRepository.updateReport(formReportId,
                report.reportModel.fieldsModel.firstWhere(
                        (element) => element.fieldType == FieldType.taps,
                    orElse: () => null),
                isBackgroundMode: true);

            if (updateRes.isLoadSuccess) {
              report.isSync = true;
              await dataLocalManager.saveReportFormDetail(report);
            } else {
              return 'Cập nhật nội dung biên bản: ${updateRes.message}';
            }
          }

        } else {
         return 'Lỗi tạo biên bản: ${createReportRes.message}' ?? '';
        }
      } else if(reportMerge.isSync == false){
        //upload image
        final fieldModelData = report.reportModel.fieldsModel
            .firstWhere((element) => element.fieldType == FieldType.taps, orElse: () => null);
        await uploadImage(fieldModelData);
        //update content report
        final updateRes = await _reportRepository.updateReport(
            report.reportId,
            report.reportModel.fieldsModel
                .firstWhereOrNull((element) => element.fieldType == FieldType.taps),
            isBackgroundMode: true);

        if (updateRes.isLoadSuccess) {
          final locationOffline = await dataLocalManager.getReportLocation(reportMerge.id);
          if(locationOffline != null) {
            await _reportRepository.sendLocationOffline(reportMerge.id, locationOffline.lat, locationOffline.long);
            await dataLocalManager.clearLocationOffline(locationOffline);
          }
          report.isSync = true;
          reportMerge.isSync = true;
          await dataLocalManager.clearMergeReports();
          await dataLocalManager.saveMergeReports(reportsMerge);
          await dataLocalManager.saveReportFormDetail(report);
        } else {
          return 'Cập nhật nội dung biên bản ${report.reportModel.name}: ${updateRes.message}';
        }

      }
    }
    return null;
  }

  Future uploadImage(FieldModel fieldModel) async {
    // await fieldModel.searchImage((file) async {
    //   final imageRes = await _imageRepository.upload(file, isBackgroundMode: true);
    //   if (imageRes?.data?.url?.isNotEmpty == true) {
    //     return imageRes?.data?.url;
    //   }
    //   return null;
    // });

  }

  Future<bool> isHasReportOffline() async {
    final dataLocalManager = RLocalDataManager.instance;
    final reports = await dataLocalManager.getReportsOffline() ?? List.empty();
    final mergerReports = await dataLocalManager.getMergeReportsOffline() ?? List.empty();
    if(reports.any((element) => element.isSync == false || element?.id?.contains(RDatabaseBoxName.nameTemp) == true)) return true;
    if(mergerReports.any((element) => element.isSync == false || element?.id?.contains(RDatabaseBoxName.nameTemp) == true)) return true;
    return false;
  }

  Future<String> _syncUpReport() async {
    final dataLocalManager = RLocalDataManager.instance;
    //report ticket created offline
    final user = AppShared.instance.getUserProfile();
    final reports = await dataLocalManager.getReportsOffline() ?? List.empty();
    for(final element in reports) {
      final report = await dataLocalManager.getReportFormDetail(element.id);

      if (report?.reportId?.contains(RDatabaseBoxName.nameTemp) == true) {
        final reportItem = reports
            .firstWhere((element) => element.id == element.id, orElse: () => null);
        final response = await _reportRepository.createReportNotPlan(
            workType: element.reportType.toString(),
            unitId: element.unitId,
            equipmentTypeId:element.equipmentTypeId,
            equipmentDetailId:element.equipmentDetailId,
            userId: user.id,
            teamId: user.teamId,
            departmentId: user.departmentId,
            createdDate:element.createdDate,
            location:element.location,
            backgroundMode: true
        );
        if (response.isLoadSuccess) {
          final reportId = response.data;
          report.reportId = reportId;
          await dataLocalManager.saveReportFormDetail(report);
          reportItem.id = reportId;
          await dataLocalManager.clearReports();
          await dataLocalManager.saveReports(reports);

          if(report?.isSync == false) {
            //upload image
            final fieldModelData = report.reportModel.fieldsModel
                .firstWhere((element) => element.fieldType == FieldType.taps, orElse: () => null);
            await uploadImage(fieldModelData);
            //update content report
            final updateRes = await _reportRepository.updateReport(
                response.data,
                report.reportModel.fieldsModel.firstWhere(
                        (element) => element.fieldType == FieldType.taps,
                    orElse: () => null),
                isBackgroundMode: true);

            if (updateRes.isLoadSuccess) {
              report.isSync = true;
              element.isSync = true;
              reports.removeWhere((e) => e.id == element.id);
              await dataLocalManager.clearReports();
              await dataLocalManager.saveReports(reports);
              await dataLocalManager.saveReportFormDetail(report);
            } else {
              return 'Cập nhật nội dung biên bản: ${updateRes.message}';
            }
          }
        }else {
          return 'Đồng bộ biên bản không theo kế hoạch không thành công \n ${response.message}';
        }
      }else if (report?.isSync == false) {
        //upload image
        final fieldModelData = report.reportModel.fieldsModel
            .firstWhere((element) => element.fieldType == FieldType.taps, orElse: () => null);
        await uploadImage(fieldModelData);
        //update content report
        final updateRes = await _reportRepository.updateReport(
            report.reportId,
            report.reportModel.fieldsModel
                .firstWhereOrNull((element) => element.fieldType == FieldType.taps),
            isBackgroundMode: true);

        if (updateRes.isLoadSuccess) {
          report.isSync = true;
          element.isSync = true;
          reports.removeWhere((e) => e.id == element.id);
          await dataLocalManager.clearReports();
          await dataLocalManager.saveReports(reports);
          await dataLocalManager.saveReportFormDetail(report);
        } else {
          return 'Cập nhật nội dung biên bản ${report.reportModel.name}: ${updateRes.message}';
        }
      } else{}

    }

    return null;
  }

  Future<String> _syncDown() async {
    // final futures = <Future<String>>[];
    //     // futures.add(_syncWorks());
    //     // futures.add(_syncReports());
    //     // futures.add(_syncListFormTemplate());
    //     // futures.add(_syncCenterListReport());
    //     // futures.add(_syncListUserAction());
    //     // futures.add(_syncLisTeams());
    //     // futures.add(_syncListLocation());
    //     // futures.add(_syncUnitWork());
    //     // futures.add(_syncUnscheduledReport());
    //     // futures.add(_syncStamps());
    //     // final res = await Future.wait<String>(futures) ?? List.empty();
    //     // final mess = res.where((element) => element != null).toList();
    //     // return mess?.map((e) => e)?.join('\n   ');

    final errorWork = await _syncWorks();
    //final errorReport = await _syncReports();
    final errorReportMerge = await _syncReportsMergeImplement();
    final errorReportReject = await _syncReportsMergeReject();
    final errorReportTemplate = await _syncListFormTemplate();
    final errorCenter = await _syncCenterListReport();
    final errorUsers = await _syncListUserAction();
    final errorTeam = await _syncLisTeams();
    final errorLocation = await _syncListLocation();
    final errorUnitWork = await _syncUnitWork();
    final errorUnscheduleReport = await _syncUnscheduledReport();
    final errorStamps = await _syncStamps();

    final errorAll = [
      errorWork,
      //errorReport,
      errorReportTemplate,
      errorReportReject,
      errorCenter,
      errorUsers,
      errorTeam,
      errorReportMerge,
      errorLocation,
      errorUnitWork,
      errorUnscheduleReport,
      errorUnscheduleReport,
      errorStamps,
    ];

        final mess = errorAll.where((element) => element != null).toList();
        return mess?.map((e) => e)?.join('\n   ');
  }

  ///Sync stamps
  Future<String> _syncStamps() async {
    final res = await _formRepository.getsTamp();
    if(res.isLoadSuccess){
      await RLocalDataManager.instance.saveStamps(res.data);
    } else {
      return 'Đồng bộ danh sách stamp thất bại';
    }
    return null;
  }

  /// danh sach công việc
  Future<String> _syncWorks() async {
    const textError = 'Danh sách công việc:';
    Future<String> getOnePageInListWork(int pageIndex) async {
      final response = await _reportRepository.getListWork(
          pageIndex: pageIndex, isNotShowLoading: true);
      if (response.isLoadSuccess) {
        await RLocalDataManager.instance.saveWorks(response.data.list);
      } else {
        return '$textError ${response?.message ?? ''}';
      }

      return null;
    }

    final response =
        await _reportRepository.getListWork(isNotShowLoading: true);
    final listError = <String>[];
    if (response.isLoadSuccess) {
      final int totalPage = response?.data?.paging?.totalPages;
      if (totalPage != null) {
        await RLocalDataManager.instance.clearWorks();
        final listPage = <int>[];
        for (var index = 1; index <= totalPage; index++) {
          listPage.add(index);
        }

        await Future.forEach(listPage, (pageIndex) async {
          final error = await getOnePageInListWork(pageIndex);
          listError.add(error);
        });
      }
    } else {
      return '$textError ${response?.message ?? ''}';
    }
    final data = listError?.where((element) => element?.isNotEmpty == true);

    return data.firstOrNull;
  }

  /// list report merge
  Future<String> _syncReportsMergeImplement() async {
    const textError = 'Danh sách gộp biên bản:';
    final listError = <String>[];
    Future<String> getOnePageInListReports(int pageIndex) async {
      final response = await _mergerFormReportRepository.getReports(
          pageIndex: pageIndex,
          workingStatus: ReportStatusType.Implementing.toString(),
          isNotShowLoading: true);

      if (response.isLoadSuccess && response.data.listReport != null) {
        final reports = response.data.listReport;

        final errors = <String>[];
        await Future.forEach(reports, (element) async {
          final response = await _mergerFormReportRepository.getDetailMergeWork(element.id, isBackgroundMode: true);
          if (response.isLoadSuccess) {
            element.reportMergeModels = response.data;
          } else {
            errors.add('Chi tiết công việc: ${element.id} ${response.message}');
          }
          await _syncHistoryApprove(element.id);
        });
        await RLocalDataManager.instance.saveMergeReports(reports);

        await Future.forEach(reports, (element) async {
          final response = await _reportRepository.getReportFormDetail(element.formReportId, isNotShowLoading: true);
          if (response.isLoadSuccess) {
            await RLocalDataManager.instance.saveReportFormDetail(response.data);
          } else {
            errors.add('Chi tiết form nhập biên bản: ${element.id} ${response.message}');
          }
        });

        return errors.firstOrNull;

      } else {
        return '$textError ${response?.message ?? ''}';
      }
    }

    final response = await _mergerFormReportRepository.getReports(
        isNotShowLoading: true, workingStatus: ReportStatusType.Implementing.toString());
    if (response.isLoadSuccess) {
      final int totalPage = response?.data?.paging?.totalPages;
      if (totalPage != null) {
        await RLocalDataManager.instance.clearMergeReports();
        final listPage = <int>[];
        for (var index = 1; index <= totalPage; index++) {
          listPage.add(index);
        }
        await Future.forEach(listPage, (pageIndex) async {
          final error = await getOnePageInListReports(pageIndex);
          listError.add(error);
        });
      }
    } else {
      return '$textError ${response?.message ?? ''}';
    }

    final data = listError?.where((element) => element?.isNotEmpty == true);

    return data.firstOrNull;
  }

  Future<String> _syncReportsMergeReject() async {
    const textError = 'Danh sách gộp biên bản:';
    final listError = <String>[];
    Future<String> getOnePageInListReports(int pageIndex) async {
      final response = await _mergerFormReportRepository.getReports(
          pageIndex: pageIndex,
          workingStatus: ReportStatusType.Rejected.toString(),
          isNotShowLoading: true);

      if (response.isLoadSuccess && response.data.listReport != null) {
        final reports = response.data.listReport;

        final errors = <String>[];
        await Future.forEach(reports, (element) async {
          final response = await _mergerFormReportRepository.getDetailMergeWork(element.id, isBackgroundMode: true);
          if (response.isLoadSuccess) {
            element.reportMergeModels = response.data;
          } else {
            errors.add('Chi tiết công việc: ${element.id} ${response.message}');
          }
          await _syncHistoryApprove(element.id);
        });
        await RLocalDataManager.instance.saveMergeReports(reports);

        await Future.forEach(reports, (element) async {
          final response = await _reportRepository.getReportFormDetail(element.formReportId, isNotShowLoading: true);
          if (response.isLoadSuccess) {
            await RLocalDataManager.instance.saveReportFormDetail(response.data);
          } else {
            errors.add('Chi tiết form nhập biên bản: ${element.id} ${response.message}');
          }
        });

        return errors.firstOrNull;

      } else {
        return '$textError ${response?.message ?? ''}';
      }
    }

    final response = await _mergerFormReportRepository.getReports(
      isNotShowLoading: true,
      workingStatus: ReportStatusType.Rejected.toString(),
    );
    if (response.isLoadSuccess) {
      final int totalPage = response?.data?.paging?.totalPages;
      if (totalPage != null) {
        final listPage = <int>[];
        for (var index = 1; index <= totalPage; index++) {
          listPage.add(index);
        }
        await Future.forEach(listPage, (pageIndex) async {
          final error = await getOnePageInListReports(pageIndex);
          listError.add(error);
        });
      }
    } else {
      return '$textError ${response?.message ?? ''}';
    }

    final data = listError?.where((element) => element?.isNotEmpty == true);

    return data.firstOrNull;
  }


  // danh sách biên bản
  Future<String> _syncReports() async {
    const textError = 'Danh sách biên bản:';
    final listError = <String>[];
    Future<String> getOnePageInListReports(int pageIndex) async {
      final response = await _reportRepository.getFormReport(
          pageIndex: pageIndex,
          isNotShowLoading: true);

      if (response.isLoadSuccess && response.data.listReport != null) {
        final reports = response.data.listReport.where((element) =>
        element.workingStatus == ReportStatusType.Implementing ||
            element.workingStatus == ReportStatusType.Rejected)?.toList() ?? List<ListReportModel>.empty();

        await RLocalDataManager.instance.saveReports(reports);
        final errors = <String>[];
        await Future.forEach(reports, (element) async {
         final error = await _syncReportFormDetail(element.id);
          if(error?.isNotEmpty == true){
           errors.add(error);
         }
        });

        return errors.firstOrNull;

      } else {
        return '$textError ${response?.message ?? ''}';
      }
    }

    final response = await _reportRepository.getFormReport(isNotShowLoading: true);
    if (response.isLoadSuccess) {
      final int totalPage = response?.data?.paging?.totalPages;
      if (totalPage != null) {
        await RLocalDataManager.instance.clearReports();
        await RLocalDataManager.instance.clearFormReportDetail();
        final listPage = <int>[];
        for (var index = 1; index <= totalPage; index++) {
          listPage.add(index);
        }
        await Future.forEach(listPage, (pageIndex) async {
          final error = await getOnePageInListReports(pageIndex);
          listError.add(error);
        });
      }
    } else {
      return '$textError ${response?.message ?? ''}';
    }

    final data = listError?.where((element) => element?.isNotEmpty == true);

    return data.firstOrNull;
  }

  Future<String> _syncListFormTemplate() async {
    Future<String> getOnePageInListForm(int pageIndex) async {
      final response = await _formRepository.getForms(pageIndex: pageIndex);
      if (response.isLoadSuccess) {
        await RLocalDataManager.instance
            .saveListFormTemplate(response.data.list);
       // final futures = <Future<String>>[];
        final listReport = response?.data?.list ?? List<FormInfo>.empty();
        //
        // for (final element in listReport) {
        //   futures.add(_syncFormTemplate(element.id, element.name));
        // }
        //
        // final errorRes = await Future.wait<String>(futures);
        // final errors = errorRes.where((element) => element?.isNotEmpty == true);
        // return errors.firstOrNull;
        final errors = <String>[];
        await Future.forEach(listReport, (element) async {
          final error = await _syncFormTemplate(element.id, element.name);
          if(error?.isNotEmpty == true){
            errors.add(error);
          }
        });

        return errors.firstOrNull;
      } else {
        return 'Mẫu biên bản: ${response?.message}' ?? '';
      }
    }

    final response = await _formRepository.getForms();
    final totalPages = response?.data?.paging?.totalPages;

    if (response.isLoadSuccess && totalPages != null) {
      await RLocalDataManager.instance.clearListFormTemplate();
      //final futures = <Future<String>>[];
      // for (var index = 1; index <= totalPages; index++) {
      //   futures.add(getOnePageInListForm(index));
      // }
      //
      // final errorRes = await Future.wait<String>(futures);
      //
      // final errors = errorRes.where((element) => element?.isNotEmpty == true);
      // return errors.firstOrNull;

      final pages = [];
      final errors = <String>[];

      for (var index = 1; index <= totalPages; index++) {
        pages.add(index);
      }

      await Future.forEach(pages, (element)  async {
       final error = await getOnePageInListForm(element);
       errors.add(error);
      });
      final data = errors?.where((element) => element?.isNotEmpty == true);
      return data.firstOrNull;
    } else {
      return 'Danh sách mẫu biên bản: ${response?.message}';
    }
  }

  Future<String> _syncFormTemplate(String formId, String formName) async {
    final response = await _formRepository.getForm(formId);
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.saveFormTemplate(response.data);
    } else {
      return 'Mẫu biên bản $formName: ${response.message}';
    }

    return null;
  }

  Future<String> _syncReportFormDetail(String formId) async {
    final response = await _reportRepository.getReportFormDetail(formId,
        isNotShowLoading: true);
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.saveReportFormDetail(response.data);
    } else {
      return 'Nội dung biên bản: $formId ${response.message}';
    }

    return null;
  }

  /// danh sách trung tâm
  Future<String> _syncCenterListReport() async {
    final response = await _reportRepository.getDepartment();
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.saveCenterReport(response.data);
    } else {
      return 'Danh sách trung tâm: ${response?.message ?? ''}';
    }

    return null;
  }

  /// danh sách người thực hiện
  Future<String> _syncListUserAction() async {
    final response = await _reportRepository.getListUser();
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.savePerformers(response.data);
    } else {
      return 'Danh sách người thực hiện: ${response?.message ?? ''}';
    }

    return null;
  }

  /// danh sách địa điểm
  Future<String> _syncListLocation() async {
    final response = await _reportRepository.getSubstation();
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.saveLocationReport(response.data);
    } else {
      return 'Danh sách địa điểm: ${response?.message ?? ''}';
    }

    return null;
  }

  /// danh sách tổ đội
  Future<String> _syncLisTeams() async {
    final response = await _reportRepository.getTeams();
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.saveTeamsReport(response.data);
    } else {
      return 'Danh sách tổ đội: ${response?.message ?? ''}';
    }

    return null;
  }

  /// danh sách lịch sử phê duyệt
  Future<String> _syncHistoryApprove(String workId) async {
    final response =
        await _mergerFormReportRepository.getApprovalHistory(id: workId);
    if (response.isLoadSuccess) {
      response?.data?.listHistory?.forEach((element) {
        element.workId = workId;
      });
      await RLocalDataManager.instance
          .saveHistoryApprove(response?.data?.listHistory);
    }
    return null;
  }

  /// danh sách đơn vị công việc
  Future<String> _syncUnitWork() async {
    final response = await _reportRepository.getUnits();
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance.saveUnitWork(response.data);
    } else {
      return 'Danh sách đơn vị : ${response?.message ?? ''}';
    }
    return null;
  }

  /// dánh sách dropdow biên bản không theo kế hoạch
  Future<String> _syncUnscheduledReport() async {
    final response = await _reportRepository.getDataUnscheduled();
    if (response.isLoadSuccess) {
      await RLocalDataManager.instance
          .saveUnscheduledReportOffline(response.data);
    } else {
      return 'Biên bản không theo kế hoạch : ${response.message ?? ''}';
    }
    return null;
  }
}

