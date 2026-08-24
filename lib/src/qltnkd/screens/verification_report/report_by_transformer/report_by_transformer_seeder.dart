// @dart=2.9
// TODO: REMOVE - File này chỉ dùng để test mock data, xóa file này khi test xong
import '../../../common/constance/report_work_status_type.dart';
import '../../../models/report_merge_model.dart';
import '../../../models/work_merge_model.dart';
import 'report_by_transformer_controller.dart';

void loadMockDataReportByTransformer(ReportByTransformerController c) {
  c.listReportByTransformerModel.clear();
  final work1 = WorkMergeModel(
    id: 'mock-w1',
    formReportId: 'mock-form-1',
    equipmentName: 'Máy biến áp lực TEST-MBA-001',
    workType: 'Kiểm định',
    location: 'TBA Test Đống Đa',
    userImp: [],
    isSync: true,
    isAllowEditing: true,
    isAllowRecall: true,
    isPaperReport: true,
  )
    ..substationId = 'sub-1'
    ..isSelected = false
    ..isAllowSend = false
    ..isAllowApprovedOrRejected = false
    ..reportMergeModels = [
      ReportMergeModel(
        id: 'mock-r1',
        reportNumber: 'TEST.001/KĐ-DEMO-TN',
        workingStatus: ReportStatusType.Rejected,
        status: 'Bị từ chối',
        type: 'Kiểm định',
        stampNumber: ['TEST-001'],
        formType: 1,
        exportCertificateAccreditation: false,
        exportCertificateTest: false,
      ),
      ReportMergeModel(
        id: 'mock-r2',
        reportNumber: 'TEST.002/TN-DEMO-TN',
        workingStatus: ReportStatusType.Rejected,
        status: 'Bị từ chối',
        type: 'Thí nghiệm',
        stampNumber: ['TEST-002'],
        formType: 1,
        exportCertificateAccreditation: false,
        exportCertificateTest: false,
      ),
      ReportMergeModel(
        id: 'mock-r3',
        reportNumber: 'TEST.003/GCN-DEMO-TN',
        workingStatus: ReportStatusType.Completed,
        status: 'Hoàn thành',
        type: 'GCN kiểm định',
        stampNumber: ['TEST-003'],
        formType: 1,
        exportCertificateAccreditation: false,
        exportCertificateTest: false,
      ),
    ];

  c.listReportByTransformerModel.add(ReportByTransformerModel(
    transformerName: 'TBA Test Đống Đa',
    transformerId: 'sub-1',
    mergeModels: [work1],
  ));
  c.isFirstLoad = true;
  c.listReportByTransformerModel.refresh();
}

