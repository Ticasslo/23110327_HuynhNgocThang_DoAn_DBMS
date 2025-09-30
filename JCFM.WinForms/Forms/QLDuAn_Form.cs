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
    public partial class QLDuAn_Form : Form
    {
        private readonly AppSession _session;
        private readonly IDuAnService _daSvc = new DuAnService();

        private enum EditMode { None, Create, Update }
        private EditMode _mode = EditMode.None;
        private int _maDuAnDangSua = 0;

        public QLDuAn_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void QLDuAn_Form_Load(object sender, EventArgs e)
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

            // CRUD buttons
            btnThem.Visible = isTP;
            btnSua.Visible = isTP;
            btnVoHieuHoa.Visible = isTP;
            btnLuu.Visible = isTP;
            btnHuy.Visible = isTP;

            // Panel chi tiết chỉ TP mới được nhập
            pnlChiTiet.Enabled = false; // mặc định readonly; SetEditMode sẽ bật khi TP edit
        }

        #region Init
        private void InitFilters()
        {
            // Trạng thái filter: (Tất cả)/active/inactive/hoan_thanh
            cboTrangThai.Items.Clear();
            cboTrangThai.Items.Add("(Tất cả)");
            cboTrangThai.Items.Add("active");
            cboTrangThai.Items.Add("inactive");
            cboTrangThai.Items.Add("hoan_thanh");
            cboTrangThai.SelectedIndex = 0;

            // DateTimePicker: set trong Designer -> ShowCheckBox = true
            dtpTuBd.Checked = false;
            dtpDenBd.Checked = false;
        }

        private void InitDetail()
        {
            // Trạng thái chi tiết
            cboTrangThaiCT.Items.Clear();
            cboTrangThaiCT.Items.Add("active");
            cboTrangThaiCT.Items.Add("inactive");
            cboTrangThaiCT.Items.Add("hoan_thanh");
            cboTrangThaiCT.SelectedIndex = 0;

            // Ngày kết thúc có thể bỏ trống: đặt ShowCheckBox = true trong Designer
            dtpNgayKt.Checked = false;

            // Ngân sách: số VN không thập phân khi hiển thị
            txtNganSach.Text = "";
        }
        #endregion

        #region Grid + Filters
        private void LoadGrid()
        {
            string trangThai = cboTrangThai.SelectedIndex <= 0 ? null : cboTrangThai.SelectedItem.ToString();
            DateTime? tuBd = dtpTuBd.Checked ? dtpTuBd.Value.Date : (DateTime?)null;
            DateTime? denBd = dtpDenBd.Checked ? dtpDenBd.Value.Date : (DateTime?)null;

            var dt = _daSvc.GetDuAn(trangThai, tuBd, denBd);

            dgvDuAn.AutoGenerateColumns = true;
            dgvDuAn.DataSource = dt;

            ApplyVietHeadersAndFormat();
            UpdateVoHieuHoaButtonState();
        }

        private void ApplyVietHeadersAndFormat()
        {
            void H(string name, string header)
            {
                if (dgvDuAn.Columns.Contains(name))
                    dgvDuAn.Columns[name].HeaderText = header;
            }
            H("ma_du_an", "Mã DA");
            H("ten_du_an", "Tên dự án");
            H("ngay_bd", "Ngày bắt đầu");
            H("ngay_kt", "Ngày kết thúc");
            H("ngan_sach", "Ngân sách");
            H("trang_thai", "Trạng thái");

            if (dgvDuAn.Columns.Contains("ngan_sach"))
            {
                var col = dgvDuAn.Columns["ngan_sach"];
                col.DefaultCellStyle.Format = "N0"; // tiền Việt: không thập phân
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }
            if (dgvDuAn.Columns.Contains("trang_thai"))
                dgvDuAn.Columns["trang_thai"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void ResetFilters()
        {
            cboTrangThai.SelectedIndex = 0;
            dtpTuBd.Checked = dtpDenBd.Checked = false;
        }
        #endregion

        #region Selection → Detail
        private void dgvDuAn_SelectionChanged(object sender, EventArgs e)
        {
            var row = (dgvDuAn.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (_mode == EditMode.None) // chỉ map khi không ở chế độ edit
            {
                BindSelectionToDetail(row);
                UpdateVoHieuHoaButtonState();
            }
        }

        private void BindSelectionToDetail(DataRow row)
        {
            txtTen.Text = txtNganSach.Text = "";
            dtpNgayBd.Value = DateTime.Now.Date;
            dtpNgayKt.Checked = false;
            cboTrangThaiCT.SelectedIndex = 0;

            if (row == null) return;

            if (row.Table.Columns.Contains("ten_du_an"))
                txtTen.Text = row["ten_du_an"]?.ToString();

            if (row.Table.Columns.Contains("ngay_bd") && row["ngay_bd"] != DBNull.Value)
                dtpNgayBd.Value = Convert.ToDateTime(row["ngay_bd"]);

            if (row.Table.Columns.Contains("ngay_kt"))
            {
                if (row["ngay_kt"] == DBNull.Value) dtpNgayKt.Checked = false;
                else { dtpNgayKt.Checked = true; dtpNgayKt.Value = Convert.ToDateTime(row["ngay_kt"]); }
            }

            if (row.Table.Columns.Contains("ngan_sach") && decimal.TryParse(row["ngan_sach"]?.ToString(), out var ns))
                txtNganSach.Text = ns.ToString("N0");

            if (row.Table.Columns.Contains("trang_thai"))
            {
                var tt = row["trang_thai"]?.ToString();
                if (!string.IsNullOrWhiteSpace(tt))
                {
                    var idx = cboTrangThaiCT.Items.Cast<object>().ToList().FindIndex(x =>
                        string.Equals(x.ToString(), tt, StringComparison.OrdinalIgnoreCase));
                    if (idx >= 0) cboTrangThaiCT.SelectedIndex = idx;
                }
            }
        }
        #endregion

        #region Edit mode + Buttons
        private void SetEditMode(EditMode m)
        {
            _mode = m;

            bool isTP = _session.Role == UserRole.TruongPhongTC;
            bool editing = (m != EditMode.None);

            pnlChiTiet.Enabled = isTP && editing;
            dgvDuAn.Enabled = !editing;

            btnThem.Enabled = isTP && !editing;
            btnSua.Enabled = isTP && !editing;
            btnVoHieuHoa.Enabled = isTP && !editing;
            btnLuu.Enabled = isTP && editing;
            btnHuy.Enabled = isTP && editing;

            btnTim.Enabled = !editing;
            btnTai.Enabled = !editing;
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            _maDuAnDangSua = 0;
            ClearDetailForCreate();
            SetEditMode(EditMode.Create);
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            var row = (dgvDuAn.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một dự án để sửa."); return; }

            _maDuAnDangSua = Convert.ToInt32(row["ma_du_an"]);
            // Map sẵn detail từ row đang chọn
            BindSelectionToDetail(row);
            SetEditMode(EditMode.Update);
        }

        private void btnVoHieuHoa_Click(object sender, EventArgs e)
        {
            var row = (dgvDuAn.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một dự án để vô hiệu hóa."); return; }

            var maDa = Convert.ToInt32(row["ma_du_an"]);
            var tt = row["trang_thai"]?.ToString();
            if (string.Equals(tt, "inactive", StringComparison.OrdinalIgnoreCase))
            {
                MessageBox.Show("Dự án đã ở trạng thái inactive.");
                return;
            }

            if (MessageBox.Show("Vô hiệu hóa dự án này?", "Xác nhận", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                return;

            try
            {
                _daSvc.VoHieuHoaDuAn(maDa); // gọi SP_UpdateDuAn
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Thao tác thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            if (_session.Role != UserRole.TruongPhongTC) return;

            // Validate
            var ten = txtTen.Text?.Trim();
            if (string.IsNullOrWhiteSpace(ten)) { MessageBox.Show("Nhập Tên dự án."); txtTen.Focus(); return; }

            if (!decimal.TryParse(txtNganSach.Text.Replace(",", "").Trim(), out var nganSach) || nganSach < 0)
            {
                MessageBox.Show("Ngân sách không hợp lệ.");
                txtNganSach.Focus(); return;
            }

            var ngayBd = dtpNgayBd.Value.Date;
            DateTime? ngayKt = dtpNgayKt.Checked ? dtpNgayKt.Value.Date : (DateTime?)null;

            try
            {
                if (_mode == EditMode.Create)
                {
                    _daSvc.ThemDuAn(ten, ngayBd, ngayKt, nganSach); // SP_ThemDuAn
                    MessageBox.Show("Thêm dự án thành công.");
                }
                else if (_mode == EditMode.Update)
                {
                    // trạng thái lấy từ combo chi tiết
                    var tt = cboTrangThaiCT.SelectedItem?.ToString() ?? "active";
                    _daSvc.SuaDuAn(_maDuAnDangSua, ten, ngayBd, ngayKt, nganSach, tt); // SP_SuaDuAn
                    MessageBox.Show("Cập nhật dự án thành công.");
                }

                SetEditMode(EditMode.None);
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Lưu thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnHuy_Click(object sender, EventArgs e)
        {
            SetEditMode(EditMode.None);
            var row = (dgvDuAn.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
        }

        private void UpdateVoHieuHoaButtonState()
        {
            if (_session.Role != UserRole.TruongPhongTC) return;
            if (_mode != EditMode.None) { btnVoHieuHoa.Enabled = false; return; }
            var row = (dgvDuAn.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { btnVoHieuHoa.Enabled = false; return; }
            var tt = row["trang_thai"]?.ToString();
            btnVoHieuHoa.Enabled = !string.Equals(tt, "inactive", StringComparison.OrdinalIgnoreCase);
        }

        private void ClearDetailForCreate()
        {
            txtTen.Clear();
            dtpNgayBd.Value = DateTime.Now.Date;
            dtpNgayKt.Checked = false;
            txtNganSach.Clear();
            cboTrangThaiCT.SelectedIndex = 0; // active
        }
        #endregion

        #region Search/Reload/Back (gán event trong Designer)
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
        private void txtNganSach_KeyPress(object sender, KeyPressEventArgs e)
        {
            // chỉ số + phím điều khiển
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
