// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';

int getWorkType(SubStationType subStationType, TicketType ticketType) {
  if (subStationType == SubStationType.distribution &&
      ticketType == TicketType.periodicDay) {
    return 1;
  } else if (subStationType == SubStationType.distribution &&
      ticketType == TicketType.periodicNight) {
    return 2;
  } else if (subStationType == SubStationType.intermediate &&
      ticketType == TicketType.periodicDay) {
    return 5;
  } else if (subStationType == SubStationType.intermediate &&
      ticketType == TicketType.periodicNight) {
    return 6;
  } else if (subStationType == SubStationType.mediumVoltage &&
      ticketType == TicketType.periodicDay) {
    return 3;
  } else if (subStationType == SubStationType.mediumVoltage &&
      ticketType == TicketType.periodicNight) {
    return 4;
  } else if (subStationType == SubStationType.lowVoltage &&
      ticketType == TicketType.periodicDay) {
    return 3;
  } else if (subStationType == SubStationType.lowVoltage &&
      ticketType == TicketType.periodicNight) {
    return 4;
  }

  return 1;
}

