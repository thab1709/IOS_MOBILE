// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/accu_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../../log_book/common/option_type.dart' as dataTesst;
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../accu_controller.dart';

Widget CheckACCUScreen(ACCUController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller.dataModel.value as ACCUModel;
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
      invalid: _controller.invalid.value,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. ${HighElectricStrings.checkACCUSystem}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkACCUSystem,
          isDisable: true,
        ),
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.conditionBottle,
            abnormal: model.conditionBottleAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkACCUSystem}',
                    description: model.conditionBottleAbnormal,
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
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_1);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
              title: '1.1.${HighElectricStrings.conditionOfTankShellPile}',
              optionsDefaultValue: model.conditionBottle,
              onSelectChange: (value) {
                model.conditionBottle = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_1);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.conditionBottleAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_1,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_1,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.conditionBottleAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.2.Tình trạng thanh đấu nối, điểm tiếp xúc
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.conditionCconnectingRod,
            abnormal: model.conditionCconnectingRodAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkACCUSystem}',
                    description: model.conditionCconnectingRodAbnormal,
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
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_2);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
              title: '1.2.Tình trạng thanh đấu nối, điểm tiếp xúc',
              optionsDefaultValue: model.conditionCconnectingRod,
              onSelectChange: (value) {
                model.conditionCconnectingRod = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_2);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.conditionCconnectingRodAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_2,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_2,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.conditionCconnectingRodAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.3.Tình trạng hệ thống chiếu sáng sự cố, quạt thông gió
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.troubleLightingStatus,
            abnormal: model.troubleLightingStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkACCUSystem}',
                    description: model.troubleLightingStatusAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_3).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_3);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
              title: '1.3.${HighElectricStrings.troubleLightingStatus}',
              optionsDefaultValue: model.troubleLightingStatus,
              onSelectChange: (value) {
                model.troubleLightingStatus = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_3);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.troubleLightingStatusAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_3,
                  description: model.troubleLightingStatusAbnormal,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_3,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.troubleLightingStatusAbnormal,
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

