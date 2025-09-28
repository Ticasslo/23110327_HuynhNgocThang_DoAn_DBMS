using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class TaiKhoanNH
    {
        private int maTknh;
        private string tenTk;
        private string soTk;
        private string nganHang;
        private decimal soDu;     // DECIMAL(15,2) >= 0
        private string trangThai; // 'active' | 'inactive'

        public TaiKhoanNH() { }

        public TaiKhoanNH(int maTknh, string tenTk, string soTk, string nganHang, decimal soDu, string trangThai = "active")
        {
            this.maTknh = maTknh;
            this.tenTk = tenTk;
            this.soTk = soTk;
            this.nganHang = nganHang;
            this.soDu = soDu;
            this.trangThai = trangThai;
        }

        public int MaTknh
        {
            get => this.maTknh;
            set => this.maTknh = value;
        }

        public string TenTk
        {
            get => this.tenTk;
            set => this.tenTk = value;
        }

        public string SoTk
        {
            get => this.soTk;
            set => this.soTk = value;
        }

        public string NganHang
        {
            get => this.nganHang;
            set => this.nganHang = value;
        }

        public decimal SoDu
        {
            get => this.soDu;
            set => this.soDu = value;
        }

        public string TrangThai
        {
            get => this.trangThai;
            set => this.trangThai = value;
        }
    }
}
