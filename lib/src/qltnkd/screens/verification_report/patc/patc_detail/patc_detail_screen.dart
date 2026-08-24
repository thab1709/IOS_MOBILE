// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:evnmobile/src/htld/common/utils/snack_bar_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_detail/patc_detail_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_participant_model.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/file_attachment_block.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/widget/patc_history_dialog.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';

class PatcDetailScreen extends StatelessWidget {
  final String id;
  final PatcModel initialModel;

  const PatcDetailScreen({Key key, @required this.id, this.initialModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PatcDetailController>(
      init: PatcDetailController(patcId: id, initialModel: initialModel),
      builder: (controller) {
        return Scaffold(
          backgroundColor: RAppColor.backgroundColorGray,
          appBar: AppBar(
            title: const Text('Chi tiết Phương án thi công', style: TextStyle(fontSize: 18)),
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                tooltip: 'Lịch sử phê duyệt',
                onPressed: () {
                  Get.bottomSheet(
                    PatcHistoryBottomSheet(id: id),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                tooltip: 'Xem PDF',
                onPressed: controller.viewPdf,
              ),
              Builder(
                builder: (context) {
                  final model = controller.model;
                  if (model != null && model.status == 2) { // 2 = Chờ xác nhận
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
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.model == null) {
                return const Center(child: Text('Không tìm thấy dữ liệu'));
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGeneralInfo(controller),
                    const SizedBox(height: 16),
                    _buildParticipantsInfo(controller),
                    const SizedBox(height: 16),
                    _buildFileSections(controller),
                  ],
                ),
              );
            }),
          ),
          bottomNavigationBar: () {
            final model = controller.model;
            if (model == null) return const SizedBox.shrink();
            
            final currentUserId = AppShared.instance.getUserProfile()?.id;
            bool isMyTurn = model.isMyTurn == true;
            if (model.status == 2 && model.participants != null && currentUserId != null) {
              isMyTurn = isMyTurn || model.participants.any((p) => p.userId?.toLowerCase() == currentUserId.toLowerCase() && p.isSigned != true);
            }
            
            bool canSend = model.isAllowSend == true || model.status == 1;
            bool canApprove = model.isAllowApprove == true || isMyTurn;
            bool canReject = model.isAllowReject == true || isMyTurn;
            
            if (!canApprove && !canReject && !canSend) return const SizedBox.shrink();
            return SafeArea(
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    if (canReject)
                      Expanded(
                        child: InkWell(
                          onTap: controller.rejectPatc,
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.orange.shade700,
                            child: const Text('Từ chối', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    if (canSend)
                      Expanded(
                        child: InkWell(
                          onTap: controller.sendPatc,
                          child: Container(
                            alignment: Alignment.center,
                            color: RAppColor.highlightColor70,
                            child: const Text('Gửi xác nhận', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    if (canApprove)
                      Expanded(
                        child: InkWell(
                          onTap: controller.approvePatc,
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
          }(),
        );
      },
    );
  }

  Widget _buildGeneralInfo(PatcDetailController controller) {
    final model = controller.model;

    String statusStr = '';
    if (model.status != null) {
      switch (model.status) {
        case 1: statusStr = 'Mới'; break;
        case 2: statusStr = 'Chờ xác nhận'; break;
        case 3: statusStr = 'Đã xác nhận'; break;
        case 4: statusStr = 'Từ chối'; break;
        default: statusStr = model.statusName ?? 'Trạng thái ${model.status}'; break;
      }
    } else {
      statusStr = model.statusName ?? '';
    }
    
    if (model.signedDate != null && (statusStr.toLowerCase().contains('đã ký') || statusStr.toLowerCase().contains('đã xác nhận'))) {
      statusStr += ' (${model.signedDate.toStringFormat(RAppStrings.ddmmyyyyHHmm)})';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin chung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildRowInfo('Số phương án', model.code ?? ''),
          _buildRowInfo('Tên phương án', model.name ?? ''),
          _buildRowInfo('Công trình', model.constructionName ?? ''),
          _buildRowInfo('Người lập', model.createdByName ?? ''),
          _buildRowInfo('Ngày lập', model.createdDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? ''),
          _buildStatusRow('Trạng thái', model.status ?? 0, statusStr),
          if (model.confirmByName != null && model.confirmByName.isNotEmpty)
            _buildRowInfo('Người xác nhận', model.confirmByName),
          if (model.confirmDate != null)
            _buildRowInfo('Ngày xác nhận', model.confirmDate.toStringFormat(RAppStrings.ddMMyyyy)),
          _buildRowInfo('Đơn vị QLVH', model.qlvhUnitName ?? ''),
          _buildRowInfo('Nội dung', (model.content == null || model.content.isEmpty) ? 'Trống' : model.content),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isHighlight ? Colors.orange : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, int status, String fallbackStr) {
    String statusName = fallbackStr;
    Color color = Colors.grey;

    if (status == 1) {
      statusName = 'Mới';
      color = Colors.blue;
    } else if (status == 2) {
      statusName = 'Chờ xác nhận';
      color = Colors.orange;
    } else if (status == 3) {
      statusName = 'Đã xác nhận';
      color = Colors.green;
    } else if (status == 4) {
      statusName = 'Từ chối';
      color = Colors.red;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 6,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusName,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantsInfo(PatcDetailController controller) {
    final participants = controller.model.participants ?? [];
    final cty = participants.where((p) => p.groupType == 1).toList();
    final qlvh = participants.where((p) => p.groupType == 2).toList();
    final tuVan = participants.where((p) => p.groupType == 3).toList();
    final others = participants.where((p) => p.groupType != 1 && p.groupType != 2 && p.groupType != 3).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thành phần ký duyệt phương án', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          const Text('1. Đơn vị công tác', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _buildParticipantTable(cty),
          const SizedBox(height: 16),
          if (tuVan.isNotEmpty) ...[
            const Text('2. Đơn vị tư vấn / liên quan khác', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildParticipantTable(tuVan),
            const SizedBox(height: 16),
          ],
          const Text('3. Đơn vị QLVH', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          _buildParticipantTable(qlvh),
          if (others.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text('4. Khác', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            _buildParticipantTable(others),
          ],
        ],
      ),
    );
  }

  Widget _buildParticipantTable(List<PatcParticipantModel> list) {
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

  Widget _buildFileSections(PatcDetailController controller) {
    final model = controller.model;

    Widget bbksTable;
    if (model.surveyReports != null && model.surveyReports.isNotEmpty) {
      final List<FileItemModel> bbksFiles = model.surveyReports.map((sr) {
        debugPrint('--- BBKS in PATC: id=${sr.id}, surveyReportId=${sr.patcId}, code=${sr.code} ---');
        final pdfPath = AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/surveyreport/${sr.id}/pdf' : '/api/surveyreport/${sr.id}/pdf';
        
        return FileItemModel(
          fileName: 'BBKS_${sr.code ?? "Template"}.pdf',
          filePath: pdfPath,
          signedFilePath: pdfPath,
        );
      }).toList();

      bbksTable = FileAttachmentGroupBlock(
        title: 'Biên bản khảo sát',
        files: bbksFiles,
      );
    }

    // 2. File PATC
    Widget patcBlock;
    if (model.signedFilePath != null && model.signedFilePath.isNotEmpty) {
      patcBlock = FileAttachmentBlock(
        title: 'File PATC',
        fileName: (model.fileName ?? '').replaceAll('.docx', '.pdf').replaceAll('.doc', '.pdf'),
        filePath: AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}' : '/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}',
        signedFilePath: AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}' : '/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}',
      );
    } else if (model.filePath != null) {
      patcBlock = FileAttachmentBlock(
        title: 'File PATC',
        fileName: (model.fileName ?? 'PATC.pdf').replaceAll('.docx', '.pdf').replaceAll('.doc', '.pdf'),
        filePath: AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}' : '/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}',
        signedFilePath: AppEnv.isDev() ? 'http://125.212.226.94:5006/tnkd/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}' : '/api/constructionplan/${model.id}/pdf?access_token=${AppShared.instance.getUserToken()}',
      );
    }

    // 3. Attachments
    Widget attachmentsBlock;
    if (model.attachments != null && model.attachments.isNotEmpty) {
      final List<FileItemModel> attFiles = [];
      for (int i = 0; i < model.attachments.length; i++) {
        final att = model.attachments[i];
        if (att != null && att is Map) {
          attFiles.add(
            FileItemModel(
              fileName: att['fileName'] ?? att['name'] ?? '',
              filePath: att['url'] ?? att['filePath'] ?? att['path'] ?? '',
              signedFilePath: att['url'] ?? att['filePath'] ?? att['path'] ?? '',
            )
          );
        }
      }
      if (attFiles.isNotEmpty) {
        attachmentsBlock = FileAttachmentGroupBlock(
          title: 'Tài liệu đính kèm',
          files: attFiles,
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bbksTable != null) bbksTable,
        if (patcBlock != null) patcBlock,
        if (attachmentsBlock != null) attachmentsBlock,
      ],
    );
  }
}
