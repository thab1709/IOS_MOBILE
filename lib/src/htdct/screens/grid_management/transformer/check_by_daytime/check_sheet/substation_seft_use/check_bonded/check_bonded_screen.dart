// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/substation_seft_use_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../substation_seft_use_controller.dart';

Widget buildCheckBondedScreen(SubstationSeftUseController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as SubstationSeftUseModel;
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
          value: _controller.dataModel.value.checkBonded,
          isDisable: true,
        ),

        //1.1 tiếng kêu mba
        if(_controller.transformerTicketController.checkAbnormalNotify(model.chirpMBA,abnormal: model.chirpMBAAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.chirpMBAAbnormal,
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
            title: '1.1 ${HighElectricStrings.checkChirpOfTransformers}',
            optionsDefaultValue: model.chirpMBA,
            onSelectChange: (value) {
              model.chirpMBA = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.chirpMBAAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_1,
                  message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.chirpMBAAbnormal),
        //1.2 Tình trạng mức dầu, mầu sắc của hạt hút ẩm MBA
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionOilLevel,abnormal: model.conditionOilLevelAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.conditionOilLevelAbnormal,
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
            listImage:
                _controller.getImageByProblem(ImageProblems.muc1_2),
            title: '1.2 ${HighElectricStrings.checkOilTankAndSilicaGelColor}',
            optionsDefaultValue: model.conditionOilLevel,
            onSelectChange: (value) {
              model.conditionOilLevel = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionOilLevelAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_2,
                  message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.conditionOilLevelAbnormal),
        //1.3 Tình trạng thân vỏ MBA (Han rỉ, chảy dầu…)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionBodyMBAContent,abnormal: model.conditionBodyMBAContentAbnormal))
        CheckWidget(

            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_3,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.conditionBodyMBAContentAbnormal,
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
            listImage:
                _controller.getImageByProblem(ImageProblems.muc1_3),
            title:
                '1.3 ${HighElectricStrings.checkBodyConditionExOfTransformers}',
            invalid: _controller.invalid.value,
            optionsDefaultValue: model.conditionBodyMBAContent,
            onSelectChange: (value) {
              model.conditionBodyMBAContent = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            onChangeInput: (value) {
              model.conditionBodyMBAContentAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_3,
                  message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.conditionBodyMBAContentAbnormal),

        //1.4 Tình trạng hệ thống nối đất MBA
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusGroundingSystemMBA,abnormal: model.statusGroundingSystemMBAAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.statusGroundingSystemMBAAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_4).abnormalId,

            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_4);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage:
            _controller.getImageByProblem(ImageProblems.muc1_4),
            title: '1.4 ${HighElectricStrings.checkGroundingTransformer}',
            optionsDefaultValue: model.statusGroundingSystemMBA,
            onSelectChange: (value) {
              model.statusGroundingSystemMBA = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusGroundingSystemMBAAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_4,
                  message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.statusGroundingSystemMBAAbnormal),

        //1.5 Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionContacts,abnormal: model.conditionContactsAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_5,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.conditionContactsAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_5).abnormalId,

            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_5);
              return result;
            },
            removeImage: (file) {
              _controller.removeImage(file);
            },
            listImage:
            _controller.getImageByProblem(ImageProblems.muc1_5),
            title: '1.5 ${HighElectricStrings.checkInsulatorAndOther}',
            optionsDefaultValue: model.conditionContacts,
            onSelectChange: (value) {
              model.conditionContacts = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionContactsAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_5,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_5,
                  message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.conditionContactsAbnormal),

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

