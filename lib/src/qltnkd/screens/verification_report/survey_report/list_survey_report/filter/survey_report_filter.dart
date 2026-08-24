// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/components/single_string_dropdown.dart';
import 'package:evnmobile/src/qltnkd/common/components/r_date_time.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/list_survey_report/list_survey_report_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/repository/survey_report_repository.dart';
import 'package:evnmobile/src/qltnkd/models/option_model.dart';
import 'package:intl/intl.dart';
import 'package:evnmobile/src/app_common/utils/utils.dart';

class SurveyReportFilter extends StatefulWidget {
  final ListSurveyReportController controller;

  const SurveyReportFilter({Key key, this.controller}) : super(key: key);

  @override
  _SurveyReportFilterState createState() => _SurveyReportFilterState();
}

class _SurveyReportFilterState extends State<SurveyReportFilter> {
  ListSurveyReportController _controller;


  final _fromDateController = TextEditingController();
  final _toDateController = TextEditingController();
  final _confirmFromDateController = TextEditingController();
  final _confirmToDateController = TextEditingController();
  
  int _selectedStatus = 0;

  
  final _repository = SurveyReportRepository();
  List<StringOptionModel> _units = [];
  List<StringOptionModel> _constructions = [];
  
  bool _isLoadingUnits = false;
  bool _isLoadingConstructions = false;

  String _selectedUnitId;
  String _selectedConstructionId;
  bool _hasPatc;

  DateTime _fromDate;
  DateTime _toDate;
  DateTime _confirmDateFrom;
  DateTime _confirmDateTo;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? Get.find<ListSurveyReportController>();
    


    _selectedStatus = EnumSurveyReport.values[_controller.currentTabIndex.value].getCode();
    
    _selectedUnitId = _controller.qlvhUnitId.value;
    if (_selectedUnitId != null && _selectedUnitId.isEmpty) _selectedUnitId = null;
    
    _selectedConstructionId = _controller.constructionId.value;
    if (_selectedConstructionId != null && _selectedConstructionId.isEmpty) _selectedConstructionId = null;
    
    _hasPatc = _controller.hasPatc.value;
    
    _fromDate = _controller.fromDate.value;
    _toDate = _controller.toDate.value;
    if (_fromDate != null && _toDate != null) {
      _fromDateController.text = 'Từ ${DateFormat('dd/MM/yyyy').format(_fromDate)} đến ${DateFormat('dd/MM/yyyy').format(_toDate)}';
    } else if (_fromDate != null) {
      _fromDateController.text = DateFormat('dd/MM/yyyy').format(_fromDate);
    }

    _confirmDateFrom = _controller.confirmFromDate.value;
    _confirmDateTo = _controller.confirmToDate.value;
    if (_confirmDateFrom != null && _confirmDateTo != null) {
      _confirmFromDateController.text = 'Từ ${DateFormat('dd/MM/yyyy').format(_confirmDateFrom)} đến ${DateFormat('dd/MM/yyyy').format(_confirmDateTo)}';
    } else if (_confirmDateFrom != null) {
      _confirmFromDateController.text = DateFormat('dd/MM/yyyy').format(_confirmDateFrom);
    }

