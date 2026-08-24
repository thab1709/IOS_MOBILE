// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/test_info_general_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/content/test_info_general/test_info_general_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/constance/option_type.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../models/weirdo_message.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../../containers/e_text_form_field.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';

Widget buildContent(TestInfoGeneralController _controller) {
  final model = _controller.dataModel.value as TestInfoGeneralModel;
  return Column(
    children: [
      ExpansionWidget(
        removeImage: (file) {
          _controller.removeImage(file);
        },
        addImage: (files) async {
          final result = await _controller.addImage(files, ImageProblems.muc1_0);
          return result;
        },
        listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
        invalid: _controller.invalid.value,
        isHeader: true,
        isCamera: true,
        title: 'Thông tin kiểm tra chung',
        children: <Widget>[
          ETextFormField(
            hint: 'Nhập thông tin',
            title: 'Nhiệt độ môi trường',
            isNumpad: true,
            isRequied: true,
            invalid: _controller.invalid.value,
            value: _controller.temperature.value,
            onChangeInput: (value) {
              _controller.temperature.value = value;
            },
          ),
          ETextFormField(
            hint: 'Nhập thông tin',
            title: 'Độ ẩm môi trường',
            isNumpad: true,
            isRequied: true,
            invalid: _controller.invalid.value,
            value: _controller.humidity.value,
            onChangeInput: (value) {
              _controller.humidity.value = value;
            },
          ),
        ],
      ),
      ExpansionWidget(
        removeImage: (file) {
          _controller.removeImage(file);
        },
        addImage: (files) async {
          final result = await _controller.addImage(files, ImageProblems.muc2_0);
          return result;
        },
        listImage: _controller.getImageByProblem(ImageProblems.muc2_0),
        invalid: _controller.invalid.value,
        isHeader: true,
        isCamera: true,
        title: '1. ${HighElectricStrings.checkBonded}',
        children: <Widget>[
          // kết luận
          ESingleDropDown(
            OptionsType.normal_weirdo.getOptions,
            value: model.generalTestInformationAbnormal,
            isDisable: true,
          ),
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.generalInformationAbnormalDescription,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_1).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result = await _controller.addImage(files, ImageProblems.muc2_1);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc2_1),
              title: '1.1 Tình trạng khóa đỡ, tạ chống rung, mối nối,...',
              optionsDefaultValue: model.generalInformation,
              onSelectChange: (value) {
                model.generalInformation = int.parse(value);
                _controller.checkValidPattern(ImageProblems.muc2_0);

                if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                  model.removeAbnormal(categoryIndex:ImageProblems.muc2_1);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.generalInformationAbnormalDescription = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc2_1,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(
                    WeirdoMessage(ImageProblems.muc2_1, message: weirdoMessage));
              },
              defaultAbnormal: model.generalInformationAbnormalDescription,
              options: OptionsType.normal_weirdo.getOptions),
        ],
      )
    ],
  );
}

