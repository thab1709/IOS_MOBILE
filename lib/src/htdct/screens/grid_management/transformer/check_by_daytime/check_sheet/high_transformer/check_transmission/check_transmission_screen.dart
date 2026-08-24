// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/check_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:flutter/material.dart';

import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/transformers_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../high_transformer_controller.dart';

Widget buildTransmission(
    HighTransformerController _controller) // kiểm tra ngoại quan
{
  final model = _controller?.dataModel?.value as TransformersModel;

  return ExpansionWidget(
    allImage: _controller.getListImage(),
    removeImage: (file) {
      _controller.removeImage(file);
    },
    addImage: (files) async {
      final result = await _controller.addImage(files, ImageProblems.muc2_0);
      return result;
    },
    listImage: _controller.getImageByProblem(ImageProblems.muc2_0),
    isHeader: true,
    invalid: _controller.invalid.value,
    isCamera: _controller.isNotMultiCopy(),
    title: '2. Kiểm tra tải MBA',
    children: <Widget>[
      ESingleDropDown(
        OptionsType.normal_weirdo.getOptions,
        value: model.mbaLoadTest,
        isDisable: true,
      ),

      //dòng tải phía 110kv
      if(_controller.transformerTicketController.checkAbnormalNotify(model.operatingParameters,abnormal: model.operatingParametersAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc2_1,
                  childCategory: title,
                  parentCategory: '2. Kiểm tra tải MBA',
                  description: model.operatingParametersAbnormal,
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
          title: '2.1 ${HighElectricStrings.checkInfoRuningTransformer}',
          checkListItem: [
            CheckModel(
                value:
                _controller.dataModel.value.hiccup
                    .toString(),
                title: 'Nấc',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.hiccup = value.toDoubleOrNull();
                }),
            CheckModel(
                value: _controller.dataModel.value.i
                    .toString(),
                title: 'I',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.i = value.toDoubleOrNull();
                }),
            CheckModel(
                value:
                _controller.dataModel.value.u
                    .toString(),
                title: 'U',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.u = value.toDoubleOrNull();
                }),
            CheckModel(
                value:
                _controller.dataModel.value.p
                    .toString(),
                title: 'P',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.p = value.toDoubleOrNull();
                }),
          ],
          optionsDefaultValue: model.operatingParameters,
          onSelectChange: (value) {
            model.operatingParameters = value.toIntOrNull();
            _controller.checkValidPattern(2);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc2_1);
              model.removeAbnormal(categoryIndex:ImageProblems.muc2_1);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.operatingParametersAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc2_1,
              description: value,
            ),isSetDescription: true);
          },
          defaultAbnormal: model.operatingParametersAbnormal,
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc2_1, message: weirdoMessage));
          },
          options: OptionsType.normal_weirdo.getOptions),

    ],
  );
}

