# Tài Liệu API - EVN Mobile Application

> **Base URL**: Được cấu hình qua `AppEnv.getServerUrl()`
> **Authentication**: Bearer Token (header: `Authorization: Bearer {token}`)
> **Timeout**: 360 giây
> **Response Format**: JSON

## Mục Lục

1. [API Chung (Common)](#api-chung-common)
2. [Module HTLD - Kiểm Tra Lưới Điện Hàng Ngày](#module-htld)
3. [Module HTDCT - Kiểm Tra/Thử Nghiệm Thiết Bị](#module-htdct)
4. [Module QLTNKD - Quản Lý Biên Bản Nghiệm Thu](#module-qltnkd)

-------------------------------------------------------

## API Chung (Common)

### Authentication

#### 1. Đăng nhập
**POST** `/user/login`

**Mô tả**: Đăng nhập người dùng vào hệ thống

**Body Parameters**:
```json
{
  "username": "string",
  "password": "string",
  "timezoneOffset": "number",
  "rememberMe": "boolean",
  "firebaseRegistrationKey": "string"
}
```

**Response**:
```json
{
  "statusCode": 200,
  "message": "success",
  "data": {
    "token": "string",
    "userProfile": {...}
  }
}
```

#### 2. Đăng nhập SSO
**POST** `/user/sso-login`

**Mô tả**: Đăng nhập qua Single Sign-On

**Body Parameters**:
```json
{
  "ticket": "string",
  "appCode": "string",
  "timezoneOffset": "number"
}
```

#### 3. Đăng xuất
**POST** `/user/logout`

**Mô tả**: Đăng xuất khỏi hệ thống (yêu cầu auth)

**Body Parameters**: `{}`

#### 4. Đổi mật khẩu
**PUT** `/user/{userId}/change-password`

**Mô tả**: Đổi mật khẩu người dùng

**Body Parameters**:
```json
{
  "userName": "string",
  "oldPassword": "string",
  "newPassword": "string",
  "confirmNewPassword": "string"
}
```

#### 5. Đổi mật khẩu hết hạn
**PUT** `/user/change-expire-password`

**Mô tả**: Đổi mật khẩu khi hết hạn

**Body Parameters**: (tương tự API đổi mật khẩu)

### File Upload

#### 1. Upload file đơn
**POST** `/common/upload`

**Mô tả**: Upload một file hình ảnh

**Content-Type**: `multipart/form-data`

**Form Data**:
- `file`: File (image/png)

**Response**:
```json
{
  "statusCode": 200,
  "data": {
    "url": "string",
    "fileName": "string"
  }
}
```

#### 2. Upload nhiều files
**POST** `/common/uploads`

**Mô tả**: Upload nhiều file hình ảnh cùng lúc

**Content-Type**: `multipart/form-data`

**Form Data**:
- `files`: File[] (image/png)

**Lưu ý**: Module HTDCT sử dụng endpoint `/common/upload` thay vì `/common/uploads`

#### 3. Tạo PDF
**POST** `/common/get-pdf`

**Mô tả**: Tạo file PDF từ báo cáo

**Body Parameters**:
```json
{
  "FormReportId": "string",
  "isGroup": "boolean"
}
```

**Response**:
```json
{
  "statusCode": 200,
  "data": "base64_string_or_url"
}
```

#### 4. Tạo PDF chứng từ
**POST** `/common/get-pdf-certificate`

**Mô tả**: Tạo file PDF cho chứng từ

**Body Parameters**:
```json
{
  "certificateId": "string"
}
```

-------------------------------------------------------

## Module HTLD

### Inspection (Phiếu Kiểm Tra)

#### 1. Danh sách phiếu kiểm tra
**GET** `/distributioninspect` | `/lineinspect` | `/immediaryinspect`

**Mô tả**: Lấy danh sách phiếu kiểm tra theo loại trạm

**Query Parameters**:
- `inspectionType`: Loại kiểm tra
- `inspectionStatus`: Trạng thái (0 = tất cả)
- `unitId`: Đơn vị (0 = tất cả)
- `fromDate`: Từ ngày
- `toDate`: Đến ngày
- `searchTerm`: Từ khóa tìm kiếm
- `orderBy`: Sắp xếp (ASC/DESC)
- `pageIndex`: Trang
- `pageSize`: Số bản ghi/trang
- `pageOffset`: Vị trí bắt đầu

**Endpoints theo loại**:
- Trạm phân phối: `/distributioninspect`
- Đường dây: `/lineinspect`
- Trạm trung gian: `/immediaryinspect`

#### 2. Chi tiết phiếu kiểm tra
**GET** `/distributioninspect/{ticketId}` | `/lineinspect/{ticketId}` | `/immediaryinspect/{ticketId}`

**Mô tả**: Lấy thông tin chi tiết phiếu kiểm tra

**Path Parameters**:
- `ticketId`: ID phiếu kiểm tra

#### 3. Tạo phiếu kiểm tra
**POST** `/distributioninspect` | `/immediaryinspect`

**Mô tả**: Tạo mới phiếu kiểm tra trạm

**Body Parameters**:
```json
{
  "weather": "string",
  "temperature": "string",
  "weather2": "string",
  "temperature2": "string",
  "equipments": [
    {
      "equipmentId": "string"
    }
  ]
}
```

#### 4. Cập nhật phiếu kiểm tra
**PUT** `/distributioninspect/{ticketId}` | `/immediaryinspect/{ticketId}`

**Mô tả**: Cập nhật thông tin chung phiếu kiểm tra

**Body Parameters**: (tương tự POST)

#### 5. Xóa phiếu kiểm tra
**DELETE** `/distributioninspect/{inspectionId}` | `/lineinspect/{inspectionId}` | `/immediaryinspect/{inspectionId}`

**Mô tả**: Xóa phiếu kiểm tra

#### 6. Hoàn thành phiếu kiểm tra
**POST** `/distributioninspect/{ticketId}/complete` | `/immediaryinspect/{ticketId}/complete`

**Mô tả**: Đánh dấu hoàn thành phiếu kiểm tra

**Body Parameters**: `{}`

#### 7. Hoàn thành phiếu đường dây
**PUT** `/lineinspect/{ticketId}/complete`

**Mô tả**: Hoàn thành phiếu kiểm tra đường dây

### Nội Dung Kiểm Tra - Trạm Phân Phối

#### 1. Lấy nội dung ban ngày
**GET** `/distributioninspect/{ticketId}/content/day-time`

**Mô tả**: Lấy nội dung kiểm tra ban ngày

#### 2. Cập nhật nội dung ban ngày
**PUT** `/distributioninspect/{ticketId}/content/day-time`

**Mô tả**: Cập nhật nội dung kiểm tra ban ngày

**Body Parameters**: Các trường động theo thiết bị

#### 3. Lấy nội dung ban đêm
**GET** `/distributioninspect/{ticketId}/content/night-time`

**Mô tả**: Lấy nội dung kiểm tra ban đêm

#### 4. Cập nhật nội dung ban đêm
**PUT** `/distributioninspect/{ticketId}/content/night-time`

**Mô tả**: Cập nhật nội dung kiểm tra ban đêm

#### 5. Lấy chi tiết thiết bị ban ngày
**GET** `/distributioninspect/{ticketId}/content/{endpoint}`

**Mô tả**: Lấy thông tin chi tiết thiết bị (popup)

**Query Parameters**:
- `equipmentId`: ID thiết bị

**Các endpoint thiết bị**:
- `substation-room`: Phòng trạm
- `substation`: Máy biến áp
- `cutting-machine`: Máy cắt
- `rmu`: RMU
- `breaker`: Aptomat
- `fall-off-fuses`: Cầu chì rơi
- `lightning-conductor`: Chống sét
- `low-pressure-cabinet`: Tủ hạ áp
- `low-voltage-capacito`: Tụ bù hạ áp
- `tu`: TU (biến dòng)
- `ti`: TI (biến áp đo lường)
- `distribution-power-cable`: Cáp điện lực
- `insulation`: Sứ cách điện
- `grounding-system`: Hệ thống tiếp địa
- `building-structure`: Kết cấu công trình

#### 6. Cập nhật thiết bị ban ngày
**PUT** `/distributioninspect/{ticketId}/content/{endpoint}`

**Mô tả**: Cập nhật thông tin thiết bị

**Body Parameters**: Dữ liệu JSON theo loại thiết bị

#### 7. Lấy chi tiết thiết bị ban đêm
**GET** `/distributioninspect/{ticketId}/content/night-time/{endpoint}`

**Query Parameters**:
- `equipmentId`: ID thiết bị

**Các endpoint ban đêm**:
- `substation-night-time`: Trạm ban đêm
- `joint-night-time`: Mối nối ban đêm
- `lighting-system-night-time`: Hệ thống chiếu sáng ban đêm

#### 8. Cập nhật thiết bị ban đêm
**PUT** `/distributioninspect/{ticketId}/content/night-time/{endpoint}`

#### 9. Hiện tượng bất thường
**GET** `/distributioninspect/{ticketId}/content/abnormal-phenomenon`

**Mô tả**: Lấy danh sách hiện tượng bất thường

**Response**:
```json
{
  "statusCode": 200,
  "data": ["string", "string"]
}
```

### Nội Dung Kiểm Tra - Trạm Trung Gian

#### 1. Lấy nội dung ban ngày
**GET** `/immediaryinspect/{ticketId}/content/day-time`

#### 2. Cập nhật nội dung ban ngày
**PUT** `/immediaryinspect/{ticketId}/content/day-time`

#### 3. Lấy nội dung ban đêm
**GET** `/immediaryinspect/{ticketId}/content/night-time`

#### 4. Cập nhật nội dung ban đêm
**PUT** `/immediaryinspect/{ticketId}/content/night-time`

#### 5. Lấy chi tiết thiết bị
**GET** `/immediaryinspect/{ticketId}/content/{endpoint}`

**Query Parameters**:
- `equipmentId`: ID thiết bị

**Các endpoint thiết bị**:
- `substation`: Máy biến áp
- `substation-room`: Phòng trạm
- `high-pressure-cable`: Cáp cao áp
- `low-pressure-cable`: Cáp hạ áp
- `one-way-system`: Hệ thống một chiều
- `alternating-current-system`: Hệ thống xoay chiều
- `battery`: Ắc quy
- `filling-cabinet`: Tủ đóng cắt
- `grounding-system`: Tiếp địa
- `measuring-system`: Hệ thống đo lường
- `electric-cabinet`: Tủ điện
- `clamp-row`: Hàng kẹp
- `joint`: Mối nối
- `resistance-temperature-detector`: Detector nhiệt độ
- `construction-structure`: Kết cấu công trình
- `station-cleaning`: Vệ sinh trạm
- `cutting-machine`: Máy cắt
- `recloser`: Recloser
- `disconnectors-switches`: Dao cách ly
- `cutter-lbs`: LBS
- `fall-of-fuse`: Cầu chì
- `variable-voltage`: Biến áp
- `current-transformer`: Biến dòng
- `lightning-conductor`: Chống sét
- `cable-head`: Đầu cáp
- `insulation`: Sứ cách điện

#### 6. Cập nhật thiết bị
**PUT** `/immediaryinspect/{ticketId}/content/{endpoint}`

#### 7. Lấy chi tiết ban đêm
**GET** `/immediaryinspect/{ticketId}/content-night-time/{endpoint}`

**Các endpoint ban đêm**:
- `joint-night-time`: Mối nối
- `substation-night-time`: Trạm
- `lighting-system-night-time`: Chiếu sáng

#### 8. Cập nhật ban đêm
**PUT** `/immediaryinspect/{ticketId}/content-night-time/{endpoint}`

### Nội Dung Kiểm Tra - Đường Dây

#### 1. Lấy chi tiết thiết bị
**GET** `/lineinspect/{ticketId}/{lineBranchInfo}/content/{endpoint}`

**Path Parameters**:
- `ticketId`: ID phiếu
- `lineBranchInfo`: Thông tin nhánh đường dây

**Query Parameters**:
- `equipmentId`: ID thiết bị

**Các endpoint thiết bị**:
- `line-pole`: Cột
- `line-capacitor`: Tụ bù
- `line-beam`: Dầm
- `cutting-machine`: Máy cắt
- `line-disconnectors-switch`: Dao cách ly
- `line-earthing`: Tiếp địa
- `line-fundament`: Móng
- `line-fuse-cut-out`: Cầu chì
- `line-insulation`: Sứ cách điện
- `line-lightning-arrester`: Chống sét
- `line-measure-the-boundary`: Đo biên
- `line-recloser`: Recloser
- `line-rod-gap`: Khe hở
- `line-wire`: Dây dẫn
- `underground-cable`: Cáp ngầm
- `line-breaker`: Aptomat
- `line-rmu`: RMU
- `line-ti`: TI
- `line-tu`: TU

#### 2. Cập nhật thiết bị
**PUT** `/lineinspect/{ticketId}/{lineBranchInfo}/content/{endpoint}`

### Kết Quả Kiểm Tra

#### 1. Lưu kết quả (trạm)
**PUT** `/distributioninspect/{ticketId}/result` | `/immediaryinspect/{ticketId}/result`

**Mô tả**: Lưu kết quả kiểm tra

**Body Parameters**: Dữ liệu kết quả

#### 2. Lưu kết quả đường dây
**POST** `/lineinspect/{ticketId}/result`

**Body Parameters**:
```json
{
  "settlementTime": "datetime"
}
```

#### 3. Lấy kết quả
**GET** `/distributioninspect/{ticketId}/result` | `/immediaryinspect/{ticketId}/result` | `/lineinspect/{ticketId}/result`

### Công Việc (Work)

#### 1. Danh sách công việc
**GET** `/work` | `/lineinspect/work`

**Mô tả**: Lấy danh sách công việc

**Query Parameters**:
- `WorkType`: Loại công việc
- `InspectType`: Loại kiểm tra (1: trạm, 2: đường dây)
- `unitId`: Đơn vị
- `userGroup`: Nhóm người dùng
- `workStatus`: Trạng thái công việc
- `SearchTerm`: Tìm kiếm
- `orderBy`: Sắp xếp
- `IsAbnormal`: Bất thường (true/false)
- `fromDate`: Từ ngày
- `toDate`: Đến ngày
- `pageIndex`: Trang
- `pageSize`: Kích thước trang
- `pageOffset`: Vị trí

**Endpoints**:
- Trạm: `/work`
- Đường dây: `/lineinspect/work`

### Quản Lý (Manager)

#### 1. Danh sách phiếu quản lý
**GET** `/manager`

**Mô tả**: Lấy danh sách phiếu cho quản lý

**Query Parameters**:
- `UnitId`: Đơn vị
- `InspectType`: Loại kiểm tra
- `InspectionType`: Loại
- `SearchTerm`: Tìm kiếm
- `FromDate`: Từ ngày
- `ToDate`: Đến ngày
- `InspectionStatus`: Trạng thái

#### 2. Xuất PDF
**GET** `/manager/{id}`

**Mô tả**: Xuất PDF báo cáo

**Query Parameters**:
- `InspectType`: Loại kiểm tra

**Response**: PDF URL hoặc base64 string

---

## Module HTDCT

### Công Việc (Work)

#### 1. Danh sách công việc
**GET** `/work`

**Mô tả**: Lấy danh sách kế hoạch kiểm tra/thử nghiệm

**Query Parameters**:
- `UserTeamIds`: ID nhóm
- `WorkType`: Loại công việc
- `UserGroupIds`: ID đội
- `WorkStatus`: Trạng thái
- `SearchTerm`: Tìm kiếm
- `OrderBy`: Sắp xếp
- `FromDate`: Từ ngày
- `LineOrSubstationIds`: ID đường dây/trạm
- `ToDate`: Đến ngày
- `PageIndex`: Trang
- `PageSize`: Kích thước trang
- `isPMIS`: PMIS (true/false)
- `HasAbnormal`: Có bất thường
- `InspectId`: ID kiểm tra
- `WorkId`: ID công việc
- `CreatedUserIds`: ID người tạo
- `ScheduleTypeId`: Loại lịch

#### 2. Công việc người dùng hiện tại
**GET** `/line/line-assign-current-user` | `/substation/substation-assign-current-user`

**Mô tả**: Lấy danh sách trạm/đường dây được giao

**Query Parameters**:
- `WorkType`: Loại công việc (default: '2')
- `PageSize`: Kích thước trang (default: '999')
- `PageIndex`: Trang (default: '1')

**Endpoints**:
- Đường dây: `/line/line-assign-current-user`
- Trạm: `/substation/substation-assign-current-user`

#### 3. Thiết bị theo danh mục
**GET** `/report/equipmentbycategory`

**Query Parameters**:
- `SubstationId`: ID trạm
- `Category`: Danh mục

#### 4. Danh mục theo trạm
**GET** `/work/listcategorybysubstation`

**Query Parameters**:
- `substationId`: ID trạm/đường dây
- `isNightTime`: Ban đêm (true/false)
- `isline`: Là đường dây (true/false)

#### 5. Danh mục theo node
**GET** `/abnormal/listcategorybynode`

**Query Parameters**:
- `Ids`: Danh sách ID nodes

#### 6. Thiết bị theo danh mục (sổ vận hành)
**GET** `/checkoperationnote/listequipmentbycategory`

**Query Parameters**:
- `SubstationId`: ID trạm (nếu là trạm)
- `LineId`: ID đường dây (nếu là đường dây)
- `Categories`: Danh mục (default: '4')

### Phiếu Kiểm Tra Trạm

#### 1. Tạo phiếu kiểm tra
**POST** `/substationinspect`

**Mô tả**: Tạo phiếu kiểm tra trạm

**Body Parameters**:
```json
{
  "type": "string",
  "workId": "string",
  "longitude": "number",
  "latitude": "number",
  "address": "string"
}
```

#### 2. Lấy thông tin chung
**GET** `/substationinspect/{ticketId}`

**Mô tả**: Lấy thông tin chung phiếu kiểm tra

#### 3. Cập nhật thiết bị
**PUT** `/substationinspect/{ticketId}/content/{endpoint}`

**Mô tả**: Cập nhật dữ liệu thiết bị

**Body Parameters**: Dữ liệu thiết bị động

#### 4. Lấy thông tin thiết bị
**GET** `/substationinspect/{ticketId}/content/{endpoint}`

**Query Parameters**:
- `equipmentId`: ID thiết bị

#### 5. Copy đường dây
**PUT** `/substationinspect/{ticketId}/content/{endpoint}/copy`

**Mô tả**: Copy dữ liệu từ đường dây khác

### Phiếu Kiểm Tra Đường Dây

#### 1. Danh sách node
**GET** `/lineinspect/listnodeinspect`

**Query Parameters**:
- `Id`: ID đường dây
- `LineInspectId`: ID phiếu (nếu update)
- `IsUnderSystem`: Dưới hệ thống (true/false)

#### 2. Xóa node
**DELETE** `/lineinspect/{idTicket}/node`

**Query Parameters**:
- `nodeId`: ID node cần xóa

#### 3. Thêm node
**POST** `/lineinspect/addnode`

**Body Parameters**:
```json
{
  "nodeId": "string",
  "lineInspectId": "string"
}
```

#### 4. Danh sách thiết bị theo nodes
**POST** `/lineinspect/listequipmentbynodes`

**Body Parameters**:
```json
{
  "workId": "string",
  "listNodes": ["string"],
  "pageIndex": "string",
  "pageSize": "string"
}
```

#### 5. Cập nhật node và thiết bị
**PUT** `/lineinspect/{ticketId}/update`

**Body Parameters**:
```json
{
  "id": "string",
  "nodes": [...],
  "lineInspectEquipments": [...],
  "address": "string"
}
```

#### 6. Tạo phiếu kiểm tra
**POST** `/lineinspect`

**Body Parameters**:
```json
{
  "inspectionType": "string",
  "nodes": ["string"],
  "lineInspectEquipments": [...],
  "workId": "string",
  "longitude": "number",
  "latitude": "number",
  "address": "string"
}
```

#### 7. Lấy thông tin chung
**GET** `/lineinspect/{idTicket}`

#### 8. Lấy thông tin test chung
**GET** `/lineinspect/{ticketId}/generaltest`

**Mô tả**: Lấy thông tin test tổng quát đường dây

#### 9. Cập nhật thông tin test chung
**POST** `/lineinspect/generaltest`

**Body Parameters**: Dữ liệu test

### Vi Phạm Đường Dây

#### 1. Tạo vi phạm
**POST** `/lineinspect/violate`

**Body Parameters**: Thông tin vi phạm

#### 2. Cập nhật vi phạm
**PUT** `/lineinspect/{idTicket}/updateviolate`

**Body Parameters**: Thông tin vi phạm

#### 3. Danh sách vi phạm
**GET** `/lineinspect/listviolate`

**Query Parameters**:
- `Id`: ID phiếu
- `TypeViolation`: Loại vi phạm
- `FromDate`: Từ ngày
- `ToDate`: Đến ngày
- `PageIndex`: Trang
- `SearchTerm`: Tìm kiếm

#### 4. Chi tiết vi phạm
**GET** `/lineinspect/{id}/violatedetail`

#### 5. Xóa vi phạm
**DELETE** `/lineinspect/{id}/deleteviolate`

#### 6. Danh sách lựa chọn bất thường
**GET** `/lineinspect/violate`

**Query Parameters**:
- `typeViolation`: Loại vi phạm

#### 7. Thêm lựa chọn bất thường
**POST** `/lineinspect/new-violate`

**Body Parameters**:
```json
{
  "name": "string",
  "typeViolation": "string"
}
```

### Nội Dung Ban Đêm

#### 1. Lấy nội dung ban đêm
**GET** `/lineinspect/{id}/content/night-time`

#### 2. Cập nhật nội dung ban đêm
**PUT** `/lineinspect/{idTicket}/content/night-time`

### Copy Đường Dây Giống Nhau

#### 1. Copy từ đường dây
**POST** `/lineinspect/equipment/copysameline`

**Body Parameters**: Thông tin đường dây nguồn

### Quản Lý Đường Dây

#### 1. Phiếu kiểm tra theo đường dây
**GET** `/lineinspect/inspect-by-line/{lineId}`

**Query Parameters**:
- `lineId`: ID đường dây

#### 2. Tất cả đường dây
**GET** `/line/get-all`

### Phiếu Không PMIS

#### 1. Tạo phiếu không PMIS
**POST** `/nonpmisinspect`

**Body Parameters**:
```json
{
  "workId": "string",
  "longitude": "number",
  "latitude": "number",
  "address": "string"
}
```

### User Management

#### 1. Thông tin người dùng
**GET** `/user/profile`

**Mô tả**: Lấy thông tin profile người dùng

#### 2. Danh sách đường dây/trạm
**GET** `/checknote/substation-or-line`

**Query Parameters**:
- `Type`: Loại (1: trạm, 2: đường dây)

#### 3. Danh sách nhóm
**GET** `/usergroup/x6`

**Query Parameters**:
- `PageSize`: Kích thước trang (default: '999')
- `PageIndex`: Trang (default: '1')

#### 4. Danh sách đội theo nhóm
**GET** `/userteam/get-team-by-usergroup`

**Query Parameters**:
- `UserGroupIds`: ID nhóm
- `PageSize`: Kích thước trang
- `PageIndex`: Trang

#### 5. Danh sách đơn vị
**GET** `/report/units`

#### 6. Danh sách đơn vị X6
**GET** `/unit`

#### 7. Danh sách người dùng
**GET** `/user/getuserlist`

---

## Module QLTNKD

### Báo Cáo (Form Report)

#### 1. Danh sách báo cáo
**GET** `/formreport`

**Mô tả**: Lấy danh sách báo cáo nghiệm thu

**Query Parameters**:
- `searchTerm`: Tìm kiếm
- `fromDate`: Từ ngày
- `toDate`: Đến ngày
- `location`: Vị trí (0 = tất cả)
- `content`: Nội dung
- `teamId`: ID đội (0 = tất cả)
- `userId`: ID người dùng (0 = tất cả)
- `departmentId`: ID phòng ban (0 = tất cả)
- `status`: Trạng thái (0 = tất cả)
- `pageIndex`: Trang
- `orderByDesc`: Sắp xếp giảm
- `orderBy`: Sắp xếp (default: 'descend')
- `ScheduleType`: Loại lịch (0 = tất cả)
- `pageSize`: Kích thước trang
- `pageOffset`: Vị trí

#### 2. Chi tiết form báo cáo
**GET** `/formreport/{id}`

**Mô tả**: Lấy chi tiết form báo cáo để điền

#### 3. Thông tin báo cáo
**GET** `/formreport/info/{reportId}`

**Mô tả**: Lấy thông tin meta của báo cáo

#### 4. Tạo báo cáo từ công việc
**POST** `/formreport`

**Body Parameters**:
```json
{
  "formId": "string",
  "scheduleId": "string"
}
```

#### 5. Cập nhật báo cáo
**PUT** `/formreport`

**Body Parameters**:
```json
{
  "formReportId": "string",
  "fieldValues": {...}
}
```

#### 6. Tạo báo cáo ngoài kế hoạch
**POST** `/formreport/unscheduled-report`

**Body Parameters**:
```json
{
  "workType": "string",
  "unitId": "string",
  "equipmentTypeId": "string",
  "equipmentDetailId": "string",
  "userId": "string",
  "teamId": "string",
  "departmentId": "string",
  "createdDate": "string",
  "location": "string",
  "note": "string"
}
```

#### 7. Dữ liệu báo cáo ngoài kế hoạch
**GET** `/formreport/unscheduled-report/data`

**Mô tả**: Lấy dữ liệu cần thiết để tạo báo cáo ngoài kế hoạch

#### 8. Danh sách form copy
**GET** `/formreport/formreport-copy-paging`

**Query Parameters**:
- `ScheduleId`: ID lịch
- `EquipmentDetailId`: ID chi tiết thiết bị
- `SearchTerm`: Tìm kiếm
- `orderBy`: Sắp xếp
- `pageIndex`: Trang
- `pageSize`: Kích thước trang

#### 9. Thêm dữ liệu chung
**POST** `/formreport/general-data`

**Body Parameters**:
```json
{
  "name": "string",
  "type": "string",
  "formId": "string"
}
```

### Phê Duyệt Báo Cáo

#### 1. Gửi phê duyệt
**POST** `/formreport/send`

**Mô tả**: Gửi báo cáo lên cấp trên phê duyệt

**Body Parameters**:
```json
{
  "note": "string",
  "ids": ["string"]
}
```

#### 2. Chấp nhận
**POST** `/formreport/accept`

**Mô tả**: Phê duyệt chấp nhận báo cáo

**Body Parameters**:
```json
{
  "note": "string",
  "ids": ["string"]
}
```

#### 3. Từ chối
**POST** `/formreport/reject`

**Body Parameters**:
```json
{
  "note": "string",
  "ids": ["string"]
}
```

#### 4. Lịch sử phê duyệt
**GET** `/formreport/approvalhistory`

**Query Parameters**:
- `formReportId`: ID báo cáo
- `pageIndex`: Trang
- `pageSize`: Kích thước trang

#### 5. Ký số
**GET** `/formreport/digitalsign`

**Query Parameters**:
- `formReportId`: ID báo cáo

### Phê Duyệt Vận Hành

#### 1. Gửi vận hành
**POST** `/formreport/operation-send`

**Body Parameters**:
```json
{
  "formReportId": "string",
  "note": "string",
  "approveId": "string"
}
```

#### 2. Chấp nhận vận hành
**POST** `/formreport/operation-accept`

**Body Parameters**:
```json
{
  "id": "string",
  "note": "string"
}
```

#### 3. Từ chối vận hành
**POST** `/formreport/operation-reject`

**Body Parameters**:
```json
{
  "id": "string",
  "note": "string"
}
```

#### 4. Vai trò vận hành
**GET** `/user/role-operation-approve`

**Mô tả**: Lấy danh sách vai trò có quyền phê duyệt vận hành

### Phê Duyệt Leader

#### 1. Chấp nhận (Leader)
**POST** `/formreport/leader-accept`

**Body Parameters**:
```json
{
  "note": "string",
  "ids": ["string"]
}
```

#### 2. Từ chối (Leader)
**POST** `/formreport/leader-reject`

**Body Parameters**:
```json
{
  "note": "string",
  "ids": ["string"]
}
```

### Vị Trí Báo Cáo

#### 1. Gửi vị trí
**POST** `/formreport/location`

**Body Parameters**:
```json
{
  "id": "string",
  "longitude": "number",
  "latitude": "number"
}
```

#### 2. Lấy vị trí báo cáo
**GET** `/formreport/{reportId}/location`

### Danh Sách Tham Chiếu

#### 1. Danh sách đơn vị
**GET** `/unit/units`

**Query Parameters**:
- `pageSize`: Kích thước trang (default: '99')

#### 2. Loại lịch
**GET** `/productionplan/schedule-type`

**Query Parameters**:
- `pageSize`: Kích thước trang

#### 3. Danh sách phòng ban
**GET** `/department`

**Query Parameters**:
- `pageSize`: Kích thước trang

#### 4. Danh sách đội
**GET** `/team/teams`

**Query Parameters**:
- `DepartmentId`: ID phòng ban

#### 5. Danh sách người dùng theo đội
**GET** `/team/list-user`

**Query Parameters**:
- `teamId`: ID đội

#### 6. Danh sách chủ tịch trung tâm
**GET** `/mergeformreport/president-center`

#### 7. Danh sách chủ tịch công ty
**GET** `/user`

**Query Parameters**:
- `UserPosition`: Vị trí người dùng
- `pageSize`: Kích thước trang

#### 8. Danh sách trạm
**GET** `/formreport/substations`

**Query Parameters**:
- `userId`: ID người dùng

### Công Việc (Individual Job)

#### 1. Danh sách công việc cá nhân
**GET** `/individualjob`

**Query Parameters**:
- `UnitId`: ID đơn vị (0 = tất cả)
- `EquipmentName`: Tên thiết bị
- `SearchTerm`: Tìm kiếm
- `EquipmentTypeId`: Loại thiết bị (0 = tất cả)
- `EquipmentDetailId`: Chi tiết thiết bị (0 = tất cả)
- `WorkProgress`: Tiến độ (0 = tất cả)
- `ReportNumber`: Số báo cáo
- `StampNumber`: Số tem
- `WorkType`: Loại công việc (0 = tất cả)
- `FromDate`: Từ ngày
- `ToDate`: Đến ngày
- `orderBy`: Sắp xếp
- `IsPaperFormReport`: Báo cáo giấy (true/false)
- `pageIndex`: Trang
- `pageSize`: Kích thước trang (default: '40')

#### 2. Chi tiết công việc
**GET** `/individualjob/{workId}`

### Chứng Từ (Certificate)

#### 1. Danh sách chứng từ
**GET** `/certificate`

**Query Parameters**:
- `status`: Trạng thái (0 = tất cả)
- `certificateType`: Loại chứng từ (0 = tất cả)
- `teamId`: ID đội (0 = tất cả)
- `departmentId`: ID phòng ban (0 = tất cả)
- `userImp`: Người thực hiện (0 = tất cả)
- `fromDate`: Từ ngày
- `toDate`: Đến ngày
- `content`: Nội dung
- `location`: Vị trí (0 = tất cả)
- `workType`: Loại công việc (0 = tất cả)
- `unitId`: ID đơn vị (0 = tất cả)
- `searchTerm`: Tìm kiếm
- `pageSize`: Kích thước trang
- `pageIndex`: Trang

#### 2. Tạo chứng từ
**POST** `/certificate`

**Body Parameters**:
```json
{
  "formReportId": "string",
  "type": "string"
}
```

#### 3. Lịch sử phê duyệt chứng từ
**GET** `/certificate/approvalhistory`

**Query Parameters**:
- `CertificateId`: ID chứng từ
- `pageIndex`: Trang
- `pageSize`: Kích thước trang

#### 4. Phê duyệt chứng từ
**POST** `/certificate/send` | `/certificate/accept` | `/certificate/reject`

**Body Parameters**:
```json
{
  "note": "string",
  "ids": ["string"]
}
```

**Endpoints**:
- `send`: Gửi phê duyệt
- `accept`: Chấp nhận
- `reject`: Từ chối

#### 5. Ký số chứng từ
**GET** `/certificate/digitalsign`

**Query Parameters**:
- `certificateId`: ID chứng từ

### Khối Lượng Công Việc (Workload)

#### 1. Danh sách xác nhận khối lượng
**GET** `/confirmmassscene`

**Query Parameters**:
- `UnitId`: ID đơn vị (0 = tất cả)
- `RequestType`: Loại yêu cầu (0 = tất cả)
- `FromDate`: Từ ngày
- `ToDate`: Đến ngày
- `orderBy`: Sắp xếp
- `SearchTerm`: Tìm kiếm
- `pageIndex`: Trang
- `pageSize`: Kích thước trang
- `Status`: Trạng thái (optional)

#### 2. Danh sách yêu cầu
**GET** `/confirmmassscene/request`

**Query Parameters**: (tương tự danh sách xác nhận)

#### 3. Danh sách công việc theo yêu cầu
**GET** `/confirmmassscene/works`

**Query Parameters**:
- `RequestId`: ID yêu cầu
- `PageSize`: Kích thước trang (default: '999')
- `FromDate`: Từ ngày
- `ToDate`: Đến ngày

#### 4. Chi tiết khối lượng
**GET** `/confirmmassscene/{workloadId}`

**Query Parameters**:
- `fromDate`: Từ ngày
- `toDate`: Đến ngày

#### 5. Tạo yêu cầu khối lượng
**POST** `/confirmmassscene`

**Body Parameters**: WorkloadRequestModel (dữ liệu phức tạp)

#### 6. Cập nhật khối lượng
**PUT** `/confirmmassscene/{workloadId}`

**Body Parameters**: WorkloadRequestModel

#### 7. Gửi xác nhận
**PUT** `/confirmmassscene/send/{workloadId}`

**Body Parameters**: `{}`

#### 8. Phê duyệt khối lượng
**PUT** `/confirmmassscene/confirm`

**Body Parameters**:
```json
{
  "ids": "string (comma separated)"
}
```

#### 9. Từ chối khối lượng
**PUT** `/confirmmassscene/reject`

**Body Parameters**:
```json
{
  "ids": "string (comma separated)"
}
```

#### 10. Xóa yêu cầu
**DELETE** `/confirmmassscene/{id}`

#### 11. Xuất PDF khối lượng
**GET** `/confirmmassscene/pdf`

**Query Parameters**:
- `Id`: ID khối lượng

### Báo Cáo Gộp (Merge Form Report)

#### 1. Chi tiết công việc gộp
**GET** `/mergeformreport/{workId}`

#### 2. Danh sách báo cáo gộp
**GET** `/mergeformreport/{endPoint}`

**Path Parameters**:
- `endPoint`: Endpoint động

**Query Parameters**:
- `UnitId`: ID đơn vị (0 = tất cả)
- `SearchTerm`: Tìm kiếm
- `FromDate`: Từ ngày
- `ToDate`: Đến ngày
- `orderBy`: Sắp xếp
- `pageIndex`: Trang
- `pageSize`: Kích thước trang

---

## Lưu Ý Chung

### HTTP Methods
- **GET**: Lấy dữ liệu
- **POST**: Tạo mới
- **PUT**: Cập nhật
- **DELETE**: Xóa

### Response Format
Tất cả API đều trả về format:
```json
{
  "statusCode": "number",
  "message": "string",
  "data": "any"
}
```

### Status Codes
- `200`: Thành công
- `400`: Bad Request
- `401`: Unauthorized (token hết hạn/không hợp lệ)
- `403`: Forbidden (không có quyền)
- `500`: Server Error

### Error Codes (Custom)
- `700`: Không có kết nối Internet
- `504`: Timeout
- `999`: Lỗi parse response
- `10000`: Lỗi chung

### Authentication
Hầu hết các API đều yêu cầu authentication. Token được gửi qua header:
```
Authorization: Bearer {token}
```

Token lấy từ API đăng nhập và được lưu trong `AppShared.instance.getUserToken()`

### Background Mode
Nhiều API hỗ trợ tham số `backgroundMode`:
- `true`: Không hiển thị loading indicator
- `false`: Hiển thị loading indicator (default)

### Pagination
Các API danh sách thường hỗ trợ phân trang:
- `pageIndex`: Trang hiện tại (bắt đầu từ 1)
- `pageSize`: Số bản ghi mỗi trang
- `pageOffset`: Vị trí bắt đầu

Response pagination:
```json
{
  "data": {
    "paging": {
      "currentPage": 1,
      "totalPages": 10,
      "totalRecords": 100,
      "pageSize": 10
    },
    "list": [...]
  }
}
```

### Date Format
Các trường ngày tháng thường sử dụng format ISO 8601:
```
YYYY-MM-DDTHH:mm:ss
```

### File Upload
Upload file sử dụng `multipart/form-data`:
- Single file: field name `file`
- Multiple files: field name `files`
- Content-Type: `image/png`

---

## Changelog

**Version 1.0** - 2025-01-22
- Tài liệu API ban đầu
- Bao gồm 3 modules: HTLD, HTDCT, QLTNKD
- API chung: Authentication, File Upload
