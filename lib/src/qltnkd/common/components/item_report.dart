// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/report_work_status_type.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/list_report_model.dart';
import 'package:evnmobile/src/qltnkd/offline_service/local_data_manager.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/detail_report/detail_report_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_button.dart';
import 'field_infor_item.dart';

class ItemReport extends StatelessWidget {
  const ItemReport({@required this.report,
    this.isHasCheckBox = true,
    this.onSelect,
    this.index,
    this.isLast = false,
    this.reloadData,
    this.showMap,
    Key key})
      : super(key: key);
  final ListReportModel report;
  final bool isHasCheckBox;
  final int index;
  final bool isLast;
  final Function() reloadData;
  final Function() showMap;

  final Function(String, bool) onSelect;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Get.to(ReportScreen(
            reportType: report.reportType,
            reportId: report.id,
            isAllowEditing: report.isEdit(),
            isCbm: report.isCbm,
          ));
        if (reloadData != null) {
          reloadData();
        }
      },
      child: Container(
        margin: EdgeInsets.only(
            top: index == 0 ? 20 : 10,
            bottom: isLast ? 16 : 8,
            left: 16,
            right: 16),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
            color: Colors.white,
            border: (report?.isSync == false ||
                report.id.contains(RDatabaseBoxName.nameTemp))
                ? Border.all(color: RAppColor.colorOrange) : null,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Column(
          children: [
            _buildHeader(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  FieldInfoItem(
                    titleFirst: RAppStrings.reportType,
                    valueFirst: report?.reportTypeName,
                    titleSecond: RAppStrings.equipmentDetail,
                    valueSecond: report?.equipmentDetail,
                  ),
                  FieldInfoItem(
                    titleFirst: RAppStrings.performer,
                    valueFirst: report?.userImp,
                    titleSecond: RAppStrings.status,
                    valueSecondWidget: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (report != null) report.getStatusIconWidget(),
                        Flexible(
                          child: Text(
                            report?.workingStatusName ?? '',
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FieldInfoItem(
                    titleFirst: RAppStrings.content,
                    valueFirst: report?.content,
                    titleSecond: RAppStrings.team,
                    valueSecond: report?.team,
                  ),
                  FieldInfoItem(
                    titleFirst: RAppStrings.initDate,
                    valueFirst: report?.getCreateDate(),
                    titleSecond: RAppStrings.titleSchedule,
                    valueSecond: report?.workId == null
                        ? RAppStrings.scheduleNot
                        : RAppStrings.schedule,
                  ),
                  FieldInfoItem(
                    titleFirst: RAppStrings.location,
                    valueFirst: report?.location,
                  ),
                //  _buildButtonSignature(report.isAlowSign, signatureReport)

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          children: [
            if (isHasCheckBox)
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: report.isSelected,
                  activeColor: RAppColor.highlightColor70,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) {
                    onSelect(report.id, value);
                  },
                ),
              ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  report?.reportNumber ?? '',
                  style: const TextStyle(
                      fontSize: TextSize.big,
                      color: RAppColor.highlightColor70,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (report != null) report.getStatusIconWidget(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton(onPressed: () {
                Get.to(() => RPdfScreen(id: report.id, code: report.reportNumber, isViewPDFUnscheduled: true,));
              }, icon: const Icon(Icons.picture_as_pdf_outlined)),
            )
          ],
        ),
        const Divider(
          thickness: 1,
          height: 30,
        ),
      ],
    );
  }

  Widget _buildButtonExport(bool isShowButton, String title, Function(int) action, int certificateType) {
    if(!isShowButton){
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: RButton(
        maxSize: true,
        action: () {
          if (action != null) {
            action(certificateType);
          }
        },
        title: title,
      ),
    );
  }

  Widget _buildButtonSignature(bool isShowButton, Function() action) {
    if(!isShowButton){
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: RButton(
        maxSize: true,
        action: () async {
          if (action != null)  {
            await rShowMyDialogOkCancel('Bạn có chắc muốn kí biên bản này', secondFunction: () {
              action();
            });
          }
        },
        title: 'Ký số',
      ),
    );
  }
}

