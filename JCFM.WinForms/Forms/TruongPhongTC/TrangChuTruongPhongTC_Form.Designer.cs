namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.TruongPhongTC
{
    partial class TrangChuTruongPhongTC_Form
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lblWelcome = new System.Windows.Forms.Label();
            this.btnBack = new System.Windows.Forms.Button();
            this.btnClose = new System.Windows.Forms.Button();
            this.btnQLTaiKhoanNH = new System.Windows.Forms.Button();
            this.btnQLDuAn = new System.Windows.Forms.Button();
            this.btnGiaoDichChoDuyet = new System.Windows.Forms.Button();
            this.btnLichSuGiaoDich = new System.Windows.Forms.Button();
            this.btnThongKeThang = new System.Windows.Forms.Button();
            this.btnBaoCaoChiTiet = new System.Windows.Forms.Button();
            this.btnLoaiGiaoDich = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblWelcome
            // 
            this.lblWelcome.AutoSize = true;
            this.lblWelcome.Location = new System.Drawing.Point(151, 25);
            this.lblWelcome.Name = "lblWelcome";
            this.lblWelcome.Size = new System.Drawing.Size(44, 16);
            this.lblWelcome.TabIndex = 0;
            this.lblWelcome.Text = "label1";
            // 
            // btnBack
            // 
            this.btnBack.FlatAppearance.BorderSize = 0;
            this.btnBack.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnBack.Font = new System.Drawing.Font("Arial", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnBack.Location = new System.Drawing.Point(657, 50);
            this.btnBack.Name = "btnBack";
            this.btnBack.Size = new System.Drawing.Size(36, 37);
            this.btnBack.TabIndex = 92;
            this.btnBack.Text = "↩️";
            this.btnBack.TextAlign = System.Drawing.ContentAlignment.TopLeft;
            this.btnBack.UseVisualStyleBackColor = true;
            this.btnBack.Click += new System.EventHandler(this.btnBack_Click);
            // 
            // btnClose
            // 
            this.btnClose.FlatAppearance.BorderSize = 0;
            this.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnClose.Font = new System.Drawing.Font("Arial", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnClose.Location = new System.Drawing.Point(737, 40);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(36, 37);
            this.btnClose.TabIndex = 93;
            this.btnClose.Text = "X";
            this.btnClose.TextAlign = System.Drawing.ContentAlignment.TopLeft;
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnQLTaiKhoanNH
            // 
            this.btnQLTaiKhoanNH.Location = new System.Drawing.Point(240, 102);
            this.btnQLTaiKhoanNH.Name = "btnQLTaiKhoanNH";
            this.btnQLTaiKhoanNH.Size = new System.Drawing.Size(121, 68);
            this.btnQLTaiKhoanNH.TabIndex = 94;
            this.btnQLTaiKhoanNH.Text = "Quản lý tài khoản ngân hàng";
            this.btnQLTaiKhoanNH.UseVisualStyleBackColor = true;
            this.btnQLTaiKhoanNH.Click += new System.EventHandler(this.btnQLTaiKhoanNH_Click);
            // 
            // btnQLDuAn
            // 
            this.btnQLDuAn.Location = new System.Drawing.Point(195, 191);
            this.btnQLDuAn.Name = "btnQLDuAn";
            this.btnQLDuAn.Size = new System.Drawing.Size(121, 68);
            this.btnQLDuAn.TabIndex = 95;
            this.btnQLDuAn.Text = "Quản lý dự án";
            this.btnQLDuAn.UseVisualStyleBackColor = true;
            this.btnQLDuAn.Click += new System.EventHandler(this.btnQLDuAn_Click);
            // 
            // btnGiaoDichChoDuyet
            // 
            this.btnGiaoDichChoDuyet.Location = new System.Drawing.Point(340, 191);
            this.btnGiaoDichChoDuyet.Name = "btnGiaoDichChoDuyet";
            this.btnGiaoDichChoDuyet.Size = new System.Drawing.Size(121, 68);
            this.btnGiaoDichChoDuyet.TabIndex = 96;
            this.btnGiaoDichChoDuyet.Text = "Giao dịch chờ duyệt";
            this.btnGiaoDichChoDuyet.UseVisualStyleBackColor = true;
            this.btnGiaoDichChoDuyet.Click += new System.EventHandler(this.btnGiaoDichChoDuyet_Click);
            // 
            // btnLichSuGiaoDich
            // 
            this.btnLichSuGiaoDich.Location = new System.Drawing.Point(482, 176);
            this.btnLichSuGiaoDich.Name = "btnLichSuGiaoDich";
            this.btnLichSuGiaoDich.Size = new System.Drawing.Size(121, 68);
            this.btnLichSuGiaoDich.TabIndex = 97;
            this.btnLichSuGiaoDich.Text = "Lịch sử giao dịch";
            this.btnLichSuGiaoDich.UseVisualStyleBackColor = true;
            this.btnLichSuGiaoDich.Click += new System.EventHandler(this.btnLichSuGiaoDich_Click);
            // 
            // btnThongKeThang
            // 
            this.btnThongKeThang.Location = new System.Drawing.Point(195, 297);
            this.btnThongKeThang.Name = "btnThongKeThang";
            this.btnThongKeThang.Size = new System.Drawing.Size(121, 68);
            this.btnThongKeThang.TabIndex = 98;
            this.btnThongKeThang.Text = "Thống kê tháng";
            this.btnThongKeThang.UseVisualStyleBackColor = true;
            this.btnThongKeThang.Click += new System.EventHandler(this.btnThongKeThang_Click);
            // 
            // btnBaoCaoChiTiet
            // 
            this.btnBaoCaoChiTiet.Location = new System.Drawing.Point(340, 297);
            this.btnBaoCaoChiTiet.Name = "btnBaoCaoChiTiet";
            this.btnBaoCaoChiTiet.Size = new System.Drawing.Size(121, 68);
            this.btnBaoCaoChiTiet.TabIndex = 99;
            this.btnBaoCaoChiTiet.Text = "Báo cáo chi tiết";
            this.btnBaoCaoChiTiet.UseVisualStyleBackColor = true;
            this.btnBaoCaoChiTiet.Click += new System.EventHandler(this.btnBaoCaoChiTiet_Click);
            // 
            // btnLoaiGiaoDich
            // 
            this.btnLoaiGiaoDich.Location = new System.Drawing.Point(482, 297);
            this.btnLoaiGiaoDich.Name = "btnLoaiGiaoDich";
            this.btnLoaiGiaoDich.Size = new System.Drawing.Size(121, 68);
            this.btnLoaiGiaoDich.TabIndex = 100;
            this.btnLoaiGiaoDich.Text = "Các loại giao dịch";
            this.btnLoaiGiaoDich.UseVisualStyleBackColor = true;
            this.btnLoaiGiaoDich.Click += new System.EventHandler(this.btnLoaiGiaoDich_Click);
            // 
            // TrangChuTruongPhongTC_Form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnLoaiGiaoDich);
            this.Controls.Add(this.btnBaoCaoChiTiet);
            this.Controls.Add(this.btnThongKeThang);
            this.Controls.Add(this.btnLichSuGiaoDich);
            this.Controls.Add(this.btnGiaoDichChoDuyet);
            this.Controls.Add(this.btnQLDuAn);
            this.Controls.Add(this.btnQLTaiKhoanNH);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.btnBack);
            this.Controls.Add(this.lblWelcome);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "TrangChuTruongPhongTC_Form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "TrangChuTruongPhongTC_Form";
            this.Load += new System.EventHandler(this.TrangChuTruongPhongTC_Form_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblWelcome;
        private System.Windows.Forms.Button btnBack;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.Button btnQLTaiKhoanNH;
        private System.Windows.Forms.Button btnQLDuAn;
        private System.Windows.Forms.Button btnGiaoDichChoDuyet;
        private System.Windows.Forms.Button btnLichSuGiaoDich;
        private System.Windows.Forms.Button btnThongKeThang;
        private System.Windows.Forms.Button btnBaoCaoChiTiet;
        private System.Windows.Forms.Button btnLoaiGiaoDich;
    }
}