// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/charging_cabinet_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../charging_cabinet_controller.dart';

Widget CheckChargingCabinetScreen(ChargingCabinetController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as ChargingCabinetModel;
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
      title: '1. ${HighElectricStrings.checkChargingCabinet}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkLoadingCabinet,
          isDisable: true,
        ),
        //Điện áp vận hành
        if(_controller.transformerTicketController.checkAbnormalNotify(model.operatingVoltage,abnormal: model.operatingVoltageAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.operatingVoltageAbnormal,
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
            title: '1.1 ${HighElectricStrings.checkOperatingVoltage}',
            checkListItem: [
              CheckModel(
                title: HighElectricStrings.phaseBYIn,
                value: model.operatingVoltageBYIn?.toString(),
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.operatingVoltageBYIn = value.toDoubleOrNull();
                },
              ),
              CheckModel(
                title: HighElectricStrings.phaseBYOut,
                value: model.operatingVoltageBYOut?.toString(),
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.operatingVoltageBYOut = value.toDoubleOrNull();
                },
              ),
              CheckModel(
                title: HighElectricStrings.phaseACCU,
                value: model.operatingVoltageACCU?.toString(),
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  model.operatingVoltageACCU = value.toDoubleOrNull();
                },
              ),
              CheckModel(
                title: HighElectricStrings.phaseDC,
                value: model.operatingVoltageDCLoad?.toString(),
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.operatingVoltageDCLoad = value.toDoubleOrNull();
                },
              )
            ],
            optionsDefaultValue: model.operatingVoltage,
            onSelectChange: (value) {
              model.operatingVoltage = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.operatingVoltageAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            defaultAbnormal: model.operatingVoltageAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //Dòng điện vận hành
        if(_controller.transformerTicketController.checkAbnormalNotify(model.operatingCurrent,abnormal: model.operatingCurrentAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.operatingCurrentAbnormal,
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
            title: '1.2 ${HighElectricStrings.operatingCurrent}',
            checkListItem: [
              CheckModel(
                title: HighElectricStrings.phaseBYInI,
                value: model.operatingCurrentBYIn?.toString(),
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  model.operatingCurrentBYIn = value.toDoubleOrNull();
                },
              ),
              CheckModel(
                title: HighElectricStrings.phaseBYOutI,
                value: model.operatingCurrentBYOut?.toString(),
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  model.operatingCurrentBYOut = value.toDoubleOrNull();
                },
              ),
              CheckModel(
                title: HighElectricStrings.phaseACCUI,
                value: model.operatingCurrentACCU?.toString(),
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  model.operatingCurrentACCU = value.toDoubleOrNull();
                },
              ),
              CheckModel(
                title: HighElectricStrings.phaseDCI,
                value: model.operatingCurrentDCLoad?.toString(),
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  model.operatingCurrentDCLoad = value.toDoubleOrNull();
                },
              )
            ],
            optionsDefaultValue: model.operatingCurrent,
            onSelectChange: (value) {
              model.operatingCurrent = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.operatingCurrentAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.operatingCurrentAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //Trạng thái tín hiệu mặt tủ
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cabinetSignalStatus,abnormal: model.cabinetSignalStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.cabinetSignalStatusAbnormal,
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
            title: '1.3 ${HighElectricStrings.cabinetSideSignalStatus}',
            optionsDefaultValue: model.cabinetSignalStatus,
            onSelectChange: (value) {
              model.cabinetSignalStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cabinetSignalStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            defaultAbnormal: model.cabinetSignalStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //Tình trạng tủ (tiếng kêu, phát nhiệt, ATM …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.loadingCabinetStatus,abnormal: model.loadingCabinetStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_4,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkChargingCabinet}',
                    description: model.loadingCabinetStatusAbnormal,
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
            title: '1.4 ${HighElectricStrings.cabinetStatus}',
            optionsDefaultValue: model.loadingCabinetStatus,
            onSelectChange: (value) {
              model.loadingCabinetStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.loadingCabinetStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
            },
            defaultAbnormal: model.loadingCabinetStatusAbnormal,
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

