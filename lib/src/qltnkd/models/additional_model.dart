// @dart=2.9
import 'package:g_json/g_json.dart';

import 'option_model.dart';

class AdditionalData {
  AdditionalData({this.options});

  factory AdditionalData.fromJSON(JSON json) {
    final optionsJson = json['listOptions'].list;
    if (optionsJson != null) {
      final options =
          optionsJson?.map((e) => StringOptionModel.fromJSON(e))?.toList();
      return AdditionalData(options: options);
    }
    return AdditionalData();
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (options != null) {
      map['listOptions'] = options.map((v) => v.toJson()).toList();
    }
    return map;
  }

  List<StringOptionModel> options;
}

