// @dart=2.9
import 'package:evnmobile/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/constance/app_color.dart';
import '../../../common/utils/alert_dialog_utils.dart';
import '../../../models/day_night/ticket.dart';
import 'grid_menu_controller.dart';

class GridMenuScreen extends StatelessWidget {
  final GridMenuController _controller = GridMenuController();

  GridMenuScreen(){
    Future.delayed(
        const Duration(milliseconds: 200), _controller.getTotalCheckNote);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppbar(),
      backgroundColor: HighElectricAppColor.nature02,
      body:
      Container(color: HighElectricAppColor.nature01, child: _renderBody()),
    );
  }

  AppBar _renderAppbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      title: const Padding(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          'Danh sách loại sổ theo dõi',
          style: TextStyle(
              fontSize: 20,
              color: HighElectricAppColor.nature01,
              fontWeight: FontWeight.w600),
        ),
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  Widget _renderBody({TicketType ticketType}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.all(16),
      height: double.infinity,
      child: SingleChildScrollView(
          child: Obx(
                () => Column(
              children: [
                _renderMenuItem(
                    title: 'Sổ nhật ký vận hành',
                    quantity: _controller.totalCheck.value.countCheckOperationNote,
                    funtion: () async {
                      await _controller.setTypeWork(
                          TestType.unKnow, TicketType.operationLog);
                      await Get.toNamed(Routes.testPlanLogBook);
                      await _controller.getTotalCheckNote();
                    }),
                _renderMenuItem(
                    title: 'Sổ ghi ý kiến các đoàn kiểm tra',
                    quantity: _controller.totalCheck.value.countCheckNote,
                    funtion: () async {
                      await _controller.setTypeWork(
                          TestType.unKnow, TicketType.userGroupLog);
                      await Get.toNamed(Routes.testPlanLogBook);
                      await _controller.getTotalCheckNote();
                    })
              ],
            ),
          )),
    );
  }


  Widget _renderMenuItem({String title, int quantity = 0, Function funtion}) {
    return GestureDetector(
      onTap: funtion,
      child: Container(
        width: double.infinity,
        height: 75,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black, width: 1),
          // color: ticketType.bgColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                maxLines: 2,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 5),
            Flexible(
              child: Text(
                '(${quantity??0} bản ghi)',
                style: const TextStyle(
                    fontSize: 14,
                    color: HighElectricAppColor.orange,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                maxLines: 2,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

