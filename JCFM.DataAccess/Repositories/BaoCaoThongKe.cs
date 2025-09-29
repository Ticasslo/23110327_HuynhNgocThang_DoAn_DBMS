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
    public class BaoCaoThongKe
    {
        // SP: SP_GetThongKeThang — Vai trò: Trưởng phòng/Kế toán (✅/✅)
        public DataTable GetThongKeThang(int? nam = null, int? thang = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetThongKeThang");
            cmd.Parameters.Add(DbHelper.Param("@Nam", nam));
            cmd.Parameters.Add(DbHelper.Param("@Thang", thang));
            return DbHelper.ExecuteDataTable(cmd);
        }

        // SP: SP_XuatBaoCaoChiTiet — Vai trò: Trưởng phòng/Kế toán (✅/✅)
        public DataTable XuatBaoCaoChiTiet(DateTime ngayBd, DateTime ngayKt, int? maDuAn = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_XuatBaoCaoChiTiet");
            cmd.Parameters.Add(DbHelper.Param("@ngay_bd", ngayBd));
            cmd.Parameters.Add(DbHelper.Param("@ngay_kt", ngayKt));
            cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));
            return DbHelper.ExecuteDataTable(cmd);
        }
    }
}
