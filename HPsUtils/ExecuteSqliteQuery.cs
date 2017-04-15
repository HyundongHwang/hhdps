using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SQLite;
using System.IO;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace HPsUtils
{
    [Cmdlet(VerbsCommon.Set, "SqliteQuery"), 
        Alias("hhdsqlitequery")]
    public class ExecuteSqliteQuery : PSCmdlet
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
        public string Sql { get; set; }

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
            var resultList = new List<object>();
            var pwd = this.SessionState.Path.CurrentFileSystemLocation.Path;
            var realDbFile = Path.Combine(pwd, this.DbFilePath);

            using (var db = new SQLiteConnection($"Data Source={realDbFile}"))
            {
                db.Open();
                var cmd = new SQLiteCommand(this.Sql, db);
                var result = cmd.ExecuteNonQuery();
                resultList.Add(result);
                db.Close();
            }

            this.WriteObject(resultList, true);
        }

        protected override void EndProcessing()
        {
            this.WriteVerbose("EndProcessing");
        }

        private void _ShowExmaples()
        {
            this.WriteObject(@"
http://www.tutorialspoint.com/sqlite/
            ", true);



            this.WriteObject(@"
CREATE TABLE COMPANY(
   ID INT PRIMARY KEY     NOT NULL,
   NAME           TEXT    NOT NULL,
   AGE            INT     NOT NULL,
   ADDRESS        CHAR(50),
   SALARY         REAL
);
            ", true);



            this.WriteObject(@"
DROP TABLE COMPANY;
            ", true);



            this.WriteObject(@"
INSERT INTO COMPANY (ID,NAME,AGE,ADDRESS,SALARY)
VALUES (1, 'Paul', 32, 'California', 20000.00 );
            ", true);



            this.WriteObject(@"
UPDATE COMPANY SET ADDRESS = 'Texas' WHERE ID = 6;
            ", true);



            this.WriteObject(@"
UPDATE COMPANY SET ADDRESS = 'Texas', SALARY = 20000.00;
            ", true);



            this.WriteObject(@"
DELETE FROM COMPANY WHERE ID = 7;
            ", true);



            this.WriteObject(@"
DELETE FROM COMPANY;
            ", true);
        }
    }
}
