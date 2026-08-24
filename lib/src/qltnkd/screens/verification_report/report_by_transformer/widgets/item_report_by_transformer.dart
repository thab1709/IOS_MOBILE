// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/report_location_utils.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report_by_transformer/widgets/detail_work.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../app_common/shared/app_shared.dart';
import '../../../../common/constance/common.dart';
import '../../../../common/constance/report_work_status_type.dart';
import '../../../../common/constance/strings.dart';
import '../../../../map/map_page.dart';
import '../../../../models/report_merge_model.dart';
import '../../../../models/work_merge_model.dart';
import '../../certificate/pdf/pdf_view.dart';
import '../../list_report/pdf_view/pdf_view.dart';
import '../../report/report_screen.dart';
import '../../report_approval_history/report_approval_history_screen.dart';
import '../report_by_transformer_controller.dart';

class ItemReportByTransformer extends StatelessWidget {
  ItemReportByTransformer(
      {@required this.model,
      @required this.exportCertificate,
      @required this.checkSubstation,
      @required this.checkEquipment,
      @required this.recall,
      @required this.cancelReport,
      @required this.sendReport,
      @required this.rejectReport,
      @required this.approveReport,
      @required this.getDetail,
      this.index,
      Key key})
      : super(key: key);

  final ReportByTransformerModel model;
  final int index;
  final Function(String, int, WorkMergeModel) exportCertificate;
  final Function(ReportByTransformerModel) checkSubstation;
  final Function(ReportByTransformerModel, WorkMergeModel) checkEquipment;
  final Function(String) recall;
  final Function(String) cancelReport;
  final Function(WorkMergeModel) sendReport;
  final Function(WorkMergeModel) getDetail;
  final Function(WorkMergeModel) rejectReport;
  final Function(WorkMergeModel) approveReport;
  final user = AppShared.instance.getUserProfile();

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      tileColor: Colors.grey.shade300,
      style: ListTileStyle.list,
      child: ExpansionTile(
        initiallyExpanded: model.isExpand == true,
        backgroundColor: Colors.white,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          title: CheckboxListTile(
            title: Text(
              model?.transformerName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            contentPadding: EdgeInsets.zero,
            value: model.isSelected == true,
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool value) {
              checkSubstation(model);
            },
          ),
        ),
        onExpansionChanged: (value) {},
        children: [...model.mergeModels.map(buildExpandedEquipment).toList()],
      ),
    );
  }

  Widget _buildContentReport(String title, String content) {
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

  Widget _buildHeaderReport(
      ReportMergeModel reportMergeModel, WorkMergeModel workMergeModel) {
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
                        exportCertificate(
                            reportMergeModel.id, 2, workMergeModel);
                        break;

                      case 3:
                        exportCertificate(
                            reportMergeModel.id, 1, workMergeModel);
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

  Widget buildReport(ReportMergeModel model, WorkMergeModel workMergeModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      child: Card(
        elevation: 0,
        color: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              _buildHeaderReport(model, workMergeModel),
              const SizedBox(
                height: 10,
              ),
              _buildContentReport(RAppStrings.temNumber, model.getTemNumber()),
              const SizedBox(
                height: 10,
              ),
              _buildContentReport('Kiểu', model.type),
              const SizedBox(
                height: 10,
              ),
              _buildContentStatus(RAppStrings.status, model.status, model),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildExpandedEquipment(WorkMergeModel workMergeModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: ListTileTheme(
        tileColor: Colors.grey.shade300,
        style: ListTileStyle.list,
        child: ExpansionTile(
          initiallyExpanded: workMergeModel.isExpand == true,
          backgroundColor: Colors.white,
          title: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Expanded(
                  child: CheckboxListTile(
                    title: Text(workMergeModel?.equipmentName ?? '', style: TextStyle(color: workMergeModel.isPaperReport == true ? Colors.red.shade300 : Colors.black),),
                    contentPadding: EdgeInsets.zero,
                    value: workMergeModel.isSelected == true,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool value) {
                      checkEquipment(model, workMergeModel);
                    },
                  ),
                ),
                PopupMenuButton(
                    icon: const Icon(Icons.more_vert_sharp),
                    onSelected: (value) async {
                      switch (value) {
                        case 0:
                          await Get.to(() => DetailWork(
                                model: workMergeModel,
                              ));
                          break;

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
                              isEdit: true,
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
                          if (recall != null) {
                            recall(workMergeModel.id);
                          }
                          break;
                        case 5:
                          if (cancelReport != null) {
                            cancelReport(workMergeModel.id);
                          }
                          break;
                        case 6:
                          if (sendReport != null) {
                            sendReport(workMergeModel);
                          }
                          break;
                        case 7:
                          if (rejectReport != null) {
                            workMergeModel.isSelected = true;
                            rejectReport(workMergeModel);
                          }
                          break;
                        case 8:
                          if (approveReport != null) {
                            workMergeModel.isSelected = true;
                            approveReport(workMergeModel);
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
                            value: 0,
                            child: Text('Chi tiết công việc'),
                          ),
                          const PopupMenuItem(
                            value: 1,
                            child: Text('Lịch sử'),
                          ),
                          PopupMenuItem(
                            value: 2,
                            child: Text(workMergeModel.isAllowEditing == true
                                ? 'Sửa biên bản'
                                : 'Xem biên bản'),
                          ),
                          if (workMergeModel.isHasPermissionViewLocation())
                            const PopupMenuItem(
                              value: 3,
                              child: Text('Xem vị trí'),
                            ),
                          if (workMergeModel.isAllowRecall == true &&
                              user.isFormReportRecall())
                            const PopupMenuItem(
                              value: 4,
                              child: Text('Thu hồi'),
                            ),
                          if (workMergeModel.isAllowCancel == true &&
                              user.isFormReportCancel())
                            const PopupMenuItem(
                              value: 5,
                              child: Text('Hủy biên bản'),
                            ),
                          if (workMergeModel.isAllowSend == true &&
                              user.isFormReportSend())
                            const PopupMenuItem(
                              value: 6,
                              child: Text('Gửi biên bản'),
                            ),
                          if (workMergeModel.isAllowApprovedOrRejected ==
                                  true &&
                              user.isFormReportReject())
                            const PopupMenuItem(
                              value: 7,
                              child: Text('Từ chối'),
                            ),
                          if (workMergeModel.isAllowApprovedOrRejected ==
                                  true &&
                              user.isFormReportApprove())
                            const PopupMenuItem(
                              value: 8,
                              child: Text('Phê duyệt'),
                            ),
                          if (workMergeModel.isAllowEditing == true)
                            const PopupMenuItem(
                              value: 9,
                              child: Text('Check in'),
                            ),
                        ])
              ],
            ),
          ),
          onExpansionChanged: (value) {
            if (value &&
                (workMergeModel.reportMergeModels == null ||
                    workMergeModel.reportMergeModels.isEmpty)) {
              getDetail(workMergeModel);
            }
          },
          children: [
            ...workMergeModel?.reportMergeModels
                    ?.map((e) => buildReport(e, workMergeModel))
                    ?.toList() ??
                []
          ],
        ),
      ),
    );
  }
}

