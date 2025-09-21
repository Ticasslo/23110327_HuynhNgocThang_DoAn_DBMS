-- =============================================
-- Database Schema for Student Job Center Financial Management
-- Hệ thống quản lý thu chi tài chính - Trung tâm giới thiệu việc làm sinh viên
-- =============================================

-- Tạo database
CREATE DATABASE JobCenterFinancialManagement;
GO

USE JobCenterFinancialManagement;
GO

-- =============================================
-- DROP TABLES (Clean up)
-- =============================================
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_GiaoDich_CheckSoDu]') AND type in (N'TR'))
    DROP TRIGGER [dbo].[TR_GiaoDich_CheckSoDu];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TR_GiaoDich_UpdateSoDu]') AND type in (N'TR'))
    DROP TRIGGER [dbo].[TR_GiaoDich_UpdateSoDu];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FN_TinhTongThuChi]') AND type in (N'FN', N'IF', N'TF'))
    DROP FUNCTION [dbo].[FN_TinhTongThuChi];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_TaoBaoCaoTaiChinh]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[SP_TaoBaoCaoTaiChinh];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SP_DuyetGiaoDich]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[SP_DuyetGiaoDich];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[V_BaoCaoThuChi]') AND type in (N'V'))
    DROP VIEW [dbo].[V_BaoCaoThuChi];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BaoCao]') AND type in (N'U'))
    DROP TABLE [dbo].[BaoCao];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GiaoDich]') AND type in (N'U'))
    DROP TABLE [dbo].[GiaoDich];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DuAn]') AND type in (N'U'))
    DROP TABLE [dbo].[DuAn];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaiKhoanNH]') AND type in (N'U'))
    DROP TABLE [dbo].[TaiKhoanNH];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LoaiGiaoDich]') AND type in (N'U'))
    DROP TABLE [dbo].[LoaiGiaoDich];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NhanVien]') AND type in (N'U'))
    DROP TABLE [dbo].[NhanVien];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TaiKhoan]') AND type in (N'U'))
    DROP TABLE [dbo].[TaiKhoan];
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaiTro]') AND type in (N'U'))
    DROP TABLE [dbo].[VaiTro];
GO

-- =============================================
-- 1. TẠO CÁC BẢNG CƠ SỞ
-- =============================================

-- =============================================
-- BẢNG VAI TRÒ (VaiTro)
-- Mục đích: Lưu trữ các vai trò trong hệ thống (Trưởng phòng, Nhân viên, Kế toán)
-- Tác dụng: Phân quyền người dùng, xác định quyền hạn của từng người
-- Lưu ý: Không có Admin vì đây là hệ thống thu chi nội bộ
-- =============================================
CREATE TABLE VaiTro (
    ma_vai_tro VARCHAR(10) PRIMARY KEY,        -- Mã vai trò (TRUONG_PHONG, NHAN_VIEN_TC, KE_TOAN)
    ten_vai_tro NVARCHAR(50) NOT NULL          -- Tên vai trò (Trưởng phòng tài chính, Nhân viên tài chính, Kế toán)
);

-- =============================================
-- BẢNG TÀI KHOẢN ĐĂNG NHẬP (TaiKhoan)
-- Mục đích: Quản lý thông tin đăng nhập của tất cả người dùng
-- Tác dụng: Xác thực người dùng, phân quyền truy cập hệ thống
-- =============================================
CREATE TABLE TaiKhoan (
    ma_tk INT IDENTITY(1,1) PRIMARY KEY,       -- Mã tài khoản tự tăng (1, 2, 3, ...)
    username VARCHAR(50) UNIQUE NOT NULL,      -- Tên đăng nhập (duy nhất trong hệ thống)
    password VARCHAR(255) NOT NULL,            -- Mật khẩu (đã mã hóa MD5/SHA256)
    ma_vai_tro VARCHAR(10) NOT NULL,           -- Mã vai trò (tham chiếu bảng VaiTro)
    trang_thai VARCHAR(20) DEFAULT 'active',   -- Trạng thái tài khoản (active/inactive)
    FOREIGN KEY (ma_vai_tro) REFERENCES VaiTro(ma_vai_tro)
);

-- =============================================
-- BẢNG NHÂN VIÊN (NhanVien)
-- Mục đích: Lưu trữ thông tin cá nhân của nhân viên trong trung tâm
-- Tác dụng: Quản lý nhân sự, liên kết với tài khoản đăng nhập
-- =============================================
CREATE TABLE NhanVien (
    ma_nv INT IDENTITY(1,1) PRIMARY KEY,       -- Mã nhân viên tự tăng (1, 2, 3, ...)
    ho_ten NVARCHAR(100) NOT NULL,             -- Họ và tên đầy đủ của nhân viên
    email VARCHAR(100) UNIQUE NOT NULL,        -- Email liên lạc (duy nhất, dùng để gửi thông báo)
    sdt VARCHAR(20),                           -- Số điện thoại liên lạc
    ma_tk INT UNIQUE NOT NULL,                 -- Mã tài khoản đăng nhập (1-1 với bảng TaiKhoan)
    FOREIGN KEY (ma_tk) REFERENCES TaiKhoan(ma_tk)
);

-- =============================================
-- BẢNG LOẠI GIAO DỊCH (LoaiGiaoDich)
-- Mục đích: Phân loại các khoản thu chi (phí dịch vụ, lương, chi phí vận hành, ...)
-- Tác dụng: Thống kê thu chi theo danh mục, báo cáo chi tiết
-- =============================================
CREATE TABLE LoaiGiaoDich (
    ma_loai INT IDENTITY(1,1) PRIMARY KEY,     -- Mã loại giao dịch tự tăng (1, 2, 3, ...)
    ten_loai NVARCHAR(100) NOT NULL,           -- Tên loại giao dịch (Phí dịch vụ, Lương nhân viên, ...)
    loai_thu_chi VARCHAR(10) NOT NULL,         -- Phân loại THU hoặc CHI
    mo_ta NVARCHAR(200)                        -- Mô tả chi tiết về loại giao dịch
);

-- =============================================
-- BẢNG TÀI KHOẢN NGÂN HÀNG (TaiKhoanNH)
-- Mục đích: Quản lý các tài khoản ngân hàng ẢO của trung tâm (không phải của sinh viên/doanh nghiệp)
-- Tác dụng: Theo dõi số dư, quản lý thu chi theo từng tài khoản của trung tâm
-- Lưu ý: 
--   - Đây là tài khoản ảo để quản lý nội bộ, không kết nối ngân hàng thật
--   - Sinh viên/doanh nghiệp KHÔNG có tài khoản trong hệ thống
--   - Hoàn tiền = tạo giao dịch CHI từ tài khoản trung tâm + trả tiền mặt
--   - Ví dụ: Tài khoản chính (100tr), Tài khoản dự phòng (50tr)
-- =============================================
CREATE TABLE TaiKhoanNH (
    ma_tknh INT IDENTITY(1,1) PRIMARY KEY,     -- Mã tài khoản ngân hàng tự tăng (1, 2, 3, ...)
    ten_tk NVARCHAR(100) NOT NULL,             -- Tên tài khoản của trung tâm (Tài khoản chính, Tài khoản dự phòng, ...)
    so_tk VARCHAR(20) UNIQUE NOT NULL,         -- Số tài khoản ảo của trung tâm (1234567890, 0987654321, ...)
    ngan_hang NVARCHAR(100) NOT NULL,          -- Tên ngân hàng (Vietcombank, BIDV, ...) - chỉ để phân loại
    so_du DECIMAL(15,2) DEFAULT 0,             -- Số dư hiện tại của trung tâm (tự động cập nhật khi có giao dịch)
    trang_thai VARCHAR(20) DEFAULT 'active'    -- Trạng thái tài khoản (active/inactive)
);

