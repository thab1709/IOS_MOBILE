// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/models/option_model.dart';

class ContentOptions {
  static final na = OptionModel(HighElectricStrings.optionNone, -1); //NA
  static final normal =
      OptionModel(HighElectricStrings.optionNormal, 1); //Bình thường
  static final weirdo =
      OptionModel(HighElectricStrings.optionWeirdo, 2); //Bất thường
  static final oilSpill =
      OptionModel(HighElectricStrings.optionOilSpill, 3); //Chảy dầu
  static final good = OptionModel(HighElectricStrings.optionGood, 4); //Tốt
  static final lack = OptionModel(HighElectricStrings.optionLack, 5); //Thiếu
  static final enough = OptionModel(HighElectricStrings.optionEnough, 6); //Đủ
  static final bad = OptionModel(HighElectricStrings.optionBad, 7); //Xấu
  static final closed =
      OptionModel(HighElectricStrings.optionClosed, 13); //Đóng
  static final cut = OptionModel(HighElectricStrings.optionCut, 14); // Cắt
  static final discolored =
      OptionModel(HighElectricStrings.optionDiscolored, 15); //Nóng đỏ, đổi màu
  static final open = OptionModel(HighElectricStrings.optionOpen, 16); //Mở
  static final original =
      OptionModel(HighElectricStrings.optionOriginal, 17); //Nguyên vẹn
  static final rusty = OptionModel(HighElectricStrings.optionRusty, 18); //Gỉ
  static final punctured =
      OptionModel(HighElectricStrings.optionPunctured, 19); //Thủng
  static final cracked =
      OptionModel(HighElectricStrings.optionCracked, 20); //Nứt
  static final broken = OptionModel(HighElectricStrings.optionBroken, 21); //Vỡ
  static final warping =
      OptionModel(HighElectricStrings.optionWarping, 22); //Cong vênh
  static final difficultToManipulate = OptionModel(
      HighElectricStrings.optionDifficultToManipulate, 23); //Khó thao tác
  static final loose = OptionModel(HighElectricStrings.optionLoose, 24); //Lỏng
  static final electricalLeakageSound = OptionModel(
      HighElectricStrings.optionElectricalLeakageSound,
      25); //Có tiếng kêu do phóng điện bề mặt
  static final fiberForm =
      OptionModel(HighElectricStrings.optionFiberForm, 26); //Tưa
  static final brokenWire =
      OptionModel(HighElectricStrings.optionBrokenWire, 27); //Đứt
  static final fire = OptionModel(HighElectricStrings.optionFire, 28); //Cháy
  static final fit = OptionModel(HighElectricStrings.optionFit, 29); //Phù hợp
  static final inappropriate =
      OptionModel(HighElectricStrings.optionInappropriate, 30); //Không phù hợp
  static final outOfGas =
      OptionModel(HighElectricStrings.optionOutOfGas, 31); //Hết khí
  static final damaged =
      OptionModel(HighElectricStrings.optionDamaged, 32); //Hư hỏng
  static final blistering =
      OptionModel(HighElectricStrings.optionBlistering, 33); //Phồng rộp
  static final melasma =
      OptionModel(HighElectricStrings.optionMelasma, 34); //Nám
  static final abnormalitiesDischarge = OptionModel(
      HighElectricStrings.optionAbnormalitiesDischarge,
      35); //Bất thường do phóng điện
  static final colorChange =
      OptionModel(HighElectricStrings.optionColorChange, 36); //Đổi màu
  static final heatGeneration =
      OptionModel(HighElectricStrings.optionHeatGeneration, 37); //Phát nhiệt
  static final brokenSegment =
      OptionModel(HighElectricStrings.optionBrokenSegment, 38); //Gãy
  static final inclined =
      OptionModel(HighElectricStrings.optionInclined, 39); //Nghiêng
  static final peelOffTheYeast =
      OptionModel(HighElectricStrings.optionPeelOffTheYeast, 40); //Tróc men
  static final differrence =
      OptionModel(HighElectricStrings.optionDifferrence, 41); //Lệch
  static final winding =
      OptionModel(HighElectricStrings.optionWinding, 42); //Uốn khúc
  static final fallingTheLatch =
      OptionModel(HighElectricStrings.optionFallingTheLatch, 43); //Rơi chốt
  static final failure =
      OptionModel(HighElectricStrings.optionFailure, 44); //Hỏng
  static final spit_it_out_of_the_ground =
      OptionModel('Nhô lên khỏi mặt đất', 45); //Nhô lên khỏi mặt đất
  static final isChanged = OptionModel('Thay đổi', 46); //Thay đổi
  static final rust = OptionModel('Gỉ sét', 47); //Gỉ sét
  static final clean = OptionModel('Sạch', 48); // Sạch
  static final notOriginal =
      OptionModel('Không nguyên vẹn', 49); //Không nguyên vẹn
  static final punk = OptionModel('Mục', 50); //Mục
  static final deformation = OptionModel('Biến dạng', 51); //Biến dạng
  static final subsidence = OptionModel('Lún', 52); //Lún
  static final slack = OptionModel('Chùng', 53); //Chùng
  static final hollow = OptionModel('Hở', 54); //Hở
  static final private = OptionModel('Kín', 55); //Kín
  static final wrongPosition = OptionModel('Sai vị trí', 56); //Sai vị trí
  static final fireNam = OptionModel('Cháy nám', 57); //Cháy nám
  static final electricSparkDischarge =
      OptionModel('Phóng tia lửa điện', 58); //Phóng tia lửa điện
  static final rustOil = OptionModel('Gỉ dầu', 59); //Gỉ dầu
  static final abnormalitiesDischargeAlongInsulation = OptionModel(
      'Bất thường do phóng điện bề mặt dọc cách điện',
      60); //Bất thường do phóng điện bề mặt dọc cắt điện
  static final fireSem = OptionModel('Cháy sém', 61); //Cháy sém
  static final notNormal =
      OptionModel('Không bình thường', 62); //Không bình thường
  static final warpingOp = OptionModel('Cong', 63); //Cong
  static final crackedBroken = OptionModel('Nứt vỡ', 64); //Nứt vỡ
  static final notExist = OptionModel('Không hiện hữu', 65); //Không hiện hữu
  static final noOil = OptionModel('Không có dầu', 76); //Ko có dầu
  static final oil = OptionModel('Dầu', 77); //Mức dầu cách điện - dầu
  static final dry = OptionModel('Khô', 78); //Mức dầu cách điện - khô
  static final onePhase = OptionModel('1 pha', 79); //Ko có dầu
  static final threePhase = OptionModel('3 pha', 80); //Ko có dầu
  static final rustCover = OptionModel('Han rỉ', 81); //Gỉ sét
  static final following = OptionModel('Đang theo dõi', 1); //Đang theo dõi
  static final finished = OptionModel('Đã kết thúc', 2); //Gỉ sét
  static final inSite = OptionModel('Trong nhà', 84); //Trong nhà
  static final outSite = OptionModel('Ngoài trời', 85); //Ngoài trời
  static final inOperation = OptionModel('Đang vận hành', 86); //Đang vận hành
  static final unOperation = OptionModel('Không vận hành', 87); //Không vận hành
  static final dryElectric = OptionModel('Khô', 88); //Khô
  static final oilElectric = OptionModel('Dầu', 89); //Dầu
  static final SF6Electric = OptionModel('SF6', 90); //SF6
  static final AcElectricCabinet = OptionModel('Tủ AC', 91); //Tủ AC
  static final DcElectricCabinet = OptionModel('Tủ DC', 92); //Tủ AD
  static final ScadaElectricCabinet = OptionModel('Tủ SCADA', 93); //Tủ SCADA
  static final MkElectricCabinet = OptionModel('Tủ MK', 94); //Tủ MK
  static final CtElectricCabinet = OptionModel('Tủ Công tơ', 95); //Tủ Công tơ
  static final BvdkElectricCabinet = OptionModel('Tủ BVĐK', 96); //Tủ BVĐK
  static final lock = OptionModel('Khóa', 103);
  static final notInstall = OptionModel('Không cài', 104);
  static final f1 = OptionModel('F1', 105);
  static final f2 = OptionModel('F2', 106);
  static final f3 = OptionModel('F3', 107);

