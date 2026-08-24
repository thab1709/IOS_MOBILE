// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/models/line/line_branch_info.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/models/work_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/line_repository.dart';
import 'package:evnmobile/src/htld/services/responsitory/substation_repository.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../../../../app_env.dart';
import '../../../../app_common/shared/app_shared.dart';

class ListLineController extends GetxController {
  static const int branchValue = 1;
  static const int allBranchValue = 2;
  RxInt groupValue = 1.obs;

  RxList<EquipmentModel> kinks = RxList.empty();
  RxList<EquipmentModel> equipments = RxList.empty();
  RxList<LineModel> lines = RxList.empty();
  RxList<LineModel> menus = RxList.empty();
  final LineTicketController _lineTicketController = Get.find();
  final repository = LineTicketRepository();
  LineBranchInfo lineBranchInfo;
  List<String> listBranchSelected;
  bool isSingleBranch = false;
  bool isFirst = false;
  LineModel lineModel;
  SubstationRepository service = SubstationRepository();
  Rx<LineModel> selectedLine = LineModel().obs;
  final RoundedLoadingButtonController btnControllerNode =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController btnControllerEquipment =
      RoundedLoadingButtonController();

  int nodePageIndex = 1;
  int equipmentPageIndex = 1;
  final isNodeHasLoadMore = false.obs;
  final isEquipmentHasLoadMore = false.obs;

  List<EquipmentModel> getSelected() {
    return kinks.where((e) => e.isChecked).toList();
  }

  Future setDataType(int type) async {
    groupValue.value = type;

    if (type == branchValue) {
      // NOTE(hau): check ha the
      // if (AppShared.instance.getAppType() == AppType.HTLDHT) {
      //   await getAllNodesInLine(isChecked: false);
      // } else {
      await _getLineData(
          _lineTicketController?.argument?.workModel?.line?.id ?? lineModel.id);
      // }
    } else if (type == allBranchValue) {
      await getAllNodesInLine();
      await getAllEquipmentInLine();
    }
  }

  Future _getLineData(String lineId,
      {String inspectId, bool isEdit = false}) async {
    equipments.clear();
    kinks.clear();
    menus.clear();
    final connection = await Connection.shared.checkConnection();
    if (connection) {
      isNodeHasLoadMore.value = false;
      final response = await service.getLine(
          parentId: lineId, inspectId: menus.isEmpty ? inspectId : '');
      lineModel = response.data;

      if (response.isLoadSuccess) {
        if (!isFirst) {
          isFirst = true;
          isSingleBranch = response?.data?.lineChilds == null ||
              response.data.lineChilds.isEmpty;
        }

        kinks.clear();
        if (listBranchSelected?.firstWhere((element) => element == lineId,
                orElse: () => null) ==
            null) {
          kinks.assignAll(response.data.substations ?? []);
        }

        menus.add(response.data);
        menus.removeDuplicates();

        ///selected node
        if (lineBranchInfo != null) {
          final startIndex = kinks.indexWhere(
              (element) => element.id == lineBranchInfo.startNodeId);
          final endIndex = kinks
              .indexWhere((element) => element.id == lineBranchInfo.endNodeId);

          for (var index = 0; index < kinks.length; index++) {
            if (index >= startIndex && index <= endIndex) {
              kinks[index].isChecked = true;
            }
          }
        } else {
          lines.assignAll(response.data.lineChilds ?? []);
        }
      } else {
        await showDialogError(response.message);
      }

      selectedLine.value = response.data;
      // await getEquipmentInLine();
    } else {
      final lineData = await LocalDataManager.shared.getLine(lineId);
      lineModel = lineData;

      kinks.clear();
      if (listBranchSelected?.firstWhere((element) => element == lineId,
              orElse: () => null) ==
          null) {
        kinks.assignAll(lineData.substations ?? []);
      }

      menus.add(lineData);
      menus.removeDuplicates();

      ///selected node
      if (lineBranchInfo != null) {
        final startIndex = kinks
            .indexWhere((element) => element.id == lineBranchInfo.startNodeId);
        final endIndex = kinks
            .indexWhere((element) => element.id == lineBranchInfo.endNodeId);

        for (var index = 0; index < kinks.length; index++) {
          if (index >= startIndex && index <= endIndex) {
            kinks[index].isChecked = true;
          }
        }
      } else {
        lines.assignAll(lineData.lineChilds ?? []);
      }

      selectedLine.value = lineData;
      await getEquipmentInLine();
    }

    update();
  }

