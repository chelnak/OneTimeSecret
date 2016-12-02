[![Build status](https://ci.appveyor.com/api/projects/status/qbhbapqr9xt24413?svg=true)](https://ci.appveyor.com/project/chelnak/onetimesecret)

#OneTimeSecret

A PowerShell module for OneTimeSecret.com

## Usage

Before using any of the commands you will need to run Set-OTSConnectionInformation to create the authorization header needed for requests

`Set-OTSConnectionInformation -Username user@mail.com -APIKey xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`

## Build

- Clone the repository and run `build.ps1`
- Import-Module Release\OneTimeSecret\OneTimeSecret.psd1
- View public commands provided by the module with `Get-Command -Module OneTimeSecret`

## Contribute

Pull requests, suggestions and bug reports welcome

