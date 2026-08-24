// @dart=2.9

import 'package:evnmobile/src/htdct/common/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../app_common/rescource/images_common.dart';
import '../../../common/constance/app_color.dart';
import '../dashboard_controller.dart';
import '../common/custom_expansion_title.dart' as custom;

class InformationCommon extends StatefulWidget {
  final DashboardController controller;

  const InformationCommon({Key key, this.controller}) : super(key: key);

  @override
  State<InformationCommon> createState() => _InformationCommonState();
}

class _InformationCommonState extends State<InformationCommon> {
  //String _timeString;


  @override
  void initState() {
    // _timeString =
    //     '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
    // Timer.periodic(const Duration(seconds: 1), (t) => _getCurrentTime());
    super.initState();
  }

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
            title: Text(
              '${widget.controller.address}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: HighElectricAppColor.nature01,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 15),
        // Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(15),
        //     color: const Color(0xffFFEACC)
        //   ),
        //   padding: const EdgeInsets.all(5),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       SvgPicture.asset(
        //         ImagesCommon.icClock,
        //         color: Colors.black,
        //         width: 40,
        //       ),
        //       const SizedBox(
        //         width: 10,
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 30),
        //         child: Text(
        //           _timeString,
        //           style: const TextStyle(
        //               fontSize: 40,
        //               fontWeight: FontWeight.w500,
        //               color: Colors.black),
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xff40A9FF),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ImagesCommon.icHumidity,
                        color: HighElectricAppColor.nature01,
                        width: 30,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Obx(() => Text(
                      widget.controller.humiValue.value != 0 ? '${widget.controller.humiValue.value.toString().replaceAll('.0', '')}%' : '---',
                            style: const TextStyle(
                                color: HighElectricAppColor.nature01,
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 100,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xffFB4746),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        ImagesCommon.icTemperature,
                        color: HighElectricAppColor.nature01,
                        width: 40,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Obx(() => Text(
                      widget.controller.tempValue.value != 0 ? '${roundDouble(widget.controller.tempValue.value, 1)}°C' : '---',
                            style: const TextStyle(
                                color: HighElectricAppColor.nature01,
                                fontWeight: FontWeight.w500,
                                fontSize: 25),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // void _getCurrentTime() {
  //   if (mounted) {
  //     setState(() {
  //       _timeString = DateTime.now().toStringFormat(HighElectricStrings.hhMMss);
  //     });
  //   }
  // }
}