  static final summary = OptionModel('Tổng', 108);
  static final line = OptionModel('Đường dây', 109);
  static final operating = OptionModel('Vận hành', 100);

  // static final noneOperating = OptionModel('Không vận hành', 101);

  static final electricalTape = OptionModel('Băng điện (Electrical tape)', 118);
  static final paint = OptionModel('Sơn (Paint)', 119);
  static final rubber = OptionModel('Cao su (Rubber)', 120);
  static final glazed = OptionModel('Sứ, men (Porcelain, glazed)', 121);
  static final concrete = OptionModel('Bê tông (Concrete)', 122);
  static final paper = OptionModel('Giấy (Paper)', 123);
  static final brick = OptionModel('Gạch (Brick, Common)', 124);
  static final copperOx = OptionModel('Oxit đồng (Copper, Ox)', 125);
  static final cement = OptionModel('Xi măng (Cement)', 126);
  static final aluminumOx = OptionModel('Oxit nhôm (Aluminum, Ox) ', 127);
  static final stainless = OptionModel('Thép không gỉ (Stainless)', 128);
  static final aluminum = OptionModel('Nhôm (Aluminum)', 129);
  static final copper = OptionModel('Đồng (Copper)', 130);
  static final nothing = OptionModel('Không có', 0);
  static final sf6 = OptionModel('SF6', 115);
  static final vacuum = OptionModel('Chân không', 116);
  static final air = OptionModel('Không khí', 117);

