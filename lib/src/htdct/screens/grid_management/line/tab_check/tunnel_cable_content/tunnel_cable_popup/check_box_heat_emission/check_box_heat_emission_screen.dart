// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/line/popups/lighting_model.dart';
import '../../../../../../../models/line/popups/line_underground_cables_system_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../../../transformer/check_by_daytime/check_sheet/common/expansion_widget.dart';
import '../tunnel_cable_controller.dart';

Widget buildCableBoxHeatEmission(TunnelCableController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as LineUndergroundCablesSystem;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) {
        _controller.addImage(files, ImageProblems.muc2_0);
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc2_0),
      isHeader: true,
      isCamera: model.cableBoxHeatEmission !=
          OptionsType.normal_weirdo.getOptions.first.value,
      title: '2. Kiểm tra hộp nối cáp',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.cableBoxHeatEmission,
          isDisable: true,
        ),
        // Hệ số phát xạ nhiệt hộp cáp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cableBoxHeatEmissionCoefficientMaterialOptions,abnormal: model.cableBoxHeatEmissionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_1,
                    childCategory: title,
                    parentCategory: '2. Kiểm tra hộp nối cáp',
                    description: model.cableBoxHeatEmissionAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_1).abnormalId,

              widgetEx: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text('Chọn vật liệu phát nhiệt', style: Styles.titleTextField,),
                ),
                ESingleDropDown(
                  OptionsType.coefficient_material.getOptions,
                  value: model.cableBoxHeatEmissionCoefficient,
                  padding: 0,
                  onSelected: (value) {
                     model.cableBoxHeatEmissionCoefficient = value.toIntOrNull();
                     _controller.changeCoefficientMaterial();
                  },
                ),
              ],
            ),
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc2_1);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_1),
            title: '2.1 Hệ số phát xạ nhiệt hộp cáp',
            checkListItem: [
              CheckModel(
                  readOnly: true,
                  value: model.cableBoxHeatEmissionCoefficientMaterial.toString(),
                  title: 'Hệ số',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.cableBoxHeatEmissionCoefficientMaterial = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.cableBoxHeatEmissionCoefficientMaterialOptions,
            //model.violationUndergroundCableSafetyCorridor,
            onSelectChange: (value) {
              model.cableBoxHeatEmissionCoefficientMaterialOptions = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cableBoxHeatEmissionAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_1, message: weirdoMessage));
            },
            defaultAbnormal: model.cableBoxHeatEmissionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Nhiệt độ đo (ºC)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.measuringTemperature,abnormal: model.measuringTemperatureAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_2,
                    childCategory: title,
                    parentCategory: '2. Kiểm tra hộp nối cáp',
                    description: model.measuringTemperatureAbnormal,
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
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc2_2);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_2),
            title: '2.2 Nhiệt độ đo (ºC)',
            checkListItem: [
              CheckModel(
                  value: model.measuringTemperaturePhaseA.toString(),
                  title: HighElectricStrings.phaseA,
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.measuringTemperaturePhaseA = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.measuringTemperaturePhaseB.toString(),
                  title: HighElectricStrings.phaseB,
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.measuringTemperaturePhaseB = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.measuringTemperaturePhaseC.toString(),
                  title: HighElectricStrings.phaseC,
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.measuringTemperaturePhaseC = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.measuringTemperature,
            onSelectChange: (value) {
              model.measuringTemperature = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.measuringTemperatureAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_2, message: weirdoMessage));
            },
            defaultAbnormal: model.measuringTemperatureAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Nhiệt độ thực (ºC)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.actualTemperature,abnormal: model.actualTemperatureAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_3,
                    childCategory: title,
                    parentCategory: '2. Kiểm tra hộp nối cáp',
                    description: model.actualTemperatureAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_3).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc2_3);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_3),
            title: '2.3 Nhiệt độ thực (ºC)',
            checkListItem: [
              CheckModel(
                  value: model.actualTemperaturePhaseA.toString(),
                  title: HighElectricStrings.phaseA,
                  isNumber: true,
                  isRequired: false,
                  readOnly: true,
                  onChange: (value) {
                    model.actualTemperaturePhaseA = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.actualTemperaturePhasB.toString(),
                  title: HighElectricStrings.phaseB,
                  isNumber: true,
                  isRequired: false,
                  readOnly: true,
                  onChange: (value) {
                    model.actualTemperaturePhasB = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.actualTemperaturePhasC.toString(),
                  title: HighElectricStrings.phaseC,
                  isNumber: true,
                  isRequired: false,
                  readOnly: true,
                  onChange: (value) {
                    model.actualTemperaturePhasC = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.actualTemperature,
            onSelectChange: (value) {
              model.actualTemperature = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.actualTemperatureAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_3, message: weirdoMessage));
            },
            defaultAbnormal: model.actualTemperatureAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
      ],
    );
  }

  return _buildHeader();
}

