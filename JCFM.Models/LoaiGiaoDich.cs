using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class LoaiGiaoDich
    {
        private string maLoai;         // PK e.g. LGD_UT
        private string tenLoai;
        private string loaiThuChi;     // 'THU' | 'CHI'
        private string moTa;

        public LoaiGiaoDich() { }

        public LoaiGiaoDich(string maLoai, string tenLoai, string loaiThuChi, string moTa)
        {
            this.maLoai = maLoai;
            this.tenLoai = tenLoai;
            this.loaiThuChi = loaiThuChi;
            this.moTa = moTa;
        }

        public string MaLoai
        {
            get => this.maLoai;
            set => this.maLoai = value;
        }

        public string TenLoai
        {
            get => this.tenLoai;
            set => this.tenLoai = value;
        }

        public string LoaiThuChi
        {
            get => this.loaiThuChi;
            set => this.loaiThuChi = value;
        }

        public string MoTa
        {
            get => this.moTa;
            set => this.moTa = value;
        }
    }
}
