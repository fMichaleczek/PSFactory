
<#
    .SYNOPSIS
        Returns the Platform name.

    .DESCRIPTION
        Gets whether the platform is Windows, Linux or MacOS.

    .EXAMPLE
        Get-SnakeOS

    .NOTES
        General notes
#>
function Get-SnakeOS
{
    [CmdletBinding()]
    param()

    $osShortName = if ($IsWindows -or $PSVersionTable.PSVersion.Major -le 5)
    {
        'Windows'
    }
    elseif ($IsMacOS)
    {
        'MacOS'
    }
    else
    {
        'Linux'
    }

    return $osShortName
}
