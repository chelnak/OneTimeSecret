function Get-OTSRecentMetadata {
<#
    .SYNOPSIS
    Return recent secret metadata

    .DESCRIPTION
    Return recent secret metadata

    This function will not currently work due to an error with the OneTimeSecret.com API

    .OUTPUTS
    System.Management.Automation.PSObject

    .Example
    Get-OTSRecentMetadata

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()

    # --- Set URI with mandatory query parameters
    $URI = "/v1/recent"

    try {

        $Response = Invoke-OTSRestMethod -Method POST -URI $URI -Verbose:$VerbosePreference

        [PSCustomObject]@{

            Custid = $Response.custid
            MetadataKey = $Response.metadata_key
            SecretKey = $Response.secret_key
            Ttl = $Response.ttl
            MetadataTtl = $Response.metadata_ttl
            SecretTtl = $Response.secret_ttl
            State = $Response.state
            Updated = (ConvertFrom-UnixTime -UnixTime $Response.updated).ToString()
            Created = (ConvertFrom-UnixTime -UnixTime $Response.created).ToString()
            Recipient = $Response.recipient
            PassphraseRequired = $Response.passphrase_required

        }


    }
    catch {

        throw

    }

}