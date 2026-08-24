// @dart=2.9

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/lightning_protection_valve_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/lightning-protection-valve/lightning_protection_valve_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../../../../../common/constance/content_option.dart';
import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';

Widget buildCheckBondedScreen(LightningProtectionValveController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel
        ?.value as LightningProtectionValveModel;
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
        //vị trí CSV
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: const TextSpan(
                  text: 'Vị trí CSV',
                  style: Styles.titleTextField,
                  children: <TextSpan>[
                    TextSpan(
                        text: '*',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        )),
                  ],
                ),
              ),
            ),
            ESingleDropDown(
              OptionsType.location.getOptions,
              value: model.csvLocation,
              padding: 0,
              onSelected: (value) {
                model.csvLocation = value.toIntOrNull();
                _controller.checkValidPattern(1);
                _controller.viewRefresh();
              },
              invalid: _controller.invalid.value,
            ),
          ],
        ),
        // 1.3.Áp lực khí SF6
        if(_controller.transformerTicketController.checkAbnormalNotify(model.checkBonded,abnormal: model.checkBondedAbnormal))
          if(_controller.isGisOrHGis)
          CheckWidget(

              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.gasPressurSF6Abnormal,
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
              '1.1.Áp lực khí SF6',
              checkListItem: [
                CheckModel(
                    value: model.p.toString(),
                    title: 'Áp lực khí',
                    isNumber: true,
                    isRequired: true,
                    readOnly: false,
                    onChange: (value) {
                      model.p = value.toDoubleOrNull();
                    }),
              ],
              optionsDefaultValue: model.gasPressurSF6,
              onSelectChange: (value) {
                model.gasPressurSF6 = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_3);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.gasPressurSF6Abnormal = value;
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
              defaultAbnormal: model.gasPressurSF6Abnormal,
              options: OptionsType.normal_weirdo.getOptions),
        // 1.1. Tình trạng nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.groundingStatus,abnormal: model.groundingStatusAbnormal))
          CheckWidget(

              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.groundingStatusAbnormal,
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
            '${_controller.isGisOrHGis ? '1.2.' : '1.1.'}${HighElectricStrings.groundingStatus}',
            optionsDefaultValue: model.groundingStatus,
            onSelectChange: (value) {
              model.groundingStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.groundingStatusAbnormal = value;
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
            defaultAbnormal: model.groundingStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        // 1.2.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionContactsTerminalsInsulators,abnormal: model.conditionContactsTerminalsInsulatorsAbnormal))
          if(_controller.checkOutsite() )
        CheckWidget(

            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.conditionContactsTerminalsInsulatorsAbnormal,
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
            '${_controller.isGisOrHGis ? '1.3.' : '1.2.'}${HighElectricStrings.checkInsulatorAndOther}',
            optionsDefaultValue: model.conditionContactsTerminalsInsulators,
            onSelectChange: (value) {
              model.conditionContactsTerminalsInsulators = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionContactsTerminalsInsulatorsAbnormal = value;
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
            defaultAbnormal: model.conditionContactsTerminalsInsulatorsAbnormal,
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
