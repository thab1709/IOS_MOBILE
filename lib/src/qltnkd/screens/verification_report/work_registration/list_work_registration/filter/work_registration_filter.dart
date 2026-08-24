// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/list_work_registration/list_work_registration_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';

class WorkRegistrationFilter extends StatefulWidget {
  @override
  _WorkRegistrationFilterState createState() => _WorkRegistrationFilterState();
}

class _WorkRegistrationFilterState extends State<WorkRegistrationFilter> {
  final ListWorkRegistrationController _controller = Get.find();
  final _repository = SurveyReportRepository();
  final _workRegRepo = WorkRegistrationRepository();

  final _registerFromController = TextEditingController();
  final _registerToController = TextEditingController();
  final _confirmFromController = TextEditingController();
  final _confirmToController = TextEditingController();
  final _createdByController = TextEditingController();
  final _confirmByController = TextEditingController();

  DateTime _registerFrom;
  DateTime _registerTo;
  DateTime _confirmFrom;
  DateTime _confirmTo;

  int _selectedStatus = 0;
  String _selectedUnitId;
  String _selectedConstructionId;
  String _selectedPatcId;

  List<StringOptionModel> _units = [];
  List<StringOptionModel> _constructions = [];
  List<StringOptionModel> _patcList = [];
  bool _isLoadingUnits = false;
  bool _isLoadingConstructions = false;
  bool _isLoadingPatc = false;

  final _fmt = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // Pre-fill from controller state
    _selectedUnitId = _controller.qlvhUnitId.value.isEmpty ? null : _controller.qlvhUnitId.value;
    _selectedConstructionId = _controller.constructionId.value.isEmpty ? null : _controller.constructionId.value;
    _selectedPatcId = _controller.patcId.value.isEmpty ? null : _controller.patcId.value;

    _registerFrom = _controller.registerDateFrom.value;
    _registerTo = _controller.registerDateTo.value;
    if (_registerFrom != null && _registerTo != null) {
      _registerFromController.text = 'Từ ${_fmt.format(_registerFrom)} đến ${_fmt.format(_registerTo)}';
    } else if (_registerFrom != null) {
      _registerFromController.text = _fmt.format(_registerFrom);
    }

    _confirmFrom = _controller.confirmFromDate.value;
    _confirmTo = _controller.confirmToDate.value;
    if (_confirmFrom != null && _confirmTo != null) {
      _confirmFromController.text = 'Từ ${_fmt.format(_confirmFrom)} đến ${_fmt.format(_confirmTo)}';
    } else if (_confirmFrom != null) {
      _confirmFromController.text = _fmt.format(_confirmFrom);
    }

