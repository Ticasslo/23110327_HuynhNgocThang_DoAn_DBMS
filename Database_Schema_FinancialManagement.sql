-- Database Schema for Student Job Center Financial Management
-- Hệ thống quản lý thu chi tài chính - Trung tâm giới thiệu việc làm sinh viên

-- 1. Các bảng cơ sở
-- 2. Các ràng buộc constraint
-- 3. Các index
-- 4. Các trigger
-- 5. Các view
-- 6. Các function
-- 7. Các stored procedure
-- 8. Các role và phân quyền, function và procedure liên quan
-- 9. Các insert dữ liệu mẫu


-- Tạo database
CREATE DATABASE JobCenterFinancialManagementSPKT;
GO

USE JobCenterFinancialManagementSPKT;
GO

-- 1. CÁC BẢNG CƠ SỞ
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
    ngay_bo_nhiem DATE DEFAULT CAST(GETDATE() AS DATE),      -- Ngày bổ nhiệm làm trưởng phòng
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
-- Phân loại các khoản thu chi
-- Lưu ý: Mã loại giao dịch là CỐ ĐỊNH, không thay đổi trong quá trình sử dụng

-- Không có thêm sửa xóa đối với loại giao dịch

-- 'LGD_UT', N'Phí ứng tuyển việc làm', 'THU', N'Thu từ phí ứng tuyển của sinh viên'
-- 'LGD_DT', N'Phí đăng tin tuyển dụng', 'THU', N'Thu từ phí đăng tin của doanh nghiệp'
-- 'LGD_TT', N'Tài trợ từ doanh nghiệp', 'THU', N'Thu từ tài trợ của doanh nghiệp'
-- 'LGD_KHAC', N'Các khoản thu khác', 'THU', N'Các khoản thu khác'
-- 'LGD_LUONG', N'Lương nhân viên', 'CHI', N'Chi trả lương cho nhân viên'
-- 'LGD_VH', N'Chi phí vận hành', 'CHI', N'Chi phí vận hành trung tâm'
-- 'LGD_MK', N'Chi phí marketing', 'CHI', N'Chi phí quảng cáo, marketing'
-- 'LGD_MB', N'Chi phí thuê mặt bằng', 'CHI', N'Chi phí thuê mặt bằng'
CREATE TABLE LoaiGiaoDich (
    ma_loai VARCHAR(10) PRIMARY KEY,           -- Mã loại giao dịch CỐ ĐỊNH (LGD_UT, LGD_DT, ...)
    ten_loai NVARCHAR(100) NOT NULL,           -- Tên loại giao dịch (Phí dịch vụ, Lương nhân viên, ...)
    loai_thu_chi VARCHAR(10) NOT NULL,         -- Phân loại THU hoặc CHI
    mo_ta NVARCHAR(200)                        -- Mô tả chi tiết về loại giao dịch
);

-- BẢNG TÀI KHOẢN NGÂN HÀNG (TaiKhoanNH)
-- Mục đích: Quản lý các tài khoản ngân hàng ẢO của trung tâm (không phải của sinh viên/doanh nghiệp)

-- Có thể thêm, sửa, xóa -> vô hiệu hóa tài khoản ngân hàng

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

-- Có thể thêm, sửa, xóa -> vô hiệu hóa/ ngừng hoạt động dự án

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

-- Thêm giao dịch
-- Cập nhật giao dịch chỉ khi trạng thái chờ duyệt thôi
-- Không có xóa giao dịch vì giữ tính lịch sử

