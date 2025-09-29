namespace _23110327_HuynhNgocThang_Nhom16_CodeQuanLyThuChiTaiChinh.Forms.NhanVienTC
{
    partial class TrangChuNhanVienTC_Form
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
            this.btnGiaoDichCuaToi = new System.Windows.Forms.Button();
            this.btnXemTaiKhoanNH = new System.Windows.Forms.Button();
            this.btnXemDuAn = new System.Windows.Forms.Button();
            this.btnLoaiGiaoDich = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblWelcome
            // 
            this.lblWelcome.AutoSize = true;
            this.lblWelcome.Location = new System.Drawing.Point(25, 24);
            this.lblWelcome.Name = "lblWelcome";
            this.lblWelcome.Size = new System.Drawing.Size(44, 16);
            this.lblWelcome.TabIndex = 1;
            this.lblWelcome.Text = "label1";
            // 
            // btnBack
            // 
            this.btnBack.FlatAppearance.BorderSize = 0;
            this.btnBack.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.btnBack.Font = new System.Drawing.Font("Arial", 13.8F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.btnBack.Location = new System.Drawing.Point(628, 82);
            this.btnBack.Name = "btnBack";
            this.btnBack.Size = new System.Drawing.Size(36, 37);
            this.btnBack.TabIndex = 93;
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
            this.btnClose.Location = new System.Drawing.Point(730, 34);
            this.btnClose.Name = "btnClose";
            this.btnClose.Size = new System.Drawing.Size(36, 37);
            this.btnClose.TabIndex = 94;
            this.btnClose.Text = "X";
            this.btnClose.TextAlign = System.Drawing.ContentAlignment.TopLeft;
            this.btnClose.UseVisualStyleBackColor = true;
            this.btnClose.Click += new System.EventHandler(this.btnClose_Click);
            // 
            // btnGiaoDichCuaToi
            // 
            this.btnGiaoDichCuaToi.Location = new System.Drawing.Point(84, 82);
            this.btnGiaoDichCuaToi.Name = "btnGiaoDichCuaToi";
            this.btnGiaoDichCuaToi.Size = new System.Drawing.Size(132, 59);
            this.btnGiaoDichCuaToi.TabIndex = 95;
            this.btnGiaoDichCuaToi.Text = "Giao dịch của tôi";
            this.btnGiaoDichCuaToi.UseVisualStyleBackColor = true;
            this.btnGiaoDichCuaToi.Click += new System.EventHandler(this.btnGiaoDichCuaToi_Click);
            // 
            // btnXemTaiKhoanNH
            // 
            this.btnXemTaiKhoanNH.Location = new System.Drawing.Point(84, 165);
            this.btnXemTaiKhoanNH.Name = "btnXemTaiKhoanNH";
            this.btnXemTaiKhoanNH.Size = new System.Drawing.Size(132, 59);
            this.btnXemTaiKhoanNH.TabIndex = 96;
            this.btnXemTaiKhoanNH.Text = "Xem tài khoản ngân hàng";
            this.btnXemTaiKhoanNH.UseVisualStyleBackColor = true;
            this.btnXemTaiKhoanNH.Click += new System.EventHandler(this.btnXemTaiKhoanNH_Click);
            // 
            // btnXemDuAn
            // 
            this.btnXemDuAn.Location = new System.Drawing.Point(84, 230);
            this.btnXemDuAn.Name = "btnXemDuAn";
            this.btnXemDuAn.Size = new System.Drawing.Size(132, 59);
            this.btnXemDuAn.TabIndex = 97;
            this.btnXemDuAn.Text = "Xem dự án";
            this.btnXemDuAn.UseVisualStyleBackColor = true;
            this.btnXemDuAn.Click += new System.EventHandler(this.btnXemDuAn_Click);
            // 
            // btnLoaiGiaoDich
            // 
            this.btnLoaiGiaoDich.Location = new System.Drawing.Point(84, 313);
            this.btnLoaiGiaoDich.Name = "btnLoaiGiaoDich";
            this.btnLoaiGiaoDich.Size = new System.Drawing.Size(132, 59);
            this.btnLoaiGiaoDich.TabIndex = 98;
            this.btnLoaiGiaoDich.Text = "Các loại giao dịch";
            this.btnLoaiGiaoDich.UseVisualStyleBackColor = true;
            this.btnLoaiGiaoDich.Click += new System.EventHandler(this.btnLoaiGiaoDich_Click_1);
            // 
            // TrangChuNhanVienTC_Form
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnLoaiGiaoDich);
            this.Controls.Add(this.btnXemDuAn);
            this.Controls.Add(this.btnXemTaiKhoanNH);
            this.Controls.Add(this.btnGiaoDichCuaToi);
            this.Controls.Add(this.btnClose);
            this.Controls.Add(this.btnBack);
            this.Controls.Add(this.lblWelcome);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "TrangChuNhanVienTC_Form";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "TrangChuNhanVienTC_Form";
            this.Load += new System.EventHandler(this.TrangChuNhanVienTC_Form_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblWelcome;
        private System.Windows.Forms.Button btnBack;
        private System.Windows.Forms.Button btnClose;
        private System.Windows.Forms.Button btnGiaoDichCuaToi;
        private System.Windows.Forms.Button btnXemTaiKhoanNH;
        private System.Windows.Forms.Button btnXemDuAn;
        private System.Windows.Forms.Button btnLoaiGiaoDich;
    }
}