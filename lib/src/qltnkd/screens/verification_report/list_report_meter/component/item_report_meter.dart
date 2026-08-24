// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/report_location_utils.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/components/report_status_icon.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/map/map_page.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_approval_history/report_approval_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/field_info_item_vertical.dart';
import '../../../../common/components/field_infor_item.dart';
import '../../../../models/report_meter_model.dart';
import '../../../../models/sub_report_meter_model.dart';
import '../../report/bb_cong_to/bb_cong_to.dart';
import '../../report/report_screen.dart';
import '../pdf_view/pdf_report_view.dart';

class ItemReportMeter extends StatelessWidget {
  final int index;
  final ReportMeterModel workMergeModel;
  final bool isLast;
  final bool isHasCheckbox;
  final Function(String, bool) onSelect;
  final Function() expandItem;
  final Function(String) cancelReport;
  final String reportStatus;

  const ItemReportMeter({
    @required this.expandItem,
    this.workMergeModel,
    this.index,
    this.isLast = false,
    this.isHasCheckbox = false,
    this.onSelect,
    this.cancelReport,
    this.reportStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: index == 0 ? 20 : 10,
          bottom: isLast ? 16 : 8,
          left: 16,
          right: 16),
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: _renderNormal(workMergeModel, context),
    );
  }

  Widget _renderNormal(ReportMeterModel item, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderWork(item),
        FieldInfoItem(
          titleFirst: 'Loại thiết bị',
          valueFirst: item?.equipmentTypeName,
          titleSecond: 'Đơn vị yêu cầu',
          valueSecond: item?.unitRequest,
        ),
        // FieldInfoItem(
        //   titleFirst: 'Loại thiết bị',
        //   valueFirst: item?.equipmentTypeName,
        //   titleSecond: 'Tên thiết bị',
        //   valueSecond: item?.equipmentName,
        // ),
        FieldInfoItem(
          titleFirst: 'Vị trí',
          valueFirst: item?.location,
        ),
        FieldInfoItemVertical(
          title: RAppStrings.performer,
          valueWidget: item?.getListNameUserImp(),
        ),
        Container(
          width: double.infinity,
          child: IconButton(
              icon: Icon(item.isExpand
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded),
              onPressed: expandItem),
        ),
        if (workMergeModel.isExpand)
          Column(
            children: [
              const Divider(
                height: 10,
                thickness: 1,
              ),
              const SizedBox(
                height: 10,
              ),
              if (workMergeModel.reportMergeModels.isNotEmpty)
                _buildItemReport(workMergeModel.reportMergeModels[0]),
              if (workMergeModel.reportMergeModels.length > 1)
                _buildItemReport(workMergeModel.reportMergeModels[1]),
              if (workMergeModel.reportMergeModels.length > 2)
                _buildItemReport(workMergeModel.reportMergeModels[2]),
              if (workMergeModel.reportMergeModels.length > 3)
                _buildItemReport(workMergeModel.reportMergeModels[3]),
              if (workMergeModel.reportMergeModels.length > 4)
                _buildItemReport(workMergeModel.reportMergeModels[4]),
              if (workMergeModel.reportMergeModels.length > 5)
                _buildItemReport(workMergeModel.reportMergeModels[5]),
              if (workMergeModel.reportMergeModels.length > 6)
                _buildItemReport(workMergeModel.reportMergeModels[6]),
              if (workMergeModel.reportMergeModels.length > 7)
                _buildItemReport(workMergeModel.reportMergeModels[7]),
              if (workMergeModel.reportMergeModels.length > 8)
                _buildItemReport(workMergeModel.reportMergeModels[8]),
              if (workMergeModel.reportMergeModels.length > 9)
                _buildItemReport(workMergeModel.reportMergeModels[9]),
              if (workMergeModel.reportMergeModels.length > 10)
                _buildItemReport(workMergeModel.reportMergeModels[10]),
            ],
          )
      ],
    );
  }

  Widget _buildItemReport(SubReportMeterModel model) {
    return Card(
      elevation: 0,
      color: Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _buildHeader(model),
            const SizedBox(
              height: 10,
            ),
            _buildContent('Tên khách hàng', model.customerName),
            const SizedBox(
              height: 10,
            ),
            _buildContent('Số công tơ', model.meterNumber),
            const SizedBox(
              height: 10,
            ),
            _buildContent(RAppStrings.status, model.workingStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: TextStyle(color: Colors.black.withOpacity(0.8), fontSize: 13),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: PaddingSize.micro),
        Expanded(
          child: Text(
            '$content',
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        )
      ],
    );
  }

  Widget _buildHeader(SubReportMeterModel reportMergeModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                reportMergeModel?.code ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            ReportStatusIcon.build(
              statusText: reportMergeModel?.workingStatus,
              rightPadding: 8,
            ),
            if (reportMergeModel.isAllowEditing)
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert_sharp),
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        if(workMergeModel.isMeter) {
                          await Get.to(() => BBCongToPage(
                            reportID: workMergeModel.formReportId,
                            isAllowEdit: workMergeModel.isAllowEditing,
                          ));
                        } else {
                          await Get.to(ReportScreen(
                            reportId: workMergeModel.formReportId,
                            isAllowEditing: workMergeModel.isAllowEditing,
                          ));
                        }
                        break;
                      case 2:
                        await Get.to(PdfMeterScreen(
                          id: reportMergeModel.id,
                          code: reportMergeModel.code,
                        ));
                        break;
                      default:
                        {}
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Sửa biên bản'),
                        ),
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Xem PDF'),
                        ),
                      ]),
            if (!reportMergeModel.isAllowEditing)
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                    onPressed: () {
                      Get.to(PdfMeterScreen(
                        id: reportMergeModel.id,
                        code: reportMergeModel.code,
                      ));
                    },
                    icon: const Icon(Icons.picture_as_pdf_outlined)),
              ),
          ],
        ),
        const Divider(
          thickness: 1,
          height: 10,
        ),
      ],
    );
  }

  Widget _buildHeaderWork(ReportMeterModel workMergeModel) {
    return Column(
      children: [
        Row(
          children: [
            if (isHasCheckbox &&
                (workMergeModel.isAllowSend ||
                    workMergeModel.isAllowApprovedOrRejected))
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: workMergeModel.isSelected,
                  activeColor: RAppColor.highlightColor70,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) {
                    onSelect(workMergeModel.id, value);
                  },
                ),
              ),
            Expanded(
              child: Text(
                workMergeModel?.equipmentName ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: RAppColor.highlightColor70,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            PopupMenuButton(
                icon: const Icon(Icons.more_vert_sharp),
                onSelected: (value) async {
                  switch (value) {
                    case 1:
                      await Get.to(() => ReportApprovalHistoryScreen(
                            id: workMergeModel.id,
                          ));
                      break;

                    case 2:
                      if(workMergeModel.isMeter) {
                        await Get.to(() => BBCongToPage(
                          reportID: workMergeModel.formReportId,
                          isAllowEdit: workMergeModel.isAllowEditing,
                        ));
                      } else {
                        await Get.to(ReportScreen(
                          reportId: workMergeModel.formReportId,
                          isAllowEditing: workMergeModel.isAllowEditing,
                        ));
                      }
                      break;

                    case 3:
                      await Get.to(() => RMapPage(
                            equipmentDetail: workMergeModel.equipmentName,
                            scheduledId: workMergeModel.id,
                            createDate: workMergeModel.createdDate,
                            location: workMergeModel.location,
                            workType: workMergeModel.workType,
                          ));
                      break;
                    case 5:
                      if (cancelReport != null) {
                        cancelReport(workMergeModel.id);
                      }
                      break;
                    case 9:
                      ReportLocationUtils.checkInAndSendLocation(workMergeModel.formReportId);
                      break;
                    default:
                      {}
                  }
                },
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 1,
                        child: Text('Lịch sử'),
                      ),
                       PopupMenuItem(
                        value: 2,
                        child: Text(workMergeModel.isAllowEditing ? 'Sửa biên bản' :'Xem biên bản'),
                      ),
                      if (workMergeModel.isHasPermissionViewLocation())
                        const PopupMenuItem(
                          value: 3,
                          child: Text('Xem vị trí'),
                        ),
                      // if (workMergeModel.isAllowRecall == true)
                      //   const PopupMenuItem(
                      //     value: 4,
                      //     child: Text('Thu hồi'),
                      //   ),
                      if (workMergeModel.isAllowDelete == true)
                        const PopupMenuItem(
                          value: 5,
                          child: Text('Xóa biên bản'),
                        ),
                      if (workMergeModel.isAllowEditing == true)
                        const PopupMenuItem(
                          value: 9,
                          child: Text('Check in'),
                        ),
                    ])
          ],
        ),
        const Divider(
          thickness: 1,
          height: 10,
        ),
      ],
    );
  }
}

