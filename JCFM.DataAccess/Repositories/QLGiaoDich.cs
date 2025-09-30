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
    public class QLGiaoDich
    {
        // SP: SP_ThemGiaoDich — Vai trò: Nhân viên TC (✅)
        public int ThemGiaoDich(string loaiGd, decimal soTien, string moTa, string maLoai, int maTknh, int maNvTaoNvtc, int? maDuAn)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_ThemGiaoDich");
            cmd.Parameters.Add(DbHelper.Param("@loai_gd", loaiGd));
            cmd.Parameters.Add(DbHelper.Param("@so_tien", soTien));
            cmd.Parameters.Add(DbHelper.Param("@mo_ta", moTa));
            cmd.Parameters.Add(DbHelper.Param("@ma_loai", maLoai));
            cmd.Parameters.Add(DbHelper.Param("@ma_tknh", maTknh));
            cmd.Parameters.Add(DbHelper.Param("@ma_nv_tao_nvtc", maNvTaoNvtc));
            cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));

            var scalar = DbHelper.ExecuteScalar(cmd); // ma_gd_moi
            return Convert.ToInt32(scalar);
        }

        // SP: SP_SuaGiaoDich — Vai trò: Nhân viên TC (✅) (chỉ sửa của mình & khi CHO_DUYET)
        public int SuaGiaoDich(int maGd, decimal soTien, string moTa, string maLoai, int maTknh, int? maDuAn, int maNvSua)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_SuaGiaoDich");
            cmd.Parameters.Add(DbHelper.Param("@ma_gd", maGd));
            cmd.Parameters.Add(DbHelper.Param("@so_tien", soTien));
            cmd.Parameters.Add(DbHelper.Param("@mo_ta", moTa));
            cmd.Parameters.Add(DbHelper.Param("@ma_loai", maLoai));
            cmd.Parameters.Add(DbHelper.Param("@ma_tknh", maTknh));
            cmd.Parameters.Add(DbHelper.Param("@ma_du_an", maDuAn));
            cmd.Parameters.Add(DbHelper.Param("@ma_nv_sua", maNvSua));

            var scalar = DbHelper.ExecuteScalar(cmd); // SELECT @@ROWCOUNT
            return Convert.ToInt32(scalar);
        }

        // SP: SP_DuyetGiaoDich — Vai trò: Trưởng phòng (✅)
        public bool DuyetGiaoDich(int maGd, int maNvDuyetTp, string trangThai) // 'DA_DUYET' hoặc 'TU_CHOI'
        {
            var cmd = DbHelper.StoredProc("dbo.SP_DuyetGiaoDich");
            cmd.Parameters.Add(DbHelper.Param("@ma_gd", maGd));
            cmd.Parameters.Add(DbHelper.Param("@ma_nv_duyet_tp", maNvDuyetTp));
            cmd.Parameters.Add(DbHelper.Param("@trang_thai", trangThai));

            // SP không trả dữ liệu; nếu không ném lỗi là OK
            DbHelper.ExecuteNonQuery(cmd);
            return true;
        }

        // SP: SP_GetGiaoDichChoDuyet — Vai trò: Trưởng phòng (✅) (xem tất cả chờ duyệt)
        public DataTable GetGiaoDichChoDuyet(int? maNvTao = null, string loaiGd = null, int? maDuAn = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetGiaoDichChoDuyet");
            cmd.Parameters.Add(DbHelper.Param("@MaNvTao", maNvTao));
            cmd.Parameters.Add(DbHelper.Param("@LoaiGd", loaiGd));
            cmd.Parameters.Add(DbHelper.Param("@MaDuAn", maDuAn));
            return DbHelper.ExecuteDataTable(cmd);
        }


        // SP: SP_GetLichSuGiaoDich — Vai trò: Trưởng phòng/Kế toán (✅/✅)
        public DataTable GetLichSuGiaoDich(DateTime? tuNgay = null, DateTime? denNgay = null, string trangThai = null, string loaiGd = null, int? maDuAn = null, int? maTknh = null, int? maNvTao = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetLichSuGiaoDich");
            cmd.Parameters.Add(DbHelper.Param("@TuNgay", tuNgay));
            cmd.Parameters.Add(DbHelper.Param("@DenNgay", denNgay));
            cmd.Parameters.Add(DbHelper.Param("@TrangThai", trangThai));
            cmd.Parameters.Add(DbHelper.Param("@LoaiGd", loaiGd));
            cmd.Parameters.Add(DbHelper.Param("@MaDuAn", maDuAn));
            cmd.Parameters.Add(DbHelper.Param("@MaTknh", maTknh));
            cmd.Parameters.Add(DbHelper.Param("@MaNvTao", maNvTao));
            return DbHelper.ExecuteDataTable(cmd);
        }

        // SP: SP_GetLichSuGiaoDich_ForNhanVienTC — Vai trò: Nhân viên TC (✅) (chỉ của tôi)
        public DataTable GetLichSuGiaoDich_CuaToi(int maNvTao, DateTime? tuNgay = null, DateTime? denNgay = null, string trangThai = null, string loaiGd = null, int? maDuAn = null, int? maTknh = null)
        {
            var cmd = DbHelper.StoredProc("dbo.SP_GetLichSuGiaoDich_ForNhanVienTC");
            cmd.Parameters.Add(DbHelper.Param("@MaNvTao", maNvTao));
            cmd.Parameters.Add(DbHelper.Param("@TuNgay", tuNgay));
            cmd.Parameters.Add(DbHelper.Param("@DenNgay", denNgay));
            cmd.Parameters.Add(DbHelper.Param("@TrangThai", trangThai));
            cmd.Parameters.Add(DbHelper.Param("@LoaiGd", loaiGd));
            cmd.Parameters.Add(DbHelper.Param("@MaDuAn", maDuAn));
            cmd.Parameters.Add(DbHelper.Param("@MaTknh", maTknh));
            return DbHelper.ExecuteDataTable(cmd);
        }
    }
}
