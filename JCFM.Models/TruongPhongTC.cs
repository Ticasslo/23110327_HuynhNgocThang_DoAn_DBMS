using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class TruongPhongTC
    {
        private int maNv;                 // PK & FK -> NhanVien
        private string quyenHan;
        private DateTime ngayBoNhiem;

        public TruongPhongTC() { }

        public TruongPhongTC(int maNv, string quyenHan, DateTime ngayBoNhiem)
        {
            this.maNv = maNv;
            this.quyenHan = quyenHan;
            this.ngayBoNhiem = ngayBoNhiem;
        }

        public int MaNv
        {
            get => this.maNv;
            set => this.maNv = value;
        }

        public string QuyenHan
        {
            get => this.quyenHan;
            set => this.quyenHan = value;
        }

        public DateTime NgayBoNhiem
        {
            get => this.ngayBoNhiem;
            set => this.ngayBoNhiem = value;
        }
    }
}
