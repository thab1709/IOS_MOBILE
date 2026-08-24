// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common/constance/app_color.dart';
import '../../../common/constance/app_icon.dart';
import '../../../models/day_night/tba_content_check.dart';

class EquipmentButton extends StatelessWidget {
  const EquipmentButton(
      {@required this.popup,
      @required this.onTap,
      Key key})
      : super(key: key);

  final Popups popup;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 8, top: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: popup.total == popup.count
                  ? HighElectricAppColor.greenColor
                  : popup.count > 0
                      ? HighElectricAppColor.orange2
                      : HighElectricAppColor.nature01,
              border: Border.all(color: HighElectricAppColor.nature03)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      popup.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: popup.count == 0
                              ? HighElectricAppColor.nature06
                              : HighElectricAppColor.nature01,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Visibility(
                    visible: popup.count == popup.total,
                    child: SvgPicture.asset(HighElectricAppIcon.check),
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: Text(
                  '(Đã KTra ${popup.count}/${popup.total} thiết bị)',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: popup.count == 0
                          ? HighElectricAppColor.nature06
                          : HighElectricAppColor.nature01,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          )),
    );
  }
}

