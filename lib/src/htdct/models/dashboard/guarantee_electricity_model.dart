// @dart=2.9
class GuaranteeElectricityModel {
  String substationCount;
  String lineCount;
  List<DbdSubstationDetails> dbdSubstationDetails;
  List<DbdLineDetails> dbdLineDetails;

  GuaranteeElectricityModel(
      {this.substationCount,
      this.lineCount,
      this.dbdSubstationDetails,
      this.dbdLineDetails});

  GuaranteeElectricityModel.fromJson(Map<dynamic, dynamic> json) {
    substationCount = json['substationCount'];
    lineCount = json['lineCount'];
    if (json['dbdSubstationDetails'] != null) {
      dbdSubstationDetails = <DbdSubstationDetails>[];
      json['dbdSubstationDetails'].forEach((v) {
        dbdSubstationDetails.add(DbdSubstationDetails.fromJson(v));
      });
    }
    if (json['dbdLineDetails'] != null) {
      dbdLineDetails = <DbdLineDetails>[];
      json['dbdLineDetails'].forEach((v) {
        dbdLineDetails.add(DbdLineDetails.fromJson(v));
      });
    }
  }
}

class DbdSubstationDetails {
  String substationName;
  String mc;
  String mcName;

  DbdSubstationDetails({this.substationName, this.mc, this.mcName});

  DbdSubstationDetails.fromJson(Map<dynamic, dynamic> json) {
    substationName = json['substationName'];
    mc = json['mc'];
    mcName = json['mcName'];
  }
}

class DbdLineDetails {
  String lineName;

  DbdLineDetails({this.lineName});

  DbdLineDetails.fromJson(Map<dynamic, dynamic> json) {
    lineName = json['lineName'];
  }
}

