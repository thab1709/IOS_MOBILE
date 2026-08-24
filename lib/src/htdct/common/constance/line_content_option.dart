// @dart=2.9
class LineContentOption {
  static const int ensureOperation = 1; // Đảm bảo vận hành
  static const int poleBroken = 2; // Gẫy đổ
  static const int inclined = 3; // Nghiêng
  static const int deformation = 4; // Biến dạng
  static const int disrepair = 5; // Hư hỏng
  static const int cracked = 6; // Nứt
  static const int brokenConcrete = 7; // Lở bê tông
  static const int rust = 8; // Gỉ
  static const int correct = 9; // Đúng quy cách
  static const int lost = 10; // Mất
  static const int broken = 11; // Hỏng
  static const int blurred = 12; // Mờ
  static const int incorrect = 13; // Sai quy cách
  static const int notNumbered = 14; // Chưa đánh số
  static const int operationNotGuaranteed = 15; // Không đảm bảo vận hành
  static const int rotted = 16; // Mọt
  static const int bubsidence = 17; // Lún
  static const int mudslide = 18; // Lở
  static const int fundamentBroken = 19; // Vỡ
  static const int normal = 20; // Bình thường
  static const int crackInGround = 21; // Có vết nứt đất
  static const int drainage = 22; // Có rãnh thoát nước
  static const int breakdow = 23; // Đứt
  static const int scratched = 24; // Tướp
  static const int injury = 25; // Tổn thương
  static const int enough = 26; // Đủ
  static const int pileBroken = 27; // Hỏng
  static const int slipOff = 28; // Tuột khỏi vị trí
  static const int loose = 29; // Lỏng
  static const int cracky = 30; // Rạn
  static const int dirty = 31; // Bẩn
  static const int sischarge = 32; // Phóng điện bề mặt
  static const int burnt = 33; // Cháy nám
  static const int meanders = 34; // Uốn khúc
  static const int deviation = 35; // Lệch
  static const int fall = 36; // Phụ kiện rơi
  static const int deficient = 37; // Thiếu
  static const int standards = 38; // Đạt tiêu chuẩn
  static const int tooFar = 39; // Quá xa
  static const int tooClose = 40; // Quá gần
  static const int fire = 41; // Đầu cực cháy
  static const int turnOut = 42; // Lưỡi gà bật ra
  static const int turnOnExhaust = 43; // Bật cửa xả
  static const int threePhaseTogether = 44; // Đấu chung 3 pha
  static const int eldNotGuaranteed = 45; // Mối hàn không đảm bảo
  static const int emerge = 46; // Nhô lên khỏi mặt đất
  static const int dent = 47; // Sứt mẻ
  static const int curved = 48; // Cong vênh
  static const int exposureNotGood = 49; // Tiếp xúc không tốt
  static const int rustedSpring = 50; // Lò xo tiếp điểm gỉ
  static const int stuck = 51; // Kẹt
  static const int inactive = 52; // Không hoạt động
  static const int sosLoose = 53; // Đầu cốt lỏng
  static const int scorched = 54; // Cháy xém
  static const int groundWireNotGood = 55; // Dây nối tiếp đất không tốt
  static const int earthingRusted = 56; // Tiếp địa gỉ
  static const int corrosive = 57; // Bị ăn  mòn
  static const int breakOption = 58; // Gãy
  static const int swollen = 59; // Phồng rộp
  static const int heatGeneration = 60; // Phát nhiệt
  static const int weirdo = 61; // Bất thường
  static const int guaranteed = 62; // Đảm bảo
  static const int contactNotGuaranteed = 63; // Không đảm bảo
  static const int yes = 64; // Có
  static const int no = 65; // Không
  static const int large = 66; // Lớn
  static const int threadBreakage = 67; // Đứt sợi
  static const int loosen = 68; // Tuột
  static const int notGuaranteedOperation = 69; // Không đảm bảo
  static const int distanceEnough = 70; // Đủ khoảng cách
  static const int distanceNotEnough = 71; // Không đủ khoảng cách
  static const int constructionUnit = 72; // Đơn vị xây dựng
  static const int people = 73; // Người dân
  static const int constructiveEquipment = 74; // Thiết bị xây dựng
  static const int construction = 75; // Công trình xây dựng
  static const int discharge = 76; // Phóng điện
  static const int crackedBroken = 77; // Nứt, Vỡ
  static const int na = 1000; // Nứt, Vỡ

}