  Future getAllNodesInLine({int pageIndex = 1, bool isChecked = true}) async {
    nodePageIndex = pageIndex;
    if (pageIndex == 1) {
      menus.value = menus.sublist(0, 1);
      menus.refresh();
      lines.clear();
      lines.refresh();
      equipments.clear();
    }
    Future online() async {
      final response = await service.getLineNodes(
          _lineTicketController?.argument?.workModel?.line?.id ?? lineModel.id,
          nodePageIndex);

      if (response.isLoadSuccess) {
        kinks.removeWhere((element) => element.id == null);
        // NOTE(hau): check ha the
        // if (AppShared.instance.getAppType() == AppType.HTLDHT) {
        //   response.data.list.forEach((element) {
        //     element.isChecked = isChecked;
        //   });
        // }
        if (pageIndex == 1) {
          kinks.assignAll(response.data.list);
        } else {
          kinks.addAll(response.data.list);
        }
        if (AppShared.instance.getAppType() != AppType.HTLDHT) {
          kinks.forEach((element) {
            element.isChecked = isChecked;
          });
        }

        isNodeHasLoadMore.value =
            response?.data?.paging?.isHasLoadMore() ?? false;
        if (isNodeHasLoadMore.value) {
          kinks.add(EquipmentModel(id: null));
        }

        kinks.refresh();
        if (pageIndex > 1) {
          btnControllerNode.success();
        }
        update();
      } else {
        await showDialogError(response?.message);
      }

      if (pageIndex > 1) {
        btnControllerNode.reset();
      }
    }

    void offline() {
      final response = LocalDataManager.shared.getAllNodeInLine(
          _lineTicketController?.argument?.workModel?.line?.id ?? lineModel.id);
      if (response != null) {
        kinks.assignAll(response);
        kinks.forEach((element) {
          element.isChecked = true;
        });

        kinks.refresh();
        update();
      }
    }

    final isOnline = await Connection.shared.checkConnection();

    if (isOnline) {
      await online();
    } else {
      offline();
    }
  }

  Future getAllEquipmentInLine({int pageIndex = 1}) async {
    Future online() async {
      equipmentPageIndex = pageIndex;
      final response = await service.getAllEquipmentInLine(
          _lineTicketController?.argument?.workModel?.line?.id ?? lineModel.id,
          equipmentPageIndex);
      if (response.isLoadSuccess) {
        equipments.removeWhere((element) => element.id == null);
        if (pageIndex == 1) {
          equipments.assignAll(response.data.list);
        } else {
          equipments.addAll(response.data.list);
        }
        isEquipmentHasLoadMore.value =
            response?.data?.paging?.isHasLoadMore() ?? false;
        if (isNodeHasLoadMore.value) {
          equipments.add(EquipmentModel(id: null));
        }

        equipments.refresh();
        if (pageIndex > 1) {
          btnControllerEquipment.success();
        }
        update();
      } else {
        await showDialogError(response?.message);
      }

      if (pageIndex > 1) {
        btnControllerEquipment.reset();
      }
    }

    void offline() {
      final response = LocalDataManager.shared.getAllEquipmentInLine(
          _lineTicketController?.argument?.workModel?.line?.id ?? lineModel.id);
      if (response != null) {
        equipments.assignAll(response);
        equipments.refresh();
        update();
      }
    }

    final isOnline = await Connection.shared.checkConnection();

    if (isOnline) {
      await online();
    } else {
      offline();
    }
  }

  Future fetchData() async {
    // NOTE(hau): check ha the
    // if (AppShared.instance.getAppType() == AppType.HTLDHT) {
    //   selectedLine.value = lineModel;
    //   menus.assignAll([lineModel]);
    //   await getAllNodesInLine(isChecked: false);
    // } else {
    await _getLineData(lineModel.id);
    // }
  }

  Future getEquipmentInLine({int index = 0}) async {
    final substationIds =
        getKinkSelected().map((element) => element.id).toList();
    if (substationIds.isEmpty) {
      return;
    }

    final connection = await Connection.shared.checkConnection();
    debugPrint('API  getEquipmentInLine ${selectedLine.value.id}');
    final listId = AppShared.instance.getAppType() == AppType.HTLDHT
        ? [lines[index].id]
        : substationIds;
    if (connection) {
      final response = await service.getEquipmentLine(substationIds: listId);

      if (response.isLoadSuccess) {
        equipments.assignAll(response.data.list);
        equipments.refresh();
      } else {
        await showDialogError(response.message);
      }
    } else {
      final response = await LocalDataManager.shared
          .getEquipmentKinks(selectedLine.value.id, substationIds);
      equipments.assignAll(response);
      equipments.refresh();
    }
  }

