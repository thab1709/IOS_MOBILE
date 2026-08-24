// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htdct/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htdct/models/team_model.dart';
import 'package:get/get.dart';

import '../../common/base/base_delegate.dart';
import '../../models/option_model.dart';
import '../../services/responsitory/location_repository.dart';
import 'models/subtation_address.dart';

class ListLocationController extends GetxController {
  RxList<SubstationAddress> substationAddress = RxList.empty();
  BaseDelegate delegate;
  final repository = LocationRepository();
  String searchTerm = '';
  String groupId = '';
  String teamId = '';
  final RxString substationId = ''.obs;
  int optionType = 0;
  int page = 1;
  List<UserOptionModel> listGroupsOption = [];
  List<TeamModel> teams = [];
  final userProfile = AppShared.instance.getUserProfile();
  final isHasLoadMore = false.obs;

  RxList<UserOptionModel> listTBAorLineOption = RxList.empty();
  RxList<UserOptionModel> listTeamOption = RxList.empty();

  void initData() {
    listGroupsOption = AppShared.instance
        .getGroupsHTDCT()
        .map((e) => UserOptionModel(e.name, e.id))
        .toList();

    listTBAorLineOption = AppShared.instance
        .getListSubstationHTDCT()
        .map((e) => UserOptionModel(e.name, e.id))
        .toList()
        .obs;

    teams = AppShared.instance.getTeamsHTDCT();

    setGroupId(AppShared.instance.getUserProfileDCT().userGroupId ?? '');
  }

  void setGroupId(String id) {

    groupId = id;
    listTeamOption.assignAll(teams
        .where((element) => element.userGroupId == groupId)
        .toList()
        .map((e) => UserOptionModel(e.name, e.id)));
    teamId = '';
    listTeamOption.refresh();
  }

  void setOptionType(String option) {
    optionType = int.parse(option);
    if (optionType == 0) {
      final data = AppShared.instance
          .getListSubstationHTDCT()
          .map((e) => UserOptionModel(e.name, e.id))
          .toList();
      listTBAorLineOption.assignAll(data);
    } else if (optionType == 1) {
      listTBAorLineOption.assignAll(AppShared.instance
          .getListLineHTDCT()
          .map((e) => UserOptionModel(e.name, e.id))
          .toList());
    } else {}
    substationId.value = '';
    listTBAorLineOption.refresh();
  }

  void clearFilter() {
    groupId = null;
    teamId = null;
    substationId.value = null;
    optionType = 0;
    getData();
  }

  Future<void> getData({bool animation = false}) async {
    page = 1;
    final response = await repository.getSubstationAddress(
        searchTerm: searchTerm,
        userGroupId: groupId,
        userTeamId: teamId,
        entityId: substationId.value,
        page: page,
        type: optionType,
        backgroundMode: animation);
    delegate?.loadSuccess();
    if (response.isLoadSuccess) {
      substationAddress.assignAll(response.data.locations);
    } else {
      await hShowDialogOneButton(response?.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  Future<void> loadMore({bool animation}) async {
    page += 1;
    final response = await repository.getSubstationAddress(
        searchTerm: searchTerm,
        page: page,
        userGroupId: groupId,
        userTeamId: teamId,
        entityId: substationId.value,
        type: optionType,
        backgroundMode: animation);
    delegate?.loadSuccess();
    if (response.isLoadSuccess) {
      substationAddress.addAll(response.data.locations);
    } else {
      await hShowDialogOneButton(response?.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  void selectItem(SubstationAddress model) {
    final index = substationAddress.indexOf(model);
    substationAddress[index].isExpand = !substationAddress[index].isExpand;
    substationAddress.refresh();
  }

  bool hasFilter() {
    return groupId!=null ||
        teamId != null ||
        substationId.value !=null;
  }
}

