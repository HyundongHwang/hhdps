<#
.SYNOPSIS
.EXAMPLE
#>
function hhdgitgraph
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
function hhdgitposhinit
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
        hhdmoduleinstallimport -MODULE_NAME posh-git

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
function hhdgitstashsave
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $stashName
    )

    Read-Host "git status ..."
    git status
    
    Read-Host "git stash list ..."
    git stash list

    Read-Host "git stash save -u `"$stashName`" ..."
    git stash save -u "$stashName"
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdgitstashapply
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.Int32]
        $stashNumber
    )

    Read-Host "git status ..."
    git status
    
    Read-Host "git stash list ..."
    git stash list

    if ($stashName -eq "") 
    {
        Read-Host "git stash pop ..."
        git stash pop
    }
    else 
    {
        Read-Host "git stash apply `"stash@{$stashNumber}`" ..."
        git stash apply "stash@{$stashNumber}"
    }
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdgitaddcommitpush
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
        [System.String]
        $commitMsg
    )

    Read-Host "git status ..."
    git status
    
    Read-Host "git add * ..."
    git add *

    if ($commitMsg -eq "") 
    {
        $commitMsg = "modify"
    }

    Read-Host "git commit -m `"$commitMsg`" ..."
    git commit -m "$commitMsg"

    Read-Host "git pull ..."
    git pull

    Read-Host "git push ..."
    git push
}



<#
.SYNOPSIS
.EXAMPLE
#>
function hhdgitresetclean
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
function hhdinstallgit
{
    [CmdletBinding()]
    param
    (
    )

    explorer "https://git-scm.com/download/win"
}