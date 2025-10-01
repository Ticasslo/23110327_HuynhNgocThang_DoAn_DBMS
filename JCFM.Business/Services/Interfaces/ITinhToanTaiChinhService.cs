using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
    public interface ITinhToanService
    {
        // FN_TinhLaiLo — Vai trò: Trưởng phòng/Kế toán (EXECUTE)
        decimal TinhLaiLo(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null);

        // FN_KiemTraSoDu — Vai trò: TP/NVTC/Kế toán (EXECUTE)
        decimal KiemTraSoDu(int maTknh);

        // FN_TinhTongThuChi — Vai trò: Trưởng phòng/Kế toán (SELECT)
        DataTable TinhTongThuChi(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null);
    }
}
