using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
   public interface IGiaoDichService
    {
        // SP_ThemGiaoDich — Vai trò: Nhân viên TC
        int ThemGiaoDich(string loaiGd, decimal soTien, string moTa, string maLoai, int maTknh, int maNvTaoNvtc, int? maDuAn);

        // SP_SuaGiaoDich — Vai trò: Nhân viên TC
        int SuaGiaoDich(int maGd, decimal soTien, string moTa, string maLoai, int maTknh, int? maDuAn, int maNvSua);

        // SP_DuyetGiaoDich — Vai trò: Trưởng phòng
        bool DuyetGiaoDich(int maGd, int maNvDuyetTp, string trangThai);

        // SP_GetGiaoDichChoDuyet — Vai trò: Trưởng phòng
        DataTable GetGiaoDichChoDuyet(int? maNvTao = null, string loaiGd = null, int? maDuAn = null);


        // SP_GetLichSuGiaoDich — Vai trò: Trưởng phòng/Kế toán
        DataTable GetLichSuGiaoDich(DateTime? tuNgay = null, DateTime? denNgay = null, string trangThai = null, string loaiGd = null, int? maDuAn = null, int? maTknh = null, int? maNvTao = null);

        // SP_GetLichSuGiaoDich_ForNhanVienTC — Vai trò: Nhân viên TC
        DataTable GetLichSuGiaoDich_CuaToi(int maNvTao, DateTime? tuNgay = null, DateTime? denNgay = null, string trangThai = null, string loaiGd = null, int? maDuAn = null, int? maTknh = null);
    }
}
