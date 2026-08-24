// @dart=2.9
import 'package:evnmobile/src/htdct/screens/grid_management/containers/e_check_box.dart';
import 'package:evnmobile/src/qltnkd/models/workload/confirm_mass_scene_schedules.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../common/components/app_button.dart';
import '../../../../../../common/components/field_infor_item.dart';
import '../../../../../../common/constance/report_work_status_type.dart';
import '../../detail_workload_controller.dart';

class WorkloadWorkItem extends StatelessWidget {
  final int index;
  final ConfirmMassSceneSchedules work;
  final bool isCreate;
  final bool isLast;
  final Function() onShowReason;
  final Function() onShowOrEditNote;
  final Function(bool) onChecked;
  final Function() onCreateTicket;

  const WorkloadWorkItem({
    @required this.work,
    @required this.index,
    @required this.isCreate,
    @required this.isLast,
    @required this.onShowReason,
    @required this.onShowOrEditNote,
    @required this.onChecked,
    @required this.onCreateTicket,
  });

  @override
  Widget build(BuildContext context) {
    final _controller = Get.find<DetailWorkloadController>();

    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: EdgeInsets.only(
            top: index == 0 ? 20 : 10,
            bottom: isLast ? 16 : 8,
            left: 16,
            right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: work.getItemColorStatus(),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: _renderNormal(work, _controller),
      ),
    );
  }

  Widget _renderNormal(
      ConfirmMassSceneSchedules item, DetailWorkloadController controller) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if(controller.isEdit == true)
            ECheckBox(
              checked: item.isChecked ?? false,
              onClicked: onChecked,
            ),
            const Spacer(),
            IconButton(
                onPressed: onShowOrEditNote, icon: Icon(item.note?.isNotEmpty == true ? Icons.note_alt_rounded : Icons.note_alt_outlined))
          ],
        ),
        FieldInfoItem(
          titleFirst: 'Ngày thực hiện',
          valueFirst: item.getFromDateToDate(),
        ),
        FieldInfoItem(
          titleFirst: 'Trạm',
          valueFirst: item.substationName,
          titleSecond: 'Công trình',
          valueSecond: item.constructionName,
        ),
        FieldInfoItem(
          titleFirst: 'Người thực hiện',
          valueFirst: item.usersPerform,
          titleSecond: 'Tên VTTB',
          valueSecond: item.equipmentName,
        ),
        FieldInfoItem(
          titleFirst: 'Loại VTTB',
          valueFirst: item.equipmentType,
          titleSecond: 'Chi tiết VTTB',
          valueSecond: item.equipmentDetail,
        ),
        FieldInfoItem(
          titleFirst: 'Loại lịch',
          valueFirst: item.scheduleType,
          titleSecond: item.reason?.isNotEmpty == true ? 'Lý do' : '',
          valueSecond: item.reason?.isNotEmpty == true ? item.reason : '',
        ),
        _buildBottom(controller)
      ],
    );
  }

  Widget _buildBottom(DetailWorkloadController _controller) {
    return Row(
      children: [
        if (work.status == ReportWorkStatusType.unfulfilled &&
            _controller.isEdit &&
            (work.reason == null || work.reason.isEmpty) &&
            !isCreate)
          Expanded(
              child: RButton(
            action: onCreateTicket,
            maxSize: true,
            title:
                work?.isConfirmComplete == true ? 'Xác nhận' : 'Tạo biên bản',
          )),
        if (work.status == ReportWorkStatusType.unfulfilled &&
            _controller.isEdit &&
            (work.reason == null || work.reason.isEmpty) &&
            !isCreate)
          const SizedBox(
            width: 20,
          ),
        if (work.status == ReportWorkStatusType.unfulfilled &&
            _controller.isEdit &&
            _controller.userProfile.isHasPermissionCreateConfirmSheet() &&
            !isCreate)
          Expanded(
              child: RButton(
            action: onShowReason,
            maxSize: true,
            title: work.reason?.isNotEmpty == true ? 'Sửa lý do' : 'Nhập lý do',
          )),
      ],
    );
  }
}

