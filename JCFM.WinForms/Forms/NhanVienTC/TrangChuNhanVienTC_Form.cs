using _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.Login;
using _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.TruongPhongTC;
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
    public partial class TrangChuNhanVienTC_Form : Form
    {
        private readonly AppSession _session;

        public TrangChuNhanVienTC_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
            lblWelcome.Text = $"Xin chào, {_session.Username} (Mã NV: {_session.MaNhanVien})";
        }

        private void TrangChuNhanVienTC_Form_Load(object sender, EventArgs e)
        {

        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            var ask = MessageBox.Show(
                "Bạn có muốn trở lại trang đăng nhập?",
                "Xác nhận",
                MessageBoxButtons.YesNo,
                MessageBoxIcon.Question,
                MessageBoxDefaultButton.Button2);

            if (ask == DialogResult.Yes)
            {
                if (this.Owner != null && !this.Owner.IsDisposed)
                {
                    this.Owner.Show();
                }
                else
                {
                    var login = new Login_Form();
                    login.Show();
                }
                this.Close();
            }
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

        private void btnGiaoDichCuaToi_Click(object sender, EventArgs e)
            => OpenChild(new GiaoDichCuaToi_Form(_session));

        private void btnXemTaiKhoanNH_Click(object sender, EventArgs e)
            => OpenChild(new QLTaiKhoanNH_Form(_session));   // form tự disable CRUD theo role

        private void btnXemDuAn_Click(object sender, EventArgs e)
            => OpenChild(new QLDuAn_Form(_session));         // readonly theo role

        private void btnLoaiGiaoDich_Click(object sender, EventArgs e)
            => OpenChild(new LoaiGiaoDich_Form(_session));

        private void btnLoaiGiaoDich_Click_1(object sender, EventArgs e)
            => OpenChild(new LoaiGiaoDich_Form(_session));
    }
}
