// @dart=2.9
import 'package:evnmobile/src/htld/services/location_background_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../htdct/common/components/app_button.dart';
import 'bb_cong_to_controller.dart';
import 'components/general_infomation_ct.dart';
import 'components/index_meter.dart';
import 'components/ma_chi_phan_cai_dat.dart';
import 'components/test_result.dart';
import 'components/tinh_trang_cong_to.dart';

class BBCongToPage extends StatefulWidget {
  const BBCongToPage(
      {@required this.reportID, @required this.isAllowEdit, Key key})
      : super(key: key);
  final String reportID;
  final bool isAllowEdit;

  @override
  State<BBCongToPage> createState() => _BBCongToState();
}

class _BBCongToState extends State<BBCongToPage> with TickerProviderStateMixin {
  final _controller = Get.put(BBCongToController());

  TabController pageController;

  @override
  void initState() {
    super.initState();
    pageController = TabController(length: 5, vsync: this);
    _controller.enable = widget.isAllowEdit;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (widget.isAllowEdit) {
        await LocationServiceBackground.shared.requestPermission();
      }
      _controller.meterId = widget.reportID;
      _controller.getMeterDetail();
      _controller.getEquipmentInspection();
      _controller.getMeterMeasuringComment(_controller.meterElectric);
      _controller.getMeterMeasuringComment(_controller.measuring);
      _controller.getMeterMeasuringComment(_controller.otherComment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Biên bản công tơ'),
          bottom: TabBar(
            controller: pageController,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Thông tin chung'),
              Tab(text: 'Chỉ số'),
              Tab(text: 'Mã chì phần cài đặt'),
              Tab(text: 'Tình trạng công tơ'),
              Tab(text: 'Kết luận'),
            ],
          ),
        ),
        body: TabBarView(
          controller: pageController,
          children: const [
            GeneralInformationCT(),
            IndexMeter(),
            MaChiPhanCaiDat(),
            TinhTrangCongTo(),
            TestResult(),
          ],
        ),
        bottomNavigationBar: widget.isAllowEdit ? Row(
          children: [
            Expanded(
              child: EButton(
                borderRadius: 0,
                maxSize: true,
                title: 'Lưu',
                action: () {
                  _controller.unFocus();
                  if (_controller.validateGeneralInfo()) {
                    _controller.updateMeter();
                  }
                },
              ),
            )
          ],
        ) : const SizedBox()
    );
  }
}

