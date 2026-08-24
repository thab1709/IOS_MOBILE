// @dart=2.9

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/lightning_protection_valve_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common/constance/content_option.dart';
import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../lightning_protection_valve_controller.dart';

Widget buildCheckElectrodeSceen(LightningProtectionValveController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel
        ?.value as LightningProtectionValveModel;
    return _controller.checkOutsite() ? ExpansionWidget(
      allImage: _controller.getListImage(),
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc2_0);
        return result;
      },
      listImage:
      _controller.getImageByProblem(ImageProblems.muc2_0),
      isHeader: true,
      isCamera:
      _controller.dataModel.value.checkCSVPolesAbnormal != 1  && _controller.isNotMultiCopy(),
      title: '2. Kiểm tra các cực CSV',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkCSVPoles,
          isDisable: true,
        ),
        //2.1.Giá trị dòng rò (mA)

        if(_controller.transformerTicketController.checkAbnormalNotify(model.leakageCurrentValue,abnormal: model.leakageCurrentValueAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_1,
                    childCategory: title,
                    parentCategory: '2. Kiểm tra các cực CSV}',
                    description: model.leakageCurrentValueAbnormal,
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
            listImage: _controller
                .getImageByProblem(ImageProblems.muc2_1),
            title:
            '2.1.${HighElectricStrings.leakageCurrentValue}',
            checkListItem: [
              CheckModel(
                  value: model.ir.toString(),
                  title: 'Ir',
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.ir = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.leakageCurrentValue,
            onSelectChange: (value) {
              model.leakageCurrentValue = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.leakageCurrentValueAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc2_1,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.leakageCurrentValueAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //Chỉ số bộ đếm sét
        if(_controller.transformerTicketController.checkAbnormalNotify(model.lightningCounterIndicator,abnormal: model.lightningCounterIndicatorAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_2,
                    childCategory: title,
                    parentCategory: '2. Kiểm tra các cực CSV}',
                    description: model.lightningCounterIndicatorAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_2).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_2);
              return result;
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc2_2),
            title:
            '2.2.${HighElectricStrings.lightningCounterIndicator}',
            checkListItem: [
              CheckModel(
                  value: model.s.toString(),
                  title: 'S',
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.s = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.lightningCounterIndicator,
            onSelectChange: (value) {
              model.lightningCounterIndicator = value.toIntOrNull();
              _controller.checkValidPattern(2);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.lightningCounterIndicatorAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc2_2,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.lightningCounterIndicatorAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
      ],
    ):Container();
  }
  return SingleChildScrollView(
    child: Column(
      children: [
        _buildHeader(),
      ],
    ),
  );
}
