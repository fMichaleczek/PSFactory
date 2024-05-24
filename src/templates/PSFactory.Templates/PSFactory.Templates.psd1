@{
    # Script module or binary module file associated with this manifest.
    RootModule        = 'PSFactory.Templates.psm1'

    # Version number of this module.
    ModuleVersion     = '0.0.1'

    # Supported PSEditions
    # CompatiblePSEditions = @('Desktop','Core') # Removed to support PS 5.0

    # ID used to uniquely identify this module
    GUID              = '2507f9cd-415e-4977-af36-fe321881fec0'

    # Author of this module
    Author            = 'Flavien MICHALECZEK'

    # Company or vendor of this module
    CompanyName       = 'LEXPEK'

    # Copyright statement for this module
    Copyright         = '(c) LEXPEK. All rights reserved.'

    # Description of the functionality provided by this module
    Description       = 'Templates for PSFactory.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.0'

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules   = @(
        'Plaster'
    )

    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules     = @()

    # Functions to export from this module
    FunctionsToExport = ''

    # Cmdlets to export from this module
    CmdletsToExport   = ''

    # Variables to export from this module
    VariablesToExport = ''

    # Aliases to export from this module
    AliasesToExport   = '*'

    # List of all modules packaged with this module
    ModuleList        = @()

    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData       = @{
        PSData = @{
            # Extension for Plaster Template discoverability with `Get-PlasterTemplate -IncludeInstalledModules`
            Extensions   = @(
                @{
                    Module         = 'Plaster'
                    minimumVersion = '1.1.3'
                    Details        = @{
                        TemplatePaths = @(
                            'templates\Classes'
                            'templates\ClassResource'
                            'templates\Composite'
                            'templates\Enum'
                            'templates\MofResource'
                            'templates\PrivateFunction'
                            'templates\PublicCallPrivateFunctions'
                            'templates\PublicFunction'
                            'templates\PSFactory'
                        )
                    }
                }
            )

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags         = @('Template', 'Pipeline', 'Plaster', 'DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource', 'Windows', 'MacOS', 'Linux')

            # A URL to the license for this module.
            LicenseUri   = 'https://github.com/fmichaleczek/PSFactory/blob/main/LICENSE.txt'

            # A URL to the main website for this project.
            ProjectUri   = 'https://github.com/fmichaleczek/PSFactory'

            # A URL to an icon representing this module.
            IconUri      = 'https://raw.githubusercontent.com/fmichaleczek/PSFactory/main/assets/PSFactory_512x512.png'

            # ReleaseNotes of this module
            ReleaseNotes = ''

            Prerelease   = ''
        } # End of PSData hashtable
    } # End of PrivateData hashtable
}
