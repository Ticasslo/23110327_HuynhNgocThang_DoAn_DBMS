using _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.KeToan;
using _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.NhanVienTC;
using _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.TruongPhongTC;
using JCFM.Business.Services.Implementations.Login;
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

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.Login
{
    public partial class Login_Form : Form
    {
        private readonly AuthService _auth = new AuthService();
        public Login_Form()
        {
            InitializeComponent();
            txtPass.UseSystemPasswordChar = true;
            this.AcceptButton = btnLogin;
        }

        private async void btnLogin_Click(object sender, EventArgs e)
        {
            btnLogin.Enabled = false;
            try
            {
                var user = txtUser.Text?.Trim();
                var pass = txtPass.Text;

                // Kiem tra dau vao
                if (string.IsNullOrWhiteSpace(user) || string.IsNullOrWhiteSpace(pass))
                {
                    MessageBox.Show("Vui lòng nhập đầy đủ tài khoản và mật khẩu.",
                        "Đăng nhập", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // Goi service dang nhap
                var result = await _auth.LoginAsync(user, pass);
                if (!result.Success)
                {
                    MessageBox.Show(result.Message, "Đăng nhập", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                    return;
                }

                // Tạo session
                var session = new AppSession
                {
                    Username = result.Username,
                    MaNhanVien = result.MaNhanVien,
                    Role = result.Role,
                };

                // Dieu huong theo vai tro
                Form next;
                switch (result.Role)
                {
                    case UserRole.TruongPhongTC: next = new TrangChuTruongPhongTC_Form(session); break;
                    case UserRole.NhanVienTC: next = new TrangChuNhanVienTC_Form(session); break;
                    case UserRole.KeToan: next = new TrangChuKeToan_Form(session); break;
                    default:
                        MessageBox.Show("Không xác định vai trò.", "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                        return;
                }

                // Mo form tiep theo
                this.Hide();
                next.FormClosed += (_, __) =>
                {
                    this.ResetFields();
                    this.Show();
                };
                next.Show(this);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lỗi đăng nhập: " + ex.Message, "Đăng nhập",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            finally
            {
                btnLogin.Enabled = true;
            }
        }

        public void ResetFields()
        {
            txtUser.Clear();
            txtPass.Clear();
            txtUser.Focus();
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

        private void Login_Form_Load(object sender, EventArgs e)
        {
            txtPass.UseSystemPasswordChar = true;
            btnAnHien.Text = "👁 Hiện mật khẩu";
        }

        private void btnAnHien_Click(object sender, EventArgs e)
        {
            txtPass.UseSystemPasswordChar = !txtPass.UseSystemPasswordChar;
            btnAnHien.Text = txtPass.UseSystemPasswordChar ? "👁 Hiện mật khẩu" : "   🔐 Ẩn mật khẩu";

            txtPass.Focus();
            txtPass.SelectionStart = txtPass.TextLength;
        }
    }
}
