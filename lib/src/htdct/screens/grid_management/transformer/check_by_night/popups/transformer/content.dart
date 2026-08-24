// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/check_date_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_night/popups/transformer/controller.dart';
import 'package:flutter/material.dart';

import '../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../models/day_night/popups/check_dropdown_model.dart';
import '../../../../../../models/day_night/popups/night/transformer_night_model.dart';
import '../../../../../../models/weirdo_message.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../check_by_daytime/check_sheet/common/expansion_widget.dart';

Widget transformerNightContent(TransformerNightController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller.dataModel.value as TransformerNightModel;
    return ExpansionWidget(
      removeImage: (file) {
        _controller.removeImage(file);
      },
      addImage: (files) async {
        final result = await _controller.addImage(files, ImageProblems.muc1_0);
        return result;
      },
      listImage: _controller.getImageByProblem(ImageProblems.muc1_0),
      isHeader: true,
      allImage: _controller.getListImage(),
      invalid: _controller.invalid.value,
      isCamera: _controller.isNotMultiCopy(),
      title: '1. Kiểm tra ngoại quan',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.chirp,abnormal: model.chirpAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_1,
                    childCategory: title,
                    parentCategory: '1. Kiểm tra ngoại quan',
                    description: model.chirpAbnormal,
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
            title: '1.1 Tiếng kêu của MBA',
            optionsDefaultValue: model.chirp,
            onSelectChange: (value) {
              model.chirp = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
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
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            defaultAbnormal: model.chirpAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.checkDischarge,abnormal: model.checkDischargeAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_2,
                    childCategory: title,
                    parentCategory: '1. Kiểm tra ngoại quan',
                    description: model.checkDischargeAbnormal,
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
            title: '1.2 Kiểm tra hiện tượng phóng điện bất thường',
            optionsDefaultValue: model.checkDischarge,
            onSelectChange: (value) {
              model.checkDischarge = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.checkDischargeAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.checkDischargeAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.outdoorLightingCondition,abnormal: model.outdoorLightingConditionAbnormal))
          CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc1_3,
                    childCategory: title,
                    parentCategory: '1. Kiểm tra ngoại quan',
                    description: model.outdoorLightingConditionAbnormal,
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
            title: '1.3 Tình trạng chiếu sáng ngoài trời',
            optionsDefaultValue: model.outdoorLightingCondition,
            onSelectChange: (value) {
              model.outdoorLightingCondition = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.enough_lack.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc1_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.outdoorLightingConditionAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc1_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_3, message: weirdoMessage));
            },
            defaultAbnormal: model.outdoorLightingConditionAbnormal,
            options: OptionsType.enough_lack.getOptions),
        if(_controller.transformerTicketController.checkAbnormalNotify(model.operatingStatusResult,abnormal: model.operatingStatusAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra ngoại quan',
                  description: model.operatingStatusAbnormal,
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
          title: '1.4 Tình trạng vận hành',
          checkListItem: [
            CheckDropdownModel(
              title: 'Tình trạng vận hành',
              value: model.operatingStatus,
              isRequired: true,
              options: OptionsType.status_operation.getOptions,
              onChange: (value) {
                _controller.setOperatorValue(value);
              }
            ),
            if(OptionsType.status_operation.getOptions.last.value == model.operatingStatus)
            CheckDateModel(
              value: model?.operationSeparationDate?.fromFormatUtcToFormatLocal(HighElectricStrings.ddMMyyyy) ?? '',
              title: 'Ngày tách vận hành',
              isRequired: true,
              onChange: (value) {
                model.operationSeparationDate = value;
                _controller.setDateDetachedOperator();
              },
            )
          ],
          optionsDefaultValue: model.operatingStatusResult,
          onSelectChange: (value) {
            model.operatingStatusResult = value.toIntOrNull();
            _controller.checkValidPattern(ImageProblems.muc1_0);
            if (value.toIntOrNull() ==
                OptionsType.normal_weirdo.getOptions.first.value) {
              _controller.removeImageOfProblem(ImageProblems.muc1_4);
              model.removeAbnormal(categoryIndex:ImageProblems.muc1_4);
            }
          },
          invalid: _controller.invalid.value,
          onChangeInput: (value) {
            model.operatingStatusAbnormal = value;
            model.setAbnormal(Abnormals(
              categoryIndex: ImageProblems.muc1_4,
              description: value,
            ),isSetDescription: true);
          },
          onChangeWeirdoMessage: (weirdoMessage) {
            model.setUnusually(
                WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
          },
          defaultAbnormal: model.operatingStatusAbnormal,
          isDisableDropdown: true,
          options: OptionsType.normal_weirdo.getOptions,
        ),
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

