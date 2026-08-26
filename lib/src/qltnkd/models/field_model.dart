import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_controller.dart';
import 'package:get/get.dart';
// @dart=2.9
import 'dart:async';
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/operator.dart';
import 'package:evnmobile/src/qltnkd/models/image_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/table_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:g_json/g_json.dart';

import 'additional_model.dart';

class StyleModel {
  StyleModel({
    this.alignItems,
    this.backgroundColor,
  });

  StyleModel.fromJSON(JSON json) {
    alignItems = json['alignItems'].string;
    backgroundColor = json['backgroundColor'].string;
    color = json['color'].string;

    borderColor = json['borderColor'].string;

    borderLeftWidth = json['borderLeftWidth'].string;
    borderLeftColor = json['borderLeftColor'].string;
    borderLeftStyle = json['borderLeftStyle'].string;

    borderTopWidth = json['borderTopWidth'].string;
    borderTopColor = json['borderTopColor'].string;
    borderTopStyle = json['borderTopStyle'].string;

    borderBottomWidth = json['borderBottomWidth'].string;
    borderBottomColor = json['borderBottomColor'].string;
    borderBottomStyle = json['borderBottomStyle'].string;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['alignItems'] = alignItems;
    map['backgroundColor'] = backgroundColor;
    map['color'] = color;
    map['borderColor'] = borderColor;

    map['borderLeftWidth'] = borderLeftWidth;
    map['borderLeftColor'] = borderLeftColor;
    map['borderLeftStyle'] = borderLeftStyle;

    map['borderTopWidth'] = borderTopWidth;
    map['borderTopColor'] = borderTopColor;
    map['borderTopStyle'] = borderTopStyle;

    map['borderBottomWidth'] = borderBottomWidth;
    map['borderBottomColor'] = borderBottomColor;
    map['borderBottomStyle'] = borderBottomStyle;

    return map;
  }

  String alignItems;
  String backgroundColor;
  String color;

  String borderColor;

  String borderLeftWidth;
  String borderLeftColor;
  String borderLeftStyle;

  String borderTopWidth;
  String borderTopColor;
  String borderTopStyle;

  String borderRightWidth;
  String borderRightColor;
  String borderRightStyle;

  String borderBottomWidth;
  String borderBottomColor;
  String borderBottomStyle;

  Color getColor(String colorString) {
    if (colorString?.startsWith('#') == true) {
      final hex = int.parse(colorString.replaceAll('#', '0xFF'));
      return Color(hex);
    }
    if (colorString?.isEmpty == false) {
      final startIndex = colorString.indexOf('(');
      final endIndex = colorString.indexOf(')', startIndex + '('?.length);
      final rgb = colorString.substring(startIndex + 1, endIndex).split(',');
      if (rgb?.isEmpty == true || rgb?.length != 3) {
        return null;
      }
      return Color.fromRGBO(
          int.parse(rgb[0]), int.parse(rgb[1]), int.parse(rgb[2]), 1);
    }
    return null;
  }

  Alignment getAlignment() {
    if (alignItems == 'center') {
      return Alignment.center;
    }

    return Alignment.centerLeft;
  }
}

class FieldModel {
  FieldModel(
      {this.formId,
      this.id,
      this.parentId,
      this.title,
      this.subTitle,
      this.fieldType,
      this.row,
      this.column,
      this.defaultValue,
      String value,
      this.size,
      this.isRequire,
      this.style,
      this.apiCode,
      this.formula,
      this.reportType,
      this.fieldName,
      this.isDisable,
      this.relationKey,
      this.formulaCode,
      this.fieldFormula,
      this.imageOffline,
      this.fieldModels,
      this.additionalData,
      this.fieldThresholdMappings,
      this.currentTemperature,
      this.vectorGroup}) {
    _value = value;
  }

