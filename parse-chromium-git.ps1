#
# parse_chromium_git.ps1
#
#<a class="u-sha1 u-monospace CommitLog-sha1" href="/chromium/src/+/9612d1982addbe16d6ae43b956aa4ff6658b6f3d">9612d19</a>
#<a class="LogNav-next" href="/chromium/src/+log/13e8fdc9b6ad4c3eb78b2cd7f3e726a0cb3535b5..9612d1982addbe16d6ae43b956aa4ff6658b6f3d/?s=d12c41271a06037f3a36d705413493630ad016af">Next ?</a>
#<pre class="u-pre u-monospace MetadataMessage">[MessageLoop] Don't clobber |recent_time_|

#I'm about to duplicate that line in
#<a href="https://chromium-review.googlesource.com/c/chromium/src/+/1106434">https://chromium-review.googlesource.com/c/chromium/src/+/1106434</a>
#and it feels silly to clobber |recent_time_| since TimeTicks is
#monotically increasing regardless of nested loops (cloberring it is at
#best irrelevant and at worse forces an unecessary recomputation of
#Now()).

#R=danakj@chromium.org, kylechar@chromium.org

#Bug: None
#Change-Id: <a href="https://chromium-review.googlesource.com/#/q/Ia11ca15fcde850fba5cc33bc1cbac68386495719">Ia11ca15fcde850fba5cc33bc1cbac68386495719</a>
#Reviewed-on: <a href="https://chromium-review.googlesource.com/1125168">https://chromium-review.googlesource.com/1125168</a>
#Reviewed-by: kylechar &lt;kylechar@chromium.org&gt;
#Reviewed-by: danakj &lt;danakj@chromium.org&gt;
#Commit-Queue: Gabriel Charette &lt;gab@chromium.org&gt;
#Cr-Commit-Position: refs/heads/master@{#572592}</pre>


$uri = New-Object System.Uri -ArgumentList @("https://chromium.googlesource.com/chromium/src/+log/13e8fdc9b6ad4c3eb78b2cd7f3e726a0cb3535b5..9612d1982addbe16d6ae43b956aa4ff6658b6f3d")
$uriPrefix = "$($uri.scheme)://$($uri.Host)"
$sb = New-Object System.Text.StringBuilder


while($true) 
{
    $pageRes = curl $uri
    $pageHref = $pageRes.Links |
    where { $_.class -eq "LogNav-next" } |
    select href 

    $pageHref.href | 
    foreach {

        $commitLinkRes = $pageRes.Links | 
        where { $_.class -eq "u-sha1 u-monospace CommitLog-sha1" } | 
        select href
        
        $commitLinkRes.href |
        foreach {
            $commitPageUri = "$uriPrefix$_"
            $commitPageRes = curl $commitPageUri

            $commitPageRes.AllElements | 
            where { $_.class -eq "u-pre u-monospace MetadataMessage" } | 
            foreach {
                "=" * 80 | tee -FilePath cromium-changes.txt -Append | Write-Host -ForegroundColor Black
                $commitPageUri | tee -FilePath cromium-changes.txt -Append | Write-Host -ForegroundColor Yellow
                "-" * 80 | tee -FilePath cromium-changes.txt -Append | Write-Host  -ForegroundColor Black
                $_.innerHTML | tee -FilePath cromium-changes.txt -Append | Write-Host
            }
        }
    }

    if($pageHref.href.Count -eq 0) {
        break
    }

    $uri = $pageHref.href
}