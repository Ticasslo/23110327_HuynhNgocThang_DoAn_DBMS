-- Database Schema for Student Job Center Financial Management
-- Hệ thống quản lý thu chi tài chính - Trung tâm giới thiệu việc làm sinh viên

-- Tạo database
CREATE DATABASE JobCenterFinancialManagement;
GO

USE JobCenterFinancialManagement;
GO
 

-- 1. TẠO CÁC BẢNG CƠ SỞ
CREATE TABLE TaiKhoan (
    ma_tk INT IDENTITY(1,1) PRIMARY KEY,       -- Mã tài khoản tự tăng (1, 2, 3, ...)
    username VARCHAR(50) UNIQUE NOT NULL,      -- Tên đăng nhập (duy nhất trong hệ thống)
    password VARCHAR(255) NOT NULL,            -- Mật khẩu
    trang_thai VARCHAR(20) DEFAULT 'active'    -- Trạng thái tài khoản (active/inactive)
);

-- BẢNG NHÂN VIÊN là bảng cha của các bảng con TruongPhongTC, NhanVienTC, KeToan
CREATE TABLE NhanVien (
    ma_nv INT IDENTITY(1,1) PRIMARY KEY,       -- Mã nhân viên tự tăng (1, 2, 3, ...)
    ho_ten NVARCHAR(100) NOT NULL,             -- Họ và tên đầy đủ của nhân viên
    email VARCHAR(100) UNIQUE NOT NULL,        -- Email liên lạc (duy nhất, dùng để gửi thông báo)
    sdt VARCHAR(20),                           -- Số điện thoại liên lạc
    ma_tk INT UNIQUE NOT NULL,                 -- Mã tài khoản đăng nhập (1-1 với bảng TaiKhoan)
    FOREIGN KEY (ma_tk) REFERENCES TaiKhoan(ma_tk)
);

CREATE TABLE TruongPhongTC (
    ma_nv INT PRIMARY KEY,                     -- Mã nhân viên (khóa chính và khóa ngoại)
    quyen_han NVARCHAR(200),                   -- Quyền hạn đặc biệt của trưởng phòng
    ngay_bo_nhiem DATE DEFAULT GETDATE(),      -- Ngày bổ nhiệm làm trưởng phòng
    FOREIGN KEY (ma_nv) REFERENCES NhanVien(ma_nv) ON DELETE CASCADE
);

CREATE TABLE NhanVienTC (
    ma_nv INT PRIMARY KEY,                     -- Mã nhân viên (khóa chính và khóa ngoại)
    chuyen_mon NVARCHAR(100),                  -- Chuyên môn (Kế toán, Tài chính, ...)
    cap_bac VARCHAR(20) DEFAULT 'NhanVien',    -- Cấp bậc (NhanVien, ChuyenVien, ...)
    FOREIGN KEY (ma_nv) REFERENCES NhanVien(ma_nv) ON DELETE CASCADE
);

CREATE TABLE KeToan (
    ma_nv INT PRIMARY KEY,                     -- Mã nhân viên (khóa chính và khóa ngoại)
    chung_chi NVARCHAR(200),                   -- Chứng chỉ kế toán (CPA, ACCA, ...)
    kinh_nghiem INT DEFAULT 0,                 -- Số năm kinh nghiệm làm kế toán
    FOREIGN KEY (ma_nv) REFERENCES NhanVien(ma_nv) ON DELETE CASCADE
);

-- BẢNG LOẠI GIAO DỊCH (LoaiGiaoDich)
-- Phân loại các khoản thu chi (phí dịch vụ, lương, chi phí vận hành, ...)
CREATE TABLE LoaiGiaoDich (
    ma_loai INT IDENTITY(1,1) PRIMARY KEY,     -- Mã loại giao dịch tự tăng (1, 2, 3, ...)
    ten_loai NVARCHAR(100) NOT NULL,           -- Tên loại giao dịch (Phí dịch vụ, Lương nhân viên, ...)
    loai_thu_chi VARCHAR(10) NOT NULL,         -- Phân loại THU hoặc CHI
    mo_ta NVARCHAR(200)                        -- Mô tả chi tiết về loại giao dịch
);

-- BẢNG TÀI KHOẢN NGÂN HÀNG (TaiKhoanNH)
-- Mục đích: Quản lý các tài khoản ngân hàng ẢO của trung tâm (không phải của sinh viên/doanh nghiệp)
-- Lưu ý: 
--   - Đây là tài khoản ảo để quản lý nội bộ, không kết nối ngân hàng thật
--   - Sinh viên/doanh nghiệp KHÔNG có tài khoản trong hệ thống
--   - Hoàn tiền = tạo giao dịch CHI từ tài khoản trung tâm + trả tiền
--   - Ví dụ: Tài khoản chính (100tr), Tài khoản dự phòng (50tr)
CREATE TABLE TaiKhoanNH (
    ma_tknh INT IDENTITY(1,1) PRIMARY KEY,     -- Mã tài khoản ngân hàng tự tăng (1, 2, 3, ...)
    ten_tk NVARCHAR(100) NOT NULL,             -- Tên tài khoản của trung tâm (Tài khoản chính, Tài khoản dự phòng, ...)
    so_tk VARCHAR(20) UNIQUE NOT NULL,         -- Số tài khoản ảo của trung tâm (1234567890, 0987654321, ...)
    ngan_hang NVARCHAR(100) NOT NULL,          -- Tên ngân hàng (Vietcombank, BIDV, ...) - chỉ để phân loại
    so_du DECIMAL(15,2) DEFAULT 0,             -- Số dư hiện tại của trung tâm (tự động cập nhật khi có giao dịch)
    trang_thai VARCHAR(20) DEFAULT 'active'    -- Trạng thái tài khoản (active/inactive)
);

-- BẢNG DỰ ÁN (DuAn)
-- Mục đích: Quản lý các dự án/hoạt động của trung tâm có ngân sách riêng
-- Ví dụ: Mở rộng trung tâm, Nâng cấp hệ thống, Tuyển dụng đặc biệt
CREATE TABLE DuAn (
    ma_du_an INT IDENTITY(1,1) PRIMARY KEY,    -- Mã dự án tự tăng (1, 2, 3, ...)
    ten_du_an NVARCHAR(200) NOT NULL,          -- Tên dự án (Mở rộng trung tâm, Nâng cấp hệ thống, ...)
    ngay_bd DATE NOT NULL,                     -- Ngày bắt đầu dự án
    ngay_kt DATE,                              -- Ngày kết thúc dự án (NULL nếu chưa kết thúc)
    ngan_sach DECIMAL(15,2) DEFAULT 0,         -- Ngân sách dự án (tổng tiền được phân bổ)
    trang_thai VARCHAR(20) DEFAULT 'active'    -- Trạng thái dự án (active/inactive/hoan_thanh)
);

