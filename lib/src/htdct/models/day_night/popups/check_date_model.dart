// @dart=2.9
class CheckDateModel {
  CheckDateModel(
      {this.value,
      this.title,
      this.isNumber,
      this.isRequired,
      this.onChange,
      this.readOnly});

  String value;
  String title;
  bool isNumber;
  bool isRequired;
  bool readOnly;
  Function(String) onChange;
}

