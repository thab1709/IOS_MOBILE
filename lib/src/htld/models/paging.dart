// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:g_json/g_json.dart';

class Paging {
  Paging({@required this.totalCount,
    @required this.pageIndex,
    @required this.pageSize,
    @required this.totalPages});

  factory Paging.fromJson(JSON json){
    return Paging(totalCount: json['totalCount'].integer,
        pageIndex: json['pageIndex'].integer,
        pageSize: json['pageSize'].integer,
        totalPages: json['totalPages'].integer);
  }

  num totalCount;
  num pageIndex;
  num pageSize;
  num totalPages;


  bool isHasLoadMore () {
    if (pageIndex != null && totalPages != null) {
      return pageIndex < totalPages;
    }

    return false;
  }
}

