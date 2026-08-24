// @dart=2.9
import '../constance_workload.dart';

enum EnumWorkload { all, newWork, reject, waitConfirm, confirmed }

enum EnumRequestStatus { all, news, created }

extension WordLoad on EnumWorkload {
  String getName() {
    switch (this) {
      case EnumWorkload.all:
        return 'Tất cả';
      case EnumWorkload.newWork:
        return 'Mới';
      case EnumWorkload.reject:
        return 'Bị từ chối';
      case EnumWorkload.waitConfirm:
        return 'Chờ xác nhận';
      case EnumWorkload.confirmed:
        return 'Đã xác nhận';
    }
    return '';
  }

  int getCode() {
    switch (this) {
      case EnumWorkload.all:
        return WorkloadStatusCode.all;
      case EnumWorkload.newWork:
        return WorkloadStatusCode.newWork;
      case EnumWorkload.reject:
        return WorkloadStatusCode.reject;
      case EnumWorkload.waitConfirm:
        return WorkloadStatusCode.waitConfirm;
      case EnumWorkload.confirmed:
        return WorkloadStatusCode.confirmed;
    }
    return WorkloadStatusCode.all;
  }
}

extension RequestStatus on EnumRequestStatus {
  String getName() {
    switch (this) {
      case EnumRequestStatus.news:
        return 'Chưa tạo phiếu';
      case EnumRequestStatus.created:
        return 'Đã tạo phiếu';
      case EnumRequestStatus.all:
        return 'Tất cả';
        break;
    }
    return '';
  }

  int getCode() {
    switch (this) {
      case EnumRequestStatus.news:
        return RequestStatusCode.news;
      case EnumRequestStatus.created:
        return RequestStatusCode.created;
      case EnumRequestStatus.all:
        return RequestStatusCode.all;
        break;
    }
    return RequestStatusCode.news;
  }
}

