$Private = Get-ChildItem -Path "$($PSScriptRoot)\Functions\Private\*.ps1" -Verbose:$VerbosePreference
$Public = Get-ChildItem -Path "$($PSScriptRoot)\Functions\Public\*.ps1" -Verbose:$VerbosePreference

foreach($Function in @($Public + $Private)) {

    try {

        . $Function.FullName

    }
    catch {

        Write-Error "Failed to import function $($Function.FullName)"

    }

}