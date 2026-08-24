// @dart=2.9
import 'package:evnmobile/src/htdct/screens/grid_management/feedback/send_feedback/send_feedback_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_bar_common.dart';
import '../../../../common/components/app_button.dart';
import '../../../../common/constance/app_color.dart';
import '../../../../common/constance/strings.dart';
import '../../../../models/work_model.dart';
import '../../containers/auto_height_text_field.dart';
import '../../containers/e_check_box.dart';

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen(
      {@required this.workType,
      @required this.isFromPmis,
      @required this.ticketId,
      @required this.isHasCreateInspectTicket});

  final String workType;
  final String ticketId;
  final bool isFromPmis;
  final bool isHasCreateInspectTicket;

  @override
  State<SendFeedbackScreen> createState() => _SendFeedbackScreenState();
}

class _SendFeedbackScreenState extends State<SendFeedbackScreen> {
  final SendFeeBackController _controller = SendFeeBackController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.workType = widget.workType;

    Future.delayed(
        const Duration(milliseconds: 100), () => {_controller.getWorkList()});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const AppBarCommon(
          title: 'Gửi phản hồi',
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildContent(),
        _buildSearch(),
        _buildHeader(),
        Expanded(
          child: Container(
              color: HighElectricAppColor.nature02,
              child: _buildListCheckPlan()),
          // _buildContent(),
        ),
        Container(
          color: HighElectricAppColor.nature01,
          padding: const EdgeInsets.all(16),
          child: EButton(
            maxSize: true,
            title: 'Gửi',
            action: () {
              _controller.sendFeedback(
                  isFromPmis: widget.isFromPmis,
                  ticketId: widget.ticketId,
                  isHasCreateInspectTicket: widget.isHasCreateInspectTicket);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      color: HighElectricAppColor.nature02,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ECheckBox(
              isSubstation: false,
              onClicked: (value) {
                _controller.checkAllWork(value: value);
              },
              checked: _controller.isCheckAll.value,
            ),
          ),
          if (_controller.workType != '0')
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 40,
                  child: const Text(
                    'Tên kế hoạch',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HighElectricAppColor.nature06,
                    ),
                  )),
            ),
          if (_controller.workType == '0')
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 40,
                  child: const Text(
                    'Tên công việc',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HighElectricAppColor.nature06,
                    ),
                  )),
            ),
          Expanded(
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 40,
                child: const Text(
                  'Ngày dự kiến',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: HighElectricAppColor.nature06,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildListCheckPlan() {
    return Obx(() {
      if (_controller?.workList?.isNotEmpty == true) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: HighElectricAppColor.nature01,
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView.separated(
                itemBuilder: (context, index) {
                  return _buildRowData(
                      index: index, model: _controller?.workList[index]);
                },
                separatorBuilder: (context, index) {
                  return const SizedBox();
                },
                itemCount: _controller?.workList?.length ?? 0),
          ),
        );
      }
      return const Center(child: Text(HighElectricStrings.emptyList));
    });
  }

  // Widget _buildListCheckPlan() {
  //   return Obx(() {
  //     if (_controller?.workList?.isNotEmpty == true) {
  //       return Container(
  //         padding: const EdgeInsets.all(12),
  //         color: HighElectricAppColor.nature01,
  //         child: Scrollbar(
  //           thumbVisibility: true,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 Container(
  //                   color: HighElectricAppColor.bgColor,
  //                   child: Table(
  //                     columnWidths: _controller.workType != '0'
  //                         ? const <int, TableColumnWidth>{
  //                             0: FixedColumnWidth(56),
  //                             1: FlexColumnWidth(),
  //                             2: FlexColumnWidth(),
  //                           }
  //                         : const <int, TableColumnWidth>{
  //                             0: FixedColumnWidth(56),
  //                             1: FlexColumnWidth(),
  //                             2: FlexColumnWidth(),
  //                           },
  //                     defaultVerticalAlignment:
  //                         TableCellVerticalAlignment.middle,
  //                     children: <TableRow>[
  //                       TableRow(
  //                         decoration: const BoxDecoration(
  //                           color: HighElectricAppColor.nature03,
  //                         ),
  //                         children: <Widget>[
  //                           Padding(
  //                             padding: const EdgeInsets.only(left: 10),
  //                             child: ECheckBox(
  //                               isSubstation: false,
  //                               onClicked: (value) {
  //                                 _controller.checkAllWork(value: value);
  //                               },
  //                               checked: _controller.isCheckAll.value,
  //                             ),
  //                           ),
  //                           if (_controller.workType != '0')
  //                             Container(
  //                                 padding:
  //                                     const EdgeInsets.symmetric(vertical: 10),
  //                                 height: 40,
  //                                 child: const Text(
  //                                   'Tên kế hoạch',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.w400,
  //                                     color: HighElectricAppColor.nature06,
  //                                   ),
  //                                 )),
  //                           if (_controller.workType == '0')
  //                             Container(
  //                                 padding:
  //                                     const EdgeInsets.symmetric(vertical: 10),
  //                                 height: 40,
  //                                 child: const Text(
  //                                   'Tên công việc',
  //                                   textAlign: TextAlign.center,
  //                                   style: TextStyle(
  //                                     fontSize: 16,
  //                                     fontWeight: FontWeight.w400,
  //                                     color: HighElectricAppColor.nature06,
  //                                   ),
  //                                 )),
  //                           Container(
  //                               padding:
  //                                   const EdgeInsets.symmetric(vertical: 10),
  //                               height: 40,
  //                               child: const Text(
  //                                 'Ngày dự kiến',
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                   fontSize: 16,
  //                                   fontWeight: FontWeight.w400,
  //                                   color: HighElectricAppColor.nature06,
  //                                 ),
  //                               )),
  //                         ],
  //                       ),
  //                       for (int i = 0; i < _controller.workList.length; i++)
  //                         _buildRowData(
  //                             index: i, model: _controller.workList[i])
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     }
  //     return const Center(child: Text(HighElectricStrings.emptyList));
  //   });
  // }

  Widget _buildRowData({int index, WorkModel model}) {
    return Container(
      decoration: BoxDecoration(
        color: index % 2 == 0
            ? HighElectricAppColor.nature01
            : HighElectricAppColor.nature02,
        border: const Border.symmetric(
          vertical: BorderSide.none,
          horizontal: BorderSide(
            color: HighElectricAppColor.bgColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: ECheckBox(
              isSubstation: false,
              onClicked: (value) {
                _controller.setChecked(model);
              },
              checked: model.isChecked,
            ),
          ),
          if (_controller.workType != '0')
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  model.entity.name ?? '',
                  textAlign: TextAlign.start,
                  // overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: HighElectricAppColor.nature06,
                  ),
                ),
              ),
            ),
          if (_controller.workType == '0')
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  model.name ?? '',
                  textAlign: TextAlign.start,
                  // overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: HighElectricAppColor.nature06,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                model.planDate,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: HighElectricAppColor.nature06,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      color: HighElectricAppColor.nature01,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nội dung',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: HighElectricAppColor.nature06,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          AutoHeightTextField(
            textFieldController: _controller.textFieldController,
            isEnable: true,
            maxHeight: 150,
            hintText: 'Nhập thông tin',
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
      color: HighElectricAppColor.nature01,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: Colors.grey.shade300),
        ),
        child: Row(children: [
          Expanded(
            child: TextFormField(
              controller: _controller.textFieldControllerSearch,
              style: const TextStyle(color: Colors.black87),
              cursorHeight: 0,
              cursorWidth: 0,
              focusNode: _focusNode,
              autofocus: false,
              onChanged: (value) {
                _controller.searchTerm = value;
                // controller.searchTerm.value = value;
              },
              onEditingComplete: () async {
                _focusNode.unfocus();
                await _controller.searchData();
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.fromLTRB(10, 12, 20, 10),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintStyle: TextStyle(
                    color: HighElectricAppColor.nature04,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                hintText: 'Nhập từ khóa tìm kiếm',
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              _controller.textFieldControllerSearch.text = '';
              _controller.searchTerm = '';
              await _controller.searchData();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(
                Icons.close,
                color: HighElectricAppColor.nature04,
              ),
            ),
          )
        ]),
      ),
    );
  }
}

