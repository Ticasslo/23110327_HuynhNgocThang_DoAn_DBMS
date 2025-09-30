using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces
{
    public interface INhanVienService
    {
        // Tra cứu danh bạ nhân viên (wrap SP_TimNhanVien)
        DataTable TimNhanVien(string keyword = null, string vaiTro = null, string trangThai = null);

        // Thêm / Xóa nhân viên (wrap SP_ThemNhanVien, SP_XoaNhanVien)
        int ThemNhanVien(string hoTen, string email, string sdt, string username, string password, string vaiTro, bool provision = true);
        int XoaNhanVien(int maNv, bool hardDelete = false, bool dropSql = true);
        int KichHoatNhanVien(int maNv, bool provision = true);
    }
}
