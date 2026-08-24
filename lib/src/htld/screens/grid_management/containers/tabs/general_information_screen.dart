// @dart=2.9
import 'package:evnmobile/src/app_common/utils/utils.dart';
import 'package:evnmobile/src/htld/common/components/count_down_view.dart';
import 'package:evnmobile/src/htld/common/constance/inspection_category.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/models/equipment_model.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_section_title.dart';
import 'package:evnmobile/src/htld/screens/grid_management/containers/e_text_area.dart';
import 'package:evnmobile/src/htld/screens/grid_management/ticket/ticket_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/components/app_button.dart';
import '../../../../models/day_night/ticket.dart';
import '../../grid_management_controller.dart';
import '../../ticket/ticket_controller.dart';
import '../e_datetime_picker.dart';
import '../e_label.dart';
import '../e_text_field.dart';
class GeneralInformationScreen extends StatefulWidget {
  final Function next;

  const GeneralInformationScreen({Key key, this.next}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GeneralInformationState();
  }
}
class GeneralInformationState extends State<GeneralInformationScreen> implements TicketDelegate{
  final GridManagementController _gridManagementController = Get.find();
  TicketController ticketController;
  ActionType _actionType;
  final _paddingHorizontal = 16.0;

  Widget _getData(){
    Future.delayed(const Duration(milliseconds: 200 ), ticketController.getGeneral);
    return Container();
  }

