// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';

import '../../../../../common/components/r_date_time.dart';
import '../../../../../common/components/r_text_field.dart';
import '../../../../../common/components/r_title.dart';
import '../../../../../common/constance/common.dart';
import '../../../../../common/constance/strings.dart';
import '../detail_workload_controller.dart';

class GeneralWorkload extends StatefulWidget {
  const GeneralWorkload({Key key}) : super(key: key);

  @override
  State<GeneralWorkload> createState() => _GeneralWorkloadState();
}

class _GeneralWorkloadState extends State<GeneralWorkload> {
  final DetailWorkloadController _controller = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ColoredBox(
      color: Colors.white,
      child: Column(
        children: [_buildInput()],
      ),
    ));
  }

  Widget _buildInput() {
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(PaddingSize.normal),
        child: Obx(() {
          if (_controller.isLoaded.value) {}
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfo(),
              _buildManageUnit(),
              _buildImplementingAgencies(),
              _buildConsultingUnit(),
              RTextField(
                title: 'Ghi chú',
                isRequire: false,
                line: 3,
                isEnable: _controller.isEdit,
                margin: const EdgeInsets.only(top: PaddingSize.normal),
                value: _controller.workloadRequestModel?.note,
                onChange: (value) {
                  _controller.workloadRequestModel.note = value;
                },
              ),
            ],
          );
        }),
      ),
    ));
  }

  Widget _buildInfo() {
    return Column(
      children: [
        RTextField(
          title: 'Loại phiếu yêu cầu',
          isRequire: true,
          isEnable: false,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller?.requestModel?.typeName ??
              _controller?.detailWorkloadModel?.requestTypeName,
        ),
        RTextField(
          title: 'Đơn vị yêu cầu',
          isRequire: true,
          isEnable: false,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller?.requestModel?.unitName ??
              _controller?.detailWorkloadModel?.unitName,
        ),
        RDateTime(
          title: 'Ngày thực hiện',
          isRequire: true,
          isEnable: _controller.isEdit,
          textController: _controller.timeController,
          onTap: () {
            showDatePicker(context);
          },
          onClear: () {
            _controller.workloadRequestModel.date = '';
            _controller.timeController.text = '';
          },
          isShowClear: true,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
        ),
        RTextField(
          title: 'Địa điểm',
          isRequire: false,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller?.workloadRequestModel?.location,
          onChange: (value) {
            _controller.workloadRequestModel.location = value;
          },
        ),
      ],
    );
  }

  Widget _buildManageUnit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RTitle(
          title: '1. Bên đơn vị quản lý',
        ),
        RTextField(
          title: 'Ông (Bà)',
          isRequire: true,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller?.workloadRequestModel?.username,
          onChange: (value) {
            _controller.workloadRequestModel.username = value;
          },
        ),
        RTextField(
          title: 'Chức vụ',
          isRequire: true,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller?.workloadRequestModel?.userPosition,
          onChange: (value) {
            _controller.workloadRequestModel.userPosition = value;
          },
        ),
        RTextField(
          title: 'Đại diện',
          isRequire: true,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.userRepresent,
          onChange: (value) {
            _controller.workloadRequestModel.userRepresent = value;
          },
        )
      ],
    );
  }

  Widget _buildImplementingAgencies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RTitle(
          title: '2. Bên thực hiện',
        ),
        RTextField(
          title: 'Ông (Bà)',
          isRequire: true,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.performer,
          onChange: (value) {
            _controller.workloadRequestModel.performer = value;
          },
        ),
        RTextField(
          title: 'Chức vụ',
          isRequire: true,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.performerPosition,
          onChange: (value) {
            _controller.workloadRequestModel.performerPosition = value;
          },
        ),
        RTextField(
          title: 'Đại diện',
          isRequire: true,
          isEnable: false,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.performerRepresent,
          onChange: (value) {
            _controller.workloadRequestModel.performerRepresent = value;
          },
        ),
      ],
    );
  }

  Widget _buildConsultingUnit() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const RTitle(
          title: '3. Bên tư vấn',
        ),
        RTextField(
          title: 'Ông (Bà)',
          isRequire: false,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.consultants,
          onChange: (value) {
            _controller.workloadRequestModel.consultants = value;
          },
        ),
        RTextField(
          title: 'Chức vụ',
          isRequire: false,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.consultantsPosition,
          onChange: (value) {
            _controller.workloadRequestModel.consultantsPosition = value;
          },
        ),
        RTextField(
          title: 'Đại diện',
          isRequire: false,
          isEnable: _controller.isEdit,
          margin: const EdgeInsets.only(top: PaddingSize.normal),
          value: _controller.workloadRequestModel?.consultantsRepresent,
          onChange: (value) {
            _controller.workloadRequestModel.consultantsRepresent = value;
          },
        ),
      ],
    );
  }

  Future showDatePicker(BuildContext context) async  {
    await DatePicker.showDatePicker(
        context,
      minTime: DateTime(DateTime.now().year - 3, 6),
      maxTime: DateTime(DateTime.now().year + 3, 6),
      locale: LocaleType.vi,
      currentTime: _controller.workloadRequestModel.date
          .toDateFormatLocal(format: RAppStrings.utcFormatNotZ) ??
          DateTime.now(),
      onConfirm: (date) {
        _controller.workloadRequestModel.date =
            date.toStringFormat(RAppStrings.utcFormatNotZ, isUtc: true);
        _controller.timeController.text = _controller.workloadRequestModel.date
            .fromFormatUtcToFormatLocal(RAppStrings.ddMMyyyy);
      }
    );
  }
}

