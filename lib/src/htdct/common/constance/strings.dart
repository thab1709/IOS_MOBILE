// @dart=2.9
class HighElectricStrings {
  HighElectricStrings._();

  //main screen
  static const tabManage = 'Quản lý hiện trường';
  static const tabProfile = 'Cá nhân';
  static const tabLogBook = 'Sổ theo dõi';
  static const tabLocation = 'Vị trí';
  static const tabDashboard = 'Dashboard';
  static const tabNotify = 'Thông báo';

  //Format date
  static const utcFormat = 'yyyy-MM-ddTHH:mm:ss';
  static const yyyyMMddTHHmmss = 'yyyy-MM-ddTHH:mm:ss';
  static const HHmmssyyyyMMdd = 'HH:mm:ss dd/MM/yyyy';
  static const utcFormatNotZ = 'yyyy-MM-ddTHH:mm:ss.SSS';
  static const planDate = 'yyyy-MM-ddTHH:mm:ss';
  static const ddMMyyyy = 'dd/MM/yyyy';
  static const yyyyMMdd = 'yyyy-MM-dd';
  static const yyyyMMddMode2 = 'yyyy/MM/dd';
  static const ddmmyyyyHHmm = 'dd/MM/yyyy HH:mm';
  static const ddmmyyyyHHmmss = 'dd/MM/yyyy HH:mm:ss';
  static const yyyyMMddHHmm = 'yyyy-MM-dd HH:mm';
  static const yyyyMMddHHmmss = 'yyyy-MM-dd HH:mm:ss';
  static const hhmmyyyyMMdd = 'HH:mm yyyy/MM/dd';
  static const hhmmddMMyyyy = 'HH:mm dd/MM/yyyy';
  static const hhMMss = 'HH:mm:ss';

  //Day-night check
  //Substation
  static const ticketTitle = 'Kiểm tra ';
  static const distribution = 'Trạm biến áp phân phối';
  static const intermediate = 'Trạm biến áp trung gian';
  static const mediumVoltage = 'Đường dây trung áp';
  static const subStation = 'Trạm biến áp';
  static const line = 'Đường dây';
  static const periodicDay = 'Định kỳ ngày';
  static const periodicMonth = 'Định kỳ tháng';
  static const periodicNight = 'Định kỳ đêm';
  static const periodicCBM = 'Định kỳ CBM';
  static const tunnelCable = 'Hầm nối cáp ngầm';
  static const experiment = 'Thí nghiệm';
  static const operationLog = 'Sổ nhật ký vận hành';
  static const userGroupLog = 'Sổ ghi ý kiến các đoàn kiểm tra';
  static const materialTracking = 'Sổ theo dõi vật tư dự phòng';
  static const lineProblem = 'Sổ tổng hợp phân tích sự cố đường dây';
  static const techDay = 'kỹ thuật';
  static const fortuityDay = 'đột xuất';
  static const incidentDay = 'sự cố';

  // name check popup
  static const conclude = 'Kết luận';
  static const unusualClassification = 'Phân loại bất thường';
  static const abnormalExpression = 'Biểu hiện bất thường';
  static const checkBonded = 'Kiểm tra ngoại quan';
  static const check = 'Kiểm tra';
  static const checkChargingCabinet = 'Kiểm tra tủ nạp';
  static const operatingVoltageTI = 'Dòng điện từng pha (A)';
  static const operatingVoltageTU = 'Điện áp từng pha (kV)';
  static const checkChirpOfTransformers = 'Tiếng kêu của MBA';
  static const checkBodyCondition = 'Tình trạng thân vỏ';
  static const checkBodyConditionOfTransformers = 'Tình trạng thân vỏ MBA';
  static const checkBodyConditionExOfTransformers =
      'Tình trạng thân vỏ MBA (Han rỉ, chảy dầu…)';
  static const checkAuxiliaryOilTankOfTransformers =
      'Tình trạng mức dầu bình dầu phụ MBA';
  static const checkAuxiliaryOilTankOfOLTC =
      'Tình trạng mức dầu bình dầu phụ MBA, OLTC';
  static const checkSilicaGelColor = 'Màu sắc của hạt hút ẩm';
  static const checkCounterTapChanger = 'Chỉ số bộ đếm chuyển nấc OLTC';
  static const checkElectricalCabinetTransformers =
      'Tình trạng tủ điều khiển, tủ đấu dây tại chỗ MBA.';
  static const checkActuatorAndOltc = 'Tình trạng tủ truyền động và bộ OLTC ';
  static const checkGroundingTransformer = 'Tình trạng hệ thống nối đất MBA';
  static const checkMistingSystemTransformer =
      'Tình trạng Hệ thống quạt mát, phun sương MBA';
  static const checkPumpSystemTransformer =
      'Tình trạng Hệ thống bơm dầu tuần hoàn MBA (chỉ dành cho MBA AT1, AT2 E1.40)';
  static const checkRiskOtherTransformer =
      'Nguy cơ gây sự cố khác (vật liệu công trường, cây đổ, vật lạ bay vào trạm…)';
  static const checkFireSystemTransformer = 'Kiểm tra hệ thống PCCC';
  static const checkInfoRuningTransformer = 'Thông số vận hành';
  static const checkInsulatorTransformer =
      'Tình trạng đầu cực, sứ đỡ các phía MBA ';

