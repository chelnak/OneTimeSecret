function InvokeOTSRestMethod {
<#
    .SYNOPSIS
    A module specific wrapper for Invoke-ResetMethod

    .DESCRIPTION
    A module specific wrapper for Invoke-ResetMethod

    .PARAMETER Method
    METHOD: GET, POST, PUT, DELETE

    .PARAMETER URI
    Service URI

    .PARAMETER Body
    Payload for the request, if applicable

    .PARAMETER Headers
    Optional Headers to send. This will override the default set provided

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    InvokeOTSRestMethod -Method POST -URI /v1/generate?passphrase=1234"

#>
[CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true)]
        [ValidateSet("GET","POST","PUT","DELETE")]
        [String]$Method,

        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$URI,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [String]$Body,

        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers

    )


    # --- Grab the SessionState variable Test for connection variable
    if (!$Script:OTSConnectionInformation) {

        throw "Could not find OTSConnectionInformation. Please run Set-OTSConnectionInformation first"

    }

    # --- Base URI
    $BaseURI = "https://onetimesecret.com/api"

    # --- Create Invoke-RestMethod Parameters
    $FullURI = "$($BaseUri)$($URI)"

    $Headers = @{

        "Authorization" = "Basic $($Script:OTSConnectionInformation.Authorization)"
    }

    try {

        Write-Verbose -Message "Invoking request with headers $($Headers)"

        if ($PSBoundParameters.ContainsKey("Body")) {

            $Response = Invoke-RestMethod -Method $Method -Headers $Headers -Uri $FullURI -Body $Body -Verbose:$VerbosePrefernce

        }
        else {

            $Response = Invoke-RestMethod -Method $Method -Headers $Headers -Uri $FullURI -Verbose:$VerbosePreference

        }

    }
    catch [Exception]{

        throw $_

    }
    finally {

        if ($PSVersionTable.PSEdition -eq "Desktop") {

            $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($FullURI)
            $ServicePoint.CloseConnectionGroup("") | Out-Null

        }

    }

    Write-Output $Response

}