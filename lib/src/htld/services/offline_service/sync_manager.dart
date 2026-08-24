// @dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/common.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/attach_image_model.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/distribution_inspect_model.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
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
import 'package:evnmobile/src/htld/models/popups_data_model.dart';
import 'package:evnmobile/src/htld/models/result_model.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/line_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/location_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/substation_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/upload_service.dart';
import 'package:evnmobile/src/htld/services/responsitory/work_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:g_json/g_json.dart';

import 'local_data_manager.dart';

class SyncManager {
  static final shared = SyncManager();
  final workRepo = WorkRepository();
  final deviceRepo = SubstationRepository();
  final ticketRepo = TicketRepository();
  final locationService = LocationRepository();
  final lineRepo = LineTicketRepository();

  ///SYNC DOWN
  Future<bool> syncDown() async {
    final hasInternet = await Connection.shared.checkConnection();

    if (hasInternet) {
      /// Đồng bộ Trạm biến áp phân phối
      EasyLoading.instance.userInteractions = false;
      final a = [
        SubStationType.distribution,
        SubStationType.intermediate,
        SubStationType.mediumVoltage
      ];
      var isHasDataOffline = false;

      for (final ticketType in SubStationType.mediumVoltage.tickets) {
        final currentWorks = await LocalDataManager.shared.getWorks(
            SubStationType.mediumVoltage,
            getWorkType(SubStationType.mediumVoltage, ticketType).toString());
        if (currentWorks?.isNotEmpty == true) {
          for (final element in currentWorks) {
            if (element?.isCreateOffline == true ||
                element?.isHasDataUpdateOffline == true) {
              isHasDataOffline = true;
              break;
            }
          }
        }

        if (isHasDataOffline) {
          break;
        }
      }

      if (isHasDataOffline) {
        var result = true;
        await showMyDialogOkCancel(
            'Tìm thấy dữ liệu chưa được đồng bộ lên, nếu tiếp tục thì dữ liệu lưu offline hiện tại sẽ mất',
            secondFunction: () {
              result = true;
            },
            secondTitle: 'Tiếp tục',
            firstAction: () {
              result = false;
            },
            firstTitle: 'Huỷ');
        if (!result) {
          return result;
        }
      }

      final futures = <Future>[];
      a?.forEach((subType) {
        subType.tickets?.forEach((ticketType) async {
          final workType = getWorkType(subType, ticketType);
          if (workType != null) {
            futures.add(syncWork(workType, subType, ticketType));
          }
        });
      });
      await Future.wait(futures);
    } else {
      await showDialogError('Vui lòng kiểm tra kết nối Internet');
    }

    return true;
  }

  Future syncWork(
      int workType, SubStationType subType, TicketType ticketType) async {
    final futures = <Future>[];
    // get công việc với status chưa thưc hiện
    final currentDate = DateTime.now();
    final fromDate = DateTime(currentDate.year, currentDate.month , 1);
    final toDate = DateTime(currentDate.year, currentDate.month + 2, 0);

    final data = await workRepo.getListWork(
        subStationType: subType,
        workType: '$workType',
        workStatus: '',
        isBackground: true,
        fromDate: fromDate.formatFirstDate(),
        toDate: toDate.formatSecondDate());

    if (data?.data?.list == null) {
      return;
    }
    await LocalDataManager.shared
        .syncWorks(data?.data?.list ?? [], subType, workType.toString());
    final newWorks =
        await LocalDataManager.shared.getWorks(subType, workType.toString());

      final listImplement = newWorks
          ?.where((element) => element.workStatus == 2)
          ?.toList() ?? <WorkModel>[];
       await Future.forEach(listImplement, (element) async {
      //Step1: sync info general
      if (subType == SubStationType.mediumVoltage) {
        Future syncGeneral() async {
          final generalData = await lineRepo.getGeneral(element.entityId, isBackgroundMode: true);
          await LocalDataManager.shared.saveLineGeneral(
              general: generalData.data, ticketId: element.entityId);
        }

        Future syncContent() async {
          final contentData = await lineRepo.getContent(element.entityId, isBackgroundMode: true);
          await LocalDataManager.shared.saveLineContent(
              contents: contentData.data, ticketId: element.entityId);
          final contentFutures = <Future>[];
          contentData.data?.forEach((e) {
            contentFutures.add(syncBranchNodes(element.entityId, e.id));
            contentFutures.add(syncContentBranch(element.entityId, e.id));
          });

          await Future.wait(contentFutures);
        }

        final lineTicketFutures = <Future>[];

        lineTicketFutures.add(syncGeneral());
        lineTicketFutures.add(syncContent());

        await Future.wait(lineTicketFutures);
      } else {
        final generalData =
            await ticketRepo.getGeneralInfo(element.entityId, subType, isBackgroundMode: true);
        await LocalDataManager.shared
            .saveGeneral(generalData.data, element.entityId);
      }

      //Step2: sync content
      await syncContent(element.entityId, subType, ticketType);
      futures.add(syncResult(element, subType));
    });

    await Future.wait(futures);

    final listTypeNotImplement = newWorks
        ?.where((element) => element.workStatus == 1 || element.workStatus == 2)
        ?.toList() ?? <WorkModel>[] ;
    await Future.forEach(listTypeNotImplement, (element) async {
     // futures.add();
       await  syncDeviceFromWork(
          element, subType, ticketType, element.substationModel.id);
    });
    return true;
  }

