// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/utils/alert_dialog_utils.dart';
import 'package:evnmobile/src/qltnkd/models/workload/workload_model.dart';
import 'package:evnmobile/src/qltnkd/screens/verification_report/workload/common/constance_workload.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_button.dart';
import '../../../../common/constance/common.dart';
import '../../../../common/themes/colorx.dart';
import '../../../../models/workload/request_model.dart';
import '../list_workload/pdf/pdf_view.dart';
import 'detail_workload_controller.dart';
import 'general/detail_general.dart';
import 'list_work/list_work_workload.dart';

class DetailWorkLoad extends StatefulWidget {
  const DetailWorkLoad({this.requestModel, this.workloadModel, Key key})
      : super(key: key);
  final RequestModel requestModel;
  final WorkloadModel workloadModel;

  @override
  State<DetailWorkLoad> createState() => _DetailWorkLoadState();
}

class _DetailWorkLoadState extends State<DetailWorkLoad>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _controller = Get.put(DetailWorkloadController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.setupData(widget.requestModel, widget?.workloadModel);
    });
  }

  @override
  void dispose() {
    Get.delete<DetailWorkloadController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        checkExit();
        return false;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            actions: [
              Obx(() {
                if (_controller.isLoaded.value) {}
                if (_controller.detailWorkloadModel != null) {
                  return IconButton(
                      onPressed: () {
                        Get.to(() => PDFWorkloadScreen(
                              id: _controller.detailWorkloadModel.id,
                              code: _controller.detailWorkloadModel.code,
                              consultantsImage: _controller.detailWorkloadModel.consultantsImage,
                            ));
                      },
                      icon: const Icon(Icons.picture_as_pdf));
                } else {
                  return const SizedBox();
                }
              })
            ],
            leading: BackButton(
              onPressed: () async {
                checkExit();
              },
            ),
            systemOverlayStyle: SystemUiOverlayStyle.light,
            centerTitle: false,
            title: const Text(
              'Phiếu xác nhận khối lượng công việc',
              style: TextStyle(fontSize: TextSize.normal),
            ),
            bottom: TabBar(
                controller: _tabController,
                isScrollable: MediaQuery.of(context).size.width < 600,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: const [
                  Tab(
                    text: 'Thông tin chung',
                  ),
                  Tab(
                    text: 'Danh sách công việc',
                  ),
                ]),
          ),
          backgroundColor: RAppColor.backgroundColorGray,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      GeneralWorkload(),
                      ListWorkWorkLoad(),
                    ],
                  ),
                ),
                _buildButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton() {
    return Obx(() {
      if (_controller.isLoaded.value) {}

      return Row(
        children: [
          if (_controller.requestModel != null &&
              _controller.userProfile.isHasPermissionCreateConfirmSheet())
            Expanded(
              flex: 3,
              child: RButton(
                title: 'Hủy',
                borderRadius: 0,
                color: RAppColor.backgroundColorGray,
                titleColor: Colors.black,
                action: () {
                  checkExit();
                },
              ),
            ),
          if (_controller?.detailWorkloadModel?.status !=
                  WorkloadStatusCode.confirmed &&
              _controller?.detailWorkloadModel?.status !=
                  WorkloadStatusCode.waitConfirm &&
              _controller.userProfile.isHasPermissionCreateConfirmSheet())
            Expanded(
              flex: 3,
              child: RButton(
                title: _controller.requestModel != null ? 'Tạo phiếu' : 'Lưu',
                color: _controller.requestModel != null ||
                        _controller?.detailWorkloadModel?.isAllowSend == true
                    ? RAppColor.colorOrange
                    : RAppColor.highlightColor70,
                borderRadius: 0,
                action: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_controller.requestModel != null) {
                    _controller.createRequest();
                  } else {
                    _controller.updateRequest();
                  }
                },
              ),
            ),
          if (_controller?.detailWorkloadModel?.isAllowSend == true &&
              (_controller?.detailWorkloadModel?.status ==
                  WorkloadStatusCode.newWork || _controller?.detailWorkloadModel?.status == WorkloadStatusCode.reject) &&
              _controller.userProfile.isHasPermissionSendConfirmSheet())
            Expanded(
              flex: 3,
              child: RButton(
                title: 'Gửi xác nhận',
                borderRadius: 0,
                action: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _controller.sendRequest();
                },
              ),
            ),
          if (_controller?.detailWorkloadModel?.isAllowConfirm == true &&
              _controller?.detailWorkloadModel?.status ==
                  WorkloadStatusCode.waitConfirm &&
              _controller.userProfile.isHasPermissionApproveConfirmSheet())
          Expanded(
            flex: 3,
            child: RButton(
              title: 'Từ chối',
              borderRadius: 0,
              color: RAppColor.colorOrange,
              action: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _controller.reject();
              },
            ),
          ),
          if (_controller?.detailWorkloadModel?.isAllowConfirm == true &&
              _controller?.detailWorkloadModel?.status ==
                  WorkloadStatusCode.waitConfirm &&
              _controller.userProfile.isHasPermissionApproveConfirmSheet())
            Expanded(
              flex: 3,
              child: RButton(
                title: 'Xác nhận',
                borderRadius: 0,
                action: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _controller.approval();
                },
              ),
            ),
        ],
      );
    });
  }

  void checkExit() {
    FocusScope.of(context).requestFocus(FocusNode());
    if ((_controller.requestModel != null ||
            _controller?.detailWorkloadModel?.status ==
                WorkloadStatusCode.newWork ||
            _controller?.detailWorkloadModel?.status ==
                WorkloadStatusCode.reject) &&
        _controller.userProfile.isHasPermissionCreateConfirmSheet()) {
      rShowMyDialogOkCancel('Bạn có chắc muốn thoát không?',
          secondFunction: () {
        Get.back();
      });
    } else {
      Get.back();
    }
  }
}

