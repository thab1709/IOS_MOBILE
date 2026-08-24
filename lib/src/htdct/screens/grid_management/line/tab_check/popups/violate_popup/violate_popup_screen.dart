// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/screens/grid_management/line/tab_check/popups/violate_popup/widgets/picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../common/components/app_button.dart';
import '../../../../../../common/constance/app_color.dart';
import '../../../../../../common/constance/content_option.dart';
import '../../../../../../common/constance/inspection_type.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/enum/ticket_enum.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../log_book/common/widget_items.dart';
import '../../../../containers/e_text_form_field.dart';
import '../../../../not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import '../../../../transformer/check_by_daytime/check_sheet/common/abnormal_dropdown_widget.dart';
import 'common/date_time_picker_custom.dart';
import 'common/image_camera.dart';
import 'common/status_tracking_dropdown.dart';
import 'violate_popup_controller.dart';

class ViolatePopup extends StatefulWidget {
  final int typeViolation;
  final String id;
  final String nameViolate;
  final ActionTicketType tiketType;
  final String title;
  final bool fromAbnormal;

  const ViolatePopup({
    @required this.nameViolate,
    @required this.tiketType,
    this.typeViolation,
    Key key,
    this.id,
    this.title,
    this.fromAbnormal = false,
  }) : super(key: key);

  @override
  State<ViolatePopup> createState() => _ViolatePopupState();
}

class _ViolatePopupState extends State<ViolatePopup> {
  final _controller = ViolatePopupController();

