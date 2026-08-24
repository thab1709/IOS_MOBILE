// @dart=2.9
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/models/intermediate_content.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_dot_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterOutlineMobileView extends StatelessWidget {
  InterOutlineMobileView(this.data, {this.onChange});

  final List<OutLines> data;
  final RxInt currentIndex = 0.obs;
  final Function(OutLines item) onChange;
  final titleStyle = const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Xuất tuyến', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
          ),
          const SizedBox(height: 16,),
          Container(height: 1, color: Colors.grey.shade300,),
          Expanded(
            child: PageView(
              onPageChanged: (index) {
                currentIndex.value = index;
              },
              children: data.mapIndexed(renderChild).toList(),
            ),
          ),
          Obx(() => EDotView(currentIndex: currentIndex.value, lenght: data.length,)),
          const SizedBox(height: 8,)
        ],
      ),
    );
  }

  Widget renderChild(OutLines item, int index) {
    return Column(
      children: [
        const SizedBox(height: 8,),
        ETextField(title: 'Tên xuất tuyến ${index + 1}', value: item.outLineName, titleStyle: titleStyle, onChange: (value) {
          item.outLineName = value;
          //onChange(item);
        },),
        Expanded(
          child: GridView.count(crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: Get.width/3/60,
            children: [
              ETextField(title: 'Ia', titleStyle: titleStyle,value: item.ia ?? '', onChange: (value) {
                item.ia = value;
                //onChange(item);
              },),
              ETextField(title: 'Ib', titleStyle: titleStyle, value: item.ib ?? '',onChange: (value) {
                item.ib = value;
                //onChange(item);
                },),
              ETextField(title: 'Ic', titleStyle: titleStyle, value: item.ic ?? '',onChange: (value) {
                item.ic = value;
                //onChange(item);
                },),
              ETextField(title: 'P', titleStyle: titleStyle, value: item.p ?? '',onChange: (value) {
                item.p = value;
                //onChange(item);
                },),
            ],),
        )
      ],
    );
  }
}

