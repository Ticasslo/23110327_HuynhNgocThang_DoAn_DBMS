using JCFM.DataAccess.DBConnection;
using JCFM.DataAccess.Exceptions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.DataAccess.Repositories
{
    public class QLTaiKhoanNH
    {
        // SP: SP_GetTaiKhoanNH — Vai trò: TP/NVTC/Kế toán (✅✅✅ xem)
        public DataTable GetTaiKhoanNH(string trangThai = null, string nganHang = null, bool? coSoDu = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetTaiKhoanNH");
            cmd.Parameters.Add(DbHelper.Param("@TrangThai", trangThai));
            cmd.Parameters.Add(DbHelper.Param("@NganHang", nganHang));
            cmd.Parameters.Add(DbHelper.Param("@CoSoDu", coSoDu.HasValue ? (object)(coSoDu.Value ? 1 : 0) : DBNull.Value));
            return DbHelper.ExecuteDataTable(cmd);
        }

        // SP: SP_ThemTaiKhoanNH — Vai trò: Trưởng phòng (✅)
        public int ThemTaiKhoanNH(string tenTk, string soTk, string nganHang, decimal soDu = 0)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_ThemTaiKhoanNH");
            cmd.Parameters.Add(DbHelper.Param("@ten_tk", tenTk));
            cmd.Parameters.Add(DbHelper.Param("@so_tk", soTk));
            cmd.Parameters.Add(DbHelper.Param("@ngan_hang", nganHang));
            cmd.Parameters.Add(DbHelper.Param("@so_du", soDu));

            var scalar = DbHelper.ExecuteScalar(cmd);
            return Convert.ToInt32(scalar);
        }

        // SP: SP_SuaTaiKhoanNH — Vai trò: Trưởng phòng (✅)
        public int SuaTaiKhoanNH(int maTknh, string tenTk, string soTk, string nganHang, string trangThai = "active")
        {
            var cmd = DbHelper.StoredProc("dbo.SP_SuaTaiKhoanNH");
            cmd.Parameters.Add(DbHelper.Param("@ma_tknh", maTknh));
            cmd.Parameters.Add(DbHelper.Param("@ten_tk", tenTk));
            cmd.Parameters.Add(DbHelper.Param("@so_tk", soTk));
            cmd.Parameters.Add(DbHelper.Param("@ngan_hang", nganHang));
            cmd.Parameters.Add(DbHelper.Param("@trang_thai", trangThai));

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT @@ROWCOUNT
            return Convert.ToInt32(scalar);
        }

        // SP: SP_UpdateTaiKhoanNH (vô hiệu hóa) — Vai trò: Trưởng phòng (✅)
        public int VohieuHoaTaiKhoanNH(int maTknh)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_UpdateTaiKhoanNH");
            cmd.Parameters.Add(DbHelper.Param("@ma_tknh", maTknh));

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT @@ROWCOUNT
            return Convert.ToInt32(scalar);
        }
    }
}
