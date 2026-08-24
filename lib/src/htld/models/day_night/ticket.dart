// @dart=2.9
import '../../../../app_env.dart';
import '../../../app_common/shared/app_shared.dart';
import '../../common/constance/inspection_type.dart';
import '../../common/constance/strings.dart';

enum SubStationType { distribution, intermediate, mediumVoltage, lowVoltage }

enum TicketType {
  periodicDay,
  periodicNight,
  techDay,
  fortuityDay,
  incidentDay
}

extension TicketTypeName on TicketType {
  String get title {
    switch (this) {
      case TicketType.periodicDay:
        return AppShared.instance.getAppType() == AppType.HTLDHT
            ? AppStrings.periodic
            : AppStrings.periodicDay;
      case TicketType.periodicNight:
        return AppStrings.periodicNight;
      case TicketType.techDay:
        return AppStrings.techDay;
      case TicketType.fortuityDay:
        return AppStrings.fortuityDay;
      case TicketType.incidentDay:
        return AppStrings.incidentDay;
      default:
        return '';
    }
  }

  int get code {
    switch (this) {
      case TicketType.periodicDay:
        return InspectionType.dayTime;
      case TicketType.periodicNight:
        return InspectionType.nightTime;
      case TicketType.techDay:
        return InspectionType.technique;
      case TicketType.fortuityDay:
        return InspectionType.fortuity;
      case TicketType.incidentDay:
        return InspectionType.incident;
      default:
        return 0;
    }
  }
}

extension SubStationName on SubStationType {
  String get title {
    switch (this) {
      case SubStationType.distribution:
        return AppStrings.distribution;
      case SubStationType.intermediate:
        return AppStrings.intermediate;
      case SubStationType.mediumVoltage:
        return AppStrings.mediumVoltage;
      case SubStationType.lowVoltage:
        return AppStrings.lowVoltage;
      default:
        return '';
    }
  }

  String get endPoint {
    switch (this) {
      case SubStationType.distribution:
        return 'distributioninspect';
      case SubStationType.intermediate:
        return 'immediaryinspect';
      case SubStationType.mediumVoltage:
        return 'lineinspect';
      case SubStationType.lowVoltage:
        return 'lineinspect';
      default:
        return '';
    }
  }

  int get code {
    switch (this) {
      case SubStationType.distribution:
        return 1;
      case SubStationType.intermediate:
        return 2;
      case SubStationType.mediumVoltage:
        return 3;
      case SubStationType.lowVoltage:
        return 3;
      default:
        return 4;
    }
  }

  List<TicketType> get tickets {
    switch (this) {
      case SubStationType.distribution:
        return [
          TicketType.periodicDay,
          TicketType.periodicNight,
          TicketType.techDay,
          TicketType.fortuityDay
        ];
      case SubStationType.intermediate:
        return [
          TicketType.periodicDay,
          TicketType.periodicNight,
          TicketType.techDay
        ];
      case SubStationType.mediumVoltage:
        return [
          TicketType.periodicDay,
          TicketType.periodicNight,
          TicketType.techDay,
          TicketType.incidentDay,
          TicketType.fortuityDay
        ];

      case SubStationType.lowVoltage:
        return [
          TicketType.periodicDay,
          TicketType.techDay,
          TicketType.incidentDay,
          TicketType.fortuityDay
        ];
      default:
        return <TicketType>[];
    }
  }
}

extension TicketTypeCode on num {
  TicketType get getTicket {
    switch (this) {
      case InspectionType.dayTime:
        return TicketType.periodicDay;

      case InspectionType.nightTime:
        return TicketType.periodicNight;

      case InspectionType.technique:
        return TicketType.techDay;

      case InspectionType.fortuity:
        return TicketType.fortuityDay;

      case InspectionType.incident:
        return TicketType.incidentDay;

      default:
        return TicketType.fortuityDay;
    }
  }
}

class TicketModel {
  String sub;
}

