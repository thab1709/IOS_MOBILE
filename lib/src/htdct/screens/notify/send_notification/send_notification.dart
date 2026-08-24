// @dart=2.9
import 'package:evnmobile/src/htdct/common/components/e_text_field.dart';
import 'package:evnmobile/src/htdct/screens/notify/send_notification/send_notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import '../../../../qltnkd/common/components/app_button.dart';
import '../../../../qltnkd/common/themes/colorx.dart';
import '../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../common/constance/app_color.dart';

class SendNotification extends StatefulWidget {
  const SendNotification({Key key}) : super(key: key);

  @override
  State<SendNotification> createState() => _SendNotificationState();
}

class _SendNotificationState extends State<SendNotification> {
  final _controller = SendNotificationController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _controller.initData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialogConfirm();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gửi phản hồi'),
          leading: BackButton(
            onPressed: () {
              showDialogConfirm();
            },
          ),
        ),
        body: Column(
          children: [_buildBody(), _buildButton(context)],
        ),
      ),
    );
  }

  Widget _buildBody() {
    const spacer = SizedBox(
      height: 20,
    );
    return Expanded(
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              ETextField(
                  title: 'Nội dung',
                  line: 3,
                  value: _controller.content.value,
                  isRequire: true,
                  hintText: 'Vui lòng nhập nội dung',
                  onChange: (value) {
                    _controller.content.value = value;
                    _controller.checkHasPermissionSend();
                  }),
              spacer,
              _buildTitle('Người nhận'),
              spacer,
              _buildTitle('Giám đốc'),
              Obx(() => MultiSelectDialogField(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.grey.shade300)),
                  cancelText: const Text('Hủy'),
                  title: const Text('Giám đốc'),
                  buttonText: const Text('Chọn',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: HighElectricAppColor.nature04)),
                  buttonIcon: const Icon(Icons.arrow_drop_down),
                  items: _controller.x6Chairmans
                      .map((e) => MultiSelectItem(e, e.title))
                      .toList(),
                  listType: MultiSelectListType.CHIP,
                  onConfirm: (values) {
                    _controller.x6ChairmansID.value = values;
                    _controller.checkHasPermissionSend();
                  })),
              spacer,
              _buildTitle('Phó giám đốc'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Phó giám đốc'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.x6ViceChairmans
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.x6ViceChairmanID.value = values;
                      _controller.checkHasPermissionSend();
                    },
                  )),
              spacer,
              _buildTitle('Trưởng phòng kỹ thuật'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Trưởng phòng kỹ thuật'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.x6TechnicalChiefs
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.x6TechnicalChiefID.value = values;
                      _controller.checkHasPermissionSend();
                    },
                  )),
              spacer,
              _buildTitle('Phó phòng kỹ thuật'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Phó phòng kỹ thuật'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.x6DeputyChiefs
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.x6DeputyChiefID.value = values;
                      _controller.checkHasPermissionSend();
                    },
                  )),
              spacer,
              _buildTitle('Chuyên viên phòng'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Chuyên viên phòng'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.x6Experts
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.x6ExpertsID.value = values;
                      _controller.checkHasPermissionSend();
                    },
                  )),
              spacer,
              _buildTitle('Phòng/Đội'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Phòng/Đội'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.groups
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.groupID.value = values;
                      _controller.clearTeamData();
                      _controller.getTeamByGroupX6();
                      _controller.checkHasPermissionSend();
                    },
                  )),
              spacer,
              _buildTitle('Tổ'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Tổ'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.teams
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.teamID.value = values;
                      _controller.clearEmployee();
                      _controller.getEmployees();
                      _controller.checkHasPermissionSend();
                    },
                  )),
              spacer,
              _buildTitle('Nhân viên'),
              Obx(() => MultiSelectDialogField(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300)),
                    cancelText: const Text('Hủy'),
                    title: const Text('Nhân viên'),
                    buttonText: const Text('Chọn',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: HighElectricAppColor.nature04)),
                    buttonIcon: const Icon(Icons.arrow_drop_down),
                    items: _controller.employees
                        .map((e) => MultiSelectItem(e, e.title))
                        .toList(),
                    listType: MultiSelectListType.CHIP,
                    onConfirm: (values) {
                      _controller.x6EmployeeID.value = values;
                      _controller.checkHasPermissionSend();
                    },
                  )),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: RButton(
            title: 'Hủy',
            borderRadius: 0,
            color: RAppColor.backgroundColorGray,
            titleColor: Colors.black,
            action: () {
              FocusScope.of(context).requestFocus(FocusNode());
              rShowMyDialogOkCancel('Bạn có chắc muốn hủy gửi phản hồi không?',
                  secondFunction: () {
                Get.back();
              });
            },
          ),
        ),
        Expanded(
          child: Obx(() => RButton(
                title: 'Gửi',
                borderRadius: 0,
                titleColor: _controller.isHasPermissionSend.value
                    ? Colors.white
                    : Colors.black,
                color: _controller.isHasPermissionSend.value
                    ? RAppColor.highlightColor70
                    : Colors.grey,
                action: () {
                  if (_controller.isHasPermissionSend.value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _controller.sendFeedback();
                  }
                },
              )),
        ),
      ],
    );
  }

  void showDialogConfirm() {
    rShowMyDialogOkCancel('Bạn có chắc muốn thoát không', secondFunction: () {
      Get.back();
    });
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w400),
      ),
    );
  }
}

