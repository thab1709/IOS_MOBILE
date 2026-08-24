// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:evnmobile/src/htdct/common/utils/progress_h_u_d.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../htld/common/components/app_button.dart';
import '../../../../../common/components/app_bar_common.dart';
import '../../../../../common/constance/app_color.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/constance/work_status.dart';
import '../../../../../common/themes/styles.dart';
import '../../../../log_book/common/widget_items.dart';
import '../../../not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import 'detail_controller.dart';

class DetailViolateScreen extends StatefulWidget {
  final String id;

  const DetailViolateScreen({
    @required this.id,
    Key key,
  }) : super(key: key);

  @override
  State<DetailViolateScreen> createState() => _DetailViolateScreenState();
}

class _DetailViolateScreenState extends State<DetailViolateScreen> {
  final _controller = DetailController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      ProgressHUD.show();
      final futures = <Future>[
        _controller.getDetailViolate(widget.id),
        _controller.getDetail(widget.id, isBackground: true)
      ];
      await Future.wait(futures);
      ProgressHUD.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarCommon(
        title: 'Thông tin vi phạm',
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Expanded(
              child: Obx(_buildBody),
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
    if (_controller.model.value.id != null) {
      final modelViolate = _controller.violateModel.value;
      final modelAbnormal = _controller.model.value;
      return Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLineString(
                    title: 'Vi phạm', value: '${modelAbnormal.violate ?? ''}'),
                _buildLineString(
                    title: 'Tên vi phạm',
                    value: '${modelAbnormal.name ?? ''}'),
                _buildLineString(
                    title: 'Tình trạm vi phạm',
                    value: '${modelAbnormal.statusViolate ?? ''}'),
                _buildLineString(
                    title: 'Trạng thái',
                    value:
                        '${modelAbnormal.trackingStatus == HWorkStatus.notImplement ? 'Chưa xử lý' : 'Đã xử lý'}',
                    textColor: modelAbnormal.trackingStatus == null
                        ? Colors.red
                        : modelAbnormal.trackingStatus ==
                                HWorkStatus.implementing
                            ? HighElectricAppColor.greenColor
                            : HighElectricAppColor.redStatus),
                _buildLineString(
                    title: 'Thời gian xử lý',
                    value:
                        '${modelAbnormal.date?.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmmss) ?? ''}'),
                _buildLineString(
                    title: 'Nội dung xử lý',
                    value: '${modelAbnormal.content ?? ''}'),
                _buildLineString(
                    title: 'Người xử lý', value: '${modelAbnormal.user ?? ''}'),
                Obx(() {
                  if (_controller.isShowFull.value) {
                    return const SizedBox();
                  } else {
                    return TextButton(
                        onPressed: () {
                          _controller.isShowFull.value = true;
                        },
                        child: const Text('Xem thêm >>'));
                  }
                }),
                Obx(() {
                  if (_controller.isShowFull.value) {
                    return Column(
                      children: [
                        _buildLineString(
                            title: 'Mã điểm vi phạm',
                            value: '${modelViolate.codePointViolate ?? ''}'),
                        _buildLineString(
                            title: 'Đối tượng vi phạm',
                            value: '${modelViolate.name ?? ''}'),
                        _buildLineString(
                            title: 'Địa chỉ',
                            value: '${modelViolate.address ?? ''}'),
                        _buildLineString(
                            title: 'Khoảng cột',
                            value: '${modelViolate.aboutColumn ?? ''}'),
                        _buildLineString(
                            title: 'Khoảng cách đứng (m)',
                            value: '${modelViolate.standingDistance ?? ''}'),
                        _buildLineString(
                            title: 'Khoảng cách ngang (m)',
                            value: '${modelViolate.horizontalDistance ?? ''}'),
                        _buildLineString(
                            title: 'Thời điểm vi phạm',
                            value:
                                '${modelViolate.timeViolate?.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmm) ?? ''}'),
                        _buildLineString(
                            title: 'Tính chất công trình',
                            value:
                                '${modelViolate.constructionProperties ?? ''}'),
                        _buildLineString(
                            title: 'Giải pháp thực hiện',
                            value: '${modelViolate.solution ?? ''}'),
                        _buildImage(),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                })
              ]),
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

  Widget _buildImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Expanded(
          child: Text(
            'Hình ảnh',
            style: Styles.textTitleContent,
            textAlign: TextAlign.left,
            softWrap: true,
          ),
        ),
        WidgetItems(
          typeItem: TypeItem.images,
          title: '',
          required: false,
          function: (value) {},
          imagesValue: _controller.model.value.images,
          //_controller.model.images,
          removeImage: (file) async {},
          addImage: (file) async {},
          invalid: false,
          readOnly: true,
        ),
      ],
    );
  }
}

