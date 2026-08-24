// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:g_json/g_json.dart';

class ReportWork {
  String date;
  String dayOfWeek;
  List<ReportWorkItem> items;
  int count;

  ReportWork({this.date, this.dayOfWeek, this.items, this.count});

  ReportWork.fromJson(JSON json) {
    date = json['date'].string;
    dayOfWeek = json['dayOfWeek'].string;
    if (json['items'] != null) {
      items = [];
      json['items']?.list?.forEach((v) {
        items.add(ReportWorkItem.fromJson(v));
      });
    }
    count = json['count'].integer;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['dayOfWeek'] = dayOfWeek;
    if (items != null) {
      map['items'] = items.map((v) => v.toJson()).toList();
    }
    map['count'] = count;
    return map;
  }
}

class ReportWorkItem {
  String id;
  int workProgressType;
  List<ListFormReport> formReports;
  String formReportId;
  String fromDate;
  String toDate;
  String location;
  String substationId;
  String unitRequest;
  String equipmentName;
  String equipmentTypeName;
  String reportNumber;
  String reportType;
  String stampNumber;
  int workProgress;
  String workProgressName;
  List<UserImp> userImps;
  List<Contact> contacts;
  String updatedBy;
  String updater;
  String updatedDate;
  String formId;
  String workTypeName;
  String workType;
  String driver;
  String departureTime;
  String latitude;
  String longitude;
  String equipmentDetailName;
  int periodicType;
  bool isMonitor;
  bool isAllowToCreateReport;
  bool isConfirmComplete;
  bool isMeter;
  bool isPaperReport;
  bool isAllowUpdatePaperFormReport;

  String equipmentTypeId;
  String equipmentDetailId;
  DateTime clonedDate;

  ReportWorkItem(
      {this.id,
      this.workProgressType,
      this.formReportId,
      this.fromDate,
      this.periodicType,
      this.toDate,
      this.location,
      this.unitRequest,
      this.equipmentName,
      this.equipmentTypeName,
      this.reportNumber,
      this.contacts,
      this.reportType,
      this.stampNumber,
      this.workProgress,
      this.userImps,
      this.updatedBy,
      this.driver,
      this.isAllowToCreateReport,
      this.latitude,
      this.longitude,
      this.updater,
      this.equipmentDetailName,
      this.departureTime,
      this.formId,
      this.isMonitor,
      this.isConfirmComplete,
      this.isMeter,
      this.equipmentDetailId,
      this.equipmentTypeId,
      this.updatedDate});

  ReportWorkItem.fromJson(JSON json) {
    id = json['id'].string;

    json['formReports']?.listObject?.map((v) {
      ListFormReport.fromJson(JSON(v));
    })?.toList();

    formReportId = json['formReportId'].string;
    fromDate = json['fromDate'].string ?? json['startDate'].string;
    driver = json['driver'].string;
    departureTime = json['departureTime'].string;
    workProgressType = json['workProgressType'].integer;
    toDate = json['toDate'].string ?? json['endDate'].string;
    isMonitor = json['isX5Monitoring'].boolean;
    workTypeName = json['workTypeName'].string;
    location = json['location'].string;
    substationId = json['substationId'].string;
    periodicType = json['periodicType'].integer;
    workProgressName = json['workProgressName'].string;
    unitRequest = json['unitRequest'].string;
    equipmentName = json['equipmentName'].string;
    latitude = json['latitude'].string;
    longitude = json['longitude'].string;
    isAllowToCreateReport = json['isAllowToCreateReport'].boolean;
    formReports = json['formReports']
        ?.listObject
        ?.map((e) => ListFormReport.fromJson(JSON(e)))
        ?.toList();
    equipmentTypeName = json['equipmentTypeName'].string;
    reportNumber = json['reportNumber'].string;
    reportType = json['reportType'].string ?? json['reportType'].integer?.toString();
    stampNumber = json['stampNumber'].string;
    equipmentTypeId = json['equipmentTypeId'].string;
    equipmentDetailId = json['equipmentDetailId'].string;
    workProgress = json['workProgress'].integer;
    userImps = json['userImps']
        ?.listObject
        ?.map((e) => UserImp.fromJson(JSON(e)))
        ?.toList();
    contacts = json['contact']
        ?.listObject
        ?.map((e) => Contact.fromJson(JSON(e)))
        ?.toList();
    updatedBy = json['updatedBy'].string;
    updater = json['updater'].string;
    updatedDate = json['updatedDate'].string;
    formId = json['formId'].string;
    workType = json['workType'].string ?? json['workType'].integer?.toString();
    equipmentDetailName = json['equipmentDetailName'].string;
    isConfirmComplete = json['isConfirmComplete'].boolean;
    isPaperReport = json['isPaperFormReport'].boolean;
    isAllowUpdatePaperFormReport = json['isAllowUpdatePaperFormReport'].boolean;
    isMeter = json['isMeter'].boolean;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    if (formReports != null) {
      map['formReports'] = formReports?.map((v) => v.toJson())?.toList();
    }
    map['fromDate'] = fromDate;
    map['toDate'] = toDate;
    map['location'] = location;
    map['driver'] = driver;
    map['isX5Monitoring'] = isMonitor;
    map['departureTime'] = departureTime;
    map['unitRequest'] = unitRequest;
    map['equipmentName'] = equipmentName;
    map['equipmentTypeName'] = equipmentTypeName;
    map['reportNumber'] = reportNumber;
    map['reportType'] = reportType;
    map['stampNumber'] = stampNumber;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['substationId'] = substationId;
    map['workTypeName'] = workTypeName;
    map['workProgressName'] = workProgressName;
    map['workProgress'] = workProgress;
    map['equipmentDetailName'] = equipmentDetailName;
    map['equipmentTypeId'] = equipmentTypeId;
    map['isConfirmComplete'] = isConfirmComplete;
    map['isMeter'] = isMeter;
    map['isPaperFormReport'] = isPaperReport;
    map['equipmentDetailId'] = equipmentDetailId;
    if (userImps != null) {
      map['userImps'] = userImps.map((v) => v.toJson()).toList();
    }
    map['contact'] = contacts?.map((e) => e.toJson())?.toList();
    map['updatedBy'] = updatedBy;
    map['updater'] = updater;
    map['updatedDate'] = updatedDate;
    map['formId'] = formId;
    map['isAllowToCreateReport'] = isAllowToCreateReport;
    map['isAllowUpdatePaperFormReport'] = isAllowUpdatePaperFormReport;
    map['workType'] = workType;
    return map;
  }

