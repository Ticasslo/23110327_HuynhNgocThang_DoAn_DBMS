using JCFM.Business.Services.Implementations;
using JCFM.Business.Services.Interfaces;
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
    public partial class QLTaiKhoanNH_Form : Form
    {
        private readonly AppSession _session;
        private readonly ITaiKhoanNHService _tknhSvc = new TaiKhoanNHService();

        private enum EditMode { None, Create, Update }
        private EditMode _mode = EditMode.None;
        private int _maTkDangSua = 0;

        public QLTaiKhoanNH_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void QLTaiKhoanNH_Form_Load(object sender, EventArgs e)
        {
            InitFilters();
            InitDetail();
            ApplyRolePermissions();
            SetEditMode(EditMode.None);
            LoadGrid();
            BindSelectionToDetail(null);
        }

        private void ApplyRolePermissions()
        {
            bool isTP = _session.Role == UserRole.TruongPhongTC;
            btnThem.Visible = isTP;
            btnSua.Visible = isTP;
            btnVoHieuHoa.Visible = isTP;
            btnLuu.Visible = isTP;
            btnHuy.Visible = isTP;

            pnlChiTiet.Enabled = false;
        }

        #region Init
        private void InitFilters()
        {
            cboTrangThai.Items.Clear();
            cboTrangThai.Items.Add("(Tất cả)");
            cboTrangThai.Items.Add("active");
            cboTrangThai.Items.Add("inactive");
            cboTrangThai.SelectedIndex = 0;

            txtNganHang.Clear(); // filter LIKE theo tên ngân hàng
        }

        private void InitDetail()
        {
            // combo trạng thái chỉ dùng khi Update
            cboTrangThaiCT.Items.Clear();
            cboTrangThaiCT.Items.Add("active");
            cboTrangThaiCT.Items.Add("inactive");
            cboTrangThaiCT.SelectedIndex = 0;

            txtTenTk.Clear();
            txtSoTk.Clear();
            txtNganHangCT.Clear();
            txtSoDu.Clear();
            txtSoDu.ReadOnly = true; // mặc định readonly; Create sẽ mở
        }
        #endregion

        #region Grid + Filters
        private void LoadGrid()
        {
            string trangThai = cboTrangThai.SelectedIndex <= 0 ? null : cboTrangThai.SelectedItem.ToString();
            string nganHang = string.IsNullOrWhiteSpace(txtNganHang.Text) ? null : txtNganHang.Text.Trim();

            var dt = _tknhSvc.GetTaiKhoanNH(trangThai, nganHang, null); // bỏ filter Có số dư

            dgvTKNH.AutoGenerateColumns = true;
            dgvTKNH.DataSource = dt;

            ApplyVietHeadersAndFormat();
            UpdateVoHieuHoaButtonState();
        }

        private void ApplyVietHeadersAndFormat()
        {
            void H(string name, string header)
            {
                if (dgvTKNH.Columns.Contains(name))
                    dgvTKNH.Columns[name].HeaderText = header;
            }

            H("ma_tknh", "Mã TK");
            H("ten_tk", "Tên tài khoản");
            H("so_tk", "Số tài khoản");
            H("ngan_hang", "Ngân hàng");
            H("so_du", "Số dư");
            H("trang_thai", "Trạng thái");

            if (dgvTKNH.Columns.Contains("so_du"))
            {
                var col = dgvTKNH.Columns["so_du"];
                col.DefaultCellStyle.Format = "N0"; // VNĐ không thập phân
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }
            if (dgvTKNH.Columns.Contains("trang_thai"))
                dgvTKNH.Columns["trang_thai"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void ResetFilters()
        {
            cboTrangThai.SelectedIndex = 0;
            txtNganHang.Clear();
        }
        #endregion

        #region Selection → Detail
        private void dgvTKNH_SelectionChanged(object sender, EventArgs e)
        {
            var row = (dgvTKNH.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (_mode == EditMode.None)
            {
                BindSelectionToDetail(row);
                UpdateVoHieuHoaButtonState();
            }
        }

        private void BindSelectionToDetail(DataRow row)
        {
            txtTenTk.Clear();
            txtSoTk.Clear();
            txtNganHangCT.Clear();
            txtSoDu.Clear();
            cboTrangThaiCT.SelectedIndex = 0;
            txtSoDu.ReadOnly = true;

            if (row == null) return;

            if (row.Table.Columns.Contains("ten_tk"))
                txtTenTk.Text = row["ten_tk"]?.ToString();

            if (row.Table.Columns.Contains("so_tk"))
                txtSoTk.Text = row["so_tk"]?.ToString();

            if (row.Table.Columns.Contains("ngan_hang"))
                txtNganHangCT.Text = row["ngan_hang"]?.ToString();

            if (row.Table.Columns.Contains("so_du") && decimal.TryParse(row["so_du"]?.ToString(), out var sd))
                txtSoDu.Text = sd.ToString("N0");

            if (row.Table.Columns.Contains("trang_thai"))
            {
                var tt = row["trang_thai"]?.ToString();
                var idx = cboTrangThaiCT.Items.Cast<object>().ToList()
                    .FindIndex(x => string.Equals(x.ToString(), tt, StringComparison.OrdinalIgnoreCase));
                if (idx >= 0) cboTrangThaiCT.SelectedIndex = idx;
            }
        }
        #endregion

        #region Edit mode + Buttons
        private void SetEditMode(EditMode m)
        {
            _mode = m;
            bool isTP = _session.Role == UserRole.TruongPhongTC;
            bool editing = m != EditMode.None;

            pnlChiTiet.Enabled = isTP && editing;
            dgvTKNH.Enabled = !editing;

            btnThem.Enabled = isTP && !editing;
            btnSua.Enabled = isTP && !editing;
            btnVoHieuHoa.Enabled = isTP && !editing;
            btnLuu.Enabled = isTP && editing;
            btnHuy.Enabled = isTP && editing;

            btnTim.Enabled = !editing;
            btnTai.Enabled = !editing;

            // Luôn khóa ô số dư
            txtSoDu.ReadOnly = true;

            // Nếu tạo mới → hiện “0”
            if (_mode == EditMode.Create) txtSoDu.Text = "0";
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            _maTkDangSua = 0;
            ClearDetailForCreate();
            SetEditMode(EditMode.Create);
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            var row = (dgvTKNH.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một tài khoản để sửa."); return; }

            _maTkDangSua = Convert.ToInt32(row["ma_tknh"]);
            BindSelectionToDetail(row);
            SetEditMode(EditMode.Update);
        }

        private void btnVoHieuHoa_Click(object sender, EventArgs e)
        {
            var row = (dgvTKNH.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một tài khoản để vô hiệu hóa."); return; }

            var ma = Convert.ToInt32(row["ma_tknh"]);
            var tt = row["trang_thai"]?.ToString();
            if (string.Equals(tt, "inactive", StringComparison.OrdinalIgnoreCase))
            {
                MessageBox.Show("Tài khoản đã inactive.");
                return;
            }

            if (MessageBox.Show("Vô hiệu hóa tài khoản này?", "Xác nhận",
                MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No) return;

            try
            {
                _tknhSvc.VoHieuHoaTaiKhoanNH(ma); // SP_UpdateTaiKhoanNH
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Thao tác thất bại: " + ex.Message, "Lỗi",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (_session.Role != UserRole.TruongPhongTC) return;

            var ten = txtTenTk.Text?.Trim();
            var so = txtSoTk.Text?.Trim();
            var nh = txtNganHangCT.Text?.Trim();

            if (string.IsNullOrWhiteSpace(ten)) { MessageBox.Show("Nhập Tên tài khoản."); txtTenTk.Focus(); return; }
            if (string.IsNullOrWhiteSpace(so)) { MessageBox.Show("Nhập Số tài khoản."); txtSoTk.Focus(); return; }
            if (string.IsNullOrWhiteSpace(nh)) { MessageBox.Show("Nhập tên Ngân hàng."); txtNganHangCT.Focus(); return; }

            try
            {
                if (_mode == EditMode.Create)
                {
                    decimal soDuBanDau = 0m; // cố định 0
                    _tknhSvc.ThemTaiKhoanNH(ten, so, nh, soDuBanDau);
                    MessageBox.Show("Thêm tài khoản thành công.");
                }
                else if (_mode == EditMode.Update)
                {
                    var tt = cboTrangThaiCT.SelectedItem?.ToString() ?? "active";
                    _tknhSvc.SuaTaiKhoanNH(_maTkDangSua, ten, so, nh, tt); // SP_SuaTaiKhoanNH
                    MessageBox.Show("Cập nhật tài khoản thành công.");
                }

                SetEditMode(EditMode.None);
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lưu thất bại: " + ex.Message, "Lỗi",
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            SetEditMode(EditMode.None);
            var row = (dgvTKNH.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
        }

        private void UpdateVoHieuHoaButtonState()
        {
            if (_session.Role != UserRole.TruongPhongTC) return;
            if (_mode != EditMode.None) { btnVoHieuHoa.Enabled = false; return; }

            var row = (dgvTKNH.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { btnVoHieuHoa.Enabled = false; return; }

            var tt = row["trang_thai"]?.ToString();
            btnVoHieuHoa.Enabled = !string.Equals(tt, "inactive", StringComparison.OrdinalIgnoreCase);
        }

        private void ClearDetailForCreate()
        {
            txtTenTk.Clear();
            txtSoTk.Clear();
            txtNganHangCT.Clear();
            txtSoDu.Clear();
            cboTrangThaiCT.SelectedIndex = 0; // active (hiển thị khi Update)
        }
        #endregion

        #region Search/Reload/Back
        private void btnTim_Click(object sender, EventArgs e)
        {
            if (BlockIfEditing()) return;
            LoadGrid();
        }

        private void btnTai_Click(object sender, EventArgs e)
        {
            if (BlockIfEditing()) return;
            ResetFilters();
            LoadGrid();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
        #endregion

        #region Input helpers
        private void txtSoTk_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar)) e.Handled = true;
        }
        #endregion

        private bool BlockIfEditing()
        {
            if (_mode != EditMode.None)
            {
                MessageBox.Show("Đang thêm/sửa. Vui lòng Lưu hoặc Hủy trước.");
                return true;
            }
            return false;
        }
    }
}
