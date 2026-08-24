// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/htld/models/substation_model.dart';
import 'package:g_json/g_json.dart';

class SubstationResponse{
  SubstationResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => SubstationModel.fromJson(JSON(e)))?.toList();
    }

  }
  List<SubstationModel> list;
  Paging paging;
}
