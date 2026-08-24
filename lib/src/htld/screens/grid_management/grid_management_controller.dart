// @dart=2.9
import 'package:evnmobile/src/htld/models/day_night/ticket.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:get/get.dart';

class GridManagementController extends GetxController {
  TicketScreenArgument argument = TicketScreenArgument();

 void setTicketType(SubStationType subStationType, TicketType ticketType) {
    argument.ticketType = ticketType;
    argument.subStationType = subStationType;
  }
}
