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
    public class DuAnService : IDuAnService
    {
        private readonly QLDuAn _repo = new QLDuAn();

        // SP_GetDuAn — Vai trò: TP/NVTC/Kế toán (✅✅✅)
        public DataTable GetDuAn(string trangThai = null, DateTime? tuNgayBd = null, DateTime? denNgayBd = null, bool? coNganSach = null)
        {
            try
            {
                if (tuNgayBd.HasValue && denNgayBd.HasValue && tuNgayBd > denNgayBd)
                    throw new BusinessException("Từ ngày không được lớn hơn đến ngày.");
                return _repo.GetDuAn(trangThai, tuNgayBd, denNgayBd, coNganSach);
            }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được danh sách dự án.", ex); }
        }

        // SP_ThemDuAn — Vai trò: Trưởng phòng (✅)
        public int ThemDuAn(string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach = 0)
        {
            if (string.IsNullOrWhiteSpace(tenDuAn)) throw new BusinessException("Tên dự án bắt buộc.");
            if (nganSach < 0) throw new BusinessException("Ngân sách không được âm.");
            if (ngayKt.HasValue && ngayKt.Value.Date < ngayBd.Date) throw new BusinessException("Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");

            try { return _repo.ThemDuAn(tenDuAn, ngayBd, ngayKt, nganSach); }
            catch (DataAccessException ex) { throw new BusinessException("Thêm dự án thất bại.", ex); }
        }

        // SP_SuaDuAn — Vai trò: Trưởng phòng (✅)
        public int SuaDuAn(int maDuAn, string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach, string trangThai = "active")
        {
            if (maDuAn <= 0) throw new BusinessException("Mã dự án không hợp lệ.");
            if (string.IsNullOrWhiteSpace(tenDuAn)) throw new BusinessException("Tên dự án bắt buộc.");
            if (nganSach < 0) throw new BusinessException("Ngân sách không được âm.");
            if (ngayKt.HasValue && ngayKt.Value.Date < ngayBd.Date) throw new BusinessException("Ngày kết thúc phải sau hoặc bằng ngày bắt đầu.");

            try { return _repo.SuaDuAn(maDuAn, tenDuAn, ngayBd, ngayKt, nganSach, trangThai); }
            catch (DataAccessException ex) { throw new BusinessException("Sửa dự án thất bại.", ex); }
        }

        // SP_UpdateDuAn — Vai trò: Trưởng phòng (✅)
        public int VoHieuHoaDuAn(int maDuAn)
        {
            if (maDuAn <= 0) throw new BusinessException("Mã dự án không hợp lệ.");
            try { return _repo.VohieuHoaDuAn(maDuAn); }
            catch (DataAccessException ex) { throw new BusinessException("Vô hiệu hóa dự án thất bại.", ex); }
        }
    }
}
