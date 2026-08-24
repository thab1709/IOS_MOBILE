// @dart=2.9
import 'package:g_json/g_json.dart';

import '../../day_night/popups/images_model.dart';

class ViolateModel {
  String id;
  int typeViolation;
  String nameViolate;
  String constructionStatus;
  String latitude;
  String longitude;
  String name;
  String violateId;

  //Vi phạm hành lang
  String codePointViolate;// mã điểm vi phạm
  String namePointViolate;// Tên điểm vi phạm
  String subjectViolate;// Đối tượng vi phạm
  String aboutColumn;// Khoảng cột
  String address;// Địa chỉ
  String timeViolate;// Thời điểm vi phạm
  String endViolate;// Thời điểm kết thúc
  int standingDistance;// Khoảng cách đứng
  int horizontalDistance;// Khoảng cách ngang
  String statusViolate;// Tình trạng vi phạm +_ tình trạng xây dựng
  String constructionProperties;// Tính chất công trình
  String solution;// Giải pháp thực hiện
  int trackingStatus;// Tình trạng theo dõix

  //Công trường thi công
  String constructionName;// Ten cong truong
  String investor;// Chu dau tu
  String constructionUnit;// Đơn vị đặt làm
  String note;// Ghi chú

  //Cây hành lang
  String treeType;// Loại cây
  String height;// Chiều cao
  String location;// Vi trí so với hành lang
  String distanceNearest;// khoảng cách gần nhất
  List<Images> images = [];

  ViolateModel(
      {this.id,
        this.typeViolation,
        this.nameViolate,
        this.constructionStatus,
        this.codePointViolate,
        this.namePointViolate,
        this.subjectViolate,
        this.aboutColumn,
        this.address,
        this.timeViolate,
        this.endViolate,
        this.standingDistance,
        this.horizontalDistance,
        this.statusViolate,
        this.constructionProperties,
        this.solution,
        this.trackingStatus,
        this.constructionName,
        this.investor,
        this.constructionUnit,
        this.note,
        this.treeType,
        this.height,
        this.location,
        this.distanceNearest,
        this.images,
      this.latitude,
      this.longitude,
      this.name,
      this.violateId});

  ViolateModel.fromJson(JSON json) {
    id = json['id'].string;
    typeViolation = json['typeViolation'].integer;
    nameViolate = json['nameViolate'].string;
    constructionStatus = json['constructionStatus'].string;
    codePointViolate = json['codePointViolate'].string;
    namePointViolate = json['namePointViolate'].string;
    subjectViolate = json['subjectViolate'].string;
    aboutColumn = json['aboutColumn'].string;
    address = json['address'].string;
    timeViolate = json['timeViolate'].string;
    endViolate = json['endViolate'].string;
    standingDistance = json['standingDistance'].integer;
    horizontalDistance = json['horizontalDistance'].integer;
    statusViolate = json['statusViolate'].string;
    constructionProperties = json['constructionProperties'].string;
    solution = json['solution'].string;
    trackingStatus = json['trackingStatus'].integer;
    constructionName = json['constructionName'].string;
    investor = json['investor'].string;
    constructionUnit = json['constructionUnit'].string;
    note = json['note'].string;
    treeType = json['treeType'].string;
    height = json['height'].string;
    location = json['location'].string;
    distanceNearest = json['distanceNearest'].string;
    if (json['images'] != null) {
      images = json['images']?.listObject?.map((e) => Images.fromJsonNotMap(JSON(e)))?.toList();
    }
    else {
      images = [];
    }
    latitude = json['latitude'].string;
    longitude = json['longitude'].string;
    name = json['name'].string;
    violateId = json['violateId'].string;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['typeViolation'] = typeViolation;
    data['nameViolate'] = nameViolate;
    data['constructionStatus'] = constructionStatus;
    data['codePointViolate'] = codePointViolate;
    data['namePointViolate'] = namePointViolate;
    data['subjectViolate'] = subjectViolate;
    data['aboutColumn'] = aboutColumn;
    data['address'] = address;
    data['timeViolate'] = timeViolate;
    data['endViolate'] = endViolate;
    data['standingDistance'] = standingDistance;
    data['horizontalDistance'] = horizontalDistance;
    data['statusViolate'] = statusViolate;
    data['constructionProperties'] = constructionProperties;
    data['solution'] = solution;
    data['trackingStatus'] = trackingStatus;
    data['constructionName'] = constructionName;
    data['investor'] = investor;
    data['constructionUnit'] = constructionUnit;
    data['note'] = note;
    data['treeType'] = treeType;
    data['height'] = height;
    data['location'] = location;
    data['distanceNearest'] = distanceNearest;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    } else {
      images = [];
    }
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['name'] = name;
    data['violateId'] = violateId;
    return data;
  }

}

