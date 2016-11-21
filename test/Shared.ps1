# Dot source this script in any Pester test script that requires the module to be imported.

$ModuleManifestName = 'OneTimeSecret.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the OneTimeSecret\ namespace
    Import-Module $ModuleManifestPath -Scope Global
}

# Get test variables
$Variables = Get-Content -Path $PSScriptRoot\Variables.json -Raw | ConvertFrom-Json