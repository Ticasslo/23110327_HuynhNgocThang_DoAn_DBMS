using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
    public interface IDuAnService
    {
        // SP_GetDuAn — Vai trò: TP/NVTC/Kế toán (✅✅✅)
        DataTable GetDuAn(string trangThai = null, DateTime? tuNgayBd = null, DateTime? denNgayBd = null, bool? coNganSach = null);

        // SP_ThemDuAn — Vai trò: Trưởng phòng (✅)
        int ThemDuAn(string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach = 0);

        // SP_SuaDuAn — Vai trò: Trưởng phòng (✅)
        int SuaDuAn(int maDuAn, string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach, string trangThai = "active");

        // SP_UpdateDuAn — Vai trò: Trưởng phòng (✅)
        int VoHieuHoaDuAn(int maDuAn);
    }
}
