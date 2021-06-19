function Set-OTSAuthorizationToken {
<#
    .SYNOPSIS
    Create the Authorization information required to interact with the OneTimeSecret.com API

    .DESCRIPTION
    Create the Authorization information required to interact with the OneTimeSecret.com API

    .PARAMETER Username
    The Username of the account

    .PARAMETER APIKey
    The API key for the account

    .PARAMETER BaseUrl
    Use a custom instance of onetimesecret. Defaults to https://onetimesecret.com/

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-OTSAuthorizationToken -Username user@mail.com -APIKey 52302308erf2e799affd33cbc7c85896b4c6a6997

    .EXAMPLE
    Set-OTSAuthorizationToken -Username user@mail.com -APIKey 52302308erf2e799affd33cbc7c85896b4c6a6997 -BaseUrl https://mycustomhost.com/

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Username,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey,

        [Parameter(Mandatory=$false, Position=2)]
        [ValidateNotNullOrEmpty()]
        [String]$BaseUrl = "https://onetimesecret.com/"
    )

    if ($PSCmdlet.ShouldProcess("onetimesecret")){

        try {

            $EncodedAuth = [System.Text.Encoding]::UTF8.GetBytes("$($Username):$($APIKey)")
            $Script:OTSConnectionInformation = [PSCustomObject]@{
                Authorization = [System.Convert]::ToBase64String($EncodedAuth)
            }

            if ($PSBoundParameters.ContainsKey("BaseUrl")){
                if (!(Test-WebAddress -Address $BaseUrl)) {
                    Write-Error -Message "The url provided was not valid: $BaseUrl" -ErrorAction Stop
                }

                if (!$BaseUrl.EndsWith("/")) {
                    $BaseUrl = $BaseUrl + "/"
                }

                $Script:OTSConnectionInformation | Add-Member -MemberType NoteProperty -Name BaseUrl -Value $BaseUrl
            }

            Write-Output $Script:OTSConnectionInformation

        } catch {

            throw $_
        }
    }
}