-- =============================================
-- BẢNG DỰ ÁN (DuAn)
-- Mục đích: Quản lý các dự án/hoạt động của trung tâm có ngân sách riêng
-- Tác dụng: Phân bổ ngân sách, theo dõi thu chi theo dự án, báo cáo hiệu quả
-- Ví dụ: Mở rộng trung tâm, Nâng cấp hệ thống, Tuyển dụng đặc biệt
-- =============================================
CREATE TABLE DuAn (
    ma_du_an INT IDENTITY(1,1) PRIMARY KEY,    -- Mã dự án tự tăng (1, 2, 3, ...)
    ten_du_an NVARCHAR(200) NOT NULL,          -- Tên dự án (Mở rộng trung tâm, Nâng cấp hệ thống, ...)
    ngay_bd DATE NOT NULL,                     -- Ngày bắt đầu dự án
    ngay_kt DATE,                              -- Ngày kết thúc dự án (NULL nếu chưa kết thúc)
    ngay_sach DECIMAL(15,2) DEFAULT 0,         -- Ngân sách dự án (tổng tiền được phân bổ)
    trang_thai VARCHAR(20) DEFAULT 'active'    -- Trạng thái dự án (active/inactive/hoan_thanh)
);

-- =============================================
-- BẢNG GIAO DỊCH (GiaoDich) - BẢNG CHÍNH
-- Mục đích: Lưu trữ tất cả các giao dịch thu chi của trung tâm
-- Tác dụng: Ghi nhận mọi hoạt động tài chính, tạo báo cáo, kiểm soát ngân sách
-- Workflow: Tạo giao dịch → Chờ duyệt → Duyệt → Cập nhật số dư tài khoản
-- Lưu ý:
--   - THU: Thu tiền từ sinh viên/doanh nghiệp (phí dịch vụ, tài trợ, ...)
--   - CHI: Chi tiền của trung tâm (lương, vận hành, hoàn tiền, ...)
--   - Hoàn tiền = tạo giao dịch CHI + trả tiền mặt cho khách hàng
--   - Sinh viên/doanh nghiệp KHÔNG có tài khoản trong hệ thống
-- =============================================
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

-- =============================================
-- BẢNG BÁO CÁO (BaoCao)
-- Mục đích: Lưu trữ các báo cáo tài chính được tạo bởi hệ thống
-- Tác dụng: Lưu trữ kết quả báo cáo, in ấn, gửi email cho quản lý
-- =============================================
CREATE TABLE BaoCao (
    ma_bao_cao INT IDENTITY(1,1) PRIMARY KEY,  -- Mã báo cáo tự tăng (1, 2, 3, ...)
    ten_bao_cao NVARCHAR(200) NOT NULL,        -- Tên báo cáo (Báo cáo tháng 1/2024, ...)
    ngay_tao DATETIME DEFAULT GETDATE(),       -- Ngày tạo báo cáo
    ma_du_an INT,                              -- Mã dự án (tham chiếu DuAn, NULL nếu báo cáo tổng hợp)
    noi_dung NVARCHAR(MAX),                    -- Nội dung báo cáo (HTML/Text format)
    ma_nv_tao INT NOT NULL,                    -- Mã nhân viên tạo báo cáo (tham chiếu NhanVien)
    FOREIGN KEY (ma_du_an) REFERENCES DuAn(ma_du_an),
    FOREIGN KEY (ma_nv_tao) REFERENCES NhanVien(ma_nv)
);

-- =============================================
-- 2. CONSTRAINTS (RÀNG BUỘC DỮ LIỆU)
-- Mục đích: Đảm bảo tính toàn vẹn dữ liệu, kiểm tra giá trị hợp lệ
-- Tác dụng: Ngăn chặn dữ liệu không hợp lệ, đảm bảo logic nghiệp vụ
-- =============================================

-- =============================================
-- RÀNG BUỘC CHO BẢNG VAI TRÒ
-- Đảm bảo mã vai trò chỉ có 3 giá trị được phép (không có Admin)
-- =============================================
ALTER TABLE VaiTro ADD CONSTRAINT CK_VaiTro_MaVaiTro 
CHECK (ma_vai_tro IN ('TRUONG_PHONG', 'NHAN_VIEN_TC', 'KE_TOAN'));

-- =============================================
-- RÀNG BUỘC CHO BẢNG TÀI KHOẢN
-- Đảm bảo trạng thái tài khoản chỉ có 2 giá trị: active hoặc inactive
-- =============================================
ALTER TABLE TaiKhoan ADD CONSTRAINT CK_TaiKhoan_TrangThai 
CHECK (trang_thai IN ('active', 'inactive'));

-- =============================================
-- RÀNG BUỘC CHO BẢNG LOẠI GIAO DỊCH
-- Đảm bảo loại thu chi chỉ có 2 giá trị: THU hoặc CHI
-- =============================================
ALTER TABLE LoaiGiaoDich ADD CONSTRAINT CK_LoaiGiaoDich_LoaiThuChi 
CHECK (loai_thu_chi IN ('THU', 'CHI'));

-- =============================================
-- RÀNG BUỘC CHO BẢNG TÀI KHOẢN NGÂN HÀNG
-- Đảm bảo trạng thái tài khoản chỉ có 2 giá trị: active hoặc inactive
-- =============================================
ALTER TABLE TaiKhoanNH ADD CONSTRAINT CK_TaiKhoanNH_TrangThai 
CHECK (trang_thai IN ('active', 'inactive'));

-- =============================================
-- RÀNG BUỘC CHO BẢNG DỰ ÁN
-- Đảm bảo trạng thái dự án chỉ có 3 giá trị: active, inactive, hoan_thanh
-- =============================================
ALTER TABLE DuAn ADD CONSTRAINT CK_DuAn_TrangThai 
CHECK (trang_thai IN ('active', 'inactive', 'hoan_thanh'));

-- =============================================
-- RÀNG BUỘC CHO BẢNG GIAO DỊCH
-- Đảm bảo loại giao dịch chỉ có 2 giá trị: THU hoặc CHI
-- =============================================
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_LoaiGd 
CHECK (loai_gd IN ('THU', 'CHI'));

-- Đảm bảo trạng thái giao dịch chỉ có 3 giá trị: CHO_DUYET, DA_DUYET, TU_CHOI
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_TrangThai 
CHECK (trang_thai IN ('CHO_DUYET', 'DA_DUYET', 'TU_CHOI'));

