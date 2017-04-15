using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Management.Automation;
using System.Text;
using System.Threading.Tasks;

//https://msdn.microsoft.com/en-us/library/ff602029(v=vs.85).aspx

namespace HPsUtils
{
    [Cmdlet(VerbsCommon.Get, "Proc")]
    public class GetProcCommand : Cmdlet
    {
        [Parameter(
            Mandatory = false,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        [ValidateNotNullOrEmpty]
        public string[] Name { get; set; }

        [Parameter(
            Mandatory = false,
            ValueFromPipeline = false,
            ValueFromPipelineByPropertyName = false)]
        [ValidateNotNullOrEmpty]
        public SwitchParameter ShowExamples { get; set; }

        protected override void ProcessRecord()
        {
            if (this.ShowExamples.IsPresent)
            {
                _ShowExmaples();
                return;
            }

            var processList = new List<Process>();

            if (this.Name == null)
            {
                processList = Process.GetProcesses().ToList();
                this.WriteObject(processList, true);
            }
            else
            {
                foreach (string name in this.Name)
                {
                    try
                    {
                        processList = Process.GetProcessesByName(name).ToList();
                    }
                    catch (InvalidOperationException ex)
                    {
                        this.WriteError(new ErrorRecord(
                           ex,
                           "UnableToAccessProcessByName",
                           ErrorCategory.InvalidOperation,
                           name));
                        continue;
                    }

                    WriteObject(processList, true);
                } // foreach (string name...
            } // else
        } // ProcessRecord

        private void _ShowExmaples()
        {
            this.WriteObject(@"
PS> Get-Proc -Name chrome

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    303      26    57604      43344   374     5.91   6748   9 chrome
    428      33    35892      38380   312   200.41  12960   9 chrome
    279      28    71116      75256   309    66.05  17096   9 chrome
    437      49   197884     242648   689   416.78   8572   9 chrome
    321      31    84988      46908   423    20.98  22380   9 chrome
    302      28    69760      50592   395    67.41  10744   9 chrome
   1933      62   115640     124680   662   372.89  13848   9 chrome
    340      31    97556      65928   459   108.05  19352   9 chrome
    130      10     1456       7360    79     0.20   9184   9 chrome
    264      29    83324      55116   315    19.47    964   9 chrome
    226      20    30560      20576   207     3.08  21552   9 chrome
    293      27    71516      48356   314   109.89  20240   9 chrome
                    ", true);

            this.WriteObject(@"
PS> Get-Proc | select -First 10

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    353       9     3528       4108 ...74    92.08    784   0 services
    204      12     1440       1432 ...78   261.53   1376   0 WUDFHost
    123       7     1296       1108    62     0.06   3148   0 HeciServer
    197      14     4204       7144 ...03    21.53   1964   0 dasHost
    498      21     9964       4556 ...71    16.70   3536   0 vmms
    730      45    25496      41344   242     5.83  20280   9 VsHub
    282      13     4756       2000 ...06     0.25   3140   0 svchost
   4088     164   159148      84504   811    58.14   9808   9 Microsoft.VsHub.Server.HttpHost
    489      30     5224       9360 ...52    70.55   1164   0 svchost
    262      14     9796      37472   200    79.81   5692   9 DisplayLinkUserAgent
                    ", true);
        }
    } // End GetProcCommand class.
}