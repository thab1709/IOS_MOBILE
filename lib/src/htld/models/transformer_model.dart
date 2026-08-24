// @dart=2.9
import 'package:g_json/g_json.dart';

class TransformerModel {
  TransformerModel(this.equipmentId,
      {this.uha,
      this.uhb,
      this.uhc,
      this.iha,
      this.ihb,
      this.ihc,
      this.i0,
      this.cosA,
      this.cosB,
      this.cosC});

  String equipmentId;
  String uha = '';
  String uhb = '';
  String uhc = '';
  String iha = '';
  String ihb = '';
  String ihc = '';
  String i0 = '';
  String cosA = '';
  String cosB = '';
  String cosC = '';

  factory TransformerModel.fromJson(JSON json) {
    return TransformerModel(
      json['equipmentId'].stringValue,
      uha: json['uha'].stringValue,
      uhb: json['uhb'].stringValue,
      uhc: json['uhc'].stringValue,
      iha: json['iha'].stringValue,
      ihb: json['ihb'].stringValue,
      ihc: json['ihc'].stringValue,
      i0: json['i0'].stringValue,
      cosA: json['cosA'].stringValue,
      cosB: json['cosB'].stringValue,
      cosC: json['cosC'].stringValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipmentId': equipmentId ?? '',
      'uha': uha ?? '',
      'uhb': uhb ?? '',
      'uhc': uhc ?? '',
      'iha': iha ?? '',
      'ihb': ihb ?? '',
      'ihc': ihc ?? '',
      'i0': i0 ?? '',
      'cosA': cosA ?? '',
      'cosB': cosB ?? '',
      'cosC': cosC ?? '',
    };
  }

  void addValueForKey(String key, String value) {
    switch (key) {
      case 'uha':
        uha = value;
        break;
      case 'uhb':
        uhb = value;
        break;

      case 'uhc':
        uhc = value;
        break;

      case 'iha':
        iha = value;
        break;

      case 'ihb':
        ihb = value;
        break;

      case 'ihc':
        ihc = value;
        break;

      case 'i0':
        i0 = value;
        break;

      case 'cosA':
        cosA = value;
        break;

      case 'cosB':
        cosB = value;
        break;

      case 'cosC':
        cosC = value;
        break;
    }
  }
}

