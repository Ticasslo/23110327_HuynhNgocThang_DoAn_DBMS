using JCFM.Business.Exceptions;
using JCFM.Business.Services.Interfaces;
using JCFM.DataAccess.Exceptions;
using JCFM.DataAccess.Repositories;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Implementations
{
    public class LoaiGiaoDichService : ILoaiGiaoDichService
    {
        private readonly XemLoaiGiaoDich _repo = new XemLoaiGiaoDich();

        // SP_GetLoaiGiaoDich — Vai trò: TP/NVTC/Kế toán
        public DataTable GetLoaiGiaoDich(string loaiThuChi = null)
        {
            try { return _repo.GetLoaiGiaoDich(loaiThuChi); }
            catch (DataAccessException ex) { throw new BusinessException("Không lấy được loại giao dịch.", ex); }
        }
    }
}
