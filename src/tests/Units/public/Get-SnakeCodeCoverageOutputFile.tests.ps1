BeforeAll {
    $script:moduleName = 'PSnake'

    # If the module is not found, run the build task 'noop'.
    if (-not (Get-Module -Name $script:moduleName -ListAvailable))
    {
        # Redirect all streams to $null, except the error stream (stream 2)
        & "$PSScriptRoot/../../build.ps1" -Tasks 'noop' 2>&1 4>&1 5>&1 6>&1 > $null
    }

    # Re-import the module using force to get any code changes between runs.
    Import-Module -Name $script:moduleName -Force -ErrorAction 'Stop'

    $PSDefaultParameterValues['InModuleScope:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Mock:ModuleName'] = $script:moduleName
    $PSDefaultParameterValues['Should:ModuleName'] = $script:moduleName
}

AfterAll {
    $PSDefaultParameterValues.Remove('Mock:ModuleName')
    $PSDefaultParameterValues.Remove('InModuleScope:ModuleName')
    $PSDefaultParameterValues.Remove('Should:ModuleName')

    Remove-Module -Name $script:moduleName
}

Describe 'Get-SnakeCodeCoverageOutputFile' {
    Context 'When there is no build configuration value' {
        It 'Should return $null' {
            $result = PSnake\Get-SnakeCodeCoverageOutputFile -PesterOutputFolder $TestDrive -BuildInfo @{}

            $result | Should -BeNullOrEmpty
        }
    }

    Context 'When using deprecated Pester build configuration value' {
        BeforeAll {
            $mockAbsolutePath = Join-Path -Path $TestDrive -ChildPath 'JaCoCo_coverage.xml'
        }

        Context 'When passing absolute path' {
            It 'Should return the absolute path' {
                $result = PSnake\Get-SnakeCodeCoverageOutputFile -PesterOutputFolder $TestDrive -BuildInfo @{
                    Pester = @{
                        CodeCoverageOutputFile = $mockAbsolutePath
                    }
                }

                $result | Should -Be $mockAbsolutePath
            }
        }

        Context 'When passing relative path' {
            It 'Should return the configured value' {
                $result = PSnake\Get-SnakeCodeCoverageOutputFile -PesterOutputFolder $TestDrive -BuildInfo @{
                    Pester = @{
                        CodeCoverageOutputFile = 'JaCoCo_coverage.xml'
                    }
                }

                $result | Should -Be $mockAbsolutePath
            }
        }
    }

    Context 'When using advanced Pester build configuration value' {
        BeforeAll {
            $mockAbsolutePath = Join-Path -Path $TestDrive -ChildPath 'JaCoCo_coverage.xml'
        }

        Context 'When passing absolute path' {
            It 'Should return the absolute path' {
                $result = PSnake\Get-SnakeCodeCoverageOutputFile -PesterOutputFolder $TestDrive -BuildInfo @{
                    Pester = @{
                        Configuration = @{
                            CodeCoverage = @{
                                OutputPath = $mockAbsolutePath
                            }
                        }
                    }
                }

                $result | Should -Be $mockAbsolutePath
            }
        }

        Context 'When passing relative path' {
            It 'Should return the configured value' {
                $result = PSnake\Get-SnakeCodeCoverageOutputFile -PesterOutputFolder $TestDrive -BuildInfo @{
                    Pester = @{
                        Configuration = @{
                            CodeCoverage = @{
                                OutputPath = 'JaCoCo_coverage.xml'
                            }
                        }
                    }
                }

                $result | Should -Be $mockAbsolutePath
            }
        }
    }
}
