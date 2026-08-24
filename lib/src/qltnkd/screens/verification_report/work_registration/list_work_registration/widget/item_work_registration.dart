// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/list_work_registration_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_detail/work_registration_detail_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_screen.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_detail/widget/history/work_registration_history_bottom_sheet.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/field_infor_item.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';

class ItemWorkRegistration extends StatelessWidget {
  final WorkRegistrationModel item;

  const ItemWorkRegistration({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ListWorkRegistrationController _controller = Get.find();
    
    // Status text and color (Status: 0=Mới, 1=Chờ xác nhận, 2=Đã xác nhận, 3=Từ chối)
    String statusName = item.statusName ?? 'Không xác định';
    Color statusColor = Colors.grey;
    if (item.status == 1) {
      statusName = 'Mới';
      statusColor = Colors.blue;
    } else if (item.status == 2) {
      statusName = 'Chờ xác nhận';
      statusColor = Colors.orange.shade600;
    } else if (item.status == 3) {
      statusName = 'Đã xác nhận';
      statusColor = Colors.green.shade600;
    } else if (item.status == 4) {
      statusName = 'Từ chối';
      statusColor = Colors.red;
    }

    return GestureDetector(
      onTap: () async {
        final result = await Get.to(() => WorkRegistrationDetailScreen(id: item.id), arguments: {
          'canApprove': item.isAllowApprove,
          'canReject': item.isAllowReject,
        });
        if (result == true) {
          _controller.refreshData();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 16, bottom: 0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, _controller),
            const Divider(height: 24, thickness: 1),
            FieldInfoItem(
              titleFirst: 'Đơn vị QLVH',
              valueFirst: item.qlvhUnitName ?? '',
              titleSecond: 'Người lập',
              valueSecond: item.createdByName ?? '',
            ),
            FieldInfoItem(
              titleFirst: 'Tên phiếu',
              valueFirst: item.name ?? '',
            ),
            FieldInfoItem(
              titleFirst: 'Công trình',
              valueFirst: item.constructionName ?? '',
            ),
            if (item.patcCode != null && item.patcCode.isNotEmpty)
              FieldInfoItem(
                titleFirst: 'PATC',
                valueFirst: item.patcCode,
              ),
            _buildStatusRow(statusName, statusColor),
            if (item.status == 4)
              _RejectHistoryInfo(
                id: item.id,
                defaultConfirmBy: item.confirmBy ?? '',
                defaultConfirmDate: item.confirmDate != null ? item.confirmDate.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddMMyyyy) : '',
              )
            else
              FieldInfoItem(
                titleFirst: 'Người xác nhận',
                valueFirst: item.confirmBy ?? '',
                titleSecond: 'Ngày xác nhận',
                valueSecond: item.confirmDate != null ? item.confirmDate.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddMMyyyy) : '',
              ),
            _buildBottom(_controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String statusName, Color statusColor) {
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
                      color: statusColor),
                  child: Text(
                    statusName,
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
                Text(item.registerDate != null ? item.registerDate.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddMMyyyy) : '',
                    style: const TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottom(ListWorkRegistrationController _controller) {
    final isCreator = item.createdBy?.toLowerCase() == AppShared.instance.getUserProfile()?.id?.toLowerCase();
    return Column(
      children: [
        if (item.isAllowSend == true || (item.status == 1 && isCreator))
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: RButton(action: () => _controller.sendRegistration(item.id), maxSize: true, title: 'Gửi xác nhận'),
          ),
        if ((item.isAllowApprove == true || item.isAllowReject == true) && !isCreator)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                if (item.isAllowReject == true)
                  Expanded(
                    child: RButton(
                      action: () => _controller.rejectRegistration(item.id),
                      maxSize: true,
                      title: 'Từ chối',
                      color: Colors.orange.shade700,
                    ),
                  ),
                if (item.isAllowApprove == true && item.isAllowReject == true)
                  const SizedBox(width: 12),
                if (item.isAllowApprove == true)
                  Expanded(
                    child: RButton(
                      action: () => _controller.approveRegistration(item.id),
                      maxSize: true,
                      title: 'Xác nhận',
                      color: RAppColor.highlightColor70,
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }

  void _viewBbksPdf() {
    if (item.id == null || item.id.isEmpty) return;
    final token = AppShared.instance.getUserToken();
    final baseUrl = AppEnv.getServerUrl().replaceAll('/api', '');
    // Dùng đúng API backend của CBM Mobile cho BBKS của ĐKCT
    final urlString = '${AppEnv.getServerUrl()}/workregistration/bbks-pdf/${item.id}?access_token=$token';
    Get.to(() => RPdfScreen(code: 'BBKS ${item.code ?? ""}', link: urlString));
  }

  void _viewDkctPdf() {
    if (item.id == null || item.id.isEmpty) return;
    final token = AppShared.instance.getUserToken();
    final urlString = '${AppEnv.getServerUrl()}/workregistration/dkct-pdf/${item.id}?access_token=$token';
    
    debugPrint('===== DEBUG XEM PDF ĐKCT =====');
    debugPrint('Item ID: ${item.id}');
    debugPrint('URL Full: $urlString');
    debugPrint('==============================');
    
    Get.to(() => RPdfScreen(code: 'ĐKCT ${item.code ?? ""}', link: urlString));
  }

  Widget _buildHeader(BuildContext context, ListWorkRegistrationController _controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            'Số ĐKCT: ${item.code ?? ""}',
            style: const TextStyle(color: RAppColor.highlightColor70, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Builder(builder: (context) {
          final isCreator = item.createdBy?.toLowerCase() == AppShared.instance.getUserProfile()?.id?.toLowerCase();
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.isAllowEdit == true || (item.status == 1 && isCreator) || (item.status == 4 && isCreator))
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () async {
                    final result = await Get.to(() => WorkRegistrationCreateScreen(id: item.id));
                    if (result == true) _controller.refreshData();
                  },
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                ),
              if (item.isAllowEdit == true || (item.status == 1 && isCreator) || (item.status == 4 && isCreator))
                const SizedBox(width: 8),
              if (item.isAllowDelete == true || (item.status == 1 && isCreator))
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _controller.deleteRegistration(item.id),
                  icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                ),
              if (item.isAllowDelete == true || (item.status == 1 && isCreator))
                const SizedBox(width: 8),
            ],
          );
        }),
        IconButton(
          icon: const Icon(Icons.picture_as_pdf, color: Colors.blue),
          onPressed: _viewDkctPdf,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) async {
            if (value == 4) {
              Get.bottomSheet(
                WorkRegistrationHistoryBottomSheet(workRegistrationId: item.id),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            } else if (value == 5) {
              _viewBbksPdf();
            }
          },
          itemBuilder: (context) {
            List<PopupMenuItem<int>> menu = [];
            menu.add(const PopupMenuItem(value: 5, child: Text('Xem BBKS')));
            menu.add(const PopupMenuItem(value: 4, child: Text('Xem lịch sử duyệt')));
            return menu;
          },
        )
      ],
    );
  }

  Widget _buildStatusGridItem(String statusName, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Trạng thái', style: TextStyle(fontSize: 13, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: statusColor),
          ),
          child: Text(
            statusName,
            style: TextStyle(
              color: statusColor,
              fontSize: TextSize.small,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: TextSize.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: TextSize.normal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({IconData icon, String text, Color color, VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
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
    final res = await WorkRegistrationRepository().getHistory(widget.id);
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

