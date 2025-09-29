using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.DataAccess.DBConnection
{
    public static class DatabaseConnection
    {
        private const string Server = @"WIN";
        private const string Database = "JobCenterFinancialManagement";
        private static string connectionString;

        public static void Configure(string user, string password)
        {
            var stringbuilder = new SqlConnectionStringBuilder
            {
                DataSource = Server,
                InitialCatalog = Database,
                UserID = user?.Trim(),
                Password = password?.Trim(),
                MultipleActiveResultSets = true,
                Encrypt = false,
                TrustServerCertificate = true
            };
            connectionString = stringbuilder.ConnectionString;
        }

        public static SqlConnection CreateConnection()
        {
            if (string.IsNullOrWhiteSpace(connectionString))
                throw new InvalidOperationException("Chưa gọi Db.Configure(user, pass).");
            return new SqlConnection(connectionString);
        }

        public static bool TestConnection(out string error)
        {
            try
            {
                using (var conn = CreateConnection())
                {
                    conn.Open();
                    error = null;
                    return true;
                }
            }
            catch (Exception ex)
            {
                error = ex.Message;
                return false;
            }
        }
    }
}
