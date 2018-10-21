##########################
# PSake build properties #
##########################

Properties {

# ----------------- General -------------------------------------
    $DocsDirectory = "$ENV:BHProjectPath\docs"
    $ModuleName = "OneTimeSecret"
    $ModuleAuthor = "chelnak"
    $ReleaseDirectoryPath = "$($ENV:BHProjectPath)\Release\$($ModuleName)"
    $ModuleManifestVersion = "0.0.0"

# ----------------- Script Analyzer ------------------------------
    # Should be Warning by default. Can be overridden on demand by using
    # !PSSAError in your commit message
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Warning'
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"

# ----------------- GitHub ---------------------------------------
    $OrgName = "chelnak"
    $RepositoryName = "onetimesecret"
    $RepositoryUrl = "https://github.com/chelnak/onetimesecret"
}