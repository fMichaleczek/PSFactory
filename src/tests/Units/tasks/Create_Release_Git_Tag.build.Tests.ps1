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
}

AfterAll {
    Remove-Module -Name $script:moduleName
}

Describe 'Create_Release_Git_Tag' {
    BeforeAll {
        $buildTaskName = 'Create_Release_Git_Tag'

        $taskAlias = Get-Alias -Name "$buildTaskName.build.PSnake.ib.tasks"
    }

    It 'Should have exported the alias correct' {
        $taskAlias.Name | Should -Be 'Create_Release_Git_Tag.build.PSnake.ib.tasks'
        $taskAlias.ReferencedCommand | Should -Be 'Create_Release_Git_Tag.build.ps1'
        $taskAlias.Definition | Should -Match 'PSnake[\/|\\]\d+\.\d+\.\d+[\/|\\]tasks[\/|\\]Create_Release_Git_Tag\.build\.ps1'
    }

    Context 'When creating a preview release tag' {
        BeforeAll {
            # Dot-source mocks
            . $PSScriptRoot/../helpers/MockSetPSnakeTaskVariable

            function script:git
            {
                throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
            }

            Mock -CommandName git

            Mock -CommandName PSnake\Invoke-SnakeGit

            Mock -CommandName PSnake\Invoke-SnakeGit -ParameterFilter {
                $Argument -contains 'rev-parse'
            } -MockWith {
                return '0c23efc'
            }

            Mock -CommandName Start-Sleep

            $mockTaskParameters = @{
                ProjectPath = Join-Path -Path $TestDrive -ChildPath 'MyModule'
                OutputDirectory = Join-Path -Path $TestDrive -ChildPath 'MyModule/output'
                SourcePath = Join-Path -Path $TestDrive -ChildPath 'MyModule/source'
                ProjectName = 'MyModule'
                BasicAuthPAT = '22222'
                GitConfigUserName = 'bot'
                GitConfigUserEmail = 'bot@company.local'
                MainGitBranch = 'main'
            }
        }

        AfterAll {
            Remove-Item 'function:git'
        }

        It 'Should run the build task without throwing' {
            {
                Invoke-Build -Task $buildTaskName -File $taskAlias.Definition @mockTaskParameters
            } | Should -Not -Throw
        }
    }

    Context 'When publishing should be skipped' {
        BeforeAll {
            $mockTaskParameters = @{
                SkipPublish = $true
            }
        }

        It 'Should run the build task without throwing' {
            {
                Invoke-Build -Task $buildTaskName -File $taskAlias.Definition @mockTaskParameters
            } | Should -Not -Throw
        }
    }

    Context 'When commit already got a tag' {
        BeforeAll {
            # Dot-source mocks
            . $PSScriptRoot/../helpers/MockSetPSnakeTaskVariable

            # Stub for git executable
            function script:git
            {
                throw '{0}: StubNotImplemented' -f $MyInvocation.MyCommand
            }

            Mock -CommandName git -MockWith {
                return 'v2.0.0'
            }

            Mock -CommandName PSnake\Invoke-SnakeGit

            Mock -CommandName PSnake\Invoke-SnakeGit -ParameterFilter {
                $Argument -contains 'rev-parse'
            } -MockWith {
                return '0c23efc'
            }

            Mock -CommandName Start-Sleep

            $mockTaskParameters = @{
                ProjectPath = Join-Path -Path $TestDrive -ChildPath 'MyModule'
                OutputDirectory = Join-Path -Path $TestDrive -ChildPath 'MyModule/output'
                SourcePath = Join-Path -Path $TestDrive -ChildPath 'MyModule/source'
                ProjectName = 'MyModule'
                BasicAuthPAT = '22222'
                GitConfigUserName = 'bot'
                GitConfigUserEmail = 'bot@company.local'
                MainGitBranch = 'main'
            }
        }

        AfterAll {
            Remove-Item 'function:git'
        }

        It 'Should run the build task without throwing' {
            {
                Invoke-Build -Task $buildTaskName -File $taskAlias.Definition @mockTaskParameters
            } | Should -Not -Throw
        }
    }
}
