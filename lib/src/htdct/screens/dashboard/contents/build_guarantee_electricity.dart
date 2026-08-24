// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/app_color.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/report/component/expand_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../htld/common/components/app_button.dart';
import '../../../common/themes/styles.dart';
import '../../../models/dashboard/guarantee_electricity_model.dart';
import '../dashboard_controller.dart';
import '../common/custom_expansion_title.dart' as custom;

class BuildGuaranteeElectricity extends StatelessWidget {
  final DashboardController controller;

  const BuildGuaranteeElectricity({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      // padding: const EdgeInsets.only(left: 16, right: 16),
      color: HighElectricAppColor.nature01,
      child: ListTileTheme(
        contentPadding: const EdgeInsets.all(0),
        tileColor: Colors.transparent,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: custom.ExpansionTile(
            backgroundColor: Colors.transparent,
            headerBackgroundColor: HighElectricAppColor.highlightColorDashboard,
            iconColor: HighElectricAppColor.nature01,
            initiallyExpanded: false,
            title: const Text(
              'Đảm bảo điện',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature01,
              ),
            ),
            children: [
              buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    var model =
        controller.guaranteeElectricityModel.value as GuaranteeElectricityModel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (!controller.abnormalSubstationSelected.value) {
                            controller.abnormalSubstationSelected.value = true;
                            controller.abnormalSubstationSelected.refresh();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xff40A9FF), //
                                width: 2, //                   <--- border color
                              ),
                              color: controller.abnormalSubstationSelected.value
                                  ? const Color(0xff40A9FF)
                                  : Colors.white),
                          child: Text(
                            'Trạm biến áp: (${model.substationCount??''})',
                            style: TextStyle(
                              color: controller.abnormalSubstationSelected.value
                                  ? Colors.white
                                  : const Color(0xff40A9FF),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.abnormalSubstationSelected.value) {
                            controller.abnormalSubstationSelected.value = false;
                            controller.abnormalSubstationSelected.refresh();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xff40A9FF), //
                                width: 2, //              <--- border color
                              ),
                              color: controller.abnormalSubstationSelected.value
                                  ? Colors.white
                                  : const Color(0xff40A9FF)),
                          child: Text(
                            'Đường dây: (${model.lineCount??''})',
                            style: TextStyle(
                              color: controller.abnormalSubstationSelected.value
                                  ? const Color(0xff40A9FF)
                                  : Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              if (controller.abnormalSubstationSelected.value && model.dbdSubstationDetails!=null)
                Column(
                  children: [
                    for (var index = 0;
                        index < model.dbdSubstationDetails.length;
                        index++)
                      Container(
                        width: double.infinity,
                        color: const Color(0xffF5F5F5),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${model.dbdSubstationDetails[index].substationName}',
                                style: const TextStyle(
                                    color: Color(0xff696973), fontSize: 14),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Máy cắt: ${model.dbdSubstationDetails[index].mcName}',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (index <
                                        model.dbdSubstationDetails.length - 1)
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 1,
                                            width: double.infinity,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${model.substationCount}:${model.dbdSubstationDetails.map((e) => e.substationName).join(', ')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFF9700),
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
              if (!controller.abnormalSubstationSelected.value&& model.dbdLineDetails!=null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var index = 0;
                        index < model.dbdLineDetails.length;
                        index++)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 10),
                        child: Text(
                          '${model.dbdLineDetails[index].lineName}',
                          style: const TextStyle(
                              color: Color(0xff696973),
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                      ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${model.lineCount}:${model.dbdLineDetails.map((e) => e.lineName).join(', ')}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFF9700),
                          ),
                          softWrap: true,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future showDetail({
    BuildContext context,
    bool isSubstation,
  }) async {
    var model =
        controller.guaranteeElectricityModel.value as GuaranteeElectricityModel;
    await showDialog(
      builder: (context) {
        return AlertDialog(
            actions: <Widget>[
              EButton(
                title: 'Đóng',
                action: () => {Navigator.pop(context), false},
                color: HighElectricAppColor.primary10,
              ),
            ],
            title: Text('${isSubstation ? 'TBA' : 'ĐZ'}_Đảm bảo điện'),
            content: Container(
              height: Get.size.height > 600
                  ? Get.size.height - 300
                  : Get.size.height - 100,
              width: Get.size.width - 150,
              child: isSubstation
                  ? Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: List.generate(
                              model.dbdSubstationDetails.length,
                              (index) => Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      child: Text(model
                                          .dbdSubstationDetails[index]
                                          .substationName)),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 50),
                                    child: Container(
                                        width: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Máy cắt: ${model.dbdSubstationDetails[index].mcName}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true,
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              width: double.infinity,
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                  text: '=>${model.substationCount}: ' ?? '',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black),
                                  children: <TextSpan>[
                                    for (int i = 0;
                                        i < model.dbdSubstationDetails.length;
                                        i++)
                                      TextSpan(
                                        text:
                                            '${model.dbdSubstationDetails[i].substationName}${i < model.dbdSubstationDetails.length - 1 ? ',' : ''}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            for (int i = 0;
                                i < model.dbdSubstationDetails.length;
                                i++)
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Máy cắt: ${model.dbdSubstationDetails[i].mcName}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      softWrap: true,
                                    )),
                              ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: List.generate(
                              model.dbdLineDetails.length,
                              (index) => Column(
                                children: [
                                  Container(
                                      width: Get.size.width,
                                      alignment: Alignment.centerLeft,
                                      child: Text(model
                                          .dbdLineDetails[index].lineName)),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: '=>${model.substationCount}: ' ?? '',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                for (int i = 0;
                                    i < model.dbdLineDetails.length;
                                    i++)
                                  TextSpan(
                                    text:
                                        '${model.dbdLineDetails[i].lineName}${i < model.dbdLineDetails.length - 1 ? ',' : ''}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ));
      },
      context: context,
    );
  }
}

