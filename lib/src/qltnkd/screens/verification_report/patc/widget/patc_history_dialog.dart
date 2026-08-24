// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/repository/patc_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_history_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/common/enum/enum_survey_report.dart';

class PatcHistoryBottomSheet extends StatefulWidget {
  final String id;
  const PatcHistoryBottomSheet({Key key, @required this.id}) : super(key: key);

  @override
  State<PatcHistoryBottomSheet> createState() => _PatcHistoryBottomSheetState();
}

class _PatcHistoryBottomSheetState extends State<PatcHistoryBottomSheet> {
  final PatcRepository _repository = PatcRepository();
  bool isLoading = true;
  List<SurveyHistoryModel> _histories = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final res = await _repository.getPatcHistory(widget.id);
    if (mounted) {
      setState(() {
        isLoading = false;
        if (res.isLoadSuccess) {
          _histories = res.data ?? [];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lịch sử duyệt', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close),
                )
              ],
            ),
          ),
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_histories.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('Không có lịch sử')),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(16),
                itemCount: _histories.length,
                itemBuilder: (context, index) {
                  final item = _histories[index];
                  bool isReject = item.action == SurveyReportStatusCode.reject;
                  String actionNameVn = item.actionName ?? '';
                  if (item.action == SurveyReportStatusCode.newReport) actionNameVn = 'Tạo mới';
                  if (item.action == SurveyReportStatusCode.waitConfirm) actionNameVn = 'Gửi xác nhận';
                  if (item.action == SurveyReportStatusCode.confirmed) actionNameVn = 'Đã xác nhận';
                  if (item.action == SurveyReportStatusCode.reject) actionNameVn = 'Từ chối';
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isReject ? Colors.red : RAppColor.highlightColor70,
                              shape: BoxShape.circle,
                            ),
                          ),
                          if (index != _histories.length - 1)
                            Container(
                              width: 2,
                              height: 60, // approximate
                              color: Colors.grey.shade300,
                            ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              actionNameVn,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isReject ? Colors.red : Colors.black),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Người thực hiện: ${item.actionBy ?? 'Người xác nhận'}',
                              style: const TextStyle(fontSize: 13),
                            ),
                            if (item.action == SurveyReportStatusCode.waitConfirm && item.nextSigners != null && item.nextSigners.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Gửi xác nhận đến: ${item.nextSigners}',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            const SizedBox(height: 4),
                            Text(
                              'Thời gian: ${item.actionDate?.toStringFormat(RAppStrings.ddMMyyyy) ?? ''}',
                              style: const TextStyle(fontSize: 13, color: Colors.grey),
                            ),
                            if (item.note != null && item.note.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Ghi chú: ${item.note}',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic,
                                      color: isReject ? Colors.red : Colors.black),
                                ),
                              ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
