using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class DuAn
    {
        private int maDuAn;
        private string tenDuAn;
        private DateTime ngayBd;
        private DateTime? ngayKt;       // NULL nếu chưa kết thúc
        private decimal nganSach;       // >= 0
        private string trangThai;       // 'active' | 'inactive' | 'hoan_thanh'

        public DuAn() { }

        public DuAn(int maDuAn, string tenDuAn, DateTime ngayBd, DateTime? ngayKt, decimal nganSach, string trangThai = "active")
        {
            this.maDuAn = maDuAn;
            this.tenDuAn = tenDuAn;
            this.ngayBd = ngayBd;
            this.ngayKt = ngayKt;
            this.nganSach = nganSach;
            this.trangThai = trangThai;
        }

        public int MaDuAn
        {
            get => this.maDuAn;
            set => this.maDuAn = value;
        }

        public string TenDuAn
        {
            get => this.tenDuAn;
            set => this.tenDuAn = value;
        }

        public DateTime NgayBd
        {
            get => this.ngayBd;
            set => this.ngayBd = value;
        }

        public DateTime? NgayKt
        {
            get => this.ngayKt;
            set => this.ngayKt = value;
        }

        public decimal NganSach
        {
            get => this.nganSach;
            set => this.nganSach = value;
        }

        public string TrangThai
        {
            get => this.trangThai;
            set => this.trangThai = value;
        }
    }
}
