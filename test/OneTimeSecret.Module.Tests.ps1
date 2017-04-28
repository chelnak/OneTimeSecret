Import-Module -Name $ENV:BHPSModuleManifest -Force -Global

# --- Get test variables
if ($ENV:APPVEYOR) {

    $Variables = $ENV:TestVariables | ConvertFrom-JSON

} else {

    $Variables = Get-Content -Path $PSScriptRoot\Variables.json -Raw | ConvertFrom-Json

}

# --- Set OTSAuthorizationToken as a global variable to avoide strange sessions state context issues
Set-OTSAuthorizationToken -Username $Variables.Username -APIKey $Variables.APIKey

Describe -Name 'Module Function Tests' {

    Context -Name "Public Functions" -Fixture {

        It -Name "Retrieve OTSAuthorizationToken Variable" -Test {

            $OTSAuthorizationToken = Get-OTSAuthorizationToken
            $OTSAuthorizationToken.Authorization | Should Not Be $Null

        }

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

Remove-Variable -Name Variables -Force -ErrorAction SilentlyContinue