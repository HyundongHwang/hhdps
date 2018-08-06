using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace temp
{
    class Program
    {
        static void Main(string[] args)
        {
            var str = "";
            var list = new[] { "a", "b" };
            str.Contains("hello");
            str.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);

            var myset = new SortedSet<string>();
            myset.Add("");
        }
    }
}
