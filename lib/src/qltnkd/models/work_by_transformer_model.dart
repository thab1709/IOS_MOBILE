// @dart=2.9

import 'report_work.dart';

class WorkByTransformerModel {
  WorkByTransformerModel(
      {this.transformerName, this.transformerId, this.mergeModels});

  String transformerName;
  String transformerId;
  List<ReportWorkItem> mergeModels;
}

