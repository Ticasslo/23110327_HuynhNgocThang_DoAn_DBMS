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
    public partial class GiaoDichChoDuyet_Form : Form
    {
        private readonly AppSession _session;

        private readonly IGiaoDichService _gdSvc = new GiaoDichService();
        private readonly IDuAnService _daSvc = new DuAnService();

        public GiaoDichChoDuyet_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void GiaoDichChoDuyet_Form_Load(object sender, EventArgs e)
        {
            // Chặn trái vai trò
            if (_session.Role != UserRole.TruongPhongTC)
            {
                MessageBox.Show("Chỉ Trưởng phòng được truy cập màn hình này.");
                Close();
                return;
            }
            InitFilters();
            LoadGrid();
            BindSelectionToDetail(null);
            ToggleApproveButtons(false);
            ApplyReadonlyDetail();
        }

        private void ApplyReadonlyDetail()
        {
            txtLoai.ReadOnly = true;
            txtSoTien.ReadOnly = true;
            txtTenLoai.ReadOnly = true;
            txtDuAn.ReadOnly = true;
            txtNgayTao.ReadOnly = true;
            txtNguoiTao.ReadOnly = true;
            txtMoTa.ReadOnly = true;
        }

        #region Init + Filters
        private void InitFilters()
        {
            // Loại: (Tất cả)/THU/CHI
            cboLoai.Items.Clear();
            cboLoai.Items.Add("(Tất cả)");
            cboLoai.Items.Add("THU");
            cboLoai.Items.Add("CHI");
            cboLoai.SelectedIndex = 0;

            // Dự án: lấy từ service (có thể rỗng)
            var da = _daSvc.GetDuAn(null, null, null, null); // DataTable: ma_du_an, ten_du_an,...
            BindCombo(cboDuAn, da, "ten_du_an", "ma_du_an", addAll: true);
        }

        private static void BindCombo(ComboBox cbo, DataTable dt, string display, string value, bool addAll)
        {
            var bind = dt?.Copy() ?? new DataTable();
            if (!bind.Columns.Contains(display)) bind.Columns.Add(display, typeof(string));
            if (!bind.Columns.Contains(value)) bind.Columns.Add(value, typeof(object));

            if (addAll)
            {
                var row = bind.NewRow();
                row[display] = "(Tất cả)";
                row[value] = DBNull.Value;
                bind.Rows.InsertAt(row, 0);
            }
            cbo.DisplayMember = display;
            cbo.ValueMember = value;
            cbo.DataSource = bind;
            cbo.SelectedIndex = 0;
        }
        #endregion

        #region Grid
        private void LoadGrid()
        {
            string loai = cboLoai.SelectedIndex <= 0 ? null : cboLoai.SelectedItem.ToString();
            int? maDuAn = (cboDuAn.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboDuAn.SelectedValue);

            var dt = _gdSvc.GetGiaoDichChoDuyet(null, loai, maDuAn); // @MaNvTao = NULL (xem tất cả)

            dgvChoDuyet.AutoGenerateColumns = true;
            dgvChoDuyet.DataSource = dt;

            if (dgvChoDuyet.Columns.Contains("mo_ta"))
                dgvChoDuyet.Columns["mo_ta"].Visible = false;

            ApplyVietHeadersAndFormat();
            ToggleApproveButtons(dgvChoDuyet.CurrentRow != null);
        }

        private void ApplyVietHeadersAndFormat()
        {
            void H(string name, string header)
            {
                if (dgvChoDuyet.Columns.Contains(name))
                    dgvChoDuyet.Columns[name].HeaderText = header;
            }

            H("ma_gd", "Mã GD");
            H("loai_gd", "Loại");
            H("so_tien", "Số tiền");
            H("ngay_gd", "Ngày tạo");
            H("ten_loai", "Loại giao dịch");
            H("ten_du_an", "Dự án");
            H("nguoi_tao", "Người tạo");
            H("mo_ta", "Mô tả");

            // Tiền Việt không thập phân
            if (dgvChoDuyet.Columns.Contains("so_tien"))
            {
                var col = dgvChoDuyet.Columns["so_tien"];
                col.DefaultCellStyle.Format = "N0";
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }

            // Căn giữa vài cột ngắn
            if (dgvChoDuyet.Columns.Contains("loai_gd"))
                dgvChoDuyet.Columns["loai_gd"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }
        #endregion

        #region Selection → Detail
        private void dgvChoDuyet_SelectionChanged(object sender, EventArgs e)
        {
            var row = (dgvChoDuyet.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
            ToggleApproveButtons(row != null);
        }

        private void BindSelectionToDetail(DataRow row)
        {
            // Clear trước
            txtLoai.Text = txtSoTien.Text = txtTenLoai.Text =
                txtDuAn.Text = txtNgayTao.Text = txtNguoiTao.Text = txtMoTa.Text = string.Empty;

            if (row == null) return;

            if (row.Table.Columns.Contains("loai_gd"))
                txtLoai.Text = row["loai_gd"]?.ToString();

            if (row.Table.Columns.Contains("so_tien"))
                txtSoTien.Text = SafeToN0(row["so_tien"]);

            if (row.Table.Columns.Contains("ten_loai"))
                txtTenLoai.Text = row["ten_loai"]?.ToString();

            if (row.Table.Columns.Contains("ten_du_an"))
                txtDuAn.Text = string.IsNullOrWhiteSpace(row["ten_du_an"]?.ToString())
                               ? "(Không có)" : row["ten_du_an"]?.ToString();

            if (row.Table.Columns.Contains("ngay_gd"))
            {
                var dt = row["ngay_gd"] as DateTime? ?? ConvertToNullableDateTime(row["ngay_gd"]);
                if (dt.HasValue) txtNgayTao.Text = dt.Value.ToString("dd/MM/yyyy HH:mm");
            }

            if (row.Table.Columns.Contains("nguoi_tao"))
                txtNguoiTao.Text = row["nguoi_tao"]?.ToString();

            if (row.Table.Columns.Contains("mo_ta"))
                txtMoTa.Text = row["mo_ta"]?.ToString();
        }

        private static string SafeToN0(object v)
        {
            if (v == null || v == DBNull.Value) return "";
            if (decimal.TryParse(v.ToString(), out var d)) return d.ToString("N0");
            return v.ToString();
        }

        private static DateTime? ConvertToNullableDateTime(object v)
        {
            if (v == null || v == DBNull.Value) return null;
            if (v is DateTime dt) return dt;
            if (DateTime.TryParse(v.ToString(), out var dt2)) return dt2;
            return null;
        }
        #endregion

        #region Buttons
        private void btnTim_Click(object sender, EventArgs e) => LoadGrid();

        private void btnTai_Click(object sender, EventArgs e)
        {
            cboLoai.SelectedIndex = 0;
            if (cboDuAn.Items.Count > 0) cboDuAn.SelectedIndex = 0;
            LoadGrid();
        }

        private void btnDuyet_Click(object sender, EventArgs e)
        {
            var row = (dgvChoDuyet.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một giao dịch để duyệt."); return; }

            var maGd = Convert.ToInt32(row["ma_gd"]);
            try
            {
                _gdSvc.DuyetGiaoDich(maGd, _session.MaNhanVien, "DA_DUYET"); // SP_DuyetGiaoDich
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Duyệt thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnTuChoi_Click(object sender, EventArgs e)
        {
            var row = (dgvChoDuyet.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Chọn một giao dịch để từ chối."); return; }

            var maGd = Convert.ToInt32(row["ma_gd"]);
            try
            {
                _gdSvc.DuyetGiaoDich(maGd, _session.MaNhanVien, "TU_CHOI"); // SP_DuyetGiaoDich
                LoadGrid();
            }
            catch (Exception ex)
            {
                MessageBox.Show("Từ chối thất bại: " + ex.Message, "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }

        private void ToggleApproveButtons(bool enabled)
        {
            btnDuyet.Enabled = enabled;
            btnTuChoi.Enabled = enabled;
        }
        #endregion
    }
}
