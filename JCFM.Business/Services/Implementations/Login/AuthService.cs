using JCFM.Business.Services.Interfaces.Login;
using JCFM.DataAccess.Repositories;
using JCFM.Models.Login;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JCFM.DataAccess.DBConnection;

namespace JCFM.Business.Services.Implementations.Login
{
    public class AuthService : IAuthService
    {
        private readonly AuthRepository _repo = new AuthRepository();

        public async Task<LoginResult> LoginAsync(string username, string password)
        {
            // cấu hình chuỗi kết nối theo “SQL Login” người dùng nhập
            DatabaseConnection.Configure(username, password);

            // test connect trước
            if (!DatabaseConnection.TestConnection(out var err))
            {
                return new LoginResult { Success = false, Message = "Kết nối thất bại: " + err };
            }

            var (roleStr, maNv) = await _repo.GetRoleAsync(username, password);
            if (string.IsNullOrEmpty(roleStr))
                return new LoginResult { Success = false, Message = "Sai tài khoản hoặc không có quyền truy cập." };

            var role = UserRole.Unknown;
            if (roleStr == "TRUONG_PHONG_TC") role = UserRole.TruongPhongTC;
            else if (roleStr == "NHAN_VIEN_TC") role = UserRole.NhanVienTC;
            else if (roleStr == "KE_TOAN") role = UserRole.KeToan;

            if (role == UserRole.Unknown)
                return new LoginResult { Success = false, Message = "Tài khoản chưa được gán vai trò." };

            return new LoginResult
            {
                Success = true,
                Message = "Đăng nhập thành công.",
                MaNhanVien = maNv,
                Role = role,
                Username = username
            };
        }
    }
}
