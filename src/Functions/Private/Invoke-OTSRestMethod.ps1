function Invoke-OTSRestMethod {
    <#
    .SYNOPSIS
    A module specific wrapper for Invoke-ResetMethod

    .DESCRIPTION
    A module specific wrapper for Invoke-ResetMethod

    .PARAMETER Method
    METHOD: GET, POST, PUT, DELETE

    .PARAMETER URI
    Service URI

    .PARAMETER QueryStringParameters
    A hashtable of query string parameters

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

    .EXAMPLE
    $QueryStringParameters = @{
        passphrase = "1234"
    }
    InvokeOTSRestMethod -Method POST -URI /v1/generate -QueryStringParameters $QueryStringParameters

#>
    [CmdletBinding()][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "POST", "PUT", "DELETE")]
        [String]$Method,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$URI,

        [Parameter(Mandatory = $false)]
        [Hashtable]$QueryStringParameters,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [String]$Body,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [System.Collections.IDictionary]$Headers

    )

    try {

        # --- Grab the SessionState variable Test for connection variable
        if (!$Script:OTSConnectionInformation) {

            throw "Could not find OTSConnectionInformation. Please run Set-OTSConnectionInformation first"
        }

        # --- Build Uri
        $BaseURI = "https://onetimesecret.com/"
        $UriBuilder = [System.UriBuilder]::new($BaseURI)
        $UriBuilder.Path = "api/$URI"

        # --- Add query parameters
        $QueryString = [System.Web.HttpUtility]::ParseQueryString([string]::Empty)
        if ($PSBoundParameters.ContainsKey("QueryStringParameters")) {
            foreach ($Parameter in $QueryStringParameters.GetEnumerator()) {
                $QueryString.Add($Parameter.Key, $Parameter.Value)
            }
        }

        $UriBuilder.Query = $QueryString.ToString()

        # --- Get full Uri
        $FullURI = $UriBuilder.Uri
                
        # --- Build headers
        $Headers = @{

            "Authorization" = "Basic $($Script:OTSConnectionInformation.Authorization)"
        }

        Write-Verbose -Message "Invoking request with headers $($Headers)"
        if ($PSBoundParameters.ContainsKey("Body")) {

            $Response = Invoke-RestMethod -Method $Method -Headers $Headers -Uri $FullURI -Body $Body -Verbose:$VerbosePrefernce

        }
        else {

            $Response = Invoke-RestMethod -Method $Method -Headers $Headers -Uri $FullURI -Verbose:$VerbosePreference

        }

        Write-Output $Response

    }
    catch [Exception] {

        throw $_

    }
    finally {

        if (($PSVersionTable.PSEdition -eq "Desktop") -and $Script:OTSConnectionInformation) {
            $ServicePoint = "$($UriBuilder.Scheme)://$($UriBuilder.Host)"
            $ServicePoint = [System.Net.ServicePointManager]::FindServicePoint($ServicePoint)
            $ServicePoint.CloseConnectionGroup("") | Out-Null

        }

    }

}