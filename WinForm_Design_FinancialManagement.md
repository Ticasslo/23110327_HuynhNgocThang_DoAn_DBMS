# THIẾT KẾ GIAO DIỆN WINFORM - HỆ THỐNG QUẢN LÝ THU CHI TÀI CHÍNH

## I. TỔNG QUAN GIAO DIỆN

### **1. Cấu trúc chính:**

- **Form đăng nhập** (LoginForm)
- **Form chính** (MainForm) với MenuStrip
- **Các form chức năng** con

### **2. Phân quyền giao diện:**

- **Admin**: Toàn quyền truy cập
- **Trưởng phòng**: Duyệt giao dịch + tất cả chức năng khác
- **Nhân viên**: Tạo giao dịch, xem báo cáo
- **Kế toán**: Chỉ xem báo cáo, không tạo giao dịch

## II. CHI TIẾT CÁC FORM

### **1. FORM ĐĂNG NHẬP (LoginForm)**

```
┌─────────────────────────────────────┐
│  HỆ THỐNG QUẢN LÝ THU CHI TÀI CHÍNH  │
│         TRUNG TÂM VIỆC LÀM          │
├─────────────────────────────────────┤
│                                     │
│  Tên đăng nhập: [_______________]   │
│                                     │
│  Mật khẩu:     [_______________]   │
│                                     │
│  [    Đăng nhập    ] [   Thoát   ]  │
│                                     │
│  [Quên mật khẩu?]                  │
└─────────────────────────────────────┘
```

**Controls:**

- TextBox: txtUsername, txtPassword
- Button: btnLogin, btnExit
- LinkLabel: lnkForgotPassword
- Label: lblTitle

### **2. FORM CHÍNH (MainForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│ File  Quản lý  Giao dịch  Báo cáo  Hệ thống  Trợ giúp          │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────┐ ┌─────────────────────────────────────────────┐ │
│ │   MENU      │ │                WORKSPACE                    │ │
│ │             │ │                                             │ │
│ │ [Dashboard] │ │  ┌─────────────────────────────────────────┐ │ │
│ │ [Giao dịch] │ │  │        NỘI DUNG CHÍNH                  │ │ │
│ │ [Tài khoản] │ │  │                                         │ │ │
│ │ [Dự án]     │ │  │  - Thông tin tổng quan                 │ │ │
│ │ [Báo cáo]   │ │  │  - Biểu đồ thu chi                     │ │ │
│ │ [Hệ thống]  │ │  │  - Giao dịch gần đây                   │ │ │
│ │             │ │  │  - Cảnh báo số dư thấp                 │ │ │
│ │             │ │  │                                         │ │ │
│ │             │ │  └─────────────────────────────────────────┘ │ │
│ │             │ │                                             │ │
│ └─────────────┘ └─────────────────────────────────────────────┘ │
├─────────────────────────────────────────────────────────────────┤
│ Trạng thái: Đăng nhập | Người dùng: [Tên] | Vai trò: [Vai trò] │
└─────────────────────────────────────────────────────────────────┘
```

**Controls:**

- MenuStrip: menuMain
- SplitContainer: splitMain (Panel trái: Menu, Panel phải: Workspace)
- StatusStrip: statusMain
- TabControl: tabWorkspace (nếu cần)

### **3. FORM QUẢN LÝ GIAO DỊCH (GiaoDichForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUẢN LÝ GIAO DỊCH                            │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────────────────────────────┐ │
│ │   TÌM KIẾM      │ │              DANH SÁCH GIAO DỊCH        │ │
│ │                 │ │                                         │ │
│ │ Loại: [Tất cả▼] │ │ ┌─────────────────────────────────────┐ │ │
│ │ Trạng thái:     │ │ │ Mã  | Loại | Số tiền | Ngày | Trạng│ │ │
│ │ [Tất cả▼]       │ │ │ 001 | THU  | 5,000K  | 1/1  | Duyệt│ │ │
│ │ Từ ngày:        │ │ │ 002 | CHI  | 2,000K  | 2/1  | Chờ  │ │ │
│ │ [____/__/____]  │ │ │ 003 | THU  | 3,000K  | 3/1  | Duyệt│ │ │
│ │ Đến ngày:       │ │ │ ... | ...  | ...     | ...  | ...  │ │ │
│ │ [____/__/____]  │ │ └─────────────────────────────────────┘ │ │
│ │                 │ │                                         │ │
│ │ [Tìm kiếm]      │ │ [Tạo mới] [Xem] [Sửa] [Xóa] [Duyệt]    │ │
│ │ [Làm mới]       │ │                                         │ │
│ └─────────────────┘ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

**Controls:**

- GroupBox: grpSearch
- ComboBox: cboLoaiGiaoDich, cboTrangThai
- DateTimePicker: dtpTuNgay, dtpDenNgay
- Button: btnSearch, btnRefresh
- DataGridView: dgvGiaoDich
- Button: btnTaoMoi, btnXem, btnSua, btnXoa, btnDuyet

### **4. FORM TẠO/SỬA GIAO DỊCH (GiaoDichEditForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│                    TẠO GIAO DỊCH MỚI                            │
├─────────────────────────────────────────────────────────────────┤
│ Loại giao dịch: ○ Thu  ○ Chi                                   │
│                                                                 │
│ Thông tin giao dịch:                                           │
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ Loại: [Phí dịch vụ giới thiệu việc làm▼]                   │ │
│ │ Số tiền: [________________] VNĐ                             │ │
│ │ Tài khoản: [Tài khoản chính - Vietcombank▼]                │ │
│ │ Dự án: [Dự án mở rộng trung tâm▼]                          │ │
│ │ Mô tả: [________________________________]                  │ │
│ │         [________________________________]                  │ │
│ │ Ngày giao dịch: [____/__/____] [__:__]                     │ │
│ └─────────────────────────────────────────────────────────────┘ │
│                                                                 │
│ [Lưu] [Lưu và tạo mới] [Hủy]                                  │
└─────────────────────────────────────────────────────────────────┘
```

