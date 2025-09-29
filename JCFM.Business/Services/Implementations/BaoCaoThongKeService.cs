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
    public class ThongKeService : IThongKeService
    {
        private readonly BaoCaoThongKe _repo = new BaoCaoThongKe();

        // SP_GetThongKeThang — Vai trò: Trưởng phòng/Kế toán (✅/✅)
        public DataTable GetThongKeThang(int? nam = null, int? thang = null)
        {
            try { return _repo.GetThongKeThang(nam, thang); }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được thống kê tháng.", ex); }
        }

        // SP_XuatBaoCaoChiTiet — Vai trò: Trưởng phòng/Kế toán (✅/✅)
        public DataTable XuatBaoCaoChiTiet(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null)
        {
            if (ngayBd.Date > ngayKt.Date) throw new BusinessException("Khoảng ngày không hợp lệ.");
            try { return _repo.XuatBaoCaoChiTiet(ngayBd, ngayKt, maDuAn); }
            catch (DataAccessException ex) { throw new BusinessException("Xuất báo cáo chi tiết thất bại.", ex); }
        }
    }
}
