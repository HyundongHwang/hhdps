<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-graph
{
    [CmdletBinding()]
    param
    (
    )

    git log --pretty=format:"%h %s - %an %ar" --graph
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-posh-init
{
    write "change prompt ..."

    if((gcm prompt).ScriptBlock -like "*PM>*")
    {
        write "this is visual studio powershell window !!!"
        write "skip setup prompt ..."
    }
    else 
    {
        write "this is normal environment !!!"
        write "import module posh-git ..."
        hhd-module-install-import -MODULE_NAME posh-git

        function global:prompt 
        {
            $realLASTEXITCODE = $LASTEXITCODE
            Write-Host ($pwd.ProviderPath) -nonewline
            Write-VcsStatus
            $global:LASTEXITCODE = $realLASTEXITCODE
            return "> "
        }
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-stash-save
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $stashName
    )

    git status
    git stash list
    git stash save -u "$stashName"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-stash-apply
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Int32]
        $stashNumber
    )

    git status  
    git stash list

    if ($stashName -eq "") 
    {
        git stash pop
    }
    else 
    {
        git stash apply "stash@{$stashNumber}"
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-add-commit-push
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $commitMsg
    )

    git status
    git add *

    if ($commitMsg -eq "") 
    {
        $commitMsg = "modify"
    }

    git commit -m "$commitMsg"
    git pull
    git push
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-reset-clean
{
    [CmdletBinding()]
    param
    (
    )

    git reset --hard HEAD
    git clean -fd
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-install-git
{
    [CmdletBinding()]
    param
    (
    )

    explorer "https://git-scm.com/download/win"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-diff
{
    [CmdletBinding()]
    param
    (
    )

    $res = git diff
    hhd-git-colored-output -INPUT_OBJECT $res
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-status
{
    [CmdletBinding()]
    param
    (
    )

    $res = git status
    hhd-git-colored-output -INPUT_OBJECT $res
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhd-git-colored-output
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Object]
        $INPUT_OBJECT
    )



    $lineNum = 1



    $INPUT_OBJECT | 
    Out-String | 
    foreach {

        $_ -split "\n" |

        foreach {

            if($lineNum % [Console]::WindowHeight -eq 0)
            {
                Read-Host "continue? press any key..."
            }

            $lineNum++

            if($_ -like "diff --git *")
            {
                Write-Host ""
                Write-Host ""
                Write-Host ""
                Write-Host ("#"*80) -ForegroundColor Cyan
                Write-Host $_ -ForegroundColor Cyan
                Write-Host ("#"*80) -ForegroundColor Cyan
                Read-Host "continue? press any key..."
                $lineNum = 1
            }
            elseif($_ -like "--- *")
            {
            }
            elseif($_ -like "+++ *")
            {
            }
            elseif($_ -like "-*")
            {
                Write-Host $_ -ForegroundColor Red
            }
            elseif($_ -like "+*")
            {
                Write-Host $_ -ForegroundColor Green
            }
            elseif($_ -like "On branch *")
            {
                Write-Host ("#"*80) -ForegroundColor Cyan
                Write-Host $_ -ForegroundColor Cyan
            }
            elseif($_ -like "Your branch is*")
            {
                Write-Host $_ -ForegroundColor Cyan
                Write-Host ("#"*80) -ForegroundColor Cyan
            }
            elseif($_ -like "Changes to be committed:*")
            {
                Write-Host ("-"*80) -ForegroundColor Green
                Write-Host $_ -ForegroundColor Green
            }
            elseif($_ -like "Changes not staged for commit:*")
            {
                Write-Host ("-"*80) -ForegroundColor Red
                Write-Host $_ -ForegroundColor Red
            }
            elseif($_ -like "Untracked files:*")
            {
                Write-Host ("-"*80) -ForegroundColor Black
                Write-Host $_ -ForegroundColor Black
            }
            elseif($_ -like "*modified:*")
            {
                Write-Host $_ -ForegroundColor Yellow
            }
            elseif($_ -like "*deleted:*")
            {
                Write-Host $_ -ForegroundColor Red
            }
            else
            {
                Write-Host $_ -ForegroundColor Gray
            }
        }
    }



}
