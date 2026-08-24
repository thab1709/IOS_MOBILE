// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/models/line/popups/pole_model.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/base/base_popup_controller_inter.dart';
import 'package:get/get.dart';

import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/image_problems.dart';

class PoleController<T> extends BasePopupController {
  PoleController() {
    dataModel = PoleModel().obs;
  }

  @override
  void checkValidPattern(int type) {
    final model = dataModel.value as PoleModel;
    switch (type) {
      case ImageProblems.muc1_0:
        {
          if (model.constructionPolesStatus == null ||
              model.systemPolesStatus == null ||
              model.numberPolesStatus == null ||
              model.lobbyPolesStatus == null) {
            if (model.linePolesAbnormal != null) {
              model.linePolesAbnormal = null;
              invalid.refresh();
            }
            return;
          }

          if (model.constructionPolesStatus != ContentOptions.normal.value ||
              model.systemPolesStatus != ContentOptions.normal.value ||
              model.numberPolesStatus != ContentOptions.normal.value ||
              model.lobbyPolesStatus != ContentOptions.normal.value) {
            //bất thường
            if (model.linePolesAbnormal != ContentOptions.weirdo.value) {
              model.linePolesAbnormal = ContentOptions.weirdo.value;
              invalid.refresh();
            }
          } else {
            model.linePolesAbnormal = ContentOptions.normal.value;
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
    final model = dataModel.value as PoleModel;
    if (model.validateData() && checkValidAbnormal()) return true;
    return false;
  }

  @override
  bool checkValidAbnormal() {
    final model = dataModel.value as PoleModel;

    if (model.constructionPolesStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_1).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_1).abnormalId.isNullOrEmpty() ||
                model.constructionPolesStatusAbnormal.isNullOrBlank()) ||
        model.systemPolesStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_2).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_2).abnormalId.isNullOrEmpty() ||
                model.systemPolesStatusAbnormal.isNullOrBlank()) ||
        model.numberPolesStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_3).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_3).abnormalId.isNullOrEmpty() ||
                model.numberPolesStatusAbnormal.isNullOrBlank()) ||
        model.lobbyPolesStatus != ContentOptions.normal.value &&
            (getImageByProblem(ImageProblems.muc1_4).isEmpty||
                getAbnormalByCategoryIndex(ImageProblems.muc1_4).abnormalId.isNullOrEmpty() ||
                model.lobbyPolesStatusAbnormal.isNullOrBlank())) {
      return false;
    }
    return true;
  }

  @override
  Future getData({String equipmentId}) async {
    return getDataLine('linePolesX6Model', equipmentId: equipmentId);
  }

  @override
  bool checkValidCopy() {
    final model = dataModel.value as PoleModel;
    if (equipmentsDestination.length > 1) {
      return model.linePolesAbnormal == ContentOptions.normal.value;
    }
    return true;
  }

  @override
  Future updateData() async {
    final model = dataModel.value as PoleModel;
    model.autoGenAbnormalType();
    await updateEquipment(model.toJson(), 'linePole');
  }

  @override
  String getEndPoint() => HighElectricInspectionCategory.getEndpointAPI(
      equipmentModel.equipmentCategory,
      testType: transformerTicketController.testType);

  @override
  Future copyData() async {
    final originalModel =
        await getData(equipmentId: equipmentModel.id) as PoleModel;
    originalModel.images = [];

    dataModel.value = originalModel;
    invalid.refresh();
  }
}

