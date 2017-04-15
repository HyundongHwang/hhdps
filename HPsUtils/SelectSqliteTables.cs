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
    [Cmdlet(VerbsCommon.Select, "SqliteTables"), 
        Alias("hhdsqliteselect")]
    public class SelectSqliteTables : PSCmdlet
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



            this.WriteVerbose("ProcessRecord");
            var result = new List<PSObject>();
            var pwd = this.SessionState.Path.CurrentFileSystemLocation.Path;
            var realDbFile = Path.Combine(pwd, this.DbFilePath);

            using (var db = new SQLiteConnection($"Data Source={realDbFile}"))
            {
                db.Open();

                if (this.TableNames == null)
                {
                    var tableNameList = new List<string>();

                    var sql = $"SELECT * FROM sqlite_sequence";
                    var cmd = new SQLiteCommand(sql, db);
                    var reader = cmd.ExecuteReader();

                    while (reader.Read())
                    {
                        var tableName = reader["name"].ToString();
                        tableNameList.Add(tableName);
                    }

                    _SelectAllTables(result, tableNameList, db);
                }
                else
                {
                    _SelectAllTables(result, this.TableNames.ToList(), db);
                }

                db.Close();
            }

            this.WriteObject(result, true);
        }

        private void _SelectAllTables(List<PSObject> result, List<string> tableNameList, SQLiteConnection db)
        {
            foreach (var tableName in tableNameList)
            {
                this.WriteVerbose($"TABLE : {tableName}");
                var sql = $"SELECT * FROM {tableName}";
                var cmd = new SQLiteCommand(sql, db);
                var reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    var obj = new PSObject();
                    result.Add(obj);

                    for (int i = 0; i < reader.FieldCount; i++)
                    {
                        var name = reader.GetName(i);
                        var value = reader[i];
                        var type = reader.GetFieldType(i);

                        if (type == typeof(long) && name.ToLower().Contains("time"))
                        {
                            try
                            {
                                var tick = long.Parse(value.ToString());
                                var dt = new DateTime(tick);
                                var timeStr = dt.ToString("yyyy-MM-dd HH:mm:ss");
                                obj.Members.Add(new PSNoteProperty(name + "Str", timeStr));
                                continue;
                            }
                            catch (Exception ex)
                            {
                            }
                        }

                        obj.Members.Add(new PSNoteProperty(name, value));
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
