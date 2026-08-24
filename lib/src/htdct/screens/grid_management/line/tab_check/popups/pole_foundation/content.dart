// @dart=2.9

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/constance/strings.dart';
import '../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../models/line/popups/csv_model.dart';
import '../../../../../../models/line/popups/pole_foundation.dart';
import '../../../../../../models/weirdo_message.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import 'controller.dart';

Widget buildContent(PoleFoundationController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as PoleFoundationModel;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      allImage: _controller.getListImage(),
      listImage:
          _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Kiểm tra',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.lineFoudationAbnormal,
          isDisable: true,
        ),
        // Tình trạng ngập nước, xói mòn móng cột
        if(_controller.transformerTicketController.checkAbnormalNotify(model.drownStatus,abnormal: model.drownStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.drownStatusAbnormal,
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
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_1),
            title:
            '1.1.Tình trạng ngập nước, xói mòn móng cột, bê tông móng',
            checkListItem: const [],
            optionsDefaultValue: model.drownStatus,
            onSelectChange: (value) {
              model.drownStatus = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.drownStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_1,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.drownStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
         ),
        //1.2 Tình trạng mặt đất, đường xung quanh, ...
        if(_controller.transformerTicketController.checkAbnormalNotify(model.roadStatus,abnormal: model.roadStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. Kiểm tra',
                    description: model.roadStatusAbnormal,
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
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_2),
            title:
                '1.2 Tình trạng mặt đất, đường xung quanh, ...',
            checkListItem: const [],
            optionsDefaultValue: model.roadStatus,
            onSelectChange: (value) {
              model.roadStatus = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.roadStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_2,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.roadStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
      ],
    );
  }

  return _buildHeader();
}