  Future<bool> syncDeviceFromWork(
      WorkModel model,
      SubStationType subStationType,
      TicketType ticketType,
      String subStationId) async {
    // Get vật tư cho đường dây
    if (subStationType == SubStationType.mediumVoltage) {
      final futures = <Future>[];
      futures.add(syncLineBranch(model.line.id));
      futures.add(syncAllEquipmentInLine(model.line.id));
      futures.add(syncAllNodeInLine(model.line.id));
      await Future.wait(futures);
      return true;
    } else {
      // Get vật tư cho trạm biến áp
      final data = await deviceRepo.getListEquipment(
          substationId: model.substationModel.id,
          isBackground: true,
          inspectType: subStationType.code.toString(),
          ticketId: model.entityId);
      if (data.isLoadSuccess) {
        await LocalDataManager.shared.syncEquipmentForWork(
            data?.data?.list ?? List.empty(),
            subStationType,
            model.entityId,
            subStationId,
            ticketType.code.toString());
        debugPrint('sync device for $subStationId success!');
      }

      return true;
    }
  }

  Future syncResult(WorkModel model, SubStationType subStationType) async {
    // Get result
    if (subStationType == SubStationType.mediumVoltage) {
      final res = await ticketRepo.getLineResult(model.entityId, isBackgroundMode: true);
      if (res.isLoadSuccess) {
        await LocalDataManager.shared
            .saveResult(res.data.resultModel.toJson(), model.entityId);
      }
    } else {
      final data =
          await ticketRepo.getResult(model.entityId, subStationType.endPoint, isBackgroundMode: true);
      await LocalDataManager.shared
          .saveResult(data.data.resultModel.toJson(), model.entityId);
    }
  }

  Future<bool> syncContent(String ticketId, SubStationType subStationType,
      TicketType ticketType) async {
    var popupJobs = <Future>[];
    if (subStationType == SubStationType.distribution) {
      if (ticketType == TicketType.periodicNight) {
        final data = await ticketRepo.getContentNight(ticketId, isBackgroundMode: true);
        await LocalDataManager.shared.savePopupForTicket(
            ticketId, data.data.popupsModel, subStationType, ticketType);
        await LocalDataManager.shared
            .saveContent(data.data.toOfflineJson(), ticketId);
        popupJobs = data.data.popupsModel
            .where((element) => element.isSaved)
            ?.map((e) =>
                syncPopupContent(e, ticketId, subStationType, ticketType))
            ?.toList();
      } else {
        final data = await ticketRepo.getContentDistributionDayTime(ticketId, isBackgroundMode: true);
        await LocalDataManager.shared.savePopupForTicket(
            ticketId, data.data.popupsModel, subStationType, ticketType);
        await LocalDataManager.shared.saveContent(data.data.toJson(), ticketId);
        popupJobs = data.data.popupsModel
            .where((element) => element.isSaved)
            ?.map((e) =>
                syncPopupContent(e, ticketId, subStationType, ticketType))
            ?.toList();
      }
    }

    if (subStationType == SubStationType.intermediate) {
      if (ticketType == TicketType.periodicNight) {
        final data = await ticketRepo.getContentInterNightTime(ticketId, isBackgroundMode: true);
        await LocalDataManager.shared.savePopupForTicket(
            ticketId, data.data.popupsModel, subStationType, ticketType);
        await LocalDataManager.shared.saveContent(data.data.toJson(), ticketId);
        popupJobs = data.data.popupsModel
            .where((element) => element.isSaved)
            ?.map((e) =>
                syncPopupContent(e, ticketId, subStationType, ticketType))
            ?.toList();
      } else {
        final data = await ticketRepo.getContentInterDayTime(ticketId, isBackgroundMode: true);
        await LocalDataManager.shared.savePopupForTicket(
            ticketId, data.data.popupsModel, subStationType, ticketType);
        await LocalDataManager.shared.saveContent(data.data.toJson(), ticketId);
        popupJobs = data.data.popupsModel
            .where((element) => element.isSaved)
            ?.map((e) =>
                syncPopupContent(e, ticketId, subStationType, ticketType))
            ?.toList();
      }
    }
    await Future.wait(popupJobs);
    return true;
  }

