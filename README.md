# PSnake Module

This project is used to scaffold a PowerShell module project, complete with
PowerShell build and deploy pipeline automation.

## Prerequisites

### Resolving dependencies

#### PSResourceGet

It is possible to use [PSResourceGet](https://github.com/PowerShell/PSResourceGet) to resolve dependencies

#### ModuleFast

It is possible to use [ModuleFast](https://github.com/JustinGrote/ModuleFast) to resolve dependencies. 
ModuleFast only works with PowerShell 7.2 or higher.

#### PowerShellGet & PSDepend

Using PowerShellGet is the default if no other configuration is done. 
We recommend the latest version of PowerShellGet v2.

### Managing the Module versions (optional)

[`GitVersion`](https://gitversion.net/docs/) will generate the version based on the git history. 
You control what version to deploy using [git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging).

```PowerShell
C:\> choco upgrade gitversion.portable
```


## Usage

### How to create a new project

#### `SimpleModule`

Creates a module with minimal structure and pipeline automation.

```powershell
Install-Module -Name 'PSnake' -Scope 'CurrentUser'

$newSampleModuleParameters = @{
    DestinationPath   = 'C:\source'
    ModuleType        = 'SimpleModule'
    ModuleName        = 'MySimpleModule'
    ModuleAuthor      = 'My Name'
    ModuleDescription = 'MySimpleModule Description'
}

New-SnakeProject @newSampleModuleParameters
```

#### `SimpleModule_NoBuild`

Creates a simple module without the build automation.

```powershell
Install-Module -Name 'PSnake' -Scope 'CurrentUser'

$newSampleModuleParameters = @{
    DestinationPath   = 'C:\source'
    ModuleType        = 'SimpleModule_NoBuild'
    ModuleName        = 'MySimpleModuleNoBuild'
    ModuleAuthor      = 'My Name'
    ModuleDescription = 'MySimpleModuleNoBuild Description'
}

New-SnakeProject @newSampleModuleParameters
```

#### `CompleteSample`

Creates a module with complete structure and example files.

```powershell
Install-Module -Name 'PSnake' -Scope 'CurrentUser'

$newSampleModuleParameters = @{
    DestinationPath   = 'C:\source'
    ModuleType        = 'CompleteSample'
    ModuleName        = 'MyCompleteSample'
    ModuleAuthor      = 'My Name'
    ModuleDescription = 'MyCompleteSample Description'
}

New-SnakeProject @newSampleModuleParameters
```

#### `dsccommunity`

Creates a DSC module according to the DSC Community baseline with a pipeline
for build, test, and release automation.

```powershell
Install-Module -Name 'PSnake' -Scope 'CurrentUser'

$newSampleModuleParameters = @{
    DestinationPath   = 'C:\source'
    ModuleType        = 'dsccommunity'
    ModuleName        = 'MyDscModule'
    ModuleAuthor      = 'My Name'
    ModuleDescription = 'MyDscModule Description'
}

New-SnakeProject @newSampleModuleParameters
```

#### `CustomModule`

Will prompt you for more details as to what you'd like to scaffold.

```powershell
Install-Module -Name 'PSnake' -Scope 'CurrentUser'

$snakeModule = Import-Module -Name PSnake -PassThru

$invokePlasterParameters = @{
   TemplatePath    = Join-Path -Path $snakeModule.ModuleBase -ChildPath 'Templates/PSnake'
   DestinationPath   = 'C:\source'
   ModuleType        = 'CustomModule'
   ModuleName        = 'MyCustomModule'
   ModuleAuthor      = 'My Name'
   ModuleDescription = 'MyCustomModule Description'
}

Invoke-Plaster @invokePlasterParameters
```

### How to download dependencies for the project


The following command will resolve dependencies using PSResourceGet:

```powershell
cd C:\source\MySimpleModule

./build.ps1 -ResolveDependency -Tasks noop
```

The following command will resolve dependencies using [ModuleFast](https://github.com/JustinGrote/ModuleFast):

```powershell
cd C:\source\MySimpleModule

./build.ps1 -ResolveDependency -Tasks noop -UseModuleFast
```

The following command will resolve dependencies using [PSResourceGet](https://github.com/PowerShell/PSResourceGet):

```powershell
cd C:\source\MySimpleModule

./build.ps1 -ResolveDependency -Tasks noop -UsePSResourceGet
```

### How to build the project


The following command will build the project:

```powershell
cd C:\source\MySimpleModule

./build.ps1 -Tasks build
```

It is also possible to resolve dependencies and build the project
at the same time using the command:

```powershell
./build.ps1 -ResolveDependency -Tasks build
```

If there are any errors during build they will be shown in the output and the
build will stop. If it is successful the output should end with:

```plaintext
Build succeeded. 7 tasks, 0 errors, 0 warnings 00:00:06.1049394
```

### How to set up the build environment in the current PowerShell session

```powershell
./build.ps1 -Tasks noop
```

>**Note:** For the built-in `noop` task to work, the dependencies must first have been resolved.

### How to run tests
Running all the unit tests, the quality tests and show code coverage can
be achieved by running the command:

```powershell
`./build.ps1 -Tasks test`
```

Integration tests are not run by default when using the build task `test`.
To run the integration test use the following command:

```powershell
`./build.ps1 -Tasks test -PesterPath 'tests/Integration' -CodeCoverageThreshold 0`
```

To run all tests in a specific folder use the parameter `PesterPath` and
optionally `CodeCoverageThreshold` set to `0` to turn off code coverage.
This runs all the quality tests:

```powershell
`./build.ps1 -Tasks test -PesterPath 'tests/QA' -CodeCoverageThreshold 0`
```

To run a specific test file, again use the parameter `PesterPath` and
optionally `CodeCoverageThreshold` set to `0` to turn off code coverage.
This runs just the specific test file `New-SnakeXmlJaCoCoCounter.tests.ps1`:

<!-- markdownlint-disable MD013 - Line length -->
```powershell
./build.ps1 -Tasks test -PesterPath ./tests/Unit/Private/New-SnakeXmlJaCoCoCounter.tests.ps1 -CodeCoverageThreshold 0
```
<!-- markdownlint-enable MD013 - Line length -->

### How to run the default workflow

```powershell
./build -ResolveDependency
```

The parameter `Task` is not used which means this will run the default workflow
(`.`). The tasks for the default workflow are configured in the file `build.yml`.
Normally the default workflow builds the project and runs all the configured test.

This means by running this it will build and run all configured tests:

```powershell
./build.ps1
```

### How to list all available tasks

Because the build tasks are `InvokeBuild` tasks, we can discover them using
the `?` task. So to list the available tasks in a project, run the following
command:

```powershell
./build.ps1 -Tasks ?
```

> **NOTE:** If it is not already done, first make sure to resolve dependencies.
> Dependencies can also hold tasks that are used in the pipeline.
