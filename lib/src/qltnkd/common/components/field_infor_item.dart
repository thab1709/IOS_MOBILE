// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/constance/common.dart';
import 'package:flutter/material.dart';

class FieldInfoItem extends StatelessWidget {
  const FieldInfoItem(
      {Key key,
      this.titleFirst,
      this.titleSecond,
      this.valueFirst,
      this.valueSecond,
      this.valueSecondWidget,
      this.padding})
      : super(key: key);

  final String titleFirst;
  final String titleSecond;
  final String valueFirst;
  final String valueSecond;
  final Widget valueSecondWidget;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildContent(titleFirst ?? '', valueFirst ?? ''),
          if(titleSecond != null)
            const SizedBox(width: PaddingSize.small),
          if(titleSecond != null && valueSecondWidget != null)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$titleSecond', style: const TextStyle(color: Colors.grey, fontSize: 15)),
                  const SizedBox(height: PaddingSize.micro),
                  valueSecondWidget,
                ],
              ),
            )
          else if(titleSecond != null)
            _buildContent(titleSecond ?? '', valueSecond ?? '')
        ],
      ),
    );
  }

  Widget _buildContent(String title, String content) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$title', style: const TextStyle(color: Colors.grey, fontSize: 15)),
          const SizedBox(height: PaddingSize.micro),
          Text(
            '$content',
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          )
        ],
      ),
    );
  }
}

