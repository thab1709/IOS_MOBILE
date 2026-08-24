// @dart=2.9
import '../../../../models/option_model.dart';

class WorkloadStatusCode {
  WorkloadStatusCode._();

  static const int all = 0;
  static const int newWork = 1;
  static const int waitConfirm = 2;
  static const int confirmed = 3;
  static const int reject = 4;
  static const listOption = <int>[all, newWork, reject, waitConfirm, confirmed];
}

class RequestStatusCode {
  RequestStatusCode._();

  static const int all = -1;
  static const int news = 0;
  static const int created = 1;
  static const listOption = <int>[
    all,
    news,
    created,
  ];
}

class TicketRequestType {
  TicketRequestType._();

  static const int all = 0;
  static const int accordingProject = 1;
  static const int notAccordingProject = 2;
  static const int measureGroup2 = 3;
  static const int safetyTool = 4;

  static const listOption = <IntOptionModel>[
    IntOptionModel('Tất cả', all),
    IntOptionModel('Theo công trình', accordingProject),
    IntOptionModel('Không theo công trình', notAccordingProject),
    IntOptionModel('Phương tiện đo nhóm 2', measureGroup2),
    IntOptionModel('Dụng cụ an toàn', safetyTool),
  ];

  static String getName(int type) {
    switch (type) {
      case all:
        return listOption[0].title;
      case accordingProject:
        return listOption[1].title;
      case notAccordingProject:
        return listOption[2].title;
      case measureGroup2:
        return listOption[3].title;
      case safetyTool:
        return listOption[4].title;
    }
    return '';
  }
}

