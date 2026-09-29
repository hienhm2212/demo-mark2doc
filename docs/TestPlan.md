---
title: "Test Plan & Test Cases"
subtitle: "Module Thanh toán – Ứng dụng ShopNow"
author: "Team QC – ACME Software"
date: "28/09/2026"
version: "1.0"
toc-title: "Mục lục"
---

# Thông tin chung

| Hạng mục          | Nội dung                                  |
|-------------------|-------------------------------------------|
| Tài liệu tham chiếu | SRS Module Thanh toán v1.2              |
| Môi trường        | Staging – https://staging.shopnow.example |
| Thời gian kiểm thử | 01/10/2026 – 10/10/2026                  |
| Người phụ trách   | Lê Chi (QC Lead)                          |

# Phạm vi kiểm thử

- Kiểm thử chức năng UC-01, UC-02
- Kiểm thử quy tắc nghiệp vụ BR-01 đến BR-05
- Kiểm thử hiệu năng màn hình thanh toán (smoke)

# Tiêu chí hoàn thành

- 100% test case mức **Critical** và **High** đạt (Pass)
- Không còn lỗi mức **Blocker**/**Critical** đang mở
- Tỷ lệ Pass tổng thể từ 95% trở lên

# Test cases

<!-- Số dấu "-" ở dòng phân cách quyết định tỉ lệ độ rộng cột trong Word -->

| ID     | Tiêu đề                                  | Bước thực hiện                                         | Kết quả mong đợi                               | Ưu tiên  | Tham chiếu |
|-----------|-------------------------|-------------------------------|--------------------------|-------------|-------------|
| TC-001 | Thanh toán thành công bằng ví điện tử    | Chọn ví điện tử → xác nhận → nhập OTP hợp lệ           | Đơn hàng chuyển trạng thái **Đã thanh toán**   | Critical | UC-01      |
| TC-002 | Đơn hàng dưới giá trị tối thiểu          | Tạo đơn 9.000 VNĐ → nhấn Thanh toán                    | Hiển thị thông báo lỗi, không chuyển Gateway   | High     | BR-01      |
| TC-003 | Hết hạn phiên thanh toán                 | Vào Gateway → chờ quá 15 phút                          | Đơn hàng về trạng thái **Chờ thanh toán**      | High     | BR-02      |
| TC-004 | Thử lại quá 3 lần                        | Thanh toán thất bại 3 lần liên tiếp → thử lần 4        | Nút Thanh toán bị vô hiệu hóa                  | Medium   | BR-03      |
| TC-005 | Hoàn tiền vượt giá trị đã thanh toán     | Tạo refund 300.000 cho đơn 250.000                     | Hệ thống từ chối, hiển thị lỗi                 | Critical | BR-05      |

# Kịch bản BDD (dùng lại cho automation)

```gherkin
Feature: Thanh toán đơn hàng

  Scenario: Thanh toán thành công bằng ví điện tử
    Given khách hàng đã đăng nhập và có giỏ hàng trị giá 250.000 VNĐ
    When khách hàng chọn "Ví điện tử" và nhập OTP hợp lệ
    Then đơn hàng có trạng thái "Đã thanh toán"
    And khách hàng nhận được hóa đơn điện tử trong vòng 5 phút
```

# Rủi ro

| Rủi ro                               | Ảnh hưởng | Giải pháp                              |
|--------------------------------------|-----------|----------------------------------------|
| Gateway sandbox không ổn định        | Cao       | Dùng mock server cho các case lỗi      |
| Thiếu dữ liệu thẻ test quốc tế       | Trung bình | Xin bộ thẻ test từ đối tác trước 30/09 |
