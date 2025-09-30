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
using System.Windows.Forms.DataVisualization.Charting;

namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms
{
    public partial class BaoCaoChiTiet_Form : Form
    {
        private readonly AppSession _session;
        private readonly IThongKeService _tkSvc = new ThongKeService();
        private readonly IDuAnService _daSvc = new DuAnService();
        private readonly ITinhToanService _calcSvc = new TinhToanService();   // dùng FN

        public BaoCaoChiTiet_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void BaoCaoChiTiet_Form_Load(object sender, EventArgs e)
        {
            // Chặn NV tài chính
            if (_session.Role == UserRole.NhanVienTC)
            {
                MessageBox.Show("Chỉ Trưởng phòng/Kế toán được truy cập màn hình này.");
                Close();
                return;
            }

            InitFilters();
            LoadGrid();
            CalcSummary();
        }

        private void InitFilters()
        {
            // Dự án
            var da = _daSvc.GetDuAn(null, null, null, null);   // ma_du_an, ten_du_an, ...
            BindCombo(cboDuAn, da, "ten_du_an", "ma_du_an", addAll: true);

            var now = DateTime.Now;
            dtpTu.Value = new DateTime(now.Year, now.Month, 1);
            dtpDen.Value = dtpTu.Value.AddMonths(1).AddDays(-1);
        }

        private static void BindCombo(ComboBox cbo, DataTable dt, string display, string value, bool addAll)
        {
            var clone = dt?.Copy() ?? new DataTable();
            if (!clone.Columns.Contains(display)) clone.Columns.Add(display, typeof(string));
            if (!clone.Columns.Contains(value)) clone.Columns.Add(value, typeof(object));

            if (addAll)
            {
                var r = clone.NewRow();
                r[display] = "(Tất cả)";
                r[value] = DBNull.Value;
                clone.Rows.InsertAt(r, 0);
            }
            cbo.DisplayMember = display;
            cbo.ValueMember = value;
            cbo.DataSource = clone;
            cbo.SelectedIndex = 0;
        }

        private void LoadGrid()
        {
            DateTime ngayBd = dtpTu.Value.Date;
            DateTime ngayKt = dtpDen.Value.Date;

            if (ngayBd > ngayKt)
            {
                MessageBox.Show("Từ ngày không được lớn hơn đến ngày.");
                return;
            }

            int? maDuAn = (cboDuAn.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboDuAn.SelectedValue);

            var dt = _tkSvc.XuatBaoCaoChiTiet(ngayBd, ngayKt, maDuAn);

            dgvBaoCao.AutoGenerateColumns = true;
            dgvBaoCao.DataSource = dt;

            ApplyVietHeadersAndFormat();
        }

        private void ApplyVietHeadersAndFormat()
        {
            void H(string name, string header)
            {
                if (dgvBaoCao.Columns.Contains(name))
                    dgvBaoCao.Columns[name].HeaderText = header;
            }

            H("ma_gd", "Mã GD");
            H("loai_gd", "Loại");
            H("so_tien", "Số tiền");
            H("ngay_gd", "Ngày tạo");
            H("mo_ta", "Mô tả");
            H("trang_thai", "Trạng thái");
            H("ten_loai", "Loại giao dịch");
            H("tai_khoan", "Tài khoản NH");
            H("nguoi_tao", "Người tạo");
            H("nguoi_duyet", "Người duyệt");
            H("ngay_duyet", "Ngày duyệt");
            H("ten_du_an", "Dự án");

            if (dgvBaoCao.Columns.Contains("so_tien"))
            {
                var col = dgvBaoCao.Columns["so_tien"];
                col.DefaultCellStyle.Format = "N0";
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }

            if (dgvBaoCao.Columns.Contains("loai_gd"))
                dgvBaoCao.Columns["loai_gd"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
            if (dgvBaoCao.Columns.Contains("trang_thai"))
                dgvBaoCao.Columns["trang_thai"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void CalcSummary()
        {
            var tu = dtpTu.Value.Date;
            var den = dtpDen.Value.Date;
            int? maDuAn = (cboDuAn.SelectedIndex <= 0) ? (int?)null : Convert.ToInt32(cboDuAn.SelectedValue);

            var tong = _calcSvc.TinhTongThuChi(tu, den, maDuAn);
            decimal thu = 0, chi = 0;
            foreach (DataRow r in tong.Rows)
            {
                var loai = r["loai_gd"]?.ToString();
                var tien = r["tong_tien"] == DBNull.Value ? 0m : Convert.ToDecimal(r["tong_tien"]);
                if (string.Equals(loai, "THU", StringComparison.OrdinalIgnoreCase)) thu = tien;
                else if (string.Equals(loai, "CHI", StringComparison.OrdinalIgnoreCase)) chi = tien;
            }
            var lllo = _calcSvc.TinhLaiLo(tu, den, maDuAn);

            txtTongThu.Text = thu.ToString("N0");
            txtTongChi.Text = chi.ToString("N0");
            txtLaiLo.Text = lllo.ToString("N0");

            BindChartThuChi((long)thu, (long)chi);
        }

        private void btnTim_Click(object sender, EventArgs e)
        {
            LoadGrid();
            CalcSummary();
        }

        private void btnTai_Click(object sender, EventArgs e)
        {
            if (cboDuAn.Items.Count > 0) cboDuAn.SelectedIndex = 0;

            var now = DateTime.Now;
            dtpTu.Value = new DateTime(now.Year, now.Month, 1);
            dtpDen.Value = dtpTu.Value.AddMonths(1).AddDays(-1);

            LoadGrid();
            CalcSummary();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }

        private void dgvBaoCao_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            CalcSummary();
        }

        private void BindChartThuChi(long tongThu, long tongChi)
        {
            chartThuChi.Series.Clear();
            chartThuChi.ChartAreas.Clear();
            chartThuChi.Legends.Clear();

            var area = new ChartArea("Main");
            chartThuChi.ChartAreas.Add(area);
            chartThuChi.Legends.Add(new Legend("Legend"));

            var s = new Series("ThuChi")
            {
                ChartType = SeriesChartType.Doughnut,
                ChartArea = "Main",
                Legend = "Legend",
                IsValueShownAsLabel = true,
                LabelFormat = "N0"                      // VN: không thập phân
            };

            s.Points.AddXY("Thu", tongThu);
            s.Points.AddXY("Chi", tongChi);

            chartThuChi.Series.Add(s);
        }

    }
}
