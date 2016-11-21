[System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
$SuppressImportModule = $false
. $PSScriptRoot\Shared.ps1

Describe 'Module Manifest Tests' {

    It 'Passes Test-ModuleManifest' {

        Test-ModuleManifest -Path $ModuleManifestPath
        $? | Should Be $true

    }

}

Describe -Name 'Module Function Tests' {

    Context -Name "Public Functions" -Fixture {

        It -Name "Connection Tests" -Test {

           $Connection = Set-OTSConnectionInformation -Username $Variables.Username -APIKey $Variables.APIKey
           $Connection.Authorization | Should Not Be $null

        }

        It -Name "Return System Status" -Test {


        }

        It -Name "Return Recent Metadata" -Test {


        }

        It -Name "Return Secret" -Test {


        }

        It -Name "Return Secret Metadata" -Test {


        }

        It -Name "Create Secret" -Test {


        }

        It -Name "Create Shared Secret" -Test {


        }

    }

}