-- Đảm bảo số tiền giao dịch phải lớn hơn 0 (không cho phép số âm hoặc 0)
ALTER TABLE GiaoDich ADD CONSTRAINT CK_GiaoDich_SoTien 
CHECK (so_tien > 0);

-- =============================================
-- RÀNG BUỘC CHO NGÀY DỰ ÁN
-- Đảm bảo ngày kết thúc dự án phải sau hoặc bằng ngày bắt đầu
-- =============================================
ALTER TABLE DuAn ADD CONSTRAINT CK_DuAn_Ngay 
CHECK (ngay_kt IS NULL OR ngay_kt >= ngay_bd);

-- =============================================
-- 3. INDEXES
-- =============================================

CREATE INDEX IX_GiaoDich_NgayGd ON GiaoDich(ngay_gd);
CREATE INDEX IX_GiaoDich_TrangThai ON GiaoDich(trang_thai);
CREATE INDEX IX_GiaoDich_LoaiGd ON GiaoDich(loai_gd);
CREATE INDEX IX_GiaoDich_MaDuAn ON GiaoDich(ma_du_an);
CREATE INDEX IX_GiaoDich_MaTknh ON GiaoDich(ma_tknh);

CREATE INDEX IX_BaoCao_NgayTao ON BaoCao(ngay_tao);
CREATE INDEX IX_BaoCao_MaDuAn ON BaoCao(ma_du_an);

CREATE INDEX IX_TaiKhoan_Username ON TaiKhoan(username);
CREATE INDEX IX_NhanVien_Email ON NhanVien(email);

-- =============================================
-- 4. TRIGGERS (TRIGGER TỰ ĐỘNG)
-- Mục đích: Tự động thực hiện các tác vụ khi có thay đổi dữ liệu
-- Tác dụng: Kiểm tra ràng buộc phức tạp, cập nhật dữ liệu liên quan
-- =============================================

-- =============================================
-- TRIGGER KIỂM TRA SỐ DƯ KHI TẠO GIAO DỊCH CHI
-- Mục đích: Ngăn chặn tạo giao dịch chi khi số dư tài khoản không đủ
-- Kích hoạt: Khi INSERT vào bảng GiaoDich
-- Logic: Kiểm tra số dư tài khoản trước khi cho phép tạo giao dịch chi
-- =============================================
GO
CREATE TRIGGER TR_GiaoDich_CheckSoDu
ON GiaoDich
FOR INSERT
AS
BEGIN
    DECLARE @so_tien DECIMAL(15,2);           -- Số tiền giao dịch
    DECLARE @ma_tknh INT;                     -- Mã tài khoản ngân hàng
    DECLARE @loai_gd VARCHAR(10);             -- Loại giao dịch (THU/CHI)
    DECLARE @so_du_hien_tai DECIMAL(15,2);    -- Số dư hiện tại của tài khoản
    
    -- Lấy thông tin giao dịch vừa được thêm
    SELECT @so_tien = so_tien, @ma_tknh = ma_tknh, @loai_gd = loai_gd
    FROM inserted;
    
    -- Chỉ kiểm tra khi là giao dịch chi (THU thì không cần kiểm tra số dư)
    IF @loai_gd = 'CHI'
    BEGIN
        -- Lấy số dư hiện tại của tài khoản
        SELECT @so_du_hien_tai = so_du 
        FROM TaiKhoanNH 
        WHERE ma_tknh = @ma_tknh;
        
        -- Kiểm tra số dư có đủ để thực hiện giao dịch chi không
        IF @so_du_hien_tai < @so_tien
        BEGIN
            -- Nếu không đủ tiền thì báo lỗi và hủy giao dịch
            RAISERROR(N'Số dư tài khoản không đủ để thực hiện giao dịch chi!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
    END
END;

-- =============================================
-- TRIGGER CẬP NHẬT SỐ DƯ TÀI KHOẢN SAU KHI DUYỆT GIAO DỊCH
-- Mục đích: Tự động cập nhật số dư tài khoản khi giao dịch được duyệt
-- Kích hoạt: Khi UPDATE trạng thái giao dịch thành DA_DUYET
-- Logic: Cộng tiền nếu là THU, trừ tiền nếu là CHI
-- =============================================
GO
CREATE TRIGGER TR_GiaoDich_UpdateSoDu
ON GiaoDich
FOR UPDATE
AS
BEGIN
    -- Chỉ xử lý khi trạng thái giao dịch thay đổi
    IF UPDATE(trang_thai)
    BEGIN
        DECLARE @ma_tknh INT;                 -- Mã tài khoản ngân hàng
        DECLARE @so_tien DECIMAL(15,2);       -- Số tiền giao dịch
        DECLARE @loai_gd VARCHAR(10);         -- Loại giao dịch (THU/CHI)
        DECLARE @trang_thai_cu VARCHAR(20);   -- Trạng thái cũ
        DECLARE @trang_thai_moi VARCHAR(20);  -- Trạng thái mới
        
        -- Lấy thông tin giao dịch cũ và mới
        SELECT @ma_tknh = i.ma_tknh, 
               @so_tien = i.so_tien, 
               @loai_gd = i.loai_gd,
               @trang_thai_cu = d.trang_thai,
               @trang_thai_moi = i.trang_thai
        FROM inserted i
        INNER JOIN deleted d ON i.ma_gd = d.ma_gd;
        
        -- Chỉ cập nhật số dư khi chuyển từ CHO_DUYET sang DA_DUYET
        IF @trang_thai_cu = 'CHO_DUYET' AND @trang_thai_moi = 'DA_DUYET'
        BEGIN
            IF @loai_gd = 'THU'
            BEGIN
                -- Nếu là giao dịch thu thì cộng tiền vào tài khoản
                UPDATE TaiKhoanNH 
                SET so_du = so_du + @so_tien 
                WHERE ma_tknh = @ma_tknh;
            END
            ELSE IF @loai_gd = 'CHI'
            BEGIN
                -- Nếu là giao dịch chi thì trừ tiền khỏi tài khoản
                UPDATE TaiKhoanNH 
                SET so_du = so_du - @so_tien 
                WHERE ma_tknh = @ma_tknh;
            END
        END
    END
END;

-- =============================================
-- 5. VIEWS (KHUNG NHÌN DỮ LIỆU)
-- Mục đích: Tạo bảng ảo kết hợp dữ liệu từ nhiều bảng
-- Tác dụng: Đơn giản hóa truy vấn, bảo mật dữ liệu, tối ưu hiệu suất
-- =============================================

-- =============================================
-- VIEW BÁO CÁO THU CHI TỔNG HỢP
-- Mục đích: Kết hợp thông tin giao dịch với các thông tin liên quan
-- Tác dụng: Hiển thị báo cáo thu chi đầy đủ thông tin, dễ đọc và hiểu
-- Dữ liệu: Mã giao dịch, loại, số tiền, ngày, mô tả, loại giao dịch, tài khoản, người tạo, dự án, trạng thái, người duyệt
-- =============================================
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

-- =============================================
-- 6. FUNCTIONS (HÀM TÍNH TOÁN)
-- Mục đích: Tạo các hàm tính toán tái sử dụng được
-- Tác dụng: Đơn giản hóa truy vấn phức tạp, tăng hiệu suất
-- =============================================

-- =============================================
-- FUNCTION TÍNH TỔNG THU CHI THEO KHOẢNG THỜI GIAN
-- Mục đích: Tính tổng thu chi trong một khoảng thời gian cụ thể
-- Tham số: 
--   @ngay_bd: Ngày bắt đầu (DATETIME)
--   @ngay_kt: Ngày kết thúc (DATETIME) 
--   @ma_du_an: Mã dự án (INT, NULL nếu tính tổng tất cả dự án)
-- Trả về: Bảng với loai_gd, tong_tien, so_giao_dich
-- Sử dụng: Báo cáo tài chính, thống kê thu chi
-- =============================================
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
    WHERE ngay_gd BETWEEN @ngay_bd AND @ngay_kt    -- Trong khoảng thời gian
      AND trang_thai = 'DA_DUYET'                   -- Chỉ tính giao dịch đã duyệt
      AND (@ma_du_an IS NULL OR ma_du_an = @ma_du_an)  -- Theo dự án (nếu có)
    GROUP BY loai_gd                      -- Nhóm theo loại giao dịch
);

