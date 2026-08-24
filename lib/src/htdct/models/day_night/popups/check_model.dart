// @dart=2.9
class CheckModel {
  String value;
  String title;
  bool isNumber;
  bool isRequired;
  bool readOnly;
  Function(String) onChange;

// CheckModel({this.value, this.title, this.isNumber, this.isRequired, this.onChange});
  CheckModel({
    String value,
    String title,
    bool isNumber,
    bool isRequired,
    bool readOnly,
    Function(String) onChange,
})
  {
    if(value=="null" || value==null)
      this.value="";
    else
      this.value = value;
    this.title=title;
    this.value=value;
    this.isNumber=isNumber;
    this.isRequired=isRequired;
    this.onChange = onChange;
    this.readOnly = readOnly;
  }

}
