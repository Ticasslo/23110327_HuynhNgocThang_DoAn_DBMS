# WORKFLOW HOẠT ĐỘNG HỆ THỐNG QUẢN LÝ THU CHI TÀI CHÍNH

## ** TỔNG QUAN WORKFLOW**

Hệ thống quản lý thu chi tài chính cho **Trung tâm giới thiệu việc làm sinh viên** hoạt động theo mô hình **2 chiều thu chi**:

### **💰 THU (Revenue):**

- **Nguồn thu**: Từ **sinh viên** và **doanh nghiệp**
- **Mục đích**: Tài trợ cho các hoạt động của trung tâm

### **💸 CHI (Expenses):**

- **Mục đích chi**: Cho các **dự án/hoạt động** của trung tâm
- **Đối tượng**: Chi phí vận hành, lương nhân viên, đầu tư phát triển

---

## **🔄 WORKFLOW CHI TIẾT**

### **1. WORKFLOW THU TIỀN (TỪ SINH VIÊN & DOANH NGHIỆP)**

#### **A. THU TỪ SINH VIÊN:**

```
Sinh viên đến trung tâm → Nộp phí dịch vụ → Nhân viên tài chính tạo phiếu thu → Trưởng phòng duyệt → Cộng tiền vào tài khoản
```

**Chi tiết từng bước:**

1. **Sinh viên đến trung tâm** tìm việc làm
2. **Nộp phí dịch vụ** (30,000 VNĐ/ứng viên)
3. **Nhân viên tài chính** tạo phiếu thu:
   - Loại: `THU`
   - Số tiền: 30,000 VNĐ
   - Loại giao dịch: "Phí dịch vụ giới thiệu việc làm"
   - Trạng thái: `CHO_DUYET`
4. **Trưởng phòng tài chính** duyệt phiếu thu
5. **Trigger tự động** cộng 30,000 VNĐ vào tài khoản
6. **Số dư tài khoản** tăng lên

#### **B. THU TỪ DOANH NGHIỆP:**

```
Doanh nghiệp đăng tin tuyển dụng → Nộp phí đăng tin → Nhân viên tài chính tạo phiếu thu → Trưởng phòng duyệt → Cộng tiền vào tài khoản
```

**Chi tiết từng bước:**

1. **Doanh nghiệp** muốn đăng tin tuyển dụng
2. **Nộp phí đăng tin** (7,000 VNĐ/ngày × số ngày)
3. **Nhân viên tài chính** tạo phiếu thu:
   - Loại: `THU`
   - Số tiền: 7,000 VNĐ × số ngày
   - Loại giao dịch: "Phí đăng tin tuyển dụng"
   - Trạng thái: `CHO_DUYET`
4. **Trưởng phòng tài chính** duyệt phiếu thu
5. **Trigger tự động** cộng tiền vào tài khoản
6. **Số dư tài khoản** tăng lên

#### **C. THU TỪ TÀI TRỢ:**

```
Doanh nghiệp tài trợ → Nhân viên tài chính tạo phiếu thu → Trưởng phòng duyệt → Cộng tiền vào tài khoản
```

---

### **2. WORKFLOW CHI TIỀN (CHO CÁC DỰ ÁN/HOẠT ĐỘNG)**

#### **A. CHI CHO DỰ ÁN MỞ RỘNG TRUNG TÂM:**

```
Có nhu cầu mở rộng → Nhân viên tài chính tạo phiếu chi → Kiểm tra số dư → Trưởng phòng duyệt → Trừ tiền khỏi tài khoản
```

**Chi tiết từng bước:**

1. **Có nhu cầu** mở rộng trung tâm (thuê mặt bằng mới)
2. **Nhân viên tài chính** tạo phiếu chi:
   - Loại: `CHI`
   - Số tiền: 200,000,000 VNĐ
   - Loại giao dịch: "Chi phí thuê mặt bằng"
   - Dự án: "Mở rộng trung tâm"
   - Trạng thái: `CHO_DUYET`
3. **Hệ thống kiểm tra** số dư tài khoản (phải ≥ 200,000,000 VNĐ)
4. **Trưởng phòng tài chính** duyệt phiếu chi
5. **Trigger tự động** trừ 200,000,000 VNĐ khỏi tài khoản
6. **Số dư tài khoản** giảm xuống

#### **B. CHI LƯƠNG NHÂN VIÊN:**

```
Đến kỳ trả lương → Nhân viên tài chính tạo phiếu chi → Kiểm tra số dư → Trưởng phòng duyệt → Trừ tiền khỏi tài khoản
```

**Chi tiết từng bước:**

1. **Đến kỳ trả lương** (hàng tháng)
2. **Nhân viên tài chính** tạo phiếu chi:
   - Loại: `CHI`
   - Số tiền: 50,000,000 VNĐ
   - Loại giao dịch: "Lương nhân viên"
   - Trạng thái: `CHO_DUYET`
3. **Hệ thống kiểm tra** số dư tài khoản
4. **Trưởng phòng tài chính** duyệt phiếu chi
5. **Trigger tự động** trừ tiền khỏi tài khoản
6. **Số dư tài khoản** giảm xuống

#### **C. CHI CHO DỰ ÁN NÂNG CẤP HỆ THỐNG:**

```
Có nhu cầu nâng cấp → Nhân viên tài chính tạo phiếu chi → Kiểm tra số dư → Trưởng phòng duyệt → Trừ tiền khỏi tài khoản
```

---

