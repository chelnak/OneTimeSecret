function Remove-OTSSecret {
<#
    .SYNOPSIS
    Burn a secren that has not been read yet.

    .DESCRIPTION
    Burn a secren that has not been read yet.

    Secrets with passphrases are currently not supported by this function

    .PARAMETER MetadataKey
    The unique key for the metadata

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .Example
    Remove-OTSSecret -MetaDataKey allrfe8gf7edstynihtvrblgfuhbbuz

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="High")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$MetadataKey
    )

    # --- Set URI with mandatory query parameters
    $URI = "/v1/private/$($MetadataKey)/burn"

    try {

        if ($PSCmdlet.ShouldProcess("onetimesecret.com")){

            $Response = (InvokeOTSRestMethod -Method POST -URI $URI -Verbose:$VerbosePreference).state

            [PSCustomObject]@{

                CustId = $Response.custid
                MetadataKey = $Response.metadata_key
                SecretKey = $Response.secret_key
                Ttl = $Response.ttl
                MetadataTtl = $Response.metadata_ttl
                SecretTtl = $Response.secret_ttl
                State = $Response.state
                Updated = (ConvertFromUnixTime -UnixTime $Response.updated).ToString()
                Created = (ConvertFromUnixTime -UnixTime $Response.created).ToString()
                Recipient = $Response.recipient
                PassphraseRequired = $Response.passphrase_required
            }
        }
    }
    catch {

        throw "$_ - This command does not support secrets with passphrases!"
    }
}