-- BẢNG GIAO DỊCH (GiaoDich) - BẢNG CHÍNH
-- Mục đích: Lưu trữ tất cả các giao dịch thu chi của trung tâm
-- Tác dụng: Ghi nhận mọi hoạt động tài chính, tạo báo cáo, kiểm soát ngân sách
-- Workflow: Tạo giao dịch → Chờ duyệt → Duyệt → Cập nhật số dư tài khoản
-- Lưu ý:
--   - THU: Thu tiền từ sinh viên/doanh nghiệp (phí dịch vụ, tài trợ, ...)
--   - CHI: Chi tiền của trung tâm (lương, vận hành, hoàn tiền, ...)
--   - Hoàn tiền = tạo giao dịch CHI + trả tiền mặt cho khách hàng
--   - Sinh viên/doanh nghiệp KHÔNG có tài khoản trong hệ thống
CREATE TABLE GiaoDich (
    ma_gd INT IDENTITY(1,1) PRIMARY KEY,       -- Mã giao dịch tự tăng (1, 2, 3, ...)
    loai_gd VARCHAR(10) NOT NULL,              -- Loại giao dịch: THU (thu tiền) hoặc CHI (chi tiền)
    so_tien DECIMAL(15,2) NOT NULL,            -- Số tiền giao dịch (phải > 0)
    ngay_gd DATETIME DEFAULT GETDATE(),        -- Ngày giờ thực hiện giao dịch
    mo_ta NVARCHAR(500),                       -- Mô tả chi tiết giao dịch (lý do thu/chi, hoàn tiền cho ai, ...)
    ma_loai INT NOT NULL,                      -- Mã loại giao dịch (tham chiếu LoaiGiaoDich)
    ma_tknh INT NOT NULL,                      -- Mã tài khoản ngân hàng (tham chiếu TaiKhoanNH)
    ma_nv_tao INT NOT NULL,                    -- Mã nhân viên tạo giao dịch (tham chiếu NhanVien)
    ma_du_an INT,                              -- Mã dự án (tham chiếu DuAn, NULL nếu không thuộc dự án)
    trang_thai VARCHAR(20) DEFAULT 'CHO_DUYET', -- Trạng thái: CHO_DUYET/DA_DUYET/TU_CHOI
    ma_nv_duyet INT,                           -- Mã nhân viên duyệt giao dịch (tham chiếu NhanVien)
    ngay_duyet DATETIME,                       -- Ngày giờ duyệt giao dịch
    FOREIGN KEY (ma_loai) REFERENCES LoaiGiaoDich(ma_loai),
    FOREIGN KEY (ma_tknh) REFERENCES TaiKhoanNH(ma_tknh),
    FOREIGN KEY (ma_nv_tao) REFERENCES NhanVien(ma_nv),
    FOREIGN KEY (ma_du_an) REFERENCES DuAn(ma_du_an),
    FOREIGN KEY (ma_nv_duyet) REFERENCES NhanVien(ma_nv)
);






-- 2. CONSTRAINTS (RÀNG BUỘC DỮ LIỆU)
-- Đảm bảo trạng thái tài khoản chỉ có 2 giá trị: active hoặc inactive
ALTER TABLE TaiKhoan ADD CONSTRAINT CK_TaiKhoan_TrangThai 
CHECK (trang_thai IN ('active', 'inactive'));

-- Đảm bảo loại thu chi chỉ có 2 giá trị: THU hoặc CHI
ALTER TABLE LoaiGiaoDich ADD CONSTRAINT CK_LoaiGiaoDich_LoaiThuChi 
CHECK (loai_thu_chi IN ('THU', 'CHI'));

-- Đảm bảo trạng thái tài khoản chỉ có 2 giá trị: active hoặc inactive
ALTER TABLE TaiKhoanNH ADD CONSTRAINT CK_TaiKhoanNH_TrangThai 
CHECK (trang_thai IN ('active', 'inactive'));

-- Đảm bảo trạng thái dự án chỉ có 3 giá trị: active, inactive, hoan_thanh
ALTER TABLE DuAn ADD CONSTRAINT CK_DuAn_TrangThai 
CHECK (trang_thai IN ('active', 'inactive', 'hoan_thanh'));

-- Đảm bảo loại giao dịch chỉ có 2 giá trị: THU hoặc CHI
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_LoaiGd 
CHECK (loai_gd IN ('THU', 'CHI'));

