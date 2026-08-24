// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/pole_foundation.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';

class PoleFoundationController<T> extends BasePopupController {
  PoleFoundationController() {
    dataModel = PoleFoundationModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as PoleFoundationModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.drownStatus == null ||
              model.roadStatus == null ) {
            if (model.lineFoudationAbnormal != null) {
              model.lineFoudationAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.drownStatus == ContentOptions.weirdo.value ||
              model.roadStatus == ContentOptions.weirdo.value) {
            //bất thường
            if (model.lineFoudationAbnormal != ContentOptions.weirdo.value) {
              model.lineFoudationAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.lineFoudationAbnormal = ContentOptions.normal.value;
            invalid.refresh();
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  bool checkValid() {
    final model = dataModel.value as PoleFoundationModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as PoleFoundationModel;

    if (model.drownStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
                model.drownStatusAbnormal.isNullOrBlank()) ||
        model.roadStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty() ||
                model.roadStatusAbnormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('lineFoudation', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as PoleFoundationModel;
    if (equipmentsDestination.length > 1) {
      return model.lineFoudationAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as PoleFoundationModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'lineFoudation');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as PoleFoundationModel;
    originalModel.images = [];

    dataModel.value = originalModel;
    invalid.refresh();
  }
}

