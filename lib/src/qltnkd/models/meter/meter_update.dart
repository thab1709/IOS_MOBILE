// @dart=2.9
import 'package:g_json/g_json.dart';

class MeterDetail {
  MeterDetail({
    this.id,
    this.errorType,
    this.diaDiem,
    this.pha,
    this.dateInFormReport,
    this.workingStatus,
    this.scheduleId,
    this.code,
    this.maKH,
    this.soCongTo,
    this.tenKH,
    this.diaChi,
    this.nuocSanXuat,
    this.k,
    this.loai,
    this.dongDien,
    this.dienAp,
    this.capChinhXacP,
    this.capChinhXacQ,
    this.ptNhan,
    this.donViPtNhan,
    this.qtNhan,
    this.donViQtNhan,
    this.ptGiao,
    this.donViPtGiao,
    this.qtGiao,
    this.donViQtGiao,
    this.r1Giao,
    this.donViR1Giao,
    this.r2Giao,
    this.donViR2Giao,
    this.r3Giao,
    this.donViR3Giao,
    this.hsn,
    this.tySoBienTU,
    this.tySoBienTI,
    this.temCongQuang,
    this.tinhTrangTemChiSo,
    this.maChiPhanCaiDat,
    this.soLuongChiTai,
    this.maChiTai,
    this.tinhTrangChi,
    this.temKiemDinh,
    this.tinhTrangTemChiPhanCaiDat,
    this.soDoDauDayDoLuong,
    this.chiSoCongToCamUng,
    this.tinhTrangCongToTruocKiemDinh,
    this.tinhTrangCongToTruocKiemDinhCode,
    this.uKiemTra,
    this.iKiemTra,
    this.heSoCos,
    this.chiSoSauKiem,
    this.chiSoSauKiemPtGiao,
    this.chiSoSauKiemQtGiao,
    this.chiSoSauKiemR1Giao,
    this.chiSoSauKiemR2Giao,
    this.chiSoSauKiemR3Giao,
    this.chiSoSauKiemPtNhan,
    this.chiSoSauKiemQtNhan,
    this.chiSoSauKiemR1Nhan,
    this.chiSoSauKiemR2Nhan,
    this.chiSoSauKiemR3Nhan,
    this.dieuKienMoiTruong,
    this.nhietDo,
    this.doAm,
    this.cos1100,
    this.cos05100,
    this.cos110,
    this.doNhay,
    this.tuQuay,
    this.tySoTruyen,
    this.dongDienSCIA,
    this.dongDienSCIB,
    this.dongDienSCIC,
    this.dongDienTCIa,
    this.dongDienTCIb,
    this.dongDienTCIc,
    this.dienApSCUA,
    this.dienApSCUB,
    this.dienApSCUC,
    this.dienApTCUa,
    this.dienApTCUb,
    this.dienApTCUc,
    this.gocLechPha,
    this.thuTuPha,
    this.soDoVecTo,
    this.ketLuan,
    this.congToDienIds,
    this.machDoLuongIds,
    this.cacYKienKhacIds,
    this.thietBiKiemId,
    this.thietBiKiemModel,
    this.conclusion,
  });

