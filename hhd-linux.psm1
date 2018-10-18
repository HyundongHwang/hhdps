function lh
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $PATH
)
{
    ls --color=auto -alFh $PATH
}



function code
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $PATH
)
{
    /snap/bin/code $PATH
}



function ff
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $PATH
)
{
    Get-ChildItem $PATH -Recurse | select FullName
}



function open
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $PATH
)
{
    nautilus --browser $PATH
}



function www
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $PATH
)
{
    gnome-www-browser $PATH
}