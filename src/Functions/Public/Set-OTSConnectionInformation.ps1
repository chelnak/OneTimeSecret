function Set-OTSConnectionInformation {
<#
    .SYNOPSIS
    Create the Authorization information required to interact with the OneTimeSecret.com API

    .DESCRIPTION
    Create the Authorization information required to interact with the OneTimeSecret.com API

    .PARAMETER Username
    The Username of the account

    .PARAMETER APIKey
    The API key for the account

    .INPUTS
    System.String

    .OUTPUTS
    System.Management.Automation.PSObject

    .EXAMPLE
    Set-OTSConnectionInformation -Username craiggumbley@gmail.com -Password 52302308eff2e799aea33cbc7c85896b4c6a6997

#>
[CmdletBinding(SupportsShouldProcess,ConfirmImpact="Low")][OutputType('System.Management.Automation.PSObject')]

    Param (

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$Username,

        [Parameter(Mandatory=$true, Position=1)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey

    )

    if ($PSCmdlet.ShouldProcess("onetimesecret.com")){

        $EncodedAuth = [System.Text.Encoding]::UTF8.GetBytes("$($Username):$($APIKey)")

        $OTSConnectionInformation = [PSCustomObject]@{

            Authorization = [System.Convert]::ToBase64String($EncodedAuth)

        }

        try {

            $PSCmdlet.SessionState.PSVariable.Set("OTSConnectionInformation", $OTSConnectionInformation)

        } catch {

            throw $_

        }

        Write-Output $OTSConnectionInformation

    }

}