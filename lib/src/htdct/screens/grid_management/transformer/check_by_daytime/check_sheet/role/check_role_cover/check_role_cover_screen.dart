// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/role_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../role_controller.dart';

Widget buildCheckRoleCoverScreen(RoleController _controller) {
  Widget _buildHeader() {
    final model = _controller?.dataModel?.value as RoleModel;
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
      title: '1. ${HighElectricStrings.roleCover}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.protectionRelays,
          isDisable: true,
        ),

        // Tình trạng nguồn hoạt động 1.1
        if(_controller.transformerTicketController.checkAbnormalNotify(model.activeSourceStatus,abnormal: model.activeSourceStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkACCUSystem}',
                    description: model.activeSourceStatusAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_1).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_1);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
            title: '1.1.${HighElectricStrings.roleActiveStatus}',
            optionsDefaultValue: model.activeSourceStatus,
            onSelectChange: (value) {
              model.activeSourceStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.activeSourceStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.activeSourceStatusAbnormal),
        //Tình trạng các đèn báo trạng thái vận hành 1.2
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusOperatingLights,abnormal: model.statusOperatingLightsAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkACCUSystem}',
                    description: model.statusOperatingLightsAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_2).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_2);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
            title: '1.2.${HighElectricStrings.roleActiveLightingStatus}',
            optionsDefaultValue: model.statusOperatingLights,
            onSelectChange: (value) {
              model.statusOperatingLights = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusOperatingLightsAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.statusOperatingLightsAbnormal),
        //1.3.Tình trạng chỉ thị trạng thái (đóng, cắt…), cảnh báo trên màn hình
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusIndicatorStatus,abnormal: model.statusIndicatorStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkACCUSystem}',
                    description: model.statusIndicatorStatusAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_3).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_3);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
            title:
                '1.3.Tình trạng chỉ thị trạng thái (đóng, cắt…), cảnh báo trên màn hình',
            optionsDefaultValue: model.statusIndicatorStatus,
            onSelectChange: (value) {
              model.statusIndicatorStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusIndicatorStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.statusIndicatorStatusAbnormal),
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

