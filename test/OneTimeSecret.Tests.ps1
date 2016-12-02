$SuppressImportModule = $false
$ModuleManifestName = 'OneTimeSecret.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the OneTimeSecret\ namespace
    Import-Module $ModuleManifestPath -Scope Global
}

# --- Get test variables
if ($ENV:APPVEYOR) {

    $Variables = $ENV:TestVariables

} else {

    $Variables = Get-Content -Path $PSScriptRoot\Variables.json -Raw | ConvertFrom-Json

}

# --- Set OTSConnectionInformation as a global variable to avoide strange sessions state context issues
$GLOBAL:OTSConnectionInformation = Set-OTSConnectionInformation -Username $Variables.Username -APIKey $Variables.APIKey

Describe -Name 'Module Function Tests' {

    Context -Name "Public Functions" -Fixture {

        # --- CREATE
        It -Name "Create Secret" -Test {

            $Param = @{

                Passphrase = $Variables.Passphrase
                Recipient = $Variables.Recipient
                Ttl = $Variables.Ttl
                MetadataTtl = $Variables.MetadataTtl
                SecretTtl = $Variables.SecretTtl
            }

            $Secret = New-OTSSecret @Param
            $ReturnedSecret = Get-OTSSecret -SecretKey $Secret.SecretKey -Passphrase $Variables.Passphrase
            $ReturnedSecret.SecretKey | Should Be $Secret.SecretKey

        }

        It -Name "Create Shared Secret" -Test {

            $Param = @{

                Secret = $Variables.Secret
                Passphrase = $Variables.Passphrase
                Ttl = $Variables.Ttl
                Recipient = $Variables.Recipient

            }

            $Secret = New-OTSSharedSecret @Param
            $ReturnedMetadata = Get-OTSSecretMetadata -MetadataKey $Secret.MetadataKey
            $ReturnedMetadata.SecretKey | Should Be $Secret.SecretKey

        }

        # --- READ
        It -Name "Return Secret" -Test {

            $Secret = New-OTSSecret -Passphrase $Variables.Passphrase
            $ReturnedSecret = Get-OTSSecret -SecretKey $Secret.SecretKey -Passphrase $Variables.Passphrase
            $ReturnedSecret.SecretKey | Should Be $Secret.SecretKey

        }

        It -Name "Return Secret Metadata" -Test {

            $Secret = New-OTSSecret -Passphrase $Variables.Passphrase
            $ReturnedMetadata = Get-OTSSecretMetadata -MetadataKey $Secret.MetadataKey
            $ReturnedMetadata.SecretKey | Should Be $Secret.SecretKey

        }

        It -Name "Return Recent Metadat Should Fail" -Test {

            try {

                $RecentMetadata = Get-OTSRecentMetadata

            } catch {}


            $RecentMetadata | Should Be $null

        }

        It -Name "Return System Status" -Test {

            $Status = Get-OTSSystemStatus
            $Status.Status | Should Be "nominal"

        }

    }

}

Remove-Variable -Name OTSConnectionInformation -Scope Global -Force -ErrorAction SilentlyContinue
Remove-Variable -Name Variables -Force -ErrorAction SilentlyContinue