-- Đảm bảo trạng thái giao dịch chỉ có 3 giá trị: CHO_DUYET, DA_DUYET, TU_CHOI
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_TrangThai 
CHECK (trang_thai IN ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI'));

-- Đảm bảo số tiền giao dịch phải lớn hơn 0 (không cho phép số âm hoặc 0)
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_SoTien 
CHECK (so_tien > 0);

-- Đảm bảo giao dịch đã duyệt thì phải có người duyệt, ngày duyệt và ngày duyệt không nhỏ hơn ngày giao dịch
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_DuyetHopLe
CHECK (
  (trang_thai <> 'DA_DUYET')
  OR (ma_nv_duyet IS NOT NULL AND ngay_duyet IS NOT NULL AND ngay_duyet >= ngay_gd)
);

-- Đảm bảo ngân_sach không âm
ALTER TABLE DuAn ADD CONSTRAINT CK_DuAn_NganSach
CHECK (ngan_sach >= 0);

-- Đảm bảo kinh_nghiem không âm
ALTER TABLE KeToan ADD CONSTRAINT CK_KeToan_KinhNghiem
CHECK (kinh_nghiem >= 0);

-- Đảm bảo số dư không âm (tùy chính sách; cho phép =0)
ALTER TABLE TaiKhoanNH ADD CONSTRAINT CK_TaiKhoanNH_SoDu
CHECK (so_du >= 0);

-- Đảm bảo ngày kết thúc dự án phải sau hoặc bằng ngày bắt đầu
ALTER TABLE DuAn ADD CONSTRAINT CK_DuAn_Ngay 
CHECK (ngay_kt IS NULL OR ngay_kt >= ngay_bd);






-- 3. INDEXES
CREATE INDEX IX_GiaoDich_NgayGd ON GiaoDich(ngay_gd);
CREATE INDEX IX_GiaoDich_TrangThai ON GiaoDich(trang_thai);
CREATE INDEX IX_GiaoDich_LoaiGd ON GiaoDich(loai_gd);
CREATE INDEX IX_GiaoDich_MaDuAn ON GiaoDich(ma_du_an);
CREATE INDEX IX_GiaoDich_MaTknh ON GiaoDich(ma_tknh);






-- 4. TRIGGERS (TRIGGER TỰ ĐỘNG)
-- TRIGGER CẬP NHẬT SỐ DƯ TÀI KHOẢN SAU KHI DUYỆT GIAO DỊCH
-- Mục đích: Tự động cập nhật số dư tài khoản khi giao dịch được duyệt
-- Kích hoạt: Khi UPDATE trạng thái giao dịch thành DA_DUYET
-- Logic: Cộng tiền nếu là THU, trừ tiền nếu là CHI
GO
CREATE OR ALTER TRIGGER TR_GiaoDich_UpdateSoDu
ON dbo.GiaoDich
AFTER UPDATE
AS
BEGIN
  SET NOCOUNT ON;

  DECLARE @Transitions TABLE (
    ma_tknh INT PRIMARY KEY,
    delta DECIMAL(15,2)
  );

  INSERT INTO @Transitions(ma_tknh, delta)
  SELECT i.ma_tknh,
         SUM(CASE WHEN i.loai_gd='THU' THEN i.so_tien
                  WHEN i.loai_gd='CHI' THEN -i.so_tien ELSE 0 END) AS delta
  FROM inserted i
  JOIN deleted  d ON d.ma_gd = i.ma_gd
  WHERE d.trang_thai = 'CHO_DUYET' AND i.trang_thai = 'DA_DUYET'
  GROUP BY i.ma_tknh;

  -- Chặn âm số dư
  IF EXISTS (
    SELECT 1
    FROM dbo.TaiKhoanNH t
    JOIN @Transitions tr ON tr.ma_tknh = t.ma_tknh
    WHERE t.so_du + tr.delta < 0
  )
  BEGIN
    RAISERROR (N'Số dư sẽ âm, không thể duyệt giao dịch.', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN;
  END

  -- Cập nhật số dư
  UPDATE t
     SET t.so_du = t.so_du + tr.delta
  FROM dbo.TaiKhoanNH t
  JOIN @Transitions tr ON tr.ma_tknh = t.ma_tknh;
END;






-- 5. VIEWS
-- VIEW BÁO CÁO THU CHI TỔNG HỢP
-- Dữ liệu: Mã giao dịch, loại, số tiền, ngày, mô tả, loại giao dịch, tài khoản, người tạo, dự án, trạng thái, người duyệt
GO
CREATE VIEW V_BaoCaoThuChi
AS
SELECT 
    gd.ma_gd,                           -- Mã giao dịch
    gd.loai_gd,                         -- Loại giao dịch (THU/CHI)
    gd.so_tien,                         -- Số tiền giao dịch
    gd.ngay_gd,                         -- Ngày giờ giao dịch
    gd.mo_ta,                           -- Mô tả giao dịch
    lg.ten_loai,                        -- Tên loại giao dịch (Phí dịch vụ, Lương nhân viên, ...)
    tkn.ten_tk,                         -- Tên tài khoản ngân hàng
    tkn.ngan_hang,                      -- Tên ngân hàng
    nv.ho_ten as nguoi_tao,             -- Họ tên người tạo giao dịch
    da.ten_du_an,                       -- Tên dự án (NULL nếu không thuộc dự án)
    gd.trang_thai,                      -- Trạng thái giao dịch (CHO_DUYET/DA_DUYET/TU_CHOI)
    nv2.ho_ten as nguoi_duyet,          -- Họ tên người duyệt giao dịch
    gd.ngay_duyet                       -- Ngày giờ duyệt giao dịch
FROM GiaoDich gd
INNER JOIN LoaiGiaoDich lg ON gd.ma_loai = lg.ma_loai      -- Kết nối với bảng loại giao dịch
INNER JOIN TaiKhoanNH tkn ON gd.ma_tknh = tkn.ma_tknh      -- Kết nối với bảng tài khoản ngân hàng
INNER JOIN NhanVien nv ON gd.ma_nv_tao = nv.ma_nv          -- Kết nối với bảng nhân viên (người tạo)
LEFT JOIN DuAn da ON gd.ma_du_an = da.ma_du_an             -- Kết nối với bảng dự án (có thể NULL)
LEFT JOIN NhanVien nv2 ON gd.ma_nv_duyet = nv2.ma_nv;      -- Kết nối với bảng nhân viên (người duyệt)

-- VIEW THỐNG KÊ THU CHI THEO THÁNG
-- Mục đích: Tổng hợp thu chi theo từng tháng để tạo biểu đồ
-- Tác dụng: Hiển thị xu hướng thu chi, báo cáo tài chính theo tháng
GO
CREATE VIEW V_ThongKeThang
AS
SELECT 
    YEAR(ngay_gd) as Nam,                          -- Năm
    MONTH(ngay_gd) as Thang,                       -- Tháng
    SUM(CASE WHEN loai_gd = 'THU' THEN so_tien ELSE 0 END) as TongThu,  -- Tổng thu
    SUM(CASE WHEN loai_gd = 'CHI' THEN so_tien ELSE 0 END) as TongChi,  -- Tổng chi
    SUM(CASE WHEN loai_gd = 'THU' THEN so_tien ELSE -so_tien END) as LaiLo  -- Lãi/Lỗ
FROM GiaoDich 
WHERE trang_thai = 'DA_DUYET'                      -- Chỉ tính giao dịch đã duyệt
GROUP BY YEAR(ngay_gd), MONTH(ngay_gd)             -- Nhóm theo năm và tháng


-- VIEW GIAO DỊCH CHỜ DUYỆT
-- Mục đích: Hiển thị danh sách giao dịch đang chờ duyệt
-- Tác dụng: Giúp trưởng phòng dễ dàng duyệt giao dịch
GO
CREATE VIEW V_GiaoDichChoDuyet
AS
SELECT 
    gd.ma_gd,                                      -- Mã giao dịch
    gd.loai_gd,                                    -- Loại giao dịch (THU/CHI)
    gd.so_tien,                                    -- Số tiền
    gd.ngay_gd,                                    -- Ngày tạo giao dịch
    gd.mo_ta,                                      -- Mô tả giao dịch
    lg.ten_loai,                                   -- Tên loại giao dịch
    nv.ho_ten as nguoi_tao,                        -- Người tạo giao dịch
    da.ten_du_an                                   -- Tên dự án (nếu có)
FROM GiaoDich gd
INNER JOIN LoaiGiaoDich lg ON gd.ma_loai = lg.ma_loai
INNER JOIN NhanVien nv ON gd.ma_nv_tao = nv.ma_nv
LEFT JOIN DuAn da ON gd.ma_du_an = da.ma_du_an
WHERE gd.trang_thai = 'CHO_DUYET'                  -- Chỉ lấy giao dịch chờ duyệt


-- VIEW LỊCH SỬ GIAO DỊCH
-- Mục đích: Hiển thị toàn bộ lịch sử giao dịch với đầy đủ thông tin
-- Tác dụng: Tra cứu lịch sử, kiểm tra giao dịch, báo cáo chi tiết
GO
CREATE VIEW V_LichSuGiaoDich
AS
SELECT 
    gd.ma_gd,                                      -- Mã giao dịch
    gd.loai_gd,                                    -- Loại giao dịch (THU/CHI)
    gd.so_tien,                                    -- Số tiền
    gd.ngay_gd,                                    -- Ngày tạo giao dịch
    gd.mo_ta,                                      -- Mô tả giao dịch
    gd.trang_thai,                                 -- Trạng thái giao dịch
    lg.ten_loai,                                   -- Tên loại giao dịch
    tkn.ten_tk as tai_khoan,                       -- Tên tài khoản
    nv.ho_ten as nguoi_tao,                        -- Người tạo giao dịch
    nv_duyet.ho_ten as nguoi_duyet,                -- Người duyệt giao dịch
    gd.ngay_duyet,                                 -- Ngày duyệt giao dịch
    da.ten_du_an                                   -- Tên dự án (nếu có)
FROM GiaoDich gd
INNER JOIN LoaiGiaoDich lg ON gd.ma_loai = lg.ma_loai
INNER JOIN TaiKhoanNH tkn ON gd.ma_tknh = tkn.ma_tknh
INNER JOIN NhanVien nv ON gd.ma_nv_tao = nv.ma_nv
LEFT JOIN NhanVien nv_duyet ON gd.ma_nv_duyet = nv_duyet.ma_nv
LEFT JOIN DuAn da ON gd.ma_du_an = da.ma_du_an
 





-- 6. FUNCTIONS
-- FUNCTION TÍNH TỔNG THU CHI THEO KHOẢNG THỜI GIAN
-- Mục đích: Tính tổng thu chi trong một khoảng thời gian cụ thể
-- Tham số: 
--   @ngay_bd: Ngày bắt đầu (DATETIME)
--   @ngay_kt: Ngày kết thúc (DATETIME) 
--   @ma_du_an: Mã dự án (INT, NULL nếu tính tổng tất cả dự án)
-- Trả về: Bảng với loai_gd, tong_tien, so_giao_dich
-- Sử dụng: Báo cáo tài chính, thống kê thu chi
GO
CREATE FUNCTION FN_TinhTongThuChi(
    @ngay_bd DATETIME,                    -- Ngày bắt đầu tính toán
    @ngay_kt DATETIME,                    -- Ngày kết thúc tính toán
    @ma_du_an INT = NULL                  -- Mã dự án (NULL = tất cả dự án)
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        loai_gd,                          -- Loại giao dịch (THU/CHI)
        SUM(so_tien) as tong_tien,        -- Tổng số tiền theo loại
        COUNT(*) as so_giao_dich          -- Số lượng giao dịch theo loại
    FROM GiaoDich 
    WHERE ngay_gd >= @ngay_bd                       -- Trong khoảng thời gian, tính TRỌN ngày kết thúc (>= @ngay_bd và < @ngay_kt+1 ngày)
      AND ngay_gd < DATEADD(DAY, 1, @ngay_kt)
      AND trang_thai = 'DA_DUYET'                   -- Chỉ tính giao dịch đã duyệt
      AND (@ma_du_an IS NULL OR ma_du_an = @ma_du_an)  -- Theo dự án (nếu có)
    GROUP BY loai_gd                      -- Nhóm theo loại giao dịch
);


-- FUNCTION TÍNH LÃI/LỖ THEO KHOẢNG THỜI GIAN
-- Mục đích: Tính lãi/lỗ trong một khoảng thời gian cụ thể
-- Tham số: @ngay_bd (ngày bắt đầu), @ngay_kt (ngày kết thúc), @ma_du_an (mã dự án, NULL = tất cả)
-- Trả về: Số tiền lãi/lỗ (DECIMAL)
-- Sử dụng: Báo cáo tài chính, thống kê hiệu quả
GO
CREATE FUNCTION FN_TinhLaiLo(
    @ngay_bd DATETIME,                             -- Ngày bắt đầu tính toán
    @ngay_kt DATETIME,                             -- Ngày kết thúc tính toán
    @ma_du_an INT = NULL                           -- Mã dự án (NULL = tất cả dự án)
)
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @tong_thu DECIMAL(15,2) = 0;          -- Tổng thu
    DECLARE @tong_chi DECIMAL(15,2) = 0;          -- Tổng chi
    
    -- Tính tổng thu chi từ giao dịch đã duyệt
    SELECT 
        @tong_thu = ISNULL(SUM(CASE WHEN loai_gd = 'THU' THEN so_tien ELSE 0 END), 0),
        @tong_chi = ISNULL(SUM(CASE WHEN loai_gd = 'CHI' THEN so_tien ELSE 0 END), 0)
    FROM GiaoDich 
    WHERE ngay_gd >= @ngay_bd                       -- Trong khoảng thời gian, tính TRỌN ngày kết thúc (>= @ngay_bd và < @ngay_kt+1 ngày)
      AND ngay_gd < DATEADD(DAY, 1, @ngay_kt)
      AND trang_thai = 'DA_DUYET'                   -- Chỉ tính giao dịch đã duyệt
      AND (@ma_du_an IS NULL OR ma_du_an = @ma_du_an);  -- Theo dự án (nếu có)
    
    -- Trả về lãi/lỗ (thu - chi)
    RETURN @tong_thu - @tong_chi;
END;


-- FUNCTION KIỂM TRA SỐ DƯ TÀI KHOẢN
-- Mục đích: Lấy số dư hiện tại của một tài khoản ngân hàng
-- Tham số: @ma_tknh (mã tài khoản ngân hàng)
-- Trả về: Số dư tài khoản (DECIMAL)
-- Sử dụng: Kiểm tra số dư trước khi tạo giao dịch chi
GO
CREATE FUNCTION FN_KiemTraSoDu(@ma_tknh INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
    DECLARE @so_du DECIMAL(15,2);
    
    -- Lấy số dư hiện tại của tài khoản
    SELECT @so_du = so_du
    FROM TaiKhoanNH
    WHERE ma_tknh = @ma_tknh;
    
    -- Trả về số dư (0 nếu không tìm thấy)
    RETURN ISNULL(@so_du, 0);
END;






-- 7. STORED PROCEDURES
-- PROCEDURE DUYỆT GIAO DỊCH
-- Mục đích: Duyệt hoặc từ chối giao dịch (chỉ Admin và Trưởng phòng)
-- Tham số:
--   @ma_gd: Mã giao dịch cần duyệt (INT)
--   @ma_nv_duyet: Mã nhân viên duyệt (INT)
--   @trang_thai: Trạng thái mới (DA_DUYET/TU_CHOI)
-- Logic: Kiểm tra quyền → Cập nhật giao dịch → Trigger tự động cập nhật số dư
GO
CREATE PROCEDURE SP_DuyetGiaoDich
    @ma_gd INT,                              -- Mã giao dịch cần duyệt
    @ma_nv_duyet INT,                        -- Mã nhân viên thực hiện duyệt
    @trang_thai VARCHAR(20)                  -- Trạng thái mới (DA_DUYET/TU_CHOI)
AS
BEGIN
    BEGIN TRANSACTION;                       -- Bắt đầu transaction để đảm bảo tính nhất quán
    
    BEGIN TRY
        -- Kiểm tra giao dịch có tồn tại và đang chờ duyệt không
        IF NOT EXISTS (SELECT 1 FROM GiaoDich WHERE ma_gd = @ma_gd AND trang_thai = 'CHO_DUYET')
        BEGIN
            RAISERROR(N'Giao dịch không tồn tại hoặc không ở trạng thái chờ duyệt!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra quyền duyệt (chỉ Trưởng phòng mới được duyệt)
        IF NOT EXISTS (
            SELECT 1 FROM TruongPhongTC tp
            WHERE tp.ma_nv = @ma_nv_duyet
        )
        BEGIN
            RAISERROR(N'Không có quyền duyệt giao dịch!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra số dư nếu là giao dịch chi tại thời điểm duyệt
        DECLARE @loai_gd_cur VARCHAR(10);
        DECLARE @ma_tknh_cur INT;
        DECLARE @so_tien_cur DECIMAL(15,2);
        SELECT @loai_gd_cur = loai_gd, @ma_tknh_cur = ma_tknh, @so_tien_cur = so_tien
        FROM GiaoDich WHERE ma_gd = @ma_gd;

        IF @trang_thai = 'DA_DUYET' AND @loai_gd_cur = 'CHI'
        BEGIN
            DECLARE @so_du_hien_tai DECIMAL(15,2);
            SELECT @so_du_hien_tai = so_du FROM TaiKhoanNH WHERE ma_tknh = @ma_tknh_cur;
            IF @so_du_hien_tai < @so_tien_cur
            BEGIN
                RAISERROR(N'Số dư tài khoản không đủ để duyệt giao dịch chi!', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
        END

        -- Cập nhật giao dịch với thông tin duyệt
        UPDATE GiaoDich 
        SET trang_thai = @trang_thai,        -- Cập nhật trạng thái mới
            ma_nv_duyet = @ma_nv_duyet,      -- Ghi lại người duyệt
            ngay_duyet = GETDATE()           -- Ghi lại thời gian duyệt
        WHERE ma_gd = @ma_gd;
        
        COMMIT TRANSACTION;                  -- Xác nhận transaction
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;                -- Hủy transaction nếu có lỗi
        THROW;                               -- Ném lại lỗi
    END CATCH
END;


-- PROCEDURE XUẤT BÁO CÁO CHI TIẾT
-- Mục đích: Xuất báo cáo giao dịch chi tiết theo thời gian và dự án
-- Tham số: @ngay_bd (ngày bắt đầu), @ngay_kt (ngày kết thúc), @ma_du_an (mã dự án, NULL = tất cả)
-- Trả về: Danh sách giao dịch với đầy đủ thông tin
-- Sử dụng: Xuất báo cáo Excel, in ấn, gửi email
GO
CREATE PROCEDURE SP_XuatBaoCaoChiTiet
    @ngay_bd DATETIME,                             -- Ngày bắt đầu báo cáo
    @ngay_kt DATETIME,                             -- Ngày kết thúc báo cáo
    @ma_du_an INT = NULL                           -- Mã dự án (NULL = tất cả dự án)
AS
BEGIN
    SELECT 
        gd.ma_gd,                                  -- Mã giao dịch
        gd.loai_gd,                                -- Loại giao dịch (THU/CHI)
        gd.so_tien,                                -- Số tiền
        gd.ngay_gd,                                -- Ngày tạo giao dịch
        gd.mo_ta,                                  -- Mô tả giao dịch
        gd.trang_thai,                             -- Trạng thái giao dịch
        lg.ten_loai,                               -- Tên loại giao dịch
        tkn.ten_tk as tai_khoan,                   -- Tên tài khoản
        nv.ho_ten as nguoi_tao,                    -- Người tạo giao dịch
        nv_duyet.ho_ten as nguoi_duyet,            -- Người duyệt giao dịch
        gd.ngay_duyet,                             -- Ngày duyệt giao dịch
        da.ten_du_an                               -- Tên dự án (nếu có)
    FROM GiaoDich gd
    INNER JOIN LoaiGiaoDich lg ON gd.ma_loai = lg.ma_loai
    INNER JOIN TaiKhoanNH tkn ON gd.ma_tknh = tkn.ma_tknh
    INNER JOIN NhanVien nv ON gd.ma_nv_tao = nv.ma_nv
    LEFT JOIN NhanVien nv_duyet ON gd.ma_nv_duyet = nv_duyet.ma_nv
    LEFT JOIN DuAn da ON gd.ma_du_an = da.ma_du_an
    WHERE gd.ngay_gd >= @ngay_bd                    -- Trong khoảng thời gian, tính TRỌN ngày kết thúc (>= @ngay_bd và < @ngay_kt+1 ngày)
      AND gd.ngay_gd < DATEADD(DAY, 1, @ngay_kt)
      AND (@ma_du_an IS NULL OR gd.ma_du_an = @ma_du_an)  -- Theo dự án (nếu có)
    ORDER BY gd.ngay_gd DESC;                      -- Sắp xếp từ mới đến cũ
END;




-- CÁC PROCEDURE CRUD (THÊM, SỬA, XÓA DỮ LIỆU)
-- PROCEDURE THÊM GIAO DỊCH MỚI
-- Mục đích: Tạo giao dịch thu/chi mới
-- Tham số: Tất cả thông tin cần thiết cho giao dịch
-- Trả về: Mã giao dịch mới được tạo
GO
CREATE PROCEDURE SP_ThemGiaoDich
    @loai_gd VARCHAR(10),                           -- Loại giao dịch (THU/CHI)
    @so_tien DECIMAL(15,2),                         -- Số tiền
    @mo_ta NVARCHAR(500),                           -- Mô tả giao dịch
    @ma_loai INT,                                   -- Mã loại giao dịch
    @ma_tknh INT,                                   -- Mã tài khoản ngân hàng
    @ma_nv_tao INT,                                 -- Mã nhân viên tạo
    @ma_du_an INT = NULL                            -- Mã dự án (có thể NULL)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm giao dịch mới
        INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
        VALUES (@loai_gd, @so_tien, @mo_ta, @ma_loai, @ma_tknh, @ma_nv_tao, @ma_du_an);
        
        -- Trả về mã giao dịch mới
        SELECT SCOPE_IDENTITY() as ma_gd_moi;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE SỬA GIAO DỊCH
-- Mục đích: Cập nhật thông tin giao dịch (chỉ khi chưa duyệt)
-- Tham số: Mã giao dịch và thông tin mới
-- Trả về: Số dòng được cập nhật
GO
CREATE PROCEDURE SP_SuaGiaoDich
    @ma_gd INT,                                     -- Mã giao dịch cần sửa
    @so_tien DECIMAL(15,2),                         -- Số tiền mới
    @mo_ta NVARCHAR(500),                           -- Mô tả mới
    @ma_loai INT,                                   -- Mã loại giao dịch mới
    @ma_tknh INT,                                   -- Mã tài khoản ngân hàng mới
    @ma_du_an INT = NULL                            -- Mã dự án mới
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra giao dịch có tồn tại và chưa duyệt không
        IF NOT EXISTS (SELECT 1 FROM GiaoDich WHERE ma_gd = @ma_gd AND trang_thai = 'CHO_DUYET')
        BEGIN
            RAISERROR(N'Giao dịch không tồn tại hoặc đã được duyệt!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Cập nhật giao dịch
        UPDATE GiaoDich 
        SET so_tien = @so_tien,
            mo_ta = @mo_ta,
            ma_loai = @ma_loai,
            ma_tknh = @ma_tknh,
            ma_du_an = @ma_du_an
        WHERE ma_gd = @ma_gd;
        
        -- Trả về số dòng được cập nhật
        SELECT @@ROWCOUNT as so_dong_cap_nhat;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE XÓA GIAO DỊCH
-- Mục đích: Xóa giao dịch (chỉ khi chưa duyệt)
-- Tham số: Mã giao dịch cần xóa
-- Trả về: Số dòng được xóa
GO
CREATE PROCEDURE SP_XoaGiaoDich
    @ma_gd INT                                      -- Mã giao dịch cần xóa
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra giao dịch có tồn tại và chưa duyệt không
        IF NOT EXISTS (SELECT 1 FROM GiaoDich WHERE ma_gd = @ma_gd AND trang_thai = 'CHO_DUYET')
        BEGIN
            RAISERROR(N'Giao dịch không tồn tại hoặc đã được duyệt!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Xóa giao dịch
        DELETE FROM GiaoDich WHERE ma_gd = @ma_gd;
        
        -- Trả về số dòng được xóa
        SELECT @@ROWCOUNT as so_dong_da_xoa;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE THÊM DỰ ÁN MỚI
-- Mục đích: Tạo dự án mới
-- Tham số: Thông tin dự án
-- Trả về: Mã dự án mới được tạo
GO
CREATE PROCEDURE SP_ThemDuAn
    @ten_du_an NVARCHAR(200),                       -- Tên dự án
    @ngay_bd DATE,                                  -- Ngày bắt đầu
    @ngay_kt DATE = NULL,                           -- Ngày kết thúc (có thể NULL)
    @ngan_sach DECIMAL(15,2) = 0                    -- Ngân sách dự án
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm dự án mới
        INSERT INTO DuAn (ten_du_an, ngay_bd, ngay_kt, ngan_sach)
        VALUES (@ten_du_an, @ngay_bd, @ngay_kt, @ngan_sach);
        
        -- Trả về mã dự án mới
        SELECT SCOPE_IDENTITY() as ma_du_an_moi;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE SỬA DỰ ÁN
-- Mục đích: Cập nhật thông tin dự án
-- Tham số: Mã dự án và thông tin mới
-- Trả về: Số dòng được cập nhật
GO
CREATE PROCEDURE SP_SuaDuAn
    @ma_du_an INT,                                  -- Mã dự án cần sửa
    @ten_du_an NVARCHAR(200),                       -- Tên dự án mới
    @ngay_bd DATE,                                  -- Ngày bắt đầu mới
    @ngay_kt DATE = NULL,                           -- Ngày kết thúc mới
    @ngan_sach DECIMAL(15,2),                       -- Ngân sách mới
    @trang_thai VARCHAR(20) = 'active'              -- Trạng thái mới
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra dự án có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM DuAn WHERE ma_du_an = @ma_du_an)
        BEGIN
            RAISERROR(N'Dự án không tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Cập nhật dự án
        UPDATE DuAn 
        SET ten_du_an = @ten_du_an,
            ngay_bd = @ngay_bd,
            ngay_kt = @ngay_kt,
            ngan_sach = @ngan_sach,
            trang_thai = @trang_thai
        WHERE ma_du_an = @ma_du_an;
        
        -- Trả về số dòng được cập nhật
        SELECT @@ROWCOUNT as so_dong_cap_nhat;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE XÓA DỰ ÁN
-- Mục đích: Xóa dự án (chỉ khi không có giao dịch liên quan)
-- Tham số: Mã dự án cần xóa
-- Trả về: Số dòng được xóa
GO
CREATE PROCEDURE SP_XoaDuAn
    @ma_du_an INT                                   -- Mã dự án cần xóa
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra dự án có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM DuAn WHERE ma_du_an = @ma_du_an)
        BEGIN
            RAISERROR(N'Dự án không tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra có giao dịch liên quan không
        IF EXISTS (SELECT 1 FROM GiaoDich WHERE ma_du_an = @ma_du_an)
        BEGIN
            RAISERROR(N'Không thể xóa dự án có giao dịch liên quan!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Xóa dự án
        DELETE FROM DuAn WHERE ma_du_an = @ma_du_an;
        
        -- Trả về số dòng được xóa
        SELECT @@ROWCOUNT as so_dong_da_xoa;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE THÊM TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Tạo tài khoản ngân hàng mới
-- Tham số: Thông tin tài khoản
-- Trả về: Mã tài khoản mới được tạo
GO
CREATE PROCEDURE SP_ThemTaiKhoanNH
    @ten_tk NVARCHAR(100),                          -- Tên tài khoản
    @so_tk VARCHAR(20),                             -- Số tài khoản
    @ngan_hang NVARCHAR(100),                       -- Tên ngân hàng
    @so_du DECIMAL(15,2) = 0                        -- Số dư ban đầu
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra số tài khoản đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM TaiKhoanNH WHERE so_tk = @so_tk)
        BEGIN
            RAISERROR(N'Số tài khoản đã tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Thêm tài khoản mới
        INSERT INTO TaiKhoanNH (ten_tk, so_tk, ngan_hang, so_du)
        VALUES (@ten_tk, @so_tk, @ngan_hang, @so_du);
        
        -- Trả về mã tài khoản mới
        SELECT SCOPE_IDENTITY() as ma_tknh_moi;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE SỬA TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Cập nhật thông tin tài khoản ngân hàng
-- Tham số: Mã tài khoản và thông tin mới
-- Trả về: Số dòng được cập nhật
GO
CREATE PROCEDURE SP_SuaTaiKhoanNH
    @ma_tknh INT,                                   -- Mã tài khoản cần sửa
    @ten_tk NVARCHAR(100),                          -- Tên tài khoản mới
    @so_tk VARCHAR(20),                             -- Số tài khoản mới
    @ngan_hang NVARCHAR(100),                       -- Tên ngân hàng mới
    @trang_thai VARCHAR(20) = 'active'              -- Trạng thái mới
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra tài khoản có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM TaiKhoanNH WHERE ma_tknh = @ma_tknh)
        BEGIN
            RAISERROR(N'Tài khoản không tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra số tài khoản mới có trùng không
        IF EXISTS (SELECT 1 FROM TaiKhoanNH WHERE so_tk = @so_tk AND ma_tknh != @ma_tknh)
        BEGIN
            RAISERROR(N'Số tài khoản đã tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Cập nhật tài khoản
        UPDATE TaiKhoanNH 
        SET ten_tk = @ten_tk,
            so_tk = @so_tk,
            ngan_hang = @ngan_hang,
            trang_thai = @trang_thai
        WHERE ma_tknh = @ma_tknh;
        
        -- Trả về số dòng được cập nhật
        SELECT @@ROWCOUNT as so_dong_cap_nhat;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;


-- PROCEDURE XÓA TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Xóa tài khoản ngân hàng (chỉ khi không có giao dịch liên quan)
-- Tham số: Mã tài khoản cần xóa
-- Trả về: Số dòng được xóa
GO
CREATE PROCEDURE SP_XoaTaiKhoanNH
    @ma_tknh INT                                    -- Mã tài khoản cần xóa
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra tài khoản có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM TaiKhoanNH WHERE ma_tknh = @ma_tknh)
        BEGIN
            RAISERROR(N'Tài khoản không tồn tại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Kiểm tra có giao dịch liên quan không
        IF EXISTS (SELECT 1 FROM GiaoDich WHERE ma_tknh = @ma_tknh)
        BEGIN
            RAISERROR(N'Không thể xóa tài khoản có giao dịch liên quan!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        
        -- Xóa tài khoản
        DELETE FROM TaiKhoanNH WHERE ma_tknh = @ma_tknh;
        
        -- Trả về số dòng được xóa
        SELECT @@ROWCOUNT as so_dong_da_xoa;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;






-- 8. PHÂN QUYỀN CHO CÁC VAI TRÒ
-- Tạo DATABASE ROLES
CREATE ROLE rl_truongphong;
CREATE ROLE rl_nhanvien_tc;
CREATE ROLE rl_ketoan;


-- Các procedure và function liên quan tới việc đăng nhập và gán quyền hạn
-- Đưa function đăng nhập lên trước để trigger có thể gọi được
GO
CREATE FUNCTION dbo.FN_Login_GetRole(
  @username VARCHAR(50),
  @password VARCHAR(255)
)
RETURNS TABLE
AS RETURN
(
  WITH u AS (
    SELECT tk.ma_tk, nv.ma_nv
    FROM TaiKhoan tk
    JOIN NhanVien nv ON nv.ma_tk = tk.ma_tk
    WHERE tk.username = @username
      AND tk.password = @password
      AND tk.trang_thai = 'active'
  )
  SELECT TOP 1
    CASE 
      WHEN EXISTS (SELECT 1 FROM TruongPhongTC tp WHERE tp.ma_nv = u.ma_nv) THEN 'TRUONG_PHONG_TC'
      WHEN EXISTS (SELECT 1 FROM NhanVienTC nvtc WHERE nvtc.ma_nv = u.ma_nv) THEN 'NHAN_VIEN_TC'
      WHEN EXISTS (SELECT 1 FROM KeToan kt WHERE kt.ma_nv = u.ma_nv) THEN 'KE_TOAN'
      ELSE 'UNKNOWN'
    END AS vai_tro,
    u.ma_nv
  FROM u
);


-- PROCEDURE TẠO TÀI KHOẢN SQL ACCOUNT CỦA NHÂN VIÊN CHO TRƯỞNG PHÒNG
GO
CREATE OR ALTER PROCEDURE SP_ProvisionSqlAccount
  @username VARCHAR(50),
  @password VARCHAR(255)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @sql NVARCHAR(MAX), @role VARCHAR(50);

  -- Tạo LOGIN nếu chưa có (yêu cầu securityadmin/sysadmin)
  IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @username)
  BEGIN
    SET @sql = N'CREATE LOGIN [' + @username + N'] WITH PASSWORD = ' + QUOTENAME(@password,'''') + N', CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;';
    EXEC (@sql);
  END

  -- Tạo USER nếu chưa có trong database hiện tại
  IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @username)
  BEGIN
    SET @sql = N'CREATE USER [' + @username + N'] FOR LOGIN [' + @username + N'];';
    EXEC (@sql);
  END

  -- Gán ROLE dựa vào hàm xác định vai trò
  SELECT TOP 1 @role = vai_tro FROM dbo.FN_Login_GetRole(@username, @password);
  IF @role = 'TRUONG_PHONG_TC' EXEC(N'ALTER ROLE rl_truongphong ADD MEMBER [' + @username + N']');
  ELSE IF @role = 'NHAN_VIEN_TC' EXEC(N'ALTER ROLE rl_nhanvien_tc ADD MEMBER [' + @username + N']');
  ELSE IF @role = 'KE_TOAN' EXEC(N'ALTER ROLE rl_ketoan ADD MEMBER [' + @username + N']');
END;
GO

-- PROCEDURE XÓA TÀI KHOẢN SQL ACCOUNT CỦA NHÂN VIÊN CHO TRƯỞNG PHÒNG
CREATE OR ALTER PROCEDURE SP_DropSqlAccount
  @username VARCHAR(50)
AS
BEGIN
  SET NOCOUNT ON;
  DECLARE @sql NVARCHAR(MAX);

  -- Kill session nếu có
  DECLARE @sid INT; SELECT TOP 1 @sid = session_id FROM sys.dm_exec_sessions WHERE login_name = @username;
  IF @sid IS NOT NULL BEGIN SET @sql = N'KILL ' + CAST(@sid AS NVARCHAR(20)); EXEC (@sql); END

  -- Xóa USER trong DB (nếu tồn tại)
  IF EXISTS (SELECT 1 FROM sys.database_principals WHERE name = @username)
  BEGIN TRY
    SET @sql = N'DROP USER [' + @username + N']';
    EXEC (@sql);
  END TRY BEGIN CATCH END CATCH;

  -- Xóa LOGIN ở server (nếu tồn tại)
  IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = @username)
  BEGIN TRY
    SET @sql = N'DROP LOGIN [' + @username + N']';
    EXEC (@sql);
  END TRY BEGIN CATCH END CATCH;
END;


-- PHÂN QUYỀN (GRANT)
-- QUYỀN CHO TRƯỞNG PHÒNG
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoan TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON LoaiGiaoDich TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoanNH TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON DuAn TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON GiaoDich TO rl_truongphong;
GRANT SELECT ON V_BaoCaoThuChi TO rl_truongphong;
GRANT SELECT ON V_ThongKeThang TO rl_truongphong;
GRANT SELECT ON V_GiaoDichChoDuyet TO rl_truongphong;
GRANT SELECT ON V_LichSuGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_DuyetGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO rl_truongphong;
GRANT EXECUTE ON FN_TinhLaiLo TO rl_truongphong;
GRANT EXECUTE ON FN_KiemTraSoDu TO rl_truongphong;
GRANT SELECT ON FN_TinhTongThuChi TO rl_truongphong;
GRANT SELECT ON dbo.FN_Login_GetRole TO rl_truongphong;
GRANT EXECUTE ON SP_ThemGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_SuaGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_XoaGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_ThemDuAn TO rl_truongphong;
GRANT EXECUTE ON SP_SuaDuAn TO rl_truongphong;
GRANT EXECUTE ON SP_XoaDuAn TO rl_truongphong;
GRANT EXECUTE ON SP_ThemTaiKhoanNH TO rl_truongphong;
GRANT EXECUTE ON SP_SuaTaiKhoanNH TO rl_truongphong;
GRANT EXECUTE ON SP_XoaTaiKhoanNH TO rl_truongphong;

-- Cấp quyền chạy SP tạo tài khoản SQL account của nhân viên cho Trưởng phòng
GRANT EXECUTE ON SP_ProvisionSqlAccount TO rl_truongphong;
GRANT EXECUTE ON SP_DropSqlAccount TO rl_truongphong;


-- QUYỀN CHO NHÂN VIÊN TÀI CHÍNH
GRANT SELECT ON TaiKhoan TO rl_nhanvien_tc;
GRANT SELECT ON NhanVien TO rl_nhanvien_tc;
GRANT SELECT ON LoaiGiaoDich TO rl_nhanvien_tc;
GRANT SELECT ON TaiKhoanNH TO rl_nhanvien_tc;
GRANT SELECT ON DuAn TO rl_nhanvien_tc;
GRANT SELECT, INSERT, UPDATE ON GiaoDich TO rl_nhanvien_tc;
GRANT SELECT ON V_BaoCaoThuChi TO rl_nhanvien_tc;
GRANT SELECT ON V_ThongKeThang TO rl_nhanvien_tc;
GRANT SELECT ON V_GiaoDichChoDuyet TO rl_nhanvien_tc;
GRANT SELECT ON V_LichSuGiaoDich TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO rl_nhanvien_tc;
GRANT EXECUTE ON FN_TinhLaiLo TO rl_nhanvien_tc;
GRANT EXECUTE ON FN_KiemTraSoDu TO rl_nhanvien_tc;
GRANT SELECT ON FN_TinhTongThuChi TO rl_nhanvien_tc;
GRANT SELECT ON dbo.FN_Login_GetRole TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_ThemGiaoDich TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_SuaGiaoDich TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_XoaGiaoDich TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_ThemDuAn TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_SuaDuAn TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_XoaDuAn TO rl_nhanvien_tc;

-- QUYỀN CHO KẾ TOÁN (READ-ONLY)
GRANT SELECT ON TaiKhoan TO rl_ketoan;
GRANT SELECT ON NhanVien TO rl_ketoan;
GRANT SELECT ON LoaiGiaoDich TO rl_ketoan;
GRANT SELECT ON TaiKhoanNH TO rl_ketoan;
GRANT SELECT ON DuAn TO rl_ketoan;
GRANT SELECT ON GiaoDich TO rl_ketoan;
GRANT SELECT ON V_BaoCaoThuChi TO rl_ketoan;
GRANT SELECT ON V_ThongKeThang TO rl_ketoan;
GRANT SELECT ON V_GiaoDichChoDuyet TO rl_ketoan;
GRANT SELECT ON V_LichSuGiaoDich TO rl_ketoan;
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO rl_ketoan;
GRANT EXECUTE ON FN_TinhLaiLo TO rl_ketoan;
GRANT EXECUTE ON FN_KiemTraSoDu TO rl_ketoan;
GRANT SELECT ON FN_TinhTongThuChi TO rl_ketoan;
GRANT SELECT ON dbo.FN_Login_GetRole TO rl_ketoan;






-- 9. INSERT DỮ LIỆU MẪU
-- Lưu ý: Insert vào TaiKhoan
-- Dùng SP_ProvisionSqlAccount để tạo tài khoản SQL account của nhân viên khi có tài khoản trong table TaiKhoan
INSERT INTO TaiKhoan (username, password) VALUES 
('truongphong', 'tp123'),
('nhanvien_tc', 'nvtc123'),
('ketoan1', 'kt123');

INSERT INTO NhanVien (ho_ten, email, sdt, ma_tk) VALUES 
(N'Trần Thị Trưởng Phòng', 'truongphong@jobcenter.com', '0123456790', 1),
(N'Lê Văn Nhân Viên TC', 'nhanvien_tc@jobcenter.com', '0123456791', 2),
(N'Phạm Thị Kế Toán', 'ketoan@jobcenter.com', '0123456792', 3);

INSERT INTO TruongPhongTC (ma_nv, quyen_han, ngay_bo_nhiem) VALUES 
(1, N'Duyệt giao dịch, quản lý tất cả hoạt động tài chính', '2024-01-01');
INSERT INTO NhanVienTC (ma_nv, chuyen_mon, cap_bac) VALUES 
(2, N'Tài chính doanh nghiệp', 'ChuyenVien');
INSERT INTO KeToan (ma_nv, chung_chi, kinh_nghiem) VALUES 
(3, N'CPA, ACCA', 5);

INSERT INTO LoaiGiaoDich (ten_loai, loai_thu_chi, mo_ta) VALUES 
(N'Phí dịch vụ giới thiệu việc làm', 'THU', N'Thu từ phí dịch vụ giới thiệu việc làm'),
(N'Phí đăng tin tuyển dụng', 'THU', N'Thu từ phí đăng tin tuyển dụng'),
(N'Tài trợ từ doanh nghiệp', 'THU', N'Thu từ tài trợ của doanh nghiệp'),
(N'Các khoản thu khác', 'THU', N'Các khoản thu khác'),
(N'Lương nhân viên', 'CHI', N'Chi trả lương cho nhân viên'),
(N'Chi phí vận hành', 'CHI', N'Chi phí vận hành trung tâm'),
(N'Chi phí marketing', 'CHI', N'Chi phí quảng cáo, marketing'),
(N'Chi phí thuê mặt bằng', 'CHI', N'Chi phí thuê mặt bằng');

INSERT INTO TaiKhoanNH (ten_tk, so_tk, ngan_hang, so_du) VALUES 
(N'Tài khoản chính', '1234567890', N'Vietcombank', 100000000),
(N'Tài khoản dự phòng', '0987654321', N'BIDV', 50000000);

INSERT INTO DuAn (ten_du_an, ngay_bd, ngay_kt, ngan_sach) VALUES 
(N'Dự án mở rộng trung tâm', '2024-01-01', '2024-12-31', 500000000),
(N'Dự án nâng cấp hệ thống', '2024-06-01', '2024-08-31', 200000000);