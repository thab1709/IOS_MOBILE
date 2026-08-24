// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_info_item_vertical.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_work/detail_work_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../../app_common/utils/permission_utils.dart';
import '../constance/report_work_status_type.dart';
import 'field_infor_item.dart';

class ItemWork extends StatelessWidget {
  final int index;
  final ReportWorkItem reportWorkItem;
  final Function callbackLoadData;
  final Function callbackChangePaperReport;
  final Function callbackCreateReport;
  final bool isLast;
  final bool isForX;

 const ItemWork(
      {this.reportWorkItem,
      this.index,
      this.isLast = false,
      this.isForX = false,
      this.callbackLoadData,
      this.callbackChangePaperReport,
      this.callbackCreateReport});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DetailWorkScreen(
          workId: reportWorkItem.id, 
          itemWork: reportWorkItem, 
          isForX: isForX
        ));
      },
      child: Container(
        margin: EdgeInsets.only(
            top: index == 0 ? 20 : 10,
            bottom: isLast ? 16 : 8,
            left: 26,
            right: 26),
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: _renderNormal(reportWorkItem),
      ),
    );
  }

  Widget _renderNormal(ReportWorkItem item) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if(item.isAllowUpdatePaperFormReport == true)
            Checkbox(value: item.isPaperReport ?? false, onChanged: (value) {
              callbackChangePaperReport();
            }),
            Expanded(
              child: Text(
                item?.equipmentName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: RAppColor.highlightColor70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            if (item?.workProgress == ReportWorkStatusType.done)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.check_circle_outline, color: Colors.green),
              )
            else if (item?.workProgress == ReportWorkStatusType.doing)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.pending_outlined, color: Colors.orange),
              )
            else if (item?.workProgress == ReportWorkStatusType.unfulfilled)
              const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(Icons.radio_button_unchecked, color: Colors.grey),
              ),
            IconButton(
                onPressed: () async {
                  if (item.latitude != null && item.longitude != null) {
                    const platform = MethodChannel('map_direction');
                    final isHasPermission = await requestPermission();
                    if (isHasPermission) {
                      final currentPosition =
                          await Geolocator.getCurrentPosition();
                      final result = await platform.invokeMethod(
                          'showMapDirection',
                          '${currentPosition.latitude},${currentPosition.longitude},${item.latitude},${item.longitude}');
                      if (!result) {
                        await rShowDialogOneButton(
                            'Vui lòng cài đặt google map để sử dụng chức năng này');
                      }
                    }
                  } else {
                    await rShowDialogOneButton(
                        'Không tìm thấy vị trí của trạm');
                  }
                },
                icon: const Icon(Icons.directions)),
            //const Icon(Icons.arrow_forward_sharp)
          ],
        ),
        const Divider(
          thickness: 1,
          height: 30,
        ),
        FieldInfoItem(
          titleFirst: RAppStrings.location,
          valueFirst: item?.location,
          titleSecond: isForX ? 'Giờ xuất phát' : 'Chu kỳ',
          valueSecond: isForX ? item?.departureTime : item?.getPeriodicTypedName(),
        ),
        if (item?.isFromDateToDate() == false)
          FieldInfoItem(
            titleFirst: 'Thời gian',
            valueFirst: item?.getTime(),
            titleSecond: 'Ngày',
            valueSecond: item?.getDate(),
          ),
        if (item?.isFromDateToDate() == true)
          FieldInfoItemVertical(
            title: 'Thời gian',
            value: item?.getFromDateToDate(),
          ),
        FieldInfoItem(
          titleFirst: 'Loại công việc',
          valueFirst: item?.workType,
          titleSecond: 'Trạng thái',
          valueSecond: item?.workProgressName,
        ),
        FieldInfoItem(
          titleFirst: 'Chi tiết VTTB',
          valueFirst: item?.equipmentDetailName,
          titleSecond: isForX ? 'Số biên bản' : 'X05 GS',
          valueSecond: isForX ? item?.reportNumber : item?.isX5MonitoringString,
        ),
        if (isForX)
          FieldInfoItem(
            titleFirst: 'Lái xe',
            valueFirst: item?.driver,
            titleSecond: 'Đơn vị đặt làm',
            valueSecond: item?.unitRequest,
          ),
        if (isForX)
          FieldInfoItem(
            titleFirst: 'Người cập nhật',
            valueFirst: item?.updater,
            titleSecond: 'T.Gian cập nhật',
            valueSecond: item?.updatedDate,
          ),
        FieldInfoItemVertical(
          title: RAppStrings.performer,
          value: item?.getListNameUserImp(),
        ),
        FieldInfoItemVertical(
          title: 'Liên hệ',
          value: item?.getContacts() ?? '',
        ),
        if (((item?.isAllowToCreateReport == true ||
                    item?.isConfirmComplete == true) &&
                item.workProgress != ReportWorkStatusType.done) ||
            (item?.isMeter == true &&
                item.workProgress == ReportWorkStatusType.unfulfilled))
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: RButton(
              action: callbackCreateReport,
              maxSize: true,
              title:
                  item?.isConfirmComplete == true ? 'Xác nhận' : 'Tạo biên bản',
            ),
          )
      ],
    );
  }
}

