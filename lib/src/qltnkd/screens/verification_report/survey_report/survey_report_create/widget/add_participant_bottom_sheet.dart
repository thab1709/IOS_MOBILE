// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/htld/common/utils/progress_h_u_d.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_report_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/survey_report_create/survey_report_create_controller.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';

class AddParticipantBottomSheet extends StatefulWidget {
  final int groupType;
  final String groupTitle;
  final String predefinedUnitId;
  final Function(SurveyReportParticipantModel) onAdd;

  const AddParticipantBottomSheet({
    Key key,
    @required this.groupType,
    @required this.groupTitle,
    this.predefinedUnitId,
    @required this.onAdd,
  }) : super(key: key);

  @override
  State<AddParticipantBottomSheet> createState() => _AddParticipantBottomSheetState();
}

class _AddParticipantBottomSheetState extends State<AddParticipantBottomSheet> {
  final SurveyReportCreateController _controller = Get.find<SurveyReportCreateController>();
  
  List<StringOptionModel> _units = [];
  List<StringOptionModel> _employees = [];
  
  String _selectedUnitId;
  String _selectedUnitName;
  
  String _selectedUserId;
  String _selectedUserName;
  
  final TextEditingController _positionController = TextEditingController();

  bool _isLoading = true;
  bool _isLoadingEmployees = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final units = await _controller.getUnits();
    
    if (mounted) {
      setState(() {
        _units = units;
        if (widget.predefinedUnitId != null && widget.predefinedUnitId.isNotEmpty) {
          _selectedUnitId = widget.predefinedUnitId;
          final match = _units.firstWhere((e) => e.value == _selectedUnitId, orElse: () => null);
          if (match != null) _selectedUnitName = match.title;
        }
        _isLoading = false;
      });
    }

    if (_selectedUnitId != null) {
      _loadEmployees(_selectedUnitId);
    }
  }

  Future<void> _loadEmployees(String unitId) async {
    setState(() {
      _isLoadingEmployees = true;
    });
    final employees = await _controller.getEmployees(unitId);
    
    if (mounted) {
      setState(() {
        _isLoadingEmployees = false;
        _employees = employees;
        _selectedUserId = null;
        _selectedUserName = null;
      });
    }
  }

  void _submit() {
    if (_selectedUnitId == null || _selectedUserId == null) {
      Get.snackbar('Lỗi', 'Vui lòng chọn đủ Đơn vị và Người ký', 
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final model = SurveyReportParticipantModel(
      unitId: _selectedUnitId,
      unitName: _selectedUnitName,
      userId: _selectedUserId,
      fullName: _selectedUserName,
      position: _positionController.text.trim(),
      groupType: widget.groupType,
    );

    widget.onAdd(model);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Thêm người ký', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Nhóm: ${widget.groupTitle}', style: const TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 16),
                     
                      const Text('Đơn vị công tác *'),
                      const SizedBox(height: 4),
                     SingleStringDropDown(
                       _units,
                       value: _selectedUnitId,
                       hint: _isLoading ? 'Đang tải đơn vị...' : 'Tìm kiếm và chọn đơn vị',
                       onSelected: (val) {
                          if (val == _selectedUnitId) return;
                          setState(() {
                             _selectedUnitId = val;
                             final match = _units.firstWhere((e) => e.value == val, orElse: () => null);
                             if (match != null) _selectedUnitName = match.title;
                          });
                          _loadEmployees(val);
                       },
                     ),
                     const SizedBox(height: 16),
                     
                     const Text('Người đại diện *'),
                     const SizedBox(height: 4),
                     SingleStringDropDown(
                       _employees,
                       value: _selectedUserId,
                       hint: _isLoadingEmployees ? 'Đang tải...' : 'Tìm kiếm và chọn người đại diện',
                       onSelected: (val) {
                          setState(() {
                             _selectedUserId = val;
                             final match = _employees.firstWhere((e) => e.value == val, orElse: () => null);
                             if (match != null) {
                               _selectedUserName = match.title;
                               _positionController.text = match.subtitle ?? '';
                             }
                          });
                       },
                     ),
                     
                     const SizedBox(height: 16),
                     const Text('Chức vụ'),
                     const SizedBox(height: 4),
                     TextField(
                       controller: _positionController,
                       decoration: InputDecoration(
                         hintText: 'Nhập chức vụ',
                         border: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(8),
                           borderSide: BorderSide(color: Colors.grey.shade300),
                         ),
                         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                       ),
                     ),
                     
                     const SizedBox(height: 24),
                     RButton(
                       title: 'Xác nhận',
                       action: _submit,
                       color: RAppColor.colorBlue,
                       titleColor: Colors.white,
                     ),
                     // spacing for keyboard
                     SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                   ],
                 ),
               ),
             ),
           ),
          ],
        ),
      ),
    );
  }
}
