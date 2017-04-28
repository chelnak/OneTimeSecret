function Get-OTSAuthorizationToken {
<#
    .SYNOPSIS
    Retrieve the authorization token variable set by Set-OTSAuthorizationToken

    .DESCRIPTION
    Retrieve the authorization token variable set by Set-OTSAuthorizationToken

    .INPUTS
    None

    .OUTPUTS
    System.Management.Automation.PSObject
    
    .Example
    Get-OTSAuthorizationToken

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()

    try {

        # --- Grab the SessionState variable Test for connection variable
        if (!$Script:OTSConnectionInformation) {

            throw "Could not find OTSConnectionInformation. Please run Set-OTSAuthorizationToken first"

        }

        Write-Output $Script:OTSConnectionInformation

    }
    catch {

        throw

    }

}