**Controls:**

- RadioButton: rdoThu, rdoChi
- ComboBox: cboLoaiGiaoDich, cboTaiKhoan, cboDuAn
- TextBox: txtSoTien, txtMoTa
- DateTimePicker: dtpNgayGiaoDich
- Button: btnLuu, btnLuuVaTaoMoi, btnHuy

### **5. FORM QUẢN LÝ TÀI KHOẢN (TaiKhoanForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUẢN LÝ TÀI KHOẢN NGÂN HÀNG                 │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────────────────────────────┐ │
│ │   THÔNG TIN     │ │              DANH SÁCH TÀI KHOẢN        │ │
│ │                 │ │                                         │ │
│ │ Tên tài khoản:  │ │ ┌─────────────────────────────────────┐ │ │
│ │ [____________]  │ │ │ Mã | Tên TK | Số TK | Ngân hàng | SD │ │ │
│ │ Số tài khoản:   │ │ │ 01 | TK Chính|123456| Vietcombank|100M│ │ │
│ │ [____________]  │ │ │ 02 | TK Dự phòng|098765| BIDV | 50M │ │ │
│ │ Ngân hàng:      │ │ │ ... | ... | ... | ... | ...        │ │ │
│ │ [____________]  │ │ └─────────────────────────────────────┘ │ │
│ │ Số dư:          │ │                                         │ │
│ │ [____________]  │ │ [Thêm] [Sửa] [Xóa] [Cập nhật số dư]    │ │
│ │                 │ │                                         │ │
│ │ [Thêm] [Sửa]    │ │                                         │ │
│ └─────────────────┘ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### **6. FORM BÁO CÁO TÀI CHÍNH (BaoCaoForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│                    BÁO CÁO TÀI CHÍNH                           │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────────────────────────────┐ │
│ │   TÙY CHỌN     │ │              BÁO CÁO                     │ │
│ │                 │ │                                         │ │
│ │ Loại báo cáo:   │ │ ┌─────────────────────────────────────┐ │ │
│ │ [Thu chi tổng hợp▼] │ │ │        BIỂU ĐỒ THU CHI           │ │ │
│ │                 │ │ │                                     │ │ │
│ │ Kỳ báo cáo:     │ │ │  Thu: ████████████ 50,000,000 VNĐ  │ │ │
│ │ [Tháng▼]        │ │ │  Chi: ████████ 30,000,000 VNĐ      │ │ │
│ │ Tháng: [1▼]     │ │ │  Lãi: ████ 20,000,000 VNĐ          │ │ │
│ │ Năm: [2024]     │ │ │                                     │ │ │
│ │                 │ │ └─────────────────────────────────────┘ │ │
│ │ Dự án:          │ │                                         │ │
│ │ [Tất cả▼]       │ │ ┌─────────────────────────────────────┐ │ │
│ │                 │ │ │        CHI TIẾT GIAO DỊCH            │ │ │
│ │ [Tạo báo cáo]   │ │ │ Mã | Loại | Số tiền | Ngày | Mô tả  │ │ │
│ │ [Xuất Excel]    │ │ │ 001| THU  | 5,000K  | 1/1  | Phí DV │ │ │
│ │ [In báo cáo]    │ │ │ 002| CHI  | 2,000K  | 2/1  | Lương  │ │ │
│ │                 │ │ │ ...| ...  | ...     | ...  | ...    │ │ │
│ └─────────────────┘ │ └─────────────────────────────────────┘ │ │
│                     └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### **7. FORM QUẢN LÝ DỰ ÁN (DuAnForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUẢN LÝ DỰ ÁN                               │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────────────────────────────┐ │
│ │   THÔNG TIN     │ │              DANH SÁCH DỰ ÁN            │ │
│ │                 │ │                                         │ │
│ │ Tên dự án:      │ │ ┌─────────────────────────────────────┐ │ │
│ │ [____________]  │ │ │ Mã | Tên dự án | Ngày BD | Ngày KT │ │ │
│ │ Ngày bắt đầu:   │ │ │ 01 | Mở rộng TT | 1/1/24 | 31/12/24│ │ │
│ │ [____/__/____]  │ │ │ 02 | Nâng cấp HT| 1/6/24 | 31/8/24 │ │ │
│ │ Ngày kết thúc:  │ │ │ ... | ... | ... | ...              │ │ │
│ │ [____/__/____]  │ │ └─────────────────────────────────────┘ │ │
│ │ Ngân sách:      │ │                                         │ │
│ │ [____________]  │ │ [Thêm] [Sửa] [Xóa] [Xem chi tiết]      │ │
│ │                 │ │                                         │ │
│ │ [Thêm] [Sửa]    │ │                                         │ │
│ └─────────────────┘ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

