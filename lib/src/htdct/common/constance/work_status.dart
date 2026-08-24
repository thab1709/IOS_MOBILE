// @dart=2.9
class HWorkStatus{
  static const notImplement = 1;
  static const implementing = 2;
  static const completed = 3;
}

class HTypeEvent
{
  static const handingOverWork = 1;//giao nhận ca
  static const workUnit = 2; // đơn vị công tác
  static const operationUnit = 3; //đơn vị thao tác
  static const abnormal = 4; //đơn vị thao tác
  static const MCMedium = 5; //MC trung thế nhảy
  static const fullTransfer = 6; //Đầy tải
  static const trouble = 7; //Sự cố
  static const ensure = 7; //ĐẢm bảo
  static const other = 8; //ĐẢm bảo
}
