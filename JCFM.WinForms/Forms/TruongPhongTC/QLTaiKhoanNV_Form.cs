using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using JCFM.Business.Services.Implementations;
using JCFM.Business.Services.Interfaces;
using JCFM.Models.Login;

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.TruongPhongTC
{
    public partial class QLTaiKhoanNV_Form : Form
    {
        private readonly AppSession _session;
        private readonly INhanVienService _nvSvc = new NhanVienService();

        private enum EditMode { None, Create }
        private EditMode _mode = EditMode.None;
        private int _maNvDangChon = 0;

        public QLTaiKhoanNV_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void QLTaiKhoanNV_Form_Load(object sender, EventArgs e)
        {
            if (_session.Role != UserRole.TruongPhongTC)
            {
                MessageBox.Show("Chỉ Trưởng phòng được truy cập màn hình này.");
                Close();
                return;
            }

            InitFilters();
            InitDetail();
            SetEditMode(EditMode.None);
            LoadGrid();
            BindSelectionToDetail(null);
        }

        #region Init
        private void InitFilters()
        {
            cboVaiTro.Items.Clear();
            cboVaiTro.Items.Add("(Tất cả)");
            cboVaiTro.Items.Add("TRUONG_PHONG_TC");
            cboVaiTro.Items.Add("NHAN_VIEN_TC");
            cboVaiTro.Items.Add("KE_TOAN");
            cboVaiTro.SelectedIndex = 0;

            cboTrangThai.Items.Clear();
            cboTrangThai.Items.Add("(Tất cả)");
            cboTrangThai.Items.Add("active");
            cboTrangThai.Items.Add("inactive");
            cboTrangThai.SelectedIndex = 0;
        }

        private void InitDetail()
        {
            cboVaiTroCT.Items.Clear();
            cboVaiTroCT.Items.Add("TRUONG_PHONG_TC");
            cboVaiTroCT.Items.Add("NHAN_VIEN_TC");
            cboVaiTroCT.Items.Add("KE_TOAN");
            cboVaiTroCT.SelectedIndex = 1; // default: NV tài chính
        }
        #endregion

        #region Grid + Filters
        private void LoadGrid()
        {
            string keyword   = txtKeyword.Text?.Trim();
            string vaiTro    = cboVaiTro.SelectedIndex <= 0 ? null : cboVaiTro.SelectedItem.ToString();
            string trangThai = cboTrangThai.SelectedIndex <= 0 ? null : cboTrangThai.SelectedItem.ToString();

            var dt = _nvSvc.TimNhanVien(keyword, vaiTro, trangThai);

            dgvNhanVien.AutoGenerateColumns = true;
            dgvNhanVien.DataSource = dt;

            ApplyHeaders();
            UpdateDeleteButtonState();
        }

        private void ApplyHeaders()
        {
            void H(string name, string header)
            {
                if (dgvNhanVien.Columns.Contains(name))
                    dgvNhanVien.Columns[name].HeaderText = header;
            }
            H("ma_nv", "Mã NV");
            H("ho_ten", "Họ tên");
            H("email", "Email");
            H("sdt", "SĐT");
            H("username", "Username");
            H("trang_thai", "Trạng thái");
            H("vai_tro", "Vai trò");

            if (dgvNhanVien.Columns.Contains("trang_thai"))
                dgvNhanVien.Columns["trang_thai"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            if (dgvNhanVien.Columns.Contains("vai_tro"))
                dgvNhanVien.Columns["vai_tro"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }
        #endregion

        #region Selection → Detail
        private void dgvNhanVien_SelectionChanged(object sender, EventArgs e)
        {
            if (_mode != EditMode.None) return; // đang tạo mới thì bỏ qua map
            var row = (dgvNhanVien.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
            UpdateDeleteButtonState();
        }

        private void BindSelectionToDetail(DataRow row)
        {
            _maNvDangChon = 0;
            txtHoTen.Clear();
            txtEmail.Clear();
            txtSdt.Clear();
            txtUsername.Clear();
            txtPassword.Clear();
            cboVaiTroCT.SelectedIndex = 1;

            if (row == null) return;

            if (row.Table.Columns.Contains("ma_nv"))
                _maNvDangChon = Convert.ToInt32(row["ma_nv"]);
            if (row.Table.Columns.Contains("ho_ten"))
                txtHoTen.Text = row["ho_ten"]?.ToString();
            if (row.Table.Columns.Contains("email"))
                txtEmail.Text = row["email"]?.ToString();
            if (row.Table.Columns.Contains("sdt"))
                txtSdt.Text = row["sdt"]?.ToString();
            if (row.Table.Columns.Contains("username"))
                txtUsername.Text = row["username"]?.ToString();

            if (row.Table.Columns.Contains("vai_tro"))
            {
                var vt = row["vai_tro"]?.ToString();
                if (!string.IsNullOrWhiteSpace(vt))
                {
                    int idx = cboVaiTroCT.Items.Cast<object>()
                        .ToList().FindIndex(x => string.Equals(x.ToString(), vt, StringComparison.OrdinalIgnoreCase));
                    if (idx >= 0) cboVaiTroCT.SelectedIndex = idx;
                }
            }
        }
        #endregion

        #region Edit mode + Buttons
        private void SetEditMode(EditMode mode)
        {
            _mode = mode;
            bool creating = (mode == EditMode.Create);

            // Khu nhập liệu
            pnlChiTiet.Enabled = creating;

            // Nút
            btnThem.Enabled = !creating;
            btnLamMoi.Enabled = !creating;
            btnTim.Enabled = !creating;

            btnTao.Enabled = creating;
            btnHuy.Enabled = creating;

            // nút Xóa mềm chỉ bật khi không tạo và có row
            btnXoa.Enabled = !creating && _maNvDangChon > 0;

            if (creating) ClearDetailForCreate();
            UpdateDeleteButtonState();
        }

        private void ClearDetailForCreate()
        {
            _maNvDangChon = 0;
            txtHoTen.Clear();
            txtEmail.Clear();
            txtSdt.Clear();
            txtUsername.Clear();
            txtPassword.Clear();
            cboVaiTroCT.SelectedIndex = 1;
        }

        private void UpdateDeleteButtonState()
        {
            // đang tạo mới thì tắt hết nút hành động
            if (_mode != EditMode.None)
            {
                btnXoa.Enabled = false;
                btnKichHoat.Enabled = false;
                return;
            }

            var row = (dgvNhanVien.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            bool hasRow = row != null;

            btnXoa.Enabled = hasRow; // luôn cho phép Inactive khi có dòng

            // chỉ bật Kích hoạt khi trạng thái hiện tại là inactive
            bool canActivate = false;
            if (hasRow && row.Table.Columns.Contains("trang_thai"))
            {
                var tt = row["trang_thai"]?.ToString();
                canActivate = string.Equals(tt, "inactive", StringComparison.OrdinalIgnoreCase);
            }
            btnKichHoat.Enabled = canActivate;
        }
        #endregion

        #region Validate
        private bool ValidateCreateInput()
        {
            if (string.IsNullOrWhiteSpace(txtHoTen.Text))
            { MessageBox.Show("Nhập Họ tên."); txtHoTen.Focus(); return false; }

            if (string.IsNullOrWhiteSpace(txtEmail.Text))
            { MessageBox.Show("Nhập Email."); txtEmail.Focus(); return false; }

            if (string.IsNullOrWhiteSpace(txtUsername.Text))
            { MessageBox.Show("Nhập Username."); txtUsername.Focus(); return false; }

            if (string.IsNullOrWhiteSpace(txtPassword.Text))
            { MessageBox.Show("Nhập Password."); txtPassword.Focus(); return false; }

            if (cboVaiTroCT.SelectedItem == null)
            { MessageBox.Show("Chọn Vai trò."); cboVaiTroCT.DroppedDown = true; return false; }

            return true;
        }
        #endregion

        #region Buttons (gán event)
        private void btnTim_Click(object sender, EventArgs e) => LoadGrid();

        private void btnLamMoi_Click(object sender, EventArgs e)
        {
            txtKeyword.Clear();
            cboVaiTro.SelectedIndex = 0;
            cboTrangThai.SelectedIndex = 0;
            LoadGrid();
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            SetEditMode(EditMode.Create);
        }

        private void btnTao_Click(object sender, EventArgs e)
        {
            if (!ValidateCreateInput()) return;

            var hoTen = txtHoTen.Text.Trim();
            var email = txtEmail.Text.Trim();
            var sdt = txtSdt.Text.Trim();
            var username = txtUsername.Text.Trim();
            var password = txtPassword.Text.Trim();
            var vaiTro = cboVaiTroCT.SelectedItem.ToString();

            try
            {
                // 1) Detect “đang inactive”
                var existedInactive = _nvSvc.TimNhanVien(username, null, "inactive");
                if (existedInactive != null && existedInactive.Rows.Count > 0)
                {
                    var ans = MessageBox.Show(
                        "Tài khoản này đang ở trạng thái INACTIVE.\n" +
                        "Bạn muốn kích hoạt lại và Provision SQL không?",
                        "Phát hiện tài khoản inactive", MessageBoxButtons.YesNo, MessageBoxIcon.Question);
                    if (ans == DialogResult.No) return;
                }

                // 2) Gọi SP_ThemNhanVien: dựa vào logic SP để “kích hoạt lại nếu inactive”
                int maNvMoi = _nvSvc.ThemNhanVien(hoTen, email, sdt, username, password, vaiTro, provision: true);

                // 3) Nếu SP re-activate thì cũng trả về id
                MessageBox.Show($"Thành công. Mã NV: {maNvMoi}");
                SetEditMode(EditMode.None);
                LoadGrid();
            }
            catch (Exception ex)
            {
                // Fallback: nếu ExecuteScalar không trả về (xem mục #2), thử xem có active chưa
                var justActivated = _nvSvc.TimNhanVien(username, null, "active");
                if (justActivated != null && justActivated.Rows.Count > 0)
                {
                    MessageBox.Show("Tạo/kích hoạt có thể đã thành công (SP không trả id). Đã reload danh sách.");
                    SetEditMode(EditMode.None);
                    LoadGrid();
                    return;
                }

                MessageBox.Show("Tạo/kích hoạt thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }


        private void btnHuy_Click(object sender, EventArgs e)
        {
            SetEditMode(EditMode.None);
            var row = (dgvNhanVien.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
        }

        private void btnXoa_Click(object sender, EventArgs e)
        {
            if (_mode != EditMode.None) { MessageBox.Show("Đang tạo mới, hãy Hủy/Lưu trước."); return; }
            var row = (dgvNhanVien.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một nhân viên để inactive."); return; }

            int maNv = Convert.ToInt32(row["ma_nv"]);
            string user = row.Table.Columns.Contains("username") ? row["username"]?.ToString() : "(?)";

            if (MessageBox.Show(
                $"Inactive tài khoản của NV [{user}] ?\n(Tài khoản SQL cũng sẽ drop nếu có.)",
                "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No) return;

            try
            {
                _nvSvc.XoaNhanVien(maNv, hardDelete: false, dropSql: true); // SOFT DELETE duy nhất
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Inactive thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
        #endregion

        private void txtSdt_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
                e.Handled = true;
        }

        private void btnKichHoat_Click(object sender, EventArgs e)
        {
            if (_mode != EditMode.None)
            {
                MessageBox.Show("Đang ở chế độ tạo mới. Hãy Lưu/Hủy trước khi thao tác kích hoạt.");
                return;
            }

            var row = (dgvNhanVien.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một nhân viên để kích hoạt."); return; }

            int maNv = Convert.ToInt32(row["ma_nv"]);
            string username = row.Table.Columns.Contains("username") ? row["username"]?.ToString() : "(?)";
            string tt = row.Table.Columns.Contains("trang_thai") ? row["trang_thai"]?.ToString() : null;

            if (!string.Equals(tt, "inactive", StringComparison.OrdinalIgnoreCase))
            {
                MessageBox.Show("Tài khoản hiện không ở trạng thái INACTIVE.");
                return;
            }

            if (MessageBox.Show(
                $"Kích hoạt lại tài khoản của NV [{username}]?\n" +
                "(Hệ thống sẽ active tài khoản ứng dụng và cấp lại SQL Login/User.)",
                "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No) return;

            try
            {
                // provision = true: cấp lại SQL Login/User bằng mật khẩu đang lưu
                _nvSvc.KichHoatNhanVien(maNv, provision: true);
                MessageBox.Show("Đã kích hoạt và provision SQL thành công.");
                LoadGrid();               // refresh lưới
                UpdateDeleteButtonState(); // cập nhật nút
            }
            catch (Exception ex)
            {
                MessageBox.Show("Kích hoạt thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }
    }
}
