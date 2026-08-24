// @dart=2.9
import 'package:evnmobile/src/htld/models/paging.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:g_json/g_json.dart';

class ReportWorkResponse {
  ReportWorkResponse.fromJson(JSON json) {
    if (json != null) {
      final data = json['data'].listObject;
      paging = Paging.fromJson(json['paging']);
      if (data != null && data.isNotEmpty) {
        if (data.first['items'] != null) {
          _listDayWork = data.map((e) => ReportWork.fromJson(JSON(e))).toList();
          _listDayWork?.forEach((element) {
            if (element.items != null) {
              list.addAll(element.items);
            }
          });
        } else {
          list = [];
          for (var e in data) {
            final item = ReportWorkItem.fromJson(JSON(e));
            if (item.fromDate != null && item.toDate != null) {
              try {
                DateTime start = DateTime.parse(item.fromDate).toLocal();
                DateTime end = DateTime.parse(item.toDate).toLocal();
                
                DateTime current = DateTime(start.year, start.month, start.day);
                DateTime endDate = DateTime(end.year, end.month, end.day);
                
                if (current.isBefore(endDate)) {
                  while (current.compareTo(endDate) <= 0) {
                    final clone = ReportWorkItem.fromJson(JSON(e));
                    clone.clonedDate = current;
                    list.add(clone);
                    current = current.add(const Duration(days: 1));
                  }
                } else {
                  list.add(item);
                }
              } catch (ex) {
                list.add(item);
              }
            } else {
              list.add(item);
            }
          }
        }
      }
    }
  }
  List<ReportWorkItem> list = <ReportWorkItem>[];
  List<ReportWork> _listDayWork;
  Paging paging;
}