  Future<bool> syncPopupContent(
      PopupsDataModel popupsDataModel,
      String ticketId,
      SubStationType subStationType,
      TicketType ticketType) async {
    if (subStationType == SubStationType.distribution) {
      if (ticketType == TicketType.periodicNight) {
        final data = await ticketRepo.getDistributionNightPopup(ticketId,
            popupsDataModel.equipmentId, popupsDataModel.getEndPoint(), isBackgroundMode: true);
        await LocalDataManager.shared.savePopup(
            popupsDataModel.getEndPoint(), data?.mapObject, ticketId,
            popupsDataModel: popupsDataModel);
        return data != null;
      } else {
        final data = await ticketRepo.getDistributionDayPopup(ticketId,
            popupsDataModel.equipmentId, popupsDataModel.getEndPoint(), isBackgroundMode: true);
        await LocalDataManager.shared.savePopup(
            popupsDataModel.getEndPoint(), data?.mapObject, ticketId,
            popupsDataModel: popupsDataModel);
        return data != null;
      }
    }

    if (subStationType == SubStationType.intermediate) {
      if (ticketType == TicketType.periodicNight) {
        final data = await ticketRepo.getIntermediateNightPopup(ticketId,
            popupsDataModel.equipmentId, popupsDataModel.getEndPoint(), isBackgroundMode: true);
        await LocalDataManager.shared.savePopup(
            popupsDataModel.getEndPoint(), data?.mapObject, ticketId,
            popupsDataModel: popupsDataModel);
        return data != null;
      } else {
        final data = await ticketRepo.getIntermediateDayPopup(ticketId,
            popupsDataModel.equipmentId, popupsDataModel.getEndPoint(), isBackgroundMode: true);
        await LocalDataManager.shared.savePopup(
            popupsDataModel.getEndPoint(), data?.mapObject, ticketId,
            popupsDataModel: popupsDataModel);
        return data != null;
      }
    }

    return true;
  }

  Future<void> syncLineBranch(String lineId) async {
    final data = await deviceRepo.getLine(parentId: lineId, isBackgroundMode: true);
    await LocalDataManager.shared.saveLine(lineId, data.data);
    final branchs = data.data.lineChilds;
    if (branchs?.isNotEmpty == true) {
      final branchJob = branchs?.map((e) => syncLineBranch(e.id))?.toList();
      await Future.wait(branchJob);
    }

    final nodeIds = data.data.substations?.map((e) => e.id)?.toList();
    await syncKinkEquipments(lineId, nodeIds);
    return true;
  }

  Future<bool> syncKinkEquipments(String lineBranchId, List<String> ids) async {
    final data = await deviceRepo.getEquipmentLine(substationIds: ids, isBackgroundMode: true);
    await LocalDataManager.shared.saveEquipmentLine(
        lineBranchId: lineBranchId, equipments: data.data.list);
    return true;
  }

  ///SYNC UP
  Future<void> syncUp() async {
    final hasInternet = await Connection.shared.checkConnection();

    if (hasInternet) {
      final a = [
        SubStationType.distribution,
        SubStationType.intermediate,
        SubStationType.mediumVoltage
      ];
      a?.forEach((subType) async {
        subType.tickets?.forEach((ticketType) async {
          final workType = getWorkType(subType, ticketType);
          final workAll = await LocalDataManager.shared
              .getWorks(subType, workType.toString());
          final workDoing = workAll
              .where((element) => element.workStatus == 2)
              .toList()
          ?? <WorkModel>[];
          await Future.forEach(workDoing, (element) async {
          final location =
          await LocalDataManager.shared.getLocation(element.entityId);
          locationService.updateLocation(location?.latitude,
          location?.longitude, element?.substationModel?.id);
          await syncUpForWork(element, subType, ticketType);
          });
        });
      });
    } else {
      await showDialogError('Vui lòng kiểm tra kết nối Internet');
    }
  }

