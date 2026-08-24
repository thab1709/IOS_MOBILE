// @dart=2.9
class QRResultModel {
  QRResultModel({
    this.equipmentName,
    this.fabricationNumber,
    this.equipmentStatus,
    this.id,});

  QRResultModel.fromJson(dynamic json) {
    equipmentName = json['EquipmentName'];
    fabricationNumber = json['FabricationNumber'];
    equipmentStatus = json['EquipmentStatus'];
    id = json['Id'];
  }
  String equipmentName;
  String fabricationNumber;
  int equipmentStatus;
  String id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['EquipmentName'] = equipmentName;
    map['FabricationNumber'] = fabricationNumber;
    map['EquipmentStatus'] = equipmentStatus;
    map['Id'] = id;
    return map;
  }
}
