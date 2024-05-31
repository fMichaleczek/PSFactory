# This file will not be keep, at build time, an automatic module script will be created.
[CmdletBinding()]
param()

$script:ModuleName = $MyInvocation.MyCommand.ScriptBlock.Module.Name
$itemSplat = @{ File = $true ; Recurse = $true ; Force = $true ; ErrorAction = 'Ignore' }

Write-Verbose '[*] Searching script files...'
$internal = Get-ChildItem @itemSplat -Path $PSScriptRoot/enums, $PSScriptRoot/classes, $PSScriptRoot/internal -Filter *.ps1
$public   = Get-ChildItem @itemSplat -Path $PSScriptRoot/public -Filter *.ps1
$tasks    = Get-ChildItem @itemSplat -Path $PSScriptRoot/tasks -Filter *.build.ps1

Write-Verbose '[*] Importing script files...'
foreach ($file in (@($internal) + @($public)).FullName)
{
    try
    {
        Write-Verbose "[*] dot source file '$file'"
        . $file
    }
    catch
    {
        Write-Error -Message "Failed to dot source file '$file', Exception: $($_.Exception)"
    }
}

Write-Verbose '[*] Importing tasks alias...'
foreach ($file in @($tasks))
{
    Set-Alias -Name ('{0}.{1}.ib.tasks' -f $file.BaseName, $ModuleName) -Value $file.FullName
}

if (Test-Path $PSScriptRoot/scripts/Set-SnakeTaskVariable.ps1)
{
    Set-Alias -Name Set-SnakeTaskVariable -Value $PSScriptRoot/scripts/Set-SnakeTaskVariable.ps1
    # Set-Alias -Name 'PSnake.Tasks' -Value "$PSScriptRoot/build.tasks.ps1" -Force -ErrorAction Ignore
}

if (Test-Path $PSScriptRoot/Localization/$ModuleName.psd1)
{
    $script:LocalizedData = Import-LocalizedData -BaseDirectory $PSScriptRoot/Localization -FileName $ModuleName.psd1
}


Write-Verbose '[*] Exporting Module Member...'
if ($Debug)
{
    Export-ModuleMember -Function * -Alias * -Variable *
}
else
{
    Export-ModuleMember -Function $public.BaseName
}