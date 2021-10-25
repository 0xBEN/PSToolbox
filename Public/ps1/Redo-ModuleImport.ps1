function Redo-ModuleImport {

    [CmdletBinding()]
    [Alias("reload")]
    param()
    DynamicParam {

        # Create a dictionary to hold any dynamic parameters
        $parameterDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary

        #########################################
        #### Dynamic Parameter 1: ModuleName ####
        #########################################
        $moduleNameParameterName = 'ModuleName'
        # Parameter Attributes
        $moduleNameParameterAttributes = New-Object System.Management.Automation.ParameterAttribute # Instantiate empty parameter attributes object for definition below
        $moduleNameParameterAttributesCollection = New-Object 'System.Collections.ObjectModel.Collection[System.Attribute]' # An array to hold any attributes assigned to this parameter
        $moduleNameParameterAttributes.Mandatory = $true # Parameter is mandatory
        $moduleNameParameterAttributes.Position = 0
        # Parameter should validate inputs on these constraints
        $moduleNameParameterValidationSet = (Get-Module -All).Name # Get a list of all loaded modules as the set of strings that can be passed in by the user
        $moduleNameParameterValidationSetAttribute = New-Object System.Management.Automation.ValidateSetAttribute($moduleNameParameterValidationSet)
        # Add the parameter attributes object and the validation set attribute
        $moduleNameParameterAttributesCollection.Add($moduleNameParameterAttributes)
        $moduleNameParameterAttributesCollection.Add($moduleNameParameterValidationSetAttribute)
        $createModuleNameParameter = New-Object System.Management.Automation.RuntimeDefinedParameter($moduleNameParameterName, [String[]], $moduleNameParameterAttributesCollection)

        $parameterDictionary.Add($moduleNameParameterName, $createModuleNameParameter) # Add ModuleName to the parameter dictionary
        return $parameterDictionary

    }
    process{

        $PSBoundParameters['ModuleName'] | ForEach-Object {
            try {
                $module = Get-Module -All -Name $_
                $module | Remove-Module -Force -ErrorAction Stop
                Import-Module $module.Path -Force -ErrorAction Stop
            }
            catch {
                Write-Error -Exception $_.Exception
            }
        }

    }

}