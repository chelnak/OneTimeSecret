function New-OTSSecret {
<#
    .SYNOPSIS
    Generate a short, unique secret. This is useful for temporary passwords, one-time pads, salts, etc.

    .DESCRIPTION
    Generate a short, unique secret. This is useful for temporary passwords, one-time pads, salts, etc.

    .PARAMETER Passphrase
    A string that the recipient must know to view the secret. This value is also used to encrypt the secret and is bcrypted before being stored so we only have this value in transit.

    .PARAMETER Ttl
    The maximum amount of time, in seconds, that the secret should survive (i.e. time-to-live). Once this time expires, the secret will be deleted and not recoverable.

    .PARAMETER MetadataTtl
    The remaining time (in seconds) that the metadata has left to live.

    .PARAMETER SecretTtl
    The remaining time (in seconds) that the secret has left to live.

    .PARAMETER Recipient
    An email address. We will send a friendly email containing the secret link (NOT the secret itself).

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-OTSSecret -Passphrase 1234 -Recipient user@mail.com

    .EXAMPLE
    New-OTSSecret -Passphrase 1234 -Ttl 90000 -MetadataTtl 90000 -SecretTtil 90000 -Recipient user@mail.com

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Passphrase,

        [Parameter(Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$Ttl,

        [Parameter(Position=2)]
        [ValidateNotNullOrEmpty()]
        [String]$MetadataTtl,

        [Parameter(Position=3)]
        [ValidateNotNullOrEmpty()]
        [String]$SecretTtl,

        [Parameter(Position=4)]
        [ValidateNotNullOrEmpty()]
        [String]$Recipient

    )

    # --- Set URI with mandatory query parameters
    $URI = "/v1/generate?passphrase=$($Passphrase)"

    try {

        if ($PSBoundParameters.ContainsKey("Ttl")){

            Write-Verbose -Message "Adding Ttl Query Parameter"

            $URI = "$($URI)&ttl=$($Ttl)"

        }

        if ($PSBoundParameters.ContainsKey("MetadataTtl")){

            Write-Verbose -Message "Adding MetadataTtl Query Parameter"

            $URI = "$($URI)&metadata_ttl=$($MetadataTtl)"

        }

        if ($PSBoundParameters.ContainsKey("SecretTtl")){

            Write-Verbose -Message "Adding SecretTtl Query Parameter"

            $URI = "$($URI)&secret_ttl=$($SecretTtl)"

        }

        if ($PSBoundParameters.ContainsKey("Recipient")) {

            Write-Verbose -Message "Adding Recipient Parameter"

            $URI = "$($URI)&recipient=$($Recipient)"

        }

        if ($PSCmdlet.ShouldProcess("onetimesecret.com")){

            $Response = Invoke-OTSRestMethod -Method POST -URI $URI -Verbose:$VerbosePreference

        }

        [PSCustomObject]@{

            CustId = $Response.custid
            MetadataKey = $Response.metadata_key
            SecretKey = $Response.secret_key
            Ttl = $Response.ttl
            MetadataTtl = $Response.metadata_ttl
            SecretTtl = $Response.secret_ttl
            State = $Response.state
            Updated = (ConvertFrom-UnixTime -UnixTime $Response.updated).ToString()
            Created = (ConvertFrom-UnixTime -UnixTime $Response.created).ToString()
            Recipient = $Response.recipient
            Value = $Response.value
            PassphraseRequired = $Response.passphrase_required

        }

    }
    catch {

        throw

    }

}