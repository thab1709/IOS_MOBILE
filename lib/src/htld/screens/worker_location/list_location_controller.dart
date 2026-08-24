// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/base/base_delegate.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/option_model.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/subtation_address.dart';
import 'package:evnmobile/src/htld/services/responsitory/location_repository.dart';
import 'package:evnmobile/src/htld/shared_preferences/app_shared.dart';
import 'package:get/get.dart';

class ListLocationController extends GetxController {
  RxList<SubstationAddress> substationAddress = RxList.empty();
  BaseDelegate delegate;
  final repository = LocationRepository();
  String searchTerm = '';
  List<UserOptionModel> units = MAppShared.shared.units
      .map((e) => UserOptionModel(e.name, e.id)).toList();
  final listGroups = MAppShared.shared.groups;
  String unitId = '0';
  String groupId = '0';
  RxList<UserOptionModel> groups = RxList.empty();
  int optionType = 0;
  int page = 1;
  final userProfile = AppShared.instance.getUserProfile();
  final isHasLoadMore = false.obs;

 void setupGroupData(){
   if(userProfile?.unitId != null){
     unitId = userProfile.unitId;

     groups?.assignAll(listGroups
         ?.firstWhere((element) => element?.unitId == unitId, orElse: () => null)
         ?.groups
         ?.map((e) => UserOptionModel(e.name, e.id)) ?? List.empty());
   } else {
     groups.assignAll(listGroups.first.groups
         .map((e) => UserOptionModel(e.name, e.id)));
   }
 }

  void setUnitId(String id){
    unitId = id;
    groups.assignAll(listGroups
        .firstWhere((element) => element.unitId == unitId)
        .groups
        .map((e) => UserOptionModel(e.name, e.id)));
    groupId = '0';
    refresh();
  }

  Future<void> getData({bool animation}) async {

    page = 1;
    final response = await repository.getSubstationAddress(
        searchTerm: searchTerm,
        unitId: unitId,
        groupId: groupId,
        page: page,
        isLine: optionType == 1,
        backgroundMode: animation);
    delegate?.loadSuccess();
    if (response.isLoadSuccess) {
      substationAddress.assignAll(response.data.locations);
    } else {
      await showDialogError(response?.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  Future<void> loadMore({bool animation}) async {
    page += 1;
    final response = await repository.getSubstationAddress(
        searchTerm: searchTerm,
        page: page,
        unitId: unitId,
        groupId: groupId,
        isLine: optionType == 1,
        backgroundMode: animation);
    delegate?.loadSuccess();
    if (response.isLoadSuccess) {
      substationAddress.addAll(response.data.locations);
    } else {
      await showDialogError(response?.message);
    }
    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  void selectItem(SubstationAddress model) {
    final index = substationAddress.indexOf(model);
    substationAddress[index].isExpand = !substationAddress[index].isExpand;
    substationAddress.refresh();
  }
}