  static const checkCarryingCapacityOfTransformer = 'Kiểm tra tải MBA';
  static const checkCarryingCapacityOf110 = 'Dòng tải phía 110kV (A)';
  static const checkCarryingCapacityOf35 = 'Dòng tải phía 35kV (A)';
  static const checkCarryingCapacityOf22 = 'Dòng tải phía 22kV (A)';
  static const checkOperatingVoltageOf110 = 'Điện áp vận hành 110kV (KV)';
  static const checkOperatingVoltageOf35 = 'Điện áp vận hành 35kV (KV)';
  static const checkOperatingVoltageOf22 = 'Điện áp vận hành 22kV (KV)';
  static const checkWattagePOf110 = 'Công suất P 110 KV (KW)';
  static const checkWattagePOf35 = 'Công suất P 35 KV (KW)';
  static const checkWattagePOf22 = 'Công suất P 22 KV (KW)';
  static const checkWattageQOf110 = 'Công suất Q 110 KV (KVAr)';
  static const checkWattageQOf35 = 'Công suất Q 35 KV (KVAr)';
  static const checkWattageQOf22 = 'Công suất Q 22 KV (KVAr)';
  static const checkActuatorCabinet =
      'Tình trạng tủ truyền động (ATM, sấy, độ kín, đọng nước, motơ quay…)';

  static const checkMechanicalStructureAndGrounding =
      'Cấu trúc cơ khí và nối đất';
  static const checkInsulator = 'Tình trạng sứ các cách điện';

  static const checkOilTemperature =
      'Nhiệt độ dầu / cuộn dây (cao / trung / hạ) (ºC)';
  static const checkTemperatureOnTransformer = 'Đồng hồ tại mặt MBA';
  static const checkTemperatureOnTransformerCabinet =
      'Đồng hồ tại tủ bảo vệ MBA';
  static const degreeOfDifferenceTransformerCabinet = 'Mức độ chênh lệch';

  static const checkCarryingCapacityOfLowVoltage = 'Dòng tải phía hạ thế (A)';
  static const checkCarryingCapacityByPhase = 'Dòng tải từng pha (A)';
  static const checkWaltByPhase = 'Công suất Q từng pha (KVAr)';
  static const checkOilTankAndSilicaGelColor =
      'Tình trạng mức dầu, mầu sắc của hạt hút ẩm MBA';
  static const checkInsulatorAndOther =
      'Tình trạng các điểm tiếp xúc, đầu cốt, sứ cách điện';

  static const phaseNumber = 'Số pha';
  static const phaseA = 'Pha A';
  static const phaseB = 'Pha B';
  static const phaseC = 'Pha C';
  static const phaseN = 'Pha N';
  static const phaseCaps = 'Cáp';
  static const phaseBYIn = 'Điện áp vào tủ nạp (VAC)';
  static const phaseBYOut = 'Điện áp ra tủ nạp (VDC)';
  static const phaseACCU = 'Điện áp nạp ACCU (VDC)';
  static const phaseDC = 'Điện áp phụ tải (VDC)';
  static const phaseBYInI = 'BY vào (IAC)';
  static const phaseBYOutI = 'BY ra (IDC)';
  static const phaseACCUI = 'ACCU (IDC)';
  static const phaseDCI = 'Phụ tải DC (IDC)';

