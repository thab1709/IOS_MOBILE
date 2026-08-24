// @dart=2.9
import 'package:evnmobile/src/qltnkd/map/model/pin_pill_info.dart';
import 'package:flutter/material.dart';

class RMapPinPillComponent extends StatefulWidget {

  final double pinPillPosition;
  final RPinInformation currentlySelectedPin;

  const RMapPinPillComponent({ this.pinPillPosition, this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => RMapPinPillComponentState();
}

class RMapPinPillComponentState extends State<RMapPinPillComponent> {

  @override
  Widget build(BuildContext context) {

    return AnimatedPositioned(
        bottom: widget.pinPillPosition,
        right: 0,
        left: 0,
        duration: const Duration(milliseconds: 200),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.all(20),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                boxShadow: <BoxShadow>[
                  BoxShadow(blurRadius: 20, offset: Offset.zero, color: Colors.grey.withOpacity(0.8))
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 40, height: 40,
                    margin: const EdgeInsets.only(left: 16),
                    child: ClipOval(child: Image.asset(widget.currentlySelectedPin.avatarPath, fit: BoxFit.cover )),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(widget.currentlySelectedPin.title ?? '', style: TextStyle(color: widget.currentlySelectedPin.labelColor, fontSize: 13,fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4,),
                          Text('${widget.currentlySelectedPin.subtitle.toString()}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1,),
                          const SizedBox(height: 4,),
                          Text('${widget.currentlySelectedPin.subtitle2.toString()}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1,),
                          const SizedBox(height: 4,),
                          if (widget.currentlySelectedPin.timeLog == null) const Text('') else Text('${widget.currentlySelectedPin.timeLog.toString()}', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1,),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(15),
                  //   child: Image.asset(widget.currentlySelectedPin.pinPath, width: 50, height: 50),
                  // )
                ],
              ),
            ),
          ),
        );
  }

}