    _loadData();
    
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đã xảy ra lỗi')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            details.exceptionAsString() + '\n\n' + (details.stack?.toString() ?? ''),
            style: const TextStyle(color: Colors.red, fontSize: 14),
          ),
        ),
      );
    };
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoadingUnits = true;
      _isLoadingConstructions = true;
    });
    
    final results = await Future.wait([
      _repository.getUnits(),
      _repository.getConstructions(),
    ]);
    
    final resUnits = results[0];
    final resConstructions = results[1];
    
    if (mounted) {
      setState(() {
        if (resUnits.isLoadSuccess && resUnits.data != null) {
          _units = resUnits.data;
        }
        if (resConstructions.isLoadSuccess && resConstructions.data != null) {
          _constructions = resConstructions.data;
        }
        _isLoadingUnits = false;
        _isLoadingConstructions = false;
      });
    }
  }

  Future<void> _showTimePicker(BuildContext context, bool isConfirmDate) async {
    final start = isConfirmDate ? _confirmDateFrom : _fromDate;
    final end = isConfirmDate ? _confirmDateTo : _toDate;
    final arrDateSearch = await showTimePickerSearch(context, start, end);
    if (arrDateSearch != null) {
      final str = 'Từ ${DateFormat('dd/MM/yyyy').format(arrDateSearch.start)} đến ${DateFormat('dd/MM/yyyy').format(arrDateSearch.end)}';
      setState(() {
        if (isConfirmDate) {
          _confirmDateFrom = arrDateSearch.start;
          _confirmDateTo = arrDateSearch.end;
          _confirmFromDateController.text = str;
        } else {
          _fromDate = arrDateSearch.start;
          _toDate = arrDateSearch.end;
          _fromDateController.text = str;
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
        title: const Text(
          'Lọc nâng cao',
          style: TextStyle(color: Colors.black),
        ),
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
                    const Text('Đơn vị QLVH', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleStringDropDown(
                      _units,
                      value: _selectedUnitId,
                      hint: _isLoadingUnits ? 'Đang tải...' : 'Lọc theo đơn vị QLVH',
                      onSelected: (val) {
                        setState(() {
                          _selectedUnitId = val;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Loại biên bản', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleStringDropDown(
                      [
                        StringOptionModel('Tất cả', null),
                        StringOptionModel('Đã lập PATC', 'true'),
                        StringOptionModel('Chưa lập PATC', 'false'),
                      ],
                      value: _hasPatc == null ? null : _hasPatc.toString(),
                      hint: 'Lọc theo loại biên bản',
                      onSelected: (val) {
                        setState(() {
                          if (val == null) {
                            _hasPatc = null;
                          } else {
                            _hasPatc = val == 'true';
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Tên công trình', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    SingleStringDropDown(
                      _constructions,
                      value: _selectedConstructionId,
                      hint: _isLoadingConstructions ? 'Đang tải...' : 'Tìm kiếm và chọn công trình',
                      onSelected: (val) {
                        setState(() {
                          _selectedConstructionId = val;
                        });
                      },
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
                          _fromDate = null;
                          _toDate = null;
                          _fromDateController.clear();
                        });
                      },
                      textController: _fromDateController,
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
                          _confirmDateFrom = null;
                          _confirmDateTo = null;
                          _confirmFromDateController.clear();
                        });
                      },
                      textController: _confirmFromDateController,
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
                      action: () {
                        _controller.constructionName.value = '';
                        _controller.hasPatc.value = null;
                        _controller.currentTabIndex.value = 0;
                        _controller.qlvhUnitId.value = '';
                        _controller.constructionId.value = '';
                        _controller.fromDate.value = null;
                        _controller.toDate.value = null;
                        _controller.confirmFromDate.value = null;
                        _controller.confirmToDate.value = null;
                        Get.back(result: true);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: RButton(
                      title: 'Áp dụng',
                      color: RAppColor.highlightColor70,
                      action: () {
                        _controller.qlvhUnitId.value = _selectedUnitId ?? '';
                        _controller.constructionId.value = _selectedConstructionId ?? '';
                        _controller.fromDate.value = _fromDate;
                        _controller.toDate.value = _toDate;
                        _controller.confirmFromDate.value = _confirmDateFrom;
                        _controller.confirmToDate.value = _confirmDateTo;
                        
                        _controller.hasPatc.value = _hasPatc;
                        
                        int index = EnumSurveyReport.values.indexWhere((e) => e.getCode() == _selectedStatus);
                        if (index != -1) {
                          _controller.currentTabIndex.value = index;
                        }
                        
                        Get.back(result: true);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
