---
title: "Software Requirement Specification"
subtitle: "Module Thanh toán – Ứng dụng ShopNow"
author: "Team BA – ACME Software"
date: "28/09/2026"
version: "1.2"
toc-title: "Mục lục"
---

# Lịch sử thay đổi

| Phiên bản | Ngày       | Người thực hiện | Nội dung thay đổi                     |
|-----------|------------|-----------------|---------------------------------------|
| 1.0       | 01/09/2026 | Nguyễn An       | Khởi tạo tài liệu                     |
| 1.1       | 15/09/2026 | Trần Bình       | Bổ sung thanh toán qua ví điện tử     |
| 1.2       | 28/09/2026 | Nguyễn An       | Cập nhật quy tắc hoàn tiền (BR-05)    |

# Giới thiệu

## Mục đích

Tài liệu mô tả các yêu cầu chức năng và phi chức năng của **Module Thanh toán** trong ứng dụng ShopNow, làm cơ sở cho đội phát triển, kiểm thử và khách hàng nghiệm thu.

## Phạm vi

Trong phạm vi:

- Thanh toán bằng thẻ nội địa, thẻ quốc tế và ví điện tử
- Hoàn tiền toàn phần và một phần
- Gửi hóa đơn điện tử qua email

Ngoài phạm vi:

- Thanh toán trả góp
- Tích hợp điểm thưởng (loyalty)

## Thuật ngữ

| Thuật ngữ | Giải thích                                               |
|-----------|----------------------------------------------------------|
| Gateway   | Cổng thanh toán bên thứ ba (ví dụ: VNPay, MoMo)          |
| OTP       | Mã xác thực dùng một lần                                  |
| Refund    | Giao dịch hoàn tiền cho khách hàng                        |

# Tổng quan luồng nghiệp vụ

Luồng thanh toán chuẩn được mô tả trong sơ đồ dưới đây:

![Luồng thanh toán qua cổng Gateway](images/payment-flow.png){width=95%}

# Yêu cầu chức năng

## UC-01: Thanh toán đơn hàng

**Tác nhân:** Khách hàng\
**Điều kiện tiên quyết:** Khách hàng đã đăng nhập và giỏ hàng có ít nhất một sản phẩm.

**Luồng chính:**

1. Khách hàng nhấn nút **Thanh toán** trên màn hình giỏ hàng.
2. Hệ thống hiển thị tổng tiền và danh sách phương thức thanh toán.
3. Khách hàng chọn phương thức và xác nhận.
4. Hệ thống chuyển hướng sang Gateway.
5. Gateway trả kết quả; hệ thống cập nhật trạng thái đơn hàng.

**Luồng thay thế:**

- *5a.* Gateway trả lỗi hoặc quá thời gian 15 phút: đơn hàng chuyển sang trạng thái **Chờ thanh toán**, khách hàng có thể thanh toán lại.

## UC-02: Hoàn tiền

**Tác nhân:** Nhân viên CSKH\
**Mô tả:** Nhân viên tạo yêu cầu hoàn tiền cho đơn hàng đã thanh toán thành công.

## Quy tắc nghiệp vụ

| Mã    | Quy tắc                                                                 | Mức độ   |
|-------|-------------------------------------------------------------------------|----------|
| BR-01 | Giá trị đơn hàng tối thiểu để thanh toán online là 10.000 VNĐ           | Bắt buộc |
| BR-02 | Phiên thanh toán hết hạn sau 15 phút                                    | Bắt buộc |
| BR-03 | Khách hàng được thử lại tối đa 3 lần cho mỗi đơn hàng                   | Bắt buộc |
| BR-04 | Hóa đơn điện tử gửi trong vòng 5 phút sau khi thanh toán thành công    | Nên có   |
| BR-05 | Hoàn tiền một phần không vượt quá giá trị đã thanh toán                 | Bắt buộc |

> **Lưu ý:** Quy tắc BR-05 được cập nhật ở phiên bản 1.2 theo yêu cầu của khách hàng ngày 25/09/2026.

# Yêu cầu phi chức năng

| Hạng mục     | Yêu cầu                                                   |
|--------------|-----------------------------------------------------------|
| Hiệu năng    | Thời gian phản hồi màn hình thanh toán dưới 2 giây        |
| Bảo mật      | Không lưu số thẻ; tuân thủ PCI DSS                        |
| Khả dụng     | Uptime 99,9% hằng tháng                                   |
| Nhật ký      | Ghi log toàn bộ giao dịch, lưu trữ tối thiểu 5 năm        |

# Phụ lục: Ví dụ payload

```json
{
  "orderId": "SN-20260928-0001",
  "amount": 250000,
  "currency": "VND",
  "method": "EWALLET"
}
```