  factory FieldModel.fromJSON(JSON json) {
    final fieldsModelJsons = json['children'].listObject;
    final fieldsModel =
        fieldsModelJsons?.map((e) => FieldModel.fromJSON(JSON(e)))?.toList();

    StyleModel fieldStyle;
    if (json['style']?.string != null) {
      fieldStyle = StyleModel.fromJSON(JSON.parse(json['style']?.string));
    }
    final additionalDataStr = json['additionalData'].string;
    final additionalData = (additionalDataStr != null && additionalDataStr.isNotEmpty)
        ? AdditionalData.fromJSON(JSON.parse(additionalDataStr))
        : null;
    final model = FieldModel(
        id: json['id'].string,
        formId: json['formId'].string,
        parentId: json['parentId'].string,
        title: json['title'].string ?? '',
        subTitle: json['subTitle'].string ?? '',
        fieldType: json['fieldType'].integer,
        row: json['row'].integer,
        size: json['size'].integer,
        reportType: json['reportType'].integer,
        column: json['column'].integer,
        formulaCode: json['formulaCode'].integer,
        defaultValue: json['defaultValue'].string,
        value: json['value'].string,
        fieldName: json['fieldName'].string,
        formula: json['formula'].string,
        apiCode: json['apiCode'].integer,
        fieldFormula: json['fieldFormula'].string,
        relationKey: json['relationKey'].string,
        isRequire: json['isRequired'].boolean,
        isDisable: json['isDisable']?.boolean ?? false,
        style: fieldStyle,
        fieldModels: fieldsModel,
        imageOffline: json['imageOffline']
            ?.listObject
            ?.map((e) => ImageReport.fromJson(JSON(e)))
            ?.toList(),
        fieldThresholdMappings: json['fieldThresholdMappings']?.listObject?.map((e) => JSON(e).mapObject)?.toList(),
        currentTemperature: json['currentTemperature'].string,
        vectorGroup: json['vectorGroup'].string,
        additionalData: additionalData);
    return model;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['formId'] = formId;
    map['parentId'] = parentId;
    map['title'] = title;
    map['subTitle'] = subTitle;
    map['fieldType'] = fieldType;
    map['row'] = row;
    map['fieldName'] = fieldName;
    map['size'] = size;
    map['column'] = column;
    map['defaultValue'] = defaultValue;
    map['isRequired'] = isRequire;
    map['style'] = style?.toJson();
    map['value'] = value;
    map['formula'] = formula;
    map['apiCode'] = apiCode;
    map['isDisable'] = isDisable;
    map['formulaCode'] = formulaCode;
    map['fieldFormula'] = fieldFormula;
    map['relationKey'] = relationKey;
    map['reportType'] = reportType;
    map['imageOffline'] = imageOffline?.map((e) => e.toJson());
    map['additionalData'] = jsonEncode(additionalData?.toJson()).toString();

    if (fieldModels != null) {
      map['children'] = fieldModels?.map((v) => v.toJson())?.toList();
    }
    return map;
  }

  String id;
  String formId;
  String parentId;
  String title;
  String fieldName;
  String subTitle;
  int fieldType;
  int reportType;
  int row;
  int column;
  int formulaCode;
  String defaultValue;
  String _value;
  ValueNotifier<String> _valueNotifier;
  ValueNotifier<String> get valueNotifier {
    _valueNotifier ??= ValueNotifier<String>(_value ?? '');
    return _valueNotifier;
  }
  String get value => _value;
  set value(String v) {
    _value = v;
    _valueNotifier?.value = v ?? '';
  }
  String formula;
  String fieldFormula;
  String relationKey;
  bool isRequire;
  bool isDisable;
  StyleModel style;
  int size;
  int apiCode;
  AdditionalData additionalData;
  List<ImageReport> imageOffline;
  List<dynamic> fieldThresholdMappings;
  String currentTemperature;
  String vectorGroup;
  final focusNode = FocusNode();
  final key = GlobalKey();

  List<FieldModel> fieldModels;

  List<TableContainerModel> getRows() {
    final newMap =
        fieldModels?.groupListsBy((element) => element.row)?.values?.toList();
    final list = newMap?.map((e) => TableContainerModel(e));
    return list?.toList();
  }

  Future<void> getValues(Map<String, dynamic> data) async {
    if ([
      FieldType.checkbox,
      FieldType.dropDown,
      FieldType.textBox,
      FieldType.textArea,
      FieldType.number,
      FieldType.dateTime,
      FieldType.yearPicker,
      FieldType.images,
      FieldType.inputTag,
      FieldType.radioButton,
      FieldType.dropDownMultiSelect,
      FieldType.evaluate,
      FieldType.uploadFile,
      FieldType.importData,
    ].contains(fieldType)) {
      data.addAll({id: value});

      if (fieldModels?.isNotEmpty == true) {
        for (var index = 0; index < fieldModels?.length ?? 0; index++) {
          fieldModels[index].getValues(data);
        }
      }
    } else {
      if (fieldModels?.isNotEmpty == true) {
        for (var index = 0; index < fieldModels?.length ?? 0; index++) {
          fieldModels[index].getValues(data);
        }
      }
    }
  }

  Future<bool> validateDataModel() async {
    if ([
      FieldType.checkbox,
      FieldType.dropDown,
      FieldType.textBox,
      FieldType.textArea,
      FieldType.number,
      FieldType.dateTime,
      FieldType.yearPicker,
      FieldType.dropDownMultiSelect,
      FieldType.uploadFile,
      FieldType.importData,
    ].contains(fieldType)){
      if ((value == null || value?.isEmpty == true) &&
          (fieldModels == null || fieldModels?.isEmpty == true) &&
          (isRequire == null || isRequire == false)) {
        return false;
      }

      if (value == null || value?.isEmpty == true && isRequire == true) {
        return true;
      }
      else {
        if (fieldModels?.isNotEmpty == true) {
          for (var index = 0; index < fieldModels?.length ?? 0; index++) {
            final bl = await fieldModels[index].validateDataModel();
            if (bl == true) {
              return true;
            }
          }
        }
      }
    } else {
      if (fieldModels?.isNotEmpty == true) {
        for (var index = 0; index < fieldModels?.length ?? 0; index++) {
          final bl = await fieldModels[index].validateDataModel();
          if (bl == true) {
            return true;
          }
        }
      }
    }
  }

