---
title: "Product Requirements Document"
subtitle: "ShopNow – Thanh toán bằng ví điện tử"
author: "PM Agent (BMAD) · Team BA review"
date: "28/09/2026"
version: "1.0"
toc-title: "Mục lục"
bmad: true
---

# ShopNow – Thanh toán bằng ví điện tử: Product Requirements Document (PRD)

## Goals and Background Context

### Goals

- Tăng tỷ lệ hoàn tất thanh toán trên mobile thêm 15% trong quý IV/2026
- Rút thời gian thanh toán trung bình xuống dưới 30 giây
- Giảm 50% số yêu cầu hỗ trợ liên quan đến thanh toán thất bại

### Background Context

Hiện tại ShopNow chỉ hỗ trợ thanh toán bằng thẻ. Khảo sát tháng 8/2026 cho thấy 62% khách hàng trên mobile muốn dùng ví điện tử, và 18% đơn hàng bị bỏ dở ở bước nhập thông tin thẻ.

Tài liệu này mô tả phạm vi MVP cho tính năng thanh toán bằng ví điện tử, làm cơ sở cho Architect thiết kế và cho đội phát triển chia story.

### Change Log

| Date       | Version | Description                       | Author   |
|------------|---------|-----------------------------------|----------|
| 20/09/2026 | 0.1     | Bản nháp đầu tiên do PM Agent tạo | PM Agent |
| 28/09/2026 | 1.0     | BA review, bổ sung NFR bảo mật    | Nguyễn An |

## Requirements

### Functional

1. **FR1:** Khách hàng chọn được ví điện tử làm phương thức thanh toán tại màn hình giỏ hàng.
2. **FR2:** Hệ thống chuyển khách hàng sang ứng dụng ví và nhận kết quả trả về qua callback.
3. **FR3:** Đơn hàng tự động chuyển trạng thái theo kết quả thanh toán.
4. **FR4:** Phiên thanh toán hết hạn sau 15 phút nếu không nhận được kết quả.
5. **FR5:** Khách hàng nhận hóa đơn điện tử qua email trong vòng 5 phút sau khi thanh toán thành công.

### Non Functional

1. **NFR1:** Thời gian phản hồi màn hình thanh toán dưới 2 giây ở phân vị 95.
2. **NFR2:** Không lưu thông tin nhạy cảm của ví; tuân thủ PCI DSS.
3. **NFR3:** Ghi log toàn bộ giao dịch, lưu trữ tối thiểu 5 năm.

## User Interface Design Goals

### Overall UX Vision

Thanh toán trong tối đa 3 lần chạm, không bắt khách hàng nhập lại thông tin.

### Core Screens and Views

- Giỏ hàng (chọn phương thức thanh toán)
- Màn hình chờ kết quả
- Kết quả thanh toán

### Target Device and Platforms

Mobile (iOS, Android) và Web responsive.

## Technical Assumptions

### Repository Structure: Monorepo

### Service Architecture

Payment Service độc lập, giao tiếp với Order Service qua message queue.

### Testing Requirements

Unit test và integration test với sandbox của ví; E2E cho luồng thanh toán chính.

## Epic List

| Epic | Tên                          | Mục tiêu                                              |
|------|------------------------------|-------------------------------------------------------|
| 1    | Nền tảng thanh toán ví       | Kết nối ví điện tử và xử lý callback an toàn          |
| 2    | Trải nghiệm thanh toán       | Luồng thanh toán trên app và web, hóa đơn điện tử     |

## Epic 1: Nền tảng thanh toán ví

Kết nối với cổng ví điện tử, xử lý callback và cập nhật trạng thái đơn hàng một cách an toàn, có thể kiểm chứng.

Luồng tổng quan:

![Luồng thanh toán qua ví điện tử](images/payment-flow.png){width=90%}

### Story 1.1: Tạo phiên thanh toán

As a **khách hàng**, I want **được chuyển sang ứng dụng ví khi chọn thanh toán**, so that **tôi hoàn tất thanh toán nhanh mà không cần nhập thẻ**.

#### Acceptance Criteria

1. Khi khách hàng xác nhận thanh toán, hệ thống tạo phiên thanh toán với mã đơn hàng và số tiền.
2. Phiên thanh toán có thời hạn 15 phút (FR4).
3. Khách hàng được chuyển hướng sang ứng dụng ví trong vòng 2 giây (NFR1).

### Story 1.2: Xử lý callback kết quả

As a **hệ thống**, I want **nhận và xác thực callback từ ví**, so that **trạng thái đơn hàng luôn chính xác**.

#### Acceptance Criteria

1. Callback không có chữ ký hợp lệ bị từ chối và ghi log (NFR3).
2. Callback trùng lặp không làm thay đổi trạng thái đơn hàng lần thứ hai.
3. Đơn hàng chuyển sang **Đã thanh toán** hoặc **Thanh toán thất bại** theo kết quả (FR3).

## Epic 2: Trải nghiệm thanh toán

Hoàn thiện luồng thanh toán trên app và web, gửi hóa đơn điện tử cho khách hàng.

### Story 2.1: Gửi hóa đơn điện tử

As a **khách hàng**, I want **nhận hóa đơn qua email sau khi thanh toán**, so that **tôi có chứng từ để đối chiếu**.

#### Acceptance Criteria

1. Email hóa đơn được gửi trong vòng 5 phút sau khi thanh toán thành công (FR5).
2. Hóa đơn có mã đơn hàng, số tiền, thời gian và phương thức thanh toán.

## Next Steps

### Architect Prompt

Dựa trên PRD này, hãy thiết kế kiến trúc cho Payment Service, tập trung vào xử lý callback idempotent và lưu vết giao dịch.