    _createdByController.text = _controller.createdBy.value;
    _confirmByController.text = _controller.confirmBy.value;

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingUnits = true;
      _isLoadingConstructions = true;
      _isLoadingPatc = true;
    });
    final resUnits = await _repository.getUnits();
    final resConstructions = await _repository.getConstructions();
    final resPatc = await _workRegRepo.getApprovedPatcList();
    if (!mounted) return;
    setState(() {
      _isLoadingUnits = false;
      _isLoadingConstructions = false;
      _isLoadingPatc = false;
      if (resUnits.isLoadSuccess && resUnits.data != null) _units = resUnits.data;
      if (resConstructions.isLoadSuccess && resConstructions.data != null) _constructions = resConstructions.data;
      if (resPatc.isLoadSuccess && resPatc.data != null) _patcList = resPatc.data;
    });
  }

  void _applyFilter() {
    _controller.qlvhUnitId.value = _selectedUnitId ?? '';
    _controller.constructionId.value = _selectedConstructionId ?? '';
    _controller.patcId.value = _selectedPatcId ?? '';
    _controller.registerDateFrom.value = _registerFrom;
    _controller.registerDateTo.value = _registerTo;
    _controller.confirmFromDate.value = _confirmFrom;
    _controller.confirmToDate.value = _confirmTo;
    _controller.createdBy.value = _createdByController.text.trim();
    _controller.confirmBy.value = _confirmByController.text.trim();
    Get.back(result: true);
  }

  void _clearFilter() {
    setState(() {
      _selectedUnitId = null;
      _selectedConstructionId = null;
      _selectedPatcId = null;
      _selectedStatus = 0;
      _registerFrom = null;
      _registerTo = null;
      _confirmFrom = null;
      _confirmTo = null;
      _registerFromController.clear();
      _registerToController.clear();
      _confirmFromController.clear();
      _confirmToController.clear();
      _createdByController.clear();
      _confirmByController.clear();
    });
    _applyFilter();
  }

  Future<void> _showTimePicker(BuildContext context, bool isConfirmDate) async {
    final start = isConfirmDate ? _confirmFrom : _registerFrom;
    final end = isConfirmDate ? _confirmTo : _registerTo;
    final arrDateSearch = await showTimePickerSearch(context, start, end);
    if (arrDateSearch != null) {
      final str = 'Từ ${_fmt.format(arrDateSearch.start)} đến ${_fmt.format(arrDateSearch.end)}';
      setState(() {
        if (isConfirmDate) {
          _confirmFrom = arrDateSearch.start;
          _confirmTo = arrDateSearch.end;
          _confirmFromController.text = str;
        } else {
          _registerFrom = arrDateSearch.start;
          _registerTo = arrDateSearch.end;
          _registerFromController.text = str;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 1,
        title: const Text('Lọc nâng cao', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Đơn vị quản lý vận hành', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleStringDropDown(
                      _units,
                      value: _selectedUnitId,
                      hint: _isLoadingUnits ? 'Đang tải...' : 'Chọn đơn vị QLVH',
                      onSelected: (val) => setState(() => _selectedUnitId = val),
                    ),
                    const SizedBox(height: 16),
                    const Text('Công trình', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleStringDropDown(
                      _constructions,
                      value: _selectedConstructionId,
                      hint: _isLoadingConstructions ? 'Đang tải...' : 'Chọn công trình',
                      onSelected: (val) => setState(() => _selectedConstructionId = val),
                    ),
                    const SizedBox(height: 16),
                    const Text('Số PATC', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleStringDropDown(
                      _patcList,
                      value: _selectedPatcId,
                      hint: _isLoadingPatc ? 'Đang tải...' : 'Chọn số PATC',
                      onSelected: (val) => setState(() => _selectedPatcId = val),
                    ),
                    const SizedBox(height: 16),
                    RDateTime(
                      title: 'Ngày lập',
                      onTap: () {
                        _showTimePicker(context, false);
                      },
                      isShowClear: true,
                      onClear: () {
                        setState(() {
                          _registerFrom = null;
                          _registerTo = null;
                          _registerFromController.clear();
                        });
                      },
                      textController: _registerFromController,
                    ),
                    const SizedBox(height: 16),
                    const Text('Người lập', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _createdByController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: RAppColor.highlightColor70),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                          onPressed: () => _createdByController.clear(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    RDateTime(
                      title: 'Ngày xác nhận',
                      onTap: () {
                        _showTimePicker(context, true);
                      },
                      isShowClear: true,
                      onClear: () {
                        setState(() {
                          _confirmFrom = null;
                          _confirmTo = null;
                          _confirmFromController.clear();
                        });
                      },
                      textController: _confirmFromController,
                    ),
                    const SizedBox(height: 16),
                    const Text('Người xác nhận', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _confirmByController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: RAppColor.highlightColor70),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.grey, size: 20),
                          onPressed: () => _confirmByController.clear(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: RButton(
                      title: 'Bỏ lọc',
                      color: Colors.white,
                      titleColor: RAppColor.highlightColor70,
                      borderColor: RAppColor.highlightColor70,
                      action: _clearFilter,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RButton(
                      title: 'Áp dụng',
                      color: RAppColor.highlightColor70,
                      action: _applyFilter,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerFromController.dispose();
    _registerToController.dispose();
    _confirmFromController.dispose();
    _confirmToController.dispose();
    _createdByController.dispose();
    _confirmByController.dispose();
    super.dispose();
  }
}
