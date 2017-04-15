using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace HPsUtils
{
    [Cmdlet(VerbsCommon.Set, "Unzip"), 
        Alias("hhdunzip")]
    public class SetUnzip : PSCmdlet
    {
        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        public string SrcZipFile { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty]
        public string TargetDir { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = false,
            ValueFromPipelineByPropertyName = false)]
        [ValidateNotNullOrEmpty]
        public SwitchParameter ShowExamples { get; set; }

        protected override void BeginProcessing()
        {
            this.WriteVerbose("BeginProcessing");
            this.WriteVerbose($"this.SessionState.Path.CurrentFileSystemLocation : {this.SessionState.Path.CurrentFileSystemLocation}");
        }

        protected override void ProcessRecord()
        {
            var resultList = new List<object>();

            if (this.ShowExamples.IsPresent)
            {
                _ShowExmaples();
                return;
            }



            this.WriteVerbose("ProcessRecord");


            var pwd = this.SessionState.Path.CurrentFileSystemLocation.ToString();
            var realZipFile = Path.Combine(pwd, this.SrcZipFile);
            var realDir = "";

            if (string.IsNullOrWhiteSpace(this.TargetDir))
            {
                var fileName = Path.GetFileNameWithoutExtension(this.SrcZipFile);
                realDir = Path.Combine(pwd, fileName);
            }
            else
            {
                var dir = this.TargetDir.Trim(new char[] { '.', '/', '\\' });
                realDir = Path.Combine(pwd, dir);
            }

            ZipFile.ExtractToDirectory(realZipFile, realDir);
            this.WriteObject(resultList);
        }

        protected override void EndProcessing()
        {
            this.WriteVerbose("EndProcessing");
        }

        private void _ShowExmaples()
        {



            this.WriteObject(@"
unzip -SrcZipFile mytest.zip -TargetDir mymytest
            ", true);



            this.WriteObject(@"
            ", true);


        }
    }
}