CREATE TABLE GiaoDich (
    ma_gd INT IDENTITY(1,1) PRIMARY KEY,       -- Mã giao dịch tự tăng (1, 2, 3, ...)
    loai_gd VARCHAR(10) NOT NULL,              -- Loại giao dịch: THU (thu tiền) hoặc CHI (chi tiền)
    so_tien DECIMAL(15,2) NOT NULL,            -- Số tiền giao dịch (phải > 0)
    ngay_gd DATETIME DEFAULT GETDATE(),        -- Ngày giờ thực hiện giao dịch
    mo_ta NVARCHAR(500),                       -- Mô tả chi tiết giao dịch (lý do thu/chi, hoàn tiền cho ai, ...)
    ma_loai VARCHAR(10) NOT NULL,              -- Mã loại giao dịch (tham chiếu LoaiGiaoDich)
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
  (trang_thai='CHO_DUYET')
  OR (
     trang_thai IN ('DA_DUYET','TU_CHOI')
     AND ma_nv_duyet IS NOT NULL
     AND ngay_duyet IS NOT NULL
     AND ngay_duyet >= ngay_gd
  )
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
CREATE INDEX IX_GiaoDich_MaLoai ON GiaoDich(ma_loai);
CREATE INDEX IX_GiaoDich_MaNvTao ON GiaoDich(ma_nv_tao);
CREATE INDEX IX_GiaoDich_MaNvDuyet ON GiaoDich(ma_nv_duyet);






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
        RAISERROR(N'Số dư sẽ âm, không thể duyệt giao dịch.', 16, 1);
        RETURN;
    END
        
  -- Cập nhật số dư
  UPDATE t
     SET t.so_du = t.so_du + tr.delta
  FROM dbo.TaiKhoanNH t
  JOIN @Transitions tr ON tr.ma_tknh = t.ma_tknh;
END;

-- TRIGGER CHẶN XÓA GIAO DỊCH
-- Mục đích: Không cho phép xóa giao dịch (bảo toàn dữ liệu lịch sử)
-- Kích hoạt: Khi DELETE trên bảng GiaoDich
-- Logic: Chặn tất cả thao tác xóa, chỉ cho phép cập nhật trạng thái
GO
CREATE OR ALTER TRIGGER TR_GiaoDich_PreventDelete
ON dbo.GiaoDich
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Chặn tất cả thao tác xóa giao dịch
    THROW 51001, N'Không được phép xóa giao dịch! Chỉ có thể cập nhật trạng thái hoặc từ chối giao dịch.', 1;
END;


-- TRIGGER SOFT-DELETE TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Khi DELETE trên TaiKhoanNH, chuyển thành cập nhật trang_thai='inactive'
-- Logic: INSTEAD OF DELETE -> UPDATE
GO
CREATE OR ALTER TRIGGER TR_TaiKhoanNH_SoftDelete
ON dbo.TaiKhoanNH
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE t
    SET t.trang_thai = 'inactive'
    FROM dbo.TaiKhoanNH t
    INNER JOIN deleted d ON d.ma_tknh = t.ma_tknh;
END;


-- TRIGGER SOFT-DELETE DỰ ÁN
-- Mục đích: Khi DELETE trên DuAn, chuyển thành cập nhật trang_thai='inactive'
-- Logic: INSTEAD OF DELETE -> UPDATE
GO
CREATE OR ALTER TRIGGER TR_DuAn_SoftDelete
ON dbo.DuAn
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE da
    SET da.trang_thai = 'inactive'
    FROM dbo.DuAn da
    INNER JOIN deleted d ON d.ma_du_an = da.ma_du_an;
END;






-- 5. VIEWS
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
 

-- VIEW DỰ ÁN
GO
CREATE VIEW V_DuAn
AS
SELECT ma_du_an, ten_du_an, ngay_bd, ngay_kt, ngan_sach, trang_thai
FROM DuAn;

-- VIEW TÀI KHOẢN NGÂN HÀNG
GO
CREATE VIEW V_TaiKhoanNH
AS
SELECT ma_tknh, ten_tk, so_tk, ngan_hang, so_du, trang_thai
FROM TaiKhoanNH;

-- VIEW NHÂN VIÊN
GO
CREATE VIEW V_NhanVien
AS
SELECT ma_nv, ho_ten, email, sdt, ma_tk
FROM NhanVien;

-- VIEW LOẠI GIAO DỊCH
GO
CREATE VIEW V_LoaiGiaoDich
AS
SELECT ma_loai, ten_loai, loai_thu_chi, mo_ta
FROM LoaiGiaoDich;






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




-- CÁC PROCEDURE CRUD (THÊM, SỬA HOẶC XÓA DỮ LIỆU)
-- PROCEDURE THÊM GIAO DỊCH MỚI
-- Mục đích: Tạo giao dịch thu/chi mới
-- Tham số: Tất cả thông tin cần thiết cho giao dịch
-- Trả về: Mã giao dịch mới được tạo
GO
CREATE PROCEDURE SP_ThemGiaoDich
    @loai_gd VARCHAR(10),                           -- Loại giao dịch (THU/CHI)
    @so_tien DECIMAL(15,2),                         -- Số tiền
    @mo_ta NVARCHAR(500),                           -- Mô tả giao dịch
    @ma_loai VARCHAR(10),                           -- Mã loại giao dịch
    @ma_tknh INT,                                   -- Mã tài khoản ngân hàng
    @ma_nv_tao INT,                                 -- Mã nhân viên tạo
    @ma_du_an INT = NULL                            -- Mã dự án (có thể NULL)
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Kiểm tra loai_gd khớp với loai_thu_chi của mã loại
        IF NOT EXISTS (
            SELECT 1
            FROM LoaiGiaoDich lgd
            WHERE lgd.ma_loai = @ma_loai
              AND lgd.loai_thu_chi = @loai_gd
        )
        BEGIN
            RAISERROR(N'Loại giao dịch không khớp THU/CHI với mã loại!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

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


-- PROCEDURE CẬP NHẬT GIAO DỊCH
-- Mục đích: Cập nhật thông tin giao dịch (chỉ khi chưa duyệt)
-- Tham số: Mã giao dịch và thông tin mới
-- Trả về: Số dòng được cập nhật
GO
CREATE PROCEDURE SP_SuaGiaoDich
    @ma_gd INT,                                     -- Mã giao dịch cần sửa
    @so_tien DECIMAL(15,2),                         -- Số tiền mới
    @mo_ta NVARCHAR(500),                           -- Mô tả mới
    @ma_loai VARCHAR(10),                           -- Mã loại giao dịch mới
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
        
        -- Kiểm tra loai_gd hiện tại khớp với loai_thu_chi của mã loại mới
        DECLARE @loai_gd_hien_tai VARCHAR(10);
        SELECT @loai_gd_hien_tai = loai_gd FROM GiaoDich WHERE ma_gd = @ma_gd;

        IF NOT EXISTS (
            SELECT 1
            FROM LoaiGiaoDich lgd
            WHERE lgd.ma_loai = @ma_loai
              AND lgd.loai_thu_chi = @loai_gd_hien_tai
        )
        BEGIN
            RAISERROR(N'Loại giao dịch không khớp THU/CHI với mã loại!', 16, 1);
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


-- PROCEDURE CẬP NHẬT DỰ ÁN
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
-- Các procedure và function liên quan tới việc đăng nhập và gán quyền hạn
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
  IF (@role IS NULL OR @role = 'UNKNOWN')
  BEGIN
    RAISERROR(N'Không tìm thấy vai trò ứng với tài khoản trong dữ liệu ứng dụng.', 16, 1);
    RETURN;
  END
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
GO


-- PHÂN QUYỀN (GRANT)
-- CÁC ROLE PHỤC VỤ PHẦN PHÂN QUYỀN
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type='R' AND name='rl_truongphong')
  CREATE ROLE rl_truongphong AUTHORIZATION dbo;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type='R' AND name='rl_nhanvien_tc')
  CREATE ROLE rl_nhanvien_tc AUTHORIZATION dbo;
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE type='R' AND name='rl_ketoan')
  CREATE ROLE rl_ketoan AUTHORIZATION dbo;
