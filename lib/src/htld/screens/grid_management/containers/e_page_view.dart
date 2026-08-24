// @dart=2.9
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_dot_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_label.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'e_text_field.dart';

class EPageViewModel {
  String title;
  String id;
  String value;
  EPageViewModel(this.title, this.id, {this.value});
}

class EPageView extends StatelessWidget {
  EPageView(this.datas, { this.title, this.onChange});

  final List<List<EPageViewModel>> datas;
  final Function(String value, String key) onChange;
  final String title;
  final RxInt currentIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: _renderMBAForMobile(),
    );
  }

  Widget _renderMBAForMobile(){
    return Container(
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ELabel(title: title, padding: const EdgeInsets.only(top: 16, left: 16, right: 16),),
          if (title != null) Container(height: 1, margin: const EdgeInsets.symmetric(vertical: 10),color: Colors.grey.shade200,),
          Expanded(
            child: Obx(() {
              if (currentIndex.value == 0) {} // listening page change to rerender view
              return PageView(
                  scrollDirection: Axis.horizontal,
                  controller: PageController(initialPage: 0),
                  onPageChanged: (index) {
                    currentIndex.value = index;
                  },
                  children: datas.mapIndexed(_renderPage).toList()
              );
            })
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Obx(() => EDotView(currentIndex: currentIndex.value, lenght: datas.length,)),
          )

        ],
      ),);
  }

  Widget _renderPage(List<EPageViewModel> data, int index){
    return  GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      childAspectRatio: 2.1,
      physics: const NeverScrollableScrollPhysics(),
      children: data.map((e) {
        final title = e.title;
        final key = e.id;
        return title.isEmpty
            ? Container()
            : ETextField(
            title: title,
            spaceBetween: 4,
            contentHorizontalPadding: 4,
            textAlign: TextAlign.center,
            titleStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13, color: Colors.black54),
            value: e.value,
            onChange: (value) {
              datas[index].firstWhere((element) => element.id == e.id).value = value;
              if (onChange != null) {
                onChange(value, key);
              }
            });
      }).toList(),
    );
  }

}

