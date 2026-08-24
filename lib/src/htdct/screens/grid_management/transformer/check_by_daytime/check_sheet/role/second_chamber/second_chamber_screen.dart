// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/role_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../role_controller.dart';

Widget buildSecondChamberScreen(RoleController _controller) {
  Widget _buildHeader() {
    final model = _controller?.dataModel?.value as RoleModel;
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
      isCamera: _controller.isNotMultiCopy(),
      title: '2. Khoang nhị thứ',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.secondChamber,
          isDisable: true,
        ),

        // 2.1.Tình trạng các đèn báo tín hiệu, bộ báo tín hiệu, cảnh báo trên mặt tủ
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusSignalLights,abnormal: model.statusSignalLightsAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_1,
                    childCategory: title,
                    parentCategory: '2. Khoang nhị thứ',
                    description: model.statusSignalLightsAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_1).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_1);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_1),
            title: '2.1.Tình trạng các đèn báo tín hiệu, bộ báo tín hiệu, cảnh báo trên mặt tủ',
            optionsDefaultValue: model.statusSignalLights,
            onSelectChange: (value) {
              model.statusSignalLights = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusSignalLightsAbnormal = value;model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_1, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.statusSignalLightsAbnormal),
        //2.2.Tình trạng các đèn chỉ thị, MIMIC so với trạng thái nhất thứ
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusIndicatorDevicesMIMIC,abnormal: model.statusIndicatorDevicesMIMICAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_2,
                    childCategory: title,
                    parentCategory: '2. Khoang nhị thứ',
                    description: model.statusIndicatorDevicesMIMICAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_2).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_2);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_2),
            title: '2.2.Tình trạng các đèn chỉ thị, MIMIC so với trạng thái nhất thứ',
            optionsDefaultValue: model.statusIndicatorDevicesMIMIC,
            onSelectChange: (value) {
              model.statusIndicatorDevicesMIMIC = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusIndicatorDevicesMIMICAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_2, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.statusIndicatorDevicesMIMICAbnormal),
        //2.3.Tình trạng hệ thống mạch sấy, chiếu sáng
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionDryingLightingCircuitSystem,abnormal: model.conditionDryingLightingCircuitSystemAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_3,
                    childCategory: title,
                    parentCategory: '2. Khoang nhị thứ',
                    description: model.conditionDryingLightingCircuitSystemAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_3).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_3);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_3),
            title:
                '2.3.Tình trạng hệ thống mạch sấy, chiếu sáng',
            optionsDefaultValue: model.conditionDryingLightingCircuitSystem,
            onSelectChange: (value) {
              model.conditionDryingLightingCircuitSystem = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionDryingLightingCircuitSystemAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_3, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.conditionDryingLightingCircuitSystemAbnormal),
        //2.4.Tình trạng mạch, hàng kẹp, ATM(phát nhiệt, lỏng,...)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.circuitStatus,abnormal: model.circuitStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_4,
                    childCategory: title,
                    parentCategory: '2. Khoang nhị thứ',
                    description: model.circuitStatusAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_4).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_4);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_4),
            title:
                '2.4.Tình trạng mạch, hàng kẹp, ATM(phát nhiệt, lỏng,...)',
            optionsDefaultValue: model.circuitStatus,
            onSelectChange: (value) {
              model.circuitStatus = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.circuitStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_4, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.circuitStatusAbnormal),
        //2.5.Tình trạng chống nước; động vật lạ xâm nhập
        if(_controller.transformerTicketController.checkAbnormalNotify(model.invasionForeignAnimals,abnormal: model.invasionForeignAnimalsAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_5,
                    childCategory: title,
                    parentCategory: '2. Khoang nhị thứ',
                    description: model.invasionForeignAnimalsAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_5).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_5);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_5),
            title:
                '2.5.Tình trạng chống nước; động vật lạ xâm nhập',
            optionsDefaultValue: model.invasionForeignAnimals,
            onSelectChange: (value) {
              model.invasionForeignAnimals = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.invasionForeignAnimalsAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_5,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_5, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.invasionForeignAnimalsAbnormal),
        //2.6.Tình trạng vệ sinh công nghiệp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.checkStateIndustrialHygiene,abnormal: model.checkStateIndustrialHygieneAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_6,
                    childCategory: title,
                    parentCategory: '2. Khoang nhị thứ',
                    description: model.checkStateIndustrialHygieneAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_6).abnormalId,

              addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_6);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_6),
            title:
                '2.6.Tình trạng vệ sinh công nghiệp',
            optionsDefaultValue: model.checkStateIndustrialHygiene,
            onSelectChange: (value) {
              model.checkStateIndustrialHygiene = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_6);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_6);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.checkStateIndustrialHygieneAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_6,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_6, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.checkStateIndustrialHygieneAbnormal),
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