  Future<void> syncUpForWork(WorkModel model, SubStationType subStationType,
      TicketType ticketType) async {
    if (subStationType == SubStationType.mediumVoltage) {
      var ticketId = '';
      final ticketIdOffLine = model.entityId;
      final general = await LocalDataManager.shared
          .getLineGeneral(ticketId: ticketIdOffLine);
      final listBranchSelected = general.listLineBranchInfo;

      if (model?.isCreateOffline == true) {
        //create ticket for all
        if (general?.isAll == true) {
          final createTicketRes = await lineRepo.createTicketAllNode(
            inspectionType: ticketType,
            lineId: model.line.id,
            branchId: model.line.id,
            workId: model.workId,
            isBackgroundMode: true
          );
          if (createTicketRes.isLoadSuccess) {
            ticketId = createTicketRes.data;
          }
        } else {
          //create ticket for multi branch
          final branchSelected = listBranchSelected.first;
          final nodesSelected = LocalDataManager.shared
              .getAllNodeBranchSelected(ticketIdOffLine, branchSelected.id);
          final equipmentDistinct = LocalDataManager.shared
              .getEquipmentDistinctBranchSelected(
                  ticketIdOffLine, branchSelected.id);

          final createTicketRes = await lineRepo.createTicket(
              inspectionType: ticketType,
              lineId: model.line.id,
              workId: model.workId,
              branchId: branchSelected.lineBranchId,
              kinks: nodesSelected,
              isBackgroundMode: true,
              equipments: equipmentDistinct);

          if (createTicketRes.isLoadSuccess) {
            ticketId = createTicketRes.data;
            if (listBranchSelected.length > 1) {
              for (var i = 1; i < listBranchSelected.length; i++) {
                final nodesSelected = LocalDataManager.shared
                    .getAllNodeBranchSelected(
                    ticketIdOffLine, listBranchSelected[i].id);

                final equipmentSelected = LocalDataManager.shared
                    .getEquipmentDistinctBranchSelected(
                        ticketIdOffLine, listBranchSelected[i].id);

                await lineRepo.addOneBranch(
                    ticketId,
                    lineBranchId: listBranchSelected[i].lineBranchId,
                    kinks: nodesSelected,
                    isBackgroundMode: true,
                    equipments: equipmentSelected);
              }
            }
          }
        }
      } else if (model?.isHasDataUpdateOffline == true) {
        ticketId = model.entityId;
        for(final branch in listBranchSelected){
          if (branch.id.contains('offline')) {
            final nodesSelected = LocalDataManager.shared.getAllNodeBranchSelected(ticketIdOffLine, branch.id);

            final equipmentSelected = LocalDataManager.shared
                .getEquipmentDistinctBranchSelected(
                ticketIdOffLine, branch.id);

            await lineRepo.addOneBranch(
                ticketId,
                lineBranchId: branch.id,
                kinks: nodesSelected,
                isBackgroundMode: true,
                equipments: equipmentSelected);
          }
        }
      }

      if (ticketId.isNotEmpty) {
        final contentOnline = await lineRepo.getContent(ticketId, isBackgroundMode: true);
        for (final lineBranch in contentOnline.data) {
          var lineBranchIdUpdate = '';
          var lineBranchIdOffLine = '';
          for (final branchSaveOffline in listBranchSelected) {
            if (branchSaveOffline.id.contains('offline')) {
              if (branchSaveOffline.lineBranchName == lineBranch.lineBranchName) {
                lineBranchIdUpdate = lineBranch.id;
                lineBranchIdOffLine = branchSaveOffline.id;
                break;
              }
            } else {
              lineBranchIdUpdate = lineBranch.id;
              lineBranchIdOffLine = lineBranch.id;
            }
          }

          //syncUp Popup
          final popupDataOffline = LocalDataManager.shared
              .getLineBranchContent(
                  ticketId: ticketIdOffLine, lineBranchId: lineBranchIdOffLine)?.popups;
          final popupDataOnline =
              (await lineRepo.getBranchContent(ticketId, lineBranch.id, isBackgroundMode: true))
                  ?.data
                  ?.popups;
          for (final popup
              in popupDataOnline ?? List<PopupsDataModel>.empty()) {
            final popupOffline = popupDataOffline?.firstWhere(
                (e) => e.inspectionCategory == popup.inspectionCategory,
                orElse: () => null);
            final dataPopup = LocalDataManager.shared
                .getLinePopup<Map<String, dynamic>>(
                    ticketIdOffLine,
                lineBranchIdOffLine,
                    popupOffline.equipmentId,
                    popup.inspectionCategory,
                    isReturnMap: true);
            if (dataPopup != null && dataPopup['isUpdateOffline'] != null && dataPopup['isUpdateOffline'] == true) {
              if (dataPopup['images'] != null) {
               final images = JSON(dataPopup['images'])?.list?.map((e) => Images.fromJson(e))?.toList();

               if (images?.isNotEmpty == true) {
                 final imagesSynced = await syncLineImage(images);
                 dataPopup['images'] = imagesSynced.map((v) => v.toJson()).toList();
               }
              }
              final keyUpdate =
                  InspectionCategory.getUpdateKeyLine(popup.inspectionCategory);
              final params = {
                'equipmentId': popup.equipmentId,
                keyUpdate: dataPopup
              };

              await ticketRepo.updateLinePopup(
                  ticketId,
                  InspectionCategory.getKeyLine(popup.inspectionCategory),
                  params,
                  lineBranch.id, isBackgroundMode: true);
            }
          }

          //syncUpContent
          final contentBranch = LocalDataManager.shared.getLineBranchContent(
              ticketId: ticketIdOffLine, lineBranchId: lineBranchIdOffLine);
          if (contentBranch?.isUpdateOffline == true) {
            if (contentBranch?.lineInsulationContent?.images?.isNotEmpty == true) {
             final images = await syncLineImage(contentBranch?.lineInsulationContent?.images);
             contentBranch.lineInsulationContent.images = images;
            }

            if (contentBranch?.lineJoint?.images?.isNotEmpty == true) {
             final images = await syncLineImage(contentBranch?.lineJoint?.images);
             contentBranch.lineJoint.images = images;
            }

            if (contentBranch?.lineRightsOfWay?.images?.isNotEmpty == true) {
             final images = await syncLineImage(contentBranch?.lineRightsOfWay?.images);
             contentBranch.lineRightsOfWay.images = images;
            }

            if (contentBranch?.lineWire?.images?.isNotEmpty == true) {
             final images = await syncLineImage(contentBranch?.lineWire?.images);
             contentBranch.lineWire.images = images;
            }

            await lineRepo.updateBranchContent(
                ticketId: ticketId,
                isBackgroundMode: true,
                lineBranchInspectId: lineBranchIdUpdate,
                params: contentBranch.toUpdateJson(ticketType));
          }
        }

        //syncUp general
        if (general.isUpdateOffline) {
          await lineRepo.updateInfo(ticketId, general, isBackgroundMode: true);
        }

        //syncUp result
        final result = await LocalDataManager.shared.getResult(ticketIdOffLine);
        if (result != null) {
         final lineResult = LineResultModel.fromJson(result);
          if (lineResult.isUpdateOffline) {
            await ticketRepo.saveLineResult(lineResult, ticketId, isBackgroundMode: true);
          }
        }


        await LocalDataManager.shared.clearWorkOffline(model, subStationType, ticketType);
      }
    } else {
      //Tram bien ap
      //Step2: Lấy trạm biến áp và vật tư được chọn
      //Step3: Create ID phiếu
      var ticketId = '';
      if (model.entityId.contains('offlineID')) {
        final ticketIDOnline =
            await createTicketForWork(model, subStationType, ticketType);
        ticketId = ticketIDOnline;
      } else {
        ticketId = model.entityId;
        debugPrint('dong bo cv len TBA: ${model.substationModel.name}');
        //general
        final generalData = await LocalDataManager.shared.getGenerals(ticketId);
        final equipments = await LocalDataManager.shared.getEquipmentForWork(
            subStationType.code.toString(),
            model.substationModel.id,
            ticketType.code.toString());
        final distributionInspectModel = DistributionInspectModel();
        distributionInspectModel.equipments =
            equipments.where((element) => element.isChecked).toList();
        distributionInspectModel.weather_1 = generalData.weather1;
        distributionInspectModel.weather_2 = generalData.weather2;
        distributionInspectModel.temperature_1 = generalData.temperature1;
        distributionInspectModel.temperature_2 = generalData.temperature2;
        await ticketRepo.update(
            distributionInspectModel, subStationType, ticketId, isBackgroundMode: true);
      }

      //Step5: Create save các popup đã làm
      final popupsLocals =
          await LocalDataManager.shared.getPopupsForTicket(model.entityId);
      final popupJobs = <Future>[];
      final savedPopups =
          popupsLocals.where((element) => element.isSaved).toList();

      final serverImage =
          await syncPopupImage(model, savedPopups, subStationType, ticketType);
      savedPopups?.forEach((element) async {
        //Đồng bộ các popup đã lưu
        final detailPopup = await LocalDataManager.shared
            .getPopup(model.entityId, equipmentId: element.equipmentId);
        if (detailPopup != null) {
          //upload popups images
          final images = serverImage[savedPopups.indexOf(element)];
          final endPoint = detailPopup['endPoint'].string;
          detailPopup.remove('endPoint');
          if (subStationType == SubStationType.distribution) {
            //POPUP TBA Phan phoi
            if (ticketType == TicketType.periodicNight) {
              final dataObject = detailPopup[
                  InspectionCategory.getKeyDistributionNightModel(
                      element.inspectionCategory)];
              if (images.isNotEmpty) {
                dataObject['images'] =
                    images?.map((e) => e.toJsonWithoutURL())?.toList();
              }
              detailPopup[InspectionCategory.getKeyDistributionNightModel(
                  element.inspectionCategory)] = dataObject;
              popupJobs.add(ticketRepo.updateDistributionNightPopup(
                  ticketId, endPoint, detailPopup?.mapObject, isBackgroundMode: true));
            } else {
              final dataObject = detailPopup[
                  InspectionCategory.getKeyDistributionDayModel(
                      element.inspectionCategory)];
              if (images.isNotEmpty) {
                dataObject['images'] =
                    images?.map((e) => e.toJsonWithoutURL())?.toList();
              }
              detailPopup[InspectionCategory.getKeyDistributionDayModel(
                  element.inspectionCategory)] = dataObject;
              popupJobs.add(ticketRepo.updatePopup(
                  ticketId, endPoint, detailPopup?.mapObject, isBackgroundMode: true));
            }
          } else if (subStationType == SubStationType.intermediate) {
            //POPUP TBA Trung Gian
            if (ticketType == TicketType.periodicNight) {
              final dataObject = detailPopup[
                  InspectionCategory.getKeyIntermediateNightModel(
                      element.inspectionCategory)];
              if (images.isNotEmpty) {
                dataObject['images'] =
                    images?.map((e) => e.toJsonWithoutURL())?.toList();
              }
              detailPopup[InspectionCategory.getKeyIntermediateNightModel(
                  element.inspectionCategory)] = dataObject;
              popupJobs.add(ticketRepo.updateInterNightPopup(
                  ticketId, endPoint, detailPopup?.mapObject, isBackgroundMode: true));
            } else {
              final dataObject = detailPopup[
                  InspectionCategory.getKeyIntermediateDayModel(
                      element.inspectionCategory)];
              if (images.isNotEmpty) {
                dataObject['images'] =
                    images?.map((e) => e.toJsonWithoutURL())?.toList();
              }
              detailPopup[InspectionCategory.getKeyIntermediateDayModel(
                  element.inspectionCategory)] = dataObject;
              popupJobs.add(ticketRepo.updateInterPopup(
                  ticketId, endPoint, detailPopup?.mapObject, isBackgroundMode: true));
            }
          }
        }
      });
      debugPrint('Created popup jobs: ${popupJobs.length} jobs');
      //final popupData = await Future.wait(popupJobs);
      debugPrint('Sync popup jobs: Done!');
      debugPrint('Sync content data');
      //Step6: Save nội dung kiểm tra với tự động điền
      //Step4: Lấy Nội dung kiểm tra
      final contentData =
          await LocalDataManager.shared.getContent(model.entityId);
      final contentJob = <Future>[];
      if (subStationType == SubStationType.distribution) {
        //POPUP TBA Phan phoi
        if (ticketType == TicketType.periodicNight) {
          contentJob.add(ticketRepo.createContentNightTime(
              contentData?.mapObject, ticketId, isBackgroundMode: true));
        } else {
          contentJob.add(ticketRepo.updateContentDayDistribution(
              contentData?.mapObject, ticketId, isBackgroundMode: true));
        }
      } else if (subStationType == SubStationType.intermediate) {
        //POPUP TBA Trung Gian
        if (ticketType == TicketType.periodicNight) {
          contentJob.add(ticketRepo.updateContentNightInter(
              contentData?.mapObject, ticketId, isBackgroundMode: true));
        } else {
          contentJob.add(ticketRepo.updateContentDayInter(
              contentData?.mapObject, ticketId, isBackgroundMode: true));
        }
      }
      //final contentJobData = await Future.wait(contentJob);
      //Step7: Get Kết quả -> save -> hoàn thành nếu đủ điều kiện
      final date = DateTime.now().add(const Duration(days: 1));
      final result = await LocalDataManager.shared.getResult(model.entityId);
      final resultModel = ResultModel.fromJson(result);
      final param = {
        'substationSituation': resultModel.substationSituation ?? '',
        'solution': resultModel.solution ?? '',
        'dueDate': date.toStringFormat(AppStrings.utcFormatNotZ, isUtc: true)
      };

      await ticketRepo.saveResult(param, ticketId, subStationType.endPoint, isBackgroundMode: true);
      await ticketRepo.completeTicket(ticketId, subStationType.endPoint, isBackgroundMode: true);
    }
  }