  String get isX5MonitoringString => isMonitor == true ? 'Có' : 'Không';

  String getListNameUserImp() {
    return userImps?.map((e) => e.name)?.join(' ,') ?? '';
  }

  String getPeriodicTypedName() {
    switch (periodicType) {
      case 1:
        return 'Lần đầu';
        break;
      case 2:
        return 'Định kỳ';
        break;
      case 3:
        return 'Bất thường';
        break;
    }

    return '';
  }

  String getContacts() {
    return contacts
        ?.map((e) =>
            '${e.getTypeName()}-${e?.name ?? ''}-${e?.phone?.trim() ?? ''}')
        ?.join(', ');
  }

  String getTime() {
    return '${fromDate?.fromFormatUtcToFormatLocal(RAppStrings.HHmm) ?? ''} - ${toDate?.fromFormatUtcToFormatLocal(RAppStrings.HHmm) ?? ''}';
  }

  String getFromDateToDate() {
    return '${fromDate?.fromFormatUtcToFormatLocal(RAppStrings.ddmmyyyyHHmm) ?? ''} - ${toDate?.fromFormatUtcToFormatLocal(RAppStrings.ddmmyyyyHHmm) ?? ''}';
  }

  bool isFromDateToDate() {
    return fromDate?.toDateFormatLocal()?.weekday !=
        toDate?.toDateFormatLocal()?.weekday;
  }

  String getDepartureTime() {
    return '${departureTime?.fromFormatUtcToFormatLocal(RAppStrings.HHmm) ?? ''}';
  }

  String getDate() {
    return '${toDate?.fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy) ?? ''}';
  }
}

class ListFormReport {
  String formReportId;
  String formReportNumber;
  String formId;
  String formName;
  String content;
  int reportType;

  ListFormReport({this.formReportId, this.formReportNumber});

  ListFormReport.fromJson(JSON json) {
    formReportId = json['formReportId'].string;
    formId = json['formId'].string;
    formName = json['formName'].string;
    reportType = json['reportType'].integer;
    formReportNumber = json['formReportNumber'].string;
    content = json['content'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formReportId'] = formReportId;
    map['formReportNumber'] = formReportNumber;
    map['formId'] = formId;
    map['formName'] = formName;
    map['reportType'] = reportType;
    map['content'] = content;
    return map;
  }

  String getTitleReportButton() {
    if (formReportId == null) {
      return 'Tạo biên bản ${formName ?? ''}';
    } else {
      return 'Xem Chi tiết biên bản ${formName ?? ''}';
    }
  }
}

class UserImp {
  String id;
  String name;
  bool isUserCreated;

  UserImp({this.id, this.name});

  UserImp.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    isUserCreated = json['isUserCreated']?.boolean ?? false;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['isUserCreated'] = isUserCreated;
    return map;
  }
}

class Contact {
  int type;
  String name;
  String phone;

  Contact({this.type, this.name});

  Contact.fromJson(JSON json) {
    type = json['type'].integer;
    name = json['name'].string;
    phone = json['phone'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = type;
    map['name'] = name;
    map['phone'] = phone;
    return map;
  }

  String getTypeName() {
    switch (type) {
      case 1:
        return 'Liên hệ đặt làm';
        break;
      case 2:
        return 'Liên hệ cấp phiếu';
        break;
      case 3:
        return 'Liên hệ chỉ dẫn';
        break;
    }

    return '';
  }
}