  static const relayOperatigVoltageValue = 'Giá trị trên rơle ngăn lộ';
  static const relayOperatigVoltageTUValue = 'Giá trị trên rơle TU';
  static const electricMeterValue = 'Giá trị trên công tơ ngăn lộ';
  static const electricMeterConcludeValue = 'Giá trị trên công tơ lộ tổng';
  static const insulationOilLevel = 'Mức dầu cách điện';
  static const groundingStatus = 'Tình trạng nối đất';
  static const leakageCurrentValue = 'Giá trị dòng rò (mA)';
  static const lightningCounterIndicator = 'Chỉ số bộ đếm sét';
  static const conditionOfCable = 'Tình trạng đầu cáp và tán cáp';
  static const conditionOfGroundingSystem =
      'Tình trạng hệ thống tiếp đất vỏ cáp';
  static const bracketCondition = 'Tình trạng giá đỡ (nứt, gỉ, cầu cáp, …)';
  static const conditionOfSeepage =
      'Tình trạng thấm rỉ, dung môi cách điện, phồng thân bình';
  static const condenserGroundingStatus = 'Tình trạng nối đất dàn tụ';
  static const cableStatus = 'Tình trạng cáp (nứt, tổn thương cáp …)';
  static const checkOperatingVoltage = 'Điện áp vận hành';
  static const operatingCurrent = 'Dòng điện vận hành';
  static const cabinetSideSignalStatus = 'Trạng thái tín hiệu mặt tủ';
  static const cabinetStatus = 'Tình trạng tủ (tiếng kêu, phát nhiệt, ATM …)';
  static const checkACCUSystem = 'Kiểm tra hệ thống ACCU';
  static const conditionOfTankShellPile =
      'Tình trạng vỏ bình, cọc bình (rỉ, ôxi hóa đầu cực, phồng bình,..)';
  static const troubleLightingStatus =
      'Tình trạng đèn chiếu sáng sự cố, quạt thông gió';
  static const roleCover = 'Các rơle bảo vệ, điều khiển và hệ thống đo lường';
  static const roleActiveStatus = 'Tình trạng nguồn hoạt động';
  static const roleActiveLightingStatus =
      'Tình trạng các đèn báo trạng thái vận hành, trạng thái kết nối mạng';
  static const roleInterfaceStatus = 'Tình trạng màn hình';
  static const roleCircuitStatus =
      'Tình trạng mạch, hàng kẹp, ATM (phát nhiệt, lỏng, …)';
  static const roleCabinetInside = 'Các loại tủ bảng điện trong nhà';
  static const roleCompartment = 'Khoang nhị thứ';
  static const roleTroubleLightingStatus =
      'Tình trạng các đèn báo tín hiệu, bộ báo tín hiệu, cảnh báo trên mặt tủ';
  static const roleDisplayDevicesStatus =
      'Tình trạng các đèn chỉ thị, MIMIC so với trạng thái nhất thứ';
  static const roleDryingAndLightingCircuit =
      'Tình trạng hệ thống mạch sấy, chiếu sáng';
  static const roleIntrusionOfAnimals = 'Tình trạng động vật lạ xâm nhập.';
  static const roleWaterIntrusionOfAnimals =
      'Tình trạng chống nước; động vật lạ xâm nhập.';
  static const roleCheckGroundingSystem = 'Kiểm tra hệ thống nối đất';
  static const roleCheckIndustrialHygiene = 'Tình trạng vệ sinh công nghiệp';
  static const roleCabinetOutside = 'Các loại tủ bảng điện ngoài trời';

