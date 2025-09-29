using JCFM.DataAccess.Exceptions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JCFM.DataAccess.DBConnection;

namespace JCFM.DataAccess.Repositories
{
    public class AuthRepository
    {
        // FN_Login_GetRole(@username, @password)
        public async Task<(string role, int maNv)> GetRoleAsync(string username, string password)
        {
            try
            {
                using (var conn = DatabaseConnection.CreateConnection())
                using (var cmd = new SqlCommand(
                    "SELECT vai_tro, ma_nv FROM dbo.FN_Login_GetRole(@u,@p)", conn))
                {
                    cmd.Parameters.AddWithValue("@u", username);
                    cmd.Parameters.AddWithValue("@p", password);

                    await conn.OpenAsync();
                    using (var rd = await cmd.ExecuteReaderAsync(CommandBehavior.SingleRow))
                    {
                        if (await rd.ReadAsync())
                            return (rd.GetString(0), rd.GetInt32(1));

                        return (null, 0);
                    }
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException("Lỗi truy vấn FN_Login_GetRole", ex);
            }
        }
    }
}
