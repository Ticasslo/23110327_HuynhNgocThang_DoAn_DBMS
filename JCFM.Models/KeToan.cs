using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models
{
    namespace JPC.Models.Finance
    {
        public class KeToan
        {
            private int maNv;        // PK & FK -> NhanVien
            private string chungChi;
            private int kinhNghiem;  // >= 0

            public KeToan() { }

            public KeToan(int maNv, string chungChi, int kinhNghiem = 0)
            {
                this.maNv = maNv;
                this.chungChi = chungChi;
                this.kinhNghiem = kinhNghiem;
            }

            public int MaNv
            {
                get => this.maNv;
                set => this.maNv = value;
            }

            public string ChungChi
            {
                get => this.chungChi;
                set => this.chungChi = value;
            }

            public int KinhNghiem
            {
                get => this.kinhNghiem;
                set => this.kinhNghiem = value;
            }
        }
    }
}