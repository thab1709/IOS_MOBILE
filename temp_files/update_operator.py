import re

file_path = r'lib\src\qltnkd\common\constance\operator.dart'

with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Add constants to OperatorType
new_constants = '''  static const deviation =
      7; //% (Điện dung đo đạc - Điện dung định mức) /  Điện dung định mức) * 100
  static const maxSubMin = 8; //Max(A,B,C) - Min(A,B,C)
  static const aDivBMulti100 = 9; //(A/B)*100'''
content = re.sub(r'static const deviation =[^;]+;\s*//[^\n]+', new_constants, content)

# Add cases to operatorCalculator
new_cases = '''    case OperatorType.aSubBDivBMulti100:
      return aSubBDivBMulti100(a, b);
      break;
    case OperatorType.maxSubMin:
      return maxSubMin(a, b, c);
      break;
    case OperatorType.aDivBMulti100:
      return aDivBMulti100(a, b);
      break;'''
content = re.sub(r'case OperatorType\.aSubBDivBMulti100:[\s\n]*return aSubBDivBMulti100\(a, b\);[\s\n]*break;', new_cases, content)

# Add functions to the end
new_functions = '''
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
'''
content = content + new_functions

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