  @override
  void initState() {
    super.initState();
    _controller.typeViolation.value = widget.typeViolation ?? 0;
    _controller.nameViolate = widget.nameViolate ?? '';
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final futures = <Future>[];
      futures.add(_controller.getAllLine());
      futures.add(_controller.getAbnormalOptions());
      if (widget.tiketType != ActionTicketType.create && widget.id != null) {
        _controller.id = widget.id;
        futures.add(_controller.getData(id: widget.id));
      } else {
        final location = await _controller.getPosition();
        if (location == null) {
          await hShowDialogOneButton('Lỗi lấy bị trí thiết bị');
          return;
        }
        await _controller.getAddress(location);
      }

      await Future.wait(futures);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _renderAppbar(),
      body: Column(
        children: [
          if (widget.fromAbnormal != true)
            Obx(() => Expanded(child: _renderContent(context))),
          if (widget.fromAbnormal == true)
            Obx(() => Expanded(child: _renderContentFromAbnormal(context))),
          Obx(
            () => (_controller.typeViolation == null ||
                    _controller.typeViolation.value == 0)
                ? Container()
                : _buildFooter(),
          )
        ],
      ),
    );
  }

  AppBar _renderAppbar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      backgroundColor: HighElectricAppColor.primary10,
      leading: BackButton(
        color: Colors.white,
        onPressed: () {
          hShowMyDialogOkCancel(
            'Bạn có chắc muốn hủy không?',
            secondFunction: () {
              Get.back();
            },
          );
        },
      ),
      title: Text(
        widget.title ?? 'Tạo kiểm tra vi phạm',
        style: const TextStyle(
          fontSize: 20,
          color: HighElectricAppColor.nature01,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return (widget.tiketType == ActionTicketType.view)
        ? Container()
        : Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: EButton(
                    title: 'Huỷ',
                    titleColor: Colors.grey,
                    borderColor: Colors.grey,
                    color: Colors.white,
                    action: () {
                      Get.back();
                    },
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Expanded(
                  child: EButton(
                    title: 'Lưu',
                    action: () {
                      _controller.onSubmit(
                        fromAbnormal: widget.fromAbnormal == true,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Widget _renderContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (_controller.typeViolation.value ==
                ViolateInspectionType.violateLobby)
              _buildViolateLobby(context)
            else if (_controller.typeViolation.value ==
                ViolateInspectionType.violateRoadworks)
              _buildViolateRoadworks(context)
            else
              _buildViolateCorridorTree(context)
          ],
        ),
      ),
    );
  }

  Widget _buildViolateLobby(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAbnormalDropdown(),
        //Mã điểm vi phạm
        if (_controller.typeViolation.value !=
            ViolateInspectionType.violateLobby)
          ETextFormField(
            /*formKey: formKey,*/
            hint: 'Nhập thông tin',
            title: 'Mã điểm vi phạm: ',
            readOnly: widget.tiketType == ActionTicketType.view,
            isNumpad: false,
            isRequied: true,
            invalid: _controller.invalid.value,
            value: _controller.model.codePointViolate,
            onChangeInput: (value) {
              _controller.model.codePointViolate = value;
            },
          ),
        //Tên điểm vi phạm
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Tên điểm vi phạm: ',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.namePointViolate,
          onChangeInput: (value) {
            _controller.model.namePointViolate = value;
          },
        ),
        //Đối tượng vi phạm
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Đối tượng vi phạm: ',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.subjectViolate,
          onChangeInput: (value) {
            _controller.model.subjectViolate = value;
          },
        ),

        //Khoảng cột
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Khoảng cột: ',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.aboutColumn,
          onChangeInput: (value) {
            _controller.model.aboutColumn = value;
          },
        ),
        //Địa chỉ
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ETextFormField(
                /*formKey: formKey,*/
                hint: 'Nhập thông tin',
                title: 'Địa chỉ: ',
                isNumpad: false,
                isRequied: true,
                readOnly: true,
                invalid: _controller.invalid.value,
                value: _controller.model.address,
                onChangeInput: (value) {
                  _controller.model.address = value;
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                final location = _controller.position;
                final position = await Get.to(() => MapPickerPage(
                      currentLocation: location,
                    ));
                if (position != null) {
                  _controller.position = position as LatLng;
                  await _controller.getAddress(position as LatLng);
                }
              },
              icon: const Icon(Icons.map),
            ),
          ],
        ),

        //Thời điểm vi phạm kết thúc
        showDateTimePicker(),
        //Khoảng cách đứng (m):
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Khoảng cách đứng (m): ',
          isNumpad: true,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.standingDistance.toString(),
          onChangeInput: (value) {
            _controller.model.standingDistance = value.toIntOrNull();
          },
        ),
        //Khoảng cách ngang (m):
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Khoảng cách ngang (m):',
          isNumpad: true,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.horizontalDistance.toString(),
          onChangeInput: (value) {
            _controller.model.horizontalDistance = value.toIntOrNull();
          },
        ),
        //Tình trạng vi phạm:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Tình trạng vi phạm:',
          isNumpad: false,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.statusViolate,
          onChangeInput: (value) {
            _controller.model.statusViolate = value;
          },
        ),
        //Tính chất công trình:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Tính chất công trình:',
          isNumpad: false,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.constructionProperties,
          onChangeInput: (value) {
            _controller.model.constructionProperties = value;
          },
        ),
        //Ảnh hiện trường:
        ImageCamera(
          required: true,
          controller: _controller,
          context: context,
          problem: 0,
          images: _controller.getImageByProblem(0),
          viewMode: widget.tiketType == ActionTicketType.view,
          title: 'Ảnh hiện trường',
        ),
        //Giải pháp thực hiện:
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ETextFormField(
                /*formKey: formKey,*/
                hint: 'Nhập thông tin',
                title: 'Giải pháp thực hiện:',
                isNumpad: false,
                isRequied: true,
                readOnly: widget.tiketType == ActionTicketType.view,
                invalid: _controller.invalid.value,
                value: _controller.model.solution,
                onChangeInput: (value) {
                  _controller.model.solution = value;
                },
              ),
            ),
            ImageCamera(
              controller: _controller,
              context: context,
              problem: 1,
              images: _controller.getImageByProblem(1),
              viewMode: widget.tiketType == ActionTicketType.view,
              title: 'Ảnh đính kèm',
            ),
          ],
        ),

        //Trạng thái theo dõi:
        StatusTrackingDropdown(
          onChange: (value) {
            _controller.model.trackingStatus = value.toIntOrNull();
          },
          invalid: _controller.model.trackingStatus == null,
          defaultValue: _controller.model.trackingStatus,
        ),
      ],
    );
  }

  Widget _buildViolateRoadworks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildAbnormalDropdown(),
        //Tên công trường:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Tên công trường:',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.constructionName,
          onChangeInput: (value) {
            _controller.model.constructionName = value;
          },
        ),
        //Khoảng cột:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Khoảng cột:',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.aboutColumn,
          onChangeInput: (value) {
            _controller.model.aboutColumn = value;
          },
        ),

        //Thời điểm vi phạm kết thúc
        showDateTimePicker(),
        //Địa chỉ:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ETextFormField(
                /*formKey: formKey,*/
                hint: 'Nhập thông tin',
                title: 'Địa chỉ: ',
                isNumpad: false,
                isRequied: true,
                readOnly: true,
                invalid: _controller.invalid.value,
                value: _controller.model.address,
                onChangeInput: (value) {
                  _controller.model.address = value;
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                final location = _controller.position;
                final position = await Get.to(() => MapPickerPage(
                      currentLocation: location,
                    ));
                if (position != null) {
                  _controller.position = position as LatLng;
                  await _controller.getAddress(position as LatLng);
                }
              },
              icon: const Icon(Icons.map),
            ),
          ],
        ),
        //Chủ đầu tư:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Chủ đầu tư: ',
          isNumpad: false,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.investor,
          onChangeInput: (value) {
            _controller.model.investor = value;
          },
        ),
        //Khoảng cách ngang (m):
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Đơn vị thi công:',
          isNumpad: false,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.constructionUnit,
          onChangeInput: (value) {
            _controller.model.constructionUnit = value;
          },
        ),
        //Tình trạng xây dựng:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Tình trạng xây dựng:',
          isNumpad: false,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.constructionStatus,
          onChangeInput: (value) {
            _controller.model.constructionStatus = value;
          },
        ),
        //Ghi chú:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Ghi chú:',
          isNumpad: false,
          isRequied: false,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.note,
          onChangeInput: (value) {
            _controller.model.note = value;
          },
        ),
        //Ảnh hiện trường:
        ImageCamera(
          required: true,
          controller: _controller,
          context: context,
          problem: 0,
          images: _controller.getImageByProblem(0),
          viewMode: widget.tiketType == ActionTicketType.view,
          title: 'Ảnh hiện trường',
        ),
        //Giải pháp thực hiện:
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ETextFormField(
                /*formKey: formKey,*/
                hint: 'Nhập thông tin',
                title: 'Giải pháp thực hiện:',
                isNumpad: false,
                isRequied: true,
                readOnly: widget.tiketType == ActionTicketType.view,
                invalid: _controller.invalid.value,
                value: _controller.model.solution,
                onChangeInput: (value) {
                  _controller.model.solution = value;
                },
              ),
            ),
            ImageCamera(
              controller: _controller,
              context: context,
              problem: 1,
              images: _controller.getImageByProblem(1),
              viewMode: widget.tiketType == ActionTicketType.view,
              title: 'Ảnh đính kèm',
            ),
          ],
        ),
        //Trạng thái theo dõi:
        StatusTrackingDropdown(
          onChange: (value) {
            _controller.model.trackingStatus = value.toIntOrNull();
          },
          invalid: _controller.model.trackingStatus == null,
          defaultValue: _controller.model.trackingStatus,
        ),
      ],
    );
  }

  Widget _buildViolateCorridorTree(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildAbnormalDropdown(),
        //Loại cây
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Loại cây:',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.treeType,
          onChangeInput: (value) {
            _controller.model.treeType = value;
          },
        ),
        //Khoảng cột:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Khoảng cột:',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.aboutColumn,
          onChangeInput: (value) {
            _controller.model.aboutColumn = value;
          },
        ),
        //Chiều cao (m):
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Chiều cao (m):',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.height,
          onChangeInput: (value) {
            _controller.model.height = value;
          },
        ),
        //Địa chỉ:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ETextFormField(
                /*formKey: formKey,*/
                hint: 'Nhập thông tin',
                title: 'Địa chỉ: ',
                isNumpad: false,
                isRequied: true,
                readOnly: true,
                invalid: _controller.invalid.value,
                value: _controller.model.address,
                onChangeInput: (value) {
                  _controller.model.address = value;
                },
              ),
            ),
            IconButton(
              onPressed: () async {
                final location = _controller.position;
                final position = await Get.to(() => MapPickerPage(
                      currentLocation: location,
                    ));
                if (position != null) {
                  _controller.position = position as LatLng;
                  await _controller.getAddress(position as LatLng);
                }
              },
              icon: const Icon(Icons.map),
            ),
          ],
        ),
        //Vị trí so với hành lang:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Vị trí so với hành lang:',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.location,
          onChangeInput: (value) {
            _controller.model.location = value;
          },
        ),
        //Khoảng cách gần nhất (m)::
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Khoảng cách gần nhất (m):',
          readOnly: widget.tiketType == ActionTicketType.view,
          isNumpad: false,
          isRequied: true,
          invalid: _controller.invalid.value,
          value: _controller.model.distanceNearest,
          onChangeInput: (value) {
            _controller.model.distanceNearest = value;
          },
        ),
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Tình trạng vi phạm:',
          isNumpad: false,
          isRequied: true,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.statusViolate,
          onChangeInput: (value) {
            _controller.model.statusViolate = value;
          },
        ),
        //Thời điểm vi phạm kết thúc
        showDateTimePicker(),
        //Ghi chú:
        ETextFormField(
          /*formKey: formKey,*/
          hint: 'Nhập thông tin',
          title: 'Ghi chú:',
          isNumpad: false,
          isRequied: false,
          readOnly: widget.tiketType == ActionTicketType.view,
          invalid: _controller.invalid.value,
          value: _controller.model.note,
          onChangeInput: (value) {
            _controller.model.note = value;
          },
        ),
        //Ảnh hiện trường:
        ImageCamera(
          required: true,
          controller: _controller,
          context: context,
          problem: 0,
          images: _controller.getImageByProblem(0),
          title: 'Ảnh hiện trường',
          viewMode: widget.tiketType == ActionTicketType.view,
        ),
        //Giải pháp thực hiện:
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ETextFormField(
                /*formKey: formKey,*/
                hint: 'Nhập thông tin',
                title: 'Giải pháp thực hiện:',
                isNumpad: false,
                isRequied: true,
                readOnly: widget.tiketType == ActionTicketType.view,
                invalid: _controller.invalid.value,
                value: _controller.model.solution,
                onChangeInput: (value) {
                  _controller.model.solution = value;
                },
              ),
            ),
            ImageCamera(
                controller: _controller,
                context: context,
                problem: 1,
                images: _controller.getImageByProblem(1),
                viewMode: widget.tiketType == ActionTicketType.view,
                title: 'Ảnh đính kèm'),
          ],
        ),
        //Trạng thái theo dõi:
        StatusTrackingDropdown(
          onChange: (value) {
            _controller.model.trackingStatus = value.toIntOrNull();
          },
          invalid: _controller.model.trackingStatus == null,
          defaultValue: _controller.model.trackingStatus,
        ),
      ],
    );
  }

  Widget showDateTimePicker() {
    return Column(
      children: [
        //Thời điểm vi phạm
        DateTimePickerCustom(
          textEditingController: _controller.timeFollowController,
          readOnly: widget.tiketType == ActionTicketType.view,
          title: 'Thời điểm vi phạm',
          onChange: (value) {
            _controller.timeFollowController.text = value.toString() == 'null'
                ? null
                : DateTime.parse(value.toString())
                    .toStringFormat(HighElectricStrings.ddmmyyyyHHmm);
            _controller.model.timeViolate = value.toString() == 'null'
                ? null
                : DateTime.parse(value.toString()).toStringFormat(
                    HighElectricStrings.utcFormatNotZ,
                    isUtc: true,
                  );

            if (_controller.model.timeViolate.isNullOrEmpty()) {
              _controller.model.trackingStatus = null;
              _controller.model.endViolate = null;
            }
            if (!_controller.model.timeViolate.isNullOrEmpty() &&
                !_controller.model.endViolate.isNullOrEmpty()) {
              _controller.model.trackingStatus = ContentOptions.finished.value;
            } else if (_controller.model.timeViolate.isNullOrEmpty()) {
              _controller.model.trackingStatus = null;
            } else {
              _controller.model.trackingStatus = ContentOptions.following.value;
            }
            _controller.refreshWidget();
          },
          invalid: _controller.invalid.value,
          isRequired: true,
          isEndTime: false,
        ),
        //Thời điểm kết thúc
        DateTimePickerCustom(
          textEditingController: _controller.timeFinishController,
          readOnly: widget.tiketType == ActionTicketType.view,
          title: 'Thời điểm kết thúc',
          isEndTime: true,
          invalid: _controller.model.timeViolate != null &&
              _controller.model.endViolate != null &&
              DateTime.parse(_controller.model.endViolate)
                  .isBefore(DateTime.parse(_controller.model.timeViolate)),
          onChange: (value) {
            _controller.timeFinishController.text = value.toString() == 'null'
                ? null
                : DateTime.parse(value.toString())
                    .toStringFormat(HighElectricStrings.ddmmyyyyHHmm);
            _controller.model.endViolate = value.toString() == 'null'
                ? null
                : DateTime.parse(value.toString()).toStringFormat(
                    HighElectricStrings.utcFormatNotZ,
                    isUtc: true,
                  );
            (_controller.model.endViolate.isNullOrEmpty())
                ? _controller.model.trackingStatus =
                    ContentOptions.following.value
                : _controller.model.trackingStatus =
                    ContentOptions.finished.value;
            _controller.refreshWidget();
          },
        ),
      ],
    );
  }

  Widget buildAbnormalDropdown() {
    return Column(
      children: [
        AbnormalDropdownWidget(
          defaultOption: _controller.model.violateId,
          options: _controller.abnormalOptions ?? [],
          invalid: _controller.invalid.value,
          onSelected: (value) {
            _controller.model.violateId = value;
          },
          disable: widget.tiketType == ActionTicketType.view,
          title: 'Tên vi phạm',
          placeholder: 'Chọn vi phạm',
          addAbnormalOption: (value) async {
            await _controller.addAbnormalOption(name: value);
          },
        ),
      ],
    );
  }

  Widget _renderContentFromAbnormal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          children: [
            WidgetItems(
              typeItem: TypeItem.singleDropdown,
              title: 'Tên đường dây',
              required: true,
              function: (value) async {
                if (value != null) {
                  _controller.id = value;
                  await _controller.getWorkByLine(lineId: value);
                } else {
                  _controller.listWorkByLine = List.empty(growable: true);
                  _controller.id = null;
                }
                _controller.invalid.refresh();
              },
              defaultSingleOptionsString: null,
              optionsString: _controller.listLine,
              invalid: false,
              isChildrenItem: false,
            ),
            WidgetItems(
              typeItem: TypeItem.singleDropdown,
              title: 'Công việc',
              required: true,
              function: (value) async {
                _controller.id = value;
                _controller.invalid.refresh();
              },
              defaultSingleOptionsString: _controller.id,
              optionsString: _controller.listWorkByLine,
              invalid: _controller.invalid.value,
              isChildrenItem: false,
            ),
            WidgetItems(
              typeItem: TypeItem.singleDropdown,
              title: 'Loại vi phạm',
              required: true,
              function: (value) async {
                if (value != null) {
                  _controller.typeViolation.value = int.parse(value.toString());
                  _controller.model.nameViolate = _controller
                      .listViolate[_controller.typeViolation.value - 1]?.title;
                  _controller.invalid.refresh();
                }
              },
              defaultOptionsNumber: _controller.typeViolation?.value,
              optionsNumber: _controller.listViolate,
              invalid: _controller.invalid.value,
              isChildrenItem: false,
              isNumber: true,
            ),
            if (_controller.id == null)
              Container()
            else if (_controller.typeViolation.value ==
                ViolateInspectionType.violateLobby)
              _buildViolateLobby(context)
            else if (_controller.typeViolation.value ==
                ViolateInspectionType.violateRoadworks)
              _buildViolateRoadworks(context)
            else if (_controller.typeViolation.value ==
                ViolateInspectionType.violateCorridorTree)
              _buildViolateCorridorTree(context)
            else
              Container()
          ],
        ),
      ),
    );
  }
}

