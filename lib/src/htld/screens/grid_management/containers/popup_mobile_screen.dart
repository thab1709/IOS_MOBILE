// @dart=2.9
import 'package:evnmobile/src/htld/common/components/app_button.dart';
import 'package:evnmobile/src/htld/screens/grid_management/medium_voltage_line/incident/popups/line_incident_poles_popup.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PopupMobileScreen extends StatelessWidget {
  final String name;
  final BasePopupWidget child;
  final ActionType actionType;
  const PopupMobileScreen({this.name, this.child, this.actionType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(name, style: const TextStyle(fontSize: 16),),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Column(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              )),
              if (actionType != ActionType.view) Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: EButton(title: 'Huỷ', titleColor: Colors.grey, borderColor: Colors.grey, color: Colors.white, action: () {
                        Get.back(result: false);
                      }),
                    ),
                    const SizedBox(width: 24,),
                    Expanded(
                      child: EButton(title: 'Lưu', action: () {
                        child.saveData();
                      }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

