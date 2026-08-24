// @dart=2.9
import 'package:evnmobile/src/htld/models/inspection_model.dart';
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/htld/services/server_response.dart';
import 'package:g_json/g_json.dart';

class InspectionResponse extends ServerResponse{
  InspectionResponse.fromJson(JSON json) : super.fromJson(json){
    if(json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      list = data?.map((e) => InspectionModel.fromJSON(JSON(e)))?.toList();
    }
  }
  List<InspectionModel> list;
  Paging paging;
}