  Future<List<List<Images>>> syncPopupImage(
      WorkModel model,
      List<PopupsDataModel> popupsLocals,
      SubStationType subStationType,
      TicketType ticketType) async {
    final imagePopupsJob = <Future<List<Images>>>[];
    popupsLocals?.forEach((element) async {
      imagePopupsJob.add(syncImage(model, element, subStationType, ticketType));
    });
    final data = await Future.wait(imagePopupsJob);
    return data ?? [];
  }

  Future<List<Images>> syncImage(
      WorkModel model,
      PopupsDataModel popupsDataModel,
      SubStationType subStationType,
      TicketType ticketType) async {
    final popupdata = await LocalDataManager.shared
        .getPopup(model.entityId, equipmentId: popupsDataModel.equipmentId);
    JSON imageJson;
    if (subStationType == SubStationType.distribution) {
      if (ticketType == TicketType.periodicNight) {
        imageJson = popupdata[InspectionCategory.getKeyDistributionNightModel(
            popupsDataModel.inspectionCategory)]['images'];
      } else {
        imageJson = popupdata[InspectionCategory.getKeyDistributionDayModel(
            popupsDataModel.inspectionCategory)]['images'];
      }
    } else if (subStationType == SubStationType.intermediate) {
      if (ticketType == TicketType.periodicNight) {
        imageJson = popupdata[InspectionCategory.getKeyIntermediateNightModel(
            popupsDataModel.inspectionCategory)]['images'];
      } else {
        imageJson = popupdata[InspectionCategory.getKeyIntermediateDayModel(
            popupsDataModel.inspectionCategory)]['images'];
      }
    }
    if (imageJson.list == null) {
      return [];
    }
    final images = imageJson.list?.map((e) => Images.fromJson(e))?.toList();
    final job = images?.map(uploadImage)?.toList();
    final data = await Future.wait(job);
    return data;
  }

