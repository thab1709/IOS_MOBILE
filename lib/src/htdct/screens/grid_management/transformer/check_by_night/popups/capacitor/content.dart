// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/night/capacitor_night.dart';
import 'package:flutter/material.dart';

import '../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../models/day_night/popups/night/transformer_auto_night_model.dart';
import '../../../../../../models/weirdo_message.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../check_by_daytime/check_sheet/common/expansion_widget.dart';
import 'controller.dart';

Widget transformerAutoNightContent(CapacitorNightController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller.dataModel.value as CapacitorNightModel;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      allImage: _controller.getListImage(),
      invalid: _controller.invalid.value,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Kiểm tra',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.checkAbnormalDischarges,abnormal: model.checkAbnormalDischargesAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. Kiểm tra',
                    description: model.checkAbnormalDischargesAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_1).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_1);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
            title: '1.1 Kiểm tra hiện tượng phóng điện bất thường',
            optionsDefaultValue: model.checkAbnormalDischarges,
            onSelectChange: (value) {
              model.checkAbnormalDischarges = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.checkAbnormalDischargesAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            defaultAbnormal: model.checkAbnormalDischargesAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.soundCondenser,abnormal: model.soundCondenserAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. Kiểm tra',
                    description: model.soundCondenserAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_2).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_2);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
            title: '1.2 Tiếng kêu của dàn tụ',
            optionsDefaultValue: model.soundCondenser,
            onSelectChange: (value) {
              model.soundCondenser = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.soundCondenserAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.soundCondenserAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
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

