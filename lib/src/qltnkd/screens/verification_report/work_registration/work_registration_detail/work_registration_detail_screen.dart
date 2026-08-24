// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_detail/work_registration_detail_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_screen.dart';
import 'package:evnmobile/src/qltnkd/common/components/file_attachment_block.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_detail/widget/history/work_registration_history_bottom_sheet.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';

class WorkRegistrationDetailScreen extends StatelessWidget {
  final String id;

  const WorkRegistrationDetailScreen({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _controller = Get.put(WorkRegistrationDetailController(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đăng ký công tác', style: TextStyle(fontSize: TextSize.normal)),
        centerTitle: false,
        actions: [
          Obx(() {
            final detail = _controller.detail.value;
            if (detail != null && detail.id != null) {
              return IconButton(
                icon: const Icon(Icons.picture_as_pdf),
                tooltip: 'Xem PDF',
                onPressed: () {
                  final token = AppShared.instance.getUserToken();
                  final urlString = '${AppEnv.getServerUrl()}/workregistration/dkct-pdf/${detail.id}?access_token=$token';
                  Get.to(() => RPdfScreen(code: 'ĐKCT ${detail.code ?? ""}', link: urlString));
                },
              );
            }
            return const SizedBox();
          }),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Lịch sử duyệt',
            onPressed: () {
              Get.bottomSheet(
                WorkRegistrationHistoryBottomSheet(workRegistrationId: id),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
          ),
          Obx(() {
            final detail = _controller.detail.value;
            if (detail == null) return const SizedBox.shrink();
            
            return PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'edit') {
                  final result = await Get.to(() => WorkRegistrationCreateScreen(id: id));
                  if (result == true) {
                    _controller.fetchData();
                  }
                } else if (value == 'delete') {
                  _controller.delete();
                } else if (value == 'send') {
                  _controller.send();
                }
              },
              itemBuilder: (BuildContext context) {
                List<PopupMenuItem<String>> menu = [];
                final isCreator = detail.createdBy?.toLowerCase() == AppShared.instance.getUserProfile()?.id?.toLowerCase();
                
                if (detail.isAllowEdit == true || (detail.status == 1 && isCreator) || (detail.status == 4 && isCreator)) {
                  menu.add(const PopupMenuItem(value: 'edit', child: Text('Sửa')));
                }
                if (detail.isAllowSend == true || (detail.status == 1 && isCreator)) {
                  menu.add(const PopupMenuItem(value: 'send', child: Text('Gửi duyệt')));
                }
                if (detail.isAllowDelete == true || (detail.status == 1 && isCreator)) {
                  menu.add(const PopupMenuItem(value: 'delete', child: Text('Xóa', style: TextStyle(color: Colors.red))));
                }
                return menu;
              },
            );
          }),
        ],
      ),
      backgroundColor: RAppColor.backgroundColorGray,
      body: SafeArea(
        child: Obx(
          () => _controller.isLoading.value
              ? const Center(child: CupertinoActivityIndicator())
              : _controller.detail.value == null
                  ? const Center(child: Text('Không tìm thấy dữ liệu', style: TextStyle(color: Colors.grey)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionTitle('Thông tin chung'),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRow('Số phiếu ĐKCT:', _controller.detail.value.code ?? ''),
                                _buildRow('Tên phiếu ĐKCT:', _controller.detail.value.name ?? ''),
                                _buildRow('Tên công trình:', _controller.detail.value.constructionName ?? ''),
                                _buildRow('Số PATC:', _controller.detail.value.patcCode ?? ''),
                                _buildRow('Đơn vị QLVH:', _controller.detail.value.qlvhUnitName ?? ''),
                                _buildRow('Người lập:', _controller.detail.value.createdByName ?? ''),
                                _buildRow('Ngày lập:', _controller.detail.value.registerDate != null ? _controller.detail.value.registerDate.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddMMyyyy) : ''),
                                if (_controller.detail.value.confirmDate != null)
                                  _buildRow('Ngày xác nhận:', _controller.detail.value.confirmDate.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddMMyyyy)),
                                if (_controller.detail.value.confirmBy != null && _controller.detail.value.confirmBy.isNotEmpty)
                                  _buildRow('Người xác nhận:', _controller.detail.value.confirmBy),
                                _buildStatusRow('Trạng thái:', _controller.detail.value.status ?? 0, _controller.detail.value.statusName ?? _getStatusName(_controller.detail.value.status ?? 0)),
                                _buildRow('Ghi chú:', _controller.detail.value.note ?? ''),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildSectionTitle('Nội dung phiếu đăng ký công tác'),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRow('1. Người chỉ huy trực tiếp:', '${_controller.detail.value.commanderName ?? ''} - Bậc AT: ${_controller.detail.value.commanderSafetyLevel ?? ''}'),
                                _buildRow('Số điện thoại:', _controller.detail.value.phoneNumber ?? ''),
                                const Divider(height: 24),
                                _buildRow('2. Nội dung công tác:', _controller.detail.value.workContent ?? ''),
                                const Divider(height: 24),
                                _buildRow('3. Địa điểm công tác:', _controller.detail.value.workLocation ?? ''),
                                const Divider(height: 24),
                                _buildRow('4. Điều kiện công tác:', _controller.detail.value.workCondition ?? ''),
                                const Divider(height: 24),
                                _buildRow('5. Thời gian bắt đầu:', _controller.detail.value.startTime != null ? _controller.detail.value.startTime.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddmmyyyyHHmm) : ''),
                                _buildRow('Thời gian kết thúc:', _controller.detail.value.endTime != null ? _controller.detail.value.endTime.fromFormatUtcToFormatLocalNotZ(RAppStrings.ddmmyyyyHHmm) : ''),
                              ],
                            ),
                          ),
                          
                          if (_controller.detail.value.workers != null && _controller.detail.value.workers.isNotEmpty)
                            ...[
                              const SizedBox(height: 20),
                              _buildSectionTitle('6. Đơn vị công tác, nhân viên công tác (${_controller.detail.value.workerCount ?? _controller.detail.value.workers.length})'),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                child: Column(
                                  children: _controller.detail.value.workers.map((w) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${w.sortOrder ?? 0}. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(w.fullName ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                                                Text('Bậc AT: ${w.safetyLevel ?? ''} - Nhiệm vụ: ${w.duty ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],

                          if (_controller.detail.value.relatedUnits != null && _controller.detail.value.relatedUnits.isNotEmpty)
                            ...[
                              const SizedBox(height: 20),
                              _buildSectionTitle('Đơn vị QLVH khác có liên quan (${_controller.detail.value.workUnitCount ?? _controller.detail.value.relatedUnits.length})'),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                child: Column(
                                  children: _controller.detail.value.relatedUnits.map((u) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${u.sortOrder ?? 0}. ', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          Expanded(child: Text(u.unitName ?? '')),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRow('7. Người lãnh đạo:', '${_controller.detail.value.workLeaderName ?? ''} - Bậc AT: ${_controller.detail.value.workLeaderSafetyLevel ?? ''}'),
                                const Divider(height: 24),
                                _buildRow('8. Người giám sát:', '${_controller.detail.value.supervisorName ?? ''} - Bậc AT: ${_controller.detail.value.supervisorSafetyLevel ?? ''}'),
                                const Divider(height: 24),
                                _buildRow('9. Người cảnh giới:', '${_controller.detail.value.guardName ?? ''} - Bậc AT: ${_controller.detail.value.guardSafetyLevel ?? ''}'),
                              ],
                            ),
                          ),
                          if (_controller.detail.value.risks != null && _controller.detail.value.risks.isNotEmpty)
                            ...[
                              const SizedBox(height: 20),
                              _buildSectionTitle('Đánh giá rủi ro & Biện pháp an toàn'),
                              Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.all(12),
                                width: double.infinity,
                                child: Column(
                                  children: _controller.detail.value.risks.map((r) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('${r.sortOrder ?? 0}. ${r.hazardContent ?? ''}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text('Biện pháp: ${r.safetyMeasure ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                          Text('Đơn vị thực hiện: ${r.execUnit ?? ''}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          const SizedBox(height: 20),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildRow('11. Nơi nhận:', _controller.detail.value.receiverNote ?? ''),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (_controller.detail.value.id != null && _controller.detail.value.id.isNotEmpty)
                            ...[
                              FileAttachmentBlock(
                                title: 'Phiếu đăng ký công tác',
                                fileName: '${_controller.detail.value.code ?? ""}.pdf',
                                signedFilePath: '/api/workregistration/dkct-pdf/${_controller.detail.value.id}?access_token=${AppShared.instance.getUserToken()}',
                              ),
                              const SizedBox(height: 20),
                            ],
                          if (_controller.detail.value.patcSignedFilePath != null && _controller.detail.value.patcSignedFilePath.isNotEmpty)
                            FileAttachmentBlock(
                              title: 'File đính kèm từ PATC',
                              fileName: (_controller.detail.value.patcFileName ?? 'PATC.pdf').replaceAll('.docx', '.pdf').replaceAll('.doc', '.pdf'),
                              signedFilePath: '/api/workregistration/patc-pdf/${_controller.detail.value.id}?access_token=${AppShared.instance.getUserToken()}',
                            ),
                          if (_controller.detail.value.bbksFiles != null && _controller.detail.value.bbksFiles.isNotEmpty)
                            ..._controller.detail.value.bbksFiles.map((b) => Column(
                                  children: [
                                    FileAttachmentBlock(
                                      title: 'Biên bản khảo sát - ${b.code ?? ""}',
                                      fileName: (b.fileName ?? 'BBKS.pdf').replaceAll('.docx', '.pdf').replaceAll('.doc', '.pdf'),
                                      signedFilePath: '/api/workregistration/bbks-pdf/${_controller.detail.value.id}?access_token=${AppShared.instance.getUserToken()}',
                                    ),
                                    const SizedBox(height: 20),
                                  ],
                                )),
                          const SizedBox(height: 20),
                          _buildSectionTitle('File tải lên'),
                          Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...(_controller.detail.value.attachments?.map((f) {
                                    return _buildFileItem(f.fileName ?? 'File', f.filePath);
                                  })?.toList() ?? []),
                                if (_controller.detail.value.attachments == null || _controller.detail.value.attachments.isEmpty)
                                  const Text('Không có file', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        final model = _controller.detail.value;
        if (model == null) return const SizedBox.shrink();
        final isCreator = model.createdBy?.toLowerCase() == AppShared.instance.getUserProfile()?.id?.toLowerCase();
        
        final canApprove = model.isAllowApprove == true && !isCreator;
        final canReject = model.isAllowReject == true && !isCreator;
        final canSend = (model.isAllowSend == true || model.status == 1) && isCreator;

        if (!canApprove && !canReject && !canSend) return const SizedBox.shrink();

        return SafeArea(
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                if (canReject)
                  Expanded(
                    child: InkWell(
                      onTap: _controller.reject,
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
                      onTap: _controller.approve,
                      child: Container(
                        alignment: Alignment.center,
                        color: RAppColor.highlightColor70,
                        child: const Text('Xác nhận', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                if (canSend)
                  Expanded(
                    child: InkWell(
                      onTap: _controller.send,
                      child: Container(
                        alignment: Alignment.center,
                        color: RAppColor.highlightColor70,
                        child: const Text('Ký số & Gửi duyệt', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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

  String _getStatusName(int status) {
    if (status == 1) return 'Mới';
    if (status == 2) return 'Chờ xác nhận';
    if (status == 3) return 'Đã xác nhận';
    if (status == 4) return 'Từ chối';
    return 'Không xác định';
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: RAppColor.colorBlue,
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: TextSize.normal,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '-' : value,
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: TextSize.normal,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  statusName,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: TextSize.normal),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(String name, String path) {
    final WorkRegistrationDetailController _controller = Get.find();
    
    final nameLower = (name ?? path ?? '').toLowerCase();
    final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');

    Widget iconWidget = const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20);

    if (isImage && path != null && path.isNotEmpty) {
      String fullPath = path;
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
          errorWidget: (context, url, error) => const Icon(Icons.image, color: Colors.blue, size: 20),
        ),
      );
    }

    return InkWell(
      onTap: () => _controller.downloadFile(path),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
