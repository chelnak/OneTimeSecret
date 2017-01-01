# --- Dot source build.settings.ps1
. $PSScriptRoot\build.settings.ps1

# --- Define the build tasks
Task Default -depends Analyze, UpdateModuleManifest, UpdateDocumentation
Task Build -depends Analyze, BumpVersion, UpdateModuleManifest, UpdateDocumentation, StageFiles, CreateArtifact
Task Publish -depends CreateGitHubRelease, PublishPSGallery

Task Analyze {

    $Results = Invoke-ScriptAnalyzer -Path $SrcRootDir -Recurse  -Settings $ScriptAnalyzerSettingsPath -Verbose:$VerbosePreference
    $Results | Select-Object RuleName, Severity, ScriptName, Line, Message | Format-List

    switch ($ScriptAnalysisFailBuildOnSeverityLevel) {

        'None' {

            return

        }
        'Error' {

            Assert -conditionToCheck (
                ($analysisResult | Where-Object Severity -eq 'Error').Count -eq 0
                ) -failureMessage 'One or more ScriptAnalyzer errors were found. Build cannot continue!'

        }
        'Warning' {

            Assert -conditionToCheck (
                ($analysisResult | Where-Object {
                    $_.Severity -eq 'Warning' -or $_.Severity -eq 'Error'
                }).Count -eq 0) -failureMessage 'One or more ScriptAnalyzer warnings were found. Build cannot continue!'

        }
        default {

            Assert -conditionToCheck ($analysisResult.Count -eq 0) -failureMessage 'One or more ScriptAnalyzer issues were found. Build cannot continue!'

        }

    }

}

Task UpdateModuleManifest {

    try {

        $PublicFunctions = Get-ChildItem -Path "$($SrcRootDir)\Functions\Public" -Filter "*.ps1" -Recurse | Sort-Object

        $ModuleManifest = Import-PowerShellDataFile -Path $ModuleManifestPath -Verbose:$VerbosePreference

        # --- Functions To Export
        Write-Verbose -Message "Processing FunctionsToExport"
        $ModuleManifest.FunctionsToExport = $PublicFunctions | Select-Object -ExpandProperty BaseName | Sort-Object

        # --- Private Data
        Write-Verbose -Message "Processing PrivateData"
        if ($ModuleManifest.ContainsKey("PrivateData") -and $ModuleManifest.PrivateData.ContainsKey("PSData")) {

            foreach ($node in $ModuleManifest.PrivateData["PSData"].GetEnumerator()) {

                $key = $node.Key

                if ($node.Value.GetType().Name -eq "Object[]") {

                    $value = $node.Value | ForEach-Object {$_}

                }
                else {

                    $value = $node.Value

                }

                $ModuleManifest[$key] = $value
            }

            $ModuleManifest.Remove("PrivateData")

        }

        New-ModuleManifest -Path $ModuleManifestPath @ModuleManifest -Verbose:$VerbosePreference

    }
    catch [System.Exception] {

        Write-Error -Message "An error occured when updating manifest functions: $_.Message"

    }

}

