// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/abnormal_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';
import 'package:evnmobile/src/htdct/models/weirdo_message.dart';
import 'package:get/get.dart';

import '../common/constance/strings.dart';
import '../screens/grid_management/transformer/transformer_ticket_controller.dart';
import 'day_night/popups/images_model.dart';

abstract class BaseHighElectricPopupModel {
  BaseHighElectricPopupModel({this.images, this.equipmentId, this.abnormals});

  List<Images> images;
  String equipmentId;
  String description;
  String title;
  List<WeirdoMessage> unusually = List.empty(growable: true);
  List<Abnormals> abnormals = List.empty(growable: true);

  void setUnusually(WeirdoMessage model) {
    unusually.removeWhere((element) => element.index == model.index);
    if (model?.message?.isNotEmpty == true) {
      model.message = '${model.message}';
      unusually.add(model);
    }
  }

  void setAbnormal(Abnormals model, {bool isSetDescription = false}) {
    abnormals ??= [];
    final item = abnormals
        .where((element) => element.categoryIndex == model.categoryIndex);
    if (item.isNotEmpty) {
      final temp = item.first;
      if (!isSetDescription) {
        temp.abnormalId = model.abnormalId;
        temp.childCategory = model.childCategory;
        temp.parentCategory = model.parentCategory;
        temp.abnormalType = model.abnormalType;
      }
      temp.description = model.description;
    } else if (isSetDescription == false) {
      abnormals.add(model);
    } else if (!model.description.isNullOrEmpty()) {
      abnormals.add(model);
    }
  }

  void removeAbnormal({int categoryIndex}) {
    abnormals ??= [];
    final item =
        abnormals.where((element) => element.categoryIndex == categoryIndex);
    if (item.isNotEmpty) {
      final temp = item.first;
      if (temp.id.isNullOrEmpty()) {
        abnormals
            .removeWhere((element) => element.categoryIndex == categoryIndex);
      } else {
        temp.abnormalId = null;
        temp.description = null;
      }
    }
  }

  Abnormals getAbnormal(int categoryIndex) {
    abnormals ??= [];
    final item =
        abnormals.where((element) => element.categoryIndex == categoryIndex);
    if (item.isNotEmpty) {
      return item.first;
    }
    return Abnormals();
  }

  String getDescription() {
    final transformerTicketController = Get.put(TransformerTicketController());
    var nodeName = '';
    if (transformerTicketController.testType == TestType.line &&
        transformerTicketController.ticketType == TicketType.periodicMonth &&
        !transformerTicketController.nodeName.isNullOrEmpty()) {
      nodeName = '- ${transformerTicketController.nodeName} ';
    }

    final time =
        DateTime.now().toStringFormat(HighElectricStrings.HHmmssyyyyMMdd);
    final allUnusually = unusually
        .map((e) => '$title $nodeName- ${e.message} $time\n\n')
        .join('');
    if (allUnusually.trim().isEmpty == true) {
      return '';
    } else {
      return '$allUnusually';
    }
  }

  bool validateData();

  void fromJson(Map<dynamic, dynamic> json) {}

  void autoGenAbnormalType() {}
}