  Future getSelectedLine(String substationId) async {
    await _getLineData(substationId, inspectId: _lineTicketController.ticketId);
  }

  Future getLineDetailFromWork(WorkModel model) async {
    await _getLineData(model.line.id, inspectId: model.entityId);
  }

  Future getLineDetail(int index) async {
    final model = lines[index];
    equipments.clear();
    final connection = await Connection.shared.checkConnection();
    if (connection) {
      final response = await service.getLine(parentId: model.id);

      if (response.isLoadSuccess) {
        selectedLine.value = response.data;
        menus.add(model);
        menus.refresh();
        kinks.clear();
        if (listBranchSelected?.firstWhere(
                (element) => element == selectedLine.value.id,
                orElse: () => null) ==
            null) {
          kinks.assignAll(response.data.substations);
        }
        lines.assignAll(response.data.lineChilds);
        update();
      } else {
        await showDialogError(response.message);
      }
    } else {
      final response = await LocalDataManager.shared.getLine(model.id);
      selectedLine.value = response;
      menus.add(model);
      menus.refresh();
      kinks.clear();
      if (listBranchSelected?.firstWhere(
              (element) => element == selectedLine.value.id,
              orElse: () => null) ==
          null) {
        kinks.assignAll(response.substations);
      }
      lines.assignAll(response.lineChilds);
      update();
    }
  }

  Future chooseMenu(int index) async {
    equipments.clear();
    final model = menus[index];
    final indexOfModel = menus.indexOf(model);
    menus.removeRange(indexOfModel, menus.length);
    await _getLineData(model.id,
        inspectId: _lineTicketController.ticketId, isEdit: true);
  }

  void chooseKink(int index) {
    final selected = kinks.where((element) => element.isChecked).toList();
    if (selected.length >= 2) {
      kinks.forEach((element) {
        element.isChecked = false;
      });
      kinks[index].isChecked = true;
      equipments.clear();
      // NOTE(hau): check ha the
      // if (AppShared.instance.getAppType() == AppType.HTLDHT) {
      //   getEquipmentInLine();
      // }
    } else {
      kinks[index].isChecked = true;
      final selectedA = kinks.where((element) => element.isChecked).toList();
      final startIndex = kinks.indexOf(selectedA.first);
      final endIndex = kinks.indexOf(selectedA.last);

      if (selectedA.length == 2) {
        kinks.forEach((element) {
          final eIndex = kinks.indexOf(element);
          if (eIndex >= startIndex && eIndex <= endIndex) {
            element.isChecked = true;
          }
        });

        getEquipmentInLine();
      } else if (selectedA.length == 1) {
        // NOTE(hau): check ha the
        // if (AppShared.instance.getAppType() == AppType.HTLDHT) {
        //   getEquipmentInLine();
        // }
      }
    }
    kinks.refresh();
  }

  void chooseSingleKink(int index) {
    final selected = kinks.where((element) => element.isChecked).toList();
    if (selected.isNotEmpty) {
      kinks.forEach((element) {
        element.isChecked = false;
      });
      equipments.clear();
    }
    kinks[index].isChecked = true;
    getEquipmentInLine();
    kinks.refresh();
  }

  Future chooseLine(int index, {bool isEdit}) async {
    final model = lines[index];
    selectedLine.value = model;
    kinks.clear();
    equipments.clear();
    lines.forEach((element) {
      element.isChecked = false;
    });
    model.isChecked = true;
    lines.refresh();
    final connection = await Connection.shared.checkConnection();
    if (connection) {
      final response = await service.getLine(parentId: lines[index].id);
      debugPrint('API  chooseLine ${lines[index].id}');
      if (response.isLoadSuccess) {
        kinks.assignAll(response.data.substations);
        kinks.refresh();
      } else {
        await showDialogError(response.message);
      }
    } else {
      final response = await LocalDataManager.shared.getLine(model.id);
      kinks.assignAll(response.substations);
      kinks.refresh();
    }
    await getEquipmentInLine(index: index);
  }

