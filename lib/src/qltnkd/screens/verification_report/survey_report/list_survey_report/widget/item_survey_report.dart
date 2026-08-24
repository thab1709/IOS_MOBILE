// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/widget/history/survey_history_bottom_sheet.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';

class ItemSurveyReport extends StatelessWidget {
  const ItemSurveyReport({
    Key key,
    @required this.model,
    @required this.isFirst,
    @required this.isLast,
    @required this.onGoToDetail,
    @required this.onDelete,
    @required this.onSend,
    @required this.onSign,
    @required this.onReject,
    @required this.onEdit,
    @required this.onExportPdf,
    @required this.onExternalSign,
    this.isSelectMode = false,
    this.isSelected = false,
    this.onSelectChanged,
  }) : super(key: key);

  final SurveyReportModel model;
  final bool isFirst;
  final bool isLast;
  final Function() onGoToDetail;
  final Function() onDelete;
  final Function() onSend;
  final Function() onSign;
  final Function() onReject;
  final Function() onEdit;
  final Function() onExportPdf;
  final Function() onExternalSign;
  final bool isSelectMode;
  final bool isSelected;
  final Function(bool) onSelectChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGoToDetail,
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: isLast ? 30 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Colors.white,
        child: Column(
          children: [
            _buildHeader(context),
            const Divider(height: 24, thickness: 1),
            _buildBody(),
            _buildNextSigner(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (isSelectMode)
          Checkbox(
            value: isSelected,
            onChanged: (val) {
              if (onSelectChanged != null) onSelectChanged(val);
            },
          ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  'Số biên bản: ${model.code ?? ""}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: RAppColor.highlightColor70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        if (model.filePath != null && model.filePath.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
            onPressed: onExportPdf,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        _buildPopupMenu(context),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 1) onSign();
        if (value == 2) onReject();
        if (value == 5) onExternalSign();
        if (value == 4) {
          // Xem lịch sử duyệt
          Get.bottomSheet(
            SurveyHistoryBottomSheet(surveyReportId: model.id),
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
          );
        }
      },
      itemBuilder: (context) {
        List<PopupMenuItem<int>> menu = [];
        if (model.status == SurveyReportStatusCode.waitConfirm || model.status == SurveyReportStatusCode.newReport) {
          menu.add(const PopupMenuItem(value: 5, child: Text('Ký ĐV tư vấn')));
        }
        menu.add(const PopupMenuItem(value: 4, child: Text('Xem lịch sử duyệt')));
        return menu;
      },
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldInfoItem(
          titleFirst: 'Đơn vị QLVH',
          valueFirst: model.qlvhUnitName ?? '',
          titleSecond: 'Người lập',
          valueSecond: model.createdByName ?? '',
        ),
        FieldInfoItem(
          titleFirst: 'Tên công trình',
          valueFirst: model.constructionName ?? '',
        ),
        _buildStatusRow(),
        if (model.status == SurveyReportStatusCode.reject)
          _RejectHistoryInfo(
            id: model.id,
            defaultConfirmBy: model.confirmByName ?? '',
            defaultConfirmDate: model.confirmDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? '',
          )
        else
          FieldInfoItem(
            titleFirst: 'Người xác nhận',
            valueFirst: model.confirmByName ?? '',
            titleSecond: 'Ngày xác nhận',
            valueSecond: model.confirmDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? '',
          ),
        if (model.patcCode != null && model.patcCode.isNotEmpty)
          FieldInfoItem(
            titleFirst: 'Số PATC',
            valueFirst: model.patcCode,
          ),
        _buildExternalSignStatus(),
        _buildNextSigner(),
        _buildBottom(),
      ],
    );
  }

  Widget _buildStatusRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Trạng thái', style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: PaddingSize.micro),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _getStatusColor(model.status)),
                  child: Text(
                    _getStatusName(model.status),
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: PaddingSize.small),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ngày lập', style: TextStyle(color: Colors.grey, fontSize: 15)),
                const SizedBox(height: PaddingSize.micro),
                Text(model.reportDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    if (!model.isAllowSend && !model.isAllowApprove && !model.isAllowReject) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (model.isAllowSend) ...[
            Expanded(
              child: RButton(action: onSend, maxSize: true, title: 'Gửi xác nhận'),
            ),
          ],
          if (model.isAllowReject) ...[
            Expanded(
              child: RButton(
                action: onReject,
                maxSize: true,
                title: 'Từ chối',
                color: Colors.orange,
              ),
            ),
            if (model.isAllowApprove) const SizedBox(width: 12),
          ],
          if (model.isAllowApprove)
            Expanded(
              child: RButton(
                action: onSign,
                maxSize: true,
                title: 'Xác nhận',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExternalSignStatus() {
    if (model.participants != null && model.participants.isNotEmpty) {
      final hasExternalSigned = model.participants.any((p) => (p.isExternal == true || p.groupType == 3) && p.isSigned == true);
      if (!hasExternalSigned) return const SizedBox();
      return _externalSignerWidget();
    }

    return FutureBuilder(
      future: SurveyReportRepository().getDetail(id: model.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final detailRes = snapshot.data;
        if (detailRes != null && detailRes.isLoadSuccess && detailRes.data != null) {
           final participants = detailRes.data.participants ?? [];
           final hasExternalSigned = participants.any((p) => (p.isExternal == true || p.groupType == 3) && p.isSigned == true);
           if (!hasExternalSigned) return const SizedBox();
           return _externalSignerWidget();
        }
        return const SizedBox();
      },
    );
  }

  Widget _externalSignerWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Đơn vị tư vấn', style: TextStyle(color: Colors.grey, fontSize: 15)),
          SizedBox(height: 4),
          Text('Đã ký', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildNextSigner() {
    if (model.nextSignerName != null && model.nextSignerName.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Đang chờ: ${model.nextSignerName} ký xác nhận',
                style: const TextStyle(fontSize: 14, color: Colors.orange, fontStyle: FontStyle.italic),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }

  Color _getStatusColor(int status) {
    if (status == SurveyReportStatusCode.newReport) {
      return Colors.blue;
    } else if (status == SurveyReportStatusCode.waitConfirm) {
      return Colors.orange;
    } else if (status == SurveyReportStatusCode.confirmed) {
      return Colors.green;
    } else if (status == SurveyReportStatusCode.reject) {
      return Colors.red;
    }
    return Colors.grey;
  }

  String _getStatusName(int status) {
    if (status == SurveyReportStatusCode.newReport) return 'Mới';
    if (status == SurveyReportStatusCode.waitConfirm) return 'Chờ xác nhận';
    if (status == SurveyReportStatusCode.confirmed) return 'Đã xác nhận';
    if (status == SurveyReportStatusCode.reject) return 'Bị từ chối';
    return model.statusName ?? '';
  }
}

class _RejectHistoryInfo extends StatefulWidget {
  final String id;
  final String defaultConfirmBy;
  final String defaultConfirmDate;
  const _RejectHistoryInfo({this.id, this.defaultConfirmBy, this.defaultConfirmDate});

  @override
  State<_RejectHistoryInfo> createState() => _RejectHistoryInfoState();
}

class _RejectHistoryInfoState extends State<_RejectHistoryInfo> {
  String actionBy;
  String actionDate;

  @override
  void initState() {
    super.initState();
    actionBy = widget.defaultConfirmBy;
    actionDate = widget.defaultConfirmDate;
    _fetchHistory();
  }

  void _fetchHistory() async {
    final res = await SurveyReportRepository().getHistory(id: widget.id);
    if (res.isLoadSuccess && res.data != null && res.data.isNotEmpty) {
      final rejectItem = res.data.firstWhere((e) => e.action == 3 || e.actionName?.toLowerCase()?.contains('từ chối') == true, orElse: () => res.data.first);
      if (mounted) {
        setState(() {
          actionBy = rejectItem.actionBy ?? widget.defaultConfirmBy;
          actionDate = rejectItem.actionDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? widget.defaultConfirmDate;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FieldInfoItem(
      titleFirst: 'Người từ chối',
      valueFirst: actionBy ?? '',
      titleSecond: 'Ngày từ chối',
      valueSecond: actionDate ?? '',
    );
  }
}

