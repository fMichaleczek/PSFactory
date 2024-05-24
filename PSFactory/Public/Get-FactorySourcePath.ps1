
<#
    .SYNOPSIS
        Gets the project's source Path based on the ModuleManifest location.

    .DESCRIPTION
        By finding the ModuleManifest of the project using `Get-FactoryProjectModuleManifest`
        this function assumes that the source folder is the parent folder of
        that module manifest.
        This allows the source folder to be src, source, or the Module name's, without
        hardcoding the name.

    .PARAMETER BuildRoot
        BuildRoot of the PSFactory project to search the Module manifest from.

    .EXAMPLE
        Get-FactorySourcePath -BuildRoot 'C:\src\MyModule'

#>
function Get-FactorySourcePath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BuildRoot
    )

    $factoryProjectModuleManifest = Get-FactoryProjectModuleManifest -BuildRoot $BuildRoot
    $factorySrcPathToTest = Join-Path -Path $BuildRoot -ChildPath 'src'
    $factorySourcePathToTest = Join-Path -Path $BuildRoot -ChildPath 'source'

    if ($null -ne $factoryProjectModuleManifest)
    {
        return $factoryProjectModuleManifest.Directory.FullName
    }
    elseif ($null -eq $factoryProjectModuleManifest -and (Test-Path -Path  $factorySourcePathToTest))
    {
        Write-Debug -Message ('The ''source'' path ''{0}'' was found.' -f $factorySourcePathToTest)
        return $factorySourcePathToTest
    }
    elseif ($null -eq $factoryProjectModuleManifest -and (Test-Path -Path $factorySrcPathToTest))
    {
        Write-Debug -Message ('The ''src'' path ''{0}'' was found.' -f $factorySrcPathToTest)
        return $factorySrcPathToTest
    }
    else
    {
        throw 'Module Source Path not found.'
    }
}
