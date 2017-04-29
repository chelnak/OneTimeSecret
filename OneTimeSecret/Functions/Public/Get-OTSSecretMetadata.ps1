function Get-OTSSecretMetadata {
<#
    .SYNOPSIS
    Retrieve metadata of a secret

    .DESCRIPTION
    Every secret also has associated metadata. The metadata is intended to be used by the creator of the secret (i.e. not the recipient) and should generally be kept private. You can safely use the metadata key to retrieve basic information about the secret itself (e.g. if or when it was viewed) since the metadata key is different from the secret key.

    .PARAMETER MetadataKey
    The unique key for the metadata

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .Example

    Get-OTSSecretMetaData -MetaDataKey allrfe8gf7edstynihtvrblgfuhbbuz

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$MetadataKey
    )

    # --- Set URI with mandatory query parameters
    $URI = "/v1/private/$($MetadataKey)"

    try {

        $Response = InvokeOTSRestMethod -Method POST -URI $URI -Verbose:$VerbosePreference

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
    catch {

        throw $_
    }
}