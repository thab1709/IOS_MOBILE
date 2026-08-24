// @dart=2.9
import 'package:get/get.dart';

import '../../../../../htdct/common/enum/list.dart';
import '../../../../common/utils/alert_dialog_utils.dart';
import '../../../../delegate/list_delegate.dart';
import '../../../../models/form_report_copy_model.dart';
import '../../../../services/responsitory/report_repository.dart';

class CopyReportController extends GetxController {
  final searchTerm = ''.obs;
  String scheduleId;
  String equipmentDetailId;
  String equipmentTypeId;
  int groupType = 0;
  final page = 1.obs;
  final service = ReportRepository();
  final reports = <FormReportCopyModel>[].obs;
  final isHasLoadMore = false.obs;
  ListDelegate delegate;

  FormReportCopyModel getReportSelected() {
    return reports.firstWhereOrNull((element) => element.isChecked == true);
  }


  Future loadData(ListTypeLoad type) async {
    if (type == ListTypeLoad.loadMore) {
      page.value = page.value + 1;
    } else if (type == ListTypeLoad.load) {
      page.value = 1;
    } else if (type == ListTypeLoad.refresh) {
      page.value = 1;
    }

    final response = await service.getFormReportCopy(
        scheduleId: scheduleId,
        equipmentDetailId: equipmentDetailId,
        equipmentTypeId: equipmentTypeId,
        groupType: groupType,
        pageIndex: page.value,
        searchTerm: searchTerm.value);

    if (type == ListTypeLoad.loadMore) {
      delegate.onLoadMoreSuccess();
    } else if (type == ListTypeLoad.refresh) {
      reports.clear();
      delegate.onRefreshSuccess();
    } else if (type == ListTypeLoad.load) {
      reports.clear();
    }

    if (response.isLoadSuccess) {
      reports.addAll(response.data.list);
      reports.refresh();
      update();
    } else {
      await rShowDialogOneButton(response.message);
    }

    isHasLoadMore.value = response?.data?.paging?.isHasLoadMore();
  }

  void handleSelectItem(FormReportCopyModel model) {
    reports.forEach((element) {
      element.isChecked = false;
    });

    model.isChecked = true;

    reports.refresh();
  }
}

