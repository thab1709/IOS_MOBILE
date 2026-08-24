// @dart=2.9
import 'dart:async';

import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../htld/common/themes/colorx.dart';
import 'contents/build_abnormal.dart';
import 'contents/build_substaion_circle.dart';
import 'contents/build_work_circle.dart';
import 'contents/index.dart';
import 'dashboard_controller.dart';



class DashboardScreen extends StatefulWidget {

  const DashboardScreen();

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _controller = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      unawaited(_controller.getAddress(isShowLoading: false));
      await getAllData();
    });
  }

  Future getAllData() async {
    ProgressHUD.show();
    final futures = <Future>[];

    futures.add(_controller.getGuaranteeElectricity());
    futures.add(_controller.getNumberAbnormalInDay());
    futures.add(_controller.getWeather());
    futures.add(_controller.getPerformOnGrid());

    await Future.wait(futures);
    ProgressHUD.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _renderAppbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: AppColor.highlightColor70,
      title: const Padding(
        padding: EdgeInsets.only(left: 16),
        child: Text(
          'DASHBOARD',
          style: TextStyle(fontSize: 18),
        ),
      ),
      titleSpacing: 0,
      centerTitle: false,
    );
  }

  Widget _buildBody() {


    return Container(
      height: double.infinity,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
      child: Obx(() => Column(

      children: [
        Visibility(
          visible: false,
          child: Column(
            children: [
              Text(
                  '${_controller.guaranteeElectricityModel.value.substationCount}'),
              Text('${_controller.abnormalModel.value.countSum}'),
              Text('${_controller.electricalGridModel.value.countSum}'),
              Text(
                  '${_controller.inspectModel.value.substationDayTimeSumCount}'),
              Text(
                  '${_controller.nightInspectModel.value.substationDayTimeSumCount}'),
              Text(
                  '${_controller.lineInspectModel.value.substationDayTimeSumCount}'),
              Text(
                  '${_controller.nightLineInspectModel.value.substationDayTimeSumCount}'),
              Text(
                  '${_controller.cableInspectModel.value.substationDayTimeSumCount}'),
              Text(
                  '${_controller.statusAbnormal.value}'),
            ],
          ),
        ),
        InformationCommon(controller: _controller),
        BuildGuaranteeElectricity(controller: _controller),
        AbnormalLineChart(controller: _controller,),
        BuildSubstaionChart(controller: _controller,),
        BuildWorkChart(controller: _controller,),
      ],
      )),
    ),
    );
  }
}

