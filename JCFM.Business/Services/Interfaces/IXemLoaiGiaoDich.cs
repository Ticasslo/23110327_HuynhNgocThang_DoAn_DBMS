using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
    public interface ILookupService
    {
        // SP_GetLoaiGiaoDich — Vai trò: TP/NVTC/Kế toán (✅✅✅)
        DataTable GetLoaiGiaoDich(string loaiThuChi = null); // "THU"/"CHI"/null
    }
}
