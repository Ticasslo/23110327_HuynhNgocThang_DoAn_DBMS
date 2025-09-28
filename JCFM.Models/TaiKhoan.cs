using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class TaiKhoan
    {
        private int maTk;
        private string username;
        private string password;
        private string trangThai; // 'active' | 'inactive'

        public TaiKhoan() { }

        public TaiKhoan(int maTk, string username, string password, string trangThai = "active")
        {
            this.maTk = maTk;
            this.username = username;
            this.password = password;
            this.trangThai = trangThai;
        }

        public int MaTk
        {
            get => this.maTk;
            set => this.maTk = value;
        }

        public string Username
        {
            get => this.username;
            set => this.username = value;
        }

        public string Password
        {
            get => this.password;
            set => this.password = value;
        }

        public string TrangThai
        {
            get => this.trangThai;
            set => this.trangThai = value;
        }
    }
}