  static final ZeroThree = OptionModel('	3	', 200);
  static final EMICVN = OptionModel('	EMIC-VN	', 201);
  static final StackingCompartments = OptionModel('	Ghép ngăn	', 202);
  static final AntiTTArk = OptionModel('	Hòm chống TT	', 203);
  static final MachineFacePoleBox = OptionModel('	Hòm đầu cực mặt máy	', 204);
  static final RoundaboutType = OptionModel('	Kiểu vòng xuyến	', 205);
  static final LowVoltageDrawers = OptionModel('	Ngăn tủ hạ thế	', 206);
  static final Distributors = OptionModel('	Nhà phân phối	', 207);
  static final AtMBAPole = OptionModel('	Tại cực MBA	', 208);
  static final TBA = OptionModel('	TBA	', 209);
  static final InOutdoorLowVoltageCabinet =
      OptionModel('	Trong  tủ hạ thế ngoài trời	', 210);
  static final InAntiLossBox = OptionModel('	Trong hòm  chống tổn thất	', 211);
  static final InAntiTTBox = OptionModel('	Trong hòm chống TT	', 212);
  static final InMeterBox = OptionModel('	Trong hòm công tơ	', 213);
  static final InBoxCTT = OptionModel('	Trong hòm CTT	', 214);
  static final InBoxTT = OptionModel('	Trong hòm TT	', 215);
  static final InAntilossCompartment =
      OptionModel('	Trong ngăn chống TT	', 216);
  static final InAntiTTCompartment = OptionModel('	Trong ngăn chống TT	', 217);
  static final InCTTPane = OptionModel('	Trong ngăn CTT	', 218);
  static final InCompartmentLowVoltageCabinet =
      OptionModel('	Trong ngăn tủ hạ thế	', 219);
  static final InCabinet04kV = OptionModel('	Trong tủ 0,4 kV	', 220);
  static final InElectricalCabinet04kV =
      OptionModel('	Trong tủ điện 0.4kV	', 221);
  static final InMeasuringCabinet = OptionModel('	Trong tủ đo đếm	', 222);
  static final InLowVoltageCabinet = OptionModel('	Trong tủ hạ thế	', 223);
  static final InLowVoltageCabinetHouse =
      OptionModel('	Trong tủ hạ thế trong nhà	', 224);
  static final InHTCabinet = OptionModel('	Trong tủ HT	', 225);
  static final InCommunicationCabinet = OptionModel('	Trong tủ liên lạc	', 226);
  static final InCabinetAtIntermediateStation =
      OptionModel('	Trong tủ tại trạm trung gian	', 227);
  static final InCabinetTT = OptionModel('	Trong tủ TT	', 228);
  static final TotalLowVoltageCabinet = OptionModel('	Tủ hạ thế tổng	', 229);
  static final MediumVoltageCabinetsSet =
      OptionModel('	Tủ trung thế tron bộ	', 230);
  static final InDistributionCabinet = OptionModel('	Trong tủ phân phối	', 231);
  static final StationTopBreaker = OptionModel('	Cầu dao đỉnh trạm	', 232);
  static final IsolationKnife = OptionModel('	Dao cách ly	', 233);
  static final KnifeRemoteControl = OptionModel('	Dao điều khiển từ xa	', 234);
  static final OddMixingKnife = OptionModel('	Dao pha lẻ	', 235);
  static final LoadKnife = OptionModel('	Dao phụ tải	', 236);
  static final ABB = OptionModel('	ABB	', 237);
  static final StandingSlash = OptionModel('	Chém đứng	', 238);
  static final KnifeInStation = OptionModel('	Dao trong trạm	', 239);
  static final BacAnKhanh = OptionModel('	NHÀ CHUNG CƯ KĐT BẮC AN KHÁNH	', 240);
  static final InCabinet = OptionModel('	Trong tủ	', 241);
  static final InRMUCabinet = OptionModel('	Trong tủ RMU	', 242);
  static final InMiddleVoltageCabinet =
      OptionModel('	Trong tủ Trung thế	', 243);
  static final FittingLowerJawSI = OptionModel('	Lắp Hàm dưới SI	', 244);
  static final MountedTGSupport = OptionModel('	Lắp tại xà đỡ TG	', 245);
  static final MountPoleToStation = OptionModel('	Lắp cột vào trạm	', 246);
  static final InstallUndergroundCable = OptionModel('	Lắp đầu cáp ngầm	', 247);
  static final PorcelainThroughWall = OptionModel('	Sứ xuyên tường	', 248);
  static final FittingMBA = OptionModel('	Lắp mặt MBA	', 249);
  static final Substation = OptionModel('	Trạm biến áp	', 250);
  static final InstalledTGBeam = OptionModel('	Lắp tại xà TG	', 251);
  static final IntermediateSupportBeams =
      OptionModel('	Xà đỡ trung gian	', 252);
  static final LightningRods = OptionModel('	Xà chống sét	', 253);
  static final FittingMachinePoleBA = OptionModel('	Lắp cực máy BA	', 254);
  static final MountingAtTBA = OptionModel('	Lắp tại TBA	', 255);
  static final InstallCableEnd = OptionModel('	Lắp đầu cáp ngầm	', 256);
  static final MountTopStation = OptionModel('	Lắp đỉnh trạm	', 257);
  static final MountedIntermediateBeamTBA =
      OptionModel('	Lắp ở xà trung gian TBA	', 258);
  static final CableHead = OptionModel('	Đầu cáp	', 259);
  static final MountMachinePole = OptionModel('	Lắp cực máy BA	', 260);
  static final OnTheRopeSupport = OptionModel('	Trên xà đỡ dây	', 261);
  static final LightningProtectionTUTI = OptionModel('	Chống sét TU TI	', 262);
  static final ExternalWallMountingMBA =
      OptionModel('	Lắp ngoài tường MBA	', 263);
  static final FittingAfterSI = OptionModel('	Lắp sau SI	', 264);
  static final LowerJawSI = OptionModel('	Hàm dưới SI	', 265);
  static final InstalledEndUndergroundCable =
      OptionModel('	Lắp tại đầu cáp ngầm	', 266);
  static final LightningProtectionTD1 = OptionModel('	Chống sét TD1	', 267);
  static final Undefined = OptionModel('	Không xác định	', 268);
  static final NoWire = OptionModel('	Dây không	', 269);
  static final InstallTGBeamBelowSI = OptionModel('	Lắp xà TG dưới SI	', 270);
  static final SubterraneanCableFeeder =
      OptionModel('	Đầu đường dây cáp ngầm	', 271);
  static final InstallIntermediateBeams =
      OptionModel('	Lắp xà trung gian	', 272);
  static final LowerJawFuseSI = OptionModel('	Hàm dưới cầu chì SI	', 273);
  static final IntermediateBarBelowSI =
      OptionModel('	Xà trung gian dưới SI	', 274);
  static final InstalledIntermediateBeam =
      OptionModel('	Lắp tại xà trung gian	', 275);
  static final MountOnWall = OptionModel('	Lắp trên tường	', 276);
  static final UndergroundCableHead = OptionModel('	Đầu cáp ngầm	', 277);
  static final Busbar = OptionModel('	Thanh cái	', 278);
  static final IntermediateBeam = OptionModel('	Xà trung gian dưới SI	', 279);
  static final FittingFrontSI = OptionModel('	Lắp trước SI	', 280);
  static final AboveSI = OptionModel('	Trên SI	', 281);
  static final InstallProtectionTU = OptionModel('	Lắp bảo vệ TU	', 282);
  static final IndoorInstallation = OptionModel('	Lắp trong nhà	', 283);
  static final Ten = OptionModel('	10	', 284);
  static final ExtremelyHighVoltageMBA = OptionModel('	Cực cao thế MBA	', 285);
  static final InstallLowerJawFuseSI =
      OptionModel('	Lắp hàm dưới cầu chì SI	', 286);
  static final MountOnSI = OptionModel('	Lắp trên SI	', 287);
  static final LowVoltageCabinetBar = OptionModel('	Thanh cái tủ hạ thế	', 288);
  static final StationHead = OptionModel('	Đầu trạm	', 289);
  static final ScoreColumn = OptionModel('	Cột điểm đấu	', 290);
  static final MountedMandibularMedialBeamSI =
      OptionModel('	Lắp tại xà trung gian hàm dưới SI	', 291);
  static final InstallCapacitorPole = OptionModel('	Lắp cực tụ	', 292);
  static final InstallBusbars = OptionModel('	Lắp thanh cái	', 293);
  static final LightningProtectionRafters =
      OptionModel('	Xà đỡ chống sét	', 294);
  static final MountedUpperIntermediateBeamSI =
      OptionModel('	Lắp tại xà trung gian hàm trên SI	', 295);
  static final MachinePole = OptionModel('	Cực máy	', 296);
  static final IntermediateBarOnSI =
      OptionModel('	Xà trung gian trên SI	', 297);
  static final Dz = OptionModel('	Dz	', 298);
  static final Zero = OptionModel('	0	', 299);
  static final MountedTGBeamBelowSI = OptionModel('	Lắp xà TG dưới SI	', 300);
  static final AfterSI = OptionModel('	Sau SI 	', 301);

