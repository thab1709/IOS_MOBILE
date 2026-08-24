// @dart=2.9
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../htld/common/components/app_button.dart';
import '../../../../../common/constance/abnormal_constance.dart';
import '../../../../../common/constance/strings.dart';
import '../../../../../common/themes/styles.dart';
import '../../../containers/widget_items.dart';
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
      appBar: AppBar(
        title: const Text('Thông tin tồn tại'),
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
    if (_controller.model.value.abnormalId != null) {
      final model = _controller.model.value;
      return Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLineString(
                    title: 'Mục bất thường',
                    value: '${model.childCategory ?? ''}'),
                _buildLineString(
                    title: 'Bất thường', value: '${model.name ?? ''}'),
                if(model?.nodeNames?.isNotEmpty == true)
                _buildLineString(
                    title: 'Cột',
                    value: '${model.nodeNames ?? ''}'),
                _buildLineString(
                  title: 'Trạng thái',
                  value: AbnormalStatus.getName(model.status),
                  textColor: AbnormalStatus.getColor(model.status),
                ),
                _buildLineString(
                    title: 'Thời gian xử lý',
                    value:
                        '${model.dateHandle?.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmmss) ?? ''}'),
                _buildLineString(
                    title: 'Nội dung xử lý',
                    value: '${model.contentHandle ?? ''}'),
                _buildLineString(
                    title: 'Người xử lý',
                    value: '${model.userHandleName ?? ''}'),
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
        TWidgetItems(
          typeItem: TTypeItem.images,
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

