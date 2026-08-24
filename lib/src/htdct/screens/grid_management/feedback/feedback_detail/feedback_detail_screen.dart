// @dart=2.9
import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import 'package:flutter/material.dart';

import '../../../../common/components/app_bar_common.dart';
import '../../../../common/constance/strings.dart';
import '../../../../common/themes/styles.dart';
import 'feedback_detail_controller.dart';
import 'package:get/get.dart';

class FeedbackDetailScreen extends StatefulWidget {
  final String id;
  const FeedbackDetailScreen({@required this.id});

  @override
  State<FeedbackDetailScreen> createState() => _FeedbackDetailScreenState();
}

class _FeedbackDetailScreenState extends State<FeedbackDetailScreen> {
  final _controller = FeedbackDetailController();

  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(const Duration(milliseconds: 200),
        () => {_controller.getDetail(widget.id)});
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
    if(_controller.model.value.id!=null) {
      return
    Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              _controller.model.value.sender!=null?'Ngày nhận':'Ngày gửi',
              style: Styles.textNormalContent,
            ),
            const SizedBox(height: 15),
            Text(
              _controller.model.value.date.fromFormatUtcToFormatLocal(HighElectricStrings.ddmmyyyyHHmmss),
              // _controller.model.value.date.fromFormatToFormat( HighElectricStrings.yyyyMMddTHHmmss,HighElectricStrings.ddmmyyyyHHmmss),
              style: Styles.textTitleContent,
            ),
            const SizedBox(height: 25),
            Text(
              _controller.model.value.sender!=null?'Người gửi':'Người nhận',
              style: Styles.textNormalContent,
            ),
            if(_controller.model.value.sender==null)
             for(int i=0;i<(_controller.model.value.recipients?.length ?? 0);i++)
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  '${_controller.model.value.recipients[i].name} - ${_controller.model.value.recipients[i].position}',
                  style: Styles.textTitleContent,
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  '${_controller.model.value.sender.name} - ${_controller.model.value.sender.position}',
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
                _controller.model.value.description,
                style: Styles.textTitleContent,
                softWrap: true,
              ),

          ],
        ),
      ),
    );
    }
    return Container();
  }
}

