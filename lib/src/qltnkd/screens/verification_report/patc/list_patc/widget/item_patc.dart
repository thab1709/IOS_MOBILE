// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/repository/patc_repository.dart';

class ItemPatc extends StatelessWidget {
  const ItemPatc({
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
    @required this.onDownload,
    @required this.onHistory,
    @required this.onExternalSign,
    this.onCreateWorkRegistration,
  }) : super(key: key);

  final PatcModel model;
  final bool isFirst;
  final bool isLast;
  final Function() onGoToDetail;
  final Function() onDelete;
  final Function() onSend;
  final Function() onSign;
  final Function() onReject;
  final Function() onEdit;
  final Function() onExportPdf;
  final Function() onDownload;
  final Function() onHistory;
  final Function() onCreateWorkRegistration;
  final Function() onExternalSign;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onGoToDetail,
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: isLast ? 30 : 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const Divider(height: 24, thickness: 1),
            _buildBody(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Số PATC: ${model.code ?? ""}',
            style: const TextStyle(color: RAppColor.highlightColor70, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        if (model.isAllowDelete == true)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onDelete,
            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
          ),
        if (model.isAllowDelete == true)
          const SizedBox(width: 8),
        if (model.filePath != null && model.filePath.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
            onPressed: onExportPdf,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == 1) onSign();
            if (value == 2) onReject();
            if (value == 5) onExternalSign();
            if (value == 4) onHistory();
          },
          itemBuilder: (context) {
            List<PopupMenuItem<int>> menu = [];
            if (model.status == 2) { // 2 = Chờ xác nhận
              menu.add(const PopupMenuItem(value: 5, child: Text('Ký ĐV tư vấn')));
            }
            menu.add(const PopupMenuItem(value: 4, child: Text('Xem lịch sử duyệt')));
            return menu;
          },
        )
      ],
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
          titleFirst: 'Tên PATC',
          valueFirst: model.name ?? '',
        ),
        FieldInfoItem(
          titleFirst: 'Tên công trình',
          valueFirst: model.constructionName ?? '',
        ),
        _buildStatusRow(),
        if (model.status == 4)
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
                      color: _getStatusColor()),
                  child: Text(
                    _getStatusName(),
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
                Text(model.createdDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom() {
    final currentUserId = AppShared.instance.getUserProfile()?.id;
    bool isMyTurn = model.isMyTurn == true;
    if (model.status == 2 && model.participants != null && currentUserId != null) {
      isMyTurn = isMyTurn || model.participants.any((p) => p.userId?.toLowerCase() == currentUserId.toLowerCase() && p.isSigned != true);
    }
    
    bool canSend = model.isAllowSend == true || model.status == 1;
    bool canApprove = model.isAllowApprove == true || isMyTurn;
    bool canReject = model.isAllowReject == true;
    
    if (!canSend && !canApprove && !canReject) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          if (canSend) ...[
            Expanded(
              child: RButton(action: onSend, maxSize: true, title: 'Gửi xác nhận'),
            ),
          ],
          if (canReject) ...[
            Expanded(
              child: RButton(
                action: onReject,
                maxSize: true,
                title: 'Từ chối',
                color: Colors.orange,
              ),
            ),
            if (canApprove) const SizedBox(width: 12),
          ],
          if (canApprove)
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

  Widget _buildStatusGridItem() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trạng thái', style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: _getStatusColor(),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            _getStatusName(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        )
      ],
    );
  }

  Widget _buildExternalSignStatus() {
    if (model.participants != null && model.participants.isNotEmpty) {
      final hasExternalSigned = model.participants.any((p) => (p.isExternal == true || p.groupType == 3) && p.isSigned == true);
      if (!hasExternalSigned) return const SizedBox();
      return _externalSignerWidget();
    }

    return FutureBuilder(
      future: PatcRepository().getPatcDetail(model.id),
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
        padding: const EdgeInsets.only(top: 16.0),
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

  Color _getStatusColor() {
    if (model.status == EnumSurveyReport.newReport.getCode()) return Colors.blue;
    if (model.status == EnumSurveyReport.waitConfirm.getCode()) return Colors.orange;
    if (model.status == EnumSurveyReport.confirmed.getCode()) return Colors.green;
    if (model.status == EnumSurveyReport.reject.getCode()) return Colors.red;
    return Colors.grey;
  }

  String _getStatusName() {
    if (model.status == EnumSurveyReport.newReport.getCode()) return 'Mới';
    if (model.status == EnumSurveyReport.waitConfirm.getCode()) return 'Chờ xác nhận';
    if (model.status == EnumSurveyReport.confirmed.getCode()) return 'Đã xác nhận';
    if (model.status == EnumSurveyReport.reject.getCode()) return 'Từ chối';
    return model.statusName ?? 'Không xác định';
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
    final res = await PatcRepository().getPatcHistory(widget.id);
    if (res.isLoadSuccess && res.data != null && res.data.isNotEmpty) {
      final rejectItem = res.data.firstWhere((e) => e.action == 4 || e.action == 3 || e.actionName?.toLowerCase()?.contains('từ chối') == true, orElse: () => res.data.first);
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

