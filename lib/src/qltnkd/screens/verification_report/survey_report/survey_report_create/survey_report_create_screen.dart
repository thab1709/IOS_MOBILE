// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/components/file_attachment_block.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/app_env.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_create/survey_report_create_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_create/widget/add_participant_bottom_sheet.dart';

class SurveyReportCreateScreen extends StatelessWidget {
  final SurveyReportModel editModel;

  const SurveyReportCreateScreen({Key key, this.editModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SurveyReportCreateController(editModel: editModel));

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(editModel != null ? 'Cập nhật biên bản khảo sát' : 'Lập Biên bản khảo sát mới'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildGeneralInfo(context, controller),
            const SizedBox(height: 16),
            _buildParticipantsInfo(context, controller),
            const SizedBox(height: 16),
            _buildFileInfo(context, controller),
            const SizedBox(height: 16),
            _buildAttachmentsList(controller),
            const SizedBox(height: 80), // padding for bottom button
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RButton(
              title: 'Lưu thông tin',
              action: () => controller.save(),
              color: RAppColor.colorBlue,
              titleColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralInfo(BuildContext context, SurveyReportCreateController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Thông tin chung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            const Text('Số biên bản khảo sát *'),
            const SizedBox(height: 4),
            RTextField(
              value: controller.code.value,
              onChange: (val) => controller.code.value = val,
              hintText: 'Nhập số biên bản (Ví dụ: 12/BBKS-HANOI)',
            ),
            const SizedBox(height: 12),
            
            const Text('Tên biên bản *'),
            const SizedBox(height: 4),
            RTextField(
              value: controller.name.value,
              onChange: (val) => controller.name.value = val,
              hintText: 'Nhập tên biên bản khảo sát',
            ),
            const SizedBox(height: 12),
            
            const Text('Công trình khảo sát *'),
            const SizedBox(height: 4),
            Obx(() {
              return SingleStringDropDown(
                controller.constructions.toList(),
                value: controller.selectedConstructionId.value,
                hint: controller.isConstructionsLoading.value ? 'Đang tải dữ liệu...' : 'Tìm kiếm và chọn công trình',
                onSelected: (val) {
                  controller.selectedConstructionId.value = val;
                  // find name
                  final matched = controller.constructions.firstWhere((e) => e.value == val, orElse: () => null);
                  if (matched != null) {
                    controller.selectedConstructionName.value = matched.title;
                  }
                },
              );
            }),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ngày lập biên bản *'),
                      const SizedBox(height: 4),
                      RDateTime(
                        title: '',
                        textController: controller.dateController,
                        onTap: () async {
                           final picked = await showDatePicker(
                             context: context,
                             initialDate: controller.reportDate.value,
                             firstDate: DateTime(2000),
                             lastDate: DateTime(2100),
                           );
                           if (picked != null) {
                             controller.reportDate.value = picked;
                             controller.dateController.text = DateFormat('dd/MM/yyyy').format(picked);
                           }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Trạng thái phê duyệt'),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300)
                        ),
                        child: const Text('Mới', style: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            const Text('Ghi chú'),
            const SizedBox(height: 4),
            RTextField(
              value: controller.note.value,
              onChange: (val) => controller.note.value = val,
              hintText: 'Nhập ghi chú...',
              line: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantsInfo(BuildContext context, SurveyReportCreateController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Thành phần ký duyệt biên bản', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            _buildParticipantGroup(context, controller, 1, '1. Đơn vị công tác', '24ecbb6c-ee76-46ff-9a58-002d6aef3352'),
            const SizedBox(height: 24),
            _buildParticipantGroup(context, controller, 2, '2. Đơn vị liên quan khác (Tư vấn giám sát/Thiết kế...)', '70faa5c7-59da-453f-9b5f-4d1ba6631a1c'),
            const SizedBox(height: 24),
            _buildParticipantGroup(context, controller, 3, '3. Đơn vị Quản lý vận hành (Công ty điện lực / Đội QLVH)', '937b18c9-c6e4-41d8-af91-0d2dc5918c83'),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantGroup(BuildContext context, SurveyReportCreateController controller, int groupType, String title, String predefinedUnitId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            ElevatedButton.icon(
              onPressed: () {
                Get.bottomSheet(
                  AddParticipantBottomSheet(
                    groupType: groupType,
                    groupTitle: title,
                    predefinedUnitId: predefinedUnitId,
                    onAdd: (model) => controller.addParticipant(model),
                  ),
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                );
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Thêm người ký'),
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF0F172A), // Dark blue like web
                onPrimary: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Obx(() {
          final groupUsers = controller.participants.where((e) => e.groupType == groupType).toList();
          if (groupUsers.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Center(
                child: Text('Chưa cấu hình người ký cho nhóm này', style: TextStyle(color: Colors.grey)),
              ),
            );
          }
          
          return Container(
             decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
             child: Column(
               children: [
                 Container(
                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                   color: Colors.grey.shade100,
                   child: Row(
                     children: const [
                       Expanded(flex: 3, child: Text('Đại diện (Đơn vị)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                       Expanded(flex: 3, child: Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                       Expanded(flex: 2, child: Text('Chức vụ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                       SizedBox(width: 40, child: Text('Xóa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
                     ],
                   ),
                 ),
                 const Divider(height: 1),
                 ...groupUsers.map((e) => Container(
                   padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                   child: Row(
                     children: [
                       Expanded(flex: 3, child: Text(e.unitName ?? '', style: const TextStyle(fontSize: 12))),
                       Expanded(flex: 3, child: Text(e.fullName ?? '', style: const TextStyle(fontSize: 12))),
                       Expanded(flex: 2, child: Text(e.position ?? '', style: const TextStyle(fontSize: 12))),
                       SizedBox(
                         width: 40,
                         child: IconButton(
                           padding: EdgeInsets.zero,
                           constraints: const BoxConstraints(),
                           icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                           onPressed: () => controller.removeParticipant(e),
                         ),
                       )
                     ],
                   ),
                 )).toList()
               ],
             ),
          );
        }),
      ],
    );
  }

  Widget _buildFileInfo(BuildContext context, SurveyReportCreateController controller) {
    if (editModel == null) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Text('File biên bản khảo sát đính kèm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text(
                '* Vui lòng nhấn nút Lưu thông tin bên trên để khởi tạo biên bản, sau đó hệ thống sẽ mở khóa chức năng tải file.',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('File biên bản khảo sát đính kèm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.uploadedFileName.value.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200)
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.description, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          controller.uploadedFileName.value,
                          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.downloadTemplate(),
                    icon: const Icon(Icons.file_download, size: 18),
                    label: const Text('Tải file Word mẫu'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => controller.uploadWordFile(),
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Tải lên file đã sửa (.docx)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsList(SurveyReportCreateController controller) {
    if (controller.editModel == null) return const SizedBox();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Tài liệu đính kèm',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.attachments.isEmpty) {
                return const Text('Chưa có tài liệu đính kèm', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
              }
              return Column(
                children: controller.attachments.asMap().entries.map((entry) {
                  final index = entry.key;
                  final att = entry.value;
                  final fileName = att['fileName'] ?? att['name'] ?? 'Tài liệu ${index + 1}';
                  final filePath = att['url'] ?? att['filePath'] ?? att['path'];

                  final nameLower = (fileName ?? filePath ?? '').toLowerCase();
                  final isImage = nameLower.endsWith('.jpg') || nameLower.endsWith('.jpeg') || nameLower.endsWith('.png');

                  Widget iconWidget = const Icon(Icons.attach_file, size: 16, color: Colors.blue);

                  if (isImage && filePath != null && filePath.isNotEmpty) {
                    String fullPath = filePath;
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
                                controller.downloadFile(filePath);
                              }
                            },
                            child: Text(fileName, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                          )
                        ),
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
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: controller.onAddAttachment,
              icon: const Icon(Icons.upload_file, size: 18),
              label: const Text('Tải lên tài liệu đính kèm'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
