// @dart=2.9
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/models/inspection_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:evnmobile/src/htld/services/responsitory/inspection_repository.dart';
import 'package:get/get.dart';

class TicketOfManagerController extends GetxController {
  RxList<InspectionModel> listItemTicket = RxList.empty();
  InspectionRepository service = InspectionRepository();
  TicketScreenArgument ticketScreenArgument;

  //Filter
  String searchTerm = '';
  String inspectType = '';
  String inspectionType = '';
  String inspectionStatus = '';
  String fromDate = '';
  String toDate = '';

  Future fetchData() async {

    final response = await service.getTicketsOfManager(inspectType: inspectType,
        inspectionType: inspectionType, inspectionStatus: inspectionStatus,
        searchTerm: searchTerm, fromDate: fromDate, toDate: toDate);
    
    if (response.isLoadSuccess) {
      listItemTicket.assignAll(response.data);
    } else {
      await showDialogError(response.message);
    }
  }
}
