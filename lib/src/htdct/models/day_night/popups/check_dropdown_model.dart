// @dart=2.9
import '../../option_model.dart';

class CheckDropdownModel {
  CheckDropdownModel(
      {this.value,
        this.options,
        this.title,
        this.isRequired,
        this.onChange,
        this.isEnable});

  List<OptionModel> options;
  int value;
  String title;
  bool isRequired;
  bool isEnable;
  Function(String) onChange;
}

