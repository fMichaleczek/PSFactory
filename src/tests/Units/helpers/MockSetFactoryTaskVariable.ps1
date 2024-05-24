<#
    .SYNOPSIS
        This script is dot-source'd into the unit test for Set-FactoryTasksVariable
        and also the unit tests for the build tasks.

    .NOTES
        This mocks the Set-FactoryTasksVariable.ps1 variables to:

        $BuiltModuleBase = "$TestDrive/output/builtModule/MyModule/2.0.0"
        $BuiltModuleManifest = "$TestDrive/output/builtModule/MyModule/2.0.0/MyModule.psd1"
        $BuiltModuleRootScriptPath = "$TestDrive/output/builtModule/MyModule/2.0.0/MyModule.psm1"
        $BuiltModuleSubDirectory = "$TestDrive/output/builtModule"
        $ChocolateyBuildOutput = "$TestDrive/output/choco"
        $ModuleManifestPath = "$TestDrive/source/MyModule.psd1"
        $ModuleVersion = '2.0.0'
        $ModuleVersionFolder = '2.0.0'
        $OutputDirectory = "$TestDrive/output"
        $ProjectName = 'MyModule'
        $ReleaseNotesPath = "$TestDrive/output/"
        $SourcePath = "$TestDrive/source"
        $VersionedOutputDirectory = $true
#>

$BuildRoot = $TestDrive

$ProjectName = $null
$SourcePath = $null
$OutputDirectory = 'output'
$ReleaseNotesPath = $null
$BuiltModuleSubDirectory = 'builtModule'
$ModuleManifestPath = $null
$ChocolateyBuildOutput = 'choco'
$VersionedOutputDirectory = $true
$BuiltModuleManifest = $null
$BuiltModuleBase = $null
$ModuleVersion = $null
$ModuleVersionFolder = $null
$BuiltModuleRootScriptPath = $null

Mock -CommandName Get-FactoryProjectName -MockWith {
    return 'MyModule'
}

Mock -CommandName Get-FactorySourcePath -MockWith {
    return (Join-Path -Path $TestDrive -ChildPath 'source')
}

Mock -CommandName Get-FactoryAbsolutePath -ParameterFilter {
    $Path -eq 'MyModule.psd1'
} -MockWith {
    return (
        Join-Path -Path $TestDrive -ChildPath 'source' |
            Join-Path -ChildPath 'MyModule.psd1'
    )
}

$script:mockGetFactoryBuiltModuleManifestReturnValue =

Mock -CommandName Get-FactoryBuiltModuleManifest -MockWith {
    return (
        Join-Path -Path $TestDrive -ChildPath 'output' |
            Join-Path -ChildPath 'builtModule' |
            Join-Path -ChildPath 'MyModule' |
            Join-Path -ChildPath '2.0.0' |
            Join-Path -ChildPath 'MyModule.psd1'
    )
}

# This is called after the mock of Get-FactoryBuiltModuleManifest
Mock -CommandName Get-Item -MockWith {
    return @{
        FullName = (
            Join-Path -Path $TestDrive -ChildPath 'output' |
                Join-Path -ChildPath 'builtModule' |
                Join-Path -ChildPath 'MyModule' |
                Join-Path -ChildPath '2.0.0' |
                Join-Path -ChildPath 'MyModule.psd1'
        )
    }
} -ParameterFilter {
    # Must be the same path that the mock for Get-FactoryBuiltModuleManifest returns.
    $Path -contains (
        Join-Path -Path $TestDrive -ChildPath 'output' |
            Join-Path -ChildPath 'builtModule' |
            Join-Path -ChildPath 'MyModule' |
            Join-Path -ChildPath '2.0.0' |
            Join-Path -ChildPath 'MyModule.psd1'
    )
}

Mock -CommandName Get-FactoryBuiltModuleBase -MockWith {
    return (
        Join-Path -Path $TestDrive -ChildPath 'output' |
            Join-Path -ChildPath 'builtModule' |
            Join-Path -ChildPath 'MyModule' |
            Join-Path -ChildPath '2.0.0'
    )
}

# This is called after the mock of Get-FactoryBuiltModuleBase
Mock -CommandName Get-Item -MockWith {
    @{
        FullName = (
            Join-Path -Path $TestDrive -ChildPath 'output' |
                Join-Path -ChildPath 'builtModule' |
                Join-Path -ChildPath 'MyModule' |
                Join-Path -ChildPath '2.0.0'
        )
    }
} -ParameterFilter {
    # Must be the same path that the mock for Get-FactoryBuiltModuleManifest returns.
    $Path -contains (
        Join-Path -Path $TestDrive -ChildPath 'output' |
            Join-Path -ChildPath 'builtModule' |
            Join-Path -ChildPath 'MyModule' |
            Join-Path -ChildPath '2.0.0'
    )
}

Mock -CommandName Get-FactoryBuiltModuleVersion -MockWith {
    return '2.0.0'
}

Mock -CommandName Get-FactoryModuleRootPath -MockWith {
    return (
        Join-Path -Path $TestDrive -ChildPath 'output' |
            Join-Path -ChildPath 'builtModule' |
            Join-Path -ChildPath 'MyModule' |
            Join-Path -ChildPath '2.0.0' |
            Join-Path -ChildPath 'MyModule.psm1'
    )
}

# This is called after the mock of Get-FactoryModuleRootPath
Mock -CommandName Get-Item -MockWith {
    @{
        FullName = (
            Join-Path -Path $TestDrive -ChildPath 'output' |
                Join-Path -ChildPath 'builtModule' |
                Join-Path -ChildPath 'MyModule' |
                Join-Path -ChildPath '2.0.0' |
                Join-Path -ChildPath 'MyModule.psm1'
        )
    }
} -ParameterFilter {
    # Must be the same path that the mock for Get-FactoryBuiltModuleManifest returns.
    $Path -contains (
        Join-Path -Path $TestDrive -ChildPath 'output' |
            Join-Path -ChildPath 'builtModule' |
            Join-Path -ChildPath 'MyModule' |
            Join-Path -ChildPath '2.0.0' |
            Join-Path -ChildPath 'MyModule.psm1'
    )
}

# This is only used when calling Set-FactoryTaskVariable with parameter -AsNewBuild
Mock -CommandName Get-BuildVersion -MockWith {
    return '2.0.0'
}