  Future<List<Images>> syncLineImage(List<Images> images) async {
    final job = images?.map(uploadImage)?.toList();
    final data = await Future.wait(job);
    return data;
  }

  Future<Images> uploadImage(Images image) async {
    final service = UploadService();
    if (image?.path?.isEmpty == true) {
      return image;
    }
    final data = await service.upload(File(image.path), isBackgroundMode: true);
    image.url = data.data.url;
    image.imageStorageId = data.data.imageStorageId;
    image.path = null;
    return image;
  }

  Future<String> createTicketForWork(WorkModel model,
      SubStationType subStationType, TicketType ticketType) async {
    final equipments = await LocalDataManager.shared.getEquipmentForWork(
        subStationType.code.toString(),
        model.substationModel.id,
        ticketType.code.toString());
    final equipmentsSelected =
        equipments.where((element) => element.isChecked).toList();
    final generalModel =
        await LocalDataManager.shared.getGenerals(model.entityId);
    final distributionModel = DistributionInspectModel();
    distributionModel.workId = model.workId;
    distributionModel.type = ticketType;
    distributionModel.subStationId = model.substationModel.id;
    distributionModel.inspectTime =
        DateTime.now().toStringFormat(AppStrings.utcFormatNotZ, isUtc: true);
    distributionModel.equipments = equipmentsSelected;
    distributionModel.lastInspectTime = model.substationModel.latestInspectTime;
    distributionModel.inspectRequest = '';
    distributionModel.frequency = model.frequency;
    distributionModel.temperature_1 ??= generalModel?.temperature1;
    distributionModel.temperature_2 ??= generalModel?.temperature2;
    distributionModel.weather_1 ??= generalModel?.weather1;
    distributionModel.weather_2 ??= generalModel?.weather2;
    final data = await ticketRepo.create(distributionModel, subStationType, isBackgroundMode: true);
    return data?.data?.ticketId ?? '';
  }