### **8. FORM QUẢN LÝ HỆ THỐNG (HeThongForm)**

```
┌─────────────────────────────────────────────────────────────────┐
│                    QUẢN LÝ HỆ THỐNG                            │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────┐ ┌─────────────────────────────────────────┐ │
│ │   MENU          │ │              NỘI DUNG                  │ │
│ │                 │ │                                         │ │
│ │ [Người dùng]    │ │  ┌─────────────────────────────────────┐ │ │
│ │ [Vai trò]       │ │  │        QUẢN LÝ NGƯỜI DÙNG           │ │ │
│ │ [Loại giao dịch]│ │  │                                     │ │ │
│ │ [Cấu hình]      │ │  │ Mã | Họ tên | Email | Vai trò | TT  │ │ │
│ │ [Backup/Restore]│ │  │ 01 | Admin  | admin@| Admin  | Hoạt │ │ │
│ │ [Log hệ thống]  │ │  │ 02 | Trưởng | tp@   | Trưởng| Hoạt │ │ │
│ │                 │ │  │ ... | ...   | ...   | ...   | ...  │ │ │
│ │                 │ │  └─────────────────────────────────────┘ │ │
│ │                 │ │                                         │ │
│ │                 │ │ [Thêm] [Sửa] [Xóa] [Đổi mật khẩu]      │ │
│ └─────────────────┘ └─────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## III. CÁC CONTROL ĐẶC BIỆT

### **1. UserControl Dashboard**

- Hiển thị tổng quan thu chi
- Biểu đồ cột/pie chart
- Cảnh báo số dư thấp
- Giao dịch gần đây

### **2. UserControl ThongKe**

- Biểu đồ thu chi theo thời gian
- So sánh các kỳ
- Xuất báo cáo

### **3. Custom Controls**

- NumericTextBox (chỉ nhập số)
- CurrencyTextBox (format tiền tệ)
- DateRangePicker (chọn khoảng ngày)

## IV. XỬ LÝ SỰ KIỆN

### **1. Form Load**

- Load dữ liệu từ database
- Kiểm tra quyền người dùng
- Ẩn/hiện controls theo vai trò

### **2. Data Binding**

- Binding DataGridView với DataTable
- Auto-refresh khi có thay đổi
- Validation dữ liệu

### **3. Error Handling**

- Try-catch cho tất cả database operations
- Hiển thị thông báo lỗi thân thiện
- Log lỗi vào file

## V. CÔNG NGHỆ SỬ DỤNG

- **.NET Framework 4.8**
- **C# WinForms**
- **SQL Server**
- **Entity Framework** (tùy chọn)
- **Chart Controls** (System.Windows.Forms.DataVisualization)
- **Crystal Reports** (cho báo cáo)

## VI. CẤU TRÚC PROJECT

```
JobCenterFinancialManagement/
├── Forms/
│   ├── LoginForm.cs
│   ├── MainForm.cs
│   ├── GiaoDichForm.cs
│   ├── GiaoDichEditForm.cs
│   ├── TaiKhoanForm.cs
│   ├── BaoCaoForm.cs
│   ├── DuAnForm.cs
│   └── HeThongForm.cs
├── UserControls/
│   ├── DashboardUC.cs
│   └── ThongKeUC.cs
├── Models/
│   ├── GiaoDich.cs
│   ├── TaiKhoanNH.cs
│   └── ...
├── DataAccess/
│   ├── DatabaseHelper.cs
│   └── ...
├── Utils/
│   ├── ValidationHelper.cs
│   └── ...
└── Resources/
    ├── Images/
    └── ...
```

## VII. TÍNH NĂNG ĐẶC BIỆT

### **1. Real-time Updates**

- Timer cập nhật số dư tài khoản
- Notification khi có giao dịch mới

### **2. Export/Import**

- Xuất báo cáo ra Excel/PDF
- Import dữ liệu từ Excel

### **3. Security**

- Mã hóa mật khẩu
- Session timeout
- Audit log

### **4. Performance**

- Lazy loading
- Caching
- Pagination cho DataGridView