  bool isDisableTextField() {
    return fieldName != null &&
            [
              '[CONTROLLER]',
              '[DIRECTOR]',
              '[TESTING_METHOD]',
              '[TEXT_CONCLUSION_EN]'
            ].contains(fieldName) ||
        formula != null;
  }

  Future handleOperatorField() async {
    fieldModels.forEach((element) async {
      if (element.fieldFormula != null &&
          element.fieldType != FieldType.radioButton) {
        final params = element.fieldFormula.split(',').map((e) => e.trim()).toList();
        final values = <String>[null, null, null, null];
        params.forEachIndexed((index, par) {
          var valueField = fieldModels.firstWhere((e) => e.fieldName == par,
              orElse: () => null);
          if (valueField == null) {
            try {
              if (Get.isRegistered<ReportController>()) {
                final reportController = Get.find<ReportController>();
                valueField = reportController.findFieldByName(
                    reportController.reportModel?.value?.fieldsModel, par);
              }
            } catch (e) {}
          }
          if (valueField != null) {
            if (index < 4) values[index] = valueField?.value ?? '';
          } else {
            if (index < 4) values[index] = '';
          }
        });

        final selectedFormulaCode =
            await getFormulaCodeByRelationKey(element.relationKey);

        final result = operatorCalculator(
            selectedFormulaCode ?? element.formulaCode,
            a: values[0],
            b: values[1],
            c: values[2],
            d: values[3]);
        element.value = result;
      }
    });
  }

  bool isFieldTester() {
    return '[TESTER]' == fieldName;
  }

  bool isTestingMethod() {
    return '[TESTING_METHOD]' == fieldName;
  }

  bool isStampNumber() {
    return '[NUMBER_TEM_INSPECTION]' == fieldName;
  }

  bool isMonitoring() {
    return '[MONITORING]' == fieldName;
  }

  bool isCongThuc() {
    return '[CONG_THUC]' == fieldName;
  }

  bool isConclusion() {
    return '[SUMMARY_CONCLUSION]' == fieldName;
  }

  bool isCodeApi() {
    return apiCode != null;
  }

  List<String> getArrValue() {
    if (value == null || value?.isEmpty == true) {
      return [];
    } else {
      return value.split(', ').toList();
    }
  }

  void arrayValueToString(List<String> values) {
    value = values.map((e) => e).join(', ');
  }

  Future fillValueToAllFieldText(String key, String valueFill) async {
    if ([
      FieldType.textBox,
    ].contains(fieldType)) {
      if (relationKey == key) {
        value = valueFill;
      }
    }

    if (fieldModels?.isNotEmpty == true) {
      for (var index = 0; index < fieldModels?.length ?? 0; index++) {
        await fieldModels[index].fillValueToAllFieldText(key, valueFill);
      }
    }
  }

  Future<int> getFormulaCodeByRelationKey(String relationKey) async {
    if ([
      FieldType.radioButton,
    ].contains(fieldType)) {
      if (this.relationKey != relationKey) return null;

      if (value == 'true' || defaultValue == 'true') {
        return formulaCode;
      }
    }

    if (fieldModels?.isNotEmpty == true) {
      for (var index = 0; index < fieldModels?.length ?? 0; index++) {
        final result = await fieldModels[index].getFormulaCodeByRelationKey(relationKey);
        if (result != null) {
          return result;
        }
      }
    }
  }

  Future changeValueRadioBT(String key) async {
    if ([
      FieldType.radioButton,
    ].contains(fieldType)) {
      if (relationKey == key) {
        value = 'false';
      }
    }

    if (fieldModels?.isNotEmpty == true) {
      for (var index = 0; index < fieldModels?.length ?? 0; index++) {
        await fieldModels[index].changeValueRadioBT(key);
      }
    }
  }

  Future fillValueToAllFieldDropdown(String key, String valueFill) async {
    if ([
      FieldType.dropDown,
    ].contains(fieldType)) {
      if (relationKey == key) {
        value = valueFill;
      }
    }

    if (fieldModels?.isNotEmpty == true) {
      for (var index = 0; index < fieldModels?.length ?? 0; index++) {
        await fieldModels[index].fillValueToAllFieldDropdown(key, valueFill);
      }
    }
  }

  Future<AdditionalData> getAdditionDataFieldDropdown(
      String key, FieldModel fieldModelQR) async {
    if ([
      FieldType.dropDown,
    ].contains(fieldType)) {
      if (relationKey == key) {
        if (fieldModelQR?.additionalData?.options == null) {
          fieldModelQR.additionalData = additionalData;
        }
      }
    }

    if (fieldModels?.isNotEmpty == true) {
      for (var index = 0; index < fieldModels?.length ?? 0; index++) {
        unawaited(
            fieldModels[index].getAdditionDataFieldDropdown(key, fieldModelQR));
      }
    }
  }
}

