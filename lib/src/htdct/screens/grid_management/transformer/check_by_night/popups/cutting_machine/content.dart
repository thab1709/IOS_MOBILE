// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/check_dropdown_model.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/check_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../common/constance/strings.dart';
import '../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../models/day_night/popups/check_date_model.dart';
import '../../../../../../models/day_night/popups/night/cutting_machine_night_model.dart';
import '../../../../../../models/weirdo_message.dart';
import '../../../../containers/e_single_drop_down.dart';
import '../../../../containers/h_dropdown.dart';
import '../../../check_by_daytime/check_sheet/common/check_widget.dart';
import '../../../check_by_daytime/check_sheet/common/expansion_widget.dart';
import 'controller.dart';

Widget cuttingMachineNightContent(CuttingMachineNightController _controller) {
  final model = _controller.dataModel.value as CuttingMachineNightModel;
  Widget _buildHeader() // kiểm tra ngoại quan
  {
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
      title: '1. Kiểm tra',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        HDropDown(
          OptionsType.position.getOptions,
          title: 'Vị trí MC',
          isRequire: true,
          invalid: _controller.invalid.value,
          value: model.mcLocation,
          onSelected: (value) {
            model.mcLocation = value.toIntOrNull();
          },
        ),
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.statusLocks,
            abnormal: model.statusLocksAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_1,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.statusLocksAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue:
                model.getAbnormal(ImageProblems.muc1_1).abnormalId,
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_1);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_1),
            title: '1.1 Tình trạng các khóa trạng thái',
            checkListItem: [
              CheckDropdownModel(
                  options: OptionsType.close_cut.getOptions,
                  title: 'MC',
                  value: model.mc,
                  isRequired: true,
                  onChange: (value) {
                    model.mc = value.toIntOrNull();
                  }),
              CheckDropdownModel(
                  options: OptionsType.operation_lock.getOptions,
                  title: 'TĐL',
                  value: model.tdl,
                  isRequired: true,
                  onChange: (value) {
                    model.tdl = value.toIntOrNull();
                  }),
              CheckDropdownModel(
                  options: OptionsType.operation_lock.getOptions,
                  title: 'Hòa đồng bộ',
                  value: model.synchronizing,
                  isRequired: true,
                  onChange: (value) {
                    model.synchronizing = value.toIntOrNull();
                  }),
              CheckDropdownModel(
                  options: OptionsType.notInstall_lock_f1_f2_f3.getOptions,
                  title: 'Tần số',
                  value: model.frequency,
                  isRequired: true,
                  onChange: (value) {
                    model.frequency = value.toIntOrNull();
                  }),
              CheckDropdownModel(
                  options: OptionsType.operation_lock_notInstall.getOptions,
                  title: 'F87',
                  value: model.f87,
                  isRequired: true,
                  onChange: (value) {
                    model.f87 = value.toIntOrNull();
                  }),
            ],
            optionsDefaultValue: model.statusLocks,
            onSelectChange: (value) {
              model.statusLocks = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_1);
                model.removeAbnormal(categoryIndex: ImageProblems.muc1_1);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.statusLocksAbnormal = value;
              model.setAbnormal(
                  Abnormals(
                    categoryIndex: ImageProblems.muc1_1,
                    description: value,
                  ),
                  isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_1, message: weirdoMessage));
            },
            defaultAbnormal: model.statusLocksAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
          ),
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.operatingStatusResult,
            abnormal: model.operatingStatusResultAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_2,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.operatingStatusResultAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue:
                model.getAbnormal(ImageProblems.muc1_2).abnormalId,
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_2);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_2),
            title: '1.2 Tình trạng vận hành',
            checkListItem: [
              CheckDropdownModel(
                  options: OptionsType.status_operation.getOptions,
                  title: 'Tình trạng vận hành',
                  value: model.operatingStatus,
                  isRequired: true,
                  onChange: (value) {
                    _controller.setOperatorValue(value);
                  }),
              if (OptionsType.status_operation.getOptions.last.value ==
                  model.operatingStatus)
                CheckDateModel(
                  value: model?.operationSeparationDate
                          ?.fromFormatUtcToFormatLocal(
                              HighElectricStrings.ddMMyyyy) ??
                      '',
                  title: 'Ngày tách vận hành',
                  isRequired: true,
                  onChange: (value) {
                    model.operationSeparationDate = value;
                    _controller.setDateDetachedOperator();
                  },
                ),
            ],
            optionsDefaultValue: model.operatingStatusResult,
            onSelectChange: (value) {
              model.operatingStatusResult = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_2);
                model.removeAbnormal(categoryIndex: ImageProblems.muc1_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.operatingStatusResultAbnormal = value;
              model.setAbnormal(
                  Abnormals(
                    categoryIndex: ImageProblems.muc1_2,
                    description: value,
                  ),
                  isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_2, message: weirdoMessage));
            },
            defaultAbnormal: model.operatingStatusResultAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
          ),
        CheckWidget(
          removeImage: (file) {
            _controller.removeImage(file);
          },
          addImage: (files) async {
            final result =
                await _controller.addImage(files, ImageProblems.muc1_3);
            return result;
          },
          listImage: _controller.getImageByProblem(ImageProblems.muc1_3),
          title: '1.3 Loại ngăn lộ',
          checkListItem: [
            CheckDropdownModel(
                options: OptionsType.summary_line.getOptions,
                title: 'Loại ngăn lộ',
                value: model.disclosureType,
                isRequired: true,
                onChange: (value) {
                  model.disclosureType = value.toIntOrNull();
                }),
          ],
          invalid: _controller.invalid.value,
          onChangeWeirdoMessage: (weirdoMessage) {},
        ),
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.powerIndicator,
            abnormal: model.powerIndicatorAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_4,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.powerIndicatorAbnormal,
                  abnormalType: model.unusualClassification,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue:
                model.getAbnormal(ImageProblems.muc1_4).abnormalId,
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_4);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_4),
            title: '1.4 Chỉ số điện năng',
            checkListItem: [
              CheckModel(
                  title: 'AP giao',
                  value: model.apDelivered.toString(),
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.apDelivered = value.toDoubleOrNull();
                  }),
              CheckModel(
                  title: 'AP nhận',
                  value: model.apReceive.toString(),
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.apReceive = value.toDoubleOrNull();
                  }),
              CheckModel(
                  title: 'AQ giao',
                  value: model.aqDelivered.toString(),
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.aqDelivered = value.toDoubleOrNull();
                  }),
              CheckModel(
                  title: 'AQ nhận',
                  value: model.aqReceive.toString(),
                  isNumber: true,
                  isRequired: false,
                  onChange: (value) {
                    model.aqReceive = value.toDoubleOrNull();
                  }),
            ],
            invalid: _controller.invalid.value,
            optionsDefaultValue: model.powerIndicator,
            onSelectChange: (value) {
              model.powerIndicator = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_4);
                model.removeAbnormal(categoryIndex: ImageProblems.muc1_4);
              }
            },
            onChangeInput: (value) {
              model.powerIndicatorAbnormal = value;
              model.setAbnormal(
                  Abnormals(
                    categoryIndex: ImageProblems.muc1_4,
                    description: value,
                    abnormalType: model.unusualClassification,
                  ),
                  isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_4, message: weirdoMessage));
            },
            defaultAbnormal: model.powerIndicatorAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
            showUnusualClassification: true,
            unusualClassificationDefaultValue:
                model.getAbnormal(ImageProblems.muc1_4).abnormalType,
            onUnusualClassificationChange: (int value) {
              model.unusualClassification = value;
              model.getAbnormal(ImageProblems.muc1_4).abnormalType = value;
            },
          ),
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.checkAbnormalDischarge,
            abnormal: model.checkAbnormalDischargeAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_5,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.checkAbnormalDischargeAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue:
                model.getAbnormal(ImageProblems.muc1_5).abnormalId,
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_5);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_5),
            title: '1.5 Kiểm tra hiện tượng phóng điện bất thường',
            optionsDefaultValue: model.checkAbnormalDischarge,
            onSelectChange: (value) {
              model.checkAbnormalDischarge = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_5);
                model.removeAbnormal(categoryIndex: ImageProblems.muc1_5);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.checkAbnormalDischargeAbnormal = value;
              model.setAbnormal(
                  Abnormals(
                    categoryIndex: ImageProblems.muc1_5,
                    description: value,
                  ),
                  isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_5, message: weirdoMessage));
            },
            defaultAbnormal: model.checkAbnormalDischargeAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
          ),
        if (_controller.transformerTicketController.checkAbnormalNotify(
            model.cutCounterIndex,
            abnormal: model.cutCounterIndexAbnormal))
          CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc1_6,
                  childCategory: title,
                  parentCategory: '1. Kiểm tra',
                  description: model.cutCounterIndexAbnormal,
                ),
              );
              _controller.viewRefresh();
            },
            addAbnormalOption: (value) async {
              await _controller.addAbnormalOption(name: value);
            },
            initAbnormalOptionValue:
                model.getAbnormal(ImageProblems.muc1_6).abnormalId,
            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result =
                  await _controller.addImage(files, ImageProblems.muc1_6);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc1_6),
            title: '1.6 Bộ đếm chỉ số lần cắt',
            checkListItem: [
              //Not edit able when in mode copy
              CheckModel(
                  title: 'n = ',
                  value: model?.n?.toInt().toString() ?? '',
                  isNumber: true,
                  readOnly: _controller.isModeCopy(),
                  isRequired: !_controller.isModeCopy(),
                  onChange: (value) {
                    model.n = value.toDoubleOrNull();
                  }),
            ],
            optionsDefaultValue: model.cutCounterIndex,
            onSelectChange: (value) {
              model.cutCounterIndex = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc1_0);
              if (value.toIntOrNull() ==
                  OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc1_6);
                model.removeAbnormal(categoryIndex: ImageProblems.muc1_6);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.cutCounterIndexAbnormal = value;
              model.setAbnormal(
                  Abnormals(
                    categoryIndex: ImageProblems.muc1_6,
                    description: value,
                  ),
                  isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc1_6, message: weirdoMessage));
            },
            defaultAbnormal: model.cutCounterIndexAbnormal,
            options: OptionsType.normal_weirdo.getOptions,
          ),
      ],
    );
  }

  Widget _buildDistributionInHome() {
    return ExpansionWidget(
        removeImage: (file) {
          _controller.removeImage(file);
        },
        addImage: (files) async {
          final result =
              await _controller.addImage(files, ImageProblems.muc2_0);
          return result;
        },
        listImage: _controller.getImageByProblem(ImageProblems.muc2_0),
        isHeader: true,
        allImage: _controller.getListImage(),
        invalid: _controller.invalid.value,
        isCamera: _controller.isNotMultiCopy(),
        title: '2. Phòng phân phối trong nhà',
        children: <Widget>[
          ESingleDropDown(
            OptionsType.normal_weirdo.getOptions,
            value: model.indoorDistributionRoom,
            isDisable: true,
          ),
          if (_controller.transformerTicketController.checkAbnormalNotify(
              model.distributionRoomStatus,
              abnormal: model.distributionRoomStatusAbnormal))
            CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_1,
                    childCategory: title,
                    parentCategory: '2. Phòng phân phối trong nhà',
                    description: model.distributionRoomStatusAbnormal,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue:
                  model.getAbnormal(ImageProblems.muc2_1).abnormalId,
              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result =
                    await _controller.addImage(files, ImageProblems.muc2_1);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc2_1),
              title: '2.1 Tình trạng phòng phân phối',
              optionsDefaultValue: model.distributionRoomStatus,
              onSelectChange: (value) {
                model.distributionRoomStatus = value.toIntOrNull();
                _controller.checkValidPattern(ImageProblems.muc2_0);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc2_1);
                  model.removeAbnormal(categoryIndex: ImageProblems.muc2_1);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.distributionRoomStatusAbnormal = value;
                model.setAbnormal(
                    Abnormals(
                      categoryIndex: ImageProblems.muc2_1,
                      description: value,
                    ),
                    isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc2_1,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.distributionRoomStatusAbnormal,
              options: OptionsType.normal_weirdo.getOptions,
            ),
          if (_controller.transformerTicketController.checkAbnormalNotify(
              model.otherAbnormal,
              abnormal: model.otherAbnormalText))
            CheckWidget(
              abnormalOptions: _controller.abnormalOptions,
              onSelectedAbnormalOption: ({value, title}) {
                model.setAbnormal(
                  Abnormals(
                    abnormalId: value,
                    categoryIndex: ImageProblems.muc2_2,
                    childCategory: title,
                    parentCategory: '2. Phòng phân phối trong nhà',
                    description: model.otherAbnormalText,
                  ),
                );
                _controller.viewRefresh();
              },
              addAbnormalOption: (value) async {
                await _controller.addAbnormalOption(name: value);
              },
              initAbnormalOptionValue:
                  model.getAbnormal(ImageProblems.muc2_2).abnormalId,
              removeImage: (file) {
                _controller.removeImage(file);
              },
              addImage: (files) async {
                final result =
                    await _controller.addImage(files, ImageProblems.muc2_2);
                return result;
              },
              listImage: _controller.getImageByProblem(ImageProblems.muc2_2),
              title: '2.2 Kiểm tra hiện tượng bất thường khác',
              optionsDefaultValue: model.otherAbnormal,
              onSelectChange: (value) {
                model.otherAbnormal = value.toIntOrNull();
                _controller.checkValidPattern(ImageProblems.muc2_0);
                if (value.toIntOrNull() ==
                    OptionsType.normal_weirdo.getOptions.first.value) {
                  _controller.removeImageOfProblem(ImageProblems.muc2_2);
                  model.removeAbnormal(categoryIndex: ImageProblems.muc2_2);
                }
              },
              invalid: _controller.invalid.value,
              onChangeInput: (value) {
                model.otherAbnormalText = value;
                model.setAbnormal(
                    Abnormals(
                      categoryIndex: ImageProblems.muc2_2,
                      description: value,
                    ),
                    isSetDescription: true);
              },
              onChangeWeirdoMessage: (weirdoMessage) {
                model.setUnusually(WeirdoMessage(ImageProblems.muc2_2,
                    message: weirdoMessage));
              },
              defaultAbnormal: model.otherAbnormalText,
              options: OptionsType.normal_weirdo.getOptions,
            ),
        ]);
  }

  return Column(
    children: [
      if (_controller.transformerTicketController.checkAbnormalNotify(
          _controller.dataModel.value.checkBonded,
          nonCheck: true,
          title: 1))
        _buildHeader(),
      if (_controller.transformerTicketController.checkAbnormalNotify(
          _controller.dataModel.value.indoorDistributionRoom,
          nonCheck: true,
          title: 2))
        _buildDistributionInHome()
    ],
  );
}

