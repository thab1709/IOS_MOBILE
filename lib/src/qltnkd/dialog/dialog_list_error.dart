// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/option_model.dart';

Future<void> showDialogListError(
    {@required Function(List<StringOptionModel>) onSelect,
    @required String ids,
    @required BuildContext context}) async {
  final listError = <StringOptionModel>[
    StringOptionModel(
        '-3FĐT HỎNG NGUỒN - Màn hình công tơ không hiển thị. Đèn phát xung P,Q không sáng. Công tơ còn nguyên chì của nhà sản xuất',
        '68'),
    StringOptionModel(
        '-3FĐT A1120 lỗi F.F 0800 - Màn hình công tơ hiển thị lỗi F.F 0800. Công tơ còn nguyên chì của nhà sản xuất.',
        '72'),
    StringOptionModel(
        '-3FĐT A1120 lỗi FF2400 - Màn hình công tơ hiển thị lỗi "FF2400". Hai đèn led P&Q sáng. Công tơ còn nguyên chì của nhà sản xuất',
        '79'),
    StringOptionModel(
        '-1FĐT LỖI ÁP CAO - Công tơ hiển thị giá trị điện áp không đúng với thực tế. Chì niêm phong công tơ còn nguyên vẹn.',
        '81'),
    StringOptionModel(
        '-3FĐT LỖI METER FAULT- Màn hình công tơ hiển thị "METER FAULT". Hai đèn phát xung P, Q sáng.Công tơ còn nguyên chì của nhà sản xuất',
        '86'),
    StringOptionModel(
        '-1FĐT LỖI HIỂN THỊ- Màn hình công tơ lỗi hiển thị, chì niêm phong của công tơ còn nguyên vẹn.',
        '88'),
    StringOptionModel(
        '- 3 PHA CƠ MẤT ÁP PHA- Chì tai niêm phong công tơ của công tơ còn nguyên vẹn. Công tơ bị mất áp pha .....',
        '116'),
    StringOptionModel(
        '- 1 PHA CƠ THẮC MẮC- Hai chì tai niêm phong công tơ còn nguyên vẹn.',
        '118'),
    StringOptionModel(
        '-1 PHA CƠ THAY K- Chì tai niêm phong công tơ của công tơ bị ...... ( - Mã chì tai niêm phong công tơ của công tơ không phải là mã chì mà Tổng công ty Điện lực TP.Hà Nội sử dụng năm .....-)',
        '119'),
    StringOptionModel(
        '- 1 PHA CƠ MẤT 1 CHÌ- Dây xâu chì tai duới ( trên ) bị đứt.', '122'),
    StringOptionModel(
        '-3FĐT LỖI ÁP CAO-Màn hình công tơ hiển thị cảnh báo điện áp A, B, C. Các giá trị điện áp pha A, B và C hiển thị không đúng với thực tế.',
        '131'),
    StringOptionModel(
        '-3FĐT MẤT ÁP- Màn hình công tơ hiển thị bình thường, đèn xung P, Q sáng. Công tơ báo mất điện áp pha .., giá trị điện áp pha .. bằng 0.',
        '132'),
    StringOptionModel(
        '-3FĐT TM - Màn hình công tơ hiển thị, 2 đèn phát xung P,Q sáng. Công tơ còn nguyên chì của nhà sản xuất.',
        '133'),
    StringOptionModel(
        '-3FĐT LỖI HIỂN THỊ- Màn hình công tơ lỗi hiển thị, đèn phát xung P, Q sáng.',
        '134'),
    StringOptionModel(
        '-3FĐT LỖI "00400000" -Màn hình công tơ báo lỗi "00400000" , Sắp hết pin. Đèn phát xung P,Q sáng.',
        '136'),
    StringOptionModel(
        '-3FĐT CHÁY HỎNG - Màn hình công tơ không hiển thị. Đèn phát xung P,Q không sáng. Công tơ bị cháy ...',
        '137'),
    StringOptionModel(
        '-3FĐT LỖI ÁP ABC= 0V - Màn hình công tơ hiển thị, 2 đèn phát xung P,Q sáng. Công tơ báo lỗi mất điện áp pha A,B,C. Giá trị điện áp 3 pha bằng 0. Công tơ còn nguyên chì của nhà sản xuất.',
        '138'),
    StringOptionModel(
        '-3FĐT LỖI 00000000- Màn hình công tơ hiển thị lỗi "00000000". Hai đèn phát xung P, Q sáng.Công tơ còn nguyên chì của nhà sản xuất.',
        '140'),
    StringOptionModel(
        '- 1FDT THẮC MẮC- Màn hình công tơ hiển thị bình thường. Hai chì tai niêm phong công tơ còn nguyên vẹn.',
        '141'),
    StringOptionModel(
        '-3FĐT MẤT ÁP QUÁ KHỨ- Màn hình công tơ hiển thị đầy đủ điện áp. Đèn phát xung P,Q sáng.',
        '142'),
    StringOptionModel(
        '3FĐT-DTS27 HỎNG NGUỒN - Màn hình công tơ hiển thị bằng nguồn pin dự phòng.Đèn phát xung P,Q không sáng. Công tơ còn nguyên chì của nhà sản xuất',
        '143'),
    StringOptionModel(
        '1FĐT ĐẤU TẮT - Hai chì tai niêm phong công tơ bị tác động. Tem kiểm định có vết rạch ở giữa',
        '144'),
    StringOptionModel(
        '3FĐT sai thời gian - Màn hình công tơ hiển thị lỗi "00000000". Hai đèn phát xung P, Q sáng. Giờ hiện tại trong công tơ không đúng với thực tế',
        '145'),
  ];

  Widget _buildItem(StringOptionModel model, Function setState) {
    return InkWell(
      onTap: () {
        Get.back();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Row(
          children: [
            Expanded(child: Center(child: Text(model.value))),
            Expanded(flex: 3, child: Text(model.title)),
            Expanded(
                child: Center(
              child: Checkbox(
                value: model.isSelected ?? false,
                onChanged: (bool value) {
                  model.isSelected = value;
                  setState(() {});
                },
              ),
            ))
          ],
        ),
      ),
    );
  }

  return showDialog(
      context: context,
      builder: (context) {
        if (ids != null) {
          ids.split(',').toList().forEach((e) {
            listError
                .firstWhereOrNull((element) => element.value == e)
                ?.isSelected = true;
          });
        }
        return StatefulBuilder(builder: (context, setState) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 150,
                // maxHeight: 250
              ),
              child: Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 26),
                      color: RAppColor.highlightColor70,
                      child: Row(
                        children: const [
                          Expanded(
                              child: Center(
                                  child: Text(
                            'Mã lỗi',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500),
                          ))),
                          Expanded(
                              flex: 3,
                              child: Center(
                                  child: Text('Tên lỗi',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)))),
                          Expanded(
                              child: Center(
                                  child: Text('Chọn',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500))))
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final model = listError[index];
                          return _buildItem(model, setState);
                        },
                        itemCount: listError.length,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RButton(
                              title: 'Hủy',
                              titleColor: Colors.black,
                              color: Colors.grey.shade100,
                              action: () {
                                Get.back();
                              }),
                          const SizedBox(
                            width: 20,
                          ),
                          RButton(
                              title: 'Xác nhận',
                              titleColor: Colors.white,
                              color: RAppColor.highlightColor70,

                              action: () {
                                final dataResult = listError
                                    .where(
                                        (element) => element.isSelected == true)
                                    .toList();
                                onSelect(dataResult);
                                Get.back();
                              }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
      });
}

