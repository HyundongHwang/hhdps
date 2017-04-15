using System;
using System.Collections.Generic;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

namespace HPsUtils
{
    public class ReturnType
    {
        public string Input { get; set; }
        public string Output { get; set; }
    }

    [Cmdlet(VerbsCommon.Set, "DoubleStr"), 
        Alias("hhddouble")]
    public class SetDoubleStr : PSCmdlet
    {
        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty]
        public string[] InputAsDouble { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true
        )]
        [ValidateNotNullOrEmpty]
        public string[] InputAsTriple { get; set; }

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

            if (this.InputAsDouble != null)
            {
                foreach (var inStr in this.InputAsDouble)
                {
                    resultList.Add(new ReturnType()
                    {
                        Input = inStr,
                        Output = inStr + inStr,
                    });
                }
            }

            if (this.InputAsTriple != null)
            {
                foreach (var inStr in this.InputAsTriple)
                {
                    resultList.Add(new ReturnType()
                    {
                        Input = inStr,
                        Output = inStr + inStr + inStr,
                    });
                }
            }

            this.WriteObject(resultList);
        }

        protected override void EndProcessing()
        {
            this.WriteVerbose("EndProcessing");
        }

        private void _ShowExmaples()
        {



            this.WriteObject(@"
PS> @(""a"", ""b"") | Set-DoubleStr
Input Output
---- - ------
a     aa
a     aaa
b     bb
b     bbb
            ", true);



            this.WriteObject(@"
PS > @(""a"", ""b"") | select @{ l = 'InputAsTriple'; e ={$_} } | Set - DoubleStr
Input Output
---- - ------
a       aaa
b       bbb
            ", true);


        }
    }
}
