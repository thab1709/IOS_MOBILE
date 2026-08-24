// @dart=2.9
import 'package:flutter/cupertino.dart';

class PostResultRequest {
  String substationSituation;
  String solution;
  String dueDate;

  String lineStatus;
  String suggestionSolution;
  String settlementTime;

  PostResultRequest.createRequest(
      {
      @required this.substationSituation,
      @required this.solution,
      @required this.dueDate});


 PostResultRequest.createRequestLine(
      {
      @required this.lineStatus,
      @required this.suggestionSolution,
      @required this.settlementTime});

  Map<dynamic, dynamic> toJson() {
    final maps = <dynamic, dynamic>{};
    maps['substationSituation'] = substationSituation;
    maps['solution'] = solution;
    maps['dueDate'] = dueDate;

    maps['lineStatus'] = lineStatus;
    maps['suggestionSolution'] = suggestionSolution;
    maps['settlementTime'] = settlementTime;

    return maps;
  }
}

