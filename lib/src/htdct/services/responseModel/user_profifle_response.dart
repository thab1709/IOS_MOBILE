// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../models/profile_model.dart';
import '../server_response.dart';

class UserProfileResponse extends ServerResponse {
  UserProfileResponse.fromJson(JSON json) : super.fromJson(json) {
    userProfile = UserProfileModel.fromJson(json['data']);
  }

  UserProfileModel userProfile;
}

