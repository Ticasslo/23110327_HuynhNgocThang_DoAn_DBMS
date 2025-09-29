using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models.Login
{
    public sealed class LoginResult
    {
        public bool Success { get; set; }
        public string Message { get; set; } = "";
        public int MaNhanVien { get; set; }
        public UserRole Role { get; set; } = UserRole.Unknown;
        public string Username { get; set; } = "";
    }
}
