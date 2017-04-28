function New-OTSSharedSecret {
<#
    .SYNOPSIS
    Store and share a secret value

    .DESCRIPTION
    Store and share a secret value

    .PARAMETER Secret
    The secret value which is encrypted before being stored. There is a maximum length based on your plan that is enforced (1k-10k

    .PARAMETER Passphrase
    A string that the recipient must know to view the secret. This value is also used to encrypt the secret and is bcrypted before being stored so we only have this value in transit.

    .PARAMETER Ttl
    The maximum amount of time, in seconds, that the secret should survive (i.e. time-to-live). Once this time expires, the secret will be deleted and not recoverable.

    .PARAMETER Recipient
    An email address. We will send a friendly email containing the secret link (NOT the secret itself).

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    New-OTSSharedSecret -Secret "Very Secret" -Passphrase 12334

    .EXAMPLE
    New-OTSSharedSecret -Secret "Very Secret" -Passphrase 1234 -Ttl 90000 -Recipient user@mail.com


#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Secret,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$Passphrase,

        [Parameter(Position=2)]
        [ValidateNotNullOrEmpty()]
        [String]$Ttl,

        [Parameter(Position=3)]
        [ValidateNotNullOrEmpty()]
        [String]$Recipient
    )

    # --- Set URI with mandatory query parameters
    $URI = "/v1/share?secret=$($Secret)&passphrase=$($Passphrase)"

    try {

        if ($PSBoundParameters.ContainsKey("Ttl")){

            Write-Verbose -Message "Adding Ttl Query Parameter"
            $URI = "$($URI)&ttl=$($Ttl)"
        }

        if ($PSBoundParameters.ContainsKey("Recipient")) {

            Write-Verbose -Message "Adding Recipient Parameter"
            $URI = "$($URI)&recipient=$($Recipient)"
        }

        if ($PSCmdlet.ShouldProcess("onetimesecret.com")){

            $Response = Invoke-OTSRestMethod -Method POST -URI $URI -Verbose:$VerbosePreference

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
                PassphraseRequired = $Response.passphrase_required

            }
        }
    }
    catch {

        throw $_
    }
}