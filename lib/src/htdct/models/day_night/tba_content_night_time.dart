// @dart=2.9
import 'package:evnmobile/src/htdct/models/day_night/popups/images_model.dart';
import 'package:g_json/g_json.dart';

class TransformerNightTime {
  double pc;
  double qc;
  double uc;
  double ic;
  double pt;
  double qt;
  double ut;
  double it;
  double ph;
  double qh;
  double uh;
  double ih;
  int chirp;
  String chirpText;
  String checkHeatGeneration;
  String checkAbnormalDischarges;
  String otherAbnormalPhenomena;
  String existencesHandled;
  String abnormalPhenomenon;
  List<Images> images;

  TransformerNightTime(
      {this.pc,
        this.qc,
        this.uc,
        this.ic,
        this.pt,
        this.qt,
        this.ut,
        this.it,
        this.ph,
        this.qh,
        this.uh,
        this.ih,
        this.chirp,
        this.chirpText,
        this.checkHeatGeneration,
        this.checkAbnormalDischarges,
        this.otherAbnormalPhenomena,
        this.existencesHandled,
        this.abnormalPhenomenon,
        this.images});

  TransformerNightTime.fromJson(JSON json) {
    pc = json['pc'].ddouble;
    qc = json['qc'].ddouble;
    uc = json['uc'].ddouble;
    ic = json['ic'].ddouble;
    pt = json['pt'].ddouble;
    qt = json['qt'].ddouble;
    ut = json['ut'].ddouble;
    it = json['it'].ddouble;
    ph = json['ph'].ddouble;
    qh = json['qh'].ddouble;
    uh = json['uh'].ddouble;
    ih = json['ih'].ddouble;
    chirp = json['chirp'].integer;
    chirpText = json['chirpText'].string;
    checkHeatGeneration = json['checkHeatGeneration'].string;
    checkAbnormalDischarges = json['checkAbnormalDischarges'].string;
    otherAbnormalPhenomena = json['otherAbnormalPhenomena'].string;
    existencesHandled = json['existencesHandled'].string;
    abnormalPhenomenon = json['abnormalPhenomenon'].string;
    if (json['images'] != null) {
      images = json['images']?.listObject?.map((e) => Images.fromJsonNotMap(JSON(e)))?.toList();
    }
    else {
      images = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['pc'] = pc;
    data['qc'] = qc;
    data['uc'] = uc;
    data['ic'] = ic;
    data['pt'] = pt;
    data['qt'] = qt;
    data['ut'] = ut;
    data['it'] = it;
    data['ph'] = ph;
    data['qh'] = qh;
    data['uh'] = uh;
    data['ih'] = ih;
    data['chirp'] = chirp;
    data['chirpText'] = chirpText;
    data['checkHeatGeneration'] = checkHeatGeneration;
    data['checkAbnormalDischarges'] = checkAbnormalDischarges;
    data['otherAbnormalPhenomena'] = otherAbnormalPhenomena;
    data['existencesHandled'] = existencesHandled;
    data['abnormalPhenomenon'] = abnormalPhenomenon;
    if (images != null) {
      data['images'] = images.map((v) => v.toJson()).toList();
    } else {
      images = [];
    }
    return data;
  }
}

