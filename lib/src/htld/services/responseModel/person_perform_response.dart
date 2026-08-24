// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../models/person_performing_model.dart';
import '../server_response.dart';

class PersonPerformResponse extends ServerResponse {
  PersonPerformResponse.fromJson(JSON json) : super.fromJson(json) {
    final data = json['data']?.list;

    persons = data?.map((e) => PersonPerformingModel.fromJson(e))?.toList();
  }

  List<PersonPerformingModel> persons;
}

