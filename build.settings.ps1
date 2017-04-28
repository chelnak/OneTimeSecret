##########################
# PSake build properties #
##########################

Properties {

# ----------------- General -------------------------------------
    $DocsDirectory = "$ENV:BHProjectPath\docs"
    $ModuleName = "OneTimeSecret"
    $ModuleAuthor = "Chelnak"

# ----------------- Script Analyzer ------------------------------
    # Should be Warning by default. Can be overridden on demand by using
    # !PSSAError in your commit message
    [ValidateSet('Error', 'Warning', 'Any', 'None')]
    $ScriptAnalysisFailBuildOnSeverityLevel = 'Warning'
    $ScriptAnalyzerSettingsPath = "$PSScriptRoot\PSScriptAnalyzerSettings.psd1"

# ----------------- GitHub ---------------------------------------
    $OrgName = "chelnak"
    $RepositoryName = "OneTimeSecret"
    $RepositoryUrl = "https://github.com/chelnak/OneTimeSecret"
}