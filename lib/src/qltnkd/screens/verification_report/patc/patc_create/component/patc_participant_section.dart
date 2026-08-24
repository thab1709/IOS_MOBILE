// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/patc_create_controller.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/models/patc_participant_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/patc/patc_create/widget/add_patc_participant_bottom_sheet.dart';

class PatcParticipantSection extends StatelessWidget {
  final PatcCreateController controller;

  const PatcParticipantSection({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thành phần tham gia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          _buildGroup(context, 1, '1. Đơn vị công tác', '078234b0-5b0d-467a-a670-52ff93f8c223'),
          const SizedBox(height: 24),
          _buildGroup(context, 2, '2. Đơn vị QLVH', null),
        ],
      ),
    );
  }

  Widget _buildGroup(BuildContext context, int groupType, String title, String predefinedUnitId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600))),
            if (controller.isAllowEdit)
              ElevatedButton.icon(
                onPressed: () {
                  Get.bottomSheet(
                    AddPatcParticipantBottomSheet(
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
                  backgroundColor: const Color(0xFF0F172A),
                  foregroundColor: Colors.white,
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
                     children: [
                       const Expanded(flex: 3, child: Text('Đại diện (Đơn vị)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                       const Expanded(flex: 3, child: Text('Họ và tên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                       const Expanded(flex: 2, child: Text('Chức vụ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                       if (controller.isAllowEdit)
                         const SizedBox(width: 40, child: Text('Xóa', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center)),
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
                       if (controller.isAllowEdit)
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
}
