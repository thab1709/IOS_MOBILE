// @dart=2.9
import 'package:g_json/g_json.dart';

class ServerResponse<T> {
  ServerResponse({this.message  = 'Có lỗi xảy ra vui lòng liên hệ admin.', this.statusCode = -1, this.data});
  ServerResponse.fromJson(JSON json) {
    if (json?.value != null) {
      message = json['message'] != null ? json['message']?.string : 'Đã xảy ra lỗi';
      statusCode = json['statusCode'] != null ? json['statusCode']?.integer : 0;
    }
  }

  Map<String, dynamic> toJson(){
    final map = <String, dynamic>{};
    map['message'] = message;
    map['data'] = data;
    map['statusCode'] = statusCode;
    return map;
  }

  String message;
  int statusCode;
  T data;

  bool get isLoadSuccess => statusCode == 200;


 // ignore: use_setters_to_change_properties
 void setData(T data){
    this.data = data;
  }

}

