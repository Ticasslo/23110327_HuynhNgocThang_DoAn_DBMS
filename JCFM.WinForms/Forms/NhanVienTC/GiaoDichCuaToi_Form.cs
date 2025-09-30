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

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.NhanVienTC
{
    public partial class GiaoDichCuaToi_Form : Form
    {
        private readonly AppSession _session;

        private readonly IGiaoDichService _gdSvc = new GiaoDichService();
        private readonly ILoaiGiaoDichService _lgdSvc = new LoaiGiaoDichService();
        private readonly ITaiKhoanNHService _tknhSvc = new TaiKhoanNHService();
        private readonly IDuAnService _daSvc = new DuAnService();
        private readonly ITinhToanService _calcSvc = new TinhToanService();

        private enum EditMode { None, Create, Update }
        private EditMode _mode = EditMode.None;
        private int _maGdDangSua = 0;

        public GiaoDichCuaToi_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void GiaoDichCuaToi_Form_Load(object sender, EventArgs e)
        {
            if (_session.Role != UserRole.NhanVienTC)
            {
                MessageBox.Show("Chỉ Nhân viên Tài chính được truy cập màn hình này.");
                Close();
                return;
            }

            InitFilters();
            InitDetailCombos();
            SetEditMode(EditMode.None);
            LoadGrid();
        }

        #region Init
        private void InitFilters()
        {
            // Loại GD: All/THU/CHI
            cboLoaiGD.Items.Clear();
            cboLoaiGD.Items.Add("(Tất cả)");
            cboLoaiGD.Items.Add("THU");
            cboLoaiGD.Items.Add("CHI");
            cboLoaiGD.SelectedIndex = 0;

            // Trạng thái: All/CHO_DUYET/DA_DUYET/TU_CHOI
            cboTrangThai.Items.Clear();
            cboTrangThai.Items.Add("(Tất cả)");
            cboTrangThai.Items.Add("CHO_DUYET");
            cboTrangThai.Items.Add("DA_DUYET");
            cboTrangThai.Items.Add("TU_CHOI");
            cboTrangThai.SelectedIndex = 0;

            // Dự án & TK NH từ service riêng
            var da = _daSvc.GetDuAn(null, null, null, null); // trả DataTable: ma_du_an, ten_du_an, ...
            BindCombo(cboDuAn, da, "ten_du_an", "ma_du_an", addAll: true);

            var tknh = _tknhSvc.GetTaiKhoanNH(null, null, null); // ma_tknh, ten_tk, ...
            BindCombo(cboTKNH, tknh, "ten_tk", "ma_tknh", addAll: true);

            // DateTimePicker dùng ShowCheckBox=true trong Designer
            dtpTu.Checked = false;
            dtpDen.Checked = false;
        }

        private void InitDetailCombos()
        {
            // Loại GD chi tiết
            cboLoaiChiTiet.Items.Clear();
            cboLoaiChiTiet.Items.Add("THU");
            cboLoaiChiTiet.Items.Add("CHI");
            cboLoaiChiTiet.SelectedIndex = 0;

            // Mã loại theo Loại GD
            ReloadMaLoaiTheoLoaiChiTiet();

            // TK & Dự án
            var tknh = _tknhSvc.GetTaiKhoanNH(null, null, null);
            BindCombo(cboTKNH2, tknh, "ten_tk", "ma_tknh", addAll: false);

            var da = _daSvc.GetDuAn(null, null, null, null);
            BindCombo(cboDuAn2, da, "ten_du_an", "ma_du_an", addAll: false);
            InsertNoneOption(cboDuAn2, "(Không có)");
            cboDuAn2.SelectedIndex = 0;
        }

        private void InsertNoneOption(ComboBox cbo, string text)
        {
            if (cbo.DataSource is DataTable dt)
            {
                var r = dt.NewRow();
                r[cbo.ValueMember] = DBNull.Value;  // NULL khi lưu SP
                r[cbo.DisplayMember] = text;
                dt.Rows.InsertAt(r, 0);
            }
        }

        private void ReloadMaLoaiTheoLoaiChiTiet()
        {
            var loai = cboLoaiChiTiet.SelectedItem?.ToString(); // "THU"/"CHI"
            var dt = _lgdSvc.GetLoaiGiaoDich(loai); // DataTable: ma_loai, ten_loai, loai_thu_chi, mo_ta
            BindCombo(cboMaLoai, dt, "ten_loai", "ma_loai", addAll: false);
        }

        private static void BindCombo(ComboBox cbo, DataTable dt, string display, string value, bool addAll)
        {
            var bind = dt?.Copy() ?? new DataTable();
            if (addAll)
            {
                var row = bind.NewRow();
                if (!bind.Columns.Contains(display)) bind.Columns.Add(display, typeof(string));
                if (!bind.Columns.Contains(value)) bind.Columns.Add(value, typeof(object));
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

        #region Grid + Filters
        private void LoadGrid()
        {
            string loai = cboLoaiGD.SelectedIndex <= 0 ? null : cboLoaiGD.SelectedItem.ToString();
            string tt = cboTrangThai.SelectedIndex <= 0 ? null : cboTrangThai.SelectedItem.ToString();

            DateTime? tu = dtpTu.Checked ? dtpTu.Value.Date : (DateTime?)null;
            DateTime? den = dtpDen.Checked ? dtpDen.Value.Date : (DateTime?)null;

            int? maDuAn = (cboDuAn.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboDuAn.SelectedValue);
            int? maTknh = (cboTKNH.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboTKNH.SelectedValue);

            var dt = _gdSvc.GetLichSuGiaoDich_CuaToi(
                _session.MaNhanVien, tu, den, tt, loai, maDuAn, maTknh);

            dgvGiaoDichCuaToi.AutoGenerateColumns = true;
            dgvGiaoDichCuaToi.DataSource = dt;

            if (dgvGiaoDichCuaToi.Columns.Contains("so_tien"))
            {
                dgvGiaoDichCuaToi.Columns["so_tien"].DefaultCellStyle.Format = "N0";
                dgvGiaoDichCuaToi.Columns["so_tien"].DefaultCellStyle.Alignment =
                    DataGridViewContentAlignment.MiddleRight;
            }

            HideIfExists("nguoi_tao");
            HideIfExists("mo_ta");

            ApplyVietHeaders();
        }
        void HideIfExists(string name)
        {
            if (dgvGiaoDichCuaToi.Columns.Contains(name))
                dgvGiaoDichCuaToi.Columns[name].Visible = false;
        }

        private void ResetFilters()
        {
            cboLoaiGD.SelectedIndex = 0;
            cboTrangThai.SelectedIndex = 0;
            dtpTu.Checked = dtpDen.Checked = false;
            if (cboDuAn.Items.Count > 0) cboDuAn.SelectedIndex = 0;
            if (cboTKNH.Items.Count > 0) cboTKNH.SelectedIndex = 0;
        }
        #endregion

        #region Handlers (gán trong Designer)
        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
        #endregion

        #region Helpers
        private void SetEditMode(EditMode m)
        {
            _mode = m;
            bool editing = m != EditMode.None;
            pnlChiTiet.Enabled = editing;
            btnLuu.Enabled = btnHuy.Enabled = editing;

            btnThem.Enabled = !editing;
            btnSua.Enabled = !editing;
        }

        private void ClearDetail()
        {
            cboLoaiChiTiet.SelectedIndex = 0;
            ReloadMaLoaiTheoLoaiChiTiet();
            txtSoTien.Clear();
            if (cboMaLoai.Items.Count > 0) cboMaLoai.SelectedIndex = 0;
            if (cboTKNH2.Items.Count > 0) cboTKNH2.SelectedIndex = 0;
            if (cboDuAn2.Items.Count > 0) cboDuAn2.SelectedIndex = 0;
            txtMoTa.Clear();
            _maGdDangSua = 0;
        }

        private static void SelectIfMatches(ComboBox cbo, string comboDisplayCol, DataRow src, string srcDisplayCol)
        {
            if (!src.Table.Columns.Contains(srcDisplayCol)) return;
            var target = src[srcDisplayCol]?.ToString();
            if (string.IsNullOrWhiteSpace(target)) return;

            var dt = cbo.DataSource as DataTable;
            if (dt == null || !dt.Columns.Contains(comboDisplayCol)) return;

            var found = dt.AsEnumerable().FirstOrDefault(r =>
                string.Equals(r.Field<string>(comboDisplayCol), target, StringComparison.OrdinalIgnoreCase));

            if (found != null)
            {
                var valMember = cbo.ValueMember;
                if (!string.IsNullOrEmpty(valMember) && dt.Columns.Contains(valMember))
                    cbo.SelectedValue = found[valMember];
            }
        }
        #endregion

        private void btnTim_Click(object sender, EventArgs e)
        {
            LoadGrid();
        }

        private void btnTai_Click(object sender, EventArgs e)
        {
            ResetFilters();
            LoadGrid();
        }

        private void btnThem_Click(object sender, EventArgs e)
        {
            _maGdDangSua = 0;
            ClearDetail();
            SetEditMode(EditMode.Create);
        }

        private void btnSua_Click(object sender, EventArgs e)
        {
            if (dgvGiaoDichCuaToi.CurrentRow == null)
            {
                MessageBox.Show("Hãy chọn 1 giao dịch để sửa.");
                return;
            }

            var row = (dgvGiaoDichCuaToi.CurrentRow.DataBoundItem as DataRowView)?.Row;
            if (row == null) { MessageBox.Show("Dòng dữ liệu không hợp lệ."); return; }

            var trangThai = row.Table.Columns.Contains("trang_thai") ? row["trang_thai"]?.ToString() : null;
            if (!string.Equals(trangThai, "CHO_DUYET", StringComparison.OrdinalIgnoreCase))
            {
                MessageBox.Show("Chỉ được sửa giao dịch đang chờ duyệt.");
                return;
            }

            _maGdDangSua = Convert.ToInt32(row["ma_gd"]);

            MapRowToDetail(row);

            SetEditMode(EditMode.Update);
        }

        private void btnLuu_Click(object sender, EventArgs e)
        {
            // Validate
            if (cboLoaiChiTiet.SelectedItem == null)
            {
                MessageBox.Show("Chọn Loại giao dịch (THU/CHI).");
                return;
            }
            if (!decimal.TryParse(txtSoTien.Text.Trim(), out var soTien) || soTien <= 0)
            {
                MessageBox.Show("Số tiền phải > 0.");
                txtSoTien.Focus();
                return;
            }
            if (cboMaLoai.SelectedValue == null || cboMaLoai.SelectedValue is DBNull)
            {
                MessageBox.Show("Chọn Mã loại giao dịch.");
                return;
            }
            if (cboTKNH2.SelectedValue == null || cboTKNH2.SelectedValue is DBNull)
            {
                MessageBox.Show("Chọn Tài khoản NH.");
                return;
            }

            var loai = cboLoaiChiTiet.SelectedItem.ToString();
            var moTa = txtMoTa.Text?.Trim();
            var maLoai = cboMaLoai.SelectedValue.ToString();
            var maTknh = Convert.ToInt32(cboTKNH2.SelectedValue);
            int? maDuAn = (cboDuAn2.SelectedIndex == 0) ? (int?)null : (int)cboDuAn2.SelectedValue;

            if (string.Equals(loai, "CHI", StringComparison.OrdinalIgnoreCase))
            {
                try
                {
                    var soDu = _calcSvc.KiemTraSoDu(maTknh);    // gọi FN_KiemTraSoDu
                    if (soTien > soDu)
                    {
                        MessageBox.Show(
                            $"Số dư tài khoản không đủ.\nSố dư hiện tại: {soDu:N0} VNĐ\nSố tiền chi: {soTien:N0} VNĐ",
                            "Không đủ số dư",
                            MessageBoxButtons.OK, MessageBoxIcon.Warning);
                        return; // chặn lưu
                    }
                }
                catch (Exception ex)
                {
                    MessageBox.Show("Không kiểm tra được số dư: " + ex.Message,
                                    "Lỗi", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }
            }

            try
            {
                if (_mode == EditMode.Create)
                {
                    _gdSvc.ThemGiaoDich(loai, soTien, moTa, maLoai, maTknh, _session.MaNhanVien, maDuAn);
                    MessageBox.Show("Thêm giao dịch thành công.");
                }
                else if (_mode == EditMode.Update)
                {
                    _gdSvc.SuaGiaoDich(_maGdDangSua, soTien, moTa, maLoai, maTknh, maDuAn, _session.MaNhanVien);
                    MessageBox.Show("Cập nhật giao dịch thành công.");
                }

                SetEditMode(EditMode.None);
                ClearDetail();
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
            ClearDetail();
        }

        private void cboLoaiChiTiet_SelectedIndexChanged(object sender, EventArgs e)
        {
            ReloadMaLoaiTheoLoaiChiTiet();
        }

        private void dgvGiaoDichCuaToi_SelectionChanged(object sender, EventArgs e)
        {
            if (dgvGiaoDichCuaToi.CurrentRow == null) return;
            var row = (dgvGiaoDichCuaToi.CurrentRow.DataBoundItem as DataRowView)?.Row;
            if (row == null) return;

            // Hiển thị để xem (readonly) khi không ở chế độ Edit
            if (_mode == EditMode.None)
            {
                MapRowToDetail(row); // điền giá trị vào các control
            }
        }

        private void MapRowToDetail(DataRow row)
        {
            // Loại GD
            if (row.Table.Columns.Contains("loai_gd"))
            {
                var loai = row["loai_gd"]?.ToString();
                if (!string.IsNullOrEmpty(loai))
                {
                    if (cboLoaiChiTiet.Items.Cast<object>().Any(x => string.Equals(x.ToString(), loai, StringComparison.OrdinalIgnoreCase)))
                        cboLoaiChiTiet.SelectedItem = loai;
                }
            }

            // Số tiền
            if (row.Table.Columns.Contains("so_tien"))
                txtSoTien.Text = Convert.ToDecimal(row["so_tien"]).ToString("0.##");

            // Mã loại (chọn theo tên loại hiển thị)
            SelectIfMatches(cboMaLoai, "ten_loai", row, "ten_loai");

            // TK ngân hàng
            SelectIfMatches(cboTKNH2, "ten_tk", row, "tai_khoan");

            // Dự án (có thể null)
            SelectIfMatches(cboDuAn2, "ten_du_an", row, "ten_du_an");

            // Mô tả
            if (row.Table.Columns.Contains("mo_ta"))
                txtMoTa.Text = row["mo_ta"]?.ToString() ?? "";
        }

        private void ApplyVietHeaders()
        {
            void H(string name, string header)
            {
                if (dgvGiaoDichCuaToi.Columns.Contains(name))
                    dgvGiaoDichCuaToi.Columns[name].HeaderText = header;
            }

            H("ma_gd", "Mã GD");
            H("loai_gd", "Loại");
            H("so_tien", "Số tiền");
            H("ngay_gd", "Ngày tạo");
            H("trang_thai", "Trạng thái");
            H("ten_loai", "Loại giao dịch");
            H("tai_khoan", "Tài khoản NH");
            H("nguoi_duyet", "Người duyệt");
            H("ngay_duyet", "Ngày duyệt");
            H("ten_du_an", "Dự án");
        }

        private void txtSoTien_KeyPress(object sender, KeyPressEventArgs e)
        {
            if (!char.IsControl(e.KeyChar) && !char.IsDigit(e.KeyChar))
                e.Handled = true;
        }
    }
}
