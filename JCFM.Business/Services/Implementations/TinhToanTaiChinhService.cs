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
    public class TinhToanService : ITinhToanService
    {
        private readonly TinhToanTaiChinh _repo = new TinhToanTaiChinh();

        // FN_TinhLaiLo — Vai trò: Trưởng phòng/Kế toán (EXECUTE)
        public decimal TinhLaiLo(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null)
        {
            if (ngayBd.Date > ngayKt.Date) throw new BusinessException("Khoảng ngày không hợp lệ.");
            try { return _repo.TinhLaiLo(ngayBd, ngayKt, maDuAn); }
            catch (DataAccessException ex) { throw new BusinessException("Tính lãi/lỗ thất bại.", ex); }
        }

        // FN_KiemTraSoDu — Vai trò: TP/NVTC/Kế toán (EXECUTE)
        public decimal KiemTraSoDu(int maTknh)
        {
            if (maTknh <= 0) throw new BusinessException("Mã tài khoản NH không hợp lệ.");
            try { return _repo.KiemTraSoDu(maTknh); }
            catch (DataAccessException ex) { throw new BusinessException("Kiểm tra số dư thất bại.", ex); }
        }

        // FN_TinhTongThuChi — Vai trò: Trưởng phòng/Kế toán (SELECT)
        public DataTable TinhTongThuChi(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null)
        {
            if (ngayBd.Date > ngayKt.Date) throw new BusinessException("Khoảng ngày không hợp lệ.");
            try { return _repo.TinhTongThuChi(ngayBd, ngayKt, maDuAn); }
            catch (DataAccessException ex) { throw new BusinessException("Tính tổng thu chi thất bại.", ex); }
        }
    }
}