  Future create(LineArgument lineArgument) async {
    final connection = await Connection.shared.checkConnection();
    if (connection) {
      final response = await repository.createTicket(
          inspectionType: _lineTicketController.argument.ticketType,
          workId: _lineTicketController.argument.workModel?.workId,
          lineId: lineArgument.line.id,
          branchId: lineArgument.branch.id,
          kinks: lineArgument.kinks,
          equipments: lineArgument.equipments,
          isNight: lineArgument.isNight);

      if (response.isLoadSuccess) {
        _lineTicketController.ticketId = response.data;
        await Get.to(() => const LineTicketScreen());
      } else {
        await showDialogError(response.message);
      }
    } else {
      final data = await LocalDataManager.shared.createLineTicket(
          inspectionType: _lineTicketController.argument.ticketType,
          workId: _lineTicketController.argument.workModel?.workId,
          lineId: lineArgument.line.id,
          branchId: lineArgument.branch.id,
          kinks: lineArgument.kinks,
          isSingleBranch: isSingleBranch,
          equipments: lineArgument.equipments,
          lineTicketArgument: _lineTicketController.argument,
          branchSelected: menus);
      _lineTicketController.ticketId = data;

      //change work status
      await LocalDataManager.shared.changeStatusLineWorkWhenCreate(
          _lineTicketController.argument.ticketType,
          _lineTicketController.argument.workModel?.workId,
          data);
      await Get.to(() => const LineTicketScreen());
    }
  }

  Future createWithAllNode(LineArgument lineArgument) async {
    Future online() async {
      final response = await repository.createTicketAllNode(
        inspectionType: _lineTicketController.argument.ticketType,
        workId: _lineTicketController.argument.workModel?.workId,
        lineId: lineArgument.line.id,
        branchId: lineArgument.branch.id,
      );

      if (response.isLoadSuccess) {
        _lineTicketController.ticketId = response.data;
        await Get.to(() => const LineTicketScreen());
      } else {
        await showDialogError(response.message);
      }
    }

    Future offline() async {
      final data = await LocalDataManager.shared.createLineTicket(
          inspectionType: _lineTicketController.argument.ticketType,
          workId: _lineTicketController.argument.workModel?.workId,
          lineId: lineArgument.line.id,
          branchId: lineArgument.branch.id,
          kinks: lineArgument.kinks,
          isAll: true,
          lineTicketArgument: _lineTicketController.argument,
          equipments: lineArgument.equipments,
          branchSelected: menus);
      _lineTicketController.ticketId = data;

      //change work status
      await LocalDataManager.shared.changeStatusLineWorkWhenCreate(
          _lineTicketController.argument.ticketType,
          _lineTicketController.argument.workModel?.workId,
          data);

      await Get.to(() => const LineTicketScreen());
    }

    final isOnline = await Connection.shared.checkConnection();
    if (isOnline) {
      await online();
    } else {
      await offline();
    }
  }

  Future addOneBranch(LineArgument lineArgument) async {
    final connection = await Connection.shared.checkConnection();
    if (connection) {
      final response = await repository.addOneBranch(
          _lineTicketController.ticketId,
          lineBranchId: lineArgument.branch.id,
          kinks: lineArgument.kinks,
          equipments: lineArgument.equipments);

      if (response.isLoadSuccess) {
        Get.back(result: true);
      } else {
        await showDialogError(response.message);
      }
    } else {
      await LocalDataManager.shared.addOneBranch(_lineTicketController.ticketId,
          lineBranchId: lineArgument.branch.id,
          kinks: lineArgument.kinks,
          workId: _lineTicketController?.argument?.workModel?.workId,
          ticketType: _lineTicketController?.argument?.ticketType,
          equipments: lineArgument.equipments,
          branchSelected: menus);
      Get.back(result: true);
    }
  }

  Future updateBranch(LineArgument lineArgument) async {
    final connection = await Connection.shared.checkConnection();

    if (connection) {
      final response = await repository.updateBranch(
          _lineTicketController.ticketId,
          lineBranchId: lineBranchInfo.id,
          kinks: lineArgument.kinks,
          equipments: lineArgument.equipments);

      if (response.isLoadSuccess) {
        Get.back(result: true);
      } else {
        await showDialogError(response.message);
      }
    } else {
      await LocalDataManager.shared.updateBranch(_lineTicketController.ticketId,
          lineBranchId: lineBranchInfo.lineBranchId,
          kinks: lineArgument.kinks,
          equipments: lineArgument.equipments,
          branchSelected: menus,
          workId: _lineTicketController.argument.workModel.workId,
          ticketType: _lineTicketController.argument.ticketType,
          isOffline: true);
      Get.back(result: true);
    }
  }

  LineModel getBranchSelected() {
    return selectedLine.value;
  }

  List<EquipmentModel> getKinkSelected() {
    if (AppShared.instance.getAppType() == AppType.HTLDHT) {
      // kinks.first.isChecked = true;
      // kinks.refresh();
    }
    final datas = kinks.where((element) => element.isChecked);
    return datas.toList();
  }
}

