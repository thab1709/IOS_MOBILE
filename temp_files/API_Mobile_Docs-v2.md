# API Biên Bản Khảo Sát (BBKS) — Tài liệu Mobile

**Base URL:** `https://<host>/api/survey-report`  
**Auth:** `Authorization: Bearer <JWT>`  
**Response wrapper:** `{ "data": ..., "paging": ..., "success": true }`  
**Cập nhật:** 2026-07-29

## 🔄 Luồng ký duyệt

**Tạo mới (Status=1: Mới)**
  ↓ Upload file Word  →  `POST /{id}/upload`
  ↓ Gửi duyệt         →  `POST /{id}/send`         → Status=2 (Chờ xác nhận)
  ↓ Nhóm 1 ký         →  `POST /approve`           (Đơn vị công tác — isMyTurn=true)
  ↓ Thu ký ngoài EVN  →  `POST /{id}/external-sign` (sau khi nhóm 1 xong)
  ↓ Nhóm 2 ký         →  `POST /approve`           (Đơn vị QLVH — isMyTurn=true)
  → Status=3 (Đã xác nhận)

---

## 📋 Danh sách API

| # | Method | Endpoint | Mô tả |
|---|--------|----------|-------|
| 1 | GET | `/api/survey-report` | Danh sách phân trang |
| 2 | GET | `/api/survey-report/{id}` | Chi tiết BBKS |
| 3 | POST | `/api/survey-report` | Tạo mới |
| 4 | PUT | `/api/survey-report/{id}` | Cập nhật |
| 5 | DELETE | `/api/survey-report/{id}` | Xóa |
| 6 | POST | `/api/survey-report/{id}/upload` | Upload file Word |
| 7 | POST | `/api/survey-report/{id}/send` | Gửi duyệt |
| 8 | POST | `/api/survey-report/approve` | Ký duyệt (hàng loạt) |
| 9 | POST | `/api/survey-report/reject` | Từ chối (hàng loạt) |
| 10| POST | `/api/survey-report/{id}/external-sign` | Thu chữ ký tay ngoài EVN ⭐ |
| 11| GET | `/api/survey-report/{id}/pdf` | Stream xem PDF |
| 12| GET | `/api/survey-report/{id}/download-word` | Tải file Word đã upload |
| 13| GET | `/api/survey-report/{id}/history` | Lịch sử phê duyệt |
| 14| POST | `/api/survey-report/upload-attachment` | Upload tài liệu đính kèm |
| 15| DELETE | `/api/survey-report/attachment/{id}` | Xóa tài liệu đính kèm |

---

### 1. Danh sách BBKS phân trang
`GET /api/survey-report`

**Query Parameters**

| Tham số | Kiểu | Bắt buộc | Mô tả |
|---------|------|----------|-------|
| pageIndex | int | ✅ | Trang hiện tại (bắt đầu từ 1) |
| pageSize | int | ✅ | Số bản ghi mỗi trang |
| searchTerm | string | ❌ | Tìm theo mã / tên / công trình |
| status | int | ❌ | 1=Mới, 2=Chờ XN, 3=Đã XN, 4=Từ chối |
| fromDate | datetime | ❌ | Ngày lập từ (ISO 8601) |
| toDate | datetime | ❌ | Ngày lập đến |
| confirmDateFrom | datetime | ❌ | Ngày xác nhận từ |
| confirmDateTo | datetime | ❌ | Ngày xác nhận đến |
| constructionId | guid | ❌ | Lọc theo công trình |
| qlvhUnitId | guid | ❌ | Lọc theo đơn vị QLVH |
| hasPatc | bool | ❌ | Lọc có/không có PATC |
| isAll | bool | ❌ | `true` = xem tất cả (admin). Mặc định `false` = chỉ xem liên quan mình |

