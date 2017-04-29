function Get-OTSSystemStatus {
<#
    .SYNOPSIS
    Get the current status of OneTimeSecret.com

    .DESCRIPTION
    Get the current status of OneTimeSecret.com

    .INPUTS
    None

    .OUTPUTS
    System.Management.Automation.PSObject

    .Example
    Get-OTSSystemStatus

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()

    # --- Set URI with mandatory query parameters
    $URI = "/v1/status"

    try {

        $Response = InvokeOTSRestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

        [PSCustomObject]@{

            Status = $Response.status
        }
    }
    catch {

        throw $_
    }
}