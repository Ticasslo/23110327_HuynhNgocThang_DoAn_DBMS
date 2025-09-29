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

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.TruongPhongTC
{
    public partial class TrangChuTruongPhongTC_Form : Form
    {
        private readonly AppSession _session;

        public TrangChuTruongPhongTC_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
            lblWelcome.Text = $"Xin chào, {_session.Username} (Mã NV: {_session.MaNhanVien})";
        }

        private void TrangChuTruongPhongTC_Form_Load(object sender, EventArgs e)
        {

        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }

        private bool _exiting = false;
        private void btnClose_Click(object sender, EventArgs e)
        {
            if (_exiting) return;

            var ask = MessageBox.Show(
                "Bạn có chắc muốn thoát ứng dụng?",
                "Xác nhận thoát",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question,
                MessageBoxDefaultButton.Button2);

            if (ask == DialogResult.Yes)
            {
                _exiting = true;
                Application.Exit();
            }
        }

        private void OpenChild(Form child)
        {
            child.Owner = this;
            this.Hide();
            child.Show();
        }

        private void btnQLTaiKhoanNH_Click(object sender, EventArgs e)
            => OpenChild(new QLTaiKhoanNH_Form(_session));

        private void btnQLDuAn_Click(object sender, EventArgs e)
            => OpenChild(new QLDuAn_Form(_session));

        private void btnGiaoDichChoDuyet_Click(object sender, EventArgs e)
            => OpenChild(new GiaoDichChoDuyet_Form(_session));

        private void btnLichSuGiaoDich_Click(object sender, EventArgs e)
            => OpenChild(new LichSuGiaoDich_Form(_session));

        private void btnThongKeThang_Click(object sender, EventArgs e)
            => OpenChild(new ThongKeThang_Form(_session));

        private void btnBaoCaoChiTiet_Click(object sender, EventArgs e)
            => OpenChild(new BaoCaoChiTiet_Form(_session));

        private void btnLoaiGiaoDich_Click(object sender, EventArgs e)
            => OpenChild(new LoaiGiaoDich_View(_session));
    }
}