GO

-- QUYỀN CHO TRƯỞNG PHÒNG
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoan TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON LoaiGiaoDich TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoanNH TO rl_truongphong;
GRANT SELECT, INSERT, UPDATE, DELETE ON DuAn TO rl_truongphong;
GRANT SELECT, INSERT ON GiaoDich TO rl_truongphong; -- UPDATE phải thông qua SP_SuaGiaoDich

GRANT SELECT ON V_ThongKeThang TO rl_truongphong;
GRANT SELECT ON V_GiaoDichChoDuyet TO rl_truongphong;
GRANT SELECT ON V_LichSuGiaoDich TO rl_truongphong;
GRANT SELECT ON V_DuAn TO rl_truongphong;
GRANT SELECT ON V_TaiKhoanNH TO rl_truongphong;
GRANT SELECT ON V_NhanVien TO rl_truongphong;
GRANT SELECT ON V_LoaiGiaoDich TO rl_truongphong;

GRANT EXECUTE ON FN_TinhLaiLo TO rl_truongphong;
GRANT EXECUTE ON FN_KiemTraSoDu TO rl_truongphong;
GRANT SELECT ON FN_TinhTongThuChi TO rl_truongphong;
GRANT SELECT ON dbo.FN_Login_GetRole TO rl_truongphong;

