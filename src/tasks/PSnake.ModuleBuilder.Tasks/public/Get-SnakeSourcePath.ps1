
<#
    .SYNOPSIS
        Gets the project's source Path based on the ModuleManifest location.

    .DESCRIPTION
        By finding the ModuleManifest of the project using `Get-SnakeProjectModuleManifest`
        this function assumes that the source folder is the parent folder of
        that module manifest.
        This allows the source folder to be src, source, or the Module name's, without
        hardcoding the name.

    .PARAMETER BuildRoot
        BuildRoot of the PSnake project to search the Module manifest from.

    .EXAMPLE
        Get-SnakeSourcePath -BuildRoot 'C:\src\MyModule'

#>
function Get-SnakeSourcePath
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $BuildRoot
    )

    $snakeProjectModuleManifest = Get-SnakeProjectModuleManifest -BuildRoot $BuildRoot
    $snakeSrcPathToTest = Join-Path -Path $BuildRoot -ChildPath 'src'
    $snakeSourcePathToTest = Join-Path -Path $BuildRoot -ChildPath 'source'

    if ($null -ne $snakeProjectModuleManifest)
    {
        return $snakeProjectModuleManifest.Directory.FullName
    }
    elseif ($null -eq $snakeProjectModuleManifest -and (Test-Path -Path  $snakeSourcePathToTest))
    {
        Write-Debug -Message ('The ''source'' path ''{0}'' was found.' -f $snakeSourcePathToTest)
        return $snakeSourcePathToTest
    }
    elseif ($null -eq $snakeProjectModuleManifest -and (Test-Path -Path $snakeSrcPathToTest))
    {
        Write-Debug -Message ('The ''src'' path ''{0}'' was found.' -f $snakeSrcPathToTest)
        return $snakeSrcPathToTest
    }
    else
    {
        throw 'Module Source Path not found.'
    }
}
