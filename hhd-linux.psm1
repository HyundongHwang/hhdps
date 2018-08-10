function lh
(
    [Parameter(Mandatory=$false, ValueFromPipeline=$true, ValueFromPipelinebyPropertyName=$true)]
    [System.String]
    $PATH
)
{
    ls --color=auto -alFh $PATH
}