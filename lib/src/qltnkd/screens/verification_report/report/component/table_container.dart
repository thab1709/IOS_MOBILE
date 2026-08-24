// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/constance/field_type.dart';
import 'package:evnmobile/src/qltnkd/models/field_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/image_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/page_title_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/qr_code_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/radio_button_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/text_input_tag.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/year_picker.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/upload_file_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../report_controller.dart';
import 'check_box_view.dart';
import 'date_time.dart';
import 'drop_down.dart';
import 'drop_down_multi_select.dart';
import 'expand_view.dart';
import 'text_field_view.dart';
import 'title_view.dart';

class TableContainerModel {
  TableContainerModel(this.columns);

  List<FieldModel> columns;
}

class TableContainer extends StatelessWidget {
  TableContainer({
    this.fieldModel,
    this.refresh,
    this.isChild = false,
    this.isEdit = false,
  });

  final FieldModel fieldModel;

  final bool isChild;

  final Function refresh;

  final bool isEdit;

  final ReportController reportController = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    if (fieldModel == null) return Container();
    int maxCols = 0;
    final rows = fieldModel.getRows();
    for (var row in rows) {
      if (row.columns != null && row.columns.length > maxCols) {
        maxCols = row.columns.length;
      }
    }

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows
          .mapIndexed<Widget>(
              (e, i) => _renderRow(context, e, i, rows))
          .toList(),
    );

    if (maxCols > 2) {
      double screenWidth = MediaQuery.of(context).size.width;
      double availableWidth = screenWidth - 16; 
      double minWidth = maxCols * 120.0;
      double finalWidth = minWidth > availableWidth ? minWidth : availableWidth;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: finalWidth,
          child: content,
        ),
      );
    }

    return content;
  }

  FieldModel nextFocus(
      BuildContext context,
      FieldModel _field,
      int indexColumn,
      int indexRow,
      List<TableContainerModel> listRow,
      List<FieldModel> columns) {
    if (indexColumn < columns.length - 1) {
      for (var i = indexColumn + 1; i < columns.length; i++) {
        if (columns[i].isDisable != true &&
            (columns[i].fieldType == FieldType.textBox ||
                columns[i].fieldType == FieldType.textArea ||
                columns[i].fieldType == FieldType.dropDown ||
                columns[i].fieldType == FieldType.yearPicker ||
                columns[i].fieldType == FieldType.dateTime ||
                columns[i].fieldType == FieldType.inputTag ||
                columns[i].fieldType == FieldType.dropDownMultiSelect ||
                columns[i].fieldType == FieldType.uploadFile ||
                columns[i].fieldType == FieldType.number) &&
            !columns[i].isDisableTextField()) {
          _field.focusNode.unfocus();
          FocusScope.of(context).requestFocus(columns[i].focusNode);
          return columns[i];
        }
      }
    }

    if (indexRow <= listRow.length - 1) {
      for (var i = indexRow + 1; i <= listRow.length - 1; i++) {
        for (var j = 0; j < listRow[i].columns.length; j++) {
          final field = listRow[i].columns[j];
          if (field.isDisable != true &&
              (field.fieldType == FieldType.textBox ||
                  field.fieldType == FieldType.textArea ||
                  field.fieldType == FieldType.dropDown ||
                  field.fieldType == FieldType.yearPicker ||
                  field.fieldType == FieldType.dateTime ||
                  field.fieldType == FieldType.inputTag ||
                  field.fieldType == FieldType.dropDownMultiSelect ||
                  field.fieldType == FieldType.uploadFile ||
                  field.fieldType == FieldType.number) &&
              !field.isDisableTextField()) {
            _field.focusNode.unfocus();
            FocusScope.of(context).requestFocus(field.focusNode);
            if (field.key != null &&
                field.fieldType != FieldType.textBox &&
                field.fieldType != FieldType.inputTag &&
                field.fieldType != FieldType.textArea &&
                field.fieldType != FieldType.number) {
              Scrollable.ensureVisible(field.key.currentContext);
            }
            return field;
          }
        }
      }

      _field.focusNode.unfocus();
    }
    return null;
  }

  Widget _renderRow(BuildContext context, TableContainerModel _model,
      int indexRow, List<TableContainerModel> listRow) {
    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _model.columns
            .mapIndexed((e, i) => renderChildRow(
                context, e, i, indexRow, listRow, _model.columns))
            .toList(),
      ),
    );
  }

  Widget renderChildRow(
      BuildContext context,
      FieldModel _field,
      int indexColumn,
      int indexRow,
      List<TableContainerModel> listRow,
      List<FieldModel> columns) {
    if (reportController.reportType != null &&
        _field?.reportType != null &&
        _field?.reportType != reportController?.reportType) {
      return Container();
    }
    final Widget defaultWidget = Expanded(
      flex: _field.size,
      child: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(4),
      ),
    );



    switch (_field.fieldType) {
      case FieldType.label:
        return Expanded(
            flex: _field.size,
            child: CustomTitleView(
              fieldModel: _field,
            ));

      case FieldType.pageTitle:
        return Expanded(
            flex: _field.size,
            child: PageTitle(
              fieldModel: _field,
            ));

      case FieldType.textBox:
        return Expanded(
          flex: _field.size,
          child: CustomTextField(
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            fieldModel: _field,
            enable: reportController.isHasEdit(),
            isEdit: isEdit,
          ),
        );

      case FieldType.textArea:
        return Expanded(
          flex: _field.size,
          child: CustomTextField(
            fieldModel: _field,
            maxLine: 6,
            minLine: 3,
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            enable: reportController.isHasEdit(),
            isEdit: isEdit,
          ),
        );

      case FieldType.number:
        return Expanded(
          flex: _field.size,
          child: CustomTextField(
            key: Key(_field.id),
            fieldModel: _field,
            isOnlyInputNumber: true,
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            enable: reportController.isHasEdit(),
            onOperatorValueChange: () async {
              if (isChild) {
                await fieldModel.handleOperatorField();
              }
            },
            isEdit: isEdit,
          ),
        );

      case FieldType.checkbox:
        return Expanded(
          flex: _field.size,
          child: CheckBoxView(
            fieldModel: _field,
            enable: reportController.isHasEdit(),
          ),
        );

      case FieldType.dateTime:
        return Expanded(
          flex: _field.size,
          child: DateTimePicker(
            key: _field.key,
            fieldModel: _field,
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            enable: reportController.isHasEdit(),
          ),
        );

      case FieldType.yearPicker:
        return Expanded(
          flex: _field.size,
          child: YearPickerView(
            fieldModel: _field,
            key: _field.key,
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            enable: reportController.isHasEdit(),
          ),
        );

      case FieldType.dropDown:
      case FieldType.evaluate:
        return Expanded(
          flex: _field.size,
          child: CustomDropDown(
            fieldModel: _field,
            key: Key('${_field.id}_${_field.value}'),
            enable: reportController.isHasEdit(),
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            refresh: refresh,
          ),
        );

      case FieldType.dropDownMultiSelect:
        return Expanded(
          flex: _field.size,
          key: _field.key,
          child: DropDownMultiSelect(
            fieldModel: _field,
            onEditingComplete: () {
              nextFocus(
                  context, _field, indexColumn, indexRow, listRow, columns);
            },
            enabled: reportController.isHasEdit(),
            isEdit: isEdit,
          ),
        );

      case FieldType.table:
        return Expanded(
          flex: _field.size,
          child: TableContainer(
            fieldModel: _field,
            isChild: isChild,
            refresh: refresh,
          ),
        );

      case FieldType.collapsible:
        return Expanded(
          flex: _field.size,
          child: ExpandView(
            fieldModel: _field,
          ),
        );

      case FieldType.taps:
        return defaultWidget;

      case FieldType.tapPane:
        return defaultWidget;

      case FieldType.children:
        return Expanded(
          flex: _field.size,
          child: TableContainer(
            fieldModel: _field,
            refresh: refresh,
          ),
        );
      case FieldType.inputTag:
        return Expanded(
          flex: _field.size,
          child: TextInputTagView(
            fieldModel: _field,
            enable: reportController.isHasEdit(),
          ),
        );

      case FieldType.uploadFile:
        return Expanded(
          flex: _field.size,
          child: UploadFileView(
            fieldModel: _field,
            enable: reportController.isHasEdit(),
          ),
        );

      case FieldType.qr:
        return QRCodeView(
          fieldModel: _field,
          enable: reportController.isHasEdit(),
        );

      case FieldType.radioButton:
        return Expanded(
          child: RadioButtonView(
            fieldModel: _field,
            enable: reportController.isHasEdit(),
            refresh: () async {
              if (isChild) {
                await fieldModel.handleOperatorField();
              }
              refresh();
            },
          ),
        );

      case FieldType.images:
        return ImageView(
          fieldModel: _field,
          enable: reportController.isHasEdit(),
        );

      case FieldType.importData:
        return const SizedBox.shrink();

      default:
        return defaultWidget;
    }
  }
}

