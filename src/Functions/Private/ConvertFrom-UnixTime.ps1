function ConvertFrom-UnixTime {
<#
    .SYNOPSIS
    Convert UNIX Time to a readable format

    .DESCRIPTION
    Convert UNIX Time to a readable format

    .PARAMETER UnixTime
    Unix Time

    .INPUTS
    System.String

    .OUTPUTS
    System.TimeZone

    .EXAMPLE
    ConvertFrom-UnixTime -UnixTime 777777

#>
[CmdletBinding()][OutputType('System.TimeZone')]

    Param (

        [Parameter(Mandatory=$true, Position=0)]
        [ValidateNotNullOrEmpty()]
        [String]$UnixTime

    )


   [System.TimeZone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').` AddSeconds($UnixTime))

}