GRANT EXECUTE ON SP_DuyetGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO rl_truongphong;
GRANT EXECUTE ON SP_ThemGiaoDich TO rl_truongphong;
GRANT EXECUTE ON SP_SuaGiaoDich TO rl_truongphong;
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
GRANT SELECT ON NhanVien TO rl_nhanvien_tc;
GRANT SELECT ON LoaiGiaoDich TO rl_nhanvien_tc;
GRANT SELECT ON TaiKhoanNH TO rl_nhanvien_tc;
GRANT SELECT ON DuAn TO rl_nhanvien_tc;
GRANT SELECT, INSERT ON GiaoDich TO rl_nhanvien_tc; -- UPDATE phải thông qua SP_SuaGiaoDich

GRANT SELECT ON V_ThongKeThang TO rl_nhanvien_tc;
GRANT SELECT ON V_GiaoDichChoDuyet TO rl_nhanvien_tc;
GRANT SELECT ON V_LichSuGiaoDich TO rl_nhanvien_tc;
GRANT SELECT ON V_DuAn TO rl_nhanvien_tc;
GRANT SELECT ON V_TaiKhoanNH TO rl_nhanvien_tc;
GRANT SELECT ON V_NhanVien TO rl_nhanvien_tc;
GRANT SELECT ON V_LoaiGiaoDich TO rl_nhanvien_tc;

GRANT EXECUTE ON FN_TinhLaiLo TO rl_nhanvien_tc;
GRANT EXECUTE ON FN_KiemTraSoDu TO rl_nhanvien_tc;
GRANT SELECT ON FN_TinhTongThuChi TO rl_nhanvien_tc;
GRANT SELECT ON dbo.FN_Login_GetRole TO rl_nhanvien_tc;

GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_ThemGiaoDich TO rl_nhanvien_tc;
GRANT EXECUTE ON SP_SuaGiaoDich TO rl_nhanvien_tc;

-- QUYỀN CHO KẾ TOÁN (READ-ONLY)
GRANT SELECT ON NhanVien TO rl_ketoan;
GRANT SELECT ON LoaiGiaoDich TO rl_ketoan;
GRANT SELECT ON TaiKhoanNH TO rl_ketoan;
GRANT SELECT ON DuAn TO rl_ketoan;
GRANT SELECT ON GiaoDich TO rl_ketoan;

GRANT SELECT ON V_DuAn TO rl_ketoan;
GRANT SELECT ON V_TaiKhoanNH TO rl_ketoan;
GRANT SELECT ON V_NhanVien TO rl_ketoan;
GRANT SELECT ON V_LoaiGiaoDich TO rl_ketoan;
GRANT SELECT ON V_ThongKeThang TO rl_ketoan;
GRANT SELECT ON V_GiaoDichChoDuyet TO rl_ketoan;
GRANT SELECT ON V_LichSuGiaoDich TO rl_ketoan;

