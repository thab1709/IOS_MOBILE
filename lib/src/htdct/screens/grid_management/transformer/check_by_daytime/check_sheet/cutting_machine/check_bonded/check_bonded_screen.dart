// @dart=2.9
import 'dart:io';

import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/cutting_machine_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/cutting_machine/cutting_machine_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/content_option.dart';
import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';

Widget buildCheckBondedScreen(CuttingMachineController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as CuttingMachineModel;
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
          value: _controller.dataModel.value.checkBonded,
          isDisable: true,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: const TextSpan(
                text: 'Vị trí máy cắt',
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
            ESingleDropDown(
              OptionsType.location.getOptions,
              value: _controller.dataModel.value.cutterPosition,
              onSelected: (value) {
                model.cutterPosition = value.toIntOrNull();
                _controller.checkValidPattern(1);
                _controller.refreshView();
              },
              invalid: _controller.invalid.value,
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: const TextSpan(
                  text: 'Phân loại cách điện hoặc phân loại theo ngăn GIS',
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
              OptionsType.cutting_sf6.getOptions,
              value: model.insulationClassificationGISCompartment,
              padding: 0,
              onSelected: (value) {
                model.insulationClassificationGISCompartment =
                    value.toIntOrNull();
                _controller.refreshView();
              },
              invalid: _controller.invalid.value,
            ),
          ],
        ),
        //1.7.Áp lực khí SF6 (nếu là cách điện SF6)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.gasPressureSF6,abnormal: model.gasPressureSF6Abnormal))
          if (model.insulationClassificationGISCompartment !=
            ContentOptions.vacuum.value)
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_7,
                  childCategory: title,
                  parentCategory: '1. ${HighElectricStrings.checkBonded}',
                  description: model.gasPressureSF6Abnormal,
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
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_7);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_7),
            title: '1.1.Áp lực khí SF6',
            checkListItem:  [
                    CheckModel(
                        value: model.phaseA.toString(),
                        title: 'Pha A/ chung',
                        isNumber: false,
                        isRequired: true,
                        onChange: (value) {
                          model.phaseA = value;
                        }),
                    CheckModel(
                        value: model.phaseB.toString(),
                        title: 'Pha B (Nếu có đồng hồ đo)',
                        isNumber: false,
                        isRequired: false,
                        onChange: (value) {
                          model.phaseB = value;
                        }),
                    CheckModel(
                        value: model.phaseC.toString(),
                        title: 'Pha C (Nếu có đồng hồ đo)',
                        isNumber: false,
                        isRequired: false,
                        onChange: (value) {
                          model.phaseC = value;
                        }),
                  ],
            optionsDefaultValue: model.gasPressureSF6,
            onSelectChange: (value) {
              model.gasPressureSF6 = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_7);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_7);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.gasPressureSF6Abnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_7,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_7, message: weirdoMessage));
            },
            defaultAbnormal: model.gasPressureSF6Abnormal,
            options: OptionsType.normal_weirdo.getOptions),

        //1.1 Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionContactPoints,abnormal: model.conditionContactPointsAbnormal))
          if (model.cutterPosition == ContentOptions.outSite.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionContactPointsAbnormal,
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
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_1);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
              title: '${model.insulationClassificationGISCompartment !=
                  ContentOptions.vacuum.value?'1.2.':'1.1.'} ${HighElectricStrings.checkInsulatorAndOther}',
              optionsDefaultValue: model.conditionContactPoints,
              onSelectChange: (value) {
                model.conditionContactPoints = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_1);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.conditionContactPointsAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_1,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_1,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.conditionContactPointsAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.2.Tình trạng tủ truyền động (ATM, sấy, độ kín, chỉ danh thiết bị, vị trí khóa điều khiển …)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionTransmissionCabinet,abnormal: model.conditionTransmissionCabinetAbnormal))
          if (model.cutterPosition == ContentOptions.outSite.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionTransmissionCabinetAbnormal,
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
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_2);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
              title:
                  '${model.insulationClassificationGISCompartment !=
                      ContentOptions.vacuum.value?'1.3.':'1.2.'}Tình trạng tủ truyền động (ATM, sấy, độ kín, chỉ danh thiết bị, vị trí khóa điều khiển …)',
              optionsDefaultValue: model.conditionTransmissionCabinet,
              onSelectChange: (value) {
                model.conditionTransmissionCabinet = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.good_bad.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_2);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.conditionTransmissionCabinetAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_2,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_2,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.conditionTransmissionCabinetAbnormal,
              options: OptionsType.good_bad.getOptions),
        //1.3.Tình trạng hệ thống hút ẩm khoang cáp (nếu có)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionCableCompartment,abnormal: model.conditionCableCompartmentAbnormal))
          if (model.cutterPosition == ContentOptions.inSite.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.conditionCableCompartmentAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_3).abnormalId,

              widgetEx: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Chế độ vận hành',
                      style: Styles.titleTextField,
                    ),
                  ),
                  ESingleDropDown(
                    OptionsType.status_operation_cutting_machine.getOptions,
                    value: model.operationMode,
                    padding: 0,
                    onSelected: (value) {
                      model.operationMode = value.toIntOrNull();
                      if(value.toIntOrNull() == ContentOptions.nothing.value && model.conditionCableCompartment != ContentOptions.normal.value)
                        {
                          model.conditionCableCompartment = ContentOptions.normal.value;
                          _controller.removeImageOfProblem(ImageProblems.muc1_3);
                          model.conditionCableCompartmentAbnormal='';
                          _controller.refreshView();
                        }
                    },
                    invalid: false,
                  ),
                ],
              ),
              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_3);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
              title: '${model.insulationClassificationGISCompartment !=
                  ContentOptions.vacuum.value?'1.2.':'1.1.'}Tình trạng hệ thống hút ẩm khoang cáp (nếu có)',
              optionsDefaultValue: model.conditionCableCompartment,
              onSelectChange: (value) {
                model.conditionCableCompartment = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_3);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.conditionCableCompartmentAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_3,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_3,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.conditionCableCompartmentAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.4.Tình trạng phòng phân phối
        if(_controller.transformerTicketController.checkAbnormalNotify(model.distributionRoomStatus,abnormal: model.distributionRoomStatusAbnormal))
          if (model.cutterPosition == ContentOptions.inSite.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_4,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.distributionRoomStatusAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_4).abnormalId,

              widgetEx: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      text: const TextSpan(
                        text: 'Quạt thông gió',
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
                    OptionsType.status_operation.getOptions,
                    value: model.ventilators,
                    padding: 0,
                    onSelected: (value) {
                      model.ventilators = value.toIntOrNull();
                    },
                    invalid: _controller.invalid.value,
                  ),
                ],
              ),
              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result =
                    await _controller.addImage(files, ImageProblems.muc1_4);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_4),
              title: '${model.insulationClassificationGISCompartment !=
                  ContentOptions.vacuum.value?'1.3.':'1.2.'}Tình trạng phòng phân phối',
              optionsDefaultValue: model.distributionRoomStatus,
              onSelectChange: (value) {
                model.distributionRoomStatus = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_4);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
                }
              },
              checkListItem: [
                CheckModel(
                    value: model.temperature.toString(),
                    title: 'Nhiệt độ (oC)',
                    isNumber: true,
                    isRequired: true,
                    readOnly: false,
                    onChange: (value) {
                      model.temperature = value.toDoubleOrNull();
                    }),
                CheckModel(
                    value: model.humidity.toString(),
                    title: 'Độ ẩm (%)',
                    isNumber: true,
                    isRequired: true,
                    readOnly: false,
                    onChange: (value) {
                      model.humidity = value.toDoubleOrNull();
                    }),
              ],
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.distributionRoomStatusAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_4,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_4,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.distributionRoomStatusAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.5 Cấu trúc cơ khí và nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.mechanicalStructureGrounding,abnormal: model.mechanicalStructureGroundingAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_5,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.mechanicalStructureGroundingAbnormal,
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
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_5);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_5),
            title:
                '${_controller.getTitleMechanicalStructureGrounding(0).toString()}.${HighElectricStrings.checkMechanicalStructureAndGrounding}',
            optionsDefaultValue: model.mechanicalStructureGrounding,
            onSelectChange: (value) {
              model.mechanicalStructureGrounding = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.mechanicalStructureGroundingAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_5,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_5, message: weirdoMessage));
            },
            defaultAbnormal: model.mechanicalStructureGroundingAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.6.Tình trạng vệ sinh công nghiệp
        if(_controller.transformerTicketController.checkAbnormalNotify(model.stateIndustrialHygiene,abnormal: model.stateIndustrialHygieneAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_6,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.stateIndustrialHygieneAbnormal,
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
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_6);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_6),
            title:
                '${_controller.getTitleMechanicalStructureGrounding(0.1).toString()}.Tình trạng vệ sinh công nghiệp',
            optionsDefaultValue: model.stateIndustrialHygiene,
            onSelectChange: (value) {
              model.stateIndustrialHygiene = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_6);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_6);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.stateIndustrialHygieneAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_6,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_6, message: weirdoMessage));
            },
            defaultAbnormal: model.stateIndustrialHygieneAbnormal,
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

