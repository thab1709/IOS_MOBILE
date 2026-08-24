// @dart=2.9
import 'package:evnmobile/src/htld/models/problem_positions_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_line_drop_down.dart';
import 'package:g_json/g_json.dart';
import 'package:get/get.dart';

import 'attach_image_model.dart';
import 'equipment_model.dart';
import 'weirdo_message.dart';

class ErrorModel {
  int index;
  String message;
  String problemName;
  int problemValue;

  ErrorModel(this.index, this.message, this.problemName, this.problemValue);
}

class TAbnormal {
  String id;
  String abnormalId;
  String description;
  int categoryIndex;
  String parentCategory;
  String nodeIds;
  String childCategory;
  int optionCategory;

  TAbnormal({
    this.id,
    this.abnormalId,
    this.description,
    this.categoryIndex,
    this.parentCategory,
    this.nodeIds,
    this.childCategory,
    this.optionCategory,
  });

  factory TAbnormal.fromJson(JSON json) {
    return TAbnormal(
      id: json['id'].string,
      abnormalId: json['abnormalId'].string,
      description: json['description'].string,
      categoryIndex: json['categoryIndex'].integer,
      optionCategory: json['optionCategory'].integer,
      parentCategory: json['parentCategory'].string,
      childCategory: json['childCategory'].string,
      nodeIds: json['nodeIds'].string,
    );
  }

  Map<String, dynamic> toJson() {
    final maps = <String, dynamic>{};
    maps['id'] = id;
    maps['abnormalId'] = abnormalId;
    maps['description'] = description;
    maps['categoryIndex'] = categoryIndex;
    maps['parentCategory'] = parentCategory;
    maps['childCategory'] = childCategory;
    maps['optionCategory'] = optionCategory;
    maps['nodeIds'] = nodeIds;
    if (optionCategory != null && (nodeIds == null || nodeIds.isEmpty)) {
      maps['abnormalId'] = null;
    }
    return maps;
  }
}

abstract class PopupBaseModel {
  String descriptionMultiSubstation = '';
  String descriptionAreaSubstation = '';
  String descriptionSubstation = '';
  String description = '';
  String title;
  bool isUpdateOffline;
  RxBool isCreated = false.obs;
  String specificPhenomena;
  String suggestedHandlingOfAbnormal;
  List<Images> images;
  List<WeirdoMessage> unusually = List.empty(growable: true);
  LineWeirdoMessage lineUnusuallyModel = LineWeirdoMessage(0);
  LineWeirdoMessage lineAreaUnusuallyModel = LineWeirdoMessage(0);
  List<ProblemPositions> problemPositions = List.empty(growable: true);
  List<ErrorModel> errorModels = List.empty(growable: true);
  List<TAbnormal> abnormals = [];

  void clearAllProblem() {
    unusually = List.empty(growable: true);
    lineUnusuallyModel = LineWeirdoMessage(0);
    lineAreaUnusuallyModel = LineWeirdoMessage(0);
    problemPositions = List.empty(growable: true);
    errorModels = List.empty(growable: true);
    abnormals?.forEach((element) {
      element.abnormalId = null;
      element.nodeIds = null;
    });
    images = [];
    descriptionMultiSubstation = '';
    descriptionAreaSubstation = '';
    descriptionSubstation = '';
    description = '';
  }

  String getSuggestedHandlingOfAbnormal() {
    return suggestedHandlingOfAbnormal ??= 'Không';
  }

  String getSpecificPhenomena() {
    return specificPhenomena ??= 'Không';
  }

  /// Lấy problemValue theo fieldValue, nếu chưa có thì tạo mới với defaultValue
  int getProblemValue(int fieldValue, int defaultValue) {
    problemPositions ??= [];
    var pos = problemPositions.firstWhere(
      (e) => e.fieldValue == fieldValue,
      orElse: () => null,
    );
    if (pos == null) {
      pos =
          ProblemPositions(fieldValue: fieldValue, problemValue: defaultValue);
      problemPositions.add(pos);
    } else {
      pos.problemValue ??= defaultValue;
    }
    return pos.problemValue;
  }

  PopupBaseModel(
      {List<WeirdoMessage> unusually,
      List<Images> images,
      String specificPhenomena,
      String suggestedHandlingOfAbnormal}) {
    specificPhenomena = specificPhenomena;
    suggestedHandlingOfAbnormal = suggestedHandlingOfAbnormal;
    unusually = unusually;
    images = images;
  }

  void setUnusually(WeirdoMessage model) {
    unusually.removeWhere((element) => element.index == model.index);
    if (model?.message?.isNotEmpty == true) {
      model.message = '${model.message}';
      unusually.add(model);
    }

    final allUnusually = unusually.map((e) => '   + ${e.message}').join(',\n');
    if (allUnusually.trim().isEmpty == true) {
      descriptionSubstation = '';
    } else {
      descriptionSubstation = '- $title: \n$allUnusually \n';
    }

    description = descriptionSubstation +
        descriptionMultiSubstation +
        descriptionAreaSubstation;
  }

