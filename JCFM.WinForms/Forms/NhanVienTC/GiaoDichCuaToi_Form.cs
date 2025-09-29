using JCFM.Business.Services.Implementations;
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

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.NhanVienTC
{
    public partial class GiaoDichCuaToi_Form : Form
    {
        private readonly AppSession _session;

        public GiaoDichCuaToi_Form(AppSession session)
        { 
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void GiaoDichCuaToi_Form_Load(object sender, EventArgs e)
        {

        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
    }
}
