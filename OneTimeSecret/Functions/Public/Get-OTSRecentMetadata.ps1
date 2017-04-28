function Get-OTSRecentMetadata {
<#
    .SYNOPSIS
    Return recent secret metadata

    .DESCRIPTION
    Return recent secret metadata

    .OUTPUTS
    System.Management.Automation.PSObject

    .Example
    Get-OTSRecentMetadata

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param ()

    # --- Set URI with mandatory query parameters
    $URI =  "/v1/private/recent"

    try {

        $Response = Invoke-OTSRestMethod -Method GET -URI $URI -Verbose:$VerbosePreference

        foreach ($Metadata in $Response) {

            [PSCustomObject]@{

                Custid = $Metadata.custid
                MetadataKey = $Metadata.metadata_key
                SecretKey = $Metadata.secret_key
                Ttl = $Metadata.ttl
                MetadataTtl = $Metadata.metadata_ttl
                SecretTtl = $Metadata.secret_ttl
                State = $Metadata.state
                Updated = (ConvertFrom-UnixTime -UnixTime $Metadata.updated).ToString()
                Created = (ConvertFrom-UnixTime -UnixTime $Metadata.created).ToString()
                Recipient = $Metadata.recipient
                PassphraseRequired = $Metadata.passphrase_required
            }
        }
    }
    catch {

        throw
    }
}