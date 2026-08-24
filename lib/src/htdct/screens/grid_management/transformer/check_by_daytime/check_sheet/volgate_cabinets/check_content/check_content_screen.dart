// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../common/constance/content_option.dart';
import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/day_night/popups/voltage_cabinet_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../volgate_cabinets_controller.dart';

Widget buildCheckContentScreen(VoltageCabinetController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as VoltageCabinetModel;
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
      isCamera: _controller.isNotMultiCopy(),
      title: '1. ${HighElectricStrings.check}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkVoltageCabinets,
          isDisable: true,
        ),
        // Vị trí dao cách ly
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'Loại tủ',
                style: Styles.titleTextField,
              ),
            ),
            ESingleDropDown(
              OptionsType.electrical_cabinet.getOptions,
              value: model.cabinetsType,
              padding: 0,
              onSelected: (value) {
                model.setCabinType(value.toIntOrNull());
                _controller.checkValidPattern(1);
                _controller.viewRefresh();
              },
            ),
          ],
        ),

        //1.1. Tình trạng đèn chỉ thị trạng thái, thông số mặt tủ
        if(_controller.transformerTicketController.checkAbnormalNotify( model.statusIndicatorLights,abnormal: model.statusIndicatorLightsAbnormal))
        if (model.cabinetsType != ContentOptions.CtElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.statusIndicatorLightsAbnormal,
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
              title: '1.1.Tình trạng đèn chỉ thị trạng thái, thông số mặt tủ ',
              optionsDefaultValue: model.statusIndicatorLights,
              onSelectChange: (value) {
                model.statusIndicatorLights = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_1);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.statusIndicatorLightsAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_1,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_1,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.statusIndicatorLightsAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.2. Tình trạng tủ (tiếng kêu, phát nhiệt, ATM …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.cabinetStatus,abnormal: model.cabinetStatusAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.check}',
                  description: model.cabinetStatusAbnormal,
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
            title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.2.':'1.1.'}Tình trạng tủ (tiếng kêu, phát nhiệt, ATM …)',
            optionsDefaultValue: model.cabinetStatus,
            onSelectChange: (value) {
              model.cabinetStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cabinetStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.cabinetStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.3. Tình trạng hệ thống mạch sấy, chiếu sáng
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionDryingLighting,abnormal: model.conditionDryingLightingAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.conditionDryingLightingAbnormal,
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
            title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.3.':'1.2.'}Tình trạng hệ thống mạch sấy, chiếu sáng',
            optionsDefaultValue: model.conditionDryingLighting,
            onSelectChange: (value) {
              model.conditionDryingLighting = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionDryingLightingAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            defaultAbnormal: model.conditionDryingLightingAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.4. Tình trạng mạch, hàng kẹp, ATM (phát nhiệt, lỏng, …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.circuitStatusClampATM,abnormal: model.circuitStatusClampATMAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_4,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.circuitStatusClampATMAbnormal,
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
            title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.4.':'1.3.'}Tình trạng mạch, hàng kẹp, ATM (phát nhiệt, lỏng, …)',
            optionsDefaultValue: model.circuitStatusClampATM,
            onSelectChange: (value) {
              model.circuitStatusClampATM = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.circuitStatusClampATMAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
            },
            defaultAbnormal: model.circuitStatusClampATMAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.5. Tình trạng chống nước; động vật lạ xâm nhập.
        if(_controller.transformerTicketController.checkAbnormalNotify(model.waterproofStatus,abnormal: model.waterproofStatusAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_5,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.waterproofStatusAbnormal,
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
            listImage: _controller.getImageByProblem(ImageProblems.muc1_5),
            title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.5.':'1.4.'}Tình trạng chống nước; động vật lạ xâm nhập.',
            optionsDefaultValue: model.waterproofStatus,
            onSelectChange: (value) {
              model.waterproofStatus = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.waterproofStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_5,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_5, message: weirdoMessage));
            },
            defaultAbnormal: model.waterproofStatusAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.6. Kiểm tra hệ thống nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.checkGroundingSystem,abnormal: model.checkGroundingSystemAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_6,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.checkGroundingSystemAbnormal,
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
            listImage: _controller.getImageByProblem(ImageProblems.muc1_6),
            title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.6.':'1.5.'}Kiểm tra hệ thống nối đất',
            optionsDefaultValue: model.checkGroundingSystem,
            onSelectChange: (value) {
              model.checkGroundingSystem = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_6);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_6);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.checkGroundingSystemAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_6,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_6, message: weirdoMessage));
            },
            defaultAbnormal: model.checkGroundingSystemAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.7. Tình trạng vệ sinh công nghiệp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.stateIndustrialHygiene,abnormal: model.stateIndustrialHygieneAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_7,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.stateIndustrialHygieneAbnormal,
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
            listImage: _controller.getImageByProblem(ImageProblems.muc1_7),
            title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.7.':'1.6.'}Tình trạng vệ sinh công nghiệp',
            optionsDefaultValue: model.stateIndustrialHygiene,
            onSelectChange: (value) {
              model.stateIndustrialHygiene = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_7);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_7);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.stateIndustrialHygieneAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_7,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_7, message: weirdoMessage));
            },
            defaultAbnormal: model.stateIndustrialHygieneAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.8. Điện áp thanh cái DC
        if(_controller.transformerTicketController.checkAbnormalNotify(model.busbarVoltageDC, abnormal:model.busbarVoltageDCAbnormal ))
          if (model.cabinetsType == ContentOptions.DcElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_8,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.busbarVoltageDCAbnormal,
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
              listImage: _controller.getImageByProblem(ImageProblems.muc1_8),
              title: '${model.cabinetsType != ContentOptions.CtElectricCabinet.value?'1.8.':'1.7.'}Thông số vận hành tủ DC',
              checkListItem: [
                CheckModel(
                    value: model.dC1Plus.toString(),
                    title: 'DC+',
                    isNumber: true,
                    isRequired: true,
                    onChange: (value) {
                      model.dC1Plus = value.toDoubleOrNull();
                      _controller.triggerAutoUpdateAbnormal = true;
                    }),
                CheckModel(
                    value: model.dC1Subtract.toString(),
                    title: 'DC-',
                    isNumber: true,
                    isRequired: true,
                    onChange: (value) {
                      model.dC1Subtract = value.toDoubleOrNull();
                      _controller.triggerAutoUpdateAbnormal = true;
                    }),
              ],
              optionsDefaultValue: model.busbarVoltageDC,
              onSelectChange: (value) {
                model.busbarVoltageDC = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_8);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_8);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.busbarVoltageDCAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_8,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_8,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.busbarVoltageDCAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.busbarVoltageAC,abnormal: model.busbarVoltageACAbnormal))
          if (model.cabinetsType == ContentOptions.AcElectricCabinet.value)
          Obx(() {
            if(_controller.degreeDifferenceValue.value != null) {}
            return CheckWidget(
                abnormalOptions: _controller.abnormalOptions,
                onSelectedAbnormalOption: ({value, title}) {
                  model.setAbnormal(
                    Abnormals(
                      abnormalId: value,
                      categoryIndex: ImageProblems.muc1_9,
                      childCategory: title,
                      parentCategory: '1. ${HighElectricStrings.check}',
                      description: model.busbarVoltageACAbnormal,
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
                listImage: _controller.getImageByProblem(ImageProblems.muc1_9),
                title: '1.8.Thông số vận hành tủ AC',
                checkListItem: [
                  CheckModel(
                      value: _controller.degreeDifferenceValue.value.toString(),
                      title: 'Mức độ chênh lệch',
                      isNumber: true,
                      isRequired: true,
                      readOnly: true,
                      onChange: (value) {
                        model.degreeDifference = value.toDoubleOrNull();
                        _controller.triggerAutoUpdateAbnormal = true;
                      }),
                  CheckModel(
                      value: model.ia.toString(),
                      title: 'Ia',
                      isNumber: true,
                      isRequired: true,
                      onChange: (value) {
                        model.ia = value.toDoubleOrNull();
                        _controller.triggerAutoUpdateAbnormal = true;
                      }),
                  CheckModel(
                      value: model.ib.toString(),
                      title: 'Ib',
                      isNumber: true,
                      isRequired: true,
                      onChange: (value) {
                        model.ib = value.toDoubleOrNull();
                        _controller.triggerAutoUpdateAbnormal = true;
                      }),
                  CheckModel(
                      value: model.ic.toString(),
                      title: 'Ic',
                      isNumber: true,
                      isRequired: true,
                      onChange: (value) {
                        model.ic = value.toDoubleOrNull();
                        _controller.triggerAutoUpdateAbnormal = true;
                      }),
                  CheckModel(
                      value: model.utb.toString(),
                      title: 'Utb',
                      isNumber: true,
                      isRequired: true,
                      onChange: (value) {
                        model.utb = value.toDoubleOrNull();
                        _controller.triggerAutoUpdateAbnormal = true;
                      }),
                ],
                optionsDefaultValue: model.busbarVoltageAC,
                onSelectChange: (value) {
                  model.busbarVoltageAC = value.toIntOrNull();
                  _controller.checkValidPattern(1);
                  if (value.toIntOrNull() ==
                      OptionsType.normal_weirdo.getOptions.first.value) {
                    _controller.removeImageOfProblem(ImageProblems.muc1_9);
                    model.removeAbnormal(categoryIndex:ImageProblems.muc1_9);
                  }
                },
                invalid: _controller.invalid.value,
                onChangeInput: (value) {
                  model.busbarVoltageACAbnormal = value;
                  model.setAbnormal(Abnormals(
                    categoryIndex: ImageProblems.muc1_9,
                    description: value,
                  ),isSetDescription: true);
                },
                onChangeWeirdoMessage: (weirdoMessage) {
                  model.setUnusually(WeirdoMessage(ImageProblems.muc1_9,
                      message: weirdoMessage));
                },
                defaultAbnormal: model.busbarVoltageACAbnormal,
                options: OptionsType.normal_weirdo.getOptions);
          }),
        //1.10. Tình trạng nguồn hoạt động của bo mạch chính
        if(_controller.transformerTicketController.checkAbnormalNotify(model.mainBoardOperatingStatus,abnormal: model.mainBoardOperatingStatusAbnormal))
          if (model.cabinetsType == ContentOptions.ScadaElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_10,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.mainBoardOperatingStatusAbnormal,
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
              listImage: _controller.getImageByProblem(ImageProblems.muc1_10),
              title: '1.8.Tình trạng nguồn hoạt động của bo mạch chính',
              optionsDefaultValue: model.mainBoardOperatingStatus,
              onSelectChange: (value) {
                model.mainBoardOperatingStatus = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_10);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_10);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.mainBoardOperatingStatusAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_10,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_10,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.mainBoardOperatingStatusAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.11. Tình trạng các đèn báo trạng thái vận hành card mở rộng
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusExpansionCardOperatingStatus,abnormal: model.statusExpansionCardOperatingStatusAbnormal))
          if (model.cabinetsType == ContentOptions.ScadaElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_11,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.statusExpansionCardOperatingStatusAbnormal,
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
              listImage: _controller.getImageByProblem(ImageProblems.muc1_11),
              title:
                  '1.9.Tình trạng các đèn báo trạng thái vận hành card mở rộng',
              optionsDefaultValue: model.statusExpansionCardOperatingStatus,
              onSelectChange: (value) {
                model.statusExpansionCardOperatingStatus = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_11);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_11);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.statusExpansionCardOperatingStatusAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_11,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_11,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.statusExpansionCardOperatingStatusAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.12. Tình trạng hệ thống HMI, SERVER, Switch mạng, GPS
        if(_controller.transformerTicketController.checkAbnormalNotify(model.systemStatusHMIServerNetworkSwitchGPS,abnormal: model.systemStatusHMIServerNetworkSwitchGPSAbnormal))
          if (model.cabinetsType == ContentOptions.ScadaElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_12,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.systemStatusHMIServerNetworkSwitchGPSAbnormal,
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
              listImage: _controller.getImageByProblem(ImageProblems.muc1_12),
              title: '1.10.Tình trạng hệ thống HMI, SERVER, Switch mạng, GPS',
              optionsDefaultValue: model.systemStatusHMIServerNetworkSwitchGPS,
              onSelectChange: (value) {
                model.systemStatusHMIServerNetworkSwitchGPS =
                    value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_12);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_12);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.systemStatusHMIServerNetworkSwitchGPSAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_12,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_12,
                    message: weirdoMessage));
              },
              defaultAbnormal:
                  model.systemStatusHMIServerNetworkSwitchGPSAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.13. Tình trạng kẹp chì tủ, kẹp chì công tơ
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusCabinetLeadClamp,abnormal: model.statusCabinetLeadClampAbnormal))
          if (model.cabinetsType == ContentOptions.CtElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_13,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.statusCabinetLeadClampAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_13).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result = await _controller.addImage(files, ImageProblems.muc1_13);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_13),
              title: '${model.cabinetsType == ContentOptions.CtElectricCabinet.value?'1.7.':'1.13.'}Tình trạng kẹp chì tủ, kẹp chì công tơ',
              optionsDefaultValue: model.statusCabinetLeadClamp,
              onSelectChange: (value) {
                model.statusCabinetLeadClamp = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_13);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_13);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.statusCabinetLeadClampAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_13,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_13,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.statusCabinetLeadClampAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.14. Tình trạng đèn chỉ thị trạng thái, thông số mặt các công tơ
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusIndicatorLightsParameters,abnormal: model.statusIndicatorLightsParametersAbnormal))
          if (model.cabinetsType == ContentOptions.CtElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_14,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.statusIndicatorLightsParametersAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_14).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result = await _controller.addImage(files, ImageProblems.muc1_14);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_14),
              title:
                  '${model.cabinetsType == ContentOptions.CtElectricCabinet.value?'1.8.':'1.14.'}Tình trạng đèn chỉ thị trạng thái, thông số mặt các công tơ',
              optionsDefaultValue: model.statusIndicatorLightsParameters,
              onSelectChange: (value) {
                model.statusIndicatorLightsParameters = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_14);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_14);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.statusIndicatorLightsParametersAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_14,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_14,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.statusIndicatorLightsParametersAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.15. Tình trạng HT chiếu sáng ngoài trời
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusOutdoorLightingHT,abnormal: model.statusOutdoorLightingHTAbnormal))
          if (model.cabinetsType == ContentOptions.MkElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_15,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.statusOutdoorLightingHTAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_15).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result = await _controller.addImage(files, ImageProblems.muc1_15);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_15),
              title: '1.8.Tình trạng HT chiếu sáng ngoài trời',
              optionsDefaultValue: model.statusOutdoorLightingHT,
              onSelectChange: (value) {
                model.statusOutdoorLightingHT = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_15);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_15);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.statusOutdoorLightingHTAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_15,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_15,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.statusOutdoorLightingHTAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.16. Tình trạng làm việc của thiết bị Merging Unit (nếu có)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.workingStatusMergingUnit,abnormal: model.workingStatusMergingUnitAbnormal))
          if (model.cabinetsType == ContentOptions.MkElectricCabinet.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_16,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.check}',
                    description: model.workingStatusMergingUnitAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_16).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result = await _controller.addImage(files, ImageProblems.muc1_16);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_16),
              title:
                  '1.9.Tình trạng làm việc của thiết bị Merging Unit (nếu có)',
              optionsDefaultValue: model.workingStatusMergingUnit,
              onSelectChange: (value) {
                model.workingStatusMergingUnit = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_16);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_16);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.workingStatusMergingUnitAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_16,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_16,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.workingStatusMergingUnitAbnormal,
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

