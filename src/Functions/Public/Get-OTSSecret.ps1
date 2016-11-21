function Get-OTSSecret {
<#
    .SYNOPSIS
    Retrieve a secret

    .DESCRIPTION
    Retrieve a secret

    .PARAMETER SecretKey
    The unique key for this secret

    .PARAMETER Passphrase
    The passphrase is required only if the secret was create with one

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .Example
    Get-OTSSecret -SecretKey qqevnp70b4uoiax4knzhwlhros6ne7x -Passphrase 1234

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$SecretKey,

        [Parameter(Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$Passphrase

    )

    # --- Set URI with mandatory query parameters
    $URI = "/v1/secret/$SecretKey"

    try {

        if ($PSBoundParameters.ContainsKey("Passphrase")){

            Write-Verbose -Message "Adding Passphrase Query Parameter"

            $URI = "$($URI)?passphrase=$($Passphrase)"

        }

        $Response = Invoke-OTSRestMethod -Method POST -URI $URI -Verbose:$VerbosePreference

        [PSCustomObject]@{

            SecretKey = $Response.secret_key
            Value = $Response.value

        }

    }
    catch {

        throw

    }

}