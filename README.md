#OneTimeSecret

A PowerShell module for OneTimeSecret.com

## Usage

Before using any of the commands you will need to run Set-OTSConnectionInformation to create the authorization header needed for requests

`Set-OTSConnectionInformation -Username user@mail.com -APIKey xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Build

- Clone the repositor and run `build.ps1`
- Import-Module Release\OneTimeSecret\OneTimeSecret.psd1
- View public commands provided by the module with `Get-Command -Module OneTimeSecret`

## Contribute

Pull requests, suggestions and bug reports welcome

