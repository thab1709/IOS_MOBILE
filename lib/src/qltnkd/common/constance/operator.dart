// @dart=2.9
import 'dart:math' as math;

import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';

class OperatorType {
  static const division = 1; //A/B
  static const average = 2; //Average(A, B, C)
  static const maxMinAve100 = 3; //((Max(A,B,C) – Min(A,B,C))/Average(A+B+C)*100
  static const maxSubDiv = 4; //((Max(B,C,D)-A)/A * 100||((Min(B,C,D)-A)/A * 100
  static const maxMinAve200 =
      5; //((Max// (A,B,C) – Min(A,B,C))/Average(A+B+C)*200
  static const aSubBDivBMulti100 = 6; //((A-B)/B)*100
    static const deviation =
      7; //% (Điện dung đo đạc - Điện dung định mức) /  Điện dung định mức) * 100
  static const maxSubMin = 8; //Max(A,B,C) - Min(A,B,C)
  static const aDivBMulti100 = 9; //(A/B)*100

}

String operatorCalculator(int operatorType,
    {String a, String b, String c, String d}) {
  switch (operatorType) {
    case OperatorType.division:
      return division(a, b);
      break;
    case OperatorType.deviation:
      return deviation(a, b);
      break;
    case OperatorType.average:
      return average(a, b, c);
      break;
    case OperatorType.maxMinAve100:
      return maxMinAve100(a, b, c);
      break;
    case OperatorType.maxSubDiv:
      return maxSubDiv(a, b, c, d);
      break;
    case OperatorType.maxMinAve200:
      return maxMinAve200(a, b, c);
      break;
        case OperatorType.aSubBDivBMulti100:
      return aSubBDivBMulti100(a, b);
      break;
    case OperatorType.maxSubMin:
      return maxSubMin(a, b, c);
      break;
    case OperatorType.aDivBMulti100:
      return aDivBMulti100(a, b);
      break;
    default:
      return '';
  }
}

String division(String a, String b) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  if (numA == null || numB == null) {
    return '';
  }
  if (numA >= 0 && numB >= 0 && numB != 0) {
    final result = numA / numB;
    return formatData(result);
  } else {
    return '0';
  }
}

String deviation(String a, String b) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  if (numA == null || numB == null) {
    return '';
  }
  if (numA >= 0 && numB >= 0 && numB != 0) {
    final result = ((numA - numB) / numB) * 100;
    return formatData(result);
  } else {
    return '0';
  }
}

String average(String a, String b, String c) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  final numC = c.toDoubleOrNull();

  if (numA == null || numB == null || numC == null) {
    return '';
  }

  if (numA >= 0 && numB >= 0 && numC >= 0) {
    final result = (numA + numB + numC) / 3;
    return formatData(result);
  } else {
    return '0';
  }
}

String maxMinAve100(String a, String b, String c) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  final numC = c.toDoubleOrNull();

  if (numA == null || numB == null || numC == null) {
    return '';
  }

  if (numA >= 0 && numB >= 0 && numC >= 0 && (numA + numB + numC) != 0) {
    final result = (math.max<double>(math.max<double>(numA, numB), numC) -
            (math.min<double>(math.min<double>(numA, numB), numC))) /
        ((numA + numB + numC) / 3) *
        100;
    return formatData(result);
  } else {
    return '0';
  }
}

String maxSubDiv(String a, String b, String c, String d) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  final numC = c.toDoubleOrNull();
  final numD = d.toDoubleOrNull();

  if (numA == null || numB == null || numC == null || numD == null) {
    return '';
  }

  if (numA >= 0 && numB >= 0 && numC >= 0 && numA != 0) {
    final max =
        ((math.max<double>(math.max<double>(numB, numC), numD) - numA) / numA) *
            100;

    final min =
        ((math.min<double>(math.min<double>(numB, numC), numD) - numA) / numA) *
            100;

    if(max.abs() > min.abs()) {
      return formatData(max);
    }

    return formatData(min);
  } else {
    return '0';
  }
}

String maxMinAve200(String a, String b, String c) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  final numC = c.toDoubleOrNull();

  if (numA == null || numB == null || numC == null) {
    return '';
  }

  if (numA >= 0 && numB >= 0 && numC >= 0) {
    final result = (math.max<double>(math.max<double>(numA, numB), numC) -
            (math.min<double>(math.min<double>(numA, numB), numC))) /
        ((numA + numB + numC) / 3) *
        200;
    return formatData(result);
  } else {
    return '0';
  }
}

String formatData(double value) {
  final def = value % 1;
  if (def.toString().length >= 5) {
    return value.toStringAsFixed(3);
  } else if (def == 0) {
    return value.toInt().toString();
  } else {
    return value.toString();
  }
}

String aSubBDivBMulti100(String a, String b) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();

  if (numA == null || numB == null) {
    return '';
  }

  if (numA >= 0 && numB >= 0) {
    final result = ((numA - numB) / numB) * 100;
    return formatData(result);
  } else {
    return '0';
  }
}


String maxSubMin(String a, String b, String c) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  final numC = c.toDoubleOrNull();

  if (numA == null || numB == null || numC == null) {
    return '';
  }

  if (numA >= 0 && numB >= 0 && numC >= 0) {
    final result = math.max<double>(math.max<double>(numA, numB), numC) -
            math.min<double>(math.min<double>(numA, numB), numC);
    return formatData(result);
  } else {
    return '0';
  }
}

String aDivBMulti100(String a, String b) {
  final numA = a.toDoubleOrNull();
  final numB = b.toDoubleOrNull();
  if (numA == null || numB == null) {
    return '';
  }
  if (numA >= 0 && numB >= 0 && numB != 0) {
    final result = (numA / numB) * 100;
    return formatData(result);
  } else {
    return '0';
  }
}
