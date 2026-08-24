// @dart=2.9
import 'package:g_json/g_json.dart';
import '../../../models/non_pmis/template_item_model.dart';
import '../../../models/option_model.dart';
import '../../../models/work_model.dart';

class TemplateResponse {
  TemplateResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['fieldDetailModels'].listObject;
      list = data?.map((e) => TemplateItemModel.fromJson(JSON(e)))?.toList();
    }
  }
  List<TemplateItemModel> list;
}


class StringOptionsResponse {
  StringOptionsResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => OptionModelString(e['name'],e['id']))?.toList();
    }
  }
  List<OptionModelString> list;
}
class StringMoreOptionsResponse {
  StringMoreOptionsResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      list = data?.map((e) => OptionModelString(e['name'],e['id']))?.toList();
      paging = Paging.fromJson(json['paging']);
    }
  }
  List<OptionModelString> list;
  Paging paging;
}


