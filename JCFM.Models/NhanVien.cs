using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class NhanVien
    {
        private int maNv;
        private string hoTen;
        private string email;
        private string sdt;
        private int maTk; // FK -> TaiKhoan

        public NhanVien() { }

        public NhanVien(int maNv, string hoTen, string email, string sdt, int maTk)
        {
            this.maNv = maNv;
            this.hoTen = hoTen;
            this.email = email;
            this.sdt = sdt;
            this.maTk = maTk;
        }

        public int MaNv
        {
            get => this.maNv;
            set => this.maNv = value;
        }

        public string HoTen
        {
            get => this.hoTen;
            set => this.hoTen = value;
        }

        public string Email
        {
            get => this.email;
            set => this.email = value;
        }

        public string Sdt
        {
            get => this.sdt;
            set => this.sdt = value;
        }

        public int MaTk
        {
            get => this.maTk;
            set => this.maTk = value;
        }
    }
}
