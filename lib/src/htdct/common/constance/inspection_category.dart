// @dart=2.9
import 'package:evnmobile/src/htdct/common/constance/strings.dart';
import 'package:evnmobile/src/htdct/models/day_night/ticket.dart';

class HighElectricInspectionCategory {
  static const TU = 1; //TU/TU trung thế
  static const TI = 2; //TI/TI trung thế
  static const CS_VAN = 3; //Chống sét van
  static const DCL = 4; //Dao cách ly
  static const MBA = 5; //Máy biến áp
  static const MBA_TD = 6; //Máy biến áp tự dùng
  static const MC = 7; //Máy cắt
  static const TCAI = 8; //Thanh cái
  static const TB = 9; //Tụ bù
  static const TNAQ = 10; //Tủ nạp ác quy
  static const AQUY = 11; //ACCU
  static const ROLE = 12; //Rơ le
  static const DCS = 13; //Dây chống sét
  static const SU = 14; //Sứ
  static const DDAN = 15; //Dây dẫn
  static const TCRUNG = 16; //Tạ chống rung
  static const CD = 17; //Cột điện
  static const MCOT = 18; //Móng cột
  static const CAPN = 19; //Cáp ngầm
  static const THT = 20; //Tủ hạ thế

  static String getEndpointAPI(int category, {TestType testType = TestType.subStation, TicketType ticketType}) {
    switch (category) {
      case TU:
        return 'tu';
        break;
      case TI:
        return 'ti';
        break;
      case CS_VAN:
        if(testType == TestType.line) {
          return 'linecsv';
        }
        return 'lightning-protection-valve';
        break;
      case DCL:
        return 'isolation-knife';
        break;
      case MBA:
        if (ticketType == TicketType.periodicNight) {
          return 'transformers-night';
        }
        return 'transformers';
        break;
      case MBA_TD:
        if (ticketType == TicketType.periodicNight) {
          return 'substation-seft-use-night';
        }
        return 'substation-seft-use';
        break;
      case MC:
        if (ticketType == TicketType.periodicNight) {
          return 'cutting-machines-night';
        }
        return 'cutting-machines';
        break;
      case TCAI:
        //ToDo update endpoint
        return '';
        break;
      case TB:
        if (ticketType == TicketType.periodicNight) {
          return 'compensating-capacitor-night';
        }
        return 'compensating-capacitor';
        break;
      case TNAQ:
        return 'charging-cabinet';
        break;
      case AQUY:
        return 'accu';
        break;
      case ROLE:
        return 'role';
        break;
      case DCS:
        return 'linelighting';
        break;
      case SU:
        return 'lineinsulations';
        break;
      case DDAN:
        return 'lineconductor';
        break;
      case TCRUNG:
        //ToDo update endpoint
        return '';
        break;
      case CD:
        return 'linepoles';
        break;
      case MCOT:
        return 'linefoudation';
        break;
      case CAPN:
        if(testType == TestType.line) {
          return 'lineUnder';
        }
        return 'underground-cables';
        break;
      case THT:
        return 'voltage-cabinets';
        break;
      default:
        return '';
    }
  }

  static String getPopupName(int category) {
    switch (category) {
      case TU:
        return HighElectricStrings.TU;
        break;
      case TI:
        return HighElectricStrings.TI;
        break;
      case CS_VAN:
        return HighElectricStrings.CS_VAN;
        break;
      case DCL:
        return HighElectricStrings.DCL;
        break;
      case MBA:
        return HighElectricStrings.MBA;
        break;
      case MBA_TD:
        return HighElectricStrings.MBA_TD;
        break;
      case MC:
        return HighElectricStrings.MC;
        break;
      case TCAI:
        return HighElectricStrings.TCAI;
        break;
      case TB:
        return HighElectricStrings.TB;
        break;
      case TNAQ:
        return HighElectricStrings.TNAQ;
        break;
      case AQUY:
        return HighElectricStrings.AQUY;
        break;
      case ROLE:
        return HighElectricStrings.ROLE;
        break;
      case DCS:
        return HighElectricStrings.DCS;
        break;
      case SU:
        return HighElectricStrings.SU;
        break;
      case DDAN:
        return HighElectricStrings.DDAN;
        break;
      case TCRUNG:
        return HighElectricStrings.TCRUNG;
        break;
      case CD:
        return HighElectricStrings.CD;
        break;
      case MCOT:
        return HighElectricStrings.MCOT;
        break;
      case CAPN:
        return HighElectricStrings.CAPN;
        break;
      case THT:
        return HighElectricStrings.THT;
        break;
      default:
        return '';
    }
  }
}