  @override
  void initState() {
    ticketController = Get.find();
    _actionType = ticketController.ticketScreenArgument.actionType;
    ticketController.isProcessing = false;
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _config();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Obx(() {
                if (ticketController.generalDataModel.value != null) {}
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: ESectionTitle('Thông tin ${ticketController.ticketScreenArgument.subStationType.title.toLowerCase()}'),
                      ),

                      if (ticketController?.generalDataModel?.value?.code != null)
                        Column(
                          children: [
                            const SizedBox(height: 16,),
                            Center(child: Obx(() => ELabel(title: '${ticketController?.generalDataModel?.value?.code  == null ? '' : '${AppStrings.workNumber}: ${ticketController?.generalDataModel?.value?.code}'}',))),
                            const SizedBox(height: 8,),
                          ],
                        ),
                      Obx(() => Stack(children: [
                        if (ticketController.time.value != 0) Countdown(
                          duration: Duration(seconds: ticketController?.time?.value),
                          onFinish: () {
                            debugPrint('finished!');
                          },
                          builder: (ctx, remaining) {
                            return Text('Hết hạn: ${formatHHMMSS(remaining.inSeconds)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red));
                          },
                        ) else Container()
                      ],),),
                      _renderContent(context)
                    ]);
              }),
            ),

          ),
          if(_actionType != ActionType.view)
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: EButton(
                title: 'Lưu và thực hiện kiểm tra',
                maxSize: true,
                action: () {
                  if(ticketController.isProcessing){
                    return;
                  }
                  if (ticketController.ticketID == null) {
                    ticketController.createTicket(getInspectRequest());
                  } else {
                    ticketController.updateInfo();
                  }
                },
              ),
            )
        ],
      ),
    );
  }

  Widget _renderContent(BuildContext context) {
     final ticketScreenArgument = ticketController.ticketScreenArgument;
     final enableEdit = ticketScreenArgument.actionType != ActionType.view;
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.symmetric(vertical: 16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           ETextField(title: 'Chu kỳ kiểm tra', weight: FontWeight.bold, enable: false,
             value: '${_gridManagementController.argument.ticketType.title.capitalizeFirst}'),
          Obx(
            () => ETextField(
              title: 'Tên trạm',
              weight: FontWeight.bold,
              enable: false,
              value: ticketController?.generalDataModel?.value?.substationName ?? ticketScreenArgument.substationModel?.name ?? '',
            ),
          ),
          ETextField(title: 'Kiểu trạm', weight: FontWeight.bold, enable: false, value: ticketController?.generalDataModel?.value?.substationKind ?? ticketController?.ticketScreenArgument?.substationModel?.substationKind,),
           Obx(() => ETextField(title: 'Thuộc đường dây', weight: FontWeight.bold, enable: false, value: ticketController?.generalDataModel?.value?.lineName ?? ticketController?.ticketScreenArgument?.substationModel?.lineName,),),
           Obx(() => ETextField(title: 'Nhiệt độ 1', enable: enableEdit && (ticketController.generalDataModel.value?.isGroupOne ?? true), weight: FontWeight.bold,
             value: ticketController?.generalDataModel?.value?.temperature1 ?? '' ,
             onChange: (value) {
               ticketController?.generalDataModel?.value?.temperature1 = value;
           },),),
           Obx(() => ETextField(title: 'Thời tiết 1',
             enable: enableEdit && (ticketController.generalDataModel.value?.isGroupOne ?? true), weight: FontWeight.bold, value: ticketController?.generalDataModel?.value?.weather1 ?? '', onChange: (value) {
               ticketController?.generalDataModel?.value?.weather1 = value;
           } ,),),
           Obx(() => ETextField(title: 'Nhiệt độ 2',
             enable: enableEdit && !(ticketController.generalDataModel.value?.isGroupOne ?? true), weight: FontWeight.bold, value: ticketController?.generalDataModel?.value?.temperature2 ?? '', onChange: (value) {
             ticketController.distributionInspectModel.temperature_2 = value;
           },),),
           Obx(() => ETextField(title: 'Thời tiết 2',
             enable: enableEdit && !(ticketController.generalDataModel?.value?.isGroupOne ?? true), weight: FontWeight.bold, value: ticketController?.generalDataModel?.value?.weather2 ?? '', onChange: (value) {
             ticketController.distributionInspectModel.weather_2 = value;
           } ,),),
           _renderMBA(),
           Obx(() => ETextField(
             title: 'Sở hữu', weight: FontWeight.bold,
             value: ticketController?.generalDataModel?.value?.assetManagementUnit ?? ticketController?.ticketScreenArgument?.substationModel?.assetManagementUnitName, enable: false,)),

         ETextField(
           title: 'Yêu cầu định kỳ kiểm tra',
           weight: FontWeight.bold,
           value: ticketController?.ticketScreenArgument?.fre ?? ticketController.generalDataModel?.value?.inspectionRequest ?? '',
           enable: false,
         ),
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16),
             child: ETextArea(title: 'Các tồn tại từ lần kiểm tra trước',
               value: ticketController?.generalDataModel?.value?.latestAbnormalPhenomenon ?? ticketScreenArgument.substationModel?.latestAbnormalPhenomenon ?? '',
               weight: FontWeight.bold, enable: false,),
           ),
           Obx(() =>  EDateTimePicker(title: 'Ngày, giờ kiểm tra',
             weight: FontWeight.bold,
             horizontalPadding: 16,
             currentDate: ticketController?.generalDataModel?.value?.inspectTime?.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm) ?? DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm),
             enable: false, dateSelected: (_) {  },),),
           Obx(() =>
               EDateTimePicker(title: 'Thời gian kiểm tra gần nhất',
                 weight: FontWeight.bold,
                 currentDate: ticketController?.generalDataModel?.value?.lastInspection?.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm) ?? DateTime.now().toStringFormat(AppStrings.ddmmyyyyHHmm),
                 horizontalPadding: 16,
                 enable: false, dateSelected: (_) {  },),),
         ],
       ),
     );
  }

  Widget _renderMBA() {
    final mbas = ticketController.ticketScreenArgument?.equipments?.where((element) {
      return element.inspectionCategory == InspectionCategory.distributionTransformer || element.inspectionCategory == InspectionCategory.immediaryTransformer;
    })?.toList() ?? <EquipmentModel>[];
    if (mbas.isEmpty) {

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: _paddingHorizontal,),
            child: const Text(
              'Dung lượng',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Obx(() => Column(
            children: ticketController?.generalDataModel?.value?.immediaryInspectGeneralEquipmentModels?.map((e) {
              return ETextField(title: '${e.equipmentName} (${e.equipmentCode})', weight: FontWeight.w500, titlePadding: const EdgeInsets.only(left: 24), value: e.capatity, enable: false,);
            })?.toList() ?? <Container>[],
          ),)
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: _paddingHorizontal,),
          child: const Text(
            'Dung lượng',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Column(
          children: mbas.map((e) {
            return ETextField(title: '${e.name} (${e.code})', weight: FontWeight.w500, titlePadding: const EdgeInsets.only(left: 24), value: e.capacity, enable: false,);
          }).toList(),
        ),
      ],
    );
  }

  String getInspectRequest(){
    return  _gridManagementController.argument.ticketType == TicketType.periodicDay ? '1 tháng/lần'
        : _gridManagementController.argument.ticketType == TicketType.periodicNight ? '3 tháng/lần' : '';
  }

  Container _config(){
    ticketController.delegate = this;
    return Container();
  }

  @override
  void onCreateContentSuccess() {
  }

  @override
  void onCreateTicketSuccess({bool isSuccess}) {
    if (isSuccess) {
      widget.next();
    }
  }
}

