// @dart=2.9
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:evnmobile/src/htdct/common/extension/extension.dart';
import '../../../../../../../app_common/utils/utils.dart';
import '../../../../../../../qltnkd/common/utils/alert_dialog_utils.dart';
import '../../../../../../../qltnkd/services/responsitory/images_repository.dart';
import '../../../../../../common/constance/strings.dart';
import '../../../../../../common/constance/work_status.dart';
import '../../../../../../common/utils/alert_dialog_utils.dart';
import '../../../../../../common/utils/common.dart';
import '../../../../../../common/utils/snack_bar_h_u_d.dart';
import '../../../../../../models/day_night/popups/images_model.dart';
import '../../../../../../models/day_night/ticket.dart';
import '../../../../../../models/non_pmis/template_item_model.dart';
import '../../../../../../models/option_model.dart';
import '../../../../../../services/responsitory/non_pmis_repository.dart';
import '../../../../../../services/responsitory/tba_repository.dart';
import '../../../../transformer/transformer_ticket_controller.dart';

class TypeItem {
  static const textBox = 1;
  static const singleDropdown = 2;
  static const multiDropdown = 3;
  static const textArea = 4;
  static const checkbox = 5;
  static const timePicker = 6;
  static const images = 7;
  static const datePicker = 8;
  static const periodTime = 9;

  // static const numberSingleDropdown = 10;
  static const title = 11;
  static const dateTimePicker = 12;
}

class ContentCheckController extends GetxController {
  var itemList =
      List<TemplateItemModel>.empty(); //RxList<TemplateItemModel>.empty();
  final _nonPmisRep = NonPmisRepository();
  final TransformerTicketController transformerTicketController = Get.find();
  final invalid = false.obs;
  final imageService = ImageRepository();
  final _tbaRep = TBARepository();
  List<OptionModelString> listStatus = [
    OptionModelString('Chưa thực hiện', HWorkStatus.notImplement.toString()),
    OptionModelString('Đang thực hiện', HWorkStatus.implementing.toString()),
    OptionModelString('Hoàn Thành', HWorkStatus.completed.toString()),
  ];

  Future getTemplateItem() async {
    final res = await _nonPmisRep.getContent(
        idTicket: transformerTicketController.ticketId,
        testType: transformerTicketController.testType);
    if (res.isLoadSuccess) {
      itemList = res.data.list;

      for (var i = 0; i < itemList.length; i++) {
        if (itemList[i].itemType == TypeItem.singleDropdown ||
            itemList[i].itemType == TypeItem.multiDropdown) {
          // await getOptions(model: itemList[i]);
          await getMoreOptions(model: itemList[i]);
        }
      }

      if (itemList.isNotEmpty && !checkValid()) {
        transformerTicketController.triggerCompleteTicket = false;
      }

      invalid.refresh();
    } else {
      await hShowDialogOneButton(res.message);
    }
  }

  Future getOptions({@required TemplateItemModel model}) async {
    if (model.value != null && isCustomDropdown(model: model)) {
      model.options =
          model.value.split(';').map((e) => OptionModelString(e, e)).toList();
      model.options.removeWhere((element) => element.title.isEmpty);
    } else {
      final res = await _nonPmisRep.getOptions(params: {'source': model.value});
      if (res.isLoadSuccess) {
        model.options = res.data.list;
        invalid.refresh();
      } else {
        await hShowDialogOneButton(res.message);
      }
    }
  }

  Future getMoreOptions(
      {@required TemplateItemModel model, bool init = true}) async {
    if (model.value != null && isCustomDropdown(model: model)) {
      model.options =
          model.value.split(';').map((e) => OptionModelString(e, e)).toList();
      model.options.removeWhere((element) => element.title.isEmpty||!element.title.contains(model.searchTerm));
    } else {
      final res = await _nonPmisRep.getMoreOptions(
          source: model.value,
          pageIndex: model.pageIndex,
          searchTerm: model.searchTerm,
          Ids:model.inputDropdownValue ?? model.inputDropdownSelectmanyValue,
          InspectId: transformerTicketController.ticketId,
      );
      if (res.isLoadSuccess) {
        model.paging = res.data.paging;
        model.options = res.data.list;
        invalid.refresh();
      } else {
        await hShowDialogOneButton(res.message);
      }
    }
  }