  void setLineUnusually(
      LineWeirdoMessage model, List<OptionData> listOptionData) {
    if (model?.message?.isNotEmpty == true) {
      errorModels.removeWhere((element) =>
          element.index == model.index &&
          element.problemValue == model.optionValue);

      final allProblem = listOptionData.map((optionData) {
        if (model.optionValue == optionData.optionModel.value) {
          final nodes = optionData.listEquipment
                  .where((element) => element.isChecked == true)
                  ?.toList() ??
              List.empty();
          var allPosition = nodes.map((e) => e.name).join(', ');
          if (allPosition == ', ') {
            allPosition = '';
          }
          final message =
              '   + ${optionData.optionModel.title}: $allPosition\n';
          return message;
        } else {
          return '';
        }
      }).join('');

      errorModels.add(ErrorModel(
          model.index, allProblem, model.problem, model.optionValue));
    } else {
      errorModels.removeWhere((element) => element.index == model.index);
    }

    final messageProblem =
        '${errorModels.map((e) => ' ${e.problemName}:\n${e.message}').toList().join('\n')}';

    if (messageProblem?.isEmpty == true) {
      descriptionMultiSubstation = '';
    } else {
      lineUnusuallyModel.message = '- $title:\n$messageProblem';
      descriptionMultiSubstation = '${lineUnusuallyModel.message}\n';
    }

    description = descriptionSubstation +
        descriptionMultiSubstation +
        descriptionAreaSubstation;
  }

  void setLineAreaUnusually(
      LineWeirdoMessage model, List<OptionData> listOptionData) {
    if (model.index == null) {
      return;
    }

    if (model?.message?.isNotEmpty == true) {
      errorModels.removeWhere((element) =>
          element.index == model.index &&
          element.problemValue == model.optionValue);

      final allProblem = listOptionData.map((optionData) {
        final nodes = optionData.listEquipment
                .where((element) => element.isChecked == true)
                ?.toList() ??
            List.empty();
        if (nodes.isEmpty) {
          return '';
        }

        final listListSelected = <List<EquipmentModel>>[];

        nodes.forEach((element) {
          final singleSelected = listListSelected.firstWhere(
              (v) => v.isNotEmpty && v[0]?.groupId == element.groupId,
              orElse: () => null);

          if (singleSelected == null) {
            listListSelected.add([element]);
          } else {
            singleSelected.add(element);
          }
        });

        final allPosition = listListSelected
            .map((e) => '[${e.map((e) => e.name).join(', ')}]')
            .join(', ');

        if (allPosition.trim() == '' || allPosition == ', ') {
          return '';
        }

        final message = '   + ${optionData.optionModel.title}: $allPosition\n';
        return message;
      }).join('');

      errorModels.add(ErrorModel(
          model.index, allProblem, model.problem, model.optionValue));
    } else {
      errorModels.removeWhere((element) => element.index == model.index);
    }

    final messageProblem =
        '${errorModels.map((e) => ' ${e.problemName}:\n${e.message}').toList().join('')}';

    if (messageProblem?.isEmpty == true) {
      descriptionAreaSubstation = '';
    } else {
      lineAreaUnusuallyModel.message = '- $title:\n$messageProblem';

      descriptionAreaSubstation = '${lineAreaUnusuallyModel.message}\n';
    }

    description = descriptionSubstation +
        descriptionMultiSubstation +
        descriptionAreaSubstation;
  }

  TAbnormal getAbnormal(int categoryIndex) {
    abnormals ??= [];
    final item =
        abnormals.where((element) => element.categoryIndex == categoryIndex);
    if (item?.isNotEmpty == true) {
      return item.first;
    }
    return TAbnormal();
  }

  void setImages(List<Images> newImages, int index) {
    if (images != null) {
      images.removeWhere((element) => element.problems == index);
      newImages.forEach((element) {
        element.problems = index;
      });
      images.addAll(newImages);
      images = images.toSet().toList();
    } else {
      images = [];
      newImages.forEach((element) {
        element.problems = index;
      });
      images.addAll(newImages);
      images = images.toSet().toList();
    }
  }

  void setProblemPositions(
      LineWeirdoMessage model, OptionData optionData, int index,
      {bool isAbnormal = false}) {
    problemPositions ??= [];
    if (model.message?.isNotEmpty == true) {
      problemPositions?.removeWhere((element) =>
          element.fieldValue == index &&
          element.problemValue == optionData.optionModel.value);
    } else {
      problemPositions?.removeWhere((element) => element.fieldValue == index);
    }

    final allEquipment = optionData?.listEquipment
            ?.where((element) => element.isChecked == true)
            ?.toList() ??
        List.empty();

    if (allEquipment.isEmpty) {
      problemPositions?.add(ProblemPositions(
          fieldValue: index,
          problemValue: optionData?.optionModel?.value,
          title: optionData?.title,
          positionId: null,
          isAbnormal: isAbnormal));
    } else {
      problemPositions?.addAll(allEquipment
          ?.map((e) => ProblemPositions(
              fieldValue: index,
              title: optionData?.title,
              problemValue: optionData?.optionModel?.value,
              positionId: e.id,
              groupId: e.groupId,
              isAbnormal: isAbnormal))
          ?.toList());
    }
    if (problemPositions != null) {
      setNodesAbnormalLine(optionData, index);
    }
  }

  void setNodesAbnormalLine(OptionData optionData, int index) {
    abnormals?.forEach((element) {
      if (element.abnormalId != null && index == element.categoryIndex) {
        element.nodeIds = problemPositions
            ?.where((e) =>
                e.problemValue == optionData.optionModel.value &&
                e.fieldValue == index &&
                e.positionId != null)
            ?.map((i) => i.positionId)
            ?.join(',');
      }
    });
  }

  bool validateData();
}

