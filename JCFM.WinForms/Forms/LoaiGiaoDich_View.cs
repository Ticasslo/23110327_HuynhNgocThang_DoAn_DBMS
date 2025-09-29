using JCFM.Models.Login;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms
{
    public partial class LoaiGiaoDich_View : Form
    {
        private readonly AppSession _session;

        public LoaiGiaoDich_View(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void LoaiGiaoDich_View_Load(object sender, EventArgs e)
        {

        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
    }
}