**Response — mỗi item trong `data[]`**
```json
{
  "id": "guid",
  "code": "BBKS-22",
  "name": "Tên biên bản",
  "constructionId": "guid",
  "constructionName": "Tên công trình",
  "reportDate": "2026-07-29T00:00:00",
  "status": 2,
  "statusName": "Chờ xác nhận",
  "qlvhUnitId": "guid",
  "qlvhUnitName": "HN08 - Sóc Sơn",
  "createdBy": "guid",
  "createdByName": "Phạm Quang Huy",
  "isFileValid": true,
  "filePath": "url",
  "basePdfPath": "url",
  "signedFilePath": "url",
  "isMyTurn": true,
  "currentSignGroupType": 1,
  "currentSignGroupName": "Đơn vị công tác",
  "isAllowEdit": false,
  "isAllowDelete": false,
  "isAllowSend": false,
  "isAllowApprove": true,
  "isAllowReject": true,
  "hasPatc": false,
  "patcId": null
}
```
*Mobile dùng `isMyTurn` để hiện/ẩn nút "Ký duyệt"*

### 2. Chi tiết BBKS
`GET /api/survey-report/{id}`

**Path Params**

| Tham số | Kiểu | Mô tả |
|---------|------|-------|
| id | guid | ID của BBKS |

**Response `data`**
```json
{
  "id": "guid",
  "code": "BBKS-22",
  "name": "Tên biên bản",
  "constructionId": "guid",
  "constructionName": "Tên công trình",
  "reportDate": "2026-07-29T00:00:00",
  "note": "Ghi chú",
  "status": 2,
  "statusName": "Chờ xác nhận",
  "qlvhUnitId": "guid",
  "qlvhUnitName": "HN08 - Sóc Sơn",
  "filePath": "url_word",
  "fileName": "BienBan.docx",
  "basePdfPath": "url_pdf_goc",
  "signedFilePath": "url_pdf_da_ky",
  "isFileValid": true,
  "createdBy": "guid",
  "createdByName": "Nguyễn Văn A",
  "isAllowEdit": false,
  "isAllowDelete": false,
  "isAllowSend": false,
  "isAllowApprove": true,
  "isAllowReject": true,
  "isMyTurn": true,
  "currentSignGroupType": 1,
  "currentSignGroupName": "Đơn vị công tác",
  "confirmDate": null,
  "confirmBy": null,
  "confirmById": null,
  "participants": [
    {
      "id": "guid",
      "groupType": 1,
      "unitId": "guid",
      "unitName": "X05 - Công ty Thí nghiệm điện",
      "userId": "guid",
      "fullName": "Nguyễn Thu Trang",
      "position": "Kiểm định viên",
      "sortOrder": 1,
      "isSigned": false,
      "signedDate": null,
      "isExternal": false,
      "signatureImagePath": null,
      "signatureCapturedByName": null
    },
    {
      "id": "guid",
      "groupType": 3,
      "unitId": null,
      "unitName": "GHD Vietnam",
      "userId": null,
      "fullName": "Nguyễn Văn Đức",
      "position": "Kỹ sư",
      "sortOrder": 1,
      "isSigned": false,
      "signedDate": null,
      "isExternal": true,
      "signatureImagePath": null,
      "signatureCapturedByName": null
    }
  ],
  "attachments": [
    {
      "id": "guid",
      "fileName": "PYC-TCT.pdf",
      "fileUrl": "url"
    }
  ]
}
```

### 3. Tạo mới BBKS
`POST /api/survey-report`  
`Content-Type: application/json`

**Request Body**
```json
{
  "code": "BBKS-22",
  "name": "Tên biên bản khảo sát",
  "constructionId": "guid",
  "reportDate": "2026-07-29T00:00:00",
  "note": "Ghi chú (tuỳ chọn)",
  "qlvhUnitId": "guid hoặc null",
  "qlvhUnitName": "HN08 - Sóc Sơn",
  "participants": [
    {
      "groupType": 1,
      "unitId": "guid",
      "unitName": "X05 - Công ty Thí nghiệm điện",
      "userId": "guid",
      "fullName": "Nguyễn Thu Trang",
      "position": "Kiểm định viên",
      "isExternal": false
    },
    {
      "groupType": 3,
      "unitId": null,
      "unitName": "GHD Vietnam",
      "userId": null,
      "fullName": "Nguyễn Văn Đức",
      "position": "Kỹ sư",
      "isExternal": true
    },
    {
      "groupType": 2,
      "unitId": "guid",
      "unitName": "HN08 - Sóc Sơn",
      "userId": "guid",
      "fullName": "Trần Minh Hoàng",
      "position": "Trưởng phòng",
      "isExternal": false
    }
  ]
}
```
**Validate BE:**
- `groupType 1` (Đơn vị công tác): bắt buộc ≥ 1 người
- `groupType 2` (QLVH): bắt buộc ≥ 1 người
- `isExternal=true`: chỉ hợp lệ với `groupType=3`; `unitId`/`userId` phải null; `unitName`/`fullName`/`position` required
- `reportDate`: chỉ nhận ngày hiện tại hoặc quá khứ

