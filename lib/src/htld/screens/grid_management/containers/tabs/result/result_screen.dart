// @dart=2.9

import 'package:evnmobile/routes.dart';
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_datetime_picker.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_single_text_field.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_sub_label.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/tabs/result/result_controller.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../e_section_title.dart';

class ConcludeScreen extends StatefulWidget {
  @override
  _ConcludeScreenState createState() => _ConcludeScreenState();
}

class _ConcludeScreenState extends State<ConcludeScreen> implements ResultDelegate {

  final ResultController _controller = ResultController();

  @override
  void initState() {
    super.initState();
    _controller.delegate = this;
    Future.delayed(const Duration(milliseconds: 300), _controller.getResult);
  }

  @override
  Widget build(BuildContext context) {
    final enableEdit = _controller.ticketController.ticketScreenArgument.actionType != ActionType.view;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 16,),
                  const ESectionTitle('Nhận xét'),
                  const SizedBox(height: 10,),
                  const ESubLabel(title: 'Tình trạng trạm:',),
                  Obx(() => ESingleTextArea(value: _controller?.resultModel?.value?.substationSituation ?? '',
                    isEnable: enableEdit,
                    onChanged: (value) {
                    _controller?.resultModel?.value?.substationSituation = value;
                  },),),
                  const SizedBox(height: 20,),
                  const ESubLabel(title: 'Biện pháp đề nghị giải quyết các tồn tại:',),
                  Obx(() => ESingleTextArea(
                    value: _controller?.resultModel?.value?.solution ?? '',
                    isEnable: enableEdit,
                    onChanged: (value) {
                    _controller?.resultModel?.value?.solution = value;
                  },),),
                  const SizedBox(height: 20,),
                  const ESubLabel(title: 'Thời gian dự kiến giải quyết các tồn tại:',),
                  const SizedBox(height: 8,),
                  Obx(() => ESingleDateTimePicker(currentDate:_controller.date.value ?? DateTime.now().add(const Duration(days: 1)),
                      dateSelected: (time) {
                        _controller.date.value = time;
                      }),),
                  const SizedBox(height: 20,),
                  const ESubLabel(title: 'Ngày hiệu chỉnh thông tin kiểm tra :',),
                  const SizedBox(height: 8,),
                  Obx(() => ESingleTextField(isEnable: false, value: _controller.dateConfig.value,),),
                  const SizedBox(height: 20,),
                  const ESubLabel(title: 'Ngày cập nhật thông tin về hồ sơ quản lý trạm :',),
                  const SizedBox(height: 8,),
                  Obx(() => ESingleTextField(isEnable: false, value: _controller.resultModel.value.completionTime,),),
                  const SizedBox(height: 24,),
                ]),
              ),
            ),
            if (_controller.ticketController.ticketScreenArgument.actionType != ActionType.view)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: EButton(
                      title: 'Lưu',
                      action: () {
                        _controller.saveResult();
                      },
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Obx(() {
                    if (_controller?.resultModel?.value?.isAllowComplete == true) {}
                    return _buildButton();
                  })
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(){
    final model = _controller.resultModel.value;
    return Expanded(
      child: EButton(
        title: 'Hoàn thành',
        action: () {
          final missing = model?.missingEquipments?.join('\n+ ') ?? '';
          final other = model?.otherMissingEquipments?.join('\n+ ') ?? '';
          final unAssigned = model?.unAssignedEquipments?.join('\n+ ') ?? '';

          final missingEquipmentMess = missing.isEmpty ? '' : '\n\n- Thiết bị chưa kiểm tra xong: \n+ $missing';
          final otherMissingEquipmentMess = other.isEmpty ? '' : '\n\n- Thiết bị của đội khác: \n+ $other';
          final unAssignedEquipmentMess = unAssigned.isEmpty ? '' : '\n\n- Thiết bị chưa được phân công: \n+ $unAssigned';

          if (_controller?.resultModel?.value?.isAllowComplete == false) {

            if(missing.isEmpty && other.isEmpty &&  unAssigned.isEmpty){
              showDialogOneButton('Vui lòng điền đầy đủ thông tin của phiếu trước khi hoàn thành');
              return;
            }

            if(missing.isEmpty || other.isEmpty ||  unAssigned.isEmpty) {
              showDialogOneButton('Bạn chưa thể hoàn thành công việc. Vui lòng kiểm tra các hạng mục sau:'
                  '$missingEquipmentMess'
                  '$otherMissingEquipmentMess'
                  '$unAssignedEquipmentMess');
              return;
            }

          }
          showMyDialogOkCancel('Công việc sau khi hoàn thành không thể sửa. Bạn có chắc muốn hoàn thành không?', secondFunction: () {
            _controller.completeTicket();
          });

        },
      ),
    );
  }

  // void _chooseDateTime(BuildContext context) {
  //     DatePicker.showDateTimePicker(context,
  //       showTitleActions: true,
  //       minTime: DateTime(2018, 3, 5),
  //       maxTime: DateTime.now().add(const Duration(days: 1)), onConfirm: (date) {
  //         _controller.date.value = date;
  //
  //       }, currentTime: DateTime.now().add(const Duration(days: 1)), locale: LocaleType.vi);
  // }

  @override
  void completeTicket() {
    Get.until((route) => [Routes.periodicInspectionPlanView, Routes.historyCheck, Routes.home].contains(route.settings.name));
  }

  @override
  void saveCompleted() {
    showMyDialogOkCancel('Cập nhật thành công!\nBạn có muốn tiếp tục hoàn thành không?', firstTitle: 'Quay lại', firstAction: () {
      completeTicket();
    }, secondTitle: 'Tiếp tục');
  }
}