extension IntExtension on int {
  String getNameOptionLine() {
    switch (this) {
      case LineContentOption.ensureOperation:
        return 'Đảm bảo vận hành';
        break;

      case LineContentOption.poleBroken:
        return 'Gẫy đổ';
        break;

      case LineContentOption.inclined:
        return 'Nghiêng';
        break;

      case LineContentOption.deformation:
        return 'Biến dạng';
        break;

      case LineContentOption.disrepair:
        return 'Hư hỏng';
        break;

      case LineContentOption.cracked:
        return 'Nứt';
        break;

      case LineContentOption.brokenConcrete:
        return 'Lở bê tông';
        break;

      case LineContentOption.rust:
        return 'Gỉ';
        break;

      case LineContentOption.correct:
        return 'Đúng quy cách';
        break;

      case LineContentOption.lost:
        return 'Mất';
        break;

      case LineContentOption.broken:
        return 'hỏng';
        break;

      case LineContentOption.blurred:
        return 'Mờ';
        break;

      case LineContentOption.incorrect:
        return 'Sai quy cách';
        break;

      case LineContentOption.notNumbered:
        return 'Chưa đánh số';
        break;

      case LineContentOption.operationNotGuaranteed:
        return 'Không đảm bảo vận hành';
        break;

      case LineContentOption.rotted:
        return 'Mọt';
        break;

      case LineContentOption.bubsidence:
        return 'Lún';
        break;

      case LineContentOption.mudslide:
        return 'Lở';
        break;

      case LineContentOption.fundamentBroken:
        return 'Vỡ';
        break;

      case LineContentOption.normal:
        return 'Bình thường';
        break;

      case LineContentOption.crackInGround:
        return 'Có vết nứt đất';
        break;

      case LineContentOption.drainage:
        return 'Có rãnh thoát nước';
        break;

      case LineContentOption.breakdow:
        return 'Đứt';
        break;

      case LineContentOption.scratched:
        return 'Tướp';
        break;

      case LineContentOption.injury:
        return 'Tổn thương';
        break;

      case LineContentOption.enough:
        return 'Đủ';
        break;

      case LineContentOption.pileBroken:
        return 'Hỏng';
        break;

      case LineContentOption.slipOff:
        return 'Tuột khỏi vị trí';
        break;

      case LineContentOption.loose:
        return 'Lỏng';
        break;

      case LineContentOption.cracky:
        return 'Rạn';
        break;

      case LineContentOption.dirty:
        return 'Bẩn';
        break;

      case LineContentOption.sischarge:
        return 'Phóng điện bề mặt';
        break;

      case LineContentOption.burnt:
        return 'Cháy nám';
        break;

      case LineContentOption.meanders:
        return 'Uốn khúc';
        break;

      case LineContentOption.deviation:
        return 'Lệch';
        break;

      case LineContentOption.fall:
        return 'Phụ kiện rơi';
        break;

      case LineContentOption.deficient:
        return 'Thiếu';
        break;

      case LineContentOption.standards:
        return 'Đạt tiêu chuẩn';
        break;

      case LineContentOption.tooFar:
        return 'Quá xa';
        break;

      case LineContentOption.tooClose:
        return 'Quá gần';
        break;

      case LineContentOption.fire:
        return 'Đầu cực cháy';
        break;

      case LineContentOption.turnOut:
        return 'Lưỡi gà bật ra';
        break;

      case LineContentOption.turnOnExhaust:
        return 'Bật cửa xả';
        break;

      case LineContentOption.threePhaseTogether:
        return 'Đấu chung 3 pha';
        break;

      case LineContentOption.eldNotGuaranteed:
        return 'Mối hàn không đảm bảo';
        break;

      case LineContentOption.emerge:
        return 'Nhô lên khỏi mặt đất';
        break;

      case LineContentOption.dent:
        return 'Sứt mẻ';
        break;

      case LineContentOption.curved:
        return 'Cong vênh';
        break;

      case LineContentOption.exposureNotGood:
        return 'Tiếp xúc không tốt';
        break;

      case LineContentOption.rustedSpring:
        return 'Lò xo tiếp điểm gỉ';
        break;

      case LineContentOption.stuck:
        return 'Kẹt';
        break;

      case LineContentOption.inactive:
        return 'Không hoạt động';
        break;

      case LineContentOption.sosLoose:
        return 'Đầu cốt lỏng';
        break;

      case LineContentOption.scorched:
        return 'Cháy xém';
        break;

      case LineContentOption.groundWireNotGood:
        return 'Dây nối tiếp đất không tốt';
        break;

      case LineContentOption.earthingRusted:
        return 'Tiếp địa gỉ';
        break;

      case LineContentOption.corrosive:
        return 'Bị ăn mòn';
        break;

      case LineContentOption.breakOption:
        return 'Gãy';
        break;

      case LineContentOption.swollen:
        return 'Phồng rộp';
        break;

      case LineContentOption.heatGeneration:
        return 'Phát nhiệt';
        break;

      case LineContentOption.weirdo:
        return 'Bất thường';
        break;

      case LineContentOption.guaranteed:
        return 'Đảm bảo';
        break;

      case LineContentOption.contactNotGuaranteed:
        return 'Tiếp xúc không đảm bảo';
        break;

      case LineContentOption.yes:
        return 'Có';
        break;

      case LineContentOption.no:
        return 'Không';
        break;

      case LineContentOption.large:
        return 'Lớn';
        break;

      case LineContentOption.threadBreakage:
        return 'Đứt sợi';
        break;

      case LineContentOption.loosen:
        return 'Tuột';
        break;

      case LineContentOption.notGuaranteedOperation:
        return 'Không đảm bảo';
        break;
      case LineContentOption.distanceEnough:
        return 'Đủ khoảng cách';
      case LineContentOption.distanceNotEnough:
        return 'Không đủ khoảng cách';
      case LineContentOption.constructionUnit:
        return 'Đơn vị thi công';
      case LineContentOption.people:
        return 'Dân cư';
      case LineContentOption.constructiveEquipment:
        return 'Thiết bị xây dựng';
      case LineContentOption.construction:
        return 'Công trình xây dựng';
      case LineContentOption.discharge:
        return 'Phóng điện';
      case LineContentOption.crackedBroken:
        return 'Nứt, vỡ';

      case LineContentOption.na:
        return 'N/A';
      default:
        return '';
    }
  }
}