## **👥 VAI TRÒ VÀ TRÁCH NHIỆM**

### **1. ADMIN HỆ THỐNG:**

- **Quyền hạn**: Toàn quyền hệ thống
- **Trách nhiệm**: Quản lý người dùng, cấu hình hệ thống
- **Workflow**: Không tham gia trực tiếp vào thu chi

### **2. TRƯỞNG PHÒNG TÀI CHÍNH:**

- **Quyền hạn**: Duyệt giao dịch, quản lý toàn bộ
- **Trách nhiệm**:
  - Duyệt/từ chối phiếu thu/chi
  - Quản lý tài khoản ngân hàng
  - Quản lý dự án và ngân sách
- **Workflow**: Là người quyết định cuối cùng

### **3. NHÂN VIÊN TÀI CHÍNH:**

- **Quyền hạn**: Tạo giao dịch, xem báo cáo
- **Trách nhiệm**:
  - Tạo phiếu thu từ sinh viên/doanh nghiệp
  - Tạo phiếu chi cho các hoạt động
  - Không được duyệt giao dịch
- **Workflow**: Thực hiện các thao tác cơ bản

### **4. KẾ TOÁN:**

- **Quyền hạn**: Chỉ xem, tạo báo cáo
- **Trách nhiệm**:
  - Xem tất cả giao dịch
  - Tạo báo cáo tài chính
  - Giám sát hoạt động thu chi
- **Workflow**: Không tham gia tạo/sửa giao dịch

---

## **📊 VÍ DỤ WORKFLOW THỰC TẾ**

### **Tình huống: Sinh viên A đến tìm việc làm**

#### **Bước 1: Sinh viên đến trung tâm**

```
Sinh viên A → Quầy tiếp tân → Nộp 30,000 VNĐ phí dịch vụ
```

#### **Bước 2: Nhân viên tài chính tạo phiếu thu**

```sql
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao)
VALUES ('THU', 30000, N'Thu phí dịch vụ từ sinh viên A', 1, 1, 3);
-- Trạng thái: CHO_DUYET
-- Số dư tài khoản: CHƯA THAY ĐỔI
```

#### **Bước 3: Trưởng phòng duyệt**

```sql
EXEC SP_DuyetGiaoDich @ma_gd = 1, @ma_nv_duyet = 2, @trang_thai = 'DA_DUYET';
-- Trạng thái: DA_DUYET
-- Trigger tự động cộng 30,000 VNĐ vào tài khoản
```

#### **Bước 4: Kết quả**

```
Số dư tài khoản: 100,000,000 + 30,000 = 100,030,000 VNĐ
Giao dịch hoàn thành
```

---

### **Tình huống: Chi lương nhân viên tháng 1/2024**

#### **Bước 1: Đến kỳ trả lương**

```
Kế toán tính lương → Báo cáo: 50,000,000 VNĐ
```

#### **Bước 2: Nhân viên tài chính tạo phiếu chi**

```sql
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao)
VALUES ('CHI', 50000000, N'Chi lương nhân viên tháng 1/2024', 4, 1, 3);
-- Trạng thái: CHO_DUYET
-- Số dư tài khoản: CHƯA THAY ĐỔI
```

#### **Bước 3: Kiểm tra số dư**

```
Hệ thống kiểm tra: Số dư hiện tại ≥ 50,000,000 VNĐ?
Nếu đủ: Cho phép tạo giao dịch
Nếu không đủ: Báo lỗi, không cho tạo
```

#### **Bước 4: Trưởng phòng duyệt**

```sql
EXEC SP_DuyetGiaoDich @ma_gd = 2, @ma_nv_duyet = 2, @trang_thai = 'DA_DUYET';
-- Trạng thái: DA_DUYET
-- Trigger tự động trừ 50,000,000 VNĐ khỏi tài khoản
```

#### **Bước 5: Kết quả**

```
Số dư tài khoản: 100,030,000 - 50,000,000 = 50,030,000 VNĐ
Giao dịch hoàn thành
```

---

## **🔍 KIỂM SOÁT VÀ BÁO CÁO**

### **1. Kiểm soát số dư:**

- **Trigger tự động** kiểm tra số dư khi tạo giao dịch chi
- **Cảnh báo** khi số dư thấp
- **Ngăn chặn** giao dịch chi khi không đủ tiền

### **2. Báo cáo tài chính:**

- **Kế toán** tạo báo cáo hàng tháng
- **Thống kê** thu chi theo dự án
- **Phân tích** hiệu quả tài chính

### **3. Audit trail:**

- **Ghi lại** mọi giao dịch
- **Theo dõi** ai tạo, ai duyệt
- **Lưu trữ** lịch sử thay đổi

---

## **💡 TÓM TẮT WORKFLOW**

### **THU TIỀN:**

```
Sinh viên/Doanh nghiệp → Nộp phí → Nhân viên TC tạo phiếu thu → Trưởng phòng duyệt → Cộng tiền
```

### **CHI TIỀN:**

```
Có nhu cầu chi → Nhân viên TC tạo phiếu chi → Kiểm tra số dư → Trưởng phòng duyệt → Trừ tiền
```

### **NGUYÊN TẮC:**

- **Mọi giao dịch** đều phải được duyệt
- **Số dư tài khoản** được cập nhật tự động
- **Phân quyền** rõ ràng theo vai trò
- **Kiểm soát** chặt chẽ mọi hoạt động

Đây là hệ thống **minh bạch**, **an toàn** và **hiệu quả** để quản lý tài chính trung tâm!
