# Inspired from https://github.com/nightroman/Invoke-Build/blob/64f3434e1daa806814852049771f4b7d3ec4d3a3/Tasks/Import/README.md#example-2-import-from-a-module-with-tasks
 
$moduleName = ([System.IO.FileInfo] $MyInvocation.MyCommand.Name).BaseName

$tasksFiles = Get-ChildItem -Path "$PSScriptRoot/tasks" -File -Filter '*.build.*' -Recurse
foreach ($taskFile in @($taskFiles))
{
    $taskFileAliasName = '{0}.{1}.ib.tasks' -f $_.BaseName, $moduleName
    Set-Alias -Name $taskFileAliasName -Value $_.FullName
}

$SetPSFactoryTaskVariableAliasName = 'Set-FactoryTaskVariable'
$SetPSFactoryTaskVariableAliasValue = "$PSScriptRoot/scripts/Set-FactoryTaskVariable.ps1"
Set-Alias -Name $SetPSFactoryTaskVariableAliasName -Value $SetPSFactoryTaskVariableAliasValue
