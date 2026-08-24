import 'package:g_json/g_json.dart';

void main() {
  final rawJsonStr = '{"data":[{"id":"123","name":"Công ty"}]}';
  final data = JSON.parse(rawJsonStr);
  
  final list = JSON(data['data'])?.list;
  for (var e in list) {
    print('e type: ${e.runtimeType}');
    final mapped = JSON(e)['name'].stringValue;
    print('mapped name: $mapped');
  }
}
