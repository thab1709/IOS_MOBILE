// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/conductor_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import '../conductor_controller.dart';

Widget buildCheckBondedScreen(ConductorController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as ConductorModel;
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
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Kiểm tra',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.lineConductorAbnormal,
          isDisable: true,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.lineConductorStatus,abnormal: model.lineConductorStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.lineConductorStatusAbnormal,
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
          title:
              '1.1 Tình trạng dây dẫn (Dấu hiệu phóng điện, tổn thương, độ võng bất thường …)',
          optionsDefaultValue: model.lineConductorStatus,
          onSelectChange: (value) {
            model.lineConductorStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_1);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.lineConductorStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_1,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
          },
          defaultAbnormal: model.lineConductorStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.lockStatus,abnormal: model.lockStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.lockStatusAbnormal,
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
          title:
              '1.2.Tình trạng khóa đỡ, tạ chống rung, mối nối và các phụ kiện khác',
          optionsDefaultValue: model.lockStatus,
          onSelectChange: (value) {
            model.lockStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_2);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.lockStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_2,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
          },
          defaultAbnormal: model.lockStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
      ],
    );
  }

  return _buildHeader();
}

