# This file will not be keep, at build time, an automatic module script will be created.
[CmdletBinding()]
param()

$intPaths = "$PSScriptRoot/enums", "$PSScriptRoot/classes", "$PSScriptRoot/internal"
$pubPaths = "$PSScriptRoot/public"

Write-Verbose "[*] Searching script files..."
$intFiles = Get-ChildItem -Path $intPaths -Filter *.ps1 -ErrorAction SilentlyContinue
$pubFiles = Get-ChildItem -Path $pubPaths -Filter *.ps1 -ErrorAction SilentlyContinue
$files = @($intFiles) + @($pubFiles)
Write-Verbose "[-] Found $($files.Count) script file(s)."

Write-Verbose "[*] Importing script files..."
foreach ($file in $files.FullName)
{
    try
    {
        Write-Verbose "`t - [*] Importing file '$file'"
        . $file
    }
    catch
    {
        Write-Error -Message "Failed to import file '$file', error: $_"
    }
}

Write-Verbose "[*] Exporting Module Member..."
if ($Debug)
{
    Export-ModuleMember -Function * -Alias * -Variable *
}
else
{
    Export-ModuleMember -Function $pubFiles.BaseName
}