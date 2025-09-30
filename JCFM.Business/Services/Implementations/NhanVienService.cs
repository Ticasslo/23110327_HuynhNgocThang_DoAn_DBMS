using JCFM.Business.Exceptions;
using JCFM.Business.Services.Interfaces;
using JCFM.DataAccess.Exceptions;
using JCFM.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JCFM.DataAccess.Repositories;

namespace JCFM.Business.Services.Implementations
{
    public class NhanVienService : INhanVienService
    {
        private readonly QLNhanVien _repo;

        public NhanVienService() : this(new QLNhanVien()) { }
        public NhanVienService(QLNhanVien repo) { _repo = repo; }

        public DataTable TimNhanVien(string keyword = null, string vaiTro = null, string trangThai = null)
        {
            return _repo.TimNhanVien(keyword, vaiTro, trangThai);
        }

        public int ThemNhanVien(string hoTen, string email, string sdt, string username, string password, string vaiTro, bool provision = true)
        {
            if (string.IsNullOrWhiteSpace(hoTen)) throw new ArgumentException("HoTen bắt buộc.");
            if (string.IsNullOrWhiteSpace(email)) throw new ArgumentException("Email bắt buộc.");
            if (string.IsNullOrWhiteSpace(username)) throw new ArgumentException("Username bắt buộc.");
            if (string.IsNullOrWhiteSpace(password)) throw new ArgumentException("Password bắt buộc.");
            if (string.IsNullOrWhiteSpace(vaiTro)) throw new ArgumentException("VaiTro bắt buộc.");

            return _repo.ThemNhanVien(hoTen, email, sdt, username, password, vaiTro, provision);
        }

        public int XoaNhanVien(int maNv, bool hardDelete = false, bool dropSql = true)
        {
            if (maNv <= 0) throw new ArgumentException("MaNv bị sai.");
            return _repo.XoaNhanVien(maNv, hardDelete, dropSql);
        }

        public int KichHoatNhanVien(int maNv, bool provision = true)
        {
            if (maNv <= 0) throw new ArgumentException("MaNv bị sai.");
            return _repo.KichHoatNhanVien(maNv, provision);
        }
    }
}
