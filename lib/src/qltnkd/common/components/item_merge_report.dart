// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/map/map_page.dart';
import 'package:evnmobile/src/qltnkd/models/report_merge_model.dart';
import 'package:evnmobile/src/qltnkd/models/work_merge_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/pdf/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_approval_history/report_approval_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'field_info_item_vertical.dart';
import 'field_infor_item.dart';

class ItemMergeReport extends StatelessWidget {
  final int index;
  final WorkMergeModel workMergeModel;
  final bool isLast;
  final bool isHasCheckbox;
  final Function(String, bool) onSelect;
  final Function() expandItem;
  final Function(String, int) exportCertificate;
  final Function(String) recall;
  final Function(String) cancelReport;
  final String reportStatus;

  const ItemMergeReport({
    @required this.expandItem,
    this.workMergeModel,
    this.index,
    this.isLast = false,
    this.isHasCheckbox = false,
    this.onSelect,
    this.exportCertificate,
    this.recall,
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
      decoration: BoxDecoration(
          color: Colors.white,
          border: (workMergeModel?.isSync == false ||
                  workMergeModel.formReportId
                      .contains(RDatabaseBoxName.nameTemp))
              ? Border.all(color: RAppColor.colorOrange)
              : null,
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: _renderNormal(workMergeModel, context),
    );
  }

  Widget _renderNormal(WorkMergeModel item, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderWork(item),
        FieldInfoItem(
          titleFirst: 'Loại công việc',
          valueFirst: item?.workType,
          titleSecond: 'Đơn vị yêu cầu',
          valueSecond: item?.unitRequest,
        ),
        FieldInfoItem(
          titleFirst: 'Loại thiết bị',
          valueFirst: item?.equipmentTypeName,
          titleSecond: 'Tên thiết bị',
          valueSecond: item?.equipmentName,
        ),
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

  Widget _buildItemReport(ReportMergeModel model) {
    if (reportStatus != null &&
        model.workingStatus.toString() != reportStatus &&
        reportStatus != '0') {
      return Container();
    }

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
            _buildContent(RAppStrings.temNumber, model.getTemNumber()),
            const SizedBox(
              height: 10,
            ),
            _buildContent('Kiểu', model.type),
            const SizedBox(
              height: 10,
            ),
            _buildContentStatus(RAppStrings.status, model.status, model),
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

  Widget _buildContentStatus(String title, String content, ReportMergeModel model) {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              model.getStatusIconWidget(),
              Text(
                '$content',
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildHeader(ReportMergeModel reportMergeModel) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                reportMergeModel.reportNumber ?? '',
                textAlign: TextAlign.start,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            reportMergeModel.getStatusIconWidget(),
            if (reportMergeModel.isShowIconMore())
              PopupMenuButton(
                  icon: const Icon(Icons.more_vert_sharp),
                  onSelected: (value) async {
                    switch (value) {
                      case 1:
                        if (reportMergeModel.formType != FormType.certificate) {
                          await Get.to(RPdfScreen(
                            id: reportMergeModel.isCbm ? reportMergeModel.refId : reportMergeModel.id,
                            code: reportMergeModel.reportNumber,
                            isMonitor: reportMergeModel.isMonitor,
                            isCbm: reportMergeModel.isCbm,
                          ));
                        } else {
                          await Get.to(RPdfCertificateScreen(
                            id: reportMergeModel.id,
                            code: reportMergeModel.reportNumber,
                          ));
                        }
                        break;

                      case 2:
                        exportCertificate(reportMergeModel.id, 2);
                        break;

                      case 3:
                        exportCertificate(reportMergeModel.id, 1);
                        break;

                      default:
                        {}
                    }
                  },
                  itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 1,
                          child: Text('Xem PDF'),
                        ),
                        if (reportMergeModel.exportCertificateTest)
                          const PopupMenuItem(
                            value: 2,
                            child: Text('Xuất giấy chứng nhận kiểm tra'),
                          ),
                        if (reportMergeModel.exportCertificateAccreditation)
                          const PopupMenuItem(
                            value: 3,
                            child: Text('Xuất giấy chứng nhận kiểm định'),
                          ),
                      ]),
            if (!reportMergeModel.isShowIconMore())
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                    onPressed: () {
                      if (reportMergeModel.formType != FormType.certificate) {
                        Get.to(RPdfScreen(
                          id: reportMergeModel.isCbm ? reportMergeModel.refId : reportMergeModel.id,
                          code: reportMergeModel.reportNumber,
                          isMonitor: reportMergeModel.isMonitor,
                          isCbm: reportMergeModel.isCbm,
                        ));
                      } else {
                        Get.to(RPdfCertificateScreen(
                          id: reportMergeModel.id,
                          code: reportMergeModel.reportNumber,
                        ));
                      }
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

  Widget _buildHeaderWork(WorkMergeModel workMergeModel) {
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
            const Icon(Icons.info_outline, color: Colors.grey, size: 14), // Test static icon
            workMergeModel.getStatusIconWidget(),
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
                      await Get.to(ReportScreen(
                        reportId: workMergeModel.formReportId,
                        isAllowEditing: workMergeModel.isAllowEditing,
                        isCbm: workMergeModel.isCbm,
                      ));
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
                    case 4:
                      if(recall != null) {
                        recall(workMergeModel.id);
                      }
                      break;
                    case 5:
                      if(cancelReport != null) {
                        cancelReport(workMergeModel.id);
                      }
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
                      const PopupMenuItem(
                        value: 2,
                        child: Text('Xem biên bản'),
                      ),
                      if (workMergeModel.isHasPermissionViewLocation())
                        const PopupMenuItem(
                          value: 3,
                          child: Text('Xem vị trí'),
                        ),
                      if (workMergeModel.isAllowRecall == true)
                        const PopupMenuItem(
                          value: 4,
                          child: Text('Thu hồi'),
                        ),
                      if (workMergeModel.isAllowCancel == true)
                        const PopupMenuItem(
                          value: 5,
                          child: Text('Hủy biên bản'),
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

