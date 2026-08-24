import 'package:g_json/g_json.dart';

void main() {
  final rawJsonStr = '{"id":"123","name":"Công ty"}';
  final data = JSON.parse(rawJsonStr);
  
  final fullName = data['fullName'].stringValue;
  print('fullName is: "$fullName"');
  
  final name = data['name'].stringValue;
  print('name is: "$name"');
  
  final mapped = (data['fullName'].stringValue != '') ? data['fullName'].stringValue : data['name'].stringValue;
  print('mapped is: "$mapped"');
}