  List<OptionModelString> getOptionInitValue(
      {@required TemplateItemModel model}) {
    final listOptions = List<OptionModelString>.empty(growable: true);
    if (model.options != null && model.options.isNotEmpty) {
      final modelOptionMulti = isCustomDropdown(model: model)
          ? model.inputCustomDropdownValue == null
              ? []
              : model.inputCustomDropdownValue.split(';')
          :
      model.inputDropdownValue != null?model.inputDropdownValue.split(';') :

      model.inputDropdownSelectmanyValue == null
              ? []
              : model.inputDropdownSelectmanyValue.split(';')



      ;
      modelOptionMulti.removeWhere((element) => element.isEmpty);

      for (var i = 0; i < modelOptionMulti.length; i++) {
        for (var j = 0; j < model.options.length; j++) {
          if (model.options[j].value == modelOptionMulti[i]) {
            listOptions.add(model.options[j]);
            break;
          }
        }
      }
    }
    listOptions.forEach((element) {element.title+=';';});
    return listOptions;
  }

  bool checkValid() {
    var valid = true;
    for (var i = 0; i < itemList.length; i++) {
      final model = itemList[i];
      if (model.required) {
        switch (model.itemType) {
          case TypeItem.textBox:
            if (model.inputTextValue.isNullOrBlank()) {
              valid = false;
            }
            break;
          case TypeItem.singleDropdown:
            if (model.inputCustomDropdownValue.isNullOrBlank() &&
                model.inputDropdownValue.isNullOrBlank()) {
              valid = false;
            }
            break;
          case TypeItem.multiDropdown:
            if (model.inputCustomDropdownValue.isNullOrBlank() &&
                model.inputDropdownSelectmanyValue.isNullOrBlank()) {
              valid = false;
            }
            break;
          case TypeItem.textArea:
            if (model.inputTextValue.isNullOrBlank()) {
              valid = false;
            }
            break;
          case TypeItem.timePicker:
            if (model.inputTimeValue.isNullOrBlank()) {
              valid = false;
            }
            break;
          case TypeItem.datePicker:
            if (model.inputDateValue.isNullOrBlank()) {
              valid = false;
            }
            break;
          case TypeItem.images:
            if (model.inputImagesValue.isEmpty) {
              valid = false;
            }
            break;
          case TypeItem.checkbox:
            if (model.inputCheckboxValue == null ||
                model.inputCheckboxValue == false) {
              valid = false;
            }
            break;
        }
      }
    }
    ;

    invalid.value = !valid;
    return valid;
  }

  Future<void> updateData() async {
    if (!checkValid()) {
      await rShowDialogOneButton(HighElectricStrings.requireUpdatePopupText);
    } else {
      final location = await getCurrentPosition();
      if(location == null) {
        await hShowDialogOneButton('Lỗi lấy bị trí thiết bị');
        return;
      }

      if(location?.isMocked == true)
      {
        await hShowDialogOneButton('${HighElectricStrings.isMockedLocation}');
        return;
      }
      final address = await getNameByLocation(location.latitude, location.longitude);

      final response = await _nonPmisRep.updateContent(
          params: {
            "id": transformerTicketController.ticketId,
            'fieldDetailModels': itemList,
            'address': address
          },
          idTicket: transformerTicketController.ticketId,
          testType: transformerTicketController.testType);
      if (response.isLoadSuccess) {
        // model = response.data.model;
        await rShowDialogOneButton(
            HighElectricStrings.updatePopupSuccessCommon);
        invalid.value = false;
        transformerTicketController.triggerCompleteTicket = true;
        invalid.refresh();
      } else {
        await rShowDialogOneButton(response.message);
        invalid.refresh();
      }
    }
    invalid.refresh();
  }

  bool isCustomDropdown({@required TemplateItemModel model}) {
    return model.source == '1';
  }

  Future addImage({
    @required TemplateItemModel model,
    @required List<File> images,
  }) async {
    await uploadImage(images, model);
    invalid.refresh();
  }

  Future removeImage(Images image, TemplateItemModel model) async {
    model.inputImagesValue.remove(image);
    invalid.refresh();
  }

  Future uploadImage(List<File> files, TemplateItemModel model) async {
    final response = await imageService.upload(files);

    if (response.isLoadSuccess) {
      for (var i = 0; i < response.data.length; i++) {
        model.inputImagesValue.add(Images(
            problems: 1,
            name: response.data[i].name,
            imageStorageId: response.data[i].imageStorageId,
            url: response.data[i].url));
      }
    } else {
      await hShowDialogOneButton(response.message);
    }
  }

  Future<bool> completeTicket() async {
    // final result = await transformerTicketController.sendLocation();
    // if(!result) return false;
    final res = await _tbaRep.completeTicket(
      ticketId: transformerTicketController.ticketId,
      testType: transformerTicketController.testType,
    );

    if (res.isLoadSuccess) {
      Get.back();
      SnackBarHUD.show('Hoàn thành công việc kiểm tra thành công');
      return true;
    } else {
      await hShowDialogOneButton(res.message);
      return false;
    }
  }
}

