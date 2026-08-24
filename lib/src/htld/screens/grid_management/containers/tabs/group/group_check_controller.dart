// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/group_model.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/models/person_performing_model.dart';
import 'package:evnmobile/src/htld/models/profile_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/common/line_ticket_screen.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/request_model/create_group_request.dart';
import 'package:evnmobile/src/htld/services/responsitory/group_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../app_env.dart';

mixin GroupCheckDelegate {
  void onUpdateGroupSuccess({bool isSuccess});
}

class GroupCheckController extends GetxController {
  final service = GroupRepository();
  final optionPerson = <UserOptionModel>[].obs;
  UserProfileModel userProfile;
  final listPerson = <PersonPerformingModel>[];
  final listPersonInGroup = <PersonPerformingModel>[].obs;
  bool _isDispose = false;
  final group = GroupModel().obs;

  final TicketController ticketController = Get.find();
  // final ConnectionController connectionController = Get.find();
  LineTicketController lineTicketController;

  GroupCheckDelegate delegate;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
    _isDispose = true;
  }

  TicketType getTicketType() {
    if (ticketController?.ticketScreenArgument?.ticketType != null) {
      return ticketController?.ticketScreenArgument?.ticketType;
    } else if (lineTicketController?.argument?.ticketType != null) {
      return lineTicketController?.argument?.ticketType;
    }
    return TicketType.periodicDay;
  }

  Future<void> getUserProfile() async {
    userProfile = AppShared.instance.getUserProfile();
  }

  void setPerson({@required num position, @required String personId}) {
    final person = listPerson?.firstWhere(
        (element) => element.userId == personId,
        orElse: () => null);

    listPersonInGroup[position] = person;
    optionPerson.forEach((element) {
      element.isSelected = false;
    });

    listPersonInGroup.forEach((elementUser) {
      optionPerson
          .firstWhere((element) => element.value == elementUser.userId,
              orElse: () => null)
          ?.isSelected = true;
    });
    optionPerson.refresh();
    listPersonInGroup.refresh();
    if (!_isDispose) {
      this?.update();
    }
  }

  Future<void> getListPersonPerforming({bool isLine}) async {
    await getUserProfile();
    String workId;
    if (isLine) {
      lineTicketController = Get.find();
      workId = lineTicketController.argument.workModel?.workId ?? '';
    } else {
      workId = ticketController.ticketScreenArgument.workId;
    }
    if (ticketController?.ticketID == null &&
        lineTicketController?.ticketId == null) {
      return;
    }

    await getGroup(isLine: isLine);

    final response = await service.getPersonPerform(workId: workId);

    if (response.isLoadSuccess && response.data != null) {
      listPerson.clear();
      listPerson.addAll(response.data.persons);

      optionPerson.clear();
      optionPerson.addAll(response.data.persons
          .map((e) => UserOptionModel(e.name, e.userId))
          ?.toList());
      optionPerson.refresh();
      if (_isDispose) return;
      this?.update();
      await getGroup(isLine: isLine);
    } else {
      // await showDialogError(response.message);
    }
  }

  Future<void> getGroup({bool isLine}) async {
    final hasInternet = await Connection.shared.checkConnection();
    final userGroup = AppShared.instance.getUserProfile().userGroup;

    if (ticketController?.ticketID == null && isLine == false ||
        lineTicketController?.ticketId == null && isLine) {
      return;
    }
    // final subStationType = isLine ? SubStationType.mediumVoltage  : ticketController?.ticketScreenArgument?.subStationType;

    final subStationType = AppShared.instance.getAppType() == AppType.HTLDHT
        ? (isLine
            ? SubStationType.lowVoltage
            : ticketController?.ticketScreenArgument?.subStationType)
        : (isLine
            ? SubStationType.mediumVoltage
            : ticketController?.ticketScreenArgument?.subStationType);

    // If there is no Internet, get data from local
    // ignore: unrelated_type_equality_checks
    if (!hasInternet) {
      final workModel = LocalDataManager.shared.works?.firstWhere(
          (element) =>
              element.substationModel.id ==
                  ticketController?.getSubstationId() ||
              element.line.id == ticketController?.getLineId(),
          orElse: () => null);
      if (workModel != null) {
        final user = workModel.users
            .where((element) => element.groupName == userGroup)
            .toList();

        listPersonInGroup.value = user;
      }
    }
    // Else, get data from API
    else {
      final response = await service.getGroup(
          formId: isLine
              ? lineTicketController.ticketId
              : ticketController.ticketID,
          endpoint: subStationType.endPoint);

      if (response.isLoadSuccess) {
        group.value = response.data.group;
        group.value?.groups?.forEach((element) {
          element.isSaved = true;
        });
        listPersonInGroup.assignAll(group?.value?.groups ?? []);

        final groupLength = listPersonInGroup.length;
        if (groupLength == 0) {
          final user = PersonPerformingModel(
            userId: userProfile.id,
            name: userProfile.name,
            position: userProfile.positionName,
            level: userProfile.level,
            atLevel: userProfile.atLevel,
          );
          listPersonInGroup.add(user);
        }
        final actionType = isLine
            ? lineTicketController.argument.actionType
            : ticketController?.ticketScreenArgument?.actionType;
        final ticketType = getTicketType();
        if (actionType != null &&
            actionType != ActionType.view &&
            (ticketType != TicketType.periodicDay ||
                ticketType != TicketType.periodicNight)) {
          for (var i = 0; i < 5 - listPersonInGroup.length; i++) {
            listPersonInGroup.add(PersonPerformingModel());
          }
        }

        listPersonInGroup.refresh();
      } else {
        //await showDialogError(response.message);

        final workModel = LocalDataManager?.shared?.works?.firstWhere(
            (element) =>
                element.substationModel.id ==
                ticketController?.getSubstationId(),
            orElse: () => null);
        if (workModel == null) return;
        listPersonInGroup.value = workModel.users;
        listPersonInGroup.forEach((elementUser) {
          optionPerson
              .firstWhere((element) => element.value == elementUser.userId,
                  orElse: () => null)
              ?.isSelected = true;
        });

        listPersonInGroup.refresh();
      }
    }
    if (!_isDispose) {
      this?.update();
    }
  }

  Future<void> createGroup({bool isLine}) async {
    final hasInternet = await Connection.shared.checkConnection();

    if (ticketController?.ticketID == null &&
        lineTicketController?.ticketId == null) {
      return;
    }

    listPersonInGroup.removeWhere((element) => element.userId == null);

    final data = CreateGroupRequest(
        groups:
            listPersonInGroup.map((e) => Groups(userId: e.userId)).toList());
    final subStationType = isLine
        ? SubStationType.mediumVoltage
        : ticketController?.ticketScreenArgument?.subStationType;

    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      if (!hasInternet) {
        delegate.onUpdateGroupSuccess(isSuccess: true);
        return;
      }

      final response = await service.createOrUpdateGroup(
          isLine ? lineTicketController.ticketId : ticketController.ticketID,
          data.toJson(),
          subStationType.endPoint);

      if (response.isLoadSuccess) {
        if (!_isDispose) {
          this?.update();
        }
        delegate.onUpdateGroupSuccess(isSuccess: response.isLoadSuccess);
      } else {
        await showDialogError(response.message);
        delegate.onUpdateGroupSuccess(isSuccess: true);
      }
    }
  }
}

