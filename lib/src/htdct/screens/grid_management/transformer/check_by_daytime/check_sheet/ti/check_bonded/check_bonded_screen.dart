// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/content_option.dart';
import 'package:evnmobile/src/htdct/common/constance/image_problems.dart';
import 'package:evnmobile/src/htdct/common/constance/option_type.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/day_night/popups/ti_model.dart';
import 'package:evnmobile/src/htdct/models/weirdo_message.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/transformer/check_by_daytime/check_sheet/ti/ti_controller.dart';
import 'package:flutter/material.dart';

import '../../../../../../../common/constance/strings.dart';
import '../../../../../../../common/themes/styles.dart';
import '../../../../../../../models/day_night/popups/abnormal_model.dart';
import '../../../../../../../models/day_night/popups/check_model.dart';
import '../../../../../containers/e_single_drop_down.dart';
import '../../common/check_widget.dart';
import '../../common/expansion_widget.dart';

Widget CheckBondedScreen(TIController _controller) {
  Widget _buildHeader() // kiểm tra ngoại quan
  {
    final model = _controller.dataModel.value as TIModel;
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
      invalid:  _controller.invalid.value,
      isCamera: _controller.isNotMultiCopy(),
      title: '2. ${HighElectricStrings.checkBonded}',
      children: <Widget>[
        // kết luận
        ESingleDropDown(
          OptionsType.normal_weirdo.getOptions,
          value: model.checkBonded,
          isDisable: true,
        ),
        //vị trí TI
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: RichText(
                text: const TextSpan(
                  text: 'Vị trí TI',
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
              value: model.tiLocation,
              padding: 0,
              onSelected: (value) {
                model.tiLocation = value.toIntOrNull();
                _controller.checkValidPattern(ImageProblems.muc2_0);
                _controller.viewRefresh();
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
                  text: 'Loại cách điện',
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
        //2.1.Tình trạng mức dầu cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.insulationOilLevelStatus,abnormal: model.insulationOilLevelStatusAbnormal))
        if(model.insulationClassificationGISCompartment == ContentOptions.oil.value)
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
          title: '2.1.Tình trạng mức dầu cách điện',
          optionsDefaultValue: model.insulationOilLevelStatus,
          onSelectChange: (value) {
            model.insulationOilLevelStatus = value.toIntOrNull();
            _controller.checkValidPattern(ImageProblems.muc2_0);
            if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
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
        //2.2.Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện
        if(_controller.transformerTicketController.checkAbnormalNotify(model.conditionContactsTerminalsInsulators,abnormal: model.conditionContactsTerminalsInsulatorsAbnormal))
        if(_controller.checkOutsite())
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc2_2,
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
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_2).abnormalId,

            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_2);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_2),
            title: '${model.insulationClassificationGISCompartment == ContentOptions.oil.value?'2.2.':'2.1.'}Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện',
            optionsDefaultValue: model.conditionContactsTerminalsInsulators,
            onSelectChange: (value) {
              model.conditionContactsTerminalsInsulators = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_2);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_2);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.conditionContactsTerminalsInsulatorsAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_2,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_2, message: weirdoMessage));
            },
            defaultAbnormal: model.conditionContactsTerminalsInsulatorsAbnormal,
            options: OptionsType.normal_weirdo.getOptions),
        //2.3.Tình trạng nối đất
        if(_controller.transformerTicketController.checkAbnormalNotify(model.groundingStatus,abnormal: model.groundingStatusAbnormal))
        CheckWidget(
            abnormalOptions: _controller.abnormalOptions,
            onSelectedAbnormalOption: ({value, title}) {
              model.setAbnormal(
                Abnormals(
                  abnormalId: value,
                  categoryIndex: ImageProblems.muc2_3,
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
            initAbnormalOptionValue: model.getAbnormal(ImageProblems.muc2_3).abnormalId,

            removeImage: (file) {
              _controller.removeImage(file);
            },
            addImage: (files) async {
              final result = await _controller.addImage(files, ImageProblems.muc2_3);
              return result;
            },
            listImage: _controller.getImageByProblem(ImageProblems.muc2_3),
            title: '${_controller.checkOutsite()?model.insulationClassificationGISCompartment == ContentOptions.oil.value?'2.3.':'2.2.':model.insulationClassificationGISCompartment == ContentOptions.oil.value?'2.2.':'2.1.'}${model.tiLocation == ContentOptions.inSite.value?'Tình trạng nối đất vỏ tủ' : (model.tiLocation == ContentOptions.outSite.value?'Tình trạng nối đất thiết bị':HighElectricStrings.groundingStatus)}',
            optionsDefaultValue: model.groundingStatus,
            onSelectChange: (value) {
              model.groundingStatus = value.toIntOrNull();
              _controller.checkValidPattern(ImageProblems.muc2_0);
              if(value.toIntOrNull() == OptionsType.normal_weirdo.getOptions.first.value) {
                _controller.removeImageOfProblem(ImageProblems.muc2_3);
                model.removeAbnormal(categoryIndex:ImageProblems.muc2_3);
              }
            },
            invalid: _controller.invalid.value,
            onChangeInput: (value) {
              model.groundingStatusAbnormal = value;
              model.setAbnormal(Abnormals(
                categoryIndex: ImageProblems.muc2_3,
                description: value,
              ),isSetDescription: true);
            },
            onChangeWeirdoMessage: (weirdoMessage) {
              model.setUnusually(
                  WeirdoMessage(ImageProblems.muc2_3, message: weirdoMessage));
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