Task UpdateDocumentation {

    $ModuleInfo = Import-Module $ModuleManifestPath -Global -Force -PassThru

    # --- Create or update existing MD documentation
    if ($ModuleInfo.ExportedCommands.Count -eq 0) {
        "No commands have been exported. Skipping $($psake.context.currentTaskName) task."
        return
    }

    if ((Test-Path -Path $DocsDirectory)) {

        # --- Clean the documentation directory
        if ($DocsDirectory) {

            Remove-Item -Path $DocsDirectory -Force -Recurse | Out-Null

        }

    }

    # --- Create a new documentation directory
    New-Item $DocsDirectory -ItemType Directory | Out-Null

    # --- ErrorAction set to SilentlyContinue so this command will not overwrite an existing MD file.
    New-MarkdownHelp -Module $ModuleName -Locale $DefaultLocale -OutputFolder $DocsDirectory -NoMetadata `
                    -ErrorAction SilentlyContinue -Verbose:$VerbosePreference | Out-Null

    # --- Ensure that index.md is present and up to date
    Copy-Item -Path "$($PSScriptRoot)\README.md" -Destination "$($DocsDirectory)\index.md" -Force -Verbose:$VerbosePreference | Out-Null

    # --- Update mkdocs.yml with new functions
    $Mkdocs = "$($PSScriptRoot)\mkdocs.yml"

    if (!(Test-Path -Path $Mkdocs)) {

        Write-Verbose -Message "Creating MKDocs.yml"

        New-Item -Path $Mkdocs -ItemType File -Force | Out-Null

    }

    $Functions = $ModuleInfo.ExportedCommands.Keys | ForEach-Object {"    - $($_) : $($_).md"}

    $Template = @"
---

site_name: $($ModuleName)
pages:
- 'Home' : 'index.md'
- 'Functions':
$($Functions -join "`r`n")
"@

    $Template | Out-File -FilePath $Mkdocs -Force

}

Task StageFiles {

    $ModuleOutDir = "$($OutDir)\$($ModuleName)"

    if ((Test-Path -LiteralPath $ModuleOutDir)) {

        Remove-Item -Path $ModuleOutDir -Recurse -Force | Out-Null

    }

    New-Item $ModuleOutDir -ItemType Directory -Verbose:$VerbosePreference | Out-Null

    Copy-Item -Path $SrcRootDir\* -Destination $ModuleOutDir -Recurse -Confirm:$false -Verbose:$VerbosePreference

}

Task CreateArtifact {

    $ModuleOutDir = "$($OutDir)\$($ModuleName)"
    $CurrentModuleVersion = (Import-PowerShellDataFile -Path $ModuleManifestPath).ModuleVersion
    $ArchiveName = "$($ModuleOutDir)-$($CurrentModuleVersion).zip"

    if (!(Test-Path -LiteralPath $ModuleOutDir )) {

        Write-Verbose -Message "Release director does not exist skipping"
        return

    }

    if ((Test-Path -LiteralPath $ArchiveName)) {

        Remove-Item -LiteralPath $ArchiveName -Force | Out-Null

    }

    Compress-Archive -Path $ModuleOutDir -DestinationPath $ArchiveName -Force -Confirm:$false -Verbose:$VerbosePreference | Out-Null

}

Task BumpVersion {

    # --- Get the current version of the module
    $ModuleManifest = Import-PowerShellDataFile -Path $ModuleManifestPath -Verbose:$VerbosePreference

    $CurrentModuleVersion = $ModuleManifest.ModuleVersion

    $ModuleManifest.Remove("ModuleVersion")

    Write-Verbose -Message "Current module version is $($CurrentModuleVersion)"

    [Int]$MajorVersion = $CurrentModuleVersion.Split(".")[0]
    [Int]$MinorVersion = $CurrentModuleVersion.Split(".")[1]
    [Int]$PatchVersion = $CurrentModuleVersion.Split(".")[2]

    $ModuleManifest.ScriptsToProcess = $ModuleManifest.ScriptsToProcess | ForEach-Object {$_}
    $ModuleManifest.FunctionsToExport = $ModuleManifest.FunctionsToExport | ForEach-Object {$_}
    $ModuleManifest.NestedModules = $ModuleManifest.NestedModules | ForEach-Object {$_}
    $ModuleManifest.RequiredModules = $ModuleManifest.RequiredModules | ForEach-Object {$_}
    $ModuleManifest.ModuleList = $ModuleManifest.ModuleList | ForEach-Object {$_}

    if ($ModuleManifest.ContainsKey("PrivateData") -and $ModuleManifest.PrivateData.ContainsKey("PSData")) {

        foreach ($node in $ModuleManifest.PrivateData["PSData"].GetEnumerator()) {

            $key = $node.Key

            if ($node.Value.GetType().Name -eq "Object[]") {

                $value = $node.Value | ForEach-Object {$_}

            }
            else {

                $value = $node.Value

            }

            $ModuleManifest[$key] = $value

        }

        $ModuleManifest.Remove("PrivateData")
    }


    switch ($BumpVersion) {

        'MAJOR' {

            Write-Verbose -Message "Bumping module major release number"

            $MajorVersion++
            $MinorVersion = 0
            $PatchVersion = 0

            break

        }

        'MINOR' {

            Write-Verbose -Message "Bumping module minor release number"

            $MinorVersion++
            $PatchVersion = 0

            break

        }

        'PATCH' {

            Write-Verbose -Message "Bumping module patch release number"

            $PatchVersion++

            break
        }

        default {

            Write-Verbose -Message "Not bumping module version"
            break

        }

    }

    # --- Build the new version string
    $ModuleVersion = "$($MajorVersion).$($MinorVersion).$($PatchVersion)"

    if ([version]$ModuleVersion -gt [version]$CurrentModuleVersion) {

        # --- Fix taken from: https://github.com/RamblingCookieMonster/BuildHelpers/blob/master/BuildHelpers/Public/Step-ModuleVersion.ps1
        New-ModuleManifest -Path $ModuleManifestPath -ModuleVersion $ModuleVersion @ModuleManifest -Verbose:$VerbosePreference
        Write-Verbose -Message "Module version updated to $($ModuleVersion)"

        # --- Update appveyor build version
        $AppveyorYMLPath = "$($PSScriptRoot)\appveyor.yml"
        $AppveyorVersion = "$($ModuleVersion).{build}"
        $NewAppveyorYML = Get-Content -Path $AppveyorYMLPath | ForEach-Object { $_ -replace '^version: .+$', "version: $($AppveyorVersion)";}
        $NewAppveyorYML | Set-Content -Path $AppveyorYMLPath -Force
        Write-Verbose -Message "Appveyor build version set to $($AppveyorVersion)"

    }

}

Task CreateGitHubRelease {

    Set-GitHubSessionInformation -UserName $GitHubUsername -APIKey $GithubAPIKey -Verbose:$VerbosePreference | Out-Null

    $CurrentModuleVersion = (Import-PowerShellDataFile -Path $ModuleManifestPath).ModuleVersion

    Write-Verbose -Message "Current module version is $($CurrentModuleVersion)"

    $AssetPath = "$($OutDir)\$($ModuleName)-$($CurrentModuleVersion).zip"

    Write-Verbose -Message "Asset path is $($AssetPath)"

    $Asset = @{
        "Path" = $AssetPath
        "Content-Type" = "application/zip"
    }

    New-GitHubRelease -Repository $GithubRepositoryName -Name $ModuleName -Target $GitHubReleaseTarget -Tag "v$($CurrentModuleVersion)" -Assets $Asset -Verbose:$VerbosePreference -Confirm:$false | Out-Null

}

Task PublishPSGallery {

    Publish-Module -Path "$($OutDir)\$($ModuleName)" -NuGetApiKey $NuGetAPIKey -Verbose:$VerbosePreference

}