# API Documentation - Danh Sách Công Việc (Work List)

## Tổng quan

Module **Danh sách công việc** (QLTNKD) hỗ trợ 2 loại công việc:
- **Công việc đơn vị** (groupType = 0): Sử dụng endpoint `/individualjob`
- **Công việc cho các X** (groupType = 1): Sử dụng endpoint `/constructionschedule/individual-job`

**Controller**: `lib/src/qltnkd/screens/verification_report/list_work/tab/list_work_controller.dart`

**Repositories**:
- `ReportRepository` - Xử lý các API liên quan đến công việc và biên bản
- `MergerFormReportRepository` - Xử lý các API tạo/xác nhận biên bản
- `WorkloadRepository` - Xử lý API lấy danh sách đơn vị

---

## 1. Lấy Danh Sách Công Việc

### API Endpoint
```
GET /individualjob                              (đơn vị)
GET /constructionschedule/individual-job        (cho các X)
```

### Repository Method
`ReportRepository.getListWork()`

### Parameters
| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| UnitId | String | Không | ID đơn vị (nếu = '0' thì null) |
| EquipmentName | String | Không | Tên thiết bị |
| SearchTerm | String | Không | Từ khóa tìm kiếm |
| EquipmentTypeId | String | Không | Loại thiết bị (nếu = '0' thì null) |
| EquipmentDetailId | String | Không | Chi tiết loại thiết bị (nếu = '0' thì null) |
| WorkProgress | String | Không | Trạng thái công việc (nếu = '0' thì null) |
| ReportNumber | String | Không | Số biên bản |
| StampNumber | String | Không | Số tem |
| WorkType | String | Không | Loại công việc (nếu = '0' thì null) |
| FromDate | String | Không | Từ ngày (ISO 8601) |
| ToDate | String | Không | Đến ngày (ISO 8601) |
| orderBy | String | Không | Thứ tự sắp xếp (mặc định: 'ASC') |
| pageIndex | Number | Có | Trang hiện tại (mặc định: 1) |
| pageSize | Number | Có | Số bản ghi/trang (mặc định: 20) |
| IsPaperFormReport | Boolean | Không | Lọc biên bản giấy |

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "list": [
      {
        "id": "string",
        "equipmentName": "string",
        "equipmentTypeId": "string",
        "equipmentDetailId": "string",
        "workProgress": "number",
        "reportNumber": "string",
        "stampNumber": "string",
        "workTypeName": "string",
        "periodicType": "string",
        "formId": "string",
        "isMeter": "boolean",
        "isConfirmComplete": "boolean",
        "clonedDate": "string (ISO 8601)"
      }
    ],
    "paging": {
      "pageIndex": 1,
      "pageSize": 20,
      "totalCount": 100
    }
  }
}
```

### Đặc biệt với "Cho các X" (groupType = 1)
- Khi có `fromDate` và `toDate`, hệ thống sẽ lọc thêm theo `clonedDate`
- Log API response với prefix: `==== CHO CAC X API RESPONSE ====`

---

## 2. Tìm Kiếm Công Việc

### API Endpoint
```
GET /individualjob
```

### Repository Method
`ReportRepository.getListWork()` với `searchTerm` parameter

### Parameters
| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| SearchTerm | String | Có | Từ khóa tìm kiếm |
| pageIndex | Number | Có | Trang hiện tại |

### Controller Method
`ListWorkController.searchData(ListTypeLoad type)`

### Offline Support
Khi offline, sử dụng: `RLocalDataManager.instance.getWorksOffline(searchTerm: searchTerm)`

---

## 3. Lấy Danh Sách Đơn Vị

### API Endpoint
```
GET /unit
```

### Repository Method
`ReportRepository.getUnits()`

### Parameters
| Tên | Kiểu | Giá trị | Mô tả |
|-----|------|---------|-------|
| pageSize | String | '99' | Lấy tất cả đơn vị |

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "list": [
      {
        "id": "string",
        "name": "string",
        "code": "string"
      }
    ]
  }
}
```

### Note
- Response luôn thêm item đầu tiên: `{ id: '0', name: 'Tất cả' }`

---

## 4. Tạo Biên Bản Từ Công Việc

### API Endpoint
```
POST /formreport
```

### Repository Method
`ReportRepository.createFromReport(ReportWorkItem workItem)`

