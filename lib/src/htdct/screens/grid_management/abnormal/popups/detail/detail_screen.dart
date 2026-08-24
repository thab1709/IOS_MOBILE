// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../htld/common/components/app_button.dart';
import '../../../../../common/components/app_bar_common.dart';
import '../../../../../common/constance/app_color.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/themes/styles.dart';
import '../../../../log_book/common/widget_items.dart';
import '../../../not_pmis/work_ticket/tab_common/content_check/content_check_controller.dart';
import 'detail_controller.dart';

class DetailAbnormalScreen extends StatefulWidget {
  final String id;

  const DetailAbnormalScreen({
    @required this.id,
    Key key,
  }) : super(key: key);

  @override
  State<DetailAbnormalScreen> createState() => _DetailAbnormalScreenState();
}

class _DetailAbnormalScreenState extends State<DetailAbnormalScreen> {
  final _controller = DetailController();

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
        title: 'Thông tin tồn tại',
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
      final model = _controller.model.value;
      return Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLineString(
                    title: 'Mục bất thường', value: '${model.category ?? ''}'),
                _buildLineString(
                    title: 'Tên bất thường', value: '${model.name ?? ''}'),
                _buildLineString(
                    title: 'Biểu hiện bất thường',
                    value: '${model.description ?? ''}'),
                _buildLineString(
                    title: 'Trạng thái',
                    value: '${model.status ?? ''}',
                    textColor: model.status == null
                        ? Colors.red
                        : model.status.contains('Đã')
                            ? HighElectricAppColor.greenColor
                            : HighElectricAppColor.redStatus),
                _buildLineString(
                    title: 'Thời gian xử lý',
                    value:
                        '${model.date?.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmmss) ?? ''}'),
                _buildLineString(
                    title: 'Nội dung xử lý', value: '${model.content ?? ''}'),
                _buildLineString(
                    title: 'Người xử lý', value: '${model.user ?? ''}'),
                _buildImage(),
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

