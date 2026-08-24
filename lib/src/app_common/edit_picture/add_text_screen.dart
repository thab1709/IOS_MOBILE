// @dart=2.9
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

import '../../htdct/common/utils/progress_h_u_d.dart';
import 'add_text_controller.dart';
import 'add_text_page.dart';

class EditImageScreen extends StatefulWidget {
  const EditImageScreen({this.files, Key key}) : super(key: key);

  final List<File> files;

  @override
  _AddTextScreenState createState() => _AddTextScreenState();
}

class _AddTextScreenState extends State<EditImageScreen> with SingleTickerProviderStateMixin {

  TabController _tabController;

  AddTextController addTextController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.files.length, vsync: this);
    addTextController = Get.put(AddTextController());
    addTextController.files = widget.files;
  }

  @override
  void dispose() {
    _tabController.dispose();
    addTextController.filesCopy = [];
    addTextController.files = [];
    addTextController.globalKeys.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder(
          future: addTextController.copyFile(),
          builder: (context, snapshot) {

            if(snapshot.hasData){
              return DefaultTabController(
                length: widget.files.length ?? 0, child: Scaffold(
                appBar: AppBar(
                  title: const Text('Ghi chú ảnh'),
                  centerTitle: true,
                  actions: [
                    TextButton(
                        onPressed: () async {

                          ProgressHUD.show();
                          final futures = <Future>[];
                          addTextController.globalKeys.forEach((element) {
                            if(element?.currentState?.renderImage() != null) {
                              futures.add(element.currentState.renderImage());
                            }
                          });
                          await Future.wait(futures);
                          ProgressHUD.dismiss();
                          Get.back(result: addTextController.filesCopy);

                        }, child: const Text('Xong', style: TextStyle(color: Colors.white),))
                  ],
                  bottom: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabs: widget.files.map((e) => Tab(text: p.basename(e.path),)).toList(),
                  ),
                ),
                body: SafeArea(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: buildListTab(),
                  ),
                ),
              ),);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  List<Widget> buildListTab() {
    final list = addTextController.filesCopy
        .mapIndexed<Widget>((index, file) => FlutterPainterExample(
              file,
              key: addTextController.globalKeys[index],
            ))
        .toList();
    return list;
  }
}