-- =============================================
-- 7. STORED PROCEDURES (THỦ TỤC LƯU TRỮ)
-- Mục đích: Tạo các thủ tục xử lý nghiệp vụ phức tạp
-- Tác dụng: Đóng gói logic nghiệp vụ, tăng bảo mật, dễ bảo trì
-- =============================================

-- =============================================
-- PROCEDURE DUYỆT GIAO DỊCH
-- Mục đích: Duyệt hoặc từ chối giao dịch (chỉ Admin và Trưởng phòng)
-- Tham số:
--   @ma_gd: Mã giao dịch cần duyệt (INT)
--   @ma_nv_duyet: Mã nhân viên duyệt (INT)
--   @trang_thai: Trạng thái mới (DA_DUYET/TU_CHOI)
-- Logic: Kiểm tra quyền → Cập nhật giao dịch → Trigger tự động cập nhật số dư
-- =============================================
GO
CREATE PROCEDURE SP_DuyetGiaoDich
    @ma_gd INT,                              -- Mã giao dịch cần duyệt
    @ma_nv_duyet INT,                        -- Mã nhân viên thực hiện duyệt
    @trang_thai VARCHAR(20)                  -- Trạng thái mới (DA_DUYET/TU_CHOI)
AS
BEGIN
    BEGIN TRANSACTION;                       -- Bắt đầu transaction để đảm bảo tính nhất quán
    
    BEGIN TRY
        -- Kiểm tra quyền duyệt (chỉ Admin và Trưởng phòng mới được duyệt)
        IF NOT EXISTS (
            SELECT 1 FROM NhanVien nv
            INNER JOIN TaiKhoan tk ON nv.ma_tk = tk.ma_tk
            WHERE nv.ma_nv = @ma_nv_duyet 
              AND tk.ma_vai_tro IN ('ADMIN', 'TRUONG_PHONG')
        )
        BEGIN
            RAISERROR(N'Không có quyền duyệt giao dịch!', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
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

-- =============================================
-- PROCEDURE TẠO BÁO CÁO TÀI CHÍNH
-- Mục đích: Tự động tạo báo cáo tài chính với thống kê thu chi
-- Tham số:
--   @ten_bao_cao: Tên báo cáo (NVARCHAR(200))
--   @ma_du_an: Mã dự án (INT, NULL = báo cáo tổng hợp)
--   @ma_nv_tao: Mã nhân viên tạo báo cáo (INT)
-- Trả về: Mã báo cáo mới được tạo
-- Logic: Tính toán thu chi → Tạo nội dung báo cáo → Lưu vào database
-- =============================================
GO
CREATE PROCEDURE SP_TaoBaoCaoTaiChinh
    @ten_bao_cao NVARCHAR(200),             -- Tên báo cáo
    @ma_du_an INT = NULL,                   -- Mã dự án (NULL = tổng hợp tất cả)
    @ma_nv_tao INT                          -- Mã nhân viên tạo báo cáo
AS
BEGIN
    DECLARE @noi_dung NVARCHAR(MAX) = '';   -- Nội dung báo cáo
    DECLARE @tong_thu DECIMAL(15,2) = 0;    -- Tổng thu
    DECLARE @tong_chi DECIMAL(15,2) = 0;    -- Tổng chi
    DECLARE @so_giao_dich_thu INT = 0;      -- Số giao dịch thu
    DECLARE @so_giao_dich_chi INT = 0;      -- Số giao dịch chi
    
    -- Tính tổng thu chi từ giao dịch đã duyệt
    SELECT 
        @tong_thu = ISNULL(SUM(CASE WHEN loai_gd = 'THU' THEN so_tien ELSE 0 END), 0),
        @tong_chi = ISNULL(SUM(CASE WHEN loai_gd = 'CHI' THEN so_tien ELSE 0 END), 0),
        @so_giao_dich_thu = ISNULL(SUM(CASE WHEN loai_gd = 'THU' THEN 1 ELSE 0 END), 0),
        @so_giao_dich_chi = ISNULL(SUM(CASE WHEN loai_gd = 'CHI' THEN 1 ELSE 0 END), 0)
    FROM GiaoDich 
    WHERE trang_thai = 'DA_DUYET'           -- Chỉ tính giao dịch đã duyệt
      AND (@ma_du_an IS NULL OR ma_du_an = @ma_du_an);  -- Theo dự án (nếu có)
    
    -- Tạo nội dung báo cáo với format đẹp
    SET @noi_dung = N'BÁO CÁO TÀI CHÍNH' + CHAR(13) + CHAR(10) +
                   N'Ngày tạo: ' + CONVERT(VARCHAR, GETDATE(), 103) + CHAR(13) + CHAR(10) +
                   N'Tổng thu: ' + FORMAT(@tong_thu, 'N0') + ' VNĐ' + CHAR(13) + CHAR(10) +
                   N'Tổng chi: ' + FORMAT(@tong_chi, 'N0') + ' VNĐ' + CHAR(13) + CHAR(10) +
                   N'Lãi/Lỗ: ' + FORMAT(@tong_thu - @tong_chi, 'N0') + ' VNĐ' + CHAR(13) + CHAR(10) +
                   N'Số giao dịch thu: ' + CAST(@so_giao_dich_thu AS VARCHAR) + CHAR(13) + CHAR(10) +
                   N'Số giao dịch chi: ' + CAST(@so_giao_dich_chi AS VARCHAR);
    
    -- Lưu báo cáo vào database
    INSERT INTO BaoCao (ten_bao_cao, ma_du_an, noi_dung, ma_nv_tao)
    VALUES (@ten_bao_cao, @ma_du_an, @noi_dung, @ma_nv_tao);
    
    -- Trả về mã báo cáo mới được tạo
    SELECT SCOPE_IDENTITY() as ma_bao_cao_moi;
END;

-- =============================================
-- 8. INSERT DỮ LIỆU MẪU (DỮ LIỆU KHỞI TẠO)
-- Mục đích: Tạo dữ liệu mẫu để test hệ thống
-- Tác dụng: Giúp người dùng hiểu cách sử dụng, test các chức năng
-- =============================================

-- =============================================
-- INSERT VAI TRÒ (3 vai trò chính trong hệ thống)
-- Lưu ý: Không có Admin vì đây là hệ thống thu chi nội bộ
-- =============================================
INSERT INTO VaiTro VALUES 
('TRUONG_PHONG', N'Trưởng phòng tài chính'),    -- Quyền cao nhất: Duyệt giao dịch, quản lý tất cả
('NHAN_VIEN_TC', N'Nhân viên tài chính'),       -- Quyền thực hiện: Tạo giao dịch, quản lý dự án
('KE_TOAN', N'Kế toán');                        -- Quyền xem: Chỉ xem báo cáo, thống kê

-- =============================================
-- INSERT TÀI KHOẢN ĐĂNG NHẬP (3 tài khoản mẫu)
-- Lưu ý: Không có tài khoản admin vì đây là hệ thống thu chi nội bộ
-- =============================================
INSERT INTO TaiKhoan (username, password, ma_vai_tro) VALUES 
('truongphong', 'tp123', 'TRUONG_PHONG'),       -- Tài khoản trưởng phòng (quyền cao nhất)
('nhanvien_tc', 'nvtc123', 'NHAN_VIEN_TC'),     -- Tài khoản nhân viên tài chính (quyền thực hiện)
('ketoan1', 'kt123', 'KE_TOAN');                -- Tài khoản kế toán (quyền xem)

-- =============================================
-- INSERT NHÂN VIÊN (3 nhân viên mẫu)
-- Lưu ý: Không có nhân viên admin vì đây là hệ thống thu chi nội bộ
-- =============================================
INSERT INTO NhanVien (ho_ten, email, sdt, ma_tk) VALUES 
(N'Trần Thị Trưởng Phòng', 'truongphong@jobcenter.com', '0123456790', 1), -- Trưởng phòng tài chính (quyền cao nhất)
(N'Lê Văn Nhân Viên TC', 'nhanvien_tc@jobcenter.com', '0123456791', 2),   -- Nhân viên tài chính (quyền thực hiện)
(N'Phạm Thị Kế Toán', 'ketoan@jobcenter.com', '0123456792', 3);           -- Kế toán (quyền xem)

-- =============================================
-- INSERT LOẠI GIAO DỊCH (8 loại thu chi chính)
-- =============================================
INSERT INTO LoaiGiaoDich (ten_loai, loai_thu_chi, mo_ta) VALUES 
-- CÁC LOẠI THU (4 loại)
(N'Phí dịch vụ giới thiệu việc làm', 'THU', N'Thu từ phí dịch vụ giới thiệu việc làm'),
(N'Phí đăng tin tuyển dụng', 'THU', N'Thu từ phí đăng tin tuyển dụng'),
(N'Tài trợ từ doanh nghiệp', 'THU', N'Thu từ tài trợ của doanh nghiệp'),
(N'Các khoản thu khác', 'THU', N'Các khoản thu khác'),

-- CÁC LOẠI CHI (4 loại)
(N'Lương nhân viên', 'CHI', N'Chi trả lương cho nhân viên'),
(N'Chi phí vận hành', 'CHI', N'Chi phí vận hành trung tâm'),
(N'Chi phí marketing', 'CHI', N'Chi phí quảng cáo, marketing'),
(N'Chi phí thuê mặt bằng', 'CHI', N'Chi phí thuê mặt bằng');

-- =============================================
-- INSERT TÀI KHOẢN NGÂN HÀNG (2 tài khoản ảo của trung tâm)
-- Lưu ý: Đây là tài khoản ảo của trung tâm, KHÔNG phải của sinh viên/doanh nghiệp
-- =============================================
INSERT INTO TaiKhoanNH (ten_tk, so_tk, ngan_hang, so_du) VALUES 
(N'Tài khoản chính', '1234567890', N'Vietcombank', 100000000),    -- Tài khoản chính của trung tâm: 100 triệu
(N'Tài khoản dự phòng', '0987654321', N'BIDV', 50000000);         -- Tài khoản dự phòng của trung tâm: 50 triệu

-- =============================================
-- INSERT DỰ ÁN (2 dự án mẫu)
-- =============================================
INSERT INTO DuAn (ten_du_an, ngay_bd, ngay_kt, ngay_sach) VALUES 
(N'Dự án mở rộng trung tâm', '2024-01-01', '2024-12-31', 500000000),  -- Dự án 1: 500 triệu
(N'Dự án nâng cấp hệ thống', '2024-06-01', '2024-08-31', 200000000);   -- Dự án 2: 200 triệu

-- =============================================
-- 9. TẠO USERS VÀ PHÂN QUYỀN (BẢO MẬT HỆ THỐNG)
-- Mục đích: Tạo tài khoản người dùng và phân quyền truy cập
-- Tác dụng: Kiểm soát quyền hạn, bảo mật dữ liệu, phân chia trách nhiệm
-- =============================================

-- =============================================
-- TẠO LOGIN VÀ USER CHO 3 VAI TRÒ
-- Lưu ý: Không có Admin vì đây là hệ thống thu chi nội bộ
-- =============================================
-- Tạo login và user cho Trưởng phòng (quyền cao nhất)
CREATE LOGIN truongphong_user WITH PASSWORD = 'TruongPhong@123';
CREATE USER truongphong_user FOR LOGIN truongphong_user;

-- Tạo login và user cho Nhân viên tài chính (quyền thực hiện)
CREATE LOGIN nhanvien_tc_user WITH PASSWORD = 'NhanVienTC@123';
CREATE USER nhanvien_tc_user FOR LOGIN nhanvien_tc_user;

-- Tạo login và user cho Kế toán (quyền xem)
CREATE LOGIN ketoan_user WITH PASSWORD = 'KeToan@123';
CREATE USER ketoan_user FOR LOGIN ketoan_user;

-- =============================================
-- PHÂN QUYỀN CHO TRƯỞNG PHÒNG (QUYỀN CAO NHẤT)
-- Lưu ý: Trưởng phòng có quyền cao nhất trong hệ thống thu chi
-- =============================================
-- Quyền quản lý tất cả bảng
GRANT SELECT, INSERT, UPDATE, DELETE ON VaiTro TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoan TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON NhanVien TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON LoaiGiaoDich TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TaiKhoanNH TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON DuAn TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON GiaoDich TO truongphong_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON BaoCao TO truongphong_user;

-- Quyền xem view và thực thi procedures
GRANT SELECT ON V_BaoCaoThuChi TO truongphong_user;
GRANT EXECUTE ON SP_DuyetGiaoDich TO truongphong_user;
GRANT EXECUTE ON SP_TaoBaoCaoTaiChinh TO truongphong_user;

-- =============================================
-- PHÂN QUYỀN CHO NHÂN VIÊN TÀI CHÍNH (QUYỀN THỰC HIỆN)
-- Lưu ý: Nhân viên tài chính có quyền thực hiện các giao dịch và quản lý dự án
-- =============================================
-- Quyền xem thông tin cơ bản
GRANT SELECT ON VaiTro TO nhanvien_tc_user;
GRANT SELECT ON TaiKhoan TO nhanvien_tc_user;
GRANT SELECT ON NhanVien TO nhanvien_tc_user;
GRANT SELECT ON LoaiGiaoDich TO nhanvien_tc_user;
GRANT SELECT ON TaiKhoanNH TO nhanvien_tc_user;
GRANT SELECT ON DuAn TO nhanvien_tc_user;

-- Quyền tạo và sửa giao dịch (không được duyệt)
GRANT SELECT, INSERT, UPDATE ON GiaoDich TO nhanvien_tc_user;

-- Quyền xem báo cáo
GRANT SELECT ON BaoCao TO nhanvien_tc_user;
GRANT SELECT ON V_BaoCaoThuChi TO nhanvien_tc_user;
GRANT EXECUTE ON SP_TaoBaoCaoTaiChinh TO nhanvien_tc_user;

-- =============================================
-- PHÂN QUYỀN CHO KẾ TOÁN (QUYỀN XEM)
-- Lưu ý: Kế toán chỉ có quyền xem báo cáo và thống kê, không được thêm/sửa/xóa
-- =============================================
-- Quyền xem tất cả dữ liệu (read-only)
GRANT SELECT ON VaiTro TO ketoan_user;
GRANT SELECT ON TaiKhoan TO ketoan_user;
GRANT SELECT ON NhanVien TO ketoan_user;
GRANT SELECT ON LoaiGiaoDich TO ketoan_user;
GRANT SELECT ON TaiKhoanNH TO ketoan_user;
GRANT SELECT ON DuAn TO ketoan_user;
GRANT SELECT ON GiaoDich TO ketoan_user;  -- CHỈ XEM, KHÔNG TẠO/SỬA

-- Quyền tạo báo cáo
GRANT SELECT, INSERT ON BaoCao TO ketoan_user;
GRANT SELECT ON V_BaoCaoThuChi TO ketoan_user;
GRANT EXECUTE ON SP_TaoBaoCaoTaiChinh TO ketoan_user;

-- =============================================
-- 10. TRANSACTION VÍ DỤ (GIAO DỊCH MẪU)
-- Mục đích: Minh họa cách sử dụng transaction trong hệ thống
-- Tác dụng: Đảm bảo tính nhất quán dữ liệu khi thực hiện nhiều thao tác
-- =============================================

-- =============================================
-- TRANSACTION TẠO GIAO DỊCH THU VÀ DUYỆT
-- Mục đích: Tạo giao dịch thu và duyệt ngay lập tức
-- Logic: Tạo giao dịch → Duyệt giao dịch → Trigger tự động cập nhật số dư
-- =============================================
BEGIN TRANSACTION T_GiaoDichThu;
BEGIN TRY
    -- Tạo giao dịch thu 5 triệu VNĐ
    INSERT INTO GiaoDich (loai_gd, so_tien, mo_ta, ma_loai, ma_tknh, ma_nv_tao, ma_du_an)
    VALUES ('THU', 5000000, N'Thu phí dịch vụ giới thiệu việc làm', 1, 1, 3, 1);
    
    -- Duyệt giao dịch ngay lập tức (Trưởng phòng duyệt)
    EXEC SP_DuyetGiaoDich @@IDENTITY, 2, 'DA_DUYET';
    
    -- Xác nhận transaction
    COMMIT TRANSACTION T_GiaoDichThu;
    PRINT N'Giao dịch thu đã được tạo và duyệt thành công!';
END TRY
BEGIN CATCH
    -- Hủy transaction nếu có lỗi
    ROLLBACK TRANSACTION T_GiaoDichThu;
    PRINT N'Lỗi: ' + ERROR_MESSAGE();
END CATCH;

-- =============================================
-- 11. THÊM CÁC VIEWS BỔ SUNG (QUAN TRỌNG)
-- Mục đích: Tạo các view hỗ trợ báo cáo và thống kê
-- Tác dụng: Đơn giản hóa truy vấn, hiển thị dữ liệu dễ đọc
-- =============================================

-- =============================================
-- VIEW THỐNG KÊ THU CHI THEO THÁNG
-- Mục đích: Tổng hợp thu chi theo từng tháng để tạo biểu đồ
-- Tác dụng: Hiển thị xu hướng thu chi, báo cáo tài chính theo tháng
-- =============================================
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
ORDER BY Nam DESC, Thang DESC;                     -- Sắp xếp từ mới đến cũ

-- =============================================
-- VIEW GIAO DỊCH CHỜ DUYỆT
-- Mục đích: Hiển thị danh sách giao dịch đang chờ duyệt
-- Tác dụng: Giúp trưởng phòng dễ dàng duyệt giao dịch
-- =============================================
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
ORDER BY gd.ngay_gd DESC;                          -- Sắp xếp từ mới đến cũ

-- =============================================
-- VIEW LỊCH SỬ GIAO DỊCH
-- Mục đích: Hiển thị toàn bộ lịch sử giao dịch với đầy đủ thông tin
-- Tác dụng: Tra cứu lịch sử, kiểm tra giao dịch, báo cáo chi tiết
-- =============================================
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
ORDER BY gd.ngay_gd DESC;                          -- Sắp xếp từ mới đến cũ

-- =============================================
-- 12. THÊM CÁC FUNCTIONS BỔ SUNG (QUAN TRỌNG)
-- Mục đích: Tạo các hàm tính toán hỗ trợ báo cáo
-- Tác dụng: Tính toán lãi/lỗ, kiểm tra số dư tài khoản
-- =============================================

-- =============================================
-- FUNCTION TÍNH LÃI/LỖ THEO KHOẢNG THỜI GIAN
-- Mục đích: Tính lãi/lỗ trong một khoảng thời gian cụ thể
-- Tham số: @ngay_bd (ngày bắt đầu), @ngay_kt (ngày kết thúc), @ma_du_an (mã dự án, NULL = tất cả)
-- Trả về: Số tiền lãi/lỗ (DECIMAL)
-- Sử dụng: Báo cáo tài chính, thống kê hiệu quả
-- =============================================
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
    WHERE ngay_gd BETWEEN @ngay_bd AND @ngay_kt    -- Trong khoảng thời gian
      AND trang_thai = 'DA_DUYET'                   -- Chỉ tính giao dịch đã duyệt
      AND (@ma_du_an IS NULL OR ma_du_an = @ma_du_an);  -- Theo dự án (nếu có)
    
    -- Trả về lãi/lỗ (thu - chi)
    RETURN @tong_thu - @tong_chi;
END;

-- =============================================
-- FUNCTION KIỂM TRA SỐ DƯ TÀI KHOẢN
-- Mục đích: Lấy số dư hiện tại của một tài khoản ngân hàng
-- Tham số: @ma_tknh (mã tài khoản ngân hàng)
-- Trả về: Số dư tài khoản (DECIMAL)
-- Sử dụng: Kiểm tra số dư trước khi tạo giao dịch chi
-- =============================================
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

-- =============================================
-- 13. THÊM PROCEDURE BỔ SUNG (QUAN TRỌNG)
-- Mục đích: Tạo procedure xuất báo cáo chi tiết
-- Tác dụng: Xuất báo cáo theo thời gian và dự án
-- =============================================

-- =============================================
-- PROCEDURE XUẤT BÁO CÁO CHI TIẾT
-- Mục đích: Xuất báo cáo giao dịch chi tiết theo thời gian và dự án
-- Tham số: @ngay_bd (ngày bắt đầu), @ngay_kt (ngày kết thúc), @ma_du_an (mã dự án, NULL = tất cả)
-- Trả về: Danh sách giao dịch với đầy đủ thông tin
-- Sử dụng: Xuất báo cáo Excel, in ấn, gửi email
-- =============================================
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
    WHERE gd.ngay_gd BETWEEN @ngay_bd AND @ngay_kt  -- Trong khoảng thời gian
      AND (@ma_du_an IS NULL OR gd.ma_du_an = @ma_du_an)  -- Theo dự án (nếu có)
    ORDER BY gd.ngay_gd DESC;                      -- Sắp xếp từ mới đến cũ
END;

-- =============================================
-- 14. CẬP NHẬT PHÂN QUYỀN CHO CÁC THÀNH PHẦN MỚI
-- Mục đích: Cấp quyền truy cập cho các view và function mới
-- Tác dụng: Đảm bảo bảo mật, phân quyền phù hợp với từng vai trò
-- =============================================

-- =============================================
-- PHÂN QUYỀN CHO TRƯỞNG PHÒNG (THÊM VIEWS VÀ FUNCTIONS MỚI)
-- =============================================
-- Quyền xem các view mới
GRANT SELECT ON V_ThongKeThang TO truongphong_user;
GRANT SELECT ON V_GiaoDichChoDuyet TO truongphong_user;
GRANT SELECT ON V_LichSuGiaoDich TO truongphong_user;

-- Quyền sử dụng các function mới
GRANT EXECUTE ON FN_TinhLaiLo TO truongphong_user;
GRANT EXECUTE ON FN_KiemTraSoDu TO truongphong_user;

-- Quyền thực thi procedure mới
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO truongphong_user;

-- =============================================
-- PHÂN QUYỀN CHO NHÂN VIÊN TÀI CHÍNH (THÊM VIEWS VÀ FUNCTIONS MỚI)
-- =============================================
-- Quyền xem các view mới
GRANT SELECT ON V_ThongKeThang TO nhanvien_tc_user;
GRANT SELECT ON V_GiaoDichChoDuyet TO nhanvien_tc_user;
GRANT SELECT ON V_LichSuGiaoDich TO nhanvien_tc_user;

-- Quyền sử dụng các function mới
GRANT EXECUTE ON FN_TinhLaiLo TO nhanvien_tc_user;
GRANT EXECUTE ON FN_KiemTraSoDu TO nhanvien_tc_user;

-- Quyền thực thi procedure mới
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO nhanvien_tc_user;

-- =============================================
-- PHÂN QUYỀN CHO KẾ TOÁN (THÊM VIEWS VÀ FUNCTIONS MỚI)
-- =============================================
-- Quyền xem các view mới
GRANT SELECT ON V_ThongKeThang TO ketoan_user;
GRANT SELECT ON V_GiaoDichChoDuyet TO ketoan_user;
GRANT SELECT ON V_LichSuGiaoDich TO ketoan_user;

-- Quyền sử dụng các function mới
GRANT EXECUTE ON FN_TinhLaiLo TO ketoan_user;
GRANT EXECUTE ON FN_KiemTraSoDu TO ketoan_user;

-- Quyền thực thi procedure mới
GRANT EXECUTE ON SP_XuatBaoCaoChiTiet TO ketoan_user;

-- =============================================
-- 15. THÊM CÁC PROCEDURE CRUD (THÊM, SỬA, XÓA DỮ LIỆU)
-- Mục đích: Tạo các procedure để thao tác dữ liệu cơ bản
-- Tác dụng: Hỗ trợ WinForm thực hiện CRUD operations
-- =============================================

-- =============================================
-- PROCEDURE THÊM GIAO DỊCH MỚI
-- Mục đích: Tạo giao dịch thu/chi mới
-- Tham số: Tất cả thông tin cần thiết cho giao dịch
-- Trả về: Mã giao dịch mới được tạo
-- =============================================
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
        -- Kiểm tra số dư nếu là giao dịch chi
        IF @loai_gd = 'CHI'
        BEGIN
            DECLARE @so_du_hien_tai DECIMAL(15,2);
            SELECT @so_du_hien_tai = so_du FROM TaiKhoanNH WHERE ma_tknh = @ma_tknh;
            
            IF @so_du_hien_tai < @so_tien
            BEGIN
                RAISERROR(N'Số dư tài khoản không đủ!', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
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

-- =============================================
-- PROCEDURE SỬA GIAO DỊCH
-- Mục đích: Cập nhật thông tin giao dịch (chỉ khi chưa duyệt)
-- Tham số: Mã giao dịch và thông tin mới
-- Trả về: Số dòng được cập nhật
-- =============================================
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
        
        -- Kiểm tra số dư nếu là giao dịch chi
        DECLARE @loai_gd VARCHAR(10);
        SELECT @loai_gd = loai_gd FROM GiaoDich WHERE ma_gd = @ma_gd;
        
        IF @loai_gd = 'CHI'
        BEGIN
            DECLARE @so_du_hien_tai DECIMAL(15,2);
            SELECT @so_du_hien_tai = so_du FROM TaiKhoanNH WHERE ma_tknh = @ma_tknh;
            
            IF @so_du_hien_tai < @so_tien
            BEGIN
                RAISERROR(N'Số dư tài khoản không đủ!', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END
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

-- =============================================
-- PROCEDURE XÓA GIAO DỊCH
-- Mục đích: Xóa giao dịch (chỉ khi chưa duyệt)
-- Tham số: Mã giao dịch cần xóa
-- Trả về: Số dòng được xóa
-- =============================================
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

-- =============================================
-- PROCEDURE THÊM DỰ ÁN MỚI
-- Mục đích: Tạo dự án mới
-- Tham số: Thông tin dự án
-- Trả về: Mã dự án mới được tạo
-- =============================================
GO
CREATE PROCEDURE SP_ThemDuAn
    @ten_du_an NVARCHAR(200),                       -- Tên dự án
    @ngay_bd DATE,                                  -- Ngày bắt đầu
    @ngay_kt DATE = NULL,                           -- Ngày kết thúc (có thể NULL)
    @ngay_sach DECIMAL(15,2) = 0                    -- Ngân sách dự án
AS
BEGIN
    BEGIN TRANSACTION;
    BEGIN TRY
        -- Thêm dự án mới
        INSERT INTO DuAn (ten_du_an, ngay_bd, ngay_kt, ngay_sach)
        VALUES (@ten_du_an, @ngay_bd, @ngay_kt, @ngay_sach);
        
        -- Trả về mã dự án mới
        SELECT SCOPE_IDENTITY() as ma_du_an_moi;
        
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;

-- =============================================
-- PROCEDURE SỬA DỰ ÁN
-- Mục đích: Cập nhật thông tin dự án
-- Tham số: Mã dự án và thông tin mới
-- Trả về: Số dòng được cập nhật
-- =============================================
GO
CREATE PROCEDURE SP_SuaDuAn
    @ma_du_an INT,                                  -- Mã dự án cần sửa
    @ten_du_an NVARCHAR(200),                       -- Tên dự án mới
    @ngay_bd DATE,                                  -- Ngày bắt đầu mới
    @ngay_kt DATE = NULL,                           -- Ngày kết thúc mới
    @ngay_sach DECIMAL(15,2),                       -- Ngân sách mới
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
            ngay_sach = @ngay_sach,
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

-- =============================================
-- PROCEDURE XÓA DỰ ÁN
-- Mục đích: Xóa dự án (chỉ khi không có giao dịch liên quan)
-- Tham số: Mã dự án cần xóa
-- Trả về: Số dòng được xóa
-- =============================================
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

-- =============================================
-- PROCEDURE THÊM TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Tạo tài khoản ngân hàng mới
-- Tham số: Thông tin tài khoản
-- Trả về: Mã tài khoản mới được tạo
-- =============================================
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

-- =============================================
-- PROCEDURE SỬA TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Cập nhật thông tin tài khoản ngân hàng
-- Tham số: Mã tài khoản và thông tin mới
-- Trả về: Số dòng được cập nhật
-- =============================================
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

-- =============================================
-- PROCEDURE XÓA TÀI KHOẢN NGÂN HÀNG
-- Mục đích: Xóa tài khoản ngân hàng (chỉ khi không có giao dịch liên quan)
-- Tham số: Mã tài khoản cần xóa
-- Trả về: Số dòng được xóa
-- =============================================
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

-- =============================================
-- 16. CẬP NHẬT PHÂN QUYỀN CHO CÁC PROCEDURE CRUD MỚI
-- Mục đích: Cấp quyền sử dụng các procedure CRUD mới
-- Tác dụng: Đảm bảo bảo mật, phân quyền phù hợp với từng vai trò
-- =============================================

-- =============================================
-- PHÂN QUYỀN CHO TRƯỞNG PHÒNG (THÊM PROCEDURE CRUD)
-- =============================================
-- Quyền thực thi các procedure CRUD
GRANT EXECUTE ON SP_ThemGiaoDich TO truongphong_user;
GRANT EXECUTE ON SP_SuaGiaoDich TO truongphong_user;
GRANT EXECUTE ON SP_XoaGiaoDich TO truongphong_user;
GRANT EXECUTE ON SP_ThemDuAn TO truongphong_user;
GRANT EXECUTE ON SP_SuaDuAn TO truongphong_user;
GRANT EXECUTE ON SP_XoaDuAn TO truongphong_user;
GRANT EXECUTE ON SP_ThemTaiKhoanNH TO truongphong_user;
GRANT EXECUTE ON SP_SuaTaiKhoanNH TO truongphong_user;
GRANT EXECUTE ON SP_XoaTaiKhoanNH TO truongphong_user;

-- =============================================
-- PHÂN QUYỀN CHO NHÂN VIÊN TÀI CHÍNH (THÊM PROCEDURE CRUD)
-- =============================================
-- Quyền thực thi các procedure CRUD (chỉ giao dịch và dự án)
GRANT EXECUTE ON SP_ThemGiaoDich TO nhanvien_tc_user;
GRANT EXECUTE ON SP_SuaGiaoDich TO nhanvien_tc_user;
GRANT EXECUTE ON SP_XoaGiaoDich TO nhanvien_tc_user;
GRANT EXECUTE ON SP_ThemDuAn TO nhanvien_tc_user;
GRANT EXECUTE ON SP_SuaDuAn TO nhanvien_tc_user;
GRANT EXECUTE ON SP_XoaDuAn TO nhanvien_tc_user;
-- Không được quản lý tài khoản ngân hàng

-- =============================================
-- PHÂN QUYỀN CHO KẾ TOÁN (CHỈ XEM, KHÔNG CRUD)
-- =============================================
-- Kế toán chỉ được xem, không được thêm/sửa/xóa

-- =============================================
-- 17. KIỂM TRA HỆ THỐNG (TEST CÁC CHỨC NĂNG)
-- Mục đích: Kiểm tra xem hệ thống hoạt động đúng không
-- Tác dụng: Xác minh database, view, function, procedure hoạt động tốt
-- =============================================

-- Kiểm tra view báo cáo thu chi
SELECT * FROM V_BaoCaoThuChi;

-- Kiểm tra view thống kê tháng
SELECT * FROM V_ThongKeThang;

-- Kiểm tra view giao dịch chờ duyệt
SELECT * FROM V_GiaoDichChoDuyet;

-- Kiểm tra view lịch sử giao dịch
SELECT TOP 10 * FROM V_LichSuGiaoDich;

-- Kiểm tra function tính tổng thu chi
SELECT * FROM FN_TinhTongThuChi('2024-01-01', '2024-12-31', NULL);

-- Kiểm tra function tính lãi/lỗ
SELECT dbo.FN_TinhLaiLo('2024-01-01', '2024-12-31', NULL) as LaiLo;

-- Kiểm tra function kiểm tra số dư
SELECT dbo.FN_KiemTraSoDu(1) as SoDuTaiKhoan1;

-- Kiểm tra procedure xuất báo cáo
EXEC SP_XuatBaoCaoChiTiet '2024-01-01', '2024-12-31', NULL;

-- Kiểm tra số dư tài khoản ngân hàng
SELECT ten_tk, ngan_hang, so_du FROM TaiKhoanNH;

-- Kiểm tra các procedure CRUD mới
-- Test thêm giao dịch
EXEC SP_ThemGiaoDich 'THU', 1000000, N'Test thu tiền', 1, 1, 3, 1;

-- Test thêm dự án
EXEC SP_ThemDuAn N'Dự án test', '2024-01-01', '2024-12-31', 10000000;

-- Test thêm tài khoản ngân hàng
EXEC SP_ThemTaiKhoanNH N'Tài khoản test', '9999999999', N'Test Bank', 0;

-- Thông báo hoàn thành
PRINT N'Database đã được tạo thành công với đầy đủ chức năng!';
PRINT N'Đã thêm: 3 Views, 2 Functions, 1 Procedure báo cáo, 9 Procedures CRUD';
PRINT N'Tổng cộng: 8 Bảng, 4 Views, 3 Functions, 12 Procedures, 2 Triggers, 3 Users';
PRINT N'Vai trò: Trưởng phòng (quyền cao nhất), Nhân viên TC (quyền thực hiện), Kế toán (quyền xem)';
