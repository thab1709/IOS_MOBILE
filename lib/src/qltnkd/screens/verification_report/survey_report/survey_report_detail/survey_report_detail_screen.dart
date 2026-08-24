// @dart=2.9
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/common/components/file_attachment_block.dart';
import 'dart:io';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/widget/history/survey_history_bottom_sheet.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_detail/survey_report_detail_controller.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';

class SurveyReportDetailScreen extends StatelessWidget {
  final String surveyReportId;
  final SurveyReportModel initialModel;

  const SurveyReportDetailScreen({Key key, @required this.surveyReportId, this.initialModel})
      : super(key: key);

  Widget build(BuildContext context) {
    final controller = Get.put(
        SurveyReportDetailController(
            surveyReportId: surveyReportId, initialModel: initialModel),
        tag: surveyReportId);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Chi tiết Biên bản khảo sát'),
        actions: [
          Obx(() {
            final model = controller.model.value;
            if (model != null && model.filePath != null && model.filePath.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: 'Xem PDF',
                onPressed: () {
                  final getPdfUrl = AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/surveyreport/$surveyReportId/pdf' : '${AppEnv.getServerUrl()}/surveyreport/$surveyReportId/pdf';
                  debugPrint('--- survey_report_detail_screen PDF url: $getPdfUrl ---');
                  Get.to(() => RPdfScreen(link: getPdfUrl, code: 'Biên bản khảo sát'));
                },
              );
            }
            return const SizedBox();
          }),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Lịch sử phê duyệt',
            onPressed: () {
              Get.bottomSheet(
                SurveyHistoryBottomSheet(surveyReportId: surveyReportId),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
          ),
          Obx(() {
            final model = controller.model.value;
            if (model != null && (model.status == SurveyReportStatusCode.waitConfirm || model.status == SurveyReportStatusCode.newReport)) {
              return PopupMenuButton<int>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 5) {
                    controller.handleExternalSign();
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(value: 5, child: Text('Ký ĐV tư vấn')),
                  ];
                },
              );
            }
            return const SizedBox();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final model = controller.model.value;
        if (model == null) {
          return const Center(child: Text('Không tìm thấy dữ liệu'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildGeneralInfo(model),
              const SizedBox(height: 16),
              _buildParticipants(model),
              _buildAttachmentsList(controller),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        final model = controller.model.value;
        if (model == null) return const SizedBox.shrink();
        
        final currentUserId = AppShared.instance.getUserProfile()?.id;
        bool isMyTurn = false;
        // Trạng thái 1 = Chờ xác nhận (theo enum SurveyReportStatusCode.waitConfirm)
        if (model.status == SurveyReportStatusCode.waitConfirm && model.participants != null && currentUserId != null) {
          isMyTurn = model.participants.any((p) => p.userId == currentUserId && p.isSigned != true);
        }
        
        bool canApprove = model.isAllowApprove == true || isMyTurn;
        bool canReject = model.isAllowReject == true || isMyTurn;
        
        if (!canApprove && !canReject) return const SizedBox.shrink();
        
        return SafeArea(
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                if (canReject)
                  Expanded(
                    child: InkWell(
                      onTap: controller.rejectReport,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.orange.shade700,
                        child: const Text('Từ chối', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                if (canApprove)
                  Expanded(
                    child: InkWell(
                      onTap: controller.approveReport,
                      child: Container(
                        alignment: Alignment.center,
                        color: RAppColor.highlightColor70,
                        child: const Text('Xác nhận', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildGeneralInfo(SurveyReportModel model) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thông tin chung',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildRow('Số biên bản', model.code ?? ''),
            _buildRow('Tên biên bản', model.name ?? ''),
            _buildRow('Công trình', model.constructionName ?? ''),
            _buildRow('Người lập', model.createdByName ?? ''),
            _buildRow(
                'Ngày lập',
                model.createdDate?.toStringFormat(RAppStrings.ddMMyyyy) ??
                    ''),
            _buildStatusRow('Trạng thái', model.status, model.statusName),
            _buildRow('Đơn vị QLVH', model.qlvhUnitName ?? ''),
            _buildRow('Người xác nhận', model.confirmByName ?? ''),
            _buildRow(
                'Ngày xác nhận',
                model.confirmDate?.toStringFormat(RAppStrings.ddmmyyyyHHmm) ??
                    ''),
            if (model.nextSignerName != null && model.nextSignerName.isNotEmpty)
              _buildRow('Đang chờ ký xác nhận', model.nextSignerName),
            _buildRow('Ghi chú', (model.note != null && model.note.isNotEmpty) ? model.note : 'Trống'),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipants(SurveyReportModel model) {
    final list = model.participants ?? <SurveyReportParticipantModel>[];
    final group1 = list.where((e) => e.groupType == 1).toList();
    final group3 = list.where((e) => e.groupType == 3).toList();
    final group2 = list.where((e) => e.groupType == 2).toList();
    final others = list.where((e) => e.groupType != 1 && e.groupType != 2 && e.groupType != 3).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thành phần ký duyệt biên bản',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            _buildParticipantGroup('1. Đơn vị công tác', group1),
            const SizedBox(height: 16),
            _buildParticipantGroup('2. Đơn vị liên quan khác', group3),
            const SizedBox(height: 16),
            _buildParticipantGroup('3. Đơn vị Quản lý vận hành', group2),
            if (others.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildParticipantGroup('4. Khác', others),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantGroup(
      String title, List<SurveyReportParticipantModel> list) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        if (list.isEmpty)
          const Text('Trống', style: TextStyle(color: Colors.grey))
        else
          _buildParticipantTable(list),
      ],
    );
  }

  Widget _buildParticipantTable(List<SurveyReportParticipantModel> list) {
    if (list.isEmpty) return const Text('Chưa có dữ liệu', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey));
    
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(0.8),
      },
      border: TableBorder.all(color: Colors.grey.shade300, width: 1),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade100),
          children: [
            _buildTableCell('Đơn vị đại diện', isHeader: true),
            _buildTableCell('Họ và tên', isHeader: true),
            _buildTableCell('Chức vụ', isHeader: true),
            _buildTableCell('Trạng thái ký', isHeader: true),
            _buildTableCell('Loại', isHeader: true),
          ],
        ),
        ...list.map((p) {
          String status = p.isSigned == true ? 'Đã ký' : 'Chờ ký';
          Color statusColor = p.isSigned == true ? Colors.green : Colors.orange;

          if (p.isExternal == true && p.isSigned == true && p.signatureCapturedByName != null) {
            status = 'Ký tay — thu bởi: ${p.signatureCapturedByName}';
          } else if (p.signedDate != null) {
            status += '\n(${p.signedDate.toStringFormat(RAppStrings.ddmmyyyyHHmm)})';
          }
          
          return TableRow(
            children: [
              _buildTableCell(p.unitName ?? ''),
              _buildTableCell(p.fullName ?? ''),
              _buildTableCell(p.position ?? ''),
              _buildTableCell(status, color: statusColor),
              _buildTableCell(p.isExternal == true ? 'Ngoài EVN' : 'EVN', color: p.isExternal == true ? Colors.orange : Colors.black87),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildTableCell(String text, {bool isHeader = false, Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
          color: color ?? (isHeader ? Colors.black87 : Colors.black54),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label, style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, int status, String apiStatusName) {
    String statusName = apiStatusName ?? '';
    if (status == SurveyReportStatusCode.newReport) statusName = 'Mới';
    if (status == SurveyReportStatusCode.waitConfirm) statusName = 'Chờ xác nhận';
    if (status == SurveyReportStatusCode.confirmed) statusName = 'Đã xác nhận';
    if (status == SurveyReportStatusCode.reject) statusName = 'Bị từ chối';

    Color color = Colors.grey;
    if (status == SurveyReportStatusCode.newReport) color = Colors.blue;
    if (status == SurveyReportStatusCode.waitConfirm) color = Colors.orange;
    if (status == SurveyReportStatusCode.confirmed) color = Colors.green;
    if (status == SurveyReportStatusCode.reject) color = Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
              width: 120,
              child: Text(label, style: const TextStyle(color: Colors.grey))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                border: Border.all(color: color),
                borderRadius: BorderRadius.circular(4)),
            child: Text(
              statusName,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentsList(SurveyReportDetailController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tài liệu đính kèm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            Obx(() {
              if (controller.attachments.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('Trống', style: TextStyle(color: Colors.grey)),
                );
              }
              return Column(
                children: controller.attachments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final att = entry.value;
                  final fileName = att['fileName'] ?? att['name'] ?? 'Tài liệu ${index + 1}';
                  final isLocal = att['isLocal'] == true;
                  String filePath;
                  if (isLocal) {
                    filePath = att['path'] ?? '';
                  } else {
                    final u = att['url'];
                    final fp = att['filePath'];
                    final p = att['path'];
                    filePath = (u != null && u.toString().isNotEmpty) ? u
                             : (fp != null && fp.toString().isNotEmpty) ? fp
                             : p ?? '';
                  }
                  
                  final nameLower = (fileName ?? filePath ?? '').toLowerCase();
                  final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');

                  Widget iconWidget = const Icon(Icons.attach_file, size: 16, color: Colors.blue);

                  if (isImage && filePath != null && filePath.isNotEmpty) {
                    if (isLocal) {
                      iconWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          File(filePath),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, color: Colors.blue, size: 16),
                        ),
                      );
                    } else {
                      String fullPath = filePath.replaceAll('\\', '/');
                      if (!fullPath.startsWith('http')) {
                        if (!fullPath.startsWith('/')) {
                          fullPath = '/$fullPath';
                        }
                        fullPath = '${AppEnv.getServerUrl().replaceAll('/api', '')}$fullPath';
                      }
                      if (!fullPath.contains('access_token=')) {
                        final token = AppShared.instance.getUserToken();
                        final separator = fullPath.contains('?') ? '&' : '?';
                        fullPath = '$fullPath${separator}access_token=$token';
                      }
                      iconWidget = ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: fullPath,
                          httpHeaders: {
                            'Authorization': 'Bearer ${AppShared.instance.getUserToken()}'
                          },
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                              width: 40, height: 40, color: Colors.grey.shade200, child: const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)))),
                          errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.blue, size: 16),
                        ),
                      );
                    }
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        iconWidget,
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (filePath != null && filePath.isNotEmpty) {
                                if (isLocal && isImage) {
                                  controller.viewLocalImage(filePath);
                                } else {
                                  controller.downloadFile(filePath);
                                }
                              }
                            },
                            child: Text(fileName, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                          )
                        ),
                        if (controller.model.value?.isAllowEdit == true)
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                            onPressed: () => controller.onRemoveAttachment(index),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }),
            Obx(() {
              if (controller.model.value?.isAllowEdit == true) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: ElevatedButton.icon(
                    onPressed: controller.onAddAttachment,
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Tải lên đính kèm'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                  ),
                );
              }
              return const SizedBox();
            }),
          ],
        ),
      ),
    );
  }
}
