using System;
using System.Collections.Generic;
using System.Data.SQLite;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace HPsUtils
{
    [Cmdlet(VerbsCommon.Select, "SqliteTableSchemas"),
        Alias("hhdsqliteschema")]
    public class SelectSqliteTableSchemas : PSCmdlet
    {
        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string DbFilePath { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string[] TableNames { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = false,
            ValueFromPipelineByPropertyName = false)]
        [ValidateNotNullOrEmpty]
        public SwitchParameter ShowExamples { get; set; }

        protected override void BeginProcessing()
        {
            this.WriteVerbose("BeginProcessing");
        }

        protected override void ProcessRecord()
        {
            if (this.ShowExamples.IsPresent)
            {
                _ShowExmaples();
                return;
            }



            var resultList = new List<object>();
            this.WriteVerbose("ProcessRecord");

            var pwd = this.SessionState.Path.CurrentFileSystemLocation.Path;
            var realDbFile = Path.Combine(pwd, this.DbFilePath);

            using (var db = new SQLiteConnection($"Data Source={realDbFile}"))
            {
                db.Open();
                var tableNameList = new List<string>();
                this.WriteVerbose($"tableName : sqlite_sequence");
                var sql = $"SELECT * FROM sqlite_sequence";
                var cmd = new SQLiteCommand(sql, db);
                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    var name = reader["name"].ToString();
                    var seq = reader["seq"].ToString();
                    tableNameList.Add(name);
                }

                if (this.TableNames == null)
                {
                    _ShowTableSchemas(db, tableNameList, resultList);
                }
                else
                {
                    _ShowTableSchemas(db, this.TableNames.ToList(), resultList);
                }

                db.Close();
            }

            this.WriteObject(resultList);
        }

        private void _ShowTableSchemas(SQLiteConnection db, List<string> tableNameList, List<object> result)
        {
            foreach (var tableName in tableNameList)
            {
                this.WriteVerbose($"TABLE : {tableName}");
                result.Add($"");
                result.Add($"");
                result.Add($"TABLE : {tableName}");
                result.Add($"-----------------------");
                var sql = $"SELECT * FROM {tableName}";
                var cmd = new SQLiteCommand(sql, db);
                var reader = cmd.ExecuteReader();
                var canRead = reader.Read();

                if (canRead)
                {
                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        var name = reader.GetName(i);
                        var value = reader[i];
                        var type = reader.GetFieldType(i);

                        result.Add(new
                        {
                            name = name,
                            type = type.Name,
                        });
                    }
                }
            }
        }

        protected override void EndProcessing()
        {
            this.WriteVerbose("EndProcessing");
        }

        private void _ShowExmaples()
        {



            this.WriteObject(@"
            ", true);



            this.WriteObject(@"
            ", true);


        }
    }
}
