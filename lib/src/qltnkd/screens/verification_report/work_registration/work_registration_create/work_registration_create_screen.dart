// @dart=2.9
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/app_common/shared/app_shared.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/models/work_registration_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/work_registration_create/work_registration_create_controller.dart';
import 'package:evnmobile/src/qltnkd/common/components/file_attachment_block.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_text_field.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:flutter/services.dart';

class WorkRegistrationCreateScreen extends StatefulWidget {
  final String id;
  final String initialPatcId;

  const WorkRegistrationCreateScreen({Key key, this.id, this.initialPatcId}) : super(key: key);

  @override
  State<WorkRegistrationCreateScreen> createState() => _WorkRegistrationCreateScreenState();
}

class _WorkRegistrationCreateScreenState extends State<WorkRegistrationCreateScreen> {
  WorkRegistrationCreateController _controller;
  final _registerDateController = TextEditingController();
  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    _controller = Get.put(WorkRegistrationCreateController(
      id: widget.id,
      initialPatcId: widget.initialPatcId,
    ));
    _registerDateController.text = _fmt.format(_controller.registerDate.value);
  }

  @override
  void dispose() {
    _registerDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: RAppColor.highlightColor70,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          widget.id != null ? 'Cập nhật đăng ký công tác' : 'Thêm mới đăng ký công tác',
          style: const TextStyle(fontSize: TextSize.normal),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => _controller.isLoading.value
              ? const Center(child: CupertinoActivityIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSection('Thông tin chung', _buildGeneralInfoSection()),
                            const SizedBox(height: 20),
                            _buildSection('Nội dung phiếu đăng ký công tác', _buildWorkContentSection()),
                            const SizedBox(height: 20),
                            if (_controller.isEdit && _controller.id != null && (_controller.basePdfPath.value.isNotEmpty || _controller.signedPdfPath.value.isNotEmpty)) ...[
                              const Text('Phiếu đăng ký công tác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue)),
                              const SizedBox(height: 8),
                              FileAttachmentBlock(
                                title: 'Phiếu đăng ký công tác',
                                fileName: '${_controller.codeController.text}.pdf',
                                signedFilePath: '/api/workregistration/dkct-pdf/${_controller.id}?access_token=${AppShared.instance.getUserToken()}',
                              ),
                              const SizedBox(height: 20),
                            ],
                            const Text('File đính kèm từ PATC', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue)),
                            const SizedBox(height: 8),
                            _buildPatcFilesSection(),
                            const SizedBox(height: 20),
                            const Text('File tải lên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue)),
                            const SizedBox(height: 8),
                            _buildUploadSection(),
                          ],
                        ),
                      ),
                    ),
                    RButton(
                      maxSize: true,
                      title: 'Lưu thông tin',
                      borderRadius: 0,
                      action: _controller.save,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue)),
        const SizedBox(height: 8),
        const SizedBox(height: 8),
        content,
      ],
    );
  }

  Widget _buildGeneralInfoSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RTextField(
            title: 'Số phiếu ĐKCT',
            isRequire: true,
            value: _controller.codeController.text,
            onChange: (val) => _controller.codeController.text = val,
          ),
          const SizedBox(height: 12),
          Obx(() {
            return RDropDown(
              title: 'Số PATC',
              isRequire: true,
              options: _controller.patcOptions,
              value: _controller.patcId.value.isEmpty ? '' : _controller.patcId.value,
              onSelected: (val) {
                _controller.onPatcSelected(val);
              },
            );
          }),
          RDateTime(
            title: 'Ngày lập',
            isRequire: true,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
            textController: _controller.registerDateController,
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: _controller.registerDate.value,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                _controller.registerDate.value = selectedDate;
                _controller.updateDateTimeControllers();
              }
            },
          ),
          RTextField(
            title: 'Tên phiếu ĐKCT',
            textController: _controller.nameController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
          Obx(() {
            return RTextField(
              title: 'Đơn vị QLVH',
              value: _controller.qlvhUnitName.value,
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              isEnable: false,
              onChange: (val) {},
            );
          }),
          Obx(() {
            return RTextField(
              title: 'Tên công trình',
              value: _controller.constructionName.value,
              margin: const EdgeInsets.only(top: PaddingSize.normal),
              isEnable: false,
              line: null,
              onChange: (val) {},
            );
          }),
          RTextField(
            title: 'Ghi chú',
            textController: _controller.noteController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkContentSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RTextField(
            title: '1. Người chỉ huy trực tiếp',
            textController: _controller.commanderNameController,
          ),
          Row(
            children: [
              Expanded(
                child: RDropDown(
                  title: 'Bậc ATĐ',
                  options: _controller.safetyLevelOptions,
                  value: _controller.commanderSafetyLevelController.text,
                  parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
                  onSelected: (val) {
                    _controller.commanderSafetyLevelController.text = val;
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RTextField(
                  title: 'Số ĐT',
                  textController: _controller.phoneNumberController,
                  margin: const EdgeInsets.only(top: PaddingSize.normal),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          RTextField(
            title: '2. Nội dung công tác',
            textController: _controller.workContentController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
          RTextField(
            title: '3. Địa điểm công tác',
            textController: _controller.workLocationController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
          RTextField(
            title: '4. Điều kiện công tác',
            textController: _controller.workConditionController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
          Column(
            children: [
              RDateTime(
                title: '5. Thời gian bắt đầu',
                margin: const EdgeInsets.only(top: PaddingSize.normal),
                textController: _controller.startTimeController,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _controller.startTime.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_controller.startTime.value),
                    );
                    if (selectedTime != null) {
                      _controller.startTime.value = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    } else {
                      _controller.startTime.value = selectedDate;
                    }
                    _controller.updateDateTimeControllers();
                  }
                },
              ),
              RDateTime(
                title: 'Thời gian kết thúc',
                margin: const EdgeInsets.only(top: PaddingSize.normal),
                textController: _controller.endTimeController,
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _controller.endTime.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (selectedDate != null) {
                    final selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_controller.endTime.value),
                    );
                    if (selectedTime != null) {
                      _controller.endTime.value = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );
                    } else {
                      _controller.endTime.value = selectedDate;
                    }
                    _controller.updateDateTimeControllers();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text('6. Đơn vị công tác, nhân viên công tác', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          _buildWorkersSection(),
          const SizedBox(height: 16),
          _buildRelatedUnitsSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          RTextField(
            title: '7. Người lãnh đạo công việc',
            textController: _controller.workLeaderNameController,
          ),
          RDropDown(
            title: 'Bậc ATĐ',
            options: _controller.safetyLevelOptions,
            value: _controller.workLeaderSafetyLevelController.text,
            parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
            onSelected: (val) {
              _controller.workLeaderSafetyLevelController.text = val;
            },
          ),
          RTextField(
            title: '8. Người giám sát an toàn điện',
            textController: _controller.supervisorNameController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
          RDropDown(
            title: 'Bậc ATĐ',
            options: _controller.safetyLevelOptions,
            value: _controller.supervisorSafetyLevelController.text,
            parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
            onSelected: (val) {
              _controller.supervisorSafetyLevelController.text = val;
            },
          ),
          RTextField(
            title: '9. Người cảnh giới',
            textController: _controller.guardNameController,
            margin: const EdgeInsets.only(top: PaddingSize.normal),
          ),
          RDropDown(
            title: 'Bậc ATĐ',
            options: _controller.safetyLevelOptions,
            value: _controller.guardSafetyLevelController.text,
            parentMargin: const EdgeInsets.only(top: PaddingSize.normal),
            onSelected: (val) {
              _controller.guardSafetyLevelController.text = val;
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildRisksSection(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          RTextField(
            title: '11. Nơi nhận',
            textController: _controller.receiverNoteController,
            line: 4,
          ),
        ],
      ),
    );
  }


  Widget _buildWorkersSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: RTextField(
                  title: 'Số lượng đơn vị',
                  textController: _controller.workUnitCountController,
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: RTextField(
                  title: 'Số lượng nhân viên',
                  textController: _controller.workerCountController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Danh sách nhân viên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: RAppColor.colorBlue),
                onPressed: () {
                  _controller.workers.add(WorkRegistrationWorkerModel(
                    sortOrder: _controller.workers.length + 1,
                    fullName: '',
                    duty: '',
                    safetyLevel: '',
                  ));
                },
              )
            ],
          ),
          if (_controller.workers.isEmpty)
            const Text('Chưa có nhân viên nào', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          ..._controller.workers.asMap().entries.map((entry) {
            final idx = entry.key;
            final w = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RTextField(
                            title: 'Họ tên',
                            value: w.fullName,
                            onChange: (val) => w.fullName = val,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _controller.workers.removeAt(idx),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RDropDown(
                            title: 'Bậc AT',
                            options: _controller.safetyLevelOptions,
                            value: w.safetyLevel,
                            onSelected: (val) {
                              w.safetyLevel = val;
                              _controller.workers.refresh();
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RTextField(
                            title: 'Nhiệm vụ',
                            value: w.duty,
                            onChange: (val) => w.duty = val,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildRelatedUnitsSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Các đơn vị liên quan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: RAppColor.colorBlue),
                onPressed: () {
                  _controller.relatedUnits.add(WorkRegistrationRelatedUnitModel(
                    sortOrder: _controller.relatedUnits.length + 1,
                    unitName: '',
                  ));
                },
              )
            ],
          ),
          if (_controller.relatedUnits.isEmpty)
            const Text('Chưa có đơn vị nào', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          ..._controller.relatedUnits.asMap().entries.map((entry) {
            final idx = entry.key;
            final u = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RTextField(
                        title: 'Tên đơn vị',
                        value: u.unitName,
                        onChange: (val) => u.unitName = val,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _controller.relatedUnits.removeAt(idx),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildRisksSection() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text('Đánh giá rủi ro và các biện pháp an toàn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: RAppColor.colorBlue))),
              IconButton(
                icon: const Icon(Icons.add_circle, color: RAppColor.colorBlue),
                onPressed: () {
                  _controller.risks.add(WorkRegistrationRiskModel(
                    sortOrder: _controller.risks.length + 1,
                    hazardContent: '',
                    safetyMeasure: '',
                    execUnit: '',
                  ));
                },
              )
            ],
          ),
          if (_controller.risks.isEmpty)
            const Text('Chưa có đánh giá rủi ro', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          ..._controller.risks.asMap().entries.map((entry) {
            final idx = entry.key;
            final r = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: RTextField(
                            title: 'Nội dung nguy hiểm',
                            value: r.hazardContent,
                            onChange: (val) => r.hazardContent = val,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _controller.risks.removeAt(idx),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RTextField(
                            title: 'Biện pháp an toàn',
                            value: r.safetyMeasure,
                            onChange: (val) => r.safetyMeasure = val,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RTextField(
                            title: 'Đơn vị thực hiện',
                            value: r.execUnit,
                            onChange: (val) => r.execUnit = val,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildPatcFilesSection() {
    return Obx(() {
      final hasPatcFile = _controller.patcSignedFilePath.value.isNotEmpty;
      final hasBbks = _controller.bbksFiles.isNotEmpty;
      final hasPatcAttachments = _controller.patcAttachments.isNotEmpty;
      if (!hasPatcFile && !hasBbks && !hasPatcAttachments) {
        return const Text('Chưa có file từ PATC', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasPatcFile)
            FileAttachmentBlock(
              title: 'File phương án thi công',
              fileName: _controller.patcFileName.value.isNotEmpty ? _controller.patcFileName.value.replaceAll('.docx', '.pdf').replaceAll('.doc', '.pdf') : 'PATC.pdf',
              signedFilePath: '/api/constructionplan/${_controller.patcId.value}/pdf?access_token=${AppShared.instance.getUserToken()}',
            ),
          ..._controller.bbksFiles.map((f) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FileAttachmentBlock(
                title: 'File biên bản khảo sát',
                fileName: (f.fileName ?? 'BBKS.pdf').replaceAll('.docx', '.pdf').replaceAll('.doc', '.pdf'),
                signedFilePath: f.signedFilePath,
              ),
            );
          }).toList(),
          ..._controller.patcAttachments.map((att) {
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: FileAttachmentBlock(
                title: 'File đính kèm khác',
                fileName: att.fileName ?? 'File',
                signedFilePath: att.filePath,
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  Widget _buildUploadSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Existing files (edit mode)
        ..._controller.existingAttachments.asMap().entries.map((entry) {
          final idx = entry.key;
          final att = entry.value;
          return ListTile(
            dense: true,
            leading: const Icon(Icons.cloud_done, color: Colors.blue),
            title: Text(att.fileName ?? 'File', style: const TextStyle(fontSize: 14)),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 18),
              onPressed: () => _controller.removeExistingFile(idx),
            ),
            contentPadding: EdgeInsets.zero,
          );
        }),
        // Local files picked
        ..._controller.localFiles.asMap().entries.map((entry) {
          final idx = entry.key;
          final file = entry.value;
          return ListTile(
            dense: true,
            leading: const Icon(Icons.insert_drive_file, color: Colors.orange),
            title: Text(file.path.split('/').last.split('\\').last, style: const TextStyle(fontSize: 14)),
            trailing: IconButton(
              icon: const Icon(Icons.close, color: Colors.red, size: 18),
              onPressed: () => _controller.removeLocalFile(idx),
            ),
            contentPadding: EdgeInsets.zero,
          );
        }),
        if (_controller.existingAttachments.isEmpty && _controller.localFiles.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('Chưa có file', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
          ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _controller.pickFile,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: RAppColor.colorBlue),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.upload_file, color: RAppColor.colorBlue, size: 18),
                SizedBox(width: 6),
                Text('Tải lên file', style: TextStyle(color: RAppColor.colorBlue, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildFileRow(String fileName, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(fileName, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
