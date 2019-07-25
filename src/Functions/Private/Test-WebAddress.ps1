function Test-WebAddress {
    <#
    .SYNOPSIS
    Validate a web address

    .DESCRIPTION
    Validate a web address

    .PARAMETER Address
    The address to validate

    .EXAMPLE
    Test-WebAddress -Address https://google.com
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)]
        [String]$Address
    )

    try {
            $URI = $Address -as [System.URI]
            $null -ne $URI.AbsoluteURI -and (($URI.Scheme -eq "http") -or ($URI.Scheme -eq "https"))
    }
    catch {
        Write-Error -Message "$_" -ErrorAction Stop
    }
}