  Future syncBranchNodes(String ticketId, String lineBranchId) async {
    final listSubstations = <EquipmentModel>[];
    final listData = <List<EquipmentModel>>[];
    Future getPage(int page) async {
      final response = await lineRepo
          .getBranchNodes(ticketId, lineBranchId, page, isBackgroundMode: true);
      if (response.isLoadSuccess && response.data.list != null) {
        listData.insert(page - 1, response.data.list);
      }
    }

    final response = await lineRepo.getBranchNodes(ticketId, lineBranchId, 1,
        isBackgroundMode: true);

    if (response.isLoadSuccess) {
      listData.add(response.data?.list);
      final totalPage = response.data.paging.totalPages;
      final futures = <Future>[];
      if (totalPage != null && totalPage > 1) {
        for (var pageIndex = 2; pageIndex <= totalPage; pageIndex++) {
          listData.add(List.empty());
          futures.add(getPage(pageIndex));
        }
      }
      await Future.wait(futures);
      listData?.forEach(listSubstations.addAll);

      await LocalDataManager.shared.saveAllNodeBranchSelected(
          ticketId: ticketId,
          lineBranchId: lineBranchId,
          equipments: listSubstations);
    } else {
      //   await showDialogError(response.message);
    }
  }

  Future syncAllNodeInLine(String lineId) async {
    final listSubstations = <EquipmentModel>[];
    final listData = <List<EquipmentModel>>[];
    Future getPage(int page) async {
      final response =
          await deviceRepo.getLineNodes(lineId, page, isBackgroundMode: true);
      if (response.isLoadSuccess && response.data.list != null) {
        listData.insert(page - 1, response.data.list);
      }
    }

    final response =
        await deviceRepo.getLineNodes(lineId, 1, isBackgroundMode: true);

    if (response.isLoadSuccess) {
      listData.add(response.data?.list);
      final totalPage = response.data.paging.totalPages;
      final futures = <Future>[];
      if (totalPage != null && totalPage > 1) {
        for (var pageIndex = 2; pageIndex <= totalPage; pageIndex++) {
          listData.add(List.empty());
          futures.add(getPage(pageIndex));
        }
      }
      await Future.wait(futures);
      listData?.forEach(listSubstations.addAll);
      await LocalDataManager.shared
          .saveAllNodeInLine(lineId: lineId, equipments: listSubstations);
    } else {
      //   await showDialogError(response.message);
    }
  }

