##########################
# PSake build properties #
##########################

Properties {

# ----------------------- Module properties --------------------------------

    # --- Setting to use when calling the BumpVersion task. This can either be Major, Minor or Patch.
    # --- This setting should eventually be parameterised
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $BumpVersion = "Patch"

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

# ------------------ Test Properties ---------------------------

    # Set the location and name of the Pester results file.
    # Remember to update .gitignore if the path changes
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '')]
    $ResultsFile = "$($PSScriptRoot)\Pester.Results-$(Get-Date -Format ddMMyyyHHMMSS).json"


}