// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/isolation_knife_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../../../../../../common/constance/content_option.dart';
import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../../../models/option_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../isolation_knife_controller.dart';

Widget buildCheckBondedScreen(IsolationKnifeController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller?.dataModel?.value as IsolationKnifeModel;
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
      title: '1. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: _controller.dataModel.value.checkBonded,
          isDisable: true,
        ),
        // Vị trí dao cách ly
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: const TextSpan(
                  text: 'Vị trí dao cách ly',
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
              value: model.locationIsolators,
              padding: 0,
              onSelected: (value) {
                model.locationIsolators = value.toIntOrNull();
                _controller.checkValidPattern(1);
                _controller.viewRefresh();
              },
              invalid: _controller.invalid.value,
            ),
          ],
        ),

        //1.1.Áp lực khí SF6 (nếu là cách điện SF6)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.gasPressureSF6,abnormal: model.gasPressureSF6Abnormal))
          if (_controller.isGisOrHGis)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
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
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_1).abnormalId,

              widgetEx: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      text: const TextSpan(
                        text:
                        'Phân loại cách điện hoặc phân loại theo ngăn GIS',
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
                    OptionsType.isolation_knife_sf6.getOptions,
                    value: model.insulationClassificationGISCompartment,
                    padding: 0,
                    onSelected: (value) {
                      model.insulationClassificationGISCompartment =
                          value.toIntOrNull();
                      _controller.viewRefresh();
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
                await _controller.addImage(files, ImageProblems.muc1_1);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
              title: '1.1.Áp lực khí SF6',
              checkListItem: (model.insulationClassificationGISCompartment ==
                  ContentOptions.sf6.value)
                  ? [
                CheckModel(
                    value: model.phaseA.toString(),
                    title: HighElectricStrings.phaseA,
                    isNumber: true,
                    isRequired: true,
                    onChange: (value) {
                      model.phaseA = value.toDoubleOrNull();
                    }),
                CheckModel(
                    value: model.phaseB.toString(),
                    title: HighElectricStrings.phaseB,
                    isNumber: true,
                    isRequired: false,
                    onChange: (value) {
                      model.phaseB = value.toDoubleOrNull();
                    }),
                CheckModel(
                    value: model.phaseC.toString(),
                    title: HighElectricStrings.phaseC,
                    isNumber: true,
                    isRequired: false,
                    onChange: (value) {
                      model.phaseC = value.toDoubleOrNull();
                    }),
              ]
                  : [],
              optionsDefaultValue: model.gasPressureSF6,
              onSelectChange: (value) {
                model.gasPressureSF6 = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_1);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_1);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.gasPressureSF6Abnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_1,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_1,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.gasPressureSF6Abnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.2 Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.statusContactPoints,abnormal: model.statusContactPointsAbnormal))
          if (model.locationIsolators == ContentOptions.outSite.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. ${HighElectricStrings.checkBonded}',
                    description: model.statusContactPointsAbnormal,
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
              '${_controller.isGisOrHGis ? '1.2.' : '1.1.'}${HighElectricStrings.checkInsulatorAndOther}',
              optionsDefaultValue: model.statusContactPoints,
              onSelectChange: (value) {
                model.statusContactPoints = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_2);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.statusContactPointsAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_2,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_2,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.statusContactPointsAbnormal,
              options: OptionsType.normal_weirdo.getOptions),
        //1.3.Cấu trúc cơ khí và nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.mechanicalStructureGrounding,abnormal: model.mechanicalStructureGroundingAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
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
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_3).abnormalId,

              removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
              await _controller.addImage(files, ImageProblems.muc1_3);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
            title:
            '${model.locationIsolators == ContentOptions.outSite.value ? _controller.isGisOrHGis ? '1.3.' : '1.2.' : _controller.isGisOrHGis ? '1.2.' : '1.1.'}Cấu trúc cơ khí và nối đất',
            optionsDefaultValue: model.mechanicalStructureGrounding,
            onSelectChange: (value) {
              model.mechanicalStructureGrounding = value.toIntOrNull();
              _controller.checkValidPattern(1);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.mechanicalStructureGroundingAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            defaultAbnormal: model.mechanicalStructureGroundingAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //1.4.Tình trạng tủ truyền động (ATM, sấy, độ kín, đọng nước, motơ quay…)
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionTransmissionCabinet,abnormal: model.conditionTransmissionCabinetAbnormal))
          if (model.locationIsolators == ContentOptions.outSite.value)
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_4,
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
              initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc1_4).abnormalId,

              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result =
                await _controller.addImage(files, ImageProblems.muc1_4);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc1_4),
              title:
              '${_controller.isGisOrHGis ? '1.4.' : '1.3.'}${HighElectricStrings.checkActuatorCabinet}',
              optionsDefaultValue: model.conditionTransmissionCabinet,
              onSelectChange: (value) {
                model.conditionTransmissionCabinet = value.toIntOrNull();
                _controller.checkValidPattern(1);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc1_4);
                  model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.conditionTransmissionCabinetAbnormal = value;
                model.setAbnormal(Abnormals(
                  categoryIndex: ImageProblems.muc1_4,
                  description: value,
                ),isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc1_4,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.conditionTransmissionCabinetAbnormal,
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