GRANT EXECUTE ON FN_TinhLaiLo TO rl_ketoan;
GRANT EXECUTE ON FN_KiemTraSoDu TO rl_ketoan;
GRANT SELECT ON FN_TinhTongThuChi TO rl_ketoan;
GRANT SELECT ON dbo.FN_Login_GetRole TO rl_ketoan;

GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO rl_ketoan;


-- DENY
DENY UPDATE (so_du) ON dbo.TaiKhoanNH TO rl_truongphong, rl_nhanvien_tc, rl_ketoan;
DENY DELETE ON dbo.GiaoDich TO rl_truongphong, rl_nhanvien_tc, rl_ketoan;






-- 9. INSERT DỮ LIỆU MẪU
-- Lưu ý: Insert vào TaiKhoan
-- Dùng SP_ProvisionSqlAccount để tạo tài khoản SQL account của nhân viên khi có tài khoản trong table TaiKhoan
INSERT INTO TaiKhoan (username, password) VALUES 
('truongphong', 'tp123'),
('nhanvientc', 'nvtc123'),
('ketoan', 'kt123');

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


-- TẠO LOGIN CHO 3 TÀI KHOẢN MẪU
-- Yêu cầu quyền server: securityadmin/sysadmin.
EXEC SP_ProvisionSqlAccount 'truongphong', 'tp123';
EXEC SP_ProvisionSqlAccount 'nhanvientc', 'nvtc123';
EXEC SP_ProvisionSqlAccount 'ketoan', 'kt123';

-- XÓA LOGIN (ROLLBACK) CHO 3 TÀI KHOẢN MẪU
-- EXEC SP_DropSqlAccount 'truongphong';
-- EXEC SP_DropSqlAccount 'nhanvientc';
-- EXEC SP_DropSqlAccount 'ketoan';


-- CÁC LOẠI GIAO DỊCH CỐ ĐỊNH (mã cố định, không thay đổi nên không có thêm sửa xóa)
INSERT INTO LoaiGiaoDich (ma_loai, ten_loai, loai_thu_chi, mo_ta) VALUES 
('LGD_UT', N'Phí ứng tuyển việc làm', 'THU', N'Thu từ phí ứng tuyển của sinh viên'),
('LGD_DT', N'Phí đăng tin tuyển dụng', 'THU', N'Thu từ phí đăng tin của doanh nghiệp'),
('LGD_TT', N'Tài trợ từ doanh nghiệp', 'THU', N'Thu từ tài trợ của doanh nghiệp'),
('LGD_KHAC', N'Các khoản thu khác', 'THU', N'Các khoản thu khác'),
('LGD_LUONG', N'Lương nhân viên', 'CHI', N'Chi trả lương cho nhân viên'),
('LGD_VH', N'Chi phí vận hành', 'CHI', N'Chi phí vận hành trung tâm'),
('LGD_MK', N'Chi phí marketing', 'CHI', N'Chi phí quảng cáo, marketing'),
('LGD_MB', N'Chi phí thuê mặt bằng', 'CHI', N'Chi phí thuê mặt bằng');

-- Có thể thêm, cập nhật, vô hiệu hóa tài khoản ngân hàng
INSERT INTO TaiKhoanNH (ten_tk, so_tk, ngan_hang, so_du) VALUES 
(N'Tài khoản chính', '1234567890', N'Vietcombank', 100000000),
(N'Tài khoản dự phòng', '0987654321', N'BIDV', 50000000),
(N'Tài khoản hoạt động', '2223334445', N'ACB', 30000000);

-- Có thể thêm, cập nhật, vô hiệu hóa/ ngừng hoạt động dự án
INSERT INTO DuAn (ten_du_an, ngay_bd, ngay_kt, ngan_sach) VALUES 
(N'Dự án nâng cấp website tuyển dụng', '2024-06-01', '2024-08-31', 200000000),
(N'Dự án quảng bá tuyển dụng', '2024-09-01', NULL, 150000000),
(N'Dự án đào tạo kỹ năng phỏng vấn', '2024-03-01', '2024-12-31', 100000000),
(N'Dự án kết nối doanh nghiệp', '2024-01-01', NULL, 300000000),
(N'Dự án hội chợ việc làm', '2024-10-01', '2024-10-31', 50000000),
(N'Dự án hỗ trợ sinh viên khó khăn', '2024-02-01', NULL, 80000000);


