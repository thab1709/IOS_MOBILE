// @dart=2.9
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/models/intermediate_content.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_dot_view.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InterTransformerMobileView extends StatelessWidget {
  InterTransformerMobileView(this.data, {this.onChange});

  final List<InterEquipments> data;
  final RxInt currentIndex = 0.obs;
  final Function(InterEquipments) onChange;
  final titleStyle = const TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 440,
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
            child: Text('Máy biến áp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
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

  Widget renderChild(InterEquipments item, int index) {
    return Column(
     children: [
       const SizedBox(height: 8,),
       ETextField(title: 'Tên máy biến áp ${index + 1}', value: item.equipmentName, titleStyle: titleStyle, onChange: (value) {
        item.equipmentName = value;
       },),
       Expanded(
         child: GridView.count(crossAxisCount: 2,
           shrinkWrap: true,
           physics: const NeverScrollableScrollPhysics(),
           childAspectRatio: Get.width/3/60,
           children: [
           ETextField(title: 'Uc', titleStyle: titleStyle,value: item.uc ?? '', onChange: (value) {
             item.uc = value;
             //onChange(item);
           },),
           ETextField(title: 'Uh', titleStyle: titleStyle, value: item.uh ?? '',onChange: (value) {
             item.uh = value;
             //onChange(item);
           },),
           ETextField(title: 'Ic', titleStyle: titleStyle, value: item.ic ?? '',onChange: (value) {
             item.ic = value;
             //onChange(item);
           },),
           ETextField(title: 'Pc', titleStyle: titleStyle, value: item.pc ?? '',onChange: (value) {
             item.pc = value;
             //onChange(item);
           },),
           ETextField(title: 'Ih', titleStyle: titleStyle, value: item.ih ?? '',onChange: (value) {
             item.ih = value;
             //onChange(item);
           },),
           ETextField(title: 'Ph', titleStyle: titleStyle, value: item.ph ?? '',onChange: (value) {
             item.ph = value;
             //onChange(item);
           },),

         ],),
       )
     ],
    );
  }
}