**Response**
```json
{ "data": "guid-cua-bbks-moi-tao" }
```

### 4. Cập nhật BBKS
`PUT /api/survey-report/{id}`  
`Content-Type: application/json`

Body giống **Tạo mới** (#3). Chỉ cho phép khi `status = 1` (Mới) hoặc `4` (Từ chối).

**Response**
```json
{ "data": "guid" }
```

### 5. Xóa BBKS
`DELETE /api/survey-report/{id}`

Chỉ xóa được khi `status = 1` (Mới) và là người lập.

### 6. Upload file Word biên bản
`POST /api/survey-report/{id}/upload`  
`Content-Type: multipart/form-data`

| Field | Kiểu | Bắt buộc | Mô tả |
|-------|------|----------|-------|
| file | file | ✅ | File Word (.docx) |

*Hệ thống tự động chèn bảng ký vào cuối file và convert sang PDF. Sau khi upload thành công → `isFileValid = true` → mới được gửi duyệt.*

**Response**
```json
{ "data": "url_file_da_upload" }
```

### 7. Gửi duyệt
`POST /api/survey-report/{id}/send`  
`Content-Type: application/json`

**Request Body**
```json
{
  "note": "Ghi chú khi gửi (tuỳ chọn)"
}
```
**Điều kiện:** `status=1` (Mới) VÀ `isFileValid=true`  
**Chuyển status:** `1 → 2` (Chờ xác nhận)

**Response**
```json
{ "data": "guid" }
```

### 8. Ký duyệt
`POST /api/survey-report/approve`  
`Content-Type: application/json`

**Request Body**
```json
{
  "ids": ["guid-bbks-1", "guid-bbks-2"]
}
```
- Hỗ trợ ký hàng loạt
- Chỉ ký được khi `isMyTurn = true`
- Sau khi tất cả participant (non-external) ký xong → status tự động → `3` (Đã xác nhận)

**Response**
```json
{ "data": ["guid-bbks-da-ky-1", "guid-bbks-da-ky-2"] }
```

### 9. Từ chối duyệt
`POST /api/survey-report/reject`  
`Content-Type: application/json`

**Request Body**
```json
{
  "ids": ["guid-bbks-1"],
  "note": "Lý do từ chối (bắt buộc)"
}
```
Hỗ trợ từ chối hàng loạt. Chỉ từ chối được khi `isMyTurn = true`.

**Response**
```json
{ "data": ["guid-bbks-da-tu-choi"] }
```

### 10. Thu chữ ký tay người ngoài EVN ⭐
`POST /api/survey-report/{id}/external-sign`  
`Content-Type: multipart/form-data`

**Path Params**

| Tham số | Kiểu | Mô tả |
|---------|------|-------|
| id | guid | ID của BBKS |

**Form Fields**

| Field | Kiểu | Bắt buộc | Mô tả |
|-------|------|----------|-------|
| participantId | guid | ✅ | ID của participant `isExternal=true` cần thu chữ ký (lấy từ `participants[].id` trong API chi tiết) |
| signatureImage | file | ✅ | Ảnh chữ ký tay (.png / .jpg / .jpeg, ≤ 2MB) |

**Điều kiện:**
- BBKS phải có `status = 2` (Chờ xác nhận)
- Caller phải là participant nhóm Đơn vị công tác (`groupType=1`) của BBKS HOẶC người lập BBKS
- Tất cả participant non-external có priority thấp hơn OtherUnit phải đã ký xong (Đơn vị công tác đã ký đủ)
- Participant được chọn phải có `isExternal=true` và `isSigned=false`

**Response**
```json
{ "data": "url-anh-chu-ky-da-luu" }
```

### 11. Xem PDF (stream)
`GET /api/survey-report/{id}/pdf`

Trả về file `application/pdf` stream trực tiếp.
- Nếu đã có chữ ký (`signedFilePath`) → trả file đã ký
- Chưa có → trả file PDF gốc (`basePdfPath`)

### 12. Tải file Word đã upload
`GET /api/survey-report/{id}/download-word`

Trả về file `.docx` — `Content-Disposition: attachment; filename="<tên file gốc>"`

### 13. Lịch sử phê duyệt
`GET /api/survey-report/{id}/history`

**Response `data[]`**
```json
[
  {
    "id": "guid",
    "surveyReportId": "guid",
    "action": 1,
    "actionName": "Ký duyệt biên bản",
    "actionBy": "Nguyễn Thu Trang - X05",
    "actionById": "guid",
    "actionDate": "2026-07-29T10:30:00",
    "note": "Ký duyệt bởi Nguyễn Thu Trang",
    "nextSigners": "Trần Minh Hoàng"
  }
]
```

### 14. Upload tài liệu đính kèm
`POST /api/survey-report/upload-attachment`  
`Content-Type: multipart/form-data`

| Field | Kiểu | Bắt buộc | Mô tả |
|-------|------|----------|-------|
| surveyReportId | guid | ✅ | ID của BBKS |
| file | file | ✅ | Bất kỳ định dạng |

**Response**
```json
{ "data": { "id": "guid", "fileName": "...", "fileUrl": "url" } }
```

### 15. Xóa tài liệu đính kèm
`DELETE /api/survey-report/attachment/{id}`

| Tham số | Kiểu | Mô tả |
|---------|------|-------|
| id | guid | ID của attachment (lấy từ `attachments[].id` trong API chi tiết) |

---

## 📊 Enum Reference

### Status (Trạng thái BBKS)
| Giá trị | Tên hiển thị | Mô tả |
|---------|--------------|-------|
| 1 | Mới | Vừa tạo, chưa gửi duyệt |
| 2 | Chờ xác nhận | Đang trong luồng ký |
| 3 | Đã xác nhận | Tất cả đã ký xong |
| 4 | Từ chối | Bị từ chối, cần chỉnh sửa |

### GroupType (Nhóm participant)
| Giá trị | Tên nhóm | Thứ tự ký | Ghi chú |
|---------|----------|-----------|---------|
| 1 | Đơn vị công tác | 1 — ký đầu tiên | Bắt buộc ≥ 1 người |
| 3 | Đơn vị liên quan khác | 2 — sau nhóm 1 | Tuỳ chọn; có thể mix EVN + ngoài EVN |
| 2 | Đơn vị QLVH | 3 — ký cuối cùng | Bắt buộc ≥ 1 người |

### IsExternal (Loại người ký)
| Giá trị | Cơ chế ký |
|---------|-----------|
| false | Người EVN — ký qua tài khoản, dùng API `/approve` |
| true | Người ngoài EVN — thu chữ ký tay qua API `/external-sign` |

### Action (Lịch sử)
| Giá trị | Tên |
|---------|-----|
| 1 | Gửi duyệt |
| 2 | Ký duyệt |
| 3 | Từ chối |
| 7 | Ký tay (ngoài EVN) |

---

## 🔑 Fields quan trọng cho Mobile

**Danh sách (paging item)**
| Field | Dùng để |
|-------|---------|
| `isMyTurn` | Hiện/ẩn nút Ký duyệt / Từ chối |
| `currentSignGroupType` | Hiển thị "Đang chờ nhóm X ký" |
| `isFileValid` | Kiểm tra có thể gửi duyệt chưa |
| `basePdfPath` | URL xem PDF gốc |
| `signedFilePath` | URL xem PDF đã có chữ ký |
| `isAllowApprove` | Có quyền duyệt không |

**Participant (trong chi tiết)**
| Field | Dùng để |
|-------|---------|
| `isExternal` | Phân biệt thu chữ ký tay vs ký tài khoản |
| `isSigned` | Trạng thái đã ký chưa |
| `signedDate` | Ngày ký |
| `signatureImagePath` | URL ảnh chữ ký tay (nếu đã thu) |
| `signatureCapturedByName` | Tên người đã thu chữ ký hộ |


---
---


# PATC (Phương án thi công) — Mobile API Reference

**Base URL:** `{host}/api/constructionplan`  
**Auth:** Bearer Token (header `Authorization: Bearer {token}`)  
*Các endpoint `[AllowAnonymous]` không cần token.*

### 1. Lấy danh sách PATC (phân trang)
`GET /api/constructionplan`

**Query Params**

| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| searchTerm | string | ❌ | Tìm kiếm theo mã / tên |
| constructionId | Guid | ❌ | Lọc theo công trình |
| qlvhUnitId | Guid | ❌ | Lọc theo đơn vị QLVH |
| status | int | ❌ | Trạng thái: 0=Mới, 1=Chờ XN, 2=Đã XN, 3=Từ chối |
| fromDate | DateTime | ❌ | Ngày lập từ |
| toDate | DateTime | ❌ | Ngày lập đến |
| fromConfirmDate | DateTime | ❌ | Ngày xác nhận từ |
| toConfirmDate | DateTime | ❌ | Ngày xác nhận đến |
| pageIndex | int | ❌ | Trang hiện tại (mặc định 1) |
| pageSize | int | ❌ | Số bản ghi/trang (mặc định 10) |

**Response**
```json
{
  "data": [
    {
      "id": "guid",
      "code": "PATC-001",
      "name": "Tên PATC",
      "constructionId": "guid",
      "constructionName": "Tên công trình",
      "createdBy": "guid",
      "createdByName": "Nguyễn Văn A",
      "qlvhUnitName": "HN08 - Sóc Sơn",
      "reportDate": "2025-07-29T00:00:00",
      "confirmDate": "2025-07-30T00:00:00",
      "confirmBy": "Trần Văn B",
      "status": 1,
      "statusName": "Chờ xác nhận",
      "filePath": "http://...",
      "basePdfPath": "http://...",
      "signedFilePath": "http://...",
      "nextSignerId": "guid",
      "nextSignerName": "Nguyễn Văn C",
      "nextSignType": 1,
      "isFileValid": true,
      "isAllowApprove": false,
      "isAllowReject": false
    }   
  ],
  "paging": { "pageIndex": 1, "pageSize": 10, "totalCount": 50 }
}
```

### 2. Lấy chi tiết PATC
`GET /api/constructionplan/{id}`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID của PATC |

**Response**
```json
{
  "data": {
    "id": "guid",
    "code": "PATC-001",
    "name": "Tên PATC",
    "constructionId": "guid",
    "constructionName": "Tên công trình",
    "content": "Nội dung",
    "reportDate": "2025-07-29T00:00:00",
    "confirmDate": null,
    "confirmBy": null,
    "confirmById": null,
    "status": 0,
    "workType": 0,
    "filePath": "http://...",
    "basePdfPath": "http://...",
    "signedFilePath": null,
    "fileName": "PATC.docx",
    "fileSize": 102400,
    "isFileValid": true,
    "qlvhUnitId": "guid",
    "createdBy": "guid",
    "createdByName": "Nguyễn Văn A",
    "participants": [
      {
        "id": "guid",
        "constructionPlanId": "guid",
        "groupType": 1,
        "sortOrder": 0,
        "unitId": "guid",
        "unitName": "Công ty Thí nghiệm điện",
        "userId": "guid",
        "fullName": "Nguyễn Văn A",
        "position": "Giám đốc",
        "isSigned": false,
        "signedDate": null,
        "isCompanySigner": true,
        "hasHsmCert": false,
        "isHsmSign": false,
        "companyOrder": 1,
        "signType": 1,
        "signOrder": 1
      }
    ],
    "surveyReports": [
      {
        "id": "guid",
        "constructionPlanId": "guid",
        "surveyReportId": "guid",
        "surveyReportCode": "BBKS-001",
        "surveyReportName": "Biên bản khảo sát ...",
        "createdByName": "Nguyễn Văn A",
        "qlvhUnitName": "HN08",
        "reportDate": "2025-07-20T00:00:00",
        "confirmDate": "2025-07-21T00:00:00",
        "status": 2,
        "signedFilePath": "http://...",
        "fileName": "BBKS.docx"
      }
    ],
    "attachments": [
      {
        "id": "guid",
        "constructionPlanId": "guid",
        "filePath": "http://...",
        "fileName": "attachment.pdf",
        "fileSize": 204800
      }
    ]
  }
}
```

### 3. Tạo mới PATC
`POST /api/constructionplan`  
`Content-Type: application/json`

**Request Body**
```json
{
  "code": "PATC-001",
  "name": "Tên phương án thi công",
  "constructionId": "guid",
  "content": "Nội dung mô tả",
  "reportDate": "2025-07-29T00:00:00",
  "workType": 0,
  "surveyReportIds": ["guid1", "guid2"],
  "participants": [
    {
      "groupType": 1,
      "unitId": "guid",
      "unitName": "Công ty Thí nghiệm điện",
      "userId": "guid",
      "fullName": "Nguyễn Văn A",
      "position": "Giám đốc/Phó GĐ công ty",
      "sortOrder": 0,
      "isCompanySigner": true,
      "hasHsmCert": false,
      "isHsmSign": false,
      "companyOrder": 1,
      "signType": 1,
      "signOrder": 1
    }
  ],
  "attachments": []
}
```

**Participants — GroupType**
| Giá trị | Nhóm |
|---------|------|
| 1 | Đơn vị công tác |
| 2 | Đơn vị QLVH |
| 3 | Đơn vị liên quan khác |

**Response**
```json
{ "data": "guid-id-mới-tạo" }
```

### 4. Cập nhật PATC
`PUT /api/constructionplan/{id}`  
`Content-Type: application/json`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC cần cập nhật |

*Request Body giống POST ở trên.*

**Response**
```json
{ "data": "guid-id" }
```

### 5. Xóa PATC
`DELETE /api/constructionplan/{id}`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC cần xóa |

**Response**
```json
{ "data": true }
```

### 6. Gửi duyệt (Send)
`POST /api/constructionplan/{id}/send`  
`Content-Type: application/json`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC |

**Request Body**
```json
{
  "note": "Ghi chú khi gửi duyệt"
}
```

**Response**
```json
{ "data": true }
```

### 7. Ký duyệt (Approve)
`POST /api/constructionplan/approve`  
`Content-Type: application/json`

**Request Body**
```json
{
  "id": "guid",
  "note": "Đồng ý"
}
```

**Response**
```json
{ "data": true }
```

### 8. Từ chối (Reject)
`POST /api/constructionplan/reject`  
`Content-Type: application/json`

**Request Body**
```json
{
  "id": "guid",
  "note": "Lý do từ chối"
}
```

**Response**
```json
{ "data": true }
```

### 9. Lấy lịch sử phê duyệt
`GET /api/constructionplan/{id}/history`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC |

**Response**
```json
{
  "data": [
    {
      "action": "Gửi duyệt",
      "note": "...",
      "createdByName": "Nguyễn Văn A",
      "createdAt": "2025-07-29T10:00:00"
    }
  ]
}
```

### 10. Upload file PATC (Word)
`POST /api/constructionplan/{id}/upload`  
`Content-Type: multipart/form-data`  
`[AllowAnonymous]`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC |

**Form Data**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| file | File | File Word (.docx) |

**Response**
```json
{ "data": "http://path-to-file" }
```

### 11. Upload tài liệu đính kèm
`POST /api/constructionplan/upload`  
`Content-Type: multipart/form-data`  
`[AllowAnonymous]`

**Form Data**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| constructionPlanId | Guid | ID PATC |
| file | File | File đính kèm (bất kỳ định dạng) |

**Response**
```json
{ "data": "http://path-to-attachment" }
```

### 12. Xóa tài liệu đính kèm
`DELETE /api/constructionplan/attachment/{id}`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID attachment |

**Response**
```json
{ "data": true }
```

### 13. Tải file template Word
`GET /api/constructionplan/{id}/template`  
`[AllowAnonymous]`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC |

**Response**  
File download: `PATC_Template.docx` (application/vnd.openxmlformats-officedocument.wordprocessingml.document)

### 14. Xem file PDF
`GET /api/constructionplan/{id}/pdf`  
`[AllowAnonymous]`

**Path Param**

| Tên | Kiểu | Mô tả |
|-----|------|-------|
| id | Guid | ID PATC |

**Response**  
Stream file PDF (`application/pdf`), hỗ trợ Range Processing.  
⚠️ *Nếu chưa có file PDF, trả về lỗi 400: "Phương án thi công chưa được tải lên file mẫu hoặc convert sang PDF."*

### 15. Lấy danh sách người ký
`GET /api/constructionplan/signers`

**Query Params**

| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| unitId | Guid | ✅ | ID đơn vị |
| keyword | string | ❌ | Tìm kiếm theo tên |

**Response**
```json
{
  "data": [
    {
      "id": "guid",
      "name": "Nguyễn Văn A",
      "position": "Giám đốc",
      "hasHsmCert": true
    }
  ]
}
```

### 16. Validate danh sách BBKS
`GET /api/constructionplan/survey-reports`

**Query Params**

| Tên | Kiểu | Bắt buộc | Mô tả |
|-----|------|----------|-------|
| surveyReportIds | string | ✅ | Danh sách ID BBKS, phân cách bằng dấu phẩy |

*Ví dụ: `?surveyReportIds=guid1,guid2,guid3`*

**Response**
```json
{
  "data": [
    {
      "id": "guid",
      "surveyReportId": "guid",
      "surveyReportCode": "BBKS-001",
      "surveyReportName": "...",
      "status": 2,
      "reportDate": "2025-07-20T00:00:00",
      "confirmDate": "2025-07-21T00:00:00"
    }
  ]
}
```

### 17. Export danh sách Excel
`GET /api/constructionplan/export`

**Query Params**  
Giống API số 1 (danh sách phân trang).

**Response**  
File download: `Danh_sach_PATC_{timestamp}.xlsx`

---

## Enum Reference (PATC)

### ConstructionPlanStatus
| Giá trị | Tên | Mô tả |
|---------|-----|-------|
| 0 | New | Mới |
| 1 | Pending | Chờ xác nhận |
| 2 | Approved | Đã xác nhận |
| 3 | Rejected | Từ chối |

### ParticipantGroupType
| Giá trị | Nhóm |
|---------|------|
| 1 | Đơn vị công tác |
| 2 | Đơn vị QLVH |
| 3 | Đơn vị liên quan khác |

### SignType
| Giá trị | Loại ký |
|---------|---------|
| 0 | Không ký |
| 1 | Ký số HSM |
| 2 | Ký tay |

---

### Tổng kết API 18 — Ký tay người ngoài EVN:
`POST /api/constructionplan/{id}/external-sign`  
`Content-Type: multipart/form-data`

**Form:**
- `participantId = <Guid>` // ID người cần ký (phải là IsExternal=true)
- `signatureImage = <File>` // Ảnh chữ ký .png/.jpg


---
---

# Tài Liệu API Đăng Ký Công Tác (Mobile)

Ứng dụng Mobile có thể tái sử dụng trực tiếp các API đang dùng cho Web vì bản thân các API này đã được thiết kế đáp ứng đầy đủ dữ liệu (bao gồm tất cả các thành phần trong file Word ĐKCT). Dưới đây là danh sách các API và tham số chi tiết để đội ngũ Mobile thực hiện.

### 1. Lấy danh sách phiếu ĐKCT (Phân trang và Tìm kiếm)
**Endpoint:** `POST /api/WorkRegistration/Paging`  
**Mô tả:** Lấy danh sách phiếu ĐKCT. Mobile truyền các tham số lọc vào body.

**Request Body:**
```json
{
  "pageIndex": 1,
  "pageSize": 20,
  "searchTerm": "",
  "qlvhUnitId": "guid-đơn-vị-nếu-có",
  "status": null,
  "registerDateFrom": "2026-07-01T00:00:00",
  "registerDateTo": "2026-07-30T23:59:59"
}
```

### 2. Lấy chi tiết phiếu ĐKCT
**Endpoint:** `GET /api/WorkRegistration/{id}`  
**Mô tả:** Trả về toàn bộ thông tin chi tiết của 1 phiếu, bao gồm danh sách nhân viên, đơn vị liên quan, rủi ro, thời gian, nội dung, địa điểm.

### 3. Tạo mới phiếu ĐKCT
**Endpoint:** `POST /api/WorkRegistration`  
**Mô tả:** Lưu ý truyền đầy đủ các trường nội dung có trong file Word vào Request Body.

**Request Body:**
```json
{
  "code": "DKCT-01",
  "name": "Phiếu ĐKCT 01",
  "patcId": "guid-patc-nếu-có",
  "note": "Ghi chú chung",
  "registerDate": "2026-07-30T00:00:00",
  
  // --- CÁC TRƯỜNG THÔNG TIN TRONG FILE WORD (Bắt buộc bổ sung trên UI Mobile) ---
  "commanderName": "Nguyễn Văn A", // Người chỉ huy trực tiếp
  "commanderSafetyLevel": "4/5",   // Bậc an toàn điện
  "phoneNumber": "0987654321",
  "workContent": "Thay MBA",       // 2. Nội dung công tác
  "workLocation": "Trạm biến áp X",// 3. Địa điểm công tác
  "workCondition": "Cắt điện",     // 4. Điều kiện công tác
  "startTime": "2026-07-30T08:00:00", // 5. Thời gian bắt đầu
  "endTime": "2026-07-30T17:00:00",   // Thời gian kết thúc
  
  "workUnitCount": 1, // Số lượng đơn vị
  "workerCount": 5,   // Số lượng nhân viên
  
  "workLeaderName": "Trần Văn B", // 7. Người lãnh đạo công việc
  "workLeaderSafetyLevel": "5/5",
  "supervisorName": "Lê Văn C",   // 8. Người giám sát an toàn điện
  "supervisorSafetyLevel": "4/5",
  "guardName": "Phạm Văn D",      // 9. Người cảnh giới
  "guardSafetyLevel": "3/5",
  "receiverNote": "- Như trên;\n- Lưu: P7.2", // 11. Nơi nhận
  // Danh sách nhân viên đơn vị công tác
  "workers": [
    {
      "sortOrder": 1,
      "fullName": "Nguyễn Nhân Viên 1",
      "safetyLevel": "3/5",
      "duty": "Thợ chính"
    }
  ],
  
  // Danh sách đơn vị QLVH khác có liên quan
  "relatedUnits": [
    {
      "sortOrder": 1,
      "unitName": "Điện lực A"
    }
  ],
  // Đánh giá rủi ro và biện pháp an toàn
  "risks": [
    {
      "sortOrder": 1,
      "hazardContent": "Ngã cao",
      "safetyMeasure": "Đeo dây an toàn",
      "execUnit": "Đội thi công"
    }
  ]
}
```

### 4. Cập nhật phiếu ĐKCT
**Endpoint:** `PUT /api/WorkRegistration/{id}`  
**Mô tả:** Tương tự như API Tạo mới, Mobile cần truyền đầy đủ các thành phần trong file Word lên để cập nhật. Tham số Request Body giống hệt cấu trúc của **Tạo mới phiếu ĐKCT**, cộng thêm `id` trên URL.

### 5. Phê duyệt phiếu ĐKCT
**Endpoint:** `POST /api/WorkRegistration/Approve`  
**Request Body:**
```json
{
  "id": "guid-phiếu-đkct"
}
```

### 6. Từ chối phiếu ĐKCT
**Endpoint:** `POST /api/WorkRegistration/Reject`  
**Request Body:**
```json
{
  "id": "guid-phiếu-đkct",
  "reason": "Lý do từ chối (bắt buộc)"
}
```

### 7. Gửi duyệt phiếu ĐKCT (Ký số)
**Endpoint:** `POST /api/WorkRegistration/Send`  
**Request Body:**
```json
{
  "id": "guid-phiếu-đkct",
  "receiverNote": "- Như trên;\n- Lưu: P7.2"
}
```

### 8. Lấy file PDF phiếu ĐKCT để xem
**Endpoint:** `GET /api/WorkRegistration/dkct-pdf/{id}`  
**Mô tả:** Trả về file nhị phân PDF (FileStream). Mobile có thể truyền thêm `access_token` trên query string để xem trong trình duyệt hoặc WebView: `https://[domain]/api/WorkRegistration/dkct-pdf/{id}?access_token={token}`
