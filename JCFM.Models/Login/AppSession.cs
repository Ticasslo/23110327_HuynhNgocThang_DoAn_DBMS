using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Models.Login
{
    public sealed class AppSession
    {
        public string Username { get; set; } = "";
        public int MaNhanVien { get; set; }
        public UserRole Role { get; set; }
        public string ConnectionString { get; set; } = "";
    }
}
