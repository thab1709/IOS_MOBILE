// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/components/app_button.dart';
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:evnmobile/src/qltnkd/models/pdf_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/certificate/pdf/pdf_view.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/list_report/pdf_view/pdf_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> showDialogListPDF({
  @required List<PDFModel> listPDF,
  @required int type,
  @required BuildContext context,
}) async {
  const titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

  return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async {
              return true;
            },
            child: Dialog(
              insetPadding: const EdgeInsets.only(left: 30, right: 30),
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: 150,
                    maxHeight: Get.size.height / 2
                  // maxHeight: 250
                ),
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20, left: 16, top: 26, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(bottom: 26),
                          child: Text('${type == 1 ? 'Biên bản' : 'Diấy chứng nhận'} đã ký số', style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: RAppColor.highlightColor70
                          ),)
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: RAppColor.backgroundColorGray,
                            borderRadius: BorderRadius.circular(6)                     ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                                flex : 2,
                                child: Text(
                                  type == 1 ? 'Số biên bản' : 'Số giấy chứng nhận',
                                  textAlign: TextAlign.left,
                                  style: titleStyle,
                                )),
                            const Expanded(
                                child: Text(
                                  'Thao tác',
                                  textAlign: TextAlign.center,
                                  style: titleStyle,
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index){
                              final model = listPDF[index];
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                                child: Row(children: [
                                  Expanded(flex : 2, child: Text(model.reportNumber, style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400
                                  ),)),
                                  Expanded(child:  IconButton(
                                    icon: const Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      if(type == 1) {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => RPdfScreen(code: model.reportNumber, link: model.link)),
                                        );
                                      } else {
                                        Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => RPdfCertificateScreen(code: model.reportNumber, link: model.link)),
                                        );
                                      }
                                    },
                                  )),
                                ],),
                              );
                            }, separatorBuilder: (context, index){
                          return const Divider(
                            thickness: 1,
                            height: 1,
                          );
                        }, itemCount: listPDF.length),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            RButton(title: 'Đóng', action: () {
                              Get.back();
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
      });
}

