using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
    public interface IThongKeService
    {
        // SP_GetThongKeThang — Vai trò: Trưởng phòng/Kế toán
        DataTable GetThongKeThang(int? nam = null, int? thang = null);

        // SP_XuatBaoCaoChiTiet — Vai trò: Trưởng phòng/Kế toán
        DataTable XuatBaoCaoChiTiet(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null);
    }
}
