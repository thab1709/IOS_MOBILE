// @dart=2.9
import 'package:g_json/g_json.dart';

import '../day_night/popups/images_model.dart';
import '../option_model.dart';
import '../work_model.dart';

class TemplateItemModel {
  String id;
  int itemType;
  int displayOrder;
  String value;
  String source;
  bool required;
  String title;
  bool isDelete;
  String inputTextValue;
  String inputCustomDropdownValue;
  String inputDropdownSelectmanyValue;
  String inputDropdownValue;
  String inputTimeValue;
  String inputDateValue;
  bool inputCheckboxValue;
  List<Images> inputImagesValue;
  List<OptionModelString> options;
  int pageIndex =1;
  String searchTerm = '';
  Paging paging;

  TemplateItemModel(
      {this.id,
      this.itemType,
      this.displayOrder,
      this.value,
      this.source,
      this.required,
      this.title,
      this.isDelete,
      this.inputTextValue,
      this.inputCustomDropdownValue,
      this.inputDropdownSelectmanyValue,
      this.inputDropdownValue,
      this.inputTimeValue,
      this.inputDateValue,
      this.inputCheckboxValue,
      this.inputImagesValue,
      this.pageIndex,
      this.searchTerm});

  TemplateItemModel.fromJson(JSON json) {
    id = json['id'].string;
    itemType = json['itemType'].integer;
    displayOrder = json['displayOrder'].integer;
    value = json['value'].string;
    source = json['source'].string;
    required = json['required'].boolean;
    title = json['title'].string;
    isDelete = json['isDelete'].boolean;
    inputTextValue = json['inputTextValue'].string;
    inputCustomDropdownValue = json['inputCustomDropdownValue'].string;
    inputDropdownSelectmanyValue = json['inputDropdownSelectmanyValue'].string;
    inputDropdownValue = json['inputDropdownValue'].string;
    inputTimeValue = json['inputTimeValue'].string;
    inputDateValue = json['inputDateValue'].string;
    if (json['inputImagesValue'].isNull) {
      inputCheckboxValue = false;
    } else {
      inputCheckboxValue = json['inputCheckboxValue'].boolean;
    }
    if (!json['inputImagesValue'].isNull) {
      inputImagesValue = json['inputImagesValue']
          ?.listObject
          ?.map((e) => Images.fromJsonNotMap(JSON(e)))
          ?.toList();
    } else {
      inputImagesValue = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['itemType'] = itemType;
    data['displayOrder'] = displayOrder;
    data['value'] = value;
    data['source'] = source;
    data['required'] = required;
    data['title'] = title;
    data['isDelete'] = isDelete;
    data['inputTextValue'] = inputTextValue;
    data['inputCustomDropdownValue'] = inputCustomDropdownValue;
    data['inputDropdownSelectmanyValue'] = inputDropdownSelectmanyValue;
    data['inputDropdownValue'] = inputDropdownValue;
    data['inputTimeValue'] = inputTimeValue;
    data['inputDateValue'] = inputDateValue;
    data['inputCheckboxValue'] = inputCheckboxValue;
    if (inputImagesValue != null) {
      data['inputImagesValue'] =
          inputImagesValue.map((v) => v.toJson()).toList();
    }
    return data;
  }

}

