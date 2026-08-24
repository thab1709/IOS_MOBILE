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

Widget buildLinkBox(TunnelCableController _controller) {
  Widget _buildHeader() // Kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as LineUndergroundCablesSystem;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) {
        _controller.addImage(files, ImageProblems.muc3_0);
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc3_0),
      isHeader: true,
      isCamera: model.linkboxCableHeatEmission !=
          OptionsType.normal_weirdo.getOptions.first.value,
      title: '3. Hộp linkbox',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.linkboxCableHeatEmission,
          isDisable: true,
        ),
        // Hệ số phát xạ nhiệt cáp linkbox
        if(_controller.transformerTicketController.checkAbnormalNotify(model.linkboxCableHeatEmissionCoefficientOptions,abnormal: model.linkboxCableHeatEmissionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc3_1,
                    childCategory: title,
                    parentCategory: '3. Hộp linkbox',
                    description: model.linkboxCableHeatEmissionAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc3_1).abnormalId,

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
                  value: model.linkboxCableHeatEmissionMaterial,
                  padding: 0,
                  onSelected: (value) {
                    model.linkboxCableHeatEmissionMaterial = value.toIntOrNull();
                    _controller.changeCoefficientMaterial();
                  },
                ),
              ],
            ),
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc3_1);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc3_1),
            title: '3.1 Hệ số phát xạ nhiệt cáp linkbox',
            checkListItem: [
              CheckModel(
                  readOnly: true,
                  value: model.linkboxCableHeatEmissionCoefficient.toString(),
                  title: 'Hệ số',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.linkboxCableHeatEmissionCoefficient = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.linkboxCableHeatEmissionCoefficientOptions,
            //model.violationUndergroundCableSafetyCorridor,
            onSelectChange: (value) {
              model.linkboxCableHeatEmissionCoefficientOptions = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc3_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc3_1);
                model.removeAbnormal(categoryIndex:ImageProblems.muc3_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.linkboxCableHeatEmissionAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc3_1,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc3_1, message: weirdoMessage));
            },
            defaultAbnormal: model.linkboxCableHeatEmissionAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Nhiệt độ cáp linkbox (ºC)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.linkboxCableTemperature,abnormal: model.linkboxCableTemperatureAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc3_2,
                    childCategory: title,
                    parentCategory: '3. Hộp linkbox',
                    description: model.linkboxCableTemperatureAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc3_2).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc3_2);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc3_2),
            title: '3.2 Nhiệt độ cáp linkbox (ºC)',
            checkListItem: [
              CheckModel(
                  value: model.linkboxCableTemperaturePhaseA.toString(),
                  title: HighElectricStrings.phaseA,
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.linkboxCableTemperaturePhaseA = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.linkboxCableTemperaturePhaseB.toString(),
                  title: HighElectricStrings.phaseB,
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.linkboxCableTemperaturePhaseB = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.linkboxCableTemperaturePhaseC.toString(),
                  title: HighElectricStrings.phaseC,
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.linkboxCableTemperaturePhaseC = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.linkboxCableTemperatureGrounding.toString(),
                  title: 'Nối đất',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.linkboxCableTemperatureGrounding = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.linkboxCableTemperature,
            onSelectChange: (value) {
              model.linkboxCableTemperature = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc3_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc3_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc3_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.linkboxCableTemperatureAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc3_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc3_2, message: weirdoMessage));
            },
            defaultAbnormal: model.linkboxCableTemperatureAbnormal,
            options: OptionsType.normal_weirdo.getOptions),

        // Nhiệt độ thực (ºC)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cableSheathInducedMeasurement,abnormal: model.cableSheathInducedMeasurementAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc3_3,
                    childCategory: title,
                    parentCategory: '3. Hộp linkbox',
                    description: model.cableSheathInducedMeasurementAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc3_3).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) {
              _controller.addImage(files, ImageProblems.muc3_3);
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc3_3),
            title: '3.3 Đo dòng cảm ứng vỏ cáp (A)',
            checkListItem: [
              CheckModel(
                  value: model.cableSheathInducedMeasurementPhaseA.toString(),
                  title: HighElectricStrings.phaseA,
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.cableSheathInducedMeasurementPhaseA = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.cableSheathInducedMeasurementPhaseB.toString(),
                  title: HighElectricStrings.phaseB,
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.cableSheathInducedMeasurementPhaseB = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.cableSheathInducedMeasurementPhaseC.toString(),
                  title: HighElectricStrings.phaseC,
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.cableSheathInducedMeasurementPhaseC = value.toDoubleOrNull();
                  }),
              CheckModel(
                  value: model.cableSheathInducedMeasurementGrounding.toString(),
                  title: 'Nối đất',
                  isNumber: true,
                  isRequired: true,
                  onChange: (value) {
                    model.cableSheathInducedMeasurementGrounding = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.cableSheathInducedMeasurement,
            onSelectChange: (value) {
              model.cableSheathInducedMeasurement = int.parse(value);
              _controller.checkValidPattern(ImageProblems.muc3_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc3_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc3_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cableSheathInducedMeasurementAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc3_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc3_3, message: weirdoMessage));
            },
            defaultAbnormal: model.cableSheathInducedMeasurementAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
      ],
    );
  }

  return _buildHeader();
}

