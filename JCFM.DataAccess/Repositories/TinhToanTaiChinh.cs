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
    public class TinhToanTaiChinh
    {
        // FN: FN_TinhLaiLo — Vai trò: Trưởng phòng/Kế toán (EXECUTE)
        public decimal TinhLaiLo(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null)
        {
            using (var cmd = new SqlCommand(
                "SELECT dbo.FN_TinhLaiLo(@ngay_bd, @ngay_kt, @ma_du_an);")
            { CommandType = CommandType.Text })
            {
                cmd.Parameters.Add(DbHelper.Param("@ngay_bd", ngayBd));
                cmd.Parameters.Add(DbHelper.Param("@ngay_kt", ngayKt));
                cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));
                var scalar = DbHelper.ExecuteScalar(cmd);
                return scalar == null || scalar == DBNull.Value ? 0m : Convert.ToDecimal(scalar);
            }
        }

        // FN: FN_KiemTraSoDu — Vai trò: NVTC/K (EXECUTE)
        public decimal KiemTraSoDu(int maTknh)
        {
            using (var cmd = new SqlCommand(
                "SELECT dbo.FN_KiemTraSoDu(@ma_tknh);")
            { CommandType = CommandType.Text })
            {
                cmd.Parameters.Add(DbHelper.Param("@ma_tknh", maTknh));
                var scalar = DbHelper.ExecuteScalar(cmd);
                return scalar == null || scalar == DBNull.Value ? 0m : Convert.ToDecimal(scalar);
            }
        }

        // FN: FN_TinhTongThuChi — Vai trò: Trưởng phòng/Kế toán (SELECT)
        public DataTable TinhTongThuChi(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null)
        {
            using (var cmd = new SqlCommand(
                "SELECT * FROM dbo.FN_TinhTongThuChi(@ngay_bd, @ngay_kt, @ma_du_an);")
            { CommandType = CommandType.Text })
            {
                cmd.Parameters.Add(DbHelper.Param("@ngay_bd", ngayBd));
                cmd.Parameters.Add(DbHelper.Param("@ngay_kt", ngayKt));
                cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));
                return DbHelper.ExecuteDataTable(cmd);
            }
        }
    }
}
