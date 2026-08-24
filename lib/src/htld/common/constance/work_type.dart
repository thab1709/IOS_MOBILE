// @dart=2.9
import 'package:evnmobile/src/htld/models/option_model.dart';

class TWorkType {
  static const int disDay = 1;
  static const int disNight = 2;
  static const int lineDay = 3;
  static const int lineNight = 4;
  static const int interDay = 5;
  static const int interNight = 6;

  static List<OptionModelString> listWorkType() {
    return [
      OptionModelString('TBA PP ngày', disDay.toString()),
      OptionModelString('TBA PP đêm', disNight.toString()),
      OptionModelString('DZ ngày', lineDay.toString()),
      OptionModelString('DZ đêm', lineNight.toString()),
      OptionModelString('TBA trung gian ngày', interDay.toString()),
      OptionModelString('TBA trung gian đêm', interNight.toString()),
    ];
  }
}
