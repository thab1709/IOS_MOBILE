// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../models/line/popups/test_info_general_model.dart';
import '../../../../../../services/responsitory/tba_repository.dart';
import '../../../../transformer/transformer_ticket_controller.dart';

class TestInfoGeneralController<T> extends BasePopupController {
  TestInfoGeneralController() {
    {
      dataModel = TestInfoGeneralModel().obs;
      final model = dataModel.value as TestInfoGeneralModel;
      model.images = [];
    }
  }
  final TransformerTicketController transformerTicketController = Get.find();
  final _tbaRep = TBARepository();
  @override
  void checkValidPattern(int type) {

  }

 @override
  bool checkValid() {
    final model = dataModel.value as TestInfoGeneralModel;
    if (!checkTemperatureAndHumidityInvalid()) return true;
    return false;
  }

@override
  bool checkValidAbnormal() {
    return true;
  }


  @override
  Future getData({String equipmentId}) async {
      final res = await _tbaRep.getGeneralInfo(idTicket: transformerTicketController.ticketId);
      if (res.isLoadSuccess) {
        humidity.value = res.data.tbaGeneralInfoModel.humidity;
        temperature.value = res.data.tbaGeneralInfoModel.temperature;
        invalid.refresh();
      } else {
        await hShowDialogOneButton(res.message);
      }
  }

  @override
  Future updateData() async {
    if (!checkValid()) {
      invalid.refresh();
      invalid.value = true;
      await hShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
    } else {
      final response = await _tbaRep.updateGeneralInfo(
        params: {
          'id': transformerTicketController.ticketId,
          'temperature': temperature.value,
          'humidity': humidity.value,
        }
      );
      if (response.isLoadSuccess) {
        transformerTicketController.triggerCompleteTicket = false;
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