  Future syncAllEquipmentInLine(String lineId) async {
    final listSubstations = <EquipmentModel>[];
    final listData = <List<EquipmentModel>>[];
    Future getPage(int page) async {
      final response = await deviceRepo.getAllEquipmentInLine(lineId, page,
          isBackgroundMode: true);
      if (response.isLoadSuccess && response?.data?.list != null) {
        listData.insert(page - 1, response.data.list);
      }
    }

    final response = await deviceRepo.getAllEquipmentInLine(lineId, 1,
        isBackgroundMode: true);

    if (response.isLoadSuccess) {
      listData.add(response.data?.list);
      final totalPage = response.data.paging.totalPages;
      final futures = <Future>[];
      if (totalPage != null && totalPage > 1) {
        for (var pageIndex = 2; pageIndex <= totalPage; pageIndex++) {
          listData.add(List.empty());
          futures.add(getPage(pageIndex));
        }
      }
      await Future.wait(futures);
      listData?.forEach(listSubstations.addAll);
      await LocalDataManager.shared
          .saveAllEquipmentInLine(lineId: lineId, equipments: listSubstations);
    } else {
      //   await showDialogError(response.message);
    }
  }

  Future syncContentBranch(String ticketId, String lineBranchId) async {
    final contentBranch =
        await lineRepo.getBranchContent(ticketId, lineBranchId, isBackgroundMode: true);
    if (contentBranch.isLoadSuccess) {
      await LocalDataManager.shared.saveLineBranchContent(
          contentModel: contentBranch.data,
          ticketId: ticketId,
          lineBranchId: lineBranchId);
      final futures = <Future>[];
      contentBranch?.data?.popups?.forEach((element) {
        futures.add(syncLinePopup(element, ticketId, lineBranchId));
      });

      await Future.wait(futures);
    }
  }

  Future syncLinePopup(PopupsDataModel popupsDataModel, String ticketId,
      String lineBranchId) async {
    final endpoint =
        InspectionCategory.getKeyLine(popupsDataModel.inspectionCategory);
    switch (popupsDataModel.inspectionCategory) {
      case InspectionCategory.linePole:
        final response = await ticketRepo.getLinePole(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LinePoleModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineBeam:
        final response = await ticketRepo.getLineBeam(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineBeamModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineFundament:
        final response = await ticketRepo.getLineFundament(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineFundamentModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineWire:
        final response = await ticketRepo.getLineWire(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineWireModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineInsulation:
        final response = await ticketRepo.getLineInsulation(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineInsulationModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineRodGap:
        final response = await ticketRepo.getLineRodGap(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineRodGadModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineLightningArrester:
        final response = await ticketRepo.getLineLightningArrester(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared
              .saveLinePopup<LineLightningArresterModel>(response.data,
                  ticketId, lineBranchId, popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineEarthing:
        final response = await ticketRepo.getLineEarthing(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineEarthingModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineDisconnectorsSwitch:
        final response = await ticketRepo.getLineDisconnectorsSwitch(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared
              .saveLinePopup<LineDisconnectorsSwitchModel>(response.data,
                  ticketId, lineBranchId, popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineRecloser:
        final response = await ticketRepo.getLineRecloser(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineRecloserModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineCuttingMachine:
        final response = await ticketRepo.getLineCuttingMachine(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineCuttingMachineModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineFuseCutOut:
        final response = await ticketRepo.getLineFuseCutOut(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineFuseCutOutModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineCapacitor:
        final response = await ticketRepo.getLineCapacitor(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineCapacitorModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.lineMeasureTheBoundary:
        final response = await ticketRepo.getLineMeasureTheBoundary(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared
              .saveLinePopup<LineMeasureTheBoundaryModel>(response.data,
                  ticketId, lineBranchId, popupsDataModel.equipmentId);
        }
        break;
      case InspectionCategory.ineUndergroundCables:
        final response = await ticketRepo.getLineUndergroundCable(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineUndergroundCable>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;

      case InspectionCategory.lineTI:
        final response = await ticketRepo.getLineTI(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineTiModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;

      case InspectionCategory.lineTU:
        final response = await ticketRepo.getLineTU(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineTUModel>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }
        break;

      case InspectionCategory.lineRMU:
        final response = await ticketRepo.getLineRmu(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineRmu>(response.data,
              ticketId, lineBranchId, popupsDataModel.equipmentId);
        }
        break;

      case InspectionCategory.lineBreaker:
        final response = await ticketRepo.getLineBreaker(
            ticketId, popupsDataModel.equipmentId, endpoint, lineBranchId, isBackgroundMode: true);
        if (response.isLoadSuccess) {
          await LocalDataManager.shared.saveLinePopup<LineBreaker>(
              response.data,
              ticketId,
              lineBranchId,
              popupsDataModel.equipmentId);
        }

        break;
      default:
        break;
    }
  }
}

