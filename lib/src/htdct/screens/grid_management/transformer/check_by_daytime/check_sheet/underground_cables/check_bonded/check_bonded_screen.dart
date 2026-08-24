// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/underground_cable_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../underground_cable_controller.dart';

Widget buildCheckBondedScreen(UndergroundCableController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel
        ?.value as UndergroundCableModel;
    return ExpansionWidget(
      allImage: _controller.getListImage(),
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      listImage:
      _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        //Tình trạng cáp (nứt, tổn thương cáp …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cableConditionCable,abnormal: model.cableConditionCableAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.cableConditionCableAbnormal,
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
            '1.1 ${HighElectricStrings.cableStatus}',
            optionsDefaultValue: model.cableConditionCable,
            onSelectChange: (value) {
              model.cableConditionCable = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cableConditionCableAbnormal = value;
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
            defaultAbnormal: model.cableConditionCableAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //Tình trạng đầu cáp và tán cáp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionCableAndCableCanopyCable,abnormal: model.conditionCableAndCableCanopyCableAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.conditionCableAndCableCanopyCableAbnormal,
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
            '1.2 ${HighElectricStrings.conditionOfCable}',
            optionsDefaultValue: model.conditionCableAndCableCanopyCable,
            onSelectChange: (value) {
              model.conditionCableAndCableCanopyCable = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionCableAndCableCanopyCableAbnormal = value;
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
            defaultAbnormal: model.conditionCableAndCableCanopyCableAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //Tình trạng hệ thống tiếp đất vỏ cáp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionCableSheathGroundingSystem,abnormal: model.conditionCableSheathGroundingSystemAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_3,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.conditionCableSheathGroundingSystemAbnormal,
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
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_3),
            title:
            '1.3 ${HighElectricStrings.conditionOfGroundingSystem}',
            optionsDefaultValue: model.conditionCableSheathGroundingSystem,
            onSelectChange: (value) {
              model.conditionCableSheathGroundingSystem = value.toIntOrNull();
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
              _controller.checkValidPattern(1);
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionCableSheathGroundingSystemAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_3,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.conditionCableSheathGroundingSystemAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //Tình trạng giá đỡ (nứt, gỉ, cầu cáp, …)4
        if(_controller.transformerTicketController.checkAbnormalNotify(model.bracketCondition,abnormal: model.bracketConditionAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.bracketConditionAbnormal,
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
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_4),
            title:
            '1.4 ${HighElectricStrings.bracketCondition}',
            optionsDefaultValue: model.bracketCondition,
            onSelectChange: (value) {
              model.bracketCondition = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.bracketConditionAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_4,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.bracketConditionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.5.Tình trạng mương cáp, hầm cáp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cableTunnelStatus,abnormal: model.cableTunnelStatusAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_5,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.cableTunnelStatusAbnormal,
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
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_5),
            title:
            '1.5.Tình trạng mương cáp, hầm cáp ',
            optionsDefaultValue: model.cableTunnelStatus,
            onSelectChange: (value) {
              model.cableTunnelStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cableTunnelStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_5,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_5,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.cableTunnelStatusAbnormal,
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
