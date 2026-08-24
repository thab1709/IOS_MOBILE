// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/check_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_single_drop_down.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/transformers_model.dart';
import '../../../../../../../models/weirdo_message.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';
import '../high_transformer_controller.dart';

Widget buildTemperature(
    HighTransformerController _controller) // kiểm tra ngoại quan
{
  final model = _controller?.dataModel?.value as TransformersModel;
  return ExpansionWidget(
    allImage: _controller.getListImage(),
    removeImage: (file) {
      _controller.removeImage(file);
    },
    addImage: (files) async {
      final result = await _controller.addImage(files, ImageProblems.muc3_0);
      return result;
    },
    listImage: _controller.getImageByProblem(ImageProblems.muc3_0),
    isHeader: true,
    invalid: _controller.invalid.value,
    isCamera: _controller.isNotMultiCopy(),
    title: '3. Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)',
    children: <Widget>[
      ESingleDropDown(
        OptionsType.normal_weirdo.getOptions,
        value: model.oilTemperature,
        isDisable: true,
      ),

      //Đồng hồ tại mặt MBA
      if(_controller.transformerTicketController.checkAbnormalNotify(model.watchMBAFace,abnormal: model.watchMBAFaceAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc3_1,
                  childCategory: title,
                  parentCategory: '3. Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)',
                  description: model.watchMBAFaceAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc3_1).abnormalId,

            removeImage: (file) {
            _controller.removeImage(file);
          },
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc3_1);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc3_1),
          title: '3.1 ${HighElectricStrings.checkTemperatureOnTransformer}',
          checkListItem: [
            CheckModel(
                value: _controller.dataModel.value.watchMBAFaceOil.toString(),
                title: 'Dầu',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning1= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.watchMBAFaceOil = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(1);
                }),
            CheckModel(
                value: _controller.dataModel.value.watchMBAFaceHigh.toString(),
                title: 'Cao',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning2= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.watchMBAFaceHigh = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(2);
                }),
            CheckModel(
                value: _controller.dataModel.value.watchMBAFaceMedium.toString(),
                title: 'Trung',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning3= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.watchMBAFaceMedium = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(3);
                }),
            CheckModel(
                value: _controller.dataModel.value.watchMBAFaceLow.toString(),
                title: 'Hạ',
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning4= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.watchMBAFaceLow = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(4);
                }),
          ],
          optionsDefaultValue: model.watchMBAFace,
          onSelectChange: (value) {
            model.watchMBAFace = value.toIntOrNull();
            _controller.checkValidPattern(3);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc3_1);
              model.removeAbnormal(categoryIndex:ImageProblems.muc3_1);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.watchMBAFaceAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc3_1,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc3_1, message: weirdoMessage));
          },
          defaultAbnormal: model.watchMBAFaceAbnormal,
          options: OptionsType.normal_weirdo.getOptions),

      //Đồng hồ tại tủ bảo vệ MBA
      if(_controller.transformerTicketController.checkAbnormalNotify(model.mbaProtectionMeter,abnormal: model.mbaProtectionMeterAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc3_2,
                  childCategory: title,
                  parentCategory: '3. Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)',
                  description: model.mbaProtectionMeterAbnormal,
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
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc3_2);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc3_2),
          title:
              '3.2 ${HighElectricStrings.checkTemperatureOnTransformerCabinet}',
          checkListItem: [
            CheckModel(
                value:
                    _controller.dataModel.value.mbaProtectionMeterOil.toString(),
                title: 'Dầu',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning1= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.mbaProtectionMeterOil = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(1);
                }),
            CheckModel(
                value:
                    _controller.dataModel.value.mbaProtectionMeterHigh.toString(),
                title: 'Cao',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning2= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.mbaProtectionMeterHigh = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(2);
                }),
            CheckModel(
                value: _controller.dataModel.value.mbaProtectionMeterMedium
                    .toString(),
                title: 'Trung',
                isNumber: true,
                isRequired: true,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning3= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.mbaProtectionMeterMedium = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(3);
                }),
            CheckModel(
                value:
                    _controller.dataModel.value.mbaProtectionMeterLow.toString(),
                title: 'Hạ',
                isNumber: true,
                isRequired: false,
                onChange: (value) {
                  _controller.triggerDegreeDifferenceWarning4= true;
                  _controller.triggerDegreeDifferenceAbnormal = true;
                  model.mbaProtectionMeterLow = value.toDoubleOrNull();
                  // _controller.updateDegreeDifference(4);
                }),
          ],
          optionsDefaultValue: model.mbaProtectionMeter,
          onSelectChange: (value) {
            model.mbaProtectionMeter = value.toIntOrNull();
            _controller.checkValidPattern(3);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc3_2);
              model.removeAbnormal(categoryIndex:ImageProblems.muc3_2);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.mbaProtectionMeterAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc3_2,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc3_2, message: weirdoMessage));
          },
          defaultAbnormal: model.mbaProtectionMeterAbnormal,
          options: OptionsType.normal_weirdo.getOptions),

      //Đồng hồ tại tủ bảo vệ MBA
      if(_controller.transformerTicketController.checkAbnormalNotify(model.degreeDifference,abnormal: model.degreeDifferenceAbnormal))
        Obx(()=>CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc3_3,
                  childCategory: title,
                  parentCategory: '3. Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)',
                  description: model.degreeDifferenceAbnormal,
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
          addImage: (files) async {
            final result = await _controller.addImage(files, ImageProblems.muc3_3);
            return result;
          },
          label: '3. Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)',
          allImage: _controller.getListImage(),
          listImage: _controller.getImageByProblem(ImageProblems.muc3_3),
          title:
          '3.3 ${HighElectricStrings.degreeOfDifferenceTransformerCabinet}',
          checkListItem: [
            CheckModel(
                value:_controller.degreeDifferenceOilValue.value.toString(),
                title: 'Dầu',
                isNumber: true,
                isRequired: false,
                readOnly: true,
                onChange: (value) {
                  model.degreeDifferenceOil = value.toDoubleOrNull();
                }),
            CheckModel(
                value:_controller.degreeDifferenceHighValue.value.toString(),
                title: 'Cao',
                isNumber: true,
                isRequired: false,
                readOnly: true,
                onChange: (value) {
                  model.degreeDifferenceHigh = value.toDoubleOrNull();
                }),
            CheckModel(
                value: _controller.degreeDifferenceMediumValue.value.toString(),
                title: 'Trung',
                isNumber: true,
                isRequired: false,
                readOnly: true,
                onChange: (value) {
                  model.degreeDifferenceMedium = value.toDoubleOrNull();
                }),
            CheckModel(
                value:
                _controller.degreeDifferenceLowValue.value.toString(),
                title: 'Hạ',
                isNumber: true,
                isRequired: false,
                readOnly: true,
                onChange: (value) {
                  model.degreeDifferenceLow = value.toDoubleOrNull();
                }),
          ],
          optionsDefaultValue: model.degreeDifference,
          onSelectChange: (value) {
            model.degreeDifference = value.toIntOrNull();
            _controller.checkValidPattern(3);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc3_3);
              model.removeAbnormal(categoryIndex:ImageProblems.muc3_3);
            }

          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.degreeDifferenceAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc3_3,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc3_3, message: weirdoMessage));
          },
          defaultAbnormal: model.degreeDifferenceAbnormal,
          options: OptionsType.normal_weirdo.getOptions)),
    ],
  );
}

