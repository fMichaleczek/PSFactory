@{
    PSDependOptions             = @{
        AddToPath  = $true
        Target     = 'output\RequiredModules'
        Parameters = @{
            Repository = 'PSGallery'
        }
    }

    InvokeBuild                 = 'latest'
    PSScriptAnalyzer            = 'latest'
    Pester                      = 'latest'
    Plaster                     = 'latest'
    ModuleBuilder               = 'latest'
    ChangelogManagement         = 'latest'
    PSFactory                   = 'latest'
    'PSFactory.GitHubTasks'     = 'latest'
    MarkdownLinkCheck           = 'latest'
    'DscResource.AnalyzerRules' = 'latest'
    'DscResource.Test'          = 'latest'
}
