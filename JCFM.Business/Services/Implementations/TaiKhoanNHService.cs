using JCFM.Business.Exceptions;
using JCFM.Business.Services.Interfaces;
using JCFM.DataAccess.Exceptions;
using JCFM.DataAccess.Repositories;
using JCFM.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Implementations
{
    public class TaiKhoanNHService : ITaiKhoanNHService
    {
        private readonly QLTaiKhoanNH _repo = new QLTaiKhoanNH();

        // SP_GetTaiKhoanNH — Vai trò: TP/NVTC/Kế toán (✅✅✅)
        public DataTable GetTaiKhoanNH(string trangThai = null, string nganHang = null, bool? coSoDu = null)
        {
            try
            {
                return _repo.GetTaiKhoanNH(trangThai, nganHang, coSoDu);
            }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được danh sách tài khoản NH.", ex); }
        }

        // SP_ThemTaiKhoanNH — Vai trò: Trưởng phòng (✅)
        public int ThemTaiKhoanNH(string tenTk, string soTk, string nganHang, decimal soDu = 0)
        {
            if (string.IsNullOrWhiteSpace(tenTk)) throw new BusinessException("Tên tài khoản bắt buộc.");
            if (string.IsNullOrWhiteSpace(soTk)) throw new BusinessException("Số tài khoản bắt buộc.");
            if (string.IsNullOrWhiteSpace(nganHang)) throw new BusinessException("Ngân hàng bắt buộc.");
            if (soDu < 0) throw new BusinessException("Số dư không được âm.");

            try { return _repo.ThemTaiKhoanNH(tenTk, soTk, nganHang, soDu); }
            catch (DataAccessException ex) { throw new BusinessException("Thêm tài khoản NH thất bại.", ex); }
        }

        // SP_SuaTaiKhoanNH — Vai trò: Trưởng phòng (✅)
        public int SuaTaiKhoanNH(int maTknh, string tenTk, string soTk, string nganHang, string trangThai = "active")
        {
            if (maTknh <= 0) throw new BusinessException("Mã tài khoản không hợp lệ.");
            if (string.IsNullOrWhiteSpace(tenTk) || string.IsNullOrWhiteSpace(soTk) || string.IsNullOrWhiteSpace(nganHang))
                throw new BusinessException("Thiếu thông tin bắt buộc.");

            try { return _repo.SuaTaiKhoanNH(maTknh, tenTk, soTk, nganHang, trangThai); }
            catch (DataAccessException ex) { throw new BusinessException("Sửa tài khoản NH thất bại.", ex); }
        }

        // SP_UpdateTaiKhoanNH — Vai trò: Trưởng phòng (✅)
        public int VohieuHoaTaiKhoanNH(int maTknh)
        {
            if (maTknh <= 0) throw new BusinessException("Mã tài khoản không hợp lệ.");
            try { return _repo.VohieuHoaTaiKhoanNH(maTknh); }
            catch (DataAccessException ex) { throw new BusinessException("Vô hiệu hóa tài khoản NH thất bại.", ex); }
        }
    }
}