  static final handingOverWork = OptionModel('Giao nhận ca', 400);
  static final workUnit = OptionModel('Đơn vị công tác', 401);
  static final operationUnit = OptionModel('Đơn vị thao tác', 402);
  static final abnormal = OptionModel('Bất thường', 403);
  static final MCMedium = OptionModel('MC trung thế nhảy', 404);
  static final fullOperation = OptionModel('Đầy tải', 405);
  static final trouble = OptionModel('Sự cố', 406);
  static final ensure = OptionModel('Đảm bảo điện', 407);
  static final other = OptionModel('Khác', 408);

  static final calendarDay = OptionModel('Ngày', 500);
  static final calendarWeek = OptionModel('Tuần', 501);
  static final calendarMonth = OptionModel('Tháng', 502);
  static final calendarYear = OptionModel('Năm', 503);
  static final calendarAll = OptionModel('Tất cả', 504);

  static final workSumHandle = OptionModel('Tổng số', 505);
  static final workNotHandle = OptionModel('Chưa xử lý', 506);
  static final workAllStatus = OptionModel('Tất cả', 507);

  static final dashboardAbmorderSynthetic =
      OptionModel('Biểu đồ tổng hợp bất thường', 508);
  static final dashboardAbmorder = OptionModel('Biểu đồ bất thường', 509);
  static final dashboardAbmorderLog =
      OptionModel('Biểu đồ bất thường theo nhật ký vận hành', 510);

  //Phân loại bất thường
  static final first = OptionModel('Nhất thứ', 1);
  static final second = OptionModel('Nhị thứ', 2);
  static final scada = OptionModel('HT SCADA + HMI', 3);
  static final htOneDirection = OptionModel('HT 1 chiều', 4);
  static final channel = OptionModel('Kênh chuyền', 5);
  static final lineType = OptionModel('Đường dây', 6);
  static final otherAbnormalType = OptionModel('Khác', 7);
  static final undefinedType = OptionModel('Hầm nối cáp ngầm', 0);
}

