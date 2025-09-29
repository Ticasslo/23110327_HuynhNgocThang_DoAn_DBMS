using JCFM.Models.Login;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.Business.Services.Interfaces.Login
{
    public interface IAuthService
    {
        Task<LoginResult> LoginAsync(string username, string password);
    }
}
