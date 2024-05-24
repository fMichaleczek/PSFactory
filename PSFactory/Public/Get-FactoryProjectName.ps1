
<#
    .SYNOPSIS
        Gets the Project Name based on the ModuleManifest if Available.

    .DESCRIPTION
        Finds the Module Manifest through `Get-FactoryProjectModuleManifest`
        and deduce ProjectName based on the BaseName of that manifest.

    .PARAMETER BuildRoot
        BuildRoot of the PSFactory project to search the Module manifest from.

    .EXAMPLE
        Get-FactoryProjectName -BuildRoot 'C:\src\MyModule'

#>
function Get-FactoryProjectName
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BuildRoot
    )

    return (Get-FactoryProjectModuleManifest -BuildRoot $BuildRoot).BaseName
}
