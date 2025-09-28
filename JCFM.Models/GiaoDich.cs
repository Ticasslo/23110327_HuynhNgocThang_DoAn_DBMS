using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class GiaoDich
    {
        private int maGd;
        private string loaiGd;          // 'THU' | 'CHI'
        private decimal soTien;         // > 0
        private DateTime ngayGd;        // default GETDATE() khi insert DB
        private string moTa;            // nullable
        private string maLoai;          // FK -> LoaiGiaoDich.ma_loai
        private int maTknh;             // FK -> TaiKhoanNH
        private int maNvTaoNvtc;        // FK -> NhanVienTC.ma_nv
        private int? maDuAn;            // FK -> DuAn.ma_du_an (nullable)
        private string trangThai;       // 'CHO_DUYET' | 'DA_DUYET' | 'TU_CHOI'
        private int? maNvDuyetTp;       // FK -> TruongPhongTC.ma_nv (nullable)
        private DateTime? ngayDuyet;    // nullable

        public GiaoDich() { }

        public GiaoDich(
            int maGd,
            string loaiGd,
            decimal soTien,
            DateTime ngayGd,
            string moTa,
            string maLoai,
            int maTknh,
            int maNvTaoNvtc,
            int? maDuAn,
            string trangThai,
            int? maNvDuyetTp,
            DateTime? ngayDuyet)
        {
            this.maGd = maGd;
            this.loaiGd = loaiGd;
            this.soTien = soTien;
            this.ngayGd = ngayGd;
            this.moTa = moTa;
            this.maLoai = maLoai;
            this.maTknh = maTknh;
            this.maNvTaoNvtc = maNvTaoNvtc;
            this.maDuAn = maDuAn;
            this.trangThai = trangThai;
            this.maNvDuyetTp = maNvDuyetTp;
            this.ngayDuyet = ngayDuyet;
        }

        public int MaGd
        {
            get => this.maGd;
            set => this.maGd = value;
        }

        public string LoaiGd
        {
            get => this.loaiGd;
            set => this.loaiGd = value;
        }

        public decimal SoTien
        {
            get => this.soTien;
            set => this.soTien = value;
        }

        public DateTime NgayGd
        {
            get => this.ngayGd;
            set => this.ngayGd = value;
        }

        public string MoTa
        {
            get => this.moTa;
            set => this.moTa = value;
        }

        public string MaLoai
        {
            get => this.maLoai;
            set => this.maLoai = value;
        }

        public int MaTknh
        {
            get => this.maTknh;
            set => this.maTknh = value;
        }

        public int MaNvTaoNvtc
        {
            get => this.maNvTaoNvtc;
            set => this.maNvTaoNvtc = value;
        }

        public int? MaDuAn
        {
            get => this.maDuAn;
            set => this.maDuAn = value;
        }

        public string TrangThai
        {
            get => this.trangThai;
            set => this.trangThai = value;
        }

        public int? MaNvDuyetTp
        {
            get => this.maNvDuyetTp;
            set => this.maNvDuyetTp = value;
        }

        public DateTime? NgayDuyet
        {
            get => this.ngayDuyet;
            set => this.ngayDuyet = value;
        }
    }
}
