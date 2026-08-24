// @dart=2.9

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/line/popups/lighting_model.dart';
import '../../../../../../../models/line/popups/line_underground_cables_system_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import '../tunnel_cable_controller.dart';

Widget buildCheckBondedScreen(TunnelCableController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as LineUndergroundCablesSystem;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) {
        _controller.addImage(files, ImageProblems.muc1_0);
      },
      listImage:
          _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      isCamera: model.checkBondedAbnormal != OptionsType.normal_weirdo.getOptions.first.value ,
      title: '1. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBondedAbnormal,
          isDisable: true,
        ),
        // Tình trạng vi phạm hành lang an toàn cáp ngầm
        if(_controller.transformerTicketController.checkAbnormalNotify(model.violationUndergroundCableSafetyCorridor,abnormal: model.violationUndergroundCableSafetyCorridorAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.violationUndergroundCableSafetyCorridorAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_1);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_1),
            title:
            '1.1 Tình trạng vi phạm hành lang an toàn cáp ngầm',
            optionsDefaultValue: model.violationUndergroundCableSafetyCorridor,
            onSelectChange: (value) {
              model.violationUndergroundCableSafetyCorridor = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.violationUndergroundCableSafetyCorridorAbnormal = value;
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
            defaultAbnormal: model.violationUndergroundCableSafetyCorridorAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Tình trạng nước trong hầm nối, thấm nước hầm nối
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionWaterConnectingTunnel,abnormal: model.conditionWaterConnectingTunnelAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionWaterConnectingTunnelAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_2);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_2),
            title:
            '1.2.Tình trạng hầm cáp (nắp hầm, nước trong hầm nối, thấm nước...)',
            optionsDefaultValue: model.conditionWaterConnectingTunnel,
            onSelectChange: (value) {
              model.conditionWaterConnectingTunnel = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionWaterConnectingTunnelAbnormal = value;
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
            defaultAbnormal: model.conditionWaterConnectingTunnelAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Tình trạng giá đỡ cáp (nứt, gỉ, …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cableHolderCondition,abnormal: model.cableHolderConditionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.cableHolderConditionAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_3);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_3),
            title:
            '1.3 Tình trạng giá đỡ cáp (nứt, gỉ, …)',
            optionsDefaultValue: model.cableHolderCondition,
            onSelectChange: (value) {
              model.cableHolderCondition = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cableHolderConditionAbnormal = value;
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
            defaultAbnormal: model.cableHolderConditionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Tình trạng biển báo, biển tên pha…
        if(_controller.transformerTicketController.checkAbnormalNotify(model.signStatus,abnormal: model.signStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_4,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.signStatusAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_4);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_4),
            title:
            '1.4 Tình trạng biển báo, biển tên pha…',
            optionsDefaultValue: model.signStatus,
            onSelectChange: (value) {
              model.signStatus = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.signStatusAbnormal = value;
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
            defaultAbnormal: model.signStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Tình trạng cáp, hộp nối (nứt, tổn thương …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cableCondition,abnormal: model.cableConditionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_5,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.cableConditionAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_5);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_5),
            title:
            '1.5 Tình trạng cáp, hộp nối (nứt, tổn thương …)',
            optionsDefaultValue: model.cableCondition,
            onSelectChange: (value) {
              model.cableCondition = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cableConditionAbnormal = value;
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
            defaultAbnormal: model.cableConditionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Tình trạng vi phạm hành lang an toàn cáp ngầm
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionCableGroundWire,abnormal: model.conditionCableGroundWireAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_6,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionCableGroundWireAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_6);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_6),
            title:
            '1.6 Tình trạng dây tiếp địa vỏ cáp, các mối nối dây tiếp địa linkbox',
            optionsDefaultValue: model.conditionCableGroundWire,
            onSelectChange: (value) {
              model.conditionCableGroundWire = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_6);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_6);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionCableGroundWireAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_6,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_6,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.conditionCableGroundWireAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        // 1.7.Tình trạng vỏ tủ linkbox, thấm nước linkbox
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusLinkBox,abnormal: model.statusLinkBoxAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_7,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.statusLinkBoxAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_7).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc1_7);
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_7),
            title:
            '1.7.Tình trạng vỏ tủ linkbox, thấm nước linkbox',
            optionsDefaultValue: model.statusLinkBox,
            onSelectChange: (value) {
              model.statusLinkBox = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_7);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_7);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusLinkBoxAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_7,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(
                  ImageProblems.muc1_7,
                  message: weirdoMessage));
            },
            defaultAbnormal: model.statusLinkBoxAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
      ],
    );
  }

  return _buildHeader();
}

