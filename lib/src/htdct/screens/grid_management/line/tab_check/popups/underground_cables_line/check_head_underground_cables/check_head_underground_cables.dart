// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/line/popups/underground_cables_line_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import '../underground_cables_line_controller.dart';

Widget buildCheckHeadUndergroundCables(
    UndergroundCableLineController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as UndergroundCablesLineModel;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      allImage: _controller.getListImage(),
      listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Kiểm tra',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.lineUndergroundCablesAbnormal,
          isDisable: true,
        ),
        // Tình trạng nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.headStatus,abnormal: model.headStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.headStatusAbnormal,
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
          title: '1.1 Tình trạng đầu cáp, cáp ngầm',
          checkListItem: const [],
          optionsDefaultValue: model.headStatus,
          onSelectChange: (value) {
            model.headStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_1);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.headStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_1,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
          },
          defaultAbnormal: model.headStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        // Tinh trạng hệ thống tiếp địa cáp, hộp tiếp địa vỏ cáp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.systemStatus,abnormal: model.systemStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.systemStatusAbnormal,
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
          title: '1.2 Tình trạng hệ thống tiếp địa cáp, hộp linkbox',
          checkListItem: const [],
          optionsDefaultValue: model.systemStatus,
          onSelectChange: (value) {
            model.systemStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_2);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.systemStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_2,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
          },
          defaultAbnormal: model.systemStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        // Tình trạng công trình cáp (cầu cáp, giá đỡ cáp, ...)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.constructionStatus,abnormal: model.constructionStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_3,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.constructionStatusAbnormal,
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
          title: '1.3 Tình trạng công trình cáp (cầu cáp, giá đỡ cáp, ...)',
          checkListItem: const [],
          optionsDefaultValue: model.constructionStatus,
          onSelectChange: (value) {
            model.constructionStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_3);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.constructionStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_3,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
          },
          defaultAbnormal: model.constructionStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        // Kiểm tra hành lang tuyến cáp (Biển cảnh báo, hoạt động thi công dọc tuyến cáp, ...)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.lobbyStatus,abnormal: model.lobbyStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.lobbyStatusAbnormal,
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
          title:
              '1.4 Kiểm tra hành lang tuyến cáp (Biển cảnh báo, hoạt động thi công dọc tuyến cáp, ...)',
          checkListItem: const [],
          optionsDefaultValue: model.lobbyStatus,
          onSelectChange: (value) {
            model.lobbyStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_4);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.lobbyStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_4,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
          },
          defaultAbnormal: model.lobbyStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        // Kiểm tra tình trạng mốc báo hiệu cáp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.mustyStatus,abnormal: model.mustyStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_5,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.mustyStatusAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_5).abnormalId,

            removeImage: (file) {
            _controller.removeImage(file);
          },
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc1_5);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc1_5),
          title: '1.5 Kiểm tra tình trạng mốc báo hiệu cáp',
          checkListItem: const [],
          optionsDefaultValue: model.mustyStatus,
          onSelectChange: (value) {
            model.mustyStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_5);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.mustyStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_5,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_5, message: weirdoMessage));
          },
          defaultAbnormal: model.mustyStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        // Kiểm tra tình trạng hầm nối cáp (Nắp hầm)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cablesStatus,abnormal: model.cablesStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_6,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.cablesStatusAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_6).abnormalId,

            removeImage: (file) {
            _controller.removeImage(file);
          },
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc1_6);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc1_6),
          title: '1.6 Kiểm tra tình trạng hầm nối cáp (Nắp hầm)',
          checkListItem: const [],
          optionsDefaultValue: model.cablesStatus,
          onSelectChange: (value) {
            model.cablesStatus = int.parse(value);
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_6);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_6);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.cablesStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_6,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_6, message: weirdoMessage));
          },
          defaultAbnormal: model.cablesStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
      ],
    );
  }

  return _buildHeader();
}

