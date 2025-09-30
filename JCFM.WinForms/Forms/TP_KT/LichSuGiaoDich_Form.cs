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

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms
{
    public partial class LichSuGiaoDich_Form : Form
    {
        private readonly AppSession _session;

        private readonly IGiaoDichService _gdSvc = new GiaoDichService();
        private readonly IDuAnService _daSvc = new DuAnService();
        private readonly ITaiKhoanNHService _tknhSvc = new TaiKhoanNHService();
        private readonly INhanVienService _nvSvc  = new NhanVienService(); // nếu bạn chưa có thì tạm bỏ filter Người tạo

        public LichSuGiaoDich_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void LichSuGiaoDich_Form_Load(object sender, EventArgs e)
        {
            // Chỉ TP & Kế toán
            if (_session.Role == UserRole.NhanVienTC)
            {
                MessageBox.Show("Chỉ Trưởng phòng/Kế toán được truy cập màn hình này.");
                Close();
                return;
            }

            InitFilters();
            LoadGrid();
            BindSelectionToDetail(null);
            ApplyReadonlyDetail();
        }

        private void ApplyReadonlyDetail()
        {
            foreach (var tb in new[] { txtLoai, txtSoTien, txtTenLoai, txtTaiKhoan, txtDuAn, txtNgay, txtNguoiTao, txtMoTa })
                tb.ReadOnly = true;
        }

        #region Init + Filters
        private void InitFilters()
        {
            // Trạng thái
            cboTT.Items.Clear();
            cboTT.Items.Add("(Tất cả)");
            cboTT.Items.Add("CHO_DUYET");
            cboTT.Items.Add("DA_DUYET");
            cboTT.Items.Add("TU_CHOI");
            cboTT.SelectedIndex = 0;

            // Loại: THU/CHI
            cboLoai.Items.Clear();
            cboLoai.Items.Add("(Tất cả)");
            cboLoai.Items.Add("THU");
            cboLoai.Items.Add("CHI");
            cboLoai.SelectedIndex = 0;

            // Dự án
            var da = _daSvc.GetDuAn(null, null, null, null); // ma_du_an, ten_du_an...
            BindCombo(cboDuAn, da, "ten_du_an", "ma_du_an", addAll: true);

            // Tài khoản NH (có trong SP_GetLichSuGiaoDich)
            var tknh = _tknhSvc.GetTaiKhoanNH(null, null, null); // ma_tknh, ten_tk...
            BindCombo(cboTKNH, tknh, "ten_tk", "ma_tknh", addAll: true);

            // ✅ dùng SP_TimNhanVien
            var nv = _nvSvc.TimNhanVien(keyword: null, vaiTro: "NHAN_VIEN_TC", trangThai: null);
            BindCombo(cboNguoiTao, nv, "ho_ten", "ma_nv", addAll: true);

            // DateTimePicker: ShowCheckBox = true trong Designer
            dtpTu.Checked = false;
            dtpDen.Checked = false;
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
            string tt = cboTT.SelectedIndex <= 0 ? null : cboTT.SelectedItem.ToString();
            string loai = cboLoai.SelectedIndex <= 0 ? null : cboLoai.SelectedItem.ToString();

            DateTime? tu = dtpTu.Checked ? dtpTu.Value.Date : (DateTime?)null;
            DateTime? den = dtpDen.Checked ? dtpDen.Value.Date : (DateTime?)null;

            int? maDuAn = (cboDuAn.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboDuAn.SelectedValue);
            int? maTknh = (cboTKNH.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboTKNH.SelectedValue);
            int? maNvTao = (cboNguoiTao.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboNguoiTao.SelectedValue);

            var dt = _gdSvc.GetLichSuGiaoDich(tu, den, tt, loai, maDuAn, maTknh, maNvTao);
            dgvLichSu.AutoGenerateColumns = true;
            dgvLichSu.DataSource = dt;

            if (dgvLichSu.Columns.Contains("mo_ta"))
                dgvLichSu.Columns["mo_ta"].Visible = false;

            ApplyVietHeadersAndFormat();
        }

        private void ApplyVietHeadersAndFormat()
        {
            void H(string name, string header)
            {
                if (dgvLichSu.Columns.Contains(name))
                    dgvLichSu.Columns[name].HeaderText = header;
            }

            // === CHỈ RA CHỖ CẦN SỬA HEADER TIẾNG VIỆT ===
            H("ma_gd", "Mã GD");
            H("loai_gd", "Loại");
            H("so_tien", "Số tiền");
            H("ngay_gd", "Ngày tạo");
            H("trang_thai", "Trạng thái");
            H("ten_loai", "Loại giao dịch");
            H("tai_khoan", "Tài khoản NH");
            H("nguoi_tao", "Người tạo");
            H("nguoi_duyet", "Người duyệt");
            H("ngay_duyet", "Ngày duyệt");
            H("ten_du_an", "Dự án");
            H("mo_ta", "Mô tả");

            // Số tiền VN: không thập phân
            if (dgvLichSu.Columns.Contains("so_tien"))
            {
                var col = dgvLichSu.Columns["so_tien"];
                col.DefaultCellStyle.Format = "N0";
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }

            // Căn giữa một số cột ngắn
            if (dgvLichSu.Columns.Contains("loai_gd"))
                dgvLichSu.Columns["loai_gd"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            if (dgvLichSu.Columns.Contains("trang_thai"))
                dgvLichSu.Columns["trang_thai"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }
        #endregion

        #region Selection → Detail (readonly view)

        private void dgvLichSu_SelectionChanged(object sender, EventArgs e)
        {
            var row = (dgvLichSu.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
        }

        private void BindSelectionToDetail(DataRow row)
        {
            txtLoai.Text = txtSoTien.Text = txtTenLoai.Text = txtTaiKhoan.Text =
            txtDuAn.Text = txtNgay.Text = txtNguoiTao.Text = txtMoTa.Text = string.Empty;

            if (row == null) return;

            if (row.Table.Columns.Contains("loai_gd"))
                txtLoai.Text = row["loai_gd"]?.ToString();

            if (row.Table.Columns.Contains("so_tien"))
                txtSoTien.Text = SafeToN0(row["so_tien"]);

            if (row.Table.Columns.Contains("ten_loai"))
                txtTenLoai.Text = row["ten_loai"]?.ToString();

            if (row.Table.Columns.Contains("tai_khoan"))
                txtTaiKhoan.Text = row["tai_khoan"]?.ToString();

            if (row.Table.Columns.Contains("ten_du_an"))
                txtDuAn.Text = string.IsNullOrWhiteSpace(row["ten_du_an"]?.ToString())
                               ? "(Không có)" : row["ten_du_an"]?.ToString();

            if (row.Table.Columns.Contains("ngay_gd"))
            {
                var dt = ToNullableDateTime(row["ngay_gd"]);
                if (dt.HasValue) txtNgay.Text = dt.Value.ToString("dd/MM/yyyy HH:mm");
            }

            if (row.Table.Columns.Contains("nguoi_tao"))
                txtNguoiTao.Text = row["nguoi_tao"]?.ToString();
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

        private static DateTime? ToNullableDateTime(object v)
        {
            if (v == null || v == DBNull.Value) return null;
            if (v is DateTime dt) return dt;
            if (DateTime.TryParse(v.ToString(), out var dt2)) return dt2;
            return null;
        }
        #endregion

        #region Buttons (gán event trong Designer)
        private void btnTim_Click(object sender, EventArgs e) => LoadGrid();

        private void btnTai_Click(object sender, EventArgs e)
        {
            cboTT.SelectedIndex = 0;
            cboLoai.SelectedIndex = 0;
            if (cboDuAn.Items.Count > 0) cboDuAn.SelectedIndex = 0;
            if (cboTKNH.Items.Count > 0) cboTKNH.SelectedIndex = 0;
            if (cboNguoiTao.Items.Count > 0) cboNguoiTao.SelectedIndex = 0;
            dtpTu.Checked = dtpDen.Checked = false;

            LoadGrid();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
        #endregion
    }
}
