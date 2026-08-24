// @dart=2.9
import 'dart:convert';

import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:evnmobile/src/htld/common/utils/global_app.dart';
import 'package:get/get.dart';
import '../../../../../../../htld/common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/line/popups/test_info_general_model.dart';

class TestInfoGeneralController<T> extends BasePopupController {
  TestInfoGeneralController() {
    {
      dataModel = TestInfoGeneralModel().obs;
      final model = dataModel.value as TestInfoGeneralModel;
      model.images = [];
    }
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as TestInfoGeneralModel;
    switch (type) {
      case ImageProblems.muc2_0:
        {
          if (model.generalInformation != ContentOptions.normal.value) {

            if (model.generalTestInformationAbnormal != ContentOptions.weirdo.value) {
              model.generalTestInformationAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            if (model.generalTestInformationAbnormal != ContentOptions.normal.value) {
              model.generalTestInformationAbnormal = ContentOptions.normal.value;
              invalid.refresh();
            }
          }
        }
        break;
      default:
        break;
    }
  }

 @override
  bool checkValid() {
    final model = dataModel.value as TestInfoGeneralModel;
    if (!checkTemperatureAndHumidityInvalid() &&
        model.validateData() &&
        checkValidAbnormal()) return true;
    return false;
  }

@override
  bool checkValidAbnormal() {
    final model = dataModel.value as TestInfoGeneralModel;

    if (model.generalInformation != ContentOptions.normal.value &&
            (model.generalInformationAbnormalDescription?.isNotEmpty != true ||
                getImageByProblem(ImageProblems.muc2_1).isEmpty|| getAbnormalByCategoryIndex(ImageProblems.muc2_1)==null || getAbnormalByCategoryIndex(ImageProblems.muc2_1).abnormalId.isNullOrEmpty())) {
      return false;
    }

    return true;
  }

  // void setDefaultData(TestInfoGeneralModel model) {
  //   model.generalTestInformationAbnormal =
  //       model.generalTestInformationAbnormal ?? ContentOptions.normal.value;
  //   model.generalInformation =
  //       model.generalInformation ?? ContentOptions.normal.value;
  //}

  @override
  Future getData({String equipmentId}) async {
    final response = await transformerService.getTestInfoGeneral(
        ticketId: transformerTicketController.ticketId);
    if (response.isLoadSuccess) {
      final data = json.decode(response.data['data'].toString());
      final model =
          data != null ? TestInfoGeneralModel.fromJson(data['generalTestInformationModel']) : TestInfoGeneralModel();
      //setDefaultData(model);
      humidity.value = data != null ? data['humidity'] : App.humiValue == 0 ? '' : App.humiValue.toStringAsFixed(1);
      temperature.value = data != null ? data['temparute'] : App.tempValue == 0 ? '' : App.tempValue.toStringAsFixed(1);
      dataModel.value = model;
      invalid.refresh();
    } else {
      await hShowDialogOneButton(response.message);
    }
    return null;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as TestInfoGeneralModel;

    if (!checkValid()) {
      invalid.refresh();
      invalid.value = true;
      await hShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
    } else {
      final response = await transformerService.putTestInfoGeneral(
          params: {
            'id': transformerTicketController.ticketId,
            'temperature': temperature.value,
            'humidity': humidity.value,
            'generalTestInformation': model.toJson()
          });

      if (response.isLoadSuccess) {
        Get.back();
      } else {
        await hShowDialogOneButton(response.message);
      }
    }
  }

  @override
  String getEndPoint() => '';

  @override
  Future copyData() async {
    return true;
  }

  @override
  bool checkValidCopy() {

  }
}

