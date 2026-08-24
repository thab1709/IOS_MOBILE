// @dart=2.9
import 'package:g_json/g_json.dart';

class AbnormalRaw {
  String id;
  int category;
  String name;
  String description;

  AbnormalRaw({
    this.id,
    this.category,
    this.name,
    this.description,
  });

  AbnormalRaw.fromJson(JSON json) {
    id = json['id'].string;
    category = json['category'].integer;
    name = json['name'].string;
    description = json['description'].string;
  }
}

