// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/line/line_model.dart';
import 'package:evnmobile/src/htld/services/responsitory/substation_repository.dart';
import 'package:get/get.dart';

import '../../../../../app_env.dart';
import '../../../../app_common/shared/app_shared.dart';

class ChooseLineController extends GetxController {
  SubstationRepository service = SubstationRepository();

  RxList<LineModel> searchValues = RxList<LineModel>();

  RxBool isSearching = false.obs;
  RxBool isSelectedSubstation = false.obs;
  RxBool didGetLineDetail = false.obs;

  Rx<LineModel> substationSelected = LineModel().obs;

  Future<void> search(String value) async {
    if (value.isEmpty) {
      didGetLineDetail.value = false;
      isSearching.value = false;
      isSelectedSubstation.value = false;
      searchValues = RxList<LineModel>();
      searchValues.refresh();
      return;
    }

    final response = await service.getListLine(searchTerm: value);

    if (response.isLoadSuccess) {
      if (response.data.lines.isNotEmpty) {
        searchValues.assignAll(response.data.lines);
      } else {
        searchValues.assignAll([
          LineModel(
              name: AppShared.instance.getAppType() == AppType.HTLDHT
                  ? 'Không tìm thấy công trình nào'
                  : 'Không tìm thấy đường dây nào')
        ]);
      }

      isSearching.value = true;
      searchValues.refresh();
    } else {
      await showDialogError(response.message);
    }
  }

  Future getLineChilds(LineModel model) async {
    substationSelected.value = model;
    didGetLineDetail.value = true;
    update();
  }
}

