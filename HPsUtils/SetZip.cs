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
    [Cmdlet(VerbsCommon.Set, "Zip"), 
        Alias("hhdzip")]
    public class SetZip : PSCmdlet
    {
        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty]
        public string SrcDir { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty]
        public string TargetZipFile { get; set; }

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
            var dir = this.SrcDir.Trim(new char[] { '.', '/', '\\' });
            var realDir = Path.Combine(pwd, dir);
            var realZipFile = "";

            if (string.IsNullOrWhiteSpace(this.TargetZipFile))
            {
                realZipFile = Path.Combine(pwd, dir) + ".zip";
            }
            else
            {
                realZipFile = Path.Combine(pwd, this.TargetZipFile);
            }

            ZipFile.CreateFromDirectory(realDir, realZipFile);
            this.WriteObject(resultList);
        }

        protected override void EndProcessing()
        {
            this.WriteVerbose("EndProcessing");
        }

        private void _ShowExmaples()
        {



            this.WriteObject(@"
zip -SrcDir test -TargetZipFile mytest.zip
            ", true);



            this.WriteObject(@"
            ", true);


        }
    }
}
