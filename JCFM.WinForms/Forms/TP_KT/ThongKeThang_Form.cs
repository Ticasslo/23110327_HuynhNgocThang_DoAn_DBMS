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
    public partial class ThongKeThang_Form : Form
    {
        private readonly AppSession _session;
        private readonly IThongKeService _tkSvc = new ThongKeService();
        private readonly ITinhToanService _calcSvc = new TinhToanService();


        public ThongKeThang_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void ThongKeThang_Form_Load(object sender, EventArgs e)
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
            // Năm: đổ vài năm gần đây + (Tất cả)
            cboNam.Items.Clear();
            cboNam.Items.Add("(Tất cả)");
            int yearNow = DateTime.Now.Year;
            for (int y = yearNow; y >= yearNow - 6; y--) cboNam.Items.Add(y.ToString());
            cboNam.SelectedIndex = 0;

            // Tháng: 1..12 + (Tất cả)
            cboThang.Items.Clear();
            cboThang.Items.Add("(Tất cả)");
            for (int m = 1; m <= 12; m++) cboThang.Items.Add(m.ToString());
            cboThang.SelectedIndex = 0;
        }

        private void LoadGrid()
        {
            int? nam = (cboNam.SelectedIndex <= 0) ? (int?)null : int.Parse(cboNam.SelectedItem.ToString());
            int? thang = (cboThang.SelectedIndex <= 0) ? (int?)null : int.Parse(cboThang.SelectedItem.ToString());

            var dt = _tkSvc.GetThongKeThang(nam, thang);

            dgvTK.AutoGenerateColumns = true;
            dgvTK.DataSource = dt;

            BindChartThongKe(dt);
            ApplyVietHeadersAndFormat();
        }

        private void BindChartThongKe(DataTable dt)
        {
            chartThongKe.Series.Clear();
            chartThongKe.ChartAreas.Clear();
            chartThongKe.Legends.Clear();

            var area = new ChartArea("Main");
            area.AxisX.Interval = 1;                    // hiển thị đầy đủ nhãn
            area.AxisX.MajorGrid.Enabled = false;
            area.AxisY.MajorGrid.LineDashStyle = ChartDashStyle.Dash;
            chartThongKe.ChartAreas.Add(area);

            chartThongKe.Legends.Add(new Legend("Legend"));

            // Chuẩn hoá trục X theo "Nam-Thang"
            var seriesThu = new Series("Tổng thu") { ChartType = SeriesChartType.Column, ChartArea = "Main", Legend = "Legend" };
            var seriesChi = new Series("Tổng chi") { ChartType = SeriesChartType.Column, ChartArea = "Main", Legend = "Legend" };
            var seriesLaiLo = new Series("Lãi/Lỗ") { ChartType = SeriesChartType.Line, ChartArea = "Main", Legend = "Legend", BorderWidth = 3 };

            foreach (DataRow r in dt.Rows)
            {
                var x = $"{r["Nam"]}-{r["Thang"]}";
                var thu = Convert.ToDecimal(r["TongThu"]);
                var chi = Convert.ToDecimal(r["TongChi"]);
                var lllo = Convert.ToDecimal(r["LaiLo"]);

                seriesThu.Points.AddXY(x, thu);
                seriesChi.Points.AddXY(x, chi);
                seriesLaiLo.Points.AddXY(x, lllo);
            }

            // format số VN (không thập phân)
            seriesThu.LabelFormat = "N0";
            seriesChi.LabelFormat = "N0";
            seriesLaiLo.LabelFormat = "N0";

            chartThongKe.Series.Add(seriesThu);
            chartThongKe.Series.Add(seriesChi);
            chartThongKe.Series.Add(seriesLaiLo);
        }


        private void ApplyVietHeadersAndFormat()
        {
            void H(string name, string header)
            {
                if (dgvTK.Columns.Contains(name))
                    dgvTK.Columns[name].HeaderText = header;
            }

            H("Nam", "Năm");
            H("Thang", "Tháng");
            H("TongThu", "Tổng thu");
            H("TongChi", "Tổng chi");
            H("LaiLo", "Lãi/Lỗ");

            foreach (var colName in new[] { "TongThu", "TongChi", "LaiLo" })
            {
                if (!dgvTK.Columns.Contains(colName)) continue;
                var col = dgvTK.Columns[colName];
                col.DefaultCellStyle.Format = "N0"; // VNĐ: không thập phân
                col.DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleRight;
            }

            if (dgvTK.Columns.Contains("Thang"))
                dgvTK.Columns["Thang"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;
        }

        private void CalcSummary()
        {
            // Khoảng ngày theo filter
            GetRangeFromFilter(out var tu, out var den);

            // Không lọc dự án ở form này → NULL
            int? maDuAn = null;

            // Gọi FN_TinhTongThuChi (bảng 2 dòng: THU/CHI)
            var tong = _calcSvc.TinhTongThuChi(tu, den, maDuAn);

            decimal tongThu = 0, tongChi = 0;
            if (tong != null)
            {
                foreach (DataRow r in tong.Rows)
                {
                    var loai = r["loai_gd"]?.ToString();
                    var tien = r["tong_tien"] == DBNull.Value ? 0m : Convert.ToDecimal(r["tong_tien"]);
                    if (string.Equals(loai, "THU", StringComparison.OrdinalIgnoreCase)) tongThu = tien;
                    else if (string.Equals(loai, "CHI", StringComparison.OrdinalIgnoreCase)) tongChi = tien;
                }
            }

            // Gọi FN_TinhLaiLo (một giá trị)
            var laiLo = _calcSvc.TinhLaiLo(tu, den, maDuAn);

            // Hiển thị: VNĐ không thập phân
            txtTongThu.Text = tongThu.ToString("N0");
            txtTongChi.Text = tongChi.ToString("N0");
            txtLaiLo.Text = laiLo.ToString("N0");
        }


        private void GetRangeFromFilter(out DateTime tu, out DateTime den)
        {
            int? nam = (cboNam.SelectedIndex <= 0) ? (int?)null : int.Parse(cboNam.SelectedItem.ToString());
            int? thang = (cboThang.SelectedIndex <= 0) ? (int?)null : int.Parse(cboThang.SelectedItem.ToString());

            if (nam.HasValue && thang.HasValue)
            {
                tu = new DateTime(nam.Value, thang.Value, 1);
                den = new DateTime(nam.Value, thang.Value, DateTime.DaysInMonth(nam.Value, thang.Value));
                return;
            }
            if (nam.HasValue)
            {
                tu = new DateTime(nam.Value, 1, 1);
                den = new DateTime(nam.Value, 12, 31);
                return;
            }

            // fallback: dùng tháng hiện tại
            var now = DateTime.Now;
            tu = new DateTime(now.Year, now.Month, 1);
            den = new DateTime(now.Year, now.Month, DateTime.DaysInMonth(now.Year, now.Month));
        }

        // Events
        private void btnTim_Click(object sender, EventArgs e)
        {
            LoadGrid();
            CalcSummary();
        }

        private void btnTai_Click(object sender, EventArgs e)
        {
            cboNam.SelectedIndex = 0;
            cboThang.SelectedIndex = 0;
            LoadGrid();
            CalcSummary();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }

        private void dgvTK_DataBindingComplete(object sender, DataGridViewBindingCompleteEventArgs e)
        {
            CalcSummary(); // nếu nguồn dữ liệu đổi
        }
    }
}