### Request Body
```json
{
  "formId": "string (optional)",
  "scheduleId": "string (required)"
}
```

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": "report-id-string"
}
```

### Controller Method
`ListWorkController.createIndividualJob(workModel, isSearch: bool)`

### Offline Support
Khi offline, sử dụng: `RLocalDataManager.instance.createReportOffline(workModel)`

### Quy trình tạo biên bản
1. Kiểm tra quyền: `userProfile.isHasCreateFormReport()`
2. Kiểm tra định vị GPS: `LocationServiceBackground.shared.requestPermission()`
3. Kiểm tra kết nối mạng
4. Tạo biên bản (online/offline)
5. Gửi location: `service.sendLocation(reportId, type: 3)`
6. Navigate đến màn hình biên bản: `ReportScreen(reportId, isAllowEditing: true)`
7. Refresh danh sách

---

## 5. Lấy Danh Sách Biên Bản Copy

### API Endpoint
```
GET /formreport/formreport-copy-paging             (đơn vị)
GET /constructionformreport/formreport-copy-paging (cho các X)
```

### Repository Method
`ReportRepository.getFormReportCopy()`

### Parameters
| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| ScheduleId | String | Có | ID công việc |
| EquipmentDetailId | String | Có | ID chi tiết thiết bị |
| EquipmentTypeId | String | Không | ID loại thiết bị |
| SearchTerm | String | Không | Từ khóa tìm kiếm |
| pageIndex | Number | Có | Trang hiện tại |
| pageSize | Number | Có | Số bản ghi/trang |

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": {
    "list": [
      {
        "id": "string",
        "reportNumber": "string",
        "createdDate": "string",
        "equipmentName": "string"
      }
    ],
    "paging": {...}
  }
}
```

---

## 6. Tạo Biên Bản Copy

### API Endpoint
```
POST /formreport/copy-formreport
```

### Repository Method
`MergerFormReportRepository.createReportsCopy()`

### Request Body
```json
{
  "formReportId": "string (ID biên bản gốc)",
  "scheduleId": "string (ID công việc)",
  "equipmentTypeId": "string",
  "equipmentDetailId": "string"
}
```

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": "new-report-id-string"
}
```

### Controller Method
`ListWorkController.createIndividualJobCopy(workModel, formReportCopyModel, isSearch: bool)`

### Note
- **Chỉ hỗ trợ online**, không có offline mode
- Sau khi tạo thành công, gửi location và navigate đến màn hình biên bản

---

## 7. Xác Nhận Hoàn Thành

### API Endpoint
```
POST /individualjob/confirm-complete
```

### Repository Method
`MergerFormReportRepository.confirmComplete(scheduleId)`

### Request Body
```json
{
  "scheduleId": "string"
}
```

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": "string"
}
```

### Controller Method
`ListWorkController.confirmComplete(scheduleId, isSearch: bool)`

### Quy trình
1. Call API `/individualjob/confirm-complete`
2. Gửi location: `service.sendLocation(scheduleId, type: 2)`
3. Refresh danh sách công việc

---

## 8. Tạo Biên Bản Công Tơ

### API Endpoint
```
POST /mergeformreport/create-meter-formreport
```

### Repository Method
`MergerFormReportRepository.createMeterReport(scheduleId)`

### Request Body
```json
{
  "scheduleId": "string"
}
```

### Response
```json
{
  "statusCode": 200,
  "message": "Success",
  "data": "report-id-string"
}
```

### Controller Method
`ListWorkController.createMeterReport(scheduleId, isSearch: bool)`

### Quy trình
1. Call API tạo biên bản công tơ
2. Gửi location: `service.sendLocation(reportId, type: 3)`
3. Navigate đến màn hình: `BBCongToPage(reportId, isAllowEdit: true)`
4. Refresh danh sách

---

## 9. Gửi Vị Trí GPS

### API Endpoint
```
POST /formreport/form-report-location
```

### Repository Method
`ReportRepository.sendLocation(reportId, type: int, position: Position?)`

### Request Body
```json
{
  "id": "string (reportId or scheduleId)",
  "longitude": "string",
  "latitude": "string",
  "type": "number"
}
```

### Location Types
| Type | Mô tả |
|------|-------|
| 1 | Location mặc định |
| 2 | Location khi xác nhận hoàn thành |
| 3 | Location khi tạo biên bản mới |

### Note
- Tự động lấy GPS hiện tại: `ReportLocationUtils.getCurrentPositionForSave()`
- Hiển thị thông báo khi `type = 3`
- **backgroundMode: true** - không hiển thị loading dialog

---

## Luồng Xử Lý Chính

