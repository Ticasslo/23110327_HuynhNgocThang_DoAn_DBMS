using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    public class NhanVienTC
    {
        private int maNv;            // PK & FK -> NhanVien
        private string chuyenMon;
        private string capBac;       // 'NhanVien','ChuyenVien', ...

        public NhanVienTC() { }

        public NhanVienTC(int maNv, string chuyenMon, string capBac = "NhanVien")
        {
            this.maNv = maNv;
            this.chuyenMon = chuyenMon;
            this.capBac = capBac;
        }

        public int MaNv
        {
            get => this.maNv;
            set => this.maNv = value;
        }

        public string ChuyenMon
        {
            get => this.chuyenMon;
            set => this.chuyenMon = value;
        }

        public string CapBac
        {
            get => this.capBac;
            set => this.capBac = value;
        }
    }
}
