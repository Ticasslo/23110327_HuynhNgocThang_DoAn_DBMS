using JCFM.DataAccess.DBConnection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.DataAccess.Repositories
{
    public class QLNhanVien
    {
        // SP: SP_TimNhanVien — TP/NVTC/Kế toán (xem)
        public DataTable TimNhanVien(string keyword = null, string vaiTro = null, string trangThai = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_TimNhanVien");
            cmd.Parameters.Add(DbHelper.Param("@Keyword", keyword));
            cmd.Parameters.Add(DbHelper.Param("@VaiTro", vaiTro));
            cmd.Parameters.Add(DbHelper.Param("@TrangThai", trangThai));
            return DbHelper.ExecuteDataTable(cmd);
        }

        // SP: SP_ThemNhanVien — Trưởng phòng
        // Trả về: ma_nv_moi
        public int ThemNhanVien(
            string hoTen,
            string email,
            string sdt,
            string username,
            string password,
            string vaiTro,      // 'TRUONG_PHONG_TC' | 'NHAN_VIEN_TC' | 'KE_TOAN'
            bool provision = true)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_ThemNhanVien");
            cmd.Parameters.Add(DbHelper.Param("@HoTen", hoTen));
            cmd.Parameters.Add(DbHelper.Param("@Email", email));
            cmd.Parameters.Add(DbHelper.Param("@Sdt", sdt));
            cmd.Parameters.Add(DbHelper.Param("@Username", username));
            cmd.Parameters.Add(DbHelper.Param("@Password", password));
            cmd.Parameters.Add(DbHelper.Param("@VaiTro", vaiTro));
            cmd.Parameters.Add(DbHelper.Param("@Provision", provision ? 1 : 0)); // BIT

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT @ma_nv AS ma_nv_moi
            return Convert.ToInt32(scalar);
        }

        // SP: SP_XoaNhanVien — Trưởng phòng
        // HardDelete = 0: chỉ inactive tài khoản + drop SQL
        // Trả về: success (1) từ SP
        public int XoaNhanVien(int maNv, bool hardDelete = false, bool dropSql = true)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_XoaNhanVien");
            cmd.Parameters.Add(DbHelper.Param("@MaNv", maNv));
            cmd.Parameters.Add(DbHelper.Param("@HardDelete", hardDelete ? 1 : 0)); // BIT
            cmd.Parameters.Add(DbHelper.Param("@DropSql", dropSql ? 1 : 0));    // BIT

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT 1 AS success
            return Convert.ToInt32(scalar);
        }

        // SP: SP_KichHoatNhanVien — Trưởng phòng
        // Trả về: success (1)
        public int KichHoatNhanVien(int maNv, bool provision = true)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_KichHoatNhanVien");
            cmd.Parameters.Add(DbHelper.Param("@MaNv", maNv));
            cmd.Parameters.Add(DbHelper.Param("@Provision", provision ? 1 : 0)); // BIT
            var scalar = DbHelper.ExecuteScalar(cmd);
            if (scalar == null || scalar == DBNull.Value) return 0;
            return Convert.ToInt32(scalar);
        }

    }
}
