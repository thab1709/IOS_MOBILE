// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/tu_model.dart';
import 'package:evnmobile/src/htdct/models/weirdo_message.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../tu_controller.dart';

Widget CheckBondedScreen(TUController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller.dataModel.value as TUModel;
    return ExpansionWidget(
      allImage: _controller.getListImage(),
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc2_0);
        return result;
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc2_0),
      isHeader: true,
      isCamera: _controller.isNotMultiCopy(),
      title: '2. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        //vị trí TU
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: const TextSpan(
                  text: 'Vị trí TU',
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
              value: model.tuLocation,
              padding: 0,
              onSelected: (value) {
                model.tuLocation = value.toIntOrNull();
                _controller.checkValidPattern(ImageProblems.muc2_0);
                _controller.viewRefresh();
              },
              invalid: _controller.invalid.value,
            ),
          ],
        ),
        //2.2. Áp lực khí SF6
        if(_controller.transformerTicketController.checkAbnormalNotify(model.gasPressurSF6,abnormal: model.gasPressurSF6Abnormal))
        CheckWidget(
          abnormalOptions: _controller.abnormalOptions,
          onSelectedAbnormalOption: ({value, title}) {
            model.setAbnormal(
              Abnormals(
                abnormalId: value,
                categoryIndex: ImageProblems.muc2_2,
                childCategory: title,
                parentCategory: '2. ${HighElectricStrings.checkBonded}',
                description: model.gasPressurSF6Abnormal,
              ),
            );
            _controller.viewRefresh();
          },
          addAbnormalOption: (value) async {
            await _controller.addAbnormalOption(name: value);
          },
          initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_2).abnormalId,

          widgetEx: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: RichText(
                  text: const TextSpan(
                    text: 'Phân loại cách điện',
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
                OptionsType.tu_sf6.getOptions,
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
          checkListItem: [
            if(model.insulationClassificationGISCompartment == ContentOptions.sf6.value)
              CheckModel(
                value: model.p.toString(),
                title: "Áp lực khí",
                isNumber: true,
                isRequired: true,
                readOnly: false,
                onChange: (value) {
                  model.p = value.toDoubleOrNull();
                },
              ),
          ],
          removeImage: (file) {
            _controller.removeImage(file);
          },
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc2_2);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc2_2),
          title: '2.1.Áp lực khí SF6',
          optionsDefaultValue: model.gasPressurSF6,
          onSelectChange: (value) {
            model.gasPressurSF6 = value.toIntOrNull();
            _controller.checkValidPattern(ImageProblems.muc2_0);
            if (value.toIntOrNull() ==
                OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc2_2);
              model.removeAbnormal(categoryIndex:ImageProblems.muc2_2);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.gasPressurSF6Abnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc2_2,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc2_2, message: weirdoMessage));
          },
          defaultAbnormal: model.gasPressurSF6Abnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),
        //2.1.Tình trạng mức dầu cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.insulationOilLevelStatus,abnormal: model.insulationOilLevelStatusAbnormal))
        if(_controller.checkOutsite())
        CheckWidget(
          abnormalOptions: _controller.abnormalOptions,
          onSelectedAbnormalOption: ({value, title}) {
            model.setAbnormal(
              Abnormals(
                abnormalId: value,
                categoryIndex: ImageProblems.muc2_1,
                childCategory: title,
                parentCategory: '2. ${HighElectricStrings.checkBonded}',
                description: model.insulationOilLevelStatusAbnormal,
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
          listImage: _controller.getImageByProblem(ImageProblems.muc2_1),
          title: '2.2. ${HighElectricStrings.insulationOilLevel}',
          optionsDefaultValue: model.insulationOilLevelStatus,
          onSelectChange: (value) {
            model.insulationOilLevelStatus = value.toIntOrNull();
            _controller.checkValidPattern(ImageProblems.muc2_0);
            if (value.toIntOrNull() ==
                OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc2_1);
              model.removeAbnormal(categoryIndex:ImageProblems.muc2_1);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.insulationOilLevelStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc2_1,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc2_1, message: weirdoMessage));
          },
          defaultAbnormal: model.insulationOilLevelStatusAbnormal,
          options: OptionsType.normal_weirdo.getOptions,
        ),

        //2.3 Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionContactsTerminalsInsulators,abnormal: model.conditionContactsTerminalsInsulatorsAbnormal))
        if(_controller.checkOutsite())
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc2_3,
                  childCategory: title,
                  parentCategory: '2. ${HighElectricStrings.checkBonded}',
                  description: model.conditionContactsTerminalsInsulatorsAbnormal,
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
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_3);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_3),
            title: '2.3.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện',
            optionsDefaultValue: model.conditionContactsTerminalsInsulators,
            onSelectChange: (value) {
              model.conditionContactsTerminalsInsulators = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionContactsTerminalsInsulatorsAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_3, message: weirdoMessage));
            },
            defaultAbnormal: model.conditionContactsTerminalsInsulatorsAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //2.4.Tình trạng nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.groundingStatus,abnormal: model.groundingStatusAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc2_4,
                  childCategory: title,
                  parentCategory: '2. ${HighElectricStrings.checkBonded}',
                  description: model.groundingStatusAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_4).abnormalId,

            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_4);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_4),
            title: '${_controller.checkOutsite()?'2.4.':'2.2.'}${model.tuLocation == ContentOptions.inSite.value?'Tình trạng nối đất vỏ tủ' : (model.tuLocation == ContentOptions.outSite.value?'Tình trạng nối đất thiết bị':HighElectricStrings.groundingStatus)}',
            optionsDefaultValue: model.groundingStatus,
            onSelectChange: (value) {
              model.groundingStatus = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_4);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_4);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.groundingStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_4,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_4, message: weirdoMessage));
            },
            defaultAbnormal: model.groundingStatusAbnormal,
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

