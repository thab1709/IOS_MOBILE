// @dart=2.9
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/constance/user_role_type.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/common/utils/connection.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/models/result_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_controller.dart';
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:evnmobile/src/htld/services/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/htld/services/responsitory/ticket_repository.dart';
import 'package:get/get.dart';

abstract class ResultDelegate{
  void completeTicket();
  void saveCompleted();
}

class ResultController extends GetxController{
  final repository = TicketRepository();

  final TicketController ticketController = Get.find();

  final resultModel = ResultModel().obs;

  final date = DateTime.now().add(const Duration(days: 1)).obs;

  final dateConfig = ''.obs;
  final _userProfile = AppShared.instance.getUserProfile();

  ResultDelegate delegate;

  Future<void> saveResult() async {
    if (ticketController.ticketID == null) {
      return;
    }

    final connection = await Connection.shared.checkConnection();

    final body = {
      'substationSituation': resultModel.value.substationSituation ?? '',
      'solution': resultModel.value.solution ?? '',
      'dueDate': date.value.toStringFormat(AppStrings.utcFormatNotZ, isUtc: true)
    };
    final subStationType = ticketController.ticketScreenArgument.subStationType;

    if (!_validateData()) {
      return;
    }
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      if (connection) {
        final response = await repository.saveResult(body, ticketController.ticketID, subStationType.endPoint);
        LocationServiceBackground.shared.updateLocationToServer(ticketController.getSubstationId());
        if (response.isLoadSuccess) {
          SnackBarHUD.show('Cập nhật kết quả thành công');
        } else {
          await showDialogError(response.message);
        }
      } else {
        await LocalDataManager.shared.saveResult(resultModel.value.toJson(), ticketController.ticketID);
        SnackBarHUD.show('Cập nhật kết quả thành công');
      }
    }
  }

  Future<void> completeTicket() async {

    if (!_validateData()) {
      return;
    }

    final subStationType = ticketController.ticketScreenArgument.subStationType;
    final isLocationGranted = await checkLocationPermission();
    if (isLocationGranted) {
      final response = await repository.completeTicket(ticketController.ticketID, subStationType.endPoint);
      LocationServiceBackground.shared.updateLocationToServer(ticketController.getSubstationId());
      if (response.isLoadSuccess) {
        SnackBarHUD.show('Hoàn thành công việc kiểm tra thành công');
        Future.delayed(const Duration( milliseconds: 200) , () {
          delegate.completeTicket();
        });
      } else {
        await showDialogError(response.message);
      }
    }
  }

  Future<void> getResult() async {
    if (ticketController.ticketID == null) {
      return;
    }

    final subStationType = ticketController.ticketScreenArgument.subStationType;
    final isHasInternet = await Connection.shared.checkConnection();

    if (isHasInternet) {
      final response = await repository.getResult(ticketController.ticketID,  subStationType.endPoint);
      if (response.isLoadSuccess) {
        resultModel.value = response.data.resultModel;
        if (resultModel.value.dueDate == '0001-01-01T00:00:00.000Z') {
          date.value = DateTime.now().add(const Duration(days: 1));
        } else {
          date.value = resultModel.value.dueDate.toDateFormatLocal();
        }

        if (UserRole.hasPermissionCreate()) {
          final userSubstationSituation = '${_userProfile?.userGroup ?? ''} - ${_userProfile.name}: ';
          final resultSituation = resultModel.value.substationSituation ?? '';
          if (!resultSituation.contains(userSubstationSituation)) {
            resultModel.value.substationSituation += '${resultSituation?.isEmpty == true ? '' : '\n\n'}$userSubstationSituation';
          }

          final userSolution = '${_userProfile?.userGroup ?? ''} - ${_userProfile.name}: ';
          final resultSolution = resultModel.value.solution ?? '';
          if(!resultSolution.contains(userSolution) ){
            resultModel.value.solution += '${resultSolution?.isEmpty == true ? '' : '\n\n'}$userSolution';
          }

        }

        if (resultModel.value.completionTime != null) {
          resultModel.value.completionTime = resultModel.value.completionTime.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm);
        }


        if (resultModel.value.updateDate != null) {
          dateConfig.value = '${resultModel.value.updateBy} - ${resultModel.value.updateDate.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm)}';
        } else if (UserRole.hasPermissionCreate()){
          dateConfig.value = '${_userProfile.name} - ${DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm)}';
        }
        update();
      }
      else {
        await showDialogError(response.message);
      }
    }
    else {
      final result = await LocalDataManager.shared.getResult(ticketController.ticketID);

      if(result != null) {
        resultModel.value = ResultModel.fromJson(result);
      } else {
        resultModel.value = ResultModel();
      }

      if (UserRole.hasPermissionCreate()) {
        final userSubstationSituation = '${_userProfile?.userGroup ?? ''} - ${_userProfile.name}: ';
        final resultSituation = resultModel.value.substationSituation ?? '';
        if (!resultSituation.contains(userSubstationSituation)) {
          resultModel.value.substationSituation ??= '';
          resultModel.value.substationSituation += '${resultModel.value.substationSituation?.isEmpty == true ? '' : '\n\n'}$userSubstationSituation';
        }

        final userSolution = '${_userProfile?.userGroup ?? ''} - ${_userProfile.name}: ';
        final resultSolution = resultModel.value.solution ?? '';
        if(!resultSolution.contains(userSolution) ){
          resultModel.value.solution += '${resultModel.value.solution?.isEmpty == true ? '' : '\n\n'}$userSolution';
        }

      }


      if (resultModel.value.dueDate == null) {
        date.value = DateTime.now().add(const Duration(days: 1));
      } else {
        date.value = resultModel.value.dueDate.toDateFormatLocal();
      }

      if (resultModel.value.completionTime != null) {
        resultModel.value.completionTime = resultModel.value.completionTime.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm);
      }

      if (resultModel.value.updateDate != null) {
        dateConfig.value = '${resultModel.value.updateBy} - ${resultModel.value.updateDate.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm)}';
      } else if (UserRole.hasPermissionCreate()){
        dateConfig.value = '${_userProfile.name} - ${DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm)}';
      }
      update();
    }

  }


  bool _validateData(){
    if (resultModel.value?.substationSituation == null || resultModel.value?.substationSituation?.isEmpty == true) {
      SnackBarHUD.show('Tình trạng trạm không được để trống');
      return false;
    }

    if (resultModel.value?.solution == null || resultModel.value?.solution?.isEmpty == true) {
      SnackBarHUD.show('Biện pháp đề nghị giải quyết các tồn tại không được để trống');
      return false;
    }

    return true;
  }

}