  MeterDetail.fromJson(JSON json) {
    id = json['id'].string;
    errorType = json['errorType'].integer;
    diaDiem = json['diaDiem'].integer;
    pha = json['pha'].integer;
    dateInFormReport = json['dateInFormReport'].string;
    workingStatus = json['workingStatus'].integer;
    scheduleId = json['scheduleId'].string;
    code = json['code'].string;
    maKH = json['maKH'].string;
    soCongTo = json['soCongTo'].string;
    tenKH = json['tenKH'].string;
    diaChi = json['diaChi'].string;
    nuocSanXuat = json['nuocSanXuat'].string;
    k = json['k'].string;
    loai = json['loai'].string;
    dongDien = json['dongDien'].string;
    dienAp = json['dienAp'].string;
    capChinhXacP = json['capChinhXacP'].string;
    capChinhXacQ = json['capChinhXacQ'].string;
    ptNhan = json['ptNhan'].string;
    donViPtNhan = json['donViPtNhan'].integer;
    qtNhan = json['qtNhan'].string;
    donViQtNhan = json['donViQtNhan'].integer;
    ptGiao = json['ptGiao'].string;
    donViPtGiao = json['donViPtGiao'].integer;
    qtGiao = json['qtGiao'].string;
    donViQtGiao = json['donViQtGiao'].integer;
    r1Giao = json['r1Giao'].string;
    donViR1Giao = json['donViR1Giao'].integer;
    r2Giao = json['r2Giao'].string;
    donViR2Giao = json['donViR2Giao'].integer;
    r3Giao = json['r3Giao'].string;
    donViR3Giao = json['donViR3Giao'].integer;
    hsn = json['hsn'].string;
    tySoBienTU = json['tySoBienTU'].string;
    tySoBienTI = json['tySoBienTI'].string;
    temCongQuang = json['temCongQuang'].string;
    tinhTrangTemChiSo = json['tinhTrangTemChiSo'].integer;
    maChiPhanCaiDat = json['maChiPhanCaiDat'].string;
    soLuongChiTai = json['soLuongChiTai'].string;
    maChiTai = json['maChiTai'].string;
    tinhTrangChi = json['tinhTrangChi'].integer;
    temKiemDinh = json['temKiemDinh'].string;
    tinhTrangTemChiPhanCaiDat = json['tinhTrangTemChiPhanCaiDat'].integer;
    soDoDauDayDoLuong = json['soDoDauDayDoLuong'].string;
    chiSoCongToCamUng = json['chiSoCongToCamUng'].string;
    tinhTrangCongToTruocKiemDinh = json['tinhTrangCongToTruocKiemDinh'].string;
    tinhTrangCongToTruocKiemDinhCode =
        json['tinhTrangCongToTruocKiemDinhCode'].string;
    uKiemTra = json['uKiemTra'].string;
    iKiemTra = json['iKiemTra'].string;
    heSoCos = json['heSoCos'].string;
    chiSoSauKiem = json['chiSoSauKiem'].boolean;
    chiSoSauKiemPtGiao = json['chiSoSauKiemPtGiao'].string;
    chiSoSauKiemQtGiao = json['chiSoSauKiemQtGiao'].string;
    chiSoSauKiemR1Giao = json['chiSoSauKiemR1Giao'].string;
    chiSoSauKiemR2Giao = json['chiSoSauKiemR2Giao'].string;
    chiSoSauKiemR3Giao = json['chiSoSauKiemR3Giao'].string;
    chiSoSauKiemPtNhan = json['chiSoSauKiemPtNhan'].string;
    chiSoSauKiemQtNhan = json['chiSoSauKiemQtNhan'].string;
    chiSoSauKiemR1Nhan = json['chiSoSauKiemR1Nhan'].string;
    chiSoSauKiemR2Nhan = json['chiSoSauKiemR2Nhan'].string;
    chiSoSauKiemR3Nhan = json['chiSoSauKiemR3Nhan'].string;
    dieuKienMoiTruong = json['dieuKienMoiTruong'].string;
    nhietDo = json['nhietDo'].string;
    doAm = json['doAm'].string;
    cos1100 = json['cos1_100'].string;
    cos05100 = json['cos05_100'].string;
    cos110 = json['cos1_10'].string;
    doNhay = json['doNhay'].string;
    tuQuay = json['tuQuay'].string;
    tySoTruyen = json['tySoTruyen'].string;
    dongDienSCIA = json['dongDienSC_IA'].string;
    dongDienSCIB = json['dongDienSC_IB'].string;
    dongDienSCIC = json['dongDienSC_IC'].string;
    dongDienTCIa = json['dongDienTC_ia'].string;
    dongDienTCIb = json['dongDienTC_ib'].string;
    dongDienTCIc = json['dongDienTC_ic'].string;
    dienApSCUA = json['dienApSC_UA'].string;
    dienApSCUB = json['dienApSC_UB'].string;
    dienApSCUC = json['dienApSC_UC'].string;
    dienApTCUa = json['dienApTC_ua'].string;
    dienApTCUb = json['dienApTC_ub'].string;
    dienApTCUc = json['dienApTC_uc'].string;
    gocLechPha = json['gocLechPha'].string;
    thuTuPha = json['thuTuPha'].string;
    soDoVecTo = json['soDoVecTo'].string;
    ketLuan = json['ketLuan'].string;
    congToDienIds = json['congToDienIds'].string;
    machDoLuongIds = json['machDoLuongIds'].string;
    cacYKienKhacIds = json['cacYKienKhacIds'].string;
    thietBiKiemId = json['thietBiKiemId'].string;
    thietBiKiemModel = json['thietBiKiemModel'] != null
        ? ThietBiKiemModel.fromJson(json['thietBiKiemModel'])
        : null;
    conclusion = json['conclusion'].integer;
  }

