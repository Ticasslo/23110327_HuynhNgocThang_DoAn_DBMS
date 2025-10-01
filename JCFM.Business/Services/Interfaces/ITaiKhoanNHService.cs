using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
    public interface ITaiKhoanNHService
    {
        // SP_GetTaiKhoanNH — Vai trò: TP/NVTC/Kế toán
        DataTable GetTaiKhoanNH(string trangThai = null, string nganHang = null, bool? coSoDu = null);

        // SP_ThemTaiKhoanNH — Vai trò: Trưởng phòng
        int ThemTaiKhoanNH(string tenTk, string soTk, string nganHang, decimal soDu = 0);

        // SP_SuaTaiKhoanNH — Vai trò: Trưởng phòng
        int SuaTaiKhoanNH(int maTknh, string tenTk, string soTk, string nganHang, string trangThai = "active");

        // SP_UpdateTaiKhoanNH — Vai trò: Trưởng phòng
        int VoHieuHoaTaiKhoanNH(int maTknh);
    }
}