### 1. Load Danh Sách Công Việc
```
┌─────────────────────────────────────────────┐
│  ListWorkController.loadData()              │
│  - Check quyền: RUserRole.isWorkView        │
└──────────────┬──────────────────────────────┘
               │
               ├─ Online: getWorksOnline()
               │  └─> GET /individualjob hoặc
               │       GET /constructionschedule/individual-job
               │
               └─ Offline: getWorksOffline()
                  └─> RLocalDataManager.instance.getWorksOffline()
```

### 2. Tạo Biên Bản Từ Công Việc
```
┌──────────────────────────────────────────────────┐
│  ListWorkController.handleCreateFormReport()     │
│  - Check workModel.isMeter                       │
│  - Check workModel.isConfirmComplete             │
└──────────────┬───────────────────────────────────┘
               │
               ├─ isMeter = true
               │  └─> createMeterReport()
               │      └─> POST /mergeformreport/create-meter-formreport
               │
               ├─ isConfirmComplete = true
               │  └─> confirmComplete()
               │      └─> POST /individualjob/confirm-complete
               │
               └─ Default: Show dialog chọn
                  ├─ Tạo mới
                  │  └─> POST /formreport
                  │
                  └─ Copy từ biên bản khác
                     ├─> GET /formreport/formreport-copy-paging
                     └─> POST /formreport/copy-formreport
```

### 3. Offline/Online Sync
```
┌──────────────────────────────────────────────┐
│  RConnection.shared.checkConnection()        │
└──────────────┬───────────────────────────────┘
               │
               ├─ Online
               │  └─> Call REST API
               │      └─> Update GetX observable
               │          └─> UI auto refresh
               │
               └─ Offline
                  └─> RLocalDataManager (Hive)
                      └─> Load từ local database
                          └─> UI hiển thị dữ liệu offline
```

---

## Data Models

### ReportWorkItem
```dart
class ReportWorkItem {
  String id;
  String equipmentName;
  String equipmentTypeId;
  String equipmentDetailId;
  int workProgress;          // ReportWorkStatusType
  String reportNumber;
  String stampNumber;
  String workTypeName;
  String periodicType;
  String formId;
  bool isMeter;
  bool isConfirmComplete;
  DateTime clonedDate;       // Chỉ có trong "cho các X"
}
```

### Trạng thái công việc (ReportWorkStatusType)
```dart
class ReportWorkStatusType {
  static const int notStarted = 0;    // Chưa bắt đầu
  static const int inProgress = 1;    // Đang thực hiện
  static const int done = 2;          // Hoàn thành
  static const int Implementing = 3;  // Đang triển khai
  static const int Rejected = 4;      // Từ chối
}
```

---

## Error Handling

### Common Error Messages
- `"Không thể tải biên bản. Vui lòng thử lại."` - Load failed
- `"Người dùng không có quyền thực hiện."` - Permission denied
- `"Công việc này phải thực hiện online"` - Offline not supported
- `"Không thể lấy toạ độ, vui lòng kiểm tra lại định vị"` - GPS error

### Offline Handling
```dart
// Kiểm tra biên bản đã tồn tại offline
if (await RLocalDataManager.instance.checkReportExist(workModel.id)) {
  // Show dialog xác nhận xóa offline và tạo online
  await RLocalDataManager.instance.deleteWorkOffline(workModel.id);
}
```

---

## Performance Notes

1. **Pagination**: Mặc định `pageSize = 20` (định nghĩa trong `rAppPageSize`)
2. **Background Mode**: Hầu hết API sử dụng `backgroundMode: true` để không hiển thị loading dialog
3. **Caching**: Không có caching ở API level, chỉ offline storage với Hive
4. **Load More**: Sử dụng `ListDelegate` để quản lý load more và refresh
5. **Date Filtering for "Cho các X"**: Client-side filtering với `clonedDate` sau khi nhận response

---

## Dependencies

- **GetX**: State management và navigation
- **Hive**: Local database cho offline support
- **Geolocator**: Lấy vị trí GPS
- **ApiProvider**: HTTP client wrapper với auto-retry và token injection

---

## Testing Notes

### Test Scenarios
1. Load danh sách công việc (online/offline)
2. Search công việc
3. Tạo biên bản mới (với/không có GPS)
4. Copy biên bản từ biên bản khác
5. Xác nhận hoàn thành
6. Tạo biên bản công tơ
7. Filter theo đơn vị, thiết bị, ngày tháng
8. Load more pagination
9. Offline sync khi có kết nối trở lại

### Mock Data
Sử dụng `RLocalDataManager` để tạo mock data offline cho testing.
