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
    /usr/bin/code $PATH
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



function pkillef
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $KEYWORD
)
{
    pkill -9 -ef $KEYWORD
}



function psgrep
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $KEYWORD
)
{
    ps -ef | grep $KEYWORD
}