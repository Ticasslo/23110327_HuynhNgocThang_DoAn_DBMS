using JCFM.DataAccess.Exceptions;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JCFM.DataAccess.DBConnection
{
    public static class DbHelper
    {
        public static SqlCommand StoredProc(string spName)
        {
            var cmd = new SqlCommand(spName) { CommandType = CommandType.StoredProcedure };
            return cmd;
        }

        public static SqlParameter Param(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }

        public static DataTable ExecuteDataTable(SqlCommand cmd)
        {
            try
            {
                using (var conn = DatabaseConnection.CreateConnection())
                using (var da = new SqlDataAdapter())
                {
                    cmd.Connection = conn;
                    var dt = new DataTable();
                    da.SelectCommand = cmd;
                    da.Fill(dt);
                    return dt;
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException($"Lỗi ExecuteDataTable cho {cmd.CommandText}", ex);
            }
        }

        public static object ExecuteScalar(SqlCommand cmd)
        {
            try
            {
                using (var conn = DatabaseConnection.CreateConnection())
                {
                    cmd.Connection = conn;
                    conn.Open();
                    return cmd.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException($"Lỗi ExecuteScalar cho {cmd.CommandText}", ex);
            }
        }

        public static int ExecuteNonQuery(SqlCommand cmd)
        {
            try
            {
                using (var conn = DatabaseConnection.CreateConnection())
                {
                    cmd.Connection = conn;
                    conn.Open();
                    return cmd.ExecuteNonQuery();
                }
            }
            catch (Exception ex)
            {
                throw new DataAccessException($"Lỗi ExecuteNonQuery cho {cmd.CommandText}", ex);
            }
        }
    }
}