-- Giao dịch mẫu
-- Giao dịch thêm, cập nhật chỉ khi chưa duyệt, không có xóa
DECLARE @gd INT;

-- === GIAO DỊCH THU PHÍ ỨNG TUYỂN (từng sinh viên) ===
-- Sinh viên Nguyễn Văn A
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000, N'Thu phí ứng tuyển từ sinh viên Nguyễn Văn A', 'LGD_UT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Sinh viên Trần Thị B
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000, N'Thu phí ứng tuyển từ sinh viên Trần Thị B', 'LGD_UT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Sinh viên Lê Văn C
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000, N'Thu phí ứng tuyển từ sinh viên Lê Văn C', 'LGD_UT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000, N'Thu phí ứng tuyển từ sinh viên D', 'LGD_UT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000, N'Thu phí ứng tuyển từ sinh viên E', 'LGD_UT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000, N'Thu phí ứng tuyển từ sinh viên F', 'LGD_UT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';



-- === GIAO DỊCH THU PHÍ ĐĂNG TIN (từng doanh nghiệp) ===
-- Công ty ABC
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 200000, N'Thu phí đăng tin từ công ty ABC', 'LGD_DT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Công ty XYZ
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 200000, N'Thu phí đăng tin từ công ty XYZ', 'LGD_DT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Công ty DEF
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 200000, N'Thu phí đăng tin từ công ty DEF', 'LGD_DT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 300000, N'Thu phí đăng tin từ công ty GHI', 'LGD_DT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 300000, N'Thu phí đăng tin từ công ty JKL', 'LGD_DT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 300000, N'Thu phí đăng tin từ công ty MNO', 'LGD_DT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';



-- === GIAO DỊCH THU TÀI TRỢ ===
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 2000000, N'Thu tài trợ từ công ty ABC cho dự án kết nối doanh nghiệp', 'LGD_TT', 2, 3, 4);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 500000, N'Thu tài trợ từ công ty XYZ cho dự án hỗ trợ sinh viên', 'LGD_TT', 1, 2, 6);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 20000000, N'Tài trợ từ doanh nghiệp PQR cho dự án kết nối', 'LGD_TT', 1, 2, 4);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 10000000, N'Tài trợ từ doanh nghiệp STU cho hoạt động trung tâm', 'LGD_TT', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('THU', 5000000, N'Đồng tài trợ từ doanh nghiệp VWX cho chiến dịch truyền thông', 'LGD_TT', 1, 2, 2);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';



-- === GIAO DỊCH CHI ===
-- Lương nhân viên
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('CHI', 15000000, N'Chi lương nhân viên tháng 9', 'LGD_LUONG', 1, 3, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Vận hành
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('CHI', 5000000, N'Chi phí vận hành trung tâm', 'LGD_VH', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Chi phí dự án đào tạo
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('CHI', 2000000, N'Chi phí thuê giảng viên dự án đào tạo', 'LGD_VH', 1, 2, 3);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Chi phí hội chợ việc làm
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('CHI', 3000000, N'Chi phí thuê gian hàng hội chợ việc làm', 'LGD_VH', 2, 3, 5);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Marketing dự án
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('CHI', 1500000, N'Chi phí marketing dự án quảng bá', 'LGD_MK', 3, 3, 2);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';

-- Chi phí thuê mặt bằng
INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
VALUES ('CHI', 8000000, N'Chi phí thuê mặt bằng trung tâm', 'LGD_MB', 1, 2, NULL);
SET @gd = SCOPE_IDENTITY();
EXEC SP_DuyetGiaoDich @gd, 1, 'DA_DUYET';