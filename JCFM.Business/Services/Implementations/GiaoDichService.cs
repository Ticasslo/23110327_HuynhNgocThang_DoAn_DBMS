using JCFM.Business.Exceptions;
using JCFM.Business.Services.Interfaces;
using JCFM.DataAccess.Exceptions;
using JCFM.DataAccess.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Implementations
{
    public class GiaoDichService : IGiaoDichService
    {
        private readonly QLGiaoDich _repo = new QLGiaoDich();

        // SP_ThemGiaoDich — Vai trò: Nhân viên TC (✅)
        public int ThemGiaoDich(string loaiGd, decimal soTien, string moTa, string maLoai, int maTknh, int maNvTaoNvtc, int? maDuAn)
        {
            if (loaiGd != "THU" && loaiGd != "CHI") throw new BusinessException("Loại giao dịch phải là THU hoặc CHI.");
            if (soTien <= 0) throw new BusinessException("Số tiền phải > 0.");
            if (string.IsNullOrWhiteSpace(maLoai)) throw new BusinessException("Mã loại bắt buộc.");
            if (maTknh <= 0) throw new BusinessException("Mã tài khoản ngân hàng không hợp lệ.");
            if (maNvTaoNvtc <= 0) throw new BusinessException("Mã nhân viên tạo không hợp lệ.");

            try { return _repo.ThemGiaoDich(loaiGd, soTien, moTa, maLoai, maTknh, maNvTaoNvtc, maDuAn); }
            catch (DataAccessException ex) { throw new BusinessException("Thêm giao dịch thất bại.", ex); }
        }

        // SP_SuaGiaoDich — Vai trò: Nhân viên TC (✅)
        public int SuaGiaoDich(int maGd, decimal soTien, string moTa, string maLoai, int maTknh, int? maDuAn, int maNvSua)
        {
            if (maGd <= 0) throw new BusinessException("Mã giao dịch không hợp lệ.");
            if (soTien <= 0) throw new BusinessException("Số tiền phải > 0.");
            if (string.IsNullOrWhiteSpace(maLoai)) throw new BusinessException("Mã loại bắt buộc.");
            if (maTknh <= 0) throw new BusinessException("Mã tài khoản ngân hàng không hợp lệ.");
            if (maNvSua <= 0) throw new BusinessException("Mã nhân viên sửa không hợp lệ.");

            try { return _repo.SuaGiaoDich(maGd, soTien, moTa, maLoai, maTknh, maDuAn, maNvSua); }
            catch (DataAccessException ex) { throw new BusinessException("Sửa giao dịch thất bại.", ex); }
        }

        // SP_DuyetGiaoDich — Vai trò: Trưởng phòng (✅)
        public bool DuyetGiaoDich(int maGd, int maNvDuyetTp, string trangThai)
        {
            if (maGd <= 0) throw new BusinessException("Mã giao dịch không hợp lệ.");
            if (maNvDuyetTp <= 0) throw new BusinessException("Mã người duyệt không hợp lệ.");
            if (trangThai != "DA_DUYET" && trangThai != "TU_CHOI") throw new BusinessException("Trạng thái phải là DA_DUYET/TU_CHOI.");

            try { return _repo.DuyetGiaoDich(maGd, maNvDuyetTp, trangThai); }
            catch (DataAccessException ex) { throw new BusinessException("Duyệt giao dịch thất bại.", ex); }
        }

        // SP_GetGiaoDichChoDuyet — Vai trò: Trưởng phòng (✅)
        public DataTable GetGiaoDichChoDuyet(int? maNvTao = null, string loaiGd = null, int? maDuAn = null)
        {
            try { return _repo.GetGiaoDichChoDuyet(maNvTao, loaiGd, maDuAn); }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được danh sách chờ duyệt.", ex); }
        }

        // SP_GetGiaoDichChoDuyet_ForNhanVienTC — Vai trò: Nhân viên TC (✅)
        public DataTable GetGiaoDichChoDuyet_CuaToi(int maNvTao)
        {
            if (maNvTao <= 0) throw new BusinessException("Mã nhân viên không hợp lệ.");
            try { return _repo.GetGiaoDichChoDuyet_CuaToi(maNvTao); }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được danh sách chờ duyệt (của tôi).", ex); }
        }

        // SP_GetLichSuGiaoDich — Vai trò: Trưởng phòng/Kế toán (✅/✅)
        public DataTable GetLichSuGiaoDich(DateTime? tuNgay = null, DateTime? denNgay = null, string trangThai = null, string loaiGd = null, int? maDuAn = null, int? maTknh = null, int? maNvTao = null)
        {
            if (tuNgay.HasValue && denNgay.HasValue && tuNgay > denNgay)
                throw new BusinessException("Từ ngày không được lớn hơn đến ngày.");
            try { return _repo.GetLichSuGiaoDich(tuNgay, denNgay, trangThai, loaiGd, maDuAn, maTknh, maNvTao); }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được lịch sử giao dịch.", ex); }
        }

        // SP_GetLichSuGiaoDich_ForNhanVienTC — Vai trò: Nhân viên TC (✅)
        public DataTable GetLichSuGiaoDich_CuaToi(int maNvTao, DateTime? tuNgay = null, DateTime? denNgay = null, string trangThai = null, string loaiGd = null, int? maDuAn = null, int? maTknh = null)
        {
            if (maNvTao <= 0) throw new BusinessException("Mã nhân viên không hợp lệ.");
            if (tuNgay.HasValue && denNgay.HasValue && tuNgay > denNgay)
                throw new BusinessException("Từ ngày không được lớn hơn đến ngày.");
            try { return _repo.GetLichSuGiaoDich_CuaToi(maNvTao, tuNgay, denNgay, trangThai, loaiGd, maDuAn, maTknh); }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được lịch sử giao dịch (của tôi).", ex); }
        }
    }
}
