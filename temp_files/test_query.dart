void main() {
  String unitId;
  String equipmentName;
  num pageIndex = 272;
  num pageOffset;
  String orderByDesc;
  bool isPaperFormReport = false;
  
  final param = {
    'UnitId': unitId == '0' ? null : unitId,
    'EquipmentName': equipmentName,
    'IsPaperFormReport': isPaperFormReport.toString(),
    'pageIndex': pageIndex.toString(),
    'orderByDesc': orderByDesc,
    'pageOffset': pageOffset?.toString(),
  };

  Map<String, dynamic> params = param;
  params?.removeWhere((key, value) => value == null || value == '');
  
  final queryString = Uri(queryParameters: params).query;
  print('Query: $queryString');
}
