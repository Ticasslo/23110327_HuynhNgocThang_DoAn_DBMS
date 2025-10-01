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
    public class QLDuAn
    {
        // SP: SP_GetDuAn — Vai trò: TP/NVTC/Kế toán (xem)
        public DataTable GetDuAn(string trangThai = null, DateTime? tuNgayBd = null, DateTime? denNgayBd = null, bool? coNganSach = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetDuAn");
            cmd.Parameters.Add(DbHelper.Param("@TrangThai", trangThai));
            cmd.Parameters.Add(DbHelper.Param("@TuNgayBd", tuNgayBd));
            cmd.Parameters.Add(DbHelper.Param("@DenNgayBd", denNgayBd));
            cmd.Parameters.Add(DbHelper.Param("@CoNganSach", coNganSach.HasValue ? (object)(coNganSach.Value ? 1 : 0) : DBNull.Value));
            return DbHelper.ExecuteDataTable(cmd);
        }

        // SP: SP_ThemDuAn — Vai trò: Trưởng phòng
        public int ThemDuAn(string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach = 0)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_ThemDuAn");
            cmd.Parameters.Add(DbHelper.Param("@ten_du_an", tenDuAn));
            cmd.Parameters.Add(DbHelper.Param("@ngay_bd", ngayBd));
            cmd.Parameters.Add(DbHelper.Param("@ngay_kt", ngayKt));
            cmd.Parameters.Add(DbHelper.Param("@ngan_sach", nganSach));

            var scalar = DbHelper.ExecuteScalar(cmd);
            return Convert.ToInt32(scalar);
        }

        // SP: SP_SuaDuAn — Vai trò: Trưởng phòng
        public int SuaDuAn(int maDuAn, string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach, string trangThai = "active")
        {
            var cmd = DbHelper.StoredProc("dbo.SP_SuaDuAn");
            cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));
            cmd.Parameters.Add(DbHelper.Param("@ten_du_an", tenDuAn));
            cmd.Parameters.Add(DbHelper.Param("@ngay_bd", ngayBd));
            cmd.Parameters.Add(DbHelper.Param("@ngay_kt", ngayKt));
            cmd.Parameters.Add(DbHelper.Param("@ngan_sach", nganSach));
            cmd.Parameters.Add(DbHelper.Param("@trang_thai", trangThai));

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT @@ROWCOUNT
            return Convert.ToInt32(scalar);
        }

        // SP: SP_UpdateDuAn (vô hiệu hóa) — Vai trò: Trưởng phòng
        public int VohieuHoaDuAn(int maDuAn)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_UpdateDuAn");
            cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT @@ROWCOUNT
            return Convert.ToInt32(scalar);
        }
    }
}
