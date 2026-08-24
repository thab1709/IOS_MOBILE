// @dart=2.9
import 'package:evnmobile/src/qltnkd/common/themes/colorx.dart';
import 'package:flutter/material.dart';

class RDateTime extends StatefulWidget {
  const RDateTime({
    @required this.title,
    @required this.textController,
    Key key,
    this.onTap,
    this.margin,
    this.onClear,
    this.isEnable = true,
    this.isRequire = false,
    this.isShowClear = false,
  }) : super(key: key);
  final String title;
  final Function onTap;
  final Function onClear;
  final TextEditingController textController;
  final EdgeInsets margin;
  final bool isEnable;
  final bool isRequire;
  final bool isShowClear;

  @override
  State<RDateTime> createState() => _RDateTimeState();
}

class _RDateTimeState extends State<RDateTime> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(widget.isEnable == true) {
          widget.onTap();
        }
      },
      child: Container(
        margin: widget.margin ?? const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _renderTitle(widget.title),
            Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color:
                        widget.isEnable ? Colors.white : Colors.grey.shade100,
                    border:
                        Border.all(width: 1, color: Colors.grey.shade300)),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: RAppColor.highlightColor70,
                      size: 20,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.textController,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          enabled: false,
                          border: InputBorder.none,
                          hintText: 'Chọn khoảng thời gian',
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    if (widget.isShowClear &&
                        widget.textController.text.isNotEmpty == true && widget.isEnable == true)
                      IconButton(
                          onPressed: () {
                            if(widget.onClear != null) widget.onClear();
                            setState(() {
                              widget.textController.text = '';
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ))
                    else
                      const SizedBox()
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _renderTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: Row(children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16),
        ),
        if (widget.isRequire)
          const Text(
            '*',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
      ],),
    );
  }
}

