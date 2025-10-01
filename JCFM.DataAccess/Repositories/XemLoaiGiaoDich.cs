using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JCFM.DataAccess.DBConnection;

namespace JCFM.DataAccess.Repositories
{
    public class XemLoaiGiaoDich
    {
        // SP: SP_GetLoaiGiaoDich — Vai trò: TP/NVTC/Kế toán
        public DataTable GetLoaiGiaoDich(string loaiThuChi = null) // "THU"/"CHI"/null
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetLoaiGiaoDich");
            cmd.Parameters.Add(DbHelper.Param("@LoaiThuChi", loaiThuChi));
            return DbHelper.ExecuteDataTable(cmd);
        }
    }
}