  //problem
  static const optionNone = 'Không có';
  static const optionNormal = 'Bình thường';
  static const optionUnNormal = 'Không bình thường';
  static const optionWeirdo = 'Bất thường';
  static const optionGood = 'Tốt';
  static const optionBad = 'Xấu';
  static const optionLack = 'Thiếu';
  static const optionEnough = 'Đủ';
  static const optionRift = 'Rạn nứt';
  static const optionDirty = 'Bẩn';
  static const optionDischarge = 'Phóng điện';
  static const optionYes = 'Có';
  static const optionNo = 'Không';
  static const optionClosed = 'Đóng';
  static const optionCut = 'Cắt';
  static const optionDiscolored = 'Nóng đỏ, đổi màu';
  static const optionOpen = 'Mở';
  static const optionOriginal = 'Nguyên vẹn';
  static const optionRusty = 'Han gỉ';
  static const optionPunctured = 'Thủng';
  static const optionCracked = 'Nứt';
  static const optionBroken = 'Vỡ';
  static const optionWarping = 'Cong vênh';
  static const optionOilSpill = 'Chảy dầu';
  static const optionDifficultToManipulate = 'Khó thao tác';
  static const optionLoose = 'Lỏng';
  static const optionElectricalLeakageSound =
      'Có tiếng kêu do phóng điện bề mặt';
  static const optionFiberForm = 'Tưa';
  static const optionBrokenWire = 'Đứt';
  static const optionFire = 'Cháy';
  static const optionFit = 'Phù hợp';
  static const optionInappropriate = 'Không phù hợp';
  static const optionOutOfGas = 'Hết khí';
  static const optionDamaged = 'Hư hỏng';
  static const optionBlistering = 'Phồng rộp';
  static const optionMelasma = 'Nám';
  static const optionAbnormalitiesDischarge = 'Bất thường do phóng điện';
  static const optionHotRed = 'Nóng đỏ chuyển màu';
  static const optionColorChange = 'Đổi màu';
  static const optionHeatGeneration = 'Phát nhiệt';
  static const optionBrokenSegment = 'Gãy';
  static const optionInclined = 'Nghiêng';
  static const optionPeelOffTheYeast = 'Tróc men';
  static const optionDifferrence = 'Lệch';
  static const optionWinding = 'Uốn khúc';
  static const optionFallingTheLatch = 'Rơi chốt';
  static const optionFailure = 'Hỏng';

  //name line popup
  static const String TU = 'TU trung thế';
  static const String TI = 'TI trung thế';
  static const String CS_VAN = 'Chống sét van';
  static const String DCL = 'Dao cách ly';
  static const String MBA = 'Máy biến áp';
  static const String MBA_TD = 'Máy biến áp tự dùng';
  static const String MC = 'Máy cắt';
  static const String TCAI = 'Thanh cái';
  static const String TB = 'Tụ bù';
  static const String TNAQ = 'Tủ chỉnh lưu 1 chiều';
  static const String AQUY = 'ACCU';
  static const String ROLE = 'Rơ le';
  static const String DCS = 'Dây chống sét';
  static const String SU = 'Sứ';
  static const String DDAN = 'Dây dẫn';
  static const String TCRUNG = 'Tạ chống rung';
  static const String CD = 'Cột điện';
  static const String MCOT = 'Móng cột';
  static const String CAPN = 'Cáp ngầm';
  static const String THT = 'Tủ hạ thế';

  //text
  static const autoFill = 'Tự động điền';
  static const workNumber = 'Công việc số';
  static final titleList = 'Danh sách các lần kiểm tra'.toUpperCase();
  static const requireText = '';
  static const updateOfflineFalse =
      'Dữ liệu chưa được đồng bộ về hoặc Không tìm thấy công việc';

  static const requireCopyPopupText =
      'Để copy dữ liệu thiết bị, yêu cầu không tồn tại trường bất thường.';
  static const requireUpdatePopupText =
      'Vui lòng nhập dữ liệu bắt buộc còn thiếu';
  static const overloadImagesLength = 'Tối đa 10 hình ảnh';

  //popup
  static const contentPopupCopyEquipment =
      'Thiết bị vừa chọn đã được kiểm tra!\nBạn có muốn kiểm tra thay thế?';
  static const invalidDistance =
      'Vị trí bạn kiểm tra cần phải nằm trong khoảng cách < hoặc = ';

  static const emptyList = 'Danh sách trống';

  static const updatePopupSuccess =
      'Cập nhật thông tin vật tư thiết bị thành công';
  static const updatePopupSuccessCommon = 'Cập nhật thông tin thành công';
  static const copyPopupSuccess =
      'Sao chép thông tin vật tư thiết bị thành công';
  static const invalidDateTime = 'Thời gian không hợp lệ';
  static const confirmDelete = 'Bạn có chắc chắn muốn xóa !';
  static const inputDataNumber = 'Nhập thông số';
  static const inputOtherData = 'Nhập thông tin khác';
  static const warningInputValue = 'Bạn cần xem lại, số liệu nhập đã đúng?';
  static const requiredLocationPermission =
      'Ứng dụng cần sử dụng vị trí để có thể thực hiện kiểm tra';
  static const isMockedLocation =
      'Để lưu thành công, bạn phải tắt vị trí mô phỏng từ ứng dụng bên thứ 3 có trên thiết bị.';
}

