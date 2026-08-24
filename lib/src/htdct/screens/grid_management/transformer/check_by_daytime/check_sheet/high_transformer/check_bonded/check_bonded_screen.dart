// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/day_night/popups/transformers_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../high_transformer_controller.dart';

Widget buildCheckBondedScreen(HighTransformerController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as TransformersModel;
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
      invalid: _controller.invalid.value,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded ,
          isDisable: true,
        ),

        //1.1 Tiếng kêu của MBA => 0k
        if(_controller.transformerTicketController.checkAbnormalNotify(model.chirp,abnormal: model.chirpAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.chirpAbnormal,
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
            optionsDefaultValue: model.chirp,
            onSelectChange: (value) {
              model.chirp = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.chirpAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,
            defaultAbnormal: model.chirpAbnormal
        ),

        //1.2 Tình trạng thân vỏ => 0k
        if(_controller.transformerTicketController.checkAbnormalNotify(model.bodyCondition,abnormal: model.bodyConditionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.bodyConditionAbnormal,
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
            listImage:
                _controller.getImageByProblem(ImageProblems.muc1_2),
            title:
                '1.2 ${HighElectricStrings.checkBodyConditionOfTransformers}',
            optionsDefaultValue: model.bodyCondition,
            onSelectChange: (value) {
              _controller.checkValidPattern(1);
              model.bodyCondition = value.toIntOrNull();
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.bodyConditionAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.bodyConditionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.3 Tình trạng đầu cực, sứ đỡ các phía MBA  => 0k
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusTerminalsPorcelainSupportsMBA,abnormal: model.statusTerminalsPorcelainSupportsMBAAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.statusTerminalsPorcelainSupportsMBAAbnormal,
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
            listImage:
            _controller.getImageByProblem(ImageProblems.muc1_3),
            title: '1.3 ${HighElectricStrings.checkInsulatorTransformer}',
            optionsDefaultValue: model.statusTerminalsPorcelainSupportsMBA,
            onSelectChange: (value) {
              model.statusTerminalsPorcelainSupportsMBA = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusTerminalsPorcelainSupportsMBAAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            defaultAbnormal:
            model.statusTerminalsPorcelainSupportsMBAAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.4 Tình trạng mức dầu bình dầu phụ MBA, OLTC =>Ok - thiếu 1 trường
        if(_controller.transformerTicketController.checkAbnormalNotify(model.mbaoltcOilLevel,abnormal: model.mbaoltcOilLevelAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.mbaoltcOilLevelAbnormal,
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
            listImage:
                _controller.getImageByProblem(ImageProblems.muc1_4),
            title: '1.4 ${HighElectricStrings.checkAuxiliaryOilTankOfOLTC}',
          checkListItem: [
            CheckModel(
                value: model.mbaOilLevel ,
                title: 'MBA',
                isNumber: false,
                isRequired: true,
                onChange: (value) {
                  model.mbaOilLevel = value;
                }),
            CheckModel(
                value: model.oltcSetOilLevel  ,
                title: 'Bộ OLTC',
                isNumber: false,
                isRequired: true,
                onChange: (value) {
                  model.oltcSetOilLevel  =
                      value;
                }),
            CheckModel(
                value: model.oilLevelBreathingTank  ,
                title: 'Mức dầu ở cốc bình thở',
                isNumber: false,
                isRequired: true,
                onChange: (value) {
                  model.oilLevelBreathingTank   =
                      value;
                }),
          ],
            optionsDefaultValue: model.mbaoltcOilLevel ,
            onSelectChange: (value) {
              model.mbaoltcOilLevel  = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.mbaoltcOilLevelAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_4,
                description: value,
              ),isSetDescription: true);
            },
            defaultAbnormal: model.mbaoltcOilLevelAbnormal,
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
            },
            options: OptionsType.normal_weirdo.getOptions,),

        //1.5 Màu sắc của hạt hút ẩm => 0k
        if(_controller.transformerTicketController.checkAbnormalNotify(model.desiccantParticleColor,abnormal: model.desiccantParticleColorAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_5,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.desiccantParticleColorAbnormal,

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
            title: '1.5 ${HighElectricStrings.checkSilicaGelColor}',
            checkListItem: [
              CheckModel(
                  value: model.desiccantParticleColorMBA,
                  title: 'MBA',
                  isNumber: false,
                  isRequired: true,
                  onChange: (value) {
                    model.desiccantParticleColorMBA =
                        value;
                  }),
              CheckModel(
                  value: model.desiccantParticleColorOLTC,
                  title: 'Bộ OLTC',
                  isNumber: false,
                  isRequired: true,
                  onChange: (value) {
                    model.desiccantParticleColorOLTC =
                        value;
                  }),
            ],
            optionsDefaultValue:
                model.desiccantParticleColor,
            onSelectChange: (value) {
              model.desiccantParticleColor =
                  value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.desiccantParticleColorAbnormal =
                  value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_5,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_5, message: weirdoMessage));
            },
            defaultAbnormal:
                model.desiccantParticleColorAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.6 Tình trạng tủ truyền động và bộ OLTC => Ok - thiếu 2 trường
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionDriveCabinetOLTC,abnormal: model.conditionDriveCabinetOLTCAbnormal))
          Obx(()=>CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_6,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionDriveCabinetOLTCAbnormal,
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
            label:'1. ${HighElectricStrings.checkBonded}',
            allImage: _controller.getListImage(),
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_6),
            title: '1.6 ${HighElectricStrings.checkActuatorAndOltc}',
            checkListItem: [
              CheckModel(
                  value: model.stepCounterIndex,
                  title: 'Chỉ số bộ đếm nấc',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    if(_controller.triggerCounterIndexWarning==false)
                    {
                      _controller. triggerCounterIndexWarning= true;
                    }
                    model.stepCounterIndex =
                        value;
                  }),
              CheckModel(
                  value: _controller.stepCounterIndexValue.value.toString(),
                  title: 'Số lần chuyển nấc',
                  isNumber: true,
                  isRequired: true,
                  readOnly: true,
                  onChange: (value) {
                    model.numberTimesSwitchSteps =
                        value;
                  }),
            ],

            optionsDefaultValue:
            model.conditionDriveCabinetOLTC,
            onSelectChange: (value) {
              model.conditionDriveCabinetOLTC =
                  value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_6);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_6);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionDriveCabinetOLTCAbnormal =
                  value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_6,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_6, message: weirdoMessage));
            },
            defaultAbnormal:
            model.conditionDriveCabinetOLTCAbnormal,
            options: OptionsType.normal_weirdo.getOptions)),

        //1.7 Tình trạng tủ điều khiển, tủ đấu dây tại chỗ MBA = >Ok
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusControlCabinets,abnormal: model.statusControlCabinetsAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_7,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.statusControlCabinetsAbnormal,
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
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_7);
              return result;
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_7),
            title:
                '1.7 ${HighElectricStrings.checkElectricalCabinetTransformers}',
            optionsDefaultValue:
                model.statusControlCabinets,
            onSelectChange: (value) {
              model.statusControlCabinets =
                  value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_7);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_7);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusControlCabinetsAbnormal =
                  value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_7,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_7, message: weirdoMessage));
            },
            defaultAbnormal:
                model.statusControlCabinetsAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.8 Tình trạng hệ thống nối đất MBA => Ok
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusGroundingSystemTransformer,abnormal: model.statusGroundingSystemTransformerAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_8,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.statusGroundingSystemTransformerAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_8).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_8);
              return result;
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_8),
            title: '1.8 ${HighElectricStrings.checkGroundingTransformer}',
            optionsDefaultValue:
            model.statusGroundingSystemTransformer,
            onSelectChange: (value) {
              model.statusGroundingSystemTransformer = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_8);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_8);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusGroundingSystemTransformerAbnormal =
                  value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_8,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_8, message: weirdoMessage));
            },
            defaultAbnormal:
            model.statusGroundingSystemTransformerAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.9 Tình trạng Hệ thống quạt mát, phun sương MBA => OK
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionCoolingFanSystem,abnormal: model.conditionCoolingFanSystemAbnormal))
          CheckWidget(abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_9,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionCoolingFanSystemAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_9).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_9);
              return result;
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_9),
            title: '1.9 ${HighElectricStrings.checkMistingSystemTransformer}',
            optionsDefaultValue:
            model.conditionCoolingFanSystem,
            onSelectChange: (value) {
              model.conditionCoolingFanSystem =
                  value.toIntOrNull();
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model
                  .conditionCoolingFanSystemAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_9,
                description: value,
              ),isSetDescription: true);
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_9);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_9);
              }
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_9, message: weirdoMessage));
            },
            defaultAbnormal: _controller
                .dataModel.value.conditionCoolingFanSystemAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.10 Tình trạng Hệ thống quạt mát, phun sương MBA => OK
        // if(_controller.isMoreThan63kvA)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionMBACirculatingOilSystem,abnormal: model.conditionMBACirculatingOilSystemAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_10,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionMBACirculatingOilSystemAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_10).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_10);
              return result;
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_10),
            title: '1.10 Tình trạng Hệ thống bơm dầu tuần hoàn MBA (nếu có)',
            optionsDefaultValue:
            model.conditionMBACirculatingOilSystem,
            onSelectChange: (value) {
              model.conditionMBACirculatingOilSystem =
                  value.toIntOrNull();
            },
            invalid: false,
            isRequiredConclude: false,
            onChangeInput: (value) {
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_10,
                description: value,
              ),isSetDescription: true);
              model
                  .conditionMBACirculatingOilSystemAbnormal = value;
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_10);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_10);
              }
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_10, message: weirdoMessage));
            },
            defaultAbnormal: _controller
                .dataModel.value.conditionMBACirculatingOilSystemAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.11 Tình trạng hệ thống chữa cháy MBA =>Ok
        if(_controller.transformerTicketController.checkAbnormalNotify(model.checkFireProtectionSystem,abnormal: model.checkFireProtectionSystemAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_11,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.checkFireProtectionSystemAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_11).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_11);
              return result;
            },
            listImage: _controller.getImageByProblem(
                ImageProblems.muc1_11),
            title: '1.11 ${HighElectricStrings.checkFireSystemTransformer}',
            optionsDefaultValue:
            model.checkFireProtectionSystem,
            onSelectChange: (value) {
              model.checkFireProtectionSystem =
                  value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_11);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_11);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model
                  .checkFireProtectionSystemAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_11,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_11, message: weirdoMessage));
            },
            defaultAbnormal: _controller
                .dataModel.value.checkFireProtectionSystemAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.12.Nguy cơ gây sự cố khác (vật liệu công trường, cây đổ, vật lạ bay vào trạm…)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.riskCausingOtherIncidents,abnormal: model.riskCausingOtherIncidentsAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_12,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.riskCausingOtherIncidentsAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_12).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc1_12);
              return result;
            },
            listImage: _controller
                .getImageByProblem(ImageProblems.muc1_12),
            title: '1.12 ${HighElectricStrings.checkRiskOtherTransformer}',
            optionsDefaultValue:
                model.riskCausingOtherIncidents,
            onSelectChange: (value) {
              model.riskCausingOtherIncidents =
                  value.toIntOrNull();
              _controller.checkValidPattern(1);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_12);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_12);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.riskCausingOtherIncidentsAbnormal =
                  value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_12,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(WeirdoMessage(ImageProblems.muc1_12, message: weirdoMessage));
            },
            defaultAbnormal:
                model.riskCausingOtherIncidentsAbnormal,
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

