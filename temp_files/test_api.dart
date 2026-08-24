import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

void main() async {
  final loginUrl = Uri.parse('https://appqthtuat.evnhanoi.com.vn/tnkd/api/user/login');
  final loginBody = jsonEncode({
    'username': 'linhbt',
    'password': 'Evn@123456',
    'timezoneOffset': -420,
    'rememberMe': true,
    'firebaseRegistrationKey': ''
  });

  final loginResponse = await http.post(
    loginUrl,
    headers: {'Content-Type': 'application/json'},
    body: loginBody,
  );

  final token = jsonDecode(loginResponse.body)['data']['accessToken'];

  final copyUrl = Uri.parse('https://appqthtuat.evnhanoi.com.vn/tnkd/api/formreport/copy-formreport');
  final copyBody = jsonEncode({
    'formReportId': '24fd66f4-0571-4241-a7e7-8ac002d12dde',
    'scheduleId': 'ba6d585e-b0e5-4549-a503-53c5084b5b39',
    'equipmentTypeId': 'd5166150-fb94-43c7-81c2-f299908a25b4',
    'equipmentDetailId': '13c79fd6-5e19-4fac-a06d-2d6613ff9c5c'
  });

  print('Sending: \$copyBody');

  final copyResponse = await http.post(
    copyUrl,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer \$token'
    },
    body: copyBody,
  );

  print('Status code: \${copyResponse.statusCode}');
  print('Response body: \${copyResponse.body}');
}
