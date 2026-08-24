// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/ti_model.dart';
import 'package:evnmobile/src/htdct/models/weirdo_message.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/ti/ti_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';

Widget OpenratingVoltageScreen(TIController _controller) {
  Widget _buildHeader() // Điện áp từng pha
  {
    final model = _controller.dataModel.value as TIModel;
    return ExpansionWidget(
      allImage: _controller.getListImage(),
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Thông số vận hành',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.operatingParameters,
          isDisable: true,
        ),
        //1.1 Dòng vận hành(A)
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.operatingCurrent,
            abnormal: model.operatingCurrentAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. Thông số vận hành',
                  description: model.operatingCurrentAbnormal,
                  abnormalType: model.unusualClassification,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue:
                model.getAbnormal(ImageProblems.muc1_1).abnormalId,
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_1);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
            title: '1.1 Dòng vận hành(A)',
            checkListItem: [
              CheckModel(
                title: 'Irole',
                value: model.irole?.toString(),
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  if (_controller.triggerWaringValue == false) {
                    _controller.triggerWaringValue = true;
                  }
                  model.irole = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference();
                },
              ),
              CheckModel(
                title: 'ICông tơ',
                value: model.iMeter?.toString(),
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  if (_controller.triggerWaringValue == false) {
                    _controller.triggerWaringValue = true;
                  }
                  model.iMeter = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference();
                },
              ),
              CheckModel(
                title: 'Mức độ chênh lệch',
                value: _controller.degreeDifferenceValue.value.toString(),
                isNumber: true,
                isRequired: false,
                readOnly: true,
                onChange: (value) {
                  model.degreeDifference = value.toDoubleOrNull();
                },
              ),
            ],
            optionsDefaultValue: model.operatingCurrent,
            onSelectChange: (value) {
              model.operatingCurrent = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex: ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.operatingCurrentAbnormal = value;
              model.setAbnormal(
                  Abnormals(
                    categoryIndex: ImageProblems.muc1_1,
                    description: value,
                    abnormalType: model.unusualClassification,
                  ),
                  isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            defaultAbnormal: model.operatingCurrentAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
            showUnusualClassification: true,
            unusualClassificationDefaultValue:
                model.getAbnormal(ImageProblems.muc1_1).abnormalType,
            onUnusualClassificationChange: (int value) {
              model.unusualClassification = value;
              model.getAbnormal(ImageProblems.muc1_1).abnormalType = value;
            },
          ),
      ],
    );
  }

  return SingleChildScrollView(
    child: Column(
      children: [
        _buildHeader(),
      ],
    ),
  );
}

