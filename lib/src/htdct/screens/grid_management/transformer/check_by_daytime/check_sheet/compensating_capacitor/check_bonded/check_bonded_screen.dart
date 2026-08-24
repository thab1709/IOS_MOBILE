// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/compensating_capacitor_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../compensating_capacitor_controller.dart';


Widget buildCheckBondedScreen(CompensatingCapacitorController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as CompensatingCapacitorModel;
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
      title: '1. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        //1.1. Thông số vận hành
        if(_controller.transformerTicketController.checkAbnormalNotify(model.operatingParameters,abnormal: model.operatingParametersAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.operatingParametersAbnormal,
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
            title: '1.1.Thông số vận hành dàn tụ',
            checkListItem: [
              CheckModel(
                  value: model.u.toString(),
                  title: 'U=',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.u = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.i.toString(),
                  title: 'I=',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.i = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.q.toString(),
                  title: 'Q=',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.q = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.operatingParameters,
            onSelectChange: (value) {
              model.operatingParameters = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.operatingParametersAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            defaultAbnormal: model.operatingParametersAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.2 Tình trạng sứ cách điện, các điểm tiếp xúc, đầu cốt
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionPorcelainInsulator,abnormal: model.conditionPorcelainInsulatorAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.conditionPorcelainInsulatorAbnormal,
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
              final result = await _controller.addImage(files, ImageProblems.muc1_2);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
            title: '1.2 ${HighElectricStrings.checkInsulatorAndOther}',
            optionsDefaultValue: model.conditionPorcelainInsulator,
            onSelectChange: (value) {
              model.conditionPorcelainInsulator = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionPorcelainInsulatorAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.conditionPorcelainInsulatorAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.3 Tình trạng thấm, dung môi cách nhiệt
        if(_controller.transformerTicketController.checkAbnormalNotify(model.seepageCondition,abnormal: model.seepageConditionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.seepageConditionAbnormal,
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
              final result = await _controller.addImage(files, ImageProblems.muc1_3);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
            title: '1.3 ${HighElectricStrings.conditionOfSeepage}',

            optionsDefaultValue: model.seepageCondition,
            onSelectChange: (value) {
              model.seepageCondition = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.seepageConditionAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            defaultAbnormal: model.seepageConditionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.4 Tình trạng nối đất dàn tụ
        if(_controller.transformerTicketController.checkAbnormalNotify(model.condenserGroundingStatus,abnormal: model.condenserGroundingStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_4,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.condenserGroundingStatusAbnormal,
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
              final result = await _controller.addImage(files, ImageProblems.muc1_4);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_4),
            title: '1.4 ${HighElectricStrings.condenserGroundingStatus}',
            optionsDefaultValue: model.condenserGroundingStatus,
            onSelectChange: (value) {
              model.condenserGroundingStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.condenserGroundingStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
            },
            defaultAbnormal: model.condenserGroundingStatusAbnormal,
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

