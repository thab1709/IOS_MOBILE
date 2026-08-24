// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../htld/common/components/app_button.dart';
import '../../../../../common/components/app_bar_common.dart';
import '../../../../../common/constance/app_color.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/themes/styles.dart';
import 'history_controller.dart';

class HistoryScreen extends StatefulWidget {
  final String id;

  const HistoryScreen({Key key, this.id}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _controller = HistoryController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.getDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(
        title: 'Lịch sử cập nhật tồn tại',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: _buildBody(),
            ),
            Container(
              width: double.infinity,
              child: EButton(
                  title: 'Đóng',
                  action: () {
                    Get.back();
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _buildSearch(),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: HighElectricAppColor.nature03,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 40,
                  child: const Text(
                    'Ngày cập nhật',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HighElectricAppColor.nature06,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  color: HighElectricAppColor.nature03,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  height: 40,
                  child: const Text(
                    'Người cập nhật',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: HighElectricAppColor.nature06,
                    ),
                  ),
                ),
              ),
              Container(
                width: 90,
                color: HighElectricAppColor.nature03,
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: 40,
                child: const Text(
                  'Trạng thái',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: HighElectricAppColor.nature06,
                  ),
                ),
              ),
            ],
          ),
          Obx(_renderLineItem),
        ],
      ),
    );
  }

  Widget _renderLineItem() {
    if (_controller.listAbnormal != null &&
        _controller.listAbnormal.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: _controller.listAbnormal.length,
          itemBuilder: (context, index) {
            return Container(
              color: index % 2 == 0
                  ? HighElectricAppColor.nature02
                  : HighElectricAppColor.nature01,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets.only(top: 20, bottom: 20, left: 8),
                      child: Text(
                        _controller.listAbnormal[index].updatedDate
                                ?.fromFormatUtcToFormatLocal(
                                    HighElectricStrings.ddmmyyyyHHmmss) ??
                            '',
                        textAlign: TextAlign.start,
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 5),
                      child: Text(
                        _controller.listAbnormal[index].updatedUser ?? '',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: HighElectricAppColor.nature06,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Text(
                      _controller.listAbnormal[index].status ?? '',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: HighElectricAppColor.nature06,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildLineString({String title, String value, Color textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: Styles.textTitleContent,
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: textColor == null
                  ? Styles.textNormalContent
                  : Styles.textNormalContent.copyWith(color: textColor),
              textAlign: TextAlign.right,
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: HighElectricAppColor.nature01,
      child: Row(children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 1, color: Colors.grey.shade300)),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(color: Colors.black87),
                    cursorHeight: 0,
                    cursorWidth: 0,
                    focusNode: _focusNode,
                    controller: _controller.searchController,
                    onChanged: (value) {
                      _controller.searchTerm = value;
                    },
                    onEditingComplete: () async {
                      _focusNode.unfocus();
                      _controller.find();
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
                      hintText: 'Người cập nhật',
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    _controller.searchController.text = '';
                    _controller.searchTerm = '';
                    _controller.find();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      Icons.close,
                      color: HighElectricAppColor.nature04,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}

