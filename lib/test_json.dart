import 'dart:convert';
import 'package:g_json/g_json.dart';
import 'package:eonmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:eonmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';

void main() {
  final jsonString = '''{
    "data": {
        "id": "bc58d770-7587-4b35-8642-9df8a43bc4af",
        "code": "BBKS-09",
        "participants": [
            {
                "id": "cbde2818-9a8a-455f-904c-e15d02707fcf",
                "surveyReportId": "bc58d770-7587-4b35-8642-9df8a43bc4af",
                "groupType": 1,
                "sortOrder": 1,
                "unitId": "078234b0-5b0d-467a-a670-52ff93f8c223",
                "unitName": "Công ty Thí nghiệm điện",
                "userId": "4bfc2661-a011-4116-cb12-08d99e913a72",
                "fullName": "Đào Quốc Hướng",
                "position": "Đội trưởng",
                "isSigned": true,
                "signedDate": "2026-06-22T17:48:53.985+07:00"
            }
        ]
    }
}''';
  try {
    final Map<String, dynamic> data = jsonDecode(jsonString);
    final json = JSON(data['data']);
    print('Testing fromJson...');
    final model = SurveyReportModel.fromJson(json);
    print('Participants length: ${model.participants?.length}');
    print('Done successfully');
  } catch (e, stack) {
    print('Exception: $e\n$stack');
  }
}