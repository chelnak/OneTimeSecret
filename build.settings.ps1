##########################
# PSake build properties #
##########################

Properties {

# ----------------------- Basic properties --------------------------------
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $SrcRootDir  = "$PSScriptRoot\src"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleName = Get-Item $SrcRootDir/*.psd1 |
                      Where-Object { $null -ne (Test-ModuleManifest -Path $_ -ErrorAction SilentlyContinue) } |
                      Select-Object -First 1 | Foreach-Object BaseName

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ModuleManifestPath = "$($SrcRootDir)\$($ModuleName).psd1"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $CurrentModuleVersion = (Import-PowerShellDataFile -Path $ModuleManifestPath).ModuleVersion

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $OutDir = "$PSScriptRoot\Release"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DocsDirectory = "$PSScriptRoot\docs"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $TestDirectory = "$PSScriptRoot\test"

    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $DefaultLocale = "en-US"

    # --- When PSScriptAnalyzer is enabled, control which severity level will generate a build failure.
    # --- Valid values are Error, Warning, Information and None.  "None" will report errors but will not
    # --- cause a build failure.  "Error" will fail the build only on diagnostic records that are of
    # --- severity error.  "Warning" will fail the build on Warning and Error diagnostic records.
    # --- "Any" will fail the build on any diagnostic record, regardless of severity.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Error'

    # Path to the PSScriptAnalyzer settings file.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"

# ----------------------- GitHubReleaseManager properties --------------------------------

    # --- The name of the repository. This will be set to the modules name by default.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $GithubRepositoryName = $($ModuleName)

    # --- The owner of the repository.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $GitHubUsername = "chelnak"

    # --- Personal Access Token. Store your token in a file called .gittoken in the root of the repository
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $GitHubAPIKey = (Get-Content -Path "$($PSScriptRoot)\.gittoken" -Raw)

    # --- The branch that you want to publish the release from. By default this is the master branch.
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $GitHubReleaseTarget = "master"

# ----------------------- PowerShell Gallery properties --------------------------------

      # --- PowerShell Gallery APIKey. Store your token in a file called .nugetapikey in the root of the repository
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $NuGetAPIKey = (Get-Content -Path "$($PSScriptRoot)\.nugetapikey" -Raw)

# ----------------------- VersioningSettings properties --------------------------------

    # --- $Version is a parameter from build.ps1
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $BumpVersion = $Version

}