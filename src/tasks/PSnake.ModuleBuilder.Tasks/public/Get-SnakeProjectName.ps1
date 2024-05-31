
<#
    .SYNOPSIS
        Gets the Project Name based on the ModuleManifest if Available.

    .DESCRIPTION
        Finds the Module Manifest through `Get-SnakeProjectModuleManifest`
        and deduce ProjectName based on the BaseName of that manifest.

    .PARAMETER BuildRoot
        BuildRoot of the PSnake project to search the Module manifest from.

    .EXAMPLE
        Get-SnakeProjectName -BuildRoot 'C:\src\MyModule'

#>
function Get-SnakeProjectName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BuildRoot
    )

    return (Get-SnakeProjectModuleManifest -BuildRoot $BuildRoot).BaseName
}
