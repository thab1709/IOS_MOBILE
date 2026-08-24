// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/components/file_attachment_block.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/patc_create_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/component/patc_participant_section.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';

class PatcCreateScreen extends StatefulWidget {
  final PatcModel editModel;

  const PatcCreateScreen({Key key, this.editModel}) : super(key: key);

  @override
  State<PatcCreateScreen> createState() => _PatcCreateScreenState();
}

class _PatcCreateScreenState extends State<PatcCreateScreen> {
  PatcCreateController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(PatcCreateController(editModel: widget.editModel));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RAppColor.backgroundColorGray,
      appBar: AppBar(
        title: Text(widget.editModel == null ? 'Lập phương án thi công' : 'Cập nhật phương án thi công', style: const TextStyle(fontSize: 18)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBasicInfo(),
                    const SizedBox(height: 24),
                    PatcParticipantSection(controller: _controller),
                    const SizedBox(height: 24),
                    _buildSurveyReportList(),
                    const SizedBox(height: 24),
                    _buildFileSection(),
                  ],
                ),
              ),
            ),
            _buildExistingFilesSection(),
            if (_controller.isAllowEdit) _buildBottomButtons(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingFilesSection() {
    return Obx(() {
      final model = _controller.editModel;
      final selectedSrs = _controller.surveyReports.where((sr) => _controller.selectedSurveyReportIds.contains(sr.id)).toList();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (model != null && ((model.filePath != null && model.filePath.isNotEmpty) || (model.signedFilePath != null && model.signedFilePath.isNotEmpty)))
            FileAttachmentBlock(
              title: 'File PATC đã lưu',
              fileName: model.fileName,
              filePath: model.filePath,
              signedFilePath: model.signedFilePath,
            ),
          if (selectedSrs.isNotEmpty)
            ...selectedSrs.map((sr) {
              return FileAttachmentBlock(
                title: 'File biên bản khảo sát (${sr.code ?? ""})',
                fileName: sr.fileName,
                filePath: sr.filePath,
                signedFilePath: sr.signedFilePath,
              );
            }).toList(),
          const SizedBox(height: 24),
        ],
      );
    });
  }

  Widget _buildFileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('File PATC *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Nếu chưa có mẫu, vui lòng tải mẫu '),
                        InkWell(
                          onTap: _controller.downloadTemplate,
                          child: const Text('Tại đây', style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _controller.isAllowEdit ? _controller.pickFiles : null,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D254F)),
                      icon: const Icon(Icons.upload_file, size: 18, color: Colors.white),
                      label: const Text('Chọn file', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 12),
                    const Text('Hỗ trợ: doc, docx, pdf, xlsx, png, jpg', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ]
          )
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Tài liệu đính kèm khác (nếu có)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 16),
              if (_controller.isAllowEdit) ...[
                InkWell(
                  onTap: _controller.pickFiles,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(Icons.upload_file, size: 32, color: Colors.grey),
                          const SizedBox(height: 8),
                          const Text('Kéo thả file vào đây hoặc'),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: _controller.pickFiles,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0D254F)),
                            child: const Text('Chọn file', style: TextStyle(color: Colors.white)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Obx(() {
                if (_controller.attachments.isEmpty) return const SizedBox();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _controller.attachments.map((file) {
                    String fileName = file.path.split('/').last.split('\\').last;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_file, size: 16, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(child: Text(fileName, style: const TextStyle(color: Colors.blue))),
                          if (_controller.isAllowEdit)
                            IconButton(
                              icon: const Icon(Icons.close, size: 16, color: Colors.red),
                              onPressed: () => _controller.removeFile(file),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo() {
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
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Số PATC *', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _controller.codeController,
                      readOnly: !_controller.isAllowEdit,
                      decoration: const InputDecoration(
                        hintText: 'Nhập số PATC',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ngày lập *', style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 8),
                    Obx(() => InkWell(
                          onTap: () async {
                            if (!_controller.isAllowEdit) return;
                            final selectedDate = await showDatePicker(
                              context: Get.context,
                              initialDate: _controller.reportDate.value,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              _controller.reportDate.value = selectedDate;
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                              color: _controller.isAllowEdit ? Colors.white : Colors.grey.shade200,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_controller.reportDate.value.toStringFormat(RAppStrings.ddMMyyyy)),
                                const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Tên PATC *', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controller.nameController,
            readOnly: !_controller.isAllowEdit,
            decoration: const InputDecoration(
              hintText: 'Nhập tên PATC',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Công trình *', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Obx(() => SingleStringDropDown(
                _controller.constructionList,
                value: _controller.selectedConstructionId.value,
                hint: _controller.isLoadingConstruction.value ? 'Đang tải...' : 'Chọn công trình',
                onSelected: _controller.isAllowEdit ? _controller.onConstructionChanged : null,
              )),
          const SizedBox(height: 16),
          const Text('Nội dung', style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _controller.contentController,
            readOnly: !_controller.isAllowEdit,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Nhập nội dung',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSurveyReportList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Biên bản khảo sát được chọn *', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Obx(() {
            if (_controller.isLoadingSurveyReports.value) {
              return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
            }
            if (_controller.surveyReports.isEmpty) {
              return const Center(child: Padding(padding: EdgeInsets.all(16), child: Text('Không có biên bản khảo sát nào thuộc công trình này')));
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: MaterialStateProperty.all(Colors.grey.shade100),
                columns: const [
                  DataColumn(label: Text('Chọn')),
                  DataColumn(label: Text('STT')),
                  DataColumn(label: Text('Số biên bản')),
                  DataColumn(label: Text('Tên công trình')),
                  DataColumn(label: Text('Người lập')),
                  DataColumn(label: Text('Trạng thái')),
                ],
                rows: _controller.surveyReports.asMap().entries.map((entry) {
                  int idx = entry.key;
                  var sr = entry.value;
                  bool isApproved = sr.status == EnumSurveyReport.confirmed.getCode();
                  bool isSelected = _controller.selectedSurveyReportIds.contains(sr.id);
                  return DataRow(
                    selected: isSelected,
                    onSelectChanged: isApproved && _controller.isAllowEdit ? (val) {
                      _controller.toggleSurveyReport(sr.id);
                    } : null,
                    cells: [
                      DataCell(
                        Checkbox(
                          value: isSelected,
                          onChanged: isApproved && _controller.isAllowEdit ? (val) {
                            _controller.toggleSurveyReport(sr.id);
                          } : null,
                        ),
                      ),
                      DataCell(Text('${idx + 1}')),
                      DataCell(Text(sr.code ?? '')),
                      DataCell(Text(sr.constructionName ?? '')),
                      DataCell(Text(sr.createdByName ?? '')),
                      DataCell(
                        Text(
                          sr.statusName ?? '',
                          style: TextStyle(
                            color: isApproved ? Colors.green : (sr.status == EnumSurveyReport.reject.getCode() ? Colors.red : Colors.orange),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: RAppColor.colorBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _controller.save(isCloseAndBack: true),
                child: const Text('Lưu lại', style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _controller.saveAndSend,
                child: const Text('Lưu và Gửi duyệt', style: TextStyle(fontSize: 16, color: Colors.white), textAlign: TextAlign.center),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
