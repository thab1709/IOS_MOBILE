// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/r_user_role_type.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/report_work.dart';
import 'package:flutter/material.dart';

import 'field_info_item_vertical.dart';
import 'field_infor_item.dart';

class ItemDriver extends StatelessWidget {
  final int index;
  final ReportWorkItem reportWorkItem;
  final bool isLast;

  const ItemDriver({
    this.reportWorkItem,
    this.index,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
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
            if(!RUserRole.isDriver)
            const Icon(Icons.arrow_forward_sharp)
          ],
        ),
        const Divider(
          thickness: 1,
          height: 30,
        ),
        FieldInfoItem(
          titleFirst: 'Địa điểm',
          valueFirst: item?.location,
          titleSecond: 'Người thực hiện',
          valueSecond: item?.getListNameUserImp(),
        ),
        if(item?.isFromDateToDate() == false)
          FieldInfoItem(
            titleFirst: 'Thời gian',
            valueFirst: item?.getTime(),
            titleSecond: 'Ngày',
            valueSecond: item?.getDate(),
          ),
        if(item?.isFromDateToDate() == true)
          FieldInfoItemVertical(
            title: 'Thời gian',
            value: item?.getFromDateToDate(),
          ),
        FieldInfoItem(
          titleFirst: 'Lái xe',
          valueFirst: item?.driver,
          titleSecond: 'Giờ xuất phát',
          valueSecond: item?.getDepartureTime(),
        ),
        FieldInfoItem(
          titleFirst: 'Trạng thái',
          valueFirst: item?.workProgressName,
          titleSecond: '',
          valueSecond: '',
        ),
      ],
    );
  }
}

