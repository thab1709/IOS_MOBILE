// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tiengviet/tiengviet.dart';

import '../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../models/abnormal/abnormal_history_model.dart';
import '../../../../../services/responsitory/abnormal_repository.dart';


class HistoryController extends GetxController {

  RxList<TAbnormalHistoryModel> listAbnormal = RxList.empty();
  List<TAbnormalHistoryModel> listAbnormalOriginal = List.empty(growable: true);
  final _abnormalRep = TAbnormalRepository();
  final searchController = TextEditingController()..text = '';
  String searchTerm = '';

  Future getDetail(String id) async
  {
    final res = await _abnormalRep.getAbnormalHistory(id: id);
    if (res.isLoadSuccess) {
      listAbnormalOriginal.addAll(res.data.list);
      listAbnormal.addAll(res.data.list);
      listAbnormal.refresh();
    } else {
      await showDialogOneButton(res.message);
    }
  }

  List<TAbnormalHistoryModel> find()
  {
    if(listAbnormalOriginal!=null)
      {
        listAbnormal.value = listAbnormalOriginal.where((element) => TiengViet.parse(element.updatedUser.toLowerCase()).contains(searchTerm==null?'':searchTerm.trim())).toList();
        listAbnormal.refresh();
      }
    return [];
  }

}
