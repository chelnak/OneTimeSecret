#Requires -Modules Psake, Pester, PSScriptAnalyzer, PlatyPS, GitHubReleaseManager
#Requires -Version 5

<#
    .SYNOPSIS
    A wrapper script for build.psake.ps1

    .DESCRIPTION
    This script is a wrapper for the processes defined in build.psake.ps1. For this process to be succesful the following modules are required:

    - Psake
    - Pester
    - PSScriptAnalyzer
    - PlatyPS
    - GitHubReleaseManager

    Each task in build.psake.ps1 relies on settings provided in build.settings.ps1

    By default the build task will be executed but it is possible to select individual tasks. See the Task parameter for more information.

    .PARAMETER Task
    The build task that needs to be executed. The value of this parameter can be:

    - Build
    - Release
    - Analyze
    - UpdateModuleManifest
    - UpdateDocumentation
    - BumpVersion

    The BumpVersion will increment the version of the Module Manifest based on the $BumpVersion setting provided in build.settings.ps1.
    By default this is patch.

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    .\build.ps1

    .EXAMPLE
    .\build.ps1 -Task Build -Version PATCH

    .Example
    .\build.ps1 -Task Publish

    .Example
    .\build.ps1 -Task Analyze

    .Example
    .\build.ps1 -Task UpdateModuleManifest

    .Example
    .\build.ps1 -Task UpdateDocumentation

    .Example
    .\build.ps1 -Task BumpVersion

#>

[Cmdletbinding()]

Param (

    [Parameter()]
    [ValidateSet("Build", "Publish", "Analyze", "UpdateModuleManifest", "UpdateDocumentation", "BumpVersion", "Default")]
    [String]$Task = "Default",

    [Parameter()]
    [ValidateSet("PATCH", "MINOR", "MAJOR")]
    [String]$Version

)

# --- Start Build
Invoke-psake -buildFile "$($PSScriptRoot)\build.psake.ps1" -taskList $Task  -parameters @{"Version"=$Version} -nologo -Verbose:$VerbosePreference

exit ( [int]( -not $psake.build_success ) )