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
    public partial class LoaiGiaoDich_Form : Form
    {
        private readonly AppSession _session;
        private readonly ILoaiGiaoDichService _lgdSvc = new LoaiGiaoDichService();

        public LoaiGiaoDich_Form(AppSession session)
        {
            InitializeComponent();
            _session = session ?? throw new ArgumentNullException(nameof(session));
        }

        private void LoaiGiaoDich_Form_Load(object sender, EventArgs e)
        {
            InitFilters();
            LoadGrid();
            BindSelectionToDetail(null);
            ApplyReadonlyDetail();
        }

        private void InitFilters()
        {
            cboLoai.Items.Clear();
            cboLoai.Items.Add("(Tất cả)");
            cboLoai.Items.Add("THU");
            cboLoai.Items.Add("CHI");
            cboLoai.SelectedIndex = 0;
        }

        private void ApplyReadonlyDetail()
        {
            txtMa.ReadOnly = true;
            txtTen.ReadOnly = true;
            txtLoai.ReadOnly = true;
            txtMoTa.ReadOnly = true;
        }

        private void LoadGrid()
        {
            string loai = cboLoai.SelectedIndex <= 0 ? null : cboLoai.SelectedItem.ToString();
            var dt = _lgdSvc.GetLoaiGiaoDich(loai);

            dgvLoai.AutoGenerateColumns = true;
            dgvLoai.DataSource = dt;

            ApplyVietHeadersAndStyle();
        }

        private void ApplyVietHeadersAndStyle()
        {
            void H(string name, string header)
            {
                if (dgvLoai.Columns.Contains(name))
                    dgvLoai.Columns[name].HeaderText = header;
            }
            H("ma_loai", "Mã loại");
            H("ten_loai", "Tên loại");
            H("loai_thu_chi", "Loại THU/CHI");
            H("mo_ta", "Mô tả");

            if (dgvLoai.Columns.Contains("loai_thu_chi"))
                dgvLoai.Columns["loai_thu_chi"].DefaultCellStyle.Alignment = DataGridViewContentAlignment.MiddleCenter;

            dgvLoai.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
        }

        private void dgvLoai_SelectionChanged(object sender, EventArgs e)
        {
            var row = (dgvLoai.CurrentRow?.DataBoundItem as DataRowView)?.Row;
            BindSelectionToDetail(row);
        }

        private void BindSelectionToDetail(DataRow row)
        {
            txtMa.Text = txtTen.Text = txtLoai.Text = txtMoTa.Text = string.Empty;
            if (row == null) return;

            if (row.Table.Columns.Contains("ma_loai"))
                txtMa.Text = row["ma_loai"]?.ToString();

            if (row.Table.Columns.Contains("ten_loai"))
                txtTen.Text = row["ten_loai"]?.ToString();

            if (row.Table.Columns.Contains("loai_thu_chi"))
                txtLoai.Text = row["loai_thu_chi"]?.ToString();

            if (row.Table.Columns.Contains("mo_ta"))
                txtMoTa.Text = row["mo_ta"]?.ToString();
        }

        private void btnTim_Click(object sender, EventArgs e) => LoadGrid();

        private void btnTai_Click(object sender, EventArgs e)
        {
            cboLoai.SelectedIndex = 0;
            LoadGrid();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            this.Owner?.Show();
            this.Close();
        }
    }
}
