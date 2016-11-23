#Requires -Modules PSake, Pester, PSScriptAnalyzer, PlatyPS

<#
    .SYNOPSIS
    A wrapper script for build.psake.ps1

    .DESCRIPTION
    This script is a wrapper for the processes defined in build.psake.ps1. For this process to be succesful the following modules are required:

    - Psake
    - Pester
    - PSScriptAnalyzer
    - PlatyPS

    Each task in build.psake.ps1 relies on settings provided in build.settings.ps1

    By default the build task will be executed but it is possible to select individual tasks. See the Task parameter for more information.

    .PARAMETER Task
    The build task that needs to be executed. The value of this parameter can be:

    - Build
    - BuildHelp
    - Test
    - Publish

    .INPUTS
    System.String

    .OUTPUTS
    None

    .EXAMPLE
    .\build.ps1

    .Example
    .\build.ps1 -Task Build

    .Example
    .\build.ps1 -Task BuildHelp

    .Example
    .\build.ps1 -Task Test

    .Example
    .\build.ps1 -Task Publish

#>

[Cmdletbinding()]

Param (

    [Parameter()]
    [ValidateSet("Build", "BuildHelp", "Test", "Publish")]
    [String]$Task = "Build"

)


# Builds the module by invoking psake on the build.psake.ps1 script.
Invoke-PSake $PSScriptRoot\build.psake.ps1 -taskList $Task -nologo -Verbose:$VerbosePreference
