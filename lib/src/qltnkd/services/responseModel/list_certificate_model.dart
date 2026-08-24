// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/certificate_model.dart';
import 'package:g_json/g_json.dart';

class ListCertificateResponse{
  List<CertificateModel> listCertificate;
  Paging paging;
  ListCertificateResponse.fromJson(JSON json){
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      listCertificate = data?.map((e) => CertificateModel.fromJson(JSON(e)))?.toList();
    }
  }
}
