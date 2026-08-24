// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/work_registration/repository/work_registration_repository.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/survey_report/models/survey_history_model.dart';

class WorkRegistrationHistoryBottomSheet extends StatefulWidget {
  final String workRegistrationId;

  const WorkRegistrationHistoryBottomSheet({Key key, @required this.workRegistrationId}) : super(key: key);

  @override
  _WorkRegistrationHistoryBottomSheetState createState() => _WorkRegistrationHistoryBottomSheetState();
}

class _WorkRegistrationHistoryBottomSheetState extends State<WorkRegistrationHistoryBottomSheet> {
  final _repository = WorkRegistrationRepository();
  bool isLoading = true;
  List<SurveyHistoryModel> _histories = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final res = await _repository.getHistory(widget.workRegistrationId);
    if (!mounted) return;
    if (res.isLoadSuccess && res.data != null) {
      setState(() {
        _histories = res.data;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
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
                  bool isReject = item.action == 4; // 4 is reject for WorkRegistration
                  String actionNameVn = item.actionName ?? '';
                  if (item.action == 1) actionNameVn = 'Tạo mới đăng ký công tác';
                  if (item.action == 2) actionNameVn = 'Gửi duyệt';
                  if (item.action == 3) actionNameVn = 'Đã duyệt';
                  if (item.action == 4) actionNameVn = 'Từ chối đăng ký công tác';
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
                              'Người thực hiện: ${item.actionBy ?? ''}',
                              style: const TextStyle(fontSize: 13),
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