  String id;
  int errorType;
  int diaDiem;
  int pha;
  String dateInFormReport;
  int workingStatus;
  String scheduleId;
  String code;
  String maKH;
  String soCongTo;
  String tenKH;
  String diaChi;
  String nuocSanXuat;
  String k;
  String loai;
  String dongDien;
  String dienAp;
  String capChinhXacP;
  String capChinhXacQ;
  String ptNhan;
  int donViPtNhan;
  String qtNhan;
  int donViQtNhan;
  String ptGiao;
  int donViPtGiao;
  String qtGiao;
  int donViQtGiao;
  String r1Giao;
  int donViR1Giao;
  String r2Giao;
  int donViR2Giao;
  String r3Giao;
  int donViR3Giao;
  String hsn;
  String tySoBienTU;
  String tySoBienTI;
  String temCongQuang;
  int tinhTrangTemChiSo;
  String maChiPhanCaiDat;
  String soLuongChiTai;
  String maChiTai;
  int tinhTrangChi;
  String temKiemDinh;
  int tinhTrangTemChiPhanCaiDat;
  String soDoDauDayDoLuong;
  String chiSoCongToCamUng;
  String tinhTrangCongToTruocKiemDinh;
  String tinhTrangCongToTruocKiemDinhCode;
  String uKiemTra;
  String iKiemTra;
  String heSoCos;
  bool chiSoSauKiem;
  String chiSoSauKiemPtGiao;
  String chiSoSauKiemQtGiao;
  String chiSoSauKiemR1Giao;
  String chiSoSauKiemR2Giao;
  String chiSoSauKiemR3Giao;
  String chiSoSauKiemPtNhan;
  String chiSoSauKiemQtNhan;
  String chiSoSauKiemR1Nhan;
  String chiSoSauKiemR2Nhan;
  String chiSoSauKiemR3Nhan;
  String dieuKienMoiTruong;
  String nhietDo;
  String doAm;
  String cos1100;
  String cos05100;
  String cos110;
  String doNhay;
  String tuQuay;
  String tySoTruyen;
  String dongDienSCIA;
  String dongDienSCIB;
  String dongDienSCIC;
  String dongDienTCIa;
  String dongDienTCIb;
  String dongDienTCIc;
  String dienApSCUA;
  String dienApSCUB;
  String dienApSCUC;
  String dienApTCUa;
  String dienApTCUb;
  String dienApTCUc;
  String gocLechPha;
  String thuTuPha;
  String soDoVecTo;
  String ketLuan;
  String congToDienIds;
  String machDoLuongIds;
  String cacYKienKhacIds;
  String thietBiKiemId;
  ThietBiKiemModel thietBiKiemModel;
  int conclusion;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['errorType'] = errorType;
    map['diaDiem'] = diaDiem;
    map['pha'] = pha;
    map['dateInFormReport'] = dateInFormReport;
    map['workingStatus'] = workingStatus;
    map['scheduleId'] = scheduleId;
    map['code'] = code;
    map['maKH'] = maKH;
    map['soCongTo'] = soCongTo;
    map['tenKH'] = tenKH;
    map['diaChi'] = diaChi;
    map['nuocSanXuat'] = nuocSanXuat;
    map['k'] = k;
    map['loai'] = loai;
    map['dongDien'] = dongDien;
    map['dienAp'] = dienAp;
    map['capChinhXacP'] = capChinhXacP;
    map['capChinhXacQ'] = capChinhXacQ;
    map['ptNhan'] = ptNhan;
    map['donViPtNhan'] = donViPtNhan;
    map['qtNhan'] = qtNhan;
    map['donViQtNhan'] = donViQtNhan;
    map['ptGiao'] = ptGiao;
    map['donViPtGiao'] = donViPtGiao;
    map['qtGiao'] = qtGiao;
    map['donViQtGiao'] = donViQtGiao;
    map['r1Giao'] = r1Giao;
    map['donViR1Giao'] = donViR1Giao;
    map['r2Giao'] = r2Giao;
    map['donViR2Giao'] = donViR2Giao;
    map['r3Giao'] = r3Giao;
    map['donViR3Giao'] = donViR3Giao;
    map['hsn'] = hsn;
    map['tySoBienTU'] = tySoBienTU;
    map['tySoBienTI'] = tySoBienTI;
    map['temCongQuang'] = temCongQuang;
    map['tinhTrangTemChiSo'] = tinhTrangTemChiSo;
    map['maChiPhanCaiDat'] = maChiPhanCaiDat;
    map['soLuongChiTai'] = soLuongChiTai;
    map['maChiTai'] = maChiTai;
    map['tinhTrangChi'] = tinhTrangChi;
    map['temKiemDinh'] = temKiemDinh;
    map['tinhTrangTemChiPhanCaiDat'] = tinhTrangTemChiPhanCaiDat;
    map['soDoDauDayDoLuong'] = soDoDauDayDoLuong;
    map['chiSoCongToCamUng'] = chiSoCongToCamUng;
    map['tinhTrangCongToTruocKiemDinh'] = tinhTrangCongToTruocKiemDinh;
    map['tinhTrangCongToTruocKiemDinhCode'] = tinhTrangCongToTruocKiemDinhCode;
    map['uKiemTra'] = uKiemTra;
    map['iKiemTra'] = iKiemTra;
    map['heSoCos'] = heSoCos;
    map['chiSoSauKiem'] = chiSoSauKiem;
    map['chiSoSauKiemPtGiao'] = chiSoSauKiemPtGiao;
    map['chiSoSauKiemQtGiao'] = chiSoSauKiemQtGiao;
    map['chiSoSauKiemR1Giao'] = chiSoSauKiemR1Giao;
    map['chiSoSauKiemR2Giao'] = chiSoSauKiemR2Giao;
    map['chiSoSauKiemR3Giao'] = chiSoSauKiemR3Giao;
    map['chiSoSauKiemPtNhan'] = chiSoSauKiemPtNhan;
    map['chiSoSauKiemQtNhan'] = chiSoSauKiemQtNhan;
    map['chiSoSauKiemR1Nhan'] = chiSoSauKiemR1Nhan;
    map['chiSoSauKiemR2Nhan'] = chiSoSauKiemR2Nhan;
    map['chiSoSauKiemR3Nhan'] = chiSoSauKiemR3Nhan;
    map['dieuKienMoiTruong'] = dieuKienMoiTruong;
    map['nhietDo'] = nhietDo;
    map['doAm'] = doAm;
    map['cos1_100'] = cos1100;
    map['cos05_100'] = cos05100;
    map['cos1_10'] = cos110;
    map['doNhay'] = doNhay;
    map['tuQuay'] = tuQuay;
    map['tySoTruyen'] = tySoTruyen;
    map['dongDienSC_IA'] = dongDienSCIA;
    map['dongDienSC_IB'] = dongDienSCIB;
    map['dongDienSC_IC'] = dongDienSCIC;
    map['dongDienTC_ia'] = dongDienTCIa;
    map['dongDienTC_ib'] = dongDienTCIb;
    map['dongDienTC_ic'] = dongDienTCIc;
    map['dienApSC_UA'] = dienApSCUA;
    map['dienApSC_UB'] = dienApSCUB;
    map['dienApSC_UC'] = dienApSCUC;
    map['dienApTC_ua'] = dienApTCUa;
    map['dienApTC_ub'] = dienApTCUb;
    map['dienApTC_uc'] = dienApTCUc;
    map['gocLechPha'] = gocLechPha;
    map['thuTuPha'] = thuTuPha;
    map['soDoVecTo'] = soDoVecTo;
    map['ketLuan'] = ketLuan;
    map['congToDienIds'] = congToDienIds;
    map['machDoLuongIds'] = machDoLuongIds;
    map['cacYKienKhacIds'] = cacYKienKhacIds;
    map['thietBiKiemId'] = thietBiKiemId;
    if (thietBiKiemModel != null) {
      map['thietBiKiemModel'] = thietBiKiemModel.toJson();
    }
    map['conclusion'] = conclusion;
    return map;
  }
}

class ThietBiKiemModel {
  ThietBiKiemModel({
    this.id,
    this.name,
    this.code,
    this.ccx,
    this.isDefault,
  });

  ThietBiKiemModel.fromJson(JSON json) {
    id = json['id'].string;
    name = json['name'].string;
    code = json['code'].string;
    ccx = json['ccx'].string;
    isDefault = json['isDefault'].boolean;
  }

  String id;
  String name;
  String code;
  String ccx;
  bool isDefault;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['code'] = code;
    map['ccx'] = ccx;
    map['isDefault'] = isDefault;
    return map;
  }
}

