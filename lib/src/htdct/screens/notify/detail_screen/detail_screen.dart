// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/components/app_bar_common.dart';
import '../../../common/themes/styles.dart';
import '../../../models/notify/notify_model.dart';
import 'detail_controller.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({Key key, this.id}) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
        title: 'Chi tiết',
      ),
      body: Obx(_buildBody),
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
              const SizedBox(height: 15),
              Text(
                model.type == NotifyModel.type_inbox ? 'Ngày nhận' : 'Ngày gửi',
                style: Styles.textNormalContent,
              ),
              const SizedBox(height: 15),
              Text(
                model.getCreateDate(),
                style: Styles.textTitleContent,
              ),
              const SizedBox(height: 25),
              Text(
                model.type == NotifyModel.type_inbox ? 'Người gửi' : 'Người nhận',
                style: Styles.textNormalContent,
              ),
              if (model.type == NotifyModel.type_inbox)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    '${model.userSendName}',
                    style: Styles.textTitleContent,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    '${model.users.map((e) => e.name).join(', ')}',
                    style: Styles.textTitleContent,
                  ),
                ),
              const SizedBox(height: 25),
              const Text(
                'Nội dung',
                style: Styles.textNormalContent,
              ),
              const SizedBox(height: 15),
              Text(
                model.content,
                style: Styles.textTitleContent,
                softWrap: true,
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}

