// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/pole_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/pole/pole_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';

Widget CheckPoleScreen(PoleController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as PoleModel;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      allImage: _controller.getListImage(),
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Kiểm tra',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.linePolesAbnormal,
          isDisable: true,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.constructionPolesStatus,abnormal: model.constructionPolesStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.constructionPolesStatusAbnormal,
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
          title: '1.1 Tình trạng công trình cột (Thanh giằng, xà, bu lông,…)',
          checkListItem: const [],
          optionsDefaultValue: model.constructionPolesStatus,
          onSelectChange: (value) {
            model.constructionPolesStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_1);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.constructionPolesStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_1,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
          },
          defaultAbnormal: model.constructionPolesStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.systemPolesStatus,abnormal: model.systemPolesStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.systemPolesStatusAbnormal,
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
          title: '1.2.Tình trạng hệ thống tiếp đất tại chân cột (han rỉ, bu lông, mối hàn, cọc TĐ...)',
          checkListItem: const [],
          optionsDefaultValue: model.systemPolesStatus,
          onSelectChange: (value) {
            model.systemPolesStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_2);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.systemPolesStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_2,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
          },
          defaultAbnormal: model.systemPolesStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.numberPolesStatus,abnormal: model.numberPolesStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_3,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.numberPolesStatusAbnormal,
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
            final result = await _controller.addImage(files, ImageProblems.muc1_3);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
          title: '1.3 Tình trạng tên lộ, số cột, biển báo an toàn',
          checkListItem: const [],
          optionsDefaultValue: model.numberPolesStatus,
          onSelectChange: (value) {
            model.numberPolesStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_3);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.numberPolesStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_3,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
          },
          defaultAbnormal: model.numberPolesStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.lobbyPolesStatus,abnormal: model.lobbyPolesStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.lobbyPolesStatusAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_4).abnormalId,

            removeImage: (file) {
            _controller.removeImage(file);
          },
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc1_4);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc1_4),
          title: '1.4 Tình trạng hành lang tuyến',
          checkListItem: const [],
          optionsDefaultValue: model.lobbyPolesStatus,
          onSelectChange: (value) {
            model.lobbyPolesStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_4);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.lobbyPolesStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_4,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
          },
          defaultAbnormal: model.lobbyPolesStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
      ],
    );
  }

  return _buildHeader();
}

