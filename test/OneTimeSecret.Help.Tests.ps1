Import-Module -Name $ENV:BHPSModuleManifest -Force -Global

# --- Tests
Describe "Help tests" {
    
    $functions = Get-Command -Module $ENV:BHProjectName -CommandType Function

    foreach($Function in $Functions){

        $help = Get-Help $Function.name

        Context $help.name {

            it "Has a Synopsis" {
                $help.synopsis | Should Not BeNullOrEmpty
            }

            it "Has a description" {
                $help.description | Should Not BeNullOrEmpty
            }

            it "Has an example" {
                 $help.examples | Should Not BeNullOrEmpty
            }

            foreach($parameter in $help.parameters.parameter) {

                if($parameter -notmatch 'whatif|confirm') {

                    it "Has a Parameter description for '$($parameter.name)'" {
                        $parameter.Description.text | Should Not BeNullOrEmpty
                    }
                }
            }
        }
    }
}